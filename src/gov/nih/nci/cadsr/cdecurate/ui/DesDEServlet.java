// Copyright (c) 2006 ScenPro, Inc.
// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/DesDEServlet.java,v 1.34 2007-06-04 18:09:10 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import gov.nih.nci.cadsr.cdecurate.tool.AC_CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.ALT_NAME_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DE_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACSearch;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.NCICurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.REF_DOC_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UserBean;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 * @author lhebel
 * 
 */
public class DesDEServlet
{
    public DesDEServlet(NCICurationServlet servlet_, UserBean ub_)
    {
        _servlet = servlet_;
        // Don't need to keep UserBean, signature includes argument for consistency
        // with other Servlet classes.
    }
    
    private String doOpen(HttpServletRequest req, HttpServletResponse res)
    {
        HttpSession session = req.getSession();
        GetACSearch getACSearch = new GetACSearch(req, res, _servlet);
        getACSearch.getSelRowToEdit(req, res, "EditDesDE");
        req.setAttribute("displayType", "Designation");
        session.setAttribute("dispACType", "DataElement");

        return "/EditDesignateDEPage.jsp";
    }
    
    private void doEditNothing(HttpSession session, GetACSearch getACSearch)
    {
        // logger.debug("clearing designate de " + sAction);
        session.setAttribute("AllAltNameList", new Vector());
        session.setAttribute("AllRefDocList", new Vector());
        Vector vACId = (Vector) session.getAttribute("vACId");
        if (vACId == null)
            vACId = new Vector();
        Vector vACName = (Vector) session.getAttribute("vACName");
        DE_Bean deBean = (DE_Bean) session.getAttribute(_beanDE);
        for (int i = 0; i < vACId.size(); i++)
        {
            String deID = (String) vACId.elementAt(i);
            String deName = "";
            if (vACName.size() > i)
                deName = (String) vACName.elementAt(i);
            // get cscsi attributes
            Vector<AC_CSI_Bean> vACCSI = getACSearch.doCSCSI_ACSearch(deID, deName);
            Vector vCS = (Vector) _servlet.m_classReq.getAttribute("selCSNames");
            Vector vCSid = (Vector) _servlet.m_classReq.getAttribute("selCSIDs");
            deBean.setAC_CS_NAME(vCS);
            deBean.setAC_CS_ID(vCSid);
            deBean.setAC_AC_CSI_VECTOR(vACCSI);
            // get alt name attributes
//            Vector vRef = getACSearch.doAltNameSearch(deID, "", "", "EditDesDE", "open");
            // get ref doc attriubtes
//            Vector vAlt = getACSearch.doRefDocSearch(deID, "ALL TYPES", "open");
        }
    }
    
    private void doEditCreate(HttpServletRequest req, HttpServletResponse res, String sAction, HttpSession session) throws Exception
    {
        // logger.debug("inserting data");
        InsACService insAC = new InsACService(req, res, _servlet);
        insAC.doSubmitDesDE(sAction);
        session.setAttribute("CheckList", new Vector()); // empty the check list.
    }

