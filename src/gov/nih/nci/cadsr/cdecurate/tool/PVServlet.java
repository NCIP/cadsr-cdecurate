/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import oracle.jdbc.driver.OracleTypes;
import org.apache.log4j.Logger;

/**
 * @author shegde
 *
 */
public class PVServlet implements Serializable
{
  private static final Logger logger = Logger.getLogger(PVServlet.class.getName());
  private static PVForm data = null;
  private static PVAction PVAct = new PVAction();

  /**constructor  */
  public PVServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
  {
    data = new PVForm();
    data.setRequest(req);
    data.setResponse(res);
    data.setCurationServlet(ser);
  //  SetACService setAC = new SetACService(ser);
  //  data.setSetAC(setAC);
  //  InsACService insAC = new InsACService(req, res, ser);
  //  data.setInsAC(insAC);
    UtilService util = new UtilService();
    data.setUtil(util);
  }

 /**
   * The doEditPVActions method handles the submission of a CreatePV form
   * Calls 'doValidatePV' if the action is Validate or submit.
   *
   * @param req The HttpServletRequest from the client
   * @param res The HttpServletResponse back to the client
   *
   * @throws Exception
   */
  public String doEditPVActions()
  {
      String retData = "";
      try
      {
         HttpSession session = data.getRequest().getSession();
         String sAction = (String)data.getRequest().getParameter("pageAction");
         data.setPageAction(sAction);
         String sMenuAction = (String)data.getRequest().getParameter("MenuAction");
         if (sMenuAction != null)
           session.setAttribute("MenuAction", sMenuAction);
         sMenuAction = (String)session.getAttribute("MenuAction");
         data.setMenuAction(sMenuAction);
         String sButtonPressed = (String)session.getAttribute("LastMenuButtonPressed");
         data.setLastButtonPressed(sButtonPressed);
         String sOriginAction = (String)session.getAttribute("originAction");
         data.setOriginAction(sOriginAction);
        // String sSubAction = (String)data.getRequest().getParameter("VDAction");
         String sSubAction = (String)session.getAttribute("VDAction");  
         data.setVDAction(sSubAction);
         String vdPageFrom = "create";
System.out.println(sMenuAction + " pv action " + sAction);
         if (!sSubAction.equals("NewVD")) 
           vdPageFrom = "edit";
         
         doViewTypes();
         
         int retPageFlag = 0;  //default to permissible value
         //clear searched data from teh session attributes
         if (sAction.equals("vddetailstab"))
         {
           session.setAttribute("TabFocus", "VD");
           if (vdPageFrom.equals("create"))
             return "/CreateVDPage.jsp";
           else
             return "/EditVDPage.jsp";
         }
         else if (sAction.equals("vdpvstab"))
         {
           session.setAttribute("TabFocus", "PV");
           return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("goBack"))
         {
           VDServlet vdser = new VDServlet(data.getRequest(), data.getResponse(), data.getCurationServlet());
           return vdser.goBackfromVD(sOriginAction, sMenuAction, "", sButtonPressed, vdPageFrom);             
         }
         else if (sAction.equals("validate"))
         {
           System.out.println("validate PVs and submit VD edits if all valid");
           return addPVValidates(null);
         }
         else if (sAction.equals("clearBoxes"))
         {
           System.out.println("clear edits");
           VDServlet vdser = new VDServlet(data.getRequest(), data.getResponse(), data.getCurationServlet());        
           String ret = vdser.clearEditsOnPage(sOriginAction, sMenuAction, "pvEdits");
           return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("save"))
         {
           System.out.println("mark the pv to be saved");
           retData = savePVAttributes();
         }
         else if (sAction.equals("openCreateNew") || sAction.equals("addNewPV"))
         {
           System.out.println("refresh the page");
           retData = readNewPVAttributes(sAction);
         }
         else if (sAction.equals("addSelectedCon"))
         {
           System.out.println("add selected vm to the pv");
            data.getCurationServlet().doSelectVMConcept(data.getRequest(), data.getResponse(), sAction);
            return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("selectParent"))
         {
           data.getCurationServlet().doSelectParentVD(data.getRequest(), data.getResponse());
           return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("CreateNonEVSRef"))
         {
           data.getCurationServlet().doNonEVSReference(data.getRequest(), data.getResponse());
           return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("restore"))
         {
           System.out.println("put back the old data of the selected PV and refresh the data");
           return doRestorePV();
         }
         else if (sAction.equals("remove"))
         {
           System.out.println("mark the pv as deleted and refresh the page");
           return doRemovePV();
         }
         else if (sAction.equals("changeAll"))
         {
           System.out.println("do hte block edit pv");
           this.addPVOtherAttributes(null, "changeAll");
           data.getRequest().setAttribute("focusElement", "pv0View");
           return "/PermissibleValue.jsp";
         }
         else if (sAction.equals("appendSearchVM"))
         {
           System.out.println("append Selected VM and refresh the page");
           return this.appendSearchVM();
         }
         else
           retData = "/PermissibleValue.jsp";
      }
      catch (RuntimeException e)
      {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      return retData;
  }

   @SuppressWarnings("unchecked")
   private void doViewTypes()
   {
     HttpSession session = (HttpSession)data.getRequest().getSession(); 
     VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");
     Vector<PV_Bean> vVDPV = vd.getVD_PV_List();  // (Vector<PV_Bean>)session.getAttribute("VDPVList");
     if (vVDPV == null) vVDPV = new Vector<PV_Bean>();
     String[] vwTypes = data.getRequest().getParameterValues("PVViewTypes"); 
     if (vwTypes != null)
     {
       PVAct.doResetViewTypes(vVDPV, vwTypes);
      // session.setAttribute("VDPVList", vVDPV);
       vd.setVD_PV_List(vVDPV);
       session.setAttribute("m_VD", vd);
     }
   }
   
   @SuppressWarnings("unchecked")
   private String readNewPVAttributes(String sAct)
   {
      HttpSession session = (HttpSession)data.getRequest().getSession(); 
      if (sAct.equals("openCreateNew")) 
      {
        savePVAttributes();  //save the edited ones before refreshing
        data.getRequest().setAttribute("refreshPageAction", "openNewPV");
        //clean up the new bean
        PV_Bean pv = new PV_Bean();
        //inititalize date and origins
        SimpleDateFormat formatter = new SimpleDateFormat ("MM/dd/yyyy");
        pv.setPV_BEGIN_DATE(formatter.format(new java.util.Date()));
        session.setAttribute("NewPV", pv);        
        data.getRequest().setAttribute("focusElement", "divpvnew");
      }
      else if (sAct.equals("addNewPV"))
      {
        PV_Bean pv = (PV_Bean)session.getAttribute("NewPV");
        if (pv == null) pv = new PV_Bean();
        //make sure all the hand typed data is captured
        String sPV = (String)data.getRequest().getParameter("pvNewValue");  //value
        if (sPV == null) sPV = "";
        pv.setPV_VALUE(sPV);
        //add pv other attribtutes 
        addPVOtherAttributes(pv, "changeOne");
        //if no concepts, read the user entered vm /desc
        VMServlet vmser = new VMServlet(data.getRequest(), data.getResponse(), data.getCurationServlet());
        vmser.readDataForCreate(pv, -1);
        VM_Bean vm = vmser.data.getVMBean();
  //TODO      pv.setPV_SHORT_MEANING(vm.getVM_SHORT_MEANING());
        pv.setPV_VM(vm);
        pv.setPV_VIEW_TYPE("expand");
        pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_INS);
        VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");
        Vector<PV_Bean> vdpvList = vd.getVD_PV_List();  // (Vector<PV_Bean>)session.getAttribute("VDPVList");
        if (vdpvList == null) vdpvList = new Vector<PV_Bean>();
        vdpvList.insertElementAt(pv, 0);
        //session.setAttribute("VDPVList", vdpvList);
        vd.setVD_PV_List(vdpvList);
        session.setAttribute("m_VD", vd);
        data.getRequest().setAttribute("focusElement", "pv0View");
        //TODO - handle the error message
      }
      return "/PermissibleValue.jsp";
   }

