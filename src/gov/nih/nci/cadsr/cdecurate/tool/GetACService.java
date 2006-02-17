// Copyright (c) 2000 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/GetACService.java,v 1.3 2006-02-17 21:36:09 hardingr Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.util.*;
import java.sql.*;
import java.math.*;
import oracle.jdbc.driver.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

import org.apache.log4j.*;

/**
 * GetACService class retrieves list from the db and stores them in session vectors
 * <P>
 * @author Joe Zhou, Sumana Hegde, Tom Phillips
 * @version 3.0
 *
 */

 /*
The CaCORE Software License, Version 3.0 Copyright 2002-2005 ScenPro, Inc. (“ScenPro”)  
Copyright Notice.  The software subject to this notice and license includes both
human readable source code form and machine readable, binary, object code form
(“the CaCORE Software”).  The CaCORE Software was developed in conjunction with
the National Cancer Institute (“NCI”) by NCI employees and employees of SCENPRO.
To the extent government employees are authors, any rights in such works shall
be subject to Title 17 of the United States Code, section 105.    
This CaCORE Software License (the “License”) is between NCI and You.  “You (or “Your”)
shall mean a person or an entity, and all other entities that control, are 
controlled by, or are under common control with the entity.  “Control” for purposes
of this definition means (i) the direct or indirect power to cause the direction
or management of such entity, whether by contract or otherwise, or (ii) ownership
of fifty percent (50%) or more of the outstanding shares, or (iii) beneficial 
ownership of such entity.  
This License is granted provided that You agree to the conditions described below.
NCI grants You a non-exclusive, worldwide, perpetual, fully-paid-up, no-charge,
irrevocable, transferable and royalty-free right and license in its rights in the
CaCORE Software to (i) use, install, access, operate, execute, copy, modify, 
translate, market, publicly display, publicly perform, and prepare derivative 
works of the CaCORE Software; (ii) distribute and have distributed to and by 
third parties the CaCORE Software and any modifications and derivative works 
thereof; and (iii) sublicense the foregoing rights set out in (i) and (ii) to 
third parties, including the right to license such rights to further third parties.
For sake of clarity, and not by way of limitation, NCI shall have no right of 
accounting or right of payment from You or Your sublicensees for the rights 
granted under this License.  This License is granted at no charge to You.
1.	Your redistributions of the source code for the Software must retain the above
copyright notice, this list of conditions and the disclaimer and limitation of
liability of Article 6, below.  Your redistributions in object code form must
reproduce the above copyright notice, this list of conditions and the disclaimer
of Article 6 in the documentation and/or other materials provided with the 
distribution, if any.
2.	Your end-user documentation included with the redistribution, if any, must 
include the following acknowledgment: “This product includes software developed 
by SCENPRO and the National Cancer Institute.”  If You do not include such end-user
documentation, You shall include this acknowledgment in the Software itself, 
wherever such third-party acknowledgments normally appear.
3.	You may not use the names "The National Cancer Institute", "NCI" “ScenPro, Inc.”
and "SCENPRO" to endorse or promote products derived from this Software.  
This License does not authorize You to use any trademarks, service marks, trade names,
logos or product names of either NCI or SCENPRO, except as required to comply with
the terms of this License.
4.	For sake of clarity, and not by way of limitation, You may incorporate this
Software into Your proprietary programs and into any third party proprietary 
programs.  However, if You incorporate the Software into third party proprietary
programs, You agree that You are solely responsible for obtaining any permission
from such third parties required to incorporate the Software into such third party
proprietary programs and for informing Your sublicensees, including without 
limitation Your end-users, of their obligation to secure any required permissions
from such third parties before incorporating the Software into such third party
proprietary software programs.  In the event that You fail to obtain such permissions,
You agree to indemnify NCI for any claims against NCI by such third parties, 
except to the extent prohibited by law, resulting from Your failure to obtain
such permissions.
5.	For sake of clarity, and not by way of limitation, You may add Your own 
copyright statement to Your modifications and to the derivative works, and You 
may provide additional or different license terms and conditions in Your sublicenses
of modifications of the Software, or any derivative works of the Software as a 
whole, provided Your use, reproduction, and distribution of the Work otherwise 
complies with the conditions stated in this License.
6.	THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES,
(INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED.  
IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE, SCENPRO, OR THEIR AFFILIATES 
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class GetACService implements Serializable
{
  /**
   * 
   */
  private static final long serialVersionUID = 6486668887681006373L;
  //Connection m_sbr_db_conn = null;
  NCICurationServlet m_servlet;
  UtilService m_util = new UtilService();
  HttpServletRequest m_classReq = null;
  HttpServletResponse m_classRes = null;
  Logger logger = Logger.getLogger(GetACService.class.getName());

  /**
   * Constructor
  */
  public GetACService(HttpServletRequest req, HttpServletResponse res,
          NCICurationServlet CurationServlet)
  {
    m_classReq = req;
    m_classRes = res;
    m_servlet = CurationServlet;
  }

  /**
  * The getACValueMeaningList method queries the db for various lists the program needs to
  * dropdown selection boxes. The lists are stored as session vectors.
  *
  * @param req The HttpServletRequest from the client
  * @param res The HttpServletResponse back to the client
  *
  */
  public void getACValueMeaningList(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vsm;
      Vector vsd;
      if(session.getAttribute("vPVM") == null)
      {
        vsm = new Vector(); // short meanings
        vsd = new Vector(); // short meanings
        //getValueMeaningsList("", vsm, vsd);    //get the Permissable Values list
        session.setAttribute("vPVM", vsm);  //set ValueMeanings name attribute
        session.setAttribute("vMeanDesc", vsd);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACService-getACValueMeaningList: " + e);
      logger.fatal("ERROR in GetACService-getACValueMeaningList : " + e.toString());
    }
  }  // end of getACValueMeaningList

  /**
  * The getACList method queries the db for various lists the program needs to
  * dropdown selection boxes. The lists are stored as session vectors.
  *
  * @param req The HttpServletRequest from the client
  * @param res The HttpServletResponse back to the client
  * @param sContext String context.
  * @param bNewContext Boolean indicating whether context is new.
  * @param sACType The type of page being called, i.e. de, dec, or vd
   * @throws IOException 
   * @throws ServletException 
  *
  */
  public void getACList(HttpServletRequest req, HttpServletResponse res,
         String sContext, boolean bNewContext, String sACType)
         throws IOException, ServletException
  {
	  Connection m_sbr_db_conn = null;
    try
    {
      //capture the duration
      java.util.Date startDate = new java.util.Date();          
    //  logger.info(m_servlet.getLogMessage(req, "getACList", "started", startDate, startDate));

      HttpSession session = req.getSession();
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn != null)
      {
          session.setAttribute("ConnectedToDB", "Yes");
          Vector v, v2, vpv, vsm, vID;
          boolean bDE = sACType.equals("de");
          boolean bDEC = sACType.equals("dec");
          boolean bVD = sACType.equals("vd");
          if (sACType.equals("ALL"))
          {
            bDE = true;
            bDEC = true;
            bVD = true;
          }
          session.setAttribute("ContextInList", sContext);
          //get cs-csi relationship data
          getCSCSIListBean();
          Vector vCon = (Vector)session.getAttribute("vContext");
          if(vCon == null || vCon.size() < 2)
          {
            v = new Vector();
            vID = new Vector();
            getContextList(vID, v);    //get the context list
            session.setAttribute("vContext", v);  //set context list attribute
            session.setAttribute("vContext_ID", vID);  //set context list attribute
          }
          if(session.getAttribute("vWriteContextDE") == null)
          {
            String sUser = (String)session.getAttribute("Username");
            v = new Vector();
            vID = new Vector();
            getWriteContextList(vID, v, sUser, "DATAELEMENT");    //get the context list
            session.setAttribute("vWriteContextDE", v);  //set context list attribute
            session.setAttribute("vWriteContextDE_ID", vID);  //set context list attribute

            v = new Vector();
            vID = new Vector();
            getWriteContextList(vID, v, sUser, "DE_CONCEPT");    //get the context list
            session.setAttribute("vWriteContextDEC", v);  //set context list attribute
            session.setAttribute("vWriteContextDEC_ID", vID);  //set context list attribute
            v = new Vector();
            vID = new Vector();
            getWriteContextList(vID, v, sUser, "VALUEDOMAIN");    //get the context list
            session.setAttribute("vWriteContextVD", v);  //set context list attribute
            session.setAttribute("vWriteContextVD_ID", vID);  //set context list attribute
          }

          if(session.getAttribute("vUsers") == null)
          {
            v = new Vector();
            vID = new Vector();
            getUserList(vID, v);    //get the User list
            session.setAttribute("vUsers", vID);  //set User list attribute
            session.setAttribute("vUsersName", v);  //set User list attribute
          }
          if(session.getAttribute("vStatusALL") == null)
          {
            v = new Vector();
            getStatusList("", v);    //get the Workflow status list
            session.setAttribute("vStatusALL", v);  //set Workflow status list attribute
          }

          if(session.getAttribute("vStatusDE") == null)
          {
            v = new Vector();
            getStatusList("DATAELEMENT", v);    //get the DE Workflow status list
            session.setAttribute("vStatusDE", v);  //set Workflow status list attribute
          }

          if(session.getAttribute("vStatusDEC") == null)
          {
            v = new Vector();
            getStatusList("DE_CONCEPT", v);    //get the DEC Workflow status list
            session.setAttribute("vStatusDEC", v);  //set Workflow status list attribute
          }
          if(session.getAttribute("vStatusVD") == null)
          {
            v = new Vector();
            getStatusList("VALUEDOMAIN", v);    //get the VD Workflow status list
            session.setAttribute("vStatusVD", v);  //set Workflow status list attribute
          }

          if(session.getAttribute("vStatusCD") == null)
          {
            v = new Vector();
            getStatusList("CONCEPTUALDOMAIN", v);    //get the Workflow status list
            session.setAttribute("vStatusCD", v);  //set Workflow status list attribute
          }

          if(session.getAttribute("vLanguage") == null)
          {
            v = new Vector();
            getLanguageList(v);    //get the Language list
            session.setAttribute("vLanguage", v);  //set Language list attribute
          }
          if(session.getAttribute("vSource") == null)
          {
             v = new Vector();
             getSourceList(v);    //get the Source list
             session.setAttribute("vSource", v);  //set Source list attribute
          }

          if(session.getAttribute("vRegStatus") == null)
          {
             v = new Vector();
             getRegStatusList(v);    //get the Registration list
             session.setAttribute("vRegStatus", v);  //set Registration list attribute
          }
          //list of ref documents used in the search
          if(session.getAttribute("vRDocType") == null)
          {
              v = new Vector();
              this.getRDocTypesList(v);    //get the Reference Document List
              session.setAttribute("vRDocType", v);  //set Reference Document list attribute
          } 
          if((session.getAttribute("vCS") == null && sContext != null) || bNewContext)
          {
              v = new Vector();
              vID = new Vector();
              getCSList(vID, v, sContext);    //get the classification scheme list
              session.setAttribute("vCS", v);  //set classification scheme list attribute
              session.setAttribute("vCS_ID", vID);  //set classification scheme list attribute
          }
//these two may not needed 
          if(session.getAttribute("vCSI") == null)
          {
            v = new Vector();
            vID = new Vector();
            //getCSItemsList(vID, v, null);    //get the classification scheme items list
            session.setAttribute("vCSI", v);  //set classification scheme items list attribute
            session.setAttribute("vCSI_ID", vID);  //set classification scheme items list attribute
          }
          if(session.getAttribute("vCSCSI_CS") == null)
          {
            v = new Vector();
            vID = new Vector();
            //getCSCSIList(vID, v, null);    //get CS_CSI list
            session.setAttribute("vCSCSI_CS", vID);  //set CS_ID in CS_CSI list attribute
            session.setAttribute("vCSCSI_CSI", v);  //set CSI_ID in CS_CSI attribute
          }
//the above two may not needed
        if((session.getAttribute("vCD") == null && sContext != null) || bNewContext)
        {
          v = new Vector();
          vID = new Vector();
          getConceptualDomainList(vID, v, sContext);    //get the Value domain list
          session.setAttribute("vCD", v);  //set  Conceptual domain list attribute
          session.setAttribute("vCD_ID", vID);  //set  Conceptual domain list attribute
        }

        if(session.getAttribute("vDataType") == null)
        {
          v = new Vector();
          Vector vDesc = new Vector();
          Vector vComm = new Vector();
          getDataTypesList(v, vDesc, vComm);    //get the Workflow status list
          //add emtpy data at the beginning
          v.insertElementAt("", 0);
          vDesc.insertElementAt("", 0);
          vComm.insertElementAt("", 0);
          session.setAttribute("vDataType", v);  //set data type names list attribute
          session.setAttribute("vDataTypeDesc", vDesc);  //set data type description list attribute
          session.setAttribute("vDataTypeComment", vComm);  //set data type comment list attribute
        }
        //list of uoml list 
        if(session.getAttribute("vUOM") == null)
        {
          v = new Vector();
          getUOMList(v);    //get the vUOM list
          session.setAttribute("vUOM", v);  //set vUOM list attribute
        }
        //list of uoml format for vd
        if(session.getAttribute("vUOMFormat") == null)
        {
          v = new Vector();
          getUOMFormatList(v);    //get the vUOMFormat list
          session.setAttribute("vUOMFormat", v);  //set vUOMFormat list attribute
        }
        //list of alternate names for create
        if(session.getAttribute("AltNameTypes") == null)
          this.getAltNamesList(session);
        //list of reference documents for create
        if(session.getAttribute("RefDocTypes") == null)
          this.getRefDocsList(session);
        //list of derivation types for create
        if(session.getAttribute("vRepType") == null)
          this.getDerTypesList(session);
        //list of organizations
        if(session.getAttribute("Organizations") == null)
          this.getOrganizeList();
        //list of organizations
        if(session.getAttribute("Persons") == null)
          this.getPersonsList();
        //list of organizations
        if(session.getAttribute("ContactRoles") == null)
          this.getContactRolesList();
        //list of organizations
        if(session.getAttribute("CommType") == null)
          this.getCommTypeList();
        //list of organizations
        if(session.getAttribute("AddrType") == null)
          this.getAddrTypeList();
        
        m_sbr_db_conn.close();
      //  logger.info(m_servlet.getLogMessage(req, "getACList", "ended", startDate, new java.util.Date()));
      }
      else
      {
        logger.fatal("getAClist: no db connection");
        session.setAttribute("ConnectedToDB", "No");
      }
    }
    catch(Exception e)
    {
        try{if (m_sbr_db_conn != null) m_sbr_db_conn.close();}catch(Exception f){} 
        //System.err.println("ERROR in GetACService-getACList: " + e);
        logger.fatal("ERROR in GetACService-getACList : " + e.toString());
    }
    try
    {
        if (m_sbr_db_conn != null) m_sbr_db_conn.close();    
    }
    catch(Exception ee)
    {
        //System.err.println("ERROR in GetACService-getACList close: " + ee);
        logger.fatal("ERROR in GetACService-getACList close: " + ee.toString());
    }
  }  // end of getACList

