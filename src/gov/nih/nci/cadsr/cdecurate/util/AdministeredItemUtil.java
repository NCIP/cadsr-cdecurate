package gov.nih.nci.cadsr.cdecurate.util;

public class AdministeredItemUtil {

	public static String handleLongName(String name) {
		String retVal = name;
		
		//GF32004
		if(name != null && !name.trim().equals("")) {
			if(name.indexOf("Integer::") > -1) {
				retVal = name.replace("Integer::", "");
			}
		}

		return retVal;
	}
	
	public static String truncateTime(String dateString) {
		String retVal = dateString;
		
		//GF30779
		if(dateString != null) {
			int i = dateString.indexOf(" ");
			if(i > -1) {
				retVal = dateString.substring(0,i);
			}
		}
		System.out.println("******* at line 28 of AdministeredItemUtil.java" + retVal);

		return retVal;
	}
}