   @SuppressWarnings("unchecked")
   private String savePVAttributes()
   {
      HttpSession session = data.getRequest().getSession();
      int pvInd = getSelectedPV();
      if (pvInd > -1)
      {
        //add pv other attribtutes 
        addPVOtherAttributes(null, "changeOne");
        PV_Bean selectPV = data.getSelectPV();
        boolean isNewPV = false;
        //get the pv name from teh page
        String chgName = (String)data.getRequest().getParameter("txtpv" + pvInd + "Value");  //pvName  
        if (!chgName.equals(selectPV.getPV_VALUE()))
          isNewPV = true;
        //handle vm changes
        VMServlet vmser = new VMServlet(data.getRequest(), data.getResponse(), data.getCurationServlet());
        //go back it vm was not changed
        VM_Bean newVM = selectPV.getPV_VM();
        String editVM = (String)data.getRequest().getParameter("currentVM");
        if (editVM != null && !editVM.equals(""))
        {
          vmser.readDataForCreate(selectPV, pvInd);
          newVM = vmser.data.getVMBean();
        }
     System.out.println(newVM.getVM_SHORT_MEANING() + " vm " + newVM.getVM_SUBMIT_ACTION());
        if (newVM.getVM_SUBMIT_ACTION().equals(VMForm.CADSR_ACTION_INS))
          isNewPV = true;
        //handle pv changes
        data.setNewVM(newVM);
        PVAct.doChangePVAttributes(chgName, pvInd, isNewPV, data);
        //store it in the session
      //  session.setAttribute("VDPVList", data.getVDPVList());
      //  data.getVD().setRemoved_VDPVList(data.getRemovedPVList());
        session.setAttribute("m_VD", data.getVD());
        //session.setAttribute("RemovedPVList", data.getRemovedPVList());
        data.getRequest().setAttribute("focusElement", "pv" + pvInd + "View");
        //TODO - status messae
        System.out.println("PV Status " + data.getStatusMsg());
      }
      return "/PermissibleValue.jsp";
   }

