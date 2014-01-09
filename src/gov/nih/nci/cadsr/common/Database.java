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

	private static final ResourceBundle RESOURCE_BUNDLE = ResourceBundle
			.getBundle(BUNDLE_NAME);

	private DbmsOutput dbmsOutput;

	public static String getString(String key) {
		try {
			return RESOURCE_BUNDLE.getString(key);
		} catch (MissingResourceException e) {
			return '!' + key + '!';
		}
	}
	
	public void trace(Connection conn) {
		try {
			dbmsOutput = new DbmsOutput(conn);
			dbmsOutput.enable( 1000000 );
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void show() {
		try {
			dbmsOutput.show();
		    dbmsOutput.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
