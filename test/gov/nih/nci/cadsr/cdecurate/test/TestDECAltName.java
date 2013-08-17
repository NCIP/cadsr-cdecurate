package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.cadsr.cdecurate.tool.AC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.AC_CONTACT_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACSearch;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;
import gov.nih.nci.cadsr.cdecurate.util.DECHelper;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;
import gov.nih.nci.cadsr.common.Constants;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import junit.framework.TestCase;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;

/**
 * Setup:
 * 
 * 1. sudo mkdir -p /local/content/cadsrsentinel/reports
 * 2. sudo touch /local/content/cadsrsentinel/reports/evstest1_log.txt
 * 3. sudo chmod 777 /local/content/cadsrsentinel/reports/evstest1_log.txt
 *
 */
public class TestDECAltName
{
    public static final Logger logger  = Logger.getLogger(CurationServlet.class.getName());
	UtilService m_util = new UtilService();
//	CurationServlet m_servlet = null;
    CurationServlet instance;	
//	public static HttpServletRequest  m_classReq       = null;
	public static HttpServletRequest  request       = null;		//GF30798
	public static HttpServletResponse m_classRes       = null;
	static HttpSession session = null;		//GF30798
    protected SetACService       m_setAC          = null;
    ServletConfig servletConfig = null;
    ServletContext servletContext = null;

	HashMap<Integer, String> objectQualifierMap = null;
	HashMap<Integer, String> propertyQualifierMap = null;
	String oc = null;
	String prop = null;
	  public static final String MOCK_SESSION_ID = "mock session id";
	  public static final String REMOTE_IP = "127.0.0.1";
	String userSelectedDefFinal = null;

	class MyHttpSession implements HttpSession {
		HashMap objectQualifierMap;
		HashMap propQualifierMap;
		String oc;
		String prop;
		
		@Override
		public Object getAttribute(String arg0) {
			Object retVal = null;
			
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
				retVal = objectQualifierMap;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
				retVal = oc;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
				retVal = propQualifierMap;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
				retVal = prop;
			} else
			if(arg0 != null && arg0.equals(Constants.FINAL_ALT_DEF_STRING)) {
				retVal = userSelectedDefFinal;
			}

			return retVal;
		}

		@Override
		public Enumeration getAttributeNames() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getCreationTime() {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public String getId() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public long getLastAccessedTime() {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public int getMaxInactiveInterval() {
			// TODO Auto-generated method stub
			return 0;
		}

		@Override
		public ServletContext getServletContext() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public HttpSessionContext getSessionContext() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public Object getValue(String arg0) {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public String[] getValueNames() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public void invalidate() {
			// TODO Auto-generated method stub
			
		}

		@Override
		public boolean isNew() {
			// TODO Auto-generated method stub
			return false;
		}

		@Override
		public void putValue(String arg0, Object arg1) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void removeAttribute(String arg0) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void removeValue(String arg0) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void setAttribute(String arg0, Object arg1) {
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
				objectQualifierMap = (HashMap)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
				oc = (String)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
				objectQualifierMap = (HashMap)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
				prop = (String)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.FINAL_ALT_DEF_STRING)) {
				userSelectedDefFinal = (String)arg1;
			}
		}

		@Override
		public void setMaxInactiveInterval(int arg0) {
			// TODO Auto-generated method stub
			
		}
		
	}
	