   private int getSelectedPV()
   {
     int pvInd = -1;
     //read edited pv
     String selPVInd = (String)data.getRequest().getParameter("editPVInd");  //index
     System.out.println(selPVInd + " edited PV " + pvInd);
     if (selPVInd != null && !selPVInd.equals("")) 
     {
       selPVInd = selPVInd.substring(2);
       if (selPVInd != null && !selPVInd.equals(""))
       {
         if (selPVInd.equalsIgnoreCase("New"))
           pvInd = -1;
         else
           pvInd = new Integer(selPVInd).intValue();
       }
     }
     System.out.println(selPVInd + " edited PV " + pvInd);
     HttpSession session = data.getRequest().getSession();
     PV_Bean selectPV = new PV_Bean();
     if (pvInd > -1)
     {
       VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");      
    //   data.setRemovedPVList(vd.getRemoved_VDPVList());  //(Vector<PV_Bean>)session.getAttribute("RemovedPVList"));
       data.setVD(vd);
       
       Vector<PV_Bean> vVDPVList = vd.getVD_PV_List();  // (Vector)session.getAttribute("VDPVList");
       if (vVDPVList == null) vVDPVList = new Vector<PV_Bean>();
       selectPV = (PV_Bean)vVDPVList.elementAt(pvInd);
       if (selectPV != null && selectPV.getPV_VALUE() != null && !selectPV.getPV_VALUE().equals(""))
         data.setSelectPV(selectPV);
     }
     else
     {
       selectPV = (PV_Bean)session.getAttribute("NewPV");
       if (selectPV == null) 
         selectPV = new PV_Bean();
       data.setSelectPV(selectPV);
     }
     return pvInd;
   }
   
