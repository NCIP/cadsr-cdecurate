package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DE_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACSearch;
import gov.nih.nci.cadsr.cdecurate.tool.GetACService;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.PV_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.tool.VD_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.VM_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ValidateBean;

import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.junit.*;
import static org.junit.Assert.*;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;

/**
 * The class <code>SetACServiceTest</code> contains tests for the class <code>{@link SetACService}</code>.
 *
 * @generatedBy CodePro at 8/31/13 9:32 AM
 * @author kim
 * @version $Revision: 1.0 $
 */
public class SetACServiceTest {
	/**
	 * Run the SetACService(CurationServlet) constructor test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetACService_1()
		throws Exception {
		CurationServlet CurationServlet = new CurationServlet();

		SetACService result = new SetACService(CurationServlet);

		// add additional test code here
		assertNotNull(result);
		assertEquals("", result.checkValueDomainIsTypeMeasurement());
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDDEToDEValidatePage(HttpServletRequest,HttpServletResponse,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDDEToDEValidatePage_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDDEToDEValidatePage(req, res, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void addDatesToValidatePage(String,String,String,String,Vector<ValidateBean>,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testAddDatesToValidatePage_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegin = "";
		String sEnd = "";
		String sWFS = "";
		String editAction = "";
		Vector<ValidateBean> vValidate = new Vector();
		String sOriginAction = "";

		fixture.addDatesToValidatePage(sBegin, sEnd, sWFS, editAction, vValidate, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = null;
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();
		m_VM.setVM_CONCEPT(new EVS_Bean());

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = null;
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();
		m_VM.setVM_CONCEPT(new EVS_Bean());

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = null;
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();
		m_VM.setVM_CONCEPT(new EVS_Bean());

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = null;
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = null;

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkConceptCodeExistsInOtherDB(Vector,InsACService,VM_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckConceptCodeExistsInOtherDB_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector vAC = new Vector();
		InsACService insAC = new InsACService(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		VM_Bean m_VM = new VM_Bean();

		String result = fixture.checkConceptCodeExistsInOtherDB(vAC, insAC, m_VM);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDECOCExist(String,HttpServletRequest,HttpServletResponse) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDECOCExist_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sDECid = "";
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();

		String result = fixture.checkDECOCExist(sDECid, req, res);

		// add additional test code here
		assertEquals("Associated Data Element Concept must have an Object Class.", result);
	}

	/**
	 * Run the String checkDECOCExist(String,HttpServletRequest,HttpServletResponse) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDECOCExist_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sDECid = "";
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();

		String result = fixture.checkDECOCExist(sDECid, req, res);

		// add additional test code here
		assertEquals("Associated Data Element Concept must have an Object Class.", result);
	}

	/**
	 * Run the String checkDECOCExist(String,HttpServletRequest,HttpServletResponse) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDECOCExist_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sDECid = "";
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();

		String result = fixture.checkDECOCExist(sDECid, req, res);

		// add additional test code here
		assertEquals("Associated Data Element Concept must have an Object Class.", result);
	}

	/**
	 * Run the String checkDECOCExist(String,HttpServletRequest,HttpServletResponse) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDECOCExist_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sDECid = "";
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();

		String result = fixture.checkDECOCExist(sDECid, req, res);

		// add additional test code here
		assertEquals("Associated Data Element Concept must have an Object Class.", result);
	}

	/**
	 * Run the String checkDECOCExist(String,HttpServletRequest,HttpServletResponse) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDECOCExist_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sDECid = "";
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();

		String result = fixture.checkDECOCExist(sDECid, req, res);

		// add additional test code here
		assertEquals("Associated Data Element Concept must have an Object Class.", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		DEC_Bean m_DEC = new DEC_Bean();
		m_DEC.setDEC_DEC_IDSEQ("");
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		DEC_Bean m_DEC = new DEC_Bean();
		m_DEC.setDEC_DEC_IDSEQ("");
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		DEC_Bean m_DEC = new DEC_Bean();
		m_DEC.setDEC_DEC_IDSEQ("");
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		DEC_Bean m_DEC = new DEC_Bean();
		m_DEC.setDEC_DEC_IDSEQ("");
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		DEC_Bean m_DEC = new DEC_Bean();
		m_DEC.setDEC_DEC_IDSEQ("");
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = null;
		DEC_Bean m_DEC = new DEC_Bean();
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkDEUsingDEC(String,DEC_Bean,GetACSearch) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckDEUsingDEC_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "";
		DEC_Bean m_DEC = new DEC_Bean();
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());

		String result = fixture.checkDEUsingDEC(ACType, m_DEC, getAC);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkForLongNameObjectAndPropertyInDECName(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckForLongNameObjectAndPropertyInDECName_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "";
		String sDEObj = "";
		String sDEProp = "";

		String result = fixture.checkForLongNameObjectAndPropertyInDECName(s, sDEObj, sDEProp);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkForLongNameObjectAndPropertyInDECName(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckForLongNameObjectAndPropertyInDECName_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "";
		String sDEObj = "";
		String sDEProp = "";

		String result = fixture.checkForLongNameObjectAndPropertyInDECName(s, sDEObj, sDEProp);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkForVDRepresentationInDELongName(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckForVDRepresentationInDELongName_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "";
		String sDERep = "";

		String result = fixture.checkForVDRepresentationInDELongName(s, sDERep);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkForVDRepresentationInDELongName(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckForVDRepresentationInDELongName_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "";
		String sDERep = "";

		String result = fixture.checkForVDRepresentationInDELongName(s, sDERep);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkLessThan8Chars(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckLessThan8Chars_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "";

		String result = fixture.checkLessThan8Chars(s);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkLessThan8Chars(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckLessThan8Chars_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String s = "aaaaaaaaa";

		String result = fixture.checkLessThan8Chars(s);

		// add additional test code here
		assertEquals(" Maximum Length must be less than 100,000,000. \n", result);
	}

	/**
	 * Run the String checkNameDiffForReleased(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckNameDiffForReleased_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldName = "";
		String newName = "";
		String oldStatus = null;

		String result = fixture.checkNameDiffForReleased(oldName, newName, oldStatus);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkNameDiffForReleased(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckNameDiffForReleased_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldName = "";
		String newName = "";
		String oldStatus = "";

		String result = fixture.checkNameDiffForReleased(oldName, newName, oldStatus);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkNameDiffForReleased(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckNameDiffForReleased_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldName = "";
		String newName = "";
		String oldStatus = "RELEASED";

		String result = fixture.checkNameDiffForReleased(oldName, newName, oldStatus);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkNameDiffForReleased(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckNameDiffForReleased_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldName = "";
		String newName = "";
		String oldStatus = "RELEASED";

		String result = fixture.checkNameDiffForReleased(oldName, newName, oldStatus);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkNameDiffForReleased(String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckNameDiffForReleased_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldName = "";
		String newName = "";
		String oldStatus = "";

		String result = fixture.checkNameDiffForReleased(oldName, newName, oldStatus);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = "";
		String prop_idseq = "";
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = "";
		String prop_idseq = "";
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = "";
		String prop_idseq = "";
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = "";
		String prop_idseq = "";
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkOCPropWorkFlowStatuses(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckOCPropWorkFlowStatuses_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String oc_idseq = null;
		String prop_idseq = null;
		String strInvalid = "";

		String result = fixture.checkOCPropWorkFlowStatuses(req, res, oc_idseq, prop_idseq, strInvalid);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkObjectPropertyAndRepTerms(HttpServletRequest) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckObjectPropertyAndRepTerms_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();

		String result = fixture.checkObjectPropertyAndRepTerms(req);

		// add additional test code here
		assertEquals("Object term must be found in DE Long Name. \nProperty term must be present in DE Long Name. \nRepresentation term must be present in DE Long Name. \n", result);
	}

	/**
	 * Run the String checkObjectPropertyAndRepTerms(HttpServletRequest) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckObjectPropertyAndRepTerms_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();

		String result = fixture.checkObjectPropertyAndRepTerms(req);

		// add additional test code here
		assertEquals("Object term must be found in DE Long Name. \nProperty term must be present in DE Long Name. \nRepresentation term must be present in DE Long Name. \n", result);
	}

	/**
	 * Run the String checkObjectPropertyAndRepTerms(HttpServletRequest) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckObjectPropertyAndRepTerms_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();

		String result = fixture.checkObjectPropertyAndRepTerms(req);

		// add additional test code here
		assertEquals("Object term must be found in DE Long Name. \nProperty term must be present in DE Long Name. \nRepresentation term must be present in DE Long Name. \n", result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the boolean checkPVQCExists(HttpServletRequest,HttpServletResponse,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckPVQCExists_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String vdIDseq = "";
		String vpIDseq = "";

		boolean result = fixture.checkPVQCExists(req, res, vdIDseq, vpIDseq);

		// add additional test code here
		assertEquals(false, result);
	}

	/**
	 * Run the String checkReleasedWFS(DE_Bean,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckReleasedWFS_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DE_Bean de = new DE_Bean();
		String sWFS = "";

		String result = fixture.checkReleasedWFS(de, sWFS);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "ObjectClass";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "Property";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "RepTerm";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "RepTerm";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "RepQualifier";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "PropertyQualifier";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueBlock(String,String,String,GetACSearch,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueBlock_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "";
		String sContext = "";
		String sValue = "";
		GetACSearch getAC = new GetACSearch(new MockHttpServletRequest(), new MockHttpServletResponse(), new CurationServlet());
		String strInValid = "";
		String sASLName = "";

		String result = fixture.checkUniqueBlock(ACType, sContext, sValue, getAC, strInValid, sASLName);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueDECVDPair(DE_Bean,GetACService,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueDECVDPair_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DE_Bean mDE = new DE_Bean();
		mDE.setDE_CONTE_IDSEQ("");
		mDE.setDE_REG_STATUS((String) null);
		mDE.setDE_DEC_IDSEQ("");
		mDE.setDE_VD_IDSEQ("");
		mDE.setDE_MIN_CDE_ID((String) null);
		GetACService getAC = new GetACService();
		String setAction = "Edit";
		String sMenu = "";

		String result = fixture.checkUniqueDECVDPair(mDE, getAC, setAction, sMenu);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueDECVDPair(DE_Bean,GetACService,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueDECVDPair_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DE_Bean mDE = new DE_Bean();
		mDE.setDE_CONTE_IDSEQ("");
		mDE.setDE_REG_STATUS((String) null);
		mDE.setDE_DEC_IDSEQ("");
		mDE.setDE_VD_IDSEQ("");
		mDE.setDE_MIN_CDE_ID((String) null);
		GetACService getAC = new GetACService();
		String setAction = "";
		String sMenu = "NewDEVersion";

		String result = fixture.checkUniqueDECVDPair(mDE, getAC, setAction, sMenu);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Version";
		String ACType = "VD";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		mVD.setVD_VD_IDSEQ("");
		mVD.setVD_CONTEXT_NAME("");
		mVD.setVD_VERSION("");
		mVD.setVD_VD_ID("");
		GetACService getAC = new GetACService();
		String setAction = "Edit";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "";
		String ACType = "VD";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		mVD.setVD_CONTEXT_NAME("");
		mVD.setVD_VERSION("");
		GetACService getAC = new GetACService();
		String setAction = "";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Name";
		String ACType = "VD";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		mVD.setVD_CONTEXT_NAME("");
		mVD.setVD_VERSION("");
		mVD.setVD_PREFERRED_NAME("");
		GetACService getAC = new GetACService();
		String setAction = "";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "";
		String ACType = "";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Version";
		String ACType = "DEC";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_DEC_ID("");
		mDEC.setDEC_VERSION("");
		mDEC.setDEC_CONTEXT_NAME("");
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "";
		String ACType = "DEC";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_VERSION("");
		mDEC.setDEC_CONTEXT_NAME("");
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Name";
		String ACType = "DEC";
		DE_Bean mDE = new DE_Bean();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_PREFERRED_NAME("");
		mDEC.setDEC_DEC_ID("");
		mDEC.setDEC_VERSION("");
		mDEC.setDEC_CONTEXT_NAME("");
		mDEC.setDEC_DEC_IDSEQ("");
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "Edit";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Version";
		String ACType = "DE";
		DE_Bean mDE = new DE_Bean();
		mDE.setDE_CONTEXT_NAME((String) null);
		mDE.setDE_VERSION((String) null);
		mDE.setDE_MIN_CDE_ID("");
		mDE.setDE_DE_IDSEQ("");
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "Edit";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueInContext(String,String,DE_Bean,DEC_Bean,VD_Bean,GetACService,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueInContext_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sField = "Name";
		String ACType = "DE";
		DE_Bean mDE = new DE_Bean();
		mDE.setDE_PREFERRED_NAME("");
		mDE.setDE_CONTEXT_NAME((String) null);
		mDE.setDE_VERSION((String) null);
		mDE.setDE_DE_IDSEQ("");
		DEC_Bean mDEC = new DEC_Bean();
		VD_Bean mVD = new VD_Bean();
		GetACService getAC = new GetACService();
		String setAction = "Edit";

		String result = fixture.checkUniqueInContext(sField, ACType, mDE, mDEC, mVD, getAC, setAction);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkUniqueOCPropPair(DEC_Bean,HttpServletRequest,HttpServletResponse,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueOCPropPair_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_DEC_ID("");
		mDEC.setDEC_OCL_IDSEQ("");
		mDEC.setDEC_PROPL_IDSEQ("");
		mDEC.setDEC_CONTE_IDSEQ("");
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String setAction = "";

		String result = fixture.checkUniqueOCPropPair(mDEC, req, res, setAction);

		// add additional test code here
		assertEquals("ERROR in checkUniqueOCPropPair ", result);
	}

	/**
	 * Run the String checkUniqueOCPropPair(DEC_Bean,HttpServletRequest,HttpServletResponse,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueOCPropPair_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_DEC_ID("");
		mDEC.setDEC_OCL_IDSEQ("");
		mDEC.setDEC_PROPL_IDSEQ("");
		mDEC.setDEC_CONTE_IDSEQ("");
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String setAction = "";

		String result = fixture.checkUniqueOCPropPair(mDEC, req, res, setAction);

		// add additional test code here
		assertEquals("ERROR in checkUniqueOCPropPair ", result);
	}

	/**
	 * Run the String checkUniqueOCPropPair(DEC_Bean,HttpServletRequest,HttpServletResponse,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckUniqueOCPropPair_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		DEC_Bean mDEC = new DEC_Bean();
		mDEC.setDEC_OCL_IDSEQ("");
		mDEC.setDEC_PROPL_IDSEQ("");
		mDEC.setDEC_CONTE_IDSEQ("");
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String setAction = "";

		String result = fixture.checkUniqueOCPropPair(mDEC, req, res, setAction);

		// add additional test code here
		assertEquals("ERROR in checkUniqueOCPropPair ", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "Name";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValidAlphanumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValidAlphanumeric_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "";

		String result = fixture.checkValidAlphanumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must be a character. \n", result);
	}

	/**
	 * Run the String checkValueDomainIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueDomainIsNumeric_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "";

		String result = fixture.checkValueDomainIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueDomainIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueDomainIsNumeric_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "";

		String result = fixture.checkValueDomainIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueDomainIsTypeMeasurement() method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueDomainIsTypeMeasurement_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();

		String result = fixture.checkValueDomainIsTypeMeasurement();

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueDomainIsTypeMeasurement() method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueDomainIsTypeMeasurement_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();

		String result = fixture.checkValueDomainIsTypeMeasurement();

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueIsNumeric_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = null;
		String sField = "";

		String result = fixture.checkValueIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueIsNumeric_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = null;
		String sField = "";

		String result = fixture.checkValueIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueIsNumeric_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";
		String sField = "";

		String result = fixture.checkValueIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkValueIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueIsNumeric_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "aa";
		String sField = "Decimal Place";

		String result = fixture.checkValueIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must contain only positive numbers. \n", result);
	}

	/**
	 * Run the String checkValueIsNumeric(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckValueIsNumeric_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "aa";
		String sField = "";

		String result = fixture.checkValueIsNumeric(sValue, sField);

		// add additional test code here
		assertEquals("Must contain only positive numbers. \n", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "aaaaaa";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("Must contain only positive numbers. \n", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "aaa";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("Must contain only positive numbers. \n", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkVersionDimension(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckVersionDimension_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.checkVersionDimension(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String checkWritePermission(String,String,String,GetACService) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckWritePermission_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "";
		String sUserName = "";
		String ContID = "";
		GetACService getAC = new GetACService();

		String result = fixture.checkWritePermission(ACType, sUserName, ContID, getAC);

		// add additional test code here
		assertEquals("Problem with write privileges.", result);
	}

	/**
	 * Run the String checkWritePermission(String,String,String,GetACService) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckWritePermission_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "";
		String sUserName = "";
		String ContID = "";
		GetACService getAC = new GetACService();

		String result = fixture.checkWritePermission(ACType, sUserName, ContID, getAC);

		// add additional test code here
		assertEquals("Problem with write privileges.", result);
	}

	/**
	 * Run the String checkWritePermission(String,String,String,GetACService) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCheckWritePermission_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String ACType = "";
		String sUserName = "";
		String ContID = "";
		GetACService getAC = new GetACService();

		String result = fixture.checkWritePermission(ACType, sUserName, ContID, getAC);

		// add additional test code here
		assertEquals("Problem with write privileges.", result);
	}

	/**
	 * Run the String compareDates(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCompareDates_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegDate = "";
		String sEndDate = "";

		String result = fixture.compareDates(sBegDate, sEndDate);

		// add additional test code here
		assertEquals("Error Occurred in validating Begin and End Dates", result);
	}

	/**
	 * Run the String compareDates(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCompareDates_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegDate = "";
		String sEndDate = "";

		String result = fixture.compareDates(sBegDate, sEndDate);

		// add additional test code here
		assertEquals("Error Occurred in validating Begin and End Dates", result);
	}

	/**
	 * Run the String compareDates(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCompareDates_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegDate = "";
		String sEndDate = "";

		String result = fixture.compareDates(sBegDate, sEndDate);

		// add additional test code here
		assertEquals("Error Occurred in validating Begin and End Dates", result);
	}

	/**
	 * Run the String compareDates(String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCompareDates_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sBegDate = "";
		String sEndDate = "";

		String result = fixture.compareDates(sBegDate, sEndDate);

		// add additional test code here
		assertEquals("Error Occurred in validating Begin and End Dates", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String createNewPVVM(HttpServletRequest,HttpServletResponse,String,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testCreateNewPVVM_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		String sValue = "";
		String sMeaning = "";
		String sCD = "";

		String result = fixture.createNewPVVM(req, res, sValue, sMeaning, sCD);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getDECDef(String,Vector<String>,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetDECDef_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = "";
		Vector<String> vObjectClass = new Vector();
		Vector<String> vProperty = new Vector();

		String result = fixture.getDECDef(oldDef, vObjectClass, vProperty);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getDECDef(String,Vector<String>,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetDECDef_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = null;
		Vector<String> vObjectClass = new Vector();
		Vector<String> vProperty = new Vector();

		String result = fixture.getDECDef(oldDef, vObjectClass, vProperty);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the Vector<String> getDefs(Vector<EVS_Bean>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetDefs_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<EVS_Bean> vConcepts = new Vector();

		Vector<String> result = fixture.getDefs(vConcepts);

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the Vector<String> getDefs(Vector<EVS_Bean>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetDefs_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<EVS_Bean> vConcepts = new Vector();

		Vector<String> result = fixture.getDefs(vConcepts);

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the Vector<String> getDefs(Vector<EVS_Bean>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetDefs_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<EVS_Bean> vConcepts = null;

		Vector<String> result = fixture.getDefs(vConcepts);

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the Vector<String> getM_ReleaseWFS() method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetM_ReleaseWFS_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();

		Vector<String> result = fixture.getM_ReleaseWFS();

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getPV(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetPV_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean pv = new PV_Bean();
		pv.setPV_SHORT_MEANING("");

		String result = fixture.getPV(req, res, pv);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getVDDef(String,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetVDDef_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = "";
		Vector<String> vRepTerm = new Vector();

		String result = fixture.getVDDef(oldDef, vRepTerm);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getVDDef(String,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetVDDef_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = "";
		Vector<String> vRepTerm = new Vector();

		String result = fixture.getVDDef(oldDef, vRepTerm);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String getVDDef(String,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetVDDef_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = "a";
		Vector<String> vRepTerm = new Vector();

		String result = fixture.getVDDef(oldDef, vRepTerm);

		// add additional test code here
		assertEquals("a", result);
	}

	/**
	 * Run the String getVDDef(String,Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testGetVDDef_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String oldDef = null;
		Vector<String> vRepTerm = new Vector();

		String result = fixture.getVDDef(oldDef, vRepTerm);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the Vector<String> makeStringVector(Vector<ValidateBean>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testMakeStringVector_1()
		throws Exception {
		Vector<ValidateBean> vValidate = new Vector();

		Vector<String> result = SetACService.makeStringVector(vValidate);

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the Vector<String> makeStringVector(Vector<ValidateBean>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testMakeStringVector_2()
		throws Exception {
		Vector<ValidateBean> vValidate = new Vector();

		Vector<String> result = SetACService.makeStringVector(vValidate);

		// add additional test code here
		assertNotNull(result);
		assertEquals(0, result.size());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_LONG_NAME("");
		deBean.setDE_DE_IDSEQ("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals("", result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals("", result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals("", result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_LONG_NAME("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals("", result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals(null, result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals(null, result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_LONG_NAME("");
		deBean.setDE_DE_IDSEQ("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals("", result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals("", result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals("", result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_LONG_NAME("");
		deBean.setDE_DE_IDSEQ("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals("", result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals("", result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals("", result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_DE_IDSEQ("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("null   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals(null, result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals("", result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals("", result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();
		deBean.setDE_DE_IDSEQ("");

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("null   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals(null, result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals("", result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals("", result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("null   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals(null, result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals(null, result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals(null, result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the DE_Bean setDECSCSIfromPage(HttpServletRequest,DE_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetDECSCSIfromPage_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		DE_Bean deBean = new DE_Bean();

		DE_Bean result = fixture.setDECSCSIfromPage(req, deBean);

		// add additional test code here
		assertNotNull(result);
		assertEquals("null   null v null", result.getDisplayName());
		assertEquals(null, result.getContextName());
		assertEquals(null, result.getDE_CONTEXT_NAME());
		assertEquals(null, result.getDE_CONTE_IDSEQ());
		assertEquals(null, result.getDE_DEC_NAME());
		assertEquals(null, result.getDE_VD_NAME());
		assertEquals(null, result.getDE_LONG_NAME());
		assertEquals(null, result.getDE_PREFERRED_NAME());
		assertEquals(null, result.getDE_ASL_NAME());
		assertEquals(null, result.getAC_PREF_NAME_TYPE());
		assertEquals(null, result.getDE_PREFERRED_DEFINITION());
		assertEquals(null, result.getDE_VERSION());
		assertEquals(null, result.getDE_REG_STATUS());
		assertEquals(null, result.getDE_DEC_IDSEQ());
		assertEquals(null, result.getDE_BEGIN_DATE());
		assertEquals(null, result.getDE_END_DATE());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION());
		assertEquals(null, result.getAC_CONTACTS());
		assertEquals(null, result.getDE_SOURCE());
		assertEquals(null, result.getDE_CHANGE_NOTE());
		assertEquals(false, result.getDE_IN_FORM());
		assertEquals(null, result.getDE_DE_IDSEQ());
		assertEquals(null, result.getDE_MIN_CDE_ID());
		assertEquals(null, result.getDE_VD_IDSEQ());
		assertEquals(null, result.getDE_DEC_Bean());
		assertEquals(null, result.getDE_VD_Bean());
		assertEquals(null, result.getAC_SELECTED_CONTEXT_ID());
		assertEquals(null, result.getALTERNATE_NAME());
		assertEquals(null, result.getAC_ALT_NAMES());
		assertEquals(null, result.getAC_REF_DOCS());
		assertEquals(null, result.getIDSEQ());
		assertEquals(null, result.getAC_SYS_PREF_NAME());
		assertEquals(null, result.getAC_ABBR_PREF_NAME());
		assertEquals(null, result.getAC_USER_PREF_NAME());
		assertEquals(null, result.getContextIDSEQ());
		assertEquals(null, result.getRETURN_CODE());
		assertEquals(null, result.getAC_CSI_NAME());
		assertEquals(null, result.getAC_CSI_ID());
		assertEquals(null, result.getAC_CONCEPT_NAME());
		assertEquals(null, result.getREFERENCE_DOCUMENT());
		assertEquals(null, result.getDE_REG_STATUS_IDSEQ());
		assertEquals(null, result.getDE_DEC_PREFERRED_NAME());
		assertEquals(null, result.getDE_VD_PREFERRED_NAME());
		assertEquals(null, result.getDE_LATEST_VERSION_IND());
		assertEquals(null, result.getDE_CREATED_BY());
		assertEquals(null, result.getDE_DATE_CREATED());
		assertEquals(null, result.getDE_MODIFIED_BY());
		assertEquals(null, result.getDE_DATE_MODIFIED());
		assertEquals(null, result.getDE_DELETED_IND());
		assertEquals(null, result.getDE_LANGUAGE());
		assertEquals(null, result.getDE_LANGUAGE_IDSEQ());
		assertEquals(null, result.getDE_SOURCE_IDSEQ());
		assertEquals(null, result.getDE_PROTOCOL_ID());
		assertEquals(null, result.getDE_CRF_NAME());
		assertEquals(null, result.getDE_PROTO_CRF_Count());
		assertEquals(null, result.getDE_CRF_IDSEQ());
		assertEquals(null, result.getDE_TYPE_NAME());
		assertEquals(null, result.getDE_DER_RELATION());
		assertEquals(null, result.getDE_DER_REL_IDSEQ());
		assertEquals(null, result.getDE_DES_ALIAS_ID());
		assertEquals(null, result.getDE_ALIAS_NAME());
		assertEquals(null, result.getDE_USEDBY_CONTEXT());
		assertEquals(null, result.getDE_USEDBY_CONTEXT_ID());
		assertEquals(null, result.getDE_DEC_Definition());
		assertEquals(null, result.getDE_VD_Definition());
		assertEquals(null, result.getDE_Question_ID());
		assertEquals(null, result.getDE_Question_Name());
		assertEquals(null, result.getDE_Permissible_Value());
		assertEquals(null, result.getDE_Permissible_Value_Count());
		assertEquals(false, result.getDE_CHECKED());
		assertEquals(null, result.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
		assertEquals(false, result.getDEC_VD_CHANGED());
		assertEquals(null, result.getDE_BROWSER_URL());
		assertEquals(null, result.getAlternates());
		assertEquals(false, result.isNewAC());
	}

	/**
	 * Run the void setM_ReleaseWFS(Vector<String>) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetM_ReleaseWFS_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> m_ReleaseWFS = new Vector();

		fixture.setM_ReleaseWFS(m_ReleaseWFS);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setPVValueFromPage(HttpServletRequest,HttpServletResponse,PV_Bean) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetPVValueFromPage_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		HttpServletResponse res = new MockHttpServletResponse();
		PV_Bean m_PV = new PV_Bean();

		fixture.setPVValueFromPage(req, res, m_PV);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "a";
		String sContent = "a";
		boolean bMandatory = true;
		int iLengLimit = 0;
		String strInValid = "a";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "a";
		String sContent = "a";
		boolean bMandatory = true;
		int iLengLimit = 0;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "a";
		String sContent = "a";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "a";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "a";
		String sContent = "a";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "aa";
		String sContent = "aa";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "";
		String sContent = "";
		boolean bMandatory = false;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "";
		String sContent = "";
		boolean bMandatory = false;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = "";
		boolean bMandatory = false;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "BlockEditDE";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = null;
		boolean bMandatory = false;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "BlockEditDEC";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_10()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = "";
		boolean bMandatory = false;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "BlockEditVD";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_11()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = null;
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_12()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "";
		String sContent = null;
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_13()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = "";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_14()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "";
		String sContent = "";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_15()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "Effective End Date";
		String sContent = "";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the void setValPageVector(Vector<String>,String,String,boolean,int,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testSetValPageVector_16()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		Vector<String> v = new Vector();
		String sItem = "";
		String sContent = "";
		boolean bMandatory = true;
		int iLengLimit = 1;
		String strInValid = "";
		String sOriginAction = "";

		fixture.setValPageVector(v, sItem, sContent, bMandatory, iLengLimit, strInValid, sOriginAction);

		// add additional test code here
	}

	/**
	 * Run the String truncateTerm(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testTruncateTerm_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "a";

		String result = fixture.truncateTerm(sValue);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.StringIndexOutOfBoundsException: String index out of range: 30
		//       at java.lang.String.substring(String.java:1934)
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.truncateTerm(SetACService.java:3476)
		assertNotNull(result);
	}

	/**
	 * Run the String truncateTerm(String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testTruncateTerm_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		String sValue = "";

		String result = fixture.truncateTerm(sValue);

		// add additional test code here
		assertEquals("", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "VD";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "VD";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "DEC";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "DEC";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "DE";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "DE";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateBegDateVsEndDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateBegDateVsEndDates_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sBeg = "";
		String sACType = "";

		String result = fixture.validateBegDateVsEndDates(req, sBeg, sACType);

		// add additional test code here
		assertEquals("Error Occurred in validateBegDateVsEndDates", result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_1()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "VD";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_2()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "VD";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_3()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_4()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "DEC";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_5()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "DEC";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_6()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "DE";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_7()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "DE";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_8()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Run the String validateEndDateVsBeginDates(HttpServletRequest,String,String) method test.
	 *
	 * @throws Exception
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Test
	public void testValidateEndDateVsBeginDates_9()
		throws Exception {
		SetACService fixture = new SetACService(new CurationServlet());
		fixture.setM_ReleaseWFS(new Vector());
		fixture.setM_vRegStatus(new Vector());
		fixture.setM_vRetWFS(new Vector());
		fixture.logger = Logger.getRootLogger();
		fixture.m_util = new UtilService();
		HttpServletRequest req = new MockHttpServletRequest();
		String sEnd = "";
		String sACType = "";

		String result = fixture.validateEndDateVsBeginDates(req, sEnd, sACType);

		// add additional test code here
		// An unexpected exception was thrown in user code while executing this test:
		//    java.lang.NullPointerException
		//       at gov.nih.nci.cadsr.cdecurate.tool.SetACService.validateEndDateVsBeginDates(SetACService.java:2341)
		assertNotNull(result);
	}

	/**
	 * Perform pre-test initialization.
	 *
	 * @throws Exception
	 *         if the initialization fails for some reason
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@Before
	public void setUp()
		throws Exception {
		// add additional set up code here
	}

	/**
	 * Perform post-test clean-up.
	 *
	 * @throws Exception
	 *         if the clean-up fails for some reason
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	@After
	public void tearDown()
		throws Exception {
		// Add additional tear down code here
	}

	/**
	 * Launch the test.
	 *
	 * @param args the command line arguments
	 *
	 * @generatedBy CodePro at 8/31/13 9:32 AM
	 */
	public static void main(String[] args) {
		new org.junit.runner.JUnitCore().run(SetACServiceTest.class);
	}
}