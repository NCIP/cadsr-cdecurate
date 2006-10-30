// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/database/TreeNodeAlt.java,v 1.2 2006-10-30 18:53:37 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.database;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet;
import gov.nih.nci.cadsr.cdecurate.util.Tree;
import gov.nih.nci.cadsr.cdecurate.util.TreeNode;

/**
 * @author lhebel
 *
 */
public class TreeNodeAlt extends TreeNode
{
    private TreeNodeAlt(TreeNodeAlt old_)
    {
        super(old_);
        _classType = AltNamesDefsServlet._classTypeCS;
    }
    
    public TreeNodeAlt dupl()
    {
        TreeNodeAlt temp = new TreeNodeAlt(this);
        temp._alt = _alt.dupl();
        
        return temp;
    }

    public TreeNodeAlt(Alternates alt_, String idseq_)
    {
        super(alt_.getName(), idseq_ + " " + alt_.getAltIdseq(), false);
        _alt = alt_;
        _classType = AltNamesDefsServlet._classTypeCS;
    }
    
    public Alternates getAlt()
    {
        return _alt;
    }
    
    public String getID()
    {
        return _alt.getAltIdseq();
    }
    
    public String toHTML(Tree branch_, int indent_, String format_)
    {
        return _alt.toHTML2(indent_);
    }

    public void clear()
    {
        super.clear();
        
        _alt = null;
    }
    
    private Alternates _alt;
}
