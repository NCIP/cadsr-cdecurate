package gov.nih.nci.cadsr.persist.concept;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.cdecurate.tool.ConBean;
import gov.nih.nci.cadsr.persist.common.BaseVO;
import gov.nih.nci.cadsr.persist.common.DBConstants;
import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.exception.DBException;

public class Con_Derivation_Rules_Ext_Mgr extends DBManager{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	
	public String setCondr(ArrayList<ConBean> list , String name, Connection conn) throws DBException{
		String condr_idseq = null;
		CondrVO condrVO = new CondrVO();
		Component_Concepts_Ext_Mgr ccMgr = new Component_Concepts_Ext_Mgr(); 
		if (list.size() == 1){
			condrVO.setCrtl_name(DBConstants.CRTL_NAME_SIMPLE);
    	}else {
    		condrVO.setCrtl_name(DBConstants.CRTL_NAME_CONCAT);
    	}
		condrVO.setName(name);
		condr_idseq = this.insert(condrVO, conn);
		//Create Component Concepts
		ComponentConceptsVO ccVO = new ComponentConceptsVO();
		ccVO.setCondr_IDSEQ(condr_idseq);
		for(int i=0; i<list.size(); i++){
			ConBean con = (ConBean)list.get(i);
			ccVO.setCon_IDSEQ(con.getCon_IDSEQ());
			ccVO.setDisplay_order(con.getDisplay_order());
			if (con.getDisplay_order() == 0){
				ccVO.setPrimary_flag_ind(DBConstants.PRIMARY_FLAG_YES);
			}else{
				ccVO.setPrimary_flag_ind(DBConstants.PRIMARY_FLAG_NO);
			}
			ccVO.setConcept_Value(con.getConcept_value());
			ccMgr.insert(ccVO, conn);
		}
		return condr_idseq;
	}
	
	/**
	 * Inserts a single row of Concept Derivation Rule and returns primary key condr_IDSEQ
	 * 
	 * @param condrVO
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public String insert(BaseVO vO, Connection conn) throws DBException {
		CondrVO condrVO = (CondrVO) vO;
		PreparedStatement statement = null;
		String primaryKey = null;
		// generate condr_IDSEQ(primary key) 	
		condrVO.setCondr_IDSEQ(this.generatePrimaryKey(conn));
		try {
			String sql ="insert into sbrext.con_derivation_rules_view_ext(condr_idseq, crtl_name, name) values(?,?,?)";
		    int column = 0;
			statement = conn.prepareStatement(sql);
		    statement.setString(++column, condrVO.getCondr_IDSEQ());
			statement.setString(++column, condrVO.getCrtl_name());
			statement.setString(++column, condrVO.getName());
			
			int count = statement.executeUpdate();
			if (count == 0) {
				throw new Exception("Unable to insert the record");
			} else {
				primaryKey = condrVO.getCondr_IDSEQ();
				if (logger.isDebugEnabled()) {
					logger.debug("Inserted Condr");
					logger.debug("condr_IDSEQ(primary key )-----> " + primaryKey);
				}
			}

		} catch (Exception e) {
			logger.error("Error inserting Condr " + e);
			//errorList.add("Error inserting Condr ");
			throw new DBException(errorList);
		} finally {
			statement = SQLHelper.closePreparedStatement(statement);
		}
		return primaryKey;
	}
}
