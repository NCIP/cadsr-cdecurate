package gov.nih.nci.cadsr.common;

import gov.nih.nci.cadsr.cdecurate.util.CurationToolProperties;
import gov.nih.nci.ncicb.cadsr.common.CaDSRUtil;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.util.Map;
import java.util.Properties;

/**
 * This class can be used to retrieve property values that dictates the settings of the application from the database, 
 * as well as the property file. In case of the property file, it is a tier specific file from template.curationtool.properties.
 *
 */
public class PropertyHelper {

	private static org.apache.log4j.Logger _logger = org.apache.log4j.Logger.getLogger(PropertyHelper.class);
    private static Properties          _propList;
    private static String              _user;
    private static String              _pswd;
	
	public static String HELP_LINK;
	public static String LOGO_LINK;
	public static String EMAIL_ID;
	public static String EMAIL_PWD;
	//GF32679
	public static String DEFAULT_CONTEXT_NAME;

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
		return null;	//Database.getString("userid");
	}
	
	public static String getDatabasePassword() {
		return null;	//Database.getString("password");
	}
	
	public static String getDatabaseURL() {
		return null;	//Database.getString("jdbcurl");
	}

	public static String getPCSURL() {
		return CurationToolProperties.getFactory().getProperty("curationtool.links.pcs.url");
	}

	public static String getPCSName() {
		return CurationToolProperties.getFactory().getProperty("curationtool.links.pcs.name");
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

	/**
	 * GF32649 Default Context change for curation tool
	 */
	public static String getDefaultContextName() {
		if(DEFAULT_CONTEXT_NAME == null) {
			try {
				DEFAULT_CONTEXT_NAME = CaDSRUtil.getDefaultContextNameNoCache();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		System.out.println("****** DEFAULT_CONTEXT_NAME = [" + DEFAULT_CONTEXT_NAME + "] from cadsrutil.properties ******");

		return DEFAULT_CONTEXT_NAME;
	}

}