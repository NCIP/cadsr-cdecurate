// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/ConceptForm.java,v 1.3 2007-05-23 15:44:26 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author shegde
 *
 */
public class ConceptForm implements Serializable
{
  private static final long serialVersionUID = -1477453409342751599L;
  //constants
  /** constant to store string value for all workflow status*/
  public static String ALL_STATUS = "AllStatus";
  /** constant to store string value for all context*/
  public static String ALL_CONTEXT = "AllContext";
  /** constant to store string value for ac search action*/
  public static String SEARCH_AC_ACTION = "searchForCreate";
  /** constant to store string value for default search in*/
  public static String SEARCH_IN_LONG_NAME = "longName";
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
  /** constant value to get the VM name and defintion of the concepts from pv page  */
  public static final int FOR_PV_PAGE_CONCEPT = 1;
  /** constant value to get the VM name and defintion of the concepts from vm page */
  public static final int FOR_VM_PAGE_CONCEPT = 2;
  /** constant value to get the VM name of the concepts at open vm page */
  public static final int FOR_VM_PAGE_OPEN = 3;
  /** constant value of Primary type */
  public static final String CONCEPT_PRIMARY = "Primary";
  /** constant value of Qualifier type */
  public static final String CONCEPT_QUALIFIER = "Qualifier";
  
  //concept data
  private String statusMsg;
  private int actionStatus;
  private String searchTerm;
  private String searchDefn;
  private String searchIn;
  private String conIDSEQ;
  private String ContextName;
  private String ASLName;
  private String[] ASLNameList;
  private String conID;
  private String decIDseq;
  private String vdIDseq;
  private Vector<EVS_Bean> conceptList; 
  private Connection DBConnection;
  private EVS_UserBean evsUser;
  private String MenuAction;
  private String ACAction;
  private UtilService util;
  private NCICurationServlet curationServlet;
  private HttpServletRequest request;
  private HttpServletResponse response;
  private Vector<String> selStatusList;
  private Vector<String> dispAttributeList;
  private Vector<String> selAttributeList;
  
  /** constructor */
  public ConceptForm()
  {
  }

  /**
   * @return Returns the aSLName.
   */
  public String getASLName()
  {
    return (ASLName == null) ? "" : ASLName;
  }

  /**
   * @param name The aSLName to set.
   */
  public void setASLName(String name)
  {
    ASLName = name;
  }
  
  /**
   * @return Returns the aSLNameList.
   */
  public String[] getASLNameList()
  {
    return ASLNameList;
  }

