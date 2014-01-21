/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.common;

import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.sql.*;

public class Database {
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
				dbmsOutput.enable( 1000000 );
				enabled = true;
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			enabled = false;
			System.out.println("Database:trace() conn is empty or NULL, trace disabled!");
		}
	}
	
	public void show() {
		if(enabled) {
			try {
				System.out.println("$$$$$$ Database.show() begin $$$$$$>");
				dbmsOutput.show();
			    dbmsOutput.close();
				System.out.println("<$$$$$$ Database.show() end $$$$$$");
			} catch (Exception e) {
				System.out.println("----- Database.show() begin error ------>");
				e.printStackTrace();
				System.out.println("<----- Database.show() end error ------");
			}
		}
	}
	
}