   private int getSelectedVM()
   {
     int pvInd = -1;
     //read edited pv
     String selPVInd = (String)data.getRequest().getParameter("editPVInd");  //index
     System.out.println(selPVInd + " edited PV " + pvInd);
     if (selPVInd != null && !selPVInd.equals("")) 
     {
       selPVInd = selPVInd.substring(2);
       if (selPVInd != null && !selPVInd.equals(""))
       {
         if (selPVInd.equalsIgnoreCase("New"))
           pvInd = -1;
         else
           pvInd = new Integer(selPVInd).intValue();
       }
     }
     System.out.println(selPVInd + " edited PV " + pvInd);
     HttpSession session = data.getRequest().getSession();
     VM_Bean selVM = (VM_Bean)session.getAttribute("selectVM");
     if (selVM == null || selVM.getVM_SHORT_MEANING().equals(""))
     {
       PV_Bean selectPV = new PV_Bean();
       if (pvInd > -1)
       {
         VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");      
      //   data.setRemovedPVList(vd.getRemoved_VDPVList());  //(Vector<PV_Bean>)session.getAttribute("RemovedPVList"));
         data.setVD(vd);
         
         Vector<PV_Bean> vVDPVList = vd.getVD_PV_List();  // (Vector)session.getAttribute("VDPVList");
         if (vVDPVList == null) vVDPVList = new Vector<PV_Bean>();
         selectPV = (PV_Bean)vVDPVList.elementAt(pvInd);
         if (selectPV != null && selectPV.getPV_VALUE() != null && !selectPV.getPV_VALUE().equals(""))
           selVM = selectPV.getPV_VM();
       }
       else
       {
         selectPV = (PV_Bean)session.getAttribute("NewPV");
         if (selectPV != null) 
           selVM = selectPV.getPV_VM();
       }     
     }
     data.setNewVM(selVM);
     return pvInd;
   }

   private void addPVOtherAttributes(PV_Bean pv, String changeType)
   {
     if (pv == null)
       pv = data.getSelectPV();
     String chgOrg = (String)data.getRequest().getParameter("currentOrg");  //edited origin
     if (chgOrg != null && !chgOrg.equals(""))
     {
       if (changeType.equals("changeAll"))
       {
         System.out.println("all origins");
         HttpSession session = data.getRequest().getSession();
         VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");
         data.setVD(vd);
         PVAct.doBlockEditPV(data, "origin", chgOrg);
         session.setAttribute("m_VD", data.getVD());
         return;
       }
       else
         pv.setPV_VALUE_ORIGIN(chgOrg);
     }
     
     String chgBD = (String)data.getRequest().getParameter("currentBD");  //edited begom date
     if (chgBD != null && !chgBD.equals(""))
     {
       if (changeType.equals("changeAll"))
       {
         System.out.println("all begin date");
         HttpSession session = data.getRequest().getSession();
         VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");
         data.setVD(vd);
         PVAct.doBlockEditPV(data, "begindate", chgBD);
         session.setAttribute("m_VD", data.getVD());
         return;
       }
       else
         pv.setPV_BEGIN_DATE(chgBD);
     }
     
     String chgED = (String)data.getRequest().getParameter("currentED");  //edited end date
     if (chgED != null && !chgED.equals(""))
     {
       if (changeType.equals("changeAll"))
       {
         System.out.println("all end date");
         HttpSession session = data.getRequest().getSession();
         VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");
         data.setVD(vd);
         PVAct.doBlockEditPV(data, "enddate", chgED);
         session.setAttribute("m_VD", data.getVD());
         return;
       }
       else
         pv.setPV_END_DATE(chgED);
     }
     
     data.setSelectPV(pv);
   }
   
   public String addPVValidates(VD_Bean vd)
   {
     HttpSession session = data.getRequest().getSession();
     if (vd ==null)
       vd = (VD_Bean)session.getAttribute("m_VD");
     data.setVD(vd);
     String sOriginAction = (String)session.getAttribute("originAction");
     data.setOriginAction(sOriginAction);
     //add values to validate bean
     Vector<String> vValString = PVAct.addValidateVDPVS(data);
     //add the vectors to the session
     data.getRequest().setAttribute("vValidate", vValString);  
     vd = data.getVD();
     data.getRequest().setAttribute("m_VD", vd);        
     return "/ValidateVDPage.jsp";
   }

