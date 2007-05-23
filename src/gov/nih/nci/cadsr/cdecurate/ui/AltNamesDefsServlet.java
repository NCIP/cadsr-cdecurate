// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsServlet.java,v 1.29 2007-05-23 04:16:46 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import gov.nih.nci.cadsr.cdecurate.tool.NCICurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.UserBean;
import gov.nih.nci.cadsr.cdecurate.util.ToolException;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;
import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;

/**
 * This is the processing logic for the Alternate Names and Definitions.
 * 
 * @author lhebel
 *
 */
public class AltNamesDefsServlet
{
    
    private UserBean _ub;
    private NCICurationServlet _servlet;

    private static final String _jspName = "/alternates.jsp";
    private static final String _jspCSI = "/alternates2.jsp";
    private static final String _jspEdit = "/alternates3.jsp";
    private static final String _jspError = "/LoginE.jsp";
    
    public static final String _errors = "errors";
    public static final String _actionTag = "alternatesAction";
    public static final String _prevActionTag = "prevAlternatesAction";
    public static final String _actionEditNameDef = "editNameDef";
    public static final String _actionDelNameDef = "delNameDef";
    public static final String _actionRestoreNameDef = "restoreNameDef";
    public static final String _actionViewName = "viewName";
    public static final String _actionViewCSI = "viewCSI";
    public static final String _actionAddName = "addName";
    public static final String _actionSaveAlt = "saveAlt";
    public static final String _actionAddDef = "addDef";
    public static final String _actionCancel = "cancel";
    public static final String _actionClear = "clear";
    public static final String _actionSort = "sort";
    public static final String _actionClassify = "classify";
    public static final String _actionRemoveAssoc = "removeAssoc";
    public static final String _actionRestoreAssoc = "restoreAssoc";
    public static final String _actionAddCSI = "addCSI";
    public static final String _sortName = AltNamesDefsSession._sortName;
    public static final String _sortType = "Type";
    
    public static final String _modeFlag = "mode";
    public static final String _modeName = "Name";
    public static final String _modeDef = "Def";
    
    public static final String _dbTextMax = "dbTextMax";
    
    public static final String _reqType = "AltNamesDefs";
    public static final String _reqAttribute = "alternatesHTML";
    public static final String _reqTitle = "alternatesTitle";
    public static final String _reqIdseq = "alternatesIdseq";
    public static final String _reqSort = "alternatesSort";
    public static final String _reqCSIList = "alternateCSIList";
    public static final String _reqSortTitle = "alternatesSortTitle";
    public static final String _reqSortTitleType = "Sort By Type";
    public static final String _reqSortTitleName = "Sort By Name";
    
    public static final String _parmNameDef = "nameDef";
    public static final String _parmContext = "altContext";
    public static final String _parmType = "altType";
    public static final String _parmLang = "altLang";
    public static final String _parmIdseq = "parmIdseq";
    public static final String _parmFilterText = "parmFilterText";
    
    public static final String _tabViewName = "View&nbsp;by&nbsp;Name/Definition";
    public static final String _tabViewCSI = "View&nbsp;by&nbsp;Classifications";
    public static final String _tabNameDef = "tabNameDef";
    public static final String _tabAddName = "Add&nbsp;Name";
    public static final String _tab3EditName = "Edit&nbsp;Name";
    public static final String _tabAddDef = "Add&nbsp;Definition";
    public static final String _tab3EditDef = "Edit&nbsp;Definition";
    
    public static final int _classTypeDef = -1;
    public static final int _classTypeAlt = 0;
    public static final int _classTypeCS = 1;
    public static final int _classTypeCSI = 2;
    
