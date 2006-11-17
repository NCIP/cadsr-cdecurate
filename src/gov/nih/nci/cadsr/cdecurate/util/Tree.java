// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/Tree.java,v 1.17 2006-11-17 05:38:33 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import gov.nih.nci.cadsr.cdecurate.database.DBAccess;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Vector;

/**
 * This class provides a generic Tree. It may be any number of levels and contain a variable number of nodes at any level
 * of the tree. To use this as a binary tree it is the responsibility of the user to limit the child nodes added to another
 * node.
 * 
 * Each node within the Tree is required to have a unique value, see the TreeNode class for the default data supported.
 * 
 * @author lhebel
 *
 */
public class Tree
{
    /**
     * A class test method during development.
     * 
     * @param args [0] the database URL
     */
    static public void main(String[] args)
    {
        // Verify arguments.
        if (args.length != 1)
        {
            System.err.println("Database URL argument missing.");
            return;
        }

        // 1st test, simple small tree
        Tree root = new Tree(new TreeNode("root", null, false));
        root.addChild(new TreeNode("level 2", "2", false));
        Tree l1 = root.addChild(new TreeNode("level 1", "1", false));
        Tree l1b = l1.addChild(new TreeNode("level 1 B", "12",  false));
        l1.addChild(new TreeNode("level 1 A", "11", false));
        l1.addChild(new TreeNode("level 1 C", "13", false));
        l1b.addChild(new TreeNode("level 1 B 1", "1B1", false));
        
        // Output the tree.
        String formatHTML = "<tr onclick=\"{[ONCLICK]}\" " + TreeNode._nodeLevel + "=\"{[NODELEVEL]}\" " + TreeNode._nodeValue + "=\"{[NODEVALUE]}\">\n"
        + "<td title=\"Name\"><div style=\"{[DELFLAG]} padding-left: {[MARGIN]}em\">{[NAME]}</div></td>\n"
        + "</tr>\n";
        String text = root.toHTML(new String[] {formatHTML});
        System.out.println(text);

        System.out.println("<hr/>");

        try
        {
            // This is a test so it is not necessary to create a connection pool or other more elaborate obfuscations.
            DriverManager.registerDriver (new oracle.jdbc.driver.OracleDriver());
            Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@" + args[0], "guest", "guest");
            
            DBAccess db = new DBAccess(conn);

            // Get the CSI hierarchy
            root = db.getCSI();
            text = root.toHTML(new String[] {formatHTML, formatHTML, formatHTML});
            System.out.println(text);
            
            conn.close();
        }
        catch (SQLException e)
        {
            e.printStackTrace();
        }
        catch (ToolException e)
        {
            e.printStackTrace();
        }
    }
    
    /**
     * Constructor
     * 
     * @param node_ the data of the node
     */
    public Tree(TreeNode node_)
    {
        _node = node_;
    }
    
    /**
     * Default constructor
     *
     */
    private Tree()
    {
    }
    
    /**
     * Mark every node in the tree as "new".
     *
     */
    public void markNew()
    {
        _node.markNew();
        
        for (Tree child = _child; child != null; child = child._sybling)
        {
            child.markNew();
        }
    }

    /**
     * Extract a lineage from a tree without altering the tree.
     * 
     * @return a new tree with a single parent lineage
     */
    private Tree extract()
    {
        Tree temp = new Tree();
        temp._node = _node.dupl();

        if (_parent != null)
        {
            _parent = _parent.extract();
            _parent.addChild(temp);
        }
            
        return temp;
    }

    /**
     * Extract a lineage from a tree beginning with the node specified.
     * 
     * @param value_ the unique identifier of a node on the tree
     * @return the new tree with a single parent lineage
     */
    public Tree extract(String value_)
    {
        // Find the node.
        Tree leaf = findValue(value_);
        if (leaf == null)
            return null;

        // Provided it has a parent, pull the lineage by duplicating the branch
        if (_parent != null)
            leaf = _parent.extract();

        // Find the top of the tree and return the root.
        Tree temp;
        for (temp = leaf; temp._parent != null; temp = _parent)
            ;
        
        return temp;
    }

    /**
     * Duplicate a branch on the tree
     * 
     * @param branch_ the starting branch
     */
    private void dupl(Tree branch_)
    {
        // If there are children, they must be duplicated and added to
        // this duplicate branch.
        if (_child != null)
        {
            for (Tree child = _child; child != null; child = child._sybling)
            {
                Tree newChild = branch_.addChild(child._node.dupl());
                child.dupl(newChild);
            }
        }
    }

    /**
     * Duplicate this tree. No references are kept to the original, all nodes
     * and branches are new objects.
     * 
     * @return the new (duplicate) tree.
     */
    public Tree dupl()
    {
        Tree root = new Tree(new TreeNode("root", null, false));
        dupl(root);
        
        return root;
    }

