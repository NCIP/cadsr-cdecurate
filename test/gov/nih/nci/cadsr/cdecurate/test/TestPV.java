package gov.nih.nci.cadsr.cdecurate.test;

import static org.junit.Assert.*;
import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.test.TestDECAltName.MyHttpSession;
import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_UserBean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACService;
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;
import gov.nih.nci.cadsr.cdecurate.util.AdministeredItemUtil;
import gov.nih.nci.cadsr.cdecurate.util.DECHelper;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;
import gov.nih.nci.cadsr.common.Constants;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionContext;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
import org.junit.BeforeClass;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;
import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

/**
 *	Test basic functionalities of PV creation, retrieving, deletion and update.
 *
 *	Setup:
 *
 *	1. Edit test/DBConnection.xml with the proper user id and password
 *	2. Run it
 */
public class TestPV
{
    public static final Logger logger  = Logger.getLogger(CurationServlet.class.getName());
	private static Connection conn = null;
    UtilService m_util = new UtilService();
    public static CurationServlet m_servlet = null;
    CurationServlet instance;	
	public static HttpServletRequest  m_classReq       = null;
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

	@BeforeClass
	public static void init() {
		CurationTestLogger logger1 = new CurationTestLogger(TestPV.class);
		// Initialize the Log4j environment.
		String logXML = "log4j.xml";
		// initialize connection
		String connXML = "DBConnection.xml";
	
		TestConnections varCon = new TestConnections(connXML, logger1);
		try {
			conn = varCon.openConnection();
			m_classReq = new MockHttpServletRequest();
			m_classRes = new MockHttpServletResponse();
			
			m_servlet = new CurationServlet();
//			m_servlet.sessionData = new Session_Data();
//			m_servlet.sessionData.EvsUsrBean = new EVS_UserBean();
	        m_servlet.setConn(conn);
		} catch (Exception e) {
			e.printStackTrace();
		}
        System.out.println("connected and initialized");
	}

	@Test
	public void testGF33185() {
		//same PV, should be true
		assertTrue(AdministeredItemUtil.isSimilarPV(null, null));

		//different PV, should be false
		String pvId = "F1C23491-BDC3-D439-E040-BB89A7B45E84";
		String pvValue = "PV1";
		String beginDateStr = "1/1/1970";
		String endDateStr = "1/1/1970";
		String shortMeaningDesc = "Short meaning description ...";
		String pvCD = "cd_name";
		String cdrId = "F37D0428-B99E-6787-E034-0003BA3F9857";
		String evsDB = "caDSR";
		PV_Bean pv1 = createPVBean(pvId, pvValue, beginDateStr, endDateStr, shortMeaningDesc, pvCD, cdrId, evsDB);
		pvId = "F1C23491-BDC3-D439-E040-BB89A7B45E84";
		pvValue = "PV1";
		beginDateStr = "1/1/1970";
		endDateStr = "1/1/1970";
		shortMeaningDesc = "Short meaning description 2 ...";
		pvCD = "cd_name";
		cdrId = "F37D0428-B99E-6787-E034-0003BA3F9857";
		evsDB = "caDSR";
		PV_Bean pv2 = createPVBean(pvId, pvValue, beginDateStr, endDateStr, shortMeaningDesc, pvCD, cdrId, evsDB);
		assertTrue(AdministeredItemUtil.isSimilarPV(pv1, pv2));

	
	}
	
	private PV_Bean createPVBean(String pvId, String pvValue, String beginDateStr, String endDateStr, String shortMeaningDesc, String pvCD, String cdrId, String evsDB) {
        PV_Bean pvBean1 = new PV_Bean();
        pvBean1.setPV_PV_IDSEQ(pvId);	//(rs.getString("pv_idseq"));
        pvBean1.setPV_VALUE(pvValue);	//rs.getString("value"));
        pvBean1.setPV_BEGIN_DATE(beginDateStr);	//s);
        pvBean1.setPV_END_DATE(endDateStr);	//s);
        pvBean1.setPV_MEANING_DESCRIPTION(shortMeaningDesc);	//rs.getString("vm_description"));
        //=== add the CD name and version in decimal number together
        pvBean1.setPV_CONCEPTUAL_DOMAIN(pvCD);	//rs.getString("cd_name"));
        //=== get vm concept attributes
        String sCondr = cdrId;	//rs.getString("condr_idseq");
        VM_Bean vm = new VM_Bean();
        vm.setVM_CONDR_IDSEQ(sCondr);	//hint: select * from CABIO_CON_DER_RULES_VIEW where rownum < 11
        EVS_Bean vmConcept = new EVS_Bean();
        vmConcept.setCONDR_IDSEQ(sCondr);
        if (sCondr != null && !sCondr.equals(""))
        {
            GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
            Vector vConList = getAC.getAC_Concepts(sCondr, null, true);
            if (vConList != null && vConList.size() > 0)
            {
                vmConcept = (EVS_Bean) vConList.elementAt(0);
                vm.setVM_CONCEPT_LIST(vConList);
            }
        }
        pvBean1.setVM_CONCEPT(vmConcept);
        pvBean1.setPV_VM(vm);
        //=== get database attribute
        pvBean1.setPV_EVS_DATABASE(evsDB);
        
        return pvBean1;
	}
	
	
	class MyHttpSession implements HttpSession {
		private List objectQualifierMap;
		private List propQualifierMap;
		private String oc;
		private String prop;
		
		@Override
		public Object getAttribute(String arg0) {
			Object retVal = null;
			
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
//				retVal = objectQualifierMap;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
//				retVal = oc;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
//				retVal = propQualifierMap;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
//				retVal = prop;
//			} else
//			if(arg0 != null && arg0.equals(Constants.FINAL_ALT_DEF_STRING)) {
//				retVal = userSelectedDefFinal;
//			}

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
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP1)) {
//				objectQualifierMap = (ArrayList)arg1;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP2)) {
//				oc = (String)arg1;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP3)) {
//				propQualifierMap = (ArrayList)arg1;
//			} else
//			if(arg0 != null && arg0.equals(Constants.USER_SELECTED_ALTERNATE_DEF_COMP4)) {
//				prop = (String)arg1;
//			} else
//			if(arg0 != null && arg0.equals(Constants.FINAL_ALT_DEF_STRING)) {
//				userSelectedDefFinal = (String)arg1;
//			}
		}

		@Override
		public void setMaxInactiveInterval(int arg0) {
			// TODO Auto-generated method stub
			
		}
		
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

	  	if(session == null) {
	  		session = new MyHttpSession();	//EasyMock.createMock(HttpSession.class);
	  	}
//	    EasyMock.expect(session.getId()).andReturn(MOCK_SESSION_ID).anyTimes();
	    HttpServletRequest request = EasyMock.createMock(HttpServletRequest.class);
	    EasyMock.expect(request.getSession()).andReturn(session).anyTimes();
	    EasyMock.expect(request.getHeader("X-FORWARDED-FOR")).andReturn(null).anyTimes();
	    EasyMock.expect(request.getRemoteAddr()).andReturn(REMOTE_IP).anyTimes();
//	    EasyMock.replay(session, request);

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

}