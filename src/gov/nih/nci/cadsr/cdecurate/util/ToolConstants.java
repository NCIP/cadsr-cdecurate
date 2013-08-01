/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.util;

/**
 * Constants used throughout the curation tool
 * 
 * @author pansu
 * 
 */
public class ToolConstants {
	public static String ONLINE_HELP_URL;
	public static String LINKS_PCS_NAME;
	public static String LINKS_PCS_URL;
	static {
		ONLINE_HELP_URL = CurationToolProperties.getFactory().getProperty(
				"curationtool.help.url");
		LINKS_PCS_NAME = CurationToolProperties.getFactory().getProperty(
				"curationtool.links.pcs.name");
		LINKS_PCS_URL = CurationToolProperties.getFactory().getProperty(
				"curationtool.links.pcs.url");
	}
}
