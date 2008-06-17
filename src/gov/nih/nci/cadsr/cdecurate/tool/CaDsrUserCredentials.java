// Copyright (c) 2008 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/CaDsrUserCredentials.java,v 1.1 2008-06-17 14:49:38 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

/**
 * This class performs common login credential security checks and processing for the caDSR Tool suite deployed under JBoss. The default &lt;jndi-name&gt;
 * is "jdbc/caDSR". It can be found in the cadsr-oracle-ds.xml file in the JBoss deploy directory. If a different jndi-name is needed use the static method
 * setJndiName() on this class prior to any other methods.
 * 
 * In the following examples applicationUserid and applicationPswd are the credentials created for and used by the caDSR Tool, e.g. the Sentinel Tool
 * application credentials. These credentials are reserved for use by the Tool and never used by a person via the Tool Login page. By contrast the loginUserid
 * and loginPswd are the credentials entered by the user on the Tool Login page.
 * 
 * There are two (2) ways to use this class. The first and easiest is to copy the following code:
 * 
 * CaDsrUserCredentials uc = new CaDsrUserCredentials();
 * try
 * {
 *      uc.validateCredentials(applicationUserid, applicationPswd, loginUserid, loginPswd);
 *  }
 *  catch (Exception ex)
 *  {
 *      _logger.error("Failed credential validation, code is " + uc.getCheckCode());
 *  }
 *  
 *  <hr/>
 *  
 *  The second use is applicable when more intervening logic is required:
 *  
 *  String msg = null;
 *  
 * CaDsrUserCredentials uc = new CaDsrUserCredentials();
 * try
 * {
 *      uc.intialize(applicationUserid, applicationPswd);
 *  }
 *  catch (Exception ex)
 *  {
 *      _logger.error("Failed initialization, code is " + uc.getCheckCode());
 *  }
 *  if (uc.isLocked(user))
 *  {
 *      msg = "User is locked";
 *  }
 *  else if (!uc.isValidCredentials(loginUserid, loginPswd))
 *  {
 *      uc.incLock(loginUserid);
 *      msg = "User is invalid";
 *  }
 *  else
 *  {
 *      uc.clearLock(loginUserid);
 *      msg = "User is good";
 *  }
 *  
 *
 * @author lhebel
 */
public class CaDsrUserCredentials
{
    /** **/
    public static final int CC_OK = 0;
    
    /** **/
    public static final int CC_LOCKED = 1;
    
    /** **/
    public static final int CC_INVALID = 2;
    
    /** **/
    public static final int CC_CONFIGURATION = 3;
    
    /** **/
    public static final int CC_DATABASE = 4;
    
    /** **/
    public static final int CC_OTHER = 5;
    
    private Connection _conn;
    private PreparedStatement _pstmt;
    private ResultSet _rs;
    private String _applUser;
    private String _applPswd;
    private int _checkCode;

    private Logger _logger = Logger.getLogger(CaDsrUserCredentials.class);
    
    private static String _jndiName = "java:/jdbc/caDSR";
    
    private static final String CHECKOPTIONS = "select COUNT(*) from sbrext.tool_options_view_ext "
        + "where tool_name = 'caDSR' and property in ('LOCKOUT.TIMER', 'LOCKOUT.THRESHOLD')";
    
    private static final String RESETLOCK = "update sbrext.users_lockout_view " 
        + "set LOCKOUT_COUNT = 0, VALIDATION_TIME = SYSDATE " 
        + "where ua_name = ? " 
        + "and LOCKOUT_COUNT > 0 " 
        + "and VALIDATION_TIME < (SYSDATE - ( " 
        + "select to_number(value)/1440 " 
        + "from sbrext.tool_options_view_ext " 
        + "where tool_name = 'caDSR' " 
        + "and property = 'LOCKOUT.TIMER'))";
    
