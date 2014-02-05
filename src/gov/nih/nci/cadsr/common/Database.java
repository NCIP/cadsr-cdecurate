/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.common;

import gov.nih.nci.cadsr.cdecurate.tool.PVAction;

import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.sql.*;

import org.apache.log4j.Logger;

public class Database {
	private static final Logger logger = Logger.getLogger(Database.class.getName());

	private static final String BUNDLE_NAME = "database"; //$NON-NLS-1$
//	private static final String BUNDLE_NAME = "gov.nih.nci.cadsr.common.database"; //$NON-NLS-1$

//	private static final ResourceBundle RESOURCE_BUNDLE = ResourceBundle
//			.getBundle(BUNDLE_NAME);

	private DbmsOutput dbmsOutput;
	private boolean enabled = false;

//	public static String getString(String key) {
//		try {
//			return RESOURCE_BUNDLE.getString(key);
//		} catch (MissingResourceException e) {
//			return '!' + key + '!';
//		}
//	}
	
	public boolean isEnabled() {
		return enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}
	
	public void trace(Connection conn) {
		if(conn != null) {
			try {
				dbmsOutput = new DbmsOutput(conn);
				dbmsOutput.enable(10000000);
				enabled = true;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			enabled = false;
			LogUtil.log("Database:trace() conn is empty or NULL, trace disabled!");
		}
	}
	
	public void show() {
		if(enabled) {
			try {
				LogUtil.log("$$$$$$ Database.show() begin $$$$$$>");
				dbmsOutput.show();
			    dbmsOutput.close();
			    LogUtil.log("<$$$$$$ Database.show() end $$$$$$");
			} catch (Exception e) {
				LogUtil.log("----- Database.show() begin error ------>");
				e.printStackTrace();
				LogUtil.log("<----- Database.show() end error ------");
			}
			LogUtil.log("$$$$$$ Database.show() end $$$$$$>");
		}
	}
	
}
