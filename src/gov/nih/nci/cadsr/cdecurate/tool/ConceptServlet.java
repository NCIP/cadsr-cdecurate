// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/ConceptServlet.java,v 1.11 2007-06-12 20:26:17 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.util.DataManager;

import java.io.Serializable;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;

/**
 * @author shegde
 *
 */
@SuppressWarnings("unchecked")
public class ConceptServlet implements Serializable
{
  private static final long serialVersionUID = 8411474971665771500L;
  private ConceptForm data = null;
  private static final Logger logger = Logger.getLogger(ConceptServlet.class);

  /** constructor 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          CurationServlet pointer
   * @param sAction String to recorgnize whether it is main page search or searchForCreate
   */
  public ConceptServlet(HttpServletRequest req, HttpServletResponse res, CurationServlet ser, String sAction)
  {
    new ConceptServlet(req, res, ser);
    data.setACAction(sAction);
  }
  /** constructor 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          CurationServlet pointer
   */
  public ConceptServlet(HttpServletRequest req, HttpServletResponse res, CurationServlet ser)
  {
    data = new ConceptForm();
    data.setRequest(req);
    data.setResponse(res);
    data.setCurationServlet(ser);
    data.setUtil(new UtilService());
    data.setEvsUser((EVS_UserBean)ser.sessionData.EvsUsrBean);
  }

  /**
   * start the search
   * @return Vector of EVS bean
   */
  public Vector<EVS_Bean> readDataForSearch()
  {    
    Vector<EVS_Bean> vAC = new Vector<EVS_Bean>();
    try
    {
      HttpServletRequest req = data.getRequest();
      HttpSession session = req.getSession();
      //get searchin data to filter
      String sSearchIn = (String)req.getParameter("listSearchIn");
      if (sSearchIn == null) sSearchIn = ConceptForm.SEARCH_IN_LONG_NAME;
      data.setSearchIn(sSearchIn);
      
      //get evs searchin for filter
      String sSearchInEVS = (String)req.getParameter("listSearchInEVS");
      if (sSearchInEVS == null) sSearchInEVS = "Synonym";

      //get the context to filter
      String sContext = (String)req.getParameter("listContextFilter");
      data.setContextName(sContext);
      
      //get work flow status filter
      String sStatusList[] = req.getParameterValues("listStatusFilter");
      data.setASLNameList(sStatusList);
      
      //get the keyword for filter
      String sKeyword = (String)req.getParameter("keyword");
      if (sKeyword == null) sKeyword = "";
      if (sSearchIn.equals("publicID"))
        data.setConID(sKeyword);
      else
        data.setSearchTerm(sKeyword);
      
      data.setMenuAction((String)session.getAttribute(Session_Data.SESSION_MENU_ACTION));
      String sAction = data.getACAction();
      if (sAction.equals(""))
        sAction = data.getMenuAction();
      //store the attributes to display in the data
      if (sAction.equals(ConceptForm.SEARCH_AC_ACTION))
      {
        data.setSelAttributeList((Vector)session.getAttribute("creSelectedAttr"));
        data.setDispAttributeList((Vector)session.getAttribute("creAttributeList"));
      }
      else
      {
        data.setSelAttributeList((Vector)session.getAttribute("selectedAttr"));
        data.setDispAttributeList((Vector)session.getAttribute("serAttributeList"));
      }
      
      //call the action to do the search
      ConceptAction conAct = new ConceptAction();
      if (!sSearchIn.equals("Code") || !sSearchInEVS.equals("MetaCode"))
        conAct.doConceptSearch(data);
      
      //put the data back in the session
      DataManager.setAttribute(session, "creSearchInBlocks", sSearchIn);  //keep the search in criteria
      DataManager.setAttribute(session, "SearchInEVS", sSearchInEVS);
      DataManager.setAttribute(session, "creContextBlocks", sContext);
      DataManager.setAttribute(session, "creKeyword", sKeyword);   //keep the old criteria
      Vector vStat = data.getSelStatusList();
      if (sAction.equals(ConceptForm.SEARCH_AC_ACTION))
      {
          DataManager.setAttribute(session, "creStatus", vStat);
         req.setAttribute("creStatusBlocks", vStat);
      }
      else
          DataManager.setAttribute(session, "serStatus", vStat);
      //get the seelcted attributes
      Vector vSel = data.getSelAttributeList();
      if (sAction.equals("searchForCreate"))
          DataManager.setAttribute(session, "creSelectedAttr", vSel);
      else
          DataManager.setAttribute(session, "selectedAttr", vSel); 
      
      //put the results back in the session
      vAC = data.getConceptList();
      DataManager.setAttribute(session, "vACSearch", vAC);
    }
    catch (RuntimeException e)
    {
      logger.fatal("Error - concept servlet search concept ", e);
      data.setStatusMsg("Error : Unable to do concept search." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    return vAC;
  }

  /**
   * gets the selected concept from teh list of concepts from search
   * @param iFrom page the where this is called from
   * @return String error message
   */
  public String appendSelectConcept(int iFrom)
  {
    String errMsg = "";
    HttpSession session = (HttpSession)data.getRequest().getSession();
    Vector<EVS_Bean> vRSel = (Vector)session.getAttribute("vACSearch");
    if (vRSel == null) vRSel = new Vector<EVS_Bean>();
    //get the array from teh hidden list
    String thisRow = "";    
    switch (iFrom)
    {
        case ConceptForm.FOR_PV_PAGE_CONCEPT:
            String selRows[] = data.getRequest().getParameterValues("hiddenSelectedRow");
            if (selRows != null && selRows.length > 0)
              thisRow = selRows[0];
            break;
        case ConceptForm.FOR_VM_PAGE_CONCEPT:
            String sRow = data.getRequest().getParameter(VMForm.ELM_SEL_CON_ROW);
            if (sRow != null)
              thisRow = sRow;
            break;
    }
    if (thisRow.equals(""))
      errMsg += "\\tUnable to select Concept, please try again"; 
    else
    {
      int iRow = Integer.parseInt(thisRow);
      if (iRow < 0 || iRow > vRSel.size())
        errMsg += "\\tRow size is either too big or too small.";
      //continue only if no error occured
      else
      {
        //get the nvp value
        String sNVP = "";
        if (iFrom == ConceptForm.FOR_VM_PAGE_CONCEPT)
            sNVP = data.getRequest().getParameter(VMForm.ELM_NVP_ORDER);
        else
            sNVP = data.getRequest().getParameter("nvp_CK" + iRow);
        //call the action
        ConceptAction conAct = new ConceptAction();
        EVS_Bean eBean = conAct.getSelectedConcept(iRow, vRSel, sNVP, data); 
        //store teh concept and vm attrirbutes in the request to place it on the vd page
        if (eBean != null && !eBean.getLONG_NAME().equals(""))
          data.getRequest().setAttribute(VMForm.REQUEST_SEL_CONCEPT, eBean);
        //display error message
        String sMsg = data.getStatusMsg();
        if (!sMsg.equals(""))
            errMsg += sMsg;
      }
    }
    return errMsg;
  }
  
}