    public static final String _formatHTMLcsiFull = "<tr onclick=\"selCSI(this);\" "
        + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" "
        + TreeNode._nodeValue + "=\"{[NODEVALUE]}\" "
        + TreeNode._nodeCsiType + "=\"{[TYPE]}\">\n"
        + "<td title=\"Class Scheme Item\"><div class=\"ind{[MARGIN]}\"><span style=\"{[DELFLAG]}\">{[NAME]}</span></div></td>\n"
        + "<td>&nbsp;</td><td>&nbsp;</td>\n"
        + "<td class=\"csi1\" title=\"Class Scheme Item Type\">{[TYPE]}</td>\n"
        + "</tr>\n";
    
    public static final String _formatHTMLcsiEdit = "<tr " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td title=\"Class Scheme Item\"><div class=\"ind{[MARGIN]}\">{[BREAK]}<span style=\"{[DELFLAG]}\">{[NAME]}</span></div></td>\n"
        + "<td>&nbsp;</td><td>&nbsp;</td>\n"
        + "<td class=\"csi1\" title=\"Class Scheme Item Type\">{[TYPE]}</td>\n"
        + "</tr>\n";
    
    public static final String _formatHTMLcsiView = "<tr " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td title=\"Class Scheme Item\"><div class=\"ind{[MARGIN]}\"><span style=\"{[DELFLAG]}\">{[NAME]}</span></div></td>\n"
        + "<td>&nbsp;</td><td>&nbsp;</td>\n"
        + "<td class=\"csi1\" title=\"Class Scheme Item Type\">{[TYPE]}</td>\n"
        + "</tr>\n";

    public static final String _formatHTMLcsFull = "<tr onclick=\"selCSI(this);\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"cs0\" title=\"Classification Scheme\"><div class=\"ind{[MARGIN]}\">{[NAME]}</div></td>\n"
        + "<td class=\"cs1\" title=\"Context\">{[CONTEXT]}</td>\n"
        + "<td class=\"cs1\" title=\"Version\">{[VERSION]}</td>\n"
        + "<td class=\"cs2\" title=\"Definition\">{[DEFIN]}</td>\n"
        + "</tr>\n";

    public static final String _formatHTMLcsEdit = "<tr " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"cs0\" title=\"Classification Scheme\"><div class=\"ind{[MARGIN]}\">{[NAME]}</div></td>\n"
        + "<td class=\"cs1\" title=\"Context\">{[CONTEXT]}</td>\n"
        + "<td class=\"cs1\" title=\"Version\">{[VERSION]}</td>\n"
        + "<td class=\"cs2\" title=\"Definition\">{[DEFIN]}</td>\n"
        + "</tr>\n";

    public static final String _formatHTMLcsView = "<tr " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"cs0\" title=\"Classification Scheme\"><div class=\"ind{[MARGIN]}\">{[NAME]}</div></td>\n"
        + "<td class=\"cs1\" title=\"Context\">{[CONTEXT]}</td>\n"
        + "<td class=\"cs1\" title=\"Version\">{[VERSION]}</td>\n"
        + "<td class=\"cs2\" title=\"Definition\">{[DEFIN]}</td>\n"
        + "</tr>\n";

    public static final String _formatHTMLcsView2 = "<tr " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td class=\"cs0\" title=\"Classification Scheme\"><div class=\"ind{[MARGIN]}\"><b>{[NAME]}</b></div></td>\n"
        + "<td class=\"cs1\" title=\"Context\"><b>{[CONTEXT]}</b></td>\n"
        + "<td class=\"cs1\" title=\"Version\"><b>{[VERSION]}</b></td>\n"
        + "<td class=\"cs2\" title=\"Definition\"><b>{[DEFIN]}</b></td>\n"
        + "</tr>\n";

    /*
    private static final String _formatHTML = "<tr onclick=\"{[ONCLICK]}\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td title=\"Name\"><div style=\"padding-left: {[MARGIN]}em\"><span style=\"{[DELFLAG]}\">{[NAME]}</span></div></td>\n"
        + "</tr>\n";
    */

    private static final Logger _logger = Logger.getLogger(AltNamesDefsServlet.class);

