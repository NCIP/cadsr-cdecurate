
// Copyright (c) 2000 ScenPro, Inc.
package com.scenpro.NCICuration;

import java.io.Serializable;
import java.util.*;
import javax.servlet.http.*;
import java.text.*;

import gov.nih.nci.system.applicationservice.*;
import gov.nih.nci.evs.domain.*;
import gov.nih.nci.evs.query.*;
import gov.nih.nci.common.util.*;



import org.apache.log4j.*;

/**
 * EVSSearch class is for search action of the tool for all components.
 * <P>
 * @author Tom Phillips
 * @version 3.0.1
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

public class EVSSearch implements Serializable
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
  public EVSSearch(HttpServletRequest req, HttpServletResponse res,
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
  public EVSSearch(HttpServletRequest req, HttpServletResponse res)
  {
    m_classReq = req;
    m_classRes = res;
    m_servlet = null;
  } 


 /**
   * This method searches EVS vocabularies and returns concepts, which are used
   * to construct names of Administered Components. If the vocabulary name passed
   * in is "NCI_Thesaurus", the two vocabularies Thesaurus and Metathesaurus are 
   * searched in succession and the results (a concept and its attributes) are
   * stored in beans. Each bean is added to a Vector vList passed in as a 
   * parameter. The search term may be either a name/definition or a concept 
   * code/identifier, as described by the parameter passed in "sSearchInEVS".
   *
   * @param termStr      Keyword value.
   * @param vList        returns Vector of search beans.
   * @param dtsVocab     the EVS Vocabulary
   * @param sSearchInEVS which field to search in.
   * @param sMetaSource  Metathesaurus source to filter by.
   * @param sMetaLimit   limit of Meta records returned
   * @param sUISearchType term or tree.
   * @param sRetired     show retired concepts or not.
   * @param sConte_idseq The context idseq
   * @param iLevelImmediate the level below th parent concept
   *
   */
 public void do_EVSSearch(String termStr,
      Vector vList, String dtsVocab, String sSearchInEVS,
      String sMetaSource , int sMetaLimit, String sUISearchType, String sRetired,
      String sConte_idseq, int iLevelImmediate) 
  {
    //capture the duration
    java.util.Date exDate = new java.util.Date();          
    String prefName = "";
    String prefNameConcept = "";
    String prefNameConceptOriginal = "";
    String CCode = "";
    int ilevel = 0;
    int ilevelImmediate = 0;
    Boolean isRetired = new Boolean(false);
    Boolean bTrue = new Boolean(true);
    Boolean bFalse = new Boolean(false);
    boolean isMetaCodeSearch = false;
    Boolean codeFoundInThesaurus = new Boolean(false);
    HttpSession session = m_classReq.getSession();
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
    String sSearchType = (String)m_classReq.getParameter("searchType");
    if(sSearchType == null) sSearchType = "";
    String sAltNameType = "";
    String synonymIsHeader = "false";
    Source src = new Source();
    String sTreeSearch = (String)session.getAttribute("OpenTreeToConcept");
    if(sTreeSearch == null) sTreeSearch = "";
    session.setAttribute("OpenTreeToConcept", "");   
    Vector vProps  = null;
    ArrayList vMetaDefs = null;
    ArrayList vMetaSrc = null;
    String source = "";
    String definition = "";
    //use unparsed search string
    if (sSearchInEVS != null && !sSearchInEVS.equalsIgnoreCase("Code") && !sSearchInEVS.equalsIgnoreCase("Concept Code"))
      termStr = (String)session.getAttribute("creKeyword");
  
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("") ||
    dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
    {
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
      sAltNameType = "NCI_CONCEPT_CODE";
    }
    // for search Meta by (LOINC) code
    else if(dtsVocab.equals("Metathesaurus") || sSearchInEVS.equals("Code"))
    {
      dtsVocab = m_servlet.m_VOCAB_NCI;  //dtsVocab = "NCI_Thesaurus";
      sAltNameType = "NCI_CONCEPT_CODE";
      isMetaCodeSearch = true;
      sUISearchType = "term";
    }
    //for Meta searches only (no Thes search), like in getSuperConcepts Meta
    else if(dtsVocab.equals("NCI Metathesaurus"))
    {
      sAltNameType = "UMLS_CUI";
      isMetaCodeSearch = false;
      sUISearchType = "term";
    }
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
    {
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
      sAltNameType = "VA_NDF_CODE";
    }
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
    {
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
      sAltNameType = "UWD_VA_CODE";
    }
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
    {
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
      sAltNameType = "NCI_MO_CODE";
    }
    else if(dtsVocab.equals("GO"))
    {
      dtsVocab = m_servlet.m_VOCAB_GO;
      sAltNameType = "GO_CODE";
    }
    else if(dtsVocab.equals("LOINC"))
    {
      dtsVocab = m_servlet.m_VOCAB_LOI;
      sAltNameType = "LOINC_CODE";
    }
    else if(dtsVocab.equals("MedDRA"))
    {
      dtsVocab = m_servlet.m_VOCAB_MED;
      sAltNameType = "MEDDRA_CODE";
    }
    else if(dtsVocab.equals("HL7_V3")) 
    {
      sAltNameType = "HL7_V3_CODE";
      dtsVocab = m_servlet.m_VOCAB_HL7;
    }
    else
      sAltNameType = "";
      
    //     m_EVS_CONNECT = "http://cbiodev104.nci.nih.gov:29080/cacoreevs301/server/HTTPServer";  //dev
    //   m_EVS_CONNECT = "http://cbioqa101.nci.nih.gov:29080/cacore30/server/HTTPServer";  //qa
    //  m_EVS_CONNECT = "http://cbioapp102.nci.nih.gov:29080/cacore30/server/HTTPServer";  //prod
    //   m_EVS_CONNECT = "http://cbioqatest501.nci.nih.gov:8080/cacore30/server/HTTPServer";  //3.0.1
    //     m_EVS_CONNECT = "http://cbioqatest501.nci.nih.gov:8080/cacoreevs301/server/HTTPServer";  // new 3.0.1
      
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    
//System.out.println("do_EVSSearch dtsVocab: " + dtsVocab + " termStr: " + termStr + " sUISearchType: " + sUISearchType);
//System.out.println("do_EVSSearch sSearchInEVS: " + sSearchInEVS + " isMetaCodeSearch: " + isMetaCodeSearch + " sRetiredxx: " + sRetired);
 
  // Search By Concept Code
  if(sSearchInEVS.equals("Concept Code") && !termStr.equals("")
  && isMetaCodeSearch == false && !dtsVocab.equals("NCI Metathesaurus"))
  {
   try
   {
    if(sRetired.equals("Include") || sTreeSearch.equals("true")) // do this if all concepts, including retired, should be included
      isRetired = new Boolean(false);
    else
    {
      EVSQuery query5 = new EVSQueryImpl();
      query5.isRetired(dtsVocab, termStr);
      List bool = null;
      try
      {
        bool = evsService.evsSearch(query5);
      }
      catch(Exception ex)
      {
        ex.printStackTrace();
      }
      isRetired = (Boolean)bool.get(0);
    }
    if(isRetired.equals(bFalse))
    {
      EVSQuery query = new EVSQueryImpl(); 
      List concepts = null;
      query.getDescLogicConceptNameByCode(dtsVocab,termStr);
      CCode = termStr;
      try
      {
        concepts = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        System.out.println("Error do_EVSSearch: " + ex.toString());
      }
      if(concepts != null && concepts.size()>0)
      {
        codeFoundInThesaurus = new Boolean(true);
        prefNameConcept = (String)concepts.get(0);
        prefNameConceptOriginal = (String)concepts.get(0);
        query.searchDescLogicConcepts(dtsVocab,prefNameConcept,1000);
        concepts = null;
        try
        {
          concepts = evsService.evsSearch(query);
        }
        catch(Exception ex)
        {
          System.out.println("Error do_EVSSearch: " + ex.toString());
        }
        if(concepts != null)
        {
          
          DescLogicConcept aDescLogicConcept = new DescLogicConcept();
          for (int i = 0; i < concepts.size(); i++)
          {
              aDescLogicConcept = (DescLogicConcept)concepts.get(i);
              prefNameConcept = (String)aDescLogicConcept.getName();
              if(sSearchAC.equals("ParentConceptVM") && sSearchType.equals("Immediate") && ilevelImmediate > 0)
                ilevel = ilevelImmediate;
              else if(sSearchAC.equals("ParentConceptVM"))
                ilevel = getLevelDownFromParent(CCode, dtsVocab);         
              if(dtsVocab.length()>2 && dtsVocab.substring(0,3).equalsIgnoreCase("NCI")) 
               // || dtsVocab.substring(0,3).equalsIgnoreCase("Med")) // both have Preferred_Name property
              {
                EVSQuery query4 = new EVSQueryImpl(); 
                query4.getPropertyValues(dtsVocab, prefNameConcept, "Preferred_Name");
                List concepts4 = null;
                try
                {
                  concepts4 = evsService.evsSearch(query4);
                }
                catch(Exception ex)
                {
                  System.out.println("Error do_EVSSearch: " + ex.toString());
                }
                if(concepts4 != null && concepts4.size()>0)
                {
                  String results = "";
                  for (int m = 0; m < 1; m++)
                  {
                    prefNameConcept = concepts4.get(0).toString();
                  }
                }
              }
              EVSQuery query3 = new EVSQueryImpl(); 
              query3.getPropertyValues(dtsVocab, prefNameConceptOriginal, "DEFINITION");
              List concepts3 = null;
              try
              {
                concepts3 = evsService.evsSearch(query3);
              }
              catch(Exception ex)
              {
                System.out.println("Error do_EVSSearch: " + ex.toString());
              }
              if(concepts3 != null && concepts3.size()>0)
              {
                String results = "";
                for (int m = 0; m < concepts3.size(); m++)
                {
                  results = concepts3.get(m).toString();
                  if(dtsVocab.equals("NCI_Thesaurus"))
                  {
                    definition = getDefinition(results);
                    source = getSource(results); 
                  }
                  else if(dtsVocab.equals("GO") || dtsVocab.equals("MGED_Ontology"))
                  {
                    definition = results;
                  }
                  EVS_Bean OCBean = new EVS_Bean();
                  OCBean.setEVSBean(definition, source, prefNameConcept, sAltNameType, "", "",
                  CCode, "", "", dtsVocab, ilevel, "", sConte_idseq, ""); 
                  vList.addElement(OCBean);    //add OC bean to vector
                }
              }
              else // no definitions
              {
                  EVS_Bean OCBean = new EVS_Bean();
                  OCBean.setEVSBean("No value exists.", "", prefNameConcept, sAltNameType, "", "",
                  CCode, "", "", dtsVocab, ilevel, "", sConte_idseq, ""); 
                  vList.addElement(OCBean);    //add OC bean to vector
              } 
          }
  
        }    
       } 
    }
     } 
     catch(Exception ee)
      {
          System.err.println("problem in Thesaurus ccode EVSSearch-do_EVSSearch: " + ee.toString());
          logger.fatal("ERROR - EVSSearch-do_EVSSearch for Thesaurus : " + ee.toString());
      }
    }   // Search By Thes Term
    else if(!termStr.equals("") && isMetaCodeSearch == false && !dtsVocab.equals("NCI Metathesaurus")) // Synonym search
    {
      try
      {
        EVSQuery query = new EVSQueryImpl(); 
        if(dtsVocab.equals("NCI_Thesaurus"))  // || dtsVocab.equals("MedDRA"))
          query.getConceptWithPropertyMatching(dtsVocab,sSearchInEVS,termStr,10000);
         else
            query.searchDescLogicConcepts(dtsVocab,termStr,10000);
        List concepts = null;
        try
        {
          concepts = evsService.evsSearch(query);
        }
        catch(Exception ex)
        {
          System.out.println("Error do_EVSSearch: " + ex.toString());
        }
        if(concepts != null)
        {
          List bool2 = null;
          EVSQuery query5 = new EVSQueryImpl();
          
          for (int i = 0; i < concepts.size(); i++)
          {
            if(dtsVocab.equals("NCI_Thesaurus"))  // || dtsVocab.equals("MedDRA"))
            {
              prefNameConcept = concepts.get(i).toString();
              prefNameConceptOriginal = concepts.get(i).toString();
            }
            else
            {
              DescLogicConcept aDescLogicConcept = new DescLogicConcept();
              aDescLogicConcept = (DescLogicConcept)concepts.get(i);
              prefNameConcept = (String)aDescLogicConcept.getName();
              prefNameConceptOriginal = (String)aDescLogicConcept.getName();
   // System.out.println("do_EVSSearch prefNameConcept term: " + prefNameConcept);
            }
            CCode = do_getEVSCode(prefNameConcept, dtsVocab); 
            query5.isRetired(dtsVocab, CCode);
            try
            {
              bool2 = evsService.evsSearch(query5);
            }
            catch(Exception ex)
            {
              System.out.println("Error do_EVSSearch: " + ex.toString());
            }
         
            isRetired = (Boolean)bool2.get(0);
            if(sRetired.equals("Include")) // do this if all concepts, including retired, should be included
              isRetired = new Boolean(false);
            if(isRetired.equals(bFalse))
            {
              if(sSearchAC.equals("ParentConceptVM") && sSearchType.equals("Immediate") && ilevelImmediate > 0)
                ilevel = ilevelImmediate;
              else if(sSearchAC.equals("ParentConceptVM"))
                ilevel = getLevelDownFromParent(CCode, dtsVocab);
              
              if(dtsVocab.length()>2 && dtsVocab.substring(0,3).equalsIgnoreCase("NCI")) 
             // || dtsVocab.substring(0,3).equalsIgnoreCase("Med")) // both have Preferred_Name property
              {
                EVSQuery query4 = new EVSQueryImpl(); 
                query4.getPropertyValues(dtsVocab, prefNameConcept, "Preferred_Name");
                List concepts4 = null;
                try
                {
                  concepts4 = evsService.evsSearch(query4);
                }
                catch(Exception ex)
                {
                  System.out.println("Error do_EVSSearch: " + ex.toString());
                }
                if(concepts4 != null && concepts4.size()>0)
                {
                  String results = "";
                  for (int m = 0; m < 1; m++)
                  {
                    prefNameConcept = concepts4.get(0).toString();
                  }
                }
              }
              
              EVSQuery query3 = new EVSQueryImpl(); 
              query3.getPropertyValues(dtsVocab, prefNameConceptOriginal, "DEFINITION");
              List concepts3 = null;
              try
              {
                concepts3 = evsService.evsSearch(query3);
              }
              catch(Exception ex)
              {
                System.out.println("Error do_EVSSearch: " + ex.toString());
              }
              if(concepts3 != null && concepts3.size()>0)
              {
                String results = "";
                for (int m = 0; m < concepts3.size(); m++)
                {
                  results = concepts3.get(m).toString();
                  if(dtsVocab.equals("NCI_Thesaurus"))
                  {
                    definition = getDefinition(results);
                    source = getSource(results); 
                  }
                  else if(dtsVocab.equals("GO") || dtsVocab.equals("MGED_Ontology"))
                  {
                    definition = results;
                  }
                  EVS_Bean OCBean = new EVS_Bean();
                  OCBean.setEVSBean(definition, source, prefNameConcept, sAltNameType, "", "",
                  CCode, "", "", dtsVocab, ilevel, "", sConte_idseq, ""); 
                  vList.addElement(OCBean);    //add OC bean to vector
                }
              }
              else // no definitions
              {
                  EVS_Bean OCBean = new EVS_Bean();
                  OCBean.setEVSBean("No value exists.", "", prefNameConcept, sAltNameType, "", "",
                  CCode, "", "", dtsVocab, ilevel, "", sConte_idseq, ""); 
                  vList.addElement(OCBean);    //add OC bean to vector
              } 
              // Header concepts have 'HD' in their Synonyms in Thesaurus. We do not want Headers as Parent Concepts
              // for Referenced Value Domains
              if(dtsVocab.length()>2 && dtsVocab.substring(0,3).equalsIgnoreCase("NCI") && sSearchAC.equals("ParentConceptVM"))
              {
                String synonym = "";
                EVSQuery query4 = new EVSQueryImpl(); 
                query4.getPropertyValues(dtsVocab, prefNameConcept, "FULL_SYN");
                List concepts4 = null;
                try
                {
                  concepts4 = evsService.evsSearch(query4);
                }
                catch(Exception ex)
                {
                  System.out.println("Error do_EVSSearch: " + ex.toString());
                }
                if(concepts4 != null && concepts4.size()>0)
                {
                  String results2 = "";
                  for (int n = 0; n < concepts4.size(); n++)
                  {
                    results2 = concepts4.get(n).toString();
                    if(dtsVocab.equals("NCI_Thesaurus"))
                    {
                    definition = getDefinition(results2);
                    source = getSource(results2);
                    synonym = results2;
                    synonymIsHeader = parseSynonymForHD(results2);
                    if(synonymIsHeader.equals("true"))
                      break;
                    }
                  }
                }
              }
            }
          }
        }
        else
          System.out.println("do_EVSSearch term search concepts is null.");
      }
      catch(Exception ee)
      {
          System.err.println("problem in Thesaurus syn EVSSearch-do_EVSSearch: " + ee);
          logger.fatal("ERROR - EVSSearch-do_EVSSearch for Thesaurus : " + ee.toString());
      }
  }
  
  if((dtsVocab.equals("NCI_Thesaurus")  //Search Meta
  || dtsVocab.equals("NCI Metathesaurus")) && sUISearchType.equals("term")
  && !termStr.equals("") && !sTreeSearch.equals("true") && codeFoundInThesaurus.equals(bFalse))
  {
//System.out.println("do_EVSSearch Meta termStr: " + termStr + " sMetaSource: " + sMetaSource + " sMetaLimit: " + sMetaLimit + " isMetaCodeSearch: " + isMetaCodeSearch);
      int length = 0;
      length = termStr.length();
      EVSQuery query = new EVSQueryImpl();
      List concepts = null;
      if(isMetaCodeSearch == true)
        query.searchByLoincId(termStr,sMetaSource);
      else if(sSearchInEVS.equals("Concept Code"))
        query.searchMetaThesaurus(termStr,sMetaLimit,sMetaSource, true, false, false);
      else if(!sSearchInEVS.equals("Concept Code"))  
        query.searchMetaThesaurus(termStr,sMetaLimit,sMetaSource, false, false, false);
      try
      {
        concepts = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        System.out.println("Error do_EVSSearch Meta: " + ex.toString());
      }
      if(concepts != null)
      {
          MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
          for (int i = 0; i < concepts.size(); i++)
          {
            // Do this so only one result is returned on Meta code search (API is dupicating a result)
            if(isMetaCodeSearch == true && i > 0)
              break;  
            aMetaThesaurusConcept = (MetaThesaurusConcept)concepts.get(i);
            prefNameConcept = (String)aMetaThesaurusConcept.getName();
 // System.out.println("do_EVSSearch Meta prefNameConcept: " + prefNameConcept);
            CCode = (String)aMetaThesaurusConcept.getCui();
            if(sSearchAC.equals("ParentConceptVM") && sSearchType.equals("Immediate") && ilevelImmediate > 0)
                ilevel = ilevelImmediate;
            
            ArrayList sourceArray = new ArrayList();
            String sourceString = "";  
            if( aMetaThesaurusConcept != null)
              sourceArray =  aMetaThesaurusConcept.getSourceCollection();
            if(sourceArray != null)
            {
              for(int j=0; j<sourceArray.size(); j++)
              {
               Source sourceObj = (Source)sourceArray.get(j);
                if(sourceObj != null)
                {
                  if(j == 0)
                    sourceString = sourceObj.getAbbreviation();
                  else
                    sourceString = sourceString + ", " + sourceObj.getAbbreviation();
                }
              }
   //  System.out.println("do_EVSSearch Meta sourceString: " + sourceString); 
            }   

            vMetaDefs = aMetaThesaurusConcept.getDefinitionCollection();
            Definition mDefinition = null;
            if(vMetaDefs != null && vMetaDefs.size()>0)
            {
              if(sourceString.indexOf(sMetaSource)>-1 || sMetaSource.equals("All Sources"))
              {
                for (int j = 0; j < vMetaDefs.size(); j++)
                {
                  mDefinition = (Definition)vMetaDefs.get(j);
                  definition = mDefinition.getDefinition();
                  source = mDefinition.getSource().getAbbreviation();
                  EVS_Bean OCBean = new EVS_Bean();
                  OCBean.setEVSBean(definition, source, prefNameConcept, sAltNameType, "", "",
                  CCode, "", "", "NCI Metathesaurus", ilevel, "", sConte_idseq, ""); 
                  vList.addElement(OCBean);    //add OC bean to vector
                }
              }
            }
            else // no definitions
            {
              if(sourceString.indexOf(sMetaSource)>-1 || sMetaSource.equals("All Sources"))
              {
                EVS_Bean OCBean = new EVS_Bean();
                OCBean.setEVSBean("No value exists.", "", prefNameConcept, sAltNameType, "", "",
                CCode, "", "", "NCI Metathesaurus", ilevel, "", sConte_idseq, ""); 
                vList.addElement(OCBean);    //add OC bean to vector
              }
            }
          }  
       }
     } 
     evsService = null;
}         
  