/**
  * The verifyConnection method queries the db to test the connection and
  * sets the ConnectedToDB variable.
  *  
  *  ConnectedToDB = "Nothing" (default)
  *  ConnectedToDB = "Yes" (connection availble)
  *  ConnectedToDB = "No" (no connection availble)
  *  
  * @param req The HttpServletRequest from the client
  * @param res The HttpServletResponse back to the client
  *
  */
  public void verifyConnection(HttpServletRequest req, HttpServletResponse res)
  {
	  Connection m_sbr_db_conn = null;
	  try
    {
      
    //  logger.info(m_servlet.getLogMessage(req, "getACList", "started", startDate, startDate));

      HttpSession session = req.getSession();
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      	
      if (m_sbr_db_conn != null)
      {
    	  session.setAttribute("ConnectedToDB", "Yes");
    	  m_sbr_db_conn.close();
      }
      else
      {
        logger.fatal("verifyConnection: no db connection");
        session.setAttribute("ConnectedToDB", "No");    
      }
    }
    catch(Exception e)
    {
        try{if (m_sbr_db_conn != null) m_sbr_db_conn.close();}catch(Exception f){} 
        logger.fatal("ERROR in GetACService-verifyConnection : " + e.toString());
    }
    try
    {
        if (m_sbr_db_conn != null) m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
        logger.fatal("ERROR in GetACService-verifyConnection close: " + ee.toString());
    }
	
  }  // end of verifyConnection


  /**
  * The getObjectClassList method queries the db for lists of Object Class ID's
  * and Names, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.GET_OBJECT_CLASSES_LIST(?,?)
  *
  * @param vIDList A Vector of the ID's of the Object Class.
  * @param vList  A Vector of Object Class names.
  * @param sContext  The context to search in.
  *
  */
  public void getObjectClassList(Vector vIDList, Vector vList, String sContext)  // returns list of ObjectClass
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_OBJECT_CLASSES_LIST(?,?)}";
        getDataListStoreProcedure(vList, vIDList, null, null, sAPI, sContext, "", 2);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getObjectClassList: " + e);
      logger.fatal("ERROR in GetACService-getObjectClassList : " + e.toString());
    }
  } //end ObjectClasslist

  /**
  * The getPropertyClassList method queries the db for lists of Property Class ID's
  * and Names, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.GET_PROPERTIES_LIST(?,?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param sContext  The context to search in.
  *
  */
  public void getPropertyClassList(Vector vIDList, Vector vList, String sContext)  // returns list of PropertyClass
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_PROPERTIES_LIST(?,?)}";
        getDataListStoreProcedure(vList, vIDList, null, null, sAPI, sContext, "", 2);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getPropertyClassList: " + e);
      logger.fatal("ERROR in GetACService-getPropertyClassList : " + e.toString());
    }
  } //end PropertyClasslist

  /**
  * The getQualifierList method queries the db for a Qualifier list,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_qualifiers_list(?)
  *
  * @param vList  A Vector of Qualifier names.
  *
  */
  public void getQualifierList(Vector vList)  // returns list of PropertyClass
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_qualifiers_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getQualifierList: " + e);
      logger.fatal("ERROR in GetACService-getQualifierList : " + e.toString());
    }
  } //end PropertyClasslist

  /**
  * The getUserList method gets list of users in the database
  * and Names, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.GET_USER_LIST(?,?)
  *
  * @param vUANameList A Vector of the user login names
  * @param vNameList  A Vector of full names.
  *
  */
  public void getUserList(Vector vUANameList, Vector vNameList)  // returns list of user list
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_USER_LIST(?)}";
        getDataListStoreProcedure(vUANameList, vNameList, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
        //System.err.println("Problem getUserList: " + e);
        logger.fatal("ERROR in GetACService-getUserList : " + e.toString());
    }
  } //end getUserList

  /**
  * The getContextList method queries the db for Context Name and ID lists,
  * stored in vectors. Calls the stored procedure:
  * SBREXT_SS_API.get_context_list(?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of Context names.
  *
  */
  public void getContextList(Vector vIDList, Vector vList)  // returns list of Contexts
  {
    try
    {
        String sAPI = "{call SBREXT_SS_API.get_context_list(?)}";
        getDataListStoreProcedure(vIDList, vList, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getContextList: " + e);
      logger.fatal("ERROR in GetACService-getContextList : " + e.toString());
    }
  }  //endContextList

  /**
  * The getWriteContextList method queries the db for Context Name and ID lists,
  * where user has write permission. Lists stored in vectors. Calls the stored procedure:
  * SBREXT_SS_API.get_write_context_list(?, ?, ?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of Context names.
  * @param UserName  Name of user.
  * @param ActlType  
  *
  */
  public void getWriteContextList(Vector vIDList, Vector vList, String UserName, String ActlType)  // returns list of Contexts
  {
    try
    {
        UserName = UserName.toUpperCase();
        String sAPI = "{call SBREXT_SS_API.get_write_context_list(?, ?, ?)}";
        getDataListStoreProcedure(vIDList, vList, null, null, sAPI, UserName, ActlType, 3);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getContextList: " + e);
      logger.fatal("ERROR in GetACService-getWriteContextList : " + e.toString());
    }
  }  //endContextList

  /**
  * The getRepTermList method queries the db for a list of Rep Terms,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_representation_list(?)
  *
  * @param vList  A Vector of Rep Term names.
  *
  */
  public void getRepTermList(Vector vList)  // returns list of Workflow Status
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_representation_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getSourceList: " + e);
      logger.fatal("ERROR in GetACService-getSourceList : " + e.toString());
    }
  }  //end getSourceList

  /**
  * The getStatusList method queries the db for a list of Statuses,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_SS_API.get_status_list(?)
  *
  * @param vList  A Vector of Status names.
  *
  */
  public void getStatusList(String ACType, Vector vList)  // returns list of Workflow Status
  {
    try
    {
        String sAPI = "{call SBREXT_SS_API.get_status_list(?,?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, ACType, "", 2);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getStatusList: " + e);
      logger.fatal("ERROR in GetACService-getStatusList : " + e.toString());
    }
  }  //end StatusList

  /**
  * The getDataElementConceptList method queries the db for lists of Names,
  * Preferred Names, and  ID's, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_data_element_concept_list(?,?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vPrefList  A Vector of preferred names.
  * @param vList  A Vector of names.
  * @param sContext  The context to search in.
  *
  */
  public void getDataElementConceptList(Vector vIDList, Vector vPrefList, Vector vList, String sContext)  // returns list of DataElementConcept
  {
    ResultSet rs = null;
    Statement CStmt = null;
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_data_element_concept_list(?,?)}";
        getDataListStoreProcedure(vIDList, vPrefList, vList, null, sAPI, sContext, "", 2);
    }
    catch(Exception e)
    {
        //System.err.println("Problem getDataElementConceptList: " + e);
        logger.fatal("ERROR in GetACService-getDataElementConceptList : " + e.toString());
    }
  } //end DataElementConceptlist

  /**
  * The getValueDomainList method queries the db for lists of Names,
  * Preferred Names, and  ID's, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_value_domain_list(?,?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vPrefList  A Vector of preferred names.
  * @param vList  A Vector of names.
  * @param sContext  The context to search in.
  *
  */
  public void getValueDomainList(Vector vIDList, Vector vPrefList, Vector vList, String sContext)  // returns list of ValueDomain
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_value_domain_list(?,?)}";
        getDataListStoreProcedure(vIDList, vPrefList, vList, null, sAPI, sContext, "", 2);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getValueDomainList: " + e);
      logger.fatal("ERROR in GetACService-getValueDomainList : " + e.toString());
    }
  } //end ValueDomainlist

  /**
  * The getConceptualDomainList method queries the db for lists of Names
  * and  ID's, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_conceptual_domain_list(?,?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param sContext  The context to search in.
  *
  */
   public void getConceptualDomainList(Vector vIDList, Vector vList, String sContext)  // returns list of ValueDomain
  {
    try
    {
         Vector vContextList = new Vector();
         Vector vASLlist = new Vector();
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_conceptual_domain_list(?,?)}";
        getDataListStoreProcedure(vIDList, vList, vASLlist, vContextList, sAPI, "", "", 2);
        //add the context to the names
        if ((vList != null) && (vContextList != null))
           for (int i=0; i<vList.size(); i++)
           {
               String cdName = (String)vList.elementAt(i);
               String cdContext = (String)vContextList.elementAt(i);
               vList.setElementAt(cdName + " - " + cdContext, i);
           }
    }
    catch(Exception e)
    {
      //System.err.println("Problem getConceptualDomainList: " + e);
      logger.fatal("ERROR in GetACService-getConceptualDomainList : " + e.toString());
    }
  } //end ConceptualDomainlist

  /**
  * The getCSList method queries the db for lists of Names
  * and  ID's, which are stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_conceptual_domain_list(?,?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param sContext  The context to search in.
  *
  */
  public void getCSList(Vector vIDList, Vector vList, String sContext)  // returns list of Classification Schemes
  {
    try
    {
         Vector vContextList = new Vector();
         Vector vASLlist = new Vector();
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_class_scheme_list(?,?)}";
        getDataListStoreProcedure(vIDList, vList, vASLlist, vContextList, sAPI, "", "", 2);
        //add the context to the names
        if ((vList != null) && (vContextList != null))
           for (int i=0; i<vList.size(); i++)
           {
               String csName = (String)vList.elementAt(i);
               String csContext = (String)vContextList.elementAt(i);
               csName = m_util.removeNewLineChar(csName);   //remove the new line char here itself
               vList.setElementAt(csName + " - " + csContext, i);
           }
    }
    catch(Exception e)
    {
      //System.err.println("Problem getCSList: " + e);
      logger.fatal("ERROR in GetACService-getCSList : " + e.toString());
    }
  } //end Classification Scheme Lists

  /**
  * The getCSItemsList method queries the db for lists of Names
  * and  ID's (which are stored in vectors) given the Classification Scheme ID.
  * Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_class_scheme_items_list(?)
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param sCSID  The ID of the Classification Scheme.
  *
  */
  public void getCSItemsList(Vector vIDList, Vector vList, String sCSID)  // returns list of Classification Scheme Items Lists
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_class_scheme_items_list(?)}";
        getDataListStoreProcedure(vIDList, vList, null, null, sAPI, "", "", 1);
        if (vList != null && vList.size() > 0)
        {
          for (int i = 0; i < vList.size(); i++)
          {
            String csiName = (String)vList.elementAt(i);
            if (csiName != null && !csiName.equals(""))
            {
              csiName = m_util.removeNewLineChar(csiName);
              vList.setElementAt(csiName, i);
            }
          }
        }
    }
    catch(Exception e)
    {
      //System.err.println("Problem getCSItemsList: " + e);
      logger.fatal("ERROR in GetACService-getCSItemsList : " + e.toString());
    }
  } //end Classification Scheme Items Lists