    /**
     * Constructor
     * 
     * @param servlet_ the application servlet
     * @param ub_ the user specific information
     */
    public AltNamesDefsServlet(NCICurationServlet servlet_, UserBean ub_)
    {
        _servlet = servlet_;
        _ub = ub_;
    }

    /**
     * Setup page content for the "View by Name/Definition" page.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doAlternates1(AltNamesDefsForm form_, DBAccess db_)
    {
        try
        {
            // Load the session title
            form_._sess.loadTitle(db_);

            // Get the Alternate Names and Definitions for the AC but first determine the desired sort
            // order.
            form_._sess.loadAlternates(db_, form_._sort);

            // Get the Alternates in HTML format
            form_._attrs = form_._sess.getAltHTML();
        }
        catch (ToolException ex)
        {
            _logger.error(ex.toString(), ex);

            form_._req.setAttribute(_errors, ex.toString());
        }

        // Write the data to the page.
        form_.write1();
        form_._sess._viewJsp = _jspName;
        return _jspName;
    }

    /**
     * Setup page content for the "View by CS/CSI" page.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doAlternates2(AltNamesDefsForm form_, DBAccess db_)
    {
        // Get the Alternates grouped in a CS/CSI "tree" and HTML format
        String[] formats = new String[3];
        formats[_classTypeAlt] = "(not used)";
        formats[_classTypeCS] = _formatHTMLcsView2;
        formats[_classTypeCSI] = _formatHTMLcsiView;

        form_._attrs = form_._sess.getAltGroupByCSI(formats);

        // Write the data to the page.
        form_.write2();
        form_._sess._viewJsp = _jspCSI;
        return _jspCSI;
    }

    /**
     * Setup page content for the "Add/Edit Name/Definition" page.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doAlternates3(AltNamesDefsForm form_, DBAccess db_)
    {
        try
        {
            // Get the Alternate Names and Definitions for the AC.
            form_._sess.checkCaches(db_);

            // Write the data to the page.
            form_.write3();
        }
        catch (ToolException ex)
        {
            _logger.error(ex.toString(), ex);

            form_._req.setAttribute(_errors, ex.toString());
        }

        return _jspEdit;
    }

    /**
     * From the "Add/Edit" page, add a CS/CSI to an Alternate.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doClassify(AltNamesDefsForm form_, DBAccess db_)
    {
        try
        {
            Tree root = form_._sess._editAlt.getCSITree();
            db_.getCSILineage(form_._targetIdseq, root);

            return doAlternates3(form_, db_);
        }
        catch (ToolException ex)
        {
            _logger.error(ex.toString(), ex);

            form_._req.setAttribute(_errors, ex.toString());
        }
        return _jspEdit;
    }

    /**
     * From the "Add/Edit" page, remove a CS/CSI from an Alternate.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doRemoveAssoc(AltNamesDefsForm form_, DBAccess db_)
    {
        Tree root = form_._sess._editAlt.getCSITree();
        Tree obj = root.findValue(form_._targetIdseq);
        if (obj.isNew())
        {
            obj.delete();
        }
        else
        {
            root.toBeDeleted(form_._targetIdseq);
        }

        return doAlternates3(form_, db_);
    }

    /**
     * From the "Add/Edit" page, restore a removed  CS/CSI to an Alternate.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doRestoreAssoc(AltNamesDefsForm form_, DBAccess db_)
    {
        Tree root = form_._sess._editAlt.getCSITree();
        root.markToKeep(form_._targetIdseq);

        return doAlternates3(form_, db_);
    }

    /**
     * From the "View ..." pages, edit an Alternate
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doEditNameDef(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        Alternates edit = form_._sess.getAltWithIdseq(form_._targetIdseq);

        form_.initialize(edit);
        return doAlternates3(form_, db_);
    }

    /**
     * From the "View ..." pages, delete an Alternate
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doDelNameDef(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        // Delete the Alternate
        form_._sess.deleteAlt(form_._targetIdseq);

        // Return to the same page.
        if (form_._sess._jsp.equals(_jspName))
            return doAlternates1(form_, db_);
        return doAlternates2(form_, db_);
    }

    /**
     * From the "View ..." pages, restore a deleted Alternate
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doRestoreNameDef(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        // Find the target
        Alternates del = form_._sess.getAltWithIdseq(form_._targetIdseq);
        
        // Keep it
        if (del.isDeleted())
            del.markToKeep();
        
        // Return to the same page.
        if (form_._sess._jsp.equals(_jspName))
            return doAlternates1(form_, db_);
        return doAlternates2(form_, db_);
    }
    
    /**
     * From the "Add/Edit ..." page, save the user entries to the intenal buffer. Can't write to the database
     * until the AC Validate/Save is done.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doSave(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        // Be sure to grab data from the form and put it in the internal edit buffer.
        form_.save();
        
        // Validate the AC/Name/Context/Type combination.
        Alternates alt = form_._sess._editAlt;
        String msg = form_._sess.check(alt); 
        if (msg != null)
        {
            form_._req.setAttribute(_errors, msg);
            return doAlternates3(form_, db_);
        }

        // Put the Alternate into the session buffer.
        form_._sess.updateAlternatesList(alt, form_._sess._cacheSort.equals(_sortName));
        
        // Return to the page prior to the Add/Edit
        if (form_._sess._viewJsp.equals(_jspName))
            return doAlternates1(form_, db_);
        return doAlternates2(form_, db_);
    }
    
    /**
     * From the "View by Name/Def" page, sort the list.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doSort(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        if (form_._sort.equals(_sortName))
            form_._sort = _sortType;
        else
            form_._sort = _sortName;
        return doAlternates1(form_, db_);
    }
    
    /**
     * From the "View by ..." page, clear the internal buffer and revert to the database.
     * 
     * @param form_ the request form
     * @param db_ the database access object
     * @return the JSP to display to the user.
     */
    private String doClear(AltNamesDefsForm form_, DBAccess db_) throws ToolException
    {
        form_._sess.clearAlts();
        
        return doAlternates1(form_, db_);
    }