/**
   * does evs code search
   * @param prefName string to search for
   * @param dtsVocab string selected vocabulary name
   * @return string of evs code
   */
public String do_getEVSCode(String prefName, String dtsVocab) 
{
// System.out.println("do_getEVSCode prefName: " + prefName + " dtsVocab: " + dtsVocab);
    if(prefName == null || prefName.equals(""))
      return "";
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    if (dtsVocab == null) dtsVocab = "";
    String CCode = ""; 
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("") ||
    dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
    {
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
      prefName = filterName(prefName, "js");
    }
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
    {
      prefName = filterName(prefName, "display");
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    }
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
    {
      dtsVocab = m_servlet.m_VOCAB_LOI;
      prefName = filterName(prefName, "display");
    }
    else if(dtsVocab.equals("MedDRA"))
    {
      dtsVocab = m_servlet.m_VOCAB_MED;
      prefName = filterName(prefName, "display");
    }
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;  
      
  if(!dtsVocab.equals("NCI Metathesaurus"))
  {
    EVSQuery codequery = new EVSQueryImpl();
    codequery.getConceptCodeByName(dtsVocab,prefName);
    List codes = null;
    try
    {
      codes = evsService.evsSearch(codequery);
    }
    catch(Exception ex)
    {
      System.out.println("Error do_getEVSCode: " + ex.toString());
      prefName = filterName(prefName, "display");
      codequery.getConceptCodeByName(dtsVocab,prefName);
      codes = null;
      try
      {
        codes = evsService.evsSearch(codequery);
      }
      catch(Exception ex2)
      {
        System.out.println("Error do_getEVSCode: " + ex2.toString());
        prefName = filterName(prefName, "js");
        codequery.getConceptCodeByName(dtsVocab,prefName);
        codes = null;
        try
        {
          codes = evsService.evsSearch(codequery);
        }
        catch(Exception ex3)
        {
          System.out.println("Error do_getEVSCode: " + ex3.toString());
        } 
      } 
    } 
    if(codes.size()>0)
      CCode = (String)codes.get(0);
    // hardcode to fix a bug in api
    if(dtsVocab.equals("GO") && (prefName.equals("double-strand break repair via homologous recombination ")
                                          || prefName.equals("double-strand break repair via homologous recombination")))
    { 
      CCode = "GO:0000724";          
    }
  }
  else if(dtsVocab.equals("NCI Metathesaurus"))
  {
    EVSQuery codequery2 = new EVSQueryImpl();
    List codes2 = null;
    codequery2.searchMetaThesaurus(prefName,100,"", false, false, false);
      try
      {
        codes2 = evsService.evsSearch(codequery2);
      }
      catch(Exception ex)
      {
         System.out.println("Error do_getEVSCode: " + ex.toString());
      }
      if(codes2 != null)
      {
          MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
          for (int i = 0; i < codes2.size(); i++)
          {
            aMetaThesaurusConcept = (MetaThesaurusConcept)codes2.get(i);
            CCode = (String)aMetaThesaurusConcept.getCui();
          }
      }
  }
  evsService = null;
  return CCode;
}