/*  /**
  * The getCSCSIList method queries the db for lists Classification Schemes and Items
  * ID's (which are stored in vectors) given the Classification Scheme ID.
  * Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_cscsi_list(?)
  *
  * @param vCSIDList A Vector of the Classification Scheme ID's.
  * @param vCSIIDList  A Vector of Classification Scheme Items ID's.
  * @param sCSID  The ID of the Classification Scheme.
  *
  */
/*  public void getCSCSIList(Vector vCSIDList, Vector vCSIIDList, String sCSID)  // returns list of Classification Scheme Items Lists
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_cscsi_list(?)}";
        getDataListStoreProcedure(vCSIDList, vCSIIDList, null, null, sAPI, "", "",1);
        //getCSCSIListBean();
    }
    catch(Exception e)
    {
      //System.err.println("Problem getCSCSIList: " + e);
      logger.fatal("ERROR in GetACService-getCSCSIList : " + e.toString());
    }
  } //end Classification Scheme Items Lists
*/

  /**
   * To get List for Class Scheme Items from database called from ?. 
   * Gets the attributes from Cs_csi table adds them to the bean then to vector in the session.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.get_cscsi_list(OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   */
  private void getCSCSIListBean()  // returns list of CSIs
  {
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector vList = new Vector();
    Connection m_sbr_db_conn = null;
    try
    {
      //Create a Callable Statement object.
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_CSCSI_LIST(?)}");

        CStmt.registerOutParameter(1, OracleTypes.CURSOR);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(1);

        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            CSI_Bean CSIBean = new CSI_Bean();
            CSIBean.setCSI_CS_IDSEQ(rs.getString("cs_idseq"));
            CSIBean.setCSI_CSI_IDSEQ(rs.getString("csi_idseq"));
            CSIBean.setCSI_CSCSI_IDSEQ(rs.getString("cs_csi_idseq"));
            CSIBean.setP_CSCSI_IDSEQ(rs.getString("p_cs_csi_idseq"));
            CSIBean.setCSI_DISPLAY_ORDER(rs.getString("display_order"));
            CSIBean.setCSI_LABEL(rs.getString("label"));
            String csName = rs.getString("cs_name");
            csName = m_util.removeNewLineChar(csName);
            CSIBean.setCSI_CS_NAME(csName);
            CSIBean.setCSI_CS_LONG_NAME(csName);
            String csiName = rs.getString("csi_name");
            csiName = m_util.removeNewLineChar(csiName);
            CSIBean.setCSI_NAME(csiName);
            CSIBean.setCSI_LEVEL(rs.getString("lvl"));

            vList.addElement(CSIBean);  //add the bean to a vector

          }  //END WHILE
        }   //END IF
      }
      HttpSession session = m_classReq.getSession();
      session.setAttribute("CSCSIList", vList);
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACService-getCSCSIList: " + e);
      logger.fatal("ERROR - GetACService-getCSCSIListBean for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null) m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACService-getCSCSIList: " + ee);
      logger.fatal("ERROR - GetACService-getCSCSIListBean for close : " + ee.toString());
    }
  }  //endGetACService-getCSCSIList

  /**
  * The getLanguageList method queries the db for a list of Languages,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_languages_list(?)
  *
  * @param vList  A Vector of Language names.
  *
  */
  public void getLanguageList(Vector vList)  // returns list of Languages
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_languages_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "",1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getLanguageList: " + e);
      logger.fatal("ERROR in GetACService-getLanguageList : " + e.toString());
    }
  } //end Languages

  /**
  * The getDataTypesList method queries the db for a list of Data Types,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_datatypes_list(?)
  *
  * @param vList  A Vector of Data Types names.
  *
  */
  public void getDataTypesList(Vector vList, Vector vDesc, Vector vComment)  // returns list of DataTypes
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_datatypes_list(?)}";
        getDataListStoreProcedure(vList, vDesc, vComment, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getDataTypesList: " + e);
      logger.fatal("ERROR in GetACService-getDataTypesList : " + e.toString());
    }
  } //end DataTypes

  /**
  * The getRDocTypesList method queries the db for a list of RDoc Types,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_doc_types_list(?)
  *
  * @param vList  A Vector of Rerence Doc Types names.
  *
  */
  public Vector getRDocTypesList(Vector vList)  // returns list of DataTypes
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_doc_types_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
        //sort the doc types such that long name and hist short cde name is on the top
        if (vList != null)
        {
          //remove Preferred Question Text and historic short cde name from the list
          if (vList.contains("Preferred Question Text"))
            vList.remove("Preferred Question Text");
          if (vList.contains("HISTORIC SHORT CDE NAME"))
            vList.remove("HISTORIC SHORT CDE NAME");
          //add Preferred Question Text and historic short cde name on the top
          if (!vList.contains("Preferred Question Text"))
            vList.insertElementAt("Preferred Question Text", 0);
          if (!vList.contains("HISTORIC SHORT CDE NAME"))
            vList.insertElementAt("HISTORIC SHORT CDE NAME", 1);
        }
    }
    catch(Exception e)
    {
      //System.err.println("Problem getRDocTypesList: " + e);
      logger.fatal("ERROR in GetACService-getRDocTypesList : " + e.toString());
    }
    return vList;
  } //end RDocTypes

   /**
  * The getValueMeaningsList method queries the db for lists of Permissable Values,
  * and Permissable Meanings, stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_valuemeaning_list(?)
  *
  * @param vIDList  The ID of the values.
  * @param vValueList  A Vector of Values.
  * @param vMeanList  A Vector of Meanings.
  *
  */
  public void getValueMeaningsList(String CD_ID, Vector vMeanList, Vector vMeanDesc)  // returns list of Permissable Values
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_valuemeaning_list(?,?)}";
        getDataListStoreProcedure(vMeanList, vMeanDesc, null, null, sAPI, CD_ID, "", 2);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getValueMeaningsList: " + e);
      logger.fatal("ERROR in GetACService-getValueMeaningsList : " + e.toString());
    }
  } //end ValueMeaningsList

  /**
  * The getPermissableValuesList method queries the db for lists of Permissable Values,
  * and Permissable Meanings, stored in vectors. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_valid_values_list(?)
  *
  * @param vIDList  The ID of the values.
  * @param vValueList  A Vector of Values.
  * @param vMeanList  A Vector of Meanings.
  *
  */
  public void getPermissableValues(Vector vIDList, Vector vValueList, Vector vMeanList)  // returns list of Permissable Values
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_valid_values_list(?)}";
        getDataListStoreProcedure(vIDList, vValueList, vMeanList, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getPermissableValuesList: " + e);
      logger.fatal("ERROR in GetACService-getPermissableValuesList : " + e.toString());
    }
  } //end PermissableValues Lists

  /**
  * The getUOMList method queries the db for a list of Units Of Measure,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_unit_of_measures_list(?)
  *
  * @param vList  A Vector of UOM names.
  *
  */
  public void getUOMList(Vector vList)  // returns list of UOM
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_unit_of_measures_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getUOMList: " + e);
      logger.fatal("ERROR in GetACService-getUOMList : " + e.toString());
    }
  } //end UOM

  /**
  * The getUOMFormatList method queries the db for a list of Units Of Measure Formats,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_CDE_CURATOR_PKG.get_formats_list(?)
  *
  * @param vList  A Vector of UOM Format names.
  *
  */
  public void getUOMFormatList(Vector vList)  // returns list of DataTypes
  {
    try
    {
        String sAPI = "{call SBREXT_CDE_CURATOR_PKG.get_formats_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getFormatList: " + e);
      logger.fatal("ERROR in GetACService-getFormatList : " + e.toString());
    }
  } //end UOMFormatList


  /**
  * The getSourceList method queries the db for a list of Sources,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_SS_API.get_source_list(?)
  *
  * @param vList  A Vector of Source names.
  *
  */
  public void getSourceList(Vector vList)  // returns list of Workflow Status
  {
    try
    {
        String sAPI = "{call SBREXT_SS_API.get_source_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getSourceList: " + e);
      logger.fatal("ERROR in GetACService-getSourceList : " + e.toString());
    }
  }  //end getSourceList

  /**
  * The getRegStatusList method queries the db for a list of Sources,
  * stored in a vector. Calls the stored procedure:
  * SBREXT_SS_API.get_reg_status_list(?)
  *
  * @param vList  A Vector of Registration Status names.
  *
  */
  public void getRegStatusList(Vector vList)  // returns list of Registration Status
  {
    try
    {
        String sAPI = "{call SBREXT_SS_API.get_reg_status_list(?)}";
        getDataListStoreProcedure(vList, null, null, null, sAPI, "", "", 1);
    }
    catch(Exception e)
    {
      //System.err.println("Problem getRegStatusList: " + e);
      logger.fatal("ERROR in GetACService-getRegStatusList : " + e.toString());
    }
  }  //end getRegStatusList

   /**
  * The getAbbreviationList method queries the db for a list of Abbreviations,
  * stored in a vector. Calls the sql query:
  * "SELECT CONTENT, SUBSTITUTION FROM SUBSTITUTIONS_EXT ORDER BY CONTENT"
  *
  * @param vTermList  A Vector of Term names.
  * @param vList  A Vector of Abbreviation names.
  *
  */
  public void getAbbreviationList(Vector vTermList, Vector vList)  // returns list of Languages
  {
    try
    {
        //there is  sbrext_cde_curator_pkg.get_abbreviations_list api.
        /*String sql = "SELECT CONTENT, SUBSTITUTION FROM SUBSTITUTIONS_EXT ORDER BY CONTENT";
        getDataListSQL(vTermList, vList, sql);*/
    //    System.out.println("Abbreviation: " + vList.size());
    }
    catch(Exception e)
    {
      //System.err.println("Problem getAbbreviationList: " + e);
      logger.fatal("ERROR in GetACService-getAbbreviationList : " + e.toString());
    }
  } //end getAbbreviationList

  /**
  * The hasPrivilege will check if the user has Database privilege to make changes
  *
  * @param DBAction The db action (wrie or update0
  * @param DBUser The username
  * @param ACType The type of page being called, i.e. de, dec, or vd
  * @param ContID  The context ID
  * @return string yes no value for privilege
  *
  */
  public String hasPrivilege(String DBAction, String DBUser, String ACType, String ContID)
  {
    ResultSet rs = null;
    Statement CStmt = null;
    String sPrivilege = "";
    Connection m_sbr_db_conn = null;
    try
    {
      DBUser = DBUser.toUpperCase();
      if (ACType.equals("de"))
        ACType = "DATAELEMENT";
      else if (ACType.equals("dec"))
        ACType = "DE_CONCEPT";
      else if (ACType.equals("vd"))
        ACType = "VALUEDOMAIN";

      String sql;
      if (DBAction.equals("Create")==true)
        sql = "SELECT ADMIN_SECURITY_UTIL.HAS_CREATE_PRIVILEGE('" + DBUser + "', '" + ACType + "', '" + ContID + "') FROM DUAL";
      else
        sql = "SELECT ADMIN_SECURITY_UTIL.HAS_ADMIN_PRIVILEGE('" + DBUser + "', '" + ACType + "', '" + ContID + "') FROM DUAL";

        //Create a Callable Statement object.
        m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
        if (m_sbr_db_conn == null)
          m_servlet.ErrorLogin(m_classReq, m_classRes);
        else
        {
          CStmt = m_sbr_db_conn.createStatement();
          rs = CStmt.executeQuery(sql);
          String s;
          //loop through to printout the outstrings
          while(rs.next())
          {
            s = "";
            s = rs.getString(1);
            if (s != null)
            {
              sPrivilege = s;
              break;
            }
          }
        }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACService- hasPrivilege: " + e);
      logger.fatal("ERROR in GetACService-hasPrivilege for other : " + e.toString());
    }
    try
    {
      if(rs!=null)  rs.close();
      if(CStmt!=null)  CStmt.close();
      if(m_sbr_db_conn != null)  m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing: " + ee);
      logger.fatal("ERROR in GetACService-hasPrivilege for close : " + ee.toString());
    }
    return sPrivilege;
  }  // end of hasPrivilege

  /**
  * The getDataListSQL returns a data list, given a sql statement
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param sSQL  The sql statement to execute.
  *
  */
  public void getDataListSQL(Vector vIDList, Vector vList, String sSQL)
  {
    ResultSet rs = null;
    Statement CStmt = null;
    Connection m_sbr_db_conn = null;
    try
    {
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)  // still null, forward to ErrorLogin page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        if(vIDList != null && !vIDList.isEmpty())
            vIDList.clear();  //It is a global var, remove all existing elements

        String sName = "", sID = "";
        //loop through to printout the outstrings
        while(rs.next())
        {
          if(vIDList != null)
          {
              sID = rs.getString(1);
              sName = rs.getString(2);
          }
          else
          {
              sName = rs.getString(1);
          }
          if(sName!=null)
          {
              if(sName.length() > 80)
                  sName = sName.substring(0, 80);
              if(vIDList != null)
                  vIDList.addElement(sID);
              vList.addElement(sName);
          }
        }// end of while
      }
    }
    catch(Exception e)
    {
      //System.err.println("Error getDataListSQL: " + e);
      logger.fatal("ERROR in GetACService-getDataListSQL for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null)  m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing: " + ee);
      logger.fatal("ERROR in GetACService-getDataListSQL for close : " + ee.toString());
    }
  } //end getDataListSQL

  /**
  * The getDataListSQL2 returns two data lists, given a sql statement
  *
  * @param vIDList A Vector of the ID's.
  * @param vList  A Vector of names.
  * @param vList2  A second Vector of names.
  * @param sSQL  The sql statement to execute.
  *
  */
  public void getDataListSQL2(Vector vIDList, Vector vList1, Vector vList2, String sSQL)  // returns list of DataElementConcept
  {
    ResultSet rs = null;
    Statement CStmt = null;
    Connection m_sbr_db_conn = null;
    try
    {
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)  // still null, forward to ErrorLogin page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        if(vIDList != null && !vIDList.isEmpty())
            vIDList.clear();  //It is a global var, remove all existing elements

        String sNameV = "";
        String sNameSM = "", sID = "";
        //loop through to printout the outstrings
        while(rs.next())
        {
          if(vIDList != null)
          {
              sID = rs.getString(1);
              sNameV = rs.getString(2);
              sNameSM = rs.getString(3);
          }
          else
          {
              sNameV = rs.getString(1);
              sNameSM = rs.getString(2);
          }
          if(sNameV != null)
          {
              if(sNameV.length() > 80)
                  sNameV = sNameV.substring(0, 80);
              if(vIDList != null)
                  vIDList.addElement(sID);
              vList1.addElement(sNameV);
          }
           if(sNameSM != null)
          {
              if(sNameSM.length() > 80)
                  sNameSM = sNameSM.substring(0, 80);
              vList2.addElement(sNameSM);
          }
        }// end of while
      }
    }
    catch(Exception e)
    {
      //System.err.println("Error getDataListSQL2: " + e);
      logger.fatal("ERROR in GetACService-getDataListSQL2 for other : " + e.toString());
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null)  m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing: " + ee);
      logger.fatal("ERROR in GetACService-getDataListSQL2 for close : " + ee.toString());
    }
  } //end getDataListSQL2

  /**
  * The getDataListStoreProcedure returns four data lists.
  *
  * @param vList1 A Vector of the ID's.
  * @param vList2  A second Vector of names.
  * @param vList3  A third Vector of names.
  * @param vList4  A fourth Vector of names.
  * @param sAPI  The API to call.
  * @param setString1  Sets an API in parameter.
  * @param setString2  Sets an API in parameter.
  * @param iParmIdx  Parameter ID.
  *
  */
  public void getDataListStoreProcedure(Vector vList1, Vector vList2, Vector vList3, Vector vList4, String sAPI, String setString1, String setString2, int iParmIdx)  // returns list of Workflow Status
  {
    /*
    Remember:  Vector parameter represent the recordset's parameter numbers.
    */
    ResultSet rs = null;
    CallableStatement CStmt = null;
    boolean isReConnect = false;
    Connection m_sbr_db_conn = null;
    try
    {
      //Create a Callable Statement object.
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null) // still null, forward to ErrorLogin page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
          isReConnect = true;
        CStmt = m_sbr_db_conn.prepareCall(sAPI);
        // Now tie the placeholders with actual parameters.
        if(iParmIdx == 1)
        {
          CStmt.registerOutParameter(1,OracleTypes.CURSOR);
          // Now we are ready to call the stored procedure
          boolean bExcuteOk = CStmt.execute();
          rs = (ResultSet) CStmt.getObject(1);
        }
        else if(iParmIdx == 2)
        {
          CStmt.registerOutParameter(2,OracleTypes.CURSOR);
          CStmt.setString(1, setString1);
          // Now we are ready to call the stored procedure
          boolean bExcuteOk = CStmt.execute();
          rs = (ResultSet) CStmt.getObject(2);
        }
        else if(iParmIdx == 3)
        {
          CStmt.registerOutParameter(3,OracleTypes.CURSOR);
          CStmt.setString(1, setString1);
          CStmt.setString(2, setString2);
          // Now we are ready to call the stored procedure
          boolean bExcuteOk = CStmt.execute();
          rs = (ResultSet) CStmt.getObject(3);
        }

        String sName = "", sID = "";
        //loop through to printout the outstrings
          if((vList1 != null) && (vList2 != null) && (vList3 != null) && (vList4 != null))
          {
            while(rs.next())
            {
              vList1.addElement(rs.getString(1));
              vList2.addElement(rs.getString(2));
              sName = rs.getString(3);
              if (sName == null) sName = "";
              //if(sName.length() > 80)
              //    sName = sName.substring(0, 80);
              vList3.addElement(sName);
              vList4.addElement(rs.getString(4));
            }
          }
          else if((vList1 != null) && (vList2 != null) && (vList3 != null))
          {
            while(rs.next())
            {
              vList1.addElement(rs.getString(1));
              vList2.addElement(rs.getString(2));
              sName = rs.getString(3);
              if (sName == null) sName = "";
              //if(sName.length() > 80)
              //    sName = sName.substring(0, 80);
              vList3.addElement(sName);
            }
          }
          else if((vList1 != null) && (vList2 != null))
          {
            while(rs.next())
            {
              vList1.addElement(rs.getString(1));
              sName = rs.getString(2);
              if (sName == null) sName = "";
             // if(sName != null)
             // {
             //   if(sName.length() > 80)
             //     sName = sName.substring(0, 80);
             // }
             // else
              //  sName = "";
                vList2.addElement(sName);
            }
          }
          else
          {
            while(rs.next())
            {
              sName = rs.getString(1);
              if (sName == null) sName = "";
              vList1.addElement(sName);
            }
          }
        }
     }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACService-getDataListStoreProcedure : " + e);
      logger.fatal("ERROR in GetACService-getDataListStoreProcedure for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      //close is if reconnected
      if (isReConnect && m_sbr_db_conn != null)  m_sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing: " + ee);
      logger.fatal("ERROR in GetACService-getDataListStoreProcedure for close : " + ee.toString());
    }
  }  //end getDataListStoreProcedure

  /**
  * The doComponentExist method queries the db, checking whether component exists.
  *
  * @param sSQL  A sql statement
  *
  * @return Boolean flag indicating whether component exists.
  */
  public boolean doComponentExist(String sSQL)  // returns flag
  {
    ResultSet rs = null;
    Statement CStmt = null;
    boolean isExist = false;
    Connection m_sbr_db_conn = null;
    try
    {
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)  // still null to login page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        int iCount=0;
        //loop through to printout the outstrings
        while(rs.next())
        {
          iCount = rs.getInt(1);
        }// end of while
        if (iCount > 0)
          isExist = true;
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in doComponentExist: " + e);
      logger.fatal("ERROR in doComponentExist : " + e.toString());
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null) m_sbr_db_conn.close();
    }
    
    catch(Exception ee)
    {
      //System.err.println("Problem closing in doComponentExist: " + ee);
      logger.fatal("ERROR in doComponentExist closing : " + ee.toString());
    }
    return isExist;
  } //end doComponentExist

  /**
  * The isUniqueInContext method queries the db, checking whether DE is unique in context.
  *
  * @param sSQL  A sql statement
  *
  * @return String Long Name.
  */
  public String isUniqueInContext(String sSQL)  // returns flag
  {
    ResultSet rs = null;
    Statement CStmt = null;
    String sName= "";
    Connection m_sbr_db_conn = null;
    try
    {
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)  // still null to login page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        int i = 0;
        //loop through to printout the outstrings
        while(rs.next())
        {
          if(i == 0)
            sName =  rs.getString(1);
          else
            sName = sName + ", " + rs.getString(1);
          i++;
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in isUniqueInContext: " + e);
      logger.fatal("ERROR in isUniqueInContext : " + e.toString());
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null) m_sbr_db_conn.close();
    }
    
    catch(Exception ee)
    {
      //System.err.println("Problem closing in isUniqueInContext: " + ee);
      logger.fatal("ERROR in isUniqueInContext closing : " + ee.toString());
    }
    return sName;
  } //end isUniqueInContext

  /**
  * The doBlockExist method queries the db, checking whether component exists.
  *
  * @param sSQL  A sql statement
  *
  * @return String idseq indicating whether component exists.
  */
  public String doBlockExist(String sSQL)  // returns flag
  {
    ResultSet rs = null;
    Statement CStmt = null;
    String blockID = "None";
    Connection m_sbr_db_conn = null;
    try
    {
      m_sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (m_sbr_db_conn == null)  // still null to login page
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = m_sbr_db_conn.createStatement();
        rs = CStmt.executeQuery(sSQL);
        //loop through to printout the outstrings
        blockID = "";
        while(rs.next())
        {
          blockID = rs.getString(1);
        }// end of while
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in doBlockExist: " + e);
      logger.fatal("ERROR in doBlockExist : " + e.toString());
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(m_sbr_db_conn != null) m_sbr_db_conn.close();
    }
    
    catch(Exception ee)
    {
      //System.err.println("Problem closing in doComponentExist: " + ee);
      logger.fatal("ERROR in doComponentExist closing : " + ee.toString());
    }
    return blockID;
  } //end doComponentExist

  /**
  * Called to get all the concepts from condr_idseq.
  * Sets in parameters, and registers output parameters and vector of evs bean.
  * Calls oracle stored procedure
  *   "{call SBREXT_CDE_CURATOR_PKG.GET_AC_CONCEPTS(?,?)}" to submit
  *
  * @param condrId condr idseq
  * 
  * @return Vector vector of evs bean.
  */
  public Vector getAC_Concepts(String condrID, VD_Bean vd, boolean bInvertBean)
  {
//System.err.println("in getAC_Concepts condrID: " + condrID);
    Connection sbr_db_conn = null;
    CallableStatement CStmt = null;
    ResultSet rs = null;
    String sCON_IDSEQ = "";
    Vector vList = new Vector();
    GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
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
            eBean.setCON_IDSEQ(rs.getString("CON_IDSEQ"));
//  System.err.println("in getAC_Concepts CON_IDSEQ: " + rs.getString("CON_IDSEQ"));
            eBean.setDISPLAY_ORDER(rs.getString("DISPLAY_ORDER"));
            eBean.setPRIMARY_FLAG(rs.getString("primary_flag_ind"));
            eBean.setNCI_CC_VAL(rs.getString("preferred_name"));
            eBean.setLONG_NAME(rs.getString("long_name"));
// System.err.println("in getAC_Concepts long name: " + rs.getString("long_name"));
            eBean.setDESCRIPTION(rs.getString("preferred_definition"));
            eBean.setPREFERRED_DEFINITION(rs.getString("preferred_definition"));
            eBean.setEVS_DATABASE(rs.getString("origin"));
 // System.err.println("in getAC_Concepts origin: " + rs.getString("origin"));
            eBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
            eBean.setNCI_CC_TYPE(rs.getString("evs_source"));
            eBean.setCONDR_IDSEQ(condrID);
            eBean.setCON_AC_SUBMIT_ACTION("NONE");
            if(rs.getString("origin") != null && rs.getString("origin").equals("NCI Metathesaurus"))
            {
              String sParent = rs.getString("long_name");
              String sCui = rs.getString("preferred_name");
              if(sParent == null) sParent = "";
              String sParentSource = "";
              sParentSource = serAC.getMetaParentSource(sParent, sCui, vd);
              if(sParentSource == null) sParentSource = "";
              eBean.setEVS_CONCEPT_SOURCE(sParentSource);
            }
            if (eBean.getCON_IDSEQ() != null && !eBean.getCON_IDSEQ().equals(""))
              vList.addElement(eBean);
          }
        }
        if(bInvertBean != false)
          vList = invertBeanVector(vList);
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in GetACService- getACConcepts for exception : " + e.toString());
      //System.out.println("get ac concept other " + e);
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR in GetACService-getConcept for close : " + ee.toString());
    }
    return vList;
  } //end get concept
  