    /**
     * adds alternate names to the vectors
     * 
     * @param req
     * @throws java.lang.Exception
     */
    private void doMarkAddAltNames(HttpServletRequest req) throws Exception
    {
        HttpSession session = req.getSession();
        // get the sessin vectors
        Vector<ALT_NAME_Bean> vAltNames = (Vector) session.getAttribute("AllAltNameList");
        Vector vContext = (Vector) session.getAttribute("vWriteContextDE");
        if (vContext == null)
            vContext = new Vector();
        // add alternate names
        String selName = (String) req.getParameter("txtAltName");
        if (selName == null)
            selName = "";
        selName = selName.trim();
        if (selName.equals(""))
        {
            _servlet.storeStatusMsg("Please enter a text for the alternate name");
            return;
        }
        // get the request vectors
        Vector<String> vACId = (Vector) session.getAttribute("vACId");
        if (vACId == null)
            vACId = new Vector<String>();
        Vector<String> vACName = (Vector) session.getAttribute("vACName");
        if (vACName == null)
            vACName = new Vector<String>();
        String sContID = (String) req.getParameter("selContext");
        String sContext = (String) req.getParameter("contextName");
        if (sContID != null)
            req.setAttribute("desContext", sContID);
        String sLang = (String) req.getParameter("dispLanguage");
        if (sLang != null)
            req.setAttribute("desLang", sLang);
        String selType = (String) req.getParameter("selAltType");
        // handle the context and ac name for new AC (DE, DEC and VD)
        if (vACId.size() < 1)
            vACId.addElement("new");
        if (vACName.size() < 1)
            vACName.addElement("new");
        if (sContID == null || sContID.equals(""))
            sContID = "new";
        // continue with acitons
        for (int i = 0; i < vACId.size(); i++)
        {
            // get ac names
            String acID = (String) vACId.elementAt(i);
            if (acID == null)
                acID = "";
            String acName = "";
            if (vACName.size() > i)
                acName = (String) vACName.elementAt(i);
            // get page attributes
            // check if another record with same type, name, ac and context exists already
            boolean isExist = false;
            for (int k = 0; k < vAltNames.size(); k++)
            {
                ALT_NAME_Bean altBean = (ALT_NAME_Bean) vAltNames.elementAt(k);
                // check if it was existed in the list already
                if (altBean.getALT_TYPE_NAME().equals(selType) && altBean.getALTERNATE_NAME().equals(selName)
                                && altBean.getCONTE_IDSEQ().equals(sContID) && altBean.getAC_IDSEQ().equals(acID))
                {
                    // change the submit action if deleted
                    if (altBean.getALT_SUBMIT_ACTION().equals("DEL"))
                    {
                        // mark it as ins if new one or upd if old one
                        String altID = altBean.getALT_NAME_IDSEQ();
                        if (altID == null || altID.equals("") || altID.equals("new"))
                            altBean.setALT_SUBMIT_ACTION("INS");
                        else
                            altBean.setALT_SUBMIT_ACTION("UPD");
                        vAltNames.setElementAt(altBean, k);
                    }
                    isExist = true;
                }
            }
            // add new one if not existed in the bean already
            if (isExist == false)
            {
                // fill in the bean and vector
                ALT_NAME_Bean AltNameBean = new ALT_NAME_Bean();
                AltNameBean.setALT_NAME_IDSEQ("new");
                AltNameBean.setCONTE_IDSEQ(sContID);
                AltNameBean.setCONTEXT_NAME(sContext);
                AltNameBean.setALTERNATE_NAME(selName);
                AltNameBean.setALT_TYPE_NAME(selType);
                AltNameBean.setAC_LONG_NAME(acName);
                AltNameBean.setAC_IDSEQ(acID);
                AltNameBean.setAC_LANGUAGE(sLang);
                AltNameBean.setALT_SUBMIT_ACTION("INS");
                vAltNames.addElement(AltNameBean);
            }
        }
        session.setAttribute("AllAltNameList", vAltNames);
    }

