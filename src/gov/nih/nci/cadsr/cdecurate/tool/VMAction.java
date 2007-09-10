// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VMAction.java,v 1.26 2007-09-10 17:18:21 hebell Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;
import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import oracle.jdbc.driver.OracleTypes;
import org.apache.log4j.Logger;
/**
 * @author shegde
 */
public class VMAction implements Serializable
{  
  private static final long serialVersionUID = 1L;
  private static final Logger logger = Logger.getLogger(VMAction.class.getName());
  private UtilService util = new UtilService(); 

  
  /** constructor*/
  public VMAction()
  {
  }

//other public methods  
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
    CallableStatement cstmt = null;
    Connection conn = null;
    try
    {
      //do not continue search if no search filter
      if (data.getSearchTerm().equals("") && data.getSearchFilterCD().equals("") && data.getSearchFilterCondr().equals("") && data.getSearchFilterDef().equals(""))
        return;
      
      Vector<VM_Bean> vmList = data.getVMList();
      if (vmList == null) vmList = new Vector<VM_Bean>();
      //get the connection from data if exists (used for testing)
      conn = data.getDBConnection();
      if (conn == null || conn.isClosed())
        conn = data.getCurationServlet().connectDB(); //VMServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (conn != null)
      {
        cstmt = conn.prepareCall("{call SBREXT.SBREXT_CDE_CURATOR_PKG.SEARCH_VM(?,?,?,?,?)}");
        // Now tie the placeholders for out parameters.
        cstmt.registerOutParameter(5, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        cstmt.setString(1, data.getSearchTerm());  //name 
        cstmt.setString(2, data.getSearchFilterCD());
        cstmt.setString(3, data.getSearchFilterDef());
        cstmt.setString(4, data.getSearchFilterCondr());
        
         // Now we are ready to call the stored procedure
        cstmt.execute();
        // store the output in the resultset
        rs = (ResultSet) cstmt.getObject(5);

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            VM_Bean vmBean = doSetVMAttributes(rs, conn);
            vmBean.setVM_BEGIN_DATE(rs.getString("begin_date"));
            vmBean.setVM_END_DATE(rs.getString("end_date"));
            vmBean.setVM_CD_NAME(rs.getString("cd_name"));            
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
      if(cstmt!=null) cstmt.close();
      if (data.getDBConnection() == null)
        data.getCurationServlet().freeConnection(conn);  //VMServlet.closeDBConnection(conn);
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR - VMAction-searchVM for close : " + ee.toString(), ee);
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
        EVS_Bean vmConcept = VMBean.getVM_CONCEPT();
        if (vmConcept == null) vmConcept = new EVS_Bean();
        if (vSelAttr.contains("Value Meaning")) vResult.addElement(VMBean.getVM_SHORT_MEANING());
        if (vSelAttr.contains("Meaning Description")) vResult.addElement(VMBean.getVM_DESCRIPTION());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(VMBean.getVM_CD_NAME());        
        if (vSelAttr.contains("EVS Identifier")) vResult.addElement(conID);  //vmConcept.getCONCEPT_IDENTIFIER());        
        if (vSelAttr.contains("Definition Source")) vResult.addElement(defsrc);  //vmConcept.getEVS_DEF_SOURCE());        
        if (vSelAttr.contains("Vocabulary")) vResult.addElement(vocab);  //vmConcept.getEVS_DATABASE());        
        if (vSelAttr.contains("Comments")) vResult.addElement(VMBean.getVM_CHANGE_NOTE());
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

  /**appends the Value meaning selected from the VM search result
   * @param selRows String array of the selected rows
   * @param vRSel vector VM Bean of the search results
   * @param pv PVBean object of the selected row
   */
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
    //log the errr message
    if (!errMsg.equals(""))
      logger.fatal("Error msg : doAppendSelectVM " + errMsg);
  }

  /** saves and marks the VM changes to store it in the database
   * @param pv PVBean object
   * @param vd VDBean object
   * @param data VMForm object
   */
  public void setDataForCreate(PV_Bean pv, VD_Bean vd, VMForm data)
  {
    VM_Bean vm = data.getVMBean();
    //VM_Bean selvm = data.getSelectVM(); 
    //boolean handTypedVM = true;
    //Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    vm.setVM_CD_IDSEQ(vd.getVD_CD_IDSEQ());
    vm.setVM_CD_NAME(vd.getVD_CD_NAME());
    vm.setVM_BEGIN_DATE(pv.getPV_BEGIN_DATE());  //vm begin date
    vm.setVM_END_DATE(pv.getPV_END_DATE());   //vm end date 
    //call the action change VM to validate the vm
    data.setVMBean(vm);
  //  if (vm.getVM_IDSEQ() == null || vm.getVM_IDSEQ().equals(""))
   //   this.doChangeVM(data);  
    VM_Bean exVM = validateVMData(data);
    if (exVM == null)
        vm.setVM_IDSEQ("");
  }
  
  /**to submit the VM changes to the database. 
   * checks if already exists in the database.
   * gets concept id to associates, creates concept or non concept VM
   * creates cd relationship
   * 
   * @param data VMForm object
   * @return String error message
   */
  public String doSubmitVM(VMForm data)
  {
    String erMsg = ""; 
    VM_Bean vm = data.getVMBean();
    String sAct = vm.getVM_SUBMIT_ACTION();
    if (!sAct.equals("") && !sAct.equals(VMForm.CADSR_ACTION_NONE))
    {
      //check if vm exists for INS action (not sure if needed or what to do later)
      data.setStatusMsg("");
      String ret = "";
      //check the condition whether changing vm with concept or not
      Vector<EVS_Bean> vCon = vm.getVM_CONCEPT_LIST();  //get the con list first
      if (vCon != null && vCon.size()> 0)
      {
        //set concept (get concept will be done at the time of selection itself
        ConceptAction conAct = new ConceptAction();
        ConceptForm condata = new ConceptForm();
        if (data.getDBConnection() != null)
          condata.setDBConnection(data.getDBConnection()); //get the connection
        else
          condata.setDBConnection(data.getCurationServlet().connectDB()); //VMServlet.makeDBConnection());  //make the connection

        String conArray = conAct.getConArray(vCon, true, condata);        
        if (data.getDBConnection() == null)
          data.getCurationServlet().freeConnection(condata.getDBConnection());  //VMServlet.closeDBConnection(condata.getDBConnection());  //close the connection
        
        //append the concept message
        if (!condata.getStatusMsg().equals(""))
          erMsg += condata.getStatusMsg();
        //set setvm_evs method to set th edata
        ret = this.setVM(data, conArray);
      }
      else
        ret = this.setVM(data, null);  //update or insert non evs vm

      if (ret != null && !ret.equals(""))
        erMsg += "\\n" + ret;
      
      //exit if error occurred
      if (erMsg == null || erMsg.equals(""))
      {      
        //create cdvms relationship
        if (!vm.getVM_CD_IDSEQ().equals(""))
            this.setCDVMS(data, vm);
        //reset back to none after successful submission 
        vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_NONE);
      }
    }
    return erMsg;
  }
  
  /**Makes the name for VM from VM concepts
   * @param vm VMBEan object
   * @param iFrom int value of which page teh action going to be
   */
  public void makeVMNameFromConcept(VM_Bean vm, int iFrom)
  {
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    String vmName = "";
    String vmDef = "";
    for (int i =0; i<vmCon.size(); i++)
    {
        EVS_Bean con = vmCon.elementAt(i);
        if (!con.getNVP_CONCEPT_VALUE().equals(""))
        {
           String conName = con.getLONG_NAME();
           String conDef = con.getPREFERRED_DEFINITION();
           //String conExp = "::" + con.getNVP_CONCEPT_VALUE();
           int nvpInd = conName.indexOf("::");
           if (nvpInd > 0 && i == vmCon.size()-1)  //last one in the list, remove con value from the name
           {             
             conName = conName.substring(0, nvpInd);
             //con.setNVP_CONCEPT_VALUE("");  //NOte - do not remove
             int nvpDefInd = conDef.indexOf("::");
             if (nvpDefInd > 0)
               conDef = conDef.substring(0, nvpDefInd);
           }
           else if (nvpInd < 1 && i < vmCon.size()-1)  //put back the concept value in the name and def
           {
               String sNVP = con.getNVP_CONCEPT_VALUE();
               conName = conName + "::" + sNVP;
               conDef = conDef + "::" + sNVP;
           }
           con.setLONG_NAME(conName);
           con.setPREFERRED_DEFINITION(conDef);
           vmCon.setElementAt(con, i);  
        }
        if (!vmName.equals(""))  vmName += " ";
        vmName += con.getLONG_NAME();
        if (!vmDef.equals("")) vmDef += ": ";
        vmDef += con.getPREFERRED_DEFINITION();
    }
   //change the name only from new vm 
    switch (iFrom)
    {
        case ConceptForm.FOR_PV_PAGE_CONCEPT:
            vm.setVM_DESCRIPTION(vmDef);
            String curName = vm.getVM_SHORT_MEANING();
            if (!curName.equalsIgnoreCase(vmName))
            {
                vm.setVM_LONG_NAME(vmName);
                vm.setVM_SHORT_MEANING(vmName);
                vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
            }
            break;
        case ConceptForm.FOR_VM_PAGE_CONCEPT:
            //add the vm definition to manual defintion if it is empty
            if (vm.getVM_ALT_DEFINITION().equals(""))
              vm.setVM_ALT_DEFINITION(vm.getVM_DESCRIPTION());
            //add name and description
            vm.setVM_ALT_NAME(vmName);
            vm.setVM_DESCRIPTION(vmDef);
            break;
        case ConceptForm.FOR_VM_PAGE_OPEN:
            vm.setVM_ALT_NAME(vmName);
            break;        
    }
  }
  
  /**
   * resets the vm concepts from page
   * @param sCons list of concept names from teh page
   * @param vm VMBean selected value meaning
   * @param pv PVBean selected permissible value
   */
  public void resetVMConcepts(String[] sCons, VM_Bean vm, PV_Bean pv)
  {
      Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
      if (sCons.length != vmCon.size())
      {
        Vector<EVS_Bean> newList = new Vector<EVS_Bean>();
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
        vm.setVM_CONCEPT_LIST(newList);
        pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_UPD);  //PVForm.CADSR_ACTION_INS);  //pv changed
      }
      //get the name   
      this.makeVMNameFromConcept(vm, ConceptForm.FOR_PV_PAGE_CONCEPT);          
  }
  
