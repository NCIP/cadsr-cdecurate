// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/AC_Bean.java,v 1.1 2006-01-26 15:25:12 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

import java.io.Serializable;

/**
 * This is the root class for all the other AC type beans,
 * e.g. DE_BEAN, DEC_BEAN, etc.
 * 
 * @author Larry Hebel Nov 18, 2005
 */

public abstract class AC_Bean implements Serializable
{
    /**
     * Constructor
     */
    public AC_Bean ()
    {
    }
    
    /**
     * Return the IDSEQ of the AC.
     * 
     * @return The database IDSEQ column value.
     */
    abstract public String getIDSEQ();
}
