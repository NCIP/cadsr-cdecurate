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
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.InvalidPropertiesFormatException;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.easymock.EasyMock;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;







//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;
import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.cdecurate.tool.AC_CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptAction;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptForm;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DataElementConceptServlet;
import gov.nih.nci.cadsr.cdecurate.tool.EVSSearch;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_UserBean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACService;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.TOOL_OPTION_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.tool.VMAction;
import gov.nih.nci.cadsr.cdecurate.tool.VMForm;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ValidationStatusBean;
import gov.nih.nci.cadsr.common.Constants;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import gov.nih.nci.cadsr.cdecurate.tool.ConceptAction;
import gov.nih.nci.cadsr.cdecurate.tool.ConceptForm;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VMAction;
import gov.nih.nci.cadsr.cdecurate.tool.VMForm;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;
import gov.nih.nci.cadsr.cdecurate.util.DownloadHelper;

//import gov.nih.nci.cadsr.cdecurate.test.CurationTestLogger;

/**
 *	Setup:
 *	
 *	Change the user id and password in DBConnection.xml before running this.
 *
 *	To run:
 *
 *	TestGF33095 DBConnection.xml
 */
public class TestGF33095 {
	static TestGF33095 testCustomDownload;
	public static final Logger logger = Logger.getLogger(CurationServlet.class
			.getName());
	UtilService m_util = new UtilService();
	CurationServlet m_servlet = null;
	private TestConnections varCon;
	private HttpServletRequest m_classReq;
	private HttpServletResponse m_classRes;

	public static final String REMOTE_IP = "127.0.0.1";
	static HttpSession session = null;

	  private void initMockHttpSession() {
		  	if(session == null) {
		  		session = new MyHttpSession();	//EasyMock.createMock(HttpSession.class);
		  	}
//		    EasyMock.expect(session.getId()).andReturn(MOCK_SESSION_ID).anyTimes();
		    m_classReq = EasyMock.createMock(HttpServletRequest.class);
		    m_classRes = EasyMock.createMock(HttpServletResponse.class);
		    EasyMock.expect(m_classReq.getSession()).andReturn(session).anyTimes();
		    EasyMock.expect(m_classReq.getHeader("X-FORWARDED-FOR")).andReturn(null).anyTimes();
		    EasyMock.expect(m_classReq.getRemoteAddr()).andReturn(REMOTE_IP).anyTimes();
//		    EasyMock.replay(session, m_classReq);
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
		
	public void doGF33095(TestGF33095 self, String connXML,
			CurationTestLogger logger1) throws Exception {
	    initEasyMock();

		varCon = new TestConnections(connXML, logger1);
		self.m_servlet = new CurationServlet();
		self.m_servlet.sessionData = new Session_Data();
		self.m_servlet.sessionData.EvsUsrBean = new EVS_UserBean();
//		m_classReq.se = session;
		
		try {
			self.m_servlet.setConn(varCon.openConnection());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		DownloadHelper.setDownloadIDs(null, null, "CDE",false);
		DownloadHelper.setColHeadersAndTypes(null, null, varCon.openConnection(), "CDE");
		ArrayList<String[]> allRows = DownloadHelper.getRecords(m_classReq, m_classRes, varCon.openConnection(), true, false);
		DownloadHelper.createDownloadColumns(null, null, allRows);
	}

	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		CurationTestLogger logger1 = new CurationTestLogger(TestDEC.class);
		// Initialize the Log4j environment.
		String logXML = "log4j.xml";
		if (args.length > 0) {
			logXML = args[0];
		}
		// initialize connection
		String connXML = "";
		if (args.length > 1)
			connXML = args[1];

		testCustomDownload = new TestGF33095();
		try {
			testCustomDownload.doGF33095(testCustomDownload, connXML, logger1);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	  private HttpSession initEasyMock() {
		  	initMockHttpSession();
		  	
//			servletConfig = EasyMock.createMock(ServletConfig.class);
//			servletContext = EasyMock.createMock(ServletContext.class);
//			EasyMock.expect(servletConfig.getServletContext()).andReturn(servletContext).anyTimes();
		    
			return session;
	  }
	  

}
