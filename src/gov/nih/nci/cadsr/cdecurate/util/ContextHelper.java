package gov.nih.nci.cadsr.cdecurate.util;

import java.text.CharacterIterator;
import java.text.StringCharacterIterator;

public class ContextHelper {

	public static String handleDefaultName(String name) {
		String retVal = name;
		
		//GF32649
		if(name != null && name.trim().equals("caBIG")) {
			retVal = "NCI";
		}

		return retVal;
	}

}