/**
   * does evs code search
   * @param prefName string to search for
   * @param dtsVocab string selected vocabulary name
   * @return string of evs code
   */
public String do_getConceptName(String CCode, String dtsVocab) 
{
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    if (dtsVocab == null) dtsVocab = "";
    String sConceptName = ""; 
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("") ||
    dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;  
      
  if(!dtsVocab.equals("NCI Metathesaurus"))
  {
    EVSQuery query = new EVSQueryImpl();
    List concepts = null;
    query.getDescLogicConceptNameByCode(dtsVocab,CCode);
    try
    {
      concepts = evsService.evsSearch(query);
    }
    catch(Exception ex)
    {
      System.out.println("Error do_EVSSearch: " + ex.toString());
    }
    if(concepts != null && concepts.size()>0)
      sConceptName = (String)concepts.get(0);
  }
  else if(dtsVocab.equals("NCI Metathesaurus"))
  {
    EVSQuery query2 = new EVSQueryImpl();
    List concepts2 = null;
    query2.searchMetaThesaurus(CCode,10,"", true, false, false);
    try
    {
      concepts2 = evsService.evsSearch(query2);
    }
    catch(Exception ex)
    {
      System.out.println("Error do_EVSSearch Meta: " + ex.toString());
    }
    if(concepts2 != null)
    {
      MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
      aMetaThesaurusConcept = (MetaThesaurusConcept)concepts2.get(0);
      sConceptName = (String)aMetaThesaurusConcept.getName();
    }    
  }
  evsService = null;
  return sConceptName;
}

 /**
   *
   * @param oc_condr_idseq  id of condr.
   * @param m_DEC
   * @param sMenu
   * 
   * @throws Exception
   * 
   */
  public void fillOCVectors(String oc_condr_idseq, DEC_Bean m_DEC, String sMenu)
  throws Exception
  {            
    if (m_DEC != null)
    { 
      HttpSession session = m_classReq.getSession();
      //get vd parent attributes
      GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
      Vector vOCConcepts = new Vector();
      if (oc_condr_idseq != null && !oc_condr_idseq.equals(""))
        vOCConcepts = getAC.getAC_Concepts(oc_condr_idseq, null, true);
      if (vOCConcepts != null) 
      {
          session.setAttribute("vObjectClass", vOCConcepts);
        // Primary concept
          EVS_Bean m_OC = (EVS_Bean)vOCConcepts.elementAt(0);
          if (m_OC == null) m_OC = new EVS_Bean();        
          m_DEC.setDEC_OCL_NAME_PRIMARY(m_OC.getLONG_NAME());
          m_DEC.setDEC_OC_CONCEPT_CODE(m_OC.getNCI_CC_VAL());
          m_DEC.setDEC_OC_EVS_CUI_ORIGEN(m_OC.getEVS_DATABASE());
          for(int i=1;i<vOCConcepts.size();i++)
          {
            EVS_Bean m_OCQ = (EVS_Bean)vOCConcepts.elementAt(i);
            if (m_OCQ == null) m_OCQ = new EVS_Bean();        
            Vector vOCQualifierNames = m_DEC.getDEC_OC_QUALIFIER_NAMES();
            if (vOCQualifierNames == null) vOCQualifierNames = new Vector();
            vOCQualifierNames.addElement(m_OCQ.getLONG_NAME());
            
            Vector vOCQualifierCodes = m_DEC.getDEC_OC_QUALIFIER_CODES();
            if (vOCQualifierCodes == null) vOCQualifierCodes = new Vector();
            vOCQualifierCodes.addElement(m_OCQ.getNCI_CC_VAL());
            
            Vector vOCQualifierDB = m_DEC.getDEC_OC_QUALIFIER_DB();
            if (vOCQualifierDB == null) vOCQualifierDB = new Vector();
            vOCQualifierDB.addElement(m_OCQ.getEVS_DATABASE());
            
            m_DEC.setDEC_OC_QUALIFIER_NAMES(vOCQualifierNames);
            m_DEC.setDEC_OC_QUALIFIER_CODES(vOCQualifierCodes);
            m_DEC.setDEC_OC_QUALIFIER_DB(vOCQualifierDB);
           // if(vOCQualifierNames.size()>0)
              //m_DEC.setDEC_OBJ_CLASS_QUALIFIER((String)vOCQualifierNames.elementAt(0));
          }
      }
    }
  }
  
