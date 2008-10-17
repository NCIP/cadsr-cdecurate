
package gov.nih.nci.cadsr.persist.common;

import gov.nih.nci.cadsr.persist.exception.DBException;

import java.sql.Connection;

/**
 * @author hveerla
 *
 */
public abstract class ACBase extends DBManager{
	
	public abstract String insert(BaseVO vo, Connection conn) throws DBException;
	public abstract void update(BaseVO vo, Connection conn) throws DBException;
	public abstract void delete(String idseq, String modified_by, Connection conn) throws DBException;


}
