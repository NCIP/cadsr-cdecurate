// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VMServlet.java,v 1.48 2009-01-20 14:58:30 veerlah Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;
import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;
import gov.nih.nci.cadsr.cdecurate.util.ToolURL;
import gov.nih.nci.cadsr.persist.exception.DBException;
import gov.nih.nci.cadsr.persist.vm.Value_Meanings_Mgr;
import gov.nih.nci.cadsr.persist.vm.VmVO;

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
  private UtilService         m_util           = new UtilService();

  /**
   * Constructor
   * 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          CurationServlet pointer
   */
  public VMServlet(HttpServletRequest req, HttpServletResponse res, CurationServlet ser)
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
    	   vmData.setSearchTerm("");
    	   if(pageAction.equals(VMForm.ACT_BACK_SEARCH))
    	   {
    		   String searchIn =(String)httpRequest.getSession().getAttribute("serSearchIn");
    		   if((searchIn!=null ||  !searchIn.equals(""))&& searchIn.equals("minID"))
    			   vmData.setSearchFilterID((String)httpRequest.getSession().getAttribute("creKeyword"));
    		   else if((searchIn!=null ||  !searchIn.equals(""))&& searchIn.equals("concept"))
    			   vmData.setSearchFilterConName((String)httpRequest.getSession().getAttribute("creKeyword"));
    		   else
    			   vmData.setSearchTerm((String)httpRequest.getSession().getAttribute("creKeyword"));
    	   }
    	   //if(((String)httpRequest.getSession().getAttribute(VMForm.SESSION_RET_PAGE)).equals(VMForm.JSP_PV_DETAIL))
    	   if (pageAction.equals(VMForm.ACT_VALIDATE_VM)||((String)httpRequest.getSession().getAttribute(VMForm.SESSION_RET_PAGE)).equals(VMForm.JSP_PV_DETAIL))
    	    {
    		   //call the method to capture user entered data
    		   captureUserEntered(pageAction);
    	    }   
      
      //to go back to PV
      if (pageAction.equals(VMForm.ACT_BACK_PV))
        retData = goBackToPV();
      if(pageAction.equals(VMForm.ACT_BACK_SEARCH))
    	  retData = goBackToSearch();
      //to switch between the tabs
      else if (pageAction.equals(VMForm.ELM_ACT_USED_TAB) || pageAction.equals(VMForm.ELM_ACT_DETAIL_TAB))
        retData = changeTab(pageAction);
      //to append the concept after the search
      else if (pageAction.equals(VMForm.ACT_CON_APPEND))
      {  
    	captureUserEntered(pageAction);  
        retData = appendConceptEditVM();
      }  
      //to delete one concept or all concepts
      else if (pageAction.equals(VMForm.ACT_CON_DELETE))
        {
    	  captureUserEntered(pageAction);
    	  retData = deleteConceptEditVM();
        }
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
      else if (pageAction.equals(VMForm.ACT_SORT_AC)){
        VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
        retData = sortUsedAC(vm, "edit"); 
      }
      //to sort the used ac
      else if (pageAction.equals(VMForm.ACT_FILTER_AC)){
    	  VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
    	  retData = filterUsedAC(vm); 
      }	  
    }
    catch (Exception e)
    {
      logger.error("ERROR - execute ", e);
    }  
    finally
    {
      String to = (String)httpRequest.getSession().getAttribute(VMForm.SESSION_VM_TAB_FOCUS);
      if (to == null) to = "";
      if (to.equals(VMForm.ELM_ACT_USED_TAB)){
    	  VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
    	  writeUsedJsp(vm);
      }  
      else if (to.equals(VMForm.ELM_ACT_DETAIL_TAB)){
        VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
        writeDetailJsp(vm);
      } 
    }
    //send back to servlet
    return retData;
  }

  /**
   * start the search
   */
  @SuppressWarnings("unchecked")
  public void readDataForSearch(GetACSearch getac)
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    //get the cd id to filter
    String sCDid = ""; 
    sCDid = (String)req.getParameter("listCDName");    //get selected cd
    if(sCDid == null || sCDid.equals("All Domains")) 
    		sCDid = "";       
    DataManager.setAttribute(session, "creSelectedCD", sCDid);
    //initialize the default values
    vmData.setSearchFilterCD(sCDid);
    if(vmData.getSearchFilterConName()==null || vmData.getSearchFilterConName().equals(""))
	{
    	vmData.setSearchFilterConName("");
	}
    if(vmData.getSearchFilterCondr()==null || vmData.getSearchFilterCondr().equals(""))
	{
    	vmData.setSearchFilterCondr("");
	}
    
    //get the keyword for filter
    String menuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
    String sKeyword = (String)req.getParameter("keyword");
      if (sKeyword == null)
            sKeyword = "";
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
          sKeyword = (String) session.getAttribute("LastAppendWord");
   
      DataManager.setAttribute(session, "creKeyword", sKeyword);   //keep the old criteria
    
    //get the searchIn
    String sSearchIn =null;
    if(pageAction!=null && pageAction.equals(VMForm.ACT_BACK_SEARCH))
	    sSearchIn =(String)httpRequest.getSession().getAttribute("serSearchIn");
    else
       sSearchIn = (String) req.getParameter("listSearchIn");
    if (sSearchIn == null)
    	sSearchIn = "";
    if (sSearchIn.equals("minID"))
    	{
    	 vmData.setSearchFilterID(sKeyword);
    	}
    if (sSearchIn.equals("concept"))
    	vmData.setSearchFilterConName(sKeyword);
    UtilService util = new UtilService();
   // sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);
    if(!sSearchIn.equals("minID") && !sSearchIn.equals("concept"))
    {	
    	if(vmData.getSearchTerm()==null || vmData.getSearchTerm().equals(""))
    	{
    	 vmData.setSearchTerm(sKeyword);
    	//vmData.setSearchFilterDef(sKeyword);
    	}
    }
    String actType = (String) req.getParameter("actSelect");
    //String menuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
    if(actType==null)actType="";
    if ((actType.equals("Attribute")&& !menuAction.equals("searchForCreate"))||(actType.equals("")&& !menuAction.equals("searchForCreate")))
    	//store the attributes to display in the vmData
        vmData.setSelAttrList((Vector)session.getAttribute("selectedAttr"));
    else
    	//store the attributes to display in the vmData
    	vmData.setSelAttrList((Vector)session.getAttribute("creSelectedAttr"));
    //set the version indicator
     setVersionValues(vmData,req,session);
    //call the action to do the search
    vmAction.searchVMValues(vmData);

    //put the results back in the session
    Vector<VM_Bean> vAC = vmData.getVMList();
    if (vAC == null)
        vAC = new Vector<VM_Bean>();
    DataManager.setAttribute(session, "vACSearch", vAC);

    //call the method to get the result vector
    this.readVMResult(getac);
    //keep these empty for now
    //DataManager.setAttribute(session, "SearchLongName", new Vector<String>());
    //DataManager.setAttribute(session, "SearchMeanDescription",  new Vector<String>());      
    
  }
  
  
 /**
 * @param vmData
 */
