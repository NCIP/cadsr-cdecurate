/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

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
