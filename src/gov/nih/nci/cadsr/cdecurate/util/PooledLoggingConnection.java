/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.ConnectionEventListener;
import javax.sql.PooledConnection;
import javax.sql.StatementEventListener;

import net.sf.log4jdbc.ConnectionSpy;

/**
 * Courtesy of https://code.google.com/p/log4jdbc/wiki/DataSourceExampleForWebSphere
 */
public class PooledLoggingConnection implements PooledConnection {

	protected PooledConnection parent;

	public PooledLoggingConnection(PooledConnection pConnection) {
		parent = pConnection;
	}

	public void close() throws SQLException {
		parent.close();
	}

	public Connection getConnection() throws SQLException {
		return new ConnectionSpy(parent.getConnection()); // -- log4jdbc entry
															// point!!!
	}

	@Override
	public void addConnectionEventListener(ConnectionEventListener pListener) {
		parent.addConnectionEventListener(pListener);
	}

	@Override
	public void addStatementEventListener(StatementEventListener arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void removeConnectionEventListener(ConnectionEventListener pListener) {
		parent.removeConnectionEventListener(pListener);
	}

	@Override
	public void removeStatementEventListener(StatementEventListener arg0) {
		// TODO Auto-generated method stub
		
	}
}