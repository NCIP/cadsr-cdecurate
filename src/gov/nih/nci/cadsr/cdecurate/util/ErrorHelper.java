package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.common.PropertyHelper;

public class ErrorHelper {

	//GF32153
	public static final String getLoginMessage() {
		String message = "<h2>We're Sorry</h2>" +
				"<div style=\"font-size: 12pt;font-weight:bold;\">We understand the inconvenience this has caused, and we are very sorry for this!" +
				"<p style=\"font-size: 12pt;font-weight:bold;\">You could try again or visit <a href='" + PropertyHelper.getPCSURL() + "'>" + PropertyHelper.getPCSName() + " (" + PropertyHelper.getPCSURL() + ")</a> to reset your password.</div>";
				
		return message;
	}

}
