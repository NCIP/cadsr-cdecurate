package gov.nih.nci.cadsr.persist.ac;

import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;

public class Admin_Components_Mgr extends DBManager {

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

}
