/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;
import java.io.Serializable;
import java.sql.Connection;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
/**
 * @author shegde
 */
@SuppressWarnings("unchecked")
public class VMServlet implements Serializable
{
  private static final long serialVersionUID = 1L;
  public static VMForm data = null;
  private static final Logger logger = Logger.getLogger(VMServlet.class.getName());
  /**
   * Constructor
   * 
   * @param req
   *          HttpServletRequest object
   * @param res
   *          HttpServletResponse object
   * @param ser
   *          NCICurationServlet pointer
   */
  public VMServlet(HttpServletRequest req, HttpServletResponse res, NCICurationServlet ser)
  {
    data = new VMForm();
    data.setRequest(req);
    data.setResponse(res);
    data.setCurationServlet(ser);
    SetACService setAC = new SetACService(ser);
    data.setSetAC(setAC);
    InsACService insAC = new InsACService(req, res, ser);
    data.setInsAC(insAC);
    UtilService util = new UtilService();
    data.setUtil(util);
    data.setEvsUser((EVS_UserBean)NCICurationServlet.sessionData.EvsUsrBean);
  }

  /**
   * start the search
   */
  public void readDataForSearch()
  {
    HttpServletRequest req = data.getRequest();
    HttpSession session = req.getSession();
    //get the cd id to filter
    String sCDid = ""; 
    sCDid = (String)req.getParameter("listCDName");    //get selected cd
    if(sCDid == null || sCDid.equals("All Domains")) sCDid = "";       
    session.setAttribute("creSelectedCD", sCDid);
    data.setSearchFilterCD(sCDid);
    
    //get the keyword for filter
    String sKeyword = (String)req.getParameter("keyword");
    if (sKeyword == null) sKeyword = "";
    session.setAttribute("creKeyword", sKeyword);   //keep the old criteria
    UtilService util = data.getUtil();
    sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);
    data.setSearchTerm(sKeyword);
    
    //store the attributes to display in the data
    data.setSelAttrList((Vector)session.getAttribute("creSelectedAttr"));
    
    //call the action to do the search
    VMAction vmAct = new VMAction();
    vmAct.searchVMValues(data);
    
    //put the results back in the session
    Vector<VM_Bean> vAC = data.getVMList();
    if (vAC == null) vAC = new Vector<VM_Bean>();
    session.setAttribute("vACSearch", vAC);