    /**
     * adds reference documents to the vectors
     * 
     * @param req
     * @throws java.lang.Exception
     */
    private void doMarkAddRefDocs(HttpServletRequest req) throws Exception
    {
        HttpSession session = req.getSession();
        String selName = (String) req.getParameter("txtRefName");
        if (selName == null)
            selName = "";
        selName = selName.trim();
        if (selName.equals(""))
        {
            _servlet.storeStatusMsg("Please enter a text for the alternate name");
            return;
        }
        // continue with adding
        Vector<REF_DOC_Bean> vRefDocs = (Vector) session.getAttribute("AllRefDocList");
        Vector<String> vACId = (Vector) session.getAttribute("vACId");
        if (vACId == null)
            vACId = new Vector<String>();
        Vector<String> vACName = (Vector) session.getAttribute("vACName");
        if (vACName == null)
            vACName = new Vector<String>();
        Vector vContext = (Vector) session.getAttribute("vWriteContextDE");
        if (vContext == null)
            vContext = new Vector();
        // get request attributes
        String sContID = (String) req.getParameter("selContext");
        String sContext = (String) req.getParameter("contextName");
        if (sContID != null)
            req.setAttribute("desContext", sContID);
        String sLang = (String) req.getParameter("dispLanguage");
        if (sLang != null)
            req.setAttribute("desLang", sLang);
        String selType = (String) req.getParameter("selRefType");
        String selText = (String) req.getParameter("txtRefText");
        String selUrl = (String) req.getParameter("txtRefURL");
        // handle the context and ac name for new AC (DE, DEC and VD)
        if (vACId.size() < 1)
            vACId.addElement("new");
        if (vACName.size() < 1)
            vACName.addElement("new");
        if (sContID == null || sContID.equals(""))
            sContID = "new";
        // do add ref doc action
        for (int i = 0; i < vACId.size(); i++)
        {
            // get ac names
            String acID = (String) vACId.elementAt(i);
            if (acID == null)
                acID = "";
            String acName = "";
            if (vACName.size() > i)
                acName = (String) vACName.elementAt(i);
            // check if another record with same type, name, ac and context exists already
            boolean isExist = false;
            for (int k = 0; k < vRefDocs.size(); k++)
            {
                REF_DOC_Bean refBean = (REF_DOC_Bean) vRefDocs.elementAt(k);
                // check if it was existed in the list already
                if (refBean.getDOC_TYPE_NAME().equals(selType) && refBean.getDOCUMENT_NAME().equals(selName)
                                && refBean.getCONTE_IDSEQ().equals(sContID) && refBean.getAC_IDSEQ().equals(acID))
                {
                    // change the submit action if deleted
                    if (refBean.getREF_SUBMIT_ACTION().equals("DEL"))
                    {
                        // mark it as ins if new one or upd if old one
                        String refID = refBean.getREF_DOC_IDSEQ();
                        if (refID == null || refID.equals("") || refID.equals("new"))
                            refBean.setREF_SUBMIT_ACTION("INS");
                        else
                            refBean.setREF_SUBMIT_ACTION("UPD");
                        vRefDocs.setElementAt(refBean, k);
                    }
                    isExist = true;
                }
            }
            // add new one if not existed in the bean already
            if (isExist == false)
            {
                // fill in the bean and vector
                REF_DOC_Bean RefDocBean = new REF_DOC_Bean();
                RefDocBean.setAC_IDSEQ(acID);
                RefDocBean.setAC_LONG_NAME(acName);
                RefDocBean.setREF_DOC_IDSEQ("new");
                RefDocBean.setDOCUMENT_NAME(selName);
                RefDocBean.setDOC_TYPE_NAME(selType);
                RefDocBean.setDOCUMENT_TEXT(selText);
                RefDocBean.setDOCUMENT_URL(selUrl);
                RefDocBean.setCONTE_IDSEQ(sContID);
                RefDocBean.setCONTEXT_NAME(sContext);
                RefDocBean.setAC_LANGUAGE(sLang);
                RefDocBean.setREF_SUBMIT_ACTION("INS");
                vRefDocs.addElement(RefDocBean);
            }
        }
        session.setAttribute("AllRefDocList", vRefDocs);
    }

    /**
     * removes alternate names from the vectors
     * 
     * @param req
     * @throws java.lang.Exception
     */
    private void doMarkRemoveAltNames(HttpServletRequest req) throws Exception
    {
        HttpSession session = req.getSession();
        String stgContMsg = "";
        // get the sessin vectors
        Vector<ALT_NAME_Bean> vAltNames = (Vector) session.getAttribute("AllAltNameList");
        Vector<String> vContext = (Vector) session.getAttribute("vWriteContextDE");
        if (vContext == null)
            vContext = new Vector<String>();
        String sContID = (String) req.getParameter("selContext");
        if (sContID != null)
            req.setAttribute("desContext", sContID);
        int j = -1;
        Vector<String> vAltAttrs = new Vector<String>();
        for (int i = 0; i < vAltNames.size(); i++)
        {
            ALT_NAME_Bean aBean = (ALT_NAME_Bean) vAltNames.elementAt(i);
            if (!aBean.getALT_SUBMIT_ACTION().equals("DEL"))
            {
                String altName = aBean.getALTERNATE_NAME();
                String altType = aBean.getALT_TYPE_NAME();
                String altCont = aBean.getCONTEXT_NAME();
                // go to next record if same type, name and context does exist
                String curAltAttr = altType + " " + altName + " " + altCont;
                // increase the count only if it didn't exist in the disp vecot list
                if (!vAltAttrs.contains(curAltAttr))
                {
                    vAltAttrs.addElement(curAltAttr);
                    j += 1;
                }
                String ckItem = (String) req.getParameter("ACK" + j);
                // get the right selected item to mark as deleted
                if (ckItem != null)
                {
                    if (vContext.contains(altCont) || altCont.equals("") || altCont.equalsIgnoreCase("new"))
                    {
                        aBean.setALT_SUBMIT_ACTION("DEL");
                        vAltNames.setElementAt(aBean, i);
                        // check if another record with same type, name and context but diff ac exists to remove
                        for (int k = 0; k < vAltNames.size(); k++)
                        {
                            ALT_NAME_Bean altBean = (ALT_NAME_Bean) vAltNames.elementAt(k);
                            if (!altBean.getALT_SUBMIT_ACTION().equals("DEL")
                                            && altBean.getALTERNATE_NAME().equals(altName))
                            {
                                if (altBean.getALT_TYPE_NAME().equals(altType)
                                                && altBean.getCONTEXT_NAME().equals(altCont))
                                {
                                    altBean.setALT_SUBMIT_ACTION("DEL");
                                    vAltNames.setElementAt(altBean, k);
                                }
                            }
                        }
                    }
                    else
                        stgContMsg += "\\n\\t" + altName + " in " + altCont + " Context ";
                    break;
                }
            }
        }
        if (stgContMsg != null && !stgContMsg.equals(""))
            _servlet.storeStatusMsg("Unable to remove the following Alternate Names, because the user does not have write permission to remove "
                                            + stgContMsg);
        session.setAttribute("AllAltNameList", vAltNames);
    }