  /**
   * @param nameList The aSLNameList to set.
   */
  public void setASLNameList(String[] nameList)
  {
    ASLNameList = nameList;
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
   * @return Returns the conID.
   */
  public String getConID()
  {
    return (conID == null) ? "" : conID;
  }

  /**
   * @param conID The conID to set.
   */
  public void setConID(String conID)
  {
    this.conID = conID;
  }

  /**
   * @return Returns the conIDSEQ.
   */
  public String getConIDSEQ()
  {
    return (conIDSEQ == null) ? "" : conIDSEQ;
  }

  /**
   * @param conIDSEQ The conIDSEQ to set.
   */
  public void setConIDSEQ(String conIDSEQ)
  {
    this.conIDSEQ = conIDSEQ;
  }

  /**
   * @return Returns the contextName.
   */
  public String getContextName()
  {
    return (ContextName == null) ? "" : ContextName;
  }

  /**
   * @param contextName The contextName to set.
   */
  public void setContextName(String contextName)
  {
    ContextName = contextName;
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
   * @return Returns the DBConnection.
   */
  public Connection getDBConnection()
  {
    return DBConnection;
  }

  /**
   * @param DBConnection The DBConnection to set.
   */
  public void setDBConnection(Connection DBConnection)
  {
    this.DBConnection = DBConnection;
  }

  /**
   * @return Returns the decIDseq.
   */
  public String getDecIDseq()
  {
    return (decIDseq == null) ? "" : decIDseq;
  }

  /**
   * @param decIDseq The decIDseq to set.
   */
  public void setDecIDseq(String decIDseq)
  {
    this.decIDseq = decIDseq;
  }

  /**
   * @return Returns the evsUser.
   */
  public EVS_UserBean getEvsUser()
  {
    return (evsUser == null) ? new EVS_UserBean() : evsUser;
  }

  /**
   * @param evsUser The evsUser to set.
   */
  public void setEvsUser(EVS_UserBean evsUser)
  {
    this.evsUser = evsUser;
  }

  /**
   * @return Returns the menuAction.
   */
  public String getMenuAction()
  {
    return (MenuAction == null) ? "" : MenuAction;
  }

  /**
   * @param menuAction The menuAction to set.
   */
  public void setMenuAction(String menuAction)
  {
    MenuAction = menuAction;
  }
  
  /**
   * @return Returns the aCAction.
   */
  public String getACAction()
  {
    return (ACAction == null) ? "" : ACAction;
  }

  /**
   * @param action The aCAction to set.
   */
  public void setACAction(String action)
  {
    ACAction = action;
  }

  /**
   * @return Returns the request.
   */
  public HttpServletRequest getRequest()
  {
    return request;
  }

  /**
   * @param request The request to set.
   */
  public void setRequest(HttpServletRequest request)
  {
    this.request = request;
  }

  /**
   * @return Returns the response.
   */
  public HttpServletResponse getResponse()
  {
    return response;
  }

  /**
   * @param response The response to set.
   */
  public void setResponse(HttpServletResponse response)
  {
    this.response = response;
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
    this.statusMsg = statusMsg;
  }

  /**
   * @return Returns the util.
   */
  public UtilService getUtil()
  {
    return (util == null) ? new UtilService() : util;
  }

  /**
   * @param util The util to set.
   */
  public void setUtil(UtilService util)
  {
    this.util = util;
  }

  /**
   * @return Returns the vdIDseq.
   */
  public String getVdIDseq()
  {
    return (vdIDseq == null) ? "" : vdIDseq;
  }

  /**
   * @param vdIDseq The vdIDseq to set.
   */
  public void setVdIDseq(String vdIDseq)
  {
    this.vdIDseq = vdIDseq;
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
   * @return Returns the dispAttributeList.
   */
  public Vector<String> getDispAttributeList()
  {
    return (dispAttributeList == null) ? new Vector<String>() : dispAttributeList;
  }

  /**
   * @param dispAttributeList The dispAttributeList to set.
   */
  public void setDispAttributeList(Vector<String> dispAttributeList)
  {
    this.dispAttributeList = dispAttributeList;
  }

  /**
   * @return Returns the selAttributeList.
   */
  public Vector<String> getSelAttributeList()
  {
    return (selAttributeList == null) ? new Vector<String>() : selAttributeList;
  }

  /**
   * @param selAttributeList The selAttributeList to set.
   */
  public void setSelAttributeList(Vector<String> selAttributeList)
  {
    this.selAttributeList = selAttributeList;
  }

  /**
   * @return Returns the selStatusList.
   */
  public Vector<String> getSelStatusList()
  {
    return (selStatusList == null) ? new Vector<String>() : selStatusList;
  }

  /**
   * @param selStatusList The selStatusList to set.
   */
  public void setSelStatusList(Vector<String> selStatusList)
  {
    this.selStatusList = selStatusList;
  }

  /**
   * @return Returns the searchIn.
   */
  public String getSearchIn()
  {
    return (searchIn == null) ? "" : searchIn;
  }

  /**
   * @param searchIn The searchIn to set.
   */
  public void setSearchIn(String searchIn)
  {
    this.searchIn = searchIn;
  }

  /**
   * @return Returns the searchDefn.
   */
  public String getSearchDefn() 
  {
    return (searchDefn == null) ? "" : searchDefn;
  }
  

  /**
   * @param searchDefn The searchDefn to set.
   */
  public void setSearchDefn(String searchDefn)
  {
    this.searchDefn = searchDefn;
  }


}
