// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VMServlet.java,v 1.16 2007-05-23 15:44:26 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.util.ToolURL;
import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 * @author shegde
 */

public class VMServlet extends GenericServlet
{
  private static final Logger logger = Logger.getLogger(VMServlet.class.getName());
  private static final long serialVersionUID = 1L;
  /**VM Form object*/
  public VMForm vmData = null;
  private VMAction vmAction = new VMAction();

  /**
   * Constructor
   * 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          NCICurationServlet pointer
   */
  public VMServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
  {
    vmData = new VMForm();
    httpRequest = req;
    httpResponse = res;
    curationServlet = ser;
    vmData.setCurationServlet(ser);
  }

  /**
   * starts the request and calls methods as per the request
   * @return String jsp name
   */
  public String execute()
  {
    String retData = VMForm.JSP_PV_DETAIL;
    try
    {
      super.execute();
      vmData = new VMForm();
      vmData.setCurationServlet(curationServlet);
      
      //call the method to capture user entered data
      captureUserEntered(pageAction);
      
      //to go back to PV
      if (pageAction.equals(VMForm.ACT_BACK_PV))
        retData = goBackToPV();
      //to switch between the tabs
      else if (pageAction.equals(VMForm.ELM_ACT_USED_TAB) || pageAction.equals(VMForm.ELM_ACT_DETAIL_TAB))
        retData = changeTab(pageAction);
      //to append the concept after the search
      else if (pageAction.equals(VMForm.ACT_CON_APPEND))
        retData = appendConceptEditVM();
      //to delete one concept or all concepts
      else if (pageAction.equals(VMForm.ACT_CON_DELETE))
        retData = deleteConceptEditVM();
      //to move the concept up or down 
      else if (pageAction.equals(VMForm.ACT_CON_MOVEUP) || pageAction.equals(VMForm.ACT_CON_MOVEDOWN))
        retData = moveConceptEditVM(pageAction);
      //to clear the changes to vm
      else if (pageAction.equals(VMForm.ACT_CLEAR_VM))
        retData = clearEditVM();
      //to validate the changes to vm
      else if (pageAction.equals(VMForm.ACT_VALIDATE_VM))
        retData = validateEditVM();      
      //to go back to edit vm and focus the ealier tab selection
      else if (pageAction.equals(VMForm.ACT_REEDIT_VM))
        retData = changeTab("");      
      //to submit the changes to vm
      else if (pageAction.equals(VMForm.ACT_SUBMIT_VM))
        retData = submitEditVM();      
      //to sort the used ac
      else if (pageAction.equals(VMForm.ACT_SORT_AC))
        retData = sortUsedAC();      
      //to sort the used ac
      else if (pageAction.equals(VMForm.ACT_FILTER_AC))
        retData = filterUsedAC();      
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - execute ", e);
    }  
    finally
    {
      String to = (String)httpRequest.getSession().getAttribute(VMForm.SESSION_VM_TAB_FOCUS);
      if (to == null) to = "";
      if (to.equals(VMForm.ELM_ACT_USED_TAB))
        writeUsedJsp();
      else if (to.equals(VMForm.ELM_ACT_DETAIL_TAB))
        writeDetailJsp();
    }
    //send back to servlet
    return retData;
  }

  /**
   * start the search
   */
  @SuppressWarnings("unchecked")
  public void readDataForSearch()
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    //get the cd id to filter
    String sCDid = ""; 
    sCDid = (String)req.getParameter("listCDName");    //get selected cd
    if(sCDid == null || sCDid.equals("All Domains")) 
    		sCDid = "";       
    session.setAttribute("creSelectedCD", sCDid);
    vmData.setSearchFilterCD(sCDid);
    