/**
   *
   * @param prop_condr_idseq  id of condr.
   * @param m_DEC
   * @param sMenu
   *
   * @throws Exception
   * 
   */
  public void fillPropVectors(String prop_condr_idseq, DEC_Bean m_DEC, String sMenu)
  throws Exception
  { 
     if (m_DEC != null)
    {
      HttpSession session = m_classReq.getSession();
      //get vd parent attributes
      GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
      Vector vPCConcepts = new Vector();
      if (prop_condr_idseq != null && !prop_condr_idseq.equals(""))
        vPCConcepts = getAC.getAC_Concepts(prop_condr_idseq, null, true);
      
      if (vPCConcepts != null) 
      {
        session.setAttribute("vProperty", vPCConcepts);
        EVS_Bean m_PC = (EVS_Bean)vPCConcepts.elementAt(0);
        if (m_PC == null) m_PC = new EVS_Bean();
        m_DEC.setDEC_PROPL_NAME_PRIMARY(m_PC.getLONG_NAME());
        m_DEC.setDEC_PROP_CONCEPT_CODE(m_PC.getNCI_CC_VAL());
        m_DEC.setDEC_PROP_EVS_CUI_ORIGEN(m_PC.getEVS_DATABASE());

        // Secondary 
         for(int i=1;i<vPCConcepts.size();i++)
        {
            EVS_Bean m_PCQ = (EVS_Bean)vPCConcepts.elementAt(i);
            if (m_PCQ == null)
              m_PCQ = new EVS_Bean();        
            Vector vPropQualifierNames = m_DEC.getDEC_PROP_QUALIFIER_NAMES();
            if (vPropQualifierNames == null) vPropQualifierNames = new Vector();
            vPropQualifierNames.addElement(m_PCQ.getLONG_NAME());
            Vector vPropQualifierCodes = m_DEC.getDEC_PROP_QUALIFIER_CODES();
            if (vPropQualifierCodes == null) vPropQualifierCodes = new Vector();
            vPropQualifierCodes.addElement(m_PCQ.getNCI_CC_VAL());
            Vector vPropQualifierDB = m_DEC.getDEC_PROP_QUALIFIER_DB();
            if (vPropQualifierDB == null) vPropQualifierDB = new Vector(); 
            vPropQualifierDB.addElement(m_PCQ.getEVS_DATABASE());
            m_DEC.setDEC_PROP_QUALIFIER_NAMES(vPropQualifierNames);
            m_DEC.setDEC_PROP_QUALIFIER_CODES(vPropQualifierCodes);
            m_DEC.setDEC_PROP_QUALIFIER_DB(vPropQualifierDB);
            //if(vPropQualifierNames.size()>0)
             // m_DEC.setDEC_PROPERTY_QUALIFIER((String)vPropQualifierNames.elementAt(0));
        }
      } 
    }
  }
  
/**
   *
   * @param rep_condr_idseq  id of condr.
   * @param m_VD
   * @param sMenu
   *
   * @throws Exception
   * 
   */
  public void fillRepVectors(String rep_condr_idseq, VD_Bean m_VD, String sMenu)
  throws Exception
  { 
     if (m_VD != null)
    {
      HttpSession session = m_classReq.getSession();
      //get vd parent attributes
      GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
      Vector vRepConcepts = new Vector();
      if (rep_condr_idseq != null && !rep_condr_idseq.equals(""))
        vRepConcepts = getAC.getAC_Concepts(rep_condr_idseq, null, true);
        
      if (vRepConcepts != null) 
      {
        session.setAttribute("vRepTerm", vRepConcepts);
        EVS_Bean m_Rep = (EVS_Bean)vRepConcepts.elementAt(0);
        if (m_Rep == null) m_Rep = new EVS_Bean();
        m_VD.setVD_REP_NAME_PRIMARY(m_Rep.getLONG_NAME());
        m_VD.setVD_REP_CONCEPT_CODE(m_Rep.getNCI_CC_VAL());
        m_VD.setVD_REP_EVS_CUI_ORIGEN(m_Rep.getEVS_DATABASE());
        if(!sMenu.equals("NewVDTemplate") && !sMenu.equals("NewVDVersion"))
          m_VD.setVD_REP_IDSEQ(m_Rep.getIDSEQ());    
   
          // Secondary 
        for(int i=1; i<vRepConcepts.size();i++)
        {
          EVS_Bean m_RepQ = (EVS_Bean)vRepConcepts.elementAt(i);
          if (m_Rep == null) m_Rep = new EVS_Bean();        
          Vector vRepQualifierNames = m_VD.getVD_REP_QUALIFIER_NAMES();
          if (vRepQualifierNames == null) vRepQualifierNames = new Vector();
          vRepQualifierNames.addElement(m_RepQ.getLONG_NAME());
          Vector vRepQualifierCodes = m_VD.getVD_REP_QUALIFIER_CODES();
          if (vRepQualifierCodes == null) vRepQualifierCodes = new Vector();
          vRepQualifierCodes.addElement(m_RepQ.getNCI_CC_VAL());
          Vector vRepQualifierDB = m_VD.getVD_REP_QUALIFIER_DB();
          if (vRepQualifierDB == null) vRepQualifierDB = new Vector(); 
          vRepQualifierDB.addElement(m_RepQ.getEVS_DATABASE());
          m_VD.setVD_REP_QUALIFIER_NAMES(vRepQualifierNames);
          m_VD.setVD_REP_QUALIFIER_CODES(vRepQualifierCodes);
          m_VD.setVD_REP_QUALIFIER_DB(vRepQualifierDB);
        //  if(vRepQualifierNames.size()>0)
        //      m_VD.setVD_REP_QUAL((String)vRepQualifierNames.elementAt(0));
        }
      } 
    }
  }

 /**
   * @param condr_idseq.
   * @return sCUIString
   */
  public String getEVSIdentifierString(String condr_idseq)  // returns list of Data Element Concepts
  {
    String sCondr = condr_idseq;
    String sCUIString = "";
    String sCUI = "";
    try
    {
      if (sCondr != null && !sCondr.equals(""))
      {
        GetACService getAC = new GetACService(m_classReq, m_classRes, m_servlet);
        Vector vCon = getAC.getAC_Concepts(sCondr, null, false);
        if (vCon != null && vCon.size() > 0)
        {
          for (int j=0; j<vCon.size(); j++)
          {
            EVS_Bean bean = new EVS_Bean();
            bean = (EVS_Bean)vCon.elementAt(j);
            if(bean != null)
            {
              sCUI = bean.getNCI_CC_VAL();
              if(sCUI == null) sCUI = "";
              if (sCUIString.equals("")) 
                sCUIString = sCUI;
              else 
                sCUIString = sCUIString + ", " + sCUI;
            }
          }
        }
      }
    }
    catch(Exception e)
    {
      logger.fatal("ERROR - EVSSearch-getEVSIdentifierString for other : " + e.toString());
    } 
    return  sCUIString;
  }  //end getEVSIdentifierString
  
/**
   * 
   * @param dtsVocab  List of Vocabularies
   * @return vRoot vector of Root concepts
   */
