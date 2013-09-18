package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.common.Constants;
import gov.nih.nci.cadsr.common.PropertyHelper;

public class ErrorHelper {

	//GF32153
	public static final String getLoginMessage() {
		String message = //"<h2>We're Sorry</h2>" +
				"<div style=\"font-size: 12pt;font-weight:bold;\">" + Constants.ERR_LOGON_ISSUE + " You could try up to 6 attempts before being locked out, or visit " + PropertyHelper.getPCSName() + " at <a href='" + PropertyHelper.getPCSURL() + "'>" + PropertyHelper.getPCSURL() +"</a> to reset your password. " +
				"</div>";
				
		return message;
	}

}