  public static void main(String[] args) throws Exception
  {
//	CurationTestLogger logger1 = new CurationTestLogger(TestDECAltName.class);
    // Initialize the Log4j environment.
    String logXML = "log4j.xml";
    if (args.length > 0)
    {
        logXML = args[0];
    }
//    logger.initLogger(logXML);
    //initialize connection
    String connXML = "";
    if (args.length > 1)
      connXML = args[1];
    
    TestDECAltName testdec = new TestDECAltName();    
    //testdec.test();

    //add and removals
    testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "minor");			//0
    testdec.testGF30798AddAltDef("Add one more oc qualifier", "ObjectQualifier", "major");		//1
    testdec.testGF30798RemoveAltDef("Remove the second oc qualifier", "ObjectQualifier", "1");
    testdec.testGF30798RemoveAltDef("Remove the first oc qualifier", "ObjectQualifier", "0");
    testdec.testGF30798RemoveAltDef("Add one prop qualifier", "PropertyQualifier", "blood");
    testdec.testGF30798RemoveAltDef("Remove the prop qualifier", "PropertyQualifier", "0");
    //clear it
    testdec.testGF30798ClearAltDef("Clear the alt def", null, null);
    //more add and removals
    testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "minor");			//0
    testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "major");			//1
    testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "major");			//2
    testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "minor");			//3
    testdec.testGF30798RemoveAltDef("Remove the second oc qualifier", "ObjectQualifier", "1");
    
	
  }

  //=== courtesy of https://opencast.jira.com/svn/MH/trunk/modules/matterhorn-usertracking-impl/src/test/java/org/opencastproject/usertracking/impl/UserTrackingRestServiceTest.java
  private HttpServletRequest getMockHttpSession() {
	  	if(session == null) {
	  		session = new MyHttpSession();	//EasyMock.createMock(HttpSession.class);
	  	}
//	    EasyMock.expect(session.getId()).andReturn(MOCK_SESSION_ID).anyTimes();
	    HttpServletRequest request = EasyMock.createMock(HttpServletRequest.class);
	    EasyMock.expect(request.getSession()).andReturn(session).anyTimes();
	    EasyMock.expect(request.getHeader("X-FORWARDED-FOR")).andReturn(null).anyTimes();
	    EasyMock.expect(request.getRemoteAddr()).andReturn(REMOTE_IP).anyTimes();
//	    EasyMock.replay(session, request);
	    return request;
	  }
  
  private HttpSession initEasyMock() {
	  	request = getMockHttpSession();

//	    EasyMock.expect(session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)).andReturn(EasyMock.isA(HashMap.class)).anyTimes();
//	    EasyMock.expect(session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)).andReturn(EasyMock.isA(String.class)).anyTimes();
//	    EasyMock.expect(session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)).andReturn(EasyMock.isA(HashMap.class)).anyTimes();
//	    EasyMock.expect(session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)).andReturn(EasyMock.isA(String.class)).anyTimes();
//	    EasyMock.expect(session.getAttribute("userSelectedDefFinal")).andReturn(EasyMock.isA(String.class)).anyTimes();
//	    
//	    session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, EasyMock.anyObject());
//	    session.setAttribute(EasyMock.eq(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2), EasyMock.isA(String.class));
//	    session.setAttribute(EasyMock.eq(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3), EasyMock.isA(HashMap.class));
//	    session.setAttribute(EasyMock.eq(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4), EasyMock.isA(String.class));
//		session.setAttribute(EasyMock.eq("userSelectedDefFinal"), EasyMock.anyObject());
//
//		session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
//	    session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2);
//	    session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
//	    session.removeAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4);
		
	    servletConfig = EasyMock.createMock(ServletConfig.class);
	    servletContext = EasyMock.createMock(ServletContext.class);
	    EasyMock.expect(servletConfig.getServletContext()).andReturn(servletContext).anyTimes();
	    
	    
		return session;
  }

  private void testGF30798AddAltDef(String message, String clickType, String userSelectedValue) throws Exception {
	    initEasyMock();
	  	System.out.println(message);
//	    EasyMock.expect(m_classReq.getParameter("pageAction")).andReturn("UseSelection");
//		EasyMock.expect(m_classReq.getParameter("MenuAction")).andReturn("editDEC");

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);

