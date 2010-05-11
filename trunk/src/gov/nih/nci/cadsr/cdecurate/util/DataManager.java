// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/DataManager.java,v 1.2 2007-09-10 17:18:22 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import javax.servlet.http.HttpSession;

/**
 * @author lhebel
 *
 */
public class DataManager
{
    private static final String _attrName = DataManager.class.getName();

    /**
     * Constructor
     */
    public DataManager()
    {
        super();
    }

    private static class ListLoc
    {
        public int _pos;
        public boolean _found;
    }
    
    /**
     * Find the value in the list using a binary search
     * 
     * @param list_ the source list
     * @param value_ the search value
     * @return the results of the search
     */
    private static ListLoc findString(String[] list_, String value_)
    {
        ListLoc loc = new ListLoc();
        
        int min = 0;
        int max = list_.length;
        while (true)
        {
            loc._pos = (max + min) / 2;
            int compare = value_.compareTo(list_[loc._pos]);
            if (compare == 0)
            {
                loc._found = true;
                break;
            }
            else if (compare < 0)
            {
                if (max == loc._pos)
                {
                    loc._found = false;
                    break;
                }
                max = loc._pos;
            }
            else
            {
                if (min == loc._pos)
                {
                    loc._pos++;
                    loc._found = false;
                    break;
                }
                min = loc._pos;
            }
        }
        
        return loc;
    }

    /**
     * Clear the session of all attributes managed by this class.
     * 
     * @param session_ the HTTP session
     */
    public static void clearSessionAttributes(HttpSession session_)
    {
        // Get the list of attributes added to the session.
        String[] myNames = (String[]) session_.getAttribute(_attrName);
        if (myNames != null)
        {
            // If there are any attributes remove them.
            for (String temp : myNames)
            {
                session_.removeAttribute(temp);
            }
            
            // Remove the attribute name list because they're all gone now.
            session_.removeAttribute(_attrName);
        }
    }

    /**
     * Let this class update the session so it can track the attribute names for future cleanup.
     * 
     * @param session_ the HTTP session
     * @param name_ the attribute name
     * @param value_ the attribute object
     */
    public static void setAttribute(HttpSession session_, String name_, Object value_)
    {
        // Get the list of attributes added to the session so far.
        String[] myNames = (String[]) session_.getAttribute(_attrName);
        if (myNames == null)
        {
            // This is the first, that's easy.
            myNames = new String[1];
            myNames[0] = name_;
            session_.setAttribute(_attrName, myNames);
        }
        else
        {
            // See if the name is already in the list.
            ListLoc loc = findString(myNames, name_);
            if (!loc._found)
            {
                // It wasn't in the list so now we add it.
                String[] temp = new String[myNames.length + 1];
                System.arraycopy(myNames, 0, temp, 0, loc._pos);
                temp[loc._pos] = name_;
                System.arraycopy(myNames, loc._pos, temp, loc._pos + 1, myNames.length - loc._pos);
                session_.setAttribute(_attrName, temp);
            }
        }
        
        // Add the attribute and object to the session.
        session_.setAttribute(name_, value_);
    }
}
