/*L
 * Copyright ScenPro Inc, SAIC-F
 *
 * Distributed under the OSI-approved BSD 3-Clause License.
 * See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
 */

// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/ConceptAction.java,v 1.22 2009-02-10 19:15:26 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.database.SQLHelper;
import gov.nih.nci.cadsr.cdecurate.util.DataManager;
import gov.nih.nci.cadsr.common.PropertyHelper;

import java.io.Serializable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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

//other public methods  
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
    
    ResultSet rs = null;
    CallableStatement cstmt = null;
    try
    {
      //get the connection from data if exists (used for testing)
      UtilService util = data.getUtil();
      // Create a Callable Statement object.
      if (data.getCurationServlet().getConn() != null)
    	  
      {
          //get the data for the call
        cstmt = data.getCurationServlet().getConn().prepareCall("{call SBREXT.SBREXT_CDE_CURATOR_PKG.SEARCH_CON(?,?,?,?,?,?,?,?,?)}");
        cstmt.registerOutParameter(6, OracleTypes.CURSOR);
        cstmt.setString(1, util.parsedStringSingleQuoteOracle(data.getSearchTerm()));
        cstmt.setString(2, getStatusValues(data.getASLNameList(), data));
        cstmt.setString(3, getContextValue(data.getContextName()));
        cstmt.setString(4, data.getConID());
        cstmt.setString(5, data.getConIDSEQ());
        cstmt.setString(7, data.getDecIDseq());
        cstmt.setString(8, data.getVdIDseq());
        cstmt.setString(9, data.getSearchDefn());
       // Now we are ready to call the stored procedure
        cstmt.execute();   
        //store the output in the resultset
        rs = (ResultSet) cstmt.getObject(6);
        //capture the duration
      //  logger.info(m_servlet.getLogMessage(m_classReq, "do_ConceptSearch", "got rsObject", exDate, new java.util.Date()));
        if(rs!=null)
        {
          EVS_UserBean eUser = data.getEvsUser();
          String sAction = data.getACAction();
          Vector<EVS_Bean> vList = new Vector<EVS_Bean>();
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
            String selVocab = conBean.getVocabAttr(eUser, sVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
            //store evs vocab name in evs origin and leave meta out
            if (selVocab.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
              conBean.setEVS_ORIGIN(sVocab);
            else conBean.setEVS_ORIGIN(selVocab);
            
            conBean.setID(rs.getString("con_ID"));//public id
            String rsV = rs.getString("version");
            if (rsV == null)
                rsV = "";
            if (rsV.indexOf('.') >= 0)
              conBean.setVERSION(rsV);
            else
              conBean.setVERSION(rsV + ".0");
            conBean.setCONTEXT_NAME(rs.getString("context"));
            conBean.setDEC_USING("");
            String sPref = util.removeNewLineChar(rs.getString("preferred_name"));
            conBean.setCONCEPT_IDENTIFIER(sPref);  //cui
            conBean.setNCI_CC_TYPE(rs.getString("evs_source"));
            if (data.getRequest() != null)
              conBean.markNVPConcept(conBean, data.getRequest().getSession());
            // add concept bean to vector 
            vList.addElement(conBean);        
          }
          data.setConceptList(vList);
        }   //END IF
      }
    }
    catch(Exception e)
    {
      logger.error("ERROR - doconceptSearch for other : ", e);
      data.setStatusMsg("Error : Unable to do concept search." + e.toString());
      data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
    }finally{
    	rs = SQLHelper.closeResultSet(rs);
        cstmt = SQLHelper.closeCallableStatement(cstmt);
    }    
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
    if (!conArray.equals(""))
    {
      ResultSet rs = null;
      Statement stmt = null;
      try
      {
       // Create a Callable Statement object.
        if (data.getCurationServlet().getConn() != null)
        {
          stmt = data.getCurationServlet().getConn().createStatement();
          rs = stmt.executeQuery("select SBREXT_COMMON_ROUTINES.CHECK_DERIVATION_EXISTS('" + conArray + "') from DUAL");
          //loop through to printout the outstrings
          while(rs.next())
          {
            condr = rs.getString(1);
            if (condr == null) condr = "";
          }
        }
      }
      catch(Exception e)
      {
        logger.error("ERROR - doconceptSearch for other : ", e);
        data.setStatusMsg("Error : Unable to do concept search." + e.toString());
        data.setActionStatus(ConceptForm.ACTION_STATUS_FAIL);
      }finally{
      	rs = SQLHelper.closeResultSet(rs);
        stmt = SQLHelper.closeStatement(stmt);
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
    try
    {
        String errMsg = "";
        for (int i=0; i<conList.size(); i++)
        {
          EVS_Bean con = (EVS_Bean)conList.elementAt(i);
          if (con == null) con = new EVS_Bean();
          String conIDseq = con.getIDSEQ();
          if (conIDseq == null || conIDseq.equals(""))  //add conidseq        
          {
              //create it in the database at submit only
            if (isCreate)
            {
              //System.out.println("create new concept");
              String sret = this.setConcept(data, con, ConceptForm.CADSR_ACTION_INS);
              if (!sret.equals(""))
              {
                logger.error("ERROR concept create " + sret);
                errMsg += "\\n" + sret;
              }
            }
            else   //at validation return empty for new concept
              return "";
          }
          conIDseq = con.getIDSEQ();
          if (!conIDseq.equals(""))
          {
            if (!conArray.equals(""))  //add comma
              conArray += ",";
            //get the nvp value if exists or not the last one (primary)
            String nvp = con.getNVP_CONCEPT_VALUE();
            if (!nvp.equals("") && i < conList.size()-1)
              conIDseq += ":" + nvp;
            //make an array
            conArray += conIDseq; 
            //System.out.println(con.getLONG_NAME() + " conarray " + conArray);
          }
        }
        if (!errMsg.equals(""))
          data.setStatusMsg(errMsg);
    }
    catch (Exception e)
    {
        logger.error("ERROR - getConArray : ", e);
    }

    return conArray;
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
     String sMsg = "";
     ResultSet rs = null;
     CallableStatement cstmt = null;
     //Get the username from the session.
     String userName = (String)data.getCurationServlet().sessionData.UsrBean.getUsername();
     try
     {
         // Create a Callable Statement object.
         if (data.getCurationServlet().getConn() != null)
         {
           //cstmt = conn.prepareCall("{call SBREXT_SET_ROW.SET_CONCEPT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
           cstmt = data.getCurationServlet().getConn().prepareCall("{call SBREXT_SET_ROW.SET_CONCEPT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");		//GF32649
           // register the Out parameters
           cstmt.registerOutParameter(2,java.sql.Types.VARCHAR);       //return code
           cstmt.registerOutParameter(4,java.sql.Types.VARCHAR);       //con idseq
           cstmt.registerOutParameter(5,java.sql.Types.VARCHAR);       //preferred name
           cstmt.registerOutParameter(6,java.sql.Types.VARCHAR);       //long name
           cstmt.registerOutParameter(7,java.sql.Types.VARCHAR);       //prefered definition
           cstmt.registerOutParameter(8,java.sql.Types.VARCHAR);       //context idseq
           cstmt.registerOutParameter(9,java.sql.Types.VARCHAR);       //version
           cstmt.registerOutParameter(10,java.sql.Types.VARCHAR);       //asl name
           cstmt.registerOutParameter(11,java.sql.Types.VARCHAR);       //latest version ind
           cstmt.registerOutParameter(12,java.sql.Types.VARCHAR);       //change note
           cstmt.registerOutParameter(13,java.sql.Types.VARCHAR);       //origin
           cstmt.registerOutParameter(14,java.sql.Types.VARCHAR);       //definition source
           cstmt.registerOutParameter(15,java.sql.Types.VARCHAR);       //evs source
           cstmt.registerOutParameter(16,java.sql.Types.VARCHAR);       //begin date
           cstmt.registerOutParameter(17,java.sql.Types.VARCHAR);       //end date
           cstmt.registerOutParameter(18,java.sql.Types.VARCHAR);       //date created
           cstmt.registerOutParameter(19,java.sql.Types.VARCHAR);       //created by
           cstmt.registerOutParameter(20,java.sql.Types.VARCHAR);       //date modified
           cstmt.registerOutParameter(21,java.sql.Types.VARCHAR);       //modified by
           cstmt.registerOutParameter(22,java.sql.Types.VARCHAR);       //deleted ind

           
           //set the userid
            cstmt.setString(1, userName);
           //truncate the definition to be 2000 long.
           //  if (sDef == null) sDef = "";
           //  if (sDef.length() > 2000) sDef = sDef.substring(0, 2000);
           // Set the In parameters (which are inherited from the PreparedStatement class)
           cstmt.setString(3, sAction);
           cstmt.setString(5, evsBean.getCONCEPT_IDENTIFIER());
           //make sure that :: is removed from the long name and defintion
           String sName = evsBean.getLONG_NAME();
           String sDef = evsBean.getPREFERRED_DEFINITION();
           int nvpInd = sName.indexOf("::");
           if (nvpInd > 0)
             sName = sName.substring(0, nvpInd);  
           nvpInd = sDef.indexOf("::");
           if (nvpInd > 0)
             sDef = sDef.substring(0, nvpInd);  
           cstmt.setString(6, sName);
           cstmt.setString(7, sDef);
           cstmt.setString(9, "1.0");
           cstmt.setString(10, "RELEASED");
           cstmt.setString(11, "Yes");
           cstmt.setString(13, evsBean.getEVS_DATABASE());
           cstmt.setString(14, evsBean.getEVS_DEF_SOURCE());
           cstmt.setString(15, evsBean.getNCI_CC_TYPE());
            // Now we are ready to call the stored procedure
           cstmt.setString(23, PropertyHelper.getDefaultContextName());		//GF32649
           cstmt.execute();
           String sReturnCode = cstmt.getString(2);
           String conIdseq = cstmt.getString(4);
           if (conIdseq == null) conIdseq = "";
           evsBean.setIDSEQ(conIdseq);
           if (sReturnCode != null)
           {
             sMsg += "\\t " + sReturnCode + " : Unable to update Concept attributes - " 
                 + evsBean.getCONCEPT_IDENTIFIER() + ": " + evsBean.getLONG_NAME() + ".";
           }
         }
     }
     catch(Exception e)
     {
       logger.error("ERROR in setConcept for other : " + e.toString(), e);
       sMsg += "\\t Exception : Unable to update Concept attributes.";
     }finally{
    	 rs = SQLHelper.closeResultSet(rs);
         cstmt = SQLHelper.closeCallableStatement(cstmt);
         }
      return sMsg;
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
    CallableStatement cstmt = null;
    ResultSet rs = null;
    Vector<EVS_Bean> vList = new Vector<EVS_Bean>();
    try
    {
      // Create a Callable Statement object.
      if (data.getDBConnection() != null)
      {
        cstmt =data.getDBConnection().prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_AC_CONCEPTS(?,?)}");
        //out parameter
        cstmt.registerOutParameter(2, OracleTypes.CURSOR);       //return cursor
        //in parameter
        cstmt.setString(1, condrID);       // condr idseq
         // Now we are ready to call the stored procedure
        cstmt.execute();
        //store the output in the resultset
        rs = (ResultSet) cstmt.getObject(2);
        //String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            EVS_Bean eBean = new EVS_Bean();
            eBean.setIDSEQ(rs.getString("CON_IDSEQ"));
            eBean.setDISPLAY_ORDER(rs.getString("DISPLAY_ORDER"));
            String sPrim = rs.getString("primary_flag_ind");
            if (sPrim != null && sPrim.equals("Yes"))
              eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_PRIMARY);
            else 
              eBean.setPRIMARY_FLAG(ConceptForm.CONCEPT_QUALIFIER);
            eBean.setCONCEPT_IDENTIFIER(rs.getString("preferred_name"));
            eBean.setLONG_NAME(rs.getString("long_name"));
            eBean.setPREFERRED_DEFINITION(rs.getString("preferred_definition"));
            eBean.setEVS_DATABASE(rs.getString("origin"));
            eBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
            eBean.setNCI_CC_TYPE(rs.getString("evs_source"));
            String nvp = rs.getString("CONCEPT_VALUE");
            if (nvp == null) nvp = "";
            eBean.setNVP_CONCEPT_VALUE(nvp);
            //append the name value pair to long name and definition of the AC that uses this concept
            if (!nvp.equals(""))
            {
              eBean.setLONG_NAME(eBean.getLONG_NAME() + "::" + nvp);
              eBean.setPREFERRED_DEFINITION(eBean.getPREFERRED_DEFINITION() + "::" + nvp);
            }
            eBean.setCONDR_IDSEQ(condrID);
            eBean.setCON_AC_SUBMIT_ACTION("NONE");
/*            String sOrg = rs.getString("origin");
            if(sOrg != null && sOrg.equals("NCI Metathesaurus"))
            {
              String sParent = rs.getString("long_name");
              //String sCui = rs.getString("preferred_name");
              if(sParent == null) sParent = "";
              String sParentSource = "";
              //sParentSource = serAC.getMetaParentSource(sParent, sCui, vd);
              if(sParentSource == null) sParentSource = "";
              eBean.setEVS_CONCEPT_SOURCE(sParentSource);
            }
*/            if (data.getRequest() != null)
              eBean.markNVPConcept(eBean, data.getRequest().getSession());

            if (!eBean.getIDSEQ().equals(""))
              vList.addElement(eBean);
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.error("ERROR in getACConcepts for exception : " + e.toString(), e);
    }finally{
    	rs = SQLHelper.closeResultSet(rs);
        cstmt = SQLHelper.closeCallableStatement(cstmt);
    }
    return vList;
  } //end get concept
  
  /**to append the concepts from the concept search results to vm bean
   * @param selRow String selected row
   * @param vRSel Vector of EVS bean object of the search resutls
   * @param sNVP string user entered value
   * @param data PVForm object
   * @return EVS_Bean selected concept
   */
  public EVS_Bean getSelectedConcept(int selRow, Vector<EVS_Bean> vRSel, String sNVP, ConceptForm data)
  {
      EVS_Bean eBean = null;
      try
      {
        String errMsg = "";
        eBean = (EVS_Bean)vRSel.elementAt(selRow);
        //send it back if unable to obtion the concept
        if (eBean == null || eBean.getLONG_NAME() == null)
        {
          errMsg += "Unable to obtain concept from the " + selRow + " row of the search results.\\n" + 
              "Please try again.";
          logger.error("ERROR - getSelectedConcept " + errMsg);
          data.setStatusMsg(errMsg);
          return null;
        }
        //get the thesaurus concept if not //TODO- this needs fixing to not use request and response
        String prefVocab = "";
        EVS_UserBean eUser = data.getEvsUser();
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
        if (sNVP != null && !sNVP.equals(""))
        {
          eBean.setNVP_CONCEPT_VALUE(sNVP);
          eBean.setLONG_NAME(eBean.getLONG_NAME() + "::" + sNVP);
          eBean.setPREFERRED_DEFINITION(eBean.getPREFERRED_DEFINITION() + "::" + sNVP);
        }
      }
      catch (Exception e)
      {
        logger.error("ERROR - getSelectedConcept : ", e);
      }
      return eBean;
  }

  /**gets the existing caDSR concept for the selected concept
   * @param eBean EVS_Bean object
   * @param eUser EVS_UserBean object
   * @param data PVForm object
   * @return EVS_Bean object existed in caDSR
   */
  public EVS_Bean getCaDSRConcept(EVS_Bean eBean, EVS_UserBean eUser, ConceptForm data)
  {
    String errMsg = "";
    data.setSearchTerm(eBean.getCONCEPT_IDENTIFIER());
    data.setEvsUser(eUser);
    //call hte action
    doConceptSearch(data);
    //get the bean from teh vector
    Vector vCon = data.getConceptList();
    if (vCon != null && vCon.size() > 0)
    {
      if (vCon.size() > 1)
         errMsg += "Multiple concepts with same concept ID exists.";
      String unMatchName = "";
      String unMatchDef = "";
      boolean matchFound = false;
      String eN = eBean.getLONG_NAME();
      String eD = eBean.getPREFERRED_DEFINITION();
      String eID = eBean.getCONCEPT_IDENTIFIER();
      for (int i = 0; i<vCon.size(); i++)
      {
        EVS_Bean cBean = (EVS_Bean)vCon.elementAt(i);
        String cN = cBean.getLONG_NAME();
        String cD = cBean.getPREFERRED_DEFINITION();
        if (cN.equalsIgnoreCase(eN) && cD.equalsIgnoreCase(eD))
        {
          eBean = (EVS_Bean)vCon.elementAt(i);
          matchFound = true;
          break;
        }
        //all other cases continue withe the logic
        if (!cN.equalsIgnoreCase(eN))
        {
          if (!unMatchName.equals("")) unMatchName += ", ";
          unMatchName += cN;
        }
        if (!cD.equalsIgnoreCase(eD))
        {
          //check if the difference is only the period
          if ((cD.length() == eD.length() + 1 && cD.lastIndexOf('.') > 0) || (eD.length() == cD.length() + 1 && eD.lastIndexOf('.') > 0))
              continue;
              
          if (!unMatchDef.equals("")) unMatchDef += ", ";
          unMatchDef += cD;   
        }       
      }
      //handle the scenario when concept is different from teh selected one
      if (!matchFound)
      {
        if (!unMatchName.equals(""))
          errMsg += "The selected concept's [" + eID + "] name from EVS does not match the name from caDSR. " + 
                      " The name from caDSR will be used for the selected concept.\\n" +
                      "\\t EVS: " + eN + "\\n\\t caDSR: " + unMatchName + "\\n";
        if (!unMatchDef.equals(""))
          errMsg += "The selected concept's [" + eID + "] definition from EVS does not match the definition from caDSR." + 
                      " The definition from caDSR will be used for the selected concept.\\n" +
                      "\\t EVS: " + eD + "\\n\\t caDSR: " + unMatchDef + "\\n";
        //log the error
        if (!errMsg.equals(""))
        {
            data.setStatusMsg(data.getStatusMsg() + errMsg);
            logger.error("ERROR in getCaDSRConcept - " + errMsg);
        }
        //take the first one and move on
        eBean = (EVS_Bean)vCon.elementAt(0);  
      }
    }
    return eBean;
  }


//private methods
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
      else
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
      if (bAllStatus)
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
      logger.error("ERROR in ERROR -setStatusValues : " + e.toString(), e);
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
      logger.error("Error - selVerWFStatBlock " + e.toString(), e);
    }
  }

  private String getContextValue(String sContext)
  {
    if (sContext == null || sContext.equals(ConceptForm.ALL_CONTEXT)) 
      sContext = "";
    return sContext;
  }
  
  /**
 * @param rs
 * @param data
 */
