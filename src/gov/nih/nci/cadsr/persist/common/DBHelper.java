/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.common;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import org.apache.log4j.*;

public class DBHelper {

	private static Logger logger = Logger.getLogger(DBHelper.class);
	
	public DBHelper(){
	}

	/**This method closes the resultset and statement object
	 * 
	 * @param rs
	 * @param stmt
	 */
	public static void close(ResultSet rs, Statement stmt) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				logger.warn("Failed to close resultset", e);
			}
		}
		close(stmt);
	}
	
	/**This method closes the statement object
	 * 
	 * @param stmt
	 */
	public static void close(Statement stmt) {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (SQLException e) {
				logger.warn("Error closing statement");
			}
		}
	}

}
