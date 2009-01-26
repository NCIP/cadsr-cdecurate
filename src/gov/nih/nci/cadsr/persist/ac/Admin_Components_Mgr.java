package gov.nih.nci.cadsr.persist.ac;

import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.DBHelper;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.log4j.Logger;

public class Admin_Components_Mgr extends DBManager {
    
	private Logger logger = Logger.getLogger(this.getClass());
	/**
	 * Checks to see that AC with same IDSEQ already exists if exists, returns
	 * true else returns false
	 * 
	 * @param ac_IDSEQ
	 * @param conn
	 * @return 
	 * @throws DBException
	 */
	public boolean isAcExists(String ac_IDSEQ, Connection conn)	throws DBException {
		boolean isExists;

		StringBuffer sql = new StringBuffer();
		sql.append("select  COUNT(*) as count from admin_components_view ");
		sql.append("where (ac_idseq = '").append(ac_IDSEQ).append("') and (deleted_ind = '")
				  .append(DBConstants.RECORD_DELETED_NO).append("')");
		isExists = this.isExists(sql.toString(), conn);
		return isExists;
	}

	/**
	 * Checks to see that AC with same preferred_name, context, version already
	 * exists if exists, returns true else returns falseChecks to see that AC
	 * with same preferred_name, context, version already exists if exists,
	 * returns true else returns false
	 * 
	 * @param preferred_name
	 * @param context_IDSEQ
	 * @param version
	 * @param actl_name
	 * @param conn
	 * @return 
	 * @throws DBException
	 */
	public boolean isAcExists(String preferred_name, String context_IDSEQ, double version, String actl_name, Connection conn) throws DBException {
		boolean isExists;

		StringBuffer sql = new StringBuffer();
		sql.append("select  COUNT(*) as count from admin_components_view ");
		sql.append("where (preferred_name = '").append(preferred_name).append(
				"') and (conte_idseq = '").append(context_IDSEQ).append(
				"') and (version = '").append(version).append(
				"') and (actl_name = '").append(actl_name).append(
				"') and (deleted_ind = '").append(DBConstants.RECORD_DELETED_NO).append("')");
		isExists = this.isExists(sql.toString(), conn);
		return isExists;
	}

	/**
	 * This method checks if prior version of AC already exists
	 * If exists, returns true else returns false
	 * 
	 * @param preferred_name
	 * @param context_IDSEQ
	 * @param actl_name
	 * @param conn
	 * @return 
	 * @throws DBException
	 */
	public boolean isAcVersionExists(String preferred_name,	String context_IDSEQ, String actl_name, Connection conn) throws DBException {
		boolean isExists;

		StringBuffer sql = new StringBuffer();
		sql.append("select  COUNT(*) as count from admin_components_view ");
		sql.append("where (preferred_name = '").append(preferred_name).append(
				"') and (conte_idseq = '").append(context_IDSEQ).append(
				"') and (actl_name = '").append(actl_name).append(
				"') and (deleted_ind = '")
				.append(DBConstants.RECORD_DELETED_NO).append("')");
		isExists = this.isExists(sql.toString(), conn);
		return isExists;
	}
    
	/**
	 * @param acIDSEQ
	 * @param public_ID
	 * @param version
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public ArrayList<String> getActlName(String acIDSEQ, long public_ID, double version, Connection conn) throws DBException{
		ArrayList<String> list = new ArrayList<String>();
		PreparedStatement statement = null;
		ResultSet rs = null;
		try {
			String sql ="select actl_name, ac_idseq from sbr.admin_components_view where ac_idseq = ? or (public_id = ? and version = ?)";
			statement = conn.prepareStatement(sql);
			statement.setString(1,acIDSEQ);
			statement.setLong(2,public_ID);
			statement.setDouble(3,version);
			rs = statement.executeQuery();
			while (rs.next()) {
				 list.add(rs.getString(1));
				 list.add(rs.getString(2));
			}
	    } catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getActlName() method of Admin_Components_Mgr class " + e);
			throw new DBException("Cannot able to get ActlName");
		} finally {
			try {
				DBHelper.close(rs, statement);
			} catch (Exception e) {
			}
		}
		return list;
	}
	public ArrayList<String> getPublicIDVersion(String acIDSEQ, Connection conn) throws DBException{
		ArrayList<String> list = new ArrayList<String>();
		PreparedStatement statement = null;
		ResultSet rs = null;
		try {
			String sql ="select public_id, version from sbr.admin_components_view where ac_idseq = ?";
			statement = conn.prepareStatement(sql);
			statement.setString(1,acIDSEQ);
			rs = statement.executeQuery();
			while (rs.next()) {
				 list.add(rs.getString(1));
				 list.add(rs.getString(2));
			}
	    } catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getPublicIDVersion() method of Admin_Components_Mgr class " + e);
			throw new DBException("Cannot able to get PublicID and Version");
		} finally {
			try {
				DBHelper.close(rs, statement);
			} catch (Exception e) {
			}
		}
		return list;
	}
	/*
	 * This method returns idseq 
	 */
	public String getACIdseq(long publicID, double version, Connection conn) throws DBException{
		String acIdseq = null;
		PreparedStatement statement = null;
		ResultSet rs = null;
		try {
			String sql ="select ac_idseq from sbr.admin_components_view where public_id = ? and version = ?";
			statement = conn.prepareStatement(sql);
			statement.setLong(1,publicID);
			statement.setDouble(2,version);
			rs = statement.executeQuery();
			while (rs.next()) {
				acIdseq = rs.getString(1);
			}
	    } catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getACIdseq() method of Admin_Components_Mgr class " + e);
			throw new DBException("Cannot able to get AC Idseq");
		} finally {
			try {
				DBHelper.close(rs, statement);
			} catch (Exception e) {
		}
		
	  }
		return acIdseq;
	}

/*
 * This method returns long name 
 */
public String getACLongName(long publicID, double version, Connection conn) throws DBException{
	String longName = "";
	PreparedStatement statement = null;
	ResultSet rs = null;
	try {
		String sql ="select long_name from sbr.admin_components_view where public_id = ? and version = ?";
		statement = conn.prepareStatement(sql);
		statement.setLong(1,publicID);
		statement.setDouble(2,version);
		rs = statement.executeQuery();
		while (rs.next()) {
			longName = rs.getString(1);
		}
    } catch (SQLException e) {
		logger.error(DBException.DEFAULT_ERROR_MSG + " in getACLongName() method of Admin_Components_Mgr class " + e);
		throw new DBException("Cannot able to get AC long_name");
	} finally {
		try {
			DBHelper.close(rs, statement);
		} catch (Exception e) {
	}
	
  }
	return longName;
}

}
