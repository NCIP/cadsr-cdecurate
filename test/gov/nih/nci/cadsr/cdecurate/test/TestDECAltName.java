/*
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/testdec.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

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
import gov.nih.nci.cadsr.cdecurate.util.DataManager;

import java.util.Hashtable;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import junit.framework.TestCase;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;

/**
 * @author shegde
 *
 */
public class TestDECAltName //extends TestCase	//CurationServlet
{
    public static final Logger logger  = Logger.getLogger(CurationServlet.class.getName());
	UtilService m_util = new UtilService();
//	CurationServlet m_servlet = null;
    CurationServlet instance;
	public HttpServletRequest  m_classReq       = null;
	public HttpServletResponse m_classRes       = null;
	HttpSession mockHttpSession = null;
    protected SetACService       m_setAC          = null;

  /**
   * Files involved -
   *
	1. CurationServlet.java
	2. SetACService.java
	3. DataElementConceptServlet.java

   * Useful SQLs -
   *
select
--*
asl_name, long_name, preferred_name, preferred_definition
from concepts_view_ext
where
length(preferred_definition) < 200
--and asl_name = 'RELEASED'
--and rownum < 10
and preferred_name in ('C19067','C42774','CL000986')
"ASL_NAME"	"LONG_NAME"	"PREFERRED_NAME"	"PREFERRED_DEFINITION"
"RELEASED"	"Title"	"C19067"	"CL000986: Title "
"RELEASED"	"Title"	"C42774"	"An official descriptive name of a document, e.g. the long name of a study protocol provided by the study sponsor."
"RETIRED PHASED OUT"	"Title"	"CL000986"	"CL000986: Title "
/
delete from COMPONENT_CONCEPTS_EXT where CON_IDSEQ = (select CON_IDSEQ from concepts_view_ext where preferred_name = 'C62682')
/
delete from concepts_view_ext where preferred_name = 'C62682' --to reuse Annual Sreening concept for GF30798 test
/
select
--*
CON_IDSEQ, asl_name, long_name, preferred_name, preferred_definition
from concepts_view_ext con
where
length(preferred_definition) < 200
--and asl_name = 'RELEASED'
--and rownum < 10
and preferred_name in ('C19067','C42774','CL000986','C62682','C1134631')
/
   *
   */

