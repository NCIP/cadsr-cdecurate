/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import oracle.jdbc.driver.OracleTypes;
import org.apache.log4j.Logger;

/**
 * @author shegde
 *
 */
public class PVAction implements Serializable
{
  private static final Logger logger = Logger.getLogger(PVServlet.class.getName());
  /**
   * 
   */
  public PVAction()
  {      
  }

  public void doResetViewTypes(Vector<PV_Bean> vVDPV, String[] vwTypes)
  {
    for (int i=0; i<vwTypes.length; i++)
    {
      String sType = vwTypes[i];
      if (sType != null && vVDPV.size() > i)
      {
        PV_Bean pv = (PV_Bean)vVDPV.elementAt(i);
 //System.out.println(sType + " reset type " + pv.getPV_VIEW_TYPE());
        if (!sType.equals("collapse") && !sType.equals("expand"))
          sType = "expand";
        pv.setPV_VIEW_TYPE(sType);
        vVDPV.setElementAt(pv, i);
      }
    }
  }
  
  public void doChangePVAttributes(String chgName, int pvInd, boolean isNew, PVForm data)
  {
    //update the existing list
    VD_Bean vd = data.getVD();
    Vector<PV_Bean> vdpvs = vd.getVD_PV_List();
    PV_Bean selPV = data.getSelectPV();
    String pvID = selPV.getPV_PV_IDSEQ();
    if (!isNew || pvID == null || pvID.equals("") || pvID.contains("EVS"))
    {
      selPV.setPV_VALUE(chgName);
      if (data.getNewVM() != null)
        selPV.setPV_VM(data.getNewVM());
      if (!isNew)
        selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_UPD);
      else
        selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_INS);
      selPV.setPV_VIEW_TYPE("expand");
      vdpvs.setElementAt(selPV, pvInd);  //data.getVDPVList().setElementAt(selPV, pvInd);
    }
    else
    {
      PV_Bean newPV = new PV_Bean();
      if (selPV != null)  //copy other attributes
        newPV.copyBean(selPV);
      newPV.setPV_VALUE(chgName);  //add the new name
      if (data.getNewVM() != null)
      {
        newPV.setPV_VM(data.getNewVM());  //copy the changed vm
      }
      //check if associated with the form
      boolean isExists = this.checkPVQCExists(vd, selPV, data);
      if (isExists)
      {
        data.setStatusMsg(data.getStatusMsg() + "\\tUnable to change the Permissible Value " +
            selPV.getPV_VALUE() + " because it is used in a CRF.\\n");
        selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_NONE);
      }
      else
      {
        selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_DEL);
        vdpvs.removeElementAt(pvInd);  //data.getVDPVList().removeElementAt(pvInd);
        vd.getRemoved_VDPVList().addElement(selPV);
      //  data.getRemovedPVList().addElement(selPV);
      }
      //insert the new one
      newPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_INS);
      newPV.setPV_VIEW_TYPE("expand");
      vdpvs.insertElementAt(newPV, pvInd);  //data.getVDPVList().insertElementAt(newPV, pvInd);
    }    
    vd.setVD_PV_List(vdpvs);
    data.setVD(vd);
  }
  

  /** 
   * Check if the permissible values associated with the form for the selected VD
   * 
   * @param vdIDseq string unique id for value domain.
   * @param vpIDseq string unique id for vd pvs table.
   * 
   * @return boolean true if pv is associated with the form false otherwise
   * 
   * @throws Exception
   */
  private boolean checkPVQCExists(VD_Bean vd, PV_Bean pv, PVForm data) //throws Exception
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    //CallableStatement CStmt = null;
    PreparedStatement pstmt = null;
    boolean isValid = false;
    try
    {
      String vpIDseq = pv.getPV_VDPVS_IDSEQ();
      String vdIDseq = vd.getVD_VD_IDSEQ();
      if (vpIDseq != null && !vpIDseq.equals("") && vdIDseq != null && !vdIDseq.equals(""))
      {
        //Create a Callable Statement object.
        sbr_db_conn = data.getDbConnection();
        if (sbr_db_conn == null || sbr_db_conn.isClosed())
          sbr_db_conn = PVServlet.makeDBConnection();
        // Create a Callable Statement object.
        if (sbr_db_conn != null)
        {
          pstmt = sbr_db_conn.prepareStatement("select SBREXT_COMMON_ROUTINES.VD_PVS_QC_EXISTS(?,?) from DUAL");
          // register the Out parameters
          pstmt.setString(1, vpIDseq);
          pstmt.setString(2, vdIDseq);
           // Now we are ready to call the function
          rs = pstmt.executeQuery();
          while (rs.next())
          {
            if (rs.getString(1).equalsIgnoreCase("TRUE"))
              isValid = true;
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - checkPVQCExists for other : ", e);
      data.setStatusMsg(data.getStatusMsg() + "\\tError : Unable to get existing pv-qc." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    try
    {
      if(rs!=null) rs.close();
      if(pstmt!=null) pstmt.close();
      if (data.getDbConnection() == null)
        PVServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR - checkPVQCExists for close : " + ee.toString(), ee);
    }
    return isValid;
   }   //end checkPVQCExists

  /**
   * checks if removed pvs are associated with the form 
   * send back the validation message for pv vds data.
   * 
   * @param req servlet request
   * @param res servlet response
   * @param m_VD VD_Bean of the selected vd.
   * @param vValidate vector of validation data
   * @param sOriginAction string page action
   * @return vector of validate
   * 
   * @throws Exception
   */
  public Vector<String> addValidateVDPVS(PVForm data) //throws Exception
  {
     VD_Bean vd = data.getVD();
     Vector<ValidateBean> vValidate = vd.getValidateList();     
     try
     {
        String sOrgAct = data.getOriginAction();
        this.addValidateParentCon(vd, vValidate, sOrgAct);
         //do this only if enumerated value domain 
        String s = vd.getVD_TYPE_FLAG();
        if (s == null) s = "";
        if (s.equals("E"))
        {
          //get current value domains vd-pv attributes
          Vector<PV_Bean> vVDPVS = vd.getVD_PV_List();  // data.getVDPVList(); // (Vector)session.getAttribute("VDPVList");  
          String vdID = vd.getVD_VD_IDSEQ();
          //remove vdidseq if new vd
          if (vdID == null || sOrgAct.equalsIgnoreCase("newVD")) vdID = "";
          //make long string of values/meanings
          String sPVVal = "";
          String sPVMean = "";        
          if (vVDPVS != null && !vVDPVS.isEmpty())
          {
            for (int i=0; i<vVDPVS.size(); i++)
            {
              PV_Bean thisPV = (PV_Bean)vVDPVS.elementAt(i);
              VM_Bean thisVM = thisPV.getPV_VM();
              //check its relationship with the form if removed 
            //  String vpID = thisPV.getPV_VDPVS_IDSEQ();
             // if (vpID == null) vpID = "";
              if (sPVVal != null && !sPVVal.equals(""))
              {
                sPVVal += ",\n ";
                sPVMean += ",\n ";
              }
              sPVVal += thisPV.getPV_VALUE();
              if (thisVM != null && thisVM.getVM_SHORT_MEANING() != null && !thisVM.getVM_SHORT_MEANING().equals(""))
                sPVMean += thisVM.getVM_SHORT_MEANING();  // thisPV.getPV_SHORT_MEANING();              
            }
          }
          //get the values element from the vector to update it
          boolean matchFound = false;
          for (int i = 0; i < vValidate.size(); i++)
          {
            ValidateBean val = (ValidateBean)vValidate.elementAt(i);
            if (val == null) val = new ValidateBean();
            if (val.getACAttribute().equals("Values"))
            {
              val.setAttributeContent(sPVVal);
              val.setAttributeStatus("Valid");
              if (sPVVal == null || sPVVal.equals("")) 
                val.setAttributeStatus("Value is required for Enumerated Value Domain");
              matchFound = true;
              vValidate.setElementAt(val, i);
            }
            else if (val.getACAttribute().equals("Value Meanings"))
            {
              val.setAttributeContent(sPVMean);
              val.setAttributeStatus("Valid");
              if (sPVMean == null || sPVMean.equals("")) 
                val.setAttributeStatus("Value Meaning is required for Enumerated Value Domain");
              matchFound = true;
              vValidate.setElementAt(val, i);
            }
          }
          //add the values and meanings row if doesn't exist already
          if (!matchFound)
          {
            UtilService.setValPageVector(vValidate, "Values", sPVVal, true, -1, "", sOrgAct);
            UtilService.setValPageVector(vValidate, "Value Meanings", sPVMean, true, -1, "", sOrgAct);
          }
        }
     }
     catch (Exception e)
     {
       logger.fatal("Error Occurred in addValidateVDPVS " + e.toString(), e);
       ValidateBean vbean = new ValidateBean();
       vbean.setACAttribute("Error addValidateVDPVS");
       vbean.setAttributeContent("Error message " + e.toString());
       vbean.setAttributeStatus("Error Occurred.  Please report to the help desk");
       vValidate.addElement(vbean);
     }
     // finaly, send vector to JSP
     vd.setValidateList(vValidate);
     data.setVD(vd);
     Vector<String> vValString = SetACService.makeStringVector(vValidate);
     return vValString;
   }    //end addvalidateVDPVS

  public void addValidateParentCon(VD_Bean vd, Vector<ValidateBean> vValidate, String sOrgAct)
  {
    String s = "";
    String strInValid = "";
    Vector vParList = vd.getReferenceConceptList();  //  (Vector)session.getAttribute("VDParentConcept");
  //  if(vParList != null)
  //        strInValid = checkConceptCodeExistsInOtherDB(vParList, insAC, null);
    if (vParList != null && vParList.size()>0)
    {
//System.out.println("val VD vParList.size(): " + vParList.size());
      for (int i =0; i<vParList.size(); i++)
      {
        EVS_Bean parBean = (EVS_Bean)vParList.elementAt(i);
        if (!parBean.getCON_AC_SUBMIT_ACTION().equals("DEL"))
        {
          String parString = "";
          if (parBean.getLONG_NAME() != null) parString = parBean.getLONG_NAME() + "   ";
          if (parBean.getEVS_DATABASE() != null)
          {
            //do not add this if non evs
            if (parBean.getCONCEPT_IDENTIFIER() != null && !parBean.getEVS_DATABASE().equals("Non_EVS")) 
                parString += parBean.getCONCEPT_IDENTIFIER() + "   ";
            parString += parBean.getEVS_DATABASE();
          }
          if (!parString.equals(""))
          {
            if (s.equals("")) s = parString;
            else s = s + ", " + parString;
          }
        }
      }
    }
    //get the values element from the vector to update it
    boolean matchFound = false;
    for (int i = 0; i < vValidate.size(); i++)
    {
      ValidateBean val = (ValidateBean)vValidate.elementAt(i);
      if (val == null) val = new ValidateBean();
      if (val.getACAttribute().equals("Parent Concept"))
      {
        val.setAttributeContent(s);
        val.setAttributeStatus("Valid");
        matchFound = true;
        vValidate.setElementAt(val, i);
        break;
      }
    }
    if (!matchFound)
    {
      UtilService.setValPageVector(vValidate, "Parent Concept", s, false, -1, strInValid, sOrgAct);    
    }

    vd.setValidateList(vValidate);
  }
  
  /**
   * To get the Permissible Values for the selected AC  from the database.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_PV(AC_IDSEQ, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to PV bean
   *
   * @param acIdseq String id of the selected ac.
   * @param acName String AC name.
   * @param sAction String search action.
   *
   * @return Integer of PV count
   */
  public Vector<PV_Bean> doPVACSearch(String acIdseq, String sAction, PVForm data)  // 
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector<PV_Bean> vList = new Vector<PV_Bean>();
  //  Integer pvCount = new Integer(0);
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = data.getDbConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = PVServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_PV(?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(2, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1, acIdseq);
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(2);
        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            PV_Bean pvBean = new PV_Bean();
            pvBean.setPV_PV_IDSEQ(rs.getString("pv_idseq"));
            pvBean.setPV_VALUE(rs.getString("value"));
            pvBean.setPV_SHORT_MEANING(rs.getString("short_meaning"));
            if (sAction.equals("NewUsing"))
              pvBean.setPV_VDPVS_IDSEQ("");
            else
              pvBean.setPV_VDPVS_IDSEQ(rs.getString("vp_idseq"));
            
            pvBean.setPV_MEANING_DESCRIPTION(rs.getString("vm_description"));             
            pvBean.setPV_VALUE_ORIGIN(rs.getString("origin"));
            String sDate = rs.getString("begin_date");
            if (sDate != null && !sDate.equals(""))
              sDate = data.getUtil().getCurationDate(sDate);
            pvBean.setPV_BEGIN_DATE(sDate);
            sDate = rs.getString("end_date");
            if (sDate != null && !sDate.equals(""))
              sDate = data.getUtil().getCurationDate(sDate);
            pvBean.setPV_END_DATE(sDate);
            if (sAction.equals("NewUsing"))
              pvBean.setVP_SUBMIT_ACTION("INS"); 
            else
              pvBean.setVP_SUBMIT_ACTION("NONE"); 
            //get valid value attributes
            pvBean.setQUESTION_VALUE("");
            pvBean.setQUESTION_VALUE_IDSEQ("");
            //get vm concept attributes
            String sCondr = rs.getString("vm_condr_idseq");
            this.doSetVMAttributes(pvBean, sCondr, data);
            //get parent concept attributes
            String sCon = rs.getString("con_idseq");
            this.doSetParentAttributes(sCon, pvBean, data);
            
            pvBean.setPV_VIEW_TYPE("expand");              
            //add pv idseq in the pv id vector
            vList.addElement(pvBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-doPVACSearch : " + e);
      logger.fatal("ERROR - doPVACSearch for other : " + e.toString(), e);
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if (data.getDbConnection() == null)
        PVServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doPVACSearch : " + ee);
      logger.fatal("ERROR - -doPVACSearch for close : " + ee.toString(), ee);
    }
    return vList;
  }  //doPVACSearch search
  
  public void doResetVersionVDPV(VD_Bean vd, Vector<PV_Bean> verList)
  {
    Vector<PV_Bean> rmVDPV = vd.getRemoved_VDPVList();
    Vector<PV_Bean> pgVDPV = vd.getVD_PV_List();
    for (int i =0; i<verList.size(); i++)
    {
      PV_Bean pv = verList.elementAt(i);
      String pvID = pv.getPV_PV_IDSEQ();
      //check if it is removed from the page
      for (int j =0; j<rmVDPV.size(); j++)
      {
        PV_Bean rmPV = rmVDPV.elementAt(j);
        String rmID = rmPV.getPV_PV_IDSEQ();
        if (rmID != null && !rmID.equals("") && rmID.equals(pvID))
        {
          rmPV.setPV_VDPVS_IDSEQ(pv.getPV_VDPVS_IDSEQ());
          rmPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_DEL);
          rmVDPV.setElementAt(rmPV, j);
          verList.removeElementAt(i);  //remove it from the vers list
          i -= 1;  //move back teh index
          break;
        }
      }      
    }
    vd.setRemoved_VDPVList(rmVDPV);
    //add the newly added ones to the list
    for (int i=0; i<pgVDPV.size(); i++)
    {
      PV_Bean pv = pgVDPV.elementAt(i);
      String value = pv.getPV_VALUE();
      String vm = pv.getPV_VM().getVM_SHORT_MEANING();
      //check if it exists in versioned list
      boolean isNew = true;
      for (int j =0; j<verList.size(); j++)
      {
        PV_Bean verPV = verList.elementAt(j);
        String verVal = verPV.getPV_VALUE();
        String verVM = verPV.getPV_VM().getVM_SHORT_MEANING();
        if (verVal.equals(value) && verVM.equals(vm))
        {
          isNew = false;
          break;
        }
      }
      if (isNew)
      {
        pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_INS);
        verList.addElement(pv);
      }
    }
    vd.setVD_PV_List(verList);    
  }
  
  private void doSetVMAttributes(PV_Bean pvBean, String sCondr, PVForm data)
  {
    VM_Bean vm = new VM_Bean();
    vm.setVM_SHORT_MEANING(pvBean.getPV_SHORT_MEANING());
    vm.setVM_DESCRIPTION(pvBean.getPV_MEANING_DESCRIPTION());
    vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_NONE);
    vm.setVM_CONDR_IDSEQ(sCondr);
    //get vm concepts
    if (sCondr != null && !sCondr.equals(""))
    {
      ConceptForm cdata = new ConceptForm();
      if (data.getDbConnection() != null)
        cdata.setDBConnection(data.getDbConnection()); //get the connection
      else
        cdata.setDBConnection(PVServlet.makeDBConnection());  //make the connection
      ConceptAction cact = new ConceptAction();
      Vector<EVS_Bean> conList = cact.getAC_Concepts(sCondr, cdata);
      if (data.getDbConnection() == null)
        PVServlet.closeDBConnection(cdata.getDBConnection());  //close the connection only if it was created here
      vm.setVM_CONCEPT_LIST(conList);
    }
    pvBean.setPV_VM(vm);
  }
  
  private void doSetParentAttributes(String conIDseq, PV_Bean pvBean, PVForm data)
  {
    EVS_Bean parConcept = new EVS_Bean();
    parConcept.setIDSEQ(conIDseq);
    if (conIDseq != null && !conIDseq.equals(""))
    {
      InsACService insAC = new InsACService(data.getRequest(), data.getResponse(), data.getCurationServlet());
      String sRet = "";
      conIDseq = insAC.getConcept(sRet, parConcept, false);
    }
    pvBean.setPARENT_CONCEPT(parConcept);
  }
  
  /**
   * To get resultSet from database for Permissible Value Component called from getACKeywordResult and getCDEIDSearch methods.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_PVVM(InString, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   * @param InString Keyword value, is empty if searchIn is minID.
   * @param vList returns Vector of PVbean.
   *
  */
  public Vector<PV_Bean> doPVVMSearch(String InString, String cd_idseq, String conName, 
      String conID, PVForm data)  // returns list of Data Elements
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector<PV_Bean> vList = new Vector<PV_Bean>();
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = data.getDbConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = PVServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT.SBREXT_CDE_CURATOR_PKG.SEARCH_PVVM(?,?,?,?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1,InString);
        CStmt.setString(2,cd_idseq);
        CStmt.setString(4,conName);
        CStmt.setString(5,conID);
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(3);

        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            PV_Bean PVBean = new PV_Bean();
            PVBean.setPV_PV_IDSEQ(rs.getString("pv_idseq"));
            PVBean.setPV_VALUE(rs.getString("value"));
            PVBean.setPV_SHORT_MEANING(rs.getString("short_meaning"));
            s = rs.getString("begin_date");
            if (s != null)
              s = data.getUtil().getCurationDate(s);      //convert to dd/mm/yyyy format
            PVBean.setPV_BEGIN_DATE(s);
            s = rs.getString("end_date");
            if (s != null)
              s = data.getUtil().getCurationDate(s);
            PVBean.setPV_END_DATE(s);
            PVBean.setPV_MEANING_DESCRIPTION(rs.getString("vm_description"));  //from meanings table
            PVBean.setPV_CONCEPTUAL_DOMAIN(rs.getString("cd_name"));
            
            //get vm concept attributes
            String sCondr = rs.getString("condr_idseq");
            this.doSetVMAttributes(PVBean, sCondr, data);
            //get database attribute
            PVBean.setPV_EVS_DATABASE("caDSR");
            vList.addElement(PVBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-searchPVVM: " + e);
      logger.fatal("ERROR - GetACSearch-searchPVVM for other : " + e.toString(), e);
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if (data.getDbConnection() == null)
        PVServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
  //    //System.err.println("Problem closing in GetACSearch-searchPVVM: " + ee);
      logger.fatal("ERROR - GetACSearch-searchPVVM for close : " + ee.toString(), ee);
    }
    return vList;
  }  //endPVVM search

  public EVS_Bean doAppendConcepts(String[] selRows, Vector<EVS_Bean> vRSel, EVS_UserBean eUser, int pvInd, PVForm data)
  {
    String errMsg = "";
    EVS_Bean eBean = new EVS_Bean();
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
          eBean = (EVS_Bean)vRSel.elementAt(iRow);
          //send it back if unable to obtion the concept
          if (eBean == null || eBean.getLONG_NAME() == null)
          {
            errMsg += "Unable to obtain concept from the " + thisRow + " row of the search results.\\n" + 
                "Please try again.";
            continue;
          }
          //get the thesaurus concept if not //TODO- this needs fixing to not use request and response
          String prefVocab = "";
          if (eUser != null)
            prefVocab = eUser.getPrefVocab();
          if (!eBean.getEVS_ORIGIN().equals(prefVocab) && !eBean.getEVS_DATABASE().equals(prefVocab))
          {
            EVSSearch evs = new EVSSearch(data.getRequest(), data.getResponse(), data.getCurationServlet());
            eBean = evs.getThesaurusConcept(eBean);            
          }
          //check if it exists in cadsr
          eBean = getCaDSRConcept(eBean, eUser, data);
          errMsg += data.getStatusMsg();
          //get the nvp value
          String sNVP = data.getRequest().getParameter("nvp_CK" + thisRow);
          if (sNVP != null && !sNVP.equals(""))
          {
            eBean.setNVP_CONCEPT_VALUE(sNVP);
            String conName = eBean.getLONG_NAME();
            eBean.setLONG_NAME(conName + "::" + sNVP);
          }
         // PV_Bean pv = data.getSelectPV();
          VM_Bean vm = data.getNewVM();  // pv.getPV_VM();
          if (vm == null) vm = new VM_Bean();
          Vector<EVS_Bean> vmCon = vm.getVM_CONCEPT_LIST();
          if (vmCon == null) vmCon = new Vector<EVS_Bean>();
          if (vmCon.size() > 0)
            vmCon.insertElementAt(eBean, vmCon.size() -1);
          else
            vmCon.addElement(eBean);  
          //TODO - make VM Name here
          vm.setVM_CONCEPT_LIST(vmCon);
          vm.setVM_IDSEQ("");
          vm.setVM_SUBMIT_ACTION(VMForm.CADSR_ACTION_INS);
          vm.setVM_SHORT_MEANING(eBean.getLONG_NAME());  //have some name
          data.setNewVM(vm);
   //       makeVMNameFromConcept(vm);  //make vm names
      //    pv.setPV_SHORT_MEANING(vm.getVM_SHORT_MEANING());
/*          pv.setPV_VM(vm);
          data.setSelectPV(pv);
          if (pvInd > -1)  //update the vector only if editing existing
          {
            VD_Bean vd = data.getVD();
            Vector<PV_Bean> vdpvs = vd.getVD_PV_List();
            vdpvs.setElementAt(pv, pvInd);
            vd.setVD_PV_List(vdpvs);
            data.setVD(vd);
          }
*/        }
      }
    return eBean;
  }
  
  public EVS_Bean getCaDSRConcept(EVS_Bean eBean, EVS_UserBean eUser, PVForm data)
  {
    String errMsg = "";
    ConceptForm conData = new ConceptForm();
    conData.setSearchTerm(eBean.getCONCEPT_IDENTIFIER());
    conData.setEvsUser(eUser);
    ConceptAction conAct = new ConceptAction();
    if (data.getDbConnection() != null)
      conData.setDBConnection(data.getDbConnection()); //get the connection
    else
      conData.setDBConnection(PVServlet.makeDBConnection());  //make the connection
    //call hte action
    conAct.doConceptSearch(conData);
    if (data.getDbConnection() == null)
      PVServlet.closeDBConnection(conData.getDBConnection());  //close the connection
    //get the bean from teh vector
    Vector vCon = conData.getConceptList();
    if (vCon != null && vCon.size() > 0)
    {
      if (vCon.size() > 1)
         errMsg += "Multiple concepts with same concept ID exists.";
      String unMatchName = "";
      String unMatchDef = "";
      boolean matchFound = false;
      for (int i = 0; i<vCon.size(); i++)
      {
        EVS_Bean cBean = (EVS_Bean)vCon.elementAt(i);
        if (cBean.getLONG_NAME().equalsIgnoreCase(eBean.getLONG_NAME()) && cBean.getPREFERRED_DEFINITION().equalsIgnoreCase(eBean.getPREFERRED_DEFINITION()))
        {
          eBean = (EVS_Bean)vCon.elementAt(i);
          matchFound = true;
          break;
        }
        else 
        {
          if (!cBean.getLONG_NAME().equalsIgnoreCase(eBean.getLONG_NAME()))
          {
            if (!unMatchName.equals("")) unMatchName += ", ";
            unMatchName += cBean.getLONG_NAME();
          }
          if (!cBean.getPREFERRED_DEFINITION().equalsIgnoreCase(eBean.getPREFERRED_DEFINITION()))
          {
            if (!unMatchDef.equals("")) unMatchDef += ", ";
            unMatchDef += cBean.getPREFERRED_DEFINITION();   
          }
          eBean = (EVS_Bean)vCon.elementAt(i);  //make this selected till exact match occurs
        }
      }
      if (!matchFound)
      {
        if (!unMatchName.equals(""))
          errMsg += "These Concept Names from caDSR do not match to the selected Concept : " + unMatchName;
        if (!unMatchDef.equals(""))
          errMsg += "These Concept Defintions from caDSR do not match to the selected Concept : " + unMatchDef;
      }
    }
    data.setStatusMsg(data.getStatusMsg() + "\\t" + errMsg);
    return eBean;
  }

  /**
   * To insert a new Permissible value in the database after the validation.
   * Called from NCICurationServlet.
   * Gets all the attribute values from the bean, sets in parameters, and registers output parameter.
   * Calls oracle stored procedure
   *   "{call SBREXT_Set_Row.SET_PV(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}" to submit
   *
   * @param sAction Insert or update Action.
   * @param sPV_ID PV IDseq.
   * @param pv PV Bean.
   *
   * @return String return code from the stored procedure call. null if no error occurred.
   */
   public String setPV(PVForm data)
   {
     //capture the duration
     //java.util.Date startDate = new java.util.Date();          
     //logger.info(m_servlet.getLogMessage(m_classReq, "setPV", "starting set", startDate, startDate));
     PV_Bean pv = data.getSelectPV();
     String sPVid = pv.getPV_PV_IDSEQ();        //out
  //   if (sPVid != null || !sPVid.equals("") || !sPVid.contains("EVS"))
  //     return "";
     
     Connection sbr_db_conn = null;
     ResultSet rs = null;
     CallableStatement CStmt = null;
     String sReturnCode = "";  //out
     try
     {
         String sAction = PVForm.CADSR_ACTION_INS;
         String sValue = pv.getPV_VALUE();
         VM_Bean vm = pv.getPV_VM();
         String sShortMeaning = pv.getPV_SHORT_MEANING();
         if (vm != null && vm.getVM_SHORT_MEANING() != null && !vm.getVM_SHORT_MEANING().equals(""))
           sShortMeaning = vm.getVM_SHORT_MEANING();
   //System.out.println(sAction + " set vm in pv " + sShortMeaning);
         String sMeaningDescription = pv.getPV_MEANING_DESCRIPTION();
         if (vm != null && vm.getVM_DESCRIPTION() != null && !vm.getVM_DESCRIPTION().equals(""))
           sMeaningDescription = vm.getVM_DESCRIPTION();
        // if (sMeaningDescription == null) sMeaningDescription = "";
       //  if (sMeaningDescription.length() > 2000) sMeaningDescription = sMeaningDescription.substring(0, 2000);
         String sBeginDate = pv.getPV_BEGIN_DATE();
         if (sBeginDate == null || sBeginDate.equals(""))
         {
           SimpleDateFormat formatter = new SimpleDateFormat ("MM/dd/yyyy");
           sBeginDate = formatter.format(new java.util.Date());
         }
         sBeginDate = data.getUtil().getOracleDate(sBeginDate);
         String sEndDate = data.getUtil().getOracleDate(pv.getPV_END_DATE());

         //check if it already exists
         String sPV_ID = this.getExistingPV(data, sValue, sShortMeaning);
         if (sPV_ID != null && !sPV_ID.equals(""))
         {
           pv.setPV_PV_IDSEQ(sPV_ID);  //update the pvbean with the id
           return sReturnCode;
         }
           
         //Create a Callable Statement object.
         sbr_db_conn = data.getDbConnection();
         if (sbr_db_conn == null || sbr_db_conn.isClosed())
           sbr_db_conn = PVServlet.makeDBConnection();
         // Create a Callable Statement object.
         if (sbr_db_conn != null)
         {
           CStmt = sbr_db_conn.prepareCall("{call SBREXT_Set_Row.SET_PV(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
           // register the Out parameters
           CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
           CStmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //pv id
           CStmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //value
           CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //short meaning
           CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //begin date
           CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //meaning description
           CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //low value num
           CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //high value num
           CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //end date
           CStmt.registerOutParameter(11,java.sql.Types.VARCHAR);       //created by
           CStmt.registerOutParameter(12,java.sql.Types.VARCHAR);       //date created
           CStmt.registerOutParameter(13,java.sql.Types.VARCHAR);       //modified by
           CStmt.registerOutParameter(14,java.sql.Types.VARCHAR);       //date modified

           // Set the In parameters (which are inherited from the PreparedStatement class)
           CStmt.setString(2,sAction);       //ACTION - INS, UPD or DEL
           if ((sAction.equals("UPD")) || (sAction.equals("DEL")))
           {
             sPV_ID = pv.getPV_PV_IDSEQ();
             CStmt.setString(3,sPV_ID);
           }
           else
           {
             CStmt.setString(4,sValue);
             CStmt.setString(5,sShortMeaning);
           }
           CStmt.setString(6,sBeginDate);
           CStmt.setString(7,sMeaningDescription);
           CStmt.setString(10,sEndDate);
            // Now we are ready to call the stored procedure
           boolean bExcuteOk = CStmt.execute();
           sReturnCode = CStmt.getString(1);
           sPV_ID = CStmt.getString(3);
           pv.setPV_PV_IDSEQ(sPV_ID);
           if (sReturnCode != null && !sReturnCode.equals("API_PV_300"))
           {
             data.setStatusMsg(data.getStatusMsg() + "\\t " + sReturnCode + " : Unable to update Permissible Value - " + sValue + ".");
             data.setRetErrorCode(sReturnCode);      //store returncode in request to track it all through this request    
             data.setPvvmErrorCode(sReturnCode);  //store it capture check for pv creation
           }
       }
       //capture the duration
       //logger.info(m_servlet.getLogMessage(m_classReq, "setPV", "end set", startDate, new java.util.Date())); 
     }
     catch(Exception e)
     {
       logger.fatal("ERROR in setPV for other : " + e.toString(), e);
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\t Exception : Unable to update Permissible Value attributes.");
     }
     try
     {
       if(rs!=null) rs.close();
       if(CStmt!=null) CStmt.close();
       if (data.getDbConnection() == null)
         PVServlet.closeDBConnection(sbr_db_conn);
     }
     catch(Exception ee)
     {
       logger.fatal("ERROR in InsACService-setPV for close : " + ee.toString(), ee);
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\t Exception : Unable to update Permissible Value attributes.");
     }
     return sReturnCode;
   }

   /**
    * Called from 'setPV' method for insert of PV.
    * Sets in parameters, and registers output parameter.
    * Calls oracle stored procedure
    *   "{call SBREXT_GET_ROW.GET_PV(?,?,?,?,?,?,?,?,?,?,?,?,?)}" to submit
    *
    * @param sValue   existing Value.
    * @param sMeaning  existing meaning.
    * 
    *  @return String existing pv_idseq from the stored procedure call.
    */
    public String getExistingPV(PVForm data, String sValue, String sMeaning)
    {
      Connection sbr_db_conn = null;
      ResultSet rs = null;
      String sPV_IDSEQ = "";
      CallableStatement CStmt = null;
      try
      {
        //Create a Callable Statement object.
        sbr_db_conn = data.getDbConnection();
        if (sbr_db_conn == null || sbr_db_conn.isClosed())
          sbr_db_conn = PVServlet.makeDBConnection();
        // Create a Callable Statement object.
        if (sbr_db_conn != null)
        {
          CStmt = sbr_db_conn.prepareCall("{call SBREXT_GET_ROW.GET_PV(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
          CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
          CStmt.registerOutParameter(2,java.sql.Types.VARCHAR);       //PV_IDSEQ
          CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //MEANING_DESCRIPTION
          CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       // HIGH_VALUE_NUM
          CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       // LOW_VALUE_NUM
          CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       // BEGIN_DATE 
          CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       // END_DATE 
          CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       // CREATED_BY
          CStmt.registerOutParameter(11,java.sql.Types.VARCHAR);       // Date Created
          CStmt.registerOutParameter(12,java.sql.Types.VARCHAR);       // MODIFIED_BY
          CStmt.registerOutParameter(13,java.sql.Types.VARCHAR);       // DATE_MODIFIED

          CStmt.setString(3, sValue);       // Value
          CStmt.setString(4, sMeaning);       // Meaning   
           // Now we are ready to call the stored procedure
          boolean bExcuteOk = CStmt.execute();
          sPV_IDSEQ = (String) CStmt.getObject(2);
          if (sPV_IDSEQ == null)
             sPV_IDSEQ = "";
        }
      }
      catch(Exception e)
      {
        logger.fatal("ERROR in getExistingPV for exception : " + e.toString(), e);
      }

      try
      {
        if(rs!=null) rs.close();
        if(CStmt!=null) CStmt.close();
        if (data.getDbConnection() == null)
          PVServlet.closeDBConnection(sbr_db_conn);
      }
      catch(Exception ee)
      {
        logger.fatal("ERROR in getExistingPV for close : " + ee.toString(), ee);
      }
      return sPV_IDSEQ;
    }

  /**
   * To remove exisitng one in VD_PVS relationship table after the validation.
   * Called from 'setVD_PVS' method.
   * Sets in parameters, and registers output parameter.
   * Calls oracle stored procedure
   *   "{call SBREXT_Set_Row.SET_VD_PVS(?,?,?,?,?,?,?,?,?,?)}" to submit
   *
   * @param pvBean PV_Bean of the selected pv.
   * @param vdBean VD_Bean of the current pv.
   * @return String of return code 
   */
   public String setVD_PVS(PVForm data)
   {
     //capture the duration
     java.util.Date startDate = new java.util.Date();          
     //logger.info(m_servlet.getLogMessage(m_classReq, "setVD_PVS", "starting set", startDate, startDate));
     PV_Bean pvBean = data.getSelectPV();
     VD_Bean vdBean = data.getVD();
     Connection sbr_db_conn = null;
     CallableStatement CStmt = null;
     String retCode = "";
     try
     {
         String sAction = pvBean.getVP_SUBMIT_ACTION();
         String vpID = pvBean.getPV_VDPVS_IDSEQ();
         //deleting newly selected/created pv don't do anything since it doesn't exist in cadsr to remove.
         if (sAction.equals("DEL") && (vpID == null || vpID.equals("")))
           return retCode;
         //TODO - create parent concept
         String parIdseq = this.setParentConcept(pvBean, vdBean);
         //Create a Callable Statement object.
         sbr_db_conn = data.getDbConnection();
         if (sbr_db_conn == null || sbr_db_conn.isClosed())
           sbr_db_conn = PVServlet.makeDBConnection();
         // Create a Callable Statement object.
         if (sbr_db_conn != null)
         {
            CStmt = sbr_db_conn.prepareCall("{call sbrext_set_row.SET_VD_PVS(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
            CStmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //vd_PVS id
            CStmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //vd id
            CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //pvs id
            CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //context id
            CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //date created
            CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //created by
            CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //modified by
            CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //date modified

            // Set the In parameters (which are inherited from the PreparedStatement class)
            //create a new row if vpIdseq is empty for updates           
            if (sAction.equals("UPD") && (vpID == null || vpID.equals(""))) sAction = "INS";
            
            CStmt.setString(2, sAction);       //ACTION - INS, UPD  or DEL
            CStmt.setString(3, pvBean.getPV_VDPVS_IDSEQ());    //VPid);       //vd_pvs ideq - not null
            CStmt.setString(4, vdBean.getVD_VD_IDSEQ());  // sVDid);       //value domain id - not null
            CStmt.setString(5, pvBean.getPV_PV_IDSEQ());  // sPVid);       //permissible value id - not null
            CStmt.setString(6, vdBean.getVD_CONTE_IDSEQ());  // sContextID);       //context id - not null for INS, must be null for UPD
            String pvOrigin = pvBean.getPV_VALUE_ORIGIN();
            //believe that it is defaulted to vd's origin
            //if (pvOrigin == null || pvOrigin.equals(""))
            //   pvOrigin = vdBean.getVD_SOURCE();
            CStmt.setString(11, pvOrigin);  // sOrigin);
            String sDate = pvBean.getPV_BEGIN_DATE();
            if (sDate != null && !sDate.equals(""))
               sDate = data.getUtil().getOracleDate(sDate);
            CStmt.setString(12, sDate);  // begin date);
            sDate = pvBean.getPV_END_DATE();
            if (sDate != null && !sDate.equals(""))
               sDate = data.getUtil().getOracleDate(sDate);
            CStmt.setString(13, sDate);  // end date);
            CStmt.setString(14, parIdseq);
 System.out.println(sAction + " set vdpvs " + pvBean.getPV_VDPVS_IDSEQ());
            boolean bExcuteOk = CStmt.execute();
            retCode = CStmt.getString(1);
            //store the status message if children row exist
            if (retCode != null && !retCode.equals(""))
            {
              String sPValue = pvBean.getPV_VALUE();
              String sVDName = vdBean.getVD_LONG_NAME();
              if (sAction.equals("INS") || sAction.equals("UPD"))
                 data.setStatusMsg(data.getStatusMsg() + "\\t " + retCode + " : Unable to update permissible value " + sPValue + ".");
              else if (sAction.equals("DEL") && retCode.equals("API_VDPVS_006"))
              {
                data.setStatusMsg(data.getStatusMsg() + "\\t This Value Domain is used by a form. " +
                   "Create a new version of the Value Domain to remove permissible value " + sPValue + ".");
              }
              else if (!sAction.equals("DEL") && !retCode.equals("API_VDPVS_005")) 
                data.setStatusMsg(data.getStatusMsg() + "\\t " + retCode + " : Unable to remove permissible value " + sPValue + ".");
              
              data.setRetErrorCode(retCode);  
            }
            else
              pvBean.setPV_VDPVS_IDSEQ(CStmt.getString(3));
         }
       //capture the duration
       //logger.info(m_servlet.getLogMessage(m_classReq, "setVD_PVS", "end set", startDate, new java.util.Date()));  
     }
     catch(Exception e)
     {
       logger.fatal("ERROR in setVD_PVS for other : " + e.toString(), e);
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\t Exception : Unable to update or remove PV of VD.");
     }
     try
     {
       if(CStmt!=null) CStmt.close();
       if (data.getDbConnection() == null)
         PVServlet.closeDBConnection(sbr_db_conn);
     }
     catch(Exception ee)
     {
       logger.fatal("ERROR in setVD_PVS for close : " + ee.toString(), ee);
       data.setRetErrorCode("Exception");
       data.setStatusMsg(data.getStatusMsg() + "\\t Exception : Unable to update or remove PV of VD.");
     }
     return retCode;
   }  //END setVD_PVS

   public void doBlockEditPV(PVForm data, String changeField, String changeData)
   {
     VD_Bean vd = data.getVD();
     Vector<PV_Bean> vdpv = vd.getVD_PV_List();
     for (int i=0; i<vdpv.size(); i++)
     {
       PV_Bean pv = (PV_Bean)vdpv.elementAt(i);
       if (changeField.equals("origin"))
         pv.setPV_VALUE_ORIGIN(changeData);
       else if (changeField.equals("begindate"))
         pv.setPV_BEGIN_DATE(changeData);
       else if (changeField.equals("enddate"))
         pv.setPV_END_DATE(changeData);
       //change the submit action
       pv.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_UPD);
       vdpv.setElementAt(pv, i);
     }
     vd.setVD_PV_List(vdpv);
     data.setVD(vd);
   }

   private String setParentConcept(PV_Bean pvBean, VD_Bean vd)
   {
     String conIDseq = "";
     //create parent concept if exists 
// TODO - do the parent concept realtionship later
     EVS_Bean pCon = (EVS_Bean)pvBean.getPARENT_CONCEPT();
     if (pCon != null)
     {
       conIDseq = pCon.getIDSEQ();  // pCon.getCONDR_IDSEQ();
       String pConID = pCon.getCONCEPT_IDENTIFIER();
       if (pConID != null && !pConID.equals("") && (conIDseq == null || conIDseq.equals("")))
       {
         Vector<EVS_Bean> vPar = vd.getReferenceConceptList();
         if (vPar != null)
         {
           for (int i=0; i<vPar.size(); i++)
           {
             EVS_Bean ePar = (EVS_Bean)vPar.elementAt(i);
             if (ePar.getCONCEPT_IDENTIFIER().equals(pConID) && ePar.getIDSEQ() != null && !ePar.getIDSEQ().equals(""))
             {
               conIDseq = ePar.getIDSEQ();   
               break;
             }
           }
         }
       }
     }
     return conIDseq;
   }

   public void doRemoveParent(String sParentCC, String sParentName, String sParentDB, String sPVAction, PVForm data)
   {
    // HttpSession session = req.getSession();   
     VD_Bean vd = data.getVD();
     Vector<EVS_Bean> vParentCon = vd.getReferenceConceptList();  // (Vector)session.getAttribute("VDParentConcept");
     if (vParentCon == null) vParentCon = new Vector<EVS_Bean>();    
     //for non evs parent compare the long names instead
     if (sParentName != null && !sParentName.equals("") && sParentDB != null && sParentDB.equals("Non_EVS"))
       sParentCC = sParentName;
     if (sParentCC != null)
     {
       for (int i=0; i<vParentCon.size(); i++)
       {
         EVS_Bean eBean = (EVS_Bean)vParentCon.elementAt(i);
         if (eBean == null) eBean = new EVS_Bean();
         String thisParent = eBean.getCONCEPT_IDENTIFIER();
         if (thisParent == null) thisParent = "";
         String thisParentName = eBean.getLONG_NAME();
         if (thisParentName == null) thisParentName = "";
         String thisParentDB = eBean.getEVS_DATABASE();
         if (thisParentDB == null) thisParentDB = "";
         //for non evs parent compare the long names instead
         if (sParentDB != null && sParentDB.equals("Non_EVS"))
           thisParent = thisParentName;
          //look for the matched parent from the vector to remove
         if (sParentCC.equals(thisParent))
         {
          // String strHTML = "";
          // EVSMasterTree tree = new EVSMasterTree(req, thisParentDB, this);
          // strHTML = tree.refreshTree(thisParentName, "false");
          // strHTML = tree.refreshTree("parentTree"+thisParentName, "false");
           
           if (sPVAction.equals("removePVandParent"))
           {
             Vector<PV_Bean> vVDPVList = vd.getVD_PV_List();  // (Vector)session.getAttribute("VDPVList");
             if (vVDPVList == null) vVDPVList = new Vector<PV_Bean>();
             //loop through the vector of pvs to get matched parent
             for (int j=0; j<vVDPVList.size(); j++)
             {
               PV_Bean pvBean = (PV_Bean)vVDPVList.elementAt(j);
               if (pvBean == null) pvBean = new PV_Bean();
               EVS_Bean pvParent = (EVS_Bean)pvBean.getPARENT_CONCEPT();
               if (pvParent == null) pvParent = new EVS_Bean();
               String pvParCon = pvParent.getCONCEPT_IDENTIFIER();
               //match the parent concept with the pv's parent concept
               if (thisParent.equals(pvParCon))
               {
                 doRemovePV(vd, j, pvBean, -1);
                 j -= 1;
               }
             }
             vd.setVD_PV_List(vVDPVList);
           }
           //mark the parent as delected and leave
           eBean.setCON_AC_SUBMIT_ACTION("DEL");
           vParentCon.setElementAt(eBean,i);
           break;
         }
       }
     }
     vd.setReferenceConceptList(vParentCon);
     data.setVD(vd);
   }

   public void doRemovePV(VD_Bean vd, int pvInd, PV_Bean selPV, int iSetVDPV)
   {
     Vector<PV_Bean> vdpvs = vd.getVD_PV_List();
     vdpvs.removeElementAt(pvInd);
   //  if (iSetVDPV == 0)
       vd.setVD_PV_List(vdpvs);
     //add the removed pv to the removed pv list
     if (selPV != null)
     {
       selPV.setVP_SUBMIT_ACTION(PVForm.CADSR_ACTION_DEL);
       Vector<PV_Bean> rmList = vd.getRemoved_VDPVList();  // data.getRemovedPVList();
       rmList.addElement(selPV);
       //session.setAttribute("RemovedPVList", rmList);
       vd.setRemoved_VDPVList(rmList);
     }       
   }

   /**
    * gets the row number from the hiddenSelRow
    * Loops through the selected row and gets the evs bean for that row from the vector of evs search results.
    * adds it to vList vector and return the vector back
    * @param req HttpServletRequest
    * @param vList Existing Vector of EVS Beans
    * @return Vector of EVS Beans
    * @throws java.lang.Exception
    */
   public void getEVSSelRowVector(Vector<EVS_Bean> vRSel, String[] selRows, PVForm data) throws Exception
   {
     VD_Bean vd = data.getVD();
     Vector<EVS_Bean> vList = vd.getReferenceConceptList();  // (Vector)session.getAttribute("VDParentConcept");
     if (vList == null) vList = new Vector<EVS_Bean>();
     
       //loop through the array of strings
       for (int i=0; i<selRows.length; i++)
       {
         String thisRow = selRows[i];
         Integer IRow = new Integer(thisRow);
         int iRow = IRow.intValue();
         if (iRow < 0 || iRow > vRSel.size())
           data.setStatusMsg(data.getStatusMsg() + "\\tRow size is either too big or too small.");
         else
         {
           EVS_Bean eBean = (EVS_Bean)vRSel.elementAt(iRow);
           //send it back if unable to obtion the concept
           if (eBean == null || eBean.getLONG_NAME() == null)
           {
             data.setStatusMsg(data.getStatusMsg() + "\\tUnable to obtain concept from the " + thisRow + " row of the search results.\\n" + 
                 "Please try again.");
             continue;
           }

           String eBeanDB = eBean.getEVS_DATABASE();
           //make sure it doesn't exist in the list
           boolean isExist = false;
           if (vList != null && vList.size() > 0)
           {
             for (int k=0; k<vList.size(); k++)
             {
               EVS_Bean thisBean = (EVS_Bean)vList.elementAt(k);
               String thisBeanDB = thisBean.getEVS_DATABASE();
               if (thisBean.getCONCEPT_IDENTIFIER().equals(eBean.getCONCEPT_IDENTIFIER()) && eBeanDB.equals(thisBeanDB))
               {
                 String acAct = thisBean.getCON_AC_SUBMIT_ACTION();
                 //put it back if was deleted
                 if (acAct != null && acAct.equals("DEL"))
                 {
                   thisBean.setCON_AC_SUBMIT_ACTION("INS");
                   vList.setElementAt(thisBean, k);
                 }
                 isExist = true;
               }
             }
           }
           if (isExist == false)
           {
             eBean.setCON_AC_SUBMIT_ACTION("INS");
             //get the evs user bean
             EVS_UserBean eUser = (EVS_UserBean)NCICurationServlet.sessionData.EvsUsrBean; //(EVS_UserBean)session.getAttribute(EVSSearch.EVS_USER_BEAN_ARG);  //("EvsUserBean");
             if (eUser == null) eUser = new EVS_UserBean();
             
             //get origin for cadsr result
             String eDB = eBean.getEVS_DATABASE();
             if (eDB != null && eBean.getEVS_ORIGIN() != null && eDB.equalsIgnoreCase("caDSR"))
             {
               eDB = eBean.getVocabAttr(eUser, eBean.getEVS_ORIGIN(), EVSSearch.VOCAB_NAME, EVSSearch.VOCAB_DBORIGIN);  // "vocabName", "vocabDBOrigin");
               eBean.setEVS_DATABASE(eDB);   //eBean.getEVS_ORIGIN()); 
             }
             vList.addElement(eBean);  
           }          
         }
       }  
       vd.setReferenceConceptList(vList);
       data.setVD(vd);
   } 
   
   /**
    * stores the non evs parent reference information in evs bean and to parent list.
    * reference document is matched like this with the evs bean adn stored in parents vector as a evs bean
    * setCONCEPT_IDENTIFIER as document type (VD REFERENCE)
    * setLONG_NAME as document name
    * setEVS_DATABASE as Non_EVS text 
    * setPREFERRED_DEFINITION as document text
    * setEVS_DEF_SOURCE as document url
    * 
    * @param req HttpServletRequest object
    * @param res HttpServletResponse object
    * @throws java.lang.Exception
    */
   public void doNonEVSReference(String sParName, String sParDef, String sParDefSource, PVForm data)
   {
     try
     {
       //document type  (concept code)
       String sParCode = "VD REFERENCE";
       //parent type (concept database)
       String sParDB = "Non_EVS";
       
       //make a string for view    
       String sParListString = sParName + "        " + sParDB; 
       if(sParListString == null) sParListString = "";
       VD_Bean vd = data.getVD();
   
       //store the evs bean for the parent concepts in vector and in session.    
       Vector<EVS_Bean> vParentCon = vd.getReferenceConceptList();  
       if (vParentCon == null) vParentCon = new Vector<EVS_Bean>();
       EVS_Bean parBean = new EVS_Bean();
       parBean.setCONCEPT_IDENTIFIER(sParCode);  //doc type
       parBean.setLONG_NAME(sParName);   //doc name
       parBean.setEVS_DATABASE(sParDB);  //ref type (non evs)
       parBean.setPREFERRED_DEFINITION(sParDef);  //doc text
       parBean.setEVS_DEF_SOURCE(sParDefSource);  //doc url
       parBean.setCON_AC_SUBMIT_ACTION("INS");
       vParentCon.addElement(parBean);
       vd.setReferenceConceptList(vParentCon);
       data.setVD(vd);
     }
     catch (RuntimeException e)
     {
       logger.fatal("ERROR - ", e);
     }
   } // end
   


}//end of class
