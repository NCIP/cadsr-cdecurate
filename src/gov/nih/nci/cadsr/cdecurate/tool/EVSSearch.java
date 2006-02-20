// Copyright (c) 2000 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVSSearch.java,v 1.4 2006-02-20 20:52:59 hardingr Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
import java.util.*;
import javax.servlet.http.*;

import gov.nih.nci.system.applicationservice.*;
import gov.nih.nci.evs.domain.*;
import gov.nih.nci.evs.query.*;

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
  private static final long serialVersionUID = 1606675727846409378L;
  NCICurationServlet m_servlet = null;
  HttpServletRequest m_classReq = null;
  HttpServletResponse m_classRes = null;
  UtilService m_util = new UtilService();
  ApplicationService evsService = null;
  EVS_UserBean m_eUser = null;
  EVS_Bean m_eBean = null;
  Logger logger = Logger.getLogger(EVSSearch.class.getName());

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
    //get application service object
    HttpSession session = (HttpSession)m_classReq.getSession();
    m_eBean = new EVS_Bean();
    m_eUser = (EVS_UserBean)session.getAttribute("EvsUserBean");
    if (m_eUser == null) m_eUser = new EVS_UserBean(); //to be safe use the default props
    if (m_eUser.getEVSConURL() != null && !m_eUser.getEVSConURL().equals(""))
      evsService = ApplicationService.getRemoteInstance(m_eUser.getEVSConURL());
  }

    /**
   * does evs code search
   * @param prefName string to search for
   * @param dtsVocab string selected vocabulary name
   * @return string of evs code
   */
  public String do_getEVSCode(String prefName, String dtsVocab) 
  {
    if(prefName == null || prefName.equals(""))
      return "";
    //check if valid dts vocab
    if (dtsVocab == null) dtsVocab = "";
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");    
    String CCode = ""; 
    if (!dtsVocab.equals("MetaValue"))
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
        logger.fatal("Error do_getEVSCode query: " + ex.toString());
      } 
      if(codes.size()>0)
        CCode = (String)codes.get(0);
    }
    else
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
        logger.fatal("Error do_getEVSCode: " + ex.toString());
      }
      if(codes2 != null)
      {
        MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
        for (int i = 0; i < codes2.size(); i++)
        {
          aMetaThesaurusConcept = (MetaThesaurusConcept)codes2.get(i);
          CCode = (String)aMetaThesaurusConcept.getCui();
          //logger.debug(prefName + " meta ccode " + CCode);
        }
      }
    }
    return CCode;
  }

  /**
   * does evs code search
   * @param CCode string to search for
   * @param dtsVocab string selected vocabulary name
   * @return string of evs code
   */
  public String do_getConceptName(String CCode, String dtsVocab) 
  {
      //check if valid dts vocab
    if (dtsVocab == null) dtsVocab = "";
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    String sConceptName = ""; 
    if(!dtsVocab.equals("MetaValue"))
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
        logger.fatal("Error do_EVSSearch: " + ex.toString());
      }
      if(concepts != null && concepts.size()>0)
        sConceptName = (String)concepts.get(0);
    }
    else  // if(dtsVocab.equals("NCI Metathesaurus"))
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
        logger.fatal("Error do_EVSSearch Meta: " + ex.toString());
      }
      if(concepts2 != null)
      {
        MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
        aMetaThesaurusConcept = (MetaThesaurusConcept)concepts2.get(0);
        sConceptName = (String)aMetaThesaurusConcept.getName();
      }    
    }
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
  @SuppressWarnings("unchecked") public void fillOCVectors(String oc_condr_idseq, DEC_Bean m_DEC, String sMenu)
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
        }
      } 
    }
  }

 /**
   * @param condr_idseq 
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
   * sorts the dlc objects
   * @param vocabRoots list of vocabsroots
   * @return sort list of vocab roots
   */
  public List sortDLCObjects(List vocabRoots) 
  { 
    int Swap = 0;
    if(vocabRoots != null && vocabRoots.size()>0)
    {
      do
      {
        DescLogicConcept dlc1 = new DescLogicConcept();
        DescLogicConcept dlc2 = new DescLogicConcept();
        DescLogicConcept dlcT = new DescLogicConcept();
        Swap = 0;
        for (int m = 0; m < vocabRoots.size()-1; m++)
        {
          dlc1 = (DescLogicConcept)vocabRoots.get(m);
          dlc2 = (DescLogicConcept)vocabRoots.get(m+1);
          String name1 = dlc1.getName();
          String name2 = dlc2.getName();
          try
          {
            if (ComparedValue("", name1, name2) > 0)
            {
              dlcT = dlc1;
              vocabRoots.set(m, dlc2);
              vocabRoots.set(m+1, dlc1);
              Swap = 1;
            }
          }
          catch(Exception ee)
          {
            logger.fatal("problem in EVSSearch-SortDLCObject: " + ee);
          }
        }
      } while (Swap != 0);
    }
    return vocabRoots;
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
      //compare the names
      return firstName.compareToIgnoreCase(SecondName);
  }
  
  
  /**
   * 
   * @param dtsVocab
   * @return vRoot vector of Root concepts
   */
   public List getRootConcepts(String dtsVocab)  //, boolean codeOrNames) 
  { 
    List vocabRoots = null;
    //check if valid dts vocab
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    try
    {
      if (!dtsVocab.equals("MetaValue"))  //not for meta
      {   
        EVSQuery query = new EVSQueryImpl();
        query.getRootConcepts(dtsVocab, true);  //define query
        vocabRoots = evsService.evsSearch(query); //call api
        if(vocabRoots != null && vocabRoots.size()>0)
          vocabRoots = this.sortDLCObjects(vocabRoots);
      }
    }
    catch(Exception ee)
    {
      logger.fatal("ERROR - EVSSearch-getRootConcepts : " + ee.toString());
      System.err.println("ERROR - EVSSearch-getRootConcepts: " + ee.toString());
    }
    return vocabRoots;
  } 

  /**
   * This method searches EVS vocabularies and returns subconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName the root concept.
   * @param type
   * @param conceptCode the root concept.
   * @param defSource
   * @return vector of concept objects
   *
   */
  public Vector getAllSubConceptCodes(String dtsVocab, String conceptName, String type, String conceptCode, String defSource) 
  {
//logger.debug("getAllSubConceptCodes conceptName: " + conceptName);
    String[] stringArray =  new String[10000];
    Vector vSub = new Vector();
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");   //check if valid dts vocab 
    if(!dtsVocab.equals("MetaValue"))
    {      
      try
      {
          String prefName = "";
          if(!conceptCode.equals(""))//try it with ConceptCode
          {
            try
            {
              query.getAllSubConceptCodes(dtsVocab,conceptCode);
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
//  System.out.println("All subconcept codes: " + stringArray[c]);
                vSub.addElement((String)subs.get(c));
              }
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
    return vSub;
  }

  /**
   * This method searches EVS vocabularies and returns subconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName the root concept.
   * @param type
   * @param conceptCode the root concept.
   * @param defSource
   * @return vector of concept objects
   *
   */
  public Vector getSubConceptNames(String dtsVocab, String conceptName, String type, String conceptCode, String defSource) 
  {
    String[] stringArray =  new String[10000];
    Vector vSub = new Vector();
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    //check if valid dts vocab
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    if(!dtsVocab.equals("MetaValue"))  
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
                logger.fatal("error getSubConcepts");
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
           // evsService = null;
          }
          catch(Exception ee)
          {
            logger.fatal("problem0 in Thesaurus EVSSearch-getSubConceptNames: " + ee);
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
             stringArray = getAllSubConceptNames(dtsVocab,stringArray, vSub);
        }
      }
      catch(Exception ee)
      {
        System.err.println("problemYY in Thesaurus syn EVSSearch-getSubConcepts: " + ee);
        logger.fatal("ERROR - EVSSearch-getSubConcepts for Thesaurus : " + ee.toString());
        return vSub;
      }
    }
    return vSub;
 }
   
/**
   * This method searches EVS vocabularies and returns subconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab String the EVS Vocabulary
   * @param conceptName String the root concept.
   * @param type String 
   * @param conceptCode the root concept.
   * @param defSource
   * @return Vector of concept objectgs
   *
 */
public Vector getSubConceptCodes(String dtsVocab, String conceptName, String type, String conceptCode, String defSource) 
{
    String[] stringArray =  new String[10000];
    Vector vSub = new Vector();
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    Boolean flagFour = new Boolean(true); 
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    if(!dtsVocab.equals("MetaValue"))  
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
           // evsService = null;
          }
          catch(Exception ee)
          {
            logger.fatal("problem in Thesaurus EVSSearch-getSubConceptCodes: " + ee);
            stringArray = null;
          }
        }
        if(type.equals("All"))
        {
          String sCode = "";
          String sDefSource = (String)m_classReq.getParameter("defSource");
          if(sDefSource == null) sDefSource = "";
          vSub = this.getAllSubConceptCodes(dtsVocab, conceptName, "All", conceptCode, sDefSource);
        }
      }
      catch(Exception ee)
      {
            System.err.println("problemYY in Thesaurus syn EVSSearch-getSubConceptCodes: " + ee);
            logger.fatal("ERROR - EVSSearch-getSubConceptCodes for Thesaurus : " + ee.toString());
            return vSub;
      }
    } 
    return vSub;
 }


