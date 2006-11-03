// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/TreeNode.java,v 1.7 2006-11-03 04:50:00 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

/**
 * This class represents a node within a Tree. It may be extended as needed to add additional
 * data.
 * 
 * @author lhebel
 *
 */
public class TreeNode
{
    /**
     * Default constructor
     *
     */
    public TreeNode()
    {
        _classType = -1;
    }
    
    /**
     * Copy constructor
     * 
     * @param old_ the old/other node
     */
    protected TreeNode(TreeNode old_)
    {
        _name = old_._name;
        _value = old_._value;
        _new = old_._new;
        _delete = old_._delete;
        _classType = old_._classType;
    }

    /**
     * Duplicate a node.
     * 
     * @return the new node.
     */
    public TreeNode dupl()
    {
        TreeNode temp = new TreeNode(this);
        
        return temp;
    }

    /**
     * Constructor
     * 
     * @param name_ a textual name or label suitable for display to a user
     * @param value_ a unique identifier typically from a database
     * @param new_ a flag to indicate the data in this node is new and has not been persisted
     *          to a database or other storage
     */
    public TreeNode(String name_, String value_, boolean new_)
    {
        _name = (name_ == null) ? "" : name_;
        _value = (value_ == null) ? "" : value_;
        _new = new_;
    }

    /**
     * Same as value on the constructor.
     * 
     * @param value_ a unique identifier typically from a database
     */
    public void setValue(String value_)
    {
        _value = (value_ == null) ? "" : value_;
    }
    
    /**
     * Same as name on the constructor.
     * 
     * @param name_ a textual name or label suitable for display to a user
     */
    public void setName(String name_)
    {
        _name = (name_ == null) ? "" : name_;
    }

    /**
     * See setName()
     * 
     * @return the name
     */
    public String getName()
    {
        return _name;
    }
    
    /**
     * See setValue()
     * 
     * @return the value
     */
    public String getValue()
    {
        return _value;
    }
    
    /**
     * Test the state of the node, see the constructor
     * 
     * @return true if the data in the node is flagged as new (not persisted)
     */
    public boolean isNew()
    {
        return _new;
    }

    /**
     * Set the node state after the data has been persisted to storage.
     *
     */
    public void setOld()
    {
        _new = false;
    }
    
    /**
     * Mark the node to be deleted
     *
     */
    public void markForDelete()
    {
        _delete = true;
    }
    
    /**
     * Mark the node to keep - undo delete
     *
     */
    public void markToKeep()
    {
        _delete = false;
    }

    /**
     * Test the node state
     * 
     * @return true if marked to be deleted
     */
    public boolean isDeleted()
    {
        return _delete;
    }

    /**
     * Clear all the data in this node.
     *
     */
    public void clear()
    {
        _name = null;
        _value = null;
        _new = false;
    }
    
    /**
     * Get the HTML which represents the visible data. Substitution variables are: (All must be wrapped
     * in {[...]}, e.g. {[NAME]}.)
     * 
     * NAME - value of "_name"
     * NODEVALUE - value of "_value"
     * NODELEVEL - value of "indent_"
     * MARGIN - the left margin
     * ONCLICK - the onclick event value
     * DELFLAG - the delete flag substitute
     * 
     * @return the formatted HTML
     */
    public String toHTML(Tree branch_, int indent_, String format_)
    {
        String text = format_;
        text = text.replace("{[NAME]}", _name.trim());
        text = text.replace("{[MARGIN]}",String.valueOf(indent_));
        text = text.replace("{[NODELEVEL]}",String.valueOf(indent_));
        text = text.replace("{[NODEVALUE]}",_value);
        text = text.replace("{[ONCLICK]}","selCSI(this);");
        if (_delete)
            text = text.replace("{[DELFLAG]}", _deleteHTML);
        else
            text = text.replace("{[DELFLAG]}", "");
        
        return text;
    }

    protected String _name;
    protected String _value;
    protected boolean _new;
    protected boolean _delete;
    protected int _classType;

    public static final String _nodeLevel = "appNodeLevel";
    public static final String _nodeValue = "appNodeValue";
    public static final String _nodeClassType = "appNodeClassType";
    public static final String _nodeName = "appNodeName";
    public static final String _deleteHTML = "text-decoration: line-through;";
    
    public static final String _defaultFormatHTML = "<tr " + _nodeLevel + "=\"{[NODELEVEL]}\" " + _nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td title=\"Name\"><div style=\"{[DELFLAG]} padding-left: {[MARGIN]}em\">{[NAME]}</div></td>\n"
        + "</tr>\n";
}
