package gov.nih.nci.cadsr.persist.concept;

import java.sql.Connection;

import org.apache.log4j.Logger;

import gov.nih.nci.cadsr.persist.common.DBManager;
import gov.nih.nci.cadsr.persist.exception.DBException;

public class Con_Derivation_Rules_Ext_Mgr extends DBManager{
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	public boolean isCondrExists(String condr_IDSEQ, Connection conn) throws DBException {
		boolean isExists;

		StringBuffer sql = new StringBuffer();
		sql.append("select  COUNT(*) as count from con_derivation_rules_ext ");
		sql.append("where (condr_idseq = '").append(condr_IDSEQ).append("')");
		isExists = this.isExists(sql.toString(), conn);
		return isExists;
	}

}
