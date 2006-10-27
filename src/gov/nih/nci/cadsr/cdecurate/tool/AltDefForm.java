package gov.nih.nci.cadsr.cdecurate.tool;
import java.sql.Connection;
import java.util.Vector;
/**
 * 
 */
/**
 * @author shegde
 */
public class AltDefForm
{
  //declare constants
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
  /** constant to mark the page action */
  public static final int PAGE_ACTION_REFRESH = 0;
  /** constant to mark the page action */
  public static final int PAGE_ACTION_CREATE = 1;
  /** constant to mark the page action */
  public static final int PAGE_ACTION_EDIT = 2;
  /** constant to mark the page action */
  public static final int PAGE_ACTION_REMOVE = 3;
  /** constant to mark the page action */
  public static final int PAGE_ACTION_SUBMIT = 4;

  //declare variables
  private Connection dbConn;
  private String acIDSEQ;
  private String deflName;
  private Vector<AltDefBean> AllADList;
  private Vector<AltDefBean> ADList;
  private AltDefBean adBean;
  private String statusMsg;
  private int actionStatus;
  private int adPageAction;
  private Vector<String> ADChecked;
  // add get and setters
  /**
   * @return Returns the dbConn.
   */
  public Connection getDbConn()
  {
    return dbConn;
  }
  /**
   * @param dbConn
   *          The dbConn to set.
   */
  public void setDbConn(Connection dbConn)
  {
    this.dbConn = dbConn;
  }
  /**
   * @return Returns the acIDSEQ.
   */
  public String getAcIDSEQ()
  {
    return acIDSEQ;
  }
  /**
   * @param acIDSEQ
   *          The acIDSEQ to set.
   */
  public void setAcIDSEQ(String acIDSEQ)
  {
    this.acIDSEQ = acIDSEQ;
  }
  /**
   * @return Returns the deflName.
   */
  public String getDeflName()
  {
    return deflName;
  }
  /**
   * @param deflName
   *          The deflName to set.
   */
  public void setDeflName(String deflName)
  {
    this.deflName = deflName;
  }
  /**
   * @return Returns the vAllAD.
   */
  public Vector<AltDefBean> getAllADList()
  {
    return AllADList;
  }
  /**
   * @param allAD
   *          The vAllAD to set.
   */
  public void setAllADList(Vector<AltDefBean> allAD)
  {
    AllADList = allAD;
  }
  /**
   * @return Returns the aDList.
   */
  public Vector<AltDefBean> getADList()
  {
    return ADList;
  }
  /**
   * @param list The aDList to set.
   */
  public void setADList(Vector<AltDefBean> list)
  {
    ADList = list;
  }
  /**
   * @return Returns the adBean.
   */
  public AltDefBean getAdBean()
  {
    return adBean;
  }
  /**
   * @param adBean The adBean to set.
   */
  public void setAdBean(AltDefBean adBean)
  {
    this.adBean = adBean;
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
    return statusMsg;
  }
  /**
   * @param statusMsg The statusMsg to set.
   */
  public void setStatusMsg(String statusMsg)
  {
    this.statusMsg = statusMsg;
  }
  /**
   * @return Returns the adPageAction.
   */
  public int getAdPageAction()
  {
    return adPageAction;
  }
  /**
   * @param adPageAction The adPageAction to set.
   */
  public void setAdPageAction(int adPageAction)
  {
    this.adPageAction = adPageAction;
  }
  /**
   * @return Returns the aDChecked.
   */
  public Vector<String> getADChecked()
  {
    return ADChecked;
  }
  /**
   * @param checked The aDChecked to set.
   */
  public void setADChecked(Vector<String> checked)
  {
    ADChecked = checked;
  }


}