    /**
     * The doDesignateDEActions method handles DesignatedDE actions of the request. Called from 'service' method where
     * reqType is 'DesignatedDE' Calls 'ValidateDEC' if the action is Validate or submit. Calls 'doSuggestionDEC' if the
     * action is open EVS Window.
     * 
     * @param req_
     *            The HttpServletRequest from the client
     * @param res_
     *            The HttpServletResponse back to the client
     * 
     * @throws Exception
     */
    public void doAction(HttpServletRequest req_, HttpServletResponse res_) throws Exception
    {
        // Get the form and session data.
        AltNamesDefsForm form = new AltNamesDefsForm(req_);

        String jsp = null;
        Connection conn = null; 
        try
        {
            // Get the database connection.
            conn = _servlet.connectDB(_ub);
            DBAccess db = new DBAccess(conn);
    
            // Default the JSP for the response
            jsp = _jspError;
    
            // Haven't opened this page before.
            if (form._action == null)
            {
                form._sess.cleanBuffers();
                jsp = doAlternates1(form, db);
            }
            
            // Returning to this page so handle it.
            else
            {
                if (form._action.equals(_actionCancel))
                    form._action = form._prevAction;
    
                if (form._action.equals(_actionViewName))
                    jsp = doAlternates1(form, db);
                else if (form._action.equals(_actionViewCSI))
                    jsp = doAlternates2(form, db);
                else if (form._action.equals(_actionAddName))
                {
                    form._mode = _modeName;
                    form.clearEdit();
                    jsp = doAlternates3(form, db);
                }
                else if (form._action.equals(_actionAddDef))
                {
                    form._mode = _modeDef;
                    form.clearEdit();
                    jsp = doAlternates3(form, db);
                }
                else if (form._action.equals(_actionSort))
                    jsp = doSort(form, db);
                else if (form._action.equals(_actionClassify))
                    jsp = doClassify(form, db);
                else if (form._action.equals(_actionSaveAlt))
                    jsp = doSave(form, db);
                else if (form._action.equals(_actionRemoveAssoc))
                    jsp = doRemoveAssoc(form, db);
                else if (form._action.equals(_actionRestoreAssoc))
                    jsp = doRestoreAssoc(form, db);
                else if (form._action.equals(_actionEditNameDef))
                    jsp = doEditNameDef(form, db);
                else if (form._action.equals(_actionDelNameDef))
                    jsp = doDelNameDef(form, db);
                else if (form._action.equals(_actionRestoreNameDef))
                    jsp = doRestoreNameDef(form, db);
                else if (form._action.equals(_actionClear))
                    jsp = doClear(form, db);
            }
        }
        catch (Exception ex)
        {
            _logger.error(ex.toString());
            throw ex;
        }

        finally
        {
            // Close the database connection.
            if (conn != null)
                conn.close();
        }

        // Set the next page and go.
        form._sess._jsp = jsp;
        _servlet.ForwardJSP(req_, res_, jsp);
    }

