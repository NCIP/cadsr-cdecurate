// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/Session_Data.java,v 1.3 2006-10-30 18:53:37 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.util.Vector;

/**
 * this keeps track of the session objects used in curation tool
 * one session attribute constant declared here will be the key and object will be the class. 
 * all other session attributes will be stored as objects of this class. 
 * whenenver the data changes change the individual object of this class. 
 * Get this session object at the service method of the servlet (begginning) and 
 * set it at the ForwardJSP method of the servlet (end).
 * 
 * @author shegde
 */
public class Session_Data
{
  /**  argument string passed in for the session attributes used for the curation tool*/
  public static final String CURATION_SESSION_ATTR = "Curation_Session_Attribute"; 
  
  /** evs user bean stored in the session */
  public EVS_UserBean EvsUsrBean;

  /** Alt Def result vector **/
  public Vector<AltDefBean> AllAltDef;
  
  /** String EVS searched **/
  public String EVSSearched;

  /** vCD vector **/
  public Vector<String> vCD;

  /** vCD_ID vector **/
  public Vector<String> vCD_ID;

  /** m_VM Bean **/
  public VM_Bean m_VM;

}