    private static final String CHECKLOCK = "select 'User is currently Locked' "
        + "from sbrext.users_lockout_view " 
        + "where ua_name = ? " 
        + "and LOCKOUT_COUNT >= ( " 
        + "select to_number(value) " 
        + "from sbrext.tool_options_view_ext " 
        + "where tool_name = 'caDSR' " 
        + "and property = 'LOCKOUT.THRESHOLD') "
        + "union all "
        + "select 'User does not exist in sbr.user_accounts' "
        + "from dual "
        + "where ? not in (select ua_name from sbr.user_accounts_view) "
        + "union all "
        + "select 'User disabled in sbr.user_accounts' "
        + "from sbr.user_accounts_view "
        + "where ua_name = ? and enabled_ind <> 'Yes' ";
    
    private static final String INCLOCK = "update sbrext.users_lockout_view " 
        + "set LOCKOUT_COUNT = LOCKOUT_COUNT + 1, VALIDATION_TIME = SYSDATE " 
        + "where ua_name = ?";
    
    private static final String CLEARLOCK = "update sbrext.users_lockout_view " 
        + "set LOCKOUT_COUNT = 0, VALIDATION_TIME = SYSDATE " 
        + "where ua_name = ?";
    
    private static final String INSLOCK = "insert into sbrext.users_lockout_view " 
        + "(ua_name, LOCKOUT_COUNT, VALIDATION_TIME) "
        + "values "
        + "(?, 1, SYSDATE)"; 
    
    /**
     * Constructor
     *
     */
    public CaDsrUserCredentials()
    {
        super();
    }
    
    /**
     * Validate the credentials
     * 
     * @param applUser_ the application database account 
     * @param applPswd_ the application account password
     * @param localUser_ the user credentials to validate
     * @param localPswd_ the user credentials to validate
     * @throws Exception throws when the application account credentials are in error
     * 
     */
    public void validateCredentials(String applUser_, String applPswd_, String localUser_, String localPswd_) throws Exception
    {
        initialize(applUser_, applPswd_);

        String msg;
        if (isLocked(localUser_))
        {
            msg = "User is locked " + localUser_;
            _logger.info(msg);
            throw new Exception(msg);
        }
        else if (!isValidCredentials(localUser_, localPswd_))
        {
            incLock(localUser_);

            msg = "User is invalid " + localUser_;
            _logger.info(msg);
            throw new Exception(msg);
        }
        else
        {
            clearLock(localUser_);
        }
    }
    
    /**
     * Initialize the class
     * 
     * @param applUser_ the application database account 
     * @param applPswd_ the application account password
     * @throws Exception throws when the application account credentials are in error
     * 
     */
    public void initialize(String applUser_, String applPswd_) throws Exception
    {
        _applUser = applUser_;
        _applPswd = applPswd_;
        _checkCode = CC_OK;
        try 
        {
            Context envContext = new InitialContext();
            DataSource ds = (DataSource)envContext.lookup(_jndiName);
            _conn = ds.getConnection(_applUser, _applPswd);
            _pstmt = _conn.prepareStatement(CHECKOPTIONS);
            _rs = _pstmt.executeQuery();
            String msg = null;
            if (_rs.next())
            {
                int count = _rs.getInt(1);
                _checkCode = CC_CONFIGURATION;
                switch (count)
                {
                    case 0:
                        msg = "Missing 'LOCKOUT.TIMER' and 'LOCKOUT.THRESHOLD' configuration values.";
                        break;
                    case 1:
                        msg = "Missing 'LOCKOUT.TIMER' or 'LOCKOUT.THRESHOLD' configuration values.";
                        break;
                    case 2:
                        msg = null;
                        _checkCode = CC_OK;
                        break;
                    default:
                        msg = "Too many 'LOCKOUT.TIMER' and 'LOCKOUT.THRESHOLD' configuration values.";
                        break;
                }
            }
            else
            {
                msg = "Problem with database connection using " + _jndiName;
                _checkCode = CC_DATABASE;
            }

            if (msg != null)
            {
                _logger.error(msg);
                throw new Exception(msg);
            }
        }
        catch (Exception ex)
        {
            _checkCode = CC_OTHER;
            throw ex;
        }
        finally
        {
            closeConn();
        }
    }

    /**
     * Clean the connection
     *
     */
    private void closeConn()
    {
        if (_rs != null)
        {
            try { _rs.close(); } catch (Exception ex) { }
            _rs = null;
        }
        if (_pstmt != null)
        {
            try { _pstmt.close(); } catch (Exception ex) { }
            _pstmt = null;
        }
        if (_conn != null)
        {
            try { _conn.close(); } catch (Exception ex) { }
            _conn = null;
        }
    }
    
