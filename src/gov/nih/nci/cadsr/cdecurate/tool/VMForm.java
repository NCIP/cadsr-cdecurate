// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VMForm.java,v 1.8 2007-05-23 15:44:26 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.Connection;
import java.util.Vector;

/**
 * @author shegde
 *
 */
public class VMForm implements Serializable
{
  private static final long serialVersionUID = 1L;

  //constants
  /** Constant for validation data **/
  public static final boolean ATTRIBUTE_MANDATORY = true;
  /** Constant for validation data **/
  public static final boolean ATTRIBUTE_NOT_MANDATORY = false;
  /** Constant for validation data **/
  public static final int ATTRIBUTE_LENGTH_LIMIT_NONE = -1;
  /** constant to mark the success for the action*/
  public static final int ACTION_STATUS_SUCCESS = 1;
  /** constant to mark the fail/error during the action*/
  public static final int ACTION_STATUS_FAIL = 0;
  /** database submit action insert INS keyword */
  public static final String CADSR_ACTION_INS = "INS";
  /** database submit action update UPD keyword */
  public static final String CADSR_ACTION_UPD = "UPD";
  /** database submit action delete DEL keyword */
  public static final String CADSR_ACTION_DEL = "DEL";
  /** database submit action update NONE keyword */
  public static final String CADSR_ACTION_NONE = "NONE";
  /** default definition value used in VM if concept definition is empty  */
  public static final String DEFINITION_DEFAULT_VALUE = "No Value Exists";
  //attributes
  private VM_Bean VMBean;
  private String VDidseq;
  private VM_Bean selectVM;
  private String EVSSearched;
  private String VMExist;
  private String statusMsg;
  private int actionStatus;
  private String retErrorCode;
  private String pvvmErrorCode;
  private Vector<String> VMValidate;
  private NCICurationServlet curationServlet;
  private String searchTerm;
  private String searchFilterCD;
  private String searchFilterDef;
  private String searchFilterCondr;
  private Vector<VM_Bean> VMList;
  private Vector<String> ResultList;
  private Connection dbConnection;
 // private EVS_UserBean evsUser;
  private String MenuAction;
  private Vector<String> SelAttrList;
  private String NumRecFound;
  private String ResultLabel;
  private String SortField;
  private int vmAction;
  private Vector<VM_Bean> existVMList;
  private Vector<VM_Bean> conceptVMList;
  private Vector<VM_Bean> defnVMList;
  private Vector<EVS_Bean> conceptList;
  private Vector<VM_Bean> errorMsgList;
  
  //get and set attributes
  /**
   * @return Returns the vMBean.
   */
  public VM_Bean getVMBean()
  {
    return (VMBean == null) ? new VM_Bean(): VMBean;
  }

  /**
   * @param bean The vMBean to set.
   */
  public void setVMBean(VM_Bean bean)
  {
    VMBean = bean;
  }

  /**
   * @return Returns the vDidseq.
   */
  public String getVDidseq()
  {
    return (VDidseq == null) ? "" : VDidseq;
  }

  /**
   * @param didseq The vDidseq to set.
   */
  public void setVDidseq(String didseq)
  {
    VDidseq = didseq;
  }


  /**
   * @return Returns the selectVM.
   */
  public VM_Bean getSelectVM()
  {
    return (selectVM == null) ? new VM_Bean() : selectVM;
  }

  /**
   * @param selectVM The selectVM to set.
   */
  public void setSelectVM(VM_Bean selectVM)
  {
    this.selectVM = selectVM;
  }

  /**
   * @return Returns the eVSSearched.
   */
  public String getEVSSearched()
  {
    return EVSSearched;
  }

  /**
   * @param searched The eVSSearched to set.
   */
  public void setEVSSearched(String searched)
  {
    EVSSearched = searched;
  }

  /**
   * @return Returns the vMExist.
   */
  public String getVMExist()
  {
    return VMExist;
  }

  /**
   * @param exist The vMExist to set.
   */
  public void setVMExist(String exist)
  {
    VMExist = exist;
  }

  /**
   * @return Returns the actionStatus.
   */
  public int getActionStatus()
  {
    return actionStatus;
  }

  /**
   * @param actionStatus The actionStatus to set.
   */
  public void setActionStatus(int actionStatus)
  {
    this.actionStatus = actionStatus;
  }

