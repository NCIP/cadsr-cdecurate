// Copyright (c) 2006 ScenPro, Inc.
// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/DesDEServlet.java,v 1.6 2006-11-01 20:41:42 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import gov.nih.nci.cadsr.cdecurate.tool.AC_CSI_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.DE_Bean;
import gov.nih.nci.cadsr.cdecurate.tool.GetACSearch;
import gov.nih.nci.cadsr.cdecurate.tool.InsACService;
import gov.nih.nci.cadsr.cdecurate.tool.NCICurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.SetACService;
import gov.nih.nci.cadsr.cdecurate.tool.UserBean;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author lhebel
 * 
 */
public class DesDEServlet
{
    public DesDEServlet(NCICurationServlet servlet_, UserBean ub_)
    {
        _servlet = servlet_;
        _ub = ub_;
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
    
    private void doEditAltRef(HttpServletRequest req, String dispType, String sAction, HttpSession session) throws Exception
    {
        _servlet.doMarkAddRemoveDesignation(req, sAction);
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
            _servlet.logger.fatal("sort alt");

        else if (sAction.equals("sortRef"))
            _servlet.logger.fatal("sort ref");

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

    private UserBean _ub;
    private NCICurationServlet _servlet;
    private static final String _beanDE = "m_DE";
}
