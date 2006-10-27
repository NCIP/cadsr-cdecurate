/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author shegde
 *
 */
public class VDServlet implements Serializable
{
  private static HttpServletRequest m_classReq;
  private static HttpServletResponse m_classRes;
  private static NCICurationServlet m_classServlet;
  
  /** Constructor */
  public VDServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
  {
    m_classReq = req;
    m_classRes = res;
    m_classServlet = ser;
  }
  
  public String goBackfromVD(String orgAct, String menuAct, String actype, String butPress, String vdPageFrom)
  {
    try
    {
      //forward the page to editDE if originated from DE
      HttpSession session = m_classReq.getSession();
      m_classServlet.clearBuildingBlockSessionAttributes(m_classReq, m_classRes);
      if (vdPageFrom.equals("create"))
      {
        m_classServlet.clearCreateSessionAttributes(m_classReq, m_classRes);
        if (menuAct.equals("NewVDTemplate") || menuAct.equals("NewVDVersion"))
        {
           VD_Bean VDBean = (VD_Bean)session.getAttribute("m_VD");
           GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_classServlet);
           serAC.refreshData(m_classReq, m_classRes, null, null, VDBean, null, "Refresh", "");
           return "/SearchResultsPage.jsp";
        }
        else if (orgAct.equalsIgnoreCase("CreateNewVDfromEditDE"))
           return "/EditDEPage.jsp";
        else
           return "/CreateDEPage.jsp";

      }
      else if (vdPageFrom.equals("edit"))
      {
        if (orgAct.equalsIgnoreCase("editVDfromDE"))
           return "/EditDEPage.jsp";
        //forward the page to search if originated from Search
        else if (menuAct.equalsIgnoreCase("editVD") || orgAct.equalsIgnoreCase("EditVD") || orgAct.equalsIgnoreCase("BlockEditVD")  
        || (butPress.equals("Search") && !actype.equals("DataElement")))
        {
           VD_Bean VDBean = (VD_Bean)session.getAttribute("m_VD");
           GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_classServlet);
           serAC.refreshData(m_classReq, m_classRes, null, null, VDBean, null, "Refresh", "");
           return "/SearchResultsPage.jsp";
        }
        else
           return "/EditVDPage.jsp";
      }
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    
    return "";
  }
  
  public String clearEditsOnPage(String orgAct, String menuAct, String vdPageFrom)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      VD_Bean VDBean = (VD_Bean)session.getAttribute("oldVDBean");
      //clear related the session attributes 
     // session.setAttribute("VDParentConcept", new Vector());
    //  session.setAttribute("VDPVList", new Vector());
      m_classServlet.clearBuildingBlockSessionAttributes(m_classReq, m_classRes);
      String sVDID = VDBean.getVD_VD_IDSEQ();
      Vector vList = new Vector();           
      //get VD's attributes from the database again
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_classServlet);
      if (sVDID != null && !sVDID.equals(""))
         serAC.doVDSearch(sVDID, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", "", "", "", "", "", vList);
      //forward editVD page with this bean
      if (vList.size() > 0)
      {
        VDBean = (VD_Bean)vList.elementAt(0);
        VDBean = serAC.getVDAttributes(VDBean, orgAct, menuAct);
      }
      else
      {
        VDBean = new VD_Bean();
        VDBean.setVD_ASL_NAME("DRAFT NEW");
        VDBean.setAC_PREF_NAME_TYPE("SYS");
      }
      VD_Bean pgBean = new VD_Bean();
      session.setAttribute("m_VD", pgBean.cloneVD_Bean(VDBean));
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return "/CreateVDPage.jsp";    
  }

}
