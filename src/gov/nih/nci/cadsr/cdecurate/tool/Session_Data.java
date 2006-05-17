/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

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
  
}
