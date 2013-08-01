/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.util.Properties;

/**
 * class to read a properties file
 * 
 * @author hveerla
 */
public class CurationToolProperties implements Serializable {

	InputStream is = null;
	private Properties props = null;
	private static CurationToolProperties CurationToolProperties = null;

	private CurationToolProperties() throws IOException {
		props = loadProps();
	}

	public static CurationToolProperties getFactory() {
		try {
			if (CurationToolProperties == null) {
				CurationToolProperties = new CurationToolProperties();
			}

		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();

		}
		return CurationToolProperties;
	}

	private Properties loadProps() throws IOException {
		try {
			ClassLoader cl = this.getClass().getClassLoader();
			is = cl.getResourceAsStream("curationtool.properties");
			props = new Properties();
			props.load(is);
		} catch (Exception e) {
			throw new IOException("Unable to get properties in loadProps() : "
					+ e);
		} finally {
			if (is != null)
				is.close();
		}

		return props;
	}

	public String getProperty(String key) {
		return props.getProperty(key);
	}
}