   public void getPVAttributes(VD_Bean vd, String sMenu)  // 
   {
      try
      {
        String pvAct = "Search";
         if (sMenu.equals("NewVDTemplate")) pvAct = "NewUsing"; 

         String acIdseq = vd.getVD_VD_IDSEQ();
         String acName = vd.getVD_LONG_NAME();
         Vector<PV_Bean> vdpv = PVAct.doPVACSearch(acIdseq, acName, pvAct, data);
         vd.setVD_PV_List(vdpv);
         //pvCount = this.doPVACSearch(VDBean.getVD_VD_IDSEQ(), VDBean.getVD_LONG_NAME(), pvAct);
         GetACSearch serAC = new GetACSearch(data.getRequest(), data.getResponse(), data.getCurationServlet());
         if (sMenu.equals("Questions"))
           serAC.getACQuestionValue();
   
         //get vd parent attributes
         GetACService getAC = new GetACService(data.getRequest(), data.getResponse(), data.getCurationServlet());
         Vector<EVS_Bean> vParent = new Vector<EVS_Bean>();
         String sCondr = vd.getVD_PAR_CONDR_IDSEQ();
         if (sCondr != null && !sCondr.equals(""))
           vParent = getAC.getAC_Concepts(vd.getVD_PAR_CONDR_IDSEQ(), vd, true);
         //get the system name and for new template make the vd_id null
         if (sMenu.equals("NewVDTemplate")) vd.setVD_VD_ID("");
         vd = data.getCurationServlet().doGetVDSystemName(data.getRequest(), vd, vParent);
         vParent = serAC.getNonEVSParent(vParent, vd, sMenu);
          
         //session.setAttribute("VDParentConcept", vParent);  
         vd.setReferenceConceptList(vParent);
      }
      catch (Exception e)
      {
        logger.fatal("Error getPVattributes - " + e.toString(), e);
        e.printStackTrace();
      }


/*       //store new ones if added on the page
       if (sAction.equals("Version") && oldVDPV.size() != vList.size())
       {
         Vector vVal = (Vector)m_classReq.getAttribute("vValue");
         for (int i=0; i<oldVDPV.size(); i++)
         {
           PV_Bean thisPV = (PV_Bean)oldVDPV.elementAt(i);
           //make sure it doesn't exists already in the vector and is not deleted
           if (!vVal.contains(thisPV.getPV_VALUE()) && !thisPV.getVP_SUBMIT_ACTION().equals("DEL"))
           {
             vList.addElement(thisPV);
           }
         }
       }
       //store the first element and count in the request
       String pvValue = "";
       if (vList != null && vList.size() > 0)
       {
         pvBean = (PV_Bean)vList.elementAt(0);
         pvValue = pvBean.getPV_VALUE();
         pvCount = new Integer(vList.size());
       }
       m_classReq.setAttribute("PermValueList", vList);
       m_classReq.setAttribute("ACName", acName);
       //get first pv name in the request
       m_classReq.setAttribute("pvValue", pvValue);
       session.setAttribute("VDPVList", vList);  //store the bean
       //store copy of this bean in the session also.
       Vector<PV_Bean> oldVDPVList = new Vector<PV_Bean>();
       for (int k =0; k<vList.size(); k++)
       {
         PV_Bean cBean = new PV_Bean();
         cBean = cBean.copyBean((PV_Bean)vList.elementAt(k));
         oldVDPVList.addElement(cBean);
         //System.out.println(cBean.getPV_BEGIN_DATE() + " what is at set " + cBean.getPV_END_DATE());
       }
       session.setAttribute("oldVDPVList", oldVDPVList);  //stor eit in the session       
*/     
   }  //doPVACSearch search

   public Vector<PV_Bean> searchPVAttributes(String InString, String cd_idseq, String conName, String conID)
   {
     Vector<PV_Bean> vdpv = PVAct.doPVVMSearch(InString, cd_idseq, conName, conID, data);
     return vdpv;
   }

