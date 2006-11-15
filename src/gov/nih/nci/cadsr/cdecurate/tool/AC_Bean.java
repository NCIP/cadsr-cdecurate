// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/AC_Bean.java,v 1.25 2006-11-15 04:59:58 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession;
import java.io.Serializable;
import java.sql.SQLException;
import java.sql.Connection;
import javax.servlet.http.HttpSession;

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
    
    /**
     * Return the IDSEQ of the associated Context
     * 
     * @return The database IDSEQ column value.
     */
    abstract public String getContextIDSEQ();
    
    /**
     * Return the Name of the associated Context
     * 
     * @return The database IDSEQ column value.
     */
    abstract public String getContextName();
    
    public AltNamesDefsSession getAlternates()
    {
        return _alts;
    }
    
    public void setAlternates(AltNamesDefsSession alts_)
    {
        _alts = alts_;
    }
    
    public void clearAlternates()
    {
        _alts = null;
    }
    
    public void save(HttpSession session_, Connection conn_, String idseq_, String conteIdseq_) throws SQLException
    {
        // Only call the instance if it's present
        if (_alts != null)
        {
            _alts.save(conn_, idseq_, conteIdseq_);
            _alts = null;
        }
    }
    
    public boolean isNewAC()
    {
        return _newAC;
    }
    
    public void markNewAC()
    {
        _newAC = true;
    }

    protected AltNamesDefsSession _alts;
    protected boolean _newAC;
}
