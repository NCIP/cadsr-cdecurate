/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright (c) 2000 ScenPro, Inc.
// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/GenericServlet.java,v 1.5 2007-09-10 17:18:21 hebell Exp $
// $Name: not supported by cvs2svn $

/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.util.DataManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author shegde
 *
 */
public class GenericServlet
{
  /**
   * 
   */
  public GenericServlet()
  {
    super();
  }
  //call this from nci servlet class
  public String run(HttpServletRequest req, HttpServletResponse res, CurationServlet ser)
  {
    httpRequest = req;
    httpResponse = res;
    curationServlet = ser;
    return execute();
  }

  //call this from nci servlet class
  public String run()
  {
    return execute();
  }
  
  protected String execute()
  {
    HttpSession session = httpRequest.getSession();
    //keep this reset
    String sMenuAction = (String)httpRequest.getParameter(VMForm.ELM_MENU_ACTION);
    if (sMenuAction != null)
      DataManager.setAttribute(session, Session_Data.SESSION_MENU_ACTION, sMenuAction);
    
    String sAction = (String)httpRequest.getParameter(VMForm.ELM_PAGE_ACTION);
    if (sAction == null || sAction.equals(""))
      return "";
    this.pageAction = sAction;
    return sAction;    
  }
  
  //protected variables
  protected String pageAction;
  public CurationServlet curationServlet;
  public HttpServletRequest httpRequest;
  public HttpServletResponse httpResponse;
  //static variables
  //private static final String ERROR_JSP = "/";
  //private static final Logger logger = Logger.getLogger(VMServlet.class.getName());
}