public Vector putRootsInAlphabeticalOrder(List vocabRoots) 
{ 
  Vector vRoots = new Vector();
  String sRootName = "";
  boolean isSorted = false;
  int Swap = 0;
  if(vocabRoots != null && vocabRoots.size()>0)
  {
    for (int m = 0; m < vocabRoots.size(); m++)
    {
      DescLogicConcept aDescLogicConcept = (DescLogicConcept)vocabRoots.get(m);
      sRootName = aDescLogicConcept.getName();
      vRoots.addElement(sRootName);
    }
    do
    {
      String Temp = "";
      String Name1 = "";
      String Name2 = "";
      Swap = 0;
      for (int i = 0; i < vRoots.size()-1; i++)
      {
        Name1 = (String)vRoots.elementAt(i);
        Name2 = (String)vRoots.elementAt(i+1);
        try
        {
          if(ComparedValue("", Name1, Name2) > 0)
          {
            Temp = (String)vRoots.elementAt(i);
            vRoots.setElementAt(Name2,i);
            vRoots.setElementAt(Name1,i+1);
            Swap = 1;
          }
        }
        catch(Exception ee)
        {
          System.err.println("problem in EVSSearch-putRootsInAlphabeticalOrder: " + ee);
        }
      } 
    }while(Swap != 0);
  }
  return vRoots;
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
   * 
   * @param dtsVocab
   * @param codeOrNames
   * @return vRoot vector of Root concepts
   */
 public Vector getRootConcepts(String dtsVocab, boolean codeOrNames) 
{ 
 // System.err.println("in getRootConcepts dtsVocab: " + dtsVocab);
    Vector vRoot = new Vector();
     if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("") ||
     dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;   
    if (dtsVocab == null) dtsVocab = "";
    ApplicationService evsService =
      ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    
  try
  {
      EVSQuery query = new EVSQueryImpl();
      query.getRootConcepts(dtsVocab, true);
      List vocabRoots = null;
      String CCode = "";
      Vector vRoots = new Vector();
      try
      {
        vocabRoots = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        ex.printStackTrace();
      } 
      if(vocabRoots != null && vocabRoots.size()>0)
      {
        vRoots = putRootsInAlphabeticalOrder(vocabRoots);
        if(vRoots != null && codeOrNames == true)
        {
           for (int i = 0; i < vRoots.size(); i++)
          {
              vRoot.addElement(vRoots.elementAt(i));
          }
        }
        if(vRoots != null && codeOrNames != true)
        {
          for (int j = 0; j < vRoots.size(); j++)
          {
              EVSQuery query2 = new EVSQueryImpl(); 
              query2.getConceptCodeByName(dtsVocab,(String)vRoots.elementAt(j));
              List concepts2 = null;
              try
              {
                concepts2 = evsService.evsSearch(query2);
              }
              catch(Exception ex)
              {
                ex.printStackTrace();
              }
              if(concepts2 != null)
              {
                for (int m = 0; m < concepts2.size(); m++)
                {
                  CCode = (String)concepts2.get(0);
                  vRoot.addElement(CCode);
                }
              }
            }   
        }
      }
   }
  catch(Exception ee)
  {
    logger.fatal("ERROR - EVSSearch-getRootConcepts for Thesaurus : " + ee.toString());
     System.err.println("ERROR - EVSSearch-getRootConcepts: " + ee.toString());
  }
  evsService = null;
  return vRoot;
}   

/**
   * This method searches EVS vocabularies and returns subconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName the root concept.
   * @param type
   * @param conceptCode the root concept.
   * @param defSource
   *
 */
public Vector getSubConceptNames(String dtsVocab, String conceptName, String type, String conceptCode, String defSource) 
{
//System.err.println("getSubConceptNames conceptName: " + conceptName + " conceptCode: " + conceptCode + " dtsVocab: " + dtsVocab);
    String[] stringArray =  new String[10000];
    Vector vSub = new Vector();
     if(dtsVocab.equals("GO") && (conceptName.equals("double-strand break repair via homologous recombination ")
     || conceptName.equals("double-strand break repair via homologous recombination")))
    {
      conceptName = "double-strand break repair via homologous recombination_";
    }
     if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
     {
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
      conceptName = filterName(conceptName, "js");
     }
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    if(!dtsVocab.equals("NCI Metathesaurus"))
    {
     try
     {
        String prefName = "";
        if(type.equals("Immediate") || type.equals(""))
        {
          try
          {
            if(!conceptCode.equals("")) //try it with ConceptCode
            {
              try
              {
                query.getSubConcepts(dtsVocab,conceptCode,flagThree,flagTwo);
                subs = evsService.evsSearch(query);
              }
              catch(Exception ex)
              {
                System.out.println("error getSubConcepts");
              }  
              if(subs != null && subs.size()>0)
              {
                  for (int b = 0; b < subs.size(); b++)
                  {
                    stringArray[b] = (String)subs.get(b);
                    vSub.addElement((String)subs.get(b));
                  }
              }
            }
            else if(conceptName != null && !conceptName.equals(""))
            {    
              try
              {
                query.getSubConcepts(dtsVocab,conceptName,flagOne,flagTwo);
                subs = evsService.evsSearch(query);
              }
              catch(Exception ex)
              {
                ex.printStackTrace();
              } 
              if(subs != null && subs.size()>0)
              {
                for (int i = 0; i < subs.size(); i++)
                {
                  stringArray[i] = (String)subs.get(i);
                  vSub.addElement((String)subs.get(i));
                }
              } 
            }
            evsService = null;
          }
          catch(Exception ee)
          {
            System.err.println("problem0 in Thesaurus EVSSearch-getSubConceptNames: " + ee);
            stringArray = null;
          }
        }
        else if(type.equals("All"))
        {
          if(!conceptCode.equals(""))//try it with ConceptCode
          {
            try
            {
              query.getSubConcepts(dtsVocab,conceptCode,flagThree,flagTwo);
              subs = evsService.evsSearch(query);
            }
            catch(Exception ex)
            {
              ex.printStackTrace();
            }  
            if(subs != null && subs.size()>0)
            {
              for (int c = 0; c < subs.size(); c++)
              {
                stringArray[c] = (String)subs.get(c);
                vSub.addElement((String)subs.get(c));
              }
            }
          }
          else if(conceptName != null && !conceptName.equals(""))
          {
            try
            {
              query.getSubConcepts(dtsVocab,conceptName,flagOne,flagTwo);
              subs = evsService.evsSearch(query);
            }
            catch(Exception ex)
            {
              ex.printStackTrace();
            }  
            if(subs != null && subs.size()>0)
            {
              for (int i = 0; i < subs.size(); i++)
              {
                stringArray[i] = (String)subs.get(i);
                vSub.addElement((String)subs.get(i));
              }
            }
           }
          if(stringArray != null)
          {
             stringArray = getAllSubConceptNames(dtsVocab,stringArray, vSub);
          }
        }
      }
      catch(Exception ee)
      {
            System.err.println("problemYY in Thesaurus syn EVSSearch-getSubConcepts: " + ee);
            logger.fatal("ERROR - EVSSearch-getSubConcepts for Thesaurus : " + ee.toString());
            return vSub;
      }
    }
    else if(dtsVocab.equals("NCI Metathesaurus"))
    {
      try
      {
        if(!conceptCode.equals("") && !defSource.equals(""))
        {
        /*  MetaThesaurusConceptSearchCriteria mtcsc = new MetaThesaurusConceptSearchCriteria();
          MetaThesaurusConcept mtc = new MetaThesaurusConcept();
          MetaThesaurusConcept[] mtcChildren = mtc.getChildren(conceptCode,defSource);
          if(mtcChildren != null)
          {
            for(int a =0 ; a< mtcChildren.length; a++)
            {
              vSub.addElement(mtcChildren[a].getName());
            }
          } */
        }
      } 
      catch(Exception eef)
      {
            //System.err.println("problem in Thesaurus syn EVSSearch-getSubConceptsMeta: " + eef);
            logger.fatal("ERROR - EVSSearch-getSubConcepts for Thesaurus : " + eef.toString());
            return vSub;
      }
    } 
    evsService = null;
    return vSub;
 }
   
/**
   * This method searches EVS vocabularies and returns subconcepts, which are used
   * to construct an EVS Tree. 
   * @param String dtsVocab the EVS Vocabulary
   * @param String conceptName the root concept.
   * @param String type
   * @param conceptCode the root concept.
   * @param defSource
   *
 */
public Vector getSubConceptCodes(String dtsVocab, String conceptName, String type, String conceptCode, String defSource) 
{
    String[] stringArray =  new String[10000];
    Vector vSub = new Vector();
     if(dtsVocab.equals("GO") && (conceptName.equals("double-strand break repair via homologous recombination ")
     || conceptName.equals("double-strand break repair via homologous recombination")))
    {
      conceptName = "double-strand break repair via homologous recombination_";
    }
     if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
     {
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
      conceptName = filterName(conceptName, "js");
     }
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    Boolean flagFour = new Boolean(true); 
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    if(!dtsVocab.equals("NCI Metathesaurus"))
    {
     try
     {
        String prefName = "";
        if(type.equals("Immediate") || type.equals(""))
        {
          try
          {
            if(conceptCode != null && !conceptCode.equals(""))
            {
              try
              {
                query.getSubConcepts(dtsVocab,conceptCode,flagThree,flagFour);
                subs = evsService.evsSearch(query);
              }
              catch(Exception ex)
              {
                ex.printStackTrace();
              } 
              if(subs != null && subs.size()>0)
              {
                for (int i = 0; i < subs.size(); i++)
                {
                  stringArray[i] = (String)subs.get(i);
                  vSub.addElement((String)subs.get(i));
                }
              }
              else if(!conceptName.equals("")) //try it with ConceptName
              {
                try
                {
                  query.getSubConcepts(dtsVocab,conceptName,flagOne,flagTwo);
                  subs = evsService.evsSearch(query);
                }
                catch(Exception ex)
                {
                  ex.printStackTrace();
                }  
                if(subs != null && subs.size()>0)
                {
                //  stringArray = new String[subs.size()];
                  for (int b = 0; b < subs.size(); b++)
                  {
                    stringArray[b] = (String)subs.get(b);
                    vSub.addElement((String)subs.get(b));
                  }
                }
              }
            }
            evsService = null;
          }
          catch(Exception ee)
          {
            System.err.println("problem in Thesaurus EVSSearch-getSubConceptCodes: " + ee);
            stringArray = null;
          }
        }
        else if(type.equals("All"))
        {
          try
          {
            query.getSubConcepts(dtsVocab,conceptCode,flagThree,flagFour);
            subs = evsService.evsSearch(query);
          }
          catch(Exception ex)
          {
            System.out.println("Error EVSSearch-getSubConceptCodes: " + ex.toString());
          }  
          if(subs != null && subs.size()>0)
          {
            for (int i = 0; i < subs.size(); i++)
            {
              stringArray[i] = (String)subs.get(i);
               vSub.addElement((String)subs.get(i));
            }
          }
          else if(!conceptName.equals(""))//try it with ConceptName
          {
            try
            {
              query.getSubConcepts(dtsVocab,conceptName,flagOne,flagTwo);
              subs = evsService.evsSearch(query);
            }
            catch(Exception ex)
            {
              System.out.println("Error EVSSearch-getSubConceptCodes: " + ex.toString());
            }  
            if(subs != null && subs.size()>0)
            {
              for (int c = 0; c < subs.size(); c++)
              {
                stringArray[c] = (String)subs.get(c);
                vSub.addElement((String)subs.get(c));
              }
            }
          }
          if(stringArray != null)
          {
             stringArray = getAllSubConceptCodes(dtsVocab,stringArray, vSub);
          }
        }
      }
      catch(Exception ee)
      {
            System.err.println("problemYY in Thesaurus syn EVSSearch-getSubConceptCodes: " + ee);
            logger.fatal("ERROR - EVSSearch-getSubConceptCodes for Thesaurus : " + ee.toString());
            return vSub;
      }
    }
    else if(dtsVocab.equals("NCI Metathesaurus"))
    {
      try
      {
        if(!conceptCode.equals("") && !defSource.equals(""))
        {
        /*  MetaThesaurusConceptSearchCriteria mtcsc = new MetaThesaurusConceptSearchCriteria();
          MetaThesaurusConcept mtc = new MetaThesaurusConcept();
          MetaThesaurusConcept[] mtcChildren = mtc.getChildren(conceptCode,defSource);
          if(mtcChildren != null)
          {
            for(int a =0 ; a< mtcChildren.length; a++)
            {
              vSub.addElement(mtcChildren[a].getName());
            }
          } */
        }
      } 
      catch(Exception eef)
      {
            //System.err.println("problem in Thesaurus syn EVSSearch-getSubConceptsMeta: " + eef);
            logger.fatal("ERROR - EVSSearch-getSubConceptCodes for Thesaurus : " + eef.toString());
            return vSub;
      }
    } 
    evsService = null;
    return vSub;
 }
   


/**
   * For a referenced value domain, this method calculates how many levels down in
   * the heirarchy a subconcept is from the parent concept.
   * @param CCode
   * @param dtsVocab.
   *
*/
public int getLevelDownFromParent(String CCode, String dtsVocab) 
{ 
   int level = 0;
   String[] stringArrayInit = new String[20];
   String[] stringArray = null;
   ApplicationService evsService = null;
   java.util.Date exDate = new java.util.Date();          

   if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus";
    else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;
      
    Boolean flagOne = new java.lang.Boolean(true);
    Boolean flagTwo = new Boolean(true);
    String sParent = "";
    String sSuperConceptCode = "";
    int index = 0;
    int loopCheck = 0;
    String supName = "";
    HttpSession session = m_classReq.getSession();
    String sSearchAC = (String)session.getAttribute("creSearchAC");
    if(sSearchAC == null) sSearchAC = "";
    String matchParent = "false";
    if(sSearchAC.equals("ParentConceptVM"))
    {
      sParent = (String)session.getAttribute("ParentConceptCode");
      if(CCode.equals(sParent))
       matchParent = "true";
      if(sParent != null && !sParent.equals(""))
      {    
        while(matchParent.equals("false"))
        {
          loopCheck++;
          if(loopCheck>20) // exit gracefully from an infinite loop
          {
            level = 0;
            break;
          }
          try
          {
            if(CCode != null && !CCode.equals(""))
            {
              evsService =
              ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
              EVSQuery query = new EVSQueryImpl();
              query.getSuperConcepts(dtsVocab,CCode,flagOne,flagTwo);
              List supers = null;
              try
              {
                supers = evsService.evsSearch(query);
              }
              catch(Exception ex)
              {
                ex.printStackTrace();
              } 
              if(supers != null && supers.size()>0)
              {
                for (int i = 0; i < supers.size(); i++)
                {
                  supName = (String)supers.get(i);
                  if(supName != null && !supName.equals(""))
                    stringArrayInit[i] = supName;
                    index = i;
                }
                stringArray = new String[index+1];
                for (int k = 0; k < (index+1); k++)
                {
                  supName = stringArrayInit[k];
                  if(supName != null && !supName.equals(""))
                    stringArray[k] = stringArrayInit[k];
                }
              }
              evsService = null; 
            }
          }
          catch(Exception ee)
          {
              System.err.println("problem2 in Thesaurus EVSSearch-getLevelDownFromParent: " + ee);
              stringArray = null;
          }
          if(stringArray != null && stringArray.length == 1)  // == 1
          {
            level++;
            sSuperConceptCode = (String)stringArray[0];
            if(sSuperConceptCode.equals(sParent))
            {            
              matchParent = "true";
            }
            else
              CCode = sSuperConceptCode;
          }
          else if(stringArray != null && stringArray.length > 1)
          {
            level++;
            sSuperConceptCode = findThePath(dtsVocab, stringArray, sParent);
            if(sSuperConceptCode.equals(""))
              sSuperConceptCode = (String)stringArray[0];
            if(sSuperConceptCode.equals(sParent))
            {            
              matchParent = "true";
            }
            else
              CCode = sSuperConceptCode;
          } 
          else
              matchParent = "true";
        }
      }
    } 
    return level; 
}

/**
   * When getting superConcepts, sometimes more than one is returned in the superConcepts array. 
   * This method looks at each member of the array and checks which one leads up
   * to the parent concept, then returns the superconcept which leads up to parent
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param stringArray.
   * @param sParent 
   * @return sCorrectSuperConceptName
   *
*/
public String findThePath(String dtsVocab, String[] stringArray, String sParent) 
{
  Boolean flagOne = new java.lang.Boolean(false);
  Boolean flagTwo = new Boolean(false);
  String[] stringArray2 = null;
  String sSuperConceptName = "";
  String sCorrectSuperConceptName = "";
  String matchParent = "false";
  String prefName = "";  
  String prefNameCurrent = ""; 
  int index = 0;
  ApplicationService evsService = null;
  for(int j=0; j < stringArray.length; j++) 
  {
    matchParent = "false";
    prefName = (String)stringArray[j];
    prefNameCurrent = (String)stringArray[j];
    if(prefName != null && prefName.equals(sParent))
    {
       matchParent = "true";
       sCorrectSuperConceptName = prefName;
    }  
    while(matchParent.equals("false"))
    {
     try
     {
      if(prefName != null && !prefName.equals(""))
      {
        evsService =
        ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
        EVSQuery query = new EVSQueryImpl();
        query.getSuperConcepts(dtsVocab,prefName,flagOne,flagTwo);
        List supers = null;
        try
        {
          supers = evsService.evsSearch(query);
        }
        catch(Exception ex)
        {
          ex.printStackTrace();
        } 
        if(supers != null && supers.size()>0)
        {
          String supName = "";
          stringArray2 = new String[supers.size()];
          for (int i = 0; i < supers.size(); i++)
          {
            supName = (String)supers.get(i);
            if(supName != null && !supName.equals(""))
              stringArray2[i] = supName;
          }
        }
        else 
          break;
      }
      }
      catch(Exception ee)
      {
        stringArray2 = null;
      }
      if(stringArray2 != null && stringArray2.length > 0)  // == 1
      {
        sSuperConceptName = (String)stringArray2[0]; 
        if(sSuperConceptName.equals(sParent))
        {            
          matchParent = "true";
          sCorrectSuperConceptName = prefNameCurrent;
          break;
        }
        else
          prefName = sSuperConceptName;
      }
      else
          matchParent = "true";
    } 
  evsService = null;
  } 
  return sCorrectSuperConceptName;
}
   
/**
   * This method returns all subconcepts of a concept
   * @param dtsVocab the EVS Vocabulary
   * @param stringArray
   * @param vSub
   * @return stringArray
   *
*/
public String[] getAllSubConceptNames(String dtsVocab, String[] stringArray, Vector vSub) 
{ 
    String[] stringArray2 = null; 
    String[] stringArray3 = new String[10000];
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false);
    String getMoreSubConcepts = "";
    String  prefName = "";
  
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
   try
   {
    if(stringArray != null && stringArray.length>0)
    {
      for(int j=0; j < stringArray.length; j++) 
      {
       if(stringArray[j] != null)
       {
        if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
        || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
        {
           prefName = filterName(stringArray[j], "js");
        }
        else
        {
          prefName = stringArray[j];
        }
        try
        {
          query.getSubConcepts(dtsVocab,prefName,flagOne,flagTwo);
          subs = evsService.evsSearch(query);
          if(subs != null && subs.size()>0)
          {
            stringArray2 = new String[subs.size()];
            for (int i = 0; i < subs.size(); i++)
            {
              stringArray2[i] = (String)subs.get(i);
              vSub.addElement((String)subs.get(i));
            }
          }
          else
            stringArray2 = null;
        }
        catch(Exception ee)
        {
          System.err.println("problem2a in Thesaurus EVSSearch-getAllSubConceptNames: " + ee);
        }
        if(stringArray2 != null && stringArray2.length>0)
        {
          stringArray3 = getAllSubConceptNames(dtsVocab,stringArray2, vSub);
        } 
       }
      }
    }
  }
  catch(Exception f)
  {
    System.err.println("problem in Thesaurus EVSSearch-getAllSubConceptNames: " + f);
  }
    evsService = null;
    return stringArray;
} 