private void setVersionValues(VMForm vmData,HttpServletRequest req, HttpSession session)
{
	SetACService setAC = new SetACService(vmData.getCurationServlet());
	// filter by version
	String sVersion = (String) req.getParameter("rVersion");
	DataManager.setAttribute(session, "serVersion", sVersion);
	// get the version number if other
	String txVersion = "";
	if (sVersion != null && sVersion.equals("Other"))
		txVersion = (String) req.getParameter("tVersion");
	if (txVersion == null)
		txVersion = "";
	DataManager.setAttribute(session, "serVersionNum", txVersion);
	double dVersion = 0;
	// validate the version and display message if not valid
	if (!txVersion.equals("")) {
		// String sValid = setAC.checkVersionDimension(txVersion);
		String sValid = setAC.checkValueIsNumeric(txVersion, "Version");
		if (sValid != null && !sValid.equals("")) {
			logger.error("not a good version " + sValid);
			DataManager.setAttribute(session, "serVersionNum", "0");
		} else {
			Double DVersion = new Double(txVersion);
			dVersion = DVersion.doubleValue();
		}
	}
	// make sVersion to empty if all or other
	if (sVersion == null || sVersion.equals("All")
			|| sVersion.equals("Other"))
		sVersion = "";
	
	vmData.setVersionInd(sVersion);
	vmData.setVersionNumber(dVersion);

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
    DataManager.setAttribute(session, "vACSearch", vAC);
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
     // if (sVMD != null && !sVMD.equals("") && !vm.getVM_DESCRIPTION().equals(sVMD))
      if (sVMD != null && !sVMD.equals("") && !vm.getVM_PREFERRED_DEFINITION().equals(sVMD))
      {
        sVMD = sVMD.trim();//trim out the extra spaces
       // vm.setVM_DESCRIPTION(sVMD);
        vm.setVM_PREFERRED_DEFINITION(sVMD);
        //do not make it new if defintion is different
       // vm.setVM_IDSEQ("");
       // vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);
      }
      //now capture name attribute
     // if (sVM != null && !sVM.equals("") && !vm.getVM_SHORT_MEANING().equals(sVM))
      if (sVM != null && !sVM.equals("") && !vm.getVM_LONG_NAME().equals(sVM))
      {
        UtilService util = new UtilService();        
        sVM = sVM.trim();//trim out the extra spaces
        sVM = util.removeNewLineChar(sVM);
       //vm.setVM_SHORT_MEANING(sVM);
        vm.setVM_LONG_NAME(sVM);
        vm.setVM_IDSEQ("");
        //vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
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
      DataManager.setAttribute(session, "VMEditMsg", vErrMsg);
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
    try
    {
      vmData.setVMBean(vm);
      if (!vm.getVM_SUBMIT_ACTION().equals(VMForm.CADSR_ACTION_NONE))
        vmError = vmAction.doSubmitVM(vmData);

      httpRequest.setAttribute("retcode", vmData.getRetErrorCode());  
      //save the alt names  //TODO - Larry - sumbit the alt name edits
      if (vm != null && !vm.getVM_IDSEQ().equals(""))
      {
        vm.save(httpRequest.getSession(), vmData.getCurationServlet().getConn(), vm.getVM_IDSEQ(), vm.getVM_CONTE_IDSEQ());
      }      
    
    }
    catch (Exception e)
    {
      logger.error("ERROR - submitting vm ", e);
    }
    finally
    {
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
        curationServlet.storeStatusMsg(errMsg);
        //DataManager.setAttribute(session, Session_Data.SESSION_STATUS_MESSAGE, errMsg);
    }
    //store teh concept and vm attrirbutes in the request to place it on the vd page; append it regardless of the message
    EVS_Bean eBean =  (EVS_Bean)httpRequest.getAttribute(VMForm.REQUEST_SEL_CONCEPT);
    if (eBean != null && !eBean.getLONG_NAME().equals(""))
    {
        vmAction.doAppendConcept(selVM, eBean, iFrom);
        DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selVM);
    }
    return errMsg;
  }

  /**
   * puts the changed data into form object to display
   */
  public void writeDetailJsp(VM_Bean vm)
  {
    //VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
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
    //get the conceptual domains
    String sVM = vm.getVM_LONG_NAME(); // ac name for pv
 // call the api to return concept attributes according to ac type and ac idseq
    Vector cdList = new Vector();
    cdList = vmAction.doCDSearch("", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", sVM, cdList,vmData); // get
                                                                                                             // the
                                                                                                                // list
                                                                                                                // of
                                                                                                                // Conceptual
                                                                                                                // Domains
    httpRequest.setAttribute("ConDomainList", cdList);
    httpRequest.setAttribute("VMName", sVM);
    //add definition
    retForm.descriptionLabel = VMForm.ELM_LBL_DESC;
    if (vmCon.size() > 0)
    {
      retForm.descriptionLabel = VMForm.ELM_LBL_MAN_DESC;
      retForm.description = vm.getVM_ALT_DEFINITION();
      //retForm.systemDescription = vm.getVM_DESCRIPTION();
      retForm.systemDescription = vm.getVM_PREFERRED_DEFINITION();
      //add concepts
      retForm.conceptExist = true;
      retForm.conceptSummary = vm.getVM_ALT_NAME();  
      retForm.vmConcepts = vm.getVM_CONCEPT_LIST();  //vm.cloneVMConVector(vmCon);
      vmAction.resetPrimaryFlag(retForm.vmConcepts);
    }
    else
      //retForm.description = vm.getVM_DESCRIPTION();
    	retForm.description = vm.getVM_PREFERRED_DEFINITION();
    //add change note
    retForm.changeNote = vm.getVM_CHANGE_NOTE(); 
    retForm.setVMBean(vm);

    httpRequest.setAttribute(VMForm.REQUEST_FORM_DATA, retForm);
  }

  /**
   * puts the changed data into form object to display
   */
  public void writeUsedJsp(VM_Bean vm)
  {
    //VM_Bean vm = (VM_Bean)httpRequest.getSession().getAttribute(VMForm.SESSION_SELECT_VM);
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
    retForm.setVMBean(vm);
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
      if (!sAction.equals(VMForm.ACT_BACK_PV) && !sAction.equals(VMForm.ACT_SUBMIT_VM) && !sAction.equals(VMForm.ACT_BACK_SEARCH))
      {
        HttpSession session = httpRequest.getSession();
        VM_Bean vm = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
      //check if user entered alt def exists
        String sLongName = (String)httpRequest.getParameter(VMForm.ELM_LONG_NAME);
        //check if user entered alt def exists
        String sDef = (String)httpRequest.getParameter(VMForm.ELM_DEFINITION);
        if (sDef != null)
        {
          if (sDef.equals(""))  //this helps to keeps to create default alt defintion only when going from user defined vm to concept vm
              sDef = " ";
          if (vm.getVM_CONCEPT_LIST().size() > 0)
            vm.setVM_ALT_DEFINITION(sDef);
          else
            //vm.setVM_DESCRIPTION(sDef);
        	  vm.setVM_PREFERRED_DEFINITION(sDef);
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
        if(sLongName!=null)
        {
        	if (!sLongName.equals(""))  //this helps to keeps to create default alt defintion only when going from user defined vm to concept vm
        		vm.setVM_LONG_NAME(sLongName);
        }
        //Check if user entered new version
        String sVersion = (String)httpRequest.getParameter("Version");
        if (sVersion != null)
        { 
          if (sVersion.equals(""))
        	  sVersion = " ";
          if (!sVersion.equals(" "))  //remove the xtra space if any
        	  sVersion = sVersion.trim();
          if(!sVersion.equals((String)httpRequest.getSession().getAttribute("prevVMVersion")))
          { vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
          	vm.markNewAC();
        }
          vm.setVM_VERSION(sVersion);
        }
        //Check if user selected new workflow
        String sWorkflow = (String)httpRequest.getParameter("selStatus");
        if (sWorkflow != null)
        { 
          vm.setASL_NAME(sWorkflow);
        }
        //update the session attribute
        DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, vm);
      }
    }
    catch (Exception e)
    {
      logger.error("ERROR - ", e);
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
        DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, new VM_Bean());
        //remove the attribute
        session.removeAttribute(PVForm.SESSION_PV_INDEX);
        session.removeAttribute(VMForm.SESSION_SELECT_PV);
        
    }
    catch (RuntimeException e)
    {
        logger.error("ERROR - back to pv ", e);
    }
    return VMForm.JSP_PV_DETAIL;
  }
  
  /**
   * Returns back to Search Page
   * @return String
   */
