/**
 * 
 */
package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Vector;
import oracle.jdbc.OracleTypes;
import org.apache.log4j.Logger;

/**
 * @author shegde
 *
 */
public class ConceptAction implements Serializable
{
  private static final long serialVersionUID = 8868343249617213234L;
  private static final Logger logger = Logger.getLogger(ConceptAction.class.getName());

  /** constructor*/
  public ConceptAction()
  {
  }

  
  /**
   * To get resultSet from database for Concept Class.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_CONCEPT(InString, ContName, ASLName, OracleTypes.CURSOR)}"
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * @param data 
   *
  */
  public void doConceptSearch(ConceptForm data)  // returns list of Concepts
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      UtilService util = data.getUtil();
      //get the data for the call
      String InString = util.parsedStringSingleQuoteOracle(data.getSearchTerm());
      String conIdseq = data.getConIDSEQ();
      String ContName = this.getContextValue(data.getContextName()); 
      String ASLName = this.getStatusValues(data.getASLNameList(), data);
      String conID = data.getConID();
      String decID = data.getDecIDseq();
      String vdID = data.getVdIDseq(); 
      String sDef = data.getSearchDefn();
      //capture the duration
      //java.util.Date exDate = new java.util.Date();          
      //logger.info(m_servlet.getLogMessage(m_classReq, "do_ConceptSearch", "begin search", exDate, exDate));
      
