package gov.nih.nci.cadsr.persist.concept;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.persist.common.BaseVO;
import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.de.DeErrorCodes;
import gov.nih.nci.cadsr.persist.evs.EvsVO;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;

public class Concepts_Ext_Mgr  extends DBManager {
	
	private Logger logger = Logger.getLogger(this.getClass());
		
	public EvsVO getConceptByIdseq(String con_IDSEQ, Connection conn) throws DBException {
		PreparedStatement stmt = null;
		ResultSet rs = null;
		EvsVO evsVO = null;
		try {
			String	sql = "select con_idseq, preferred_name, long_name, preferred_definition, definition_source, origin  from concepts_view_ext where con_idseq = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, con_IDSEQ);
			rs = stmt.executeQuery();
			while (rs.next()) {
				evsVO = new EvsVO();
				evsVO.setIDSEQ(rs.getString("CON_IDSEQ"));
				evsVO.setPrefferred_name(rs.getString("PREFERRED_NAME"));
				evsVO.setLong_name(rs.getString("LONG_NAME"));
				evsVO.setPrefferred_def(rs.getString("PREFERRED_DEFINITION"));
				evsVO.setAsl_name(rs.getString("DEFINITION_SOURCE"));
				evsVO.setAsl_name(rs.getString("ORIGIN"));
			}
		} catch (SQLException e) {
			logger.error(DBException.DEFAULT_ERROR_MSG + " in getConceptByIdseq() method of Concepts_Ext_Mgr class " + e);
			throw new DBException("API_DE_000");
		} finally {
			try {
				rs = SQLHelper.closeResultSet(rs);
				stmt = SQLHelper.closePreparedStatement(stmt);
			} catch (Exception e) {
			}
		}
		return evsVO;
	}
}

