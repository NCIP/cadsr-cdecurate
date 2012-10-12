package gov.nih.nci.cadsr.cdecurate.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

public class ConnectionUtil {

    private static Logger logger = Logger.getLogger(ConnectionUtil.class.getName());

	private static Connection pooledConnection;
    private String dbms;
	private String userName;
	private String password;
	private String serverName;
	private int portNumber = -1;
	private String dbName;
	
	public String getDbms() {
		return dbms;
	}

	public void setDbms(String dbms) {
		this.dbms = dbms;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getServerName() {
		return serverName;
	}

	public void setServerName(String serverName) {
		this.serverName = serverName;
	}

	public int getPortNumber() {
		return portNumber;
	}

	public void setPortNumber(int portNumber) {
		this.portNumber = portNumber;
	}

	public String getDbName() {
		return dbName;
	}

	public void setDbName(String dbName) {
		this.dbName = dbName;
	}

	public static Connection getPooledConnection() {
		return pooledConnection;
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

	public static DataSource getDS(String _jndiUser) throws Exception {
		Context envContext = new InitialContext();
		DataSource ds = (DataSource)envContext.lookup(_jndiUser);
		return ds;
	}
	
}
