package gov.nih.nci.cadsr.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import org.apache.log4j.Logger;

public class TestUtil {

    private static Logger logger = Logger.getLogger(TestUtil.class.getName());
	
	private static Connection pooledConnection;
    private String dbms;
	private String userName;
	private String password;
	private String serverName;
	private int portNumber = -1;
	private String dbName;
	
	public static Connection getConnection(String username, String password)
			throws Exception {
		String dbtype = "oracle";
//		String dbserver = "ncidb-dsr-q.nci.nih.gov";
//		String dbname = "DSRQA";
//		int port = 1551;
		String dbserver = "137.187.181.4";
		String dbname = "DSRDEV";
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
	
	public Connection getConnection() throws Exception {
		if(dbms == null ||
		userName == null ||
		password == null ||
		serverName == null ||
		portNumber == -1 ||
		dbName == null) {
			throw new Exception("All parameters must be set.");
		}

	    Connection conn = null;
	    Properties connectionProps = new Properties();
	    connectionProps.put("user", this.userName);
	    connectionProps.put("password", this.password);

	    if (this.dbms.equals("oracle")) {
	    	Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
	    	//SID only, not service name (ref: http://www.orafaq.com/wiki/JDBC)
	        conn = DriverManager.getConnection(
	                   "jdbc:" + this.dbms + ":thin:" +
	                    "@" +
	                   this.serverName +
	                   ":" + this.portNumber + ":" +
	                   this.dbName,
	                   connectionProps);        
	    } else if (this.dbms.equals("mysql")) {
	    	Class.forName ("com.mysql.jdbc.Driver").newInstance(); 
	    	String jdbcUrl = 
	                   "jdbc:" + this.dbms + "://" +
	                   this.serverName +
	                   ":" + this.portNumber + "/" + this.dbName;
	    	logger.info("jdbc url = '" + jdbcUrl + "'");
	        conn = DriverManager.getConnection(jdbcUrl,
	                   connectionProps);
	    } else if (this.dbms.equals("derby")) {
	        conn = DriverManager.getConnection(
	                   "jdbc:" + this.dbms + ":" +
	                   this.dbName +
	                   ";create=true",
	                   connectionProps);
	    }
	    return conn;
	}

}
