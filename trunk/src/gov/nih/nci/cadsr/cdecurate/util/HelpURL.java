// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/HelpURL.java,v 1.1 2008-07-03 21:17:28 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.util;

import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

/**
 * This class wraps all foreign URL references for static access by the Curation Tool.
 * 
 * @author lhebel
 *
 */
public class HelpURL
{
    
    public static String curationToolHelpURL;
    public static final String defaultUrl = "http://ncicb.nci.nih.gov";
    /**
     * Constructor
     */
    public HelpURL()
    {
        super();
    }
    
    public static final void setCurationToolHelpURL(String url_)
    {
        curationToolHelpURL = (url_ == null) ? defaultUrl : url_;
    }
    
    public static final String getCurationToolHelpURL(PageContext context_)
    {
        return curationToolHelpURL;
    }
    public static final String getCurationToolHelpURL()
    {
        return curationToolHelpURL;
    }
}