  /**
   * inserts or adds new depeneding on teh existing concepts and sets vm attributes
   * @param vm VM bean
   * @param eBean evs bean object
   * @param iFrom from pv or vm edit pages
   */
  public void doAppendConcept(VM_Bean vm, EVS_Bean eBean, int iFrom)
  {
    //update vm with the concept
    Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
    if (vmCon.size() > 0)
    {
      eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_QUALIFIER);
      vmCon.insertElementAt(eBean, vmCon.size() -1);  //TODO - check if this is right????
    }
    else
    {
      eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_PRIMARY);
      vmCon.addElement(eBean);  
    }
    vm.setVM_CONCEPT_LIST(vmCon);
    //reset it only if pv edit
    switch (iFrom)
    {
        case ConceptForm.FOR_PV_PAGE_CONCEPT:
            
            //vm.setVM_IDSEQ("");
            vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_UPD);  //VMForm.CADSR_ACTION_INS);
            vm.setVM_SHORT_MEANING(eBean.getLONG_NAME());  //have same name for now
            vm.setVM_LONG_NAME(eBean.getLONG_NAME());  //have same name for now
            break;
        case ConceptForm.FOR_VM_PAGE_CONCEPT:
            makeVMNameFromConcept(vm, ConceptForm.FOR_VM_PAGE_CONCEPT);      
            break;
    }
  }

  /**
   * method to delete the concept
   * @param vm VM_Bean object
   * @param sRow selected pv row
   * @return String error message
   */
  public String doDeleteConcept(VM_Bean vm, String sRow)
  {
    String errMsg = "";
    try
    {
      Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
      //to remove all the concepts or the last one in the list
      if (sRow.equals("-99") || vmCon.size() == 1)
      {
        vm.setVM_CONCEPT_LIST(new Vector<EVS_Bean>());
        //put alt name back to vm definition
        if (!vm.getVM_ALT_DEFINITION().trim().equals(""))
          vm.setVM_DESCRIPTION(vm.getVM_ALT_DEFINITION());
        vm.setVM_ALT_NAME("");
        vm.setVM_CONDR_IDSEQ(" ");
      }
      else  //individual concepts
      {
        int iRow = Integer.parseInt(sRow);
        if (iRow < 0 || iRow > vmCon.size())
          errMsg += "Unable to determine the selected concept from the list.";
        else
        {
          vmCon.removeElementAt(iRow);
          this.resetPrimaryFlag(vmCon);
          vm.setVM_CONCEPT_LIST(vmCon);
          //reset the concept name summary and description
          makeVMNameFromConcept(vm, ConceptForm.FOR_VM_PAGE_CONCEPT);
        }
      }
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - doDeleteConcept : ", e);
    }
    return errMsg;
  }

  /**
   * method to move the concept up and down
   * @param vm VM_Bean object
   * @param sRow selected concept row
   * @param moveAct String up or down move action 
   * @return String error message
   */
  public String doMoveConcept(VM_Bean vm, String sRow, String moveAct)
  {
    String errMsg = "";
    try
    {
      Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
      Integer IRow = new Integer(sRow);
      int iRow = IRow.intValue();
      if (iRow < 0 || iRow > vmCon.size())
        errMsg += "Unable to determine the selected concept from the list.";
      else if (iRow == 0 && moveAct.equals("moveUpConcept"))
        errMsg += "Unable to move the concept up in the list.";
      else if (iRow == vmCon.size() -1 && moveAct.equals("moveDownConcept"))
        errMsg += "Unable to move the concept down in the list.";
      else
      {
        //first store current concept and remove it
        EVS_Bean curCon = (EVS_Bean)vmCon.remove(iRow);
        //insert teh current one at the next or previous position
        if (moveAct.equals(VMForm.ACT_CON_MOVEDOWN))
          vmCon.insertElementAt(curCon, iRow + 1);
        else if (moveAct.equals(VMForm.ACT_CON_MOVEUP))
          vmCon.insertElementAt(curCon, iRow - 1);
        //mark the primary flag
        this.resetPrimaryFlag(vmCon);
        vm.setVM_CONCEPT_LIST(vmCon);
      }
      //reset the concept name summary and description
      if (errMsg.equals(""))
        makeVMNameFromConcept(vm, ConceptForm.FOR_VM_PAGE_CONCEPT);
    }
    catch (Exception e)
    {
      logger.fatal("ERROR - doMoveConcept : ", e);
    }
    return errMsg;
  }

  /**
   * get the vm from the pv bean 
   * gets the vm name and definition from the concept list depending on the where the method is called from
   * @param pv selected pv bean
   * @param toAct constant to open the page
   * @return VM_Bean object
   */
  public VM_Bean getVM(PV_Bean pv, int toAct)
  {
    VM_Bean selVM = new VM_Bean().copyVMBean(pv.getPV_VM());
    //make sure vm's long exists; 
    if (selVM.getVM_LONG_NAME() == null || selVM.getVM_LONG_NAME().equals(""))
      selVM.setVM_LONG_NAME(selVM.getVM_SHORT_MEANING());
    Vector<EVS_Bean> vmCon = selVM.getVM_CONCEPT_LIST();
    if (vmCon != null && vmCon.size() > 0)
      makeVMNameFromConcept(selVM, ConceptForm.FOR_VM_PAGE_OPEN);
    //get the vd, de and crf associate only when opening the page ; act = 0
    if (toAct == 0)
      System.out.println("get other acs");
    
    return selVM;
  }
  
  /**
   * To check validity of the data for Value Meanings component before submission.
   * Validation is done against Database restriction and ISO1179 standards.
   * calls various methods to get validity messages and store it into the vector.
   * Valid/Invalid Messages are stored in request Vector 'vValidate' along with the field, data.
   *
   * @param vm Value Meanings Bean.
   * @return ValidateBean
   *
   */
   public Vector<ValidateBean> doValidateVM(VM_Bean vm) 
   {
     Vector<ValidateBean> vValidate = new Vector<ValidateBean>();
     try
     {
         String s;
         String strInValid = "";
         s = vm.getVM_LONG_NAME();
         if (s == null) s = "";
         UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_NAME, s, true, 255, strInValid, "");

         s = vm.getVM_DESCRIPTION();
         if (s == null) s = "";
         Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
         if (vmCon.size() > 0) 
         {
           String sAlt = vm.getVM_ALT_DEFINITION();
           if (!sAlt.equals(""))
             UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_MAN_DESC, sAlt, false, 2000, strInValid, "");
           //system generated
           UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_SYS_DESC, s, true, 2000, strInValid, "");
         }
         else
           UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_DESC, s, true, 2000, strInValid, "");

         s = vm.getVM_CHANGE_NOTE();
         if (s == null) s = "";
         UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_CH_NOTE, s, false, 2000, "", "");
         
         s = vm.getVM_ALT_NAME();
         if (s == null) s = "";
         UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_CON_SUM, s, false, 2000, "", "");

         s = "";
         for (int i =0; i<vmCon.size(); i++)
         {
           EVS_Bean eBean = (EVS_Bean)vmCon.elementAt(i);
           String sN = eBean.getLONG_NAME();
           if (!sN.equals(""))
           {
             String sID = eBean.getCONCEPT_IDENTIFIER();
             if (!sID.equals(""))
               sN += " : " + sID;
             s += sN + "<br>";
           }
         }
         UtilService.setValPageVector(vValidate, VMForm.ELM_LBL_CON_NAME + " : " + VMForm.ELM_LBL_CON_ID, s, false, -1, "", "");
     }
     catch (Exception e)
     {
       logger.fatal("ERROR in setValidatePageValuesVM " + e.toString(), e);
       ValidateBean vbean = new ValidateBean();
       vbean.setACAttribute("Error setValidatePageValuesVM");
       vbean.setAttributeContent("Error message " + e.toString());
       vbean.setAttributeStatus("Error Occurred.  Please report to the help desk");
       vValidate.addElement(vbean);
     }
     return vValidate;
  }  // end of do Validate VM

   /**
    * resets the concept type of each concept
    * @param vmCon Vector of EVS_Bean object
    */
   public void resetPrimaryFlag(Vector<EVS_Bean> vmCon)
   {
     int size = vmCon.size();
     for (int i=0; i<size ; i++)
     {
       EVS_Bean eBean = vmCon.elementAt(i);
       if (i== size  -1)
         eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_PRIMARY);
       else
         eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_QUALIFIER);
       vmCon.setElementAt(eBean, i);
     }
   }

   /**
    * Sting gets the vm display name
    * @param vm VM_Bean object
    * @return concatenated vm name
    */
   public String getVMDisplayName(VM_Bean vm)
   {
     String vmNameDisplay = "";
     String sLongName = vm.getVM_LONG_NAME();
     //append the name, id and version to display
     if (!sLongName.equals(""))
     {
       String sVersion = vm.getVM_VERSION();
       String sVMID = vm.getVM_ID();
       vmNameDisplay = sLongName + "  [" + sVMID + "v" + sVersion + "]";
     }
     return vmNameDisplay;
   }
   
   /**store vm attributes from the database in pv bean 
    * @param rs ResultSet from the query
    * @param conn Connection object
    * @return VM_Bean
    */
   public VM_Bean doSetVMAttributes(ResultSet rs, Connection conn)
   {
     VM_Bean vm = new VM_Bean();
     try
     {
       vm.setVM_SHORT_MEANING(rs.getString("short_meaning"));
       String vmD = rs.getString("vm_description");
       if (vmD == null || vmD.equals(""))
           vmD = rs.getString("PREFERRED_DEFINITION");
       vm.setVM_DESCRIPTION(vmD);
       vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_NONE);
       vm.setVM_LONG_NAME(rs.getString("LONG_NAME"));
       vm.setVM_IDSEQ(rs.getString("VM_IDSEQ"));
       vm.setVM_ID(rs.getString("VM_ID"));
       vm.setVM_CONTE_IDSEQ(rs.getString("conte_idseq"));
       String sChg = rs.getString("comments");
       if (sChg == null || sChg.equals(""))
         sChg = rs.getString("change_note");
       vm.setVM_CHANGE_NOTE(sChg);
       vm.setASL_NAME(rs.getString("asl_name"));

       this.getVMVersion(rs, vm);
       String sCondr = rs.getString("condr_idseq");
       vm.setVM_CONDR_IDSEQ(sCondr);
       //get vm concepts
       if (sCondr != null && !sCondr.equals(""))
       {
         ConceptForm cdata = new ConceptForm();
         cdata.setDBConnection(conn);
         ConceptAction cact = new ConceptAction();
         Vector<EVS_Bean> conList = cact.getAC_Concepts(sCondr, cdata);
         vm.setVM_CONCEPT_LIST(conList);
       }       
     }
     catch (SQLException e)
     {
       logger.fatal("ERROR - -doSetVMAttributes for close : " + e.toString(), e);
     }
     return vm;
   }
   
   /**
    * to validate the vm changes on pv page
    * records if multiple value meanings match against name, defintion or concept exist in cadsr already
    * sends back the exact match vm (against name, def and concept) if exists
    * @param data VMForm object
    * @return VM_Bean object if exact match otherwise null
    */
   public VM_Bean validateVMData(VMForm data)
   {
       VM_Bean vmBean = data.getVMBean();
       String VMName = vmBean.getVM_SHORT_MEANING();
       //check for vm name match
       getExistingVM(VMName, "", "", data);  //check if vm exists
       Vector<VM_Bean> nameList = data.getExistVMList();      
       //if the returned one has the same idseq as as the one in hand; ignore it
      // boolean editexisting = false;
       if (nameList.size() == 1)
       {
           VM_Bean existVM = checkExactMatch(nameList.elementAt(0), vmBean);
           if (existVM != null)  
           {
               data.setVMBean(existVM);
               return existVM;   //return the exact match name- definition- concept
           }
       }
           
       //add the name matched one to the vector of nameMatchVMs; mark this one as (name) match
       if (nameList.size()>0)
           getFlaggedMessageVM(data, 'E');
       else
           data.setExistVMList(new Vector<VM_Bean>());  //make it empty because found the existing
       
       String VMDef = vmBean.getVM_DESCRIPTION();
       Vector<EVS_Bean> vCon = vmBean.getVM_CONCEPT_LIST();
       //check if default definition; added when no definition exist; ignore it if found
       if (!checkDefaultDefinition(VMDef, vCon))
       {
           //check for vm defn match
           this.getExistingVM("", "", VMDef, data);
           Vector<VM_Bean> defList = data.getDefnVMList();
           //add the list of definitionMatchVMs to existing list if not existed already
           if (defList.size()>0)
               getFlaggedMessageVM(data, 'D');
       }
       //check if selected vm has concepts
       if (vCon != null && vCon.size() > 0)
       {
         //get the condr idseq from the database
         String sCondr = this.getConceptCondr(vCon, data);
         if (!sCondr.equals(""))
         {
           getExistingVM("", sCondr, "", data);
           Vector<VM_Bean> conList = data.getConceptVMList();
           //add the list of conceptMatchVMs to existing list if not existed already
           if (conList.size() > 0)
               getFlaggedMessageVM(data, 'C');
         }
       }
       return null; //no exact match found
   }
   
   /**
    * gets the exact match vm
    * @param existVM existing vm
    * @param newVM new vm
    * @return VM_Bean object if matched, null otherwise
    */
   public VM_Bean checkExactMatch(VM_Bean existVM, VM_Bean newVM)
   {
       boolean match = true;

       String VMDef = newVM.getVM_DESCRIPTION();
       String nameDef = existVM.getVM_DESCRIPTION();
       //match the name
       if (!newVM.getVM_LONG_NAME().equals(existVM.getVM_LONG_NAME()))
          match = false;
       //check for exact match by defintion
       else if (VMDef.equals(nameDef))
       {
           //check for exact match for the concepts
           Vector<EVS_Bean> vCon = newVM.getVM_CONCEPT_LIST();
           Vector<EVS_Bean> nameCon = existVM.getVM_CONCEPT_LIST();
           if (nameCon.size() == vCon.size())
           {              
               for (int i =0; i<nameCon.size(); i++)
               {
                   EVS_Bean nBean = nameCon.elementAt(i);
                   EVS_Bean cBean = vCon.elementAt(i);
                   //if concepts don't match break the loop
                   if (!nBean.getCONCEPT_IDENTIFIER().equals(cBean.getCONCEPT_IDENTIFIER()))
                   {
                       match = false;  //concept data don't match
                       break;
                   }
               }
           }
           else  //concept size don't match
               match = false;
       }
       else  //defintion don't match
           match = false;
       //return the exact match vm
       if (match)
           return existVM;
       //if reached here send back null
       return null;
   }

   
