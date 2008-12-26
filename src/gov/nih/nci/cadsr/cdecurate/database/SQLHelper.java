/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.database;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.log4j.Logger;

/**
 * @author asharma
 *
 */
public class SQLHelper {
	 public static final Logger  logger  = Logger.getLogger(SQLHelper.class.getName());
		   
    /**
     * @param ps
     */
    public static void closePreparedStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e1) {
            	logger.error("Failed to close PreparedStatement", e1);
            }
        }
    }
    /**
     * @param stmt
     */
    public static void closeStatement(Statement stmt) {
        if (stmt != null) {
            try {
            	stmt.close();
            } catch (SQLException e1) {
            	logger.error("Failed to close Statement", e1);
            }
        }
    }
    /**
     * @param rs
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e1) {
            	logger.error("Failed to close ResultSet", e1);
            }
        }
       
    }
    
    /**
     * @param cstmt
     */
    public static void closeCallableStatement(CallableStatement cstmt) {
        if (cstmt != null) {
            try {
            	cstmt.close();
            } catch (SQLException e1) {
            	logger.error("Failed to close CallableStatement", e1);
            }
        }
    }  
        
    /**
     * @param con
     */
    public static void closeConnection(Connection con){
            try
            {
              if (con != null && !con.isClosed())
                    con.close();
            }catch (SQLException e1) {
            	logger.error("Failed to close Connection", e1);
            }catch (Exception e){
                logger.fatal("Error closing the connection ", e);
            }
        }
  
 }

