/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

/**
 * 
 */
package gov.nih.nci.cadsr.persist.ac;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.de.DeErrorCodes;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import org.apache.log4j.Logger;

/**
 * @author hveerla
 *
 */
public class Tool_Options_View_Ext_Mgr extends DBManager{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public HashMap<String, String> getDefaultContext(Connection conn) throws DBException{
		HashMap<String, String> defaultContext = new HashMap<String, String>();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "select tv.value, cv.name from tool_options_view_ext tv , contexts_view  cv where tv.tool_name = 'caDSR' and tv.property = 'DEFAULT_CONTEXT' and tv.value = cv.conte_idseq";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			while (rs.next()) {
				defaultContext.put("idseq", rs.getString("VALUE"));
				defaultContext.put("name", rs.getString("NAME"));
			}
		} catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getDefaultContext() method in Evs_Mgr " + e);
			errorList.add(DeErrorCodes.API_DE_000);
			throw new DBException(errorList);
		} finally {
			rs = SQLHelper.closeResultSet(rs);
			stmt = SQLHelper.closePreparedStatement(stmt);
		}
	     return defaultContext;
		
	}

}
