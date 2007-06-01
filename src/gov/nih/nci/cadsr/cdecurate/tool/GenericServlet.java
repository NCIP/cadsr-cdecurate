// Copyright (c) 2000 ScenPro, Inc.
// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/GenericServlet.java,v 1.2 2007-06-01 22:17:44 hegdes Exp $
// $Name: not supported by cvs2svn $
/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

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
  public String run(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
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
      session.setAttribute(Session_Data.SESSION_MENU_ACTION, sMenuAction);
    
    String sAction = (String)httpRequest.getParameter(VMForm.ELM_PAGE_ACTION);
    if (sAction == null || sAction.equals(""))
      return "";
    this.pageAction = sAction;
    return sAction;    
  }
  
  //protected variables
  protected String pageAction;
  public NCICurationServlet curationServlet;
  public HttpServletRequest httpRequest;
  public HttpServletResponse httpResponse;
  //static variables
  //private static final String ERROR_JSP = "/";
  //private static final Logger logger = Logger.getLogger(VMServlet.class.getName());
}