  /**
   * @return Returns the statusMsg.
   */
  public String getStatusMsg()
  {
    return (statusMsg == null) ? "" : statusMsg;
  }

  /**
   * @param statusMsg The statusMsg to set.
   */
  public void setStatusMsg(String statusMsg)
  {
    if (statusMsg == null) statusMsg = "";
    this.statusMsg = statusMsg;
  }

  /**
   * @return Returns the retErrorCode.
   */
  public String getRetErrorCode()
  {
    return retErrorCode;
  }

  /**
   * @param retErrorCode The retErrorCode to set.
   */
  public void setRetErrorCode(String retErrorCode)
  {
    this.retErrorCode = retErrorCode;
  }
  

  /**
   * @return Returns the pvvmErrorCode.
   */
  public String getPvvmErrorCode()
  {
    return pvvmErrorCode;
  }

  /**
   * @param pvvmErrorCode The pvvmErrorCode to set.
   */
  public void setPvvmErrorCode(String pvvmErrorCode)
  {
    this.pvvmErrorCode = pvvmErrorCode;
  }

  /**
   * @return Returns the vMValidate.
   */
  public Vector<String> getVMValidate()
  {
    return (VMValidate == null) ? new Vector<String>(): VMValidate;
  }

  /**
   * @param validate The vMValidate to set.
   */
  public void setVMValidate(Vector<String> validate)
  {
    VMValidate = validate;
  }

  /**
   * @return Returns the curationServlet.
   */
  public NCICurationServlet getCurationServlet()
  {
    return curationServlet;
  }

  /**
   * @param curationServlet The curationServlet to set.
   */
  public void setCurationServlet(NCICurationServlet curationServlet)
  {
    this.curationServlet = curationServlet;
  }

  /**
   * @return Returns the searchFilterCD.
   */
  public String getSearchFilterCD()
  {
    return (searchFilterCD == null) ? "" : searchFilterCD;
  }

  /**
   * @param searchFilterCD The searchFilterCD to set.
   */
  public void setSearchFilterCD(String searchFilterCD)
  {
    this.searchFilterCD = searchFilterCD;
  }

  /**
   * @return Returns the searchTerm.
   */
  public String getSearchTerm()
  {
    return (searchTerm == null) ? "" : searchTerm;
  }

  /**
   * @param searchTerm The searchTerm to set.
   */
  public void setSearchTerm(String searchTerm)
  {
    this.searchTerm = searchTerm;
  }

  
  /**
   * @return Returns the searchFilterCondr.
   */
  public String getSearchFilterCondr()
  {
    return (searchFilterCondr == null) ? "" : searchFilterCondr;
  }

  /**
   * @param sCondr The searchFilterCondr to set.
   */
  public void setSearchFilterCondr(String sCondr)
  {
    this.searchFilterCondr = sCondr;
  }

  /**
   * @return Returns the searchFilterDef.
   */
  public String getSearchFilterDef()
  {
    return (searchFilterDef == null) ? "" : searchFilterDef;
  }

  /**
   * @param searchFilterDef The searchFilterDef to set.
   */
  public void setSearchFilterDef(String searchFilterDef)
  {
    this.searchFilterDef = searchFilterDef;
  }

  /**
   * @return Returns the VMList.
   */
  public Vector<VM_Bean> getVMList()
  {
    return (VMList == null) ? new Vector<VM_Bean>(): VMList;
  }

  /**
   * @param VMList The VMList to set.
   */
  public void setVMList(Vector<VM_Bean> VMList)
  {
    this.VMList = VMList;
  }

  /**
   * @return Returns the ResultList.
   */
  public Vector<String> getResultList()
  {
    return (ResultList == null) ? new Vector<String>(): ResultList;
  }

  /**
   * @param result The ResultList to set.
   */
  public void setResultList(Vector<String> result)
  {
    ResultList = result;
  }
  

  /**
   * @return Returns the dbConnection.
   */
  public Connection getDBConnection()
  {
    return dbConnection;
  }

  /**
   * @param dbConnection The dbConnection to set.
   */
  public void setDBConnection(Connection dbConnection)
  {
    this.dbConnection = dbConnection;
  }

  /**
   * @return Returns the menuAction.
   */
  public String getMenuAction()
  {
    return MenuAction;
  }

