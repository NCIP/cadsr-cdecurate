package gov.nih.nci.cadsr.persist.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.persist.common.DBHelper;
import gov.nih.nci.cadsr.persist.exception.DBException;

public class User_Accounts_Mgr extends DBHelper {
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * This method returns user's full name 
	 * @param userName
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public String getUserFullName(String userName, Connection conn) throws DBException{
		String userFullName = null;
		PreparedStatement statement = null;
		ResultSet rs = null;
		try {
			String sql ="select name from user_accounts_view where ua_name = ?";
			statement = conn.prepareStatement(sql);
			statement.setString(1,userName);
			rs = statement.executeQuery();
			while (rs.next()) {
				userFullName = rs.getString(1);
			}
	    } catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getUserFullName() method of DBManager class " + e);
			throw new DBException("Cannot able to get userFullName");
		} finally {
			try {
				DBHelper.close(rs, statement);
			} catch (Exception e) {
			}
		}
		return userFullName;
	}

}
