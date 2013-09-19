/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/TestConnections.java,v 1.9 2007-09-10 17:18:20 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;
import oracle.jdbc.pool.OracleDataSource;

/**
 * Setup:
 * 
 * Change the user id and password in DBConnection.xml before running this!
 */
public class TestConnections {
	/**
	 * @param dbXML
	 *            db connection xml file
	 * @param dbLogger
	 *            curationtooltest logger
	 * 
	 */
	public TestConnections(String dbXML, CurationTestLogger dbLogger) {
		if (dbXML.equals(""))
			dbXML = "DBConnection.xml";
		_logger = dbLogger;
		// load db file
		this.loadProp(dbXML);
	}

	public TestConnections() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * Load the properties from the XML file specified.
	 * 
	 * @param propFile_
	 *            the properties file.
	 */
	public void loadProp(String propFile_) {
		_prop = new Properties();
		try {
			_logger.section("Loading properties...");
			if (propFile_ == null || propFile_.equals(""))
				propFile_ = "DBConnection.xml";
			_propFile = propFile_;
			// FileInputStream in = new FileInputStream(_propFile);
			InputStream in = ClassLoader.getSystemResourceAsStream(_propFile);
			_prop.loadFromXML(in);
			in.close();
		} catch (FileNotFoundException ex) {
			_logger.fatal(ex.toString());
		} catch (InvalidPropertiesFormatException ex) {
			_logger.fatal(ex.toString());
		} catch (IOException ex) {
			_logger.fatal(ex.toString());
		}

	}

	/**
	 * Open a database connection to the caDSR specified in the properties XML.
	 * 
	 * @return Connection object
	 * 
	 * @throws SQLException
	 */
	public Connection openConnection() throws SQLException {
		// We only need one connection.
		if (_conn != null)
			return _conn;

		_logger.section("Connecting to caDSR...");

		// Read the mandatory database properties.
		String dburl = _prop.getProperty("DSurl");
		if (dburl == null) {
			_logger.fatal("Missing DB caDSR property.");
			return null;
		}
		String user = _prop.getProperty("DSusername");
		if (user == null) {
			_logger.fatal("Missing DB user property.");
			return null;
		}
		String pswd = _prop.getProperty("DSpassword");
		if (pswd == null) {
			_logger.fatal("Missing DB password property.");
			return null;
		}
		_logger.info("DSurl: " + dburl);
		_logger.info("DSusername: " + user);
		_logger.info("DSpassword: " + pswd);

		// Open the database connection. If the format contains colons ( : )
		// this will be a thin
		// client connection. Otherwise this will be a thick client connection.
		// OracleDataSource ods = new OracleDataSource();
		// if (dburl.indexOf(':') > 0)
		// {
		// String parts[] = dburl.split("[:]");
		// ods.setDriverType("thin");
		// ods.setServerName(parts[0]);
		// ods.setPortNumber(Integer.parseInt(parts[1]));
		// ods.setServiceName(parts[2]);
		// }
		// else
		// {
		// ods.setDriverType("oci8");
		// ods.setTNSEntryName(dburl);
		// }
		// _conn = ods.getConnection(user, pswd);
		try {
			_conn = getConnection(user, pswd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// No updates should be done using this connection.
		_conn.setAutoCommit(false);

		return _conn;
	}

	public Connection getConnection(String username, String password)
			throws Exception {
		String dbtype = "oracle";
		String dbserver = "137.187.181.4";
		String dbname = "DSRDEV"; // dev
		// String dbserver = "137.187.181.89"; String dbname = "DSRQA";
		int port = 1551;
		ConnectionUtil cu = new ConnectionUtil();
		cu.setUserName(username);
		cu.setPassword(password);
		cu.setDbms(dbtype);
		cu.setDbName(dbname);
		cu.setServerName(dbserver);
		cu.setPortNumber(port);
		Connection conn = cu.getConnection();
		return conn;
	}

	/**
	 * Close the database connection.
	 * 
	 * @throws SQLException
	 */
	public void closeConnection() throws SQLException {
		_conn.close();
	}

	private static Connection _conn;

	private static Properties _prop;

	private static String _propFile;

	private static CurationTestLogger _logger;

	public static void main(String[] args) {
		CurationTestLogger logger1 = new CurationTestLogger(TestDEC.class);
		// Initialize the Log4j environment.
		String logXML = "log4j.xml";
		if (args.length > 0) {
			logXML = args[0];
		}
		// initialize connection
		String connXML = "";
		if (args.length > 1)
			connXML = args[1];

		TestConnections tConn = new TestConnections();
		TestSentinel sentinel = new TestSentinel();
		
		try {
			//tConn.testSQL(connXML, logger1);
			sentinel.testGF7680(connXML, logger1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void testSQL(String connXML,
			CurationTestLogger logger1) throws Exception {

		TestConnections varCon = new TestConnections(connXML, logger1);
		Connection conn = null;
		conn = varCon.openConnection();
        System.out.println("connected");
		PreparedStatement stmt = conn.prepareStatement("begin SBREXT_CDE_CURATOR_PKG.ADD_TO_SENTINEL_CS('618EF2EF-0953-F882-E040-BB89AD434C20','ALAIS',null); end;");	//GF7680
		//stmt.setString(1, username.toUpperCase());
//		ResultSet rs = stmt.executeQuery();
//		if(rs.next()) {
//		}
		System.out.println("returned = " + stmt.executeUpdate());

	}

}