//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		createFinalAlternateDefinition(request, userSelectedValue);
		System.out.println("Final string = >>>" + session.getAttribute(Constants.FINAL_ALT_DEF_STRING) + "<<<");
		System.out.println("\n");
  }
  
  private void testGF30798RemoveAltDef(String message, String clickType, String userSelectedValue) throws Exception {
		initEasyMock();
	  	System.out.println(message);
//		EasyMock.expect(m_classReq.getParameter("pageAction")).andReturn("RemoveSelection");
//		EasyMock.expect(m_classReq.getParameter("MenuAction")).andReturn("editDEC");

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);
//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		createFinalAlternateDefinition(request, null);
		System.out.println("Final string = >>>" + session.getAttribute(Constants.FINAL_ALT_DEF_STRING) + "<<< ");
		System.out.println("\n");
  }
  
  private void testGF30798ClearAltDef(String message, String clickType, String userSelectedValue) throws Exception {
	    initEasyMock();
	  	System.out.println(message);
//	    EasyMock.expect(m_classReq.getParameter("pageAction")).andReturn("clearBoxes");
//		EasyMock.expect(m_classReq.getParameter("MenuAction")).andReturn("editDEC");

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);
//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		DECHelper.clearAlternateDefinition(session);

		System.out.println("Final string = >>>" + session.getAttribute(Constants.FINAL_ALT_DEF_STRING) + "<<< ");
		System.out.println("\n");
  }

  /**
   * ==================================================================================================================
   * The following are the real methods copied from the application methods
   * ==================================================================================================================
   */
  //begin GF30798
	private void createFinalAlternateDefinition(HttpServletRequest request, String userSelectedDef) throws Exception {
		HttpSession session = request.getSession();
		String sComp = (String) request.getParameter("sCompBlocks");
		if (sComp == null)
			sComp = "";
	//		String sSelRow = "";
	//		sSelRow = (String) request.getParameter("selCompBlockRow");
	//		Integer rowIndex = null;
	//		if(sSelRow != null && !sSelRow.startsWith("CK")) {
	//			throw new Exception("Can not get the row index from the front end for alternate defintion!");
	//		} else {
	//			rowIndex = new Integer(sSelRow.substring(2, sSelRow.length()));
	//		}
		objectQualifierMap = (HashMap<Integer, String>)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1);
		if(objectQualifierMap == null) {
			objectQualifierMap = new HashMap<Integer, String>();
		}
		propertyQualifierMap = (HashMap<Integer, String>)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3);
		if(propertyQualifierMap == null) {
			propertyQualifierMap = new HashMap<Integer, String>();
		}
		String comp1 = null, comp2 = null, comp3 = null, comp4 = null;
	//		if(userSelectedDef != null) {
			if (sComp.equals("ObjectQualifier")) {
				objectQualifierMap.put(objectQualifierMap.size(), userSelectedDef);
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1, objectQualifierMap);
			} else if (sComp.startsWith("Object")) {
				comp2 = userSelectedDef;
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2, comp2);
			} else if (sComp.equals("PropertyQualifier")) {
				propertyQualifierMap.put(propertyQualifierMap.size(), userSelectedDef);
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3, propertyQualifierMap);
			} else if (sComp.startsWith("Prop")) {
				comp4 = userSelectedDef;
				session.setAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4, comp4);
			}
	//		}
		comp1 = createOCQualifierDefinition(objectQualifierMap);
		comp2 = oc;	//(String)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2);
		comp3 = createPropQualifierDefinition(propertyQualifierMap);
		comp4 = prop;	//(String)session.getAttribute(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4);
		String finalStr = trimTrailingEndingUnderscores(comp1 + "_" + comp2 + "_" + comp3 + "_" + comp4);
		session.setAttribute(Constants.FINAL_ALT_DEF_STRING, finalStr);
	}

	private String trimTrailingEndingUnderscores(String def) {
		String retVal = def;
		
		if(def != null && def.trim().startsWith("_")) {
			retVal = retVal.trim().substring(1, def.length());
		}
		
		if(def != null && def.trim().endsWith("_")) {
			retVal = retVal.trim().substring(0, def.length()-1);
		}
		
		return retVal;
	}
	
	private String createOCQualifierDefinition(HashMap map) {
		String retVal = null;
		
		Iterator iter = map.keySet().iterator();
		while(iter.hasNext()) {
			Integer key = (Integer)iter.next();
			String val = (String)map.get(key);
			//System.out.println("key,val: " + key + "," + val);
			if(key == 0) {
				retVal = val;
			} else {
				retVal = retVal + "_" + val;
			}
		}
		
		return retVal;
	}
	
	private String createPropQualifierDefinition(HashMap map) {
		String retVal = null;
		
		Iterator iter = map.keySet().iterator();
		while(iter.hasNext()) {
			Integer key = (Integer)iter.next();
			String val = (String)map.get(key);
			//System.out.println("key,val: " + key + "," + val);
			if(key == 0) {
				retVal = val;
			} else {
				retVal = retVal + "_" + val;
			}
		}
		
		return retVal;
	}
  //end GF30798

}


