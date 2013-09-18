package gov.nih.nci.cadsr.cdecurate.test;

import static org.junit.Assert.*;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;
import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;
import gov.nih.nci.cadsr.cdecurate.util.DECHelper;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;
import gov.nih.nci.cadsr.common.Constants;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;
import org.junit.Test;

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

	List objectQualifierMap = null;
	List propertyQualifierMap = null;
	String oc = null;
	String prop = null;
	  public static final String MOCK_SESSION_ID = "mock session id";
	  public static final String REMOTE_IP = "127.0.0.1";
	String userSelectedDefFinal = null;

	class MyHttpSession implements HttpSession {
		private List objectQualifierMap;
		private List propQualifierMap;
		private String oc;
		private String prop;
		
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
				objectQualifierMap = (ArrayList)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
				oc = (String)arg1;
			} else
			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
				propQualifierMap = (ArrayList)arg1;
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
	
	@Test
	public void handleUserSelectedAlternateDefinition() throws Exception {
		Alternates[] _alts = new Alternates[3];
		for(int i = 0; i < _alts.length ; i++) _alts[i] = new Alternates();
		_alts[0].setName("Def 1");
		_alts[1].setName("Def 2");
		_alts[2].setName("Def 3");
		AltNamesDefsSession altSession = new AltNamesDefsSession(_alts);

		assertTrue(AdministeredItemUtil.isAlternateDefinitionExists("Def 1", altSession));
		assertTrue(AdministeredItemUtil.isAlternateDefinitionExists("Def 3", altSession));
		assertFalse(AdministeredItemUtil.isAlternateDefinitionExists("Def 112", altSession));
		assertFalse(AdministeredItemUtil.isAlternateDefinitionExists("Def", altSession));
		assertTrue(AdministeredItemUtil.isAlternateDefinitionExists("Def 2", altSession));
		assertTrue(AdministeredItemUtil.isAlternateDefinitionExists("Def 3", altSession));	
	}
		