    /**
     * removes reference documents from the vectors
     * 
     * @param req
     * @throws java.lang.Exception
     */
    private void doMarkRemoveRefDocs(HttpServletRequest req) throws Exception
    {
        HttpSession session = req.getSession();
        String stgContMsg = "";
        Vector<REF_DOC_Bean> vRefDocs = (Vector) session.getAttribute("AllRefDocList");
        Vector vContext = (Vector) session.getAttribute("vWriteContextDE");
        if (vContext == null)
            vContext = new Vector();
        String sContID = (String) req.getParameter("selContext");
        if (sContID != null)
            req.setAttribute("desContext", sContID);
        int j = -1;
        Vector<String> vRefAttrs = new Vector<String>();
        for (int i = 0; i < vRefDocs.size(); i++)
        {
            REF_DOC_Bean rBean = (REF_DOC_Bean) vRefDocs.elementAt(i);
            if (!rBean.getREF_SUBMIT_ACTION().equals("DEL"))
            {
                String refName = rBean.getDOCUMENT_NAME();
                String refType = rBean.getDOC_TYPE_NAME();
                String refCont = rBean.getCONTEXT_NAME();
                // go to next record if same type, name and context does exist
                String curRefAttr = refType + " " + refName + " " + refCont;
                // increase the count only if it didn't exist in the disp vecot list
                if (!vRefAttrs.contains(curRefAttr))
                {
                    vRefAttrs.addElement(curRefAttr);
                    j += 1;
                }
                String ckItem = (String) req.getParameter("RCK" + j);
                // get the right selected item to mark as deleted
                if (ckItem != null)
                {
                    if (vContext.contains(refCont) || refCont.equals("") || refCont.equalsIgnoreCase("new"))
                    {
                        rBean.setREF_SUBMIT_ACTION("DEL");
                        vRefDocs.setElementAt(rBean, i);
                        // check if another record with same type, name and context but diff ac exists to remove
                        for (int k = 0; k < vRefDocs.size(); k++)
                        {
                            REF_DOC_Bean refBean = (REF_DOC_Bean) vRefDocs.elementAt(k);
                            if (!refBean.getREF_SUBMIT_ACTION().equals("DEL")
                                            && refBean.getDOCUMENT_NAME().equals(refName))
                            {
                                if (refBean.getDOC_TYPE_NAME().equals(refType)
                                                && refBean.getCONTEXT_NAME().equals(refCont))
                                {
                                    refBean.setREF_SUBMIT_ACTION("DEL");
                                    vRefDocs.setElementAt(refBean, k);
                                }
                            }
                        }
                    }
                    else
                        stgContMsg += "\\n\\t" + refName + " in " + refCont + " Context ";
                    break;
                }
            }
        }
        if (stgContMsg != null && !stgContMsg.equals(""))
            _servlet.storeStatusMsg("Unable to remove the following Reference Documents, because the user does not have write permission to remove "
                                            + stgContMsg);
        session.setAttribute("AllRefDocList", vRefDocs);
    }

    /**
     * adds and removes alternate names and reference documents from the vectors
     * 
     * @param req
     * @param pageAct
     * @throws java.lang.Exception
     */
    private void doMarkAddRemoveDesignation(HttpServletRequest req, String pageAct) throws Exception
    {
        // call methods for different actions
        if (pageAct.equals("addAlt"))
            doMarkAddAltNames(req);
        else if (pageAct.equals("addRefDoc"))
            doMarkAddRefDocs(req);
        else if (pageAct.equals("removeAlt"))
            doMarkRemoveAltNames(req);
        else if (pageAct.equals("removeRefDoc"))
            doMarkRemoveRefDocs(req);
    }

