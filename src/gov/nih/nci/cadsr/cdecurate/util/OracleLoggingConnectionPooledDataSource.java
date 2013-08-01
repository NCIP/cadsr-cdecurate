/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.util;

import java.sql.SQLException;
import java.util.Properties;

import javax.sql.PooledConnection;

import org.apache.log4j.PropertyConfigurator;

import oracle.jdbc.pool.OracleConnectionPoolDataSource;

public class OracleLoggingConnectionPooledDataSource extends
		OracleConnectionPoolDataSource {

	public OracleLoggingConnectionPooledDataSource()
			throws java.sql.SQLException {
		super();
		initLogging();
	}

	protected void initLogging() {
		try {
			PropertyConfigurator.configure(getClass().getClassLoader()
					.getResource("log4jdbc_log4j.properties"));
		} catch (Exception pEx) {
			System.err.println("Error configuring log4jdbc logging: "
					+ pEx.toString());
		}
	}

	public PooledConnection getPooledConnection(Properties arg0)
			throws SQLException {
		return new PooledLoggingConnection(getPooledConnection(arg0));
	}

	public PooledConnection getPooledConnection(String arg0, String arg1)
			throws SQLException {
		return new PooledLoggingConnection(
				super.getPooledConnection(arg0, arg1));
	}
}