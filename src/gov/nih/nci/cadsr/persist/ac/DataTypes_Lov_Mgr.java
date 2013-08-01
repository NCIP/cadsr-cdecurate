/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.ac;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.exception.DBException;

public class DataTypes_Lov_Mgr extends DBManager{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public Vector<DataTypeVO> getDatatypesList(Connection conn) throws DBException{
		Vector<DataTypeVO> dataTypesList = new Vector<DataTypeVO>();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		try {
			String sql = "select * from sbr.datatypes_lov_view order by upper(dtl_name)";
			stmt = conn.prepareStatement(sql);
			rs = stmt.executeQuery();
			while (rs.next()) {
				DataTypeVO dataTypeVO = new DataTypeVO();
				dataTypeVO.setDtl_name(rs.getString("DTL_NAME"));
				dataTypeVO.setDescription(rs.getString("DESCRIPTION"));
				dataTypeVO.setComments(rs.getString("COMMENTS"));
				dataTypeVO.setScheme_reference(rs.getString("SCHEME_REFERENCE"));
				dataTypeVO.setAnnotation(rs.getString("ANNOTATION"));
				dataTypesList.add(dataTypeVO);
			}
		} catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getDatatypesList() method of DataTypes_Lov_Mgr class " + e);
			throw new DBException("API_DE_000");
		} finally {
			rs = SQLHelper.closeResultSet(rs);
			stmt = SQLHelper.closePreparedStatement(stmt);
		}
		return dataTypesList;
	}

}