    abstract class DBAction
    {
        /**
         * Execute the database work to be performed
         * 
         * @throws SQLException 
         */
        abstract public void execute() throws SQLException;
        
        /**
         * Get the user name to establish the database connection
         * @return the user name
         */
        public String getConnectionUser()
        {
            return _applUser;
        }
        
        /**
         * Get the user password to establish the database connection
         * @return the password
         */
        public String getConnectionPswd()
        {
            return _applPswd;
        }

        /**
         * Called when an exception is thrown
         */
        public void failure()
        {
        }
    }
    
    /**
     * Common work module that encapsulates all connection creation and management.
     * 
     * @param obj_ the working object
     */
    private void doSQL(DBAction obj_)
    {
        try
        {
            // Establish connection
            Context envContext = new InitialContext();
            DataSource ds = (DataSource)envContext.lookup(_jndiName);
            _conn = ds.getConnection(obj_.getConnectionUser(), obj_.getConnectionPswd());
            
            // Execute the SQL provided by the Work object.
            obj_.execute();
        }
        catch (SQLException ex)
        {
            exceptionMessage(obj_, ex, null);
        }
        catch (NamingException ex)
        {
            exceptionMessage(obj_, ex, "Can not establish a connection using " + _jndiName + " ");
        }
        catch (Exception ex)
        {
            exceptionMessage(obj_, ex, null);
        }
        finally
        {
            closeConn();
        }
    }

    /**
     * Convenience logging method
     * 
     * @param obj_ the DBAction object
     * @param ex_ the Exception
     * @param msg_ any extra text to insert in the log message
     */
    private void exceptionMessage(DBAction obj_, Exception ex_, String msg_)
    {
        if (msg_ == null)
            _logger.error(obj_.getClass().getName() + ": " + exceptionMessage(ex_));
        else
            _logger.error(obj_.getClass().getName() + ": " + msg_ + exceptionMessage(ex_));
        obj_.failure();
    }

    /**
     * Find the line number in this class for ease of debugging. Don't need the stack trace.
     * 
     * @param ex_ the exception
     * @return the exception message and the point in the hierarchy corresponding to this class.
     */
    private String exceptionMessage(Exception ex_)
    {
        StackTraceElement[] ste = ex_.getStackTrace();
        for (StackTraceElement element : ste)
        {
            if (element.getClassName().startsWith(this.getClass().getName()))
            {
                return ex_.toString() + "\n" + element.toString();
            }
        }
        return "(could not locate class in stack trace)";
    }

    /**
     * Reset and check the account lock
     * 
     * @author lhebel
     */
    class DBActionLockCheck extends DBAction
    {
        private String _localUser;
        private boolean _locked;
        
        DBActionLockCheck(String user_)
        {
            _localUser = user_;
            _locked = true;
        }

        /**
         * Handle checking the lock.
         * 
         * @throws SQLException
         */
        public void execute() throws SQLException
        {
            // Reset the lock count if the timer has expired.
            _pstmt = _conn.prepareStatement(RESETLOCK);
            _pstmt.setString(1, _localUser);
            _pstmt.execute();
            _pstmt.close();
            
            // Check the lock.
            _pstmt = _conn.prepareStatement(CHECKLOCK);
            _pstmt.setString(1, _localUser);
            _pstmt.setString(2, _localUser);
            _pstmt.setString(3, _localUser);
            _rs = _pstmt.executeQuery();
            _locked = _rs.next();
            if (_locked)
                _logger.warn(_rs.getString(1) + " " + _localUser);
        }
        
        /**
         * Get the locked value
         * 
         * @return true if locked.
         */
        public boolean getLock()
        {
            return _locked;
        }
    }

    /**
     * Is the user account locked?
     * 
     * @param user_ the user name
     * 
     * @return true when "locked", false when "open"
     */
    public boolean isLocked(String user_)
    {
        DBActionLockCheck lw = new DBActionLockCheck(user_);
        doSQL(lw);

        boolean flag = lw.getLock();
        
        if (flag)
            _checkCode = CC_LOCKED;
        
        return flag;
    }

