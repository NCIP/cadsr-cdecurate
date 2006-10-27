/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Hashtable;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import org.apache.log4j.Logger;
/**
 * @author shegde
 */
public class DatabaseConnection extends HttpServlet
{
  private static final Logger logger = Logger.getLogger(DatabaseConnection.class.getName());
  private static Hashtable<String, DataSource> hashOracleOCIConnectionPool = new Hashtable<String, DataSource>();

  /**
   * @param config 
   */
  public void initOracleConnect(ServletConfig serCon)
  {
    try
    {
      logger.info("initOracleConnect - accessing data source pool");
      String stAppContext = "/cdecurate";
      String stDataSource = serCon.getInitParameter("jbossDataSource");
      String stUser = serCon.getInitParameter("username");
      String stPswd = serCon.getInitParameter("password");
      // Create database pool
      Context envContext = null;
      DataSource ds = null;
      try
      {
        envContext = new InitialContext();
        ds = (DataSource) envContext.lookup("java:/" + stDataSource);
      }
      catch (Exception e)
      {
        String stErr = "Error creating database pool[" + e.getMessage() + "].";
        e.printStackTrace();
        System.out.println(stErr);
        logger.fatal(stErr, e);
        return;
      }
      // Test connnection
      Connection con = null;
      Statement stmt = null;
      ResultSet rset = null;
      try
      {
        con = ds.getConnection(stUser, stPswd);
        stmt = con.createStatement();
        rset = stmt.executeQuery("Select sysdate from dual");
        if (rset.next()) rset.getString(1);
        else throw (new Exception("DBPool connection test failed."));
        hashOracleOCIConnectionPool.put(stAppContext, ds);
      }
      catch (Exception e)
      {
        System.err.println("Could not open database connection.");
        e.printStackTrace();
        logger.fatal("Could not open database connection." + e.toString(), e);
      }
      finally
      {
        try
        {
          rset.close();
          stmt.close();
        }
        catch (Exception e)
        {
          logger.fatal("rset and stmtClose", e);
        };
        freeConnection(con);
      }
    }
    catch (Exception e)
    {
      logger.fatal("initOracleConnect - Some other error", e);
    }
  }
  /**
   * gets the connection object from pool
   * 
   * @param stDBAppContext
   * @param stUser
   * @param stPassword
   * @return connection object
   * @throws java.lang.Exception
   */
  public Connection getConnFromPool(String stDBAppContext, String stUser, String stPassword)
      throws Exception
  {
    DataSource ds = (DataSource) hashOracleOCIConnectionPool.get(stDBAppContext);
    if (ds != null)
    {
      try
      {
        Connection con = ds.getConnection(stUser, stPassword);
        return (con);
      }
      catch (SQLException e)
      {
        logger.fatal("Error getting connection" + e.toString(), e);
      }
    }
    return (null);
  }
  /**
   * free up the connection
   * 
   * @param con
   */
  public void freeConnection(Connection con)
  {
    try
    {
      con.close();
    }
    catch (Exception e)
    {
      System.err.println("Could not close database connection.");
      logger.fatal("Could not close database connection." + e.toString(), e);
    }
  }

  /**
   * sets user bean using login info and verifies the connection
   * @param req HttpServletRequest
   */
  public void setUserBean(HttpServletRequest req)
  {
    try
    {
      HttpSession session = req.getSession();
      String Username = req.getParameter("Username");
      String Password = req.getParameter("Password");
      UserBean Userbean = new UserBean();
      Userbean.setUsername(Username);
      Userbean.setPassword(Password);
      Userbean.setDBAppContext("/cdecurate");
      session.setAttribute("Userbean", Userbean);
      session.setAttribute("Username", Username);
      this.verifyConnection(req);
    }
    catch (RuntimeException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
      logger.fatal("setuserbean ", e);
    }
  }
  /**
   * The verifyConnection method queries the db to test the connection and
   * sets the ConnectedToDB variable.
   *  
   *  ConnectedToDB = "Nothing" (default)
   *  ConnectedToDB = "Yes" (connection availble)
   *  ConnectedToDB = "No" (no connection availble)
   *  
   * @param req The HttpServletRequest from the client
   *
   */
   public void verifyConnection(HttpServletRequest req)
   {
    Connection m_sbr_db_conn = null;
    try
     {
       
     //  logger.info(m_servlet.getLogMessage(req, "getACList", "started", startDate, startDate));

       HttpSession session = req.getSession();
       m_sbr_db_conn = this.connectDB(req);
        
       if (m_sbr_db_conn != null)
       {
        session.setAttribute("ConnectedToDB", "Yes");
        m_sbr_db_conn.close();
       }
       else
       {
         logger.fatal("verifyConnection: no db connection");
         session.setAttribute("ConnectedToDB", "No");    
       }
     }
     catch(Exception e)
     {
         try{if (m_sbr_db_conn != null) m_sbr_db_conn.close();}catch(Exception f){} 
         logger.fatal("ERROR in GetACService-verifyConnection : " + e.toString(), e);
     }
     try
     {
         if (m_sbr_db_conn != null) m_sbr_db_conn.close();
     }
     catch(Exception ee)
     {
         logger.fatal("ERROR in GetACService-verifyConnection close: " + ee.toString(), ee);
     }
  
   }  // end of verifyConnection

   /**
   * This method tries to connect to the db, returns the Connection object if successful, if
   * unsuccessful tries to reconnect, returns null if unsuccessful. Called from various classes
   * needing a connection. forwards page 'CDELoginPageError2.jsp'.
   * 
   * @param req
   *          The HttpServletRequest from the client
   * @return Connection SBRDb_conn 04/15/03 JZ Implement Realm Authen connction
   */
  public Connection connectDB(HttpServletRequest req)
  {
    Connection SBRDb_conn = null;
    HttpSession session = req.getSession();
    try
    {
      String username = "";
      String password = "";
      String sDBAppContext = "/cdecurate";
      UserBean Userbean = new UserBean();
      Userbean = (UserBean) session.getAttribute("Userbean");
      if (Userbean != null)
      {
        username = Userbean.getUsername();
        password = Userbean.getPassword();
        sDBAppContext = Userbean.getDBAppContext();
      }
      try
      {
        SBRDb_conn = this.getConnFromPool(sDBAppContext, username, password);
      }
      catch (Exception e)
      {
        logger.fatal("Servlet error: no pool connection.", e);
      }
    }
    catch (Exception e)
    {
      logger.fatal("Servlet connectDB : " + e.toString(), e);
    }
    return SBRDb_conn;
  }
}
