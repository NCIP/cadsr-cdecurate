
// Copyright (c) 2000 ScenPro, Inc.
package com.scenpro.NCICuration;

import java.io.Serializable;
import java.util.*;
import java.sql.*;
import java.math.*;
import oracle.jdbc.driver.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.text.*;

import org.apache.log4j.*;

/**
 * GetACSearch class is for search action of the tool for all components.
 * <P>
 * @author Sumana Hegde
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

public class GetACSearch implements Serializable
{
  NCICurationServlet m_servlet = null;
  UtilService m_util = new UtilService();
  HttpServletRequest m_classReq = null;
  HttpServletResponse m_classRes = null;
  Logger logger = Logger.getLogger(GetACSearch.class.getName());

  /**
   * Constructs a new instance.
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param CurationServlet NCICuration servlet object.
   */
  public GetACSearch(HttpServletRequest req, HttpServletResponse res,
                     NCICurationServlet CurationServlet)
  {
    m_classReq = req;
    m_classRes = res;
    m_servlet = CurationServlet;
  }
  
    /**
   * Constructs a new instance.
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   */
  public GetACSearch(HttpServletRequest req, HttpServletResponse res)
  {
    m_classReq = req;
    m_classRes = res;
    m_servlet = null;
  } 

  /**
   * To start a new search called from NCICurationServlet.
   * selected component, keyword, selected context, seletcted status parameters of request are stored in session.
   * calls search method for selected component to get the result set from the database.
   * search result from the database is stored in session vector "vACSearch".
   * calls method 'setAttributeValues' to get list of selected attributes at search.
   * calls method 'getRowSelected' to get list of checked rows to display.
   * calls get result method for selected component to get vector of selected attribute and checked rows from the ACSearch vector.
   * final result vector is stored in the session vector "results".
   * calls method 'stackSearchComponents' to store the results, ac in the stack to use it for back button on the searchpage
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */

  public void getACKeywordResult(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();     //get the session
      //capture the duration
      java.util.Date startDate = new java.util.Date();          
   //   logger.info(m_servlet.getLogMessage(req, "getACKeywordResult", "starting search", startDate, startDate));
      
      Vector vAC = new Vector();
      Vector vS = new Vector();
      SetACService setAC = new SetACService(m_servlet);
      session.setAttribute("sortType", "longName");
      session.setAttribute("serProtoID", "");  //empty the proto id attribute

      //get the selected Administed component for Search
      String sComponent = (String)req.getParameter("listSearchFor");
      if (sComponent != null)
        session.setAttribute("searchAC", sComponent);
      else
        session.setAttribute("searchAC", "DataElement");

      String sSearchAC = (String)session.getAttribute("searchAC");

      //do the keyword search for the selected component
      String sKeyword = (String)req.getParameter("keyword");
      if (sKeyword != null)
      {
        //call the method to set the attribute checked values
        setAttributeValues(req, res, sSearchAC, "nothing");

        session.setAttribute("serKeyword", sKeyword);   //keep the old keyword criteria
        session.setAttribute("LastAppendWord", sKeyword);

        UtilService util = new UtilService();
        sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);  //parse the string to handle single quote
        //filter by context 
        String sContext = "";
          sContext = this.getMultiReqValues(sSearchAC, "MainSearch", "Context");      
  
        //filter by contextUse
        String sContextUse = (String)req.getParameter("rContextUse");
        session.setAttribute("serContextUse", sContextUse);   //store contextUse in the session
        if (sContextUse == null) sContextUse = "";

        //filter by version
        String sVersion = (String)req.getParameter("rVersion");
        session.setAttribute("serVersion", sVersion);   //store version in the session
        //get the version number if other
        String txVersion = "";
        if (sVersion != null && sVersion.equals("Other"))
          txVersion = (String)req.getParameter("tVersion");
        if (txVersion == null) txVersion = "";
        session.setAttribute("serVersionNum", txVersion);   //store version in the session
        double dVersion = 0;
        //validate the version and display message if not valid
        if (!txVersion.equals(""))
        {
          //String sValid = setAC.checkVersionDimension(txVersion);
          String sValid = setAC.checkValueIsNumeric(txVersion, "Version");
          if (sValid != null && !sValid.equals(""))
          {
             logger.fatal("not a good version " + sValid);
             session.setAttribute("serVersionNum", "0");
          }
          else
          {
             Double DVersion = new Double(txVersion);
             dVersion = DVersion.doubleValue();
          }
        }
        //make sVersion to empty if all or other
        if (sVersion == null || sVersion.equals("All") || sVersion.equals("Other")) sVersion = "";
     
        //filter by value domain type enumerated
        String sVDType = "";
        String sVDTypeEnum = (String)req.getParameter("enumBox");
        session.setAttribute("serVDTypeEnum", sVDTypeEnum);   //store VDType Enum in the session
        if (sVDTypeEnum != null) sVDType = "E";

        //filter by value domain type non enumerated
        String sVDTypeNonEnum = (String)req.getParameter("nonEnumBox");
        session.setAttribute("serVDTypeNonEnum", sVDTypeNonEnum);   //store VDType Non Enum in the session
        if (sVDTypeNonEnum != null && !sVDTypeNonEnum.equals(""))
        {
            if (!sVDType.equals("")) sVDType = sVDType + ", ";
            sVDType = sVDType + "N";        
        }
          
        //filter by value domain type enumerated by reference
        String sVDTypeRef = (String)req.getParameter("refEnumBox");
        session.setAttribute("serVDTypeRef", sVDTypeRef);   //store VDType Ref in the session
        if (sVDTypeRef != null && !sVDTypeRef.equals(""))
        {
            if (!sVDType.equals("")) sVDType = sVDType + ", ";
            sVDType = sVDType + "R";        
        }
        sVDType = sVDType.trim();  //trim extra spaces if any

        String sSchemes = "";
      //  if (sSearchAC.equals("ClassSchemeItems"))
      //  {
           sSchemes = (String)req.getParameter("listCSName");    //get selected CSI
           if (sSchemes != null && sSchemes.equalsIgnoreCase("AllSchemes"))
              sSchemes = "";
           session.setAttribute("selCS", sSchemes);
      //  }
        
        String sCDid = "";
      //  if (sSearchAC.equals("PermissibleValue"))
      //  {
           sCDid = (String)req.getParameter("listCDName");    //get selected cd
           session.setAttribute("serSelectedCD", sCDid);
           if (sCDid != null && sCDid.equalsIgnoreCase("All Domains"))
              sCDid = "";
      //  }
      
        //filter by workflow status
        String sStatus = getStatusValues(req, res, sSearchAC, "MainSearch");   //to get a string from multiselect list
        if ((sStatus == null) || sStatus.equals("AllStatus"))
           sStatus = "";
     
        //filter by registration status
        String sRegStatus = (String)req.getParameter("listRegStatus");
        session.setAttribute("serRegStatus", sRegStatus);   //store regstatus in the session
        if (sRegStatus == null || sRegStatus.equals("allReg")) sRegStatus = "";

        //fitler by date created from date
        String sCreatedFrom = (String)req.getParameter("createdFrom");
        session.setAttribute("serCreatedFrom", sCreatedFrom);   //store date created From in the session
        if (sCreatedFrom == null) sCreatedFrom = "";

        //fitler by date created To date
        String sCreatedTo = (String)req.getParameter("createdTo");
        session.setAttribute("serCreatedTo", sCreatedTo);   //store date created To in the session
        if (sCreatedTo == null) sCreatedTo = "";

        //fitler by date Modified from date
        String sModifiedFrom = (String)req.getParameter("modifiedFrom");
        session.setAttribute("serModifiedFrom", sModifiedFrom);   //store date Modified From in the session
        if (sModifiedFrom == null) sModifiedFrom = "";

        //fitler by date Modified To date
        String sModifiedTo = (String)req.getParameter("modifiedTo");
        session.setAttribute("serModifiedTo", sModifiedTo);   //store date Modified To in the session
        if (sModifiedTo == null) sModifiedTo = "";

        //fitler by Modifier type
        String sModifier = (String)req.getParameter("modifier");
        session.setAttribute("serModifier", sModifier);   //store Modifier in the session
        if ((sModifier == null) || sModifier.equals("allUsers")) sModifier = "";

        //fitler by Creator type
        String sCreator = (String)req.getParameter("creator");
        session.setAttribute("serCreator", sCreator);   //store Creator in the session
        if ((sCreator == null) || sCreator.equals("allUsers")) sCreator = "";

        //get value of search in
        String sSearchIn = (String)req.getParameter("listSearchIn");
        if (sSearchIn == null) sSearchIn = "longName";
            session.setAttribute("serSearchIn", sSearchIn);  //keep the main search in criteria
        //search in by public id
        if (sSearchIn.equals("minID"))
        {
           String sMinID = sKeyword;
           if ((sMinID != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, 
                  sRegStatus, sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, 
                  sModifier, "", "", sMinID, "", "", "", "", "", "", "", "", "", "",vAC);  //get the list of Data Elements
           }
           else if ((sMinID != "") && sSearchAC.equals("DataElementConcept"))
           {
             doDECSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID, "", "", "", 
                  dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts
           }
           else if ((sMinID != "") && sSearchAC.equals("ValueDomain"))
           {
             doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                  sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID,  
                  "", "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains
           }
           else if ((sMinID != "") && sSearchAC.equals("ConceptualDomain"))
           {
             doCDSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID, "", dVersion, vAC);  //get the list of Conceptual Domains
           }
           else if ((sMinID != "") && sSearchAC.equals("ObjectClass"))
           {
                do_caDSRSearch("", sContext, sStatus, sMinID, vAC, "OC");
           }
           else if ((sMinID != "") && sSearchAC.equals("Property"))
           {
                do_caDSRSearch("", sContext, sStatus, sMinID, vAC, "PROP");
           }  

        }
        //call function if seach in is crfName
        else if (sSearchIn.equals("CRFName"))
        {
           //do the keyword search for the selected component
           String sProtoID = (String)req.getParameter("protoKeyword");
           session.setAttribute("serProtoID", sProtoID);  //keep the old criteria
           sProtoID = util.parsedStringSingleQuoteOracle(sProtoID);
           //crf name is keyword 
           String sCRFName = sKeyword;
           //crf search if search ac is data element
           if (sSearchAC.equals("DataElement"))
           {
              doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, 
                  sRegStatus, sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, 
                  sModifier, "", "", "", "", "", "", sProtoID, sCRFName, "", "", "", "", "", vAC);  //get the list of Data Elements             
           }

             // doDE_CRFSearch(sProtoID, sKeyword, sContext, sVersion, sStatus, sRegStatus, 
             //   sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, vAC);
        }
        //search in by doc text
        else if (sSearchIn.equals("docText"))
        {           
           String sDocs[] = req.getParameterValues("listRDType");
           String sDocTypes = "ALL";
           if (sDocs != null && sDocs.length > 0)
              sDocTypes = this.getDocTypeValues(sDocs, "MainSearch");
         
           String sDocText = sKeyword;
           if (sDocText == null || sDocText.equals(""))
              sDocText = "*";
           if ((sDocText != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, 
                  sRegStatus, sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, 
                  sModifier, sDocText, sDocTypes, "", "", "", "", "", "", "", "", "", "", "", vAC);   //get the list of Data Elements for docText searchin
           }
        }
        //search in by names adn doc text long name and historic short cde name
        else if (sSearchIn.equals("NamesAndDocText"))
        {
           String sDocTypes = "LONG_NAME, HISTORIC SHORT CDE NAME";         
           String sDocText = sKeyword;
           if (sDocText == null || sDocText.equals(""))
              sDocText = "*";
           if ((sDocText != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", sKeyword, "", sContext, sContextUse, sVersion, dVersion, sStatus, 
                  sRegStatus, sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, 
                  sModifier, sDocText, sDocTypes, "", "", "", "", "", "", "", "", "", "", "", vAC);   //get the list of Data Elements for Names and docText searchin
           }
        }
        //search in by historical cde id
        else if (sSearchIn.equals("histID"))
        {
           String sHistID = sKeyword;
           if ((sHistID != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, 
                  sRegStatus, sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, 
                  sModifier, "", "", "", sHistID, "", "", "", "", "", "", "", "", "", vAC);  //get the list of Data Elements for Historical ID seach in
           }       
        }
        //search in by permissible value
        else if (sSearchIn.equals("permValue"))
        {
           String permValue = sKeyword;
           if ((permValue != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                  sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                  "", "", "", "", permValue, "", "", "", "", "", "", "", "", vAC); //get the list of Data Elements for permissible value search in
           }
           else if ((permValue != "") && sSearchAC.equals("ValueDomain"))
           {
             doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                  sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "",  
                  permValue, "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains for permissible value search in
           }
        }
       
        //search in by origin
        else if (sSearchIn.equals("origin"))
        {
           String sOrigin = sKeyword;
           if ((sOrigin != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                  sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                  "", "", "", "", "", sOrigin, "", "", "", "", "", "", "", vAC);  //get the list of Data Elements for origin search in
           }
           else if ((sOrigin != "") && sSearchAC.equals("DataElementConcept"))
           {
             doDECSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", "", sOrigin, 
                  dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts for origin search in
           }
           else if ((sOrigin != "") && sSearchAC.equals("ValueDomain"))
           {
             doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                  sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "",  "", 
                  sOrigin, dVersion, sCDid, "", "", vAC);  //get the list of Value Domains for origin search in
           }
           else if ((sOrigin != "") && sSearchAC.equals("ConceptualDomain"))
           {
             doCDSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, "", sOrigin, dVersion, vAC);  //get the list of Conceptual Domains for origin search in
           }
        }
        //search in by names and definitions
        else
        {
          // call the method to get the data from the database
          if (sSearchAC.equals("DataElement"))
          {
             doDESearch("", sKeyword, "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                "", "", "", "", "", "", "", "", "", "", "", "", "", vAC);  //get the list of Data Elements
          }
          else if (sSearchAC.equals("DataElementConcept"))
          {
             doDECSearch("", sKeyword, "", sContext, sVersion, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", "", "", dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts for keyword
          }
          else if (sSearchAC.equals("ValueDomain"))
          {
             doVDSearch("", sKeyword, "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "",  
                "", "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains for permissible value search in
          }
          else if (sSearchAC.equals("PermissibleValue"))
             doPVVMSearch(sKeyword, sCDid, vAC);  //get the list of PVVM's
          else if (sSearchAC.equals("ObjectClass"))
          {
            sKeyword = filterName(sKeyword, "display");
            do_caDSRSearch(sKeyword, sContext, sStatus, "", vAC, "OC");
          }
          else if (sSearchAC.equals("Property"))
          {
             sKeyword = filterName(sKeyword, "display");
             do_caDSRSearch(sKeyword, sContext, sStatus, "", vAC, "PROP");
          }
          else if (sSearchAC.equals("ConceptualDomain"))
          {
             doCDSearch("", sKeyword, "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", dVersion, vAC);  //get the list of Conceptual Domains
          }
          else if (sSearchAC.equals("ClassSchemeItems"))
            doCSISearch(sKeyword, sContext, sSchemes, vAC);  //get the list of Class Scheme Items
        }

        //append the searched data with old data.
        String AppendAction = (String)session.getAttribute("AppendAction");
        if (AppendAction != null && AppendAction.equals("Appended"))
        {
           session.setAttribute("newSearchRes", vAC);  //store to append it to the existing
           getRowSelected(req, res, true);
           session.setAttribute("AppendAction", "Was Appended");
        }
        else
        {
            session.setAttribute("AppendAction", "Not Appended");
            session.setAttribute("vSelRows", vAC);        //store the only searched data
            Vector vCheckList = new Vector();
            session.setAttribute("CheckList", vCheckList); //empty the check list in the new search when not appended.
        }
        // do ID's up here because it will need an existing ID stack first time into getResult
        if (sSearchAC.equals("DataElement")||sSearchAC.equals("DataElementConcept")
        || sSearchAC.equals("ValueDomain")||sSearchAC.equals("ConceptualDomain")
        || sSearchAC.equals("ObjectClass")||sSearchAC.equals("Property")
        || sSearchAC.equals("ClassSchemeItems")||sSearchAC.equals("PermissibleValue"))
        {
          Stack vSearchIDStack = new Stack();
          session.setAttribute("vSearchIDStack", vSearchIDStack); 
          Stack vSearchNameStack = new Stack();
          session.setAttribute("vSearchNameStack", vSearchNameStack);
          Stack vSearchLongNameStack = new Stack();
          session.setAttribute("vSearchLongNameStack", vSearchLongNameStack);
          Stack vSearchUsedContextStack = new Stack();
          session.setAttribute("vSearchUsedContextStack", vSearchUsedContextStack);
          Stack sSearchACStack = new Stack();
          session.setAttribute("sSearchACStack", sSearchACStack);
          Stack vACSearchStack = new Stack();
          session.setAttribute("vACSearchStack", vACSearchStack);
          Stack vSearchASLStack = new Stack();
          session.setAttribute("vSearchASLStack", vSearchASLStack);
          Stack vSelRowsStack = new Stack();
          session.setAttribute("vSelRowsStack", vSelRowsStack);
          Stack vResultStack = new Stack();
          session.setAttribute("vResultStack", vResultStack);
          Stack vCompAttrStack = new Stack();
          session.setAttribute("vCompAttrStack", vCompAttrStack);
          Stack vAttributeListStack = new Stack();
          session.setAttribute("vAttributeListStack", vAttributeListStack);
          EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
          //call method to get the final result vector
          Vector vResult = new Vector();
          if (sSearchAC.equals("DataElement"))
            getDEResult(req, res, vResult, "");
          else if (sSearchAC.equals("DataElementConcept"))
            getDECResult(req, res, vResult, "");
          else if (sSearchAC.equals("ValueDomain"))
            getVDResult(req, res, vResult, "");
          else if (sSearchAC.equals("PermissibleValue"))
            getPVVMResult(req, res, vResult, "");
          else if (sSearchAC.equals("ObjectClass"))
             evs.get_Result(req, res, vResult, "");
          else if (sSearchAC.equals("Property"))
             evs.get_Result(req, res, vResult, "");
          else if (sSearchAC.equals("Questions"))
            getQuestionResult(req, res, vResult);
          else if (sSearchAC.equals("ConceptualDomain"))
            getCDResult(req, res, vResult, "");
          else if (sSearchAC.equals("ClassSchemeItems"))
            getCSIResult(req, res, vResult, "");
  
          //store result vector in the attribute
          session.setAttribute("results", vResult);
        }
      }
      //capture the duration
   //   logger.info(m_servlet.getLogMessage(req, "getKeywordResult", "ending search", startDate, new java.util.Date()));
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - GetACSearch-getKeywordResult!! : " + e.toString());
    }
  }

  /**
   * Stores search parameter attributes in the hash table and in session attributes to access it later.
   * 
   */
   private HashMap storeSearchParamAttr()
   {
      HttpSession session = m_classReq.getSession();     //get the session
      Vector vAC = new Vector();
      Vector vS = new Vector();
      SetACService setAC = new SetACService(m_servlet);
      session.setAttribute("sortType", "longName");
      session.setAttribute("serProtoID", "");  //empty the proto id attribute
      //create hash map
      HashMap paramMap = new HashMap();
      
      //get the selected Administed component for Search
      String sComponent = (String)m_classReq.getParameter("listSearchFor");
      if (sComponent != null)
        session.setAttribute("searchAC", sComponent);
      else
        session.setAttribute("searchAC", "DataElement");
      paramMap.put("sComponent", sComponent);    //put the key and object in the map
      
      String sSearchAC = (String)session.getAttribute("searchAC");
      paramMap.put("sSearchAC", sSearchAC);    //put the key and object in the map

      //do the keyword search for the selected component
      String sKeyword = (String)m_classReq.getParameter("keyword");
      if (sKeyword != null)
      {
        //call the method to set the attribute checked values
        setAttributeValues(m_classReq, m_classRes, sSearchAC, "nothing");

        session.setAttribute("serKeyword", sKeyword);   //keep the old keyword criteria
        session.setAttribute("LastAppendWord", sKeyword);

        UtilService util = new UtilService();
        sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);  //parse the string to handle single quote
        paramMap.put("sKeyword", sKeyword);    //put the key and object in the map after parsing

        //filter by context 
        String sContext = (String)m_classReq.getParameter("listContextFilter");
       // session.setAttribute("serContext", sContext);   //keep the old context criteria
        if ((sContext == null)||(sContext.equals("AllContext") == true))
          sContext = "";
        paramMap.put("sContext", sContext);    //put the key and object in the map after validity

        //filter by contextUse
        String sContextUse = (String)m_classReq.getParameter("rContextUse");
        session.setAttribute("serContextUse", sContextUse);   //store contextUse in the session
        if (sContextUse == null) sContextUse = "";
        paramMap.put("sContextUse", sContextUse);    //put the key and object in the map after validity

        //filter by version
        String sVersion = (String)m_classReq.getParameter("rVersion");
        session.setAttribute("serVersion", sVersion);   //store version in the session
        //get the version number if other
        String txVersion = "";
        if (sVersion != null && sVersion.equals("Other"))
          txVersion = (String)m_classReq.getParameter("tVersion");
        if (txVersion == null) txVersion = "";
        session.setAttribute("serVersionNum", txVersion);   //store version in the session
        //double dVersion = 0;
        Double DVersion = new Double(txVersion);
        //validate the version and display message if not valid
        if (!txVersion.equals(""))
        {
          String sValid = setAC.checkVersionDimension(txVersion);
          if (sValid != null && !sValid.equals(""))
          {
             logger.fatal("not a good version " + sValid);
          }
        }
        //make sVersion to empty if all or other
        if (sVersion == null || sVersion.equals("All") || sVersion.equals("Other")) sVersion = "";
        paramMap.put("sVersion", sVersion);    //put the key and object in the map after validity
        paramMap.put("DVersion", DVersion);    //put the key and object in the map after validity
     
        //filter by value domain type enumerated
        String sVDType = "";
        String sVDTypeEnum = (String)m_classReq.getParameter("enumBox");
        session.setAttribute("serVDTypeEnum", sVDTypeEnum);   //store VDType Enum in the session
        if (sVDTypeEnum != null) sVDType = "E";

        //filter by value domain type non enumerated
        String sVDTypeNonEnum = (String)m_classReq.getParameter("nonEnumBox");
        session.setAttribute("serVDTypeNonEnum", sVDTypeNonEnum);   //store VDType Non Enum in the session
        if (sVDTypeNonEnum != null && !sVDTypeNonEnum.equals(""))
        {
            if (!sVDType.equals("")) sVDType = sVDType + ", ";
            sVDType = sVDType + "N";        
        }
          
        //filter by value domain type enumerated by reference
        String sVDTypeRef = (String)m_classReq.getParameter("refEnumBox");
        session.setAttribute("serVDTypeRef", sVDTypeRef);   //store VDType Ref in the session
        if (sVDTypeRef != null && !sVDTypeRef.equals(""))
        {
            if (!sVDType.equals("")) sVDType = sVDType + ", ";
            sVDType = sVDType + "R";        
        }
        sVDType = sVDType.trim();  //trim extra spaces if any

        String sStatus = "";
        if (sSearchAC.equals("ClassSchemeItems"))
        {
           sStatus = (String)m_classReq.getParameter("listCSName");    //get selected CSI
           if (sStatus.equalsIgnoreCase("AllSchemes"))
              sStatus = "";
           session.setAttribute("selCS", sStatus);
        }
        else if (sSearchAC.equals("PermissibleValue"))
        {
           sStatus = (String)m_classReq.getParameter("listCDName");    //get selected cd
           session.setAttribute("serSelectedCD", sStatus);
        }
        else
           sStatus = getStatusValues(m_classReq, m_classRes, sSearchAC, "MainSearch");   //to get a string from multiselect list

        if ((sStatus == null) || sStatus.equals("AllStatus") || sStatus.equals("All Domains"))
           sStatus = "";
     
        //filter by registration status
        String sRegStatus = (String)m_classReq.getParameter("listRegStatus");
        session.setAttribute("serRegStatus", sRegStatus);   //store regstatus in the session
        if (sRegStatus == null || sRegStatus.equals("allReg")) sRegStatus = "";

        //fitler by date created from date
        String sCreatedFrom = (String)m_classReq.getParameter("createdFrom");
        session.setAttribute("serCreatedFrom", sCreatedFrom);   //store date created From in the session
        if (sCreatedFrom == null) sCreatedFrom = "";

        //fitler by date created To date
        String sCreatedTo = (String)m_classReq.getParameter("createdTo");
        session.setAttribute("serCreatedTo", sCreatedTo);   //store date created To in the session
        if (sCreatedTo == null) sCreatedTo = "";

        //fitler by date Modified from date
        String sModifiedFrom = (String)m_classReq.getParameter("modifiedFrom");
        session.setAttribute("serModifiedFrom", sModifiedFrom);   //store date Modified From in the session
        if (sModifiedFrom == null) sModifiedFrom = "";

        //fitler by date Modified To date
        String sModifiedTo = (String)m_classReq.getParameter("modifiedTo");
        session.setAttribute("serModifiedTo", sModifiedTo);   //store date Modified To in the session
        if (sModifiedTo == null) sModifiedTo = "";

        //fitler by Modifier type
        String sModifier = (String)m_classReq.getParameter("modifier");
        session.setAttribute("serModifier", sModifier);   //store Modifier in the session
        if ((sModifier == null) || sModifier.equals("allUsers")) sModifier = "";

        //fitler by Creator type
        String sCreator = (String)m_classReq.getParameter("creator");
        session.setAttribute("serCreator", sCreator);   //store Creator in the session
        if ((sCreator == null) || sCreator.equals("allUsers")) sCreator = "";

        //get value of search in
        String sSearchIn = (String)m_classReq.getParameter("listSearchIn");
        if (sSearchIn == null) sSearchIn = "longName";
            session.setAttribute("serSearchIn", sSearchIn);  //keep the main search in criteria
      }
      return paramMap;
   } // end storeSearchParamAttr
   
   
  /**
   * Adds the search component, result bean vector and result vector in a stack to use it later.
   * 
   * @param sSearchAC the name of the selected component
   * @param vAC the vector of bean from the result
   * @param vRSel the vector of selected results
   * @param vSearchID the vector of id's
   * @param vSearchName the vector of names
   * @param vResult result vector used to display.
   * 
   * @throws Exception
   */
  
   private void pushAllOntoStack(Stack sSearchACStack, Stack vACSearchStack, Stack vSelRowsStack, Stack vSearchIDStack,
   Stack vSearchNameStack, Stack vSearchUsedContextStack, Stack vResultStack, Stack vCompAttrStack, Stack vAttributeListStack,
   String sSearchAC, Vector vAC,  Vector vRSel, Vector vSearchID, Vector vSearchName, Vector vResult, Stack vSearchASLStack, 
   Vector vSearchASL, Stack vSearchLongNameStack, Vector vSearchLongName) throws Exception
   {
     try
     {
       HttpSession session = m_classReq.getSession();
       if(sSearchACStack != null)
      {
//System.out.println("pushAll sSearchAC: " + sSearchAC + " vSearchLongNameStack: " + vSearchLongNameStack);
        sSearchACStack.push(sSearchAC);
        session.setAttribute("sSearchACStack", sSearchACStack);
      }
      if(vACSearchStack != null)
      {
        vACSearchStack.push(vAC);
        session.setAttribute("vACSearchStack", vACSearchStack);
      }
      if(vSearchASLStack != null)
      {
        vSearchASLStack.push(vSearchASL);
        session.setAttribute("vSearchASLStack", vSearchASLStack);
      }
      if(vSelRowsStack != null)
      {
        vSelRowsStack.push(vRSel);
        session.setAttribute("vSelRowsStack", vSelRowsStack);
      }
      if(vSearchIDStack != null)
      {
        vSearchIDStack.push(vSearchID);
        session.setAttribute("vSearchIDStack", vSearchIDStack);
// System.out.println("pushAllOntoStack: vSearchIDStack.size: " + vSearchIDStack.size());
      }
      if(vSearchNameStack != null)
      {
        vSearchNameStack.push(vSearchName);
        session.setAttribute("vSearchNameStack", vSearchNameStack);
      }
       if(vSearchLongNameStack != null)
      {
        vSearchLongNameStack.push(vSearchLongName);
        session.setAttribute("vSearchLongNameStack", vSearchLongNameStack);
      }
      if(vResultStack != null)
      {
        vResultStack.push(vResult);
        session.setAttribute("vResultStack", vResultStack);
      }
      
      Vector vCompAttr = new Vector();
      String sMenu = (String)session.getAttribute("MenuAction");
      if (sMenu.equals("searchForCreate"))
            vCompAttr = (Vector)session.getAttribute("creSelectedAttr");
      else
            vCompAttr = (Vector)session.getAttribute("selectedAttr");
      if(vCompAttrStack != null && vCompAttr != null)
      {
        vCompAttrStack.push(vCompAttr);
        session.setAttribute("vCompAttrStack", vCompAttrStack);
      }

      Vector vACAttr = new Vector();
      if (sMenu.equals("searchForCreate"))
            vACAttr = (Vector)session.getAttribute("creAttributeList");
      else
            vACAttr = (Vector)session.getAttribute("serAttributeList");
      if(vAttributeListStack != null && vACAttr != null)
      {
        vAttributeListStack.push(vACAttr);
        session.setAttribute("vAttributeListStack", vAttributeListStack);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-pushAllOntoStack: " + e);
      logger.fatal("ERROR in GetACSearch-pushAllOntoStack : " + e.toString());
    }
   }

  /**
   * Adds the search component, result bean vector and result vector in a stack to use it later.
   * 
   * @param sSearchAC the name of the selected component
   * @param vAC the vector of bean from the result
   * @param vRSel the vector of selected results
   * @param vSearchID the vector of id's
   * @param vSearchName the vector of names
   * @param vResult result vector used to display.
   * @param vSearchASL result vector used to display.
   * 
   * @throws Exception
   */
   public void stackSearchComponents(String sSearchAC, Vector vAC,  Vector vRSel,
   Vector vSearchID, Vector vSearchName, Vector vResult, Vector vSearchASL, Vector vSearchLongName) throws Exception
   {
  //System.out.println("stackSearchComponents sSearchAC: " + sSearchAC);
      HttpSession session = m_classReq.getSession();     //get the session
      String sSearchAC2 = "";
      String sDummyVariable = "";
      Vector vDummyVector = new Vector();   
      // for Back button, put search results on a stack
    if (sSearchAC.equals("DataElement")||sSearchAC.equals("DataElementConcept")
    || sSearchAC.equals("ValueDomain")||sSearchAC.equals("ConceptualDomain")
    || sSearchAC.equals("ObjectClass")||sSearchAC.equals("Property")
    || sSearchAC.equals("ClassSchemeItems")||sSearchAC.equals("PermissibleValue"))
    {
    try
    {
      // for Back button, put search results on a stack
      Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
      Stack vACSearchStack = (Stack)session.getAttribute("vACSearchStack");
      Stack vSearchASLStack = (Stack)session.getAttribute("vSearchASLStack");
      Stack vSelRowsStack = (Stack)session.getAttribute("vSelRowsStack");
      Stack vSearchIDStack = (Stack)session.getAttribute("vSearchIDStack");
      Stack vSearchNameStack = (Stack)session.getAttribute("vSearchNameStack");
      Stack vSearchLongNameStack = (Stack)session.getAttribute("vSearchLongNameStack");
      Stack vSearchUsedContextStack = (Stack)session.getAttribute("vSearchUsedContextStack");
      Stack vResultStack = (Stack)session.getAttribute("vResultStack");
      Stack vCompAttrStack = (Stack)session.getAttribute("vCompAttrStack");
      Stack vAttributeListStack = (Stack)session.getAttribute("vAttributeListStack");
    
      if(sSearchACStack != null && sSearchACStack.size()>0)
      {
        sSearchAC2 = (String)sSearchACStack.peek();
      }
      if(sSearchAC2 != null && sSearchAC2.equals(sSearchAC))
      {
        // pop all the others
        if (sSearchACStack != null && sSearchACStack.size()>0)
          sSearchAC2 = (String)sSearchACStack.pop();
        if (vACSearchStack != null && vACSearchStack.size()>0)
          vDummyVector = (Vector)vACSearchStack.pop();
         if (vSearchASLStack != null && vSearchASLStack.size()>0)
          vDummyVector = (Vector)vSearchASLStack.pop();
        if (vSelRowsStack != null && vSelRowsStack.size()>0)
          vDummyVector = (Vector)vSelRowsStack.pop();
        if (vSearchIDStack != null && vSearchIDStack.size()>0)
          vDummyVector = (Vector)vSearchIDStack.pop();
        if (vSearchNameStack != null && vSearchNameStack.size()>0)
          vDummyVector = (Vector)vSearchNameStack.pop();
         if (vSearchLongNameStack != null && vSearchLongNameStack.size()>0)
          vDummyVector = (Vector)vSearchLongNameStack.pop();
        if (vSearchUsedContextStack != null && vSearchUsedContextStack.size()>0) 
          vDummyVector = (Vector)vSearchUsedContextStack.pop();
        if (vResultStack != null && vResultStack.size()>0)
          vDummyVector = (Vector)vResultStack.pop();
        if (vCompAttrStack != null && vCompAttrStack.size()>0)
          vDummyVector = (Vector)vCompAttrStack.pop();
         if (vAttributeListStack != null && vAttributeListStack.size()>0)
          vDummyVector = (Vector)vAttributeListStack.pop();  
 //  System.out.println("stackSearchComponents pushAll1: ");
        // then push All new ones onto stack
        pushAllOntoStack(sSearchACStack, vACSearchStack, vSelRowsStack, vSearchIDStack, vSearchNameStack,
        vSearchUsedContextStack, vResultStack, vCompAttrStack, vAttributeListStack,
        sSearchAC, vAC, vRSel, vSearchID, vSearchName, vResult, vSearchASLStack, vSearchASL, vSearchLongNameStack, vSearchLongName);
      }
      else if(sSearchAC2 != null && sSearchACStack != null)
      {
// System.out.println("stackSearchComponents pushAll2: ");
        // push All Others
        pushAllOntoStack(sSearchACStack, vACSearchStack, vSelRowsStack, vSearchIDStack, vSearchNameStack,
        vSearchUsedContextStack, vResultStack, vCompAttrStack, vAttributeListStack,
        sSearchAC, vAC, vRSel, vSearchID, vSearchName, vResult, vSearchASLStack, vSearchASL, vSearchLongNameStack, vSearchLongName);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-stackSearchComponents: " + e);
      logger.fatal("ERROR in GetACSearch-stackSearchComponents : " + e.toString());
    }
   }
  }

   
  /**
   * To get the ac_idseq of the component when the selected searchIn is CDE_ID,
   * called from method getACKeywordResult
   * uses sql query "SELECT ac_idseq FROM de_cde_id_view where min_cde_id = '" + sCDEID + "'"
   *
   * @param sCDEID from the keyword input box.
   *
   * @return String ac_idseq if found. otherwise empty string.
   */

   //note : need to handle exceptions here.
  private String getCDEIDSearch(String sCDEID)  // get the ac id for the selected cdeid.
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    Statement CStmt = null;
    String s = "";
    try
    {
      String sql = "SELECT ac_idseq FROM de_cde_id_view where min_cde_id = '" + sCDEID + "'";
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.createStatement();
        //store the output in the resultset
        rs = CStmt.executeQuery(sql);
        //loop through to printout the outstrings
        while(rs.next())
        {
          s = "";
          s = s + rs.getString("ac_idseq");
          return s;
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("error exception in GetACSearch-CDEIDSearch: " + e);
      logger.fatal("ERROR - GetACSearch-getCDEIDSearch for others : " + e.toString());
    }

    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-CDEIDSearch: " + ee);
      logger.fatal("GetACSearch-getCDEIDSearch for closing : " + ee.toString());
    }
    return s;
  }  //end search cdeid

  /**
   * To get selected attributes or rows to display, called from NCICurationServlet.
   * calls method 'setAttributeValues' to get list of selected attributes at search.
   * calls method 'getRowSelected' to get list of checked rows to display.
   * calls method 'getDEResult' for selected component to get vector of selected attribute and checked rows from the ACSearch vector.
   * final result vector is stored in the session vector "results".
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param actType selected action type.
   *
   */

  public void getACShowResult(HttpServletRequest req, HttpServletResponse res,
         String actType)
  {
    try
    {

      HttpSession session = req.getSession();
      String sSearchAC = "";
      String menuAction = (String)session.getAttribute("MenuAction");
      String sComponent = "";
      if (menuAction.equals("searchForCreate"))
          sSearchAC = (String)session.getAttribute("creSearchAC");
      else
          sSearchAC = (String)session.getAttribute("searchAC");
      //selected more attributes from the display attribute list.
      if (actType.equals("Attribute"))
        setAttributeValues(req, res, sSearchAC, menuAction);
//System.out.println("getACShowResult actType: " + actType + " sSearchAC: " + sSearchAC);
      //store the append action in the session to handle new search
      String sAppendAct = (String)req.getParameter("AppendAction");
      if (sAppendAct != null)
      {
         session.setAttribute("AppendAction", sAppendAct);
         //save the last word in the request attribute
         session.setAttribute("LastAppendWord", (String)session.getAttribute("serKeyword"));
         session.setAttribute("serKeyword", "");   //keep the old criteria
      }

      //call the method to get the selected rows
      if (menuAction.equals("BEDisplay"))
         getRowSelectedBEDisplay(req, res);
      //get checked rows for data element in all cases and all others only for search for create
      else if (sSearchAC.equals("DataElement") || (!menuAction.equals("searchForCreate") && !actType.equals("Attribute")))
         getRowSelected(req, res, false);
      EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
      boolean isBlockSearch = false;
      String dtsVocab = req.getParameter("listContextFilterVocab");
      if (dtsVocab != null && !dtsVocab.equals("")) isBlockSearch = true;
      //call method to get the final result vector
      Vector vResult = new Vector();
        //get the final result for selected component
      if (sSearchAC.equals("DataElement"))
        getDEResult(req, res, vResult, "");
      else if (sSearchAC.equals("DataElementConcept"))
        getDECResult(req, res, vResult, "");
      else if (sSearchAC.equals("ValueDomain"))
        getVDResult(req, res, vResult, "");
      else if (sSearchAC.equals("PermissibleValue"))
        getPVVMResult(req, res, vResult, "");
      else if (sSearchAC.equals("Questions"))
        getQuestionResult(req, res, vResult);
      else if (sSearchAC.equals("ConceptualDomain"))
        getCDResult(req, res, vResult, "");
      else if (sSearchAC.equals("ClassSchemeItems"))
        getCSIResult(req, res, vResult, "");
      else if (sSearchAC.equals("ObjectClass") || sSearchAC.equals("Property"))
        evs.get_Result(req, res, vResult, "");
      else if (isBlockSearch == true)
        evs.get_Result(req, res, vResult, "");
  



      if(actType.equals("BEDisplayRows")) 
        session.setAttribute("resultsBEDisplay", vResult);
      else
        session.setAttribute("results", vResult);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR -  in GetACSearch-showResult: " + e);
      logger.fatal("ERROR - GetACSearch-showResult : " + e.toString());
    }
  }

  /**
   * To get the sorted result vector to display for selected sort type, called from NCICurationServlet.
   * calls method 'getDESortedRows' for the selected component to get sorted bean.
   * calls method 'getDEResult' for the selected component to result vector from the sorted bean.
   * final result vector is stored in the session vector "results".
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getACSortedResult(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
      //get the sort string parameter
      String sSortType = (String)req.getParameter("sortType");
      if (sSortType != null)
        session.setAttribute("sortType", sSortType);
      String sMenuAction = (String)session.getAttribute("MenuAction");
      String sComponent = "";
      if (sMenuAction.equals("searchForCreate"))
          sComponent = (String)session.getAttribute("creSearchAC");
      else
          sComponent = (String)session.getAttribute("searchAC");

      if ((!sComponent.equals("")) && (sComponent !=null))
      {
        Vector vResult = new Vector();
        if (sComponent.equals("DataElement"))
        {
          getDESortedRows(req, res);        //sort the DE bean
          getDEResult(req, res, vResult, "");
          //getDEResult(req, res, vResult, "true");
        }    //get final result vector
        else if (sComponent.equals("DataElementConcept"))
        {
          getDECSortedRows(req, res);       //sort the DEC bean
          getDECResult(req, res, vResult, "");
          //getDECResult(req, res, vResult, "true");
        }
        else if (sComponent.equals("ValueDomain"))
        {
          getVDSortedRows(req, res);          //sort the VD bean
          getVDResult(req, res, vResult, "");
         // getVDResult(req, res, vResult, "true");
        }
        else if (sComponent.equals("PermissibleValue"))
        {
          getPVVMSortedRows(req, res);          //sort the PVbean
          getPVVMResult(req, res, vResult, "");
          //getPVVMResult(req, res, vResult, "true");
        }
        else if (sComponent.equals("ValueMeaning"))
        {
          this.getVMSortedRows(req, res);          //sort the VMbean
          this.getVMResult(req, res, vResult);
        }
        else if (sComponent.equals("Questions"))
        {
          getQuestionSortedRows(req, res);          //sort the Question bean
          getQuestionResult(req, res, vResult);
        }
        else if (sComponent.equals("ConceptualDomain"))
        {
          getCDSortedRows(req, res);          //sort the conceptual domain bean
          getCDResult(req, res, vResult, "");
          //getCDResult(req, res, vResult, "true");
        }
        else if (sComponent.equals("ClassSchemeItems"))
        {
          getCSISortedRows(req, res);          //sort the class scheme items bean
          getCSIResult(req, res, vResult, "");
          //getCSIResult(req, res, vResult, "true");
        }
        else if (sComponent.equals("ObjectClass"))
        {
          getOCSortedRows(req, res);          //sort the class scheme items bean
          evs.get_Result(req, res, vResult, "");
         // get_Result(req, res, vResult, "true");
        }
        else if (sComponent.equals("Property"))
        {
          getPCSortedRows(req, res);          //sort the class scheme items bean
          evs.get_Result(req, res, vResult, "");
          //get_Result(req, res, vResult, "true");
        }
        session.setAttribute("results", vResult);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR - in GetACSearch-sortedResult: " + e);
      logger.fatal("ERROR - GetACSearch-sortedResult : " + e.toString());
    }
  }

  /**
   * To get the Question result vector to display for the user, called from NCICurationServlet.
   * calls method 'doQuestionSearch' to search the questions.
   * calls method 'setAttributeValues' to get the selected attributes.
   * calls method 'getQuestionSortedRows' for the selected component to get sorted bean.
   * calls method 'getQuestionResult' for the selected component to result vector from the sorted bean.
   * final result vector is stored in the session vector "results".
   *
   * @param userName String name of the user.
   * @throws exception e
   */
  public void getACQuestion() throws Exception
  {
      HttpSession session = m_classReq.getSession();
      Vector vResult = new Vector();
      session.setAttribute("searchAC", "Questions");
      session.setAttribute("MenuAction", "Questions");

      String userName = (String)session.getAttribute("Username");
      //call to search questions
      doQuestionSearch(userName, vResult);
      session.setAttribute("vACSearch", vResult);
      session.setAttribute("vSelRows", vResult);

      //get the selected attributes
      setAttributeValues(m_classReq, m_classRes, "Questions", "nothing");

      //get the final result
      vResult = new Vector();
      getQuestionResult(m_classReq, m_classRes, vResult);
      session.setAttribute("results", vResult);
  }

  /**
   * To get Search results for CRF from database for DE called from getACKeywordResult.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_CRF_DE(DE_IDSEQ, InString, ContID, ContName, 
   *      ASLName, CDE_ID, OracleTypes.CURSOR, createdFrom, ModifiedFrom, toCreated, fromCreated, 
   *      toModified, fromModified, sVersion, regStatus)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   * @param ProtoWord String Keyword for Protocol.
   * @param CRFWord String Keyword for CRF Name.
   * @param ContName String selected context name.
   * @param sVersion String selected version .
   * @param ASLName String selected workflow status name.
   * @param regStatus String selected Registration Status.
   * @param sCreatedFrom String created from date filter.
   * @param sCreatedTo String created to date filter.
   * @param sModifiedFrom String modified from date filter.
   * @param sModifiedTo String modified to date filter.
   * @param sCreator String selected creator.
   * @param sModifier String selected modifier.
   * @param vList returns Vector of DEbean.
   *
   */
  private void doDE_CRFSearch(String ProtoWord, String CRFWord, String ContName, String sVersion, 
          String ASLName, String regStatus, String sCreatedFrom, String sCreatedTo, String sModifiedFrom, 
          String sModifiedTo, String sCreator, String sModifier, Vector vList)  // returns list of Data Elements
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_CRF_DE(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(6, OracleTypes.CURSOR);

        // Now tie the placeholders for In parameters.
        CStmt.setString(1,ContName);
        CStmt.setString(2,CRFWord);
        CStmt.setString(3,ProtoWord);
        CStmt.setString(4,ASLName);
        CStmt.setString(5, "");
        CStmt.setString(7, sCreatedFrom);
        CStmt.setString(8, sCreatedTo);
        CStmt.setString(9, sModifiedFrom);
        CStmt.setString(10, sModifiedTo);
        CStmt.setString(11, sCreator);
        CStmt.setString(12, sModifier);
        CStmt.setString(13, sVersion);
        CStmt.setString(14, regStatus);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(6);

        String s;

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            DE_Bean DEBean = new DE_Bean();
            DEBean.setDE_ALIAS_NAME(rs.getString("preferred_name"));
            DEBean.setDE_PREFERRED_NAME(rs.getString("preferred_name"));
            DEBean.setDE_LONG_NAME(rs.getString("long_name"));
            DEBean.setDE_PREFERRED_DEFINITION(rs.getString("preferred_definition"));
            DEBean.setDE_ASL_NAME(rs.getString("asl_name"));
            DEBean.setDE_CONTE_IDSEQ(rs.getString("conte_idseq"));
            s = rs.getString("begin_date");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to dd/mm/yyyy format
            DEBean.setDE_BEGIN_DATE(s);
            s = rs.getString("end_date");
            if (s != null)
              s = m_util.getCurationDate(s);
            DEBean.setDE_END_DATE(s);
            DEBean.setDE_CONTEXT_NAME(rs.getString("name"));
            DEBean.setDE_DEC_IDSEQ(rs.getString("dec_idseq"));
            DEBean.setDE_DEC_NAME(rs.getString("dec_name"));
            DEBean.setDE_VD_IDSEQ(rs.getString("vd_idseq"));
            DEBean.setDE_VD_NAME(rs.getString("vd_name"));
            //add the decimal number
            if (rs.getString("version").indexOf('.') >= 0)
               DEBean.setDE_VERSION(rs.getString("version"));
            else
               DEBean.setDE_VERSION(rs.getString("version") + ".0");
            DEBean.setDE_MIN_CDE_ID(rs.getString("cde_id"));
            DEBean.setDE_CHANGE_NOTE(rs.getString("change_note"));
          //  DEBean.setDE_LANGUAGE(rs.getString("language"));
            DEBean.setDE_DE_IDSEQ(rs.getString("de_idseq"));
          //  DEBean.setDE_LANGUAGE_IDSEQ(rs.getString("desig_idseq"));
            //DEBean.setDE_SOURCE_IDSEQ(rs.getString(21));
            DEBean.setDE_DEC_PREFERRED_NAME(rs.getString("dec_pref_name"));
            DEBean.setDE_VD_PREFERRED_NAME(rs.getString("vd_pref_name"));
            //DEBean.setDE_CRF_NAME(rs.getString("crf_name"));
            //DEBean.setDE_PROTOCOL_ID(rs.getString("protocol_id"));
            DEBean.setDE_SOURCE(rs.getString("origin"));
            DEBean.setDE_TYPE_NAME("PRIMARY");
            s = rs.getString("date_created");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
            DEBean.setDE_DATE_CREATED(s);
            s = rs.getString("date_modified");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
            DEBean.setDE_DATE_MODIFIED(s);
            DEBean.setDE_REG_STATUS(rs.getString("ar_idseq"));
            DEBean.setDE_REG_STATUS(rs.getString("registration_status"));
            DEBean.setDE_CREATED_BY(rs.getString("created_by"));
            DEBean.setDE_MODIFIED_BY(rs.getString("modified_by"));

            //get pv and historic cde id with counts
            DEBean = this.getMultiRecordsResultOther(rs, DEBean, false);
            //doc text attributes
            DEBean.setDOC_TEXT_LONG_NAME(rs.getString("long_name_doc_text"));
            DEBean.setDOC_TEXT_HISTORIC_NAME(rs.getString("hist_cde_doc_text"));
            //DEBean = this.getMultiRecordsResult(rs, DEBean);

            vList.addElement(DEBean);  //add the bean to a vector

          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-DECRFSearch: " + e);
      logger.fatal("ERROR - GetACSearch-DECRFSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doDECRFSearch: " + ee);
      logger.fatal("ERROR - GetACSearch-DECRFSearch for close : " + ee.toString());
    }
  }  //endDE_crf search

  /**
   * To get resultSet from database for Questions called from getACKeywordResult and Servlet methods.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE(DE_IDSEQ, InString, ContID, ContName, ASLName, CDE_ID, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to Question bean which is added to the vector to return
   *
   * @param userName name of the user.
   * @param vList returns Vector of DEbean.
   *
   */
  public void doQuestionSearch(String userName, Vector vList)  // returns list of Questions
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_QUESTION(?,?,?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(4, java.sql.Types.VARCHAR);
        CStmt.registerOutParameter(5, OracleTypes.CURSOR);

        // Now tie the placeholders for In parameters.
        CStmt.setString(1,userName.toUpperCase());
        CStmt.setString(2,"DRAFT NEW");
        CStmt.setString(3, null);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        String isValidCRF = (String) CStmt.getString(4);
        if ((isValidCRF != null) && (isValidCRF.equalsIgnoreCase("ASSIGNED")))
        {
           //store the output in the resultset
           rs = (ResultSet) CStmt.getObject(5);

           String s;
           if(rs!=null)
           {
             //loop through the resultSet and add them to the bean
             while(rs.next())
             {
               Quest_Bean QuestBean = new Quest_Bean();
               QuestBean.setPROTO_IDSEQ(rs.getString(1));
               QuestBean.setPROTOCOL_ID(rs.getString(2));
               QuestBean.setCRF_IDSEQ(rs.getString(3));
               QuestBean.setCRF_NAME(rs.getString(4));
               QuestBean.setQC_IDSEQ(rs.getString(5));
               QuestBean.setQUEST_NAME(rs.getString(6));
               QuestBean.setCONTE_IDSEQ(rs.getString(7));
               QuestBean.setCONTEXT_NAME(rs.getString(8));
               QuestBean.setASL_NAME(rs.getString(9));
               QuestBean.setDE_IDSEQ(rs.getString(10));
               QuestBean.setDE_LONG_NAME(rs.getString(11));
               QuestBean.setDE_VD_IDSEQ(rs.getString(12));
               QuestBean.setVD_IDSEQ(rs.getString(13));
               QuestBean.setVD_LONG_NAME(rs.getString(14));
               QuestBean.setVD_PREF_NAME(rs.getString(15));
               QuestBean.setVD_DEFINITION(rs.getString(16));
               QuestBean.setCDE_ID(rs.getString(17));
               QuestBean.setHIGH_LIGHT_INDICATOR(rs.getString(18));
               QuestBean.setQC_ID(rs.getString(19));
               QuestBean.setQUEST_ORIGIN(rs.getString(20));
               String sDE = rs.getString(10);
               String sDE_VD = rs.getString(12);
               String sCRF_VD = rs.getString(13);
               if (sDE == null || sDE.equals(""))
                  QuestBean.setSTATUS_INDICATOR("New");
               else
               {
                   //open the template if value domains are not same for both options.
                  if ((sCRF_VD != null) && !sDE_VD.equals(sCRF_VD))
                     QuestBean.setSTATUS_INDICATOR("Template");
                  else
                     QuestBean.setSTATUS_INDICATOR("Edit");
               }
               vList.addElement(QuestBean);  //add the bean to a vector

             }  //END WHILE
           }   //END IF
         }
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-QuestionSearch: " + e);
      logger.fatal("ERROR - GetACSearch-QuestionSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doQuestionSearch: " + ee);
      logger.fatal("ERROR - GetACSearch-QuestionSearch for close : " + ee.toString());
    }
  }  //endQuestion search

  /**
   * To get resultSet from database for DataElement Component called from getACKeywordResult and getCDEIDSearch methods.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE(DE_IDSEQ, InString, ContID, ContName, 
   *      ASLName, CDE_ID, OracleTypes.CURSOR,  regStatus, origin, createdFrom, Createdto, 
   *      ModifiedFrom, modifiedTo, creator, modifier, permvalue, docText, histID, sVersion, 
   *      doctypes, contextUse)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * if the record is added to the vector already, updates only the used by context to display all used by contexts in a row.
   *
   * @param DE_IDSEQ Data Element's idseq.
   * @param InString Keyword value, is empty if searchIn is minID.
   * @param ContID Selected Context IDseq.
   * @param ContName selected context name.
   * @param ContUse string is either owned, used, or both.
   * @param sVersion String yes for latest version filter or null for all version filter.
   * @param dVersion double typed version number.
   * @param ASLName selected workflow status name.
   * @param regStatus String selected Registration Status.
   * @param sCreatedFrom String created from date filter.
   * @param sCreatedTo String created to date filter.
   * @param sModifiedFrom String modified from date filter.
   * @param sModifiedTo String modified to date filter.
   * @param sCreator String selected creator.
   * @param sModifier String selected modifier.
   * @param DocText String keyword when search in is reference document types
   * @param docTypes String comma delimited values of selected document types, 'ALL' if everything
   * @param CDE_ID typed in keyword value for cde_id search, is empty if SearchIN is names and definition.
   * @param histID String Keyword for historical id search in.
   * @param permValue String Keyword for permissible value searchin.
   * @param sOrigin String keyword for origin search in.
   * @param sProtoID String typed ID of the protocol can be wild card included
   * @param crfName String keyword value of the crf name.
   * @param pvIDseq String idseq of the selected permissible value for get associated pvs.
   * @param vdIDseq String idseq of the selected value domain for get associated vds.
   * @param decIDseq String idseq of the selected data elmeent concept for get associated decs.
   * @param cdIDseq String idseq of the selected conceptual domain for get associated cds.
   * @param cscsiIDseq String idseq of the selected class scheme items for get associated csis.
   * @param vList returns Vector of DEbean.
   *
   */
  public void doDESearch(String DE_IDSEQ, String InString, String ContID, String ContName, 
      String ContUse, String sVersion, double dVersion, String ASLName, String regStatus, 
      String sCreatedFrom, String sCreatedTo, String sModifiedFrom, String sModifiedTo, 
      String sCreator, String sModifier, String DocText, String docTypes, String CDE_ID, String histID, 
      String permValue, String sOrigin, String sProtoId, String crfName, String pvIDseq, 
      String vdIDseq, String decIDseq, String cdIDseq, String cscsiIDseq, Vector vList)  // returns list of Data Elements
  {
    //capture the duration
    java.util.Date startDate = new java.util.Date();          
  //  logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "start desearch call", startDate, startDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Hashtable desTable = new Hashtable();
    HttpSession session = m_classReq.getSession();
    try
    {
      int g = 0;
      //check if search in is protocol/crf name
      boolean isProtoCRF = false;
      if (sProtoId != null && !sProtoId.equals("")) isProtoCRF = true;
      if (isProtoCRF == false && crfName != null && !crfName.equals("")) isProtoCRF = true;
      
      //get the existing desHash table if appendsearch
      String strAppend = (String)session.getAttribute("AppendAction");
      if (strAppend !=null && strAppend.equals("Appended"))
         desTable = (Hashtable)session.getAttribute("desHashTable");

      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE" + 
            "(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(7, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1, DE_IDSEQ);
        CStmt.setString(2, InString);
        CStmt.setString(3, ContID);
        CStmt.setString(4, ContName);
        CStmt.setString(5, ASLName);
        CStmt.setString(6, CDE_ID);
        CStmt.setString(8, regStatus);
        CStmt.setString(9, sOrigin);
        CStmt.setString(10, sCreatedFrom);
        CStmt.setString(11, sCreatedTo);
        CStmt.setString(12, sModifiedFrom);
        CStmt.setString(13, sModifiedTo);
        CStmt.setString(14, sCreator);
        CStmt.setString(15, sModifier);
        CStmt.setString(16, permValue);
        CStmt.setString(17, DocText);
        CStmt.setString(18, histID);
        CStmt.setString(19, sVersion);
        CStmt.setString(20, docTypes);
        CStmt.setString(21, ContUse);
        CStmt.setString(22, sProtoId);
        CStmt.setString(23, crfName);
        CStmt.setDouble(24, dVersion);
        CStmt.setString(25, pvIDseq);
        CStmt.setString(26, decIDseq);
        CStmt.setString(27, vdIDseq);
        CStmt.setString(28, cscsiIDseq);
        CStmt.setString(29, cdIDseq);
        //capture the duration
        //logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "begin executing search", startDate, new java.util.Date()));
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //capture the duration
     //   logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "end executing search", startDate, new java.util.Date()));
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(7);
    //    logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "got resultset object", startDate, new java.util.Date()));
        String s;
        Integer iCount;
        Vector vStoredIDs = new Vector();
        if (rs!=null)
        {
          DE_Bean DEBean = new DE_Bean();
          //capture the duration
          //logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "begin search resultset", startDate, new java.util.Date()));
           //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            boolean isFound = false;
            Vector usedBy = new Vector();
            //check if ID is found in the vector.
            if (vList != null)
            {
               for (int i = 0; i<vList.size(); i++)
               {
                   DEBean = (DE_Bean)vList.elementAt(i);
                   if (DEBean.getDE_DE_IDSEQ().equals(rs.getString("de_idseq")))
                   {
                      isFound = true;
                      break;
                   }
               }
            }
            //add the primary record to the Vector
            if (isFound == false)
            {
               g = g + 1;
               DEBean = new DE_Bean();
               DEBean.setDE_PREFERRED_NAME(rs.getString("preferred_name"));
               DEBean.setDE_LONG_NAME(rs.getString("long_name"));
               DEBean.setDE_PREFERRED_DEFINITION(rs.getString("preferred_definition"));
               DEBean.setDE_ASL_NAME(rs.getString("asl_name"));
               DEBean.setDE_CONTE_IDSEQ(rs.getString("conte_idseq"));
               s = rs.getString("begin_date");
               if (s != null)
                  s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
               DEBean.setDE_BEGIN_DATE(s);
               s = rs.getString("end_date");
               if (s != null)
                  s = m_util.getCurationDate(s);
               DEBean.setDE_END_DATE(s);
               DEBean.setDE_CONTEXT_NAME(rs.getString("name"));
               DEBean.setDE_DEC_IDSEQ(rs.getString("dec_idseq"));
               DEBean.setDE_DEC_NAME(rs.getString("dec_name"));
               DEBean.setDE_DEC_Definition(rs.getString("dec_preferred_definition"));
               DEBean.setDE_VD_IDSEQ(rs.getString("vd_idseq"));
               DEBean.setDE_VD_NAME(rs.getString("vd_name"));
               DEBean.setDE_VD_Definition(rs.getString("vd_preferred_definition"));
               //add the decimal number
               if (rs.getString("version").indexOf('.') >= 0)
                  DEBean.setDE_VERSION(rs.getString("version"));
               else
                  DEBean.setDE_VERSION(rs.getString("version") + ".0");

               DEBean.setDE_MIN_CDE_ID(rs.getString("cde_id"));
               DEBean.setDE_CHANGE_NOTE(rs.getString("change_note"));
           //    DEBean.setDE_LANGUAGE(rs.getString("language"));
               DEBean.setDE_DE_IDSEQ(rs.getString("de_idseq"));
           //    DEBean.setDE_LANGUAGE_IDSEQ(rs.getString("desig_idseq"));
               DEBean.setDE_DEC_PREFERRED_NAME(rs.getString("dec_pref_name"));
               DEBean.setDE_VD_PREFERRED_NAME(rs.getString("vd_pref_name"));
               DEBean.setDE_ALIAS_NAME(rs.getString("usedby_name"));      //used by name
               DEBean.setDE_USEDBY_CONTEXT(rs.getString("used_by_context"));
               usedBy = new Vector();
               if (rs.getString("used_by_conte_idseq") != null)
                  usedBy.addElement(rs.getString("used_by_conte_idseq"));
               DEBean.setDE_USEDBY_CONTEXT_ID(usedBy);  //keep it in the vector
               DEBean.setDE_SOURCE(rs.getString("origin"));
               s = rs.getString("date_created");
               if (s != null)
                  s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
               DEBean.setDE_DATE_CREATED(s);
               s = rs.getString("date_modified");
               if (s != null)
                  s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
               DEBean.setDE_DATE_MODIFIED(s);
               DEBean.setDE_REG_STATUS(rs.getString("registration_status"));
               DEBean.setDE_REG_STATUS_IDSEQ(rs.getString("ar_idseq"));
               DEBean.setDE_CREATED_BY(rs.getString("created_by"));
               DEBean.setDE_MODIFIED_BY(rs.getString("modified_by"));
               //get pv and historic cde id with counts
               DEBean = this.getMultiRecordsResultOther(rs, DEBean, isProtoCRF);
               //doc text attributes
               DEBean.setDOC_TEXT_LONG_NAME(rs.getString("long_name_doc_text"));
               DEBean.setDOC_TEXT_HISTORIC_NAME(rs.getString("hist_cde_doc_text"));
              // DEBean = this.getMultiRecordsResultDocText(rs, DEBean);
               
               DEBean.setDE_TYPE_NAME("PRIMARY");                   
               //add the combination usedbycontext+acID and desIdseq in the hash table
               if ((rs.getString("used_by_context") != null) && !rs.getString("used_by_context").equals(""))
                  desTable.put(rs.getString("used_by_context") + "," + rs.getString("de_idseq"), rs.getString("u_desig_idseq"));
               vList.addElement(DEBean);  //add the bean to a vector
            }
            else
            {
                //add the used by if not null  with the comma.
               if ((rs.getString("used_by_context") != null) && (!rs.getString("used_by_context").equals("")))
               {
                   usedBy = DEBean.getDE_USEDBY_CONTEXT_ID();
                   //store it only if does not exist already
                   if (rs.getString("used_by_conte_idseq") != null && !usedBy.contains(rs.getString("used_by_conte_idseq")))
                   {
                      usedBy.addElement(rs.getString("used_by_conte_idseq"));
                      DEBean.setDE_USEDBY_CONTEXT_ID(usedBy);  //keep it in the vector
                      DEBean.setDE_USEDBY_CONTEXT(DEBean.getDE_USEDBY_CONTEXT() + ", " + rs.getString("used_by_context"));
                      desTable.put(rs.getString("used_by_context") + "," + rs.getString("de_idseq"), rs.getString("u_desig_idseq"));
                   }
               }
            } 
  //  System.out.println(rs.getString("de_idseq") + " des " + rs.getString("u_desig_idseq") + " con " + rs.getString("used_by_conte_idseq"));
          }  //END WHILE
          //capture the duration
      //    logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "end resultset", startDate, new java.util.Date()));
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-DESearch: " + e);
      logger.fatal("ERROR - GetACSearch-DESearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
      session.setAttribute("desHashTable", desTable);  //store it in session
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doDESearch: " + ee);
      logger.fatal("ERROR - GetACSearch-DESearch for close : " + ee.toString());
    }
    logger.info(m_servlet.getLogMessage(m_classReq, "doDESearch", "end call", startDate, new java.util.Date()));
  }  //endDE search

  /**
   * to get the records perm value, histID with the counts from the RS into the Bean
   * 
   * @param rst ResultSet 
   * @param deBean DE_Bean
   * 
   * @return DE_Bean
   * 
   * @throws Exception
   */
  private DE_Bean getMultiRecordsResultOther(ResultSet rst, DE_Bean deBean, boolean isProtoCRF) throws Exception
  {
     String sText = "";
     Integer iCount;
    //doc type min_hist_cde_id
     sText = rst.getString("min_hist_cde_name");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDE_HIST_CDE_ID(sText);
       sText = rst.getString("hist_cde_count");
       iCount = new Integer(sText);
       deBean.setDE_HIST_CDE_ID_COUNT(iCount);                 
     }
     //permissible value 
     sText = rst.getString("min_value");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDE_Permissible_Value(sText);
       sText = rst.getString("value_count");
       iCount = new Integer(sText);
       deBean.setDE_Permissible_Value_Count(iCount);                 
     }
     //protocol id 
     if (isProtoCRF)
     {
       sText = rst.getString("protocol_id");
       if (sText != null && !sText.equals(""))
       {
         deBean.setDE_PROTOCOL_ID(sText);
         sText = rst.getString("protocol_crf_count");
         iCount = new Integer(sText);
         deBean.setDE_PROTO_CRF_Count(iCount);                 
       }
       //crf name 
       sText = rst.getString("crf_name");
       if (sText != null && !sText.equals(""))
       {
         deBean.setDE_CRF_NAME(sText);
         sText = rst.getString("protocol_crf_count");
         iCount = new Integer(sText);
         deBean.setDE_PROTO_CRF_Count(iCount);                 
       }       
     }
     return deBean;
  }
  
  /**
   * to get the records document text with the counts from the RS into the Bean
   * 
   * @param rst ResultSet 
   * @param deBean DE_Bean
   * 
   * @return DE_Bean
   * 
   * @throws Exception
   */
  private DE_Bean getMultiRecordsResultDocText(ResultSet rst, DE_Bean deBean) throws Exception
  {
     String sText = "";
     Integer iCount;
     //doc type reference 
     sText = rst.getString("reference_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_REFERENCE(sText);
       sText = rst.getString("reference_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_REFERENCE_COUNT(iCount);                 
     }
     //doc type example 
     sText = rst.getString("example_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_EXAMPLE(sText);
       sText = rst.getString("example_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_EXAMPLE_COUNT(iCount);                 
     }
     //doc type comment
     sText = rst.getString("comment_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_COMMENT(sText);
       sText = rst.getString("comment_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_COMMENT_COUNT(iCount);                 
     }
     //doc type note
     sText = rst.getString("note_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_NOTE(sText);
       sText = rst.getString("note_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_NOTE_COUNT(iCount);                 
     }
     //doc type DESCRIPTION
     sText = rst.getString("desc_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_DESCRIPTION(sText);
       sText = rst.getString("desc_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_DESCRIPTION_COUNT(iCount);                 
     }
     //doc type long name
     sText = rst.getString("long_name_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_LONG_NAME(sText);
       sText = rst.getString("long_name_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_LONG_NAME_COUNT(iCount);                 
     }
     //doc type IMAGE_FILE
     sText = rst.getString("img_file_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_IMAGE_FILE(sText);
       sText = rst.getString("img_file_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_IMAGE_FILE_COUNT(iCount);                 
     }
     //doc type VALID_VALUE_SOURCE
     sText = rst.getString("vv_source_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_VALID_VALUE_SOURCE(sText);
       sText = rst.getString("vv_source_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_VALID_VALUE_SOURCE_COUNT(iCount);                 
     }
     //doc type DATA_ELEMENT_SOURCE
     sText = rst.getString("de_source_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_DATA_ELEMENT_SOURCE(sText);
       sText = rst.getString("de_source_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT(iCount);                 
     }
     //doc type hist_cde
     sText = rst.getString("hist_cde_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_HISTORIC_NAME(sText);
       sText = rst.getString("hist_cde_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_HISTORIC_COUNT(iCount);                 
     }
     //doc type uml_class
     sText = rst.getString("uml_class_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_UML_Class(sText);
       sText = rst.getString("uml_class_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_UML_Class_Count(iCount);                 
     }
     //doc type detl_desc
     sText = rst.getString("detl_desc_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_DETAIL_DESCRIPTION(sText);
       sText = rst.getString("detl_desc_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_DETAIL_DESCRIPTION_COUNT(iCount);                 
     }
     //doc type tech_guide
     sText = rst.getString("tech_guide_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_TECHNICAL_GUIDE(sText);
       sText = rst.getString("tech_guide_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_TECHNICAL_GUIDE_COUNT(iCount);                 
     }
     //doc type uml_attr
     sText = rst.getString("uml_attr_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_UML_Attribute(sText);
       sText = rst.getString("uml_attr_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_UML_Attribute_Count(iCount);                 
     }
    //doc type label
     sText = rst.getString("label_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_LABEL(sText);
       sText = rst.getString("label_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_LABEL_COUNT(iCount);                 
     }
    //doc type other_doc
     sText = rst.getString("other_doc_text");
     if (sText != null && !sText.equals(""))
     {
       deBean.setDOC_TEXT_OTHER_REF_TYPES(sText);
       sText = rst.getString("other_doc_cnt");
       iCount = new Integer(sText);
       deBean.setDOC_TEXT_OTHER_REF_TYPES_COUNT(iCount);                 
     }
     return deBean;
  }
 

 /**
   * To get resultSet from database for DataElementConcept Component called from getACKeywordResult method.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_DEC(ContID, InString, ContName, ASLName, 
   *      DEC_IDSEQ, DEC_ID, OracleTypes.CURSOR, origin, , sObject, sProperty, createdFrom, 
   *      Createdto, ModifiedFrom, modifiedTo, creator, modifier, sVersion)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * if the record is added to the vector already, updates only the used by context to display all used by contexts in a row.
   *
   * @param DEC_IDSEQ Data Element Concept's idseq.
   * @param InString Keyword value.
   * @param ContID Selected Context IDseq.
   * @param ContName selected context name.
   * @param sVersion String yes for latest version filter or null for all version filter.
   * @param ASLName selected workflow status name.
   * @param sCreatedFrom String created from date filter.
   * @param sCreatedTo String created to date filter.
   * @param sModifiedFrom String modified from date filter.
   * @param sModifiedTo String modified to date filter.
   * @param sCreator String selected creator.
   * @param sModifier String selected modifier.
   * @param DEC_ID typed in keyword value for public id search, is empty if SearchIN is names and definition.
   * @param sObject String Keyword for Object Class search in.
   * @param sProperty String Keyword for Property searchin.
   * @param sOrigin String keyword for origin search in.
   * @param dVersion double typed version number.
   * @param cdIDseq String idseq of the selected conceptual domain for get associated cds.
   * @param deIDseq String idseq of the selected data elmeent for get associated des.
   * @param vList returns Vector of DEbean.
   */
  public void doDECSearch(String DEC_IDSEQ, String InString, String ContID, String ContName, 
      String sVersion, String ASLName, String sCreatedFrom, String sCreatedTo, String sModifiedFrom, 
      String sModifiedTo, String sCreator, String sModifier, String DEC_ID, String sObject, 
      String sProperty, String sOrigin, double dVersion, String sCDid, String deIDseq, Vector vList)  // returns list of Data Element Concepts
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
   // logger.info(m_servlet.getLogMessage(m_classReq, "doDECSearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    HttpSession session = m_classReq.getSession();
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_DEC(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        // Now tie the placeholders with actual parameters.
        CStmt.registerOutParameter(7, OracleTypes.CURSOR);
        CStmt.setString(1,ContID);
        CStmt.setString(2,InString);
        CStmt.setString(3,ContName);
        CStmt.setString(4,ASLName);
        CStmt.setString(5,DEC_IDSEQ);
        CStmt.setString(6,DEC_ID);
        CStmt.setString(8, sOrigin);
        CStmt.setString(9, sObject);
        CStmt.setString(10, sProperty);
        CStmt.setString(11, sCreatedFrom);
        CStmt.setString(12, sCreatedTo);
        CStmt.setString(13, sModifiedFrom);
        CStmt.setString(14, sModifiedTo);
        CStmt.setString(15, sCreator);
        CStmt.setString(16, sModifier);
        CStmt.setString(17, sVersion);
        CStmt.setDouble(18, dVersion);
        CStmt.setString(19, sCDid);
        CStmt.setString(20, deIDseq);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(7);
        //capture the duration
     //   logger.info(m_servlet.getLogMessage(m_classReq, "doDECSearch", "got object", exDate,  new java.util.Date()));
        String s;
        Vector vStoredIDs = new Vector();
        String oc_condr_idseq = "";
        String prop_condr_idseq = "";
        if(rs!=null)
        {
          //loop through to printout the outstrings
          DEC_Bean DECBean = new DEC_Bean();
          while(rs.next())
          {
             DECBean = new DEC_Bean();
             DECBean.setDEC_PREFERRED_NAME(rs.getString("preferred_name"));
             DECBean.setDEC_LONG_NAME(rs.getString("long_name"));
             DECBean.setDEC_PREFERRED_DEFINITION(rs.getString("preferred_definition"));
             DECBean.setDEC_ASL_NAME(rs.getString("asl_name"));
             DECBean.setDEC_CONTE_IDSEQ(rs.getString("conte_idseq"));
             s = rs.getString("begin_date");
             if (s != null)
             s = m_util.getCurationDate(s);      //convert to dd/mm/yyyy format
             DECBean.setDEC_BEGIN_DATE(s);
             s = rs.getString("end_date");
             if (s != null)
               s = m_util.getCurationDate(s);
             DECBean.setDEC_END_DATE(s);
             //add the decimal number
             if (rs.getString("version").indexOf('.') >= 0)
                DECBean.setDEC_VERSION(rs.getString("version"));
             else
                DECBean.setDEC_VERSION(rs.getString("version") + ".0");
             DECBean.setDEC_DEC_IDSEQ(rs.getString("dec_idseq"));
             DECBean.setDEC_CHANGE_NOTE(rs.getString("change_note"));
             DECBean.setDEC_CONTEXT_NAME(rs.getString("context"));
             DECBean.setDEC_CD_NAME(rs.getString("cd_name"));
             DECBean.setDEC_OCL_NAME(rs.getString("ocl_name"));
             DECBean.setDEC_PROPL_NAME(rs.getString("propl_name"));
             //DECBean.setDEC_OBJ_CLASS_QUALIFIER("");
             //DECBean.setDEC_PROPERTY_QUALIFIER("");
             DECBean.setDEC_CD_IDSEQ(rs.getString("CD_IDSEQ"));  //
             DECBean.setDEC_OCL_IDSEQ(rs.getString("OC_IDSEQ"));  //oc_idseq
             DECBean.setDEC_PROPL_IDSEQ(rs.getString("PROP_IDSEQ"));  //prop_idseq
             oc_condr_idseq = rs.getString("oc_condr_idseq");
             DECBean.setDEC_OC_CONDR_IDSEQ(oc_condr_idseq);
             prop_condr_idseq = rs.getString("prop_condr_idseq");
             DECBean.setDEC_PROP_CONDR_IDSEQ(prop_condr_idseq);
             DECBean.setDEC_DEC_ID(rs.getString("dec_id"));
             DECBean.setDEC_SOURCE(rs.getString("ORIGIN"));
             s = rs.getString("date_created");
             if (s != null)
                s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
             DECBean.setDEC_DATE_CREATED(s);
              s = rs.getString("date_modified");
             if (s != null)
                s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
             DECBean.setDEC_DATE_MODIFIED(s);
             DECBean.setDEC_CREATED_BY(rs.getString("created_by"));
             DECBean.setDEC_MODIFIED_BY(rs.getString("modified_by"));  
             DECBean.setDEC_OBJ_ASL_NAME(rs.getString("oc_asl_name"));
             DECBean.setDEC_PROP_ASL_NAME(rs.getString("prop_asl_name"));  
             
             vList.addElement(DECBean);    //add DEC bean to vector
             //store the ocl name or propl name in the request 
             String reslabel = "Search Results for Data Element Concept associated with - ";
             if (sObject != null && !sObject.equals(""))
                m_classReq.setAttribute("resultLabel", reslabel + DECBean.getDEC_OCL_NAME());
             else if (sProperty != null && !sProperty.equals(""))
                m_classReq.setAttribute("resultLabel", reslabel + DECBean.getDEC_PROPL_NAME());
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-DECSearch: " + e);
      logger.fatal("ERROR - GetACSearch-DECSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doDECSearch: " + ee);
      logger.fatal("GetACSearch-DECSearch for close : " + ee.toString());
    }
    //capture the duration
    logger.info(m_servlet.getLogMessage(m_classReq, "doDECSearch", "end search", exDate,  new java.util.Date()));
  }  //endDEC search
  
 
  /**
   * To get resultSet from database for Value Domian Component called from getACKeywordResult method.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_VD(ContID, InString, ContName, ASLName, VD_IDSEQ, 
   *      VD_ID, OracleTypes.CURSOR, sOrigin, sCreatedFrom, sCreatedTo, sModifiedFrom, 
   *      sModifiedTo, sCreator, sModifier, sPermValue, sVersion, VDType)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * if the record is added to the vector already, updates only the used by context to display all used by contexts in a row.
   *
   * @param VD_IDSEQ Value Domain's idseq.
   * @param InString Keyword value.
   * @param ContID Selected Context IDseq.
   * @param ContName selected context name.
   * @param sVersion String yes for latest version filter or null for all version filter.
   * @param vdType String comma delimited 'E,N,R' for each type selected.
   * @param ASLName selected workflow status name.
   * @param sCreatedFrom String created from date filter.
   * @param sCreatedTo String created to date filter.
   * @param sModifiedFrom String modified from date filter.
   * @param sModifiedTo String modified to date filter.
   * @param sCreator String selected creator.
   * @param sModifier String selected modifier.
   * @param VD_ID typed in keyword value for public id search, is empty if SearchIN is names and definition.
   * @param permValue String Keyword for Permissible Value search in.
   * @param sOrigin String keyword for origin search in.
   * @param dVersion double typed version number.
   * @param cdIDseq String idseq of the selected conceptual domain for get associated cds.
   * @param pvIDseq String idseq of the selected permissible value for get associated pvs.
   * @param deIDseq String idseq of the selected data elmeent for get associated des.
   * @param vList returns Vector of DEbean.
   */
  public void doVDSearch(String VD_IDSEQ, String InString, String ContID, String ContName, 
      String sVersion, String VDType, String ASLName, String sCreatedFrom, String sCreatedTo, 
      String sModifiedFrom, String sModifiedTo, String sCreator, String sModifier, String VD_ID, 
      String sPermValue, String sOrigin, double dVersion, String sCDid, String pvIDseq, String deIDseq, Vector vList)  // returns list of Value Domains
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
    logger.info(m_servlet.getLogMessage(m_classReq, "doVDSearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    HttpSession session = m_classReq.getSession();
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_VD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
        // Now tie the placeholders with actual parameters.
        CStmt.registerOutParameter(7, OracleTypes.CURSOR);
        CStmt.setString(1,ContID);
        CStmt.setString(2,InString);
        CStmt.setString(3,ContName);
        CStmt.setString(4,ASLName);
        CStmt.setString(5,VD_IDSEQ);
        CStmt.setString(6,VD_ID);
        CStmt.setString(8, sOrigin);
        CStmt.setString(9, sCreatedFrom);
        CStmt.setString(10, sCreatedTo);
        CStmt.setString(11, sModifiedFrom);
        CStmt.setString(12, sModifiedTo);
        CStmt.setString(13, sCreator);
        CStmt.setString(14, sModifier);
        CStmt.setString(15, sPermValue);
        CStmt.setString(16, sVersion);
        CStmt.setString(17, VDType);
        CStmt.setDouble(18, dVersion);
        CStmt.setString(19, sCDid);
        CStmt.setString(20, pvIDseq);
        CStmt.setString(21, deIDseq);
       
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(7);
        //capture the duration
        logger.info(m_servlet.getLogMessage(m_classReq, "doVDSearch", "got rsObject", exDate,  new java.util.Date()));
        String s;
        Vector vStoredIDs = new Vector();
        if(rs!=null)
        {
          //loop through to printout the outstrings
          VD_Bean VDBean = new VD_Bean();
          while(rs.next())
          {
             VDBean = new VD_Bean();
             VDBean.setVD_PREFERRED_NAME(rs.getString("preferred_name"));
             VDBean.setVD_LONG_NAME(rs.getString("long_name"));
             VDBean.setVD_PREFERRED_DEFINITION(rs.getString("preferred_definition"));
             VDBean.setVD_CONTE_IDSEQ(rs.getString("conte_idseq"));
             VDBean.setVD_ASL_NAME(rs.getString("asl_name"));
             VDBean.setVD_VD_IDSEQ(rs.getString("vd_idseq"));
             //add the decimal number
             if (rs.getString("version").indexOf('.') >= 0)
                VDBean.setVD_VERSION(rs.getString("version"));
             else
                VDBean.setVD_VERSION(rs.getString("version") + ".0");
             VDBean.setVD_DATA_TYPE(rs.getString("dtl_name"));
             s = rs.getString("begin_date");
             if (s != null)
                s = m_util.getCurationDate(s);    //convert to DD/MM/YYYY format
             VDBean.setVD_BEGIN_DATE(s);
             s = rs.getString("end_date");
             if (s != null)
                s = m_util.getCurationDate(s);
             VDBean.setVD_END_DATE(s);
             VDBean.setVD_TYPE_FLAG(rs.getString("vd_type_flag"));
             VDBean.setVD_CHANGE_NOTE(rs.getString("change_note"));
             VDBean.setVD_UOML_NAME(rs.getString("uoml_name"));
             VDBean.setVD_FORML_NAME(rs.getString("forml_name"));
             VDBean.setVD_MAX_LENGTH_NUM(rs.getString("max_length_num"));
             VDBean.setVD_MIN_LENGTH_NUM(rs.getString("min_length_num"));
             VDBean.setVD_DECIMAL_PLACE(rs.getString("decimal_place"));
             VDBean.setVD_CHAR_SET_NAME(rs.getString("char_set_name"));
             VDBean.setVD_HIGH_VALUE_NUM(rs.getString("high_value_num"));
             VDBean.setVD_LOW_VALUE_NUM(rs.getString("low_value_num"));
             VDBean.setVD_REP_TERM(rs.getString("rep_term"));
             VDBean.setVD_REP_IDSEQ(rs.getString("rep_idseq"));
           //  VDBean.setVD_REP_QUAL(rs.getString("qualifier_name"));
             VDBean.setVD_REP_CONDR_IDSEQ(rs.getString("rep_condr_idseq"));
             VDBean.setVD_PAR_CONDR_IDSEQ(rs.getString("vd_condr_idseq"));                     
             String rep_condr_idseq = rs.getString("rep_condr_idseq");
             VDBean.setVD_REP_CONDR_IDSEQ(rep_condr_idseq);
         //    fillRepVectors(rep_condr_idseq, VDBean);                     
             VDBean.setVD_CONTEXT_NAME(rs.getString("context"));
             VDBean.setVD_CD_IDSEQ(rs.getString("cd_idseq"));
             VDBean.setVD_CD_NAME(rs.getString("cd_name"));
     //        VDBean.setVD_LANGUAGE(rs.getString("language"));
     //        VDBean.setVD_LANGUAGE_IDSEQ(rs.getString("lae_des_idseq"));
             VDBean.setVD_VD_ID(rs.getString("vd_id"));
             VDBean.setVD_SOURCE(rs.getString("origin"));
             s = rs.getString("date_created");
             if (s != null)
                s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
             VDBean.setVD_DATE_CREATED(s);
              s = rs.getString("date_modified");
             if (s != null)
                s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
             VDBean.setVD_DATE_MODIFIED(s);
             VDBean.setVD_CREATED_BY(rs.getString("created_by"));
             VDBean.setVD_MODIFIED_BY(rs.getString("modified_by"));
             VDBean.setVD_REP_ASL_NAME(rs.getString("rep_asl_name"));
             //get permissible value
             s = rs.getString("min_value");
             if (s != null && !s.equals(""))
             {
               VDBean.setVD_Permissible_Value(s);
               s = rs.getString("value_count");
               Integer iCount = new Integer(s);
               VDBean.setVD_Permissible_Value_Count(iCount);                 
             }
                
             VDBean.setVD_DES_ALIAS_ID("");
             VDBean.setVD_OBJ_CLASS("");
             VDBean.setVD_OBJ_QUAL("");
             VDBean.setVD_PROP_CLASS("");
             VDBean.setVD_PROP_QUAL("");
             VDBean.setVD_PROTOCOL_ID("");                        //rs.getString(24));
             VDBean.setVD_CRF_NAME("");                           //rs.getString(24));
               
             vList.addElement(VDBean);   //add to vector
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-doVDSearch: " + e);
      logger.fatal("ERROR - GetACSearch-doVDSearch for other : " + e.toString());
    }
    try
    {
      if (rs!=null) rs.close();
      if (CStmt!=null) CStmt.close();
      if (sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doVDSearch: " + ee);
      logger.fatal("ERROR - GetACSearch-doVDSearch for close : " + ee.toString());
    }
    //capture the duration
  //  logger.info(m_servlet.getLogMessage(m_classReq, "doVDSearch", "end search", exDate,  new java.util.Date()));
  }  //endVD search

 

  /**
   * To get Search results for Conceptual Domain from database called from getACKeywordResult.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_CD(CD_IDSEQ, InString, ContID, ContName, ASLName, CD_ID, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   * @param ProtoWord String Keyword for Protocol.
   * @param CRFWord String Keyword for CRF Name.
   * @param ContName selected context name.
   * @param ASLName selected workflow status name.
   * @param vList returns Vector of DEbean.
   *
   */
   public void doCDSearch(String CD_IDSEQ, String InString, String ContID, String ContName, 
        String sVersion, String ASLName, String sCreatedFrom, String sCreatedTo, String sModifiedFrom, 
        String sModifiedTo, String sCreator, String sModifier, String CD_ID, String sOrigin, 
        double dVersion, Vector vList)  // returns list of conceptual domains
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
 //   logger.info(m_servlet.getLogMessage(m_classReq, "doCDSearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_CD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

        CStmt.registerOutParameter(7, OracleTypes.CURSOR);
        CStmt.setString(1,InString);
        CStmt.setString(2,ContID);
        CStmt.setString(3,ContName);
        CStmt.setString(4,ASLName);
        CStmt.setString(5,CD_IDSEQ);
        CStmt.setString(6,CD_ID);
        CStmt.setString(8, sCreatedFrom);
        CStmt.setString(9, sCreatedTo);
        CStmt.setString(10, sModifiedFrom);
        CStmt.setString(11, sModifiedTo);
        CStmt.setString(12, sOrigin);
        CStmt.setString(13, sCreator);
        CStmt.setString(14, sModifier);
        CStmt.setString(15, sVersion);
        CStmt.setDouble(16, dVersion);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(7);
        //capture the duration
    //    logger.info(m_servlet.getLogMessage(m_classReq, "doCDSearch", "got rsObject", exDate,  new java.util.Date()));

        String s;

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            CD_Bean CDBean = new CD_Bean();
            CDBean.setCD_PREFERRED_NAME(rs.getString("preferred_name"));
            CDBean.setCD_LONG_NAME(rs.getString("long_name"));
            CDBean.setCD_PREFERRED_DEFINITION(rs.getString("preferred_definition"));
            CDBean.setCD_ASL_NAME(rs.getString("asl_name"));
            CDBean.setCD_CONTE_IDSEQ(rs.getString("conte_idseq"));
            s = rs.getString("begin_date");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to dd/mm/yyyy format
            CDBean.setCD_BEGIN_DATE(s);
            s = rs.getString("end_date");
            if (s != null)
              s = m_util.getCurationDate(s);
            CDBean.setCD_END_DATE(s);
            //add the decimal number
            if (rs.getString("version").indexOf('.') >= 0)
               CDBean.setCD_VERSION(rs.getString("version"));
            else
               CDBean.setCD_VERSION(rs.getString("version") + ".0");
            CDBean.setCD_CD_IDSEQ(rs.getString("cd_idseq"));
            CDBean.setCD_CHANGE_NOTE(rs.getString("change_note"));
            CDBean.setCD_CONTEXT_NAME(rs.getString("context"));
            CDBean.setCD_CD_ID(rs.getString("cd_id"));
            CDBean.setCD_SOURCE(rs.getString("ORIGIN"));
            CDBean.setCD_DIMENSIONALITY(rs.getString("dimensionality"));
            s = rs.getString("date_created");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
            CDBean.setCD_DATE_CREATED(s);
              s = rs.getString("date_modified");
            if (s != null)
              s = m_util.getCurationDate(s);      //convert to mm/dd/yyyy format
            CDBean.setCD_DATE_MODIFIED(s);
            CDBean.setCD_CREATED_BY(rs.getString("created_by"));
            CDBean.setCD_MODIFIED_BY(rs.getString("modified_by"));

            vList.addElement(CDBean);  //add the bean to a vector

          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-CDSearch: " + e);
      logger.fatal("ERROR - GetACSearch-CDSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doCDSearch: " + ee);
      logger.fatal("ERROR - GetACSearch-CDSearch for close : " + ee.toString());
    }
    //capture the duration
 //   logger.info(m_servlet.getLogMessage(m_classReq, "doCDSearch", "end search", exDate,  new java.util.Date()));
  }  //endCDsearch

  /**
   * To get Search results for Class Scheme Items from database called from getACKeywordResult.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_CSI(CSI_IDSEQ, InString, ContID, ContName, ASLName, CSI_ID, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   * @param ProtoWord String Keyword for Protocol.
   * @param CRFWord String Keyword for CRF Name.
   * @param ContName selected context name.
   * @param ASLName selected workflow status name.
   * @param vList returns Vector of DEbean.
   *
   */
  private void doCSISearch(String InString, String ContName, String CSName, Vector vList)  // returns list of Data Elements
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
    logger.info(m_servlet.getLogMessage(m_classReq, "doCSISearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_CSI(?,?,?,?)}");

        CStmt.registerOutParameter(4, OracleTypes.CURSOR);

        CStmt.setString(1,InString);
        CStmt.setString(2,CSName);
        CStmt.setString(3,ContName);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(4);
        //capture the duration
        logger.info(m_servlet.getLogMessage(m_classReq, "doCSISearch", "got rsObject", exDate,  new java.util.Date()));

        String s;

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            CSI_Bean CSIBean = new CSI_Bean();
            CSIBean.setCSI_CS_IDSEQ(rs.getString(1));
            CSIBean.setCSI_CS_NAME(rs.getString(2));
            CSIBean.setCSI_CS_LONG_NAME(rs.getString(3));
            CSIBean.setCSI_CONTEXT_NAME(rs.getString(4));
            CSIBean.setCSI_CSI_IDSEQ(rs.getString(5));
            CSIBean.setCSI_NAME(rs.getString(6));
            CSIBean.setCSI_CSITL_NAME(rs.getString(7));
            CSIBean.setCSI_DEFINITION(rs.getString(8));
            CSIBean.setCSI_CSCSI_IDSEQ(rs.getString(9));

            vList.addElement(CSIBean);  //add the bean to a vector

          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-CSISearch: " + e);
      logger.fatal("ERROR - GetACSearch-CSISearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doCSISearch: " + ee);
      logger.fatal("ERROR - GetACSearch-CSISearch for close : " + ee.toString());
    }
    //capture the duration
    logger.info(m_servlet.getLogMessage(m_classReq, "doCSISearch", "end search", exDate,  new java.util.Date()));
  }  //endCSIsearch

  /**
   * To get the list of attributes selected to display, called from getACKeywordResult and getACShowResult methods.
   * selected attribute values from the multi select list is stored in session vector 'selectedAttr'.
   * "All Attribute" select will add all the fields of the selected component to the vector
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param sSearchAC selected Administered component.
   *
   */
  public void setAttributeValues(HttpServletRequest req, HttpServletResponse res,
         String sSearchAC, String sMenuAct)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vAttrList = new Vector();
      String sAttrList[] = req.getParameterValues("listAttrFilter");
      boolean bAllAttr = false;
      //loop through the string array to extract values.
      if (sAttrList != null)
      {
        for (int i = 0; i<sAttrList.length; i++)
        {
          if(sAttrList[i] != null)
          {

            String sAttr = new String(sAttrList[i]);
            vAttrList.addElement(sAttr);      //store each string into a vector
            if (sAttr.equals("All Attributes"))
            {
              bAllAttr = true;
              break;
            }
          }
        }       
      }
      //add all fields to the vector if all attributes selected.
      if (bAllAttr == true)
      {  
          //get all the attributes from the session to select
        vAttrList = new Vector();
        if (sMenuAct.equals("searchForCreate"))
           vAttrList = (Vector)session.getAttribute("creAttributeList");
        else
           vAttrList = (Vector)session.getAttribute("serAttributeList");
      }
      //remove all attributes from the selected list if any
      if (vAttrList.contains("All Attributes"))
         vAttrList.removeElement("All Attributes");

      //store the vector in session
      if (sMenuAct.equals("searchForCreate"))
      {
         session.setAttribute("creSelectedAttr", vAttrList);
      }
      else
         session.setAttribute("selectedAttr", vAttrList);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-setAttribute: " + e);
      logger.fatal("ERROR in GetACSearch-setAttribute : " + e.toString());
    }
  }

   /**
   * To get the list of attributes selected to display, called from getACKeywordResult and getACShowResult methods.
   * selected attribute values from the multi select list is stored in session vector 'selectedAttr'.
   * "All Attribute" select will add all the fields of the selected component to the vector
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param sSearchAC selected Administered component.
   *
   */
  public String getMultiReqValues(String sSearchAC, String sAction, String sAttr)
  {
    String sValues = "";
    if(sSearchAC == null) sSearchAC = "";
    try
    {
      HttpSession session = m_classReq.getSession();
      Vector vSelectList = new Vector();
      Vector vStatusDE = (Vector)session.getAttribute("vStatusDE");
      Vector vStatusDEC = (Vector)session.getAttribute("vStatusDEC");
      Vector vStatusVD = (Vector)session.getAttribute("vStatusVD");
      Vector vStatusCD = (Vector)session.getAttribute("vStatusCD");
      String sSelectList[] = null;
      if (sAttr.equals("WFStatus"))  
          sSelectList = m_classReq.getParameterValues("listStatusFilter");
      else
          sSelectList = m_classReq.getParameterValues("listMultiContextFilter");

      boolean bAllValues = false;
      if (sSelectList == null)
         bAllValues = true;

      if(sSelectList != null)
      {
      //loop through the string array to extract values.
      for(int i = 0; i<sSelectList.length; i++)
      {
        if(sSelectList[i] != null)
        {
          //make one string value to submit
          if (i == 0)
            sValues = sSelectList[i];
          else
            sValues = sValues + "," +  sSelectList[i];
          //set the value and break if all statuses or contexts selected
          if (sValues.equals("AllContext") || sValues.equals("AllStatus"))
          {
            bAllValues = true;
            break;
          }
          //store it in vector to refresh list on the page
          vSelectList.addElement(sSelectList[i]);
        }
      }
    }
      if (bAllValues == true)
      {
        vSelectList = new Vector();
        sValues = "";
        if (sSearchAC.equals("Questions") && sAttr.equals("WFStatus"))
        {
          sValues = "DRAFT NEW";
          vSelectList.addElement("DRAFT NEW");
        }
      }
      //store it in the session to refresh the list on the page
      if (sAttr.equals("WFStatus"))
      {
        if (sAction.equals("searchForCreate"))
        {
           session.setAttribute("creStatus", vSelectList);
           m_classReq.setAttribute("creStatusBlocks", vSelectList);
        }
        else
           session.setAttribute("serStatus", vSelectList);
      }
      else
      {
        if (sAction.equals("searchForCreate"))
           session.setAttribute("creMultiContext", vSelectList);
        else
           session.setAttribute("serMultiContext", vSelectList);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getMultiReqValues: " + e);
      logger.fatal("ERROR in GetACSearch-getMultiReqValues : " + e.toString());
    }
    return sValues;
  }

   /**
   * To get the list of attributes selected to display, called from getACKeywordResult and getACShowResult methods.
   * selected attribute values from the multi select list is stored in session vector 'selectedAttr'.
   * "All Attribute" select will add all the fields of the selected component to the vector
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param sSearchAC selected Administered component.
   *
   */
  public String getStatusValues(HttpServletRequest req, HttpServletResponse res,
         String sSearchAC, String sAction)
  {
    String sStatus = "";
    if(sSearchAC == null) sSearchAC = "";
    try
    {
      HttpSession session = req.getSession();
      Vector vStatusList = new Vector();
      Vector vStatusDE = (Vector)session.getAttribute("vStatusDE");
      Vector vStatusDEC = (Vector)session.getAttribute("vStatusDEC");
      Vector vStatusVD = (Vector)session.getAttribute("vStatusVD");
      Vector vStatusCD = (Vector)session.getAttribute("vStatusCD");
      String sStatusList[] = req.getParameterValues("listStatusFilter");
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
          if (sStatus.equals("AllStatus"))
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
        vStatusList = new Vector();
        sStatus = "";
        if (sSearchAC.equals("Questions"))
        {
          sStatus = "DRAFT NEW";
          vStatusList.addElement("DRAFT NEW");
        }
      }
      //store it in the session to refresh the list on the page
      if (sAction.equals("searchForCreate"))
      {
         session.setAttribute("creStatus", vStatusList);
         req.setAttribute("creStatusBlocks", vStatusList);
      }
      else
         session.setAttribute("serStatus", vStatusList);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getStatusValues: " + e);
      logger.fatal("ERROR in GetACSearch-setStatusValues : " + e.toString());
    }
    return sStatus;
  }

   /**
   * To get the list of doc types selected, called from getACKeywordResult and getACShowResult methods.
   * selected attribute values from the multi select list is stored in session vector 'selectedAttr'.
   * "All Attribute" select will add all the fields of the selected component to the vector
   *
   * @param sDocTypeList String[] array of strings.
   * @param sAction String for search action .
   *
   * @return String of selectd doc types.
   */
  public String getDocTypeValues(String[] sDocTypeList, String sAction) throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String sDocType = "";
      Vector vDocTypeList = new Vector();
      boolean bAllDocType = false;
      if(sDocTypeList != null)
      {
        //loop through the string array to extract values.
        for(int i = 0; i<sDocTypeList.length; i++)
        {
          if(sDocTypeList[i] != null)
          {
            //make one string value to submit
            if (i == 0)
              sDocType = sDocTypeList[i];
            else
              sDocType = sDocType + "," +  sDocTypeList[i];
            
            //set the value and break if all DocTypees checked
            if (sDocType.equals("AllDocType"))
            {
              bAllDocType = true;
              break;
            }
            //store it in vector to refresh list on the page
            vDocTypeList.addElement(sDocTypeList[i]);
          }
        }
      }
      //get all types into a vector vector if all Types
      if (bAllDocType == true)
      {
        sDocType = "ALL";
        vDocTypeList = (Vector)session.getAttribute("vRDocType");
      }
      //store them in the session according to the search action
      Vector vSelectedAttr = new Vector();
      if (sAction.equals("searchForCreate"))
      {
        session.setAttribute("creDocTyes", vDocTypeList);
        //add these to default display attributes
        vSelectedAttr = (Vector)session.getAttribute("creSelectedAttr");
      }
      else
      {
        session.setAttribute("serDocTyes", vDocTypeList); 
        //add these to default display attributes
        vSelectedAttr = (Vector)session.getAttribute("selectedAttr");
      }
      //add the selected type to the default display attributes
      if (vDocTypeList.contains("LONG_NAME") && !vSelectedAttr.contains("Long Name Document Text"))
        vSelectedAttr.addElement("Long Name Document Text");
        
      if (vDocTypeList.contains("HISTORIC SHORT CDE NAME") && !vSelectedAttr.contains("Historic Short CDE Name Document Text"))
        vSelectedAttr.addElement("Historic Short CDE Name Document Text");

      if (!vSelectedAttr.contains("Reference Documents"))
        vSelectedAttr.addElement("Reference Documents");
      
      //get the component attribute list
      Vector vComp = new Vector();
      if (sAction.equals("searchForCreate"))
          vComp = (Vector)session.getAttribute("creAttributeList");
      else
          vComp = (Vector)session.getAttribute("serAttributeList");

      //call method to resort the display attributes
      vSelectedAttr = m_servlet.resortDisplayAttributes(vComp, vSelectedAttr);

      //store the display attributes back in the session   
      if (sAction.equals("searchForCreate"))
      {
        session.setAttribute("creSelectedAttr", vSelectedAttr);
      //  m_classReq.setAttribute("creSelectedAttrBlocks", vSelectedAttr);
      }
      else
        session.setAttribute("selectedAttr", vSelectedAttr);
      
    return sDocType;   //return comma delimited string value back
  }

  /**
   * To get compared value to sort.
   * called from getDESortedRows, getDECSortedRows, getVDSortedRows, getPVSortedRows methods.
   * empty strings are considered as strings.
   * according to the fields, converts the string object into integer, double or dates.
   *
   * @param sField field name to sort.
   * @param firstName first name to compare.
   * @param SecondName second name to compare.
   *
   * @return int ComparedValue using compareto method of the object.
   *
   * @throws Exception
   */
  private int ComparedValue(String sField, String firstName, String SecondName)
          throws Exception
  {
      firstName = firstName.trim();
      SecondName = SecondName.trim();
      //this allows to put empty cells at the bottom by specify the return 
      if (firstName.equals(""))
         return 1;
      else if (SecondName.equals(""))
         return -1;

      if (sField.equals("minID") || sField.equals("MaxLength") ||
            sField.equals("MinLength") || sField.equals("Decimal"))
      {
         Integer iName1 = new Integer(firstName);
         Integer iName2 = new Integer(SecondName);
         return iName1.compareTo(iName2);
      }
      else if (sField.equals("version"))
      {
         Double dName1 = new Double(firstName);
         Double dName2 = new Double(SecondName);
         return dName1.compareTo(dName2);
      }
      else if ((sField.equals("BeginDate")) || (sField.equals("EndDate")) || (sField.equals("creDate")) || (sField.equals("modDate")))
      {
         SimpleDateFormat dteFormat = new SimpleDateFormat("MM/dd/yyyy");
         java.util.Date dtName1 = dteFormat.parse(firstName);
         java.util.Date dtName2 = dteFormat.parse(SecondName);
         return dtName1.compareTo(dtName2);
      }
      else
      {
         return firstName.compareToIgnoreCase(SecondName);
      }
  }

  /**
   * To get final result vector of selected attributes/rows to display for Data Element component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the DEBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getDEResult(HttpServletRequest req, HttpServletResponse res, Vector vResult, String refresh)
  {
    Vector vDE = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      String actType = (String)req.getParameter("actSelected");
      if(actType == null) actType = "";
      if(menuAction == null) menuAction = "";
      Vector vSelAttr = new Vector();
      Vector vRSel = new Vector();
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

      vDE = (Vector)session.getAttribute("vACSearch");
      if(actType.equals("BEDisplayRows") || menuAction.equals("BEDisplay")) 
        vRSel = (Vector)session.getAttribute("vSelRowsBEDisplay");
      else if (menuAction.equals("searchForCreate"))
        vRSel = (Vector)session.getAttribute("vACSearch");
      else
        vRSel = (Vector)session.getAttribute("vSelRows");  
            
      // Do this so vRSel is not null when SearchIn is changed to ProtocolID/CRFName
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if(sKeyword == null) sKeyword = "";
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      //add protocol id search term to the keyword search term
      String sProtoID = (String)session.getAttribute("serProtoID");  //get the proto id attribute
      if (sProtoID != null && !sProtoID.equals(""))
      {
          if (sKeyword != null && !sKeyword.equals(""))
              sKeyword = sProtoID + " & " + sKeyword;
          else
              sKeyword = sProtoID;
      }
      req.setAttribute("labelKeyword", "Data Element - " + sKeyword);   //make the label
      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vUsedContext = new Vector();
      for(int i=0; i<(vRSel.size()); i++)
      {
        DE_Bean DEBean = new DE_Bean();
        DEBean = (DE_Bean)vRSel.elementAt(i);

        vSearchID.addElement(DEBean.getDE_DE_IDSEQ());
        vSearchName.addElement(DEBean.getDE_PREFERRED_NAME());
        vSearchLongName.addElement(DEBean.getDE_LONG_NAME());
        vSearchASL.addElement(DEBean.getDE_ASL_NAME());
        vSearchDefinition.addElement(DEBean.getDE_PREFERRED_DEFINITION());
        vUsedContext.addElement(DEBean.getDE_USEDBY_CONTEXT());
        if (vSelAttr.contains("Long Name")) vResult.addElement(DEBean.getDE_LONG_NAME());
        if (vSelAttr.contains("Public ID")) vResult.addElement(DEBean.getDE_MIN_CDE_ID());
        if (vSelAttr.contains("Version")) vResult.addElement(DEBean.getDE_VERSION());
        if (vSelAttr.contains("Registration Status")) vResult.addElement(DEBean.getDE_REG_STATUS());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(DEBean.getDE_ASL_NAME());
        if (vSelAttr.contains("Owned By Context")) vResult.addElement(DEBean.getDE_CONTEXT_NAME());
        if (vSelAttr.contains("Used By Context")) vResult.addElement(DEBean.getDE_USEDBY_CONTEXT());
        if (vSelAttr.contains("Definition")) vResult.addElement(DEBean.getDE_PREFERRED_DEFINITION());
        if (vSelAttr.contains("Data Element Concept")) vResult.addElement(DEBean.getDE_DEC_NAME());
        if (vSelAttr.contains("Value Domain")) vResult.addElement(DEBean.getDE_VD_NAME());
        if (vSelAttr.contains("Name")) vResult.addElement(DEBean.getDE_PREFERRED_NAME());
        if (vSelAttr.contains("Origin")) vResult.addElement(DEBean.getDE_SOURCE());
       // if (vSelAttr.contains("Protocol ID")) vResult.addElement(DEBean.getDE_PROTOCOL_ID());
       // if (vSelAttr.contains("CRF Name")) vResult.addElement(DEBean.getDE_CRF_NAME());
        //put protocol id and crf with more hyperlink for multirecord attributes          
        vResult = this.addMultiRecordResultOther(vSelAttr, DEBean, vResult, "proto_crf");
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(DEBean.getDE_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(DEBean.getDE_END_DATE());
        if (vSelAttr.contains("Creator")) vResult.addElement(DEBean.getDE_CREATED_BY());
        if (vSelAttr.contains("Date Created")) vResult.addElement(DEBean.getDE_DATE_CREATED());
        if (vSelAttr.contains("Modifier")) vResult.addElement(DEBean.getDE_MODIFIED_BY());
        if (vSelAttr.contains("Date Modified")) vResult.addElement(DEBean.getDE_DATE_MODIFIED());
        if (vSelAttr.contains("Comments/Change Note")) vResult.addElement(DEBean.getDE_CHANGE_NOTE());
   //     if (vSelAttr.contains("Language")) vResult.addElement(DEBean.getDE_LANGUAGE());
        //get doc text and other multirecord attributes          
        vResult = this.addMultiRecordResultOther(vSelAttr, DEBean, vResult, "Other");
        if (vSelAttr.contains("Long Name Document Text")) vResult.addElement(DEBean.getDOC_TEXT_LONG_NAME());          
        if (vSelAttr.contains("Historic Short CDE Name Document Text")) vResult.addElement(DEBean.getDOC_TEXT_HISTORIC_NAME());          
        if (vSelAttr.contains("Reference Documents"))
        {
            String hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('ALL TYPES','" + 
            DEBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>Details_>></b></a>";
            vResult.addElement(hyperText);          
        }
        //vResult = this.addMultiRecordResultDocText(vSelAttr, DEBean, vResult);
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchASL", vSearchASL);
      session.setAttribute("SearchDefinitionAC", vSearchDefinition);
      session.setAttribute("SearchUsedContext", vUsedContext);
      // for Back button, put search results on a stack
    //  if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
      if(!menuAction.equals("searchForCreate"))
        this.stackSearchComponents("DataElement", vDE, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getDEResult: " + e);
      logger.fatal("ERROR in GetACSearch-getDEResult : " + e.toString());
    }
  }
  
  /**
   * adds registration staus to result vector
   * @param req
   * @param res
   * @param vResult
   */
  public void getDE_RegStatusResult(HttpServletRequest req, HttpServletResponse res, Vector vResult)
  {
    Vector vDE = new Vector();
    try
    {
      HttpSession session = req.getSession(); 
      Vector vRSel = (Vector)session.getAttribute("vSelRows");
      for(int i=0; i<(vRSel.size()); i++)
      {
        DE_Bean DEBean = new DE_Bean();
        DEBean = (DE_Bean)vRSel.elementAt(i);
        vResult.addElement(DEBean.getDE_REG_STATUS());
        vResult.addElement(DEBean.getDE_LONG_NAME());
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getDE_RegStatusResult: " + e);
      logger.fatal("ERROR in GetACSearch-getDE_RegStatusResult : " + e.toString());
    }
  }


 /**
  * adds more hyperlink for some attributes in the search results, which would open new window to get all attributes of AC
   * @param vSel vector of ac display attributes bean 
   * @param deBean current de bean
   * @param vRes display result vector
   * @param disType type of attribute to make the more hyperlink
   * @return vector of modified display result vector
   * @throws java.lang.Exception
  */
  private Vector addMultiRecordResultOther(Vector vSel, DE_Bean deBean, Vector vRes, String disType) throws Exception
  {
    String hyperText = "";
    if (disType.equals("proto_crf"))
    {
        //protocol id
        if (vSel.contains("Protocol ID") && deBean.getDE_PROTO_CRF_Count() != null 
              && deBean.getDE_PROTO_CRF_Count().intValue() >= 1) 
        {
            String acName = deBean.getDE_LONG_NAME();
            if (acName == null || acName.equals("")) acName = deBean.getDE_PREFERRED_NAME();
            UtilService util = new UtilService();
            acName = util.parsedStringSingleQuote(acName);
            acName = util.parsedString(acName);
            hyperText = "<a href=" + "\"" + "javascript:openProtoCRFWindow('" + acName +"','" + 
                  deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
            vRes.addElement(deBean.getDE_PROTOCOL_ID() + "  " + hyperText);
        }
        else if (vSel.contains("Protocol ID")) vRes.addElement(deBean.getDE_PROTOCOL_ID());
    
        //crf Name
        if (vSel.contains("CRF Name") && deBean.getDE_PROTO_CRF_Count() != null 
              && deBean.getDE_PROTO_CRF_Count().intValue() >= 1) 
        {
            String acName = deBean.getDE_LONG_NAME();
            if (acName == null || acName.equals("")) acName = deBean.getDE_PREFERRED_NAME();
            UtilService util = new UtilService();
            acName = util.parsedStringSingleQuote(acName);
            acName = util.parsedString(acName);
            hyperText = "<a href=" + "\"" + "javascript:openProtoCRFWindow('" + acName +"','" + 
                  deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
            vRes.addElement(deBean.getDE_CRF_NAME() + "  " + hyperText);
        }
        else if (vSel.contains("CRF Name")) vRes.addElement(deBean.getDE_CRF_NAME());      
    }
    else
    {
        //historical cde id
        if (vSel.contains("Historical CDE ID") && deBean.getDE_HIST_CDE_ID_COUNT() != null 
              && deBean.getDE_HIST_CDE_ID_COUNT().intValue() >= 1) 
        {
            hyperText = "<a href=" + "\"" + "javascript:openAltNameWindow('HISTORICAL_CDE_ID','" + 
                  deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
            vRes.addElement(deBean.getDE_HIST_CDE_ID() + "  " + hyperText);
        }
        else if (vSel.contains("Historical CDE ID")) vRes.addElement(deBean.getDE_HIST_CDE_ID());
        
        //permissible value
        if (vSel.contains("Permissible Value") && deBean.getDE_Permissible_Value_Count() != null 
              && deBean.getDE_Permissible_Value_Count().intValue() >= 1) 
        {
            String acName = deBean.getDE_LONG_NAME();
            if (acName == null || acName.equals("")) acName = deBean.getDE_PREFERRED_NAME();
            UtilService util = new UtilService();
            acName = util.parsedStringSingleQuote(acName);
            acName = util.parsedString(acName);
            hyperText = "<a href=" + "\"" + "javascript:openPermValueWindow('" + acName +"','" + 
                  deBean.getDE_VD_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
            vRes.addElement(deBean.getDE_Permissible_Value() + "  " + hyperText);
        }
        else if (vSel.contains("Permissible Value")) vRes.addElement(deBean.getDE_Permissible_Value());      
    }
    return vRes;
  }
  
  /**
   * makes the more hyperlink to display in the search result.
   * @param vSel vector of ac display attributes bean 
   * @param deBean current de bean
   * @param vRes display result vector
   * @return vector of modified display result vector
   * @throws java.lang.Exception
   */
  private Vector addMultiRecordResultDocText(Vector vSel, DE_Bean deBean, Vector vRes) throws Exception
  {
    String hyperText = "";
    //document text long name
    if (vSel.contains("Long Name Document Text") && deBean.getDOC_TEXT_LONG_NAME_COUNT() != null && deBean.getDOC_TEXT_LONG_NAME_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('LONG_NAME','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_LONG_NAME() + "  " + hyperText);
    }
    else if (vSel.contains("Long Name Document Text")) vRes.addElement(deBean.getDOC_TEXT_LONG_NAME());

    //document text historic short cde name
    if (vSel.contains("Historic Short CDE Name Document Text") && deBean.getDOC_TEXT_HISTORIC_COUNT() != null && deBean.getDOC_TEXT_HISTORIC_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('HISTORIC SHORT CDE NAME','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_HISTORIC_NAME() + "  " + hyperText);
    }
    else if (vSel.contains("Historic Short CDE Name Document Text")) vRes.addElement(deBean.getDOC_TEXT_HISTORIC_NAME());
    
    //document text Comment
    if (vSel.contains("Comment Document Text") && deBean.getDOC_TEXT_COMMENT_COUNT() != null && deBean.getDOC_TEXT_COMMENT_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('COMMENT','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_COMMENT() + "  " + hyperText);
    }
    else if (vSel.contains("Comment Document Text")) vRes.addElement(deBean.getDOC_TEXT_COMMENT());
    
    //document text Data Element Source 
    if (vSel.contains("Data Element Source Document Text") && deBean.getDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT() != null && deBean.getDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('DATA_ELEMENT_SOURCE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_DATA_ELEMENT_SOURCE() + "  " + hyperText);
    }
    else if (vSel.contains("Data Element Source Document Text")) vRes.addElement(deBean.getDOC_TEXT_DATA_ELEMENT_SOURCE());
    
    //document text Description
    if (vSel.contains("Description Document Text") && deBean.getDOC_TEXT_DESCRIPTION_COUNT() != null && deBean.getDOC_TEXT_DESCRIPTION_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('DESCRIPTION','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_DESCRIPTION() + "  " + hyperText);
    }
    else if (vSel.contains("Description Document Text")) vRes.addElement(deBean.getDOC_TEXT_DESCRIPTION());
    
    //document text Detail Description 
    if (vSel.contains("Detail Description Document Text") && deBean.getDOC_TEXT_DETAIL_DESCRIPTION_COUNT() != null && deBean.getDOC_TEXT_DETAIL_DESCRIPTION_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('DETAIL_DESCRIPTION','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_DETAIL_DESCRIPTION() + "  " + hyperText);
    }
    else if (vSel.contains("Detail Description Document Text")) vRes.addElement(deBean.getDOC_TEXT_DETAIL_DESCRIPTION());
    
    //document text Example 
    if (vSel.contains("Example Document Text") && deBean.getDOC_TEXT_EXAMPLE_COUNT() != null && deBean.getDOC_TEXT_EXAMPLE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('EXAMPLE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_EXAMPLE() + "  " + hyperText);
    }
    else if (vSel.contains("Example Document Text")) vRes.addElement(deBean.getDOC_TEXT_EXAMPLE());
    
    //document text Image File 
    if (vSel.contains("Image File Document Text") && deBean.getDOC_TEXT_IMAGE_FILE_COUNT() != null && deBean.getDOC_TEXT_IMAGE_FILE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('IMAGE_FILE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_IMAGE_FILE() + "  " + hyperText);
    }
    else if (vSel.contains("Image File Document Text")) vRes.addElement(deBean.getDOC_TEXT_IMAGE_FILE());
    
    //document text Label 
    if (vSel.contains("Label Document Text") && deBean.getDOC_TEXT_LABEL_COUNT() != null && deBean.getDOC_TEXT_LABEL_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('LABEL','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_LABEL() + "  " + hyperText);
    }
    else if (vSel.contains("Label Document Text")) vRes.addElement(deBean.getDOC_TEXT_LABEL());
    
    //document text Note
    if (vSel.contains("Note Document Text") && deBean.getDOC_TEXT_NOTE_COUNT() != null && deBean.getDOC_TEXT_NOTE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('NOTE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_NOTE() + "  " + hyperText);
    }
    else if (vSel.contains("Note Document Text")) vRes.addElement(deBean.getDOC_TEXT_NOTE());
    
    //document text Reference
    if (vSel.contains("Reference Document Text") && deBean.getDOC_TEXT_REFERENCE_COUNT() != null && deBean.getDOC_TEXT_REFERENCE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('REFERENCE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_REFERENCE() + "  " + hyperText);
    }
    else if (vSel.contains("Reference Document Text")) vRes.addElement(deBean.getDOC_TEXT_REFERENCE());
    
    //document text Technical Guide 
    if (vSel.contains("Technical Guide Document Text") && deBean.getDOC_TEXT_TECHNICAL_GUIDE_COUNT() != null && deBean.getDOC_TEXT_TECHNICAL_GUIDE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('TECHNICAL GUIDE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_TECHNICAL_GUIDE() + "  " + hyperText);
    }
    else if (vSel.contains("Technical Guide Document Text")) vRes.addElement(deBean.getDOC_TEXT_TECHNICAL_GUIDE());
    
    //document text UML Attribute 
    if (vSel.contains("UML Attribute Document Text") && deBean.getDOC_TEXT_UML_Attribute_Count() != null && deBean.getDOC_TEXT_UML_Attribute_Count().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('UML Attribute','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_UML_Attribute() + "  " + hyperText);
    }
    else if (vSel.contains("UML Attribute Document Text")) vRes.addElement(deBean.getDOC_TEXT_UML_Attribute());
    
    //document text UML Class 
    if (vSel.contains("UML Class Document Text") && deBean.getDOC_TEXT_UML_Class_Count() != null && deBean.getDOC_TEXT_UML_Class_Count().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('UML Class','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_UML_Class() + "  " + hyperText);
    }
    else if (vSel.contains("UML Class Document Text")) vRes.addElement(deBean.getDOC_TEXT_UML_Class());
    
    //document text Valid Value Source 
    if (vSel.contains("Valid Value Source Document Text") && deBean.getDOC_TEXT_VALID_VALUE_SOURCE_COUNT() != null && deBean.getDOC_TEXT_VALID_VALUE_SOURCE_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('VALID_VALUE_SOURCE','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_VALID_VALUE_SOURCE() + "  " + hyperText);
    }
    else if (vSel.contains("Valid Value Source Document Text")) vRes.addElement(deBean.getDOC_TEXT_VALID_VALUE_SOURCE());
    
    //document text Other Types 
    if (vSel.contains("Other Types Document Text") && deBean.getDOC_TEXT_OTHER_REF_TYPES_COUNT() != null && deBean.getDOC_TEXT_OTHER_REF_TYPES_COUNT().intValue() >1) 
    {
        hyperText = "<a href=" + "\"" + "javascript:openRefDocWindow('OTHER TYPES','" + 
              deBean.getDE_DE_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
        vRes.addElement(deBean.getDOC_TEXT_OTHER_REF_TYPES() + "  " + hyperText);
    }
    else if (vSel.contains("Other Types Document Text")) vRes.addElement(deBean.getDOC_TEXT_OTHER_REF_TYPES());
    
    return vRes;
  }
  
 /**
   * get DDE info, including RepType, rule, method, Conca_Char and all DE Components
   * and set them to session
   *
   * calls oracle stored procedure
   *  get_complex_de
   * This method is called by getSelRowToEdit(), by doSearchSelectionAction() or doSearchSelectionBEAction()
   * 
   * @param P_DE_IDSEQ, in, Primary DE's idseq.
   *
   */
  public void getDDEInfo(String P_DE_IDSEQ)
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
    logger.info(m_servlet.getLogMessage(m_classReq, "getDDEInfo", "begin getComplexDE", exDate, exDate));

    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    HttpSession session = m_classReq.getSession();

    String sRepType = "";
    String sRule = "";
    String sMethod = "";
    String sConcatChar = "";
    Vector vDEComp = new Vector();
    Vector vDECompID = new Vector();
    Vector vDECompOrder = new Vector();
    Vector vDECompRelID = new Vector();
    Vector vDECompDelete = new Vector();
    String sRulesAction = "newRule";

    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_COMPLEX_DE(?,?,?,?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(2, java.sql.Types.VARCHAR);
        CStmt.registerOutParameter(3, java.sql.Types.VARCHAR);
        CStmt.registerOutParameter(4, java.sql.Types.VARCHAR);
        CStmt.registerOutParameter(5, java.sql.Types.VARCHAR);
        CStmt.registerOutParameter(6, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1, P_DE_IDSEQ);
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //assign output DDE info from the result
        sRepType = (String) CStmt.getString(5);
        //capture the duration
      	logger.info(m_servlet.getLogMessage(m_classReq, "getDDEInfo", "get object", exDate, new java.util.Date()));
        if(sRepType != null && sRepType.length() > 1)
        {
            sMethod = (String) CStmt.getString(2);
            sRule = (String) CStmt.getString(3);
            sConcatChar = (String) CStmt.getString(4);
            if(sMethod == null)
                sMethod = "";
            if(sRule == null)
                sRule = "";
            if(sConcatChar == null)
                sConcatChar = "";
            sRulesAction = "existedRule";
            //set DE Comp vectors from resultset
            rs = (ResultSet) CStmt.getObject(6);
            if (rs!=null)
            {
              //loop through the resultSet and add them to the vector
              while(rs.next())
              {
                vDECompRelID.addElement(rs.getString(1));  // to be a new field in cursor
                vDEComp.addElement(rs.getString(2));
                vDECompID.addElement(rs.getString(3));
                vDECompOrder.addElement(rs.getString(4));
              }  //END WHILE
              //sort vDEComp against DECompOrder
              UtilService util = new UtilService();
              util.sortDEComps(vDEComp, vDECompID, vDECompRelID, vDECompOrder);
            }   //END IF (rs!=null)
        }

        // save them to session, even empty, refresh it
        session.setAttribute("vDEComp", vDEComp);
        session.setAttribute("vDECompID", vDECompID);
        session.setAttribute("vDECompOrder", vDECompOrder);
        session.setAttribute("vDECompRelID", vDECompRelID);
        session.setAttribute("vDECompDelete", vDECompDelete);   //clear vDECompDelete by setting it empty 
        session.setAttribute("sRepType", sRepType);
        session.setAttribute("sRule", sRule);
        session.setAttribute("sMethod", sMethod);
        session.setAttribute("sConcatChar", sConcatChar);
        session.setAttribute("sRulesAction", sRulesAction);
      }  // end of if (sbr_db_conn == null)
    }  // end of try
    catch(Exception e)
    {
      //System.err.println("problem in getDDEInfo: " + e);
      logger.fatal("ERROR - getDDEInfo : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in getDDEInfo: " + ee);
      logger.fatal("ERROR - getDDEInfo for close : " + ee.toString());
    }
    //capture the duration
    logger.info(m_servlet.getLogMessage(m_classReq, "getDDEInfo", "end search", exDate, new java.util.Date()));
  }  //end getDDEInfo

 /**
   * get Complex RepType and set them to session for DDE page repType drop list
   * 
   * calls oracle stored procedure
   *  get_complex_rep_type
   * This method is called by doInitDDEInfo()
   * 
   * @param 
   *
   */
  public void getComplexRepType()

  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    HttpSession session = m_classReq.getSession();

    String sRepType = "";
    Vector vRepType = new Vector();

    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_COMPLEX_REP_TYPE(?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(1, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

        //assign output complex rep type from the result
        vRepType.addElement("");  // top empty row
        rs = (ResultSet) CStmt.getObject(1);
        if (rs!=null)
        {
          //loop through the resultSet and add them to the vector
          while(rs.next())
          {
            vRepType.addElement(rs.getString("crtl_name"));
          }  //END WHILE
        }   //END IF (rs!=null)
        // save them to session
        session.setAttribute("vRepType", vRepType);
      }  // end of if (sbr_db_conn == null)
    }  // end of try
    catch(Exception e)
    {
      //System.err.println("problem in getComplexRepType: " + e);
      logger.fatal("ERROR - getComplexRepType : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in getComplexRepType: " + ee);
      logger.fatal("ERROR - getComplexRepType for close : " + ee.toString());
    }
  }  //end getComplexRepType

  /**
   * To get final result vector of selected attributes/rows to display for Data Element Concept component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the DECBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getDECResult(HttpServletRequest req, HttpServletResponse res,
         Vector vResult, String refresh)
  {
    Vector vDEC = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
     // Vector vSearchASL2 = (Vector)session.getAttribute("SearchASL");     
      Vector vSelAttr = new Vector();
      Vector vRSel = new Vector();
      String actType = (String)req.getParameter("actSelected");
      if(actType == null) actType = "";
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");
      //all search results
      vDEC = (Vector)session.getAttribute("vACSearch");
      if(actType.equals("BEDisplayRows") || menuAction.equals("BEDisplay")) 
        vRSel = (Vector)session.getAttribute("vSelRowsBEDisplay");
      else if (menuAction.equals("searchForCreate"))
        vRSel = (Vector)session.getAttribute("vACSearch");
      else
        vRSel = (Vector)session.getAttribute("vSelRows");
      //convert int to string to get the rec count
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Data Element Concept - " + sKeyword);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vUsedContext = new Vector();

      for(int i=0; i<(vRSel.size()); i++)
      {
        DEC_Bean DECBean = new DEC_Bean();
        DECBean = (DEC_Bean)vRSel.elementAt(i);
        vSearchID.addElement(DECBean.getDEC_DEC_IDSEQ());
        vSearchName.addElement(DECBean.getDEC_PREFERRED_NAME());
 System.out.println("getDECResult DECBean.getDEC_LONG_NAME(): " + DECBean.getDEC_LONG_NAME());
        vSearchLongName.addElement(DECBean.getDEC_LONG_NAME());
        vSearchASL.addElement(DECBean.getDEC_ASL_NAME());
        vSearchDefinition.addElement(DECBean.getDEC_PREFERRED_DEFINITION());
        vUsedContext.addElement(DECBean.getDEC_USEDBY_CONTEXT());

        if (vSelAttr.contains("Long Name")) vResult.addElement(DECBean.getDEC_LONG_NAME());
        if (vSelAttr.contains("Public ID")) vResult.addElement(DECBean.getDEC_DEC_ID());
        if (vSelAttr.contains("Version")) vResult.addElement(DECBean.getDEC_VERSION());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(DECBean.getDEC_ASL_NAME());
        if (vSelAttr.contains("Context")) vResult.addElement(DECBean.getDEC_CONTEXT_NAME());
        if (vSelAttr.contains("Definition")) vResult.addElement(DECBean.getDEC_PREFERRED_DEFINITION());
        if (vSelAttr.contains("Name")) vResult.addElement(DECBean.getDEC_PREFERRED_NAME());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(DECBean.getDEC_CD_NAME());
        if (vSelAttr.contains("Origin")) vResult.addElement(DECBean.getDEC_SOURCE());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(DECBean.getDEC_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(DECBean.getDEC_END_DATE());
        if (vSelAttr.contains("Creator")) vResult.addElement(DECBean.getDEC_CREATED_BY());
        if (vSelAttr.contains("Date Created")) vResult.addElement(DECBean.getDEC_DATE_CREATED());
        if (vSelAttr.contains("Modifier")) vResult.addElement(DECBean.getDEC_MODIFIED_BY());
        if (vSelAttr.contains("Date Modified")) vResult.addElement(DECBean.getDEC_DATE_MODIFIED());
        if (vSelAttr.contains("Comments/Change Note")) vResult.addElement(DECBean.getDEC_CHANGE_NOTE());
     //   if (vSelAttr.contains("Language")) vResult.addElement(DECBean.getDEC_LANGUAGE());
   }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchASL", vSearchASL);      
      session.setAttribute("SearchDefinitionAC", vSearchDefinition);
      session.setAttribute("SearchUsedContext", vUsedContext);
      // for Back button, put search results on a stack
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        this.stackSearchComponents("DataElementConcept", vDEC, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getDECResult: " + e);
      logger.fatal("ERROR in GetACSearch-getDECResult : " + e.toString());
    }
  }

  /**
   * To get final result vector of selected attributes/rows to display for Value Domain component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the VDBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getVDResult(HttpServletRequest req, HttpServletResponse res,
              Vector vResult, String refresh)
  {
    Vector vVD = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSelAttr = new Vector();
      Vector vRSel = new Vector();
      String actType = (String)req.getParameter("actSelected");     
      if(actType == null) actType = "";
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

      vVD = (Vector)session.getAttribute("vACSearch");
       if(actType.equals("BEDisplayRows") || menuAction.equals("BEDisplay")) 
        vRSel = (Vector)session.getAttribute("vSelRowsBEDisplay");
      else if (menuAction.equals("searchForCreate"))
        vRSel = (Vector)session.getAttribute("vACSearch");
      else
        vRSel = (Vector)session.getAttribute("vSelRows");
      
    //  if (menuAction.equals("searchForCreate"))  vRSel = null;
    //  if (vRSel == null)
    //    vRSel = vVD;
      if (vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Value Domain - " + sKeyword);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vUsedContext = new Vector();

      for(int i=0; i<(vRSel.size()); i++)
      {
        VD_Bean VDBean = new VD_Bean();
        VDBean = (VD_Bean)vRSel.elementAt(i);
        vSearchID.addElement(VDBean.getVD_VD_IDSEQ());
        vSearchName.addElement(VDBean.getVD_PREFERRED_NAME());
        vSearchLongName.addElement(VDBean.getVD_LONG_NAME());
        vSearchASL.addElement(VDBean.getVD_ASL_NAME());
        vSearchDefinition.addElement(VDBean.getVD_PREFERRED_DEFINITION());
        vUsedContext.addElement(VDBean.getVD_USEDBY_CONTEXT());

        if (vSelAttr.contains("Long Name")) vResult.addElement(VDBean.getVD_LONG_NAME());
        if (vSelAttr.contains("Public ID")) vResult.addElement(VDBean.getVD_VD_ID());
        if (vSelAttr.contains("Version")) vResult.addElement(VDBean.getVD_VERSION());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(VDBean.getVD_ASL_NAME());
        if (vSelAttr.contains("Context")) vResult.addElement(VDBean.getVD_CONTEXT_NAME());
        if (vSelAttr.contains("Definition")) vResult.addElement(VDBean.getVD_PREFERRED_DEFINITION());
        if (vSelAttr.contains("Name")) vResult.addElement(VDBean.getVD_PREFERRED_NAME());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(VDBean.getVD_CD_NAME());
        if (vSelAttr.contains("Data Type")) vResult.addElement(VDBean.getVD_DATA_TYPE());
        if (vSelAttr.contains("Origin")) vResult.addElement(VDBean.getVD_SOURCE());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(VDBean.getVD_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(VDBean.getVD_END_DATE());
        if (vSelAttr.contains("Creator")) vResult.addElement(VDBean.getVD_CREATED_BY());
        if (vSelAttr.contains("Date Created")) vResult.addElement(VDBean.getVD_DATE_CREATED());
        if (vSelAttr.contains("Modifier")) vResult.addElement(VDBean.getVD_MODIFIED_BY());
        if (vSelAttr.contains("Date Modified")) vResult.addElement(VDBean.getVD_DATE_MODIFIED());
        if (vSelAttr.contains("Comments/Change Note")) vResult.addElement(VDBean.getVD_CHANGE_NOTE());
      //  if (vSelAttr.contains("Language")) vResult.addElement(VDBean.getVD_LANGUAGE());
        if (vSelAttr.contains("Unit of Measures")) vResult.addElement(VDBean.getVD_UOML_NAME());
        if (vSelAttr.contains("Display Format")) vResult.addElement(VDBean.getVD_FORML_NAME());
        if (vSelAttr.contains("Maximum Length")) vResult.addElement(VDBean.getVD_MAX_LENGTH_NUM());
        if (vSelAttr.contains("Minimum Length")) vResult.addElement(VDBean.getVD_MIN_LENGTH_NUM());
        if (vSelAttr.contains("High Value Number")) vResult.addElement(VDBean.getVD_HIGH_VALUE_NUM());
        if (vSelAttr.contains("Low Value Number")) vResult.addElement(VDBean.getVD_LOW_VALUE_NUM());
        if (vSelAttr.contains("Decimal Place")) vResult.addElement(VDBean.getVD_DECIMAL_PLACE());
        if (vSelAttr.contains("Type Flag")) vResult.addElement(VDBean.getVD_TYPE_FLAG());
        //permissible value
        if (vSelAttr.contains("Permissible Value") && VDBean.getVD_Permissible_Value_Count() != null && VDBean.getVD_Permissible_Value_Count().intValue() >= 1) 
        {
            String acName = VDBean.getVD_LONG_NAME();
            if (acName == null || acName.equals("")) acName = VDBean.getVD_PREFERRED_NAME();
            UtilService util = new UtilService();
            acName = util.parsedStringSingleQuote(acName);
            acName = util.parsedString(acName);
            String hyperText = "<a href=" + "\"" + "javascript:openPermValueWindow('" + acName +"','" + 
                  VDBean.getVD_VD_IDSEQ() + "')" + "\"" + "><b>More_>></b></a>";
            vResult.addElement(VDBean.getVD_Permissible_Value() + "  " + hyperText);
        }
        else if (vSelAttr.contains("Permissible Value")) vResult.addElement(VDBean.getVD_Permissible_Value());
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchASL", vSearchASL);  
      session.setAttribute("SearchDefinitionAC", vSearchDefinition);
      session.setAttribute("SearchUsedContext", vUsedContext);
      // for Back button, put search results on a stack
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        this.stackSearchComponents("ValueDomain", vVD, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in  GetACSearch-getVDResult: " + e);
      logger.fatal("ERROR in GetACSearch-getVDResult : " + e.toString());
    }
  }

  /**
   * To get final result vector of selected attributes/rows to display for Data Element Concept component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the CDBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getCDResult(HttpServletRequest req, HttpServletResponse res,
         Vector vResult, String refresh)
  {

    Vector vCD = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSearchASL2 = (Vector)session.getAttribute("SearchASL");
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");
      vCD = (Vector)session.getAttribute("vACSearch");
      Vector vRSel = new Vector();  //(Vector)session.getAttribute("vSelRows");    //from selected rows
      if (menuAction.equals("searchForCreate"))
        vRSel = (Vector)session.getAttribute("vACSearch");
      else
        vRSel = (Vector)session.getAttribute("vSelRows");              
      //if (menuAction.equals("searchForCreate"))  vRSel = null;
     // if (vRSel == null)
     //   vRSel = vCD;
      //convert int to string to get the rec count
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Conceptual Domain - " + sKeyword);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vUsedContext = new Vector();

      for(int i=0; i<(vRSel.size()); i++)
      {
        CD_Bean CDBean = new CD_Bean();
        CDBean = (CD_Bean)vRSel.elementAt(i);
        vSearchID.addElement(CDBean.getCD_CD_IDSEQ());
        vSearchName.addElement(CDBean.getCD_PREFERRED_NAME());
        vSearchLongName.addElement(CDBean.getCD_LONG_NAME());
        vSearchASL.addElement(CDBean.getCD_ASL_NAME());
        vSearchDefinition.addElement(CDBean.getCD_PREFERRED_DEFINITION());
        vUsedContext.addElement(CDBean.getCD_CONTEXT_NAME());

        if (vSelAttr.contains("Long Name")) vResult.addElement(CDBean.getCD_LONG_NAME());
        if (vSelAttr.contains("Public ID")) vResult.addElement(CDBean.getCD_CD_ID());
        if (vSelAttr.contains("Version")) vResult.addElement(CDBean.getCD_VERSION());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(CDBean.getCD_ASL_NAME());
        if (vSelAttr.contains("Context")) vResult.addElement(CDBean.getCD_CONTEXT_NAME());
        if (vSelAttr.contains("Definition")) vResult.addElement(CDBean.getCD_PREFERRED_DEFINITION());
        if (vSelAttr.contains("Name")) vResult.addElement(CDBean.getCD_PREFERRED_NAME());
        if (vSelAttr.contains("Origin")) vResult.addElement(CDBean.getCD_SOURCE());
        //if (vSelAttr.contains("Dimensionality")) vResult.addElement(CDBean.getCD_DIMENSIONALITY());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(CDBean.getCD_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(CDBean.getCD_END_DATE());
        if (vSelAttr.contains("Creator")) vResult.addElement(CDBean.getCD_CREATED_BY());
        if (vSelAttr.contains("Date Created")) vResult.addElement(CDBean.getCD_DATE_CREATED());
        if (vSelAttr.contains("Modifier")) vResult.addElement(CDBean.getCD_MODIFIED_BY());
        if (vSelAttr.contains("Date Modified")) vResult.addElement(CDBean.getCD_DATE_MODIFIED());
        if (vSelAttr.contains("Comments/Change Note")) vResult.addElement(CDBean.getCD_CHANGE_NOTE());
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchASL", vSearchASL);     
      session.setAttribute("SearchDefinitionAC", vSearchDefinition);
      session.setAttribute("SearchUsedContext", vUsedContext);
      // for Back button, put search results and attributes on a stack
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        this.stackSearchComponents("ConceptualDomain", vCD, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getCDResult: " + e);
      logger.fatal("ERROR in GetACSearch-getCDResult : " + e.toString());
    }
  }
  
/**
   * To get resultSet from database for Object Class Component called from getACKeywordResult method.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_OC(InString, ContName, ASLName, OracleTypes.CURSOR)}"
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * @param InString Keyword value.
   * @param ContName selected context name.
   * @param ASLName selected workflow status name.
   * @param vList returns Vector of DEC bean.
   *
*/
  public void do_caDSRSearch(String InString,
      String ContName, String ASLName, String ID, Vector vList, String type)  // returns list of Data Element Concepts
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
  //  logger.info(m_servlet.getLogMessage(m_classReq, "do_caDSRSearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    String sql = "";
    String sDECUsing = "";
    String sCUIString = "";
    String compType = "";
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
        if(type.equals("OC") || type.equals("ObjQ"))
        {
          CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_OC(?,?,?,?,?)}");
          CStmt.registerOutParameter(5, OracleTypes.CURSOR);
          compType = "Object Class";
        }
        else if(type.equals("PROP") || type.equals("PropQ"))
        {
          CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_PROP(?,?,?,?,?)}");
          CStmt.registerOutParameter(5, OracleTypes.CURSOR);
          compType = "Property";
        }
        else if(type.equals("REP")  || type.equals("RepQ"))
        {
          CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_REP(?,?,?,?,?)}");
          CStmt.registerOutParameter(5, OracleTypes.CURSOR);
          compType = "Rep Term";
        }
        CStmt.setString(1,InString);
        CStmt.setString(2,ASLName);
        CStmt.setString(3,ContName);
        CStmt.setString(4,ID);
       // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();   
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(5);
        //capture the duration
    //    logger.info(m_servlet.getLogMessage(m_classReq, "do_caDSRSearch", "got rsObject", exDate, new java.util.Date()));
        String s;
        if(rs!=null)
        {
          //loop through to printout the outstrings
          while(rs.next())
          {
            EVS_Bean OCBean = new EVS_Bean();
            OCBean.setPREFERRED_NAME(rs.getString(1));
            OCBean.setLONG_NAME(rs.getString(2));
            OCBean.setPREFERRED_DEFINITION(rs.getString(3));
            OCBean.setCONTE_IDSEQ(rs.getString(4));
            OCBean.setASL_NAME(rs.getString(5));
            OCBean.setIDSEQ(rs.getString(6)); 
            OCBean.setEVS_DEF_SOURCE(rs.getString(12));
            OCBean.setCONDR_IDSEQ(rs.getString("condr_idseq"));
            OCBean.setEVS_DATABASE("caDSR");
            OCBean.setcaDSR_COMPONENT(compType);
            OCBean.setEVS_CONCEPT_SOURCE("origin");
            OCBean.setID(rs.getString(16));//public id
            OCBean.setCONTEXT_NAME(rs.getString(13));
            String decUseURL = "";
            //get the number of decs using this oc or prop
            if(type.equals("OC") || type.equals("ObjQ") || type.equals("PROP") || type.equals("PropQ"))
            {
              String decCount = rs.getString("dec_count");
              if (decCount != null && !decCount.equals("") && !decCount.equals("0"))
              {
                decUseURL = "<a href=" + "\"" + "javascript:openDECDetail('" + 
                  OCBean.getIDSEQ() + "')" + "\"" + "><b>" + decCount + "</b></a>";                
              }
            }
            OCBean.setDEC_USING(decUseURL);  //add the url to the attribute

            // get concatenated string of concept codes for EVS Identifier
            EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
            sCUIString = evs.getEVSIdentifierString(rs.getString("condr_idseq"));
            if(sCUIString == null) sCUIString = "";
            OCBean.setNCI_CC_VAL(sCUIString);
            
            vList.addElement(OCBean);    //add OC bean to vector
          }  //END WHILE
        }   //END IF
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-do_caDSRSearch: " + e);
      logger.fatal("ERROR - GetACSearch-do_caDSRSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-docaDSRSearch: " + ee);
      logger.fatal("GetACSearch-do_caDSRSearch for close : " + ee.toString());
    }
    //capture the duration
 //   logger.info(m_servlet.getLogMessage(m_classReq, "do_caDSRSearch", "end search", exDate,  new java.util.Date()));
  }  //endOC search
  
/**
   * To get resultSet from database for Concept Class called from getACKeywordResult method.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_CONCEPT(InString, ContName, ASLName, OracleTypes.CURSOR)}"
   * loop through the ResultSet and add them to bean which is added to the vector to return
   * @param InString Keyword value.
   * @param ContName selected context name.
   * @param ASLName selected workflow status name.
   * @param vList returns Vector of DEC bean.
   *
*/
  public Vector do_ConceptSearch(String InString, String conIdseq, 
      String ContName, String ASLName, String conID, Vector vList)  // returns list of Concepts
  {
System.out.println("do_conceptSearch InString: " + InString + " conIdseq: " + conIdseq);
    //capture the duration
 //   java.util.Date exDate = new java.util.Date();          
 //   logger.info(m_servlet.getLogMessage(m_classReq, "do_ConceptSearch", "begin search", exDate, exDate));
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    boolean bVListExist = false;
    //mark it if oc/prop/rep search was done earlier
    if (vList != null && vList.size()>0) bVListExist = true;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_CON(?,?,?,?,?,?)}");
      CStmt.registerOutParameter(6, OracleTypes.CURSOR);
      CStmt.setString(1, InString);
      CStmt.setString(2, ASLName);
      CStmt.setString(3, ContName);
      CStmt.setString(4, conID);
      CStmt.setString(5, conIdseq);
     // Now we are ready to call the stored procedure
      boolean bExcuteOk = CStmt.execute();   
      //store the output in the resultset
      rs = (ResultSet) CStmt.getObject(6);
      //capture the duration
    //  logger.info(m_servlet.getLogMessage(m_classReq, "do_ConceptSearch", "got rsObject", exDate, new java.util.Date()));
      String s;
      if(rs!=null)
      {
        //loop through to printout the outstrings
        while(rs.next())
        {
          EVS_Bean conBean = new EVS_Bean();
          conBean.setPREFERRED_NAME(rs.getString("preferred_name"));
          conBean.setLONG_NAME(rs.getString("long_name"));
          conBean.setPREFERRED_DEFINITION(rs.getString("preferred_definition"));
          conBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
          conBean.setASL_NAME(rs.getString("asl_name"));
          conBean.setIDSEQ(rs.getString("con_idseq")); 
          conBean.setEVS_DEF_SOURCE(rs.getString("definition_source"));
          conBean.setEVS_DATABASE("caDSR");
          conBean.setcaDSR_COMPONENT("Concept Class");
          conBean.setEVS_ORIGIN(rs.getString("origin"));
          conBean.setID(rs.getString("con_ID"));//public id
          conBean.setCONTEXT_NAME(rs.getString("context"));
          conBean.setDEC_USING("");
          conBean.setNCI_CC_VAL(rs.getString("preferred_name"));
          conBean.setNCI_CC_TYPE(rs.getString("evs_source"));
          //make sure it is included only once by matching evsId and concept name only if oc/prop/rep search was done earlier.
          boolean isExist = false;
          if (bVListExist == true)
          {
            for (int j = 0; j < vList.size(); j++)
            {
              EVS_Bean exBean = (EVS_Bean)vList.elementAt(j);
              String curEvsId = exBean.getNCI_CC_VAL();
              String curLName = exBean.getLONG_NAME();
              //check if not null or empty
              if (curEvsId != null && !curEvsId.equals("") && curLName != null && !curLName.equals(""))
              {
                //compare to the current one
                String evsId = conBean.getNCI_CC_VAL();
                String longName = conBean.getLONG_NAME();
                if (evsId != null && evsId.equals(curEvsId) && longName != null && longName.equals(curLName))
                  isExist = true;
              }
            }
          }
          if (isExist == false)
            vList.addElement(conBean);    //add concept bean to vector
        }  //END WHILE
      }   //END IF
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - GetACSearch-do_conceptSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      logger.fatal("GetACSearch-do_conceptSearch for close : " + ee.toString());
    }
    //capture the duration
 //   logger.info(m_servlet.getLogMessage(m_classReq, "do_conceptSearch", "end search", exDate,  new java.util.Date()));
    return vList;
  }  //endconcept search
  

 /**
	 * Puts in and takes out "_"
   *  @param String nodeName.
   *  @param String type.
	 */
	private final String filterName(String nodeName, String type)
  {
    if(type.equals("display"))
      nodeName = nodeName.replaceAll("_"," ");
    else if(type.equals("js"))
      nodeName = nodeName.replaceAll(" ","_");
      return nodeName;
  }


  /**
   * To get vector of checked rows, called from getACKeywordResult and getACShowResult methods.
   * loops through the vector 'vSelRows' and adds the checked rows to a vector.
   * stored resulted vector to in session 'vSelRows'
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getRowSelectedBEDisplay(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vAC = (Vector)session.getAttribute("vACSearch");
      Vector vSelRows = new Vector();
      Vector vSRows = (Vector)session.getAttribute("vSelRows");
      String sSearchAC = (String)session.getAttribute("searchAC");
      Vector vCheckList2 = (Vector)session.getAttribute("CheckList");
      //check if the vector has the data
      if (vSRows != null && vSRows.size()>0)
      {
         int rowNo = 0;
        //loop through the searched vector to get the matched checked rows
        for(int i=0; i<(vSRows.size()); i++)
        {
          String ckName = ("CK" + i);             
          //if the number of rows selected is more then add only the checked ones to the vector of vSelRows
         
            if (vCheckList2 != null && vCheckList2.contains(ckName))  // && vAC != null)
            {
                vSelRows.addElement(vSRows.elementAt(i));
            }
        }
      }
      session.setAttribute("vSelRowsBEDisplay", vSelRows);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-rowSelectedBEDisplay: " + e);
      logger.fatal("ERROR in GetACSearch-rowSelectedBEDispay : " + e.toString());
    }
  }

   /**
   * To get vector of checked rows, called from getACKeywordResult and getACShowResult methods.
   * loops through the vector 'vSelRows' and adds the checked rows to a vector.
   * stored resulted vector to in session 'vSelRows'
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
   public void getRowSelected(HttpServletRequest req, HttpServletResponse res, boolean isNewList)
  {
    try
    {
      HttpSession session = req.getSession();
     // Vector vAC = (Vector)session.getAttribute("vACSearch");
      Vector vSelRows = new Vector();
      Vector vSRows = new Vector();    //(Vector)session.getAttribute("vSelRows");
      String rNumSel = (String)req.getParameter("numSelected");
      String sMenu = (String)session.getAttribute("MenuAction");
      String sSearchAC = "";
      //get the searched results according to the menu action
      if (sMenu != null && sMenu.equals("searchForCreate"))
      {
        sSearchAC = (String)session.getAttribute("creSearchAC");
        vSRows = (Vector)session.getAttribute("vACSearch");
      }
      else
      {
        sSearchAC = (String)session.getAttribute("searchAC");
        vSRows = (Vector)session.getAttribute("vSelRows");
      }
      String actType = (String)req.getParameter("actSelected");
      if (actType == null) actType = "";
      Vector vCheckList = new Vector();  
      //check if the vector has the data
      if (vSRows != null && vSRows.size()>0 && isNewList == false && !actType.equals("NoRowsSelected"))
      {
         int rowNo = 0;
        //loop through the searched vector to get the matched checked rows
        OuterLoop:
        for(int i=0; i<(vSRows.size()); i++)
        {
          //if the number of rows selected is more then add only the checked ones to the vector of vSelRows
          if ((rNumSel != null) && (!rNumSel.equals("")))
          {
            String ckName = ("CK" + i);
            String rSel = (String)req.getParameter(ckName);
            if (rSel == null)
              continue OuterLoop;
            else
            {
              vCheckList.addElement("CK" + rowNo);    //add the checked names to the vector
              rowNo++;
            }
          }
          vSelRows.addElement(vSRows.elementAt(i));
        }
        if(!actType.equals("BEDisplayRows")) 
        {
          if (sMenu.equals("searchForCreate"))
            session.setAttribute("creCheckList", vCheckList); //add the check list in the session.
          else
            session.setAttribute("CheckList", vCheckList); //add the check list in the session.
        }
      }
      else if(actType.equals("NoRowsSelected"))
      {
          if (sMenu.equals("searchForCreate"))
            session.setAttribute("creCheckList", vCheckList); //add the check list in the session.
          else
            session.setAttribute("CheckList", null);
          vSelRows = vSRows;
      }
      else if (!sMenu.equals("searchForCreate"))
      {
        vSelRows = vSRows;
        // Code below ensures dupliclate enries are not put in the vectors during an append
        Vector vSearchID = (Vector)session.getAttribute("SearchID"); 
        if (vSearchID == null) vSearchID = new Vector();
        Vector vAC = (Vector)session.getAttribute("newSearchRes"); 
        if (vAC != null)
        {
            for(int i=0; i<(vAC.size()); i++)
            {
              if(sSearchAC.equals("DataElement"))
              {
                DE_Bean DEBean = new DE_Bean();
                DEBean = (DE_Bean)vAC.elementAt(i);
                if(!vSearchID.contains(DEBean.getDE_DE_IDSEQ()))
                {
                  vSelRows.addElement(vAC.elementAt(i));
                  vSearchID.addElement(DEBean.getDE_DE_IDSEQ());
                }
              }
              else if(sSearchAC.equals("DataElementConcept"))
              {
                DEC_Bean DECBean = new DEC_Bean();
                DECBean = (DEC_Bean)vAC.elementAt(i);
                if(!vSearchID.contains(DECBean.getDEC_DEC_IDSEQ()))
                {
                  vSelRows.addElement(vAC.elementAt(i));
                  vSearchID.addElement(DECBean.getDEC_DEC_IDSEQ());
                }
              }
              else if(sSearchAC.equals("ValueDomain"))
              {
                VD_Bean VDBean = new VD_Bean();
                VDBean = (VD_Bean)vAC.elementAt(i);
                if(!vSearchID.contains(VDBean.getVD_VD_IDSEQ()))
                {
                  vSelRows.addElement(vAC.elementAt(i));
                  vSearchID.addElement(VDBean.getVD_VD_IDSEQ());
                }
              }
            }
            session.setAttribute("newSearchRes", new Vector()); 
        }
      }
      if(actType != null && actType.equals("BEDisplayRows")) 
        session.setAttribute("vSelRowsBEDisplay", vSelRows);
      else if (!sMenu.equals("searchForCreate"))
        session.setAttribute("vSelRows", vSelRows);

    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-rowSelected: " + e);
      logger.fatal("ERROR in GetACSearch-rowSelected : " + e.toString());
    }
  }


  /**
   * To get checked row bean(single or multiple), called from NCICuration Servlet.
   * loops through the vector 'vSelRows' and gets bean of the checked row of a selected component.
   * checks the edit permission if action is not a new from template.
   * gets many to many related components if any.
   * calls 'getACListForEdit' to load the list for the selected context.
   * stores resulted bean in session ('m_DE') for th selected component.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   * @return boolean false if error exists
   */
  public boolean getSelRowToEdit(HttpServletRequest req, HttpServletResponse res, String sAction)
  {
    HttpSession session = req.getSession();
    Vector vBEResult = new Vector();
    boolean isValid = true;
    try
    {
      GetACService getAC = new GetACService(req, res, m_servlet);  //
      String sUser = (String)session.getAttribute("Username");
      String sMenuAction = (String)session.getAttribute("MenuAction");
      session.setAttribute("statusMessage", "");
      String sSearchAC = (String)session.getAttribute("searchAC");   //get the selected component
      Vector vSRows = (Vector)session.getAttribute("vSelRows");   //get the selected rows
      Vector vCheckList = new Vector();
      //handle problem with menu item when get associated.
      if (sSearchAC.equals("DataElement"))
      {     
        //reset menu action is it was get associated 
        if (sMenuAction.equals("NewDECTemplate") || sMenuAction.equals("NewVDTemplate"))
            sMenuAction = "NewDETemplate";
        else if (sMenuAction.equals("NewDECVersion") || sMenuAction.equals("NewVDVersion"))
            sMenuAction = "NewDEVersion";
      }
      else if (sSearchAC.equals("DataElementConcept"))
      {
        //reset menu action is it was get associated 
        if (sMenuAction.equals("NewDETemplate") || sMenuAction.equals("NewVDTemplate"))
            sMenuAction = "NewDECTemplate";
        else if (sMenuAction.equals("NewDEVersion") || sMenuAction.equals("NewVDVersion"))
            sMenuAction = "NewDECVersion";
      }
      else if (sSearchAC.equals("ValueDomain"))
      {
        //reset menu action is it was get associated 
        if (sMenuAction.equals("NewDECTemplate") || sMenuAction.equals("NewDETemplate"))
            sMenuAction = "NewVDTemplate";
        else if (sMenuAction.equals("NewDECVersion") || sMenuAction.equals("NewDEVersion"))
            sMenuAction = "NewVDVersion";
      }
      //reset the menu action
      session.setAttribute("MenuAction", sMenuAction);
      //set variable but not the session attribute to avoid the problem with the menuaction other than Edit DE
      if (sAction.equals("EditDesDE")) 
        sMenuAction = sAction;
      // reset cs/csi vectors prior to each block edit
      if (vSRows.size()>0)
      {
        String sContext = "";
        String sStatus = "";
        String strInValid = "";

      	//capture the duration
      	java.util.Date exDate = new java.util.Date();          
      	logger.info(m_servlet.getLogMessage(m_classReq, "getSelRowToEdit", "begin rowselect", exDate, exDate));
        //loop through the searched DE result to get the matched checked rows
        for(int i=0; i<(vSRows.size()); i++)
        {
          String ckName = ("CK" + i);
          String rSel = (String)req.getParameter(ckName);
          if (rSel != null)
          {   //reset the bean with selected row for the selected component
            session.setAttribute("ckName", ckName);
            vCheckList.addElement(ckName);    //add the checked checkbox in the vector
            if (sSearchAC.equals("DataElement"))
            {
              DE_Bean DEBean = new DE_Bean();
              //DEBean = (DE_Bean)vSRows.elementAt(i);
              DEBean = DEBean.cloneDE_Bean((DE_Bean)vSRows.elementAt(i),"Complete");
              //doCSCSISearch(DEBean, sAction, req);    //related CSCSI result
              String sContextID = DEBean.getDE_CONTE_IDSEQ();
              //check the permissiion if not template and not designation   
              if(!sMenuAction.equals("NewDETemplate") && !sMenuAction.equals("EditDesDE"))
                strInValid = checkWritePermission("de", sUser, sContextID, getAC);
              //back to search results page if  no write permit and is one of the create item
              if (!strInValid.equals(""))   // && sMenuAction.substring(0, 5).equalsIgnoreCase("NewDE"))
              {
                session.setAttribute("statusMessage", "User does not have authorization to Create/Edit for the selected context");
                Vector vResult = new Vector();
                getDEResult(req, res, vResult, "");
                session.setAttribute("results", vResult);
                isValid = false;
                break;
              }
              else
              {
                //get used by attributes and continue with other actions if is valid.  No need to do this here
                DEBean = this.getDEAttributes(DEBean, sAction, sMenuAction);  //get other DE attributes
                // clone the bean to store it
                DE_Bean clDEBean = new DE_Bean();
                clDEBean = clDEBean.cloneDE_Bean(DEBean, "Complete");
                vBEResult.addElement(clDEBean);   //store this in the vector for block edit
                //store this bean to get its attributes and to use it to clear the changes
                if (DEBean != null)
                   session.setAttribute("oldDEBean",  clDEBean);

                session.setAttribute("m_DE", DEBean);  //this removed the problem
              }                
            }
            else if (sSearchAC.equals("DataElementConcept"))
            {
              DEC_Bean DECBean = new DEC_Bean();
              DECBean = DECBean.cloneDEC_Bean((DEC_Bean)vSRows.elementAt(i));
              String sContextID = "";
              if (DECBean != null) sContextID = DECBean.getDEC_CONTE_IDSEQ();
              if(!sMenuAction.equals("NewDECTemplate"))
                 strInValid = checkWritePermission("dec", sUser, sContextID, getAC);
              if (!strInValid.equals(""))
              {
                session.setAttribute("statusMessage", "User does not have authorization to Create/Edit for the selected context");
                Vector vResult = new Vector();
                getDECResult(req, res, vResult, "");
                session.setAttribute("results", vResult);
                isValid = false;
                break;
              }
              else
              {
                DECBean = this.getDECAttributes(DECBean, sAction, sMenuAction);  //get all other attributes of DEC
                // clone the bean to store it
                DEC_Bean clDECBean = new DEC_Bean();
                clDECBean = clDECBean.cloneDEC_Bean(DECBean);
                vBEResult.addElement(clDECBean);   //store this in the vector for block edit
                //store this bean to get its attributes and to use it to clear the changes
                if (DECBean != null)
                   session.setAttribute("oldDECBean",  clDECBean);
                session.setAttribute("m_DEC", DECBean);  
              }
            }
            else if (sSearchAC.equals("ValueDomain"))
            {

              VD_Bean VDBean = new VD_Bean();
              VD_Bean VDBean2 = new VD_Bean();
              VDBean2 = (VD_Bean)vSRows.elementAt(i);     
              VDBean = VDBean.cloneVD_Bean((VD_Bean)vSRows.elementAt(i));            
              if (VDBean != null) sContext = VDBean.getVD_CONTEXT_NAME();
              if (VDBean != null) sStatus = VDBean.getVD_ASL_NAME();
              String sContextID = "";
              if (VDBean != null) sContextID = VDBean.getVD_CONTE_IDSEQ();
  
              if(!sMenuAction.equals("NewVDTemplate"))
                 strInValid = checkWritePermission("vd", sUser, sContextID, getAC);
              if (!strInValid.equals(""))
              {
                session.setAttribute("statusMessage", "User does not have authorization to Create/Edit for the selected context");
                Vector vResult = new Vector();          
                getVDResult(req, res, vResult, "");
                session.setAttribute("results", vResult);
                isValid = false;
                break;
              }
              else
              {           
                VDBean = this.getVDAttributes(VDBean, sAction, sMenuAction);           
                // clone the bean to store it
                VD_Bean clVDBean = new VD_Bean();
                clVDBean = clVDBean.cloneVD_Bean(VDBean);          
                vBEResult.addElement(clVDBean);   //store this in the vector for block edit
                //store this bean to get its attributes and to use it to clear the changes
                if (VDBean != null)
                   session.setAttribute("oldVDBean",  clVDBean);                
                session.setAttribute("m_VD", VDBean);
              }
            }
            else if (sSearchAC.equals("Questions"))
            {
               //get the quest bean  from the vector
               Quest_Bean selQuestBean = new Quest_Bean();
               selQuestBean = (Quest_Bean)vSRows.elementAt(i);
               session.setAttribute("m_Quest", selQuestBean);
               isValid = doSelectDEforQuestion(req, res, selQuestBean, getAC);
               break;
            }
          }
        }
        //capture the duration
        logger.info(m_servlet.getLogMessage(m_classReq, "getSelRowToEdit", "end rowselect", exDate,  new java.util.Date()));
        if (!strInValid.equals(""))
        {
            vCheckList = new Vector();
            for(int m=0; m<(vSRows.size()); m++)  //add all checked to vChecklist
            {
              String ckName2 = ("CK" + m);
              String rSel2 = (String)req.getParameter(ckName2);
              if (rSel2 != null)
                vCheckList.addElement(ckName2);
            }        
        }        
        session.setAttribute("CheckList", vCheckList); //add the check list in the session.
      }
      if (sAction.equalsIgnoreCase("BlockEdit") || sAction.equalsIgnoreCase("EditDesDE"))
         this.getSelRowForBlockEdit(sSearchAC);  //store attributes in the session fro block edit.

      session.setAttribute("vBEResult", vBEResult);    //store this for block edit
      session.setAttribute("vACId", (Vector)m_classReq.getAttribute("vACId"));
      session.setAttribute("vACName", (Vector)m_classReq.getAttribute("vACName"));
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in  GetACSearch-getSelRowToEdit: " + e);
      logger.fatal("ERROR in GetACSearch-getSelRowToEdit : " + e.toString());
      session.setAttribute("statusMessage", "Unable to open the Create/Edit page. Please try again.");
      return false;
    }
    return isValid;
  } //getSelRowEdit



  /**
  * The getDECAttributes method gets other attributes of DEC.
  * Called from 'doOpenEditDECPage' method from servlet and 'getSelRowEdit' method
  * Calls doCSCSI_ACSearch to get its cs-csi attributes
  * Calls 'doAltNameSearch' to get alternate names attributes.
  * Calls 'getCDContext' to append context to cd name.
  *
  * @param DECBean the selected DEC_Bean
  * @param sAction string the origin action of the ac
  * @param sMenu string menu action of the ac
  *
  * @return DEC_Bean a bean of DEC attributes
  * 
  * @throws Exception
  */
  public DEC_Bean getDECAttributes(DEC_Bean DECBean, String sAction, String sMenu) throws Exception
  {
      HttpSession session = m_classReq.getSession();
      EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
      //get this ac cs-csi attributes
      if (!sMenu.equals("NewDECTemplate"))
      {
        Vector vACCSI = this.doCSCSI_ACSearch(DECBean.getDEC_DEC_IDSEQ(), DECBean.getDEC_LONG_NAME());
      //  if (vACCSI != null)
      //  {
          Vector vCS = (Vector)m_classReq.getAttribute("selCSNames");
          Vector vCSid = (Vector)m_classReq.getAttribute("selCSIDs"); 
      
          DECBean.setDEC_CS_NAME(vCS);
          DECBean.setDEC_CS_ID(vCSid);
          DECBean.setDEC_AC_CSI_VECTOR(vACCSI);
      //  }
      }
      //make some attributes default/empty for NUE action
      if (sMenu.equals("NewDECTemplate"))
      {
        DECBean.setDEC_VERSION("1.0");
        DECBean.setDEC_ASL_NAME("");
      }
      //make the workflow status to empty if
      if (sMenu.equals("NewDECVersion"))
        DECBean.setDEC_ASL_NAME("");        

      //get all the selected ac id and name
      Vector vACid = (Vector)m_classReq.getAttribute("vACId");
      Vector vACName = (Vector)m_classReq.getAttribute("vACName");
      if (vACid == null) vACid = new Vector();
      if (vACName == null) vACName = new Vector();
      vACid.addElement(DECBean.getDEC_DEC_IDSEQ());
      String acName = "";
      if (DECBean.getDEC_LONG_NAME() != null && !DECBean.getDEC_LONG_NAME().equals(""))
        acName = DECBean.getDEC_LONG_NAME();
      else
        acName = DECBean.getDEC_PREFERRED_NAME();
      vACName.addElement(acName);
  //System.out.println("getDECAttributes2 DECBean ocid: " + DECBean.getDEC_OCL_IDSEQ());
      if(!sAction.equalsIgnoreCase("BlockEdit"))
      {           
          String oc_condr_idseq = DECBean.getDEC_OC_CONDR_IDSEQ();
 //System.out.println("getDECAttributes2 oc_condr_idseq: " + oc_condr_idseq);
          if(oc_condr_idseq != null)
          {
            session.setAttribute("vObjectClass", null);
            evs.fillOCVectors(oc_condr_idseq, DECBean, sMenu);
          }
          String prop_condr_idseq = DECBean.getDEC_PROP_CONDR_IDSEQ();
          if(prop_condr_idseq != null)
          {
            session.setAttribute("vProperty", null);
            evs.fillPropVectors(prop_condr_idseq, DECBean, sMenu);
          }

          DECBean.setAC_USER_PREF_NAME(DECBean.getDEC_PREFERRED_NAME());
          DECBean.setAC_PREF_NAME_TYPE("");
          //get the oc and prop information
          DECBean = m_servlet.doGetDECNames(m_classReq, m_classRes, null, "OpenDEC", DECBean);
          //get dec system name
          InsACService insAC = new InsACService(m_classReq, m_classRes, m_servlet);
          String sysName = insAC.getDECSysName(DECBean);
          if (sysName == null) sysName = "";
          DECBean.setAC_SYS_PREF_NAME(sysName);
          DECBean.setAC_USER_PREF_NAME(DECBean.getDEC_PREFERRED_NAME());

          //make sure that no name type is selected
       }  
      //get contexts selected so far
      Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
      if (selContext == null) selContext = new Vector();
      String sContID = DECBean.getDEC_CONTE_IDSEQ();
      if (!selContext.contains(sContID))
      {
        selContext.addElement(sContID);
        m_classReq.setAttribute("SelectedContext", selContext);  //add to the request
        DECBean.setDEC_SELECTED_CONTEXT_ID(selContext);     //add to the DEC bean
      }
                                  
      //get the cd name with the context
      acName = this.getCDContext(DECBean.getDEC_CD_IDSEQ());
      if (acName !=null && !acName.equals(""))
         DECBean.setDEC_CD_NAME(acName);

      //store ac names and ids in the req attribute
      m_classReq.setAttribute("vACId", vACid);
      m_classReq.setAttribute("vACName", vACName);
      return DECBean;    
  }//getDECAttributes
  
  /**
  * The getDEAttributes method gets other attributes of DE.
  * Called from 'doOpenEditDEPage' method from servlet and 'getSelRowEdit' method
  * Calls doCSCSI_ACSearch to get its cs-csi attributes
  * Calls 'getCDContext' to append context to cd name.
  *
  * @param DEBean DE_Bean the selected DE_Bean
  * @param sAction string the origin action of the ac
  * @param sMenu string menu action of the ac
  *
  * @return DE_Bean a bean of DE attributes
  * 
  * @throws Exception
  */
  public DE_Bean getDEAttributes(DE_Bean DEBean, String sAction, String sMenu) throws Exception
  {
      HttpSession session = m_classReq.getSession();
      //get doc text long name idseq for edit
      InsACService insAC = new InsACService(m_classReq, m_classRes, m_servlet);
      String desID = insAC.getRD_ID(DEBean.getDE_DE_IDSEQ());
      if (desID != null) DEBean.setDOC_TEXT_LONG_NAME_IDSEQ(desID);
             
      if (!sAction.equals("BlockEdit") && !sAction.equals("EditDesDE"))      
        getDDEInfo(DEBean.getDE_DE_IDSEQ());  // get DDE info and set them to session

      //make some attributes to default/empty if NUE
      if (sMenu.equals("NewDETemplate") || sAction.equals("Template"))
      {
        DEBean.setDE_VERSION("1.0");
        DEBean.setDE_ASL_NAME("");
        DEBean.setDE_REG_STATUS("");
        DEBean.setDE_REG_STATUS_IDSEQ("");
      }
      //make the workflow status to empty if
      if (sMenu.equals("NewDEVersion"))
        DEBean.setDE_ASL_NAME("");
        
      //get this ac cs-csi attributes not for template
      if (!sMenu.equals("NewDETemplate") && !sAction.equals("Template"))
      {
        Vector vACCSI = this.doCSCSI_ACSearch(DEBean.getDE_DE_IDSEQ(), DEBean.getDE_LONG_NAME());
       // if (vACCSI != null)
       // {
          Vector vCS = (Vector)m_classReq.getAttribute("selCSNames");
          Vector vCSid = (Vector)m_classReq.getAttribute("selCSIDs");    
          DEBean.setDE_CS_NAME(vCS);
          DEBean.setDE_CS_ID(vCSid);
          DEBean.setDE_AC_CSI_VECTOR(vACCSI);
       // }
      }

      //get alternate names and reference documents if menu is edit des
      if (sAction.equals("EditDesDE"))
      {
        //get ref docs for this de
        this.doRefDocSearch(DEBean.getDE_DE_IDSEQ(), "ALL TYPES");
        //get alt names for this DE
        this.doAltNameSearch(DEBean.getDE_DE_IDSEQ(), "", "", "EditDesDE");
      }
      //get all the selected ac id and name
      Vector vACid = (Vector)m_classReq.getAttribute("vACId");
      Vector vACName = (Vector)m_classReq.getAttribute("vACName");
      if (vACid == null) vACid = new Vector();
      if (vACName == null) vACName = new Vector();
      vACid.addElement(DEBean.getDE_DE_IDSEQ());
      String acName = "";
      if (DEBean.getDE_LONG_NAME() != null && !DEBean.getDE_LONG_NAME().equals(""))
        acName = DEBean.getDE_LONG_NAME();
      else
        acName = DEBean.getDE_PREFERRED_NAME();
      vACName.addElement(acName);

      //get contexts selected so far
      Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
      if (selContext == null) selContext = new Vector();
      String sContID = DEBean.getDE_CONTE_IDSEQ();
      if (!selContext.contains(sContID))
      {
        selContext.addElement(sContID);
        m_classReq.setAttribute("SelectedContext", selContext);  //add to the request
        DEBean.setDE_SELECTED_CONTEXT_ID(selContext);     //add to the de bean
      }
      
      //get associated dec and vd beans into de bean
      //if (!sAction.equals("BlockEdit") && !sAction.equals("EditDesDE"))
      if (!sAction.equals("EditDesDE"))
      {
        DEBean.setAC_USER_PREF_NAME(DEBean.getDE_PREFERRED_NAME());
        DEBean.setAC_PREF_NAME_TYPE("");
        String sDECid = DEBean.getDE_DEC_IDSEQ();
        Vector vDECList = new Vector();
        this.doDECSearch(sDECid, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", vDECList);
        if (vDECList != null && vDECList.size() > 0)
          DEBean.setDE_DEC_Bean((DEC_Bean)vDECList.elementAt(0));
        String sVDid = DEBean.getDE_VD_IDSEQ();
        Vector vVDList = new Vector();
        this.doVDSearch(sVDid, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", "", vVDList);
        if (vVDList != null && vVDList.size() > 0)
          DEBean.setDE_VD_Bean((VD_Bean)vVDList.elementAt(0));
        //store teh current one as user preferred
        //get system and abbr name to use it later
        DEBean = m_servlet.doGetDENames(m_classReq, m_classRes, "noChange", "OpenDE", DEBean);
      }
      //store ac names and ids in the req attribute
      m_classReq.setAttribute("vACId", vACid);
      m_classReq.setAttribute("vACName", vACName);
      return DEBean;    
  }//getDEAttributes
  
  /**
  * The getVDAttributes method gets other attributes of VD.
  * Called from 'doOpenEditVDPage' method from servlet and 'getSelRowEdit' method
  * Calls doCSCSI_ACSearch to get its cs-csi attributes
  * Calls 'getCDContext' to append context to cd name.
  *
  * @param VDBean the selected VD_Bean
  * @param sAction string the origin action of the ac
  * @param sMenu string menu action of the ac
  *
  * @return VD_Bean a bean of VD attributes
  * 
  * @throws Exception
  */
  public VD_Bean getVDAttributes(VD_Bean VDBean, String sAction, String sMenu) throws Exception
  {
      HttpSession session = m_classReq.getSession();
      EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
      //get this ac cs-csi attributes
      if (!sMenu.equals("NewVDTemplate"))
      {
        Vector vACCSI = this.doCSCSI_ACSearch(VDBean.getVD_VD_IDSEQ(), VDBean.getVD_LONG_NAME());
      //  if (vACCSI != null)
      //  {
          Vector vCS = (Vector)m_classReq.getAttribute("selCSNames");
          Vector vCSid = (Vector)m_classReq.getAttribute("selCSIDs"); 
          VDBean.setVD_CS_NAME(vCS);
          VDBean.setVD_CS_ID(vCSid);
          VDBean.setVD_AC_CSI_VECTOR(vACCSI);
      //  }        
      }
      //make some attributes default/empty for NUE action
      if (sMenu.equals("NewVDTemplate"))
      {
        VDBean.setVD_VERSION("1.0");
        VDBean.setVD_ASL_NAME("");
      }
      //make the workflow status to empty if
      if (sMenu.equals("NewVDVersion"))
        VDBean.setVD_ASL_NAME("");        

      //get all the selected ac id and name
      Vector vACid = (Vector)m_classReq.getAttribute("vACId");
      Vector vACName = (Vector)m_classReq.getAttribute("vACName");
      if (vACid == null) vACid = new Vector();
      if (vACName == null) vACName = new Vector();
      vACid.addElement(VDBean.getVD_VD_IDSEQ());
      String acName = "";
      if (VDBean.getVD_LONG_NAME() != null && !VDBean.getVD_LONG_NAME().equals(""))
        acName = VDBean.getVD_LONG_NAME();
      else
        acName = VDBean.getVD_PREFERRED_NAME();
      vACName.addElement(acName);

      boolean isSystemName = false;
      String vdName = VDBean.getVD_PREFERRED_NAME();
      //store preferred name type attributes
      VDBean.setAC_USER_PREF_NAME(vdName);  //user is whatever it was before by default.
      VDBean.setAC_PREF_NAME_TYPE("");
 
      String rep_condr_idseq = VDBean.getVD_REP_CONDR_IDSEQ();
      if(!sAction.equalsIgnoreCase("BlockEdit") && rep_condr_idseq != null)
      {
        session.setAttribute("vRepTerm", null);
        evs.fillRepVectors(rep_condr_idseq, VDBean, sMenu); 
        //make the abbreviated name if existing one is system name
        VDBean = m_servlet.doGetVDNames(m_classReq, m_classRes, null, "OpenVD", VDBean);
      }
      //get contexts selected so far
      Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
      if (selContext == null) selContext = new Vector();
      String sContID = VDBean.getVD_CONTE_IDSEQ();
      if (!selContext.contains(sContID))
      {
        selContext.addElement(sContID);
        m_classReq.setAttribute("SelectedContext", selContext);  //add to the request
        VDBean.setVD_SELECTED_CONTEXT_ID(selContext);     //add to the de bean
      }
                                  
      //get the cd name with the context
      acName = this.getCDContext(VDBean.getVD_CD_IDSEQ());
      if (acName !=null && !acName.equals(""))
         VDBean.setVD_CD_NAME(acName);
      //VDBean = doPVSearch(VDBean, "search");    //get the permissible values 
      Integer pvCount = new Integer(0);
      if (!sAction.equalsIgnoreCase("BlockEdit"))
      {
        String pvAct = "Search";
        if (sMenu.equals("NewVDTemplate")) pvAct = "NewUsing";         
        pvCount = this.doPVACSearch(VDBean.getVD_VD_IDSEQ(), VDBean.getVD_LONG_NAME(), pvAct);
        if (sMenu.equals("Questions"))
          this.getACQuestionValue();
      }
      
      //get vd parent attributes
      if (!sAction.equalsIgnoreCase("BlockEdit"))
      {
        GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
        Vector vParent = new Vector();
        String sCondr = VDBean.getVD_PAR_CONDR_IDSEQ();
        if (sCondr != null && !sCondr.equals(""))
          vParent = getAC.getAC_Concepts(VDBean.getVD_PAR_CONDR_IDSEQ(), VDBean, true);
        //get the system name and for new template make the vd_id null
        if (sMenu.equals("NewVDTemplate")) VDBean.setVD_VD_ID("");
        VDBean = m_servlet.doGetVDSystemName(m_classReq, VDBean, vParent);
        vParent = this.getNonEVSParent(vParent, VDBean, sMenu);
         
        session.setAttribute("VDParentConcept", vParent);  
      }
      //store ac names and ids in the req attribute
      m_classReq.setAttribute("vACId", vACid);
      m_classReq.setAttribute("vACName", vACName);
      return VDBean;   
  }//getVDAttributes
  
  /**
   * gets the non evs parent from reference documents table for the vd
   * @param vParent
   * @param vd
   * @return Vector
   * @throws java.lang.Exception
   */
  public String getMetaParentSource(String sParent, String sCui, VD_Bean PageVD) throws Exception
  { 
    //search the existing reference document 
    HttpSession session = m_classReq.getSession();
    String sRDMetaCUI = "";
    String sUMLS_CUI = "";
 
    if(PageVD != null)
    {
      this.doRefDocSearch(PageVD.getVD_VD_IDSEQ(), "META_CONCEPT_SOURCE");
      Vector vList = (Vector)m_classReq.getAttribute("RefDocList");
      if (vList != null && vList.size() > 0)
      {
        for (int i=0; i<vList.size(); i++)
        {
          REF_DOC_Bean RDBean = (REF_DOC_Bean)vList.elementAt(i);
          //copy rd attributes to evs attribute
          if (RDBean != null && RDBean.getDOCUMENT_NAME() != null && !RDBean.getDOCUMENT_NAME().equals(""))
          {
            sRDMetaCUI = RDBean.getDOCUMENT_TEXT();
            if(sRDMetaCUI.equals(sCui))
              return RDBean.getDOCUMENT_NAME();
            else if(sCui.equals("None"))
              return RDBean.getDOCUMENT_NAME();
          }
        }
      }
    }
    return "";
  }
  
  /**
   * gets the non evs parent from reference documents table for the vd
   * @param vParent vector of selected parents
   * @param vd current VD_Bean
   * @param menuAct string menu action
   * 
   * @return Vector
   * @throws java.lang.Exception
   */
  public Vector getNonEVSParent(Vector vParent, VD_Bean vd, String menuAct) throws Exception
  {
    //search the existing reference document 
    this.doRefDocSearch(vd.getVD_VD_IDSEQ(), "VD REFERENCE");
    Vector vList = (Vector)m_classReq.getAttribute("RefDocList");
    if (vList != null && vList.size() > 0)
    {
      for (int i=0; i<vList.size(); i++)
      {
        REF_DOC_Bean RDBean = (REF_DOC_Bean)vList.elementAt(i);
        //copy rd attributes to evs attribute
        if (RDBean != null && RDBean.getDOCUMENT_NAME() != null && !RDBean.getDOCUMENT_NAME().equals(""))
        {
          //since already created by api reset it to do upate action for new version
          if (menuAct != null && menuAct.equals("versionSubmit"))
          {
            for (int j=0; j<vParent.size(); j++)
            {
              EVS_Bean nBean = (EVS_Bean)vParent.elementAt(j);
              if (nBean.getEVS_DATABASE() != null && nBean.getEVS_DATABASE().equals("Non_EVS"))
              {
                //reset rd id seq
                if (RDBean.getDOC_TYPE_NAME().equals(nBean.getNCI_CC_VAL()) && RDBean.getDOCUMENT_NAME().equals(nBean.getLONG_NAME()))
                {
                  nBean.setCON_IDSEQ(RDBean.getREF_DOC_IDSEQ());
                  vParent.setElementAt(nBean, j);
                }
              }
            }
          }
          else
          {
            EVS_Bean eBean = new EVS_Bean();
            eBean.setCON_IDSEQ(RDBean.getREF_DOC_IDSEQ());
            eBean.setNCI_CC_VAL(RDBean.getDOC_TYPE_NAME());
            eBean.setLONG_NAME(RDBean.getDOCUMENT_NAME());
            eBean.setPREFERRED_DEFINITION(RDBean.getDOCUMENT_TEXT());
            eBean.setEVS_DEF_SOURCE(RDBean.getDOCUMENT_URL());
            eBean.setCONTE_IDSEQ(RDBean.getCONTE_IDSEQ());
            eBean.setEVS_DATABASE("Non_EVS");
            eBean.setCON_AC_SUBMIT_ACTION("UPD");
            //new one to be created
            if (menuAct == null || menuAct.equals("NewVDTemplate"))
            {
              eBean.setCON_AC_SUBMIT_ACTION("INS");
              eBean.setCON_IDSEQ("");
            }
            vParent.addElement(eBean);
          }
        }
      }
    }
    return vParent;
  }
  /**
   * resets attributes for block edit
   * @param sSearchAC string of the search ac name
   */
   private void getSelRowForBlockEdit(String sSearchAC) throws Exception
   {
      HttpSession session = m_classReq.getSession();
      Vector vCS = (Vector)m_classReq.getAttribute("selCSNames");
      Vector vCSid = (Vector)m_classReq.getAttribute("selCSIDs");
      Vector vACCSI = (Vector)m_classReq.getAttribute("blockAC_CSI");
      if (sSearchAC.equals("DataElementConcept"))
      {
        DEC_Bean bDECBean = new DEC_Bean();   //remove all other attributes
        bDECBean.setDEC_CS_NAME(vCS);
        bDECBean.setDEC_CS_ID(vCSid);
        bDECBean.setDEC_AC_CSI_VECTOR(vACCSI);
        //add selected contexts to the bean
        Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
        bDECBean.setDEC_SELECTED_CONTEXT_ID(selContext);
        session.setAttribute("m_DEC", bDECBean);
        DEC_Bean clBean = new DEC_Bean();
        session.setAttribute("oldDECBean",  clBean.cloneDEC_Bean(bDECBean));
      }
      else if (sSearchAC.equals("ValueDomain"))
      {
        VD_Bean bVDBean = new VD_Bean();   //remove all other attributes
        bVDBean.setVD_CS_NAME(vCS);
        bVDBean.setVD_CS_ID(vCSid);
        bVDBean.setVD_AC_CSI_VECTOR(vACCSI);
        //add selected contexts to the bean
        Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
        bVDBean.setVD_SELECTED_CONTEXT_ID(selContext);
        session.setAttribute("m_VD", bVDBean);
        VD_Bean clBean = new VD_Bean();
        session.setAttribute("oldVDBean",  clBean.cloneVD_Bean(bVDBean));
      }
      else if (sSearchAC.equals("DataElement"))
      {
        DE_Bean bDEBean = new DE_Bean();   //remove all other attributes
        bDEBean.setDE_CS_NAME(vCS);
        bDEBean.setDE_CS_ID(vCSid);
        bDEBean.setDE_AC_CSI_VECTOR(vACCSI);
        //add selected contexts to the bean
        Vector selContext = (Vector)m_classReq.getAttribute("SelectedContext");
        bDEBean.setDE_SELECTED_CONTEXT_ID(selContext);
        session.setAttribute("m_DE", bDEBean);
        DE_Bean clBean = new DE_Bean();
        session.setAttribute("oldDEBean",  clBean.cloneDE_Bean(bDEBean, "Complete"));
      }      
   }
   
  /**
   * To store the old attributes of the selected row in the session.
   * called from selRowToEdit method after gettting the selected row.
   * Extract the attributes from the bean stores it in the session.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param DEBean Data Element Bean.
   * @param DECBean Data Element Concept Bean.
   * @param VDBean Value Domain Bean.
   *
   * @throws exception
   */
  private void storeOldAttInSession(HttpServletRequest req, HttpServletResponse res,
    DE_Bean DEBean, DEC_Bean DECBean, VD_Bean VDBean) throws Exception
  {
      HttpSession session = req.getSession();
      String ACIDseq = "";
      String conName = "";
      String prefName = "";
      String contextID = "";
      String aslName = "";
      if (DEBean != null)
      {
         ACIDseq = DEBean.getDE_DE_IDSEQ();
         conName = DEBean.getDE_CONTEXT_NAME();
         prefName = DEBean.getDE_PREFERRED_NAME();
         contextID = DEBean.getDE_CONTE_IDSEQ();
         aslName = DEBean.getDE_ASL_NAME();
         session.setAttribute("OldDEContextID", contextID);
         session.setAttribute("OldDEContext", conName);
         session.setAttribute("OldDEPreferredName", prefName);
         session.setAttribute("OldDEAslName", aslName);
      }
      else if (DECBean != null)
      {
         ACIDseq = DECBean.getDEC_DEC_IDSEQ();
         conName = DECBean.getDEC_CONTEXT_NAME();
         prefName = DECBean.getDEC_PREFERRED_NAME();
         contextID = DECBean.getDEC_CONTE_IDSEQ();
         aslName = DECBean.getDEC_ASL_NAME();
         session.setAttribute("OldDECContextID", contextID);
         session.setAttribute("OldDECContext", conName);
         session.setAttribute("OldDECPreferredName", prefName);
         session.setAttribute("OldDECAslName", aslName);
      }
      else if (VDBean != null)
      {
         ACIDseq = VDBean.getVD_VD_IDSEQ();
         conName = VDBean.getVD_CONTEXT_NAME();
         prefName = VDBean.getVD_PREFERRED_NAME();
         contextID = VDBean.getVD_CONTE_IDSEQ();
         aslName = VDBean.getVD_ASL_NAME();
         session.setAttribute("OldVDContextID", contextID);
         session.setAttribute("OldVDContext", conName);
         session.setAttribute("OldVDPreferredName", prefName);
         session.setAttribute("OldVDAslName", aslName);
      }
  }
  /**
   * To check write permission for the user for the selected context in the selected component, called from getSelRowToEdit.
   * calls 'getAC.hasPrivilege' to get the permission value.
   * returns error Message if no permit.
   *
   * @param ACType selected component.
   * @param sUserName User Name.
   * @param ContID selected context idseq.
   * @param getAC reference to class GetACService.
   *
   * @return String sErrorMessage if permission is No. empty string if Yes.
   */
   public String checkWritePermission(String ACType, String sUserName,
                 String ContID, GetACService getAC)
   {
    String sErrorMessage = "";
    try
    {
       // validation code here
       String sPermit = "";
       sPermit = getAC.hasPrivilege("Create", sUserName, ACType, ContID);
       if (sPermit.equals("Yes"))
          sErrorMessage = "";
       else if (sPermit.equals("No"))
          sErrorMessage = sUserName + " does not have authorization";
       else
          sErrorMessage = "Unable to determine the write permission.";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in  GetACSearch-checkWritePermission: " + e);
      logger.fatal("ERROR in GetACSearch-checkWritePermission : " + e.toString());
    }
    return sErrorMessage;
   }

  /**
   * To open the Data Element page to create new or edit  for the selected question, called from getSelRowToEdit.
   * Stores the DE_Bean for the selected question in the session
   *
   * @param QuestBean Quest_Bean.
   * @param DEBean DE_Bean.
   * @param sUserName User Name.
   * @param getAC reference to class GetACService.
   *
   * @return boolean isValid if no write permission
   */
   private boolean doSelectDEforQuestion(HttpServletRequest req, HttpServletResponse res,
                  Quest_Bean QuestBean, GetACService getAC) throws Exception
   {
       HttpSession session = req.getSession();
       String strInValid = "";
       String sDEID = QuestBean.getDE_IDSEQ();   //get the associated deID from the bean
       boolean isValid = true;
       DE_Bean DEBean = new DE_Bean();
       //call search_DE to get all the attributes of DE with this de_id if exists
       if (sDEID != null && !sDEID.equals(""))
       {  
          Vector vList = new Vector();
          doDESearch(sDEID, "", "","","","", 0, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", vList);
          if (vList != null && vList.size()>0)
             DEBean = (DE_Bean)vList.elementAt(0);
          //check permission, get cs and csi, check create or edit
          if (DEBean != null)
          {
             //check if user is editing or creating new from existing
             if ((QuestBean.getVD_IDSEQ() != null) && (!QuestBean.getVD_IDSEQ().equals("")))
             {
                //check if the de_vd is same as crf_vd
                if (DEBean.getDE_VD_IDSEQ().equals(QuestBean.getVD_IDSEQ()))
                   QuestBean.setSTATUS_INDICATOR("Edit");
                else
                   QuestBean.setSTATUS_INDICATOR("Template");
             }
             //allow to edit only if the user has the write permission to do so.
             if (QuestBean.getSTATUS_INDICATOR().equals("Edit"))
             {
                String sUser = (String)session.getAttribute("Username");
                String sContextID = DEBean.getDE_CONTE_IDSEQ();
                strInValid = checkWritePermission("de", sUser, sContextID, getAC);
                if (!strInValid.equals(""))
                {
                   session.setAttribute("statusMessage", "User does not have authorization to Create/Edit for the selected context");
                   Vector vResult = new Vector();
                   getQuestionResult(req, res, vResult);
                   session.setAttribute("results", vResult);
                   isValid = false;
                   return isValid;
                }
                //get other de attributes for edit
                DEBean = this.getDEAttributes(DEBean, "Edit", "Question");                
             }
          }
       }  //end if de exist

       //add the quest attributes to the DE bean if not edit
       if (!QuestBean.getSTATUS_INDICATOR().equals("Edit"))
       {
          DEBean.setDE_CONTE_IDSEQ(QuestBean.getCONTE_IDSEQ());   //question context id
          DEBean.setDE_CONTEXT_NAME(QuestBean.getCONTEXT_NAME()); //question context name
          DEBean.setDOC_TEXT_LONG_NAME(QuestBean.getQUEST_NAME());  //question name

          //add vd attribute if VD exists already for the question
          if ((QuestBean.getVD_IDSEQ() != null) && (!QuestBean.getVD_IDSEQ().equals("")))
          {
             //add the crf_vd attributes to the DE bean
             DEBean.setDE_VD_IDSEQ(QuestBean.getVD_IDSEQ());
             DEBean.setDE_VD_NAME(QuestBean.getVD_LONG_NAME());
             String sName = DEBean.getDE_DEC_NAME();
             if (sName == null) sName = "";
             DEBean.setDE_LONG_NAME(sName + " " + QuestBean.getVD_LONG_NAME());
             DEBean.setDE_VD_PREFERRED_NAME(QuestBean.getVD_PREF_NAME());
             sName = DEBean.getDE_DEC_PREFERRED_NAME();
             if (sName == null) sName = "";
             DEBean.setDE_PREFERRED_NAME(sName + "_" + QuestBean.getVD_PREF_NAME());
             DEBean.setDE_VD_Definition(QuestBean.getVD_DEFINITION());
             sName = DEBean.getDE_DEC_Definition();
             if (sName == null) sName = "";
             DEBean.setDE_PREFERRED_DEFINITION(sName + "_" + QuestBean.getVD_DEFINITION());
          }
          //get other de attributes this de template
          if (DEBean.getDE_DE_IDSEQ() != null && !DEBean.getDE_DE_IDSEQ().equals(""))
          {
            DEBean = this.getDEAttributes(DEBean, "Template", "Question");
            DEBean.setDE_DE_IDSEQ("");   //make de_idseq to null for template
          }
          //get vd attributes since this question has VD but not DE
          else if (DEBean.getDE_VD_IDSEQ() != null && !DEBean.getDE_VD_IDSEQ().equals(""))
          {
            String sVDid = DEBean.getDE_VD_IDSEQ();
            Vector vVDList = new Vector();
            this.doVDSearch(sVDid, "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 0, "", "", "", vVDList);
            if (vVDList != null && vVDList.size() > 0)
              DEBean.setDE_VD_Bean((VD_Bean)vVDList.elementAt(0));
            //get system and abbr name to use it later
            DEBean = m_servlet.doGetDENames(m_classReq, m_classRes, "noChange", "OpenDE", DEBean);            
            DEBean.setAC_USER_PREF_NAME(DEBean.getDE_PREFERRED_NAME());
            DEBean.setDE_ASL_NAME("DRAFT NEW");
          }
          else
          {
            String DEDefinition = m_servlet.getPropertyDefinition();  //m_settings.getProperty("DEDefinition");
            DEBean.setDE_PREFERRED_DEFINITION(DEDefinition);
            DEBean.setDE_ASL_NAME("DRAFT NEW");
            DEBean.setAC_PREF_NAME_TYPE("SYS");            
          }
       }
      //store this in the session bean to use it later
      session.setAttribute("m_Quest", QuestBean);
      session.setAttribute("sDefaultContext", QuestBean.getCONTEXT_NAME());
      session.setAttribute("m_DE", DEBean);
      DE_Bean oldDE = new DE_Bean();
      session.setAttribute("oldDEBean", oldDE.cloneDE_Bean(DEBean, "Complete"));     //store the bean in the oldDEbean to use it later
      return isValid;
   }

  /**
   * To load the drop lists for the selected context in the selected component, called from getSelRowToEdit.
   * if the selected context is same as context of the loaded list, gets lists only if doesn't exist.
   * if different contexts, calls 'getAC.getACList' for the selected component.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param sContext selected context Name.
   * @param ACType selected component.
   * @param getAC reference to class GetACService.
   *
   */


  /**
   * To get search result from database for permissible values Component
   * called from getACListForEdit method, servlet 'doOpenEditVDPage'.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_PV(VD_IDSEQ, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to value and item vectors.
   * Update the VDBean with value, item and pvIDSeq vectors.
   *
   * @param VDBean Bean of the Value Domain
   *
   */
  public VD_Bean doPVSearch(VD_Bean VDBean, String sAction)  // returns list of Data Elements
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      String VD_IDSEQ = VDBean.getVD_VD_IDSEQ();
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_PV(?,?)}");
        // Now tie the placeholders with actual parameters.
        CStmt.registerOutParameter(2, OracleTypes.CURSOR);
        CStmt.setString(1,VD_IDSEQ);
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(2);
        Vector vPValue = new Vector();
        Vector vShortMean = new Vector();
        Vector vShortMeanDesc = new Vector();
        Vector vPVidseq = new Vector();
        Vector vVPidseq = new Vector();
        Vector vOrigin = new Vector();
        //to capture vdpvs relationship store related attributes in pv bean
        PV_Bean pvBean = new PV_Bean();
        Vector vPVBean = new Vector();
        if(rs!=null)
        {
          //loop through to printout the outstrings
          while(rs.next())
          {
            vPVidseq.addElement(rs.getString(1));
            vPValue.addElement(rs.getString(2));
            vShortMean.addElement(rs.getString(3));
            vVPidseq.addElement(rs.getString(4));
            vOrigin.addElement(rs.getString(5));
            vShortMeanDesc.addElement(rs.getString(6));
            //store these attributes in pv bean to access later
            pvBean = new PV_Bean();
            pvBean.setPV_PV_IDSEQ(rs.getString(1));
            pvBean.setPV_VALUE(rs.getString(2));
            pvBean.setPV_SHORT_MEANING(rs.getString(3));
            pvBean.setPV_VDPVS_IDSEQ(rs.getString(4));
            pvBean.setPV_VALUE_ORIGIN(rs.getString(5));
            pvBean.setPV_MEANING_DESCRIPTION(rs.getString(6));
            pvBean.setPV_VM_CONDR_IDSEQ(rs.getString("vm_condr_idseq"));
            //store it in the vector
            vPVBean.addElement(pvBean);
          }  //END WHILE
        }   //END IF
        //this is to allow re-search this for new id to get only the old ids
        if (!sAction.equals("Version"))
        {
           VDBean.setVD_PV_ID(vPVidseq);
           VDBean.setVD_PV_NAME(vPValue);
           VDBean.setVD_PV_MEANING(vShortMean);
           VDBean.setVD_PV_MEANING_DESCRIPTION(vShortMeanDesc);
           VDBean.setVD_PV_ORIGIN(vOrigin);
        }
        //store the old ids in the session
        HttpSession session = m_classReq.getSession();
        session.setAttribute("serPVID", vPVidseq);
        session.setAttribute("serPVBeanList", vPVBean);
      }
    }
    catch(Exception e)
    {
   //   //System.err.println("ERROR in  GetACSearch-doPVSearch: " + e);
      logger.fatal("ERROR in GetACSearch-doPVSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
 //     //System.err.println("Problem closing in GetACSearch-doPVSearch: " + ee);
      logger.fatal("ERROR in GetACSearch-doPVSearch for close : " + ee.toString());
    }
    return VDBean;
  }  //endPV search

  /**
   * To get search result from database for Classification Scheme/Items Component called from getACListForEdit method.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE_CS_NAME(DE_IDSEQ, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to CS and CSI vectors.
   * Update the DEBean with CS, CSIDseq, CSI and CSIIDSeq vectors.
   *
   * @param DECBean Bean of the Data Element Concept
   *
   */
  public Vector doCSCSI_ACSearch(String AC_IDseq, String AC_Name)  // returns bean of Data Elements
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    HttpSession session = m_classReq.getSession();
    Vector vAC_CSI = new Vector();
    try
    {
       // String AC_IDSEQ = DECBean.getDEC_DEC_IDSEQ();        
      Vector vCSNames = (Vector)m_classReq.getAttribute("selCSNames");
      Vector vCSids = (Vector)m_classReq.getAttribute("selCSIDs");
      vAC_CSI = (Vector)m_classReq.getAttribute("blockAC_CSI");
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE_CS_NAME(?,?)}");
        // Now tie the placeholders with actual parameters.
        CStmt.registerOutParameter(2, OracleTypes.CURSOR);
        CStmt.setString(1, AC_IDseq);
         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();
        //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(2);
        if(rs!=null)
        {
          //loop through to printout the outstrings
          while(rs.next())
          {
            AC_CSI_Bean acCSIBean = new AC_CSI_Bean();
            acCSIBean.setAC_CSI_IDSEQ(rs.getString("ac_csi_idseq"));
            //csi related
            //store it in the csi bean and store the bean in ac_csi bean
            CSI_Bean csiBean = new CSI_Bean();
            csiBean.setCSI_CS_IDSEQ(rs.getString("CS_IDSEQ"));
            csiBean.setCSI_CS_LONG_NAME(rs.getString("long_name"));
            csiBean.setCSI_CSI_IDSEQ(rs.getString("csi_idseq"));
            csiBean.setCSI_NAME(rs.getString("CSI_NAME"));
            csiBean.setCSI_CSCSI_IDSEQ(rs.getString("cs_csi_idseq"));
            csiBean.setP_CSCSI_IDSEQ(rs.getString("p_cs_csi_idseq"));
            csiBean.setCSI_LABEL(rs.getString("label"));
            csiBean.setCSI_DISPLAY_ORDER(rs.getString("display_order"));
            csiBean.setCSI_LEVEL(rs.getString("csi_level"));
            acCSIBean.setCSI_BEAN(csiBean);
            //get ac attributes.
            acCSIBean.setAC_IDSEQ(AC_IDseq);
            UtilService util = new UtilService();
            //AC_Name = util.parsedString(AC_Name);
            acCSIBean.setAC_LONG_NAME(AC_Name);
            acCSIBean.setAC_TYPE_NAME("DE_CONCEPT");
            if (vCSNames == null) vCSNames = new Vector();
            if (vCSids == null) vCSids = new Vector();
            if (vCSids == null || vCSids.isEmpty() || (!vCSids.contains(csiBean.getCSI_CS_IDSEQ())))
            {
              vCSNames.addElement(csiBean.getCSI_CS_LONG_NAME());
              vCSids.addElement(csiBean.getCSI_CS_IDSEQ());
            }
            
            if (vAC_CSI == null) vAC_CSI = new Vector();
            vAC_CSI.addElement(acCSIBean);
          }
        }
      }
      m_classReq.setAttribute("selCSNames", vCSNames);
      m_classReq.setAttribute("selCSIDs", vCSids);
      m_classReq.setAttribute("blockAC_CSI", vAC_CSI);
      //store this to keep track of the old ones if removing the existing relationship
      session.setAttribute("vAC_CSI", vAC_CSI);
   }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-doCSCSI_ACSearch: " + e);
      logger.fatal("ERROR in GetACSearch-doCSCSI_ACSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doCSCSI_ACSearch: " + ee);
      logger.fatal("ERROR in GetACSearch-doCSCSI_ACSearch for close : " + ee.toString());
    }
    return vAC_CSI;
  }  //endCS search

  /**
   * To get the sorted vector for the selected field in the DE component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getDEFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareto method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getDESortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {

      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
         vSRows = (Vector)session.getAttribute("vACSearch");
      else
         vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null && !sortField.equalsIgnoreCase("referenceDoc"))
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               DE_Bean DEBean = (DE_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  DEBean.setDE_CHECKED(true);
               else
                  DEBean.setDE_CHECKED(false);
             }
           }

           //loop through the  vector to get the bean row
           OuterLoop:
           for (int i=0; i<(vSRows.size()); i++)
           {
             isSorted = false;
             DE_Bean DESortBean1 = (DE_Bean)vSRows.elementAt(i);
             String Name1 = getDEFieldValue(DESortBean1, sortField);
             int tempInd = i;
             DE_Bean tempBean = DESortBean1;
             String tempName = Name1;
             //loop through again to get the next bean in the vector
             for(int j=i+1; j<(vSRows.size()); j++)
             {
               DE_Bean DESortBean2 = (DE_Bean)vSRows.elementAt(j);
               String Name2 = getDEFieldValue(DESortBean2, sortField);
               if (ComparedValue(sortField, Name1, Name2) > 0)
               {
                 if (tempInd == i)
                 {
                    tempName = Name2;
                    tempBean = DESortBean2;
                    tempInd = j;
                 }
                 //else if (tempName.compareToIgnoreCase(Name2) > 0)
                 else if (ComparedValue(sortField, tempName, Name2) > 0)
                 {
                   tempName = Name2;
                   tempBean = DESortBean2;
                   tempInd = j;
                 }
               }
             }
             vSRows.removeElementAt(tempInd);
             vSRows.insertElementAt(DESortBean1, tempInd);
             vSortedRows.addElement(tempBean);     //add the temp bean to a vector
           }

           if (menuAction.equals("searchForCreate"))
              session.setAttribute("vACSearch", vSortedRows);
           else
           {
              session.setAttribute("vSelRows", vSortedRows);
              session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                DE_Bean DEBean = (DE_Bean)vSortedRows.elementAt(i);
                if (DEBean.getDE_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
           }
         }
       }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-DEsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-DEsortedRows : " + e.toString());
    }
  }

  //can be used to sort properly.
  public void getDESortedRowsBubbleSort(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {

      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
         vSRows = (Vector)session.getAttribute("vACSearch");
      else
         vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               DE_Bean DEBean = (DE_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  DEBean.setDE_CHECKED(true);
               else
                  DEBean.setDE_CHECKED(false);
             }
           }

           //loop through the  vector to get the bean row
           OuterLoop:
           for (int i=0; i<(vSRows.size()); i++)
           {
             //sort from the last item in the loop so that the ascending of nlogn can be done.
             for(int j=vSRows.size()-1; j>=i; j--)
             {
               DE_Bean DESortBean1 = (DE_Bean)vSRows.elementAt(j);
               String Name1 = getDEFieldValue(DESortBean1, sortField);
               if (j-1 >= i)
               {
                 DE_Bean DESortBean2 = (DE_Bean)vSRows.elementAt(j-1);
                 String Name2 = getDEFieldValue(DESortBean2, sortField);
                 if (Name1 != "" && !Name1.equals(Name2) && (ComparedValue(sortField, Name2, Name1) > 0))
                 {
                    DE_Bean tempBean = DESortBean2;  //store second element in temp
                    vSRows.setElementAt(DESortBean1, j-1);  //add first element to second row
                    vSRows.setElementAt(tempBean, j);       //add temp element in first row
                 }
               }
             }
           }

           if (menuAction.equals("searchForCreate"))
              session.setAttribute("vACSearch", vSRows);
           else
           {
              session.setAttribute("vSelRows", vSRows);
              session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSRows.size()); i++)
             {
                DE_Bean DEBean = (DE_Bean)vSRows.elementAt(i);
                if (DEBean.getDE_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
           }
         }
       }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-DEsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-DEsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from DEsortedRows.
   *
   * @param curBean DE bean.
   * @param curField sort Type field name.
   *
   * @return String DEField Value if selected field is found. otherwise empty string.
   */
  private String getDEFieldValue(DE_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("name"))
        returnValue = curBean.getDE_PREFERRED_NAME();
      else if (curField.equals("longName"))
        returnValue = curBean.getDE_LONG_NAME();
      else if (curField.equals("def"))
        returnValue = curBean.getDE_PREFERRED_DEFINITION();
      else if (curField.equals("context"))
        returnValue = curBean.getDE_CONTEXT_NAME();
      else if (curField.equals("UsedContext"))
        returnValue = curBean.getDE_USEDBY_CONTEXT();
      else if (curField.equals("vd"))
        returnValue = curBean.getDE_VD_NAME();
      else if (curField.equals("minID"))
        returnValue = curBean.getDE_MIN_CDE_ID();
      else if (curField.equals("version"))
        returnValue = curBean.getDE_VERSION();
      else if (curField.equals("Comments"))
        returnValue = curBean.getDE_CHANGE_NOTE();
      else if (curField.equals("Origin"))
        returnValue = curBean.getDE_SOURCE();
      else if (curField.equals("DEC"))
        returnValue = curBean.getDE_DEC_NAME();
      else if (curField.equals("Status"))
        returnValue = curBean.getDE_ASL_NAME();
      else if (curField.equals("BeginDate"))
        returnValue = curBean.getDE_BEGIN_DATE();
      else if (curField.equals("EndDate"))
        returnValue = curBean.getDE_END_DATE();
      else if (curField.equals("aliasName"))
        returnValue = curBean.getDE_ALIAS_NAME();
      else if (curField.equals("ProtoID"))
        returnValue = curBean.getDE_PROTOCOL_ID();
      else if (curField.equals("CRFName"))
        returnValue = curBean.getDE_CRF_NAME();
      else if (curField.equals("TypeName"))
        returnValue = curBean.getDE_TYPE_NAME();
      else if (curField.equals("regStatus"))
        returnValue = curBean.getDE_REG_STATUS();
      else if (curField.equals("creDate"))
        returnValue = curBean.getDE_DATE_CREATED();
      else if (curField.equals("creator"))
        returnValue = curBean.getDE_CREATED_BY();
      else if (curField.equals("modDate"))
        returnValue = curBean.getDE_DATE_MODIFIED();
      else if (curField.equals("modifier"))
        returnValue = curBean.getDE_MODIFIED_BY();
      else if (curField.equals("HistID"))
        returnValue = curBean.getDE_HIST_CDE_ID();
      else if (curField.equals("permValue"))
        returnValue = curBean.getDE_Permissible_Value();
      else if (curField.equals("DocText"))
        returnValue = curBean.getDOC_TEXT_LONG_NAME();
      else if (curField.equals("HistoricName"))
        returnValue = curBean.getDOC_TEXT_HISTORIC_NAME();
      else if (curField.equals("CommentDocText"))
        returnValue = curBean.getDOC_TEXT_COMMENT();
      else if (curField.equals("DESourceDocText"))
        returnValue = curBean.getDOC_TEXT_DATA_ELEMENT_SOURCE();
      else if (curField.equals("DescDocText"))
        returnValue = curBean.getDOC_TEXT_DESCRIPTION();
      else if (curField.equals("DetailDescDocText"))
        returnValue = curBean.getDOC_TEXT_DETAIL_DESCRIPTION();
      else if (curField.equals("ExampleDocText"))
        returnValue = curBean.getDOC_TEXT_EXAMPLE();
      else if (curField.equals("ImageFileDocText"))
        returnValue = curBean.getDOC_TEXT_IMAGE_FILE();
      else if (curField.equals("LabelDocText"))
        returnValue = curBean.getDOC_TEXT_LABEL();
      else if (curField.equals("NoteDocText"))
        returnValue = curBean.getDOC_TEXT_NOTE();
      else if (curField.equals("ReferenceDocText"))
        returnValue = curBean.getDOC_TEXT_REFERENCE();
      else if (curField.equals("TechGuideDocText"))
        returnValue = curBean.getDOC_TEXT_TECHNICAL_GUIDE();
      else if (curField.equals("UMLAttrDocText"))
        returnValue = curBean.getDOC_TEXT_UML_Attribute();
      else if (curField.equals("UMLClassDocText"))
        returnValue = curBean.getDOC_TEXT_UML_Class();
      else if (curField.equals("VVSourceDocText"))
        returnValue = curBean.getDOC_TEXT_VALID_VALUE_SOURCE();
      //else if (curField.equals("OtherTypesDocText"))
      //  returnValue = curBean.getDOC_TEXT_OTHER_REF_TYPES();
     // else if (curField.equals("referenceDoc"))
     //   returnValue = curBean.getDOC_TEXT_OTHER_REF_TYPES();

      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getDEField: " + e);
      logger.fatal("ERROR in GetACSearch-getDEField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the DEC component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getDEFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareto method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getDECSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               DEC_Bean DECBean = (DEC_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  DECBean.setDEC_CHECKED(true);
               else
                  DECBean.setDEC_CHECKED(false);
             }
           }

          //loop through the searched DE result to get the matched checked rows
          OuterLoop:
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            DEC_Bean DECSortBean1 = (DEC_Bean)vSRows.elementAt(i);
            String Name1 = getDECFieldValue(DECSortBean1, sortField);        
            int tempInd = i;
            DEC_Bean tempBean = DECSortBean1;
            String tempName = Name1;
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              DEC_Bean DECSortBean2 = (DEC_Bean)vSRows.elementAt(j);
              String Name2 = getDECFieldValue(DECSortBean2, sortField);    
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = DECSortBean2;
                  tempInd = j;
                }
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = DECSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(DECSortBean1, tempInd);
            vSortedRows.addElement(tempBean);
          }

          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                DEC_Bean DECBean = (DEC_Bean)vSortedRows.elementAt(i);
                if (DECBean.getDEC_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-DECsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-DECsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the DECbean for the selected field, called from DECsortedRows.
   *
   * @param curBean DEC bean.
   * @param curField sort Type field name.
   *
   * @return String DECField Value if selected field is found. otherwise empty string.
   */
  private String getDECFieldValue(DEC_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
    if (curField.equals("name"))
      returnValue = curBean.getDEC_PREFERRED_NAME();
    else if (curField.equals("longName"))
      returnValue = curBean.getDEC_LONG_NAME();
    else if (curField.equals("def"))
      returnValue = curBean.getDEC_PREFERRED_DEFINITION();
    else if (curField.equals("context"))
      returnValue = curBean.getDEC_CONTEXT_NAME();
    else if (curField.equals("UsedContext"))
      returnValue = curBean.getDEC_USEDBY_CONTEXT();
    else if (curField.equals("version"))
      returnValue = curBean.getDEC_VERSION();
    else if (curField.equals("Status"))
      returnValue = curBean.getDEC_ASL_NAME();
    else if (curField.equals("BeginDate"))
      returnValue = curBean.getDEC_BEGIN_DATE();
    else if (curField.equals("ConDomain"))
      returnValue = curBean.getDEC_CD_NAME();
    else if (curField.equals("Comments"))
      returnValue = curBean.getDEC_CHANGE_NOTE();
    else if (curField.equals("EndDate"))
      returnValue = curBean.getDEC_END_DATE();
    else if (curField.equals("aliasName"))
      returnValue = curBean.getDEC_ALIAS_NAME();
    else if (curField.equals("ProtoID"))
      returnValue = curBean.getDEC_PROTOCOL_ID();
    else if (curField.equals("CRFName"))
      returnValue = curBean.getDEC_CRF_NAME();
    else if (curField.equals("TypeName"))
      returnValue = curBean.getDEC_TYPE_NAME();
    else if (curField.equals("minID"))
      returnValue = curBean.getDEC_DEC_ID();
    else if (curField.equals("Origin"))
      returnValue = curBean.getDEC_SOURCE();
    else if (curField.equals("creDate"))
      returnValue = curBean.getDEC_DATE_CREATED();
    else if (curField.equals("creator"))
      returnValue = curBean.getDEC_CREATED_BY();
    else if (curField.equals("modDate"))
      returnValue = curBean.getDEC_DATE_MODIFIED();
    else if (curField.equals("modifier"))
      returnValue = curBean.getDEC_MODIFIED_BY();

    if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getDECField: " + e);
      logger.fatal("ERROR in GetACSearch-getDECField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the VD component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getDEFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getVDSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               VD_Bean VDBean = (VD_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  VDBean.setVD_CHECKED(true);
               else
                  VDBean.setVD_CHECKED(false);
             }
           }

          //loop through the searched DE result to get the matched checked rows
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            VD_Bean VDSortBean1 = (VD_Bean)vSRows.elementAt(i);
            String Name1 = getVDFieldValue(VDSortBean1, sortField);        
            int tempInd = i;
            VD_Bean tempBean = VDSortBean1;
            String tempName = Name1;
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              VD_Bean VDSortBean2 = (VD_Bean)vSRows.elementAt(j);
              String Name2 = getVDFieldValue(VDSortBean2, sortField);       
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = VDSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = VDSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(VDSortBean1, tempInd);
            vSortedRows.addElement(tempBean);
          }

          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                VD_Bean VDBean = (VD_Bean)vSortedRows.elementAt(i);
                if (VDBean.getVD_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-VDSortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-VDSortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from VDsortedRows.
   *
   * @param curBean VD bean.
   * @param curField sort Type field name.
   *
   * @return String VDField Value if selected field is found. otherwise empty string.
   */
  private String getVDFieldValue(VD_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
    if (curField.equals("name"))
      returnValue = curBean.getVD_PREFERRED_NAME();
    else if (curField.equals("longName"))
      returnValue = curBean.getVD_LONG_NAME();
    else if (curField.equals("def"))
      returnValue = curBean.getVD_PREFERRED_DEFINITION();
    else if (curField.equals("context"))
      returnValue = curBean.getVD_CONTEXT_NAME();
    else if (curField.equals("UsedContext"))
      returnValue = curBean.getVD_USEDBY_CONTEXT();
    else if (curField.equals("version"))
      returnValue = curBean.getVD_VERSION();
    else if (curField.equals("Status"))
      returnValue = curBean.getVD_ASL_NAME();
    else if (curField.equals("BeginDate"))
      returnValue = curBean.getVD_BEGIN_DATE();
    else if (curField.equals("ConDomain"))
      returnValue = curBean.getVD_CD_NAME();
    else if (curField.equals("EndDate"))
      returnValue = curBean.getVD_END_DATE();
    else if (curField.equals("HighNum"))
      returnValue = curBean.getVD_HIGH_VALUE_NUM();
    else if (curField.equals("LowNum"))
      returnValue = curBean.getVD_LOW_VALUE_NUM();
    else if (curField.equals("Decimal"))
      returnValue = curBean.getVD_DECIMAL_PLACE();
    else if (curField.equals("MaxLength"))
      returnValue = curBean.getVD_MAX_LENGTH_NUM();
    else if (curField.equals("MinLength"))
      returnValue = curBean.getVD_MIN_LENGTH_NUM();
    else if (curField.equals("DataType"))
      returnValue = curBean.getVD_DATA_TYPE();
    else if (curField.equals("UOML"))
      returnValue = curBean.getVD_UOML_NAME();
    else if (curField.equals("Format"))
      returnValue = curBean.getVD_FORML_NAME();
    else if (curField.equals("Comments"))
      returnValue = curBean.getVD_CHANGE_NOTE();
    else if (curField.equals("TypeFlag"))
      returnValue = curBean.getVD_TYPE_FLAG();
    else if (curField.equals("aliasName"))
      returnValue = curBean.getVD_ALIAS_NAME();
    else if (curField.equals("ProtoID"))
      returnValue = curBean.getVD_PROTOCOL_ID();
    else if (curField.equals("CRFName"))
      returnValue = curBean.getVD_CRF_NAME();
    else if (curField.equals("TypeName"))
      returnValue = curBean.getVD_TYPE_NAME();
    else if (curField.equals("minID"))
      returnValue = curBean.getVD_VD_ID();
    else if (curField.equals("Origin"))
      returnValue = curBean.getVD_SOURCE();
    else if (curField.equals("creDate"))
      returnValue = curBean.getVD_DATE_CREATED();
    else if (curField.equals("creator"))
      returnValue = curBean.getVD_CREATED_BY();
    else if (curField.equals("modDate"))
      returnValue = curBean.getVD_DATE_MODIFIED();
    else if (curField.equals("modifier"))
      returnValue = curBean.getVD_MODIFIED_BY();
    else if (curField.equals("permValue"))
      returnValue = curBean.getVD_Permissible_Value();

    if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getVDField: " + e);
      logger.fatal("ERROR in GetACSearch-getVDField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the CD component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getCDFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareto method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getCDSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               CD_Bean CDBean = (CD_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  CDBean.setCD_CHECKED(true);
               else
                  CDBean.setCD_CHECKED(false);
             }
           }

          //loop through the searched DE result to get the matched checked rows
          OuterLoop:
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            CD_Bean CDSortBean1 = (CD_Bean)vSRows.elementAt(i);
            String Name1 = getCDFieldValue(CDSortBean1, sortField); 
            int tempInd = i;
            CD_Bean tempBean = CDSortBean1;
            String tempName = Name1;
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              CD_Bean CDSortBean2 = (CD_Bean)vSRows.elementAt(j);
              String Name2 = getCDFieldValue(CDSortBean2, sortField);        
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = CDSortBean2;
                  tempInd = j;
                }
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = CDSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(CDSortBean1, tempInd);
            vSortedRows.addElement(tempBean);
          }

          for(int i=0; i<(vSortedRows.size()); i++)
          {
            CD_Bean CDSortBean1 = (CD_Bean)vSortedRows.elementAt(i);
          }
          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                CD_Bean CDBean = (CD_Bean)vSortedRows.elementAt(i);
                if (CDBean.getCD_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-CDsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-CDsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the CSIbean for the selected field, called from CSIsortedRows.
   *
   * @param curBean CSI bean.
   * @param curField sort Type field name.
   *
   * @return String CDField Value if selected field is found. otherwise empty string.
   */
  private String getCDFieldValue(CD_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
    if (curField.equals("name"))
      returnValue = curBean.getCD_PREFERRED_NAME();
    else if (curField.equals("longName"))
      returnValue = curBean.getCD_LONG_NAME();
    else if (curField.equals("def"))
      returnValue = curBean.getCD_PREFERRED_DEFINITION();
    else if (curField.equals("context"))
      returnValue = curBean.getCD_CONTEXT_NAME();
    else if (curField.equals("version"))
      returnValue = curBean.getCD_VERSION();
    else if (curField.equals("Status"))
      returnValue = curBean.getCD_ASL_NAME();
    else if (curField.equals("BeginDate"))
      returnValue = curBean.getCD_BEGIN_DATE();
    else if (curField.equals("Dimension"))
      returnValue = curBean.getCD_DIMENSIONALITY();
    else if (curField.equals("Comments"))
      returnValue = curBean.getCD_CHANGE_NOTE();
    else if (curField.equals("EndDate"))
      returnValue = curBean.getCD_END_DATE();
    else if (curField.equals("minID"))
      returnValue = curBean.getCD_CD_ID();
    else if (curField.equals("Origin"))
      returnValue = curBean.getCD_SOURCE();
    else if (curField.equals("creDate"))
      returnValue = curBean.getCD_DATE_CREATED();
    else if (curField.equals("creator"))
      returnValue = curBean.getCD_CREATED_BY();
    else if (curField.equals("modDate"))
      returnValue = curBean.getCD_DATE_MODIFIED();
    else if (curField.equals("modifier"))
      returnValue = curBean.getCD_MODIFIED_BY();

    if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getCDField: " + e);
      logger.fatal("ERROR in GetACSearch-getCDField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get final result vector of selected attributes/rows to display for Data Element Concept component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the CSIBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getCSIResult(HttpServletRequest req, HttpServletResponse res,
         Vector vResult, String refresh)
  {

    Vector vCSI = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

      //all search results
      vCSI = (Vector)session.getAttribute("vACSearch");
      Vector vRSel = (Vector)session.getAttribute("vSelRows");    //from selected rows
      if (menuAction.equals("searchForCreate"))  vRSel = null;
      if (vRSel == null)
        vRSel = vCSI;

            //convert int to string to get the rec count
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Class Scheme Items - " + sKeyword);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vUsedContext = new Vector();

      for(int i=0; i<(vRSel.size()); i++)
      {
        CSI_Bean CSIBean = new CSI_Bean();
        CSIBean = (CSI_Bean)vRSel.elementAt(i);
        vSearchID.addElement(CSIBean.getCSI_CSCSI_IDSEQ());
        vSearchName.addElement(CSIBean.getCSI_NAME());
        vSearchLongName.addElement(CSIBean.getCSI_CS_LONG_NAME());
        vSearchDefinition.addElement(CSIBean.getCSI_DEFINITION());
        vUsedContext.addElement(CSIBean.getCSI_CONTEXT_NAME());
        if (vSelAttr.contains("CSI Name")) vResult.addElement(CSIBean.getCSI_NAME());
        if (vSelAttr.contains("CSI Type")) vResult.addElement(CSIBean.getCSI_CSITL_NAME());
        if (vSelAttr.contains("CSI Definition")) vResult.addElement(CSIBean.getCSI_DEFINITION());
        if (vSelAttr.contains("CS Long Name")) vResult.addElement(CSIBean.getCSI_CS_LONG_NAME());
        if (vSelAttr.contains("Context")) vResult.addElement(CSIBean.getCSI_CONTEXT_NAME());
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchDefinitionAC", vSearchDefinition);
      session.setAttribute("SearchUsedContext", vUsedContext);
      // for Back button, put search results and attributes on a stack
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        stackSearchComponents("ClassSchemeItems", vCSI, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getCSIResult: " + e);
      logger.fatal("ERROR in GetACSearch-getCSIResult : " + e.toString());
    }
  }

  /**
   * To get the value from the CSIbean for the selected field, called from CSIsortedRows.
   *
   * @param curBean CSI bean.
   * @param curField sort Type field name.
   *
   * @return String CSIField Value if selected field is found. otherwise empty string.
   */
  private String getCSIFieldValue(CSI_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
    if (curField.equals("CSIName"))
      returnValue = curBean.getCSI_NAME();
    else if (curField.equals("CSName"))
      returnValue = curBean.getCSI_CS_LONG_NAME();  //getCSI_CS_NAME();
    else if (curField.equals("def"))
      returnValue = curBean.getCSI_DEFINITION();
    else if (curField.equals("context"))
      returnValue = curBean.getCSI_CONTEXT_NAME();
    else if (curField.equals("CSITL"))
      returnValue = curBean.getCSI_CSITL_NAME();

    if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getCSIField: " + e);
      logger.fatal("ERROR in GetACSearch-getCSIField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the CSI component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getCSIFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareto method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getCSISortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               CSI_Bean CSIBean = (CSI_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  CSIBean.setCSI_CHECKED(true);
               else
                  CSIBean.setCSI_CHECKED(false);
             }
           }

          //loop through the searched DE result to get the matched checked rows
          OuterLoop:
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            CSI_Bean CSISortBean1 = (CSI_Bean)vSRows.elementAt(i);
            String Name1 = getCSIFieldValue(CSISortBean1, sortField);      
            int tempInd = i;
            CSI_Bean tempBean = CSISortBean1;
            String tempName = Name1;
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              CSI_Bean CSISortBean2 = (CSI_Bean)vSRows.elementAt(j);
              String Name2 = getCSIFieldValue(CSISortBean2, sortField);     
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = CSISortBean2;
                  tempInd = j;
                }
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = CSISortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(CSISortBean1, tempInd);
            vSortedRows.addElement(tempBean);
          }

          for(int i=0; i<(vSortedRows.size()); i++)
          {
            CSI_Bean CSISortBean1 = (CSI_Bean)vSortedRows.elementAt(i);
          }
          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                CSI_Bean CSIBean = (CSI_Bean)vSortedRows.elementAt(i);
                if (CSIBean.getCSI_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-CSIsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-CSIsortedRows : " + e.toString());
    }
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
  private void doPVVMSearch(String InString, String cd_idseq, Vector vList)  // returns list of Data Elements
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_PVVM(?,?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1,InString);
        CStmt.setString(2,cd_idseq);
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
              s = m_util.getCurationDate(s);      //convert to dd/mm/yyyy format
            PVBean.setPV_BEGIN_DATE(s);
            s = rs.getString("end_date");
            if (s != null)
              s = m_util.getCurationDate(s);
            PVBean.setPV_END_DATE(s);
            PVBean.setPV_MEANING_DESCRIPTION(rs.getString("vm_description"));  //from meanings table
            //add the CD name and version in decimal number together
            String CDNameVersion = "";
            if (rs.getString("version") != null && !rs.getString("version").equals(""))
            {
               if (rs.getString("version").indexOf('.') >= 0)
                  CDNameVersion = rs.getString(7) + " - Version " +  rs.getString("version");
               else
                  CDNameVersion = rs.getString(7) + " - Version " + rs.getString("version") + ".0";
            }
            PVBean.setPV_CONCEPTUAL_DOMAIN(CDNameVersion);
            
            //get vm concept attributes
            String sCondr = rs.getString("condr_idseq");
            EVS_Bean vmConcept = new EVS_Bean();
            vmConcept.setCONDR_IDSEQ(sCondr);            
            if (sCondr != null && !sCondr.equals(""))
            {
              GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
              Vector vConList = getAC.getAC_Concepts(sCondr, null, true);
              if (vConList != null && vConList.size() > 0) 
                vmConcept = (EVS_Bean)vConList.elementAt(0);
            }
            PVBean.setVM_CONCEPT(vmConcept);
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
      logger.fatal("ERROR - GetACSearch-searchPVVM for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
  //    //System.err.println("Problem closing in GetACSearch-searchPVVM: " + ee);
      logger.fatal("ERROR - GetACSearch-searchPVVM for close : " + ee.toString());
    }
  }  //endPVVM search

 
 
  /**
   * To get final result vector of selected attributes/rows to display for Permissible Values component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the PVBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getPVVMResult(HttpServletRequest req, HttpServletResponse res,
              Vector vResult, String refresh)
  {
    Vector vPVVM = new Vector();
    try
    {
      HttpSession session = req.getSession();
      Vector vSearchASL = new Vector();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");
      vPVVM = (Vector)session.getAttribute("vACSearch");
      Vector vRSel = (Vector)session.getAttribute("vSelRows");
      if (menuAction.equals("searchForCreate"))  vRSel = null;
      if (vRSel == null)
        vRSel = vPVVM;
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Permissible Value - " + sKeyword);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchMeanDescription = new Vector();
      String evsDB = "";
      String umlsCUI = "";
      String tempCUI = "";
      String ccode = "";

      for(int i=0; i<(vRSel.size()); i++)
      {
        PV_Bean PVBean = new PV_Bean();
        PVBean = (PV_Bean)vRSel.elementAt(i);
        vSearchID.addElement(PVBean.getPV_PV_IDSEQ());
        vSearchName.addElement(PVBean.getPV_VALUE());
        vSearchLongName.addElement(PVBean.getPV_SHORT_MEANING());
        vSearchMeanDescription.addElement(PVBean.getPV_MEANING_DESCRIPTION());
        evsDB = PVBean.getPV_EVS_DATABASE();
        umlsCUI = PVBean.getPV_UMLS_CUI_VAL();
        tempCUI = PVBean.getPV_TEMP_CUI_VAL();
        ccode = PVBean.getPV_NCI_CC_VAL();

        if (vSelAttr.contains("Value")) vResult.addElement(PVBean.getPV_VALUE());
        if (vSelAttr.contains("Value Meaning")) vResult.addElement(PVBean.getPV_SHORT_MEANING());
        if (vSelAttr.contains("PV Meaning Description")) vResult.addElement(PVBean.getPV_MEANING_DESCRIPTION());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(PVBean.getPV_CONCEPTUAL_DOMAIN());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(PVBean.getPV_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(PVBean.getPV_END_DATE());
        EVS_Bean vmCon = PVBean.getVM_CONCEPT();
        if (vmCon == null) vmCon = new EVS_Bean();
        if (vSelAttr.contains("EVS Identifier")) vResult.addElement(vmCon.getNCI_CC_VAL());
        if (vSelAttr.contains("Description Source")) vResult.addElement(vmCon.getEVS_DEF_SOURCE());
        if (vSelAttr.contains("Vocabulary")) vResult.addElement(PVBean.getPV_EVS_DATABASE());
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchMeanDescription", vSearchMeanDescription);

       // for Back button, put search results and attributes on a stack
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        this.stackSearchComponents("PermissibleValue", vPVVM, vRSel, vSearchID, vSearchName, vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getPVVMResult: " + e);
      logger.fatal("ERROR in GetACSearch-getPVVMResult : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from PVsortedRows.
   *
   * @param curBean PV bean.
   * @param curField sort Type field name.
   *
   * @return String PVField Value if selected field is found. otherwise empty string.
   */
  private String getPVVMFieldValue(PV_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      EVS_Bean vmCon = curBean.getVM_CONCEPT();
      if (vmCon == null) vmCon = new EVS_Bean();
      if (curField.equals("value"))
        returnValue = curBean.getPV_VALUE();
      else if (curField.equals("meaning"))
        returnValue = curBean.getPV_SHORT_MEANING();
      else if (curField.equals("MeanDesc"))
        returnValue = curBean.getPV_MEANING_DESCRIPTION();
      else if (curField.equals("database"))
        returnValue = curBean.getPV_EVS_DATABASE();
      else if (curField.equals("descSource"))
        returnValue = vmCon.getEVS_DEF_SOURCE(); // curBean.getPV_EVS_SOURCE();
      else if (curField.equals("umls") || curField.equals("Ident"))
        returnValue = vmCon.getNCI_CC_VAL();    //curBean.getPV_NCI_CC_VAL();
      else if (curField.equals("ConDomain"))
        returnValue = curBean.getPV_CONCEPTUAL_DOMAIN();
      else if (curField.equals("BeginDate"))
        returnValue = curBean.getPV_BEGIN_DATE();
      else if (curField.equals("EndDate"))
        returnValue = curBean.getPV_END_DATE();
      else if (curField.equals("ValidValue"))
        returnValue = curBean.getQUESTION_VALUE();
      else if (curField.equals("VMConcept"))
      {
        EVS_Bean eBean = curBean.getVM_CONCEPT();
        if (eBean != null)
          returnValue = eBean.getNCI_CC_VAL();
      }
      else if (curField.equals("ParConcept"))
      {
        EVS_Bean eBean = curBean.getPARENT_CONCEPT();
        if (eBean != null)
          returnValue = eBean.getNCI_CC_VAL();
      }
      else if (curField.equals("Origin"))
        returnValue = curBean.getPV_VALUE_ORIGIN();
        
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getPVField: " + e);
      logger.fatal("ERROR in GetACSearch-getPVField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the PV component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getPVVMFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getPVVMSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               PV_Bean PVBean = (PV_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  PVBean.setPV_CHECKED(true);
               else
                  PVBean.setPV_CHECKED(false);
             }
           }

          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            PV_Bean PVSortBean1 = (PV_Bean)vSRows.elementAt(i);
            String Name1 = getPVVMFieldValue(PVSortBean1, sortField);            //PVSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            PV_Bean tempBean = PVSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              PV_Bean PVSortBean2 = (PV_Bean)vSRows.elementAt(j);
              String Name2 = getPVVMFieldValue(PVSortBean2, sortField);         //PVSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = PVSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = PVSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(PVSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }

          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                PV_Bean PVBean = (PV_Bean)vSortedRows.elementAt(i);
                if (PVBean.getPV_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null && vCheckList.size() > 0)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-PVVMsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-PVVMsortedRows : " + e.toString());
    }
  }

  /**
   * sorts the permissible values from the vd page
   * @param sortField String the column to sort
   */
  public void getVDPVSortedRows(String sortField)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      Vector vSRows = (Vector)session.getAttribute("VDPVList");
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      if (sortField != null && !sortField.equals(""))
      {
        //check if the vector has the data
        if (vSRows != null && vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            PV_Bean PVSortBean1 = (PV_Bean)vSRows.elementAt(i);
            String Name1 = getPVVMFieldValue(PVSortBean1, sortField);            //PVSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            PV_Bean tempBean = PVSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              PV_Bean PVSortBean2 = (PV_Bean)vSRows.elementAt(j);
              String Name2 = getPVVMFieldValue(PVSortBean2, sortField);         //PVSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = PVSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = PVSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(PVSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          session.setAttribute("VDPVList", vSortedRows);
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-VDPVsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-VDPVsortedRows : " + e.toString());
    }
  }

    /**
   * To get the refreshed vector after designating the component to display in SearchPage.
   * called from the servlet
   * gets the bean from the 'vSelRows' vector that has same as desID.
   * updates the used by context attribute of the selected element with the existing one.
   * calls 'getDEResult' to display the result.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param selComp name of the selected component
   * @param desID idseq of the component designated
   * @param desName alias name of the designated component
   * @param desContext  designated context name.
   * @param desContextID  designated context IDseq.
   * @param action  to recorgnize created or deleted action.
   *
   */
  public void refreshDesData(String desCompID, String desID, String desName, String desContext, String desContextID, String action)
  {
     HttpSession session = m_classReq.getSession();
     Vector vSRows = new Vector();
     String sMenuAction = (String)session.getAttribute("MenuAction");   //get the selected menu action
     if (sMenuAction.equals("searchForCreate"))
         vSRows = (Vector)session.getAttribute("vACSearch");   //get the selected rows
     else
         vSRows = (Vector)session.getAttribute("vSelRows");   //get the selected rows
     String selComp = (String)session.getAttribute("searchAC");
     Vector vResult = new Vector();
     if (vSRows.size() > 0)
     {
       for(int i=0; i<(vSRows.size()); i++)
       {
           DE_Bean DEBean = new DE_Bean();
           DEBean = (DE_Bean) vSRows.elementAt(i);
           //if the deID is same as desID make a copy of this, replace name & context, put back in the vector
           if (DEBean.getDE_DE_IDSEQ().equals(desCompID))
           {
              Vector vUsedBy = DEBean.getDE_USEDBY_CONTEXT_ID();
              //insert the bean if created
              if (action.equals("INS"))
              {
                 String sUsed = DEBean.getDE_USEDBY_CONTEXT();
                 if ((sUsed == null) || (sUsed.equals("")))
                    DEBean.setDE_USEDBY_CONTEXT(desContext);
                 else
                    DEBean.setDE_USEDBY_CONTEXT(sUsed + ", " + desContext);
                 //add the context id in usedby vector attribute
                 if (vUsedBy == null) vUsedBy = new Vector();
                 vUsedBy.addElement(desContextID);
              }
              //remove the used by context name if deleted
              else if (action.equals("DEL"))
              {
                  String sUsed = DEBean.getDE_USEDBY_CONTEXT();
                  DEBean.setDE_USEDBY_CONTEXT(ParseString(sUsed, desContext));
                  //remove context id from used by vector attribute
                  if (vUsedBy != null && vUsedBy.contains(desContextID))
                    vUsedBy.removeElement(desContextID);
              }
              //getDESortedRows(req, res);    remove the sorting here so that it won't affect the list
  //  System.out.println("used context " + DEBean.getDE_USEDBY_CONTEXT());
              DEBean.setDE_USEDBY_CONTEXT_ID(vUsedBy);
              vSRows.setElementAt(DEBean, i);
              break;
           }
       }
       //store the bean vector in the session
       if (sMenuAction.equals("searchForCreate"))
           session.setAttribute("vACSearch", vSRows);
       else
           session.setAttribute("vSelRows", vSRows);
     }
  }
  
  /**
   * makes the comma delimited context name for used by contexts
   * @param sUsed
   * @param desContext
   * @return 
   */
   private String ParseString (String sUsed, String desContext)
   {
      String subUsed = "";
      if ((sUsed != null) && (!sUsed.equals("")))
      {
         StringTokenizer desTokens = new StringTokenizer(sUsed, ",");
         while (desTokens.hasMoreTokens())
         {
            String thisToken = desTokens.nextToken().trim();
            if (!thisToken.equalsIgnoreCase(desContext))
            {
               if (subUsed.equals(""))
                  subUsed = thisToken;
               else
                  subUsed = subUsed + ", " + thisToken;
            }
         }
      }
      return subUsed;
   }
 
 /**
   * 
   * @param sSynonym
   * @return 
   */
 private String parseSynonymForHD(String sSynonym)
{
      String isHeader = "false";
      int index = 0;
      if ((sSynonym != null) && (!sSynonym.equals("")))
      {
         if(sSynonym.indexOf(">HD<") != -1)
           isHeader = "true";
      }
      return isHeader;
   }
   
   
    /**
   * To get the refreshed vector after creating or editing the component to display in SearchPage.
   * gets the 'ckName' a row that was selected before the create action
   * and 'vSelRows' vector from session vecotr of selected rows after the search.
   * First insert or replace the checked row data
   * calls 'getDESortedRows' to sort the data, calls 'getDEResult' to add in to the vector for display.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param m_DE DE_Bean  if the selected component is DataElement
   * @param m_DEC DEC_Bean if the selected component is DataElementConcept
   * @param m_VD VD_Bean  if the selected component is ValueDomain
   * @param sAction  earlier action template, version or Edit.
   *
   */
  public void refreshData(HttpServletRequest req, HttpServletResponse res,
         DE_Bean m_DE, DEC_Bean m_DEC, VD_Bean m_VD, Quest_Bean m_Quest,
         String sAction, String oldIDseq) throws Exception
  {
     HttpSession session = req.getSession();
     String sCKname = (String)session.getAttribute("ckName");
     Vector vSRows = (Vector)session.getAttribute("vSelRows");   //get the selected rows
     Vector vResult = new Vector();
     String thisIDseq = "";
     if (vSRows.size()>0)                          //check if the vector has the data
     {
        if (m_DE != null)
        {
           //copy the non modifed attributes to redisplay 
           DE_Bean oldDEBean = (DE_Bean)session.getAttribute("oldDEBean");
           m_DE = m_DE.cloneDE_Bean(oldDEBean, "Partial");
           //remove used by for version
           if (sAction.equals("Version") || sAction.equals("Template"))
           {
             m_DE.setDE_USEDBY_CONTEXT("");
             m_DE.setDE_USEDBY_CONTEXT_ID(new Vector());
           }
           //refresh the pv counts of this DE
           m_DE = this.refreshSearchPVCount(m_DE);
           //insert a row and sort it
           if ((sAction.equals("Template")) && (m_DE != null))
           {
              vSRows.insertElementAt(m_DE, 0);
              session.setAttribute("vSelRows", vSRows);
              //reset the checking to thisRow
              Vector vCheckList = new Vector();
              vCheckList.addElement("CK0");
              session.setAttribute("CheckList", vCheckList);
            //  getDESortedRows(req, res);
           }
           else if (!sAction.equals("Refresh"))
           {
              //loop through the selected rows vector to get the matched idseq
              for (int i=0; i<(vSRows.size()); i++)
              {
                 DE_Bean thisDE = (DE_Bean)vSRows.elementAt(i);
                 thisIDseq = thisDE.getDE_DE_IDSEQ();
                 //match idseqs of the changed one to the old one.
                 if (thisIDseq.equals(oldIDseq))
                 {
                    //update row for edit and insert row for version
                    if (sAction.equals("Edit"))
                       vSRows.setElementAt(m_DE, i);
                    else if (sAction.equals("Version"))
                       vSRows.insertElementAt(m_DE, i);
                    break;
                 }
              }
           }
           //store it in selrows and get the final result vector
           session.setAttribute("vSelRows", vSRows);
           getDEResult(req, res, vResult, "");
        }
        else if (m_DEC != null)
        {
             //insert a row and sort it
           if (sAction.equals("Template"))
           {
              vSRows.insertElementAt(m_DEC, 0);
              session.setAttribute("vSelRows", vSRows);
              //reset the checking to thisRow
              Vector vCheckList = new Vector();
              vCheckList.addElement("CK0");
              session.setAttribute("CheckList", vCheckList);
              //sort the rows
              //getDECSortedRows(req, res);
           }
           else if (!sAction.equals("Refresh"))
           {
              //loop through the selected rows vector to get the matched idseq
              for (int i=0; i<(vSRows.size()); i++)
              {
                 DEC_Bean thisDEC = (DEC_Bean)vSRows.elementAt(i);
                /* String sOCCondrID = m_DEC.getDEC_OC_CONDR_IDSEQ();
                 if(sOCCondrID != null && !sOCCondrID.equals(""))
                  thisDEC.setDEC_OC_CONDR_IDSEQ(sOCCondrID);
                 String sPCCondrID = m_DEC.getDEC_PROP_CONDR_IDSEQ();
                 if(sPCCondrID != null && !sPCCondrID.equals(""))
                  thisDEC.setDEC_PROP_CONDR_IDSEQ(sPCCondrID); */
                 thisIDseq = thisDEC.getDEC_DEC_IDSEQ();
                 //match idseqs of the changed one to the old one.
                 if (thisIDseq.equals(oldIDseq))
                 {
                    //update row for edit and insert row for version
                    if (sAction.equals("Edit"))
                       vSRows.setElementAt(m_DEC, i);
                    else if (sAction.equals("Version"))
                       vSRows.insertElementAt(m_DEC, i);
                    break;
                 }
              }
           }
           //store it in selrows and get the final result vector
           session.setAttribute("vSelRows", vSRows);
           getDECResult(req, res, vResult, "");
        }
        else if (m_VD != null)
        {
             //insert a row and sort it
           if (sAction.equals("Template"))
           {
              vSRows.insertElementAt(m_VD, 0);
              session.setAttribute("vSelRows", vSRows);
              //reset the checking to thisRow
              Vector vCheckList = new Vector();
              vCheckList.addElement("CK0");
              session.setAttribute("CheckList", vCheckList);
         //     getVDSortedRows(req, res);
           }
           else if (!sAction.equals("Refresh"))
           {
              //loop through the selected rows vector to get the matched idseq
              for (int i=0; i<(vSRows.size()); i++)
              {
                 VD_Bean thisVD = (VD_Bean)vSRows.elementAt(i);
                // String sRepCondrID = m_VD.getVD_REP_CONDR_IDSEQ();
                // if(sRepCondrID != null && !sRepCondrID.equals(""))
                 // thisVD.setVD_REP_CONDR_IDSEQ(sRepCondrID); 
                 thisIDseq = thisVD.getVD_VD_IDSEQ();
                 //match idseqs of the changed one to the old one.
                 if (thisIDseq.equals(oldIDseq))
                 {
                    //update row for edit and insert row for version
                    if (sAction.equals("Edit"))
                       vSRows.setElementAt(m_VD, i);
                    else if (sAction.equals("Version"))
                       vSRows.insertElementAt(m_VD, i);
                    break;
                 }
              }
           }
           //store it in selrows and get the final result vector
           session.setAttribute("vSelRows", vSRows);
           getVDResult(req, res, vResult, "");
        }
        else if (m_Quest != null)
        {
           //loop through the selected rows vector to get checked row
           for (int i=0; i<(vSRows.size()); i++)
           {
               String ckName = ("CK" + i);
               if (ckName.equals(sCKname))
               {
                    //update row for edit
                  if (sAction.equals("Edit"))
                     vSRows.setElementAt(m_Quest, i);
               }
            }
           //store it in selrows and get the final result vector
           session.setAttribute("vSelRows", vSRows);
           getQuestionResult(req, res, vResult);
        }
        //finally store the display data in the result session
        session.setAttribute("results", vResult);
     }
  }

  /**
   * @param sSearchFor
   */
   public Vector refreshSearchPage(String sSearchFor) throws Exception
   {
     EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
     Vector vRes = new Vector();
     String actType = (String)m_classReq.getParameter("actSelect");
     if (sSearchFor != null)
     {
       if (sSearchFor.equals("DataElement"))
          this.getDEResult(m_classReq, m_classRes, vRes, "true");
       else if (sSearchFor.equals("DataElementConcept"))
          this.getDECResult(m_classReq, m_classRes, vRes, "true");
       else if (sSearchFor.equals("ValueDomain"))
          this.getVDResult(m_classReq, m_classRes, vRes, "true");
       else if (sSearchFor.equals("ConceptualDomain"))
          this.getCDResult(m_classReq, m_classRes, vRes, "true");
       else if ((sSearchFor.equals("EVSValueMeaning") || sSearchFor.equals("CreateVM_EVSValueMeaning")
       || sSearchFor.equals("ParentConcept") || sSearchFor.equals("ParentConceptVM")
       || sSearchFor.equals("ObjectClass") || sSearchFor.equals("Property")
       || sSearchFor.equals("RepTerm") || sSearchFor.equals("ParentConceptVM")
       || sSearchFor.equals("ObjectQualifier") || sSearchFor.equals("PropertyQualifier")
       || sSearchFor.equals("RepQualifier")) && !actType.equals("doVocabChange"))
          evs.get_Result(m_classReq, m_classRes, vRes, "");
     }
     return vRes;
   }
   
 
   /**
    * 
    */
   public DE_Bean refreshSearchPVCount(DE_Bean DEBean) throws Exception
   {
        //update the count of the current bean.
      HttpSession session = m_classReq.getSession();     //get the session
      boolean isNewVD = false;
      //do the pvac search to get the names and count of the pvs for this vd 
      Integer pvCount = this.doPVACSearch(DEBean.getDE_VD_IDSEQ(), DEBean.getDE_VD_NAME(), "Detail");
      String pvValue = (String)m_classReq.getAttribute("pvValue");

      //compare the vd id from old to new if they are the same.
      DE_Bean oldDEBean = (DE_Bean)session.getAttribute("oldDEBean");
      String oldVD = oldDEBean.getDE_VD_IDSEQ();
      String newVD = DEBean.getDE_VD_IDSEQ();
      
      if (oldVD != null && newVD != null && !oldVD.equals("") && !newVD.equals("") && !oldVD.equals(newVD))
        isNewVD = true;
      //add the pv counts of the DE bean
      DEBean.setDE_Permissible_Value(pvValue);
      DEBean.setDE_Permissible_Value_Count(pvCount);
      if (isNewVD == false)
      {
          //update the count of the all beans of the same vd only if it was changed
          Vector vSRows = (Vector)session.getAttribute("vSelRows");   //get the selected rows
          if (vSRows != null)
          {
            String thisVDID = DEBean.getDE_VD_IDSEQ();
            for (int k=0; k<vSRows.size(); k++)
            {
              DE_Bean thisDE = (DE_Bean)vSRows.elementAt(k);
              //if the same vd id, update pv count
              if (thisDE.getDE_VD_IDSEQ().equalsIgnoreCase(thisVDID))
              {
                //change it only if necessary.
                thisDE.setDE_Permissible_Value_Count(pvCount);
                thisDE.setDE_Permissible_Value(pvValue);
                //reset the element
                vSRows.setElementAt(thisDE, k);
              }
            }
            session.setAttribute("vSelRows", vSRows);
          }          
      }  
      return DEBean;
   }
  /**
   * To start a new search called from NCICurationServlet.
   * selected component, keyword, selected context, seletcted status parameters of request are stored in session.
   * calls method 'doDESearch' for selected component to get the result set from the database.
   * search result from the database is stored in session vector "vACSearch".
   * calls method 'setAttributeValues' to get list of selected attributes at search.
   * calls method 'getDEResult' for selected component to get vector of selected attribute and checked rows from the ACSearch vector.
   * final result vector is stored in the session vector "results".
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */

public void getACSearchForCreate(HttpServletRequest req, HttpServletResponse res,
boolean isIntSearch)
{
  try
  {
    HttpSession session = req.getSession();     //get the session
    Vector vAC = new Vector();
    session.setAttribute("sortType", "longName");
    SetACService setAC = new SetACService(m_servlet);
    EVSSearch evs = new EVSSearch(req, res, m_servlet); 
    String sSearchAC = (String)req.getParameter("listSearchFor");
     if (sSearchAC == null)
     {
        sSearchAC = (String)session.getAttribute("searchAC");
        if (sSearchAC == null)
          logger.fatal("In GetACSearch-getKeywordResult : no Component is selected");
     }
     session.setAttribute("creSearchAC", sSearchAC);

      //get the search in data
     String sSearchIn = (String)req.getParameter("listSearchIn");
     if (sSearchIn == null) sSearchIn = "longName";
     req.setAttribute("creSearchIn", sSearchIn);  //keep the search in criteria
     session.setAttribute("creSearchInBlocks", sSearchIn);  //keep the search in criteria

     boolean isBlockSearch = false;
     String dtsVocab = req.getParameter("listContextFilterVocab");
     if (dtsVocab != null && !dtsVocab.equals("")) isBlockSearch = true;
     if(dtsVocab == null) dtsVocab = "NCI_Thesaurus";
     session.setAttribute("dtsVocab", dtsVocab); 

     String sSearchInEVS = (String)req.getParameter("listSearchInEVS");
     if (sSearchInEVS == null) sSearchInEVS = "Synonym";
     session.setAttribute("SearchInEVS", sSearchInEVS);
   
     //filter by Retired Concepts
	   String sRetired = (String)req.getParameter("rRetired");
     session.setAttribute("creRetired", sRetired);   //store contextUse in the session
	   if (sRetired == null) sRetired = "";
     
     String sMetaSource = (String)req.getParameter("listContextFilterSource");
     if (sMetaSource == null) sMetaSource = "All Sources";
     session.setAttribute("MetaSource", sMetaSource);

     String sMetaLimit = (String)req.getParameter("listMetaLimit");
     int intMetaLimit = 0;
     if(sMetaLimit != null)
     {
      Integer iMetaLimit = new Integer(sMetaLimit);
      intMetaLimit = iMetaLimit.intValue();
      if(intMetaLimit < 100) intMetaLimit = 100;
     }
     else
      intMetaLimit = 100;
     
     //do the keyword search for the selected component
     String sKeyword = (String)req.getParameter("keyword");
     if (sKeyword == null) sKeyword = "";
     if (isIntSearch == true) sKeyword = "";  //make keyword empty if initial search for window open
     session.setAttribute("creKeyword", sKeyword);   //keep the old criteria
 //System.out.println("getACKeyword sKeyword: " + sKeyword);   
     UtilService util = new UtilService();
     sKeyword = util.parsedStringSingleQuoteOracle(sKeyword);
     if(sSearchInEVS.equals("Code"))// search Meta by LOINC code
      dtsVocab = "Metathesaurus";
      
     //call the method to set the attribute checked values if not the initial value
     if (isIntSearch == false)
        setAttributeValues(req, res, sSearchAC, "searchForCreate");

     //filter by context; looks for ACs that uses multi select context and gets it from requests according to that
     String sContext = "";
    // if (sSearchAC.equals("RepTerm") || sSearchAC.equals("Property") || sSearchAC.equals("ObjectClass"))
     if (isBlockSearch == true)
     {
       sContext = (String)req.getParameter("listContextFilter");
       session.setAttribute("creContext", sContext);   //keep the old context criteria
       session.setAttribute("creContextBlocks", sContext);
       if (sContext == null || sContext.equals("AllContext")) sContext = "";       
     }
     else
       sContext = this.getMultiReqValues(sSearchAC, "searchForCreate", "Context");      

     //filter by contextUse
	   String sContextUse = (String)req.getParameter("rContextUse");
     session.setAttribute("creContextUse", sContextUse);   //store contextUse in the session
	   if (sContextUse == null) sContextUse = "";
          
     //filter by version
	   String sVersion = (String)req.getParameter("rVersion");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sVersion = "Yes"; //"All";  //make it all
     session.setAttribute("creVersion", sVersion);   //store version in the session
     //get the version number if other
     String txVersion = "";
     if (sVersion != null && sVersion.equals("Other"))
       txVersion = (String)req.getParameter("tVersion");
     if (txVersion == null) txVersion = "";
     session.setAttribute("creVersionNum", txVersion);   //store version in the session
     double dVersion = 0;
     //validate the version and display message if not valid
     if (txVersion != null && !txVersion.equals(""))
     {
       String sValid = setAC.checkVersionDimension(txVersion);
       if (sValid != null && !sValid.equals(""))
       {
         logger.fatal("not a good version ;" + sValid);
       }
       else
       {
         Double DVersion = new Double(txVersion);
         dVersion = DVersion.doubleValue();
       }   
     }
     //make sVersion to empty if all or other
     if (sVersion == null || sVersion.equals("All") || sVersion.equals("Other")) sVersion = "";

      //filter by value domain type enumerated
      String sVDType = "";
	    String sVDTypeEnum = (String)req.getParameter("enumBox");
      session.setAttribute("creVDTypeEnum", sVDTypeEnum);   //store VDType Enum in the session
	    if (sVDTypeEnum != null) sVDType = "E";  
      //filter by value domain type non enumerated
	    String sVDTypeNonEnum = (String)req.getParameter("nonEnumBox");
      session.setAttribute("creVDTypeNonEnum", sVDTypeNonEnum);   //store VDType Non Enum in the session
	    if (sVDTypeNonEnum != null && !sVDTypeNonEnum.equals(""))
      {
          if (!sVDType.equals("")) sVDType = sVDType + ", ";
          sVDType = sVDType + "N";        
      }
          
      //filter by value domain type enumerated by reference
	    String sVDTypeRef = (String)req.getParameter("refEnumBox");
      session.setAttribute("creVDTypeRef", sVDTypeRef);   //store VDType Ref in the session
	    if (sVDTypeRef != null && !sVDTypeRef.equals(""))
      {
          if (!sVDType.equals("")) sVDType = sVDType + ", ";
          sVDType = sVDType + "R";        
      }
      sVDType = sVDType.trim();  //trim extra spaces if any
      
      String sCDid = ""; 
      sCDid = (String)req.getParameter("listCDName");    //get selected cd
      if(sCDid == null || sCDid.equals("All Domains")) sCDid = "";       
      session.setAttribute("creSelectedCD", sCDid);

     //to get a string from multiselect list
     String sStatus = "";
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain"))
        session.setAttribute("creStatus", new Vector());  //make it all status for cd open
     else
        sStatus = getStatusValues(req, res, sSearchAC, "searchForCreate");
	   if ((sStatus == null) || (sStatus.equals("AllStatus")))
	       sStatus = "";
     
     //filter by registration status
	   String sRegStatus = (String)req.getParameter("listRegStatus");
     session.setAttribute("creRegStatus", sRegStatus);   //store regstatus in the session
	   if (sRegStatus == null || sRegStatus.equals("allReg")) sRegStatus = "";

     //fitler by date created from date
	   String sCreatedFrom = (String)req.getParameter("createdFrom");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sCreatedFrom = "";  //make it empty
     session.setAttribute("creCreatedFrom", sCreatedFrom);   //store date created From in the session
	   if (sCreatedFrom == null) sCreatedFrom = "";

     //fitler by date created To date
	   String sCreatedTo = (String)req.getParameter("createdTo");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sCreatedTo = "";  //make it empty
     session.setAttribute("creCreatedTo", sCreatedTo);   //store date created To in the session
	   if (sCreatedTo == null) sCreatedTo = "";

     //fitler by date Modified from date
	   String sModifiedFrom = (String)req.getParameter("modifiedFrom");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sModifiedFrom = "";  //make it empty
     session.setAttribute("creModifiedFrom", sModifiedFrom);   //store date Modified From in the session
	   if (sModifiedFrom == null) sModifiedFrom = "";

     //fitler by date Modified To date
	   String sModifiedTo = (String)req.getParameter("modifiedTo");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sModifiedTo = "";  //make it empty
     session.setAttribute("creModifiedTo", sModifiedTo);   //store date Modified To in the session
	   if (sModifiedTo == null) sModifiedTo = "";

     //fitler by Modifier type
	   String sModifier = (String)req.getParameter("modifier");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sModifier = "";  //make it empty
     session.setAttribute("creModifier", sModifier);   //store Modifier in the session
	   if ((sModifier == null) || sModifier.equals("allUsers")) sModifier = "";

     //fitler by Creator type
	   String sCreator = (String)req.getParameter("creator");
     if (isIntSearch == true && sSearchAC.equals("ConceptualDomain")) sCreator = "";  //make it empty
     session.setAttribute("creCreator", sCreator);   //store Creator in the session
	   if ((sCreator == null) || sCreator.equals("allUsers")) sCreator = "";
     
    // String sUISearchType = (String)session.getAttribute("UISearchType");
     String sUISearchType = (String)req.getAttribute("UISearchType");
     if (sUISearchType == null || sUISearchType.equals("nothing")) 
      sUISearchType = "term";

     // call the method to get the data from the database and to get the final result vector
     Vector vResult = new Vector();
     String sMinID = sKeyword;
     if (sSearchAC.equals("DataElement"))
     {
        if (sSearchIn.equals("minID"))
        {
           doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                "", "", sMinID, "", "", "", "", "", "", "", "", "", "", vAC);  //get the list of Data Elements
        }
        else if (sSearchIn.equals("histID"))
        {
           String sHistID = sKeyword;
           doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier,
                "", "", "", sHistID, "", "", "", "", "", "", "", "", "", vAC);  //get the list of Data Elements
        }
        //search in by doc text
        else if (sSearchIn.equals("docText"))
        {
           String sDocs[] = req.getParameterValues("listRDType");
           String sDocTypes = "ALL";
           if (sDocs != null && sDocs.length > 0)
              sDocTypes = this.getDocTypeValues(sDocs, "searchForCreate");
         
           String sDocText = sKeyword;
           if (sDocText == null || sDocText.equals(""))
              sDocText = "*";
           if ((sDocText != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                  sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                  sDocText, sDocTypes, "", "", "", "", "", "", "", "", "", "", "", vAC);   //get the list of Data Elements for docText searchin
           }
        }
        //search in by names adn doc text long name and historic short cde name
        else if (sSearchIn.equals("NamesAndDocText"))
        {
           String sDocTypes = "LONG_NAME, HISTORIC SHORT CDE NAME";         
           String sDocText = sKeyword;
           if (sDocText == null || sDocText.equals(""))
              sDocText = "*";
           if ((sDocText != "") && sSearchAC.equals("DataElement"))
           {
             doDESearch("", sKeyword, "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                  sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                  sDocText, sDocTypes, "", "", "", "", "", "", "", "", "", "", "", vAC);   //get the list of Data Elements for Names and docText searchin
           }
        }
        //search in for origin
        else if (sSearchIn.equals("origin"))
        {
           String sOrigin = sKeyword;
           doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier,
                "", "", "", "", "", sOrigin, "", "", "", "", "", "", "", vAC);  //get the list of Data Elements
        }
        //search in by permissible value
        else if (sSearchIn.equals("permValue"))
        {
           String permValue = sKeyword;
           doDESearch("", "", "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                  sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                  "", "", "", "", permValue, "", "", "", "", "", "", "", "", vAC); //get the list of Data Elements for permissible value search in
        }       
        else
        {
           doDESearch("", sKeyword, "", sContext, sContextUse, sVersion, dVersion, sStatus, sRegStatus, 
                sCreatedFrom, sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, 
                "", "", "", "", "", "", "", "", "", "", "", "", "", vAC);  //get the list of Data Elements
        }
        session.setAttribute("vACSearch", vAC);
        getDEResult(req, res, vResult, "");
     }
     else if (sSearchAC.equals("DataElementConcept"))
     {
        if (sSearchIn.equals("minID"))
        {
           doDECSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID, "", "", "", dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts
        }
        else if (sSearchIn.equals("origin"))
        {
           String sOrigin = sKeyword;
           doDECSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", "", sOrigin, dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts
        }        
        else
        {
           doDECSearch("", sKeyword, "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", "", "", dVersion, sCDid, "", vAC);  //get the list of Data Element Concepts
        }        

        session.setAttribute("vACSearch", vAC);
        getDECResult(req, res, vResult, "");
     }
     else if (sSearchAC.equals("ValueDomain"))
     {
        if (sSearchIn.equals("minID"))
        {
           doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID,  
                "", "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains
        }
        else if (sSearchIn.equals("permValue"))
        {
           String sPermValue = sKeyword;
           doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "", 
                sPermValue, "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains
        }        
        else if (sSearchIn.equals("origin"))
        {
           String sOrigin = sKeyword;
            doVDSearch("", "", "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "",  "", 
                sOrigin, dVersion, sCDid, "", "", vAC);  //get the list of Value Domains
        }        
        else
        {
           doVDSearch("", sKeyword, "", sContext, sVersion, sVDType, sStatus, sCreatedFrom, 
                sCreatedTo, sModifiedFrom, sModifiedTo, sCreator, sModifier, "",  
                "", "", dVersion, sCDid, "", "", vAC);  //get the list of Value Domains
        }

        session.setAttribute("vACSearch", vAC);
        getVDResult(req, res, vResult, "");
     }
     else if (sSearchAC.equals("ConceptualDomain"))
     {
        //search only if not the first time or if the first time and not all contexts
        if (isIntSearch == false || (isIntSearch == true && !sContext.equals("")))
        {
          if (sSearchIn.equals("minID"))    //public id   
          {
             doCDSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, sMinID, "", dVersion, vAC);  //get the list of Conceptual Domains
          }
          else if (sSearchIn.equals("origin"))
          {
             String sOrigin = sKeyword;
             doCDSearch("", "", "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, "", sOrigin, dVersion, vAC);  //get the list of Conceptual Domains
          }        
          else
          {
             doCDSearch("", sKeyword, "", sContext, sVersion, sStatus, sCreatedFrom, sCreatedTo, 
                  sModifiedFrom, sModifiedTo, sCreator, sModifier, "", "", dVersion, vAC);  //get the list of Conceptual Domains
          }
          session.setAttribute("vACSearch", vAC);
          getCDResult(req, res, vResult, "");          
        }        
     }
     else if (sSearchAC.equals("PermissibleValue"))
     {
         //store the CRFValue id in the session
        String crfValueID = req.getParameter("QCValueIDseq");
        String crfValueName = req.getParameter("QCValueName");
       
        if (crfValueID != null && !crfValueID.equals(""))
        {
           session.setAttribute("selCRFValueID", crfValueID);
           session.setAttribute("selQCValueName", crfValueName);
        } 
        doPVVMSearch(sKeyword, sStatus, vAC);
        getPVVMResult(req, res, vResult, "");
         
        if (isIntSearch == false)
        {
           evs.do_EVSSearch(sKeyword, vAC, "NCI_Thesaurus", "Synonym", "All Sources",
           100, sUISearchType, sRetired, "", -1); // search both Thesaurus and Metathesaurus
           evs.get_Result(req, res, vResult, "DEF");
        }

        session.setAttribute("vACSearch", vAC);
        session.setAttribute("vPVVMResult", vAC);
        getPVVMResult(req, res, vResult, "");
      }
      else if (sSearchAC.equals("ValueMeaning"))
      {
        this.doVMSearch(sKeyword, sCDid, vAC);
        session.setAttribute("vACSearch", vAC);
        this.getVMResult(req, res, vResult);
      }
      else if (sSearchAC.equals("EVSValueMeaning"))
      {
        //first do the concept class search
        if (sSearchIn.equals("publicID"))
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        else if (!sSearchIn.equals("Code"))
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        //now the evs search
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
          intMetaLimit, sUISearchType, sRetired, "", -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        if(vAC != null)
          session.setAttribute("vEVSValueMeaning", vAC);
        evs.get_Result(req, res, vResult, "");
      }
       else if (sSearchAC.equals("CreateVM_EVSValueMeaning"))
      {
        //first do the concept class search
        if (sSearchIn.equals("publicID"))
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        else if (!sSearchIn.equals("Code"))
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        //now the evs search
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
          intMetaLimit, sUISearchType, sRetired, "", -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        if(vAC != null)
          session.setAttribute("vCreateVM_EVSValueMeaning", vAC);
        evs.get_Result(req, res, vResult, "");
      }
       else if (sSearchAC.equals("ParentConcept"))
      {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        if(vAC != null)
          session.setAttribute("vParentConcept", vAC);
        evs.get_Result(req, res, vResult, "");
      }
       else if (sSearchAC.equals("ParentConceptVM"))
      {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        if(vAC != null)
          session.setAttribute("vParentConceptVM", vAC);
        evs.get_Result(req, res, vResult, "");
      }
      else if (sSearchAC.equals("ObjectClass"))
      {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
        {
          do_caDSRSearch("", sContext, sStatus, sKeyword, vAC, "OC"); 
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        }
        else if (!sSearchIn.equals("Code"))
        {
          do_caDSRSearch(sKeyword, sContext, sStatus, "", vAC, "OC");
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        }
        // To search Synonym in EVS, need to filter
        if((dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
        && !sSearchIn.equals("publicID"))
            sKeyword = filterName(sKeyword, "display");

        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
              intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     else if (sSearchAC.equals("Property"))
     {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
        {
          do_caDSRSearch("", sContext, sStatus, sKeyword, vAC, "PROP");
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        }
        else if (!sSearchIn.equals("Code"))
        {
          do_caDSRSearch(sKeyword, sContext, sStatus, "", vAC, "PROP");
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        }
        //To search synonym you need to filter
        if(dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
          sKeyword = filterName(sKeyword, "display");
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource, 
            intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     else if (sSearchAC.equals("RepTerm"))
     {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
        {
          do_caDSRSearch("", sContext, sStatus, sKeyword, vAC, "REP"); 
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        }
        else if (!sSearchIn.equals("Code"))
        {
          do_caDSRSearch(sKeyword, sContext, sStatus, "", vAC, "REP");
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        }
        // To search Synonym in EVS, need to filter
        if((dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
        && !sSearchIn.equals("publicID"))
            sKeyword = filterName(sKeyword, "display");
        //To search synonym you need to filter
        if(dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
          sKeyword = filterName(sKeyword, "display");
          
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
            intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     else if (sSearchAC.equals("ObjectQualifier"))
     {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        else if (!sSearchIn.equals("Code"))   //do concept search
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);
        
        //To search synonym you need to filter
        if(dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
          sKeyword = filterName(sKeyword, "display");
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     else if (sSearchAC.equals("PropertyQualifier"))
     {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        else if (!sSearchIn.equals("Code"))   //do concept search
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);

        //To search synonym you need to filter
        if(dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
          sKeyword = filterName(sKeyword, "display");
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     else if (sSearchAC.equals("RepQualifier")|| sSearchAC.equals("RepTermQualifier"))
     {
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        if (sSearchIn.equals("publicID"))
          vAC = this.do_ConceptSearch("", "", sContext, sStatus, sKeyword, vAC);
        else if (!sSearchIn.equals("Code"))   //do concept search
          vAC = this.do_ConceptSearch(sKeyword, "", sContext, sStatus, "", vAC);

        //To search synonym you need to filter
        if(dtsVocab.equals("NCI_Thesaurus")|| dtsVocab.equals("Thesaurus/Metathesaurus"))
          sKeyword = filterName(sKeyword, "display");
        evs.do_EVSSearch(sKeyword, vAC, dtsVocab, sSearchInEVS, sMetaSource,
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1); // search both Thesaurus and Metathesaurus
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "");
     }
     //store result vector in the attribute
     session.setAttribute("results", vResult);
  }
  catch(Exception e)
  {
    //System.err.println("ERROR in GetACSearch-getACSearchForCreate: " + e);
    logger.fatal("ERROR - GetACSearch-getACSearchForCreate: " + e.toString());
  }
}

  /**
   * To get the sorted result vector to display for selected sort type, called from NCICurationServlet.
   * calls method 'getSortedRows' for the selected component to get sorted bean.
   * calls method 'getResult' for the selected component to result vector from the sorted bean.
   * final result vector is stored in the session vector "results".
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getBlockSortedResult(HttpServletRequest req, HttpServletResponse res, String ACType)
  {
    try
    {
     HttpSession session = req.getSession();

      //get the sort string parameter
      String sSortType = (String)req.getParameter("blockSortType");
      if (sSortType != null)
        session.setAttribute("blockSortType", sSortType);
      String sComponent = "";
      sComponent = (String)session.getAttribute("creSearchAC");
      String sUISearchType = (String)req.getParameter("UISearchType");
      req.setAttribute("UISearchType", sUISearchType);
      EVSSearch evs = new EVSSearch(m_classReq, m_classRes, m_servlet); 
      if ((!sComponent.equals("")) && (sComponent !=null))
      {
        Vector vResult = new Vector();
        getEVSSortedRows(req, res);
        evs.get_Result(req, res, vResult, "");
        session.setAttribute("results", vResult);
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR - in GetACSearch-BlockSortedResult: " + e);
      logger.fatal("ERROR - GetACSearch-BlockSortedResult : " + e.toString());
    }
  }

  /**
   * To get the sorted vector for the selected field in the EVS component, called from getBlockSortedResult.
   * gets the 'blockSortType' from request and 'vACSearch' vector from session.
   * calls 'getEVSFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vACSearch'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getEVSSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("blockSortType"); // Block searches
      if (sortField == null)
         sortField = (String)req.getParameter("sortType");  // Main search page
      else if (sortField == null)
         sortField = (String)session.getAttribute("blockSortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            EVS_Bean EVSSortBean1 = (EVS_Bean)vSRows.elementAt(i);
            String Name1 = getEVSFieldValue(EVSSortBean1, sortField);            //EVSSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            EVS_Bean tempBean = EVSSortBean1;
            String tempName = Name1;

            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              EVS_Bean EVSSortBean2 = (EVS_Bean)vSRows.elementAt(j);
              String Name2 = getEVSFieldValue(EVSSortBean2, sortField);         //EVSSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = EVSSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = EVSSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(EVSSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
       
          if (menuAction.equals("searchForCreate"))
              session.setAttribute("vACSearch", vSortedRows);
        } 
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-EVSsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-EVSsortedRows : " + e.toString());
    }
  }

  /**
   * 
   * @param vSRows
   * @param menuAction
   * @param sortField
   */
  private void sortEVSStringValue(Vector vSRows, String menuAction, String sortField)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //check if the vector has the data
      if (vSRows.size()>0)
      {
         if (!menuAction.equals("searchForCreate"))
         {
            //get the checked rows and store it in the bean 
           for (int i=0; i<vSRows.size(); i++)
           {
             EVS_Bean EVSBean = (EVS_Bean)vSRows.elementAt(i);
             //check if the row is checked
             String ckName = ("CK" + i);
             String rSel = (String)m_classReq.getParameter(ckName);
             if (rSel != null)
                EVSBean.setCHECKED(true);
             else
                EVSBean.setCHECKED(false);
           }
         }
        //loop through the  vector to get the bean row
        for(int i=0; i<(vSRows.size()); i++)
        {
          isSorted = false;
          EVS_Bean EVSSortBean1 = (EVS_Bean)vSRows.elementAt(i);
          String Name1 = getEVSFieldValue(EVSSortBean1, sortField);            //EVSSortBean1.getDE_PREFERRED_NAME();
          int tempInd = i;
          EVS_Bean tempBean = EVSSortBean1;
          String tempName = Name1;

          //loop through again to get the next bean in the vector
          for(int j=i+1; j<(vSRows.size()); j++)
          {
            EVS_Bean EVSSortBean2 = (EVS_Bean)vSRows.elementAt(j);
            String Name2 = getEVSFieldValue(EVSSortBean2, sortField);         //EVSSortBean2.getDE_PREFERRED_NAME();
            //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
            if (ComparedValue(sortField, Name1, Name2) > 0)
            {
              if (tempInd == i)
              {
                tempName = Name2;
                tempBean = EVSSortBean2;
                tempInd = j;
              }
              //else if (tempName.compareToIgnoreCase(Name2) > 0)
              else if (ComparedValue(sortField, tempName, Name2) > 0)
              {
                tempName = Name2;
                tempBean = EVSSortBean2;
                tempInd = j;
              }
            }
          }
          vSRows.removeElementAt(tempInd);
          vSRows.insertElementAt(EVSSortBean1, tempInd);
          vSortedRows.addElement(tempBean);     //add the temp bean to a vector
        }
        for(int i=0; i<(vSortedRows.size()); i++)
        {
          EVS_Bean EVSSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
        }
        if (menuAction.equals("searchForCreate"))
            session.setAttribute("vACSearch", vSortedRows);
         else
         {
            session.setAttribute("vSelRows", vSortedRows);
            session.setAttribute("sortType", sortField);
           //get the checked beans and add the checked names to the vector to keep the checkbox checked.
           Vector vCheckList = new Vector();
           for (int i=0; i<(vSortedRows.size()); i++)
           {
              EVS_Bean EVSBean = (EVS_Bean)vSortedRows.elementAt(i);
              if (EVSBean.getCHECKED())
                 vCheckList.addElement("CK" + i);
           }
           if (vCheckList != null)
              session.setAttribute("CheckList", vCheckList);
         }
      }  
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-sortEVSStringValue: " + e);
      logger.fatal("ERROR in GetACSearch-sortEVSStringValue : " + e.toString());
    }
  }
  
  /**
   * 
   * @param vSRows
   * @param menuAction
   * @param sortField
   */
  private void sortEVSIntValue(Vector vSRows, String menuAction, String sortField)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //check if the vector has the data
      if (vSRows.size()>0)
      {
        //loop through the  vector to get the bean row
        for(int i=0; i<(vSRows.size()); i++)
        {
          isSorted = false;
          EVS_Bean EVSSortBean1 = (EVS_Bean)vSRows.elementAt(i);
          String Name1 = getEVSFieldValue(EVSSortBean1, sortField);            //EVSSortBean1.getDE_PREFERRED_NAME();
          int tempInd = i;
          EVS_Bean tempBean = EVSSortBean1;
          String tempName = Name1;

          //loop through again to get the next bean in the vector
          for(int j=i+1; j<(vSRows.size()); j++)
          {
            EVS_Bean EVSSortBean2 = (EVS_Bean)vSRows.elementAt(j);
            String Name2 = getEVSFieldValue(EVSSortBean2, sortField);         //EVSSortBean2.getDE_PREFERRED_NAME();
            //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
            if (ComparedValue(sortField, Name1, Name2) > 0)
            {
              if (tempInd == i)
              {
                tempName = Name2;
                tempBean = EVSSortBean2;
                tempInd = j;
              }
              //else if (tempName.compareToIgnoreCase(Name2) > 0)
              else if (ComparedValue(sortField, tempName, Name2) > 0)
              {
                tempName = Name2;
                tempBean = EVSSortBean2;
                tempInd = j;
              }
            }
          }
          vSRows.removeElementAt(tempInd);
          vSRows.insertElementAt(EVSSortBean1, tempInd);
          vSortedRows.addElement(tempBean);     //add the temp bean to a vector
        }
        for(int i=0; i<(vSortedRows.size()); i++)
        {
          EVS_Bean EVSSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
        }
        if (menuAction.equals("searchForCreate"))
            session.setAttribute("vACSearch", vSortedRows);
         else
         {
            session.setAttribute("vSelRows", vSortedRows);
            session.setAttribute("sortType", sortField);
           //get the checked beans and add the checked names to the vector to keep the checkbox checked.
           Vector vCheckList = new Vector();
           for (int i=0; i<(vSortedRows.size()); i++)
           {
              EVS_Bean EVSBean = (EVS_Bean)vSortedRows.elementAt(i);
              if (EVSBean.getCHECKED())
                 vCheckList.addElement("CK" + i);
           }
           if (vCheckList != null)
              session.setAttribute("CheckList", vCheckList);
         }
      }  
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-sortEVSIntValue: " + e);
      logger.fatal("ERROR in GetACSearch-sortEVSIntValue : " + e.toString());
    }
  }
  /**
   * To get the value from the bean for the selected field, called from EVSsortedRows.
   *
   * @param curBean EVS bean.
   * @param curField sort Type field name.
   *
   * @return String EVSField Value if selected field is found. otherwise empty string.
   */
  private String getEVSFieldValue(EVS_Bean curBean, String curField)
  {
    String returnValue = "";
   try
    {
      if (curField.equals("name"))
        returnValue = curBean.getLONG_NAME();
      else if (curField.equals("umls") || curField.equals("Ident"))
        returnValue = curBean.getNCI_CC_VAL();
    /*  {
        String evsDB = curBean.getEVS_DATABASE();
        String umlsCUI = curBean.getUMLS_CUI_VAL();
        String tempCUI = curBean.getTEMP_CUI_VAL();
        if (evsDB.equals("NCI Thesaurus"))
           returnValue = curBean.getNCI_CC_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && !umlsCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getUMLS_CUI_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && tempCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getTEMP_CUI_VAL();
        else if (evsDB.equals("caDSR"))
           returnValue = curBean.getID();
        else
           returnValue = curBean.getNCI_CC_VAL();
      } */
      else if (curField.equals("def"))
        returnValue = curBean.getPREFERRED_DEFINITION();
      else if (curField.equals("source"))
        returnValue = curBean.getEVS_DEF_SOURCE();
      else if (curField.equals("db") || curField.equals("database"))
        returnValue = curBean.getEVS_DATABASE();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();
      else if (curField.equals("Level"))
      {
        int rValue = curBean.getLEVEL();        
        returnValue = returnValue.valueOf(rValue);
      }
      else if (curField.equals("decUse"))
        returnValue = curBean.getDEC_USING();
      else if (curField.equals("cadsrComp"))
        returnValue = curBean.getcaDSR_COMPONENT();
      else if (curField.equals("comment"))
        returnValue = curBean.getCOMMENTS();
      else if (curField.equals("publicID"))
        returnValue = curBean.getID();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getEVSField: " + e);
      logger.fatal("ERROR in GetACSearch-getEVSField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the OC component, called from getBlockSortedResult.
   * gets the 'blockSortType' from request and 'vACSearch' vector from session.
   * calls 'getOCFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vACSearch'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getOCSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("blockSortType"); // Block searches
      if (sortField == null)
         sortField = (String)req.getParameter("sortType");  // Main search page
      else if (sortField == null)
         sortField = (String)session.getAttribute("blockSortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               EVS_Bean OCBean = (EVS_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  OCBean.setCHECKED(true);
               else
                  OCBean.setCHECKED(false);
             }
           }
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            EVS_Bean OCSortBean1 = (EVS_Bean)vSRows.elementAt(i);
            String Name1 = getOCFieldValue(OCSortBean1, sortField);            //OCSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            EVS_Bean tempBean = OCSortBean1;
            String tempName = Name1;

            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              EVS_Bean OCSortBean2 = (EVS_Bean)vSRows.elementAt(j);
              String Name2 = getOCFieldValue(OCSortBean2, sortField);         //OCSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = OCSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = OCSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(OCSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          for(int i=0; i<(vSortedRows.size()); i++)
          {
            EVS_Bean OCSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
          }
          if (menuAction.equals("searchForCreate"))
              session.setAttribute("vACSearch", vSortedRows);
           else
           {
              session.setAttribute("vSelRows", vSortedRows);
              session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                EVS_Bean OCBean = (EVS_Bean)vSortedRows.elementAt(i);
                if (OCBean.getCHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
           }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-OCsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-OCsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from OCsortedRows.
   *
   * @param curBean OC bean.
   * @param curField sort Type field name.
   *
   * @return String OCField Value if selected field is found. otherwise empty string.
   */
  private String getOCFieldValue(EVS_Bean curBean, String curField)
  {
    String returnValue = "";
   try
    {
      if (curField.equals("name"))
        returnValue = curBean.getLONG_NAME();  //getPREFERRED_NAME();
      else if (curField.equals("umls") || curField.equals("Ident"))
        returnValue = curBean.getNCI_CC_VAL();
      else if (curField.equals("def"))
        returnValue = curBean.getPREFERRED_DEFINITION();
      else if (curField.equals("source"))
        returnValue = curBean.getEVS_DEF_SOURCE();
      else if (curField.equals("db") || curField.equals("database"))
        returnValue = curBean.getEVS_DATABASE();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();
      else if (curField.equals("minID") || curField.equals("publicID"))
        returnValue = curBean.getID();
      else if (curField.equals("decUse"))
        returnValue = curBean.getDEC_USING();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getOCField: " + e);
      logger.fatal("ERROR in GetACSearch-getOCField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the PC component, called from getBlockSortedResult.
   * gets the 'blockSortType' from request and 'vACSearch' vector from session.
   * calls 'getPCFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vACSearch'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getPCSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("blockSortType"); // Block searches
      if (sortField == null)
         sortField = (String)req.getParameter("sortType");  // Main search page
      else if (sortField == null)
         sortField = (String)session.getAttribute("blockSortType");
         
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               EVS_Bean PCBean = (EVS_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  PCBean.setCHECKED(true);
               else
                  PCBean.setCHECKED(false);
             }
           }
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            EVS_Bean PCSortBean1 = (EVS_Bean)vSRows.elementAt(i);
            String Name1 = getPCFieldValue(PCSortBean1, sortField);            //PCSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            EVS_Bean tempBean = PCSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              EVS_Bean PCSortBean2 = (EVS_Bean)vSRows.elementAt(j);
              String Name2 = getPCFieldValue(PCSortBean2, sortField);         //PCSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = PCSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = PCSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(PCSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          for(int i=0; i<(vSortedRows.size()); i++)
          {
            EVS_Bean PCSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
          }
          if (menuAction.equals("searchForCreate"))
              session.setAttribute("vACSearch", vSortedRows);
           else
           {
              session.setAttribute("vSelRows", vSortedRows);
              session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                EVS_Bean PCBean = (EVS_Bean)vSortedRows.elementAt(i);
                if (PCBean.getCHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null)
                session.setAttribute("CheckList", vCheckList);
           }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-PCsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-PCsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from PCsortedRows.
   *
   * @param curBean PC bean.
   * @param curField sort Type field name.
   *
   * @return String PCField Value if selected field is found. otherwise empty string.
   */
  private String getPCFieldValue(EVS_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("name"))
        returnValue = curBean.getLONG_NAME();  //getPREFERRED_NAME();
      else if (curField.equals("umls") || curField.equals("Ident"))
        returnValue = curBean.getNCI_CC_VAL();
    /*  else if (curField.equals("umls") || curField.equals("Ident"))
      {
        String evsDB = curBean.getEVS_DATABASE();
        String umlsCUI = curBean.getUMLS_CUI_VAL();
        String tempCUI = curBean.getTEMP_CUI_VAL();
        if (evsDB.equals("NCI Thesaurus"))
           returnValue = curBean.getNCI_CC_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && !umlsCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getUMLS_CUI_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && tempCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getTEMP_CUI_VAL();
        else if (evsDB.equals("caDSR"))
           returnValue = curBean.getID();
        else
           returnValue = curBean.getNCI_CC_VAL();
      } */
      else if (curField.equals("def"))
        returnValue = curBean.getPREFERRED_DEFINITION();
      else if (curField.equals("source"))
        returnValue = curBean.getEVS_DEF_SOURCE();
      else if (curField.equals("db") || curField.equals("database"))
        returnValue = curBean.getEVS_DATABASE();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();
      else if (curField.equals("minID") || curField.equals("publicID"))
        returnValue = curBean.getID();
      else if (curField.equals("decUse"))
        returnValue = curBean.getDEC_USING();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getPCField: " + e);
      logger.fatal("ERROR in GetACSearch-getPCField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the Rep component, called from getBlockSortedResult.
   * gets the 'blockSortType' from request and 'vACSearch' vector from session.
   * calls 'getRepFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vACSearch'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getRepSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      vSRows = (Vector)session.getAttribute("vACSearch");
      String sortField = (String)req.getParameter("blockSortType");
      if (sortField == null)
         sortField = (String)session.getAttribute("blockSortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            EVS_Bean RepSortBean1 = (EVS_Bean)vSRows.elementAt(i);
            String Name1 = getRepFieldValue(RepSortBean1, sortField);            //RepSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            EVS_Bean tempBean = RepSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              EVS_Bean RepSortBean2 = (EVS_Bean)vSRows.elementAt(j);
              String Name2 = getRepFieldValue(RepSortBean2, sortField);         //RepSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = RepSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = RepSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(RepSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          for(int i=0; i<(vSortedRows.size()); i++)
          {
            EVS_Bean RepSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
          }
            session.setAttribute("vACSearch", vSortedRows);
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-RepsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-RepsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from RepsortedRows.
   *
   * @param curBean Rep bean.
   * @param curField sort Type field name.
   *
   * @return String RepField Value if selected field is found. otherwise empty string.
   */
  private String getRepFieldValue(EVS_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("name"))
        returnValue = curBean.getPREFERRED_NAME();
      else if (curField.equals("umls") || curField.equals("Ident"))
      {
        String evsDB = curBean.getEVS_DATABASE();
        String umlsCUI = curBean.getUMLS_CUI_VAL();
        String tempCUI = curBean.getTEMP_CUI_VAL();
        if (evsDB.equals("NCI Thesaurus"))
           returnValue = curBean.getNCI_CC_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && !umlsCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getUMLS_CUI_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && tempCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getTEMP_CUI_VAL();
        else if (evsDB.equals("caDSR"))
           returnValue = curBean.getID();
        else
           returnValue = curBean.getNCI_CC_VAL();
      }
      else if (curField.equals("def"))
        returnValue = curBean.getPREFERRED_DEFINITION();
      else if (curField.equals("source"))
        returnValue = curBean.getEVS_CONCEPT_SOURCE();
      else if (curField.equals("db") || curField.equals("database"))
        returnValue = curBean.getEVS_DATABASE();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();

      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getRepField: " + e);
      logger.fatal("ERROR in GetACSearch-getRepField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the Q component, called from getBlockSortedResult.
   * gets the 'blockSortType' from request and 'vACSearch' vector from session.
   * calls 'getQFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vACSearch'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getQSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      vSRows = (Vector)session.getAttribute("vACSearch");
      String sortField = (String)req.getParameter("blockSortType");
      if (sortField == null)
         sortField = (String)session.getAttribute("blockSortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            EVS_Bean QSortBean1 = (EVS_Bean)vSRows.elementAt(i);
            String Name1 = getQFieldValue(QSortBean1, sortField);            //QSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            EVS_Bean tempBean = QSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              EVS_Bean QSortBean2 = (EVS_Bean)vSRows.elementAt(j);
              String Name2 = getQFieldValue(QSortBean2, sortField);         //QSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = QSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = QSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(QSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          for(int i=0; i<(vSortedRows.size()); i++)
          {
            EVS_Bean QSortBean1 = (EVS_Bean)vSortedRows.elementAt(i);
          }
            session.setAttribute("vACSearch", vSortedRows);
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-QsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-QsortedRows : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from QsortedRows.
   *
   * @param curBean Q bean.
   * @param curField sort Type field name.
   *
   * @return String QField Value if selected field is found. otherwise empty string.
   */
  private String getQFieldValue(EVS_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("name"))
        returnValue = curBean.getPREFERRED_NAME();
      else if (curField.equals("umls") || curField.equals("Ident"))
      {
        String evsDB = curBean.getEVS_DATABASE();
        String umlsCUI = curBean.getUMLS_CUI_VAL();
        String tempCUI = curBean.getTEMP_CUI_VAL();
        if (evsDB.equals("NCI Thesaurus"))
           returnValue = curBean.getNCI_CC_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && !umlsCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getUMLS_CUI_VAL();
        else if (evsDB.equals("NCI Metathesaurus") && tempCUI.equalsIgnoreCase("No value returned."))
           returnValue = curBean.getTEMP_CUI_VAL();
        else
           returnValue = curBean.getNCI_CC_VAL();
      }
      else if (curField.equals("def"))
        returnValue = curBean.getDESCRIPTION();
      else if (curField.equals("source"))
        returnValue = curBean.getEVS_DEF_SOURCE();
      else if (curField.equals("db") || curField.equals("database"))
        returnValue = curBean.getEVS_DATABASE();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getQField: " + e);
      logger.fatal("ERROR in GetACSearch-getQField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get final result vector of selected attributes/rows to display for Permissible Values component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the QuestBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getQuestionResult(HttpServletRequest req, HttpServletResponse res, Vector vResult)
  {
    Vector vQuestion = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

      vQuestion = (Vector)session.getAttribute("vACSearch");
      Vector vRSel = (Vector)session.getAttribute("vSelRows");
      if (menuAction.equals("searchForCreate"))  vRSel = null;
      if (vRSel == null)
        vRSel = vQuestion;
      Integer recs = new Integer(vRSel.size());
      String recs2 = recs.toString();
      String sKeyword = "";
      req.setAttribute("recsFound", recs2);
      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchASL = new Vector();
      Quest_Bean QuestBean = new Quest_Bean();
      for (int i=0; i<(vRSel.size()); i++)
      {
        QuestBean = new Quest_Bean();
        QuestBean = (Quest_Bean)vRSel.elementAt(i);
        //store the status in the vector
        vSearchID.addElement(QuestBean.getSTATUS_INDICATOR());

        vResult.addElement(QuestBean.getSTATUS_INDICATOR());
        if (vSelAttr.contains("Question Text")) vResult.addElement(QuestBean.getQUEST_NAME());
        if (vSelAttr.contains("DE Long Name")) vResult.addElement(QuestBean.getDE_LONG_NAME());
        if (vSelAttr.contains("DE Public ID")) vResult.addElement(QuestBean.getCDE_ID());
        if (vSelAttr.contains("Question Public ID")) vResult.addElement(QuestBean.getQC_ID());
        if (vSelAttr.contains("Origin")) vResult.addElement(QuestBean.getQUEST_ORIGIN());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(QuestBean.getASL_NAME());
        if (vSelAttr.contains("Value Domain")) vResult.addElement(QuestBean.getVD_LONG_NAME());
        if (vSelAttr.contains("Context")) vResult.addElement(QuestBean.getCONTEXT_NAME());
        if (vSelAttr.contains("Protocol ID")) vResult.addElement(QuestBean.getPROTOCOL_ID());
        if (vSelAttr.contains("CRF Name")) vResult.addElement(QuestBean.getCRF_NAME());
        if (vSelAttr.contains("Highlight Indicator")) vResult.addElement(QuestBean.getHIGH_LIGHT_INDICATOR());
      }
      if (QuestBean != null)
      {
         //make keyWordLabel label request session
         session.setAttribute("serKeyword", QuestBean.getCRF_NAME());
         session.setAttribute("serProtoID", QuestBean.getPROTOCOL_ID());
         String crfName = QuestBean.getCRF_NAME();
         if(crfName == null) crfName = "";
         req.setAttribute("labelKeyword", "Draft New Questions in CRF: - " + crfName);   //make the label
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchASL", vSearchASL);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getQuestionResult: " + e);
      logger.fatal("ERROR in GetACSearch-getQuestionResult : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from QuestsortedRows.
   *
   * @param curBean Quest bean.
   * @param curField sort Type field name.
   *
   * @return String QuestField Value if selected field is found. otherwise empty string.
   */
  private String getQuestionFieldValue(Quest_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("QuestText"))
        returnValue = curBean.getQUEST_NAME();
      else if (curField.equals("context"))
        returnValue = curBean.getCONTEXT_NAME();
      else if (curField.equals("DEPublicID"))
        returnValue = curBean.getCDE_ID();
      else if (curField.equals("minID"))
        returnValue = curBean.getQC_ID();
      else if (curField.equals("Status"))
        returnValue = curBean.getASL_NAME();
      else if (curField.equals("Origin"))
        returnValue = curBean.getQUEST_ORIGIN();
      else if (curField.equals("ProtoID"))
        returnValue = curBean.getPROTOCOL_ID();
      else if (curField.equals("CRFName"))
        returnValue = curBean.getCRF_NAME();
      else if (curField.equals("DELongName"))
        returnValue = curBean.getDE_LONG_NAME();
      else if (curField.equals("HighLight"))
        returnValue = curBean.getHIGH_LIGHT_INDICATOR();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getQuestField: " + e);
      logger.fatal("ERROR in GetACSearch-getQuestField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the Quest component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getQuestionFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getQuestionSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               Quest_Bean QuestBean = (Quest_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  QuestBean.setQUEST_CHECKED(true);
               else
                  QuestBean.setQUEST_CHECKED(false);
             }
           }

          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            Quest_Bean QuestSortBean1 = (Quest_Bean)vSRows.elementAt(i);
            String Name1 = getQuestionFieldValue(QuestSortBean1, sortField);            //QuestSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            Quest_Bean tempBean = QuestSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              Quest_Bean QuestSortBean2 = (Quest_Bean)vSRows.elementAt(j);
              String Name2 = getQuestionFieldValue(QuestSortBean2, sortField);         //QuestSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = QuestSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = QuestSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(QuestSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }

          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                Quest_Bean QuestBean = (Quest_Bean)vSortedRows.elementAt(i);
                if (QuestBean.getQUEST_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null && vCheckList.size() > 0)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-QuestionsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-QuestionsortedRows : " + e.toString());
    }
  }

  /**
   * To get the Question Value result vector to display for the user, called from NCICurationServlet.
   * calls method 'doQuestValueSearch' to search the questions.
   * calls method 'setAttributeValues' to get the selected attributes.
   * calls method 'getQuestValueSortedRows' for the selected component to get sorted bean.
   * calls method 'getQuestValueResult' for the selected component to result vector from the sorted bean.
   * final result vector is stored in the session vector "results".
   *
   * @param userName String name of the user.
   * @throws exception e
   */
  public void getACQuestionValue() throws Exception
  {
      HttpSession session = m_classReq.getSession();
      Vector vResult = new Vector();
      //get the crf id and question id from the selected quest bean
      Quest_Bean QuestBean = (Quest_Bean)session.getAttribute("m_Quest");
      String sQuestId = QuestBean.getQC_IDSEQ();
      String sCRFId = QuestBean.getCRF_IDSEQ();

      //call to search questions and save the result in the questValue session vector
      doQuestValueSearch(sQuestId, sCRFId, vResult);
  }

  /**
   * To get resultSet from database for Question Values called from getACQuestionValue methods.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_DE(DE_IDSEQ, InString, ContID, ContName, ASLName, CDE_ID, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to Question bean which is added to the vector to return
   *
   * @param userName name of the user.
   * @param vList returns Vector of DEbean.
   *
   */
  private void doQuestValueSearch(String sQuestID, String sCRFID, Vector vList)  // returns list of Questions
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      HttpSession session = m_classReq.getSession();
      Vector pvList = (Vector)session.getAttribute("VDPVList"); 
      Vector vvList = new Vector();
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_CRFValue(?,?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(4, OracleTypes.CURSOR);

        // Now tie the placeholders for In parameters.
        CStmt.setString(1,sQuestID);
        CStmt.setString(2,"");
        CStmt.setString(3,"");

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

           //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(4);

        String s;

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            Quest_Value_Bean QuestValueBean = new Quest_Value_Bean();
            QuestValueBean.setQUESTION_VALUE_IDSEQ(rs.getString(1));
            QuestValueBean.setQUESTION_VALUE(rs.getString(2));
            QuestValueBean.setVP_IDSEQ(rs.getString(3));
            vList.addElement(QuestValueBean);  //add the bean to a vector
            if (pvList == null) pvList = new Vector();
            //match the vp id with the VD's PV if valid values allready been matched.
            boolean isMatched = false;
            for (int i=0; i<pvList.size(); i++)
            {
              PV_Bean pvBean = (PV_Bean)pvList.elementAt(i);
              if (pvBean != null && pvBean.getPV_VDPVS_IDSEQ() != null)
              {
                if (pvBean.getPV_VDPVS_IDSEQ().equals(QuestValueBean.getVP_IDSEQ()))
                {
                  pvBean.setQUESTION_VALUE_IDSEQ(rs.getString(1));
                  pvBean.setQUESTION_VALUE(rs.getString(2));
                  pvList.setElementAt(pvBean, i);
                  isMatched = true;
                  break;
                }
              }
            }
            //add as a new item to the pv bean if not matched
            if (!isMatched)
            {
              vvList.addElement(rs.getString(2));
            }
          }  //END WHILE
        }   //END IF
        if (pvList != null) session.setAttribute("VDPVList", pvList);
      }
      session.setAttribute("vQuestValue", vList);  //all valid values
      session.setAttribute("NonMatchVV", vvList);
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-QuestionValueSearch: " + e);
      logger.fatal("ERROR - GetACSearch-QuestionValueSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-QuestionValueSearch: " + ee);
      logger.fatal("ERROR - GetACSearch-QuestionValueSearch for close : " + ee.toString());
    }
  }  //endQuestionValue search

  /**
   * To get final result vector of selected attributes/rows to display for Permissible Values component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the QuestBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getQuestValueResult(HttpServletRequest req, HttpServletResponse res, Vector vResult)
  {

    try
    {
      HttpSession session = req.getSession();

      Vector vQuestValue = (Vector)session.getAttribute("vQuestValue");
      Integer recs = new Integer(vQuestValue.size());
      String recs2 = recs.toString();
      session.setAttribute("creKeyword", "");
      //make keyWordLabel label request session
      Quest_Bean QuestBean = (Quest_Bean)session.getAttribute("m_Quest");
      String sQuestion = QuestBean.getQUEST_NAME();
      req.setAttribute("labelKeyword", "CRF Values - " + sQuestion);   //make the label

      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      for(int i=0; i<(vQuestValue.size()); i++)
      {
        Quest_Value_Bean QuestValueBean = new Quest_Value_Bean();
        QuestValueBean = (Quest_Value_Bean)vQuestValue.elementAt(i);
        vSearchID.addElement(QuestValueBean.getQUESTION_VALUE_IDSEQ());
        vSearchName.addElement(QuestValueBean.getQUESTION_VALUE());

        vResult.addElement(QuestValueBean.getQUESTION_VALUE());
        vResult.addElement(QuestValueBean.getPERMISSIBLE_VALUE());
        vResult.addElement(QuestValueBean.getVALUE_MEANING());
      }
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getQuestValueResult: " + e);
      logger.fatal("ERROR in GetACSearch-getQuestValueResult : " + e.toString());
    }
  }

  /**
   * To get the value from the bean for the selected field, called from QuestValuesortedRows.
   *
   * @param curBean Quest bean.
   * @param curField sort Type field name.
   *
   * @return String QuestValueField Value if selected field is found. otherwise empty string.
   */
  private String getQuestValueFieldValue(Quest_Value_Bean curBean, String curField)
  {
    String returnValue = "";
    try
    {
      if (curField.equals("crfValue"))
        returnValue = curBean.getQUESTION_VALUE();
      else if (curField.equals("value"))
        returnValue = curBean.getPERMISSIBLE_VALUE();
      else if (curField.equals("meaning"))
        returnValue = curBean.getVALUE_MEANING();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getQuestValueField: " + e);
      logger.fatal("ERROR in GetACSearch-getQuestValueField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the QuestValue component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getQuestValueFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getQuestValueSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      vSRows = (Vector)session.getAttribute("vQuestValue");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            Quest_Value_Bean QuestValueSortBean1 = (Quest_Value_Bean)vSRows.elementAt(i);
            String Name1 = getQuestValueFieldValue(QuestValueSortBean1, sortField);            //QuestValueSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            Quest_Value_Bean tempBean = QuestValueSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              Quest_Value_Bean QuestValueSortBean2 = (Quest_Value_Bean)vSRows.elementAt(j);
              String Name2 = getQuestValueFieldValue(QuestValueSortBean2, sortField);         //QuestValueSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = QuestValueSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = QuestValueSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(QuestValueSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }
          for(int i=0; i<(vSortedRows.size()); i++)
          {
            Quest_Value_Bean QuestValueSortBean1 = (Quest_Value_Bean)vSortedRows.elementAt(i);
          }
          session.setAttribute("vQuestValue", vSortedRows);
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-QuestValuesortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-QuestValuesortedRows : " + e.toString());
    }
  }

     /**
  * To search for definitions.
  * Called from 'service' method where reqType is 'searchEVS'
  * forwards page 'EVSSearchPage.jsp'.
  *
  * @param req The HttpServletRequest from the client
  * @param res The HttpServletResponse back to the client
  *
  * @throws Exception
  */
  public void doSearchEVS(HttpServletRequest req, HttpServletResponse res)
  throws Exception
  {
      try
      {
        HttpSession session = req.getSession();     //get the session
        Vector vAC = new Vector();
        Vector vResult = new Vector();
        String termStr = req.getParameter("tfSearchTerm");
         //get the search in data
      //  String sSearchIn = (String)req.getParameter("listSearchIn");
     //   if (sSearchIn == null) sSearchIn = "longName";
      //  session.setAttribute("creSearchInBlocks", sSearchIn);  //keep the search in criteria

        String dtsVocab = req.getParameter("listContextFilterVocab");
        if(dtsVocab == null) dtsVocab = "NCI_Thesaurus";
     //   session.setAttribute("dtsVocab", dtsVocab); 

        String sSearchInEVS = (String)req.getParameter("listSearchInEVS");
        if (sSearchInEVS == null) sSearchInEVS = "Synonym";
      //  req.setAttribute("SearchInEVS", sSearchInEVS);
     
        String sMetaSource = (String)req.getParameter("listContextFilterSource");
        if (sMetaSource == null) sMetaSource = "All Sources";
     //   req.setAttribute("MetaSource", sMetaSource);
        
        String sRetired = (String)req.getParameter("rRetired");
        if (sRetired == null) sRetired = "Exclude";
    //    req.setAttribute("creRetired", sRetired);
        
     //   String sUISearchType = (String)session.getAttribute("UISearchType");
        String sUISearchType = (String)req.getAttribute("UISearchType");
        if (sUISearchType == null || sUISearchType.equals("nothing")) 
          sUISearchType = "term";

        String sMetaLimit = (String)req.getParameter("listMetaLimit");
        int intMetaLimit = 0;
        if(sMetaLimit != null)
        {
          Integer iMetaLimit = new Integer(sMetaLimit);
          intMetaLimit = iMetaLimit.intValue();
          if(intMetaLimit < 100) intMetaLimit = 100;
        }
        else
          intMetaLimit = 100;
          
        String sConteIdseq = (String)req.getParameter("sConteIdseq");
        if (sConteIdseq == null) sConteIdseq = "";
        session.setAttribute("creKeyword", termStr);
        //call the method to search
        EVSSearch evs = new EVSSearch(req, res, m_servlet);
        evs.do_EVSSearch(termStr, vAC, dtsVocab, sSearchInEVS, sMetaSource, 
        intMetaLimit, sUISearchType, sRetired, sConteIdseq, -1);
        session.setAttribute("vACSearch", vAC);
        evs.get_Result(req, res, vResult, "DEF");
        session.setAttribute("EVSresults", vResult);
        req.setAttribute("labelKeyword", termStr);
        Integer recs = new Integer(vAC.size());
        String recs2 = recs.toString();
        String sKeyword = "";
        req.setAttribute("creRecsFound", recs2);
      }
      catch (Exception e)
      {
        //System.err.println("EVS Definition Search : " + e);
      }
  } 

  /**
   * To get the alternate names for the selected AC from the database.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.GET_ALTERNATE_NAMES(AC_IDSEQ, detl_name, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to ALT_NAME bean
   *
   * @param acIdseq String id of the selected ac.
   * @param detlName String the detl type of the selected AC.
   *
   */
  public void doAltNameSearch(String acIdseq, String detlName, String CD_ID, String sOrigin)  // 
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector vList = new Vector();
    HttpSession session = m_classReq.getSession();
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_ALTERNATE_NAMES(?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);

        // Now tie the placeholders for In parameters.
        if(CD_ID == null || CD_ID.equals(""))
          CStmt.setString(1, acIdseq);
        else 
          CStmt.setString(1, CD_ID);
        CStmt.setString(2, detlName);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

           //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(3);

        String s;
        //get the current session list of ref doc to append to all DEs
        Vector vAllAltName = (Vector)session.getAttribute("AllAltNameList"); 
        if (vAllAltName == null) vAllAltName = new Vector();
    //System.out.println("alt names list");

        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            if (sOrigin.equals("EditDesDE") && rs.getString("detl_name").equals("USED_BY"))
              continue;
            ALT_NAME_Bean AltNameBean = new ALT_NAME_Bean();
            AltNameBean.setALT_NAME_IDSEQ(rs.getString("desig_idseq"));
            AltNameBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
            AltNameBean.setCONTEXT_NAME(rs.getString("context_name"));            
            AltNameBean.setALTERNATE_NAME(rs.getString("name"));
            AltNameBean.setALT_TYPE_NAME(rs.getString("detl_name"));
            AltNameBean.setAC_LONG_NAME(rs.getString("ac_long_name"));
            AltNameBean.setAC_IDSEQ(acIdseq);
            AltNameBean.setAC_LANGUAGE(rs.getString("lae_name"));
            AltNameBean.setALT_SUBMIT_ACTION("UPD");
            vList.addElement(AltNameBean);  //add the bean to a vector
            vAllAltName.addElement(AltNameBean);
          }  //END WHILE
        }   //END IF
        session.setAttribute("AllAltNameList", vAllAltName);
      }
      m_classReq.setAttribute("AltNameList", vList);
      m_classReq.setAttribute("itemType", detlName);
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-doAltNameSearch : " + e);
      logger.fatal("ERROR - GetACSearch-doAltNameSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doAltNameSearch : " + ee);
      logger.fatal("ERROR - GetACSearch-doAltNameSearch for close : " + ee.toString());
    }
  }  //doAltNameSearch search

  /**
   * To get the reference documents for the selected AC and type from the database.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.GET_REFERENCE_DOCUMENTS(AC_IDSEQ, DCTL_NAME, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to REF_DOC bean
   *
   * @param acIdseq String id of the selected ac.
   * @param docType String the type of reference document.
   *
   */
  public void doRefDocSearch(String acIdseq, String docType)  // 
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector vList = new Vector();
    HttpSession session = m_classReq.getSession();
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_REFERENCE_DOCUMENTS(?,?,?)}");

        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);

        // Now tie the placeholders for In parameters.
        CStmt.setString(1, acIdseq);
        //make it empty if all types
        if (docType == null || docType.equals("ALL TYPES"))
          docType = "";
        CStmt.setString(2, docType);

         // Now we are ready to call the stored procedure
        boolean bExcuteOk = CStmt.execute();

           //store the output in the resultset
        rs = (ResultSet) CStmt.getObject(3);

        String s;
        //get the current session list of ref doc to append to all DEs
        Vector vAllRefDoc = (Vector)session.getAttribute("AllRefDocList"); 
        if (vAllRefDoc == null) vAllRefDoc = new Vector();
        if(rs!=null)
        {
          //loop through the resultSet and add them to the bean
          while(rs.next())
          {
            REF_DOC_Bean RefDocBean = new REF_DOC_Bean();
            RefDocBean.setAC_IDSEQ(rs.getString("ac_idseq"));
            RefDocBean.setAC_LONG_NAME(rs.getString("ac_long_name"));
            RefDocBean.setREF_DOC_IDSEQ(rs.getString("rd_idseq"));
            RefDocBean.setDOCUMENT_NAME(rs.getString("rd_name"));
            RefDocBean.setDOC_TYPE_NAME(rs.getString("rd_dctl_name"));
            String sValue = rs.getString("rd_doc_text");
            if (sValue == null) sValue = "";
            RefDocBean.setDOCUMENT_TEXT(sValue); 
            sValue = rs.getString("url");
            if (sValue == null) sValue = "";
            RefDocBean.setDOCUMENT_URL(sValue);
            RefDocBean.setCONTE_IDSEQ(rs.getString("conte_idseq"));
            RefDocBean.setCONTEXT_NAME(rs.getString("context_name"));
            RefDocBean.setAC_LANGUAGE(rs.getString("rd_lae_name"));
            RefDocBean.setREF_SUBMIT_ACTION("UPD");
            vList.addElement(RefDocBean);  //add the bean to a vector
            vAllRefDoc.addElement(RefDocBean);
          }  //END WHILE
        }   //END IF
        session.setAttribute("AllRefDocList", vAllRefDoc);
      }
      m_classReq.setAttribute("RefDocList", vList);
      m_classReq.setAttribute("itemType", docType);
    }
    catch (Exception e)
    {
      //System.err.println("other problem in GetACSearch-doRefDocSearch : " + e);
      logger.fatal("ERROR - GetACSearch-doRefDocSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doRefDocSearch : " + ee);
      logger.fatal("ERROR - GetACSearch-doRefDocSearch for close : " + ee.toString());
    }
  }  //doRefDocSearch search

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
  public Integer doPVACSearch(String acIdseq, String acName, String sAction)  // 
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Integer pvCount = new Integer(0);
    try
    {
      Vector vList = new Vector();
      HttpSession session = m_classReq.getSession();
      Vector oldVDPV = (Vector)session.getAttribute("VDPVList");
      PV_Bean pvBean = new PV_Bean();
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
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
            pvBean = new PV_Bean();
            pvBean.setPV_PV_IDSEQ(rs.getString("pv_idseq"));
            pvBean.setPV_VALUE(rs.getString("value"));
            pvBean.setPV_SHORT_MEANING(rs.getString("short_meaning"));
            if (sAction.equals("NewUsing"))
              pvBean.setPV_VDPVS_IDSEQ("");
            else
              pvBean.setPV_VDPVS_IDSEQ(rs.getString("vp_idseq"));
            pvBean.setPV_MEANING_DESCRIPTION(rs.getString("vm_description"));             
            if (sAction.equals("Version"))
              pvBean = this.updatePVBean(pvBean, oldVDPV);
            else
            {
              pvBean.setPV_VALUE_ORIGIN(rs.getString("origin"));
              String sDate = rs.getString("begin_date");
              if (sDate != null && !sDate.equals(""))
                sDate = m_util.getCurationDate(sDate);
              pvBean.setPV_BEGIN_DATE(sDate);
              sDate = rs.getString("end_date");
              if (sDate != null && !sDate.equals(""))
                sDate = m_util.getCurationDate(sDate);
              pvBean.setPV_END_DATE(sDate);
              if (sAction.equals("NewUsing"))
                pvBean.setVP_SUBMIT_ACTION("INS"); 
              else
                pvBean.setVP_SUBMIT_ACTION("NONE"); 
              //get valid value attributes
              pvBean.setQUESTION_VALUE("");
              pvBean.setQUESTION_VALUE_IDSEQ("");
              //get vm concept attributes
              EVS_Bean vmConcept = new EVS_Bean();
              String sCondr = rs.getString("vm_condr_idseq");
              vmConcept.setCONDR_IDSEQ(sCondr);            
              if (sCondr != null && !sCondr.equals(""))
              {
                GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
                Vector vConList = getAC.getAC_Concepts(sCondr, null, true);
                if (vConList != null && vConList.size() > 0) 
                  vmConcept = (EVS_Bean)vConList.elementAt(0);
              }
              pvBean.setVM_CONCEPT(vmConcept);
              //get parent concept attributes
              EVS_Bean parConcept = new EVS_Bean();
              String sCon = rs.getString("con_idseq");
              parConcept.setCON_IDSEQ(sCon);
              if (sCon != null && !sCon.equals(""))
              {
                InsACService insAC = new InsACService(m_classReq, m_classRes, m_servlet);
                String sRet = "";
                sCon = insAC.getConcept(sRet, parConcept, false);
              }
              pvBean.setPARENT_CONCEPT(parConcept);
            }            
            //add pv idseq in the pv id vector
            vList.addElement(pvBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
      //store new ones if added on the page
      if (sAction.equals("Version") && oldVDPV.size() != vList.size())
      {
        Vector vVal = (Vector)m_classReq.getAttribute("vValue");
        for (int i=0; i<oldVDPV.size(); i++)
        {
          PV_Bean thisPV = (PV_Bean)oldVDPV.elementAt(i);
          //make sure it doesn't exists already in the vector and is not deleted
          if (!vVal.contains(thisPV.getPV_VALUE()) && !thisPV.getVP_SUBMIT_ACTION().equals("DEL"))
          {
            vList.addElement(thisPV);
          }
        }
      }
      //store the first element and count in the request
      String pvValue = "";
      if (vList != null && vList.size() > 0)
      {
        pvBean = (PV_Bean)vList.elementAt(0);
        pvValue = pvBean.getPV_VALUE();
        pvCount = new Integer(vList.size());
      }
      m_classReq.setAttribute("PermValueList", vList);
      m_classReq.setAttribute("ACName", acName);
      //get first pv name in the request
      m_classReq.setAttribute("pvValue", pvValue);
      session.setAttribute("VDPVList", vList);  //store the bean
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-doPVACSearch : " + e);
      logger.fatal("ERROR - GetACSearch-doPVACSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doPVACSearch : " + ee);
      logger.fatal("ERROR - GetACSearch-doPVACSearch for close : " + ee.toString());
    }
    return pvCount;
  }  //doPVACSearch search

  /**
   * ac_version method copies all other attributes from old ac to versioned ac, but some attributes are changed on the page. 
   * This method compares the existing pvs and updates its attributes and mark it to update/remove
   * 
   * @param newBean pv_bean class
   * @param oldVDPV old vdpv vector from session
   * @return pv_bean updated with changes attributes from the page
   */
  private PV_Bean updatePVBean(PV_Bean newBean, Vector oldVDPV)
  {
    try
    {
      Vector vValue = (Vector)m_classReq.getAttribute("vValue");
      if (vValue == null) vValue = new Vector();
      for (int i=0; i<oldVDPV.size(); i++)
      {
        PV_Bean oldPV = (PV_Bean)oldVDPV.elementAt(i);
        String oldValue = oldPV.getPV_VALUE();
        String oldMean = oldPV.getPV_SHORT_MEANING();
        String newValue = newBean.getPV_VALUE();
        String newMean = newBean.getPV_SHORT_MEANING();
        if (oldValue.equals(newValue) && oldMean.equals(newMean))
        {
          newBean.setPV_VALUE_ORIGIN(oldPV.getPV_VALUE_ORIGIN());
          newBean.setPV_BEGIN_DATE(oldPV.getPV_BEGIN_DATE());
          newBean.setPV_END_DATE(oldPV.getPV_END_DATE());
          if (oldPV.getVP_SUBMIT_ACTION().equalsIgnoreCase("NONE"))
            newBean.setVP_SUBMIT_ACTION("UPD");
          else
            newBean.setVP_SUBMIT_ACTION(oldPV.getVP_SUBMIT_ACTION());
          newBean.setVM_CONCEPT(oldPV.getVM_CONCEPT());
          newBean.setPV_VM_CONDR_IDSEQ(oldPV.getPV_VM_CONDR_IDSEQ());
          newBean.setPARENT_CONCEPT(oldPV.getPARENT_CONCEPT());
          vValue.addElement(newValue);
          break;
        }
      }
      m_classReq.setAttribute("vValue", vValue);
    }
    catch (Exception e)
    {
      //System.err.println("Problem closing in GetACSearch-updatePVBean : " + e);
      logger.fatal("ERROR - GetACSearch-updatePVBean for close : " + e.toString());      
    }
    return newBean;
  }
  /**
   * To get the Protocol CRFs for the selected AC  from the database.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.GET_PROTO_CRF(AC_IDSEQ, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to Quest bean
   *
   * @param acIdseq String id of the selected ac.
   * @param acName String AC name.
   *
   * @return Integer of Proto CRF Count
   */
  public Integer doProtoCRFSearch(String acIdseq, String acName)  // 
  {
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    Vector vList = new Vector();
    HttpSession session = m_classReq.getSession();
    Integer qCount = new Integer(0);
    try
    {
      Quest_Bean QuestBean = new Quest_Bean();
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.GET_PROTOCOL_CRF(?,?)}");

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
            QuestBean = new Quest_Bean();
            QuestBean.setPROTOCOL_ID(rs.getString("PROTOCOL_ID"));
            QuestBean.setPROTOCOL_NAME(rs.getString("PROTOCOL_NAME"));
            QuestBean.setCRF_NAME(rs.getString("crf"));
            //QuestBean.setCONTEXT_NAME(rs.getString("CRF_CONTEXT")); 
            //QuestBean.setASL_NAME(rs.getString("CRF_ASL_NAME"));
            vList.addElement(QuestBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
      String QuestValue = "";
      if (vList != null && vList.size() > 0)
      {
        QuestBean = (Quest_Bean)vList.elementAt(0);
        //QuestValue = QuestBean.getQuest_VALUE();
        qCount = new Integer(vList.size());
      }
      m_classReq.setAttribute("ProtoCRFList", vList);
      m_classReq.setAttribute("ACName", acName);        
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-doProtoCRFSearch : " + e);
      logger.fatal("ERROR - GetACSearch-doProtoCRFSearch for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      //System.err.println("Problem closing in GetACSearch-doProtoCRFSearch : " + ee);
      logger.fatal("ERROR - GetACSearch-doProtoCRFSearch for close : " + ee.toString());
    }
    return qCount;
  }  //doProtoCRFSearch search

   /** To get the Context name for the CD assoicated with VD or DEC.
   * Uses the session attriubtes of CD list and get the context name.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param sCDid selected Administered component.
   *
   */
  public String getCDContext(String sCDid) throws Exception  
  {
      String cdName = "";
      HttpSession session = m_classReq.getSession();
      Vector vCDNames = (Vector)session.getAttribute("vCD");  //get  Conceptual domain list attribute
      Vector vCDID = (Vector)session.getAttribute("vCD_ID");  //get  Conceptual domain list attribute
      if (vCDID != null)
      {
        cdName = (String)vCDNames.elementAt(vCDID.indexOf(sCDid));
        if (cdName == null) cdName = "";
      }
      return cdName; 
  }//getCDContext

   /** 
   * To get the value meanings for the selected cd.
   *
   * @param sCDid selected Administered component.
   * @param vAC search result of vlaue meanings.
   * @throws exception
   */
  public void doVMListSearch(String sCDid, Vector vAC) throws Exception  
  {
      String cdName = "";
      HttpSession session = m_classReq.getSession();
      Vector vCDNames = (Vector)session.getAttribute("vCD");  //get  Conceptual domain list attribute
      Vector vCDID = (Vector)session.getAttribute("vCD_ID");  //get  Conceptual domain list attribute
      if (vCDID != null)
      {
        if (sCDid != null && !sCDid.equals(""))
            cdName = (String)vCDNames.elementAt(vCDID.indexOf(sCDid));
        if (cdName == null) cdName = "";
        session.setAttribute("creKeyword", cdName);
      }

      //get the value meanings
      GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
      Vector vMeaning = new Vector();
      Vector vDescription = new Vector();
      getAC.getValueMeaningsList(sCDid, vMeaning, vDescription);
      //loop through the meaning list and store it in the bean.
      if (vMeaning != null)
      {
        for (int i=0; i<vMeaning.size(); i++)
        {
          //get the vm and desc attributes from teh vector
          VM_Bean vmBean = new VM_Bean();
          String sMean = (String)vMeaning.elementAt(i);
          String sDesc = "";
          if (vDescription != null && vDescription.size() > i)
            sDesc = (String)vDescription.elementAt(i);
          //add the attributes to the bean  
          vmBean.setVM_SHORT_MEANING(sMean);
          vmBean.setVM_DESCRIPTION(sDesc);
          vmBean.setVM_CD_IDSEQ(sCDid);
          vmBean.setVM_CD_NAME(cdName);
          //add the bean to the vector
          vAC.addElement(vmBean);
        }
      }
  }//do VM Search
  
/**
   * To get resultSet from database for Permissible Value Component called from getACKeywordResult and getCDEIDSearch methods.
   *
   * calls oracle stored procedure
   *  "{call SBREXT_CDE_CURATOR_PKG.SEARCH_VM(InString, OracleTypes.CURSOR)}"
   *
   * loop through the ResultSet and add them to bean which is added to the vector to return
   *
   * @param InString Keyword value, is empty if searchIn is minID.
   * @param vList returns Vector of PVbean.
   *
  */
  private void doVMSearch(String InString, String cd_idseq, Vector vList)  // returns list of Data Elements
  {
System.out.println("in doVMSearch InString: " + InString);
    Connection sbr_db_conn = null;
    ResultSet rs = null;
    CallableStatement CStmt = null;
    try
    {
      //Create a Callable Statement object.
      sbr_db_conn = m_servlet.connectDB(m_classReq, m_classRes);
      if (sbr_db_conn == null)
        m_servlet.ErrorLogin(m_classReq, m_classRes);
      else
      {
        CStmt = sbr_db_conn.prepareCall("{call SBREXT_CDE_CURATOR_PKG.SEARCH_VM(?,?,?)}");
        // Now tie the placeholders for out parameters.
        CStmt.registerOutParameter(3, OracleTypes.CURSOR);
        // Now tie the placeholders for In parameters.
        CStmt.setString(1,InString);
        CStmt.setString(2,cd_idseq);
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
            EVS_Bean vmConcept = new EVS_Bean();
            vmConcept.setEVSBean("", rs.getString("evs_definition_source"), 
                          rs.getString("vm_concept_name"), 
                          rs.getString("vm_evs_cui_source"), "", "", 
                          rs.getString("vm_concept_code"), "", "", 
                          rs.getString("evs_origin"), 0, "", "", "");
            vmBean.setVM_CONCEPT(vmConcept);
            vList.addElement(vmBean);  //add the bean to a vector
          }  //END WHILE
        }   //END IF
      }
    }
    catch(Exception e)
    {
      //System.err.println("other problem in GetACSearch-searchVM: " + e);
      logger.fatal("ERROR - GetACSearch-searchVM for other : " + e.toString());
    }
    try
    {
      if(rs!=null) rs.close();
      if(CStmt!=null) CStmt.close();
      if(sbr_db_conn != null) sbr_db_conn.close();
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR - GetACSearch-searchVM for close : " + ee.toString());
    }
  }  //endVM search

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
      if (curField.equals("meaning"))
        returnValue = curBean.getVM_SHORT_MEANING();
      else if (curField.equals("MeanDesc"))
        returnValue = curBean.getVM_DESCRIPTION();
      else if (curField.equals("comment"))
        returnValue = curBean.getVM_COMMENTS();
      else if (curField.equals("ConDomain"))
        returnValue = curBean.getVM_CD_NAME();
      if (returnValue == null)
        returnValue = "";
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getVMField: " + e);
      logger.fatal("ERROR in GetACSearch-getVMField : " + e.toString());
    }
    return returnValue;
  }

  /**
   * To get the sorted vector for the selected field in the VM component, called from getACSortedResult.
   * gets the 'sortType' from request and 'vSelRows' vector from session.
   * calls 'getVMFieldValue' to extract the value from the bean for the selected sortType.
   * modified bubble sort method to sort beans in the vector using the strings compareToIgnoreCase method.
   * adds the sorted bean to a vector 'vSelRows'.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getVMSortedRows(HttpServletRequest req, HttpServletResponse res)
  {
    try
    {
      HttpSession session = req.getSession();
      Vector vSRows = new Vector();
      Vector vSortedRows = new Vector();
      boolean isSorted = false;
      //get the selected rows
      String menuAction = (String)session.getAttribute("MenuAction");
      if (menuAction.equals("searchForCreate"))
          vSRows = (Vector)session.getAttribute("vACSearch");
      else
          vSRows = (Vector)session.getAttribute("vSelRows");

      String sortField = (String)req.getParameter("sortType");
      if (sortField == null) sortField = (String)session.getAttribute("sortType");
      if (sortField != null)
      {
        //check if the vector has the data
        if (vSRows.size()>0)
        {
           if (!menuAction.equals("searchForCreate"))
           {
              //get the checked rows and store it in the bean 
             for (int i=0; i<vSRows.size(); i++)
             {
               VM_Bean VMBean = (VM_Bean)vSRows.elementAt(i);
               //check if the row is checked
               String ckName = ("CK" + i);
               String rSel = (String)req.getParameter(ckName);
               if (rSel != null)
                  VMBean.setVM_CHECKED(true);
               else
                  VMBean.setVM_CHECKED(false);
             }
           }

          //loop through the  vector to get the bean row
          for(int i=0; i<(vSRows.size()); i++)
          {
            isSorted = false;
            VM_Bean VMSortBean1 = (VM_Bean)vSRows.elementAt(i);
            String Name1 = getVMFieldValue(VMSortBean1, sortField);            //VMSortBean1.getDE_PREFERRED_NAME();
            int tempInd = i;
            VM_Bean tempBean = VMSortBean1;
            String tempName = Name1;
            //loop through again to get the next bean in the vector
            for(int j=i+1; j<(vSRows.size()); j++)
            {
              VM_Bean VMSortBean2 = (VM_Bean)vSRows.elementAt(j);
              String Name2 = getVMFieldValue(VMSortBean2, sortField);         //VMSortBean2.getDE_PREFERRED_NAME();
              //if (Name1.compareToIgnoreCase(Name2) > 0)   //make comparisions and store it in temp
              if (ComparedValue(sortField, Name1, Name2) > 0)
              {
                if (tempInd == i)
                {
                  tempName = Name2;
                  tempBean = VMSortBean2;
                  tempInd = j;
                }
                //else if (tempName.compareToIgnoreCase(Name2) > 0)
                else if (ComparedValue(sortField, tempName, Name2) > 0)
                {
                  tempName = Name2;
                  tempBean = VMSortBean2;
                  tempInd = j;
                }
              }
            }
            vSRows.removeElementAt(tempInd);
            vSRows.insertElementAt(VMSortBean1, tempInd);
            vSortedRows.addElement(tempBean);     //add the temp bean to a vector
          }

          if (menuAction.equals("searchForCreate"))
             session.setAttribute("vACSearch", vSortedRows);
          else
          {
             session.setAttribute("vSelRows", vSortedRows);
             session.setAttribute("sortType", sortField);
             //get the checked beans and add the checked names to the vector to keep the checkbox checked.
             Vector vCheckList = new Vector();
             for (int i=0; i<(vSortedRows.size()); i++)
             {
                VM_Bean VMBean = (VM_Bean)vSortedRows.elementAt(i);
                if (VMBean.getVM_CHECKED())
                   vCheckList.addElement("CK" + i);
             }
             if (vCheckList != null && vCheckList.size() > 0)
                session.setAttribute("CheckList", vCheckList);
          }
        }
      }
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-VMsortedRows: " + e);
      logger.fatal("ERROR in GetACSearch-VMsortedRows : " + e.toString());
    }
  }

  /**
   * To get final result vector of selected attributes/rows to display for Permissible Values component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the VMBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   *
   */
  public void getVMResult(HttpServletRequest req, HttpServletResponse res, Vector vResult)
  {
    Vector vVM = new Vector();
    try
    {
      HttpSession session = req.getSession();

      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSelAttr = new Vector();
      vSelAttr =(Vector)session.getAttribute("creSelectedAttr");

      Vector vRSel = (Vector)session.getAttribute("vACSearch");
      if (vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      //get the keyword value
      req.setAttribute("creRecsFound", recs2);
      sKeyword = (String)session.getAttribute("creKeyword");

      //make keyWordLabel label request session
      if (sKeyword.equals("") && !menuAction.equals("searchForCreate"))
         sKeyword = (String)session.getAttribute("LastAppendWord");
      if (sKeyword == null) sKeyword = "";
      req.setAttribute("labelKeyword", "Value Meaning : " + sKeyword);   //make the label
      Vector vValue = new Vector();
      Vector vDesc = new Vector();
      for (int i=0; i<(vRSel.size()); i++)
      {
        VM_Bean VMBean = new VM_Bean();
        VMBean = (VM_Bean)vRSel.elementAt(i);
        //they have to be in the order of attribute multi select list
        vValue.addElement(VMBean.getVM_SHORT_MEANING());
        vDesc.addElement(VMBean.getVM_DESCRIPTION());  
        EVS_Bean vmConcept = VMBean.getVM_CONCEPT();
        if (vmConcept == null) vmConcept = new EVS_Bean();
        if (vSelAttr.contains("Value Meaning")) vResult.addElement(VMBean.getVM_SHORT_MEANING());
        if (vSelAttr.contains("Meaning Description")) vResult.addElement(VMBean.getVM_DESCRIPTION());
        if (vSelAttr.contains("Conceptual Domain")) vResult.addElement(VMBean.getVM_CD_NAME());        
        if (vSelAttr.contains("EVS Identifier")) vResult.addElement(vmConcept.getNCI_CC_VAL());        
        if (vSelAttr.contains("Definition Source")) vResult.addElement(vmConcept.getEVS_DEF_SOURCE());        
        if (vSelAttr.contains("Vocabulary")) vResult.addElement(vmConcept.getEVS_DATABASE());        
        if (vSelAttr.contains("Comments")) vResult.addElement(VMBean.getVM_COMMENTS());
        if (vSelAttr.contains("Effective Begin Date")) vResult.addElement(VMBean.getVM_BEGIN_DATE());
        if (vSelAttr.contains("Effective End Date")) vResult.addElement(VMBean.getVM_END_DATE());
      }
      session.setAttribute("SearchLongName", vValue);
      session.setAttribute("SearchMeanDescription", vDesc);      
    }
    catch(Exception e)
    {
      //System.err.println("ERROR in GetACSearch-getVMResult: " + e);
      logger.fatal("ERROR in GetACSearch-getVMResult : " + e.toString());
    }
  }
//close the class
} 