private String goBackToSearch()
  {
	String sSearchAC = (String) httpRequest.getSession().getAttribute("searchAC");
	HttpSession session = httpRequest.getSession();
	if(sSearchAC.equals("ValueMeaning"))
	{ 
		Vector<VM_Bean> result =(Vector<VM_Bean>)session.getAttribute("vSelRows");
		Vector vSelAttr =(Vector<VM_Bean>)session.getAttribute("selectedAttr");
		vmData.setVMList(result);
		vmData.setSelAttrList(vSelAttr);
		this.readVMResult();
	}else
	{
		
		GetACSearch getAc =new GetACSearch(httpRequest,  httpResponse, curationServlet);
		Vector vResult =new Vector();
		getAc.getPVVMResult(httpRequest,  httpResponse,vResult,"true");
		DataManager.setAttribute(session, "results", vResult);
	}
      return VMForm.BACK_TO_SEARCH;
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
      DataManager.setAttribute(session, VMForm.SESSION_VM_TAB_FOCUS, to);
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
    {
        curationServlet.storeStatusMsg(errMsg);
      //DataManager.setAttribute(session, Session_Data.SESSION_STATUS_MESSAGE, errMsg);
    }
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
        //DataManager.setAttribute(session, Session_Data.SESSION_STATUS_MESSAGE, smsg);
        curationServlet.storeStatusMsg(smsg);
        DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selectVM);
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
        //DataManager.setAttribute(session, Session_Data.SESSION_STATUS_MESSAGE, smsg);
        curationServlet.storeStatusMsg(smsg);
        DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selectVM);
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
    String ret_page =(String)session.getAttribute(VMForm.SESSION_RET_PAGE);
    if(ret_page.equals(VMForm.JSP_PV_DETAIL))
    {
    	PV_Bean selPV = (PV_Bean)session.getAttribute(VMForm.SESSION_SELECT_PV);
       VM_Bean selVM = vmAction.getVM(selPV, -1);  //-1 to clear
       //set the attributes
       DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selVM);
       return changeTab("");  // VMForm.JSP_VM_DETAIL;
    }else
    {
    	VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM); 
    	DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selVM);
    	return changeTab("");
    }
  }

  /**
   * validates the vm and forwards it to validate page
   * @return String jsp name
   */
  private String validateEditVM()
  {
	  
	HttpSession session = httpRequest.getSession();
    VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    //set the attributes
    Vector<ValidateBean> vVal = vmAction.doValidateVM(selVM,vmData);
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
      logger.error("ERROR message at submitEditVM : " + errmsg);
    else
      selVM.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_NONE);  
    
    //reset the vd bean
    if(((String)httpRequest.getSession().getAttribute(VMForm.SESSION_RET_PAGE)).equals(VMForm.ACT_BACK_PV))
    {	
    PVServlet pvser = new PVServlet(httpRequest, httpResponse, curationServlet);
    pvser.putBackVMEdits(selVM);
    return goBackToPV();
    }
    else{
    	return goBackToSearch();
    }
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
      Vector<CommonACBean> vAC = dbac.getAssociated(vmData.getCurationServlet().getConn(), vm.getVM_IDSEQ(), isStatFilter, orderBy);
      //set data to vm
      dbac.setUsedAttributes(vm, vAC, isStatFilter, null);
   }
  
  /**
   * submits the vm changes to database 
   * forwards to pv page
   * @return String jsp to go back
   */
  private String sortUsedAC(VM_Bean selVM, String action)
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
    //VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    dbac.sortACs(selVM, fieldType);
    //store it in the vm
    if (action.equals("view"))
      DataManager.setAttribute(session, "viewVM", selVM);
    else	
      DataManager.setAttribute(session, VMForm.SESSION_SELECT_VM, selVM);
    //return the jsp
    DataManager.setAttribute(session, VMForm.SESSION_VM_TAB_FOCUS, VMForm.ELM_ACT_USED_TAB);
    httpRequest.setAttribute(VMForm.REQUEST_FOCUS_ELEMENT, acType);
    return sJsp;
  }
  
  /**
   * toggle action between released or show all items 
   * @return String jsp name
   */
  private String filterUsedAC(VM_Bean selVM)
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
    //VM_Bean selVM = (VM_Bean)session.getAttribute(VMForm.SESSION_SELECT_VM);
    
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
  private void readVMResult(GetACSearch getac)
  {
    HttpServletRequest req = httpRequest;
    HttpSession session = req.getSession();
    
    //call teh method for sorting
    vmAction.getVMResult(vmData,req,getac);
    //store the result back in request/session attributes
    DataManager.setAttribute(session, "results", vmData.getResultList());
    session.setAttribute("creRecsFound", vmData.getNumRecFound());
    session.setAttribute("labelKeyword", vmData.getResultLabel());  
    session.setAttribute("recsFound", vmData.getNumRecFound());
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
    vmAction.getVMResult(vmData,req);
    //store teh result back in request/session attributes
    DataManager.setAttribute(session, "results", vmData.getResultList());
    session.setAttribute("creRecsFound", vmData.getNumRecFound());
    session.setAttribute("labelKeyword", vmData.getResultLabel());  
    session.setAttribute("recsFound", vmData.getNumRecFound());
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
//    if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals(""))
    if (vm == null || vm.getVM_LONG_NAME() == null || vm.getVM_LONG_NAME().equals("")) 
      vm = new VM_Bean().copyVMBean(pv.getPV_VM());
    Vector vmCon = vm.getVM_CONCEPT_LIST();
    String[] sCons = req.getParameterValues("hiddenConVM");
    if (sCons != null && vmCon != null)
    {
      vmAction.resetVMConcepts(sCons, vm, pv);
    }
    return vm;
  }

