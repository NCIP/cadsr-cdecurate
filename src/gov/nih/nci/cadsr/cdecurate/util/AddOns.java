// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/AddOns.java,v 1.7 2007-06-12 20:26:18 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import java.util.Vector;

/**
 * A class of general utilities used within the Tool
 * 
 * @author lhebel
 *
 */
public class AddOns
{
    /**
     * Constructor
     */
    public AddOns()
    {
    }
    
    /**
     * Sort two lists in tandem. The 2nd list is sorted alphabetically ascending case insensitive and the first
     * list is sorted in the same order. This is provided for value/name pairs, the 1st list being the values
     * and the 2nd being the names.
     * 
     * @param values_ a list of values (usually database IDSEQ)
     * @param names_ a list of names
     */
    public static void sortTandemLists(Vector<String> values_, Vector<String> names_)
    {
        // Verify the lists are not empty and the same size, otherwise there's nothing
        // to do.
        if (values_ == null || names_ == null || values_.size() != names_.size() || values_.size() == 0)
            return;

        // Declare working sorted arrays.
        String[] values = new String[values_.size()];
        String[] names = new String[names_.size()];
        
        // Seed the array with a value. Must have something to compare to later.
        values[0] = values_.get(0);
        names[0] = names_.get(0);
        int total = 1;
        
        // Use a binary sort to insert the values into the working arrays.
        for (int i = 1; i < names.length; ++i)
        {
            String name = names_.get(i);
            String value = values_.get(i);
            int min = 0;
            int max = total;
            int pos = 0;
            while (true)
            {
                pos = (min + max) / 2;
                int compare = name.compareToIgnoreCase(names[pos]);
                if (compare < 0)
                {
                    if (max == pos)
                        break;
                    max = pos;
                }
                else if (compare > 0)
                {
                    if (min == pos)
                    {
                        ++pos;
                        break;
                    }
                    min = pos;
                }
                else
                {
                    break;
                }
            }

            // Place the entries in the sorted arrays.
            System.arraycopy(names, pos, names, pos + 1, total - pos);
            names[pos] = name;
            System.arraycopy(values, pos, values, pos + 1, total - pos);
            values[pos] = value;
            ++total;
        }

        // Replace the elements in the vectors with the sorted order
        for (int i = 0; i < names.length; ++i)
        {
            values_.set(i, values[i]);
            names_.set(i, names[i]);
        }
    }
}