    //get the keyword for filter
    String sKeyword = (String)req.getParameter("keyword");
        if (sKeyword == null)
            sKeyword = "";
    session.setAttribute("creKeyword", sKeyword);   //keep the old criteria
    UtilService util = new UtilService();
    sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);
    vmData.setSearchTerm(sKeyword);
    
    //store the attributes to display in the vmData
    vmData.setSelAttrList((Vector)session.getAttribute("creSelectedAttr"));
    
    //call the action to do the search
    vmAction.searchVMValues(vmData);
    
    //put the results back in the session
    Vector<VM_Bean> vAC = vmData.getVMList();
    if (vAC == null)
        vAC = new Vector<VM_Bean>();
    session.setAttribute("vACSearch", vAC);

    //call the method to get the result vector
    this.readVMResult();
    //keep these empty for now
    session.setAttribute("SearchLongName", new Vector<String>());
    session.setAttribute("SearchMeanDescription",  new Vector<String>());      
    
  }

  /**
   * do vm sorting
   */
  @SuppressWarnings("unchecked")
  public void readDataForSort()
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    
    //get the request or session attributes into the form vmData
    vmData.setSelAttrList((Vector)session.getAttribute("creSelectedAttr"));
    vmData.setVMList((Vector)session.getAttribute("vACSearch"));
    String sortField = (String)req.getParameter("sortType");
    if (sortField == null) 
    	sortField = (String)session.getAttribute("sortType");
    vmData.setSortField(sortField);
    
    //call teh method for sorting
    vmAction.getVMSortedRows(vmData);
    
    //put the results back in the session
    Vector<VM_Bean> vAC = vmData.getVMList();
    session.setAttribute("vACSearch", vAC);
    //call the method to get the result vector
    this.readVMResult();
  }

  /**
   * read the vmData from edits or creates
   * @param pv PVBean object
   * @param pvInd int selected PV indicator
   */
  public void readDataForCreate(PV_Bean pv, int pvInd)
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
  //  boolean newPVVM = true;
    //get all attributes of the vm into this bean
    VM_Bean vm = new VM_Bean();
    VM_Bean selvm = new VM_Bean();
    if (pv != null && pv.getPV_VALUE() != null && !pv.getPV_VALUE().equals(""))
      vm = resetConceptsFromPage(pv);  //pv.getPV_VM();

    boolean handTypedVM = true;
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    if (vmCon != null && vmCon.size() > 0)
      handTypedVM = false;
    //read vm name and desc if no concept
    if (handTypedVM)
    {
      String sVM = "";
      String sVMD = "";
      if (pvInd == -1)
      {
        sVM = (String)req.getParameter("pvNewVM");  //vm name
        sVMD = (String)req.getParameter("pvNewVMD");  //vm desc  
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
     // System.out.println(sVM + " new " + sVMD);
      }
      else
      {
        sVM = (String)req.getParameter("txtpv" + pvInd + "Mean");  //vm name
        sVMD = (String)req.getParameter("txtpv" + pvInd + "Def");  //vm desc        
      }      
      //first capture description attributes
      if (sVMD != null && !sVMD.equals("") && !vm.getVM_DESCRIPTION().equals(sVMD))
      {
        sVMD = sVMD.trim();//trim out the extra spaces
        vm.setVM_DESCRIPTION(sVMD); 
        //do not make it new if defintion is different
       // vm.setVM_IDSEQ("");
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);
      }
      //now capture name attribute
      if (sVM != null && !sVM.equals("") && !vm.getVM_SHORT_MEANING().equals(sVM))
      {
        UtilService util = new UtilService();        
        sVM = sVM.trim();//trim out the extra spaces
        sVM = util.removeNewLineChar(sVM);
        vm.setVM_SHORT_MEANING(sVM);
        vm.setVM_LONG_NAME(sVM);
        vm.setVM_IDSEQ("");
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
      }
    }
    //call the action change VM to validate the vm
    VD_Bean vd = (VD_Bean)session.getAttribute(PVForm.SESSION_SELECT_VD);  //vm cd
    vmData.setVMBean(vm);
    
    VD_Bean oldvd = (VD_Bean)session.getAttribute("oldVDBean");
    Vector<PV_Bean> vdpvs = oldvd.getVD_PV_List();
    if (pvInd > -1 && vdpvs.size() > 0)  // (selvm != null)
    {
        for (int i=0; i<vdpvs.size(); i++)
        {
          PV_Bean orgPV =  (PV_Bean)vdpvs.elementAt(i);
          if (orgPV != null && pv.getPV_PV_IDSEQ() != null && orgPV.getPV_PV_IDSEQ().equals(pv.getPV_PV_IDSEQ()))
          {            
            selvm = orgPV.getPV_VM();
            vmData.setSelectVM(selvm);
         //   if (selvm.getVM_SHORT_MEANING().equals(vm.getVM_SHORT_MEANING()))
         //     newPVVM = false;
            break;
          }
        }
    }

    vmAction.setDataForCreate(pv, vd, vmData);
    // - handle status message and other session attributes as needed    
    Vector<VM_Bean> vErrMsg = vmData.getErrorMsgList();
    if (vErrMsg != null && vErrMsg.size()>0)
    {
      session.setAttribute("VMEditMsg", vErrMsg);
      httpRequest.setAttribute("ErrMsgAC", vmData.getStatusMsg());
      httpRequest.setAttribute("editPVInd", pvInd);
      vmData.setVMBean(vm);
      Vector<VM_Bean> vmList = vmData.getExistVMList();
      if (vmList.size() > 0)
          httpRequest.setAttribute("vmNameMatch", "true");  
    }
  }
  
  /**
   * method to call Submit to the Database
   * @param vm VMBEan object
   * @return String vm error message
   */
  public String submitVM(VM_Bean vm)
  {
    String vmError = "";
    Connection conn = null;
    try
    {
      vmData.setVMBean(vm);
      if (!vm.getVM_SUBMIT_ACTION().equals(VMForm.CADSR_ACTION_NONE))
        vmError = vmAction.doSubmitVM(vmData);

      httpRequest.setAttribute("retcode", vmData.getRetErrorCode());  
      //save the alt names  //TODO - Larry - sumbit the alt name edits
      if (vm != null && !vm.getVM_IDSEQ().equals(""))
      {
        //System.out.println(vm.getVM_IDSEQ() + " vm alt name " + vm.getVM_LONG_NAME());
        conn = vmData.getCurationServlet().connectDB();
        vm.save(httpRequest.getSession(), conn, vm.getVM_IDSEQ(), vm.getVM_CONTE_IDSEQ());
      }      
    
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - submitting vm ", e);
    }
    finally
    {
      if (conn != null)
        vmData.getCurationServlet().freeConnection(conn);
    }
    return vmError;
  }

  /**
   * appends the selected concept from the search to editing vm
   * @param selVM VM_Bean object
   * @param iFrom int to recognize teh page it is called from
   * @return String forward jsp
   */
  public String appendConceptVM(VM_Bean selVM, int iFrom)
  {
    HttpSession session = httpRequest.getSession();
    ConceptServlet conSer = new ConceptServlet(httpRequest, httpResponse, curationServlet);
    String errMsg = conSer.appendSelectConcept(iFrom);
    //log the message and display it to the user
    if (!errMsg.equals(""))
    {
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, errMsg);
    }
    //store teh concept and vm attrirbutes in the request to place it on the vd page; append it regardless of the message
    EVS_Bean eBean =  (EVS_Bean)httpRequest.getAttribute(VMForm.REQUEST_SEL_CONCEPT);
    if (eBean != null && !eBean.getLONG_NAME().equals(""))
    {
        vmAction.doAppendConcept(selVM, eBean, iFrom);
        session.setAttribute(VMForm.SESSION_SELECT_VM, selVM);
    }
    return errMsg;
  }

  /**
   * puts the changed data into form object to display
   */
  public void writeDetailJsp()
  {
    VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
    VMForm retForm = new VMForm();
    retForm.vmDisplayName = vmAction.getVMDisplayName(vm);
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    //add long name
    int nlen = vm.getVM_LONG_NAME().length();
    if (nlen > 139)
      nlen = 95;
    else if (nlen > 60 && nlen < 140)
      nlen = (nlen/2) + 5;
    else
      nlen = 30;
    String nWidth = String.valueOf(nlen) + "%";
    //add the width name to the hash table
    retForm.longNameWidth = nWidth;
    retForm.longName =  vm.getVM_LONG_NAME();
    //add definition
    retForm.descriptionLabel = VMForm.ELM_LBL_DESC;
    if (vmCon.size() > 0)
    {
      retForm.descriptionLabel = VMForm.ELM_LBL_MAN_DESC;
      retForm.description = vm.getVM_ALT_DEFINITION();
      retForm.systemDescription = vm.getVM_DESCRIPTION();      
      //add concepts
      retForm.conceptExist = true;
      retForm.conceptSummary = vm.getVM_ALT_NAME();  
      retForm.vmConcepts = vm.getVM_CONCEPT_LIST();  //vm.cloneVMConVector(vmCon);
      vmAction.resetPrimaryFlag(retForm.vmConcepts);
    }
    else
      retForm.description = vm.getVM_DESCRIPTION();      
    //add change note
    retForm.changeNote = vm.getVM_CHANGE_NOTE(); 

    httpRequest.setAttribute(VMForm.REQUEST_FORM_DATA, retForm);
  }

  /**
   * puts the changed data into form object to display
   */
  public void writeUsedJsp()
  {
    VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
    VMForm retForm = new VMForm();
    //set attributes
    retForm.vmDisplayName = vmAction.getVMDisplayName(vm);
    retForm.vmVDs = vm.getVM_VD_LIST();
    retForm.vmDEs = vm.getVM_DE_LIST();
    retForm.vmCRFs = vm.getVM_CRF_LIST();
    if (vm.getVM_SHOW_RELEASED_CRF())
    {
      retForm.filteredCRF = VMForm.ELM_LBL_SHOW_ALL;
      retForm.vmCRFs = filterACs(vm.getVM_CRF_LIST());
    }
    if (vm.getVM_SHOW_RELEASED_VD())
    {
      retForm.filteredVD = VMForm.ELM_LBL_SHOW_ALL;
      retForm.vmVDs = filterACs(vm.getVM_VD_LIST());
    }
    if (vm.getVM_SHOW_RELEASED_DE())
    {
      retForm.filteredDE = VMForm.ELM_LBL_SHOW_ALL;
      retForm.vmDEs = filterACs(vm.getVM_DE_LIST());
    }
    retForm.sortedCRF = vm.getVM_SORT_COLUMN_CRF();
    retForm.sortedDE = vm.getVM_SORT_COLUMN_DE();
    retForm.sortedVD = vm.getVM_SORT_COLUMN_VD();
    //store the form
    httpRequest.setAttribute(VMForm.REQUEST_FORM_DATA, retForm);
  }
  
