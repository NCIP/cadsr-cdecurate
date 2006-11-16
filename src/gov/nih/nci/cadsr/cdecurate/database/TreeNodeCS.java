// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/TreeNodeCS.java,v 1.16 2006-11-16 05:55:00 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;

/**
 * The specific TreeNode for Class Schemes
 * 
 * @author lhebel
 *
 */
public class TreeNodeCS extends TreeNode
{
    public TreeNodeCS dupl()
    {
        TreeNodeCS temp = new TreeNodeCS(this);
        
        return temp;
    }
    
    private TreeNodeCS(TreeNodeCS old_)
    {
        super(old_);
        _defin = old_._defin;
        _version = old_._version;
        _context = old_._context;
        _classType = AltNamesDefsServlet._classTypeCS;
    }

    public TreeNodeCS(String name_, String value_, String defin_, String vers_, String cont_, boolean new_)
    {
        super(name_, value_, new_);

        _classType = AltNamesDefsServlet._classTypeCS;
        _defin = (defin_ == null) ? "" : defin_;
        _context = (cont_ == null) ? "" : cont_;

        if (vers_ == null)
            _version = "";
        else if (vers_.indexOf('.') > 0)
            _version = vers_;
        else
            _version = vers_ + ".0";
    }

    public String toHTML(Tree branch_, int indent_, String format_)
    {
        String text = format_;
        text = text.replace("{[NAME]}", _name.trim());
        text = text.replace("{[VERSION]}", _version);
        text = text.replace("{[CONTEXT]}", _context.trim());
        text = text.replace("{[DEFIN]}", _defin.trim().replaceAll("[\\n]", "<br/>"));
        text = text.replace("{[MARGIN]}",String.valueOf(indent_));
        text = text.replace("{[NODELEVEL]}",String.valueOf(indent_));
        text = text.replace("{[NODEVALUE]}",_value);
        if (_delete)
            text = text.replace("{[DELFLAG]}", _deleteHTML);
        else
            text = text.replace("{[DELFLAG]}", "");
        
        return text;
    }
    
    public void clear()
    {
        super.clear();
        _defin = null;
        _version = null;
        _context = null;
    }

    private String _defin;
    private String _version;
    private String _context;
}
