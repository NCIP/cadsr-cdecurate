package gov.nih.nci.cadsr.cdecurate.tool;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.Vector;
import oracle.jdbc.driver.OracleTypes;
import org.apache.log4j.Logger;
/**
 * @author shegde
 */
public class AltDefAction
{
  Logger logger = Logger.getLogger(AltDefAction.class.getName());

  /**
   * @param data
   * @return Vector of alt definition beans
   */
  public AltDefForm doSearchAltDef(AltDefForm data)
  {
    Vector<AltDefBean> vList = new Vector<AltDefBean>();
    try
    {
      // search for existing alternate definitions from caDSR for an existing AC
      String sAC = data.getAcIDSEQ();
      ResultSet rs = null;
      CallableStatement CStmt = null;
      if (sAC != null && !sAC.equals(""))
      {
        Connection dbCon = data.getDbConn();
        // call the API
        CStmt = dbCon.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_ALTERNATE_NAMES(?,?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);
        // register input parameters
        CStmt.setString(1, sAC);
        CStmt.setString(2, data.getDeflName());
        // Now we are ready to call the stored procedure
        CStmt.execute();
        // store the output in the resultset
        rs = (ResultSet) CStmt.getObject(3);
        // get the data from rs object
        if (rs != null)
        {
          // loop through the resultSet and add them to the bean
          Vector<AltDefBean> allAD = data.getAllADList();
          while (rs.next())
          {
            AltDefBean AltDefBean = new AltDefBean();
            AltDefBean.setALT_DEF_IDSEQ(rs.getString("desig_idseq"));
            AltDefBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
            AltDefBean.setCONTEXT_NAME(rs.getString("context_name"));
            AltDefBean.setALT_DEFINITION(rs.getString("name"));
            AltDefBean.setALT_DEF_TYPE(rs.getString("detl_name"));
            AltDefBean.setAC_LONG_NAME(rs.getString("ac_long_name"));
            AltDefBean.setAC_IDSEQ(sAC);
            AltDefBean.setAC_LANGUAGE(rs.getString("lae_name"));
            AltDefBean.setALT_SUBMIT_ACTION(AltDefForm.CADSR_ACTION_UPD);
            vList.addElement(AltDefBean); // add the bean to a vector
            allAD.addElement(AltDefBean);  //add the bean to All AD vector
          } // END WHILE
          data.setAllADList(allAD);
          data.setADList(vList);
          data.setActionStatus(AltDefForm.ACTION_STATUS_SUCCESS);
        } // END IF
      }
    } catch (Exception e)
    {
      logger.fatal("Error - doSearchAltDef ", e);
      data.setActionStatus(AltDefForm.ACTION_STATUS_FAIL);
    }
    return data;
  }
 
  public AltDefForm doMarkAltDefEdits(AltDefForm adData)
  {
    try
    {
      int iPageAct = adData.getAdPageAction();
      //add the newly edited bean data as new item
      if (iPageAct == AltDefForm.PAGE_ACTION_CREATE)
      {
        AltDefBean adBean = adData.getAdBean();
        adBean.setALT_SUBMIT_ACTION(AltDefForm.CADSR_ACTION_INS);
        adBean.setAC_IDSEQ("new");
      }
      //update the existing data with edited text as well as CSCSI for each AD. This should allow block edits also??
      else if (iPageAct == AltDefForm.PAGE_ACTION_EDIT)
      {
        //loop through selected vector and mark each one updated 
      }
      //mark the existing data to remove
      
      //send back with the refreshed data 
      adData.setActionStatus(AltDefForm.ACTION_STATUS_SUCCESS);
    }
    catch(Exception e)
    {
      logger.fatal("Error : Unable to mark Alt Definition edits.", e);
      adData.setStatusMsg("Error : Unable to mark Alt Definition edits." + e.toString());
      adData.setActionStatus(AltDefForm.ACTION_STATUS_FAIL);
    }
    return adData;
  }
  private AltDefForm setDefinition(AltDefForm adData)
  {
    try
    {
      AltDefBean adBean = adData.getAdBean();
      Connection dbCon = adData.getDbConn();
      CallableStatement CStmt = null;
      if (dbCon != null)
      {
        CStmt = dbCon.prepareCall("{call SBREXT_Set_Row.SET_DES(?,?,?,?,?,?,?,?,?,?,?,?)}");
        CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
        CStmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //des desig id
        CStmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //des name
        CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //des detl name
        CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //des ac id
        CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //context id
        CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //lae name
        CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //created by
        CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //date created
        CStmt.registerOutParameter(11,java.sql.Types.VARCHAR);       //modified by
        CStmt.registerOutParameter(12,java.sql.Types.VARCHAR);       //date modified

        // Set the In parameters (which are inherited from the PreparedStatement class)
        String sAction = adBean.getALT_SUBMIT_ACTION();
        if (sAction == null) sAction = AltDefForm.CADSR_ACTION_UPD;
        String defIDSEQ = adBean.getALT_DEF_IDSEQ();
        if ((sAction.equals(AltDefForm.CADSR_ACTION_UPD)) || (sAction.equals(AltDefForm.CADSR_ACTION_DEL)))
        {
          if ((defIDSEQ != null) && (!defIDSEQ.equals("")))
            CStmt.setString(3,defIDSEQ);              //definition idseq if updated
          else
            sAction = AltDefForm.CADSR_ACTION_INS;              //INSERT A NEW RECORD IF NOT EXISTED
        }
        CStmt.setString(2,sAction);              //ACTION - INS, UPD or DEL
        CStmt.setString(4, adBean.getALT_DEFINITION());         //selected value for rep and null for cde_id
        CStmt.setString(5,adBean.getALT_DEF_TYPE());        //detl name - must be string CDE_ID
        CStmt.setString(6,adBean.getAC_IDSEQ());           //ac id - must be NULL FOR UPDATE
        CStmt.setString(7,adBean.getCONTE_IDSEQ());     //context id - must be same as in set_DE
        CStmt.setString(8,adBean.getAC_LANGUAGE());            //language name - can be null
         // Now we are ready to call the stored procedure
        CStmt.execute();
        //get the return code 
        String sRet = CStmt.getString(1);
        adBean.setRETURN_CODE(sRet);
        if (sRet != null || !sRet.equals(""))
        {
          //send back the error message
          adData.setActionStatus(AltDefForm.ACTION_STATUS_FAIL);
          adData.setStatusMsg(sRet + " : Unable add or remove Alt Definition.");
        }
        else
          adData.setActionStatus(AltDefForm.ACTION_STATUS_SUCCESS);
      } 
      adData.setAdBean(adBean);
    }
    catch(Exception e)
    {
      logger.fatal("Error : Unable add or remove Alt Definition.", e);
      adData.setStatusMsg("Error : Unable add or remove Alt Definition." + e.toString());
      adData.setActionStatus(AltDefForm.ACTION_STATUS_FAIL);
    }
    return adData;
  }
}