/**
   * For a referenced value domain, this method calculates how many levels down in
   * the heirarchy a subconcept is from the parent concept
   * @param CCode stirng code id
   * @param dtsVocab string of vocab name
   * @return int level
*/
public int getLevelDownFromParent(String CCode, String dtsVocab) 
{ 
 //System.out.println("do_EVSSEarch getLevelDownFromParent");
   int level = 0;
   //check if valid dts vocab and get out if meta search
   dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
   if (!dtsVocab.equals("MetaValue")) return level;
   
   String[] stringArrayInit = new String[20];
   String[] stringArray = null;
   java.util.Date exDate = new java.util.Date();          
      
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
            }
          }
          catch(Exception ee)
          {
              logger.fatal("problem2 in Thesaurus EVSSearch-getLevelDownFromParent: " + ee);
              stringArray = null;
          }
          if(stringArray != null && stringArray.length == 1)  // == 1
          {
            level++;
            sSuperConceptCode = (String)stringArray[0];
 // System.out.println("do_EVSSEarch getLevelDownFromParent sSuperConceptCode0: " + sSuperConceptCode);
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
 // System.out.println("do_EVSSEarch getLevelDownFromParent FTP sSuperConceptCode1: " + sSuperConceptCode);
            if(sSuperConceptCode.equals(""))
              sSuperConceptCode = (String)stringArray[0];
 // System.out.println("do_EVSSEarch getLevelDownFromParent FTP sSuperConceptCode2: " + sSuperConceptCode);
            if(sSuperConceptCode.equals(sParent))
            {            
              matchParent = "true";
            }
            else if(!sSuperConceptCode.equals(""))
              CCode = sSuperConceptCode;
            else if(sSuperConceptCode.equals(""))
              matchParent = "true"; //stringArray[0] == ""
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
   * @param stringArray array of string
   * @param sParent 
   * @return sCorrectSuperConceptCode
   *
  */
 public String findThePath(String dtsVocab, String[] stringArray, String sParent) 
  {
    Boolean flagOne = new java.lang.Boolean(true);
    Boolean flagTwo = new Boolean(false);
    String[] stringArray2 = null;
    String sSuperConceptCode = "";
    String sCorrectSuperConceptCode = "";
    String matchParent = "false";
    String prefName = "";  
    String prefNameCurrent = ""; 
    int index = 0;
   //check if valid dts vocab and get out if meta search
   dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
   if (dtsVocab.equals("MetaValue")) return "";
   
  for(int j=0; j < stringArray.length; j++) 
  {
    matchParent = "false";
    prefName = (String)stringArray[j];
    prefNameCurrent = (String)stringArray[j];
    if(prefName != null && prefName.equals(sParent))
    {
       matchParent = "true";
       sCorrectSuperConceptCode = prefName;
    }  
    while(matchParent.equals("false"))
    {
     try
     {
      if(prefName != null && !prefName.equals(""))
      {
        EVSQuery query = new EVSQueryImpl();
//  System.out.println("findThePath dtsVocab: " + dtsVocab + " prefName: " + prefName + " stringArray.length: " + stringArray.length);
        query.getSuperConcepts(dtsVocab,prefName,flagOne,flagOne);
        List supers = null;
        try
        {
          supers = evsService.evsSearch(query);
        }
        catch(Exception ex)
        {
          logger.fatal("ERROR findThePath: " + ex.toString());
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
      if(stringArray2 != null && stringArray2.length == 1)
      {
        sSuperConceptCode = (String)stringArray2[0]; 
        if(sSuperConceptCode.equals(sParent))
        {            
          matchParent = "true";
          sCorrectSuperConceptCode = prefNameCurrent;
          break;
        }
        else
          prefName = sSuperConceptCode;
      }
      else if(stringArray2 != null && stringArray2.length > 1)  // == 1
      {
        for (int i = 0; i < stringArray2.length; i++)
        {
          sSuperConceptCode = (String)stringArray2[i]; 
          if(sSuperConceptCode.equals(sParent))
          {            
            matchParent = "true";
            sCorrectSuperConceptCode = prefNameCurrent;
            break;
          }
        }
        if(matchParent.equals("false"))
        {
            prefName = findThePath(dtsVocab, stringArray2, sParent);
            if(prefName.equals(""))
              matchParent = "true"; // stop the loop
        }
      }
      else  // stringArray2.length == 0
          matchParent = "true";
    } 
  } 
  return sCorrectSuperConceptCode;
}
   
/**
   * This method returns all subconcepts of a concept
   * @param dtsVocab the EVS Vocabulary
   * @param stringArray array of strings
   * @param vSub vector of subs
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
    EVSQuery query = new EVSQueryImpl();
    List subs = null;
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    if(dtsVocab.equals("MetaValue")) return stringArray; 
   try
   {
    if(stringArray != null && stringArray.length>0)
    {
      for(int j=0; j < stringArray.length; j++) 
      {
       if(stringArray[j] != null)
       {
          prefName = stringArray[j];
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
          logger.fatal("problem2a in Thesaurus EVSSearch-getAllSubConceptNames: " + ee);
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
    logger.fatal("problem in Thesaurus EVSSearch-getAllSubConceptNames: " + f);
  }
   // evsService = null;
    return stringArray;
} 

 /**
	 *  Puts in and takes out "_"
   *  @param nodeName
   *  @param type
   *  @return String return fitlered 
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
    //check if valid dts vocab and get out if meta search
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    if (dtsVocab.equals("MetaValue")) return vSub;   
    
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false);  
    Boolean flagThree = new Boolean(true);  
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
  //  evsService = null;
    return vSub;
 } 

/**
   * This method searches EVS vocabularies and returns superconcepts, which are used
   * to construct an EVS Tree. 
   * @param dtsVocab the EVS Vocabulary
   * @param conceptName
   * @param conceptCode
   * @param defSource
   * @return vSub
 */
public Vector getSuperConceptNames(String dtsVocab, String conceptName, String conceptCode, String defSource) 
{
    String[] stringArray = new String[50];
    String[] stringArray2 = new String[50];
    Vector vSub = new Vector();
      
    Boolean flagOne = new java.lang.Boolean(false);
    Boolean flagTwo = new Boolean(false); 
    Boolean flagThree = new Boolean(true); 
    //check if valid dts vocab and get out if meta search
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    if (dtsVocab.equals("MetaValue")) return vSub;
   
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
        logger.fatal("Error in EVSSearch getSuperConceptNames: " + ex.toString());
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
        logger.fatal("Error in EVSSearch getSuperConceptNames: " + ex.toString());
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
   // evsService = null;
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
   
    //check if valid dts vocab and get out if meta search
    dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
    if (dtsVocab.equals("MetaValue")) return stringArray;
   
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
        logger.fatal("problem2a in Thesaurus EVSSearch-getAllSuperConceptNames: " + ee);
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
    return stringArray;
} 

/** 
  *  The EVS API returns def source from Thesaurus inside of xml tags <>. This methods
  *  extracts the def source from the tags
  *  @param termStr
  *  @return source
  *
*/
  public String parseDefSource(String termStr) 
  {
    try
    {
   // System.out.println(" def sorouce " + termStr);
      if (termStr == null || termStr.equals("")) return "";
      if (termStr.indexOf("<def-source>") >= 0)
      {
        termStr = termStr.replaceAll("<def-source>", "");
        int iEnd = termStr.indexOf('<', 0);
        if (iEnd > 0)
          termStr = termStr.substring(0,iEnd);        
      }
      else
        return "";  // no source
    }
    catch(Exception ee)
    {
      System.err.println("problem in Thesaurus syn EVSSearch-parseDefSource: " + ee);
      logger.fatal("ERROR - EVSSearch-parseDefSource for Thesaurus : " + ee.toString());
      return termStr;
    }
    return termStr;
  }

/** 
  *  The EVS API returns definitions from Thesaurus inside of xml tags <>. This methods
  *  extracts the definition from the tags
  *  @param termStr String 
  *  @return definition
  *
  */
public String parseDefinition(String termStr) 
{
  try
  {
      if (termStr == null || termStr.equals("")) return "";
      int iStartDef = termStr.indexOf("<def-definition>");
      if (iStartDef >= 0)
      {
        termStr = termStr.replaceAll("<def-definition>", "");
        int iEnd = termStr.indexOf("</def-definition>", iStartDef + 1);
        if (iEnd > 0)
          termStr = termStr.substring(iStartDef,iEnd);        
      }
//logger.debug(" - parseDef - " + termStr);
  }
  catch(Exception ee)
  {
    System.err.println("problem in Thesaurus syn EVSSearch-parseDefinition: " + ee);
    logger.fatal("ERROR - EVSSearch-parseDefinition for Thesaurus : " + ee.toString());
    return termStr;
  }
  return termStr;
}
      
 /**
   * To trim "Source => Name:" from Definition Source.
   *
   * @param termStr
   * @return String def source
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
//logger.debug(termStr + " - parseDef - ");
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
      Vector vSelAttr = new Vector();
      if (menuAction.equals("searchForCreate") || menuAction.equals("BEDisplay"))
          vSelAttr =(Vector)session.getAttribute("creSelectedAttr");
      else
          vSelAttr =(Vector)session.getAttribute("selectedAttr");

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
      boolean isMainConcept = false;
      if (!menuAction.equals("searchForCreate") && sSearchAC.equals("ConceptClass"))
        isMainConcept = true;
      
      String evsDB = "";
      String ccode = "";
      //prepare 2 session vectors for getAssociatedAC
      Vector vSearchID = new Vector();  
      Vector vSearchName = new Vector();
      for(int i=0; i<(vRSel.size()); i++)
      {
        EVS_Bean OCBean = new EVS_Bean();
        OCBean = (EVS_Bean)vRSel.elementAt(i);
        evsDB = OCBean.getEVS_DATABASE();

        ccode = OCBean.getNCI_CC_VAL();
        String sLevel = "";
        int iLevel = OCBean.getLEVEL();
        Integer Int = new Integer(iLevel);
        if(Int != null)
          sLevel = Int.toString();

        //assign 2 session vectors for getAssociatedAC
        vSearchID.addElement(OCBean.getIDSEQ());
        vSearchName.addElement(OCBean.getLONG_NAME());
        
        if (vSelAttr.contains("Concept Name") || refresh.equals("DEF")) vResult.addElement(OCBean.getLONG_NAME());
        if (vSelAttr.contains("Public ID")) vResult.addElement(OCBean.getID());
        if (vSelAttr.contains("Version")) vResult.addElement(OCBean.getVERSION());
        if (vSelAttr.contains("EVS Identifier")) vResult.addElement(OCBean.getNCI_CC_VAL());
        if (isMainConcept)  //main page concept class search addd it here with evs origin
          if (vSelAttr.contains("Vocabulary") || refresh.equals("DEF")) vResult.addElement(OCBean.getEVS_DATABASE());
        if (vSelAttr.contains("Definition") || refresh.equals("DEF")) vResult.addElement(OCBean.getPREFERRED_DEFINITION());
        if (vSelAttr.contains("Definition Source") || refresh.equals("DEF")) vResult.addElement(OCBean.getEVS_DEF_SOURCE());
        if (vSelAttr.contains("Workflow Status")) vResult.addElement(OCBean.getASL_NAME());
        if (vSelAttr.contains("Semantic Type")) vResult.addElement(OCBean.getEVS_SEMANTIC());
        if (vSelAttr.contains("Context") && !refresh.equals("DEF")) vResult.addElement(OCBean.getCONTEXT_NAME());
        if (vSelAttr.contains("Comments")) vResult.addElement(OCBean.getCOMMENTS());
        if (!isMainConcept) //add it here only if not the main concept 
          if (vSelAttr.contains("Vocabulary") || refresh.equals("DEF")) vResult.addElement(OCBean.getEVS_DATABASE());
        if (vSelAttr.contains("caDSR Component")) vResult.addElement(OCBean.getcaDSR_COMPONENT());
        if (vSelAttr.contains("DEC's Using")) vResult.addElement(OCBean.getDEC_USING());
        if (vSelAttr.contains("Level")) vResult.addElement(sLevel);
      }

      // set session var for getAssociatedAC
      session.setAttribute("SearchID", vSearchID);
      session.setAttribute("SearchName", vSearchName);
      // push info on stacks for back button
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
      if(!refresh.equals("true") && (!menuAction.equals("searchForCreate")))
        serAC.stackSearchComponents(sSearchAC, vOC, vRSel, vSearchID, vSearchName,
        vResult, vSearchASL, vSearchName); 
      
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
      else if (sSearchAC.equals("ConceptClass"))
        sSearchAC = "Concept Class";
        
      if(evsDB.equals("NCI_Thesaurus") || evsDB.equals("Thesaurus/Metathesaurus"))
        sKeyword = filterName(sKeyword, "display");
      if (!sSearchAC.equals("ParentConcept"))
        req.setAttribute("labelKeyword", sSearchAC + " - " + sKeyword);   //make the label
      else if (sSearchAC.equals("ParentConcept"))
        req.setAttribute("labelKeyword", " - " + sKeyword);
      
    }
    catch(Exception e)
    {
     // System.err.println("ERROR in EVSSearch-get_Result: " + e);
      if(!e.toString().equals("java.lang.NullPointerException"))
        logger.fatal("ERROR in EVSSearch-get_Result : " + e.toString());
    }
  }

  
  /**
   * gets the non evs parent from reference documents table for the vd
   * @param sParent String parent name
   * @param sCui String meta cui
   * @param PageVD String page VD
   * @return String document name 
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
      Vector vRef = serAC.doRefDocSearch(PageVD.getVD_VD_IDSEQ(), "META_CONCEPT_SOURCE", "open");
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
   */
  public void getMetaSources()
  {
    try
    {
      if (evsService == null)
      {
        logger.fatal("Error - EVSSearch-getMetaSources : no evs connection");
        return;
      }
      Vector vMetaSources = new Vector();
      HttpSession session = m_classReq.getSession();
      ArrayList vMetaSrc = null;
      String source = "";
      EVSQuery query = new EVSQueryImpl(); 
      query.getMetaSources(); 
      List concepts = null;  
        concepts = evsService.evsSearch(query);
      if(concepts != null)
      { 
        //MetaThesaurusConcept aMetaThesaurusConcept = new MetaThesaurusConcept();
        for (int i = 0; i < concepts.size(); i++)
        {
          Source mSource = null;
          mSource = (Source)concepts.get(i);
          source = mSource.getAbbreviation();
          vMetaSources.addElement(source);
        }      
      }
     // evsService = null; 
      session.setAttribute("MetaSources", vMetaSources); 
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
       logger.fatal("Error - EVSSearch-getMetaSources : " + ex.toString());
    }
  }

  /**
   * various search for concept method including name, cui etc for all vocabularies
   * stores the results in EVS bean which then stored in the vector to send back.
   * @param vConList vector existing vector of concepts 
   * @param termStr String search term
   * @param dtsVocab STring vocabulary name
   * @param sSearchIn String search in attribute
   * @param namePropIn String property name to search in
   * @param sSearchAC String AC name for the search
   * @param sIncludeRet String include or exclude the retired search
   * @param sMetaSource String meta source selected
   * @param iMetaLimit int meta search result limit
   * @param isMetaSearch boolean to meta search or not
   * @param ilevel int current level of the concept
   * @param subConType String immediate or all sub concepts to return
   * @return VEctor of concept bean 
   */
  public Vector doVocabSearch(Vector<EVS_Bean> vConList, String termStr, String dtsVocab, 
    String sSearchIn, String namePropIn, String sSearchAC, String sIncludeRet, 
    String sMetaSource, int iMetaLimit, boolean isMetaSearch, int ilevel, String subConType)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      //do not continue if empty string search.
      if (termStr == null || termStr.equals("")) return vConList;
      //check if the concept name property exists for the vocab
      if (vConList == null) vConList = new Vector<EVS_Bean>(); 
      ilevel += 1;
      //get vocab specific propeties stored in the vocab bean 
      //get the vocab specific attributes
      Hashtable hVoc = (Hashtable)m_eUser.getVocab_Attr();
      if (hVoc == null) hVoc = new Hashtable();
      EVS_UserBean vocabBean = null;
      if (hVoc.containsKey(dtsVocab))
        vocabBean = (EVS_UserBean)hVoc.get(dtsVocab);
      if (vocabBean == null) 
        vocabBean = (EVS_UserBean)session.getAttribute("EvsUserBean");
      String namePropDisp = vocabBean.getPropNameDisp();
      if (namePropDisp == null) namePropDisp = "";
      if (namePropIn == null || namePropIn.equals(""))  //get the vocab specific prop to search in
        namePropIn = vocabBean.getPropName();
      String conCodeType = vocabBean.getVocabCodeType();
      String sMetaName = vocabBean.getIncludeMeta();
      //int ilevel = 0;  //it is zero for keyword search
      String defnProp = vocabBean.getPropDefinition(); 
      String hdSynProp = vocabBean.getPropHDSyn();
      String retConProp = vocabBean.getPropRetCon();
      String semProp = vocabBean.getPropSemantic();
      String vocabType = vocabBean.getNameType();
      String sDefDefault = vocabBean.getDefDefaultValue();  // "No Value Exists.";
    //logger.debug(termStr + " before query " + namePropDisp + namePropIn + conCodeType + sMetaName + defnProp + hdSynProp + retConProp + semProp + vocabType);
      try
      {
        //call method to do the search from EVS vocab
        List lstResults = null;
        //do not do vocab search if it is meta code search
        if (!sSearchIn.equals("MetaCode"))
          lstResults = this.doConceptQuery(termStr, dtsVocab, sSearchIn, vocabType, namePropIn);
        //get the desc object from the list
        if (lstResults != null)
        {
    //logger.debug(sSearchIn + " after query " + lstResults.size());
          Hashtable hType = m_eUser.getMetaCodeType();
          if (hType == null) hType = new Hashtable();
        skipConcept:
          for (int i =0; i < lstResults.size(); i++)
          {
            DescLogicConcept oDLC = new DescLogicConcept();
            oDLC = (DescLogicConcept)lstResults.get(i); 
            String sConName = oDLC.getName();
            if (sConName == null) sConName = "";
            String sConID = oDLC.getCode();
            if (sConID == null) sConID = "";
      //logger.debug(sConName + " con " + sConID);
            String sFullSyn = "", sSemantic = "", sPrefName = "", sStatus = "Active";
            String sDispName = sConName;
            String vocabMetaType = "", vocabMetaCode = "";
            Vector properties = oDLC.getPropertyCollection();
            if (properties == null) properties = new Vector();
            for(int k=0; k< properties.size(); k++)
            {
              Property property = (Property) properties.get(k);
              if (property != null)
              {
            //  System.out.println(" property " + property.getName() + "\t" + property.getValue() + "\t" + property.getName().indexOf("Semantic") + "\n");
                String propName = property.getName();
                if (propName == null) propName = "";
                String propValue = property.getValue();
                if (propValue == null) propValue = "";
                if (propName.indexOf(retConProp) >= 0)  //"Concept_Status" retired concept
                {
                  if (sIncludeRet != null && sIncludeRet.equals("Include")) sStatus = "Retired";  //property.getValue();
                  else continue skipConcept;  //do not add to the list if exclued from teh search filter
                }
                //test full syn only if parentconcept search "FULL_SYN"
                if (propName.indexOf(hdSynProp) >= 0 && sSearchAC.equals("ParentConceptVM"))
                {
                  sFullSyn = propValue;   // property.getValue();
                  String isHeader = this.parseSynonymForHD(sFullSyn);
                  if (isHeader.equals("true")) continue skipConcept;  //do not add to the list if header concept for parent
                }
                if (propName.indexOf(semProp) >= 0)   //"Semantic" property
                {
                  if (!sSemantic.equals("")) sSemantic += ", ";
                  sSemantic += propValue;   // property.getValue();
                }
                if (!namePropDisp.equals("") && propName.indexOf(namePropDisp) >= 0)   //"Preferred_Name" prop for concept name if not emtpy
                  sDispName = propValue;   // property.getValue();
                String sMeta = this.getNCIMetaCodeType(propName, "byKey");
            //logger.debug(propName + " property " + sMeta + " value " + propValue);
                if (sMeta != null && !sMeta.equals("")) // (hType.containsKey(propName))  //evs source type for nci- meta
                {
                  vocabMetaType = propName;
                  vocabMetaCode = propValue;   // property.getValue();
                //logger.debug(propName + " meta code " + propValue);
                }
              }
            }
            //store to concept according to the number of defitions exist for a concept
            vConList = this.storeConceptToBean(vConList, properties, dtsVocab, sConName, sDispName,
                  conCodeType, sConID, ilevel, sStatus, sSemantic, sDefDefault, defnProp, vocabMetaType, vocabMetaCode);
            //repeat the sub concept query for child concepts if all sub concept action
            if (sSearchIn.equals("subConcept") && subConType.equals("All"))
            {
              Boolean bHasChildren = new Boolean(false);
              bHasChildren = oDLC.getHasChildren();
              boolean bool = bHasChildren.booleanValue();
              if(bool)
              {
                this.doVocabSearch(vConList, sConID, dtsVocab, sSearchIn, "", sSearchAC, 
                  sIncludeRet, sMetaSource, iMetaLimit, isMetaSearch, ilevel, subConType);
              }
            }
          }        
        }
      //  else
      //    logger.fatal("EVSSearch-doVocabSearch vocabulary " + dtsVocab + " search has no data for." + termStr);
      }    
      catch(Exception ee)
      {
          System.err.println("problem in EVSSearch-doVocabSearch - vocab result : " + ee);
          logger.fatal("ERROR - EVSSearch-doVocabSearch - vocab result : " + ee.toString());
      }        
      //do the meta thesaurus search if meta name exists and if meta search is true
      if (sMetaName != null && !sMetaName.equals("") && isMetaSearch)
        vConList = this.doMetaSearch(vConList, termStr, sSearchIn, sMetaSource, iMetaLimit, sMetaName);
    }    
    catch(Exception ee)
    {
        System.err.println("problem in EVSSearch-doVocabSearch: " + ee);
        logger.fatal("ERROR - EVSSearch-doVocabSearch : " + ee.toString());
    }
    return vConList;
  }
  
  /**
   * gets the display name of the concepts
   * @param dtsVocab STring vocabulary name
   * @param dlc concepts desclogicobject from the API call
   * @param sName name of the concept
   * @return String display name
   */
  public String getDisplayName(String dtsVocab, DescLogicConcept dlc, String sName)
  {
    String dispName = sName;
 // System.out.println(dtsVocab + " display name " + sName);
    try
    {
      Vector vVocabs = (Vector)m_eUser.getVocabNameList();
      if (vVocabs == null) vVocabs = new Vector();
    
      //make sure the vocab exists in the list
      if (!vVocabs.contains(dtsVocab)) return sName;
      //get the property from cadsr
      Hashtable vHash = (Hashtable)m_eUser.getVocab_Attr();
      EVS_UserBean eUser = (EVS_UserBean)vHash.get(dtsVocab);
      if (eUser == null) return sName;
      String sPropDisp = eUser.getPropNameDisp();
      if (sPropDisp == null || sPropDisp.equals("")) return dispName;
      //get the value of the display property
      if (dlc == null)  //get it from evs query
      {
  //logger.debug(dtsVocab + " display name " + sName +  " dlc null - " + sPropDisp);
        EVSQuery query = new EVSQueryImpl();
        query.getPropertyValues(dtsVocab, sName, sPropDisp);
        List lstResult = evsService.evsSearch(query);
        if (lstResult != null && lstResult.size()>0)
          return (String)lstResult.get(0);
        else return sName;
      }
      else //get it from dlc object
      {//loop through prop to get the name
  //logger.debug(dtsVocab + " display name " + sName +  " dlc not null - " + sPropDisp);
        Vector properties = dlc.getPropertyCollection();
        if (properties == null) properties = new Vector();
        for(int k=0; k< properties.size(); k++)
        {
          Property property = (Property) properties.get(k);
          if (property != null)
          {
            String propName = property.getName();
            if (propName == null) propName = "";
            if (propName.indexOf(sPropDisp) >= 0)   //"Preferred_Name" prop for concept name if not emtpy
            {
              dispName = property.getValue();
              if (dispName != null && !dispName.equals("")) return dispName;
              else return sName;
            }
          }
        }
      }
    }    
    catch(Exception ee)
    {
        System.err.println("problem in EVSSearch-getDisplayName: " + ee);
        logger.fatal("ERROR - EVSSearch-getDisplayName : " + ee.toString());
    }
    return sName;
  }

  private List doConceptQuery(String termStr, String dtsVocab, String sSearchIn, 
      String vocabType, String sPropIn)
  {
    List lstResult = null;
  //logger.debug("con query " + termStr + dtsVocab + sSearchIn + sPropIn + vocabType); 
    try
    {
      //check if valid dts vocab
      dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "", "vocabName");
      if (dtsVocab.equals("MetaValue")) return lstResult;
      EVSQuery query = new EVSQueryImpl();
      if (sSearchIn.equals("ConCode")) 
        query.getDescLogicConcept(dtsVocab, termStr, true);
      else if (sSearchIn.equals("subConcept"))
        query.getChildConcepts(dtsVocab, termStr, true);
      else
      {
        if (vocabType.equals("") || vocabType.equals("NameType"))  //do concept name search
          query.searchDescLogicConcepts(dtsVocab, termStr, 10000);
        else if (vocabType.equals("PropType"))  //do concept prop search
          query.searchDescLogicConcepts(dtsVocab, termStr, 10000, 2, sPropIn, 1);
      }
      //call the evs to get resutls
      lstResult = evsService.evsSearch(query);
    }
    catch(Exception ex)
    {
      System.out.println("conceptNameSearch lstResults: " + ex.toString());
      logger.fatal("conceptNameSearch lstResults: " + ex.toString());
      //ex.printStackTrace();
    }  
    return lstResult;
  }
  
  private Vector storeConceptToBean(Vector<EVS_Bean> vCons, Vector vProp, String dtsVocab,
      String sConName, String sDispName, String conCodeType, String sConID, int ilevel, String sStatus, 
      String sSemantic, String sDefDefault, String defnProp, String sMType, String sMCode) 
  {
    try
    {
      EVS_Bean conBean = new EVS_Bean();
      //get the db origin vocab name from the vocab name
      String dbVocab = conBean.getVocabAttr(m_eUser, dtsVocab, "vocabName", "vocabDBOrigin");
  
      //do the definition separatly so that concept for each definition is displayed in new row and bean.
      boolean defExists = false;
      for(int k=0; k< vProp.size(); k++)
      {
        Property property = (Property) vProp.get(k);
        String sDef = sDefDefault; // "No Value Exists.";
        if (property != null)
        {
          if (property.getName().indexOf(defnProp) >= 0)   //"DEFINITION"
          {
            sDef = this.parseDefinition(property.getValue());  //get def value
            String sDefSrc = this.parseDefSource(property.getValue());  //get def source
            defExists = true;
            //add the properties to the bean
            conBean = new EVS_Bean();
            conBean.setEVSBean(sDef, sDefSrc, sConName, sDispName, conCodeType, sConID, 
              dtsVocab, dbVocab, ilevel, "", "", "", sStatus, sSemantic, sMType, sMCode);
            vCons.addElement(conBean);  //add concept bean to the vector
          }
        }
      }
      //add concept to the bean if not done by defintion loop already
      if (!defExists)
      {
        //add the properties to the bean
        String sDef = sDefDefault;
        conBean = new EVS_Bean();
        conBean.setEVSBean(sDef, "", sConName, sDispName, conCodeType, sConID, dtsVocab, 
            dbVocab, ilevel, "", "", "", sStatus, sSemantic, sMType, sMCode);
        vCons.addElement(conBean);
      }
    }
    catch(Exception ex)
    {
      System.out.println("storeConceptToBean: " + ex.toString());
      logger.fatal("storeConceptToBean: " + ex.toString());
      //ex.printStackTrace();
    }  
    return vCons;
  }

  private Vector doMetaSearch(Vector<EVS_Bean> vList, String termStr, String sSearchIn, String sMetaSource, 
      int iMetaLimit, String sVocab)
  {
    if (vList == null) vList = new Vector<EVS_Bean>();
    try
    {
      if (termStr == null || termStr.equals("")) return vList;
      List metaResults = null;
      EVSQuery query = new EVSQueryImpl();
      try
      {
  //System.out.println("meta search " + termStr + sVocab + sSearchIn); 
        if (sSearchIn.equalsIgnoreCase("MetaCode")) //do meta code specific to vocabulary source
          query.searchSourceByCode(termStr,sMetaSource);
        else if (sSearchIn.equalsIgnoreCase("ConCode")) //meta cui search
          query.searchMetaThesaurus(termStr, iMetaLimit, sMetaSource, true, false, false);
        else  //meta keyword search
          query.searchMetaThesaurus(termStr, iMetaLimit, sMetaSource, false, false, false);
        //do the search
        metaResults = evsService.evsSearch(query);
      }
      catch(Exception ex)
      {
        logger.fatal("doMetaSearch evsSearch: " + ex.toString());
      }
      if (metaResults != null)
      {
        String sConName = "", sConID = "", sCodeType = "", sSemantic = "";
        int iLevel = 0;
        for (int i =0; i<metaResults.size(); i++)
        {
          // Do this so only one result is returned on Meta code search (API is dupicating a result)
          if (sSearchIn.equals("MetaCode") && i > 0) break;
          //get concept properties
          MetaThesaurusConcept metaCon = (MetaThesaurusConcept)metaResults.get(i);
          if (metaCon != null)
          {
            sConName = metaCon.getName();
            sConID = metaCon.getCui();
            sCodeType = this.getNCIMetaCodeType(sConID, "byID");
            //get semantic types
            sSemantic = "";
            ArrayList semanticTypes = metaCon.getSemanticTypeCollection();
            if (semanticTypes != null)
            {
              for(int k=0; k<semanticTypes.size(); k++)
              {
                SemanticType semanticType = (SemanticType) semanticTypes.get(k);
                if (!sSemantic.equals("")) sSemantic += "; ";
                sSemantic += semanticType.getName();
              } 
            }
            boolean defExists = false;
            
            String sDefSource = "", sDefinition = m_eUser.getDefDefaultValue();
            //add sepeate record for each definition
            ArrayList arrDef = metaCon.getDefinitionCollection();
            if (arrDef != null && arrDef.size() > 0)
            {
              for(int k=0; k<arrDef.size(); k++)
              {
                Definition defType = (Definition)arrDef.get(k);
                sDefinition = defType.getDefinition();
                sDefSource = defType.getSource().getAbbreviation();
                EVS_Bean conBean = new EVS_Bean();
                conBean.setEVSBean(sDefinition, sDefSource, sConName, sConName, sCodeType, 
                  sConID, sVocab, sVocab, iLevel, "", "", "", "", sSemantic, "", ""); 
                vList.addElement(conBean);    //add concept bean to vector
              } 
            }
            else
            {
              EVS_Bean conBean = new EVS_Bean();
              conBean.setEVSBean(sDefinition, sDefSource, sConName, sConName, sCodeType,
                  sConID, sVocab, sVocab, iLevel, "", "", "", "", sSemantic, "", ""); 
              vList.addElement(conBean);    //add concept bean to vector              
            }
          }
        }
      }
    }
    catch(Exception ex)
    {
      System.out.println("conceptNameSearch lstResults: " + ex.toString());
      logger.fatal("conceptNameSearch lstResults: " + ex.toString());
    }
    return vList;
  }
  
  private String getNCIMetaCodeType(String conID, String ftrType) throws Exception
  {
    String sCodeType = "";
    //get the hash table of meta code property types
    Hashtable hType = m_eUser.getMetaCodeType();
    if (hType == null) hType = new Hashtable();
    //define code type according to the con id
    Enumeration enum1 = hType.keys();
    while (enum1.hasMoreElements())
    {
      String sKey = (String)enum1.nextElement();
      //String sCFilter = (String)hType.get(sMCode);
      EVS_METACODE_Bean metaBean = (EVS_METACODE_Bean)hType.get(sKey);
      if (metaBean == null) metaBean = new EVS_METACODE_Bean();
      String sMCode = metaBean.getMETACODE_TYPE();
      String sCFilter = metaBean.getMETACODE_FILTER().toUpperCase();  //  (String)hType.get(sMCode);
      if (sCFilter == null) sCFilter = "";
      if (ftrType.equals("byID"))
      {
        //get the default value regardless
        if (sCFilter.equals("DEFAULT")) sCodeType = sMCode;
        //use the fitlered one if exists and leave
        else if (!sCFilter.equals("") && conID.toUpperCase().indexOf(sCFilter) >= 0) 
        {
          sCodeType = sMCode;
          break;
        }
      }
      else  //by key
      {
        if (conID.toUpperCase().indexOf(sKey.toUpperCase()) >= 0)
        {
          sCodeType = sMCode;
       //logger.debug(conID + " meta code upper case " + sKey);
          break;
        }
      }
    }
    return sCodeType;
  }

  /**
   * to get the vocabulary name
   * @param sMetaName
   * @return String vocabulary name from the vector
   */
  public String getMetaVocabName(String sMetaName)
  {
    String sVocab = "";
    Vector vName = m_eUser.getVocabNameList();
    Hashtable eHash = (Hashtable)m_eUser.getVocab_Attr();
    //get the two vectors to check
    for (int i=0; i<vName.size(); i++)
    {
      String sName = (String)vName.elementAt(i);
      EVS_UserBean usrVocab = (EVS_UserBean)eHash.get(sName);
      String sValue = "";
      //get the thesaurs name for the meta thesarurs
      String sMeta = usrVocab.getIncludeMeta();
      if (sMeta != null && !sMeta.equals("") && sMetaName.equals(sMeta))
      {
        sVocab = sName;
        break;
      }
    }
    if (sVocab.equals("")) sVocab = (String)vName.elementAt(0);  //get the first one
    //logger.debug(sMetaName + " svocab " + sVocab);
    return sVocab;
  }
  
  /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  *
  * @throws Exception
  */
  public void doGetSuperConcepts()  throws Exception
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      String sConceptName = (String)m_classReq.getParameter("nodeName"); 
      String sConceptCode = (String)m_classReq.getParameter("nodeCode");
      String dtsVocab = (String)m_classReq.getParameter("vocab");
      String sDefSource = (String)m_classReq.getParameter("defSource");
      String sSearchType = (String)m_classReq.getParameter("searchType");
      String sUISearchType = (String)m_classReq.getParameter("UISearchType");
      if(sUISearchType == null || sUISearchType.equals("nothing")) 
        sUISearchType = "term";
      String sRetired = (String)m_classReq.getParameter("rRetired");
      if (sRetired == null) sRetired = "Include";
      String sConteIdseq = (String)m_classReq.getParameter("sConteIdseq");
      if (sConteIdseq == null) sConteIdseq = "";
        
      if (sConceptName == null || sConceptCode == null || dtsVocab == null) 
        return;
      Vector vAC = new Vector();
      Vector vResult = new Vector();
      Vector vSuperConceptNamesUnique = new Vector();
      String sSearchAC = (String)session.getAttribute("creSearchAC");
      if(sSearchAC == null) sSearchAC = "";
    //  EVSSearch evs = new EVSSearch(m_classm_classReq, m_classRes, this); 
    //  GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, this);
      Vector vSuperConceptNames = null;
      String sName = "";
      String sCode = "";
      String sParentName = "";
      dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "vocabDBOrigin", "vocabName");
      if(sSearchAC.equals("ParentConceptVM"))
        sParentName= (String)session.getAttribute("ParentConcept");   
      vSuperConceptNames = this.getSuperConceptNames(dtsVocab, sConceptName, sConceptCode, sDefSource);
      for(int j=0; j < vSuperConceptNames.size(); j++) 
      { 
          sName = (String)vSuperConceptNames.elementAt(j);
          if(!vSuperConceptNamesUnique.contains(sName))
          {
            vSuperConceptNamesUnique.addElement(sName);
            if(sName != null && !sName.equals(""))
              sCode = this.do_getEVSCode(sName, dtsVocab);
            if(sCode != null && !sCode.equals(""))
              vAC = this.doVocabSearch(vAC, sCode, dtsVocab, "ConCode", "", sSearchAC, sRetired, "", 100, false, -1, "");
             // evs.do_EVSSearch(sCode, vAC, dtsVocab, "Concept Code",
             // "All Sources", 100, "term", sRetired, sConteIdseq, -1);
            if(sName.equals(sParentName))
              break;
          }
      }
      session.setAttribute("vACSearch", vAC);
      if(sSearchAC.equals("ParentConcept"))
        session.setAttribute("vParResult", vAC);
      else if(sSearchAC.equals("ParentConceptVM"))
        session.setAttribute("vParResultVM", vAC);
      session.setAttribute("creRetired", sRetired);
      session.setAttribute("dtsVocab", dtsVocab);
      //get the final result vector
      this.get_Result(m_classReq, m_classRes, vResult, "");
      session.setAttribute("results", vResult);
      session.setAttribute("creKeyword", sConceptCode);
     /* if(dtsVocab.equals("NCI_Thesaurus"))
          sConceptName = filterName(sConceptName, "display"); */
      m_classReq.setAttribute("labelKeyword", sConceptName);
      Integer recs = new Integer(vAC.size());
      String recs2 = recs.toString();
      m_classReq.setAttribute("creRecsFound", recs2);  
      session.setAttribute("vACSearch", vAC);
      if(sSearchAC.equals("ParentConceptVM"))
        sUISearchType = "tree";
      m_classReq.setAttribute("UISearchType", sUISearchType);

      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
    }
    catch(Exception ex)
    {
      System.out.println("doGetSuperConcepts : " + ex.toString());
      logger.fatal("doGetSuperConcepts : " + ex.toString());
      //ex.printStackTrace();
    }
  }

  /**
   * to show the concept in a tree
   * @param actType String action type
   */
  public void showConceptInTree(String actType)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      String sComp = (String)m_classReq.getParameter("searchComp");
      if (sComp == null) sComp = "";
      session.setAttribute("creSearchAC", sComp);       
      String sCCodeDB = (String)m_classReq.getParameter("OCCCodeDB");
      Vector vVocabList = m_eUser.getVocabNameList();
      if (vVocabList == null) vVocabList = new Vector();
      String sCCode = (String)m_classReq.getParameter("OCCCode");
      String sCCodeName = (String)m_classReq.getParameter("OCCCodeName");
      String sNodeID = (String)m_classReq.getParameter("nodeID");
      String dtsVocab = m_eBean.getVocabAttr(m_eUser, sCCodeDB, "vocabDBOrigin", "vocabName");
      if(sCCode == null || sCCode.equals(""))
        sCCode = this.do_getEVSCode(sCCodeName, dtsVocab);
  //logger.debug(sCCodeDB + " show concept " + sCCode + " dtsvocab " + dtsVocab);
      Vector vList = new Vector();
      if(!sCCode.equals("")) // && !sComp.equals("ParentConcept"))
      {
        //this.doCollapseAllNodes(dtsVocab);
        //first get the details from evs as well as from cadsr
        this.doCallConceptSearch(sCCode, sCCodeDB, sCCodeName, dtsVocab);
        //open the tree if from the vocab list else just display teh details
        if (vVocabList.contains(dtsVocab))
          this.doCallTreeSearch("OpenTreeToConcept", dtsVocab, sCCodeName, sCCode);
      /*  if(sComp.equals("ParentConceptVM") && !sCCodeDB.equals("MetaValue"))
          this.doTreeOpenToConcept("OpenParentTreeToConcept", "Blocks", sCCode, sCCodeDB, sCCodeName, sNodeID);      
        else   // if (vVocabList.contains(sVocab))  //display tree for all vocabularies
          this.doTreeOpenToConcept("tree", "Blocks", sCCode, sCCodeDB, sCCodeName, sNodeID); 
        return;*/
      }
      else if(!sComp.equals("ParentConcept"))
      {
      //logger.debug(sComp + " do we come here for name search to open tree?" + sCCodeDB);
        this.doCollapseAllNodes(sCCodeDB);
        this.doTreeSearch(actType, "Blocks");
        return;
      }
      m_classReq.setAttribute("labelKeyword", sCCodeName);
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
    }
    catch(Exception e)
    {
      //logger.debug("showConceptInTree : " + e.toString());
      logger.fatal("showConceptInTree : " + e.toString());      
    }    
  }

  private void getOtherVocabDetails(String sCode, String sConDB, String sVocab)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      String sVocabName = this.getMetaVocabName(sVocab);  //get its equivalent vocab name (eg. NCI Thesarurs)
      Vector vList = new Vector();
      if (sConDB.equals("MetaValue")) //no need for tree
        vList = this.doMetaSearch(vList, sCode, "ConCode", "", 100, sVocab);
      else //get details from concept class
      {
        GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
        vList = serAC.do_ConceptSearch(sCode, "", "", "RELEASED", "", "", "", vList);
      }
      session.setAttribute("vACSearch", vList);
      m_classReq.setAttribute("UISearchType", "term");
      session.setAttribute("SearchInEVS", "ConCode");
      session.setAttribute("creSearchInBlocks", "evsIdentifier");
      Vector vRes = new Vector();
      this.get_Result(m_classReq, m_classRes, vRes, "");
      session.setAttribute("results", vRes);  
      
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
    }
    catch(Exception e)
    {
      //logger.debug("getOtherVocabDetails : " + e.toString());
      logger.fatal("getOtherVocabDetails : " + e.toString());      
    }
  }
  
  /**
  * Opens teh tree to the selected concept
  * @param actType string action type
  * @param searchType string search tye of filter a simple or advanced
  * @param sCCode string concept identifier
  * @param sCCodeDB string concept database
  * @param sCCodeName string concept name
  * @param sNodeID string current node id
  *
  * @throws Exception
  */
  public void doTreeOpenToConcept(String actType, String searchType, String sCCode, String sCCodeDB, String sCCodeName, String sNodeID)  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String strHTML = "";
      String sOpenToTree = (String)m_classReq.getParameter("openToTree");
      session.setAttribute("OpenTreeToConcept", "true");
      String sOpenTreeToConcept = (String)session.getAttribute("OpenTreeToConcept");
      if(sOpenTreeToConcept == null) sOpenTreeToConcept = "";
      if(sCCode.equals("") && !sCCodeName.equals(""))
        sCCode = this.do_getEVSCode(sCCodeName, sCCodeDB);  
        
      if(sOpenToTree == null) sOpenToTree = "";
      if (actType.equals("term")|| actType.equals(""))
          m_classReq.setAttribute("UISearchType", "term");
      else if (actType.equals("tree"))
      {
          this.doTreeSearchRequest("", sCCode, "false", sCCodeDB);
          m_classReq.setAttribute("UISearchType", "tree");
          EVSMasterTree tree = new EVSMasterTree(m_classReq, sCCodeDB, m_servlet);
          Vector vStackVector = new Vector();
          Vector vStackVector2 = new Vector();
          strHTML = tree.populateTreeRoots(sCCodeDB);
          Stack stackSuperConcepts = new Stack();
 //logger.debug(sCCodeName + " what is null " + sCCodeDB);       
          Vector vSuperImmediate = this.getSuperConceptNamesImmediate(sCCodeDB, sCCodeName, sCCode, "");
          session.setAttribute("vSuperImmediate", vSuperImmediate);
          vStackVector2 = tree.buildVectorOfSuperConceptStacks(stackSuperConcepts, sCCodeDB, sCCode, vStackVector);
          if(vStackVector.size()<1) // must be a root concept
          {
            Tree RootTree = (Tree)tree.m_treesHash.get(sCCodeDB);
            if(RootTree != null)
              strHTML = tree.renderHTML(RootTree);        
          }
          else
          {
            Stack vStack = new Stack();
            for(int j=0; j<vStackVector.size(); j++)
            {
              vStack = (Stack)vStackVector.elementAt(j);
              if(vStack.size()>0)
                strHTML = tree.expandTreeToConcept(vStack, sCCodeDB, sCCode);
            }
          }
   // System.out.println(" strHtml " + strHTML);
          session.setAttribute("strHTML", strHTML);
          session.setAttribute("vSuperImmediate", null);
      }
      else if (actType.equals("parentTree"))
      {
          session.setAttribute("ParentConceptCode", sCCode);
          session.setAttribute("ParentConcept", sCCodeName);
          this.doTreeSearchRequest(sCCodeName, sCCode, "false", sCCodeDB);
          m_classReq.setAttribute("UISearchType", "tree");
          EVSMasterTree tree = new EVSMasterTree(m_classReq, sCCodeDB, m_servlet);
          if(!sCCodeDB.equals("NCI Metathesaurus"))
            strHTML = tree.populateTreeRoots(sCCodeDB);
          strHTML = tree.showParentConceptTree(sCCode, sCCodeDB, sCCodeName);
          session.setAttribute("strHTML", strHTML); 
      }
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }
  
  /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  * @param sConceptName string concept name
  * @param sConceptID string concept identifier
  * @param strForward string true or false values to forward the page or not
  * @param dtsVocab string vocab name
  *
  * @throws Exception
  */
  public void doTreeSearchRequest(String sConceptName, String sConceptID, String strForward, String dtsVocab)  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      session.setAttribute("ConceptLevel", "0");
      String sUISearchType = (String)m_classReq.getAttribute("UISearchType");
      if (sUISearchType == null || sUISearchType.equals("nothing")) sUISearchType = "tree";
      String sKeywordID = (String)m_classReq.getParameter("keywordID");
      String sKeywordName = (String)m_classReq.getParameter("keywordName");
      String conLevel = (String)m_classReq.getParameter("nodeLevel");
      int iLevel = -1;
      if (conLevel != null && !conLevel.equals(""))
        iLevel = Integer.parseInt(conLevel);
    //logger.debug(iLevel + " level " + conLevel);
      if (sKeywordID == null || sKeywordID.equals("")) 
        sKeywordID = sConceptID;
      if (sKeywordName == null || sKeywordName.equals("")) 
        sKeywordName = sConceptName;
      //since dtsvocab is empty, get it from url vocab, otherwise get it from dropdown
      if (dtsVocab == null || dtsVocab.equals("")) dtsVocab = (String)m_classReq.getParameter("vocab");
      if(dtsVocab == null || dtsVocab.equals("")) dtsVocab = (String)m_classReq.getParameter("listContextFilterVocab");
      if(dtsVocab == null) dtsVocab = ""; //dtsVocab;
      if(sKeywordID.equals("") && !sKeywordName.equals(""))
        sKeywordID = this.do_getEVSCode(sKeywordName, dtsVocab);   
      String sOpenToTree = (String)m_classReq.getParameter("openToTree");
      if(sOpenToTree == null) sOpenToTree = "";

      String sRetired = (String)m_classReq.getParameter("rRetired");
      if (sRetired == null) sRetired = "Include";  
      String sConteIdseq = (String)m_classReq.getParameter("sConteIdseq");
      if (sConteIdseq == null) sConteIdseq = "";
      session.setAttribute("creRetired", sRetired);
      session.setAttribute("dtsVocab", dtsVocab);
      String sSearchType = "";
      String sSearchAC = (String)session.getAttribute("creSearchAC");

      if(sSearchAC == null) 
        sSearchAC = "";
      else if(sSearchAC.equals("ObjectClass"))
        sSearchType = "OC";
      else if(sSearchAC.equals("Property"))
        sSearchType = "PROP";
      else if(sSearchAC.equals("RepTerm"))
        sSearchType = "REP";
      else if(sSearchAC.equals("ObjectQualifier"))
        sSearchType = "ObjQ";
       else if(sSearchAC.equals("PropertyQualifier"))
        sSearchType = "PropQ";
       else if(sSearchAC.equals("RepQualifier"))
        sSearchType = "RepQ";
      Vector vAC = new Vector();
      Vector vResult = new Vector();
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet); 
      if (sKeywordID != null)
      {
        if(!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM"))
        {
          if(sSearchAC.equals("ObjectClass") || sSearchAC.equals("Property") || sSearchAC.equals("RepTerm"))
            serAC.do_caDSRSearch(sKeywordID, "", "RELEASED", "", vAC, sSearchType, "", "");
          vAC = serAC.do_ConceptSearch(sKeywordID, "", "", "RELEASED", "", "", "", vAC);
        }
  
        session.setAttribute("creKeyword", sKeywordID);
        String sMetaSource = "";
        int intMetaLimit = 100;
    //logger.debug(sKeywordID + " voc " + dtsVocab + " ac " + sSearchAC + " uitype " + sUISearchType);
        if (sKeywordID != null && !sKeywordID.equals("")) 
          vAC = this.doVocabSearch(vAC, sKeywordID, dtsVocab, "ConCode", "", sSearchAC, sRetired, sMetaSource, intMetaLimit, false, iLevel, "");
         // evs.do_EVSSearch(sKeywordID, vAC, sVocab, "Concept Code",
         // "All Sources", 100, sUISearchType, sRetired, sConteIdseq, -1);
        else if (sKeywordName != null && !sKeywordName.equals("")) 
          vAC = this.doVocabSearch(vAC, sKeywordName, dtsVocab, "Name", "", sSearchAC, sRetired, sMetaSource, intMetaLimit, false, iLevel, "");
          //evs.do_EVSSearch(sKeywordName, vAC, sVocab, "term",
          //"All Sources", 100, sUISearchType, sRetired, sConteIdseq, -1);
          
        session.setAttribute("vACSearch", vAC);
        if(sSearchAC.equals("ParentConcept"))
          session.setAttribute("vParResult", vAC);
        else if(sSearchAC.equals("ParentConceptVM"))
          session.setAttribute("vParResultVM", vAC);
          
        this.get_Result(m_classReq, m_classRes, vResult, "");
        session.setAttribute("results", vResult);

        m_classReq.setAttribute("labelKeyword", sKeywordName);
        session.setAttribute("labelKeyword", sKeywordName);
        Integer recs = new Integer(vAC.size());
        String recs2 = recs.toString();
        sKeywordID = "";
        sKeywordName = "";
        m_classReq.setAttribute("creRecsFound", recs2);  
      }
 
      m_classReq.setAttribute("UISearchType", "tree");
      if(!strForward.equals("false"))
      {
        m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
      }
  }

  /**
  *
  * @param actType String  type of filter a simple or advanced
  * @param searchType  String type of filter a simple or advanced
  *
  * @throws Exception
  */
  public void doTreeSearch(String actType, String searchType)  throws Exception
  {
  //logger.debug(actType + " dotreeseach - why am i here " + searchType);
      HttpSession session = m_classReq.getSession();
      GetACSearch getACSearch = new GetACSearch(m_classReq, m_classRes, m_servlet);
      String dtsVocab = m_classReq.getParameter("listContextFilterVocab");
      if (actType.equals("term")|| actType.equals(""))
          m_classReq.setAttribute("UISearchType", "term");
      else if (actType.equals("tree"))
      {
          m_classReq.setAttribute("UISearchType", "tree");
          EVSMasterTree tree = new EVSMasterTree(m_classReq, dtsVocab, m_servlet);
          String strHTML = tree.populateTreeRoots(dtsVocab);
          session.setAttribute("strHTML", strHTML);
      }
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }

 /**
  * to collapse all the nodes of the tree
  * @param dtsVocab String vocabulary name
  * @throws Exception
  */
  public void doCollapseAllNodes(String dtsVocab)  throws Exception
  {
    HttpSession session = m_classReq.getSession();
    session.setAttribute("results", null);
    session.setAttribute("vACSearch", null);
    session.setAttribute("ConceptLevel", "0");
    m_classReq.setAttribute("UISearchType", "term");
// System.out.println("doCollapseAllNodes");
    EVSMasterTree tree = new EVSMasterTree(m_classReq, dtsVocab, m_servlet);
    tree.collapseAllNodes();
// System.out.println("done doCollapseAllNodes");
  }
  
    /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  *
  * @throws Exception
  */
  public void doTreeRefreshRequest()  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String vocab = m_classReq.getParameter("vocab");
      vocab = m_eBean.getVocabAttr(m_eUser, vocab, "vocabDisplay", "vocabName");
   /*   if(vocab == null || vocab.equals("Thesaurus/Metathesaurus")) 
        vocab = "NCI_Thesaurus";
      else if(vocab.equals("MGED")) 
        vocab = "MGED_Ontology"; */
      session.setAttribute("dtsVocab", vocab);   
      this.doCollapseAllNodes(vocab);
      EVSMasterTree tree = new EVSMasterTree(m_classReq, vocab, m_servlet);
      String strHTML = tree.refreshTree(vocab, "");
      session.setAttribute("strHTML", strHTML);
      m_classReq.setAttribute("UISearchType", "tree");
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }

    /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  * forwards JSP 'SearchResultsPage.jsp' if the action is not searchForCreate.
  * if action is searchForCreate forwards OpenSearchWindow.jsp
  *
  * @throws Exception
  */
  public void doTreeExpandRequest()  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String sSearchAC = (String)session.getAttribute("creSearchAC");
      session.setAttribute("creKeyword", "");
      if(sSearchAC == null)
        sSearchAC = "";
      else
      {
        GetACSearch getACSearch = new GetACSearch(m_classReq, m_classRes, m_servlet);
        Vector vResult = getACSearch.refreshSearchPage(sSearchAC);
        session.setAttribute("results", vResult); 
      }
      String nodeName = m_classReq.getParameter("nodeName");
      String nodeCode = m_classReq.getParameter("nodeCode");
      String nodeID = m_classReq.getParameter("nodeID");
      String vocab = m_classReq.getParameter("vocab");
      if(vocab == null) vocab = "NCI_Thesaurus";
      session.setAttribute("dtsVocab", vocab);     
      if(nodeCode.equals("") && !nodeName.equals(""))
        nodeCode = this.do_getEVSCode(nodeName, vocab);   
      EVSMasterTree tree = new EVSMasterTree(m_classReq, vocab, m_servlet);
      String strHTML = tree.expandNode(nodeName, vocab, "", nodeCode, "", 0, nodeID);
      session.setAttribute("strHTML", strHTML);
      m_classReq.setAttribute("UISearchType", "tree");
      m_classReq.setAttribute("labelKeyword", nodeName);
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }
  
    /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  * forwards JSP 'SearchResultsPage.jsp' if the action is not searchForCreate.
  * if action is searchForCreate forwards OpenSearchWindow.jsp
  *
  * @param req The HttpServletRequest from the client
  * @param res The HttpServletResponse back to the client
  *
  * @throws Exception
  */
  public void doTreeCollapseRequest()  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String sSearchAC = (String)session.getAttribute("creSearchAC");
      if(sSearchAC == null)
        sSearchAC = "";
      else
      {
        GetACSearch getACSearch = new GetACSearch(m_classReq, m_classRes, m_servlet);
        Vector vResult = getACSearch.refreshSearchPage(sSearchAC);
        session.setAttribute("results", vResult); 
      }
      String nodeName = m_classReq.getParameter("nodeName");
      String vocab = m_classReq.getParameter("vocab");
      String nodeID = m_classReq.getParameter("nodeID");
      if(vocab == null) vocab = "NCI_Thesaurus";
      session.setAttribute("dtsVocab", vocab);  
      EVSMasterTree tree = new EVSMasterTree(m_classReq, vocab, m_servlet);
    //  if(vocab.equals("VA_NDFRT") || vocab.equals("MedDRA"))
    //    nodeName = filterName(nodeName, "display");
      String strHTML = tree.collapseNode(nodeID, vocab, "", nodeName);
      session.setAttribute("strHTML", strHTML);
      m_classReq.setAttribute("UISearchType", "tree");
      m_classReq.setAttribute("labelKeyword", nodeName);
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }

  /**
  * gets request parameters to store the selected values in the session according to what the menu action is
  *
  *
  * @throws Exception
  */
  public void doGetSubConcepts()  throws Exception
  {
      HttpSession session = m_classReq.getSession();
      String sConceptName = (String)m_classReq.getParameter("nodeName"); 
      String sConceptCode = (String)m_classReq.getParameter("nodeCode");
      String dtsVocab = (String)m_classReq.getParameter("vocab");
      if (dtsVocab == null) dtsVocab = "";
      dtsVocab = m_eBean.getVocabAttr(m_eUser, dtsVocab, "vocabDBOrigin", "vocabName");
      String sDefSource = (String)m_classReq.getParameter("defSource");
      int ilevelStartingConcept = 0;
      int ilevelImmediate = 0;
      String sSearchType = (String)m_classReq.getParameter("searchType"); 
      String sRetired = "";  //(String)m_classReq.getParameter("rRetired");
      String sConteIdseq = (String)m_classReq.getParameter("sConteIdseq");
      if (sConteIdseq == null) sConteIdseq = "";
      
      String sUISearchType = (String)m_classReq.getParameter("UISearchType");
      if(sUISearchType == null || sUISearchType.equals("nothing")) 
        sUISearchType = "term";
     if (dtsVocab == null) dtsVocab = "";
     if (sConceptName == null || sConceptCode == null || dtsVocab == null) 
        return;
      Vector vAC = new Vector();
      Vector vResult = new Vector();
      String sSearchAC = (String)session.getAttribute("creSearchAC");
      if(sSearchAC == null) sSearchAC = "";
      GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet);
      Vector vSubConceptNames = null;
      Vector vSubConceptCodes = null;
      
      String sParent = (String)session.getAttribute("ParentConcept");
      if(sParent == null) sParent = "";
      String sParentSource = "";
      if(dtsVocab.equals("MetaValue") && sSearchAC.equals("ParentConceptVM"))
        sParentSource = serAC.getMetaParentSource(sParent, "None", null);
      if(!sParentSource.equals(""))
        sDefSource = sParentSource;
     
      if(sConceptName.equals(sParent))
        ilevelStartingConcept = 0;
      else if(sSearchAC.equals("ParentConceptVM"))
      {
        //EVSSearch evs = new EVSSearch(m_classReq, m_classRes, this);         
       // ilevelStartingConcept = this.getLevelDownFromParent(sConceptCode, dtsVocab);
        String slevel = (String)m_classReq.getParameter("conLevel");
        if (slevel != null && !slevel.equals(""))
          ilevelStartingConcept = Integer.parseInt(slevel);
    //logger.debug(slevel + " level " + ilevelStartingConcept);
      }      
      ilevelImmediate = ilevelStartingConcept + 1;
      String sLevelStartingConcept = "";
      Integer ILevelStartingConcept = new Integer(ilevelStartingConcept);
      sLevelStartingConcept = ILevelStartingConcept.toString();
      session.setAttribute("ConceptLevel", sLevelStartingConcept);
      if(dtsVocab.equals("MetaValue"))
      {
        sDefSource = (String)session.getAttribute("ParentMetaSource"); 
        sDefSource = m_servlet.getSourceToken(sDefSource);
        if(sDefSource == null) sDefSource = "";
      }
    //  EVSSearch evs = new EVSSearch(m_classReq, m_classRes, this); 
      EVSMasterTree tree = new EVSMasterTree(m_classReq, dtsVocab, m_servlet);
      Vector vSuperConceptNames = new Vector();
      Vector vSubNames = new Vector();
      Vector vSubNodeNames = new Vector();
      String sName = "";
      String subNodeName = "";
      String strHTML = "";
      String foundConcept = "";
      vAC = this.doVocabSearch(vAC, sConceptCode, dtsVocab, "subConcept", "", sSearchAC, "Exclude", "", 0, false, ilevelStartingConcept, sSearchType);
 /*     if(sSearchType.equals("All"))
        this.getChildConcepts(vAC, dtsVocab, sConceptName, sConceptCode, ilevelStartingConcept, "All");
      else if(sSearchType.equals("Immediate"))
      {
  System.out.println("servlet doGetSubConceptsX Immediate");
         this.getChildConcepts(vAC, dtsVocab, sConceptName, sConceptCode, ilevelStartingConcept, "Immediate");
      } */
      session.setAttribute("vACSearch", vAC);
      if(sSearchAC.equals("ParentConcept"))
        session.setAttribute("vParResult", vAC);
      else if(sSearchAC.equals("ParentConceptVM"))
        session.setAttribute("vParResultVM", vAC);
      else  //for all other
        session.setAttribute("vACSearch", vAC);
        
      session.setAttribute("creRetired", sRetired);
      session.setAttribute("dtsVocab", dtsVocab);
    
      //get the final result vector
      this.get_Result(m_classReq, m_classRes, vResult, "");
      session.setAttribute("results", vResult);
      
      session.setAttribute("creKeyword", sConceptCode);
    /*  if(dtsVocab.equals("NCI_Thesaurus"))
          sConceptName = filterName(sConceptName, "display"); */
      m_classReq.setAttribute("labelKeyword", sConceptName);
      Integer recs = new Integer(vAC.size());
      String recs2 = recs.toString();
      m_classReq.setAttribute("creRecsFound", recs2);  
      session.setAttribute("vACSearch", vAC);
      if(sSearchAC.equals("ParentConceptVM"))
        sUISearchType = "tree";
      m_classReq.setAttribute("UISearchType", sUISearchType);
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
  }

  /**
   * to open the tree to the selected concept 
   * @param actType String action type
   */
  public void openTreeToConcept(String actType)
  {
    try
    {
      HttpSession session = (HttpSession)m_classReq.getSession();
      String sCCodeDB = (String)m_classReq.getParameter("sCCodeDB"); 
      String sCCode = (String)m_classReq.getParameter("sCCode");
      String sCCodeName = (String)m_classReq.getParameter("sCCodeName"); 
      String sNodeID = (String)m_classReq.getParameter("nodeID");
  //logger.debug(sCCode + " code " + sCCodeName + " codedb " + sCCodeDB + " node " + sNodeID);
      String dtsVocab = m_eBean.getVocabAttr(m_eUser, sCCodeDB, "vocabDBOrigin", "vocabName");
      Vector vVocabs = m_eUser.getVocabNameList();
      if (vVocabs == null) vVocabs = new Vector();
      if(!sCCode.equals(""))
      {
        if (actType.equals("OpenTreeToConcept"))
          this.doCollapseAllNodes(dtsVocab);
        else if (actType.equals("OpenTreeToParentConcept"))
        {
          String treeName = "parentTree" + sCCodeName;
          session.setAttribute("SelectedParentName", sCCodeName);
          session.setAttribute("SelectedParentCC", sCCode);
          session.setAttribute("SelectedParentDB", sCCodeDB);
          this.doCollapseAllNodes(treeName);        
        }
        //first get the details from evs as well as from cadsr
        this.doCallConceptSearch(sCCode, sCCodeDB, sCCodeName, dtsVocab);
        //open the tree if from the vocab list else just display teh details
        if (vVocabs.contains(dtsVocab))
        {
          session.setAttribute("dtsVocab", dtsVocab);
          this.doCallTreeSearch(actType, dtsVocab, sCCodeName, sCCode);
        }
      }
      else 
      {
        this.doCollapseAllNodes(dtsVocab);
        this.doTreeSearch(actType, "Blocks");
      }
      m_classReq.setAttribute("labelKeyword", sCCodeName);
      m_servlet.ForwardJSP(m_classReq, m_classRes, "/OpenSearchWindowBlocks.jsp");
    }
    catch (Exception e)
    {
      logger.fatal("Error - openTreeToConcept : " + e.toString());
    }
  }

  /**
   * to open the tree to the selected concept from the parent level 
   * @param actType String action type
   */
  public void openTreeToParentConcept(String actType)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      String sCCodeDB = (String)m_classReq.getParameter("sCCodeDB");
      String sCCode = (String)m_classReq.getParameter("sCCode");
      String sCCodeName = (String)m_classReq.getParameter("sCCodeName");
      String sNodeID = (String)m_classReq.getParameter("nodeID");  
      String treeName = "parentTree" + sCCodeName;
      session.setAttribute("SelectedParentName", sCCodeName);
      session.setAttribute("SelectedParentCC", sCCode);
      session.setAttribute("SelectedParentDB", sCCodeDB);
  //logger.debug(sCCodeDB + " doBlocks sCCode: " + sCCode);
      sCCodeDB = m_eBean.getVocabAttr(m_eUser, sCCodeDB, "vocabDBOrigin", "vocabName");
      if(sCCode != null && !sCCode.equals(""))
      {
        //if(sCCodeDB.equals("NCI Thesaurus"))  sCCodeDB = "Thesaurus/Metathesaurus";
        this.doCollapseAllNodes(treeName);
        this.doTreeOpenToConcept("parentTree", "Blocks", sCCode, sCCodeDB, sCCodeName, sNodeID);
      }
      else 
      {
        this.doCollapseAllNodes(sCCodeDB);
        this.doTreeSearch(actType, "Blocks");
      }
    }
    catch (Exception e)
    {
      logger.fatal("Error - openTreeToParentConcept : " + e.toString());
    }
  }
  
  private void doCallConceptSearch(String searchID, String sCCodeDB, String sCodeName, String dtsVocab)
  {
    try
    {
      HttpSession session = (HttpSession)m_classReq.getSession();
      Vector vAC = new Vector();
      Vector vResult = new Vector();
      String sSearchType = "";
      m_classReq.setAttribute("UISearchType", "term");
      String sSearchAC = (String)session.getAttribute("creSearchAC");
      //first do cadsr search
      if(!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM"))
      {
        if(sSearchAC.equals("ObjectClass"))
          sSearchType = "OC";
        else if(sSearchAC.equals("Property"))
          sSearchType = "PROP";
        else if(sSearchAC.equals("RepTerm"))
          sSearchType = "REP";
        else if(sSearchAC.equals("ObjectQualifier"))
          sSearchType = "ObjQ";
        else if(sSearchAC.equals("PropertyQualifier"))
          sSearchType = "PropQ";
        else if(sSearchAC.equals("RepQualifier"))
          sSearchType = "RepQ";
        GetACSearch serAC = new GetACSearch(m_classReq, m_classRes, m_servlet); 
        if (searchID != null && !searchID.equals(""))
        {
          if(sSearchAC.equals("ObjectClass") || sSearchAC.equals("Property") || sSearchAC.equals("RepTerm"))
            serAC.do_caDSRSearch(searchID, "", "RELEASED", "", vAC, sSearchType, "", "");
          vAC = serAC.do_ConceptSearch(searchID, "", "", "RELEASED", "", "", "", vAC);
        }
      }
    //logger.debug("callConcept Search " + searchID + " voc " + sCCodeDB + " ac " + sSearchAC + " dts " + dtsVocab);
      
      //call vocab search without meta if one of the vocabs
      Vector vVocabs = m_eUser.getVocabNameList();
      if (vVocabs.contains(dtsVocab))
      {
        vAC = this.doVocabSearch(vAC, searchID, dtsVocab, "ConCode", "", sSearchAC, "Include", "", 10, false, -1, "");
        m_classReq.setAttribute("UISearchType", "tree");
      }
      else if (dtsVocab.equals("MetaValue"))
      {
        vAC = this.doMetaSearch(vAC, searchID, "ConCode", "", 10, sCCodeDB);
        String vName = this.getMetaVocabName(sCCodeDB);
      //logger.debug(sCCodeDB + " vocab " + vName);
        session.setAttribute("dtsVocab", vName);
      }
      //store it in the session  
      session.setAttribute("creKeyword", searchID);
      session.setAttribute("vACSearch", vAC);
      this.get_Result(m_classReq, m_classRes, vResult, "");
      session.setAttribute("results", vResult);          
    }    
    catch (Exception e)
    {
      logger.fatal("Error - doCallConceptSearch : " + e.toString());
    }
  }
  
  private void doCallTreeSearch(String actType, String dtsVocab, String sCodeName, String sCode)
  {
    try
    {
      //do the tree search
      HttpSession session = (HttpSession)m_classReq.getSession();  
      String strHTML = "";
      EVSMasterTree tree = new EVSMasterTree(m_classReq, dtsVocab, m_servlet);
  //logger.debug("callTreeSEarch " + sCodeName + " db " + dtsVocab + " code " + sCode);       
      if (actType.equals("OpenTreeToConcept"))
      {
        Vector vStackVector = new Vector();
        Vector vStackVector2 = new Vector();
        strHTML = tree.populateTreeRoots(dtsVocab);
        Stack stackSuperConcepts = new Stack();
        Vector vSuperImmediate = this.getSuperConceptNamesImmediate(dtsVocab, sCodeName, sCode, "");
        session.setAttribute("vSuperImmediate", vSuperImmediate);
        vStackVector2 = tree.buildVectorOfSuperConceptStacks(stackSuperConcepts, dtsVocab, sCode, vStackVector);
    //logger.debug(vStackVector.size() + " tree stack size " + vStackVector2.size() + " super " + vSuperImmediate.size());
        if(vStackVector.size()<1) // must be a root concept
        {
          Tree RootTree = (Tree)tree.m_treesHash.get(dtsVocab);
          if(RootTree != null)
            strHTML = tree.renderHTML(RootTree);        
        }
        else
        {
          Stack vStack = new Stack();
          for(int j=0; j<vStackVector.size(); j++)
          {
            vStack = (Stack)vStackVector.elementAt(j);
            if(vStack.size()>0)
              strHTML = tree.expandTreeToConcept(vStack, dtsVocab, sCode);
          }
        }
      session.setAttribute("vSuperImmediate", null);
      }
      if (actType.equals("OpenTreeToParentConcept"))
      {
          session.setAttribute("ParentConceptCode", sCode);
          session.setAttribute("ParentConcept", sCodeName);
          this.doTreeSearchRequest(sCodeName, sCode, "false", dtsVocab);
          m_classReq.setAttribute("UISearchType", "tree");
          strHTML = tree.populateTreeRoots(dtsVocab);
          strHTML = tree.showParentConceptTree(sCode, dtsVocab, sCodeName);
      }
      session.setAttribute("strHTML", strHTML);
    }    
    catch (Exception e)
    {
      logger.fatal("Error - doCallConceptSearch : " + e.toString());
    }
  }
  
  /**
   * to get the matching thesaurus concept
   * @param eBean EVS Bean of the concept
   * @return return the EVS_Bean
   */
  public EVS_Bean getThesaurusConcept(EVS_Bean eBean)
  {
    try
    {
      HttpSession session = m_classReq.getSession();
      String conID = ""; // eBean.getNCI_CC_VAL();
      String conType = "";  // eBean.getNCI_CC_TYPE();
      String eDB = eBean.getEVS_DATABASE();
      String metaName = m_eUser.getMetaDispName();
      String nciVocab = this.getMetaVocabName(metaName);
      String dtsVocab = eBean.getVocabAttr(m_eUser, eDB, "vocabDBOrigin", "vocabName");
      Vector<EVS_Bean> vList = new Vector<EVS_Bean>();
      //continue only if term is not from Thesaururs
      if (dtsVocab != null && !dtsVocab.equals(nciVocab))
      {
        if (!dtsVocab.equals("MetaValue"))
        {
          conType = eBean.getMETA_CODE_TYPE();
      //logger.debug(conType + " evs " + eBean.getMETA_CODE_VAL() + " con " + eBean.getLONG_NAME());
          //check if can be searched by meta type properlty (UMLS or NCI_META)
          if (conType != null && !conType.equals(""))
          {
            conType = this.getNCIMetaCodeType(conType, "byKey");
            conID = eBean.getMETA_CODE_VAL();
            vList = this.doVocabSearch(vList, conID, nciVocab, "Name", conType, "", 
                "Exclude", "", 10, false, -1, "");
            if (vList != null && vList.size() > 0)
            {
              eBean = this.getNCIDefinition(vList);  //get the right definition
              return eBean;
            }
            else
              conID = "";
          }
          if (conID == null || conID.equals(""))
          {
            Hashtable vhash = m_eUser.getVocab_Attr();
            if (vhash == null) return eBean;
            //get the vocab source
            EVS_UserBean eUser = (EVS_UserBean)vhash.get(dtsVocab);
            if (eUser == null) return eBean;
            String vSource = eUser.getVocabMetaSource();
            if (vSource == null || vSource.equals("")) return eBean;
            //get its equivalent meta code
            conID = eBean.getNCI_CC_VAL();
            vList = new Vector<EVS_Bean>();
            vList = this.doMetaSearch(vList, conID, "MetaCode", vSource, 10, metaName);          
            if (vList == null || vList.size() < 1) return eBean;
            //get the value
            conID = "";
            EVS_Bean mBean = (EVS_Bean)vList.elementAt(0);
            if (mBean != null) conID = mBean.getNCI_CC_VAL(); 
            for (int j=0; j<vList.size(); j++)
            {
            EVS_Bean tBean = (EVS_Bean)vList.elementAt(j);
            String sConID = tBean.getNCI_CC_VAL(); 
    //logger.debug(j + " loop aftermetacode " + sConID + " name " + tBean.getLONG_NAME());
            }
          }
        }
        if (conID == null || conID.equals(""))
          conID = eBean.getNCI_CC_VAL();  //go back to original id if not found
        
        //now get the meta concept        
        vList = new Vector<EVS_Bean>();
        conType = this.getNCIMetaCodeType(conID, "byID");
     //logger.debug(dtsVocab + " metasearch in meta " + conID + conType);
        vList = new Vector<EVS_Bean>();
        vList = this.doVocabSearch(vList, conID, nciVocab, "Name", conType, "", 
              "Exclude", "", 10, false, -1, "");
        if (vList != null && vList.size() > 0)
          eBean = this.getNCIDefinition(vList);  // (EVS_Bean)vList.elementAt(0);        
      }
      //logger.debug(eBean.getEVS_ORIGIN() + " con name " + eBean.getLONG_NAME());
    }    
    catch (Exception e)
    {
      logger.fatal("Error - getThesaurusConcept : " + e.toString());
    }
    return eBean;
  }
  
  private EVS_Bean getNCIDefinition(Vector vList)
  {
   //logger.debug("get nci def " + vList.size());
    EVS_Bean eBean = (EVS_Bean)vList.elementAt(0);
    Vector vNCIsrc = m_eUser.getNCIDefSrcList();
    if (vNCIsrc == null) vNCIsrc = new Vector();
    boolean isDefMatched = false;
    //loop through list of nci sources to get the right order
    for (int i = 0; i<vNCIsrc.size(); i++)
    {
      String srcNCI = (String)vNCIsrc.elementAt(i);
      //loop through list of def sources for the concept
      for (int k=0; k<vList.size(); k++)
      {
        EVS_Bean thisBean = (EVS_Bean)vList.elementAt(k);
        String sSrc = thisBean.getEVS_DEF_SOURCE();
    //logger.debug(thisBean.getNCI_CC_VAL() + " nci def " + sSrc + " nci src " + srcNCI);
        //match def source order to the bean
        if (sSrc.equalsIgnoreCase(srcNCI))
        {
          isDefMatched = true;
          eBean = (EVS_Bean)vList.elementAt(k);   //to return the def matched bean
          break;
        }
      }
      if (isDefMatched) break;  //no need to continue if found the right def source
    }
    //update the status message
    InsACService insAC = new InsACService(m_classReq, m_classRes, m_servlet);
    insAC.storeStatusMsg("The selected Concept will be replaced by the matching NCI Thesaurus Concept : " + eBean.getLONG_NAME());
    
    return eBean;  //return teh bean
  }
//close the class
} 