  /**
   * @param menuAction The menuAction to set.
   */
  public void setMenuAction(String menuAction)
  {
    MenuAction = menuAction;
  }

  /**
   * @return Returns the numRecFound.
   */
  public String getNumRecFound()
  {
    return NumRecFound;
  }

  /**
   * @param numRecFound The numRecFound to set.
   */
  public void setNumRecFound(String numRecFound)
  {
    NumRecFound = numRecFound;
  }

  /**
   * @return Returns the resultLabel.
   */
  public String getResultLabel()
  {
    return ResultLabel;
  }

  /**
   * @param resultLabel The resultLabel to set.
   */
  public void setResultLabel(String resultLabel)
  {
    ResultLabel = resultLabel;
  }

  /**
   * @return Returns the selAttrList.
   */
  public Vector<String> getSelAttrList()
  {
    return SelAttrList;
  }

  /**
   * @param selAttrList The selAttrList to set.
   */
  public void setSelAttrList(Vector<String> selAttrList)
  {
    SelAttrList = selAttrList;
  }

  /**
   * @return Returns the sortField.
   */
  public String getSortField()
  {
    return SortField;
  }

  /**
   * @param sortField The sortField to set.
   */
  public void setSortField(String sortField)
  {
    SortField = sortField;
  }

  /**
   * @return Returns the vmAction.
   */
  public int getVmAction()
  {
    return vmAction;
  }

  /**
   * @param vmAction The vmAction to set.
   */
  public void setVmAction(int vmAction)
  {
    this.vmAction = vmAction;
  }


  /**
   * @return Returns the conceptVMList.
   */
  public Vector<VM_Bean> getConceptVMList() 
  {
    return (conceptVMList == null) ? new Vector<VM_Bean>() : conceptVMList;
  }
  

  /**
   * @param conceptVMList The conceptVMList to set.
   */
  public void setConceptVMList(Vector<VM_Bean> conceptVMList)
  {
    this.conceptVMList = conceptVMList;
  }


  /**
   * @return Returns the defnVMList.
   */
  public Vector<VM_Bean> getDefnVMList() 
  {
    return (defnVMList == null) ? new Vector<VM_Bean>() : defnVMList;
  }
  

  /**
   * @param defnVMList The defnVMList to set.
   */
  public void setDefnVMList(Vector<VM_Bean> defnVMList)
  {
    this.defnVMList = defnVMList;
  }


  /**
   * @return Returns the existVMList.
   */
  public Vector<VM_Bean> getExistVMList() 
  {
    return (existVMList == null) ? new Vector<VM_Bean>() : existVMList;
  }
  

  /**
   * @param existVMList The existVMList to set.
   */
  public void setExistVMList(Vector<VM_Bean> existVMList)
  {
    this.existVMList = existVMList;
  }


  /**
   * @return Returns the conceptList.
   */
  public Vector<EVS_Bean> getConceptList()
  {
    return (conceptList == null) ? new Vector<EVS_Bean>() : conceptList;
  }


  /**
   * @param conceptList The conceptList to set.
   */
  public void setConceptList(Vector<EVS_Bean> conceptList)
  {
    this.conceptList = conceptList;
  }

  /**
   * @return Returns the errorMsgList.
   */
  public Vector<VM_Bean> getErrorMsgList()
  {
    return (errorMsgList == null) ? new Vector<VM_Bean>() : errorMsgList;
  }