    private void doEditAltRef(HttpServletRequest req, String dispType, String sAction, HttpSession session) throws Exception
    {
        doMarkAddRemoveDesignation(req, sAction);
        // keep the cscsi selection in the bean
        if (dispType.equals("") || dispType.equals("Designation"))
        {
            SetACService setAC = new SetACService(_servlet);
            DE_Bean deBean = (DE_Bean) session.getAttribute(_beanDE);
            deBean = setAC.setDECSCSIfromPage(_servlet.m_classReq, deBean);
            session.setAttribute(_beanDE, deBean);
        }
    }
    
    private String doEditOpen(HttpServletRequest req, HttpServletResponse res, String dispType, String sAction, HttpSession session)
    {
        String sAC = (String) session.getAttribute("dispACType");
        if (sAction.equalsIgnoreCase("open for Alternate Names"))
            dispType = "Alternate Names";
        if (sAction.equalsIgnoreCase("open for Reference Documents"))
            dispType = "Reference Documents";
        _servlet.doMarkACBeanForAltRef(req, res, sAC, "all", "openAR");
        
        return dispType;
    }
    
    private int doEditAction(HttpServletRequest req, HttpServletResponse res, HttpSession session) throws Exception
    {
        GetACSearch getACSearch = new GetACSearch(req, res, _servlet);

        String dispType = (String) req.getParameter("pageDisplayType");
        if (dispType == null)
            dispType = "";

        String sAction = (String) req.getParameter("pageAction");
        if (sAction == null)
            sAction = "";
        
        int forward = -1;
        if (sAction.equals("") || sAction.equals("clearBoxes") || sAction.equals("nothing"))
        {
            doEditNothing(session, getACSearch);
        }

        // add or remove designation
        else if (sAction.equals("create") || sAction.equals("remove"))
        {
            doEditCreate(req, res, sAction, session);
            forward = 0;
        }
        else if (sAction.equals("backToSearch"))
        {
            forward = 0;
        }

        // add or remove alt names or ref docs names from the list
        else if (sAction.equals("addAlt") || sAction.equals("removeAlt") || sAction.equals("addRefDoc") || sAction.equals("removeRefDoc"))
        {
            doEditAltRef(req, dispType, sAction, session);
        }

        else if (sAction.equals("sortAlt"))
            logger.fatal("sort alt");

        else if (sAction.equals("sortRef"))
            logger.fatal("sort ref");

        // refresh page with session attributes
        else if (sAction.equalsIgnoreCase("open for Alternate Names") || sAction.equalsIgnoreCase("open for Reference Documents"))
        {
            dispType = doEditOpen(req, res, dispType, sAction, session);
        }

        // store the display type attributes
        req.setAttribute("displayType", dispType);
        if (forward == -1 && dispType.equals("Designation"))
            forward = 1;
        
        return forward;
    }

    private String doEdit(HttpServletRequest req, HttpServletResponse res) throws Exception
    {
        HttpSession session = req.getSession();

        int forward = doEditAction(req, res, session);

        switch (forward)
        {
            case 0:
                Vector vResult = new Vector();
                GetACSearch serAC = new GetACSearch(req, res, _servlet);
                serAC.getDEResult(req, res, vResult, "");
                session.setAttribute("results", vResult);
                // reset the menu action to edit de if it was editdesde
                session.setAttribute("AllAltNameList", new Vector());
                session.setAttribute("AllRefDocList", new Vector());

                return "/SearchResultsPage.jsp";

            case 1:
                return "/EditDesignateDEPage.jsp";

            default:
                return "/EditDesignateDE.jsp";
        }
    }

    /**
     * The doDesignateDEActions method handles DesignatedDE actions of the request. Called from 'service' method where
     * reqType is 'DesignatedDE' Calls 'ValidateDEC' if the action is Validate or submit. Calls 'doSuggestionDEC' if the
     * action is open EVS Window.
     * 
     * @param req
     *            The HttpServletRequest from the client
     * @param res
     *            The HttpServletResponse back to the client
     * @param sOrigin
     *            String origin action
     * 
     * @throws Exception
     */
    public void doAction(HttpServletRequest req, HttpServletResponse res, String sOrigin) throws Exception
    {
        String jsp;
        
        // do the open designate page action
        if (sOrigin.equals("Open")) // get the list of checked DEs from the page
        {
            jsp = doOpen(req, res);
        }
        // do edit designate page action
        else // if (sOrigin.equals("Edit"))
        {
            jsp = doEdit(req, res);
        }

        _servlet.ForwardJSP(req, res, jsp);
    }

    private NCICurationServlet _servlet;
    private static final String _beanDE = "m_DE";
    private static final Logger logger = Logger.getLogger(DesDEServlet.class);
}