      //get the connection from data if exists (used for testing)
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = ConceptServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT.SBREXT_CDE_CURATOR_PKG.SEARCH_CON(?,?,?,?,?,?,?,?,?)}");
        CStmt.registerOutParameter(6, OracleTypes.CURSOR);
        CStmt.setString(1, InString);
        CStmt.setString(2, ASLName);
        CStmt.setString(3, ContName);
        CStmt.setString(4, conID);
        CStmt.setString(5, conIdseq);
        CStmt.setString(7, decID);
        CStmt.setString(8, vdID);
        CStmt.setString(9, sDef);
       // Now we are ready to call the stored procedure
        CStmt.execute();   
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(6);
        //capture the duration
      //  logger.info(m_servlet.getLogMessage(m_classReq, "do_ConceptSearch", "got rsObject", exDate, new java.util.Date()));
        if(rs!=null)
        {
          //this.storeRecordInVector(rs, data);
          EVS_UserBean eUser = data.getEvsUser();
         // UtilService util = data.getUtil();
          String sAction = data.getACAction();
          boolean existInd = false;
          Vector<EVS_Bean> vList = new Vector<EVS_Bean>();
          while(rs.next())
          {
            EVS_Bean conBean = new EVS_Bean();
            String sConName = util.removeNewLineChar(rs.getString("long_name"));
            conBean.setCONCEPT_NAME(sConName);  
            conBean.setLONG_NAME(sConName);  //rs.getString("long_name"));
            sDef = util.removeNewLineChar(rs.getString("preferred_definition"));
            conBean.setPREFERRED_DEFINITION(sDef);
            conBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
            conBean.setASL_NAME(rs.getString("asl_name"));
            conBean.setIDSEQ(rs.getString("con_idseq")); 
            conBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
            String sVocab = rs.getString("origin");
            if (sAction.equals("searchForCreate"))
              conBean.setEVS_DATABASE("caDSR");
            else  //make the vocab as evs origin from cadsr for main page concept class search
              conBean.setEVS_DATABASE(sVocab);
            conBean.setcaDSR_COMPONENT("Concept Class"); 
            String selVocab = conBean.getVocabAttr(eUser, sVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
            //store evs vocab name in evs origin and leave meta out
            if (selVocab.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
              conBean.setEVS_ORIGIN(sVocab);
            else conBean.setEVS_ORIGIN(selVocab);
            
            conBean.setID(rs.getString("con_ID"));//public id
            if (rs.getString("version").indexOf('.') >= 0)
              conBean.setVERSION(rs.getString("version"));
            else
              conBean.setVERSION(rs.getString("version") + ".0");
            conBean.setCONTEXT_NAME(rs.getString("context"));
            conBean.setDEC_USING("");
            String sPref = util.removeNewLineChar(rs.getString("preferred_name"));
            conBean.setCONCEPT_IDENTIFIER(sPref);  //cui
     System.out.println(sPref + rs.getString("con_idseq") + sConName + " conname " + sDef);
            conBean.setNCI_CC_TYPE(rs.getString("evs_source"));
            if (data.getRequest() != null)
              conBean.markNVPConcept(conBean, data.getRequest().getSession());
            //make sure it is included only once by matching evsId and concept name only if oc/prop/rep search was done earlier.
            boolean isExist = false;
            if (existInd == true)
            {
              for (int j = 0; j < vList.size(); j++)
              {
                EVS_Bean exBean = (EVS_Bean)vList.elementAt(j);
                String curEvsId = exBean.getCONCEPT_IDENTIFIER();
                String curLName = exBean.getLONG_NAME();
                //check if not null or empty
                if (curEvsId != null && !curEvsId.equals("") && curLName != null && !curLName.equals(""))
                {
                  //compare to the current one
                  String evsId = conBean.getCONCEPT_IDENTIFIER();
                  String longName = conBean.getLONG_NAME();
                  if (evsId != null && evsId.equals(curEvsId) && longName != null && longName.equals(curLName))
                    isExist = true;
                }
              }
            }
            if (isExist == false)
              vList.addElement(conBean);    //add concept bean to vector     
          }
          data.setConceptList(vList);
        }   //END IF
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - doconceptSearch for other : ", e);
      System.out.println(e);
      data.setStatusMsg("Error : Unable to do concept search." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if (data.getDBConnection() == null)
        ConceptServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      logger.fatal("GetACSearch-do_conceptSearch for close : " + ee.toString(), ee);
    }
    //capture the duration
    //logger.info(m_servlet.getLogMessage(m_classReq, "do_conceptSearch", "end search", exDate,  new java.util.Date()));
  }  //endconcept search

  /**gets teh existing condr idseq for the concepts from teh database
   * @param data ConceptForm object
   * @return String condr idseq
   */
  public String getConDerivation(ConceptForm data)
  {
    String condr = "";
    Vector<EVS_Bean> conList = data.getConceptList();
    //make con idseq array
    String conArray = this.getConArray(conList, false, data);
    System.out.println(conList.size() + " get derivation " + conArray);
    if (!conArray.equals(""))
    {
      Connection sbr_db_conn = null;
      ResultSet rs = null;
      Statement stmt = null;
      try
      {
        sbr_db_conn = data.getDBConnection();
        if (sbr_db_conn == null || sbr_db_conn.isClosed())
          sbr_db_conn = ConceptServlet.makeDBConnection();
        // Create a Callable Statement object.
        if (sbr_db_conn != null)
        {
          stmt = sbr_db_conn.createStatement();
          rs = stmt.executeQuery("select SBREXT_COMMON_ROUTINES.CHECK_DERIVATION_EXISTS('" + conArray + "') from DUAL");
          //loop through to printout the outstrings
          while(rs.next())
          {
            condr = rs.getString(1);
          System.out.println(conArray + " condr " + condr);
            if (condr == null) condr = "";
          }
        }
      }
      catch(Exception e)
      {
        logger.fatal("ERROR - doconceptSearch for other : ", e);
        data.setStatusMsg("Error : Unable to do concept search." + e.toString());
        data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
      }
      try
      {
        if(rs!=null) rs.close();
        if(stmt!=null) stmt.close();
        if (data.getDBConnection() == null)
          ConceptServlet.closeDBConnection(sbr_db_conn);
      }
      catch(Exception ee)
      {
        logger.fatal("GetACSearch-do_conceptSearch for close : " + ee.toString(), ee);
      }
    }
    return condr;
  }

  /** creates concept in the database if doesn't exist one
   * makes array of conidseq to submit
   * @param conList vector of evs bean object
   * @param isCreate boolean to check if submiting or viewing
   * @param data conceptform object
   * @return String of concept idseq array
   */
  public String getConArray(Vector<EVS_Bean> conList, boolean isCreate, ConceptForm data)
  {
    String conArray = "";
    for (int i=0; i<conList.size(); i++)
    {
      EVS_Bean con = (EVS_Bean)conList.elementAt(i);
      if (con == null) con = new EVS_Bean();
      String conIDseq = con.getIDSEQ();
      if (conIDseq == null || conIDseq.equals(""))  //add conidseq        
      {
        if (isCreate)
        {
          System.out.println("create new concept");
          String sret = this.setConcept(data, con, ConceptForm.CADSR_ACTION_INS);
        }
        else
          return "";
      }
      conIDseq = con.getIDSEQ();
      if (!conArray.equals(""))  //add comma
        conArray += ",";
      //get the nvp value if exists or not the last one (primary)
      if (!con.getNVP_CONCEPT_VALUE().equals("") && i < conList.size()-1)
        conIDseq += ":" + con.getNVP_CONCEPT_VALUE();
      //make an array
      conArray += conIDseq; 
      System.out.println(con.getLONG_NAME() + " conarray " + conArray);
    }
    return conArray;
  }

  private void storeRecordInVector(ResultSet rs, ConceptForm data)
  {

    try
    {
      EVS_UserBean eUser = data.getEvsUser();
      UtilService util = data.getUtil();
      String sAction = data.getACAction();
      boolean existInd = false;
      //mark it if oc/prop/rep search was done earlier
      Vector<EVS_Bean> vList = data.getConceptList();
      if (vList != null && vList.size()>0) 
        existInd = true;
    System.out.println(" record " + rs.toString());
      //loop through to printout the outstrings
      while(rs.next())
      {
        EVS_Bean conBean = new EVS_Bean();
        String sConName = util.removeNewLineChar(rs.getString("long_name"));
        conBean.setCONCEPT_NAME(sConName);  
        conBean.setLONG_NAME(sConName);  //rs.getString("long_name"));
        String sDef = util.removeNewLineChar(rs.getString("preferred_definition"));
        conBean.setPREFERRED_DEFINITION(sDef);
        conBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
        conBean.setASL_NAME(rs.getString("asl_name"));
        conBean.setIDSEQ(rs.getString("con_idseq")); 
        conBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
        String sVocab = rs.getString("origin");
        if (sAction.equals("searchForCreate"))
          conBean.setEVS_DATABASE("caDSR");
        else  //make the vocab as evs origin from cadsr for main page concept class search
          conBean.setEVS_DATABASE(sVocab);
        conBean.setcaDSR_COMPONENT("Concept Class"); 
  System.out.println(rs.getString("con_idseq") + sConName + " conname " + sDef);
        String selVocab = conBean.getVocabAttr(eUser, sVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
        //store evs vocab name in evs origin and leave meta out
        if (selVocab.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
          conBean.setEVS_ORIGIN(sVocab);
        else conBean.setEVS_ORIGIN(selVocab);
        
        conBean.setID(rs.getString("con_ID"));//public id
        if (rs.getString("version").indexOf('.') >= 0)
          conBean.setVERSION(rs.getString("version"));
        else
          conBean.setVERSION(rs.getString("version") + ".0");
        conBean.setCONTEXT_NAME(rs.getString("context"));
        conBean.setDEC_USING("");
        String sPref = util.removeNewLineChar(rs.getString("preferred_name"));
        conBean.setCONCEPT_IDENTIFIER(sPref);  //cui
        conBean.setNCI_CC_TYPE(rs.getString("evs_source"));
        if (data.getRequest() != null)
          conBean.markNVPConcept(conBean, data.getRequest().getSession());
        //make sure it is included only once by matching evsId and concept name only if oc/prop/rep search was done earlier.
        boolean isExist = false;
        if (existInd == true)
        {
          for (int j = 0; j < vList.size(); j++)
          {
            EVS_Bean exBean = (EVS_Bean)vList.elementAt(j);
            String curEvsId = exBean.getCONCEPT_IDENTIFIER();
            String curLName = exBean.getLONG_NAME();
            //check if not null or empty
            if (curEvsId != null && !curEvsId.equals("") && curLName != null && !curLName.equals(""))
            {
              //compare to the current one
              String evsId = conBean.getCONCEPT_IDENTIFIER();
              String longName = conBean.getLONG_NAME();
              if (evsId != null && evsId.equals(curEvsId) && longName != null && longName.equals(curLName))
                isExist = true;
            }
          }
        }
        if (isExist == false)
          vList.addElement(conBean);    //add concept bean to vector     
      }
      data.setConceptList(vList);
    }
    catch (Exception e)
    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
  }
  /**
   * To get the list of attributes selected to display, called from getACKeywordResult and getACShowResult methods.
   * selected attribute values from the multi select list is stored in session vector 'selectedAttr'.
   * "All Attribute" select will add all the fields of the selected component to the vector
   * @param sStatusList String array of status values
   * @param data Concept Form object
   * @return String of comma delimited status values
   *
   */
  private String getStatusValues(String sStatusList[], ConceptForm data)
  {
    String sStatus = "";
    try
    {
      Vector<String> vStatusList = new Vector<String>();
      boolean bAllStatus = false;
      if (sStatusList == null)
         bAllStatus = true;

      if(sStatusList != null)
      {
        //loop through the string array to extract values.
        for(int i = 0; i<sStatusList.length; i++)
        {
          if(sStatusList[i] != null)
          {
            //make one string value to submit
            if (i == 0)
              sStatus = sStatusList[i];
            else
              sStatus = sStatus + "," +  sStatusList[i];
            //set the value and break if all statuses checked
            if (sStatus.equals(ConceptForm.ALL_STATUS))
            {
              bAllStatus = true;
              break;
            }
  
            //store it in vector to refresh list on the page
            vStatusList.addElement(sStatusList[i]);
          }
        }
      }
      if (bAllStatus == true)
      {
        vStatusList = new Vector<String>();
        sStatus = "";
        this.selVerWFStatBlock(data);
      }
      //store it in the data to refresh the list on the page
      data.setSelStatusList(vStatusList);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getStatusValues: " + e);
      logger.fatal("ERROR in GetACSearch-setStatusValues : " + e.toString(), e);
    }
    return sStatus;
  }

  private void selVerWFStatBlock(ConceptForm data)
  {
    try
    {
      //get teh session data from the class form
      Vector<String> vSel = data.getSelAttributeList();
      Vector<String> vDisp = data.getDispAttributeList();
      
      //first get the index of version and add it to vsel
      int iInd = -1;
      if (vDisp.contains("Version"))
        iInd = vDisp.indexOf("Version");
      if (!vSel.contains("Version") && iInd > 0)
        vSel.insertElementAt("Version", iInd);
      //get index of wf status and add it to vsel
      iInd = -1;
      if (vDisp.contains("Workflow Status"))
        iInd = vDisp.indexOf("Workflow Status");
      if (!vSel.contains("Workflow Status") && iInd > 0)
        vSel.insertElementAt("Workflow Status", iInd);
      //store it back in teh data
      data.setSelAttributeList(vSel);
    }
    catch(Exception e)
    {
      logger.fatal("Error - selVerWFStatBlock " + e.toString(), e);
    }
  }

  private String getContextValue(String sContext)
  {
    if (sContext == null || sContext.equals(ConceptForm.ALL_CONTEXT)) 
      sContext = "";
    return sContext;
  }

  /**
   * To insert a new concept from evs to cadsr.
   * Gets all the attribute values from the bean, sets in parameters, and registers output parameter.
   * Calls oracle stored procedure
   *   "{call SBREXT_Set_Row.SET_CONCEPT(?,?,?,?,?,?,?,?,?,?,?)}" to submit
   * @param data ConceptForm object
   *
   * @param sAction Insert or update Action.
   * @param evsBean EVS_Bean.
   *
   * @return String concept idseq from the table.
   */
   public String setConcept(ConceptForm data, EVS_Bean evsBean, String sAction)
   {
     //capture the duration
     java.util.Date startDate = new java.util.Date();          
     //logger.info(m_servlet.getLogMessage(m_classReq, "setConcept", "starting set", startDate, startDate));

     String sReturnCode = "";
     Connection sbr_db_conn = null;
     ResultSet rs = null;
     CallableStatement CStmt = null;
     String conIdseq = "";
     String sEvsSource = "";
     try
     {
         sbr_db_conn = data.getDBConnection();
         if (sbr_db_conn == null || sbr_db_conn.isClosed())
           sbr_db_conn = ConceptServlet.makeDBConnection();
         // Create a Callable Statement object.
         if (sbr_db_conn != null)
         {
           CStmt = sbr_db_conn.prepareCall("{call SBREXT_SET_ROW.SET_CONCEPT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
           // register the Out parameters
           CStmt.registerOutParameter(1,java.sql.Types.VARCHAR);       //return code
           CStmt.registerOutParameter(3,java.sql.Types.VARCHAR);       //con idseq
           CStmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //preferred name
           CStmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //long name
           CStmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //prefered definition
           CStmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //context idseq
           CStmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //version
           CStmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //asl name
           CStmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //latest version ind
           CStmt.registerOutParameter(11,java.sql.Types.VARCHAR);       //change note
           CStmt.registerOutParameter(12,java.sql.Types.VARCHAR);       //origin
           CStmt.registerOutParameter(13,java.sql.Types.VARCHAR);       //definition source
           CStmt.registerOutParameter(14,java.sql.Types.VARCHAR);       //evs source
           CStmt.registerOutParameter(15,java.sql.Types.VARCHAR);       //begin date
           CStmt.registerOutParameter(16,java.sql.Types.VARCHAR);       //end date
           CStmt.registerOutParameter(17,java.sql.Types.VARCHAR);       //date created
           CStmt.registerOutParameter(18,java.sql.Types.VARCHAR);       //created by
           CStmt.registerOutParameter(19,java.sql.Types.VARCHAR);       //date modified
           CStmt.registerOutParameter(20,java.sql.Types.VARCHAR);       //modified by
           CStmt.registerOutParameter(21,java.sql.Types.VARCHAR);       //deleted ind

           //truncate the definition to be 2000 long.
         //  if (sDef == null) sDef = "";
         //  if (sDef.length() > 2000) sDef = sDef.substring(0, 2000);
           // Set the In parameters (which are inherited from the PreparedStatement class)
           CStmt.setString(2, sAction);
           CStmt.setString(4, evsBean.getCONCEPT_IDENTIFIER());
           //make sure that :: is removed from the long name and defintion
           String sName = evsBean.getLONG_NAME();
           String sDef = evsBean.getPREFERRED_DEFINITION();
           int nvpInd = sName.indexOf("::");
           if (nvpInd > 0)
             sName = sName.substring(0, nvpInd);  
           nvpInd = sDef.indexOf("::");
           if (nvpInd > 0)
             sDef = sDef.substring(0, nvpInd);  
           CStmt.setString(5, sName);
           CStmt.setString(6, sDef);
         //  CStmt.setString(7, evsBean.getCONTE_IDSEQ());  caBIG by default
           CStmt.setString(8, "1.0");
           CStmt.setString(9, "RELEASED");
           CStmt.setString(10, "Yes");
           CStmt.setString(12, evsBean.getEVS_DATABASE());
           CStmt.setString(13, evsBean.getEVS_DEF_SOURCE());
           CStmt.setString(14, evsBean.getNCI_CC_TYPE());
            // Now we are ready to call the stored procedure
           //logger.info("setConcept " + evsBean.getCONCEPT_IDENTIFIER());     

           boolean bExcuteOk = CStmt.execute();
           sReturnCode = CStmt.getString(1);
           conIdseq = CStmt.getString(3);
           evsBean.setIDSEQ(conIdseq);
           if (sReturnCode != null)
           {
             data.setStatusMsg("\\t " + sReturnCode + " : Unable to update Concept attributes - " 
                 + evsBean.getCONCEPT_IDENTIFIER() + ": " + evsBean.getLONG_NAME() + ".");
             //m_classReq.setAttribute("retcode", sReturnCode);      //store returncode in request to track it all through this request    
           }
         }
       //capture the duration
       //logger.info(m_servlet.getLogMessage(m_classReq, "setConcept", "end set", startDate, new java.util.Date()));
     }
     catch(Exception e)
     {
       logger.fatal("ERROR in setConcept for other : " + e.toString(), e);
       //m_classReq.setAttribute("retcode", "Exception");
       sReturnCode = "Exception";
       data.setStatusMsg("\\t Exception : Unable to update Concept attributes.");
     }
     try
     {
       if(rs!=null) rs.close();
       if(CStmt!=null) CStmt.close();
       if (data.getDBConnection() == null)
         ConceptServlet.closeDBConnection(sbr_db_conn);
     }
     catch(Exception ee)
     {
       logger.fatal("ERROR in setConcept for close : " + ee.toString(), ee);
       //m_classReq.setAttribute("retcode", "Exception");
       sReturnCode = "Exception";
       data.setStatusMsg("\\t Exception : Unable to update Concept attributes.");
     }
     return conIdseq;
   }  //end concept

   /**
    * Called to get all the concepts from condr_idseq.
    * Sets in parameters, and registers output parameters and vector of evs bean.
    * Calls oracle stored procedure
    *   "{call SBREXT_CDE_CURATOR_PKG.GET_AC_CONCEPTS(?,?)}" to submit
   * @param condrID String condr idseq
   * @param data ConceptForm object
   * @return Vector vector of evs bean.
  */
  public Vector<EVS_Bean> getAC_Concepts(String condrID, ConceptForm data)
  {
//System.out.println("in getAC_Concepts condrID: " + condrID);
    Connection sbr_db_conn = null;
    CallableStatement CStmt = null;
    ResultSet rs = null;
  //  String sCON_IDSEQ = "";
    Vector<EVS_Bean> vList = new Vector<EVS_Bean>();
    try
    {
      sbr_db_conn = data.getDBConnection();
      if (sbr_db_conn == null || sbr_db_conn.isClosed())
        sbr_db_conn = ConceptServlet.makeDBConnection();
      // Create a Callable Statement object.
      if (sbr_db_conn != null)
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_AC_CONCEPTS(?,?)}");
        //out parameter
        CStmt.registerOutParameter(2, OracleTypes.CURSOR);       //return cursor
        //in parameter
        CStmt.setString(1, condrID);       // condr idseq
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
            EVS_Bean eBean = new EVS_Bean();
            eBean.setIDSEQ(rs.getString("CON_IDSEQ"));
            eBean.setDISPLAY_ORDER(rs.getString("DISPLAY_ORDER"));
            eBean.setPRIMARY_FLAG(rs.getString("primary_flag_ind"));
            eBean.setCONCEPT_IDENTIFIER(rs.getString("preferred_name"));
            eBean.setLONG_NAME(rs.getString("long_name"));
       //     eBean.setDESCRIPTION(rs.getString("preferred_definition"));
            eBean.setPREFERRED_DEFINITION(rs.getString("preferred_definition"));
            eBean.setEVS_DATABASE(rs.getString("origin"));
            eBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
            eBean.setNCI_CC_TYPE(rs.getString("evs_source"));
            eBean.setNVP_CONCEPT_VALUE(rs.getString("CONCEPT_VALUE"));
            if (!eBean.getNVP_CONCEPT_VALUE().equals(""))
            {
              eBean.setLONG_NAME(eBean.getLONG_NAME() + "::" + eBean.getNVP_CONCEPT_VALUE());
              eBean.setPREFERRED_DEFINITION(eBean.getPREFERRED_DEFINITION() + "::" + eBean.getNVP_CONCEPT_VALUE());
            }
            eBean.setCONDR_IDSEQ(condrID);
            eBean.setCON_AC_SUBMIT_ACTION("NONE");
            if(rs.getString("origin") != null && rs.getString("origin").equals("NCI Metathesaurus"))
            {
              String sParent = rs.getString("long_name");
              String sCui = rs.getString("preferred_name");
              if(sParent == null) sParent = "";
              String sParentSource = "";
              //sParentSource = serAC.getMetaParentSource(sParent, sCui, vd);
              if(sParentSource == null) sParentSource = "";
              eBean.setEVS_CONCEPT_SOURCE(sParentSource);
            }
         System.out.println(eBean.getCONCEPT_IDENTIFIER() + eBean.getLONG_NAME());
            if (data.getRequest() != null)
              eBean.markNVPConcept(eBean, data.getRequest().getSession());

            if (eBean.getIDSEQ() != null && !eBean.getIDSEQ().equals(""))
              vList.addElement(eBean);
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in getACConcepts for exception : " + e.toString(), e);
      //System.out.println("get ac concept other " + e);
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if (data.getDBConnection() == null)
        ConceptServlet.closeDBConnection(sbr_db_conn);
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR in getACConcept for close : " + ee.toString(), ee);
    }
    return vList;
  } //end get concept
  

}
