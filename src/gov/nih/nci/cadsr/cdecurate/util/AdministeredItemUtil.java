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
}
