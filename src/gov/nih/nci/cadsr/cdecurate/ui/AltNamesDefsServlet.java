// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsServlet.java,v 1.18 2006-11-17 16:40:43 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import gov.nih.nci.cadsr.cdecurate.database.TreeNodeAlt;
import gov.nih.nci.cadsr.cdecurate.database.TreeNodeCS;
import gov.nih.nci.cadsr.cdecurate.tool.NCICurationServlet;
import gov.nih.nci.cadsr.cdecurate.tool.UserBean;
import gov.nih.nci.cadsr.cdecurate.util.ToolException;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;
import java.sql.Connection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * This is the processing logic for the Alternate Names and Definitions.
 * 
 * @author lhebel
 *
 */
public class AltNamesDefsServlet
{
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
        String attr = "";
        try
        {
            // Load the session title
            form_._sess.loadTitle(db_);

            // Get the Alternate Names and Definitions for the AC but first determine the desired sort
            // order.
            form_._sess.loadAlternates(db_, form_._sort);

            // Output each with the desired related information.
            int flag = -1;
            attr = "";
            for (Alternates temp : form_._sess._alts)
            {
                if (flag != temp.getInstance())
                {
                    flag = temp.getInstance();
                    switch (temp.getInstance())
                    {
                    case Alternates._INSTANCEDEF:
                        attr += Alternates._INSTANCEDEFTITLE;
                        break;
                    case Alternates._INSTANCENAME:
                        attr += Alternates._INSTANCENAMETITLE;
                        break;
                    default:
                        attr += Alternates._INSTANCEUNKTITLE;
                        break;
                    }
                }
                attr += temp.toHTML();
            }

            form_._attrs = attr;
        }
        catch (ToolException ex)
        {
            ex.printStackTrace();

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
        String attr = "";

        String[] formats = new String[3];
        formats[_classTypeAlt] = "(not used)";
        formats[_classTypeCS] = _formatHTMLcsView2;
        formats[_classTypeCSI] = _formatHTMLcsiView;

        // Get the Alternate Names and Definitions for the AC.
        Tree root = new Tree(new TreeNode("root", null, false));

        Alternates[] alts = form_._sess._alts;
        for (int i = 0; i < alts.length; ++i)
        {
            // This gets a little tricky. "altRoot" is the original internal buffer data, "temp" is the tree containing only this orignal buffer data with
            // the Alternates add to each leaf, "root" is the composite page Tree. This is all necessary to ensure the Alternates appear on every
            // leaf of the tree for which they are associated. This requires the data to be duplicated during this process. It is released once the
            // response is sent back to the user.
            
            Tree temp = new Tree(new TreeNode("root", null, false));
            Tree altRoot = alts[i].getCSITree();
            if (altRoot.isEmpty())
            {
                temp.addChild(new TreeNodeCS("(unclassified)", "(unclassified)", "Unclassified Alternate Names and Definitions.", null, null, false));
            }
            else
            {
                temp = altRoot.dupl();
            }
            temp.addLeaf(new TreeNodeAlt(alts[i], ""));
            root.merge(temp);
        }
        
        // Format display
        attr = root.toHTML(formats);
        form_._attrs = attr;

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
            if (form_._sess._cacheCSI == null)
            {
                form_._sess._cacheCSI = db_.getCSI();
            }
            
            if (form_._sess._cacheAltTypes == null)
                form_._sess._cacheAltTypes = db_.getDesignationTypes();
            
            if (form_._sess._cacheDefTypes == null)
                form_._sess._cacheDefTypes = db_.getDefinitionTypes();
            
            if (form_._sess._cacheLangs == null)
                form_._sess._cacheLangs = db_.getLangs();

            // Write the data to the page.
            form_.write3();
        }
        catch (ToolException ex)
        {
            ex.printStackTrace();

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
            ex.printStackTrace();

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
     * Find the target Alternate to be edited.
     * 
     * @param form_ the request form
     * @return the target Alternate
     * @throws ToolException
     */
    private Alternates  findTarget(AltNamesDefsForm form_) throws ToolException
    {
        int pos = findTargetPos(form_);
        return form_._sess._alts[pos];
    }

    /**
     * Find the specified object position in the internal buffer
     * 
     * @param form_ the request form
     * @param idseq_ the target idseq
     * @return the array index within the internal buffer
     * @throws ToolException
     */
    private int findTargetPos(AltNamesDefsForm form_, String idseq_) throws ToolException
    {
        Alternates[] alts = form_._sess._alts;
        int pos;
        for (pos = 0; pos < alts.length; ++pos)
        {
            if (alts[pos].isIdseq(idseq_))
            {
                break;
            }
        }
        if (pos == alts.length)
            return -1;
        
        return pos;
    }

    /**
     * Find the target object position in the internal buffer.
     * 
     * @param form_ the request form
     * @return the array index within the internal buffer
     * @throws ToolException
     */
    private int findTargetPos(AltNamesDefsForm form_) throws ToolException
    {
        return findTargetPos(form_, form_._targetIdseq);
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
        Alternates edit = findTarget(form_);

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
        // Find the target
        Alternates[] alts = form_._sess._alts;
        int pos = findTargetPos(form_);
        Alternates del = alts[pos];
        
        // If it's new just get rid of it, nothing to do to the database.
        if (del.isNew())
        {
            Alternates[] temp = new Alternates[alts.length - 1];
            System.arraycopy(alts, 0, temp, 0, pos);
            ++pos;
            System.arraycopy(alts, pos, temp, pos - 1, alts.length - pos);
            form_._sess._alts = temp;
        }
        
        // It's in the database so mark it for deletion.
        else
            del.toBeDeleted();

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
        Alternates[] alts = form_._sess._alts;
        int pos = findTargetPos(form_);
        Alternates del = alts[pos];
        
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
        Alternates alt = form_._sess._editAlt;

        // Find the target
        int pos = findTargetPos(form_, alt.getAltIdseq());
        if (pos < 0)
        {
            // This is a new one NOT an edit of an existing entry.
            pos = form_._sess._alts.length;
            Alternates[] temp = new Alternates[pos + 1];
            System.arraycopy(form_._sess._alts, 0, temp, 0, pos);
            form_._sess._alts = temp;
        }
        // Save the edit buffer to the internal buffer.
        form_._sess._alts[pos] = alt;

        // Sort it into the list
        form_._sess.sortBy(form_._sess._cacheSort.equals(_sortName));
        
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
        form_._sess._alts = null;
        
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

        // Get the database connection.
        Connection conn = _servlet.connectDB(_ub);
        DBAccess db = new DBAccess(conn);

        // Default the JSP for the response
        String jsp;
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
            else if (form._action.equals(_actionSaveName))
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

        // Close the database connection.
        conn.close();

        // Set the next page and go.
        form._sess._jsp = jsp;
        _servlet.ForwardJSP(req_, res_, jsp);
    }

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
    public static final String _actionSaveName = "saveName";
    public static final String _actionAddDef = "addDef";
    public static final String _actionSaveDef = "saveDef";
    public static final String _actionCancel = "cancel";
    public static final String _actionClear = "clear";
    public static final String _actionSort = "sort";
    public static final String _actionClassify = "classify";
    public static final String _actionRemoveAssoc = "removeAssoc";
    public static final String _actionRestoreAssoc = "restoreAssoc";
    public static final String _actionAddCSI = "addCSI";
    public static final String _sortName = "Name";
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
    
    public static final String _formatHTMLcsiFull = "<tr onclick=\"selCSI(this);\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
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
}
