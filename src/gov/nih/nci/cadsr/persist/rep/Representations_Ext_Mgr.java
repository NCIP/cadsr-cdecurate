/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.persist.rep;

import gov.nih.nci.cadsr.cdecurate.tool.ConBean;
import gov.nih.nci.cadsr.persist.common.BaseVO;
import gov.nih.nci.cadsr.persist.evs.Evs_Mgr;
import gov.nih.nci.cadsr.persist.evs.ResultVO;
import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;
import java.util.ArrayList;

import org.apache.log4j.Logger;

public class Representations_Ext_Mgr extends Evs_Mgr{
private Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * Inserts a single row of Representation and returns primary key rep_IDSEQ
	 * 
	 * @param EVSBean
	 * @param conn
	 * @return
	 * @throws DBException
	 */
	public String insert(BaseVO vO, Connection conn) throws DBException {
		String primaryKey = null;  
		String sql = "insert into representations_view_ext ( rep_idseq, preferred_name, long_name, preferred_definition, conte_idseq, version, asl_name,"
					+ "latest_version_ind, begin_date, definition_source, origin, created_by, deleted_ind, condr_idseq) "
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		primaryKey = this.insert(sql, vO, conn);
		return primaryKey;
	}

	public ArrayList<ResultVO> isCondrExists(ArrayList<ConBean> list, Connection conn) throws DBException{
		ArrayList resultList = new ArrayList();
		String sql =  " SELECT cdr.condr_idseq, rep.rep_idseq as idseq, rep.long_name, rep.rep_id as public_id, rep.version, rep.asl_name, c.name AS context " 
			   + "FROM (SELECT ccv.condr_idseq FROM (SELECT COUNT (*) AS cnt FROM conlist) conlistcnt, conlist hits " 
			   + "INNER JOIN sbrext.component_concepts_view_ext ccv ON ccv.con_idseq = hits.con_idseq AND ccv.display_order = hits.display_order " 
			   + "AND NVL (ccv.concept_value, chr(1)) = NVL (hits.concept_value, chr(1)) GROUP BY ccv.condr_idseq, conlistcnt.cnt HAVING COUNT (*) = conlistcnt.cnt " 
			   + "INTERSECT SELECT ccv.condr_idseq FROM (SELECT COUNT (*) AS cnt FROM conlist) conlistcnt, sbrext.component_concepts_view_ext ccv " 
			   + "GROUP BY ccv.condr_idseq, conlistcnt.cnt HAVING COUNT (*) = conlistcnt.cnt) cdr " 
			   + "LEFT OUTER JOIN sbrext.representations_view_ext rep ON rep.condr_idseq = cdr.condr_idseq " 
			   + "LEFT OUTER JOIN sbr.contexts_view c ON c.conte_idseq = rep.conte_idseq "
			   + "WHERE rep.conte_idseq NOT IN (SELECT value FROM sbrext.tool_options_view_ext where tool_name = 'caDSR' and property like 'EXCLUDE.CONTEXT.%' and value = rep.conte_idseq)";
		resultList = this.isCondrExists(list, sql, conn);
		return resultList;
	}
}
