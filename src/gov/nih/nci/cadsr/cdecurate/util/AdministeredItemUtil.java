/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;

import java.io.BufferedReader;
import java.io.BufferedReader;
import java.text.CharacterIterator;
import java.text.StringCharacterIterator;
import java.util.Vector;

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
	
	public static boolean isSimilarPV(PV_Bean pv1, PV_Bean pv2) {
		boolean retVal = false;
		boolean isSimilar1, isSimilar2;
		StringBuffer pv1string, pv2string;
		
		//GF33185 constructing the new CDR string
		String n1 = constructCDRName(pv1);
		String n2 = constructCDRName(pv2);

		//=== check 1 by CDR name
		System.out.println("\nAdministeredItemUtil:isSimilarPV comparing [" + n1 + "] with [" + n2 + "]");
		if(!n1.equals(n2)) {
			isSimilar1 = false;
			System.out.println("AdministeredItemUtil:isSimilarPV 1 different!");
		} else {
			isSimilar1 = true;
			System.out.println("AdministeredItemUtil:isSimilarPV 1 similar!");
		}

		//=== check 2 by vm desc/def
		String vmDesc1 = "";
		if(pv1 != null && pv1.getPV_VM() != null) {
			vmDesc1 = pv1.getPV_VM().getVM_PREFERRED_DEFINITION();
		}
		String vmDesc2 = "";
		if(pv2 != null && pv2.getPV_VM() != null) {
			vmDesc2 = pv2.getPV_VM().getVM_PREFERRED_DEFINITION();
		}
		if(vmDesc1 != null && vmDesc2 != null && !vmDesc1.equals(vmDesc2)) {
			isSimilar2 = false;
			System.out.println("AdministeredItemUtil:isSimilarPV 2 different!");
		} else {
			isSimilar2 = true;
			System.out.println("AdministeredItemUtil:isSimilarPV 2 similar!");
		}
		
		//=== final check
		if(isSimilar1 && isSimilar2) {
			retVal = true;
		}
		System.out.println("AdministeredItemUtil:isSimilarPV returning " + retVal);
		
		return retVal;
	}

	private static String constructCDRName(PV_Bean pv) {
		String cdrName = "";
		if(pv != null && pv.getPV_VM() != null) {
			VM_Bean vm = pv.getPV_VM();
			Vector<EVS_Bean> nameCon = vm.getVM_CONCEPT_LIST();
			if (nameCon.size() > 0)
			{
				for (int i = 0; i < nameCon.size(); i++) {
					EVS_Bean nBean = nameCon.elementAt(i);
					//=== construct the concepts based on the ID and the source
					cdrName += nBean.getCONCEPT_IDENTIFIER() + ":" + nBean.getEVS_DATABASE();
				}
			}
			System.out.println("AdministeredItemUtil:constructCDRName Concepts size of pv [" + pv.getPV_VALUE() + "] vm [" + vm.getVM_LONG_NAME() + "] vm def [" + vm.getVM_PREFERRED_DEFINITION() + "] = " + vm.getVM_CONCEPT_LIST().size() + " CDR name [" + cdrName + "]");
		}
		
		return cdrName;
	}

}

