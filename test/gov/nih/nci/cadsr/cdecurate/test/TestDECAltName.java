// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/test/testdec.java,v 1.11 2008-03-13 17:57:59 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.test;

import gov.nih.nci.cadsr.cdecurate.tool.CurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.DEC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.EVS_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACSearch;
import gov.nih.nci.cadsr.cdecurate.tool.Session_Data;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UtilService;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.easymock.EasyMock;
//import com.sun.org.apache.xerces.internal.impl.xs.dom.DOMParser;

/**
 * @author shegde
 *
 */
public class TestDECAltName extends CurationServlet
{
//    public static final Logger logger  = Logger.getLogger(CurationServlet.class.getName());
	UtilService m_util = new UtilService();
	CurationServlet m_servlet = null;
	static public HttpServletRequest  m_classReq       = null;
	static public HttpServletResponse m_classRes       = null;
    protected SetACService       m_setAC          = new SetACService(this);

  /**
   * Files involved -
   * 
1. CurationServlet.java
2. SetACService.java
3. DataElementConceptServlet.java

   * Useful SQLs -
   * 
   * To check existing DEC without CDR rule (CONDR_IDSEQ is missing aka no row found in SBREXT.con_derivation_rules_ext):

   
   *
   */

  /**
   * @param args
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
    testdec.run();

  }
  
  public void run() {
	  
	    m_classReq = EasyMock.createStrictMock(HttpServletRequest.class);
		HttpSession mockHttpSession = EasyMock.createMock(HttpSession.class);
		EasyMock.expect(m_classReq.getSession()).andReturn(mockHttpSession);
		EasyMock.expect(m_classReq.getParameter("MenuAction")).andReturn("editDEC");
		EasyMock.replay(m_classReq);
	    
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

}