//private methods
  @SuppressWarnings("unchecked")
  private Vector<CommonACBean> filterACs(Vector<CommonACBean> vAC)
  {
    Vector<CommonACBean> vFilter = new Vector<CommonACBean>();
    Vector<String> vStat = (Vector)httpRequest.getSession().getAttribute(Session_Data.SESSION_ASL_FILTER);
    for (int i=0; i<vAC.size(); i++) 
    {
      CommonACBean ac = (CommonACBean)vAC.elementAt(i);
      String wfs = ac.getWorkflowStatus();
      if (vStat.contains(wfs))
        vFilter.addElement(ac);
    }
    return vFilter;
  }
  
  /**
   * captures the user entered data 
   * called for every vm edit page submit
   * @param sAction String action
   */
  private void captureUserEntered(String sAction)
  {
    try
    {
      if (!sAction.equals(VMForm.ACT_BACK_PV) && !sAction.equals(VMForm.ACT_SUBMIT_VM))
      {
        HttpSession session = httpRequest.getSession();
        VM_Bean vm = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
        //check if user entered alt def exists
        String sDef = (String)httpRequest.getParameter(VMForm.ELM_DEFINITION);
        if (sDef != null)
        {
          if (sDef.equals(""))  //this helps to keeps to create default alt defintion only when going from user defined vm to concept vm
              sDef = " ";
          if (vm.getVM_CONCEPT_LIST().size() > 0)
            vm.setVM_ALT_DEFINITION(sDef);
          else
            vm.setVM_DESCRIPTION(sDef);
        }
        //check if user entered comment exists
        String sCmt = (String)httpRequest.getParameter(VMForm.ELM_CHANGE_NOTE);
        if (sCmt != null)
        { 
          if (sCmt.equals(""))
            sCmt = " ";
          if (!sCmt.equals(" "))  //remove the xtra space if any
              sCmt = sCmt.trim();
          vm.setVM_CHANGE_NOTE(sCmt);
        }
        //update the session attribute
        session.setAttribute(VMForm.SESSION_SELECT_VM, vm);
      }
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - ", e);
    }
  }

  /**
   * returns back to pv page
   * @return String jsp to go back
   */
  private String goBackToPV()
  {
    try
    {
        //clear vm attribute
        HttpSession session = httpRequest.getSession();
        int pvInd = (Integer)session.getAttribute(PVForm.SESSION_PV_INDEX);
        httpRequest.setAttribute(PVForm.REQUEST_FOCUS_ELEMENT, "pv" + pvInd);
        session.setAttribute(VMForm.SESSION_SELECT_VM, new VM_Bean());
        //remove the attribute
        session.removeAttribute(PVForm.SESSION_PV_INDEX);
        session.removeAttribute(VMForm.SESSION_SELECT_PV);
        
    }
    catch (RuntimeException e)
    {
        logger.fatal("ERROR - back to pv ", e);
    }
    return VMForm.JSP_PV_DETAIL;
  }

  /**
   * switchs back forth on the tab
   * @param to String the tab name to change to
   * @return String jsp to go back
   */
  private String changeTab(String to)
  {
    //default to detail page
    String retData = VMForm.JSP_VM_DETAIL;
    HttpSession session = httpRequest.getSession();
    //get the existing tab focus
    if (to.equals(""))
      to = (String)session.getAttribute(VMForm.SESSION_VM_TAB_FOCUS);
    else
      session.setAttribute(VMForm.SESSION_VM_TAB_FOCUS, to);
    //set the element focus to empty
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, "");
    if (to != null && to.equals(VMForm.ELM_ACT_USED_TAB))
    {
      VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
      this.readAllUsedComponents(selVM, false, "");
      retData = VMForm.JSP_VM_USED;
    }
    //return jsp
    return retData;
  }

  /**
   * appends the selected concept from teh search to the value meaning
   * gets appropriate definitions and concept summary name
   * focus the element to concept and forwards the page back
   * @return String jsp to go back
   */
  private String appendConceptEditVM()
  {
    HttpSession session = httpRequest.getSession();
    VM_Bean selectVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    String errMsg = appendConceptVM(selectVM, ConceptForm.FOR_VM_PAGE_CONCEPT);
    if (!errMsg.equals(""))
      session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, errMsg);
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, VMForm.ELM_LABEL_CON);
    return VMForm.JSP_VM_DETAIL;    
  }

  /**
   * get the rowno to delete
   * loop thourh the list to delete one by one if marked to delete all
   * @return String jsp to go back
   */
  private String deleteConceptEditVM()
  {
    HttpSession session = httpRequest.getSession();
    String sRow = httpRequest.getParameter(VMForm.ELM_SEL_CON_ROW);
    VM_Bean selectVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    if (sRow != null)
    {
      String smsg = vmAction.doDeleteConcept(selectVM, sRow);
      if (!smsg.equals(""))
      {
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, smsg);
        session.setAttribute(VMForm.SESSION_SELECT_VM, selectVM);
      }
    }    
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, VMForm.ELM_LABEL_CON);
    return VMForm.JSP_VM_DETAIL;
  }

  /**
   * to rearrange the concepts in the VM and display the name in the order it is displayed
   * @param sAction String indicates the action to move up or down 
   * @return String jsp to go back
   */
  private String moveConceptEditVM(String sAction)
  {
    HttpSession session = httpRequest.getSession();
    String sRow = httpRequest.getParameter(VMForm.ELM_SEL_CON_ROW);
    VM_Bean selectVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    if (sRow != null)
    {
      String smsg = vmAction.doMoveConcept(selectVM, sRow, sAction);
      if (!smsg.equals(""))
      {
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, smsg);
        session.setAttribute(VMForm.SESSION_SELECT_VM, selectVM);
      }
    }    
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, VMForm.ELM_LABEL_CON);
    return VMForm.JSP_VM_DETAIL;
  }

  /**
   * clears the edits and restores it to the opened page
   * @return String jsp name
   */
  private String clearEditVM()
  {
    HttpSession session = httpRequest.getSession();
    PV_Bean selPV = (PV_Bean)session.getAttribute(VMForm.SESSION_SELECT_PV);
    VM_Bean selVM = vmAction.getVM(selPV, -1);  //-1 to clear
    //set the attributes
    session.setAttribute(VMForm.SESSION_SELECT_VM, selVM);
    return changeTab("");  // VMForm.JSP_VM_DETAIL;    
  }

  /**
   * validates the vm and forwards it to validate page
   * @return String jsp name
   */
  private String validateEditVM()
  {
    HttpSession session = httpRequest.getSession();
    VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    Vector<ValidateBean> vVal = vmAction.doValidateVM(selVM);
    //set the attributes
    SetACService setAC = new SetACService(curationServlet);
    Vector<String> vValString = setAC.makeStringVector(vVal);
    httpRequest.setAttribute(Session_Data.REQUEST_VALIDATE, vValString);        
    return VMForm.JSP_VM_VALIDATE;    
  }

  /**
   * submits the vm changes to database 
   * forwards to pv page
   * @return String jsp to go back
   */
  private String submitEditVM()
  {
   // String jsp = VMForm.JSP_PV_DETAIL;
    HttpSession session = httpRequest.getSession();
    VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    String vmSubmit = selVM.getVM_SUBMIT_ACTION();
    if (vmSubmit.equals(VMForm.CADSR_ACTION_NONE))
        selVM.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);
    //to mark add/update/delete manual definition
    String sDef = selVM.getVM_ALT_DEFINITION();
    if (!sDef.equals(""))
    {
        AltNamesDefsServlet altSer = new AltNamesDefsServlet(vmData.getCurationServlet(), vmData.getCurationServlet().sessionData.UsrBean);
        altSer.editManualDefinition(httpRequest, VMForm.ELM_FORM_SEARCH_EVS, sDef);
    }
    
    //call the method to submit
    String errmsg = this.submitVM(selVM);
    if (errmsg != null && !errmsg.equals(""))      
      logger.fatal("ERROR message at submitEditVM : " + errmsg);
    else
      selVM.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_NONE);  
    
    //reset the vd bean
    PVServlet pvser = new PVServlet(httpRequest, httpResponse, curationServlet);
    pvser.putBackVMEdits(selVM);
    return goBackToPV();
  }

  /**
   * to get all the used componenets at the time of open
   * @param vm VM_Bean object
   * @param isStatFilter boolean to check if should the query filter the data by workflow status
   * @param orderBy String sort the query at the time of getting the data
   */
  private void readAllUsedComponents(VM_Bean vm, boolean isStatFilter, String orderBy)
  {
    String browseURL = (String) httpRequest.getSession().getAttribute(ToolURL.browserUrl);
    //read CRF
    readUsedComponent(new CaseReportFormAction(), vm, isStatFilter, orderBy);
    //read VD
    readUsedComponent(new ValueDomainAction(), vm, isStatFilter, orderBy);
    //read DE
    readUsedComponent(new DataElementAction(browseURL), vm, isStatFilter, orderBy);
  }
  
  /**
   * action to read one used component at a time
   * @param dbac CommonACAction object action file common to all ACs
   * @param vm VM_Bean name of the vm bean
   * @param isStatFilter  boolean to check if should the query filter the data by workflow status
   * @param orderBy String sort the query at the time of getting the data
   */
  private void readUsedComponent(CommonACAction dbac, VM_Bean vm, boolean isStatFilter, String orderBy)
  {
    Connection conn = null;
    try
    {
      //get the connection
      conn = vmData.getCurationServlet().connectDB();
      //query the database
      Vector<CommonACBean> vAC = dbac.getAssociated(conn, vm.getVM_SHORT_MEANING(), isStatFilter, orderBy);
      //set data to vm
      dbac.setUsedAttributes(vm, vAC, isStatFilter, null);
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - : " + e.toString(), e);
    }
    finally
    {
        //close connection
        if (conn != null)
            vmData.getCurationServlet().freeConnection(conn);
    }
  }
  
  /**
   * submits the vm changes to database 
   * forwards to pv page
   * @return String jsp to go back
   */
  private String sortUsedAC()
  {
    String sJsp = VMForm.JSP_VM_USED;
    HttpSession session = httpRequest.getSession();
    String acType = httpRequest.getParameter(VMForm.ELM_AC_TYPE);    
    String fieldType = httpRequest.getParameter(VMForm.ELM_FIELD_TYPE);
    if (acType == null || fieldType == null)
      return sJsp;
    //intiiate teh class 
    CommonACAction dbac = null;
    if (acType.equals(VMForm.ELM_CRF_NAME))
      dbac = new CaseReportFormAction();
    else if (acType.equals(VMForm.ELM_DE_NAME))
      dbac = new DataElementAction();
    else if (acType.equals(VMForm.ELM_VD_NAME))
      dbac = new ValueDomainAction();
    
    //sort the results
    VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    dbac.sortACs(selVM, fieldType);
    //store it in the vm
    session.setAttribute(VMForm.SESSION_SELECT_VM, selVM);
    //return the jsp
    session.setAttribute(VMForm.SESSION_VM_TAB_FOCUS, VMForm.ELM_ACT_USED_TAB);
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, acType);
    return sJsp;
  }
  
  /**
   * toggle action between released or show all items 
   * @return String jsp name
   */
  private String filterUsedAC()
  {
    String sJsp = VMForm.JSP_VM_USED;
    HttpSession session = httpRequest.getSession();
    //get the values from the page
    String acType = httpRequest.getParameter(VMForm.ELM_AC_TYPE);    
    if (acType == null)
      return sJsp;
    boolean bfilter = false;
    String filterType = httpRequest.getParameter(VMForm.ELM_FIELD_TYPE);
    if (filterType != null && filterType.equals(VMForm.ELM_LBL_SHOW_RELEASE))
      bfilter = true;
    VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    
    //set the property value
    if (acType.equals(VMForm.ELM_CRF_NAME))
      selVM.setVM_SHOW_RELEASED_CRF(bfilter);
    else if (acType.equals(VMForm.ELM_DE_NAME))
      selVM.setVM_SHOW_RELEASED_DE(bfilter);
    else if (acType.equals(VMForm.ELM_VD_NAME))
      selVM.setVM_SHOW_RELEASED_VD(bfilter);

    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, acType);
    return sJsp;
  }
  
  /**
   * gets teh result vector and stores attributes in the request/session object
   *
   */
  private void readVMResult()
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    
    //call teh method for sorting
    vmAction.getVMResult(vmData);
    //store teh result back in request/session attributes
    session.setAttribute("results", vmData.getResultList());
    req.setAttribute("creRecsFound", vmData.getNumRecFound());
    req.setAttribute("labelKeyword", vmData.getResultLabel());        
  }

  /** resets the vm concepts from page at save action to make sure newly added or deleted ones in the order
   * @param pv PVBean object
   * @return VM_Bean object
   */
  private VM_Bean resetConceptsFromPage(PV_Bean pv)
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    //use the session vm by default; if null or empty, use pv-vm  //TODO- check if this is right???
    VM_Bean vm = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);  // pv.getPV_VM();
    if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals("")) 
      vm = new VM_Bean().copyVMBean(pv.getPV_VM());
    Vector vmCon = vm.getVM_CONCEPT_LIST();
    String[] sCons = req.getParameterValues("hiddenConVM");
    if (sCons != null && vmCon != null)
    {
      vmAction.resetVMConcepts(sCons, vm, pv);
    }
    return vm;
  }

}