    /**
     * Add the node as a new leaf to all leaves in the tree. Of course that
     * means the leaves become branches.
     * 
     * @param node_ the new node to replicate through the tree.
     */
    public void addLeaf(TreeNode node_)
    {
        // If this is a leaf then add the new node.
        Tree child;
        if (_child == null)
        {
            // Always duplicate to avoid object references.
            child = addChild(node_.dupl());
            
            // The new child must have a unique value or the node can not
            // be replicated to other parts of the tree.
            child._node.setValue(_node._value + " " + child._node._value);
            return;
        }

        // This is not a leaf so recursively keep looking for a place to add the
        // new node.
        for (child = _child; child != null; child = child._sybling)
        {
            child.addLeaf(node_);
        }
    }

    /**
     * Merge another tree into this tree. Duplicates of the branches and
     * nodes are NOT made.
     * 
     * @param other_ the other tree
     */
    public void merge(Tree other_)
    {
        for(Tree child = other_._child; child != null; child = child._sybling)
        {
            Tree myChild = addChild(child._node);
            myChild.merge(child);
        }
    }
    
    /**
     * Find a branch matching the name provided. This is a case insensitive comparison.
     * 
     * @param name_ the desired name
     * @return null if no match is found, otherwise the first branch with a matching name
     */
    public Tree findName(String name_)
    {
        // This is recursive, so compare first to avoid any more calls.
        int compare = name_.compareToIgnoreCase(_node.getName());

        // We match.
        if (compare == 0)
            return this;

        // No match so look at the children. By the way a sybling of a child is a child of this
        // branch.
        Tree result = null;

        // Looping through the branch children avoids eating resources with too many
        // recursive calls.
        for (Tree temp = _child; result == null && temp != null; temp = temp._sybling)
        {
            result = temp.findName(name_);
        }

        // Return the result so far.
        return result;
    }
    
    /**
     * Find a branch matching the value provided. This is a case sensitive comparison.
     * 
     * @param value_ the desired value
     * @return null if no match is found, otherwise the first branch with a matching value
     */
    public Tree findValue(String value_)
    {
        // A match
        if (value_.equals(_node.getValue()))
            return this;

        // No match so look at the children. By the way a sybling of a child is a child of this
        // branch.
        Tree result = null;

        // Looping through the branch children avoids eating resources with too many
        // recursive calls.
        for (Tree temp = _child; result == null && temp != null; temp = temp._sybling)
        {
            result = temp.findValue(value_);
        }

        // Return the result so far.
        return result;
    }

    /**
     * Add a hierarchy of values into the Tree.
     * 
     * @param nodes_ the data node for each element
     * @param levels_ the level of the node
     * @param index_ the current index in the lists
     * @return the index to continue with next
     */
    private int addHierarchy(TreeNode[] nodes_, int[] levels_, int index_)
    {
        // Start with the index indicated.
        int index = index_;
        int level = levels_[index];
        Tree last = null;
        
        // All arrays must have the same number of entries.
        while (index < nodes_.length)
        {
            if (levels_[index] < level)
                break;

            if (levels_[index] == level)
            {
                last = addChild(nodes_[index]);
                ++index;
                continue;
            }

            if (levels_[index] > level)
            {
                index = last.addHierarchy(nodes_, levels_, index);
            }
        }

        return index;
    }

    /**
     * Add a hierarchy of values to the Tree.
     * 
     * @param nodes_ the data node for each element
     * @param levels_ the level of the node
     * @throws ToolException
     */
    public void addHierarchy(TreeNode[] nodes_, int[] levels_) throws ToolException
    {
        if (nodes_.length != levels_.length)
        {
            throw new ToolException("Mismatching arguments.");
        }

        if (nodes_.length == 0)
            return;

        addHierarchy(nodes_, levels_, 0);
    }

    /**
     * Add a child to the branch which contains the value provided.
     * 
     * @param pValue_ the parent branch value
     * @param child_ the child branch to add
     * @return the child branch added or null if the pValue can not be found
     */
    public Tree addChild(String pValue_, Tree child_)
    {
        Tree parent = findValue(pValue_);
        if (parent != null)
            return parent.addChild(child_);

        return null;
    }
    
    /**
     * Add a child to this branch
     * 
     * @param child_ the child data
     * @return the child branch
     */
    public Tree addChild(TreeNode child_)
    {
        return addChild(new Tree(child_));
    }

    /**
     * Add a child branch to this branch
     * 
     * @param child_ the child branch
     * @return the child branch
     */
    public Tree addChild(Tree child_)
    {
        // The value must be unique within the Tree.
        Tree child = findValue(child_._node.getValue());
        if (child != null)
            return child;

        // Add the child as the first child.
        child_._parent = this;
        if (_child == null)
            _child = child_;

        // Add the child to the sybling list in alphabetical order.
        else
        {
            // The child goes before the first sybling.
            if (child_._node.getName().compareToIgnoreCase(_child._node.getName()) < 0)
            {
                child_._sybling = _child;
                _child = child_;
            }

            // The child goes into or at the end of the sybling chain.
            else
            {
                Tree rec;
                for (rec = _child; rec._sybling != null; rec = rec._sybling)
                {
                    if (child_._node.getName().compareToIgnoreCase(rec._sybling._node.getName()) < 0)
                        break;
                }
                child_._sybling = rec._sybling;
                rec._sybling = child_;
            }
        }
        
        // Tell the caller the real Tree branch.
        return child_;
    }
    
