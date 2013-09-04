package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;

import java.io.BufferedReader;

import java.io.BufferedReader;
import java.text.CharacterIterator;
import java.text.StringCharacterIterator;

public class AdministeredItemUtil {

	public static String handleLongName(String name) {
		String retVal = name;

		// GF32004
		if (name != null && !name.trim().equals("")) {
			if (name.indexOf("Integer::") > -1) {
				retVal = name.replace("Integer::", "");
			}
		}

		return retVal;
	}

	public static String handleSpecialCharacters(byte[] value) throws Exception {
		String retVal = "";

		if (value != null && value.length > 0) {
			retVal = toASCIICode(new String(value));
		}

		return retVal;
	}

	public static String safeString(String str) throws Exception {
		final StringBuilder result = new StringBuilder();
		final StringCharacterIterator iterator = new StringCharacterIterator(
				str);
		char character = iterator.current();
		boolean found = false;
		while (character != CharacterIterator.DONE) {
			if ((int) character < 32 || (int) character > 126) {
				result.append(" ");
				found = true;
				// System.out.println("Ctrl char detected -"+(int)character+"-, filtered with a space!");
			} else {
				result.append(character);
			}
			character = iterator.next();
		}
		if (found) {
			System.out.println("Ctrl char detected in str '" + str + "'");
		}
		return result.toString();
	}

	/**
	 * Utility method to prints out its ASCII value
	 */
	public static String toASCIICode(String str) throws Exception {
		final StringBuilder result = new StringBuilder();
		final StringCharacterIterator iterator = new StringCharacterIterator(
				str);
		char character = iterator.current();
		while (character != CharacterIterator.DONE) {
			if ((int) character < 32 || (int) character > 126) {
				result.append("{").append((int) character).append("}");
			} else {
				result.append(character);
			}
			character = iterator.next();
		}
		return result.toString();
	}

	public static String truncateTime(String dateString) {
		String retVal = dateString;

		// GF30779
		if (dateString != null) {
			int i = dateString.indexOf(" ");
			if (i > -1) {
				retVal = dateString.substring(0, i);
			}
		}
		System.out.println("******* at line 28 of AdministeredItemUtil.java"
				+ retVal);

		return retVal;
	}

	public static boolean isAlternateDefinitionExists(String altDef,
			AltNamesDefsSession altSession) throws Exception {
		boolean retVal = false;

		if (altSession == null) {
			throw new Exception(
					"Alternate definition session can not be NULL or empty.");
		}
		if (altDef == null) {
			throw new Exception(
					"New alternate definition can not be NULL or empty.");
		}
		Alternates[] _alts = altSession.getAlternates();

		if (_alts != null) {
			for (Alternates alt : _alts) {
				String temp = alt.getName();
				if (altDef.trim().equals(temp.trim())) {
					retVal = true;
				}
			}
		}

		return retVal;
	}

	public static boolean isAlternateDesignationExists(String type, String name,
			AltNamesDefsSession altSession) throws Exception {
		boolean retVal = false;

		if (altSession == null) {
			throw new Exception(
					"Alternate designation session can not be NULL or empty.");
		}
		if (type == null || name == null) {
			throw new Exception(
					"Alternate designation name and/or type can not be NULL or empty.");
		}
		Alternates[] _alts = altSession.getAlternates();
		boolean typeMatched = false;
		boolean nameMatched = false;
		
		if (_alts != null) {
			for (Alternates alt : _alts) {
				String temp1 = alt.getType();
				if (type.trim().equals(temp1.trim())) {
					typeMatched = true;
				}
				String temp2 = alt.getName();
				if (name.trim().equals(temp2.trim())) {
					nameMatched = true;
				}
				if(typeMatched && nameMatched) {
					retVal = true;
				}
			}
		}

		return retVal;
	}
}