   @SuppressWarnings("unchecked")
   public String storeConceptAttributes()
   {
     HttpSession session = (HttpSession)data.getRequest().getSession();
     Vector<EVS_Bean> vRSel = (Vector)session.getAttribute("vACSearch");
     if (vRSel == null) vRSel = new Vector<EVS_Bean>();

     //get the array from teh hidden list
     String selRows[] = data.getRequest().getParameterValues("hiddenSelectedRow");  //("hiddenSelRow");
     if (selRows == null)
       data.setStatusMsg("Unable to select Concept, please try again");    
     else
     {
       System.out.println("call method to get the concepts");
       //get evs user bean from teh session
       EVS_UserBean eUser = (EVS_UserBean)NCICurationServlet.sessionData.EvsUsrBean; 
       if (eUser == null) eUser = new EVS_UserBean();
       //get the editing VM from teh page
       int pvInd = getSelectedVM();  // getSelectedPV();
       VM_Bean selectVM = data.getNewVM();
       if (selectVM != null)
       {         
      System.out.println(selectVM.getVM_SHORT_MEANING() + " sele vm " + selectVM.getVM_IDSEQ());
         EVS_Bean eBean = PVAct.doAppendConcepts(selRows, vRSel, eUser, pvInd, data);
         //store teh concept and vm attrirbutes in the request to place it on the vd page
         if (eBean != null && !eBean.getLONG_NAME().equals(""))
         {
           data.getRequest().setAttribute("selConcept", eBean);
           VM_Bean vm = data.getNewVM();     //getSelectPV().getPV_VM();
           session.setAttribute("selectVM", vm);
           //mark the NVP concepts 
/*           for (int i =0; i<vRSel.size(); i++)
           {
             EVS_Bean sBean = (EVS_Bean)vRSel.elementAt(i);
             sBean.markNVPConcept(sBean, session);
             vRSel.setElementAt(sBean, i);
           }
           session.setAttribute("vACSearch", vRSel);
*/         }
/*         if (pvInd < 0)
           session.setAttribute("NewPV", data.getSelectPV());
         else
           session.setAttribute("m_VD", data.getVD());
*/       }
       
     }
     //EVSSearch evs = new EVSSearch(data.getRequest(), data.getResponse(), data.getCurationServlet());
     Vector<String> vRes = new Vector<String>();
     //evs.get_Result(data.getRequest(), data.getResponse(), vRes, "");
     session.setAttribute("results", vRes);
     return "/OpenSearchWindowBlocks.jsp";
   }
   
   
   @SuppressWarnings("unchecked")
   public void submitPV(VD_Bean vd)
   {
     
     Vector<PV_Bean> vVDPVS = vd.getVD_PV_List();
     if (vVDPVS == null) vVDPVS = new Vector<PV_Bean>();
     
     //insert or update vdpvs relationship
     String ret = "";
     for (int j=0; j<vVDPVS.size(); j++)
     {
         PV_Bean pvBean = (PV_Bean)vVDPVS.elementAt(j);
         //submit the pv to either insert or update if something done to this pv
         String vpAction = pvBean.getVP_SUBMIT_ACTION();
         if (vpAction == null) vpAction = "NONE";
         //submit the vm if edited
         VM_Bean vm = pvBean.getPV_VM();
         if (vm.getVM_CD_IDSEQ() == null || vm.getVM_CD_IDSEQ().equals(""))
           vm.setVM_CD_IDSEQ(vd.getVD_CD_IDSEQ());
         VMServlet vmser = new VMServlet(data.getRequest(), data.getResponse(), data.getCurationServlet());
         String errCode = vmser.submitVM(vm);
         //udpate pv and vdpvs only if edited
         if (!vpAction.equals("NONE") && !vpAction.equals("DEL"))
         {
             if (errCode == null || errCode.equals(""))
             {
//                 create new pv if not exists already.
               String sPVid = pvBean.getPV_PV_IDSEQ();
               String vmName = pvBean.getPV_SHORT_MEANING();
               if (vmName == null) vmName = "";
               //short meaning don't match from pv to vm
               if (vpAction.equals("INS") || vmName.equals("")  || !vmName.equals(vm.getVM_SHORT_MEANING()))
               {
                 sPVid = "";
                 pvBean.setPV_PV_IDSEQ(sPVid);
                 pvBean.setPV_VDPVS_IDSEQ(sPVid);
               }
               pvBean.setPV_SHORT_MEANING(vm.getVM_SHORT_MEANING());  //need to update PV vm befor esubmit
               data.setSelectPV(pvBean);
               if (sPVid == null || sPVid.equals("") || sPVid.contains("EVS"))   
                 ret = PVAct.setPV(data);                    
             }
             if (data.getRetErrorCode() == null || data.getRetErrorCode().equals(""))
             {
               //remove olny if it was already existed in the database 
               data.setSelectPV(pvBean);
               data.setVD(vd);
               ret = PVAct.setVD_PVS(data);
               if (ret == null || ret.equals(""))
               {
                   //create crf value pv relationship in QC table.
                   pvBean = data.getSelectPV();
                   String vpID = pvBean.getPV_VDPVS_IDSEQ();
                   if (pvBean.getVP_SUBMIT_ACTION().equals(PVForm.CADSR_ACTION_INS) && (vpID != null  || !vpID.equals("")))
                   {
                      InsACService insac = new InsACService(data.getRequest(), data.getResponse(), data.getCurationServlet());
                      insac.UpdateCRFValue(pvBean);
                   }
                   pvBean.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_NONE);
                   vVDPVS.setElementAt(pvBean, j);
               }
             }
         }
       }  //end loop
       vd.setVD_PV_List(vVDPVS);
       data.getRequest().setAttribute("retcode", data.getRetErrorCode()); 
       //delete the record when items were added to the deleted vector
       Vector<PV_Bean> delVDPV = vd.getRemoved_VDPVList();  // (Vector)session.getAttribute("RemovedPVList");
       if (delVDPV != null)
       {
         for (int i =0; i<delVDPV.size(); i++)
         {
           PV_Bean pv = delVDPV.elementAt(i);
           String idseq = pv.getPV_PV_IDSEQ();
           if (idseq != null && !idseq.equals("") && !idseq.contains("EVS"))
           {
             pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_DEL);
             data.setSelectPV(pv);
             data.setVD(vd);
             ret = PVAct.setVD_PVS(data);
           }
         }
         vd.setRemoved_VDPVList(new Vector<PV_Bean>());
       }
   }

   private String doRemovePV()
   {
     int pvInd = getSelectedPV();
     if (pvInd > -1)
     {
       HttpSession session = data.getRequest().getSession();
       //remove the pv from the current vd list
       VD_Bean vd = data.getVD();
       Vector<PV_Bean> vdpvs = vd.getVD_PV_List();
       vdpvs.removeElementAt(pvInd);
       vd.setVD_PV_List(vdpvs);
       //add the removed pv to the removed pv list
       PV_Bean selPV = data.getSelectPV();
       if (selPV != null)
       {
         selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_DEL);
         Vector<PV_Bean> rmList = vd.getRemoved_VDPVList();  // data.getRemovedPVList();
         rmList.addElement(selPV);
         //session.setAttribute("RemovedPVList", rmList);
         vd.setRemoved_VDPVList(rmList);
       }
       //make the one before to be in view
       if (pvInd > 0)
         pvInd = (pvInd - 1);
       
       session.setAttribute("m_VD", vd);
     }
     data.getRequest().setAttribute("focusElement", "pv" + pvInd + "View");
     return "/PermissibleValue.jsp";
   }

   private String doRestorePV()
   {
     int pvInd = getSelectedPV();
     if (pvInd > -1)
     {
       HttpSession session = data.getRequest().getSession();
       //remove the pv from the current vd list
       PV_Bean selPV = data.getSelectPV();
       if (selPV != null)
       {
         //check it idseq was from cadsr
         String idseq = selPV.getPV_PV_IDSEQ();
         PV_Bean orgPV = new PV_Bean();
         if (idseq != null && !idseq.equals("") && !idseq.contains("EVS"))
         {
           VD_Bean oldvd = (VD_Bean)session.getAttribute("oldVDBean");
           Vector<PV_Bean> vdpvs = oldvd.getVD_PV_List();
           if (vdpvs.size() > 0)  
           {
             for (int i=0; i<vdpvs.size(); i++)
             {
               PV_Bean thisPV =  (PV_Bean)vdpvs.elementAt(i);
               if (thisPV.getPV_PV_IDSEQ() != null && selPV.getPV_PV_IDSEQ() != null && thisPV.getPV_PV_IDSEQ().equals(selPV.getPV_PV_IDSEQ()))
               {
                 orgPV = orgPV.copyBean(thisPV);
                 break;
               }
             }
           }
         }
         else
           orgPV = orgPV.copyBean(selPV);

         VD_Bean vd = data.getVD();
         Vector<PV_Bean> vCurVP = vd.getVD_PV_List();
         orgPV.setPV_VIEW_TYPE("expand");
         vCurVP.setElementAt(orgPV, pvInd);
         vd.setVD_PV_List(vCurVP); 
         session.setAttribute("m_VD", vd);
       }
     }
     data.getRequest().setAttribute("focusElement", "pv" + pvInd + "View");     
     return "/PermissibleValue.jsp";
   }

   /**
    * gets the selected vm from the resutls and append the concepts and other attributes to the pv bean
    *
    */
   @SuppressWarnings("unchecked")
   public String appendSearchVM()
   {
     //read the selected row from the request
     HttpSession session = (HttpSession)data.getRequest().getSession();
     Vector<VM_Bean> vRSel = (Vector)session.getAttribute("vACSearch");
     if (vRSel == null) vRSel = new Vector<VM_Bean>();

     //get the array from teh hidden list
     String selRows[] = data.getRequest().getParameterValues("hiddenSelRow");  //("hiddenSelRow");
     if (selRows == null)
       data.setStatusMsg("Unable to select value meaning, please try again");    
     else
     {
       PV_Bean pv = (PV_Bean)session.getAttribute("NewPV");
       if (pv == null) pv = new PV_Bean();
       //make sure all the hand typed data is captured
       String sPV = (String)data.getRequest().getParameter("pvNewValue");  //value
       if (sPV == null) sPV = "";
       pv.setPV_VALUE(sPV);
       //add pv other attribtutes 
       addPVOtherAttributes(pv, "changeOne");
       //get the vm bean
       VMAction vmAct = new VMAction();
       vmAct.doAppendSelectVM(selRows, vRSel, pv);
       session.setAttribute("NewPV", pv);
     }
     data.getRequest().setAttribute("focusElement", "divpvnew");
     data.getRequest().setAttribute("refreshPageAction", "openNewPV");
     return "/PermissibleValue.jsp";
   }
   
   
   /**
    * connects the db and returns the connection object
    * @return Connection object
    */
   public static Connection makeDBConnection()
   {
     Connection sbr_db_conn = null;
     try
     {
       // Create a Callable Statement object. connection class is in the future
     //  DatabaseConnection dbCon = new DatabaseConnection();
     //  sbr_db_conn = dbCon.connectDB(req);
       NCICurationServlet servlet = data.getCurationServlet();
       sbr_db_conn = servlet.connectDB(data.getRequest(), data.getResponse());
       if (sbr_db_conn == null) 
         logger.fatal("Error : Unable to make db connection.");
     }
     catch (Exception e)
     {
       logger.fatal("Error : Unable to make db connection.", e);
       data.setStatusMsg("Error : Unable to make db connection." + e.toString());
       data.setActionStatus(PVForm.ACTION_STATUS_FAIL);
     }
     return sbr_db_conn;
   }
   /**
    * closes the db connection
    * @param con connection object
    */
   public static void closeDBConnection(Connection con)
   {
     try
     {
       if (con != null && !con.isClosed())
         con.close();
     }
     catch (Exception e)
     {
       logger.fatal("Error : Unable to close connection.", e);
       data.setStatusMsg("Error : Unable to close db connection." + e.toString());
       data.setActionStatus(PVForm.ACTION_STATUS_FAIL);
     }
   }
   
} //end of teh class
