// Copyright (c) 2007 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/util/ToolURL.java,v 1.9 2008-07-03 21:17:37 chickerura Exp $
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
public class ToolURL
{
    public static final String defaultUrl = "http://ncicb.nci.nih.gov";
    public static final String evsNewTermUrl = "EVSNewTermURL";
    public static final String browserUrl = "BrowserURL";
    public static final String sentinelUrl = "SentinelURL";
    public static final String umlBrowserUrl = "UMLBrowserURL";
    public static final String curationToolHelpURL="curationToolHelpURL";

    /**
     * Constructor
     */
    public ToolURL()
    {
        super();
    }
    
    public static final void setEVSNewTermURL(HttpSession session_, String url_)
    {
        DataManager.setAttribute(session_, evsNewTermUrl, (url_ == null) ? defaultUrl : url_);
    }
    
    public static final String getEVSNewTermURL(PageContext context_)
    {
        return (String) context_.getSession().getAttribute(evsNewTermUrl);
    }
    
    public static final void setBrowserUrl(HttpSession session_, String url_)
    {
        DataManager.setAttribute(session_, browserUrl, (url_ == null) ? defaultUrl : url_);
    }
    
    public static final String getBrowserUrl(PageContext context_)
    {
        return (String) context_.getSession().getAttribute(browserUrl);
    }

    public static final String getBrowserUrl(HttpSession session)
    {
        return (String) session.getAttribute(browserUrl);
    }
    
    public static final void setSentinelUrl(HttpSession session_, String url_)
    {
        DataManager.setAttribute(session_, sentinelUrl, (url_ == null) ? defaultUrl : url_);
    }
    
    public static final String getSentinelUrl(PageContext context_)
    {
        return (String) context_.getSession().getAttribute(sentinelUrl);
    }
    
    public static final void setUmlBrowserUrl(HttpSession session_, String url_)
    {
        DataManager.setAttribute(session_, umlBrowserUrl, (url_ == null) ? defaultUrl : url_);
    }
    
    public static final String getUmlBrowserUrl(PageContext context_)
    {
        return (String) context_.getSession().getAttribute(umlBrowserUrl);
    }
  
    public static final void setCurationToolHelpURL(HttpSession session_, String url_)
    {
        DataManager.setAttribute(session_, curationToolHelpURL, (url_ == null) ? defaultUrl : url_);
    }
    
    public static final String getCurationToolHelpURL(PageContext context_)
    {
        return (String) context_.getSession().getAttribute(curationToolHelpURL);
    }
}