    /**
     * Common credential validation for all tools. Verifies a connection can be created with the
     * credentials provided.
     * 
     * @author lhebel
     *
     */
    class DBActionValidateCreds extends DBAction
    {
        private String _localUser;
        private String _localPswd;
        private boolean _valid;

        DBActionValidateCreds(String user_, String pswd_)
        {
            _localUser = user_;
            _localPswd = pswd_;
        }

        public void execute() throws SQLException
        {
            // The connection was created so the credentials are valid.
            _valid = true;
        }

        public String getConnectionUser()
        {
            return _localUser;
        }

        public String getConnectionPswd()
        {
            return _localPswd;
        }

        public void failure()
        {
            // An exception occurred with the connection so credentials can not be used.
            _valid = false;
        }
        
        /**
         * Are the credentials valid?
         * 
         * @return true when valid, otherwise false;
         */
        public boolean isValid()
        {
            return _valid;
        }
    }
    
    /**
     * Validate the user provided credentials
     * 
     * @param user_ the user name/account
     * @param pswd_ the password
     * @return true when valid, otherwise false
     */
    public boolean isValidCredentials(String user_, String pswd_)
    {
        DBActionValidateCreds vw = new DBActionValidateCreds(user_, pswd_);
        doSQL(vw);

        boolean flag = vw.isValid();
        if (flag)
            _checkCode = CC_INVALID;

        return flag;
    }
    
    /**
     * Increment the lockout for a user.
     * 
     * @author lhebel
     */
    class DBActionSetLock extends DBAction
    {
        private String _localUser;
        private String _sql;
        private boolean _failed;
        
        DBActionSetLock(String update_, String user_)
        {
            _localUser = user_;
            _sql = update_;
            _failed = false;
        }

        public void execute() throws SQLException
        {
            // Update the lock count appropriately.
            _pstmt = _conn.prepareStatement(_sql);
            _pstmt.setString(1, _localUser);
            _pstmt.execute();
            _failed = (_pstmt.getUpdateCount() == 0);
        }
        
        public void failure()
        {
            _failed = true;
        }
        
        /**
         * Test for failure
         * 
         * @return true if the SQL failed.
         */
        public boolean failed()
        {
            return _failed;
        }
        
        /**
         * Try another SQL statement.
         * 
         * @param insert_ an insert
         */
        public void trySql(String insert_)
        {
            _sql = insert_;
            _failed = false;
        }
    }
    
    /**
     * Increment the lockout for the user
     * 
     * @param user_ the user account
     */
    public void incLock(String user_)
    {
        // Try an update first.
        _checkCode = CC_OTHER;
        DBActionSetLock uw = new DBActionSetLock(INCLOCK, user_);
        doSQL(uw);
        if (uw.failed())
        {
            // Try the insert when the update fails.
            uw.trySql(INSLOCK);
            doSQL(uw);
            if (!uw.failed())
                _checkCode = CC_OK;
        }
        else
            _checkCode = CC_OK;
    }
    
    /**
     * Clear the lockout for the user
     * 
     * @param user_ the user account
     */
    public void clearLock(String user_)
    {
        DBActionSetLock iw = new DBActionSetLock(CLEARLOCK, user_);
        doSQL(iw);
        if (iw.failed())
            _checkCode = CC_OTHER;
        else
            _checkCode = CC_OK;
    }
    
    /**
     * Get the check code. The code indicates the state of the last action performed.
     * 
     * @return CC_OK, CC_LOCKED, CC_INVALID, etc (see the public static final CC_ values on this class)
     */
    public int getCheckCode()
    {
        return _checkCode;
    }
    
    /**
     * Set the static jndi-name for all uses of this class.
     * 
     * @param jndi_ the jndi-name as it appears in the oracle-ds.xml, it is case sensistive
     */
    public static void setJndiName(String jndi_)
    {
        if (jndi_.indexOf(':') > -1)
            _jndiName = jndi_;
        else
        {
            _jndiName = "java:/" + jndi_;
        }
    }
}
