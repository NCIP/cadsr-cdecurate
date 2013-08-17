package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.common.Constants;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class DECHelper {

	/*
	 * Clear the DEC's alternate definition.
	 */
	public static void clearAlternateDefinition(HttpSession session) throws Exception {
		if(session != null) {
			session.setAttribute("userSelectedDefFinal", "");
			session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
			session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2);
			session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
			session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4);
		} else {
			throw new Exception("Session is NULL or empty");
		}
	}

	/**
	 * Clear the alternate definition of the OC.
	 *
	 * @param session
	 */
	public static void clearAlternateDefinitionForOC(HttpServletRequest request) {
		String sSelRow = (String) request.getParameter("selObjQRow");
		Integer selectedIndex = new Integer(sSelRow);
		HttpSession session = request.getSession();
		HashMap<Integer, String> map = (HashMap<Integer, String>)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
		Iterator iter = map.entrySet().iterator();
		Entry<Integer, String> entry = null;
		while (iter.hasNext()) {
		    entry = (Entry<Integer, String>) iter.next();
		    if(entry.getKey().intValue() == selectedIndex.intValue()) {
		        iter.remove();
		    }
		}
		session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, map);
	}
	
	/**
	 * Clear the alternate definition of the Prop.
	 *
	 * @param session
	 */
	public static void clearAlternateDefinitionForProp(HttpServletRequest request) {
		String sSelRow = (String) request.getParameter("selObjQRow");
		Integer selectedIndex = new Integer(sSelRow);
		HttpSession session = request.getSession();
		HashMap<Integer, String> map = (HashMap<Integer, String>)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
		Iterator iter = map.entrySet().iterator();
		Entry<Integer, String> entry = null;
		while (iter.hasNext()) {
		    entry = (Entry<Integer, String>) iter.next();
		    if(entry.getKey() == selectedIndex) {
		        iter.remove();
		    }
		}
		session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3, map);
	}
	
	public static String trimTrailingEndingUnderscores(String def) {
		String retVal = def;
		
		if(def != null && def.trim().startsWith("_")) {
			retVal = retVal.trim().substring(1, def.length());
		}
		
		if(def != null && def.trim().endsWith("_")) {
			retVal = retVal.trim().substring(0, def.length()-1);
		}
		
		return retVal;
	}
	
}
