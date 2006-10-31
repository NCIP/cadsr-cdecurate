// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/ToolException.java,v 1.4 2006-10-31 06:54:53 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import java.sql.SQLException;

/**
 * @author lhebel
 *
 */
public class ToolException extends Exception
{
    public ToolException()
    {
        _code = -1;
        _msg = null;
    }
    
    public ToolException(SQLException ex_)
    {
        _code = -2;
        _msg = null;
        _sql = ex_;
    }
    
    public ToolException(String msg_)
    {
        _code = -1;
        _msg = msg_;
    }
    
    public ToolException(int code_, String msg_)
    {
        _code = code_;
        _msg = msg_;
    }
    
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