    /**
     * Get the manually curated definition for this AC
     * 
     * @param req_ the request
     * @param launch_ the source of the request
     * @return the manually curated Alternate Definition or null if it doesn't exist
     */
    public Alternates getManualDefinition(HttpServletRequest req_, String launch_)
    {
        // Need a database connection
        Connection conn = null;
        // Find the manually curated one.
        Alternates alt = null;
        try
        {
            conn = _servlet.connectDB(_ub);
            DBAccess db = new DBAccess(conn);
            
            // Get the session buffer for the AC
            AltNamesDefsSession buffer = AltNamesDefsSession.getAlternates(req_, launch_);
            
            // Load the AC alternate names and definitions but if they've already been loaded this does not
            // refresh the session buffers.
            buffer.loadAlternates(db, AltNamesDefsServlet._sortName);
            
            alt = buffer.findAltWithType(Alternates._INSTANCEDEF, DBAccess._manuallyCuratedDef);
        }
        catch (ToolException e)
        {
            _logger.error(e.toString(), e);
        }
        catch (Exception e)
        {
            _logger.error(e.toString(), e);
        }

        //close the connection
        finally
        {
            if (conn != null)
                _servlet.freeConnection(conn);
        }
        return alt;
    }

    /**
     * Update the manually curated definition with a new value
     * 
     * @param req_ the request
     * @param launch_ the source of the request
     * @param def_ the new definition
     */
    public void editManualDefinition(HttpServletRequest req_, String launch_, String def_)
    {
        try
        {
            // Get the AC session buffer
            AltNamesDefsSession buffer = AltNamesDefsSession.getAlternates(req_, launch_);
            
            // Find the manually curated definition
            Alternates alt = buffer.findAltWithType(Alternates._INSTANCEDEF, DBAccess._manuallyCuratedDef);

            boolean updated = false;
            if (alt == null)
            {
                if (def_ != null && !def_.equals(" "))
                {
                    // Have to create the object to hold the definition because we don't have one.
                    def_ = def_.trim();
                    alt = new Alternates(Alternates._INSTANCEDEF, def_, DBAccess._manuallyCuratedDef, "", "", null, "", null);
                    updated = true;
                }
            }
            else if (def_.equals(" ") && alt.getAltIdseq() != null && !alt.getAltIdseq().equals(""))
            {
                alt.toBeDeleted();
                updated = true;
            }

            else if (alt.getName() == null || (!alt.getName().equals(def_) && !def_.equals(" ")))
            {
                // There's a change to the definition so remember it.
                def_ = def_.trim();
                alt.setName(def_);
                updated = true;
            }

            // When an object is updated the the Alternates are sorted to avoid unnecessary processing every time
            // the list is displayed or referenced for reading.
            if (updated)
                buffer.updateAlternatesList(alt, true);
        }
        catch (Exception e)
        {
            _logger.error(e.toString(), e);
        }
    }
}
