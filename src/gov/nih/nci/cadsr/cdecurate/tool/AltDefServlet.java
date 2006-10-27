package gov.nih.nci.cadsr.cdecurate.tool;
import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
/**
 * Servelt class for the object which interacts with the main servlet class
 * 
 * @author shegde
 */
public class AltDefServlet
{
  HttpServletRequest m_classReq = null;
  HttpServletResponse m_classRes = null;
  NCICurationServlet m_servlet;
  Connection m_conn = null;
  private static final Logger logger = Logger.getLogger(AltDefServlet.class.getName());
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
  public AltDefServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
  {
    m_classReq = req;
    m_classRes = res;
    m_servlet = ser;
  }
  /**
   * @param acID
   * @param AllAD
   */
  public void doCallSearchAltDef(String acID, Vector<AltDefBean> AllAD)
  {
    try
    {
      AltDefForm ADData = new AltDefForm();
      // store params in object data
      ADData.setAcIDSEQ(acID);
      String sType = (String) m_classReq.getParameter("dftl_name");
      if (sType == null) sType = "";
      ADData.setDeflName(sType);
      ADData.setAllADList(AllAD);
      if (acID != null || sType != null)
      {
        // call teh search action
        m_conn = m_servlet.makeDBConnection(m_classReq, m_classRes);
        if (m_conn != null)
        {
          // do the search action
          ADData.setDbConn(m_conn);
          AltDefAction adAction = new AltDefAction();
          ADData = adAction.doSearchAltDef(ADData);
          m_servlet.freeConnection(m_conn);
        }
      }
      // store it in the session vector
      AllAD = ADData.getAllADList();
      NCICurationServlet.sessionData.AllAltDef = AllAD;
    } 
    catch (Exception e)
    {
      logger.fatal("Error : call search for alt definition ", e);
    }
  }
  public void readDataFromPage()
  {
    try
    {
      String sAct = m_classReq.getParameter("AddButton");
      //get selected check box for remove or edit
      //** to do **/
      //store other information in the AD Bean
      String sType = m_classReq.getParameter("DefnType");  
      String sDef = m_classReq.getParameter("Definition");
      String sLang = m_classReq.getParameter("Language");
      String sContID = m_classReq.getParameter("ContextID");
      String sAC = m_classReq.getParameter("ACid");
      //String sT = m_classReq.getParameter("");
      //store ad attributes in the bean
      AltDefBean adBean = new AltDefBean();
      adBean.setALT_DEF_TYPE(sType);
      adBean.setALT_DEFINITION(sDef);
      adBean.setAC_LANGUAGE(sLang);
      adBean.setCONTE_IDSEQ(sContID);
      adBean.setAC_IDSEQ(sAC);
      //get cscsi data
      //*** todo **/
      //call the method
      callPageActions(sAct, adBean);
    }
    catch(Exception e)
    {
      
    }
  }
  private AltDefForm readCheckedAD(AltDefForm aData)
  {
    return aData;
  }
  private void callPageActions(String ADAct, AltDefBean adBean)
  {
    try
    {
      AltDefForm ADData = new AltDefForm();
      //get teh existing list of ADs from the session and store it data bean
      Vector<AltDefBean> AllAD = NCICurationServlet.sessionData.AllAltDef;
      if (AllAD == null) AllAD = new Vector<AltDefBean>();
      ADData.setAllADList(AllAD);
      //store the page action in the data
      if (ADAct == null) ADAct = "";
      if (ADAct.equals("refresh"))
      {
        ADData.setAdPageAction(AltDefForm.PAGE_ACTION_REFRESH);
      } 
      else if (ADAct.equals("create"))
      {
        ADData.setAdPageAction(AltDefForm.PAGE_ACTION_CREATE);
        ADData.setAdBean(adBean);
      }
      else if (ADAct.equals("edit"))
      {
        ADData.setAdPageAction(AltDefForm.PAGE_ACTION_EDIT);
      }
      else if (ADAct.equals("remove"))
      {
        ADData.setAdPageAction(AltDefForm.PAGE_ACTION_REMOVE);
      } 
      else if (ADAct.equals("submit"))
      {
        ADData.setAdPageAction(AltDefForm.PAGE_ACTION_SUBMIT);
      } 
      // store it in the session vector
      AllAD = ADData.getAllADList();
      NCICurationServlet.sessionData.AllAltDef = AllAD;
    }   
    catch (Exception e)
    {
      logger.fatal("Error : call search for alt definition ", e);
    }
  }

}