// private methods 
   
  /**
   * To insert a new Value Meaing in the database when selected a term from EVS. Called from
   * CurationServlet. Gets all the attribute values from the bean, sets in parameters, and
   * registers output parameter. Calls oracle stored procedure "{call
   * SBREXT_Set_Row.SET_VM_CONDR(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   * 
   * @param data VM Data object.
   * @param conArray 
   * @return String return code
   */
  private String setVM(VMForm data, String conArray)
  {
    // capture the duration
    // java.util.Date startDate = new java.util.Date();
    // logger.info(m_servlet.getLogMessage(m_classReq, "setVM_EVS", "starting set", startDate,startDate));
    ResultSet rs = null;
    CallableStatement cstmt = null;
    Connection conn = null;    
    String stMsg = ""; // out
    try    
    {
      VM_Bean vm = data.getVMBean();
      String sAction = vm.getVM_SUBMIT_ACTION();
      if (sAction == null) sAction = VMForm.CADSR_ACTION_INS;
      //get the connection from data if exists (used for testing)
      conn = data.getDBConnection();
      if (conn == null || conn.isClosed())
        conn = data.getCurationServlet().connectDB(); //VMServlet.makeDBConnection();
      if (conn != null)
      {
        cstmt = conn.prepareCall("{call SBREXT.SBREXT_SET_ROW.SET_VM(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        // register the Out parameters
        cstmt.registerOutParameter(1, java.sql.Types.VARCHAR); // return code
        cstmt.registerOutParameter(2, java.sql.Types.VARCHAR); // action
        cstmt.registerOutParameter(4, java.sql.Types.VARCHAR); // vm_idseq
        cstmt.registerOutParameter(5, java.sql.Types.VARCHAR); // preferred name
        cstmt.registerOutParameter(6, java.sql.Types.VARCHAR); // long name
        cstmt.registerOutParameter(7, java.sql.Types.VARCHAR); // preferred definition
        cstmt.registerOutParameter(8, java.sql.Types.VARCHAR); // context idseq
        cstmt.registerOutParameter(9, java.sql.Types.VARCHAR); // asl name
        cstmt.registerOutParameter(10, java.sql.Types.VARCHAR); // version
        cstmt.registerOutParameter(11, java.sql.Types.VARCHAR); // vm_id
        cstmt.registerOutParameter(12, java.sql.Types.VARCHAR); // latest version ind
        cstmt.registerOutParameter(13, java.sql.Types.VARCHAR); // condr idseq
        cstmt.registerOutParameter(14, java.sql.Types.VARCHAR); // definition source
        cstmt.registerOutParameter(15, java.sql.Types.VARCHAR); // origin
        cstmt.registerOutParameter(16, java.sql.Types.VARCHAR); // change note
        cstmt.registerOutParameter(17, java.sql.Types.VARCHAR); // begin date
        cstmt.registerOutParameter(18, java.sql.Types.VARCHAR); // end date
        cstmt.registerOutParameter(19, java.sql.Types.VARCHAR); // created by
        cstmt.registerOutParameter(20, java.sql.Types.VARCHAR); // date created
        cstmt.registerOutParameter(21, java.sql.Types.VARCHAR); // modified by
        cstmt.registerOutParameter(22, java.sql.Types.VARCHAR); // date modified

        // Set the In parameters (which are inherited from the PreparedStatement class)
        cstmt.setString(2, sAction);
        cstmt.setString(3, conArray);
        // set value meaning if action is to update
        if (sAction.equals(VMForm.CADSR_ACTION_UPD) || conArray == null)
          cstmt.setString(6, vm.getVM_SHORT_MEANING());
        //definition and change note
        cstmt.setString(7, vm.getVM_DESCRIPTION());
        cstmt.setString(16, vm.getVM_CHANGE_NOTE());
        //remove the concepts
        if (vm.getVM_CONDR_IDSEQ().equals(" "))
            cstmt.setString(13, null);
        // Now we are ready to call the stored procedure
        cstmt.execute();
        String sRet = cstmt.getString(1);
        if (sRet != null && !sRet.equals("") && !sRet.equals("API_VM_300"))
        {
          stMsg = "\\t" + sRet + " : Unable to update the Value Meaning - "
              + vm.getVM_SHORT_MEANING() + ".";
          // creation
          data.setRetErrorCode(sRet);
          data.setPvvmErrorCode(sRet);
        }
        else
        {
          // store the vm attributes created by stored procedure in the bean
          vm.setVM_SHORT_MEANING(cstmt.getString(6));
          vm.setVM_LONG_NAME(cstmt.getString(6));
          vm.setVM_DESCRIPTION(cstmt.getString(7));
          vm.setVM_CHANGE_NOTE(cstmt.getString(16));
          vm.setVM_BEGIN_DATE(cstmt.getString(17));
          vm.setVM_END_DATE(cstmt.getString(18));
          vm.setVM_CONDR_IDSEQ(cstmt.getString(13));
          vm.setVM_IDSEQ(cstmt.getString(4));
          vm.setVM_CONTE_IDSEQ(cstmt.getString(8));
          vm.setASL_NAME(cstmt.getString(9));
          vm.setVM_VERSION(cstmt.getString(10));
          vm.setVM_ID(cstmt.getString(11));
        //  System.out.println(cstmt.getString(11) + " condr " + cstmt.getString(13) + " change " + cstmt.getString(16));
        }
      }
      // capture the duration
      // logger.info(m_servlet.getLogMessage(m_classReq, "setVM_EVS", "end set", startDate, new
      // java.util.Date()));
    }
    catch (Exception e)
    {
      logger.fatal("ERROR in setVM for other : " + e.toString(), e);
      data.setRetErrorCode("Exception");
      stMsg += "\\tException : Unable to update VM attributes.";
    }
    try
    {
      if (rs != null) rs.close();
      if (cstmt != null) cstmt.close();
      if (data.getDBConnection() == null)
        data.getCurationServlet().freeConnection(conn);  //VMServlet.closeDBConnection(conn);
    }
    catch (Exception ee)
    {
      logger.fatal("ERROR in setVM for close : " + ee.toString(), ee);
      data.setRetErrorCode("Exception");
      stMsg += "\\tException : Unable to close the connection at set_VM.";
    }
    return stMsg;
  }

  /**
   * To insert a new CD VMS relationship in the database after creating VM or its relationship with VD.
   * Called from CurationServlet.
   * Gets all the attribute values from the bean, sets in parameters, and registers output parameter.
   * Calls oracle stored procedure
   *   "{call SBREXT_Set_Row.SET_CDVMS(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   * @param data VMForm object
   * @param vm VM Bean.
   *
   * @return String return code from the stored procedure call. null if no error occurred.
   */
  private String setCDVMS(VMForm data, VM_Bean vm)
  {
     //capture the duration
     //java.util.Date startDate = new java.util.Date();          
     //logger.info(m_servlet.getLogMessage(m_classReq, "setCDVMS", "starting set", startDate, startDate));
  
     Connection conn = null;
     ResultSet rs = null;
     CallableStatement cstmt = null;
     String sReturnCode = "";  //out
     try
     {
         //get the connection from data if exists (used for testing)
         conn = data.getDBConnection();
         if (conn == null || conn.isClosed())
           conn = data.getCurationServlet().connectDB(); //VMServlet.makeDBConnection();
         if (conn != null)
         {
           cstmt = conn.prepareCall("{call SBREXT_Set_Row.SET_CD_VMS(?,?,?,?,?,?,?,?,?,?)}");
           // register the Out parameters
           cstmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
           cstmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //out cv_idseq
           cstmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //out cd_idseq
           cstmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //out value meaning
           cstmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //out description
           cstmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //date created
           cstmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //created by
           cstmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //modified by
           cstmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //date modified
           // Set the In parameters (which are inherited from the PreparedStatement class)
           cstmt.setString(2, VMForm.CADSR_ACTION_INS);
           cstmt.setString(4, vm.getVM_CD_IDSEQ());
           cstmt.setString(5, vm.getVM_SHORT_MEANING());
           cstmt.setString(6, vm.getVM_DESCRIPTION());
            // Now we are ready to call the stored procedure
           cstmt.execute();
           sReturnCode = cstmt.getString(1);
           //String sCV_ID = CStmt.getString(3);
           if (sReturnCode != null && !sReturnCode.equals("") && !sReturnCode.equals("API_CDVMS_203"))
           {
             data.setStatusMsg(data.getStatusMsg() + "\\t " + sReturnCode + " : Unable to update Conceptual Domain and Value Meaning relationship - "
                 + vm.getVM_CD_NAME() + " and " + vm.getVM_SHORT_MEANING() + ".");
             logger.fatal(data.getStatusMsg());
             //data.setRetErrorCode(sReturnCode);
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
       if(cstmt!=null) cstmt.close();
       if (data.getDBConnection() == null)
         data.getCurationServlet().freeConnection(conn);  //VMServlet.closeDBConnection(conn);
     }
     catch(Exception ee)
     {
       logger.fatal("ERROR in setCDVMS for close : " + ee.toString(), ee);
     }
     return sReturnCode;
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
        returnValue = curBean.getVM_CHANGE_NOTE();
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
  
  /** adds all existing vms to vector to display it on the page
   * @param data VMForm object
   * @param vmFlag char to display all or vm by name filter, vm by concept filter, vm by defin filter.
   */
  private void getFlaggedMessageVM(VMForm data, char vmFlag)
  {
    Vector<VM_Bean> vErrMsg = data.getErrorMsgList();
    data.setStatusMsg("Value Meaning");
    //String sMsg = "";
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
            //mark the message
            vm.setVM_COMMENT_FLAG("Name matches.");
            vErrMsg.addElement(vm);
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
            //mark the message
            if (!existsInList(vm, vErrMsg))
            {
                vm.setVM_COMMENT_FLAG("Concept matches.");
                vErrMsg.addElement(vm);
            }
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
            //mark the message
            if (!existsInList(vm, vErrMsg))
            {
                vm.setVM_COMMENT_FLAG("Definition matches.");
                vErrMsg.addElement(vm);
            }
          }
        }
        break;
      default:
    }
    data.setErrorMsgList(vErrMsg);
  }

  /**
   * checks if aleady exists in the list
   * @param vm VM_Bean obejct to check against
   * @param existList Vector<VM_Bean> existing list 
   * @return boolean value
   */
  private boolean existsInList(VM_Bean vm, Vector<VM_Bean> existList)
  {
      boolean exists = false;
      for (int i=0; i<existList.size(); i++)
      {
          VM_Bean eBean = existList.elementAt(i);
          if (eBean.getVM_IDSEQ().equals(vm.getVM_IDSEQ()))
          {
              exists = true;
              break;
          }
      }
      return exists;
  }
  
  /**gets the existing condr idseq from the database
   * @param conList EVS Bean vector of concepts of the vm
   * @param data VMForm object
   * @return String condridseq
   */
  private String getConceptCondr(Vector<EVS_Bean> conList, VMForm data)
  {
    String condr = "";
    Connection conn = null;
    try
    {
      ConceptForm conData = new ConceptForm();
      conData.setConceptList(conList);
      
      conn = data.getDBConnection();
      if (conn == null || conn.isClosed())
        conn = data.getCurationServlet().connectDB(); //VMServlet.makeDBConnection();
      conData.setDBConnection(conn);
      //call the method n concept action
      ConceptAction conAct = new ConceptAction();
      condr = conAct.getConDerivation(conData);
    }
    catch (SQLException e)
    {
      logger.fatal("VM concept search connection problem ", e);
      //e.printStackTrace();
    }
    finally
    {
        //close the conn only if not testing
        if (data.getDBConnection() == null)
          data.getCurationServlet().freeConnection(conn);  //VMServlet.closeDBConnection(conn);        
    }
    return condr;
  }

  /**to get the vms filtered by vmname, condridseq, or definition
   * @param vmName String vm name to filter
   * @param sCondr String condr idseq to filter
   * @param sDef String defintion to filter
   * @param data VMForm object to filter
   */
  private void getExistingVM(String vmName, String sCondr, String sDef, VMForm data)
  {
    //set data filters
    data.setSearchTerm(vmName);           //search by name
    data.setSearchFilterCondr(sCondr);    //search by condr
    data.setSearchFilterDef(sDef);        //search by defintion
    //call method
    data.setVMList(new Vector<VM_Bean>());
  //System.out.println(vmName+sCondr+sDef+ " : VMs before - " + data.getVMList().size());
    searchVMValues(data);
    //set teh flag
    Vector<VM_Bean> vmList = data.getVMList();
    if (vmList != null && vmList.size() >0)
    {      
      //System.out.println(vmName+sCondr+sDef+ " : VMs after - " + data.getVMList().size());
      if (!vmName.equals(""))
        data.setExistVMList(vmList);
      else if (!sCondr.equals(""))
        data.setConceptVMList(vmList);
      else if (!sDef.equals(""))
        data.setDefnVMList(vmList);
    }
  }

  /**
   * puts the .0 to the version number if to make it decimal
   * @param rs ResultSet object
   * @param vm VM_Bean object
   */
  private void getVMVersion(ResultSet rs, VM_Bean vm)
  {
    try
    {
      String rsV = rs.getString("version");
      if (rsV == null)
          rsV = "";
      if (!rsV.equals("") && rsV.indexOf('.') < 0)
          rsV += ".0";
       vm.setVM_VERSION(rsV);
    }
    catch (SQLException e)
    {
      logger.fatal("ERROR - getVMVersion ", e);
    }
  }
  
  /**
   * no need to match the default definition in cadsr. 
   * this method to get check editing vm has the default definition
   * @param sDef String current defintion
   * @param vmCon Vector<EVS_Bean> list of concepts 
   * @return boolean true if it default value
   */
  private boolean checkDefaultDefinition(String sDef, Vector<EVS_Bean> vmCon)
  {
      String dDef = VMForm.DEFINITION_DEFAULT_VALUE;
      boolean bDefault = false;
      //check for empty or single one
      if (sDef.equals("") || sDef.equalsIgnoreCase(dDef) || sDef.equalsIgnoreCase(dDef + "."))
          bDefault = true;
      //make the default defintion from the concepts to match the selected definition
      if (vmCon.size() > 1)
      {
          bDefault = true;  //assume default defintion when concept exists
          for(int i=0; i<vmCon.size(); i++)
          {
              EVS_Bean eBean = vmCon.elementAt(i);
              String conDef = eBean.getPREFERRED_DEFINITION();
              if (!conDef.equalsIgnoreCase(dDef) && !conDef.equalsIgnoreCase(dDef + "."))
              {
                  bDefault = false;
                  break;
              }
          }
      }
      return bDefault;
  }
  
  /**
   * to get the sql query string
   * @param sInput String vm value
   * @return sql string
   */
  private String makeSelectQuery(String sInput)
  {
      String sSQL = "SELECT vm.VM_IDSEQ, vm.LONG_NAME, vm.PREFERRED_DEFINITION, vm.description vm_description" +
             ", vm.begin_date, vm.end_date, vm.condr_idseq, vm.short_meaning, vm.VERSION,vm.vm_id, vm.conte_idseq" +
             ", vm.asl_name, vm.change_note, vm.comments, vm.latest_version_ind" +
             " FROM sbr.value_meanings_view  vm" +
             " WHERE vm.short_meaning IN ('" + sInput + "')" + 
             " ORDER BY short_meaning";
      return sSQL;
  }
  
  /**
   * to search multiple vm names at time
   * @param conn connection object  
   * @param searchString String search string
   * @return vector of existing vm bean object
   */
  public Vector<VM_Bean> searchMultipleVM(Connection conn, String searchString)
  {
      ResultSet rs = null;
      PreparedStatement pstmt = null;
      Vector<VM_Bean> vVMs = new Vector<VM_Bean>();      
      try
      {
          // make sql
          String sSQL = makeSelectQuery(searchString);
          // prepare statement
          pstmt = conn.prepareStatement(sSQL);
          // Now we are ready to call the function
          rs = pstmt.executeQuery();
          // get attributes from the recorset
          while (rs.next())
          {
              VM_Bean vm = doSetVMAttributes(rs, conn);
              // add the element              
              vVMs.addElement(vm);
          }
      }
      catch (Exception e)
      {
          logger.fatal("ERROR - : " + e.toString(), e);
      }
      finally
      {
          try
          {
              if (rs != null)
                  rs.close();
              if (pstmt != null)
                  pstmt.close();
          }
          catch (Exception ee)
          {
              logger.fatal("ERROR for close : " + ee.toString(), ee);
          }
      }
      return vVMs;
  }
  
}//end of the class
