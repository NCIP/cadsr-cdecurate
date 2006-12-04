/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;
import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import oracle.jdbc.driver.OracleTypes;
import org.apache.log4j.Logger;
/**
 * @author shegde
 */
public class VMAction implements Serializable
{  
  private static final long serialVersionUID = 1L;
  private static final Logger logger = Logger.getLogger(VMAction.class.getName());
  private static UtilService util = new UtilService(); 

  
  /** constructor*/
  public VMAction()
  {
  }

  /**
   * searching for Value Meaning in caDSR
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_VM(InString, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * 
   * @param data VMForm object
   *
  */
  public void searchVMValues(VMForm data)  
  {
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Connection sbr_db_conn = null;
    try
    {
      //do not continue search if no search filter
      if (data.getSearchTerm().equals("") && data.getSearchFilterCD().equals("") && data.getSearchFilterCondr().equals("") && data.getSearchFilterDef().equals(""))
        return;
      
      Vector<VM_Bean> vmList = data.getVMList();
      if (vmList == null) vmList = new Vector<VM_Bean>();
      //get the connection from data if exists (used for testing)
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT.SBREXT_CDE_CURATOR_PKG.SEARCH_VM(?,?,?,?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(5, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1, data.getSearchTerm());  //name 
        CStmt.setString(2, data.getSearchFilterCD());
        CStmt.setString(3, data.getSearchFilterDef());
        CStmt.setString(4, data.getSearchFilterCondr());
        
         // Now we are ready to call the stored procedure
        CStmt.execute();
        // store the output in the resultset
        rs = (ResultSet) CStmt.getObject(5);

        if(rs!=null)
        {
          int i = 0;
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            i += 1;
            VM_Bean vmBean = new VM_Bean();
            vmBean.setVM_SHORT_MEANING(rs.getString("short_meaning"));
            vmBean.setVM_BEGIN_DATE(rs.getString("begin_date"));
            vmBean.setVM_END_DATE(rs.getString("end_date"));
            String sCD = rs.getString("cd_name");
            if (rs.getString("version") != null && !rs.getString("version").equals(""))
            {
               if (rs.getString("version").indexOf('.') >= 0)
                  sCD = sCD + " - Version " +  rs.getString("version");
               else
                  sCD = sCD + " - Version " + rs.getString("version") + ".0";
            }
            vmBean.setVM_CD_NAME(sCD);            
            vmBean.setVM_DESCRIPTION(rs.getString("vm_description"));
            vmBean.setVM_CONDR_IDSEQ(rs.getString("condr_idseq"));
            vmBean.setVM_LONG_NAME(rs.getString("LONG_NAME"));
            vmBean.setVM_IDSEQ(rs.getString("VM_IDSEQ"));
          //  vmBean.setVM_DESCRIPTION(rs.getString("PREFERRED_DEFINITION"));
            vmBean.setVM_VERSION(rs.getString("VERSION"));
            ConceptForm cdata = new ConceptForm();
            cdata.setDBConnection(sbr_db_conn);  //  data.getDBConnection());
            ConceptAction cact = new ConceptAction();
            Vector<EVS_Bean> conList = cact.getAC_Concepts(vmBean.getVM_CONDR_IDSEQ(), cdata);
            vmBean.setVM_CONCEPT_LIST(conList);
            vmList.addElement(vmBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
      data.setVMList(vmList);
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - VMAction-searchVM for other : " + e.toString(), e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to search VM." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
      e.printStackTrace();
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR - VMAction-searchVM for close : " + ee.toString(), ee);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to search VM." + ee.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
  }  //endVM search

  /**
   * To get final result vector of selected attributes/rows to display for Permissible Values component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the VMBean vector 'vACSearch' and adds the selected fields to result vector.
   * @param data VMForm object
   *
   */
  public void getVMResult(VMForm data)
  {
    try
    {
      //get number of records
      Vector vRSel = data.getVMList();  // (Vector)session.getAttribute("vACSearch");
      if (vRSel == null) vRSel = new Vector();
      Integer iRecs = new Integer(0);
      if(vRSel.size()>0)
        iRecs = new Integer(vRSel.size());
      String sRecs = "";
      if(iRecs != null)
        sRecs = iRecs.toString();
      data.setNumRecFound(sRecs);  //req.setAttribute("creRecsFound", recs2);

      //make keyWordLabel label request session
      String sKeyword = "";
      sKeyword = data.getSearchTerm();  // (String)session.getAttribute("creKeyword");
      if (sKeyword == null) sKeyword = "";
      data.setResultLabel("Value Meaning : " + sKeyword);  //req.setAttribute("labelKeyword", "Value Meaning : " + sKeyword);   //make the label

      //loop through the bean collection to add it to the result vector
      Vector<String> vSelAttr = data.getSelAttrList();  //(Vector)session.getAttribute("creSelectedAttr");
      Vector<String> vResult = new Vector<String>();
      for (int i=0; i<(vRSel.size()); i++)
      {
        VM_Bean VMBean = new VM_Bean();
        VMBean = (VM_Bean)vRSel.elementAt(i);
        Vector<EVS_Bean> vcon = VMBean.getVM_CONCEPT_LIST();
        String conID = "", defsrc = "", vocab = "";
        for (int j = 0; j<vcon.size(); j++)
        {
          EVS_Bean con = (EVS_Bean)vcon.elementAt(j);
          if (!conID.equals("")) conID += ": ";
          conID += con.getCONCEPT_IDENTIFIER();
          if (!defsrc.equals("")) defsrc += ": ";
          defsrc += con.getEVS_DEF_SOURCE();
          if (!vocab.equals("")) vocab += ": ";
          vocab += con.getEVS_DATABASE();          
        }
        //they have to be in the order of attribute multi select list
        //vValue.addElement(VMBean.getVM_SHORT_MEANING());
        //vDesc.addElement(VMBean.getVM_DESCRIPTION());  
        EVS_Bean vmConcept = VMBean.getVM_CONCEPT();
        if (vmConcept == null) vmConcept = new EVS_Bean();
        if (vSelAttr.contains("Value Meaning")) vResult.addElement(VMBean.getVM_SHORT_MEANING());
        if (vSelAttr.contains("Meaning Description")) vResult.addElement(VMBean.getVM_DESCRIPTION());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(VMBean.getVM_CD_NAME());        
        if (vSelAttr.contains("EVS Identifier")) vResult.addElement(conID);  //vmConcept.getCONCEPT_IDENTIFIER());        
        if (vSelAttr.contains("Definition Source")) vResult.addElement(defsrc);  //vmConcept.getEVS_DEF_SOURCE());        
        if (vSelAttr.contains("Vocabulary")) vResult.addElement(vocab);  //vmConcept.getEVS_DATABASE());        
        if (vSelAttr.contains("Comments")) vResult.addElement(VMBean.getVM_COMMENTS());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(VMBean.getVM_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(VMBean.getVM_END_DATE());
      }
      data.setResultList(vResult);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in VMAction-getVMResult: " + e);
      logger.fatal("ERROR in VMAction-getVMResult : " + e.toString(), e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to search VM." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
  }
  
  /**
   * To get the sorted vector for the selected field in the VM component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getVMFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param data VM_Form object
   *
   */
  public void getVMSortedRows(VMForm data)
  {
    try
    {
      Vector<VM_Bean> vSRows = new Vector<VM_Bean>();
      Vector<VM_Bean> vSortedRows = new Vector<VM_Bean>();
      //get the selected rows
      vSRows = data.getVMList();
      String sortField = data.getSortField();  
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            VM_Bean VMSortBean1 = (VM_Bean)vSRows.elementAt(i);
            String Name1 = getVMFieldValue(VMSortBean1, sortField);            
            int tempInd = i;
            VM_Bean tempBean = VMSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              VM_Bean VMSortBean2 = (VM_Bean)vSRows.elementAt(j);
              String Name2 = getVMFieldValue(VMSortBean2, sortField);         
              try
              { 
               // UtilService util = data.getUtil();
                if (util == null) util = new UtilService();
                if (util.ComparedValue("String", Name1, Name2) > 0)
                {
                  if (tempInd == i)
                  {
                    tempName = Name2;
                    tempBean = VMSortBean2;
                    tempInd = j;
                  }
                  //else if (tempName.compareToIgnoreCase(Name2) > 0)
                  else if (util.ComparedValue("String", tempName, Name2) > 0)
                  {
                    tempName = Name2;
                    tempBean = VMSortBean2;
                    tempInd = j;
                  }
                }
              }
              catch (RuntimeException e)
              {
                logger.fatal("Error - Compare Value in Value Meaning sort", e);
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(VMSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          data.setVMList(vSortedRows);
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in VMAction-VMsortedRows : ", e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to search VM." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
  }

  public void doAppendSelectVM(String[] selRows, Vector<VM_Bean> vRSel, PV_Bean pv)
  {
    String errMsg = "";
    //loop through the array of strings
    for (int i=0; i<selRows.length; i++)
    {
      String thisRow = selRows[i];
      Integer IRow = new Integer(thisRow);
      int iRow = IRow.intValue();
      if (iRow < 0 || iRow > vRSel.size())
        errMsg += "Row size is either too big or too small.";
      else
      {
        VM_Bean vm = (VM_Bean)vRSel.elementAt(iRow);
        if (vm != null && vm.getVM_SHORT_MEANING() != null)
          pv.setPV_VM(vm);
      }
    }
  }

  public void setDataForCreate(PV_Bean pv, VD_Bean vd, VMForm data)
  {
    VM_Bean vm = data.getVMBean();
    VM_Bean selvm = data.getSelectVM(); 
    boolean handTypedVM = true;
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    vm.setVM_CD_IDSEQ(vd.getVD_CD_IDSEQ());
    vm.setVM_CD_NAME(vd.getVD_CD_NAME());
    vm.setVM_BEGIN_DATE(pv.getPV_BEGIN_DATE());  //vm begin date
    vm.setVM_END_DATE(pv.getPV_END_DATE());   //vm end date 
    //call the action change VM to validate the vm
    data.setVMBean(vm);
    if (vm.getVM_IDSEQ() == null || vm.getVM_IDSEQ().equals(""))
      this.doChangeVM(data);
    
  }
  
  /**
   * mark vm as new or existed by matching short meaning in the database
   * if existed match the vm definition,  check if exists in other VDs etc
   * check if same definition exist in concept table
   * create, update or use the existing as per the rules
   * send back the messages to display as needed
   * 
   * @param data VMForm object
   */
  public void doChangeVM(VMForm data)
  {
    try
    {
      VM_Bean vmBean = data.getVMBean();
      Vector<EVS_Bean> vCon = vmBean.getVM_CONCEPT_LIST();
      //check the condition whether changing vm with concept or not
      System.out.println("doChangeVM - " + vCon.size());
      boolean dispMsg = false;
      String dispMsgACType = ""; 
      if (vCon != null && vCon.size()> 0)
        dispMsgACType = validateConceptVM(data);
      else  
        dispMsgACType = validateNonConVM(data);
      
      //print the messages
      if (!dispMsgACType.equals(""))
      {
        //get the message
        data.setStatusMsg(dispMsgACType);
        if (dispMsgACType.equals("Concept"))
        {
          //sMsg.append("One or more matching Concepts were found.  \nPlease select one from the list below and click Use Selection or Cancel. \n");
          getFlaggedMessageCon(data, "Name, Definition");
        }
        else
        {
          //sMsg.append("One or more matching Value Meanings were found.  \nPlease select one from the list below and click Use Selection, Alt Name/Definition or Cancel. \n");
          //print the list of vms or concepts
          getFlaggedMessageVM(data, 'A');
        }
      }
    }
    catch (RuntimeException e)
    {
      e.printStackTrace();
    }
  }

  public void doSubmitVM(VMForm data)
  {
    VM_Bean vm = data.getVMBean();
    Vector<EVS_Bean> vCon = vm.getVM_CONCEPT_LIST();  //get the con list first
    String sAct = vm.getVM_SUBMIT_ACTION();
    if (!sAct.equals("") && !sAct.equals(VMForm.CADSR_ACTION_NONE))
    {
      String erMsg = ""; 
      //check if vm exists for INS action (not sure if needed or what to do later)
      VM_Bean existVM = new VM_Bean();
      if (sAct.equals(VMForm.CADSR_ACTION_INS))
        existVM = this.getVM(data, vm.getVM_SHORT_MEANING());
      if (existVM != null && existVM.getVM_SHORT_MEANING() != null && !existVM.getVM_SHORT_MEANING().equals(""))
      {
        vm = vm.copyVMBean(existVM);
        if (existVM.getVM_CONCEPT_LIST() != null && existVM.getVM_CONCEPT_LIST().size() > 0)
          return;
        else
          vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);  //udpate the existing with concept relationship
      }
      //check the condition whether changing vm with concept or not
      if (vCon != null && vCon.size()> 0)
      {
        //set concept (get concept will be done at the time of selection itself
        ConceptAction conAct = new ConceptAction();
        ConceptForm condata = new ConceptForm();
        if (data.getDBConnection() != null)
          condata.setDBConnection(data.getDBConnection()); //get the connection
        else
          condata.setDBConnection(VMServlet.makeDBConnection());  //make the connection

        String conArray = conAct.getConArray(vCon, true, condata);        
        if (data.getDBConnection() == null)
          VMServlet.closeDBConnection(condata.getDBConnection());  //close the connection
        //set setvm_evs method to set th edata
        erMsg = this.setVM_EVS(data, conArray);
      }
      else
        erMsg = this.setVM(data);  //update or insert non evs vm
      
     System.out.println("vm error : " + erMsg);
      //exit if error occurred
      if (erMsg != null && !erMsg.equals(""))
        return;
      //check if cd vms exist in cadsr for this vm and cd
      String cdvms = this.getCDVMS(data, vm);
      if (cdvms.equals(""))  //call setcdvms method to create new record if does not exist.
        this.setCDVMS(data, vm);
    }
  }
  
  /**
   * To insert a new Value Meaing in the database after the validation. Called from
   * NCICurationServlet. Gets all the attribute values from the bean, sets in parameters, and
   * registers output parameter. Calls oracle stored procedure "{call
   * SBREXT_Set_Row.SET_VM(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   * 
   * @param data
   *          VMForm object
   */
  private String setVM(VMForm data)
  {
    // capture the duration
    // java.util.Date startDate = new java.util.Date();
    // logger.info(m_servlet.getLogMessage(m_classReq, "setVM", "starting set", startDate,
    // startDate));
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Connection sbr_db_conn = null;
    String sReturnCode = ""; // out
    try
    {
      VM_Bean vm = data.getVMBean();
      String sAction = vm.getVM_SUBMIT_ACTION();
      String sComments = vm.getVM_COMMENTS();
      String sShortMeaning = vm.getVM_SHORT_MEANING();
      String sMeaningDescription = vm.getVM_DESCRIPTION();
      String sBeginDate = util.getOracleDate(vm.getVM_BEGIN_DATE());
      String sEndDate = util.getOracleDate(vm.getVM_END_DATE());
      //get the connection from data if exists (used for testing)
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      if (sbr_db_conn != null)
      {
        //CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_VM(?,?,?,?,?,?,?,?,?,?,?)}");
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_VM(?,?,?,?,?,?,?,?,?,?,?,?)}");
        // register the Out parameters
        CStmt.registerOutParameter(1, java.sql.Types.VARCHAR); // return code
        CStmt.registerOutParameter(3, java.sql.Types.VARCHAR); // short meaning
        CStmt.registerOutParameter(4, java.sql.Types.VARCHAR); // meaning description
        CStmt.registerOutParameter(5, java.sql.Types.VARCHAR); // comments
        CStmt.registerOutParameter(6, java.sql.Types.VARCHAR); // begin date
        CStmt.registerOutParameter(7, java.sql.Types.VARCHAR); // end date
        CStmt.registerOutParameter(8, java.sql.Types.VARCHAR); // created by
        CStmt.registerOutParameter(9, java.sql.Types.VARCHAR); // date created
        CStmt.registerOutParameter(10, java.sql.Types.VARCHAR); // modified by
        CStmt.registerOutParameter(11, java.sql.Types.VARCHAR); // date modified
        CStmt.registerOutParameter(12, java.sql.Types.VARCHAR); // vm_idseq
        // Set the In parameters (which are inherited from the PreparedStatement class)
        CStmt.setString(2, sAction);
        CStmt.setString(3, sShortMeaning);
        CStmt.setString(4, sMeaningDescription);
        CStmt.setString(5, sComments);
        CStmt.setString(6, sBeginDate);
        CStmt.setString(7, sEndDate);
        // Now we are ready to call the stored procedure
        CStmt.execute();
        sReturnCode = CStmt.getString(1);
        if (sReturnCode != null && !sReturnCode.equals("API_VM_300"))
        {
          data.setStatusMsg(data.getStatusMsg() + "\\t" + sReturnCode + " : Unable to update Value Meaning - "
              + sShortMeaning + ".");
          data.setRetErrorCode(sReturnCode); // store returncode in request to track it all through
          // this request
        }
        else
        {
          // store the vm attributes created by stored procedure in the bean
          vm.setVM_SHORT_MEANING(CStmt.getString(3));
          vm.setVM_DESCRIPTION(CStmt.getString(4));
          vm.setVM_COMMENTS(CStmt.getString(5));
          vm.setVM_BEGIN_DATE(CStmt.getString(6));
          vm.setVM_END_DATE(CStmt.getString(7));
          vm.setVM_IDSEQ(CStmt.getString(12));
        }
      }
      // capture the duration
      // logger.info(m_servlet.getLogMessage(m_classReq, "setVM", "end set", startDate, new
      // java.util.Date()));
    }
    catch (Exception e)
    {
      logger.fatal("ERROR in setVM for other : " + e.toString(), e);
      data.setRetErrorCode("Exception");
      data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update VM attributes.");
      // m_classReq.setAttribute("retcode", "Exception");
      // this.storeStatusMsg("\\t Exception : Unable to update VM attributes.");
    }
    try
    {
      if (rs != null) rs.close();
      if (CStmt != null) CStmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (Exception ee)
    {
      logger.fatal("ERROR in setVM for close : " + ee.toString(), ee);
      data.setRetErrorCode("Exception");
      data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update VM attributes.");
      // m_classReq.setAttribute("retcode", "Exception");
      // this.storeStatusMsg("\\t Exception : Unable to update VM attributes.");
    }
    return data.getRetErrorCode();
  }

  /**
   * To insert a new Value Meaing in the database when selected a term from EVS. Called from
   * NCICurationServlet. Gets all the attribute values from the bean, sets in parameters, and
   * registers output parameter. Calls oracle stored procedure "{call
   * SBREXT_Set_Row.SET_VM_CONDR(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   * 
   * @param data
   *          VM Data object.
   */
  private String setVM_EVS(VMForm data, String conArray)
  {
    // capture the duration
    // java.util.Date startDate = new java.util.Date();
    // logger.info(m_servlet.getLogMessage(m_classReq, "setVM_EVS", "starting set", startDate,startDate));
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Connection sbr_db_conn = null;    
    try    
    {
      String sReturnCode = ""; // out
      VM_Bean vm = data.getVMBean();
      String sAction = vm.getVM_SUBMIT_ACTION();
      if (sAction == null) sAction = VMForm.CADSR_ACTION_INS;
      //get the connection from data if exists (used for testing)
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      if (sbr_db_conn != null)
      {
       // CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_VM_CONDR(?,?,?,?,?,?,?,?,?,?,?,?)}");
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_VM_CONDR(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        // register the Out parameters
        CStmt.registerOutParameter(2, java.sql.Types.VARCHAR); // return code
        CStmt.registerOutParameter(3, java.sql.Types.VARCHAR); // short meaning
        CStmt.registerOutParameter(4, java.sql.Types.VARCHAR); // meaning description
        CStmt.registerOutParameter(5, java.sql.Types.VARCHAR); // comments
        CStmt.registerOutParameter(6, java.sql.Types.VARCHAR); // begin date
        CStmt.registerOutParameter(7, java.sql.Types.VARCHAR); // end date
        CStmt.registerOutParameter(8, java.sql.Types.VARCHAR); // created by
        CStmt.registerOutParameter(9, java.sql.Types.VARCHAR); // date created
        CStmt.registerOutParameter(10, java.sql.Types.VARCHAR); // modified by
        CStmt.registerOutParameter(11, java.sql.Types.VARCHAR); // date modified
        CStmt.registerOutParameter(12, java.sql.Types.VARCHAR); // condr idseq
        CStmt.registerOutParameter(13, java.sql.Types.VARCHAR); // vm idseq
        // Set the In parameters (which are inherited from the PreparedStatement class)
        CStmt.setString(1, conArray);
        // set value meaning if action is to update
        if (sAction.equals(VMForm.CADSR_ACTION_UPD))
          CStmt.setString(3, vm.getVM_SHORT_MEANING());
        // Now we are ready to call the stored procedure
        System.out.println(sAction + " vm con array " + conArray + " query " + CStmt.toString());
        CStmt.execute();
        sReturnCode = CStmt.getString(2);
        if (sReturnCode != null)
        {
          data.setStatusMsg(data.getStatusMsg() + "\\t" + sReturnCode + " : Unable to update Value Meaning - "
              + vm.getVM_SHORT_MEANING() + ".");
          // creation
          data.setRetErrorCode(sReturnCode);
          data.setPvvmErrorCode(sReturnCode);
        }
        else
        {
          // store the vm attributes created by stored procedure in the bean
          vm.setVM_SHORT_MEANING(CStmt.getString(3));
          vm.setVM_DESCRIPTION(CStmt.getString(4));
          vm.setVM_COMMENTS(CStmt.getString(5));
          vm.setVM_BEGIN_DATE(CStmt.getString(6));
          vm.setVM_END_DATE(CStmt.getString(7));
          vm.setVM_CONDR_IDSEQ(CStmt.getString(12));
          vm.setVM_IDSEQ(CStmt.getString(13));
        }
      }
      // capture the duration
      // logger.info(m_servlet.getLogMessage(m_classReq, "setVM_EVS", "end set", startDate, new
      // java.util.Date()));
    }
    catch (Exception e)
    {
      logger.fatal("ERROR in setEVS_VM for other : " + e.toString(), e);
      data.setRetErrorCode("Exception");
      data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update VM attributes.");
    }
    try
    {
      if (rs != null) rs.close();
      if (CStmt != null) CStmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (Exception ee)
    {
      logger.fatal("ERROR in setEVS_VM for close : " + ee.toString(), ee);
      data.setRetErrorCode("Exception");
      data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update VM attributes.");
    }
    return data.getRetErrorCode();
  }

  private String getCDVMS(VMForm data, VM_Bean vm)
  {
    String sCD = vm.getVM_CD_IDSEQ();
    String vmname = vm.getVM_SHORT_MEANING();
    System.out.println(sCD + " get cdvms " + vmname);
    String cdvmsID = "";
    if (!sCD.equals(""))
    {
      Connection sbr_db_conn = null;
      ResultSet rs = null;
      Statement stmt = null;
      try
      {
        sbr_db_conn = data.getDBConnection();
        if (sbr_db_conn == null || sbr_db_conn.isClosed())
          sbr_db_conn = VMServlet.makeDBConnection();
        // Create a Callable Statement object.
        if (sbr_db_conn != null)
        {
          stmt = sbr_db_conn.createStatement();
          rs = stmt.executeQuery("select SBREXT_COMMON_ROUTINES.CD_VM_EXISTS('" + sCD + "', '" + vmname + "') from DUAL");
          //loop through to printout the outstrings
          while(rs.next())
          {
            cdvmsID = rs.getString(1);
          System.out.print(" cdvms " + cdvmsID);
            break;
          }
        }
      }
      catch(Exception e)
      {
        logger.fatal("ERROR - getCDVMS for other : ", e);
    //    data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to get existing cdvms." + e.toString());
        data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
      }
      try
      {
        if(rs!=null) rs.close();
        if(stmt!=null) stmt.close();
        if (data.getDBConnection() == null)
          VMServlet.closeDBConnection(sbr_db_conn);
      }
      catch(Exception ee)
      {
        logger.fatal("GetACSearch-do_conceptSearch for close : " + ee.toString(), ee);
      }
    }
    return cdvmsID;
  }
  
  /**
   * To insert a new CD VMS relationship in the database after creating VM or its relationship with VD.
   * Called from NCICurationServlet.
   * Gets all the attribute values from the bean, sets in parameters, and registers output parameter.
   * Calls oracle stored procedure
   *   "{call SBREXT_Set_Row.SET_CDVMS(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   *
   * @param sAction Insert or update Action.
   * @param vm VM Bean.
   *
   * @return String return code from the stored procedure call. null if no error occurred.
   */
  private String setCDVMS(VMForm data, VM_Bean vm)
  {
     //capture the duration
     //java.util.Date startDate = new java.util.Date();          
     //logger.info(m_servlet.getLogMessage(m_classReq, "setCDVMS", "starting set", startDate, startDate));
  
     Connection sbr_db_conn = null;
     ResultSet rs = null;
     CallableStatement CStmt = null;
     String sReturnCode = "";  //out
     try
     {
         String sShortMeaning = vm.getVM_SHORT_MEANING();
         String sMeaningDescription = vm.getVM_DESCRIPTION();
         String sCD_ID = vm.getVM_CD_IDSEQ();
         String cdName = vm.getVM_CD_NAME();
         //get the connection from data if exists (used for testing)
         sbr_db_conn = data.getDBConnection();
         if (sbr_db_conn == null || sbr_db_conn.isClosed())
           sbr_db_conn = VMServlet.makeDBConnection();
         if (sbr_db_conn != null)
         {
           CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_CD_VMS(?,?,?,?,?,?,?,?,?,?)}");
           // register the Out parameters
           CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
           CStmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //out cv_idseq
           CStmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //out cd_idseq
           CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //out value meaning
           CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //out description
           CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //date created
           CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //created by
           CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //modified by
           CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //date modified
           // Set the In parameters (which are inherited from the PreparedStatement class)
           CStmt.setString(2, VMForm.CADSR_ACTION_INS);
           CStmt.setString(4, sCD_ID);
           CStmt.setString(5, sShortMeaning);
           CStmt.setString(6, sMeaningDescription);
            // Now we are ready to call the stored procedure
           boolean bExcuteOk = CStmt.execute();
           sReturnCode = CStmt.getString(1);
           String sCV_ID = CStmt.getString(3);
           if (sReturnCode != null && !sReturnCode.equals("API_CDVMS_203"))
           {
             data.setStatusMsg(data.getStatusMsg() + "\\t " + sReturnCode + " : Unable to update Conceptual Domain and Value Meaning relationship - "
                 + cdName + " and " + sShortMeaning + ".");
            // m_classReq.setAttribute("retcode", sReturnCode);      //store returncode in request to track it all through this request
             data.setRetErrorCode(sReturnCode);
           }
       }
       //capture the duration
       //logger.info(m_servlet.getLogMessage(m_classReq, "setCDVMS", "end set", startDate, new java.util.Date()));  
     }
     catch(Exception e)
     {
       logger.fatal("ERROR in setCDVMS for other : " + e.toString(), e);
       //m_classReq.setAttribute("retcode", "Exception");
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update CD and VM relationship.");
     }
     try
     {
       if(rs!=null) rs.close();
       if(CStmt!=null) CStmt.close();
       if (data.getDBConnection() == null)
         VMServlet.closeDBConnection(sbr_db_conn);
     }
     catch(Exception ee)
     {
       logger.fatal("ERROR in setCDVMS for close : " + ee.toString(), ee);
       //m_classReq.setAttribute("retcode", "Exception");
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\tException : Unable to update CD and VM relationship.");
     }
     return sReturnCode;
  }
  
  /**
   * get the VM from caDSR
   * 
   * @param data
   *          VMForm object
   */
  private VM_Bean getVM(VMForm data, String vmName)
  {
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Connection sbr_db_conn = null;
    VM_Bean vm = new VM_Bean();
    try
    {
      // Create a Callable Statement object.
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      if (sbr_db_conn != null)
      {
        String sReturnCode = ""; // out
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_get_Row.GET_VM(?,?,?,?,?,?,?,?,?,?,?)}");
       // CStmt = sbr_db_conn.prepareCall("{call SBREXT_get_Row.GET_VM(?,?,?,?,?,?,?,?,?,?,?,?)}");
        // register the Out parameters
        CStmt.registerOutParameter(1, java.sql.Types.VARCHAR); // return code
        CStmt.registerOutParameter(2, java.sql.Types.VARCHAR); // short meaning
        CStmt.registerOutParameter(3, java.sql.Types.VARCHAR); // meaning description
        CStmt.registerOutParameter(4, java.sql.Types.VARCHAR); // comments
        CStmt.registerOutParameter(5, java.sql.Types.VARCHAR); // begin date
        CStmt.registerOutParameter(6, java.sql.Types.VARCHAR); // end date
        CStmt.registerOutParameter(7, java.sql.Types.VARCHAR); // created by
        CStmt.registerOutParameter(8, java.sql.Types.VARCHAR); // date created
        CStmt.registerOutParameter(9, java.sql.Types.VARCHAR); // modified by
        CStmt.registerOutParameter(10, java.sql.Types.VARCHAR); // date modified
        CStmt.registerOutParameter(11, java.sql.Types.VARCHAR); // condr_idseq
       // CStmt.registerOutParameter(12, java.sql.Types.VARCHAR); // vm_idseq
        // Set the In parameters (which are inherited from the PreparedStatement class)
        CStmt.setString(2, vmName);  //vm.getVM_SHORT_MEANING());
        // Now we are ready to call the stored procedure
        try
        {
          CStmt.execute();
        }
        catch (Exception ee)
        {
          return vm;  //no vm found error
        }
        sReturnCode = CStmt.getString(1);
        vm.setRETURN_CODE(sReturnCode);
        // update vm bean if found
        if (sReturnCode == null || sReturnCode.equals(""))
        {
          String sCondr = CStmt.getString(11);
          if (sCondr != null && !sCondr.equals(""))
          {
            // get the concept attributes from the condr idseq
            GetACService getAC = new GetACService(data.getRequest(), data.getResponse(), data.getCurationServlet());
            Vector<EVS_Bean> vCon = new Vector<EVS_Bean>();
            if (getAC != null)
              vCon = getAC.getAC_Concepts(sCondr, null, true);
            // get the evs bean from teh vector and store it in vm concept
            if (vCon != null && vCon.size() > 0)
              vm.setVM_CONCEPT_LIST(vCon);
          }
          // update all other attributes
          vm.setVM_CONDR_IDSEQ(sCondr);
          vm.setVM_SHORT_MEANING(CStmt.getString(2));
          vm.setVM_DESCRIPTION(CStmt.getString(3));
          vm.setVM_COMMENTS(CStmt.getString(4));
          vm.setVM_LONG_NAME(CStmt.getString(2));
         // vm.setVM_IDSEQ(CStmt.getString(12));
        }
        //data.setVMBean(vm);
      }
    }
    catch (Exception e)
    {
      logger.fatal("ERROR in getVM : " + e.toString(), e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to get VM." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
    try
    {
      if (rs != null) rs.close();
      if (CStmt != null) CStmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (Exception ee)
    {
      logger.fatal(data.getStatusMsg() + "\\tERROR in getVM for close : " + ee.toString(), ee);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to get VM." + ee.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
    return vm;
  }
  
  /**
   * To get the value from the bean for the selected field, called from VMsortedRows.
   *
   * @param curBean VM bean.
   * @param curField sort Type field name.
   *
   * @return String VMField Value if selected field is found. otherwise empty string.
   */
  private String getVMFieldValue(VM_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {      
      EVS_Bean curEVS = curBean.getVM_CONCEPT();
      if (curEVS == null) curEVS = new EVS_Bean();
      if (curField.equals("meaning"))
        returnValue = curBean.getVM_SHORT_MEANING();
      else if (curField.equals("MeanDesc"))
        returnValue = curBean.getVM_DESCRIPTION();
      else if (curField.equals("comment"))
        returnValue = curBean.getVM_COMMENTS();
      else if (curField.equals("ConDomain"))
        returnValue = curBean.getVM_CD_NAME();
      else if (curField.equals("umls"))
        returnValue = curEVS.getCONCEPT_IDENTIFIER();
      else if (curField.equals("source"))
        returnValue = curEVS.getEVS_DEF_SOURCE();
      else if (curField.equals("database"))
        returnValue = curEVS.getEVS_DATABASE();
        
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in VMAction-getVMField : " + e.toString(), e);
    }
    return returnValue;
  }
  
  private String validateConceptVM(VMForm data)
  {
    String dispAC = "";
    try
    {
      VM_Bean vmBean = data.getVMBean();
      String VMName = vmBean.getVM_SHORT_MEANING();
      String VMDef = vmBean.getVM_DESCRIPTION();
      Vector<EVS_Bean> vCon = vmBean.getVM_CONCEPT_LIST();
      //selected vm
      VM_Bean selVM = data.getSelectVM();
      String selVMName = selVM.getVM_SHORT_MEANING();
      String selVMDef = selVM.getVM_DESCRIPTION();
      if (selVMName == null) selVMName = "";
      StringBuffer sMsg = new StringBuffer(); 
      boolean changeVM = false;
      if (!selVMName.equals(""))
        changeVM = true;
      
      VM_Bean existVM = new VM_Bean();
      boolean editExisting = false;
      //create new VM with concepts
      if (selVMName.equals("") || !selVMName.equalsIgnoreCase(VMName))
      {
        sMsg.append("creating new with evs concepts \n");
        if (!VMName.equals(""))
          existVM = getExistingVM(VMName, "", "", data);  //check if vm exists      
      }
      else if (selVMName.equalsIgnoreCase(VMName))  //may be adding concepts to existing VM matching with name
      {
        sMsg.append("editing existing vm with evs concepts \n");
        existVM = data.getSelectVM();
        this.FLAG_VM_NAME_MATCH = 'Y';
        editExisting = true;
      }

      //common for both scenario      
      VM_Bean conVM = this.getExistVMbyCondr(vCon, existVM, data, sMsg);
      VM_Bean defVM = existVM;  //expect it to be same;
      if (editExisting && !selVMDef.equalsIgnoreCase(VMDef))
      {
        this.FLAG_VM_DEF_MATCH = VMAction.VM_DEF_NOT;  //make it that it does not match
        defVM = getExistVMbyDefn(VMDef, existVM, conVM, data, sMsg);        
      }
      dispAC = markSubmitVM(data, vmBean, existVM, conVM, defVM, vCon, VMName, sMsg, editExisting);
      
/*      //compare teh conditions
      if (this.FLAG_VM_NAME_MATCH == 'N')  // && this.FLAG_CON_DER_MATCH == 'N')
      {
        switch (this.FLAG_CON_DER_MATCH) 
        {
          case VMAction.CON_DEF_DER_NOT:
            vmBean.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);  //create new one
            //sMsg.append("New Value Meaning with concepts");
            data.setVMBean(vmBean);
            break;
          case VMAction.CON_DEF_DER_VM:
            //sMsg.append("There exists another Value Meaning with the same concepts. \n");
            dispAC = "Value Meaning";
            data.setVMBean(conVM);
            break;
          default:
            sMsg.append("new vm create problem");
            dispAC = "Value Meaning";
            //printFlagedVMs(data, sMsg, 'A');
        }
      }
      else if (this.FLAG_VM_NAME_MATCH == 'Y')
      {
        switch (this.FLAG_CON_DER_MATCH) 
        {
          case VMAction.CON_DEF_DER_VM:
            dispAC = "Value Meaning";
            //sMsg.append("Value Meaning matched to the existing one in caDSR, but Concepts do not match. \n");
          case VMAction.CON_DEF_NAME:
            if (existVM.getVM_CONDR_IDSEQ() == null || existVM.getVM_CONDR_IDSEQ().equals(""))
            {
              existVM.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);  //mark to update existing with evs concpets 
              //if (!changeVM)
                //sMsg.append("Update the existing Value Meaning with Concepts. \n");
            }
          case VMAction.CON_DEF_DER_VM_NAME:
            data.setVMBean(existVM);  //use the existing one for all three scenario's above
            break;
          default:
            //sMsg.append("Edit existing value Meaning problem \n");
            dispAC = "Value Meaning";
        }
      }
*/
    //  data.setStatusMsg(sMsg.toString());
      //print the message
      System.out.println("Remove later --- Condition : " + this.FLAG_VM_NAME_MATCH + this.FLAG_CON_DER_MATCH + " : \n");
    }
    catch (RuntimeException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return dispAC;
  }
  
  private String validateNonConVM(VMForm data)
  {
    String dispAC = "";
    try
    {
      VM_Bean vmBean = data.getVMBean();
      String VMName = vmBean.getVM_SHORT_MEANING();
      String vmDef = vmBean.getVM_DESCRIPTION();
      Vector<EVS_Bean> vCon = vmBean.getVM_CONCEPT_LIST();
      if (vCon == null) vCon = new Vector<EVS_Bean>();
      //selected vm
      VM_Bean selVM = data.getSelectVM();
      String selVMName = selVM.getVM_SHORT_MEANING();
      if (selVMName == null) selVMName = "";
      //check if creating new or editing existing
      VM_Bean existVM = new VM_Bean();
      StringBuffer sMsg = new StringBuffer(); 
      //check concept defn match to the value meaning
      if (VMName.equals("") && vmDef.equals(""))
        return dispAC;
      EVS_Bean con = new EVS_Bean();
      //allow search only if not default defintion
      if (!vmDef.equalsIgnoreCase(data.DEFINITION_DEFAULT_VALUE) && !vmDef.equalsIgnoreCase(data.DEFINITION_DEFAULT_VALUE + "."))
        con = checkConDefNameExist(VMName, vmDef, data, sMsg);
      Vector<EVS_Bean> conList = data.getConceptList();
      switch (this.FLAG_CON_DER_MATCH)
      {
        case (VMAction.CON_DEF_NAME_NOT):  // 'S':  //definition match name doesn't; continue to next case with new name
          String conName = con.getLONG_NAME();
          if (conName != null && !conName.equals(""))
            VMName = conName;
        case (VMAction.CON_DEF_NAME):  // 'Y':  //both defn and name match
          vCon.addElement(con);
          break;
        case (VMAction.CON_DEF_NAME_MULTI): // 'M':
        case (VMAction.CON_DEF_MULTI):  //'D':
          sMsg.append("Value Meaning definition you entered matches one or more concepts in caDSR. " +
              " Select one of the existing concepts or click Cancel to edit the VM.\n");
          //TODO - display all the concepts to select in a window.
          return "Concept";
        default:          
      }
      //create new VM with concepts
      boolean editExisting = false;
      if (selVMName.equals("") || !selVMName.equalsIgnoreCase(VMName))
      {
        sMsg.append("creating new without evs concepts \n");
        if (!VMName.equals(""))
          existVM = getExistingVM(VMName, "", "", data);  //check if vm exists
      }  //edit existing
      else if (selVMName.equalsIgnoreCase(VMName))
      {
        editExisting = true;
        sMsg.append("Edit existing VM without evs concepts \n");
        this.FLAG_VM_NAME_MATCH = 'Y';   //vm exists already
        existVM = data.getSelectVM();     //exist vm is selected vm
        Vector<VM_Bean> vList = new Vector<VM_Bean>();
        vList.addElement(existVM);
        data.setExistVMList(vList);
      }
      //common to both scenario
      String acs = "";
      VM_Bean conVM = this.getExistVMbyCondr(vCon, existVM, data, sMsg);
      VM_Bean defVM = getExistVMbyDefn(vmDef, existVM, conVM, data, sMsg);
      //call method to mark the change action
      dispAC = markSubmitVM(data, vmBean, existVM, conVM, defVM, vCon, VMName, sMsg, editExisting);
      
     // System.out.println("Final Message : ");
     // System.out.println(sMsg);
    }
    catch (RuntimeException e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    return dispAC;
  }
 
  private String markSubmitVM(VMForm data, VM_Bean vmBean, VM_Bean existVM, VM_Bean conVM, VM_Bean defVM, 
      Vector<EVS_Bean> vCon, String VMName, StringBuffer sMsg, boolean editExisting)
  {
    String dispAC = "";
    int flgVMCases = this.FLAG_CON_DER_MATCH + this.FLAG_VM_DEF_MATCH;
    if (this.FLAG_VM_NAME_MATCH == 'Y')
    {
      switch (flgVMCases)
      {
        case (VMAction.CON_DEF_DER_VM_NAME + VMAction.VM_DEF_NOT):  //'E' + 'N'  //con with exist but no def match
          //follows the next case
        case (VMAction.CON_DEF_DER_NOT + VMAction.VM_DEF_NOT):  //'N' + 'N'
         // if (vCon != null && vCon.size() > 0)
         //   existVM.setVM_CONCEPT_LIST(vCon);
          if (editExisting)  //reset the description attributes and update the vm
            existVM.setVM_DESCRIPTION(vmBean.getVM_DESCRIPTION());
          else
          {
            dispAC = "Value Meaning";
            break;
          }
        case (VMAction.CON_DEF_NAME + VMAction.VM_DEF_NOT):  //'C' + 'N'
        case (VMAction.CON_DEF_NAME + VMAction.VM_DEF_NAME):   //'C' + 'E':  //con name & def match but no condr
          //no message 
          if (this.FLAG_VM_DEF_MATCH != VMAction.VM_DEF_NOT || existVM.getVM_CONDR_IDSEQ().equals(""))  //update the condr only if 
            if (vCon != null && vCon.size() > 0)
            {
              existVM.setVM_DESCRIPTION(vmBean.getVM_DESCRIPTION());
              existVM.setVM_CONCEPT_LIST(vCon);
            }
          //same for all three above cases
          existVM.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD); 
        case (VMAction.CON_DEF_DER_VM_NAME + VMAction.VM_DEF_NAME): //'E' + 'E':
          //no message take exisitng=
        case (VMAction.CON_DEF_DER_NOT + VMAction.VM_DEF_NAME): //'N' + 'E':  //no concept at all
          data.setVMBean(existVM);  //use the existing one with matching concept msg
          break;
        default:
          dispAC = "Value Meaning";
          //sMsg.append("multiple scenarios occurred against the existing VM. Please select the right one to continue or cancel to edit \n");
          //printFlagedVMs(data, sMsg, 'A');
      }
    }
    else if (this.FLAG_VM_NAME_MATCH == 'N')
    {
      switch (flgVMCases)
      {
        case (VMAction.CON_DEF_DER_VM + VMAction.VM_DEF_NOT):
          //TODO display vm window matching to concept name /definition matches
        case (VMAction.CON_DEF_DER_VM + VMAction.VM_DEF_CONCEPT):
          data.setVMBean(conVM);  //use concept matched VM (vmdef not or both vmdef and concept match to another vm)
          dispAC = "Value Meaning";
//      TODO display vm window matching to concept name /definition matches
          break;
          
        case (VMAction.CON_DEF_DER_NOT + VMAction.VM_DEF_OTHER):
          data.setVMBean(defVM);  //use the defn vm one with msg
          dispAC = "Value Meaning";
//      TODO display vm window matching to vm definition matches
          break;
          
        case (VMAction.CON_DEF_NAME_NOT + VMAction.VM_DEF_NOT):
          vmBean.setVM_SHORT_MEANING(VMName);  //add the concept name that has matching defn but not matching name
//      TODO display concept window matching to concept definition 
        case (VMAction.CON_DEF_DER_VM_NAME + VMAction.VM_DEF_NOT):
          vmBean.setVM_CONCEPT_LIST(vCon);  //add concept list
          dispAC = "Concept";
         // TODO display concept window message
        case (VMAction.CON_DEF_DER_NOT + VMAction.VM_DEF_NOT):
          vmBean.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);  //create new one; no msg
          data.setVMBean(vmBean);
          break;
          
        default:
          dispAC = "Value Meaning";
          //sMsg.append("multiple scenarios occurred against NON existing vm. Please select the right one to continue or cancel to edit \n");
          //printFlagedVMs(data, sMsg, 'A');
          
      }
    }
    //print the message
    System.out.println(dispAC + " Remove later --- " + flgVMCases + " Condition : " + this.FLAG_VM_NAME_MATCH + this.FLAG_CON_DER_MATCH + this.FLAG_VM_DEF_MATCH + " : \n");
    return dispAC;
  }
  
  private void getFlaggedMessageVM(VMForm data, char vmFlag)
  {
    Vector<VM_Bean> vErrMsg = data.getErrorMsgList();
    String sMsg = "";
    switch (vmFlag)
    {
      case 'A': //print all cases
      case 'E':  //existing vm only
        Vector<VM_Bean> vmexist = data.getExistVMList();
        if (vmexist != null && vmexist.size() > 0)
        {
          for (int i=0; i<vmexist.size(); i++)
          {
            VM_Bean vm = vmexist.elementAt(i);
            if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals(""))
              break;
            else
              vErrMsg.addElement(printFlagedVMs(vm, "Name"));
          }
        }
        if (vmFlag != 'A')
          break;
      case 'C':   //concept vm only
        Vector<VM_Bean> vmcon = data.getConceptVMList();
        if (vmcon != null && vmcon.size() > 0)
        {
          for (int i=0; i<vmcon.size(); i++)
          {
            VM_Bean vm = vmcon.elementAt(i);
            if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals(""))
              break;
            else
              vErrMsg.addElement(printFlagedVMs(vm, "Concept"));
          }
        }
        if (vmFlag != 'A')
          break;
      case 'D': 
        Vector<VM_Bean> vmdef = data.getDefnVMList();
        if (vmdef != null && vmdef.size() > 0)
        {
          for (int i=0; i<vmdef.size(); i++)
          {
            VM_Bean vm = vmdef.elementAt(i);
            if (vm == null || vm.getVM_SHORT_MEANING() == null || vm.getVM_SHORT_MEANING().equals(""))
              break;
            else
              vErrMsg.addElement(printFlagedVMs(vm, "Definition"));
          }
        }
      default:
    }
    data.setErrorMsgList(vErrMsg);
  }

  private VM_Bean printFlagedVMs(VM_Bean aVM, String vmTypeMatch)
  {
    aVM.setVM_COMMENTS(vmTypeMatch + " matches.");
/*    String sMsg = "";
    sMsg += "&nbsp;&nbsp;VM Name: " + aVM.getVM_SHORT_MEANING() + "<br>";
    sMsg += "&nbsp;&nbsp;VM Description: " + aVM.getVM_DESCRIPTION() + "<br>";
    sMsg += "&nbsp;&nbsp;VM Concepts: <br>";
    if (aVM.getVM_CONCEPT_LIST() != null && aVM.getVM_CONCEPT_LIST().size() > 0)
    {
      for (int i=0; i<aVM.getVM_CONCEPT_LIST().size(); i++)
      {
        EVS_Bean eB = (EVS_Bean)aVM.getVM_CONCEPT_LIST().elementAt(i);
        if (eB != null)
          sMsg += "&nbsp;&nbsp;" + eB.getLONG_NAME() + "&nbsp;&nbsp;" + eB.getCONCEPT_IDENTIFIER() + "&nbsp;&nbsp;" + eB.getPREFERRED_DEFINITION() + "<br>";        
      }
    }
    if (!vmTypeMatch.equals(""))
      sMsg += "&nbsp;&nbsp;Reason: " + vmTypeMatch + " matches.&nbsp;&nbsp;";
*/    return aVM;
  }

  private void getFlaggedMessageCon(VMForm data, String typeMatch)
  {
  //  Vector<String> vErrMsg = data.getErrorMsgList();
    Vector<EVS_Bean> conList = data.getConceptList();
    if (conList != null && conList.size() > 0)
    {
      for (int i=0; i<conList.size(); i++)
      {
        String sMsg = "";
        EVS_Bean eB = (EVS_Bean)conList.elementAt(i);
        if (eB != null)
        {
          //String sDef = eB.getDESCRIPTION();
          //if (sDef == null || sDef.equals(""))
          String sDef = eB.getPREFERRED_DEFINITION();
          sMsg += "\\tConcept Name: " + eB.getLONG_NAME() + "\\n";
          sMsg += "\\tConcept ID: " + eB.getCONCEPT_IDENTIFIER() + "\\n";
          sMsg += "\\tConcept Definition:" + sDef + "\\n";
          sMsg += "\tReason: " + typeMatch + " matches.\n\n";
         // vErrMsg.addElement(sMsg);
        }
      }
    }
   // data.setErrorMsgList(vErrMsg);
  }
  
  private String getConceptCondr(Vector<EVS_Bean> conList, VMForm data)
  {
    String condr = "";
    try
    {
      ConceptForm conData = new ConceptForm();
      conData.setConceptList(conList);
      
      Connection sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      conData.setDBConnection(sbr_db_conn);
      //call the method n concept action
      ConceptAction conAct = new ConceptAction();
      condr = conAct.getConDerivation(conData);
      //close the conn only if not testing
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (SQLException e)
    {
      logger.fatal("VM concept search connection problem ", e);
      e.printStackTrace();
    }    
    return condr;
  }

  private VM_Bean getExistVMbyCondr(Vector<EVS_Bean> vCon, VM_Bean exeVM, VMForm data, StringBuffer sMsg)
  {
    VM_Bean conVM = new VM_Bean();
    if (vCon != null && vCon.size() > 0)
    {
      String sCondr = this.getConceptCondr(vCon, data);
    System.out.println(sCondr + " exist vm by condr " + vCon.size() + " con flag " + this.FLAG_CON_DER_MATCH);

      if (!sCondr.equals(""))
      {
        //if conder is not matched assume match to name & def (because it will be created later)
        if (this.FLAG_CON_DER_MATCH == this.CON_DEF_DER_NOT)
          this.FLAG_CON_DER_MATCH = this.CON_DEF_NAME;
//      matches to the matched vm
        String vmCondr = exeVM.getVM_CONDR_IDSEQ();
        if (vmCondr.equals(sCondr)) 
        {
          this.FLAG_CON_DER_MATCH = this.CON_DEF_DER_VM_NAME;  // 'E';
          sMsg.append("Concept Derivation matches to the Existing Value Meaning. \n");
        }
        else  //look for concept matched vm
        {
        //  if (!sCondr.equals(""))
            conVM = this.getExistingVM("", sCondr, "", data);
          //reset the con defn match value to mark that concept defn match does not exist in vm
          if (this.FLAG_CON_DER_MATCH == this.CON_DEF_NAME)  // 'Y')    //name & def match
          {
            //this.FLAG_CON_DER_MATCH = 'C';
            sMsg.append("Matched concept definition and Name does not exist in Value Meaning. \n");
          }
          else if (this.FLAG_CON_DER_MATCH ==  this.CON_DEF_NAME_NOT)  //'S')  //only def match
          {
            //this.FLAG_CON_DER_MATCH = 'S';
            sMsg.append("Matched concept definition does not exist in Value Meaning. \n");
          }
          else if (this.FLAG_CON_DER_MATCH == this.CON_DEF_DER_VM_MULTI)  // 'D')
            sMsg.append("Concept Derivation matches to the multiple Value Meanings. \n");
           //TODO same as concept multi message 
          else if (this.FLAG_CON_DER_MATCH == this.CON_DEF_DER_VM)  // 'Y')
            sMsg.append("Concept Derivation matches to the Value Meanings. \n");
        }  
      }
    }
    //System.out.println(this.FLAG_CON_DER_MATCH + " CONder " + sMsg);

    return conVM;
  }
  
  private VM_Bean getExistVMbyDefn(String sDef, VM_Bean exVM, VM_Bean conVM, VMForm data, StringBuffer sMsg)
  {
    VM_Bean defVM = new VM_Bean();
    //first check if existing vm matches teh defn
    if (exVM != null && exVM.getVM_DESCRIPTION().equalsIgnoreCase(sDef))
    {
      this.FLAG_VM_DEF_MATCH = this.VM_DEF_NAME; // 'E';
      sMsg.append("Value Meaning description matches to the Existing Value Meaning \n");
      return exVM;
    }
    //check if concept matched vm matches defn
    if (conVM != null && conVM.getVM_DESCRIPTION().equalsIgnoreCase(sDef))
    {
      this.FLAG_VM_DEF_MATCH = this.VM_DEF_CONCEPT; // 'C';
      sMsg.append("Value Meaning description matches to the Value Meaning that matches to the Concept Definition \n");
      return conVM;
    }
    //search for defintion match vm in cadsr
    boolean isDefault = false;
    if (sDef.equalsIgnoreCase(data.DEFINITION_DEFAULT_VALUE) || sDef.equalsIgnoreCase(data.DEFINITION_DEFAULT_VALUE + "."))
      isDefault = true;
    if (!sDef.equals("") && !isDefault)
      defVM = this.getExistingVM("", "", sDef, data);
    if (this.FLAG_VM_DEF_MATCH == this.VM_DEF_MULTI)  // 'D')
      sMsg.append("Value Meaning description matches to the multiple Value Meanings. \n");
    else if (this.FLAG_VM_DEF_MATCH == this.VM_DEF_OTHER)  // 'Y')
      sMsg.append("Value Meaning description matches to the Value Meanings. \n");
    
    //System.out.println(this.FLAG_VM_DEF_MATCH + " vmDEF " + sMsg);
    
    return defVM;
  }
  
  private String getVMbyCondr(VMForm data, String condr)
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    Statement stmt = null;
    String vm = "";
    try
    {
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        stmt = sbr_db_conn.createStatement();
        rs = stmt.executeQuery("select short_meaning from sbr.value_meanings_view where condr_idseq = '" + condr + "'");
        //loop through to printout the outstrings
        while(rs.next())
        {
          vm = rs.getString(1);
        //System.out.println(vm + " vm condr " + condr);
          if (vm == null) vm = "";
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - getVMbyCondr for other : ", e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to do search vm by condr." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    try
    {
      if(rs!=null) rs.close();
      if(stmt!=null) stmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      logger.fatal("error - dovmsearch by condr for close : " + ee.toString(), ee);
    }
    return vm;
  }
  
  /**
   * when the changing vm does not have concept relationship, tool checks if there exists matched definition in concept class.
   * if matched by defnition and name to the vm, it would update the vm with that concept relationship.
   * @param vmName
   * @param vmDef
   * @param data
   * @return String concept name.
   */
  private EVS_Bean checkConDefNameExist(String vmName, String vmDef, VMForm data, StringBuffer sMsg) 
  {
    //System.out.println("checkConDefExist - ");
    EVS_Bean eBean = new EVS_Bean();
    Vector<EVS_Bean> vConDef = new Vector<EVS_Bean>();
    if (!vmDef.equals(""))
      this.callConceptSearch(vmDef, data);
    if (vConDef != null && vConDef.size() > 0)  //definition matched
    {
      int matchFound = 0;
      data.setConceptList(vConDef);
      for (int i =0; i<vConDef.size(); i++)
      {
        eBean = (EVS_Bean)vConDef.elementAt(i);
        if (eBean != null)
        {
          String conName = eBean.getCONCEPT_NAME();
          if (vmName.equalsIgnoreCase(conName));
            matchFound += 1;
        }
      }
      //return the constants according to the number of records found
      if (matchFound == 0 && vConDef.size() > 1)
      {
        this.FLAG_CON_DER_MATCH = this.CON_DEF_MULTI;  // 'D';  //multiple defn but no name match
        sMsg.append("Definition matches to multiple concepts but Name does not match. \n");
      }
      else if (matchFound == 0)
      {
        this.FLAG_CON_DER_MATCH = this.CON_DEF_NAME_NOT;  // 'S';  //single defn but no name match
        sMsg.append("Value Meaning Desrciption matches the Concept Definition but name does not. \n");
      }
      else if (matchFound > 1)
      {
        this.FLAG_CON_DER_MATCH = this.CON_DEF_NAME_MULTI;  // 'M';  //mutliple defn and name match
        sMsg.append("Multiple concept matches to same Defintion and Name. \n");
      }
      else if (matchFound == 1)
      {
        this.FLAG_CON_DER_MATCH = this.CON_DEF_NAME; // 'Y';  //single defn & name match.
        sMsg.append("Existing Concept has same Name and Definition. \n");
      }
    }
    //System.out.println(data.FLAG_CON_DEF_NAME_MATCH + " condef " + sMsg);
    return eBean;
  }

  /**
   * calls method to do the concept search matched by defintion
   * @param vmName
   * @param vmDef
   * @param data
   * @return vector of concepts
   */
  private Vector<EVS_Bean> callConceptSearch(String vmDef, VMForm data)
  {
    //System.out.println("callConceptSearch - ");
    ConceptForm conData = new ConceptForm();
    try
    {
      //submit concept info
      conData.setSearchDefn(vmDef);
      String[] status = {"RELEASED"};
      conData.setASLNameList(status);
      //get eth connection
      Connection sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      conData.setDBConnection(sbr_db_conn);
      //call the method
      ConceptAction conAct = new ConceptAction();
      conAct.doConceptSearch(conData);
      //close the connection
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (SQLException e)
    {
      logger.fatal("VM concept search connection problem ", e);
      e.printStackTrace();
    }
    return conData.getConceptList();    
  }

  private void setSubmitAction(String dispMsg, VM_Bean selBean, VMForm data, String sAct)
  {
    System.out.println("setSubmitAction - " + sAct + " sumbit " + dispMsg);
  }

  private VM_Bean getExistingVM(String vmName, String sCondr, String sDef, VMForm data)
  {
    //System.out.println("getExistingVM - " + vmName + sCondr + sDef);
    VM_Bean exVM = new VM_Bean();
    
    //set data filters
    data.setSearchTerm(vmName);           //search by name
    data.setSearchFilterCondr(sCondr);    //search by condr
    data.setSearchFilterDef(sDef);        //search by defintion
    //call method
    data.setVMList(new Vector<VM_Bean>());
  System.out.println(vmName+sCondr+sDef+ " : VMs before - " + data.getVMList().size());
    searchVMValues(data);
    //set teh flag
    Vector<VM_Bean> vmList = data.getVMList();
    if (vmList != null && vmList.size() >0)
    {      
      System.out.println(vmName+sCondr+sDef+ " : VMs after - " + data.getVMList().size());
      if (!vmName.equals(""))
        data.setExistVMList(vmList);
      else if (!sCondr.equals(""))
        data.setConceptVMList(vmList);
      else if (!sDef.equals(""))
        data.setDefnVMList(vmList);
   //   int vmFound = 0;
      for (int i =0; i<vmList.size(); i++)
      {
        VM_Bean vm = vmList.elementAt(i);
        System.out.println(i + " : " + vm.getVM_SHORT_MEANING() + " : " + vm.getVM_CONDR_IDSEQ() + " : " + vm.getVM_DESCRIPTION());
        if (!vmName.equals(""))  // && vm.getVM_SHORT_MEANING().equals(vmName))
        {
          this.FLAG_VM_NAME_MATCH = 'Y';
          exVM = vmList.elementAt(i);
          if (i > 0)
            this.FLAG_VM_DEF_MATCH = this.VM_DEF_MULTI; // 'D';
          else
            this.FLAG_VM_DEF_MATCH = this.VM_DEF_OTHER;  // 'Y';
        //  break;
        }
        else if (!sCondr.equals("")) // && vm.getVM_CONDR_IDSEQ().equals(sCondr))
        {
          exVM = vmList.elementAt(i);
          if (i > 0)
            this.FLAG_CON_DER_MATCH = this.CON_DEF_DER_VM_MULTI;  // 'D';
          else
            this.FLAG_CON_DER_MATCH = this.CON_DEF_DER_VM; // 'Y';
        }
        else if (!sDef.equals("")) // && vm.getVM_DESCRIPTION().equals(sDef))
        {
          exVM = vmList.elementAt(i);
          if (i > 0)
            this.FLAG_VM_DEF_MATCH = this.VM_DEF_MULTI; // 'D';
          else
            this.FLAG_VM_DEF_MATCH = this.VM_DEF_OTHER;  // 'Y';
        }
      }
    }
    //System.out.println(exVM.getVM_SHORT_MEANING() + " existing vm Name " + exVM.getVM_CONDR_IDSEQ());    
    return exVM;
  }

  private void getVDandForm(VMForm data, VM_Bean vm)
  {
    //System.out.println("getVDandForm - ");
    ResultSet rs = null;
    Statement CStmt = null;
    Connection sbr_db_conn = null;
    try
    {
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = VMServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        String vmName = vm.getVM_SHORT_MEANING();   //.toUpperCase();
        String sSQL = "select vd.long_name, vd.vd_id, vd.version, vd.asl_name, pv.VALUE, pv.SHORT_MEANING " + 
             "from sbr.value_domains_view vd, sbr.vd_pvs_view vp, sbr.permissible_values_view pv, value_meanings_view vm " +
             "where vd.VD_IDSEQ = vp.vd_idseq and  vp.PV_IDSEQ = pv.PV_IDSEQ and pv.SHORT_MEANING = vm.SHORT_MEANING " +
             "and vm.SHORT_MEANING = '" + vmName + "'";
             //"and upper(vm.SHORT_MEANING) = '" + vmName + "'";
        System.out.print(vmName + " SQL : " + sSQL);
        CStmt = sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        Vector<VD_Bean> vdAssoc = new Vector<VD_Bean>();
        while(rs.next())
        {
          VD_Bean vd = new VD_Bean();
          vd.setVD_LONG_NAME(rs.getString(1));
          vd.setVD_VD_ID(rs.getString(2));
          vd.setVD_VERSION(rs.getString(3));
          vd.setVD_ASL_NAME(rs.getString(4));
          vd.setVD_Permissible_Value(rs.getString(5));
          vdAssoc.addElement(vd);
          //System.out.println(vd.getVD_LONG_NAME() + " : " + vd.getVD_VERSION());
        }// end of while
        vm.setVM_VD_LIST(vdAssoc);
      }
    }
    catch (SQLException e)
    {
      e.printStackTrace();
      logger.fatal("ERROR in getVM : " + e.toString(), e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to get VM." + e.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
    try
    {
      if (rs != null) rs.close();
      if (CStmt != null) CStmt.close();
      if (data.getDBConnection() == null)
        VMServlet.closeDBConnection(sbr_db_conn);
    }
    catch (Exception ee)
    {
      logger.fatal("ERROR in close connection : " + ee.toString(), ee);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : close connection." + ee.toString());
      data.setActionStatus(VMForm.ACTION_STATUS_FAIL);
    }
  }

  //VM Flags
  private char FLAG_VM_NAME_MATCH = 'N';
  private int FLAG_VM_DEF_MATCH = 1;
 // public int FLAG_CON_DEF_NAME_MATCH = 1;
  private int FLAG_CON_DER_MATCH = 100;  //no defn or deriv match
  private char FLAG_VM_VD_RELATION_MATCH = 'N';

  //concept definition data match constants 
  private static final int CON_DEF_NOT = 10;
  private static final int CON_DEF_MULTI = 20;  //'D'  mutliple definitions and no name
  private static final int CON_DEF_NAME_MULTI = 30;  //'M'  multiple def and multiple names
  private static final int CON_DEF_NAME_NOT = 40;  //'S'  only one defn and name don't
  private static final int CON_DEF_NAME = 50;  //'Y'  both name and defn
  private static final int CON_DEF_DER_VM_NAME = 60;  //'E'  matching concept with existing vm
  private static final int CON_DEF_DER_VM_MULTI = 70;  //'D'  matching concept with multiple vm
  private static final int CON_DEF_DER_VM = 80;  //'Y'  matching concept derivation to another vm (not existing
  private static final int CON_DEF_DER_NOT = 100;     //no matching derivation vm

  //value meaning definition data match constants 
  private static final int VM_DEF_NOT = 1;
  private static final int VM_DEF_MULTI = 2;     //multiple definitions but name don't match
  private static final int VM_DEF_NAME_MULTI = 3;  //multiple defns with multiple names
  private static final int VM_DEF_NAME = 4;    //defn matches to existing vm
  private static final int VM_DEF_CONCEPT = 5;  //defn matches to concept vm
  private static final int VM_DEF_OTHER = 6;  //defn matches to other vm (neither existing or concept vms)
  
  //vm messages
  private final String VM_NAME_MATCH_MSG = "Name";
  private final String CON_DEF_NAME_NOT_MATCH_MSG = "Value Meaning definition matches the Concept Defintion in caDSR but does not match the Concept Name. ";
  private final String VM_DEF_NOT_MATCH_MSG = "Value Meaning definition does not match the existing VM definition. ";
  private final String VM_EXIST_OTHERVD_MSG = "This VM is referenced by other administered components. ";
  private final String VM_CON_DER_MATCH_MSG = "The existing VM has a relationship to EVS concepts. ";
  private final String CREATE_NEW_MSG = "Change Value Meaning attributes to create new VM. ";
  private final String EDIT_EXISTING_MSG = "Click OK to selected the existing VM. ";

  
}