//  @Test
  public void runDecomposeTest() {
	  //created specifically for GF30798 editing of DEC
	  Object stat[] = null;

	  String altDef = "oc q 1_oc q 2_oc q 3_oc 1_prop q 1_prop q 2_prop 1";
	  int count1 = 3;	//3 oc qualifiers
	  int count2 = 1;	//1 oc
	  int count3 = 2;	//2 prop qualifiers
	  int count4 = 1;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 3);
	  assertNotNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNotNull((String)(stat[3]));
	  System.out.println("\n");
	  
	  altDef = "oc q 1_oc q 2_oc 1_prop q 1_prop q 2_prop 1";
	  count1 = 2;	//2 oc qualifiers
	  count2 = 1;	//1 oc
	  count3 = 2;	//2 prop qualifiers
	  count4 = 1;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 2);
	  assertNotNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNotNull((String)(stat[3]));
	  System.out.println("\n");

	  altDef = "oc q 1_oc q 2_prop q 1_prop q 2_prop 1";
	  count1 = 2;	//2 oc qualifiers
	  count2 = 0;	//1 oc
	  count3 = 2;	//2 prop qualifiers
	  count4 = 1;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 2);
	  assertNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNotNull((String)(stat[3]));
	  System.out.println("\n");

	  altDef = "oc q 1_oc q 2_prop q 1_prop q 2";
	  count1 = 2;	//2 oc qualifiers
	  count2 = 0;	//1 oc
	  count3 = 2;	//2 prop qualifiers
	  count4 = 0;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 2);
	  assertNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNull((String)(stat[3]));
	  System.out.println("\n");

	  altDef = "oc q 1_prop q 1_prop q 2";
	  count1 = 1;	//2 oc qualifiers
	  count2 = 0;	//1 oc
	  count3 = 2;	//2 prop qualifiers
	  count4 = 0;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 1);
	  assertNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNull((String)(stat[3]));
	  System.out.println("\n");

	  altDef = "prop q 1_prop q 2";
	  count1 = 0;	//2 oc qualifiers
	  count2 = 0;	//1 oc
	  count3 = 2;	//2 prop qualifiers
	  count4 = 0;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 0);
	  assertNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 2);
	  assertNull((String)(stat[3]));
	  System.out.println("\n");

	  altDef = "oc q 1_oc q 2_oc q 3_oc q 4_prop 1";
	  count1 = 4;	//2 oc qualifiers
	  count2 = 0;	//1 oc
	  count3 = 0;	//2 prop qualifiers
	  count4 = 1;	//1 prop
	  stat = DECHelper.decompose(altDef, count1, count2, count3, count4);
	  assertEquals(((ArrayList)(stat[0])).size(), 4);
	  assertNull((String)(stat[1]));
	  assertEquals(((ArrayList)(stat[2])).size(), 0);
	  assertNotNull((String)(stat[3]));
	  System.out.println("\n");
	 
  }
  
  @Test
  public void runTest() throws Exception
  {
    TestDECAltName testdec = new TestDECAltName();    
    String status = null;
    //add and removals
    status = testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "oc qual 0");
	assertEquals(status, "oc qual 0");
    status = testdec.testGF30798AddAltDef("Add one more oc qualifier", "ObjectQualifier", "oc qual 1");		//1
	assertEquals(status, "oc qual 0_oc qual 1");
    status = testdec.testGF30798RemoveAltDef("Remove the second oc qualifier", "ObjectQualifier", "1");
	assertEquals(status, "oc qual 0");
    status = testdec.testGF30798RemoveAltDef("Remove the first oc qualifier", "ObjectQualifier", "0");
	assertNull(status, null);
    status = testdec.testGF30798AddAltDef("Add one prop qualifier", "PropertyQualifier", "prop qual 0");
	assertEquals(status, "prop qual 0");
    status = testdec.testGF30798RemoveAltDef("Remove the prop qualifier", "PropertyQualifier", "0");
	assertNull(status, null);
    status = testdec.testGF30798AddAltDef("Add one prop", "Prop", "prop 0");
	assertEquals(status, "prop 0");
    status = testdec.testGF30798RemoveAltDef("Remove the prop", "Property", "0");
	assertNull(status, null);
    //clear it
    status = testdec.testGF30798ClearAltDef("Clear the alt def", null, null);
	assertNull(status, null);
    //more add and removals
    status = testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "oc q 0");			//0
	assertEquals(status, "oc q 0");
    status = testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "oc q 1");			//1
	assertEquals(status, "oc q 0_oc q 1");
    status = testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "oc q 1");			//2
	assertEquals(status, "oc q 0_oc q 1_oc q 1");
    status = testdec.testGF30798AddAltDef("Add one oc qualifier", "ObjectQualifier", "oc q 2");			//3
	assertEquals(status, "oc q 0_oc q 1_oc q 1_oc q 2");
    status = testdec.testGF30798RemoveAltDef("Remove the second oc qualifier (first oc q 1)", "ObjectQualifier", "1");
	assertEquals(status, "oc q 0_oc q 1_oc q 2");
    status = testdec.testGF30798AddAltDef("Add one prop", "Prop", "prop 0");
	assertEquals(status, "oc q 0_oc q 1_oc q 2_prop 0");
    status = testdec.testGF30798AddAltDef("Add second prop", "Prop", "prop 1");
	assertEquals(status, "oc q 0_oc q 1_oc q 2_prop 1");
    status = testdec.testGF30798AddAltDef("Add third prop", "Prop", "prop 2");
	assertEquals(status, "oc q 0_oc q 1_oc q 2_prop 2");
    status = testdec.testGF30798AddAltDef("Add one oc", "Object", "oc 0");			//0
	assertEquals(status, "oc q 0_oc q 1_oc q 2_oc 0_prop 2");
    status = testdec.testGF30798AddAltDef("Add second oc", "Object", "oc 1");		//1
	assertEquals(status, "oc q 0_oc q 1_oc q 2_oc 1_prop 2");
    status = testdec.testGF30798AddAltDef("Add 1 prop qualifier", "PropertyQualifier", "prop qual 0");    
	assertEquals(status, "oc q 0_oc q 1_oc q 2_oc 1_prop qual 0_prop 2");
    status = testdec.testGF30798RemoveAltDef("Remove the first oc  (first oc 0)", "ObjectClass", "0");
	assertEquals(status, "oc q 0_oc q 1_oc q 2_prop qual 0_prop 2");
    status = testdec.testGF30798ClearAltDef("Clear the alt def", null, null);
	assertNull(status, null);
    //no one each
    status = testdec.testGF30798AddAltDef("Add 1 oc qualifier", "ObjectQualifier", "oc qual 0");			//0
	assertEquals(status, "oc qual 0");
    status = testdec.testGF30798AddAltDef("Add 1 oc", "Object", "oc 0");			//0
	assertEquals(status, "oc qual 0_oc 0");
    status = testdec.testGF30798AddAltDef("Add 1 prop qualifier", "PropertyQualifier", "prop qual 0");
	assertEquals(status, "oc qual 0_oc 0_prop qual 0");
    status = testdec.testGF30798AddAltDef("Add 1 prop", "Prop", "prop 0");
	assertEquals(status, "oc qual 0_oc 0_prop qual 0_prop 0");
		
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

  private String testGF30798AddAltDef(String message, String clickType, String userSelectedValue) throws Exception {
	    initEasyMock();
	  	System.out.println(message);
	    EasyMock.expect(request.getParameter("pageAction")).andReturn("UseSelection");
		EasyMock.expect(request.getParameter("MenuAction")).andReturn("editDEC");

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);

