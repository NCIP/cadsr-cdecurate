// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/ui/AltNamesDefsForm.java,v 1.20 2006-11-22 21:12:44 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.ui;

import gov.nih.nci.cadsr.cdecurate.database.Alternates;
import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import javax.servlet.http.HttpServletRequest;

/**
 * Map the JSP form data for internal processing.
 * 
 * @author lhebel
 *
 */
public class AltNamesDefsForm
{
    /**
     * Constructor
     * 
     * @param req_ the user request
     * @throws Exception
     */
    public AltNamesDefsForm(HttpServletRequest req_) throws Exception
    {
        _req = req_;
        _sess = AltNamesDefsSession.getSessionData(_req);
        read();
    }

    /**
     * Read values from the request form.
     *
     */
    private void read()
    {
        _action = _req.getParameter(AltNamesDefsServlet._actionTag);
        _prevAction = _req.getParameter(AltNamesDefsServlet._prevActionTag);
        _mode = _req.getParameter(AltNamesDefsServlet._modeFlag);
        _targetIdseq = _req.getParameter(AltNamesDefsServlet._parmIdseq);
        
        _nameDef = _req.getParameter(AltNamesDefsServlet._parmNameDef);
        if (_nameDef == null || _nameDef.length() == 0)
            _nameDef = _sess._editAlt.getName();
        else if (_nameDef.length() > DBAccess._MAXDEFLEN)
            _nameDef = _nameDef.trim().substring(0, DBAccess._MAXDEFLEN);

        _type = _req.getParameter(AltNamesDefsServlet._parmType);
        if (_type == null || _type.length() == 0)
            _type = _sess._editAlt.getType();
        
        _lang = _req.getParameter(AltNamesDefsServlet._parmLang);
        if (_lang == null || _lang.length() == 0)
            _lang = _sess._editAlt.getLanguage();

        _sort = _req.getParameter(AltNamesDefsServlet._reqSort);
        if (_sort == null || _sort.length() == 0)
            _sort = _sess._cacheSort;
    }

    /**
     * Clear the edit buffer.
     *
     */
    public void clearEdit()
    {
        _sess.clearEdit();
        _sess._editAlt.setAltIdseq(_sess.newIdseq());
        _sess._editAlt.setInstance((_mode.equals(AltNamesDefsServlet._modeName)) ? Alternates._INSTANCENAME : Alternates._INSTANCEDEF);
        _sess._editAlt.setConteIdseq(_sess._conteIdseq[0]);
        _sess._editAlt.setConteName(_sess._conteName[0]);
        _sess._editAlt.setACIdseq(_sess._acIdseq[0]);
        
        _nameDef = "";
        _type = "";
        _lang = "";
    }

    /**
     * Format the internal buffer for output on the JSP.
     * 
     * @param root_ the Tree hierarchy
     * @param formats_ the HTML format strings
     * @return the formatted output for the hierarchy
     */
    private String toHTML(Tree root_, String[] formats_)
    {
        return Alternates._HTMLprefix + root_.toHTML(formats_) + Alternates._HTMLsuffix;
    }

    /**
     * Write common data to the request for output back to the user on the JSP.
     *
     */
    private void write()
    {
        _sess._cacheSort = _sort;
        if (_sort == null || _sort.equals(AltNamesDefsServlet._sortName))
        {
            _req.setAttribute(AltNamesDefsServlet._reqSort, AltNamesDefsServlet._sortName);
            _req.setAttribute(AltNamesDefsServlet._reqSortTitle, AltNamesDefsServlet._reqSortTitleType);
        }
        else
        {
            _req.setAttribute(AltNamesDefsServlet._reqSort, AltNamesDefsServlet._sortType);
            _req.setAttribute(AltNamesDefsServlet._reqSortTitle,  AltNamesDefsServlet._reqSortTitleName);
        }

        String attr = _req.getParameter(AltNamesDefsServlet._prevActionTag);
        _req.setAttribute(AltNamesDefsServlet._prevActionTag, attr);

        attr = _req.getParameter(AltNamesDefsServlet._parmFilterText);
        if (attr == null)
            attr = "";
        _req.setAttribute(AltNamesDefsServlet._parmFilterText, attr);

        _req.setAttribute(AltNamesDefsServlet._reqTitle, _sess._cacheTitle);
        
        if (_attrs != null)
            _req.setAttribute(AltNamesDefsServlet._reqAttribute, Alternates._HTMLprefix + _attrs + Alternates._HTMLsuffix);
    }

