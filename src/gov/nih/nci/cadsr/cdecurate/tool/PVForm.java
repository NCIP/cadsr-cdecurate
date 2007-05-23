// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/PVForm.java,v 1.4 2007-05-23 15:44:26 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author shegde
 *
 */
public class PVForm
{
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

  //session attributes
  public static final String SESSION_PV_INDEX = "selectPVIndex";  
  public static final String SESSION_SELECT_VD = "m_VD";  
  //request attribute
  public static final String REQUEST_FOCUS_ELEMENT = "focusElement";  
  
  //attributes
  private String statusMsg;
  private int actionStatus;
  private NCICurationServlet curationServlet;
  private HttpServletRequest request;
  private HttpServletResponse response;
  private Connection dbConnection;
  private String MenuAction;
  private String PageAction;
  private String VDAction;
  private String OriginAction;
  private String LastButtonPressed;
  //private Vector<PV_Bean> VDPVList;
  private Vector<PV_Bean> RemovedPVList;
  private VD_Bean VD;
  private UtilService util;
  private PV_Bean newPV;
  private PV_Bean selectPV;
  private VM_Bean newVM;
  private String pvvmErrorCode;
  private String retErrorCode;
  
  /**
   * 
   */
  public PVForm()
  {
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
   * @return Returns the dbConnection.
   */
  public Connection getDbConnection()
  {
    return dbConnection;
  }

  /**
   * @param dbConnection The dbConnection to set.
   */
  public void setDbConnection(Connection dbConnection)
  {
    this.dbConnection = dbConnection;
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
    if(statusMsg == null) statusMsg = "";
    this.statusMsg = statusMsg;
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
   * @return Returns the originAction.
   */
  public String getOriginAction()
  {
    return (OriginAction == null) ? "" : OriginAction;
  }

  /**
   * @param originAction The originAction to set.
   */
  public void setOriginAction(String originAction)
  {
    OriginAction = originAction;
  }

  /**
   * @return Returns the pageAction.
   */
  public String getPageAction()
  {
    return (PageAction == null) ? "" : PageAction;
  }

  /**
   * @param pageAction The pageAction to set.
   */
  public void setPageAction(String pageAction)
  {
    PageAction = pageAction;
  }

  /**
   * @return Returns the vDAction.
   */
  public String getVDAction()
  {
    return (VDAction == null) ? "" : VDAction;
  }

  /**
   * @param action The vDAction to set.
   */
  public void setVDAction(String action)
  {
    VDAction = action;
  }
  
  /**
   * @return Returns the lastButtonPressed.
   */
  public String getLastButtonPressed()
  {
    return (LastButtonPressed == null) ? "" : LastButtonPressed;
  }

  /**
   * @param lastButtonPressed The lastButtonPressed to set.
   */
  public void setLastButtonPressed(String lastButtonPressed)
  {
    LastButtonPressed = lastButtonPressed;
  }

/*  *//**
   * @return Returns the vDPVList.
   *//*
  public Vector<PV_Bean> getVDPVList()
  {
    return (VDPVList == null) ? new Vector<PV_Bean>() : VDPVList;
  }

  *//**
   * @param list The vDPVList to set.
   *//*
  public void setVDPVList(Vector<PV_Bean> list)
  {
    VDPVList = list;
  }
*/  
  /**
   * @return Returns the removedPVList.
   */
  public Vector<PV_Bean> getRemovedPVList()
  {
    return (RemovedPVList == null) ? new Vector<PV_Bean>() : RemovedPVList;
  }

  /**
   * @param removedPVList The removedPVList to set.
   */
  public void setRemovedPVList(Vector<PV_Bean> removedPVList)
  {
    RemovedPVList = removedPVList;
  }

  /**
   * @return Returns the vD.
   */
  public VD_Bean getVD()
  {
    return (VD == null) ? new VD_Bean() : VD;
  }

  /**
   * @param vd The vD to set.
   */
  public void setVD(VD_Bean vd)
  {
    VD = vd;
  }

  /**
   * @return Returns the util.
   */
  public UtilService getUtil()
  {
    return util;
  }

  /**
   * @param util The util to set.
   */
  public void setUtil(UtilService util)
  {
    this.util = util;
  }


  /**
   * @return Returns the newPV.
   */
  public PV_Bean getNewPV()
  {
    return newPV;
  }

  /**
   * @param newPV The newPV to set.
   */
  public void setNewPV(PV_Bean newPV)
  {
    this.newPV = newPV;
  }

  /**
   * @return Returns the selectPV.
   */
  public PV_Bean getSelectPV()
  {
    return selectPV;
  }

  /**
   * @param selectPV The selectPV to set.
   */
  public void setSelectPV(PV_Bean selectPV)
  {
    this.selectPV = selectPV;
  }

  /**
   * @return Returns the newVM.
   */
  public VM_Bean getNewVM()
  {
    return newVM;
  }

  /**
   * @param newVM The newVM to set.
   */
  public void setNewVM(VM_Bean newVM)
  {
    this.newVM = newVM;
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
  
  
}