  public static void main(String[] args)
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
//    TestConnections varCon = new TestConnections(connXML, logger1);
//    VMForm vmdata = new VMForm();
//    testdec.m_servlet = new CurationServlet();
//    try {
//		vmdata.setDBConnection(varCon.openConnection());
//		testdec.m_servlet.setConn(varCon.openConnection());
//		vmdata.setCurationServlet(testdec.m_servlet);
//	} catch (SQLException e) {
//		// TODO Auto-generated catch block
//		e.printStackTrace();
//	}
    testdec.test();

  }

  public void test() {
	    m_classReq = EasyMock.createNiceMock(HttpServletRequest.class);
        m_classRes = EasyMock.createMock(HttpServletResponse.class);
		mockHttpSession = EasyMock.createNiceMock(HttpSession.class);
		//Creating the ServletConfig mock here
        ServletConfig servletConfig = EasyMock.createMock(ServletConfig.class);
        //Creating the ServletContext mock here
        ServletContext servletContext = EasyMock.createMock(ServletContext.class);
        //Create the target object
        instance = new CurationServlet();
        //Call the init of the servlet with the mock ServletConfig
        instance.init(m_classReq, m_classRes, servletContext);
        m_setAC = new SetACService(instance);

        //Set up the ServletConfig mock so that when
        //getServletContext is called it can provide the
        //servlet with a ServletContext mock
        EasyMock.expect(servletConfig.getServletContext()).andReturn(servletContext).anyTimes();

        EasyMock.expect(m_classReq.getSession()).andReturn(mockHttpSession).anyTimes();
		EasyMock.expect(m_classReq.getParameter("pageAction")).andReturn("UseSelection");
		EasyMock.expect(m_classReq.getParameter("MenuAction")).andReturn("editDEC");
		String m[] = {"ErrorMessage"};
		EasyMock.expect(mockHttpSession.getAttribute("gov.nih.nci.cadsr.cdecurate.util.DataManager")).andReturn(m);	//ErrorMessage
		EasyMock.expect(mockHttpSession.getAttribute("originAction")).andReturn("EditDEC");
		EasyMock.expect(mockHttpSession.getAttribute(Session_Data.SESSION_STATUS_MESSAGE)).andReturn("");

		EasyMock.replay(mockHttpSession);
		EasyMock.replay(m_classReq);
		EasyMock.replay(m_classRes);
		EasyMock.replay(servletConfig);
		EasyMock.replay(servletContext);

	    try {
			doEditDECActions();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
  }

	private void doEditDECActions() throws Exception
	{
		HttpSession session = m_classReq.getSession();

		String sMenuAction = (String) m_classReq.getParameter("MenuAction");
		if (sMenuAction != null)
			DataManager.setAttribute(session, Session_Data.SESSION_MENU_ACTION, sMenuAction);
		String sAction = (String) m_classReq.getParameter("pageAction");
		DataManager.setAttribute(session, "DECPageAction", sAction); // store the page action in attribute
		String sSubAction = (String) m_classReq.getParameter("DECAction");
		DataManager.setAttribute(session, "DECAction", sSubAction);
		String sButtonPressed = (String) session.getAttribute("LastMenuButtonPressed");
		String sOriginAction = (String) session.getAttribute("originAction");
		if (sAction.equals("submit"))
			doSubmitDEC();
		else if (sAction.equals("validate") && sOriginAction.equals("BlockEditDEC"))
			doValidateDECBlockEdit();
		else if (sAction.equals("validate"))
			doValidateDEC();
		else if (sAction.equals("suggestion"))
			doSuggestionDE(m_classReq, m_classRes);
		else if (sAction.equals("UseSelection"))
		{
			String nameAction = "appendName";
			if (sOriginAction.equals("BlockEditDEC"))
				nameAction = "blockName";
			doDECUseSelection(nameAction);
			ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
			return;
		}
		else if (sAction.equals("RemoveSelection"))
		{
			doRemoveBuildingBlocks();
			// re work on the naming if new one
			DEC_Bean dec = (DEC_Bean) session.getAttribute("m_DEC");
			EVS_Bean nullEVS = null;
			dec = (DEC_Bean) this.getACNames(nullEVS, "Remove", dec); // need to change the long name & def also
			DataManager.setAttribute(session, "m_DEC", dec);
			ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
			return;
		}
		else if (sAction.equals("changeNameType"))
		{
			this.doChangeDECNameType();
			ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
		}
		else if (sAction.equals("Store Alternate Names") || sAction.equals("Store Reference Documents"))
			this.doMarkACBeanForAltRef(m_classReq, m_classRes, "DataElementConcept", sAction, "editAC");
		// add, edit and remove contacts
		else if (sAction.equals("doContactUpd") || sAction.equals("removeContact"))
		{
			DEC_Bean DECBean = (DEC_Bean) session.getAttribute("m_DEC");
			// capture all page attributes
			m_setAC.setDECValueFromPage(m_classReq, m_classRes, DECBean);
			DECBean.setAC_CONTACTS(this.doContactACUpdates(m_classReq, sAction));
			ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
		}
		else if (sAction.equals("clearBoxes"))
		{
			DEC_Bean DECBean = (DEC_Bean) session.getAttribute("oldDECBean");
			this.clearBuildingBlockSessionAttributes(m_classReq, m_classRes);
			String sDECID = DECBean.getDEC_DEC_IDSEQ();
			Vector vList = new Vector();
			// get VD's attributes from the database again
			GetACSearch serAC = null;	//new GetACSearch(m_classReq, m_classRes, this);
			if (sDECID != null && !sDECID.equals(""))
				serAC.doDECSearch(sDECID, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", "",
						"", "", vList, "0");//===gf32398== added one more parameter regstatus
			if (vList.size() > 0)
			{
				DECBean = (DEC_Bean) vList.elementAt(0);
				// logger.debug("cleared name " + DECBean.getDEC_PREFERRED_NAME());
				DECBean = serAC.getDECAttributes(DECBean, sOriginAction, sMenuAction);
			}
			DEC_Bean pgBean = new DEC_Bean();
			DataManager.setAttribute(session, "m_DEC", pgBean.cloneDEC_Bean(DECBean));
			ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
		}
		// open the create DE page or search result page
		else if (sAction.equals("backToDE"))
		{
			this.clearBuildingBlockSessionAttributes(m_classReq, m_classRes); // clear session attributes
			if (sOriginAction.equalsIgnoreCase("editDECfromDE"))
				ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
			else if (sMenuAction.equalsIgnoreCase("editDEC") || sOriginAction.equalsIgnoreCase("BlockEditDEC")
					|| sButtonPressed.equals("Search") || sOriginAction.equalsIgnoreCase("EditDEC"))
			{
				DEC_Bean DECBean = (DEC_Bean) session.getAttribute("m_DEC");
				if (DECBean == null){
					DECBean = new DEC_Bean();
				}
				GetACSearch serAC = null;	//new GetACSearch(m_classReq, m_classRes, this);
				serAC.refreshData(m_classReq, m_classRes, null, DECBean, null, null, "Refresh", "");
				ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
			}
			else
				ForwardJSP(m_classReq, m_classRes, "/EditDECPage.jsp");
		}
	}

	public AC_Bean getACNames(EVS_Bean newBean, String nameAct, AC_Bean pageAC)
	{
		HttpSession session = m_classReq.getSession();
		DEC_Bean pageDEC = (DEC_Bean)pageAC;
		if (pageDEC == null)
			pageDEC = (DEC_Bean) session.getAttribute("m_DEC");
		// get DEC object class and property names
		String sLongName = "";
		String sPrefName = "";
		String sAbbName = "";
		String sOCName = "";
		String sPropName = "";
		String sDef = "";
		//======================GF30798==============START
				String sComp = (String) m_classReq.getParameter("sCompBlocks");
				InsACService ins = new InsACService(m_classReq, m_classRes, instance);
				Vector vObjectClass = (Vector) session.getAttribute("vObjectClass");
				Vector vProperty = (Vector) session.getAttribute("vProperty");
				logger.debug("at Line 700 of DEC.java" + "***" + sComp + "***" + newBean);
				if(newBean != null) {
					if (sComp.startsWith("Object")) {
						logger.debug("at Line 703 of DEC.java" + newBean.getEVS_DATABASE());
						if (!(newBean.getEVS_DATABASE().equals("caDSR"))) {
								String conIdseq = ins.getConcept("", newBean, false);
								if (conIdseq == null || conIdseq.equals("")){
									logger.debug("at Line 707 of DEC.java"+newBean.getPREFERRED_DEFINITION()+"**"+newBean.getLONG_NAME());
								}else {
									logger.debug("at Line 709 of DEC.java"+newBean.getPREFERRED_DEFINITION()+"**"+newBean.getLONG_NAME());
								}

						}
					}else if (sComp.startsWith("Prop")) {
						logger.debug("at Line 714 of DEC.java" + newBean.getEVS_DATABASE());
						if (!(newBean.getEVS_DATABASE().equals("caDSR"))) {
							String conIdseq = ins.getConcept("", newBean, false);
							if (conIdseq == null || conIdseq.equals("")){
								logger.debug("at Line 718 of DEC.java"+newBean.getPREFERRED_DEFINITION()+"**"+newBean.getLONG_NAME());
							}else {
								logger.debug("at Line 720 of DEC.java"+newBean.getPREFERRED_DEFINITION()+"**"+newBean.getLONG_NAME());
							}
						}
					}
				}
				//======================GF30798==============END
		// get the existing one if not restructuring the name but appending it
		if (newBean != null)
		{
			sLongName = pageDEC.getDEC_LONG_NAME();
			if (sLongName == null)
				sLongName = "";
			sDef = pageDEC.getDEC_PREFERRED_DEFINITION();
			if (sDef == null)
				sDef = "";
			logger.debug("At line 688 of DECServlet.java"+sLongName+"**"+sDef);
		}
		// get the typed text on to user name
		String selNameType = "";
		if (nameAct.equals("Search") || nameAct.equals("Remove"))
		{
			logger.info("At line 750 of DECServlet.java");
			selNameType = (String) m_classReq.getParameter("rNameConv");
			sPrefName = (String) m_classReq.getParameter("txPreferredName");
			if (selNameType != null && selNameType.equals("USER") && sPrefName != null)
				pageDEC.setAC_USER_PREF_NAME(sPrefName);
		}
		// get the object class into the long name and abbr name
		//Vector vObjectClass = (Vector) session.getAttribute("vObjectClass");	//GF30798
		if (vObjectClass == null) {
			vObjectClass = new Vector();
		}
		//begin of GF30798
		for (int i=0; i<vObjectClass.size();i++){
			EVS_Bean eBean =(EVS_Bean)vObjectClass.get(i);
			logger.debug("At line 762 of DECServlet.java "+eBean.getPREFERRED_DEFINITION()+"**"+eBean.getLONG_NAME()+"**"+eBean.getCONCEPT_IDENTIFIER());
		}
		//end of GF30798
		// add the Object Class qualifiers first
		for (int i = 1; vObjectClass.size() > i; i++)
		{
			EVS_Bean eCon = (EVS_Bean) vObjectClass.elementAt(i);
			if (eCon == null)
				eCon = new EVS_Bean();
			String conName = eCon.getLONG_NAME();
			if (conName == null)
				conName = "";
			if (!conName.equals(""))
			{
				logger.info("At line 778 of DECServlet.java");
				String nvpValue = "";
				if (this.checkNVP(eCon))
					nvpValue = "::" + eCon.getNVP_CONCEPT_VALUE();

				// rearrange it long name and definition
				if (newBean == null)
				{
					if (!sLongName.equals(""))
						sLongName += " ";
					sLongName += conName + nvpValue;
					if (!sDef.equals(""))
						sDef += "_"; // add definition
					sDef += eCon.getPREFERRED_DEFINITION() + nvpValue;
					logger.debug("At line 792 of DECServlet.java"+sLongName+"**"+sDef);

				}
				if (!sAbbName.equals(""))
					sAbbName += "_";
				if (conName.length() > 3)
					sAbbName += conName.substring(0, 4); // truncate to four letters
				else
					sAbbName += conName;
				// add object qualifiers to object class name
				if (!sOCName.equals(""))
					sOCName += " ";
				sOCName += conName + nvpValue;
				logger.debug("At line 805 of DECServlet.java"+conName+"**"+nvpValue+"**"+sLongName+"**"+sDef+"**"+sOCName);
			}
		}
		// add the Object Class primary
		if (vObjectClass != null && vObjectClass.size() > 0)
		{
			EVS_Bean eCon = (EVS_Bean) vObjectClass.elementAt(0);
			if (eCon == null)
				eCon = new EVS_Bean();
			String sPrimary = eCon.getLONG_NAME();
			if (sPrimary == null)
				sPrimary = "";
			if (!sPrimary.equals(""))
			{
				logger.info("At line 819 of DECServlet.java");
				String nvpValue = "";
				if (this.checkNVP(eCon))
					nvpValue = "::" + eCon.getNVP_CONCEPT_VALUE();

				// rearrange it only long name and definition
				if (newBean == null)
				{
					if (!sLongName.equals(""))
						sLongName += " ";
					sLongName += sPrimary + nvpValue;
					if (!sDef.equals(""))
						sDef += "_"; // add definition
					sDef += eCon.getPREFERRED_DEFINITION() + nvpValue;
					logger.debug("At line 833 of DECServlet.java"+sLongName+"**"+sDef);
				}
				if (!sAbbName.equals(""))
					sAbbName += "_";
				if (sPrimary.length() > 3)
					sAbbName += sPrimary.substring(0, 4); // truncate to four letters
				else
					sAbbName += sPrimary;
				// add primary object to object name
				if (!sOCName.equals(""))
					sOCName += " ";
				sOCName += sPrimary + nvpValue;
				logger.debug("At line 778 of DECServlet.java"+sPrimary+"**"+nvpValue+"**"+sLongName+"**"+sDef+"**"+sOCName);
			}
		}
		// get the Property into the long name and abbr name
		//Vector vProperty = (Vector) session.getAttribute("vProperty");	//GF30798
		if (vProperty == null)
			vProperty = new Vector();
		//begin of GF30798
		for (int i=0; i<vProperty.size();i++){
			EVS_Bean eBean =(EVS_Bean)vProperty.get(i);
			logger.debug("At line 853 of DECServlet.java "+eBean.getPREFERRED_DEFINITION()+"**"+eBean.getLONG_NAME()+"**"+eBean.getCONCEPT_IDENTIFIER());
		}
		//begin of GF30798
		// add the property qualifiers first
		for (int i = 1; vProperty.size() > i; i++)
		{
			EVS_Bean eCon = (EVS_Bean) vProperty.elementAt(i);
			if (eCon == null)
				eCon = new EVS_Bean();
			String conName = eCon.getLONG_NAME();
			if (conName == null)
				conName = "";
			if (!conName.equals(""))
			{
				logger.info("At line 869 of DECServlet.java");
				String nvpValue = "";
				if (this.checkNVP(eCon))
					nvpValue = "::" + eCon.getNVP_CONCEPT_VALUE();

				// rearrange it long name and definition
				if (newBean == null)
				{
					if (!sLongName.equals(""))
						sLongName += " ";
					sLongName += conName + nvpValue;
					if (!sDef.equals(""))
						sDef += "_"; // add definition
					sDef += eCon.getPREFERRED_DEFINITION() + nvpValue;
					logger.debug("At line 883 of DECServlet.java"+sLongName+"**"+sDef);
				}
				if (!sAbbName.equals(""))
					sAbbName += "_";
				if (conName.length() > 3)
					sAbbName += conName.substring(0, 4); // truncate to four letters
				else
					sAbbName += conName;
				// add property qualifiers to property name
				if (!sPropName.equals(""))
					sPropName += " ";
				sPropName += conName + nvpValue;
				logger.debug("At line 895 of DECServlet.java"+conName+"**"+nvpValue+"**"+sLongName+"**"+sDef+"**"+sOCName);
			}
		}
		// add the property primary
		if (vProperty != null && vProperty.size() > 0)
		{
			EVS_Bean eCon = (EVS_Bean) vProperty.elementAt(0);
			if (eCon == null)
				eCon = new EVS_Bean();
			String sPrimary = eCon.getLONG_NAME();
			if (sPrimary == null)
				sPrimary = "";
			if (!sPrimary.equals(""))
			{
				logger.info("At line 909 of DECServlet.java");
				String nvpValue = "";
				if (this.checkNVP(eCon))
					nvpValue = "::" + eCon.getNVP_CONCEPT_VALUE();

				// rearrange it only long name and definition
				if (newBean == null)
				{
					if (!sLongName.equals(""))
						sLongName += " ";
					sLongName += sPrimary + nvpValue;
					if (!sDef.equals(""))
						sDef += "_"; // add definition
					sDef += eCon.getPREFERRED_DEFINITION() + nvpValue;
					logger.debug("At line 923 of DECServlet.java"+sLongName+"**"+sDef);
				}
				if (!sAbbName.equals(""))
					sAbbName += "_";
				if (sPrimary.length() > 3)
					sAbbName += sPrimary.substring(0, 4); // truncate to four letters
				else
					sAbbName += sPrimary;
				// add primary property to property name
				if (!sPropName.equals(""))
					sPropName += " ";
				sPropName += sPrimary + nvpValue;
				logger.debug("At line 935 of DECServlet.java"+sPrimary+"**"+nvpValue+"**"+sLongName+"**"+sDef+"**"+sOCName);
			}
		}
		// truncate to 30 characters
		if (sAbbName != null && sAbbName.length() > 30)
			sAbbName = sAbbName.substring(0, 30);
		// add the abbr name to vd bean and page is selected
		pageDEC.setAC_ABBR_PREF_NAME(sAbbName);
		// make abbr name name preferrd name if sys was selected
		if (selNameType != null && selNameType.equals("ABBR"))
			pageDEC.setDEC_PREFERRED_NAME(sAbbName);
		// appending to the existing;
		if (newBean != null)
		{
			String sSelectName = newBean.getLONG_NAME();
			if (!sLongName.equals(""))
				sLongName += " ";
			sLongName += sSelectName;
			if (!sDef.equals(""))
				sDef += "_"; // add definition
			sDef += newBean.getPREFERRED_DEFINITION();
			logger.debug("At line 956 of DECServlet.java"+sLongName+"**"+sDef);
		}
		// store the long names, definition, and usr name in vd bean if searched
		if (nameAct.equals("Search") || nameAct.equals("Remove")) // GF30798 - added to call when name act is remove
		{
			pageDEC.setDEC_LONG_NAME(AdministeredItemUtil.handleLongName(sLongName));	//GF32004;
			pageDEC.setDEC_PREFERRED_DEFINITION(sDef);
			logger.debug("DEC_LONG_NAME at Line 963 of DECServlet.java"+pageDEC.getDEC_LONG_NAME()+"**"+pageDEC.getDEC_PREFERRED_DEFINITION());
		}
		if (!nameAct.equals("OpenDEC")){
			pageDEC.setDEC_OCL_NAME(sOCName);
			pageDEC.setDEC_PROPL_NAME(sPropName);
			logger.debug("At line 968 of DECServlet.java"+sOCName+"**"+sPropName);
		}
		if (nameAct.equals("Search") || nameAct.equals("Remove"))
		{
			pageDEC.setAC_SYS_PREF_NAME("(Generated by the System)"); // only for dec
			if (selNameType != null && selNameType.equals("SYS"))
				pageDEC.setDEC_PREFERRED_NAME(pageDEC.getAC_SYS_PREF_NAME());
		}
		return pageDEC;
	}

	private void clearBuildingBlockSessionAttributes(
			HttpServletRequest m_classReq2, HttpServletResponse m_classRes2) {
		// TODO Auto-generated method stub

	}

	private Hashtable<String, AC_CONTACT_Bean> doContactACUpdates(
			HttpServletRequest m_classReq2, String sAction) {
		// TODO Auto-generated method stub
		return null;
	}

	private void doMarkACBeanForAltRef(HttpServletRequest m_classReq2,
			HttpServletResponse m_classRes2, String string, String sAction,
			String string2) {
		// TODO Auto-generated method stub

	}

	private void ForwardJSP(HttpServletRequest m_classReq2,
			HttpServletResponse m_classRes2, String string) {
		// TODO Auto-generated method stub

	}

	private void doSuggestionDE(HttpServletRequest m_classReq2,
			HttpServletResponse m_classRes2) {
		// TODO Auto-generated method stub

	}

	private void doChangeDECNameType() {
		// TODO Auto-generated method stub
		System.out.println("doChangeDECNameType");
	}

	private void doRemoveBuildingBlocks() {
		// TODO Auto-generated method stub
		System.out.println("doRemoveBuildingBlocks");
	}

	private void doDECUseSelection(String nameAction) {
		// TODO Auto-generated method stub
		System.out.println("doDECUseSelection");
	}

	private void doValidateDEC() {
		// TODO Auto-generated method stub
		System.out.println("doValidateDEC");
	}

	private void doValidateDECBlockEdit() {
		// TODO Auto-generated method stub
		System.out.println("doValidateDECBlockEdit");
	}

	private void doSubmitDEC() {
		// TODO Auto-generated method stub
		System.out.println("doSubmitDEC");
	}

	public static boolean checkNVP(EVS_Bean eCon) {

		return (eCon.getNAME_VALUE_PAIR_IND() > 0 && eCon.getLONG_NAME().indexOf("::") < 1 && eCon.getNVP_CONCEPT_VALUE().length() > 0);	//JT not sure what is this checking for, second portion could be buggy!!!
	}
}
=======
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
