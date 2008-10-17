package gov.nih.nci.cadsr.persist.ac;

import gov.nih.nci.cadsr.persist.common.DBHelper;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.de.DeErrorCodes;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.apache.log4j.Logger;

@SuppressWarnings("unchecked")
public class Ac_Histories_Mgr extends DBManager {

	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * This method creates a history record
	 * 
	 * @param sourceIDSEQ
	 * @param IDSEQ
	 * @param alName
	 * @param createdBy
	 * @param conn
	 * @throws DBException
	 */
	public void createAcHistory(String sourceIDSEQ, String IDSEQ, String alName, String createdBy, Connection conn) throws DBException {
		PreparedStatement statement = null;
		try {
			String ach_idseq = this.generatePrimaryKey(conn);
			String sql = "insert into ac_Histories_View (ach_idseq, ac_idseq, source_ac_idseq, al_name, action_date, created_by, date_created) values(?,?,?,?,?,?,?)";

			int column = 0;
			statement = conn.prepareStatement(sql);
			statement.setString(++column, ach_idseq);
			statement.setString(++column, IDSEQ);
			statement.setString(++column, sourceIDSEQ);
			statement.setString(++column, alName);
			statement.setTimestamp(++column, new Timestamp(new java.util.Date().getTime()));
			statement.setString(++column, createdBy);
			statement.setTimestamp(++column, new Timestamp(new java.util.Date().getTime()));

			statement.executeUpdate();

			if (logger.isDebugEnabled()) {
				logger.debug("History Created -----> " + ach_idseq);
			}
		} catch (SQLException e) {
			logger.error("Error creating history for " + IDSEQ + e);
			errorList.add(DeErrorCodes.API_DE_504);
			throw new DBException(errorList);
		} finally {
			DBHelper.close(statement);
		}
	}
}















