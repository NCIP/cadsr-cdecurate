package gov.nih.nci.cadsr.common;

import java.io.FileInputStream;
import java.sql.Connection;
import java.util.Map;
import java.util.Properties;

public class PropertyHelper {

	private static org.apache.log4j.Logger _logger = org.apache.log4j.Logger.getLogger(PropertyHelper.class);
    private static Properties          _propList;
    private static String              _user;
    private static String              _pswd;
	
	public static String HELP_LINK;
	public static String LOGO_LINK;
	public static String EMAIL_ID;
	public static String EMAIL_PWD;
	
	public static String getHELP_LINK() {
		return HELP_LINK;
	}
	public static void setHELP_LINK(String hELP_LINK) {
		HELP_LINK = hELP_LINK;
	}
	public static String getLOGO_LINK() {
		return LOGO_LINK;
	}
	public static void setLOGO_LINK(String lOGO_LINK) {
		LOGO_LINK = lOGO_LINK;
	}
	public static String getEMAIL_ID() {
		return EMAIL_ID;
	}
	public static void setEMAIL_ID(String eMAIL_ID) {
		EMAIL_ID = eMAIL_ID;
	}
	public static String getEMAIL_PWD() {
		return EMAIL_PWD;
	}
	public static void setEMAIL_PWD(String eMAIL_PWD) {
		EMAIL_PWD = eMAIL_PWD;
	}
	
	public static String getDatabaseUserID() {
		return Database.getString("userid");
	}
	
	public static String getDatabasePassword() {
		return Database.getString("password");
	}
	
	public static String getDatabaseURL() {
		return Database.getString("jdbcurl");
	}
	
    /**
     * Load the properties from the XML file specified.
     *
     * @param propFile_ the properties file.
     */
	/*
    public static void loadProp(String propFile_) throws Exception
    {
        _propList = new Properties();

        _logger.debug("PropertyHelper:Loading properties...\n\n");

        try
        {
            FileInputStream in = new FileInputStream(propFile_);
            _propList.loadFromXML(in);
            in.close();
        }
        catch (Exception ex)
        {
            throw ex;
        }

        _user = _propList.getProperty(Constants._DSUSER);
        if (_user == null)
            _logger.error("Missing " + Constants._DSUSER + " in " + propFile_);

        _pswd = _propList.getProperty(Constants._DSPSWD);
        if (_pswd == null)
            _logger.error("Missing " + Constants._DSPSWD + " in " + propFile_);

        _logger.debug("PropertyHelper: " + _user + " property loaded.");
    }
    */
}