    /**
     * Format the Tree using <div> tags. Fortunately the margin style stacks for nested <div> tags.
     * 
     * @param indent_ the tree indentation
     * @return the HTML string
     */
    private String formatHTML(int indent_, String[] formats_)
    {
        String format = (formats_ == null) ? TreeNode._defaultFormatHTML : formats_[_node._classType];
        String text = (indent_ == 0) ? "" : _node.toHTML(this, indent_, format);

        for (Tree temp = _child; temp != null; temp = temp._sybling)
        {
            text += temp.formatHTML(indent_ + 1, formats_);
        }

        return text;
    }

    /**
     * Extract the entire branch as an HTML string using <div> tags.
     * 
     * @return the formatted HTML
     */
    public String toHTML(String[] formats_)
    {
        // Start with an indentation of zero (0)
        return  formatHTML(0, formats_);
    }

    /**
     * Find all the new nodes in the Tree
     * 
     * @param list_ the data marked as new
     */
    private void findNew(Vector<TreeNode> list_)
    {
        // Add any data marked as new.
        if (_node.isNew() && isLeaf())
            list_.add(_node);

        // Check the children.
        for (Tree temp = _child; temp != null; temp = temp._sybling)
        {
            temp.findNew(list_);
        }
    }

    /**
     * Find all the new nodes in the Tree
     * 
     * @return the data marked as new
     */
    public Vector<TreeNode> findNew()
    {
        // Create the data vector.
        Vector<TreeNode> list = new Vector<TreeNode>();

        // Get the new nodes
        findNew(list);
        
        // Return the list
        return list;
    }

    /**
     * Find all the new nodes in the Tree
     * 
     * @param list_ the data marked as new
     */
    private void findDeleted(Vector<TreeNode> list_)
    {
        // Add any data marked as new.
        if (_node.isDeleted() && isLeaf())
            list_.add(_node);

        // Check the children.
        for (Tree temp = _child; temp != null; temp = temp._sybling)
        {
            temp.findDeleted(list_);
        }
    }

    /**
     * Find all the new nodes in the Tree
     * 
     * @return the data marked as new
     */
    public Vector<TreeNode> findDeleted()
    {
        // Create the data vector.
        Vector<TreeNode> list = new Vector<TreeNode>();

        // Get the new nodes
        findDeleted(list);
        
        // Return the list
        return list;
    }

    /**
     * Empty the tree
     *
     */
    public void clear()
    {
        Tree temp = _child;
        while (temp != null)
        {
            Tree next = temp._sybling;
            temp.clear();
            temp = next;
        }

        _child = null;
        _sybling = null;
        _node.clear();
    }

    /**
     * Determine if this object is a root for the tree.
     * 
     * @return true if this object has no parent or if the parent has no parent.
     */
    public boolean isRoot()
    {
        if (_parent == null)
            return true;
        
        if (_parent._parent == null)
            return true;
        
        return false;
    }

    /**
     * Test the node state.
     * 
     * @return true if the node is marked as "new"
     */
    public boolean isNew()
    {
        return _node.isNew();
    }

    /**
     * Delete this branch of the tree.
     *
     */
    public void delete()
    {
        // Can't delete the root - duh!
        if (_parent == null)
            return;
        
        // Be sure to remove the children first.
        Tree prevSyb = null;
        for (Tree child = _parent._child; child != null; child = child._sybling)
        {
            // The top child requires the parent be changed. Syblings require
            // the other children be changed.
            if (child == this)
            {
                if (prevSyb == null)
                {
                    _parent._child = child._sybling;
                    if (_parent._child == null)
                        _parent.delete();
                }
                else
                {
                    prevSyb._sybling = child._sybling;
                }
                break;
            }
            prevSyb = child;
        }
    }
    
    /**
     * Determine if this object is a leaf (no children exist)
     * 
     * @return true if no children exist.
     */
    public boolean isLeaf()
    {
        return (_child == null);
    }
    
    /**
     * Mark a branch in the tree to-be-deleted but don't remove it yet. 
     * 
     * @param value_ the TreeNode unique value
     */
    public void toBeDeleted(String value_)
    {
        Tree branch = findValue(value_);
        if (branch == null)
            return;
        
        branch._node.markForDelete();
    }

    /**
     * The caller wants to keep the specified node - i.e. remove
     * any delete marks.
     * 
     * @param value_ the value of the node to keep
     */
    public void markToKeep(String value_)
    {
        Tree branch = findValue(value_);
        if (branch == null)
            return;
        
        branch._node.markToKeep();
    }
    
    /**
     * Test the state of the tree
     * 
     * @return true if the tree is empty - i.e. only the root exists
     */
    public boolean isEmpty()
    {
        return (_child == null && _sybling == null && _parent == null);
    }

    private TreeNode _node;
    private Tree _child;
    private Tree _sybling;
    private Tree _parent;
    
    public static final int _topLevel = 1;
}
