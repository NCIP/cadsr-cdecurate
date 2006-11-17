// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/TreeNodeCSI.java,v 1.17 2006-11-17 05:34:57 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;

/**
 * The specific TreeNode for Class Scheme Items
 * 
 * @author lhebel
 *
 */
public class TreeNodeCSI extends TreeNode
{
    public TreeNodeCSI dupl()
    {
        TreeNodeCSI temp = new TreeNodeCSI(this);
        return temp;
    }
    
    private TreeNodeCSI(TreeNodeCSI old_)
    {
        super(old_);
        
        _type = old_._type;
        _packageAlias = old_._packageAlias;
        _csCsiIdseq = old_._csCsiIdseq;
        _classType = AltNamesDefsServlet._classTypeCSI;
    }

    public TreeNodeCSI(String name_, String value_, String csCsiIdseq_, String type_, String packageAlias_, boolean new_)
    {
        super(name_, value_, new_);

        _csCsiIdseq = csCsiIdseq_;
        _classType = AltNamesDefsServlet._classTypeCSI;
        _type = (type_ == null) ? "" : type_;
        if (DBAccess.isPackageName(type_))
            _packageAlias = packageAlias_;
        else
            _packageAlias = null;
    }

    public void markNew()
    {
        super.markNew();
        
        _value = _csCsiIdseq;
    }
    
    public String toHTML(Tree branch_, int indent_, String format_)
    {
        String text = format_;
        text = text.replace("{[NAME]}", _name.trim());
        text = text.replace("{[TYPE]}", _type);
        text = text.replace("{[MARGIN]}",String.valueOf(indent_));
        text = text.replace("{[NODELEVEL]}",String.valueOf(indent_));
        text = text.replace("{[NODEVALUE]}",_value);
        if (branch_.isLeaf())
        {
            if (_delete)
            {
                text = text.replace("{[DELFLAG]}", _deleteHTML);
                text = text.replace("{[BREAK]}", "<span class=\"restore\" title=\"Restore Association\" onclick=\"restoreAssoc(this);\">&#81;</span> &nbsp; ");
            }
            else
            {
                text = text.replace("{[DELFLAG]}", "");
                text = text.replace("{[BREAK]}", "<span class=\"remove\" title=\"Remove Association\" onclick=\"removeAssoc(this);\">&#126;</span> &nbsp; ");
            }
        }
        else
        {
            text = text.replace("{[DELFLAG]}", "");
            text = text.replace("{[BREAK]}", "");
        }
        
        return text;
    }
    
    public String getType()
    {
        return _type;
    }
    
    public boolean isPackageName()
    {
        return (_packageAlias != null);
    }
    
    public String getPackageAlias()
    {
        return _packageAlias;
    }
    
    public void setPackageAlias(String alias_)
    {
        _packageAlias = alias_;
    }
    
    public void clear()
    {
        super.clear();
        _type = null;
    }

    private String _type;
    private String _packageAlias;
    private String _csCsiIdseq;
}
