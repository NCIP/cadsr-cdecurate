// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/TestConnections.java,v 1.9 2007-09-10 17:18:20 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.InvalidPropertiesFormatException;
import java.util.Properties;
import oracle.jdbc.pool.OracleDataSource;

/**
 * @author shegde
 *
 */
public class TestConnections
{
  /**
   * @param dbXML db connection xml file
   * @param dbLogger curationtooltest logger
   * 
   */
  public TestConnections(String dbXML, CurationTestLogger dbLogger)
  {
    if (dbXML.equals("")) dbXML = "DBConnection.xml";
    _logger = dbLogger;
    //load db file
    this.loadProp(dbXML);
  }

  /**
   * Load the properties from the XML file specified.
   * 
   * @param propFile_ the properties file.
   */
  public void loadProp(String propFile_)
  {
      _prop = new Properties();
      try
      {
          _logger.section("Loading properties...");
          if (propFile_ == null || propFile_.equals(""))
            propFile_ = "DBConnection.xml";
          _propFile = propFile_;
          FileInputStream in = new FileInputStream(_propFile);
          _prop.loadFromXML(in);
          in.close();
      }
      catch (FileNotFoundException ex)
      {
          _logger.fatal(ex.toString());
      }
      catch (InvalidPropertiesFormatException ex)
      {
          _logger.fatal(ex.toString());
      }
      catch (IOException ex)
      {
          _logger.fatal(ex.toString());
      }
      
  }

  /**
   * Open a database connection to the caDSR specified in the properties XML.
   * @return Connection object
   * 
   * @throws SQLException
   */
  public Connection openConnection() throws SQLException
  {
      // We only need one connection.
      if (_conn != null)
          return _conn;

      _logger.section("Connecting to caDSR...");
      
      // Read the mandatory database properties.
      String dburl = _prop.getProperty("DSurl");
      if (dburl == null)
      {
          _logger.fatal("Missing DB caDSR property.");
          return null;
      }
      String user = _prop.getProperty("DSusername");
      if (user == null)
      {
          _logger.fatal("Missing DB user property.");
          return null;
      }
      String pswd = _prop.getProperty("DSpassword");
      if (pswd == null)
      {
          _logger.fatal("Missing DB password property.");
          return null;
      }
      _logger.info("DSurl: " + dburl);
      _logger.info("DSusername: " + user);
      _logger.info("DSpassword: " + pswd);

      // Open the database connection. If the format contains colons ( : ) this will be a thin
      // client connection. Otherwise this will be a thick client connection.
      OracleDataSource ods = new OracleDataSource();
      if (dburl.indexOf(':') > 0)
      {
          String parts[] = dburl.split("[:]");
          ods.setDriverType("thin");
          ods.setServerName(parts[0]);
          ods.setPortNumber(Integer.parseInt(parts[1]));
          ods.setServiceName(parts[2]);
      }
      else
      {
          ods.setDriverType("oci8");
          ods.setTNSEntryName(dburl);
      }
      _conn = ods.getConnection(user, pswd);
      
      // No updates should be done using this connection.
      _conn.setAutoCommit(false);
      
      return _conn;
  }

  /**
   * Close the database connection.
   * 
   * @throws SQLException
   */
  public void closeConnection() throws SQLException
  {
      _conn.close();
  }

  private static Connection _conn;
  
  private static Properties _prop;
  
  private static String _propFile;

  private static CurationTestLogger _logger;

}
