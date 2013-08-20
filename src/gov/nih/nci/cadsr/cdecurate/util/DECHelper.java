package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.common.Constants;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;
import java.util.regex.MatchResult;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class DECHelper {

	//GF30798
	/**
	 * userSelectedDef matters only if it is adding AC; regeneration does not require it
	 * 
	 * @param request
	 * @param userSelectedDef
	 * @throws Exception
	 */
	public static void createFinalAlternateDefinition(HttpServletRequest request, String userSelectedDef) throws Exception {
		HttpSession session = request.getSession();
		String sComp = (String) request.getParameter("sCompBlocks");
		if (sComp == null) {
			sComp = (String) request.getAttribute("sCompBlocks1");	//from EditDEC.jsp
		}
		if (sComp == null) {
			sComp = "";
		}
		
		List objectQualifierMap = (ArrayList)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
		if(objectQualifierMap == null) {
			objectQualifierMap = new ArrayList();
		}
		List propertyQualifierMap = (ArrayList)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
		if(propertyQualifierMap == null) {
			propertyQualifierMap = new ArrayList();
		}
		String comp1 = null, comp2 = null, comp3 = null, comp4 = null;
		if(userSelectedDef != null) {
			if (sComp.equals("ObjectQualifier")) {
				objectQualifierMap.add(userSelectedDef);
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, objectQualifierMap);
			} else if (sComp.startsWith("Object")) {
				comp2 = userSelectedDef;
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2, comp2);
			} else if (sComp.equals("PropertyQualifier")) {
				propertyQualifierMap.add(userSelectedDef);
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3, propertyQualifierMap);
			} else if (sComp.startsWith("Prop")) {
				comp4 = userSelectedDef;
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4, comp4);
			}
		}
		comp1 = DECHelper.createOCQualifierDefinition(objectQualifierMap);
		comp2 = (String)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2);
		comp3 = DECHelper.createPropQualifierDefinition(propertyQualifierMap);
		comp4 = (String)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4);

		//logic to construct
		String finalString = "";
		if(comp1 != null) {
			finalString = comp1 + "_"; 
		}
		if(comp2 != null) {
			finalString = finalString + comp2 + "_"; 
		}
		if(comp3 != null && comp4 != null) {
			finalString = finalString + comp3 + "_" + comp4; 
		} else {
			if(comp3 != null) {
				finalString = finalString + comp3;
			} else {
				finalString = finalString + comp4;
			}
		}
		session.setAttribute(Constants.FINAL_ALT_DEF_STRING, DECHelper.trimTrailingEndingUnderscores(finalString));
	}
	
	/*
	 * Clear the DEC's alternate definition.
	 */
	public static void clearAlternateDefinition(HttpSession session) throws Exception {
		if(session != null) {
			session.setAttribute(Constants.FINAL_ALT_DEF_STRING, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1_COUNT, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2_COUNT, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3_COUNT, null);
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4_COUNT, null);
		} else {
			throw new Exception("Session is NULL or empty");
		}
	}

	/**
	 * Clear the alternate definition of the OC.
	 *
	 * @param session
	 */
	public static void clearAlternateDefinitionForOCQualifier(HttpServletRequest request) {
		String sSelRow = (String) request.getParameter("selObjQRow");
		if(sSelRow == null || sSelRow.trim().equals("")) {
			System.out.println("clearAlternateDefinitionForOCQualifier: sSelRow is NULL or empty (no row is selected), assumed the first row");
			sSelRow = "0";
		}
		Integer selectedIndex = new Integer(sSelRow);
		HttpSession session = request.getSession();
		List map = (ArrayList)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
		List newArray = new ArrayList();
		if(map != null) {
			for (int i = 0; i<map.size(); i++) {
			    if(i != selectedIndex.intValue()) {
			    	if(map.get(i) != null) {
			    		newArray.add(map.get(i));
			    	}
			    }
			}
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, newArray);
		}
	}
	
	public static void clearAlternateDefinitionForOC(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2, null);
	}
	
	/**
	 * Clear the alternate definition of the Prop.
	 *
	 * @param session
	 */
	public static void clearAlternateDefinitionForPropQualifier(HttpServletRequest request) {
		String sSelRow = (String) request.getParameter("selPropQRow");
		if(sSelRow == null || sSelRow.trim().equals("")) {
			System.out.println("clearAlternateDefinitionForPropQualifier: sSelRow is NULL or empty (no row is selected), assumed the first row");
			sSelRow = "0";
		}
		Integer selectedIndex = new Integer(sSelRow);
		HttpSession session = request.getSession();
		List map = (ArrayList)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
		List newArray = new ArrayList();
		if(map != null) {
			for (int i = 0; i<map.size(); i++) {
			    if(i != selectedIndex.intValue()) {
			    	if(map.get(i) != null) {
			    		newArray.add(map.get(i));
			    	}
			    }
			}
			session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3, newArray);
		}
	}
	
	public static void clearAlternateDefinitionForProp(HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4, null);
	}
	
	public static String trimTrailingEndingUnderscores(String def) {
		String retVal = def;
		
		if(def != null && def.trim().startsWith("_")) {
			retVal = retVal.trim().substring(1, def.length());
		}
		
		if(def != null && def.trim().endsWith("_")) {
			retVal = retVal.trim().substring(0, def.length()-1);
		}
		
		retVal = retVal.replaceAll("_null", "");
		retVal = retVal.replaceAll("null_", "");
		
		return retVal;
	}
	
	public static String createOCQualifierDefinition(List map) {
		String retVal = null;
		
		Iterator iter = map.iterator();
		int i = 0;
		while(iter.hasNext()) {
			String val = (String)iter.next();
			//System.out.println("key,val: " + key + "," + val);
			if(i == 0) {
				retVal = val;
			} else {
				retVal = retVal + "_" + val;
			}
			i++;
		}
		
		return retVal;
	}
	
	public static String createPropQualifierDefinition(List map) {
		String retVal = null;
		
		Iterator iter = map.iterator();
		int i = 0;
		while(iter.hasNext()) {
			String val = (String)iter.next();
			//System.out.println("key,val: " + key + "," + val);
			if(i == 0) {
				retVal = val;
			} else {
				retVal = retVal + "_" + val;
			}
			i++;
		}
		
		return retVal;
	}
	
	/**
	 * Decompose big string into individual components e.g. OC qualifier, OC, Prop qualifer, Prop
	 * @param altDef
	 * @return
	 */
	public static Object[] decompose(String altDef, int count1, int count2, int count3, int count4) {
		Object[] retVal = new Object[4];
		List objectQualifierMap = new ArrayList();
		String oc = null;
		List propQualifierMap = new ArrayList();
		String prop = null;

		if(altDef != null) {
			int total = count1 + count2 + count3 + count4;
			String input = altDef;	//"1 fish 2 fish red fish blue fish";
			Scanner s = new Scanner(input).useDelimiter("_");
			String def = null;
			try {
				for (int a=0; a<count1; a++) {
					def = s.next();
				    System.out.println("comp1="+ def);
				    objectQualifierMap.add(def);
				}
				retVal[0] = objectQualifierMap;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			try {
				if(count2 > 0) {
					def = s.next();
				    System.out.println("comp2="+ def);
				    oc = def;
					retVal[1] = oc;
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			try {
				for (int c=0; c<count3; c++) {
					def = s.next();
				    System.out.println("comp3="+ def);
				    propQualifierMap.add(def);
				}
				retVal[2] = propQualifierMap;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	
			try {
				if(count4 > 0) {
					def = s.next();
				    System.out.println("comp4="+ def);
				    prop = def;
					retVal[3] = prop;
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			s.close();
		}
		
		return retVal;
	}
	
}
