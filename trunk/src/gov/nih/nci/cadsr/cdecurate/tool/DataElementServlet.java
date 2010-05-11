package gov.nih.nci.cadsr.cdecurate.tool;

import java.util.Vector;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DataElementServlet extends CurationServlet{

    //private HttpServletRequest  m_classReq       = null;
    //private HttpServletResponse m_classRes       = null;
	
	public DataElementServlet() {
		super();
	}

	public DataElementServlet(HttpServletRequest req, HttpServletResponse res)
    {
       //super(req, res);
    }
	
	public DataElementServlet(HttpServletRequest req, HttpServletResponse res, ServletContext sc)
    {
       super(req, res, sc);
    }
	
	public void execute(ACRequestTypes reqType) throws Exception {	
			
		switch (reqType){
			case newDEFromMenu:
				doOpenCreateNewPages(); 
				break;
			case newDEfromForm:
				doCreateDEActions();
				break;
			case editDE:
				doEditDEActions();
				break;
			case validateDEFromForm:
				doInsertDE();
				break;
			case getDDEDetails:
				doDDEDetailsActions();
				break;
			case viewDATAELEMENT:
				doOpenViewPage();
				break;
		}
	}	
		
    /**
     * The doOpenCreateNewPages method will set some session attributes then forward the request to a Create page.
     * Called from 'service' method where reqType is 'newDEFromMenu', 'newDECFromMenu', 'newVDFromMenu' Sets some
     * initial session attributes. Calls 'getAC.getACList' to get the Data list from the database for the selected
     * context. Sets session Bean and forwards the create page for the selected component.
     *
     * @throws Exception
     */
    private void doOpenCreateNewPages() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        clearSessionAttributes(m_classReq, m_classRes);
        this.clearBuildingBlockSessionAttributes(m_classReq, m_classRes);
        String context = (String) session.getAttribute("sDefaultContext"); // from Login.jsp

        DataManager.setAttribute(session, Session_Data.SESSION_MENU_ACTION, "nothing");
        DataManager.setAttribute(session, "DDEAction", "nothing"); // reset from "CreateNewDEFComp"

        DataManager.setAttribute(session, "sCDEAction", "nothing");
        DataManager.setAttribute(session, "VDPageAction", "nothing");
        DataManager.setAttribute(session, "DECPageAction", "nothing");
        DataManager.setAttribute(session, "sDefaultContext", context);
        this.clearCreateSessionAttributes(m_classReq, m_classRes); // clear some session attributes

        DE_Bean m_DE = new DE_Bean();
        m_DE.setDE_ASL_NAME("DRAFT NEW");
        m_DE.setAC_PREF_NAME_TYPE("SYS");
        DataManager.setAttribute(session, "m_DE", m_DE);
        DE_Bean oldDE = new DE_Bean();
        oldDE.setDE_ASL_NAME("DRAFT NEW");
        oldDE.setAC_PREF_NAME_TYPE("SYS");
        DataManager.setAttribute(session, "oldDEBean", oldDE);
        DataManager.setAttribute(session, "originAction", "NewDEFromMenu");
        DataManager.setAttribute(session, "LastMenuButtonPressed", "CreateDE");
        doInitDDEInfo();
        ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");

/*        else if (sACType.equals("pv"))
        {
            ForwardJSP(req, res, "/CreatePVPage.jsp");
        }
*/    } // end of doOpenCreateNewPages

    /**
     * The doCreateDEActions method handles CreateDE or EditDE actions of the request. Called from 'service' method
     * where reqType is 'newDEfromForm' Calls 'ValidateDE' if the action is Validate or submit. Calls 'doSuggestionDE'
     * if the action is open EVS Window. Calls 'doOpenCreateDECPage' if the action is create new DEC from DE Page. Calls
     * 'doOpenCreateVDPage' if the action is create new VD from VD Page.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doCreateDEActions() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        String sPageAction = (String) m_classReq.getParameter("pageAction");
        if (sPageAction != null)
            DataManager.setAttribute(session, "sCDEAction", sPageAction);
        String sMenuAction = (String) m_classReq.getParameter("MenuAction");
        if (sMenuAction != null)
            DataManager.setAttribute(session, Session_Data.SESSION_MENU_ACTION, sMenuAction);
        String sSubAction = (String) m_classReq.getParameter("DEAction");
        DataManager.setAttribute(session, "DEAction", sSubAction);
        String sOriginAction = (String) session.getAttribute("originAction");
        // save DDE info every case except back from DEComp
        String ddeType = (String) m_classReq.getParameter("selRepType");
        if (ddeType != null && !ddeType.equals(""))
            doUpdateDDEInfo();
        // handle all page actions
/*        if (sPageAction.equals("changeContext"))
            doChangeContext(m_classReq, m_classRes, "de");
        else*/ if (sPageAction.equals("submit"))
            doSubmitDE();
        else if (sPageAction.equals("validate"))
            doValidateDE();
        else if (sPageAction.equals("suggestion"))
            doSuggestionDE(m_classReq, m_classRes);
        else if (sPageAction.equals("updateNames"))
        {
            this.getACNames("new", "Search", null);
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
        else if (sPageAction.equals("changeNameType"))
        {
            this.doChangeDENameType();
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
        else if (sPageAction.equals("createNewDEC"))
        {
            DataManager.setAttribute(session, "originAction", "CreateNewDECfromCreateDE");
            DataElementConceptServlet decServ = (DataElementConceptServlet) getACServlet("DataElementConcept");
            decServ.doOpenCreateDECPage();  
        }
        else if (sPageAction.equals("createNewVD"))
        {
            DataManager.setAttribute(session, "originAction", "CreateNewVDfromCreateDE");
            ValueDomainServlet vdServ = (ValueDomainServlet) getACServlet("ValueDomain");
            vdServ.doOpenCreateVDPage();   
        }
        else if (sPageAction.equals("CreateNewDEFComp"))
            doOpenCreateDECompPage();
        else if (sPageAction.equals("DECompBackToNewDE") || sPageAction.equals("DECompBackToEditDE"))
            doOpenDEPageFromDEComp();
        else if (sPageAction.equals("Store Alternate Names") || sPageAction.equals("Store Reference Documents"))
            this.doMarkACBeanForAltRef(m_classReq, m_classRes, "DataElement", sPageAction, "createAC");  
        else if (sPageAction.equals("doContactUpd") || sPageAction.equals("removeContact"))
        {
            DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
            // capture all page attributes
            m_setAC.setDEValueFromPage(m_classReq, m_classRes, DEBean);
            DEBean.setAC_CONTACTS(doContactACUpdates(m_classReq, sPageAction));
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
        else if (sPageAction.equals("clearBoxes"))
        {
            DE_Bean DEBean = (DE_Bean) session.getAttribute("oldDEBean");
            String sDEID = DEBean.getDE_DE_IDSEQ();
            String sVDid = DEBean.getDE_VD_IDSEQ();
            Vector vList = new Vector();
            // get VD's attributes from the database again
            GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
            if (sDEID != null && !sDEID.equals(""))
            {
                serAC.doDESearch(sDEID, "", "", "", "", "", 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                                "", "", "", "", "", "", "", "", "", "", "", vList, "0");
            }
            if (vList.size() > 0) // get all attributes
            {
                DEBean = (DE_Bean) vList.elementAt(0);
                DEBean = serAC.getDEAttributes(DEBean, sOriginAction, sMenuAction);
                serAC.getDDEInfo(DEBean.getDE_DE_IDSEQ()); // clear dde
            }
            else if (sVDid == null || sVDid.equals(""))
            {
                DEBean = new DE_Bean();
                DEBean.setDE_ASL_NAME("DRAFT NEW");
                DEBean.setAC_PREF_NAME_TYPE("SYS");
                this.doInitDDEInfo();
            }
            // get the clone copy of hte updated bean to open the page
            DE_Bean pgBean = new DE_Bean();
            DataManager.setAttribute(session, "m_DE", pgBean.cloneDE_Bean(DEBean, "Complete"));
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
        else if (sPageAction.equals("backToSearch"))
        {
            this.clearCreateSessionAttributes(m_classReq, m_classRes);
            GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
            // forword to search page with de search results
            if (sMenuAction.equals("NewDETemplate") || sMenuAction.equals("NewDEVersion"))
            {
                DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
                serAC.refreshData(m_classReq, m_classRes, DEBean, null, null, null, "Refresh", "");
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            // forward to search page with questions search results
            else if (sMenuAction.equals("Questions"))
            {
                Quest_Bean QuestBean = (Quest_Bean) session.getAttribute("m_Quest");
                serAC.refreshData(m_classReq, m_classRes, null, null, null, QuestBean, "Refresh", "");
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            else
                ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
    }

    /**
     * The doEditDEActions method handles EditDE actions of the request. Called from 'service' method where reqType is
     * 'EditDEfromForm' Calls 'ValidateDE' if the action is Validate or submit. Calls 'doSuggestionDE' if the action is
     * open EVS Window. Calls 'doOpenDECForEdit' if the action is Edit DEC from EditDE Page. Calls 'doOpenVDForEdit' if
     * the action is Edit VD from EditDE Page.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doEditDEActions() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        String sPageAction = (String) m_classReq.getParameter("pageAction");
        if (sPageAction != null)
            DataManager.setAttribute(session, "sCDEAction", sPageAction);
        String sMenuAction = (String) m_classReq.getParameter("MenuAction");
        if (sMenuAction != null)
            DataManager.setAttribute(session, Session_Data.SESSION_MENU_ACTION, sMenuAction);
        String sSubAction = (String) m_classReq.getParameter("DEAction");
        DataManager.setAttribute(session, "DEAction", sSubAction);
        String sButtonPressed = (String) session.getAttribute("LastMenuButtonPressed");
        String sOriginAction = (String) session.getAttribute("originAction");
        if (sOriginAction == null)
            sOriginAction = "";
        // save DDE info every case except back from DEComp
        String ddeType = (String) m_classReq.getParameter("selRepType");
        String oldDDEType = (String) session.getAttribute("sRepType");
        // update the dde info if new one or if old one if not block edit
        if (!sOriginAction.equals("BlockEditDE")
                        && ((ddeType != null && !ddeType.equals("")) || (oldDDEType != null && !oldDDEType.equals(""))))
            doUpdateDDEInfo();
        if (sPageAction.equals("submit"))
            doSubmitDE();
        else if (sPageAction.equals("validate") && sOriginAction.equals("BlockEditDE"))
            doValidateDEBlockEdit();
        else if (sPageAction.equals("validate"))
            doValidateDE();
        else if (sPageAction.equals("suggestion"))
            doSuggestionDE(m_classReq, m_classRes);
        else if (sPageAction.equals("EditDECfromDE"))
        {
            DataManager.setAttribute(session, "originAction", "editDECfromDE");
            DataElementConceptServlet decServ = (DataElementConceptServlet) getACServlet("DataElementConcept");
            decServ.doOpenEditDECPage();   
        }
        else if (sPageAction.equals("createNewDEC"))
        {
            DataManager.setAttribute(session, "originAction", "CreateNewDECfromEditDE");
            DataElementConceptServlet decServ = (DataElementConceptServlet) getACServlet("DataElementConcept");
            decServ.doOpenCreateDECPage(); 
        }
        else if (sPageAction.equals("createNewVD"))
        {
            DataManager.setAttribute(session, "originAction", "CreateNewVDfromEditDE");
            ValueDomainServlet vdServ = (ValueDomainServlet) getACServlet("ValueDomain");
            vdServ.doOpenCreateVDPage(); 
        }
        else if (sPageAction.equals("EditVDfromDE"))
        {
            DataManager.setAttribute(session, "originAction", "editVDfromDE");
            ValueDomainServlet vdServ = (ValueDomainServlet) getACServlet("ValueDomain");
            vdServ.doOpenEditVDPage();  
        }
        else if (sPageAction.equals("updateNames"))
        {
            this.getACNames("new", "Search", null);
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
        else if (sPageAction.equals("changeNameType"))
        {
            this.doChangeDENameType();
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
        else if (sPageAction.equals("clearBoxes"))
        {
            DE_Bean DEBean = (DE_Bean) session.getAttribute("oldDEBean");
            String sDEID = DEBean.getDE_DE_IDSEQ();
            Vector vList = new Vector();
            // get VD's attributes from the database again
            GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
            if (sDEID != null && !sDEID.equals(""))
                serAC.doDESearch(sDEID, "", "", "", "", "", 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                                "", "", "", "", "", "", "", "", "", "", "", vList, "0");
            if (vList.size() > 0) // get all attributes
            {
                DEBean = (DE_Bean) vList.elementAt(0);
                DEBean = serAC.getDEAttributes(DEBean, sOriginAction, sMenuAction);
                serAC.getDDEInfo(DEBean.getDE_DE_IDSEQ()); // clear dde
            }
            else
            {
                this.doInitDDEInfo();
            }
            DE_Bean pgBean = new DE_Bean();
            DataManager.setAttribute(session, "m_DE", pgBean.cloneDE_Bean(DEBean, "Complete"));
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
        else if (sPageAction.equals("backToSearch"))
        {
            GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
            // forward to search page with questions search results
            if (sMenuAction.equals("Questions"))
            {
                Quest_Bean QuestBean = (Quest_Bean) session.getAttribute("m_Quest");
                serAC.refreshData(m_classReq, m_classRes, null, null, null, QuestBean, "Refresh", "");
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            else if (sMenuAction.equalsIgnoreCase("editDE") || sOriginAction.equalsIgnoreCase("BlockEditDE")
                            || sButtonPressed.equals("Search") || sOriginAction.equalsIgnoreCase("EditDE")) // ||
                                                                                                            // sMenuAction.equals("EditDesDE"))
            {
                // DE_Bean DEBean = (DE_Bean)session.getAttribute("m_DE");
                Vector<String> vResult = new Vector<String>();
                serAC.getDEResult(m_classReq, m_classRes, vResult, "");
                DataManager.setAttribute(session, "results", vResult);
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            else
                ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
        else if (sPageAction.equals("CreateNewDEFComp"))
        {
            doOpenCreateDECompPage();
        }
        else if (sPageAction.equals("Store Alternate Names") || sPageAction.equals("Store Reference Documents"))
            this.doMarkACBeanForAltRef(m_classReq, m_classRes, "DataElement", sPageAction, "editAC");
        else if (sPageAction.equals("doContactUpd") || sPageAction.equals("removeContact"))
        {
            DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
            // capture all page attributes
            m_setAC.setDEValueFromPage(m_classReq, m_classRes, DEBean);
            DEBean.setAC_CONTACTS(this.doContactACUpdates(m_classReq, sPageAction));
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
    } // end of doEditDEActions

    /**
     * this method is used to create preferred name for DE it gets the selected DEC or VD bean from the search result
     * and stores it in DE if from teh search. if from create or edit dec or vd, it refreshes DE bean with new dec or
     * vd. names of all three types will be stored in the bean for later use if type is changed, it populates name
     * according to type selected.
     *
     * @param nameAct
     *            string new name or apeend name
     * @param sOrigin
     *            String what changed to make this name creation
     * @param pageDE
     *            current de bean
     * @return DE_Bean
     * @throws java.lang.Exception
     */
    public AC_Bean getACNames(String nameAct, String sOrigin, AC_Bean pageAC)
    {
    	DE_Bean pageDE = (DE_Bean)pageAC;
        HttpSession session = m_classReq.getSession();
        if (pageDE == null)
            pageDE = (DE_Bean) session.getAttribute("m_DE");
        // get other de attributes from page
        if (sOrigin.equals("Search"))
            m_setAC.setDEValueFromPage(m_classReq, m_classRes, pageDE);
        String sSysName = pageDE.getAC_SYS_PREF_NAME();
        String sAbbName = pageDE.getAC_ABBR_PREF_NAME();
        // store teh page one if typed ealier
        String selNameType = pageDE.getAC_PREF_NAME_TYPE();
        if (selNameType == null)
            selNameType = "";
        if (sOrigin.equals("Search") || sOrigin.equals("Remove"))
        {
            selNameType = (String) m_classReq.getParameter("rNameConv");
            if (selNameType == null)
                selNameType = "";
            String sPrefName = (String) m_classReq.getParameter("txtPreferredName");
            if (selNameType != null && selNameType.equals("USER") && sPrefName != null)
                pageDE.setAC_USER_PREF_NAME(sPrefName);
        }
        String sUsrName = pageDE.getAC_USER_PREF_NAME();
        // get other attrs
        sSysName = "";
        sAbbName = "";
        DEC_Bean deDEC = pageDE.getDE_DEC_Bean();
        VD_Bean deVD = pageDE.getDE_VD_Bean();
        String sDef = pageDE.getDE_PREFERRED_DEFINITION();
        // get selected row from the search results
        if (sOrigin.equals("Search"))
        {
            String acSearch = (String) m_classReq.getParameter("acSearch");
            if (acSearch == null)
                acSearch = "ALL";
            // get the result vector from the session
            Vector vRSel = (Vector) session.getAttribute("vACSearch");
            if (vRSel == null)
                vRSel = new Vector();
            // get the array from teh hidden list
            String selRows[] = m_classReq.getParameterValues("hiddenSelRow");
            if (selRows == null)
                DataManager.setAttribute(session, "StatusMessage", "Unable to select Row, please try again");
            else
            {
                // loop through the array of strings
                for (int i = 0; i < selRows.length; i++)
                {
                    String thisRow = selRows[i];
                    Integer IRow = new Integer(thisRow);
                    int iRow = IRow.intValue();
                    if (iRow < 0 || iRow > vRSel.size())
                    {
                        DataManager.setAttribute(session, "StatusMessage", "Row size is either too big or too small.");
                    }
                    else
                    {
                        if (acSearch.equals("DataElementConcept"))
                        {
                            deDEC = (DEC_Bean) vRSel.elementAt(iRow);
                            pageDE.setDE_DEC_Bean(deDEC);
                            // if (nameAct.equals("append"))
                            // pageDE.setDE_PREFERRED_DEFINITION(pageDE.getDE_PREFERRED_DEFINITION() + "_" +
                            // deDEC.getDEC_PREFERRED_DEFINITION());
                        }
                        else if (acSearch.equals("ValueDomain"))
                        {
                            deVD = (VD_Bean) vRSel.elementAt(iRow);
                            pageDE.setDE_VD_Bean(deVD);
                            // if (nameAct.equals("append"))
                            // pageDE.setDE_PREFERRED_DEFINITION(pageDE.getDE_PREFERRED_DEFINITION() + "_" +
                            // deVD.getVD_PREFERRED_DEFINITION());
                        }
                    }
                }
            }
        }
        String sLongName = "";
        if (nameAct.equals("new"))
            sDef = "";
        // get sys name and abbr names from dec and vd beans
        if (deDEC != null)
        {
            String sver = deDEC.getDEC_VERSION();
            if (sver != null && sver.indexOf(".") < 0)
                sver += ".0";
            sSysName = deDEC.getDEC_DEC_ID() + "v" + sver + ":";
            sAbbName = deDEC.getDEC_PREFERRED_NAME() + "_";
            sLongName = deDEC.getDEC_LONG_NAME() + " ";
            if (nameAct.equals("new"))
                sDef = deDEC.getDEC_PREFERRED_DEFINITION() + "_";
        }
        if (deVD != null)
        {
            String sver = deVD.getVD_VERSION();
            if (sver != null && sver.indexOf(".") < 0)
                sver += ".0";
            sSysName = sSysName + deVD.getVD_VD_ID() + "v" + sver;
            sAbbName = sAbbName + deVD.getVD_PREFERRED_NAME();
            sLongName = sLongName + deVD.getVD_LONG_NAME();
            if (nameAct.equals("new"))
                sDef = sDef + deVD.getVD_PREFERRED_DEFINITION();
        }
        // truncate to 30 characters
        if (sAbbName != null && sAbbName.length() > 30)
            sAbbName = sAbbName.substring(0, 30);
        // truncate to 30 characters
        if (sSysName != null && sSysName.length() > 30)
            sSysName = sSysName.substring(0, 30);
        pageDE.setAC_ABBR_PREF_NAME(sAbbName);
        pageDE.setAC_SYS_PREF_NAME(sSysName);
        // set pref name accoding to teh type
        if (selNameType.equals("SYS"))
            pageDE.setDE_PREFERRED_NAME(sSysName);
        else if (selNameType.equals("ABBR"))
            pageDE.setDE_PREFERRED_NAME(sAbbName);
        else if (selNameType.equals("USER")) // store the user typeed name
            pageDE.setDE_PREFERRED_NAME(sUsrName);
        // update long name and defintion if dec or vd is searched
        if (!sOrigin.equalsIgnoreCase("openDE")) // (sOrigin.equals("Search"))
        {
            pageDE.setDE_LONG_NAME(sLongName);
            pageDE.setDE_PREFERRED_DEFINITION(sDef);
            pageDE.setDEC_VD_CHANGED(true); // mark as changed
        }
        // update session attributes
        //DataManager.setAttribute(session, "m_DE", pageDE);
        return pageDE;
    }

    /**
     * changes the dec name type as selected
     *
     * @param req
     *            HttpServletRequest
     * @param res
     *            HttpServletResponse
     * @param sOrigin
     *            string of origin action of the ac
     * @throws java.lang.Exception
     */
    private void doChangeDENameType() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        // get teh selected type from teh page
        DE_Bean pageDE = (DE_Bean) session.getAttribute("m_DE");
        // capture all other attributes
        m_setAC.setDEValueFromPage(m_classReq, m_classRes, pageDE);
        String sSysName = pageDE.getAC_SYS_PREF_NAME();
        String sAbbName = pageDE.getAC_ABBR_PREF_NAME();
       // String sUsrName = pageDE.getAC_USER_PREF_NAME();
        String sNameType = (String) m_classReq.getParameter("rNameConv");
        if (sNameType == null)
            sNameType = "";
        // logger.debug(sSysName + " name abb " + sAbbName + " name usr " + sUsrName);
        // get the existing preferred name to make sure earlier typed one is saved in the user
        String sPrefName = (String) m_classReq.getParameter("txtPreferredName");
        if (sPrefName != null && !sPrefName.equals("") && !sPrefName.equals("(Generated by the System)")
                        && !sPrefName.equals(sSysName) && !sPrefName.equals(sAbbName))
            pageDE.setAC_USER_PREF_NAME(sPrefName); // store typed one in de bean
        // reset system generated or abbr accoring
        if (sNameType.equals("SYS"))
            pageDE.setDE_PREFERRED_NAME(sSysName);
        else if (sNameType.equals("ABBR"))
            pageDE.setDE_PREFERRED_NAME(sAbbName);
        else if (sNameType.equals("USER"))
            pageDE.setDE_PREFERRED_NAME(pageDE.getAC_USER_PREF_NAME());
        // store the type in the bean
        pageDE.setAC_PREF_NAME_TYPE(sNameType);
        // logger.debug(pageDE.getAC_PREF_NAME_TYPE() + " pref " + pageDE.getDE_PREFERRED_NAME());
        DataManager.setAttribute(session, "m_DE", pageDE);
    }

    /**
     * Called from doCreateDEActions. Calls 'setAC.setDEValueFromPage' to set the DEC data from the page. Calls
     * 'setAC.setValidatePageValuesDE' to validate the data. Loops through the vector vValidate to check if everything
     * is valid and Calls 'doInsertDE' to insert the data. If vector contains invalid fields, forwards to validation
     * page
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doSubmitDE() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        DataManager.setAttribute(session, "sCDEAction", "validate");
        DE_Bean m_DE = (DE_Bean) session.getAttribute("m_DE");
        if (m_DE == null)
            m_DE = new DE_Bean();
        GetACService getAC = new GetACService(m_classReq, m_classRes, this);
        m_setAC.setDEValueFromPage(m_classReq, m_classRes, m_DE);
        m_setAC.setValidatePageValuesDE(m_classReq, m_classRes, m_DE, getAC);
        DataManager.setAttribute(session, "m_DE", m_DE);
        boolean isValid = true;
        boolean isValidFlag = true;
        Vector vValidate = new Vector();
        vValidate = (Vector) m_classReq.getAttribute("vValidate");
        if (vValidate == null)
            isValid = false;
        else
        {
            for (int i = 0; vValidate.size() > i; i = i + 3)
            {
                String sStat = (String) vValidate.elementAt(i + 2);
                if ((sStat.equals("Valid") || sStat
                                .equals("Warning: A Data Element with a duplicate DEC and VD pair already exists within the selected context. ")))
                    isValid = true; // this just keeps the status quo
                else
                    isValidFlag = false; // we have true failure here
            }
            isValid = isValidFlag;
        }
        if (isValid == false)
        {
            ForwardJSP(m_classReq, m_classRes, "/ValidateDEPage.jsp");
        }
        else
        {
            doInsertDE();
        }
    } // end of doSumitDE

    /**
     * The doValidateDE method gets the values from page the user filled out, validates the input, then forwards results
     * to the Validate page Called from 'doCreateDEActions' method. Calls 'setAC.setDEValueFromPage' to set the data
     * from the page to the bean. Calls 'setAC.setValidatePageValuesDE' to validate the data. Stores 'm_DE' bean in
     * session. Forwards the page 'ValidateDEPage.jsp' with validation vector to display.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doValidateDE() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        // do below for versioning to check whether these two have changed
        DataManager.setAttribute(session, "DEEditAction", "DEEdit");
        DataManager.setAttribute(session, "sCDEAction", "validate");
        DE_Bean m_DE = (DE_Bean) session.getAttribute("m_DE");
        if (m_DE == null)
            m_DE = new DE_Bean();
        GetACService getAC = new GetACService(m_classReq, m_classRes, this);
        m_setAC.setDEValueFromPage(m_classReq, m_classRes, m_DE);
        m_setAC.setValidatePageValuesDE(m_classReq, m_classRes, m_DE, getAC);
        DataManager.setAttribute(session, "m_DE", m_DE);
        ForwardJSP(m_classReq, m_classRes, "/ValidateDEPage.jsp");
    } // end of doValidateDE

    /**
     * The doValidateDE method gets the values from page the user filled out, validates the input, then forwards results
     * to the Validate page Called from 'doCreateDEActions' method. Calls 'setAC.setDEValueFromPage' to set the data
     * from the page to the bean. Calls 'setAC.setValidatePageValuesDE' to validate the data. Stores 'm_DE' bean in
     * session. Forwards the page 'ValidateDEPage.jsp' with validation vector to display.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doValidateDEBlockEdit() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        DataManager.setAttribute(session, "sCDEAction", "validate");
        DataManager.setAttribute(session, "DEAction", "EditDE");
        DE_Bean m_DE = (DE_Bean) session.getAttribute("m_DE");
        if (m_DE == null)
            m_DE = new DE_Bean();
        // GetACService getAC = new GetACService(req, res, this);
        m_setAC.setDEValueFromPage(m_classReq, m_classRes, m_DE);
        DataManager.setAttribute(session, "m_DE", m_DE);
        m_setAC.setValidateBlockEdit(m_classReq, m_classRes, "DataElement");
        DataManager.setAttribute(session, "DEEditAction", "DEBlockEdit");
        ForwardJSP(m_classReq, m_classRes, "/ValidateDEPage.jsp");
    } // end of doValidateDE

    /**
     * update record in the database and display the result. Called from 'doInsertDE' method when the aciton is editing.
     * Retrieves the session bean m_DE. calls 'insAC.setDE' to update the database. calls 'serAC.refreshData' to get the
     * refreshed search result forwards the page back to search page with refreshed list after updating.
     *
     * If ret is not null stores the statusMessage as error message in session and forwards the page back to
     * 'EditDEPage.jsp' for Edit.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doUpdateDEAction() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        InsACService insAC = new InsACService(m_classReq, m_classRes, this); //
        DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
        DE_Bean oldDEBean = (DE_Bean) session.getAttribute("oldDEBean");
        // udpate the status message with DE name and ID
        storeStatusMsg("Data Element Name : " + DEBean.getDE_LONG_NAME());
        storeStatusMsg("Public ID : " + DEBean.getDE_MIN_CDE_ID());
        // call stored procedure to update attributes
        String ret = insAC.setDE("UPD", DEBean, "Edit", oldDEBean);
        // forwards to search page if successful
        if ((ret == null) || ret.equals(""))
        {
            ret = insAC.setDDE(DEBean.getDE_DE_IDSEQ(), ""); // set DEComp rules and relations
            GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
            String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
            // forward to search page with the refreshed question list
            if (sMenuAction.equals("Questions"))
            {
                DataManager.setAttribute(session, "searchAC", "Questions");
                Quest_Bean questBean = (Quest_Bean) session.getAttribute("m_Quest");
                if (questBean != null)
                {
                    questBean.setQUEST_DEFINITION(DEBean.getDE_PREFERRED_DEFINITION());
                    questBean.setSUBMITTED_LONG_NAME(DEBean.getDOC_TEXT_PREFERRED_QUESTION());
                    questBean.setDE_IDSEQ(DEBean.getDE_DE_IDSEQ());
                    questBean.setDE_LONG_NAME(DEBean.getDE_LONG_NAME());
                    questBean.setVD_IDSEQ(DEBean.getDE_VD_IDSEQ());
                    questBean.setVD_LONG_NAME(DEBean.getDE_VD_NAME());
                    questBean.setSTATUS_INDICATOR("Edit");
                    serAC.refreshData(m_classReq, m_classRes, null, null, null, questBean, "Edit", "");
                    // reset the appened attributes to remove all the checking of the row
                    Vector vCheck = new Vector();
                    DataManager.setAttribute(session, "CheckList", vCheck);
                    DataManager.setAttribute(session, "AppendAction", "Not Appended");
                    // call the method to update Quest contents table
                    ret = insAC.setQuestContent(questBean, "", "");
                    DataManager.setAttribute(session, "m_Quest", questBean);
                }
            }
            else
            {
                DEBean.setDE_ALIAS_NAME(DEBean.getDE_PREFERRED_NAME());
                DEBean.setDE_TYPE_NAME("PRIMARY");
                String oldID = oldDEBean.getDE_DE_IDSEQ();
                serAC.refreshData(m_classReq, m_classRes, DEBean, null, null, null, "Edit", oldID);
            }
            ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp"); // forward to search page
        }
        // back to edit page if not successful
        else
        {
            // DataManager.setAttribute(session, "statusMessage", ret + " - Unable to update Data Element successfully.");
            DataManager.setAttribute(session, "sCDEAction", "nothing");
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp"); // send it back to edit page
        }
    }

    /**
     * The doInsertDE method to insert or update record in the database. Called from 'service' method where reqType is
     * 'validateDEFromForm'. Retrieves the session bean m_DE. if the action is reEditDE forwards the page back to Edit
     * or create pages. Otherwise, calls 'insAC.setDE' to submit the record to the database null value return would
     * store the statusMessage as successful in session and forwards the page 'SearchResultsPage.jsp' for create new
     * from template, new version, or Edit actions, and 'CreateDEPage.jsp' for create new DE action. If ret is not null
     * stores the statusMessage as error message in session and forwards the page 'CreateDEPage.jsp' for create and
     * 'EditDEPage.jsp' for Edit.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doInsertDE() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        // make sure that status message is empty
        DataManager.setAttribute(session, Session_Data.SESSION_STATUS_MESSAGE, "");
        Vector vStat = new Vector();
        DataManager.setAttribute(session, "vStatMsg", vStat);
        String sAction = (String) m_classReq.getParameter("ValidateDEPageAction");
        String sDEEditAction = (String) session.getAttribute("DEEditAction");
        if (sDEEditAction == null)
            sDEEditAction = "";
        String sOriginAction = (String) session.getAttribute("originAction");
        if (sOriginAction == null)
            sOriginAction = "";
        String sDEAction = (String) session.getAttribute("DEAction");
        if (sDEAction == null)
            sDEAction = "";
        //String sMenu = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
        if (sAction == null)
            sAction = "submitting"; // covers direct submits without going to Validate page
        if (sAction != null)
        {
            // go back from validation page according editing or creating action
            if (sAction.equals("reEditDE"))
            {
                if (sDEAction.equals("EditDE"))
                    ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
                else
                    ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
            }
            else
            {
                if (sDEAction.equals("EditDE") && !sOriginAction.equals("BlockEditDE"))
                    doUpdateDEAction();
                // update the data for block editing
                else if (sDEEditAction.equals("DEBlockEdit"))
                    doUpdateDEActionBE();
                // insert a new one if create new, template or version
                else
                    doInsertDEfromMenuAction();
            }
        }
    } // end of doInsertDE

    /**
     * creates new record in the database and display the result. Called from 'doInsertDE' method when the aciton is
     * create new DEC from Menu. Retrieves the session bean m_DE. calls 'insAC.setDE' to insert in the database. calls
     * 'serAC.refreshData' to get the refreshed search result for template/version forwards the page back to create DEC
     * page if new DE or back to search page if template or version after successful insert.
     *
     * If ret is not null stores the statusMessage as error message in session and forwards the page back to
     * 'createDEPage.jsp' for Edit.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doInsertDEfromMenuAction() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        InsACService insAC = new InsACService(m_classReq, m_classRes, this);
        GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
        String ret = "";
        boolean isUpdateSuccess = true;
        String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
       // String sOriginAction = (String) session.getAttribute("originAction");
        String sDDEAction = (String) session.getAttribute("DDEAction");
        // insert the new DE for DDE
        if (sDDEAction.equals("CreateNewDEFComp"))
        {
            doInsertDEComp();
            return;
        }
        DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
        DE_Bean oldDEBean = (DE_Bean) session.getAttribute("oldDEBean");
        // DE version
        if (sMenuAction.equals("NewDEVersion"))
        {
            // udpate the status message with DE name and ID only for version and updates
            storeStatusMsg("Data Element Name : " + DEBean.getDE_LONG_NAME());
            storeStatusMsg("Public ID : " + DEBean.getDE_MIN_CDE_ID());
            // call stored procedure to version and update attributes
            ret = insAC.setAC_VERSION(DEBean, null, null, "DataElement");
            if (ret == null || ret.equals(""))
            {
                // update other attributes
                ret = insAC.setDE("UPD", DEBean, "Version", oldDEBean);
                if (ret != null && !ret.equals(""))
                {
                    // DataManager.setAttribute(session, "statusMessage", ret + " - Created new version but unable to update
                    // attributes successfully.");
                    // add newly created row to searchresults and send it to edit page for update
                    isUpdateSuccess = false;
                    String oldID = oldDEBean.getDE_DE_IDSEQ();
                    DEBean = DEBean.cloneDE_Bean(oldDEBean, "Versioned");
                    serAC.refreshData(m_classReq, m_classRes, DEBean, null, null, null, "Version", oldID);
                }
            }
            else
                storeStatusMsg("\\t " + ret + " - Unable to create new version successfully.");
        }
        else
        { // insert a new one
            ret = insAC.setDE("INS", DEBean, "New", oldDEBean);
        }
        if ((ret == null) || ret.equals(""))
        {
            DataManager.setAttribute(session, "sCDEAction", "nothing");
            DataManager.setAttribute(session, "DECLongID", "nothing");
            DataManager.setAttribute(session, "VDLongID", "nothing");
            // forwards to search page with the refreshed list after success if template or version
            if ((sMenuAction.equals("NewDETemplate")) || (sMenuAction.equals("NewDEVersion")))
            {
                ret = insAC.setDDE(DEBean.getDE_DE_IDSEQ(), "INS"); // set DEComp rules and relationships
                DataManager.setAttribute(session, "searchAC", "DataElement");
                String oldID = oldDEBean.getDE_DE_IDSEQ();
                if (sMenuAction.equals("NewDETemplate"))
                    serAC.refreshData(m_classReq, m_classRes, DEBean, null, null, null, "Template", oldID);
                else if (sMenuAction.equals("NewDEVersion"))
                    serAC.refreshData(m_classReq, m_classRes, DEBean, null, null, null, "Version", oldID);
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            // forward to search page with the refreshed question list
            else if (sMenuAction.equals("Questions"))
            {
                ret = insAC.setDDE(DEBean.getDE_DE_IDSEQ(), "INS"); // set DEComp rules and relationships
                doInitDDEInfo();
                DataManager.setAttribute(session, "searchAC", "Questions");
                Quest_Bean questBean = (Quest_Bean) session.getAttribute("m_Quest");
                if (questBean != null)
                {
                    questBean.setQUEST_DEFINITION(DEBean.getDE_PREFERRED_DEFINITION());
                    questBean.setSUBMITTED_LONG_NAME(DEBean.getDOC_TEXT_PREFERRED_QUESTION());
                    questBean.setDE_IDSEQ(DEBean.getDE_DE_IDSEQ());
                    questBean.setDE_LONG_NAME(DEBean.getDE_LONG_NAME());
                    questBean.setCDE_ID(DEBean.getDE_MIN_CDE_ID());
                    questBean.setVD_IDSEQ(DEBean.getDE_VD_IDSEQ());
                    questBean.setVD_LONG_NAME(DEBean.getDE_VD_NAME());
                    questBean.setSTATUS_INDICATOR("Edit");
                    serAC.refreshData(m_classReq, m_classRes, null, null, null, questBean, "Edit", "");
                    // reset the appened attributes to remove all the checking of the row
                    Vector vCheck = new Vector();
                    DataManager.setAttribute(session, "CheckList", vCheck);
                    DataManager.setAttribute(session, "AppendAction", "Not Appended");
                    // call the method to update Quest contents table
                    ret = insAC.setQuestContent(questBean, "", "");
                    // //// to get new DE's CDE_ID, reload all questions
                    String userName = (String) session.getAttribute("Username");
                    // call to search questions
                    Vector vResult = new Vector();
                    serAC.doQuestionSearch(userName, vResult);
                    DataManager.setAttribute(session, "vACSearch", vResult);
                    DataManager.setAttribute(session, "vSelRows", vResult);
                    vResult = new Vector<String>();
                    serAC.getQuestionResult(m_classReq, m_classRes, vResult);
                    DataManager.setAttribute(session, "results", vResult);
                    // ///////////////////////////
                    if (ret != null && !ret.equals(""))
                        storeStatusMsg("\\t " + ret + " : Unable to update CRF Questions.");
                    else
                        storeStatusMsg("\\t Successfully updated CRF Questions.");
                    DataManager.setAttribute(session, "m_Quest", questBean);
                }
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            }
            // forwards back to create page with empty data if create new
            else
            {
                ret = insAC.setDDE(DEBean.getDE_DE_IDSEQ(), ""); // after Primery DE created, set DEComp rules and
                                                                    // relationship
                doInitDDEInfo();
                DEBean = new DE_Bean();
                DEBean.setDE_ASL_NAME("DRAFT NEW");
                DEBean.setAC_PREF_NAME_TYPE("SYS");
                DataManager.setAttribute(session, "m_DE", DEBean);
                ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
            }
        }
        // sends back to create page with the error message.
        else
        {
            DataManager.setAttribute(session, "sCDEAction", "validate");
            // forward to create or edit pages
            if (isUpdateSuccess == false)
                ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
            else
                ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
    } // end of doInsertDEfromMenuAction

    /**
     * creates new DE Component and back to CreateDE/EditDE. Called from 'doInsertDEfromMenuAction' method when
     * 'originAction' is 'CreateNewDEFComp'. Retrieves the session bean m_DE. calls 'insAC.setDE' to insert in the
     * database.
     *
     * If ret is not null stores the statusMessage as error message in session and forwards the page back to
     * 'createDEPage.jsp' for Edit.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    private void doInsertDEComp() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        InsACService insAC = new InsACService(m_classReq, m_classRes, this);
        String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
        String ret = "";
        DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
        DE_Bean oldDEBean = (DE_Bean) session.getAttribute("oldDEBean");
        DE_Bean pDEBean = (DE_Bean) session.getAttribute("p_DEBean");
        DE_Bean pOldBean = (DE_Bean) session.getAttribute("p_oldBean");
        // insert a new one
        ret = insAC.setDE("INS", DEBean, "New", oldDEBean);
        if ((ret == null) || ret.equals("")) // set session vectors
        {
            // One DEComp for DDE is created, add it to vDEComp and back to CreateDE page or EditDE page
            // get exist vDEComp vectors from session
            Vector<String> vDEComp = new Vector<String>();
            Vector<String> vDECompID = new Vector<String>();
            Vector<String> vDECompOrder = new Vector<String>();
            Vector<String> vDECompRelID = new Vector<String>();
            vDEComp = (Vector) session.getAttribute("vDEComp");
            vDECompID = (Vector) session.getAttribute("vDECompID");
            vDECompOrder = (Vector) session.getAttribute("vDECompOrder");
            vDECompRelID = (Vector) session.getAttribute("vDECompRelID");
            int iCount = vDEComp.size() + 1;
            String sCount = Integer.toString(iCount);
            // add new one to v
            String sName = DEBean.getDE_LONG_NAME();
            if (sName == null || sName.equals(""))
                sName = DEBean.getDE_PREFERRED_NAME();
            vDEComp.addElement(sName);
            vDECompID.addElement(DEBean.getDE_DE_IDSEQ());
            vDECompOrder.addElement(sCount);
            vDECompRelID.addElement("newDEComp");
            // set v back
            DataManager.setAttribute(session, "vDEComp", vDEComp);
            DataManager.setAttribute(session, "vDECompID", vDECompID);
            DataManager.setAttribute(session, "vDECompOrder", vDECompOrder);
            DataManager.setAttribute(session, "vDECompRelID", vDECompRelID);
            // change flag
            DataManager.setAttribute(session, "originAction", "DECompCreated");
            DataManager.setAttribute(session, "DDEAction", "nothing"); // reset from "CreateNewDEFComp"
            DataManager.setAttribute(session, "m_DE", pDEBean); // back old DE (replace DDE) to session for edit
            DataManager.setAttribute(session, "oldDEBean", pOldBean); // store old de bean back
            DataManager.setAttribute(session, "sCDEAction", "nothing");
            DataManager.setAttribute(session, "DECLongID", "nothing");
            DataManager.setAttribute(session, "VDLongID", "nothing");
        }
        else
        {
            DataManager.setAttribute(session, "sCDEAction", "validate");
        }
        // sends back to create page with the error message.
        if (sMenuAction.equalsIgnoreCase("EditDE"))
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        else
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
    } // end of doInsertDEComp

    /**
     * updates bean the selected DE from the changed values of block edit.
     *
     * @param DEBeanSR
     *            selected DE bean from search result
     * @param de
     *            DE_Bean of the changed values.
     * @param req
     *            request object
     * @param res
     *            response object
     */
    private void InsertEditsIntoDEBeanSR(DE_Bean DEBeanSR, DE_Bean de)
    {
        try
        {
            // get all attributes of DEBean, if attribute != "" then set that attribute of DEBeanSR
            String sDefinition = de.getDE_PREFERRED_DEFINITION();
            if (sDefinition == null)
                sDefinition = "";
            if (!sDefinition.equals(""))
                DEBeanSR.setDE_PREFERRED_DEFINITION(sDefinition);
            // do dec/vd/registration status uniqueness check before making changes.
            DEC_Bean Pdec = de.getDE_DEC_Bean();
            if (Pdec == null)
                Pdec = new DEC_Bean();
            VD_Bean Pvd = de.getDE_VD_Bean();
            if (Pvd == null)
                Pvd = new VD_Bean();
            // get the dec vd ids frm teh page beans
            String sDEC_ID = Pdec.getDEC_DEC_IDSEQ(); // de.getDE_DEC_IDSEQ();
            if (sDEC_ID == null)
                sDEC_ID = "";
            String sVD_ID = Pvd.getVD_VD_IDSEQ(); // de.getDE_VD_IDSEQ();
            if (sVD_ID == null)
                sVD_ID = "";
            String RegStatus = de.getDE_REG_STATUS();
            if (RegStatus == null)
                RegStatus = "";
            // store the old reg status; get the dec vd idseqs from the sr bean
            DEC_Bean SRdec = DEBeanSR.getDE_DEC_Bean();
            if (SRdec == null)
                SRdec = new DEC_Bean();
            VD_Bean SRvd = DEBeanSR.getDE_VD_Bean();
            if (SRvd == null)
                SRvd = new VD_Bean();
            String oldDEC = SRdec.getDEC_DEC_IDSEQ(); // DEBeanSR.getDE_DEC_IDSEQ();
            String oldVD = SRvd.getVD_VD_IDSEQ(); // DEBeanSR.getDE_VD_IDSEQ();
            String oldReg = DEBeanSR.getDE_REG_STATUS();
            if (oldReg == null)
                oldReg = "";
            // update the bean with only the changed data
            if (!sDEC_ID.equals(""))
                DEBeanSR.setDE_DEC_IDSEQ(sDEC_ID);
            if (!sVD_ID.equals(""))
                DEBeanSR.setDE_VD_IDSEQ(sVD_ID);
            if (!RegStatus.equals(""))
                DEBeanSR.setDE_REG_STATUS(RegStatus);
            // do the validation for dec-vd pair
            SetACService setAC = new SetACService(this);
            GetACService getAC = new GetACService(m_classReq, m_classRes, this);
            String sValid = setAC.checkUniqueDECVDPair(DEBeanSR, getAC, "Edit", "Edit");
            // put back to old if not valid even if it is just warning
            boolean newDECVD = true;
            if (sValid != null && !sValid.equals(""))
            {
                String changeAC = "\\t Please note that "; // message if old one has the problem
                if (!sDEC_ID.equals(""))
                {
                    DEBeanSR.setDE_DEC_IDSEQ(oldDEC);
                    changeAC = "\\t Unable to update the Data Element Concept because \\n\\t";
                    newDECVD = false;
                }
                else if (!sVD_ID.equals(""))
                {
                    DEBeanSR.setDE_VD_IDSEQ(oldVD);
                    changeAC = "\\t Unable to update the Value Domain because \\n\\t";
                    newDECVD = false;
                }
                storeStatusMsg(changeAC
                                + "the combination of DEC, VD and Context already exists in other Data Elements.\\n");
            }
            // do the validation for reg status
            String sReg = RegStatus;
            if (sReg.equals(""))
                sReg = oldReg;
            if (sReg == null)
                sReg = "";
            if (sReg.equalsIgnoreCase("Standard") || sReg.equalsIgnoreCase("Candidate")
                            || sReg.equalsIgnoreCase("Proposed"))
            {
                String sDEC = DEBeanSR.getDE_DEC_IDSEQ();
                String sRegValid = setAC.checkDECOCExist(sDEC, m_classReq, m_classRes);
                if (sRegValid != null && !sRegValid.equals(""))
                {
                    // go back to old one
                    String changeAC = "\\t Please note that "; // message if old one has the problem
                    boolean isRegChange = false;
                    if (!RegStatus.equals(""))
                    {
                        // check if old one is also standard
                        if (!oldReg.equalsIgnoreCase("Standard") && !oldReg.equalsIgnoreCase("Candidate")
                                        && !oldReg.equalsIgnoreCase("Proposed"))
                        {
                            DEBeanSR.setDE_REG_STATUS(oldReg);
                            changeAC = "\\t Unable to update the Registration Status because \\n\\t";
                            isRegChange = true;
                        }
                    }
                    // need to put back old dec, since can't do anything with Reg status
                    if (!sDEC_ID.equals("") && isRegChange == false)
                    {
                        DEBeanSR.setDE_DEC_IDSEQ(oldDEC);
                        changeAC = "\\t Unable to update the Data Element Concept because \\n\\t";
                        newDECVD = false;
                    }
                    storeStatusMsg(changeAC
                                    + "the Data Element Concept is not associated with an Object Class.\\n");
                }
            }
            // update the names and the bean if dec and vd are valid
            String sDEC = de.getDE_DEC_NAME();
            if (sDEC == null)
                sDEC = "";
            if (!sDEC.equals("") && newDECVD)
            {
                DEBeanSR.setDE_DEC_NAME(sDEC);
                DEBeanSR.setDE_DEC_Bean(de.getDE_DEC_Bean());
            }
            String sVD = de.getDE_VD_NAME();
            if (sVD == null)
                sVD = "";
            if (!sVD.equals("") && newDECVD)
            {
                DEBeanSR.setDE_VD_NAME(sVD);
                DEBeanSR.setDE_VD_Bean(de.getDE_VD_Bean());
            }
            // get preferred name if not user and not released
            String prefType = de.getAC_PREF_NAME_TYPE();
          //  String oldName = DEBeanSR.getDE_PREFERRED_NAME();
            String oldASL = DEBeanSR.getDE_ASL_NAME();
            if (oldASL == null)
                oldASL = "";
            String pageVer = de.getDE_VERSION();
            if (pageVer == null)
                pageVer = "";
            if (prefType != null && !prefType.equals("USER"))
            {
                DEBeanSR.setAC_PREF_NAME_TYPE(prefType);
                if (oldASL.equals("RELEASED") && !(pageVer.equals("Point") || pageVer.equals("Whole")))
                    storeStatusMsg("\\t Unable to update the Short Name because \\n"
                                    + "\\t the Workflow Status of the Data Element is RELEASED.\\n");
                else
                    DEBeanSR = (DE_Bean) this.getACNames("noChange", "openDE", DEBeanSR);
            }
            // check the workflow status
            String sASL = de.getDE_ASL_NAME();
            if (sASL != null && !sASL.equals(""))
            {
                String wfsValid = m_setAC.checkReleasedWFS(DEBeanSR, sASL);
                if (wfsValid.equals(""))
                    DEBeanSR.setDE_ASL_NAME(sASL);
                else
                    // do not update
                    storeStatusMsg("\\t Unable to update the Workflow Status because " + wfsValid + "\\n");
            }
            // other attributes
            String sDocText = de.getDOC_TEXT_PREFERRED_QUESTION();
            if (sDocText == null)
                sDocText = "";
            if (!sDocText.equals(""))
                DEBeanSR.setDOC_TEXT_PREFERRED_QUESTION(sDocText);
            String sBeginDate = de.getDE_BEGIN_DATE();
            if (sBeginDate == null)
                sBeginDate = "";
            if (!sBeginDate.equals(""))
                DEBeanSR.setDE_BEGIN_DATE(sBeginDate);
            String sEndDate = de.getDE_END_DATE();
            if (sEndDate == null)
                sEndDate = "";
            if (!sEndDate.equals(""))
                DEBeanSR.setDE_END_DATE(sEndDate);
            String sSource = de.getDE_SOURCE();
            if (sSource == null)
                sSource = "";
            if (!sSource.equals(""))
                DEBeanSR.setDE_SOURCE(sSource);
            String changeNote = de.getDE_CHANGE_NOTE();
            if (changeNote == null)
                changeNote = "";
            if (!changeNote.equals(""))
                DEBeanSR.setDE_CHANGE_NOTE(changeNote);
            // get cs-csi from the page into the DECBean for block edit
            Vector<AC_CSI_Bean> vAC_CS = de.getAC_AC_CSI_VECTOR();
            if (vAC_CS != null)
                DEBeanSR.setAC_AC_CSI_VECTOR(vAC_CS);
            //get the Ref docs from the page into the DEBean for block edit
            Vector<REF_DOC_Bean> vAC_REF_DOCS = de.getAC_REF_DOCS();
            if(vAC_REF_DOCS!=null){
            	Vector<REF_DOC_Bean> temp_REF_DOCS = new Vector<REF_DOC_Bean>();
            for(REF_DOC_Bean refBean:vAC_REF_DOCS )
            {
            	if(refBean.getAC_IDSEQ() == DEBeanSR.getDE_DE_IDSEQ())
            	{
            		temp_REF_DOCS.add(refBean);
            	}
            }
            DEBeanSR.setAC_REF_DOCS(temp_REF_DOCS);
            }
        }
        catch (Exception e)
        {
            logger.error("Error - InsertEditsIntoDEBeanSR ", e);
        }
    }

    /**
     * updates bean the selected DE from the changed values of block edit.
     *
     * @param DEBeanSR
     *            selected DE bean from search result
     * @param de
     *            DE_Bean of the changed values.
     * @param req
     * @param res
     *
     * @return String valid if no version error
     * @throws Exception
     */
    private String InsertVersionDEBeanSR(DE_Bean DEBeanSR, DE_Bean de)
                    throws Exception
    {
        // get the version number if versioned
        String version = de.getDE_VERSION();
        String lastVersion = (String) DEBeanSR.getDE_VERSION();
        if (lastVersion == null)
            lastVersion = "";
        String verError = "valid";
        GetACService getAC = new GetACService(m_classReq, m_classRes, this);
        String sValid = m_setAC.checkUniqueDECVDPair(DEBeanSR, getAC, "Edit", "Edit");
        if (sValid != null && !sValid.equals("")) // version only if valid dec-vd pair
        {
            storeStatusMsg("\\t Unable to create new version because \\n"
                            + "\\t the combination of DEC, VD and Context already exists in other Data Elements.\\n");
            verError = "decvdError";
        }
        else
        // get the right version number
        {
            String newVersion = this.getNewVersionNumber(version, lastVersion);
            if (newVersion != null && !newVersion.equals(""))
                DEBeanSR.setDE_VERSION(newVersion);
            else
            {
                storeStatusMsg("\\t Unable to create new version because \\n"
                                + "\\t new version of the Data Element is not available.\\n");
                verError = "verNumError";
            }
        }
        return verError;
    }

    /**
     * update record in the database and display the result. Called from 'doInsertDEC' method when the aciton is
     * editing. Retrieves the session bean m_DEC. calls 'insAC.setDE' to update the database. otherwise calls
     * 'serAC.refreshData' to get the refreshed search result forwards the page back to search page with refreshed list
     * after updating.
     *
     * If ret is not null stores the statusMessage as error message in session and forwards the page back to
     * 'EditDEPage.jsp' for Edit.
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doUpdateDEActionBE() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        DE_Bean DEBean = (DE_Bean) session.getAttribute("m_DE");
        if (DEBean == null)
            DEBean = new DE_Bean();
        String ret = ":";
        DataManager.setAttribute(session, "DEEditAction", ""); // reset this
        boolean isRefreshed = false;
        InsACService insAC = new InsACService(m_classReq, m_classRes, this);
        GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
        GetACService getAC = new GetACService(m_classReq, m_classRes, this);
        Vector vBERows = (Vector) session.getAttribute("vBEResult");
        int vBESize = vBERows.size();
        Integer vBESize2 = new Integer(vBESize);
        m_classReq.setAttribute("vBESize", vBESize2);
        if (vBERows.size() > 0)
        {
            // Be sure the buffer is loaded when doing versioning.
            String newVersion = DEBean.getDE_VERSION();
            if (newVersion == null)
                newVersion = "";
            boolean newVers = (newVersion.equals("Point") || newVersion.equals("Whole"));
            if (newVers)
            {
                @SuppressWarnings("unchecked")
                Vector<AC_Bean> tvec = vBERows;
                AltNamesDefsSession.loadAsNew(this, session, tvec);
            }
            for (int i = 0; i < (vBERows.size()); i++)
            {
                DE_Bean DEBeanSR = new DE_Bean();
                DEBeanSR = (DE_Bean) vBERows.elementAt(i);
                // udpate the status message with DE name and ID
                storeStatusMsg("Data Element Name : " + DEBeanSR.getDE_LONG_NAME());
                storeStatusMsg("Public ID : " + DEBeanSR.getDE_MIN_CDE_ID());
                DE_Bean oldDEBean = new DE_Bean();
                oldDEBean = oldDEBean.cloneDE_Bean(DEBeanSR, "Complete");
              //  String oldName = (String) DEBeanSR.getDE_PREFERRED_NAME();
                // gets all the data from the page
                InsertEditsIntoDEBeanSR(DEBeanSR, DEBean);
                // DataManager.setAttribute(session, "m_DE", DEBeanSR);
                String oldID = oldDEBean.getDE_DE_IDSEQ();
                // creates a new version
                if (newVers) // block version
                {
                    String validVer = this.InsertVersionDEBeanSR(DEBeanSR, DEBean);
                    if (validVer != null && validVer.equals("valid"))
                    {
                        // insert a new row with new version
                        String strValid = m_setAC.checkUniqueInContext("Version", "DE", DEBeanSR, null, null, getAC,
                                        "version");
                        if (strValid != null && !strValid.equals(""))
                            ret = "unique constraint";
                        else
                            ret = insAC.setAC_VERSION(DEBeanSR, null, null, "DataElement");
                        if ((ret == null) || ret.equals(""))
                        {
                            // update this new row with changed attributes
                            ret = insAC.setDE("UPD", DEBeanSR, "Version", oldDEBean);
                            if ((ret == null) || ret.equals(""))
                            {
                                // do dde updates for new version
                                serAC.getDDEInfo(oldDEBean.getDE_DE_IDSEQ()); // get info, set session attributes
                                DataManager.setAttribute(session, "sRulesAction", "newRule"); // reset the rules action attribute
                                ret = insAC.setDDE(DEBeanSR.getDE_DE_IDSEQ(), ""); // set DEComp rules and relations
                                // save the status message and retain the this row in the vector
                                serAC.refreshData(m_classReq, m_classRes, DEBeanSR, null, null, null, "Version", oldID);
                                isRefreshed = true;
                                // reset the appened attributes to remove all the checking of the row
                                Vector vCheck = new Vector();
                                DataManager.setAttribute(session, "CheckList", vCheck);
                                DataManager.setAttribute(session, "AppendAction", "Not Appended");
                            }
                        }
                        // alerady exists
                        else if (ret.indexOf("unique constraint") >= 0)
                            storeStatusMsg("\\t The new version " + DEBeanSR.getDE_VERSION()
                                            + " already exists in the data base.\\n");
                        // some other problem
                        else
                            storeStatusMsg("\\t " + ret + " : Unable to create new version "
                                            + DEBeanSR.getDE_VERSION() + "\\n");
                    }
                }
                else
                // block edit
                {
                    ret = insAC.setDE("UPD", DEBeanSR, "Edit", oldDEBean);
                    if ((ret == null) || ret.equals(""))
                    {
                        serAC.refreshData(m_classReq, m_classRes, DEBeanSR, null, null, null, "Edit", oldID);
                        isRefreshed = true;
                    }
                }
            }
            AltNamesDefsSession.blockSave(this, session);
        }
        // to get the final result vector if not refreshed at all
        if (!(isRefreshed))
        {
            Vector<String> vResult = new Vector<String>();
            serAC.getDEResult(m_classReq, m_classRes, vResult, "");
            DataManager.setAttribute(session, "results", vResult); // store the final result in the session
            DataManager.setAttribute(session, "DEPageAction", "nothing");
        }
        // forward to search page.
        ForwardJSP(m_classReq, m_classRes, "/SearchResultsPage.jsp");
    }

    /**
     * The doOpenCreateDECompPage method get current primary DE bean, seve it to session as old DE Bean, then forward to
     * CreateDE page for DE Comp. It is called from doCreateDEActions and doEditDEActions
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doOpenCreateDECompPage() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        // DataManager.setAttribute(session, "originAction", "CreateNewDEFComp");
        DataManager.setAttribute(session, "DDEAction", "CreateNewDEFComp");
        // store the old bean into primary old bean
        DE_Bean oldBean = (DE_Bean) session.getAttribute("oldDEBean");
        if (oldBean == null)
            oldBean = new DE_Bean();
        DE_Bean primBean = oldBean.cloneDE_Bean(oldBean, "Complete");
        DataManager.setAttribute(session, "p_oldBean", primBean);
        // store the page bean into primary bean
        DE_Bean m_DE = (DE_Bean) session.getAttribute("m_DE");
        if (m_DE == null)
            m_DE = new DE_Bean();
        m_setAC.setDEValueFromPage(m_classReq, m_classRes, m_DE); // store DE bean
        DataManager.setAttribute(session, "p_DEBean", m_DE); // save primary DE
        // clear DEBean because new DE Comp
        DE_Bean de = new DE_Bean();
        de.setDE_ASL_NAME("DRAFT NEW");
        de.setAC_PREF_NAME_TYPE("SYS");
        DataManager.setAttribute(session, "m_DE", de);
        DataManager.setAttribute(session, "oldDEBean", new DE_Bean());
        this.clearCreateSessionAttributes(m_classReq, m_classRes); // clear some session attributes
        ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
    }

    /**
     * The doOpenDEPageFromDEComp method set primary DE from old DE Bean back to current DE Bean, then forward to
     * CreateDE page or EditDE page. It is called from doCreateDEActions
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doOpenDEPageFromDEComp() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        String sPageAction = (String) m_classReq.getParameter("pageAction");
        DataManager.setAttribute(session, "DDEAction", "nothing"); // reset from "CreateNewDEFComp"
        // set primary DE back
        DE_Bean pDEBean = new DE_Bean();
        pDEBean = (DE_Bean) session.getAttribute("p_DEBean");
        DataManager.setAttribute(session, "m_DE", pDEBean);
        // set primary oldDE back
        DE_Bean pOldBean = new DE_Bean();
        pOldBean = (DE_Bean) session.getAttribute("p_oldBean");
        DataManager.setAttribute(session, "oldDEBean", pOldBean);
        if (sPageAction.equals("DECompBackToNewDE"))
        {
            DataManager.setAttribute(session, "originAction", "NewDEFromMenu");
            ForwardJSP(m_classReq, m_classRes, "/CreateDEPage.jsp");
        }
        else if (sPageAction.equals("DECompBackToEditDE"))
        {
            DataManager.setAttribute(session, "originAction", "EditDE");
            ForwardJSP(m_classReq, m_classRes, "/EditDEPage.jsp");
        }
    }

    /**
     * The doUpdateDDEInfo get DDE info from jsp page hidden fields and save them to session It is called from
     * doCreateDEActions and doEditDEActions
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    private void doUpdateDDEInfo() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        // Create DDE from CreateDE page, save existed DEComp to session first, then goto CreateDE page for DDE
        // get exist vDEComp vectors from jsp
        String sDEComps[] = m_classReq.getParameterValues("selDECompHidden");
        String sDECompIDs[] = m_classReq.getParameterValues("selDECompIDHidden");
        String sDECompOrders[] = m_classReq.getParameterValues("selDECompOrderHidden");
        String sDECompRelIDs[] = m_classReq.getParameterValues("selDECompRelIDHidden");
        Vector<String> vDEComp = new Vector();
        Vector<String> vDECompID = new Vector();
        Vector<String> vDECompOrder = new Vector();
        Vector<String> vDECompRelID = new Vector();
        if (sDEComps != null && sDECompIDs != null)
        {
            for (int i = 0; i < sDEComps.length; i++)
            {
                String sDEComp = sDEComps[i];
                String sDECompID = sDECompIDs[i];
                String sDECompOrder = sDECompOrders[i];
                String sDECompRelID = sDECompRelIDs[i];
                vDEComp.addElement(sDEComp);
                vDECompID.addElement(sDECompID);
                vDECompOrder.addElement(sDECompOrder);
                vDECompRelID.addElement(sDECompRelID);
            }
            // sort vDEComp against DECompOrder
            UtilService util = new UtilService();
            util.sortDEComps(vDEComp, vDECompID, vDECompRelID, vDECompOrder);
        }
        // save it, even empty, refresh
        DataManager.setAttribute(session, "vDEComp", vDEComp);
        DataManager.setAttribute(session, "vDECompID", vDECompID);
        DataManager.setAttribute(session, "vDECompOrder", vDECompOrder);
        DataManager.setAttribute(session, "vDECompRelID", vDECompRelID);
        // DEComp removed list
        String sDECompDeletes[] = m_classReq.getParameterValues("selDECompDeleteHidden");
        String sDECompDelNames[] = m_classReq.getParameterValues("selDECompDelNameHidden");
        Vector<String> vDECompDelete = new Vector<String>();
        Vector<String> vDECompDelName = new Vector<String>();
        if (sDECompDeletes != null)
        {
            for (int i = 0; i < sDECompDeletes.length; i++)
            {
                String sDECompDelete = sDECompDeletes[i];
                String sDECompDelName = sDECompDelNames[i];
                vDECompDelete.addElement(sDECompDelete);
                vDECompDelName.addElement(sDECompDelName);
                // System.out.println(sDECompDelName + " updte dde info " + sDECompDelete);
            }
        }
        // save it to session
        DataManager.setAttribute(session, "vDECompDelete", vDECompDelete);
        DataManager.setAttribute(session, "vDECompDelName", vDECompDelName);
        // DDE rules
        String sDDERepTypes[] = m_classReq.getParameterValues("selRepType");
        String sRepType = sDDERepTypes[0];
        String sRule = (String) m_classReq.getParameter("DDERule");
        String sMethod = (String) m_classReq.getParameter("DDEMethod");
        String sConcatChar = (String) m_classReq.getParameter("DDEConcatChar");
        if (sRepType != null)
            DataManager.setAttribute(session, "sRepType", sRepType);
        else
            DataManager.setAttribute(session, "sRepType", "");
        if (sConcatChar != null)
            DataManager.setAttribute(session, "sConcatChar", sConcatChar);
        else
            DataManager.setAttribute(session, "sConcatChar", "");
        if (sRule != null)
            DataManager.setAttribute(session, "sRule", sRule);
        else
            DataManager.setAttribute(session, "sRule", "");
        if (sMethod != null)
            DataManager.setAttribute(session, "sMethod", sMethod);
        else
            DataManager.setAttribute(session, "sMethod", "");
    }

    /**
     * The doInitDDEInfo set DDE data to session It is called from doOpenCreateNewPages and doOpenSearchPage
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    private void doInitDDEInfo() throws Exception
    {
        HttpSession session = m_classReq.getSession();
        Vector vDEComp = new Vector();
        Vector vDECompID = new Vector();
        Vector vDECompOrder = new Vector();
        DataManager.setAttribute(session, "vDEComp", vDEComp);
        DataManager.setAttribute(session, "vDECompID", vDECompID);
        DataManager.setAttribute(session, "vDECompOrder", vDECompOrder);
        DataManager.setAttribute(session, "sRepType", "");
        DataManager.setAttribute(session, "NotValidDBType", "");
        DataManager.setAttribute(session, "sConcatChar", "");
        DataManager.setAttribute(session, "sRule", "");
        DataManager.setAttribute(session, "sMethod", "");
        DataManager.setAttribute(session, "sRulesAction", "newRule");
    } // end of doInitDDEInfo

    /**
     * to get Derived DE info and components called when the DerivedDEWindow opened first time and calls
     * 'getAC.getDDEInfo' forwards page back to DerivedDEWindow jsp
     *
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     *
     * @throws Exception
     */
    @SuppressWarnings("unchecked")
    private void doDDEDetailsActions() throws Exception
    {
        HttpSession session = (HttpSession) m_classReq.getSession();
        GetACSearch getAC = new GetACSearch(m_classReq, m_classRes, this);
        String acID = m_classReq.getParameter("acID");
        String acName = m_classReq.getParameter("acName"); // de name for DDE
        String searchType = m_classReq.getParameter("itemType"); // dde type
        // split acID into list if more then one existed
        if (searchType != null && searchType.equals("Component")) // (acID.indexOf(',') > 0)
        {
            String[] ddes = acID.split(",");
            Vector vDDEs = new Vector();
            for (int i = 0; i < ddes.length; i++)
            {
                String sAC = ddes[i];
                sAC = sAC.trim();
                getAC.getDDEInfo(sAC); // call api
                DDE_Bean dde = (DDE_Bean) session.getAttribute("DerivedDE"); // get it from teh session
                if (dde != null)
                    vDDEs.addElement(dde); // store it in the vector
            }
            // store it in the session
            m_classReq.setAttribute("AllDerivedDE", vDDEs);
        }
        else
            // only one
            getAC.getDDEInfo(acID);
        m_classReq.setAttribute("ACName", acName);
        ForwardJSP(m_classReq, m_classRes, "/DerivedDEWindow.jsp");
    }

    public void doOpenViewPage() throws Exception
    {
    	//System.out.println("I am here open view page");
    	HttpSession session = m_classReq.getSession();
    	String acID = (String) m_classReq.getAttribute("acIdseq");
    	if (acID.equals(""))
    		acID = m_classReq.getParameter("idseq");
        Vector<DE_Bean> vList = new Vector<DE_Bean>();
        // get DE's attributes from the database again
        GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
        if (acID != null && !acID.equals(""))
        {
            serAC.doDESearch(acID, "", "", "", "", "", 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                            "", "", "", "", "", "", "", "", "", "", "", vList, "0");
        }
        if (vList.size() > 0) // get all attributes
        {
        	DE_Bean DEBean = (DE_Bean) vList.elementAt(0);
        	DEBean = serAC.getDEAttributes(DEBean, "openView", "viewDE");
            serAC.getDDEInfo(DEBean.getDE_DE_IDSEQ()); // clear dde
            m_classReq.setAttribute("viewDEId", DEBean.getIDSEQ());
            String viewDE = "viewDE" + DEBean.getIDSEQ();
            DataManager.setAttribute(session, viewDE, DEBean);
            String title = "CDE Curation View DE "+DEBean.getDE_LONG_NAME()+ " [" + DEBean.getDE_MIN_CDE_ID() + "v" + DEBean.getDE_VERSION() +"]";
			m_classReq.setAttribute("title", title);
			m_classReq.setAttribute("publicID", DEBean.getDE_MIN_CDE_ID());
			m_classReq.setAttribute("version", DEBean.getDE_VERSION());
           	m_classReq.setAttribute("IncludeViewPage", "EditDE.jsp") ;
       }
     	//ForwardJSP(m_classReq, m_classRes, "/ViewPage.jsp");
    }
	
}
