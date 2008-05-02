// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/TreeNodeCSI.java,v 1.38 2008-05-02 15:10:17 chickerura Exp $
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
        _version = old_._version;
        _packageAlias = old_._packageAlias;
        _csCsiIdseq = old_._csCsiIdseq;
        _classType = AltNamesDefsServlet._classTypeCSI;
    }

    /**
     * Constructor
     * 
     * @param name_ the CSI name
     * @param value_ non-leaf nodes, the IDSEQ for the CS/CSI hierarchy node, so we can know the specific lineage (a CSI may be referenced multiple places
     *      in the CSI tree); leaf nodes are the IDSEQ of the Alt/CSI hierarchy node. Must be a guaranteed unique value for all entries in the tree.
     * @param csCsiIdseq_ the CS/CSI IDSEQ hierarchy id
     * @param type_ the CSI type stored in the caDSR
     * @param packageAlias_ the IDSEQ of the Parent CSI UML_PACKAGE_ALIAS when this is a UML_PACKAGE_NAME type 
     * @param new_ true if this is a new record not stored in the caDSR, false if this data is read from the caDSR.
     */
    public TreeNodeCSI(String name_, String value_, String csCsiIdseq_, String type_, String packageAlias_, boolean new_,String vers_,String id)
    {
        super(name_, value_, new_);
        _csiId =id;
        _csCsiIdseq = csCsiIdseq_;
        _classType = AltNamesDefsServlet._classTypeCSI;
        _type = (type_ == null) ? "" : type_;
        if (vers_ == null)
            _version = "";
        else if (vers_.indexOf('.') > 0)
            _version = vers_;
        else
            _version = vers_ + ".0";
        
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
        text = text.replace("{[VERSION]}", _csiId + "v" +_version);
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
                text = text.replace("{[BREAK]}", "<img src=\"images/delete.gif\" title=\"Remove\" onclick=\"removeAssoc(this);\" /> &nbsp; ");
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
    private String _version;
    private String _csCsiIdseq;
    private String _csiId;
}