/**
 * @return the vmData
 */
public VMForm getVmData() {
	return vmData;
}

/**
 * @param vmData the vmData to set
 */
public void setVmData(VMForm vmData) {
	this.vmData = vmData;
}
public void doOpenViewPage() throws Exception{
	VMForm vmForm = new VMForm();
	VM_Bean vmBean = new VM_Bean();
	VmVO vmVO = new VmVO();
    HttpServletRequest req = httpRequest;
   	HttpSession session = req.getSession();
	String acID = (String) req.getParameter("idseq");
	if (acID == null){
		acID = (String) req.getAttribute("acIdseq");
	}
	try{
	    Value_Meanings_Mgr vmMgr = new Value_Meanings_Mgr();
	    double version = 0;
		vmVO = vmMgr.getVm(acID, "",version, "", this.curationServlet.m_conn);
	}catch(DBException e){
		logger.error(e.getMessage());
	}
	if (vmVO.getBegin_date() != null){
	  vmBean.setVM_BEGIN_DATE(vmVO.getBegin_date().toString());
	}
	if (vmVO.getEnd_date() != null){
	  vmBean.setVM_END_DATE(vmVO.getEnd_date().toString());
	}  
	vmBean.setVM_PREFERRED_DEFINITION(vmVO.getPrefferred_def());
	vmBean.setVM_LONG_NAME(vmVO.getLong_name());
	vmBean.setVM_IDSEQ(vmVO.getVm_IDSEQ());
	Long id = new Long(vmVO.getVm_ID());
	vmBean.setVM_ID(id.toString());
	vmBean.setVM_CONTE_IDSEQ(vmVO.getConte_IDSEQ());
	vmBean.setVM_CHANGE_NOTE(vmVO.getChange_note());
	vmBean.setASL_NAME(vmVO.getAsl_name());
	Double version =  new Double(vmVO.getVersion());
	vmBean.setVM_VERSION(version.toString());
	String sCondr = vmVO.getCondr_IDSEQ();
	vmBean.setVM_CONDR_IDSEQ(vmVO.getCondr_IDSEQ());
	//get vm concepts
	if (sCondr != null && !sCondr.equals("")){
      ConceptForm cdata = new ConceptForm();
      cdata.setDBConnection(this.curationServlet.m_conn);
      ConceptAction cact = new ConceptAction();
      Vector<EVS_Bean> conList = cact.getAC_Concepts(sCondr, cdata);
      vmBean.setVM_CONCEPT_LIST(conList);
      DBAccess db =new DBAccess(this.curationServlet.m_conn);
      Alternates[] altList = db.getAlternates(new String[] {acID}, true, true);
      vmBean.setVM_ALT_LIST(altList);
    }
	DataManager.setAttribute(session, "viewVM", vmBean);
	//AltNamesDefsServlet altSer = new AltNamesDefsServlet(curationServlet,  curationServlet.sessionData.UsrBean);
    //Alternates alt = altSer.getManualDefinition(req, VMForm.ELM_FORM_SEARCH_EVS);
  //  if (alt != null && !alt.getName().equals(""))
   	//    vmBean.setVM_ALT_DEFINITION(alt.getName());
	DataManager.setAttribute(session, VMForm.SESSION_VM_TAB_FOCUS, VMForm.ELM_ACT_DETAIL_TAB);
	writeDetailJsp(vmBean);
    req.setAttribute("IncludeViewPage", "ValueMeaningDetail.jsp") ;
}
public void doViewVMActions(){
	String action = httpRequest.getParameter("action");
	HttpSession session = httpRequest.getSession();
	if (action != null){
	   if (action.equals("detailsTab")){
		  DataManager.setAttribute(session, VMForm.SESSION_VM_TAB_FOCUS, VMForm.ELM_ACT_DETAIL_TAB);
		  VM_Bean selVM = (VM_Bean)session.getAttribute("viewVM");
		  writeDetailJsp(selVM); 
		  httpRequest.setAttribute("IncludeViewPage", VMForm.JSP_VM_DETAIL) ;
       }else if (action.equals("whereUsedTab")){
    	  DataManager.setAttribute(session, VMForm.SESSION_VM_TAB_FOCUS, VMForm.ELM_ACT_USED_TAB);
    	  VM_Bean selVM = (VM_Bean)session.getAttribute("viewVM");
	      this.readAllUsedComponents(selVM, false, "");
		  writeUsedJsp(selVM); 
		  httpRequest.setAttribute("IncludeViewPage", VMForm.JSP_VM_USED) ;
      }else if (action.equals("sort")){
    	  VM_Bean selVM = (VM_Bean)session.getAttribute("viewVM");
    	  String page = sortUsedAC(selVM, "view");
    	  writeUsedJsp(selVM);
    	  httpRequest.setAttribute("IncludeViewPage", page) ;
      }else if (action.equals("show")){
    	  VM_Bean selVM = (VM_Bean)session.getAttribute("viewVM");
    	  String page = filterUsedAC(selVM);
    	  writeUsedJsp(selVM);
    	  httpRequest.setAttribute("IncludeViewPage", page) ;
      }
    }
}

}


