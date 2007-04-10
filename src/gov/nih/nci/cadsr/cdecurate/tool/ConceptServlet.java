/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 * @author shegde
 *
 */
@SuppressWarnings("unchecked")
public class ConceptServlet implements Serializable
{
  private static final long serialVersionUID = 8411474971665771500L;
  private ConceptForm data = null;
  private static final Logger logger = Logger.getLogger(ConceptServlet.class);

  /** constructor 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          NCICurationServlet pointer
   * @param sAction String to recorgnize whether it is main page search or searchForCreate
   */
  public ConceptServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser, String sAction)
  {
    data = new ConceptForm();
    data.setRequest(req);
    data.setResponse(res);
    data.setCurationServlet(ser);
    UtilService util = new UtilService();
    data.setUtil(util);
    data.setEvsUser((EVS_UserBean)ser.sessionData.EvsUsrBean);
    data.setACAction(sAction);
  }

  /**
   * start the search
   * @return Vector of EVS bean
   */
  public Vector<EVS_Bean> readDataForSearch()
  {    
    Vector<EVS_Bean> vAC = new Vector<EVS_Bean>();
    try
    {
      HttpServletRequest req = data.getRequest();
      HttpSession session = req.getSession();
      //get searchin data to filter
      String sSearchIn = (String)req.getParameter("listSearchIn");
      if (sSearchIn == null) sSearchIn = ConceptForm.SEARCH_IN_LONG_NAME;
      data.setSearchIn(sSearchIn);
      
      //get evs searchin for filter
      String sSearchInEVS = (String)req.getParameter("listSearchInEVS");
      if (sSearchInEVS == null) sSearchInEVS = "Synonym";

      //get the context to filter
      String sContext = (String)req.getParameter("listContextFilter");
      data.setContextName(sContext);
      
      //get work flow status filter
      String sStatusList[] = req.getParameterValues("listStatusFilter");
      data.setASLNameList(sStatusList);
      
      //get the keyword for filter
      String sKeyword = (String)req.getParameter("keyword");
      if (sKeyword == null) sKeyword = "";
      if (sSearchIn.equals("publicID"))
        data.setConID(sKeyword);
      else
        data.setSearchTerm(sKeyword);
      
      data.setMenuAction((String)session.getAttribute("MenuAction"));
      String sAction = data.getACAction();
      if (sAction.equals(""))
        sAction = data.getMenuAction();
      //store the attributes to display in the data
      if (sAction.equals(ConceptForm.SEARCH_AC_ACTION))
      {
        data.setSelAttributeList((Vector)session.getAttribute("creSelectedAttr"));
        data.setDispAttributeList((Vector)session.getAttribute("creAttributeList"));
      }
      else
      {
        data.setSelAttributeList((Vector)session.getAttribute("selectedAttr"));
        data.setDispAttributeList((Vector)session.getAttribute("serAttributeList"));
      }
      
      //call the action to do the search
      ConceptAction conAct = new ConceptAction();
      if (!sSearchIn.equals("Code") || !sSearchInEVS.equals("MetaCode"))
        conAct.doConceptSearch(data);
      
      //put the data back in the session
      session.setAttribute("creSearchInBlocks", sSearchIn);  //keep the search in criteria
      session.setAttribute("SearchInEVS", sSearchInEVS);
      session.setAttribute("creContextBlocks", sContext);
      session.setAttribute("creKeyword", sKeyword);   //keep the old criteria
      Vector vStat = data.getSelStatusList();
      if (sAction.equals(ConceptForm.SEARCH_AC_ACTION))
      {
         session.setAttribute("creStatus", vStat);
         req.setAttribute("creStatusBlocks", vStat);
      }
      else
         session.setAttribute("serStatus", vStat);
      //get the seelcted attributes
      Vector vSel = data.getSelAttributeList();
      if (sAction.equals("searchForCreate"))
        session.setAttribute("creSelectedAttr", vSel);
      else
        session.setAttribute("selectedAttr", vSel); 
      
      //put the results back in the session
      vAC = data.getConceptList();
      session.setAttribute("vACSearch", vAC);
    }
    catch (RuntimeException e)
    {
      logger.fatal("Error - concept servlet search concept ", e);
      data.setStatusMsg("Error : Unable to do concept search." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    return vAC;
  }
  
  /**
   * connects the db and returns the connection object
   * @return Connection object
   */
  public Connection makeDBConnection()
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
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    return sbr_db_conn;
  }
  /**
   * closes the db connection
   * @param con connection object
   */
  public void closeDBConnection(Connection con)
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
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
  }
}