/** Puts the primary concept at the top of the list, for internal use
  * 
  * @return vList   Vector of evs bean.
  */
  public Vector invertBeanVector(Vector vList)
  {
    Vector newVector = new Vector();
    EVS_Bean evsBean = (EVS_Bean)vList.elementAt(vList.size()-1);
    newVector.addElement(evsBean);
    for(int i=0;i<vList.size()-1;i++)
    {
      evsBean = (EVS_Bean)vList.elementAt(i);
      newVector.addElement(evsBean);
    }
   return newVector;
  }

  public void getAltNamesList(HttpSession session)
  {
    try
    {
      Vector vT = new Vector();
      String sQuery = "select detl_name from designation_types_lov_view";
      getDataListSQL(null, vT, sQuery);
      Vector vList = new Vector();
      Vector vTypes = this.getToolOptionData("CURATION", "DESIGNATION_TYPE", "");  // 
      if (vTypes != null && vTypes.size() > 0)
      {
        for (int i=0; i<vTypes.size(); i++)
        {
          TOOL_OPTION_Bean tob = (TOOL_OPTION_Bean)vTypes.elementAt(i);
          if (tob != null)
          {
            String sValue = tob.getVALUE();
            if (vT != null && sValue != null && vT.contains(sValue))
              vList.addElement(sValue);
          }
        }
      }
      session.setAttribute("AltNameTypes", vList);
    }
    catch(Exception e)
    {
       logger.fatal("Error - getAltNamesList : " + e.toString());
    }
  }

  public void getRefDocsList(HttpSession session)
  {
    try
    {
       Vector vT = new Vector();
       String sQuery = "select dctl_name from document_types_lov_view";
       getDataListSQL(null, vT, sQuery);
       Vector vList = new Vector();
       Vector vTypes = this.getToolOptionData("CURATION", "DOCUMENT_TYPE", "");  // 
       if (vTypes != null && vTypes.size() > 0)
       {
         for (int i=0; i<vTypes.size(); i++)
         {
           TOOL_OPTION_Bean tob = (TOOL_OPTION_Bean)vTypes.elementAt(i);
           if (tob != null)
           {
             String sValue = tob.getVALUE();
             if (vT != null && sValue != null && vT.contains(sValue))
               vList.addElement(sValue);
           }
         }
       }
       session.setAttribute("RefDocTypes", vList);
    }  
    catch(Exception e)
    {
       logger.fatal("Error - getRefDocsList : " + e.toString());
    }
  }

  public void getDerTypesList(HttpSession session)
  {
    try
    {
      Vector vT = new Vector();
      String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_COMPLEX_REP_TYPE(?)}";
      getDataListStoreProcedure(vT, null, null, null, sAPI, "", "", 1);
      //store it in the session for later use
      if (vT != null) 
        session.setAttribute("allDerTypes", vT);
      Vector vList = new Vector();
      Vector vTypes = this.getToolOptionData("CURATION", "DERIVATION_TYPE", "");  // 
      if (vTypes != null && vTypes.size() > 0)
      {
        for (int i=0; i<vTypes.size(); i++)
        {
          TOOL_OPTION_Bean tob = (TOOL_OPTION_Bean)vTypes.elementAt(i);
          if (tob != null)
          {
            String sValue = tob.getVALUE();
            if (vT != null && sValue != null && vT.contains(sValue))
              vList.addElement(sValue);
          }
        }
      }
      session.setAttribute("vRepType", vList);
    }  
    catch(Exception e)
    {
       logger.fatal("Error - getDerTypesList : " + e.toString());
    }
  }

  public Vector getToolOptionData(String toolName, String sProperty, String sValue)  // returns data from tool options
  {
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector vList = new Vector();
    Connection sbr_db_conn = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_TOOL_OPTIONS(?,?,?,?,?)}");

        CStmt.registerOutParameter(4, OracleTypes.CURSOR);
        CStmt.registerOutParameter(5, OracleTypes.VARCHAR);

        CStmt.setString(1, toolName);
        CStmt.setString(2, sProperty);
        CStmt.setString(3, sValue);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(4);
        String sRet = (String)CStmt.getString(5);
        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            TOOL_OPTION_Bean TO_Bean = new TOOL_OPTION_Bean();
            TO_Bean.setTOOL_OPTION_IDSEQ(rs.getString("TOOL_IDSEQ"));
            TO_Bean.setTOOL_NAME(rs.getString("TOOL_NAME"));
            TO_Bean.setPROPERTY(rs.getString("PROPERTY"));
            TO_Bean.setVALUE(rs.getString("VALUE"));
            TO_Bean.setLANGUAGE(rs.getString("UA_NAME"));   
            vList.addElement(TO_Bean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      System.err.println("other problem in GetACService-getToolOptionData: " + e);
      logger.fatal("ERROR - GetACService-getToolOptionData for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      System.err.println("Problem closing in GetACService-getToolOptionData: " + ee);
      logger.fatal("ERROR - GetACService-getToolOptionData for close : " + ee.toString());
    }
    return vList;
  }  //endGetACService-getToolOptionData

  private Hashtable getHashListFromAPI(String sAPI)
  {
    Hashtable hRes = new Hashtable();
    Connection sbr_db_conn = null;
    CallableStatement CStmt = null;
    ResultSet rs = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall(sAPI);
        //out parameter
        CStmt.registerOutParameter(1, OracleTypes.CURSOR);       //return cursor
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(1);
        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            String sID = rs.getString(1);
            String sName = rs.getString(2);
            if (sName == null) sName = sID;
            hRes.put(sID, sName);  //add it to the hash table
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in GetACService- getHashListFromAPI for exception : " + sAPI + " : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR in GetACService-getHashListFromAPI for close : " + ee.toString());
    }
    
    return hRes;
  } //end getHashListFromAPI

  public void getOrganizeList()
  {
    String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_ORGANIZATION_LIST(?)}";
    Hashtable hOrg = this.getHashListFromAPI(sAPI);
    HttpSession session = (HttpSession)m_classReq.getSession();
    session.setAttribute("Organizations", hOrg);
  }
  
  public void getContactRolesList()
  {
    String sAPI = "{call SBREXT.SBREXT_CDE_CURATOR_PKG.GET_CONTACT_ROLES_LIST(?)}";
    Hashtable hOrg = this.getHashListFromAPI(sAPI);
    HttpSession session = (HttpSession)m_classReq.getSession();
    session.setAttribute("ContactRoles", hOrg);
  System.out.println("get contact roles " + hOrg.size());
  }
  
  public void getCommTypeList()
  {
    String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_COMM_TYPE_LIST(?)}";
    Hashtable hOrg = this.getHashListFromAPI(sAPI);
    HttpSession session = (HttpSession)m_classReq.getSession();
    session.setAttribute("CommType", hOrg);
  }
  
  public void getAddrTypeList()
  {
    String sAPI = "{call SBREXT_CDE_CURATOR_PKG.GET_ADDR_TYPE_LIST(?)}";
    Hashtable hOrg = this.getHashListFromAPI(sAPI);
    HttpSession session = (HttpSession)m_classReq.getSession();
    session.setAttribute("AddrType", hOrg);
  }

  public void getPersonsList()
  {
    Hashtable hPer = new Hashtable();
    Connection sbr_db_conn = null;
    CallableStatement CStmt = null;
    ResultSet rs = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_PERSONS_LIST(?)}");
        //out parameter
        CStmt.registerOutParameter(1, OracleTypes.CURSOR);       //return cursor
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(1);
        String s;
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            String sID = rs.getString("per_idseq");
            String lName = rs.getString("lname");
            String fName = rs.getString("fname");
            String sOrg = rs.getString("org_idseq");
            String sName = "";
            //append the last name and first name together
            if (lName != null && !lName.equals(""))
              sName = lName;
            if (!sName.equals("") && fName != null && !fName.equals("")) sName += ", ";
            sName += fName;
            hPer.put(sID, sName);  //add it to the hash table
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR in GetACService- getPersonsList for exception : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR in GetACService-getPersonsList for close : " + ee.toString());
    }
    //store it in the session attributes
    HttpSession session = (HttpSession)m_classReq.getSession();
    session.setAttribute("Persons", hPer);
  } //getPersonsList

}//close the class
