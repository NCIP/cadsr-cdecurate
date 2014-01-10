/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/testdec.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

//import gov.nih.nci.cadsr.cdecurate.test.CurationTestLogger;
import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.cdecurate.tool.AC_CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptAction;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptForm;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVSSearch;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_UserBean;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.tool.VMForm;
import gov.nih.nci.cadsr.cdecurate.tool.ValidationStatusBean;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.InvalidPropertiesFormatException;
import java.util.List;
import java.util.Properties;
import java.util.Vector;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;

/**
 * @author shegde
 * 
 */
public class TestPLSQL {
	private static TestConnections varCon;
	static TestPLSQL testdec;
	public static final Logger logger = Logger.getLogger(CurationServlet.class
			.getName());
	UtilService m_util = new UtilService();
	CurationServlet m_servlet = null;
	public static HttpServletRequest  m_classReq       = null;
	public static HttpServletResponse m_classRes       = null;

	public static final String REMOTE_IP = "127.0.0.1";
	static HttpSession session = null;

	  private HttpServletRequest getMockHttpSession() {
		  	if(session == null) {
		  		session = new MyHttpSession();	//EasyMock.createMock(HttpSession.class);
		  	}
//		    EasyMock.expect(session.getId()).andReturn(MOCK_SESSION_ID).anyTimes();
		    HttpServletRequest request = EasyMock.createMock(HttpServletRequest.class);
		    EasyMock.expect(request.getSession()).andReturn(session).anyTimes();
		    EasyMock.expect(request.getHeader("X-FORWARDED-FOR")).andReturn(null).anyTimes();
		    EasyMock.expect(request.getRemoteAddr()).andReturn(REMOTE_IP).anyTimes();
//		    EasyMock.replay(session, request);
		    return request;
	  }
	  
		class MyHttpSession implements HttpSession {
			private List objectQualifierMap;
			private List propQualifierMap;
			private String oc;
			private String prop;
			
			@Override
			public Object getAttribute(String arg0) {
				Object retVal = null;
				
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
//					retVal = objectQualifierMap;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
//					retVal = oc;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
//					retVal = propQualifierMap;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
//					retVal = prop;
//				} else
				if(arg0 != null && arg0.equals("defaultContext")) {
					retVal = new HashMap<String, String>();
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
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
//					objectQualifierMap = (ArrayList)arg1;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
//					oc = (String)arg1;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
//					propQualifierMap = (ArrayList)arg1;
//				} else
//				if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
//					prop = (String)arg1;
//				} else
//				if(arg0 != null && arg0.equals(Constants.FINAL_ALT_DEF_STRING)) {
//					userSelectedDefFinal = (String)arg1;
//				}
			}

			@Override
			public void setMaxInactiveInterval(int arg0) {
				// TODO Auto-generated method stub
				
			}
			
		}
		
	public TestPLSQL() {
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CurationTestLogger logger1 = new CurationTestLogger(TestPLSQL.class);
		// Initialize the Log4j environment.
		String logXML = "log4j.xml";
		if (args.length > 0) {
			logXML = args[0];
		}
		// initialize connection
		String connXML = "";
		if (args.length > 1)
			connXML = args[1];

		testdec = new TestPLSQL();
		testdec.testDataElementConceptServlet(testdec, connXML, logger1);
	}

	public void testDataElementConceptServlet(TestPLSQL testdec, String connXML,
			CurationTestLogger logger1) {
	    initEasyMock();

		varCon = new TestConnections(connXML, logger1);
		testdec.m_servlet = new CurationServlet();
		testdec.m_servlet.sessionData = new Session_Data();
		testdec.m_servlet.sessionData.EvsUsrBean = new EVS_UserBean();
		
		try {
			testdec.m_servlet.setConn(varCon.openConnection());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		Vector vObjectClass = new Vector();	//(Vector) session.getAttribute("vObjectClass");
		
		
	}

	  private HttpSession initEasyMock() {
		  	m_classReq = getMockHttpSession();
		  	
			return session;
	  }
	  
}