public void getApprovedRepTermConcepts(ResultSet rs,ConceptForm data)
  {
	  Vector<EVS_Bean> vList = new Vector<EVS_Bean>();   
	  UtilService util = data.getUtil();  
	  try {
		if(rs!=null)
		  {
		    EVS_UserBean eUser = data.getEvsUser();
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
		      conBean.setEVS_DATABASE("caDSR");
		      conBean.setcaDSR_COMPONENT("Concept Class"); 
		      String selVocab = conBean.getVocabAttr(eUser, sVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
		      //store evs vocab name in evs origin and leave meta out
		      if (selVocab.equals(EVSSearch.META_VALUE))  // "MetaValue")) 
		        conBean.setEVS_ORIGIN(sVocab);
		      else conBean.setEVS_ORIGIN(selVocab);
		      
		      conBean.setID(rs.getString("con_ID"));//public id
		      String rsV = rs.getString("version");
		      if (rsV == null)
		          rsV = "";
		      if (rsV.indexOf('.') >= 0)
		        conBean.setVERSION(rsV);
		      else
		        conBean.setVERSION(rsV + ".0");
		      conBean.setCONTEXT_NAME(rs.getString("context"));
		      conBean.setDEC_USING("");
		      String sPref = util.removeNewLineChar(rs.getString("preferred_name"));
		      conBean.setCONCEPT_IDENTIFIER(sPref);  //cui
		      conBean.setNCI_CC_TYPE(rs.getString("evs_source"));
		      if (data.getRequest() != null)
		       conBean.markNVPConcept(conBean, data.getRequest().getSession()); 
		      // add concept bean to vector 
		      vList.addElement(conBean);        
		    }
		 }
		
	} catch (SQLException e) {
		 logger.error("Error - getApprovedRepTermConcepts " + e.toString(), e);
	}
	data.setConceptList(vList);
   // return vList;
  }	  
  
//end of class  
}