  /**
   * @param errorMsgList The errorMsgList to set.
   */
  public void setErrorMsgList(Vector<VM_Bean> errorMsgList)
  {
    this.errorMsgList = errorMsgList;
  }

//page values
  public String longName = "";
  public String longNameWidth = "";
  public String descriptionLabel = "";
  public String description = "";
  public String systemDescription = "";
  public String changeNote = "";
  public String conceptSummary = "";
  public String vmDisplayName = "";
  public boolean conceptExist = false;
  public Vector<EVS_Bean> vmConcepts = new Vector<EVS_Bean>();
  public Vector<CommonACBean> vmDEs = new Vector<CommonACBean>();
  public Vector<CommonACBean> vmVDs = new Vector<CommonACBean>();
  public Vector<CommonACBean> vmCRFs = new Vector<CommonACBean>();
  public String filteredDE = ELM_LBL_SHOW_RELEASE;
  public String filteredVD = ELM_LBL_SHOW_RELEASE;
  public String filteredCRF = ELM_LBL_SHOW_RELEASE;
  public String sortedDE = "";
  public String sortedVD = "";
  public String sortedCRF = "";
 
  
//constants for jsp parameters
  public static final String ELM_CHANGE_NOTE = "changeNote";
  public static final String ELM_DEFINITION = "txtDef";
  public static final String ELM_PAGE_ACTION = "pageAction";
  public static final String ELM_OPEN_TO_TREE = "openToTree";
  public static final String ELM_SEL_CON_ROW = "selectConceptRow";
  public static final String ELM_MENU_ACTION = "MenuAction";
  public static final String ELM_LABEL_CON = "labelCon";
  public static final String ELM_CRF_NAME = "Form(s)/Template(s)";
  public static final String ELM_VD_NAME = "Value Domain(s)";
  public static final String ELM_DE_NAME = "Data Element(s)";
  public static final String ELM_AC_TYPE = "acType";
  public static final String ELM_FIELD_TYPE = "fieldType";
  public static final String ELM_NVP_ORDER = "vmConOrder";

  public static final String ELM_LBL_NAME = "Long Name";
  public static final String ELM_LBL_MAN_DESC = "Manually Curated Definition/Description";
  public static final String ELM_LBL_SYS_DESC = "System Generated Definition/Description";
  public static final String ELM_LBL_DESC = "Definition/Description";
  public static final String ELM_LBL_CH_NOTE = "Change Note";
  public static final String ELM_LBL_CON_NAME = "Concept Name";
  public static final String ELM_LBL_CON_ID = "Concept ID";
  public static final String ELM_LBL_CON_SUM = "Concept Name Summary";
  public static final String ELM_LBL_SHOW_RELEASE = "Show Released Only";
  public static final String ELM_LBL_SHOW_ALL = "Show All Items";
  
  public static final String ELM_ACT_DETAIL_TAB = "detailtab";
  public static final String ELM_ACT_USED_TAB = "usedtab";

//constants for form req type
  public static final String ELM_FORM_REQ_DETAIL = "vmDetail";
  public static final String ELM_FORM_REQ_USED = "vmUse";  
  public static final String ELM_FORM_REQ_VAL = "vmValidate";  
  public static final String ELM_FORM_SEARCH_EVS = "ValueMeaningEdit";  
  
//constants for jsp actions
  public static final String ACT_PAGE_DEFAULT = "nothing";
  public static final String ACT_CON_APPEND = "appendConcept";
  public static final String ACT_CON_DELETE = "deleteConcept";
  public static final String ACT_CON_MOVEUP = "moveUpConcept";
  public static final String ACT_CON_MOVEDOWN = "moveDownConcept";
  public static final String ACT_BACK_PV = "backToPV";
  public static final String ACT_CLEAR_VM = "clearBoxes";
  public static final String ACT_VALIDATE_VM = "validate";
  public static final String ACT_REEDIT_VM = "reEditVM";
  public static final String ACT_SUBMIT_VM = "submitVM";
  public static final String ACT_SORT_AC = "sortAC";  
  public static final String ACT_FILTER_AC = "filterAC";  
  
//constants for session attributes
  public static final String SESSION_SELECT_VM = "selectVM";
  public static final String SESSION_SELECT_PV = "selectPV";
  public static final String SESSION_VM_TAB_FOCUS = "VMTabFocus";  
  public static final String SESSION_PV_INDEX = "selectPVIndex";  
  public static final String SESSION_SELECT_VD = "m_VD";  
  
//constants for request attributes
  public static final String REQUEST_FOCUS_ELEMENT = "VMFocusElement";  
  public static final String REQUEST_FORM_DATA = "VMDisplayData";  
  public static final String REQUEST_SEL_CONCEPT = "selConcept";  
  
//constants for jsp names
  public static final String JSP_VM_DETAIL = "ValueMeaningDetail.jsp";     
  public static final String JSP_PV_DETAIL = "PermissibleValue.jsp";     
  public static final String JSP_TITLE_BAR = "TitleBar.jsp";     
  public static final String JSP_VM_TITLE = "ValueMeaningTitle.jsp";     
  public static final String JSP_VM_USED = "ValueMeaningUsed.jsp";     
  public static final String JSP_VM_VALIDATE = "ValidateVMPage.jsp";     
  
}