    /**
     * Write data for the alternates.jsp page.
     *
     */
    public void write1()
    {
        write();
    }
    
    /**
     * Write data for the alternates2.jsp page.
     *
     */
    public void write2()
    {
        write();
    }
    
    /**
     * Initialize the edit buffer and form.
     * 
     * @param obj_ the Alternate to be edited.
     */
    public void initialize(Alternates obj_)
    {
        _sess._editAlt = obj_.dupl();
        _mode = (obj_.getInstance() == Alternates._INSTANCENAME) ? AltNamesDefsServlet._modeName : AltNamesDefsServlet._modeDef;
        _nameDef = obj_.getName();
        _type = obj_.getType();
        _lang = obj_.getLanguage();
    }

    /**
     * Save the form data into the edit buffer.
     *
     */
    public void save()
    {
        _sess._editAlt.setName(_nameDef);
        _sess._editAlt.setType(_type);
        _sess._editAlt.setLanguage(_lang);
    }
    
    /**
     * Write data for the alternates3.jsp page.
     *
     */
    public void write3()
    {
        // Save anything the user entered.
        save();
        
        // Write common data to the page.
        write();
        
        // nameFlag is true when editing Alternate Names, false for editing Alternate Definitions
        boolean nameFlag = (_mode.equals(AltNamesDefsServlet._modeName));
        String attr = "";

        // Output data back to user appropriate to the Name or Definition
        _req.setAttribute(AltNamesDefsServlet._modeFlag, _mode);
        if (nameFlag)
        {
            _req.setAttribute(AltNamesDefsServlet._dbTextMax, String.valueOf(DBAccess._MAXNAMELEN));
            _req.setAttribute(AltNamesDefsServlet._tabNameDef, AltNamesDefsServlet._tabAddName);
        }
        else
        {
            _req.setAttribute(AltNamesDefsServlet._dbTextMax, String.valueOf(DBAccess._MAXDEFLEN));
            _req.setAttribute(AltNamesDefsServlet._tabNameDef, AltNamesDefsServlet._tabAddDef);
        }
        _req.setAttribute(AltNamesDefsServlet._parmNameDef, _nameDef);

        // Format the Alternate Names and Definitions for the AC.
        String[] formats = new String[3];
        
        formats[AltNamesDefsServlet._classTypeAlt] = "(not used)";
        formats[AltNamesDefsServlet._classTypeCSI] = AltNamesDefsServlet._formatHTMLcsiFull;
        formats[AltNamesDefsServlet._classTypeCS] = AltNamesDefsServlet._formatHTMLcsFull;
        _req.setAttribute(AltNamesDefsServlet._reqAttribute, toHTML(_sess._cacheCSI, formats));

        // This is the edit page so fill up the Alternate Name/Definition Types dropdown.
        String[] list;
        list = (nameFlag) ? _sess._cacheAltTypes : _sess._cacheDefTypes;
        attr = "<option value=\"\"></option>\n";
        for (int i = 0; i < list.length; ++i)
        {
            String sel = (list[i].equals(_type)) ? "selected" : "";
            attr += "<option value=\"" + list[i] + "\" " + sel + ">" + list[i] + "</option>\n";
        }
        _req.setAttribute(AltNamesDefsServlet._parmType, attr);

        // Fill up the Language dropdown.
        list = _sess._cacheLangs;
        attr = "<option value=\"\"></option>\n";
        for (int i = 0; i < list.length; ++i)
        {
            String sel = (list[i].equals(_lang)) ? "selected" : "";
            attr += "<option value=\"" + list[i] + "\" " + sel + ">" + list[i] + "</option>\n";
        }
        _req.setAttribute(AltNamesDefsServlet._parmLang, attr);

        // Setup object specific data.
        formats[AltNamesDefsServlet._classTypeAlt] = "(not used)";
        formats[AltNamesDefsServlet._classTypeCSI] = AltNamesDefsServlet._formatHTMLcsiEdit;
        formats[AltNamesDefsServlet._classTypeCS] = AltNamesDefsServlet._formatHTMLcsEdit;
        _req.setAttribute(AltNamesDefsServlet._reqCSIList, toHTML(_sess._editAlt.getCSITree(), formats));
    }

    public HttpServletRequest _req;
    public AltNamesDefsSession _sess;
    public String _action;
    public String _prevAction;
    public String _mode;
    public String _sort;
    public String _nameDef;
    public String _type;
    public String _lang;
    public String _targetIdseq;
    public String _attrs;
}