/**
   * This method returns all subconceptcodes of a concept
   * @param dtsVocab the EVS Vocabulary
   * @param stringArray
   * @param vSub
   * @return stringArray
   *
*/
public String[] getAllSubConceptCodes(String dtsVocab, String[] stringArray, Vector vSub) 
{ 
    String[] stringArray2 = null;  
    String[] stringArray3 = new String[10000];
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false);
    Boolean flagThree = new java.lang.Boolean(true);
    Boolean flagFour = new Boolean(true);
    String getMoreSubConcepts = "";
    String  prefCode = "";
  
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
   try
   {
    if(stringArray != null && stringArray.length>0)
    {
      for(int j=0; j < stringArray.length; j++) 
      {
       if(stringArray[j] != null)
       {
        prefCode = stringArray[j];
        try
        {
          query.getSubConcepts(dtsVocab,prefCode,flagThree,flagFour);
          subs = evsService.evsSearch(query);
          if(subs != null && subs.size()>0)
          {
            stringArray2 = new String[subs.size()];
            for (int i = 0; i < subs.size(); i++)
            {
              stringArray2[i] = (String)subs.get(i);
              vSub.addElement((String)subs.get(i));
            }
          }
          else
            stringArray2 = null;
        }
        catch(Exception ee)
        {
          System.err.println("problem2a in Thesaurus EVSSearch-getAllSubConceptCodes: " + ee);
        }
        if(stringArray2 != null && stringArray2.length>0)
        {
          stringArray3 = getAllSubConceptCodes(dtsVocab,stringArray2, vSub);
        }
       }
      }
    }
  }
  catch(Exception f)
  {
    System.err.println("problem3 in Thesaurus EVSSearch-getAllSubConceptCodes: " + f);
  }
    evsService = null;
    return stringArray;
} 
    
 /**
	 * Puts in and takes out "_"
   *  @param nodeName.
   *  @param type.
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
   * This method searches EVS vocabularies and returns superconcepts name of subconcepts
   * on level below concept in heirarchy
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName the root concept.
   * @param conceptCode
   * @param defSource
   * @return vSub
 */
