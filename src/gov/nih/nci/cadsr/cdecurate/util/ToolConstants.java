package gov.nih.nci.cadsr.cdecurate.util;

/**
 * Constants used throughout the curation tool
 * 
 * @author pansu
 * 
 */
public class ToolConstants {
	public static String ONLINE_HELP_URL;
	static {
		ONLINE_HELP_URL = CurationToolProperties.getFactory().getProperty(
				"curationtool.help.url");
	}
}
