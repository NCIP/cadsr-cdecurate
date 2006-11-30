// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/ToolException.java,v 1.21 2006-11-30 04:05:18 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import java.sql.SQLException;

/**
 * This class wraps all exceptions.
 * 
 * @author lhebel
 *
 */
public class ToolException extends Exception
{
    /**
     * Default constructor
     *
     */
    public ToolException()
    {
        _code = -1;
        _msg = null;
    }
    
    /**
     * Constructor from a SQLException
     * 
     * @param ex_ the SQLException
     */
    public ToolException(SQLException ex_)
    {
        _code = -2;
        _msg = null;
        _sql = ex_;
    }
    
    /**
     * Constructor from a message.
     * 
     * @param msg_ message text
     */
    public ToolException(String msg_)
    {
        _code = -1;
        _msg = msg_;
    }

    /**
     * Constructor from a code and message.
     * 
     * @param code_ caller defined code
     * @param msg_ message text
     */
    public ToolException(int code_, String msg_)
    {
        _code = code_;
        _msg = msg_;
    }
    
    /**
     * Display the exception as a String.
     * 
     * @return the exception message
     */
    public String toString()
    {
        if (_sql != null)
            return _sql.toString();
        if (_msg != null)
            return _msg;
        return "Unknown Error, code " + _code;
    }

    protected String _msg;
    protected int _code;
    protected SQLException _sql;
    private static final long serialVersionUID = 1723113094421969108L;
}