    //call the method to get the result vector
    this.readVMResult();
    //keep these empty for now
    session.setAttribute("SearchLongName", new Vector<String>());
    session.setAttribute("SearchMeanDescription",  new Vector<String>());      
    
  }

  /**
   * do vm sorting
   */
  public void readDataForSort()
  {
    HttpServletRequest req = data.getRequest();
    HttpSession session = req.getSession();
    
    //get the request or session attributes into the form data
    data.setSelAttrList((Vector)session.getAttribute("creSelectedAttr"));
    data.setVMList((Vector)session.getAttribute("vACSearch"));
    String sortField = (String)req.getParameter("sortType");
    if (sortField == null) sortField = (String)session.getAttribute("sortType");
    data.setSortField(sortField);
    
    //call teh method for sorting
    VMAction vmAct = new VMAction();
    vmAct.getVMSortedRows(data);
    
    //put the results back in the session
    Vector<VM_Bean> vAC = data.getVMList();
    session.setAttribute("vACSearch", vAC);
    //call the method to get the result vector
    this.readVMResult();
  }

  /**
   * gets teh result vector and stores attributes in the request/session object
   *
   */
  private void readVMResult()
  {
    HttpServletRequest req = data.getRequest();
    HttpSession session = req.getSession();
    
    //call teh method for sorting
    VMAction vmAct = new VMAction();
    vmAct.getVMResult(data);
    //store teh result back in request/session attributes
    session.setAttribute("results", data.getResultList());
    req.setAttribute("creRecsFound", data.getNumRecFound());
    req.setAttribute("labelKeyword", data.getResultLabel());        
  }

  public void readDataForCreate(PV_Bean pv, int pvInd)
  {
    HttpServletRequest req = data.getRequest();
    HttpSession session = req.getSession();
  //  boolean newPVVM = true;
    //get all attributes of the vm into this bean
    VM_Bean vm = new VM_Bean();
    VM_Bean selvm = new VM_Bean();
    if (pv != null && pv.getPV_VALUE() != null && !pv.getPV_VALUE().equals(""))
      vm = resetConceptsFromPage(pv);  //pv.getPV_VM();

    boolean handTypedVM = true;
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    if (vmCon != null && vmCon.size() > 0)
      handTypedVM = false;
    //read vm name and desc if no concept
    if (handTypedVM)
    {
      String sVM = "";
      String sVMD = "";
      if (pvInd == -1)
      {
        sVM = (String)req.getParameter("pvNewVM");  //vm name
        sVMD = (String)req.getParameter("pvNewVMD");  //vm desc  
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
      System.out.println(sVM + " new " + sVMD);
      }
      else
      {
        sVM = (String)req.getParameter("txtpv" + pvInd + "Mean");  //vm name
        sVMD = (String)req.getParameter("txtpv" + pvInd + "Def");  //vm desc        
      }
      if (sVM != null && !sVM.equals("") && !vm.getVM_SHORT_MEANING().equals(sVM))
      {
        vm.setVM_SHORT_MEANING(sVM);
        vm.setVM_LONG_NAME(sVM);
        vm.setVM_IDSEQ("");
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
      }
      if (sVMD != null && !sVMD.equals("") && !vm.getVM_DESCRIPTION().equals(sVMD))
      {
        vm.setVM_DESCRIPTION(sVMD); 
        vm.setVM_IDSEQ("");
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
      }
    }
    //call the action change VM to validate the vm
    VD_Bean vd = (VD_Bean)session.getAttribute("m_VD");  //vm cd
    data.setVMBean(vm);
    
    VD_Bean oldvd = (VD_Bean)session.getAttribute("oldVDBean");
    Vector<PV_Bean> vdpvs = oldvd.getVD_PV_List();
    if (pvInd > -1 && vdpvs.size() > 0)  // (selvm != null)
    {
        for (int i=0; i<vdpvs.size(); i++)
        {
          PV_Bean orgPV =  (PV_Bean)vdpvs.elementAt(i);
          if (orgPV != null && pv.getPV_PV_IDSEQ() != null && orgPV.getPV_PV_IDSEQ().equals(pv.getPV_PV_IDSEQ()))
          {            
            selvm = orgPV.getPV_VM();
            data.setSelectVM(selvm);
         //   if (selvm.getVM_SHORT_MEANING().equals(vm.getVM_SHORT_MEANING()))
         //     newPVVM = false;
            break;
          }
        }
    }
    VMAction vmact = new VMAction();
    vmact.setDataForCreate(pv, vd, data);
  //  pv.setPV_VM(vm);
    //TODO - handle status message and other session attributes as needed    
    Vector<VM_Bean> vErrMsg = data.getErrorMsgList();
    if (vErrMsg != null && vErrMsg.size()>0)
    {
      session.setAttribute("VMEditMsg", vErrMsg);
    System.out.println(pvInd + " error " + data.getStatusMsg());
      data.getRequest().setAttribute("ErrMsgAC", data.getStatusMsg());
      data.getRequest().setAttribute("editPVInd", pvInd);
      data.setVMBean(vm);
    }
  }
  
  private VM_Bean resetConceptsFromPage(PV_Bean pv)
  {
    HttpServletRequest req = data.getRequest();
    HttpSession session = req.getSession();
    //get the edited vm
    VM_Bean vm = (VM_Bean)session.getAttribute("selectVM");  // pv.getPV_VM();
    if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals("")) 
      vm = new VM_Bean().copyVMBean(pv.getPV_VM());
    Vector vmCon = vm.getVM_CONCEPT_LIST();
    String[] sCons = req.getParameterValues("hiddenConVM");
    if (sCons != null && vmCon != null)
    {
      Vector<EVS_Bean> newList = new Vector<EVS_Bean>();
      if (sCons.length == vmCon.size())
        newList = vmCon;
      else
      {
        //remove the deleted concepts if not the same size
        for (int i =0; i<sCons.length; i++)
        {
          String sID = sCons[i].trim();
          for (int j =0; j<vmCon.size(); j++)
          {
            EVS_Bean eBean = (EVS_Bean)vmCon.elementAt(j);
            String conId = eBean.getCONCEPT_IDENTIFIER().trim();
            if (sID.equalsIgnoreCase(conId))
            {
              newList.addElement(eBean);
              break;
            }
          }
        }
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
        pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_INS);  //pv changed
      }
      //get the name
      vm.setVM_CONCEPT_LIST(newList);
      this.makeVMNameFromConcept(vm);      
    }
    return vm;
  }

  private void makeVMNameFromConcept(VM_Bean vm)
  {
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    String vmName = "";
    String vmDef = "";
    for (int i =0; i<vmCon.size(); i++)
    {
      EVS_Bean con = vmCon.elementAt(i);
      if (i == vmCon.size()-1)
      {
        if (con.getNVP_CONCEPT_VALUE() != null && !con.getNVP_CONCEPT_VALUE().equals(""))
        {
           String conName = con.getLONG_NAME();
           String conExp = "::" + con.getNVP_CONCEPT_VALUE();
           int nvpInd = conName.indexOf("::");
           if (nvpInd > 0)
           {             
             conName = conName.substring(0, nvpInd);
             con.setLONG_NAME(conName);
             con.setNVP_CONCEPT_VALUE("");
             String conDef = con.getPREFERRED_DEFINITION();
             if (conDef.indexOf("::") > 0)
               con.setPREFERRED_DEFINITION(conDef.substring(0, conDef.indexOf("::")));
             vmCon.setElementAt(con, i);
           }
        }
      }
      if (!vmName.equals(""))  vmName += " ";
      vmName += con.getLONG_NAME();
      if (!vmDef.equals("")) vmDef += ": ";
      vmDef += con.getPREFERRED_DEFINITION();
    System.out.println(i + " cname " + con.getLONG_NAME() + " cdef " + con.getPREFERRED_DEFINITION());
    }
    System.out.println(vmName + " vm name " + vmDef);
    vm.setVM_LONG_NAME(vmName);
    vm.setVM_SHORT_MEANING(vmName);
    vm.setVM_DESCRIPTION(vmDef);
  }
  
  public String submitVM(VM_Bean vm)
  {
    VMAction vmact = new VMAction();
    data.setVMBean(vm);
    if (vm.getVM_SUBMIT_ACTION() != null && !vm.getVM_SUBMIT_ACTION().equals(VMForm.CADSR_ACTION_NONE))
      vmact.doSubmitVM(data);
    String vmError = data.getRetErrorCode();
    data.getRequest().setAttribute("retcode", data.getRetErrorCode());      
    return vmError;
  }

  /**
   * connects the db and returns the connection object
   * @return Connection object
   */
  public static Connection makeDBConnection()
  {
    Connection sbr_db_conn = null;
    try
    {
      // Create a Callable Statement object. connection class is in the future
    //  DatabaseConnection dbCon = new DatabaseConnection();
    //  sbr_db_conn = dbCon.connectDB(req);
      NCICurationServlet servlet = data.getCurationServlet();
      sbr_db_conn = servlet.connectDB(data.getRequest(), data.getResponse());
      if (sbr_db_conn == null) 
        logger.fatal("Error : Unable to make db connection.");
    }
    catch (Exception e)
    {
      logger.fatal("Error : Unable to make db connection.", e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to make db connection." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
    return sbr_db_conn;
  }
  /**
   * closes the db connection
   * @param con connection object
   */
  public static void closeDBConnection(Connection con)
  {
    try
    {
      if (con != null && !con.isClosed())
        con.close();
    }
    catch (Exception e)
    {
      logger.fatal("Error : Unable to close connection.", e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to close db connection." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
  }
}