public Vector getSuperConceptNamesImmediate(String dtsVocab, String conceptName, String conceptCode, String defSource) 
{

    String[] stringArray = new String[50];
    String[] stringArray2 = new String[50];
    Vector vSub = new Vector();
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus"; 
    else if(dtsVocab.equals("VA NDFRT")|| dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;
      
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      conceptName = filterName(conceptName, "js");
      
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false);  
    Boolean flagThree = new Boolean(true);  
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
    if(!conceptCode.equals(""))
       query.getSuperConcepts(dtsVocab,conceptCode,flagThree,flagTwo);
    else if(!conceptName.equals(""))
       query.getSuperConcepts(dtsVocab,conceptName,flagOne,flagTwo);
  
    List subs = null;
    try
    {
      subs = evsService.evsSearch(query);
    }
    catch(Exception ex)
    {
      ex.printStackTrace();
    } 
    if(subs != null && subs.size()>0)
    {
      for (int i = 0; i < subs.size(); i++)
      {
        if(!vSub.contains(subs.get(i)))
          vSub.addElement((String)subs.get(i));
      }
    }
    evsService = null;
    return vSub;
 } 

/**
   * This method searches EVS vocabularies and returns superconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName.
   * @param conceptCode
   * @param defSource
   * @return vSub
 */
public Vector getSuperConceptNames(String dtsVocab, String conceptName, String conceptCode, String defSource) 
{
    String[] stringArray = new String[50];
    String[] stringArray2 = new String[50];
    Vector vSub = new Vector();
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      dtsVocab = m_servlet.m_VOCAB_NCI; //"NCI_Thesaurus"; 
    else if(dtsVocab.equals("VA NDFRT")|| dtsVocab.equals("VA_NDFRT"))
      dtsVocab = m_servlet.m_VOCAB_VA;  //"VA_NDFRT";
    else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_VISUAL_ANATOMIST"))
      dtsVocab = m_servlet.m_VOCAB_UWD;  //"UWD_Visual_Anatomist";
    else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) 
      dtsVocab = m_servlet.m_VOCAB_MGE;  //"MGED_Ontology";
    else if(dtsVocab.equals("GO"))
      dtsVocab = m_servlet.m_VOCAB_GO;
    else if(dtsVocab.equals("LOINC"))
      dtsVocab = m_servlet.m_VOCAB_LOI;
    else if(dtsVocab.equals("MedDRA"))
      dtsVocab = m_servlet.m_VOCAB_MED;
    else if(dtsVocab.equals("HL7_V3")) 
      dtsVocab = m_servlet.m_VOCAB_HL7;
      
    if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("")
     || dtsVocab.equals("NCI Thesaurus") || dtsVocab.equals("NCI_Thesaurus"))
      conceptName = filterName(conceptName, "js");
      
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
   
    // Now get superConcepts
    List sups = null;
    if(!conceptCode.equals(""))//try it with ConceptCode
    {
      try
      {
        query.getSuperConcepts(dtsVocab,conceptCode,flagThree,flagTwo);
        sups = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        System.out.println("Error in EVSSearch getSuperConceptNames: " + ex.toString());
      }  
      if(sups != null && sups.size()>0)
      {
        for (int c = 0; c < sups.size(); c++)
        {
          stringArray[c] = (String)sups.get(c);
          if(!vSub.contains(sups.get(c)))
            vSub.addElement((String)sups.get(c));
        }
        stringArray2 = getAllSuperConceptNames(dtsVocab,stringArray, vSub);
      }
    }
    else if(!conceptName.equals(""))
    {
      query.getSuperConcepts(dtsVocab,conceptName,flagOne,flagTwo);
      try
      {
        sups = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        System.out.println("Error in EVSSearch getSuperConceptNames: " + ex.toString());
      } 
      if(sups != null && sups.size()>0)
      {
        for (int i = 0; i < sups.size(); i++)
        {
          if(!vSub.contains((String)sups.get(i)))
          {
            if(!vSub.contains(sups.get(i)))
              vSub.addElement((String)sups.get(i));
            stringArray[i] = (String)sups.get(i);
          }
        }
        stringArray2 = getAllSuperConceptNames(dtsVocab,stringArray, vSub);
      }
    }
    evsService = null;
    return vSub;
 } 
 
 
/**
   * This method returns all superconceptnames of a concept
   * @param dtsVocab the EVS Vocabulary
   * @param stringArray
   * @param vSub
   * @return vSub
   *
*/
public String[] getAllSuperConceptNames(String dtsVocab, String[] stringArray, Vector vSub) 
{ 
    String[] stringArray2 = new String[60];
    String[] stringArray3 = null;
    String[] stringArray4 = null;
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false);
   
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    int index = 0;
    if(stringArray != null && stringArray.length>0)
    {
      try
      {
        for (int j = 0; j < stringArray.length; j++)
        {
          if(stringArray[j] != null)
          {
            if(!vSub.contains(stringArray[j]))
              vSub.addElement(stringArray[j]);
            query.getSuperConcepts(dtsVocab,stringArray[j],flagOne,flagTwo);
            subs = evsService.evsSearch(query);
            if(subs != null && subs.size()>0)
            {
              for (int i = 0; i < subs.size(); i++)
              {
                stringArray2[index] = (String)subs.get(i);
                if(!vSub.contains(stringArray2[index]))
                  vSub.addElement(stringArray2[index]);
                index++;
              }
            }
          }
        }
      }
      catch(Exception ee)
      {
        System.err.println("problem2a in Thesaurus EVSSearch-getAllSuperConceptNames: " + ee);
        stringArray2 = null;
      }
      // See how many non-null names there are
      int index2 = 0;
      for (int m = 0; m < stringArray2.length; m++)
      {
          if(stringArray2[m] != null)
            index2++;
      }
      if(index2 > 0)
      {
        int index3 = 0;
        // create a string array of just the right size
        stringArray4 = new String[index2];
        for (int n = 0; n < stringArray2.length; n++)
        {
          if(stringArray2[n] != null)
          {
            stringArray4[index3] = stringArray2[n];
            index3++;
          }
        }
      }
      if(stringArray4 != null && stringArray4.length>0)
      {
        stringArray3 = getAllSuperConceptNames(dtsVocab,stringArray4, vSub);
      }
    }   
    evsService = null;
    return stringArray;
} 

/** 
  *  The EVS API returns def source from Thesaurus inside of xml tags <>. This methods
  *  extracts the def source from the tags
  *  @param termStr.
  *  @return source
  *
  */
public String getSource(String termStr) 
{
   String source = "";
try
{
  int length = 0;  //<def-source>,  <def-definition>
  length = termStr.length();
  int iStartDefSource = 0;
  int iEndDefSource = 0;
  if(length > 0)
  {
    iStartDefSource = termStr.lastIndexOf("<def-source>");
    iEndDefSource = termStr.indexOf("</def-source>");
    source = termStr.substring(iStartDefSource, iEndDefSource);     
  }
}
catch(Exception ee)
{
  System.err.println("problem in Thesaurus syn EVSSearch-getSource: " + ee);
  logger.fatal("ERROR - EVSSearch-getSource for Thesaurus : " + ee.toString());
  return source;
}
return source;
}

/** 
  *  The EVS API returns definitions from Thesaurus inside of xml tags <>. This methods
  *  extracts the definition from the tags
  *  @param String termStr.
  *  @return definition
  *
  */