//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		DECHelper.createFinalAlternateDefinition(request, userSelectedValue);
		String retVal = (String)session.getAttribute(Constants.FINAL_ALT_DEF_STRING);
		System.out.println("Final string = >>>" + retVal + "<<<");
		System.out.println("\n");
		
		return retVal;
  }
  
  private String testGF30798RemoveAltDef(String message, String clickType, String userSelectedValue) throws Exception {
		initEasyMock();
	  	System.out.println(message);
		EasyMock.expect(request.getParameter("pageAction")).andReturn("RemoveSelection");
		EasyMock.expect(request.getParameter("MenuAction")).andReturn("editDEC");
		if(clickType != null && clickType.equals("ObjectQualifier")) {
			EasyMock.expect(request.getParameter("selObjQRow")).andReturn(userSelectedValue);	//index to delete
		} else {
			EasyMock.expect(request.getParameter("selPropQRow")).andReturn(userSelectedValue);	//index to delete
		}

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);
//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		if(clickType != null && clickType.equals("ObjectQualifier")) {
			DECHelper.clearAlternateDefinitionForOCQualifier(request);
		} else
		if(clickType != null && clickType.equals("ObjectClass")) {
			DECHelper.clearAlternateDefinitionForOC(request);
		} else
		if(clickType != null && clickType.equals("PropertyQualifier")) {
			DECHelper.clearAlternateDefinitionForPropQualifier(request);
		} else
		if(clickType != null && (clickType.equals("Property") || clickType.equals("PropertyClass"))) {
			DECHelper.clearAlternateDefinitionForProp(request);
		}
		
		DECHelper.createFinalAlternateDefinition(request, null);
		String retVal = (String)session.getAttribute(Constants.FINAL_ALT_DEF_STRING);
		System.out.println("Final string = >>>" + retVal + "<<< ");
		System.out.println("\n");
		
		return retVal;
  }
  
  private String testGF30798ClearAltDef(String message, String clickType, String userSelectedValue) throws Exception {
	    initEasyMock();
	  	System.out.println(message);
	    EasyMock.expect(request.getParameter("pageAction")).andReturn("clearBoxes");
//		EasyMock.expect(request.getParameter("MenuAction")).andReturn("editDEC");

		EasyMock.expect(request.getParameter("sCompBlocks")).andReturn(clickType);
//	    EasyMock.replay(session, request);
	    EasyMock.replay(request);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

		DECHelper.clearAlternateDefinition(session, null);

		String retVal = (String)session.getAttribute(Constants.FINAL_ALT_DEF_STRING);
		System.out.println("Final string = >>>" + retVal + "<<< ");
		System.out.println("\n");

		return retVal;
  }

}