public String getDefinition(String termStr) 
{
   String definition = "";
try
{
  int length = 0;  //<def-source>,  <def-definition>
  length = termStr.length();
  int iStartDef = 0;
  int iEndDef = 0;
 
  if(length > 0)
  {
    iStartDef = termStr.lastIndexOf("<def-definition>");
    iEndDef = termStr.indexOf("</def-definition>");
      definition = termStr.substring(iStartDef, iEndDef);   
  }
}
catch(Exception ee)
{
  System.err.println("problem in Thesaurus syn EVSSearch-getDefinition: " + ee);
  logger.fatal("ERROR - EVSSearch-getDefinition for Thesaurus : " + ee.toString());
  return definition;
}
return definition;
}
      
 /**
   * To trim "Source => Name:" from Definition Source.
   *
   * @param termStr.
   *
  */
 private String trimDefSource(String termStr)
 {
    int length = 0;
    length = termStr.length();
    // Take off "," form end of term
    String strLastLetter = termStr.substring(length-2, length-1);
    if(strLastLetter.equals(","))
      termStr = termStr.substring(0, length-2);
    // Take off opening phrase
    if(length > 17)
    {
      length = termStr.length();
      String strOpeningPhrase = termStr.substring(0,16);
      if(strOpeningPhrase.equals("Source => Name: "))
        termStr = termStr.substring(16, length);
    }
    return termStr;
  }
 
   /**
   * To get final result vector of selected attributes/rows to display for Object Class component,
   * called from getACKeywordResult, getACSortedResult and getACShowResult methods.
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the OCBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   * @param vResult output result vector.
   * @param refresh
   *
   */
  public void get_Result(HttpServletRequest req, HttpServletResponse res,
         Vector vResult, String refresh)
  {
    Vector vOC = new Vector();
    try
    {
      HttpSession session = req.getSession();
      String menuAction = (String)session.getAttribute("MenuAction");
      Vector vSearchASL = new Vector();
     
      boolean bName = false;
      boolean bDefinition = false;
      boolean bContext = false;
      boolean bComments = false;
      boolean bDefSource = false;
      boolean bPublicID = false;
      boolean bEVSID = false;
      boolean bLevel = false;
      boolean bDB = false;
      boolean bDBComp = false;
      boolean bDECUsing = false;
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate") || menuAction.equals("BEDisplay"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

      if (vSelAttr != null)
      {
        for (int i =0; i < vSelAttr.size(); i++)
        {
          String sAttr = (String)vSelAttr.elementAt(i);
          if (sAttr.equals("Concept Name"))
            bName = true;
          else if (sAttr.equals("Definition"))
            bDefinition = true;
          else if (sAttr.equals("Definition Source"))
            bDefSource = true;
          else if (sAttr.equals("Context") || sAttr.equals("Owned By"))
            bContext = true;
          else if (sAttr.equals("EVS Identifier") || refresh.equals("DEF"))
            bEVSID = true;
          else if (sAttr.equals("Public ID"))
            bPublicID = true;
          else if (sAttr.equals("Vocabulary"))
            bDB = true;
          else if (sAttr.equals("caDSR Component"))
            bDBComp = true;
          else if (sAttr.equals("DEC's Using"))
            bDECUsing = true;
          else if (sAttr.equals("Level"))
            bLevel = true;
          else if (sAttr.equals("Comments"))
            bComments = true;
        }
      }
      vOC = (Vector)session.getAttribute("vACSearch");
      Vector vRSel = new Vector();  
      if (menuAction.equals("searchForCreate")) //|| menuAction.equals("BEDisplay")) 
        vRSel = (Vector)session.getAttribute("vACSearch");    //from selected rows   //null;
      else
        vRSel = (Vector)session.getAttribute("vSelRows");    //from selected rows   //null;
      if(vRSel == null) vRSel = new Vector();
      Integer recs = new Integer(0);
      if(vRSel.size()>0)
       recs = new Integer(vRSel.size());
      String recs2 = "";
      if(recs != null)
        recs2 = recs.toString();
      String sKeyword = "";
      if (menuAction.equals("searchForCreate") || menuAction.equals("BEDisplay"))
      {
         req.setAttribute("creRecsFound", recs2);
         sKeyword = (String)session.getAttribute("creKeyword");
      }
      else
      {     
          req.setAttribute("recsFound", recs2);
          sKeyword = (String)session.getAttribute("serKeyword");
      }
      if (sKeyword == null) sKeyword = "";
      String sSearchAC = "";
      String sSelectedParent = "";
      if(menuAction.equals("searchForCreate"))
      {
        sSearchAC = (String)session.getAttribute("creSearchAC");
        sSelectedParent = (String)session.getAttribute("SelectedParent");
        if(sSelectedParent == null) sSelectedParent = "";
      }
      else
        sSearchAC = (String)session.getAttribute("searchAC");
      if (sSearchAC.equals("EVSValueMeaning") || sSearchAC.equals("ParentConceptVM") 
          || sSearchAC.equals("ValueMeaning") || sSearchAC.equals("CreateVM_EVSValueMeaning")) 
        sSearchAC = "Value Meaning";
     
      Vector vSearchID = new Vector();
      Vector vSearchName = new Vector();
      Vector vSearchLongName = new Vector();
      Vector vSearchDefinition = new Vector();
      Vector vSearchDefSource = new Vector();
      Vector vSearchDatabase = new Vector();
      Vector vCCode = new Vector();
      Vector vCCodeDB = new Vector();
      String evsDB = "";
      String umlsCUI = "";
      String tempCUI = "";
      String ccode = "";
      for(int i=0; i<(vRSel.size()); i++)
      {
        EVS_Bean OCBean = new EVS_Bean();
        OCBean = (EVS_Bean)vRSel.elementAt(i);
        evsDB = OCBean.getEVS_DATABASE();
        umlsCUI = OCBean.getUMLS_CUI_VAL();
        tempCUI = OCBean.getTEMP_CUI_VAL();
        ccode = OCBean.getNCI_CC_VAL();
        String sLevel = "";
        int iLevel = OCBean.getLEVEL();
        Integer Int = new Integer(iLevel);
        if(Int != null)
          sLevel = Int.toString();
        vSearchID.addElement(OCBean.getIDSEQ());
        vSearchName.addElement(OCBean.getLONG_NAME());
        vSearchLongName.addElement(OCBean.getLONG_NAME());
//System.out.println("get_Result long name: " + OCBean.getLONG_NAME());
        vSearchDefinition.addElement(OCBean.getPREFERRED_DEFINITION());
        vSearchDefSource.addElement(OCBean.getEVS_DEF_SOURCE());
        vSearchDatabase.addElement(OCBean.getEVS_DATABASE());
        vCCode.addElement(OCBean.getNCI_CC_VAL());
        vCCodeDB.addElement(evsDB);
        if (bName == true || refresh.equals("DEF")) vResult.addElement(OCBean.getLONG_NAME());
        if (bPublicID == true) vResult.addElement(OCBean.getID());
        if (bEVSID == true) vResult.addElement(OCBean.getNCI_CC_VAL());
        if (bDefinition == true || refresh.equals("DEF")) vResult.addElement(OCBean.getPREFERRED_DEFINITION());
        if (bDefSource == true || refresh.equals("DEF")) vResult.addElement(OCBean.getEVS_DEF_SOURCE());
        if (bContext == true && !refresh.equals("DEF")) vResult.addElement(OCBean.getCONTEXT_NAME());
        if (bComments == true) vResult.addElement(OCBean.getCOMMENTS());
        if (bDB == true || refresh.equals("DEF")) vResult.addElement(OCBean.getEVS_DATABASE());
        if (bDBComp == true) vResult.addElement(OCBean.getcaDSR_COMPONENT());
        if (bDECUsing == true) vResult.addElement(OCBean.getDEC_USING());
        if (bLevel == true) vResult.addElement(sLevel);
      }
      if (sSearchAC.equals("PropertyClass")) 
        sSearchAC = "Property";
      else if (sSearchAC.equals("ObjectClass"))
        sSearchAC = "Object Class";
      else if (sSearchAC.equals("Property"))
        sSearchAC = "Property";
      else if (sSearchAC.equals("ObjectQualifier"))
        sSearchAC = "Object Qualifier";
      else if (sSearchAC.equals("PropertyQualifier"))
        sSearchAC = "Property Qualifier";
      else if (sSearchAC.equals("RepQualifier"))
        sSearchAC = "Rep Qualifier";
      else if (sSearchAC.equals("RepTerm"))
        sSearchAC = "Rep Term";
        
      if(evsDB.equals("NCI_Thesaurus") || evsDB.equals("Thesaurus/Metathesaurus"))
        sKeyword = filterName(sKeyword, "display");
      if (!sSearchAC.equals("ParentConcept"))
        req.setAttribute("labelKeyword", sSearchAC + " - " + sKeyword);   //make the label
      else if (sSearchAC.equals("ParentConcept"))
        req.setAttribute("labelKeyword", " - " + sKeyword);
 //System.out.println("get_Result sSearchAC: " + sSearchAC + " sKeyword: " + sKeyword);       
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      session.setAttribute("SearchLongName", vSearchLongName);
      session.setAttribute("SearchDefinition", vSearchDefinition);
      session.setAttribute("SearchDefSource", vSearchDefSource);
      session.setAttribute("SearchDatabase", vSearchDatabase);
      session.setAttribute("vCCode", vCCode);
      session.setAttribute("vCCodeDB", vCCodeDB);
       // for Back button, put search results and attributes on a stack
      if(sSearchAC.equals("Object Class"))
        sSearchAC = "ObjectClass";
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        serAC.stackSearchComponents(sSearchAC, vOC, vRSel, vSearchID, vSearchName,
        vResult, vSearchASL, vSearchLongName);
    }
    catch(Exception e)
    {
      System.err.println("ERROR in EVSSearch-get_Result: " + e);
      logger.fatal("ERROR in EVSSearch-get_Result : " + e.toString());
    }
  }

  
  /**
   * gets the non evs parent from reference documents table for the vd
   * @param sParent
   * @param sCui
   * @return PageVD
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
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
      serAC.doRefDocSearch(PageVD.getVD_VD_IDSEQ(), "META_CONCEPT_SOURCE");
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
   * makes the comma delimited context name for used by contexts
   * @param sUsed
   * @param desContext
   * @return subUsed
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
   * @return isHeader
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
   * To get final result vector of selected attributes/rows to display for Rep Term component,
   * gets the selected attributes from session vector 'selectedAttr'.
   * loops through the RepBean vector 'vACSearch' and adds the selected fields to result vector.
   *
   * @param req The HttpServletRequest object.
   * @param res HttpServletResponse object.
   *
   */
  public void getMetaSources(HttpServletRequest req, HttpServletResponse res)
  {
    Vector vMetaSources = new Vector();
    HttpSession session = req.getSession();
    ArrayList vMetaSrc = null;
    String source = "";
    ApplicationService evsService =
    ApplicationService.getRemoteInstance(m_servlet.m_EVS_CONNECT);
    EVSQuery query = new EVSQueryImpl(); 
    query.getMetaSources(); 
    List concepts = null;
    try
    {
      concepts = evsService.evsSearch(query);
    }
    catch(Exception ex)
    {
          ex.printStackTrace();
    }
    if(concepts != null)
    {
      MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
      for (int i = 0; i < concepts.size(); i++)
      {
        Source mSource = null;
        mSource = (Source)concepts.get(i);
        source = mSource.getAbbreviation();
        vMetaSources.addElement(source);
      }      
    }
  evsService = null;
  session.setAttribute("MetaSources", vMetaSources); 
  }
//close the class
} 
