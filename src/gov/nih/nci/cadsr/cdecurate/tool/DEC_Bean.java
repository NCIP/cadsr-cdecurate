// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/DEC_Bean.java,v 1.37 2007-01-26 19:30:37 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.util.*;

/**
 * The DEC_Bean encapsulates the DEC information and is stored in the
 * session after the user has created a new Data Element Concept.
 * <P>
 * @author Joe Zhou
 * @version 3.0
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

public class DEC_Bean extends AC_Bean {

  private static final long serialVersionUID = 5924881666562977357L;
  
// attributes
  private String RETURN_CODE;
  private String DEC_DEC_IDSEQ;
  private String DEC_PREFERRED_NAME;
  private String DEC_CONTE_IDSEQ;
  private String DEC_VERSION;
  private String DEC_PREFERRED_DEFINITION;
  private String DEC_CD_IDSEQ;
  private String DEC_ASL_NAME;
  private String DEC_LATEST_VERSION_IND;
  private String DEC_LONG_NAME;
  private String DEC_OCL_NAME;
  private String DEC_OBJ_ASL_NAME;
  private String DEC_OCL_IDSEQ;
  private String DEC_PROPL_NAME;
  private String DEC_PROP_ASL_NAME;
  private String DEC_PROPL_IDSEQ;
  private String DEC_BEGIN_DATE;
  private String DEC_END_DATE;
  private String DEC_CHANGE_NOTE;
  private String DEC_CREATED_BY;
  private String DEC_DATE_CREATED;
  private String DEC_MODIFIED_BY;
  private String DEC_DATE_MODIFIED;
  private String DEC_DELETED_IND;
  private String DEC_PROTOCOL_ID;
  private String DEC_CRF_NAME;
  private String DEC_TYPE_NAME;
  private String DEC_ALIAS_NAME;
  private String DEC_USEDBY_CONTEXT;
  private String DEC_Obj_Definition;
  private String DEC_Prop_Definition;
  private String DEC_DEC_ID;
  private String DEC_SOURCE;

  // Not required for Procedure SET_DEC
  private String DEC_CD_NAME;
  private String DEC_CONTEXT_NAME;
  private String DEC_LANGUAGE;
  private String DEC_LANGUAGE_IDSEQ;
  private String DEC_DES_ALIAS_ID;
  private boolean DEC_CHECKED;

  //cs-csi relationship
  private Vector DEC_SELECTED_CONTEXT_ID;  
  private Vector DEC_CS_NAME;  //store CS name
  private Vector DEC_CS_ID;  //store CS_IDSEQs
  private Vector DEC_CSI_NAME; //store CSI name
  private Vector DEC_CSI_ID; //store CSI_IDSEQs
  private Vector<AC_CSI_Bean> DEC_AC_CSI_VECTOR;
  private Vector DEC_AC_CSI_ID;
  private Vector DEC_CS_CSI_ID;
  
  //altname ref docs
  private Vector AC_ALT_NAMES;
  private Vector AC_REF_DOCS;
  //concept name
  private String AC_CONCEPT_NAME;
  //contact inf
  private Hashtable<String, AC_CONTACT_Bean> AC_CONTACTS;
  private String REFERENCE_DOCUMENT;
  private String ALTERNATE_NAME;
  
  private Vector<String> DEC_OC_QUALIFIER_NAMES;
  private Vector DEC_PROP_QUALIFIER_NAMES;
  private Vector<String> DEC_OC_QUALIFIER_CODES;
  private Vector DEC_PROP_QUALIFIER_CODES;
  private Vector<String> DEC_OC_QUALIFIER_DB;
  private Vector DEC_PROP_QUALIFIER_DB;
   
  private String DEC_OC_CONCEPT_CODE;
  private String DEC_OC_EVS_CUI_ORIGEN;
  private String DEC_OC_EVS_CUI_SOURCE;
  private String DEC_OC_DEFINITION_SOURCE;
  
  private String DEC_OC_QUAL_CONCEPT_CODE;
  private String DEC_OC_QUAL_EVS_CUI_ORIGEN;
  private String DEC_OC_QUAL_EVS_CUI_SOURCE;
  private String DEC_OC_QUAL_DEFINITION_SOURCE;
  
  private String DEC_PROP_CONCEPT_CODE;
  private String DEC_PROP_EVS_CUI_ORIGEN;
  private String DEC_PROP_EVS_CUI_SOURCE;
  private String DEC_PROP_DEFINITION_SOURCE;
  
  private String DEC_PROP_QUAL_CONCEPT_CODE;
  private String DEC_PROP_QUAL_EVS_CUI_ORIGEN;
  private String DEC_PROP_QUAL_EVS_CUI_SOURCE;
  private String DEC_PROP_QUAL_DEFINITION_SOURCE; 
  
  private String DEC_OC_CONDR_IDSEQ;
  private String DEC_PROP_CONDR_IDSEQ;  
  private String DEC_OCL_NAME_PRIMARY;
  private String DEC_PROPL_NAME_PRIMARY;
  
  private String AC_SYS_PREF_NAME;
  private String AC_ABBR_PREF_NAME;
  private String AC_USER_PREF_NAME;
  private String AC_PREF_NAME_TYPE;
  /**
   * Constructor
  */
  public DEC_Bean() {
  }

  /**
   * makes a copy of the bean
   *
   * @param copyBean passin the bean whose attributes  need to be copied and returned.
   *
   * @return DEC_Bean returns this bean after copying its attributes
   */
  public DEC_Bean cloneDEC_Bean(DEC_Bean copyBean)
  {
			this.setDEC_PREFERRED_NAME(copyBean.getDEC_PREFERRED_NAME());
			this.setDEC_LONG_NAME(copyBean.getDEC_LONG_NAME());
			this.setDEC_PREFERRED_DEFINITION(copyBean.getDEC_PREFERRED_DEFINITION());
			this.setDEC_ASL_NAME(copyBean.getDEC_ASL_NAME());
			this.setDEC_CONTE_IDSEQ(copyBean.getDEC_CONTE_IDSEQ());
			this.setDEC_BEGIN_DATE(copyBean.getDEC_BEGIN_DATE());
			this.setDEC_END_DATE(copyBean.getDEC_END_DATE());
			this.setDEC_VERSION(copyBean.getDEC_VERSION());
			this.setDEC_DEC_IDSEQ(copyBean.getDEC_DEC_IDSEQ());
			this.setDEC_CHANGE_NOTE(copyBean.getDEC_CHANGE_NOTE());
			this.setDEC_CONTEXT_NAME(copyBean.getDEC_CONTEXT_NAME());
			this.setDEC_CD_NAME(copyBean.getDEC_CD_NAME());
			this.setDEC_OCL_NAME(copyBean.getDEC_OCL_NAME());
	 		this.setDEC_OCL_IDSEQ(copyBean.getDEC_OCL_IDSEQ());
	 		this.setDEC_Obj_Definition(copyBean.getDEC_Obj_Definition());
			this.setDEC_PROPL_NAME(copyBean.getDEC_PROPL_NAME());
			this.setDEC_PROPL_IDSEQ(copyBean.getDEC_PROPL_IDSEQ());
			this.setDEC_Prop_Definition(copyBean.getDEC_Prop_Definition());
			this.setDEC_OBJ_ASL_NAME(copyBean.getDEC_OBJ_ASL_NAME());
			this.setDEC_PROP_ASL_NAME(copyBean.getDEC_PROP_ASL_NAME());
			this.setDEC_LANGUAGE(copyBean.getDEC_LANGUAGE());
			this.setDEC_LANGUAGE_IDSEQ(copyBean.getDEC_LANGUAGE_IDSEQ());
			this.setDEC_CD_IDSEQ(copyBean.getDEC_CD_IDSEQ());
			this.setDEC_PROTOCOL_ID(copyBean.getDEC_PROTOCOL_ID());
			this.setDEC_CRF_NAME(copyBean.getDEC_CRF_NAME());
			this.setDEC_TYPE_NAME(copyBean.getDEC_TYPE_NAME());
			this.setDEC_DES_ALIAS_ID(copyBean.getDEC_DES_ALIAS_ID());
			this.setDEC_USEDBY_CONTEXT(copyBean.getDEC_USEDBY_CONTEXT());
			this.setDEC_DEC_ID(copyBean.getDEC_DEC_ID());
			this.setDEC_SOURCE(copyBean.getDEC_SOURCE());

      this.setDEC_DATE_CREATED(copyBean.getDEC_DATE_CREATED());
      this.setDEC_CREATED_BY(copyBean.getDEC_CREATED_BY());
      this.setDEC_DATE_MODIFIED(copyBean.getDEC_DATE_MODIFIED());
      this.setDEC_MODIFIED_BY(copyBean.getDEC_MODIFIED_BY());
      
      this.setAC_SELECTED_CONTEXT_ID(copyBean.getAC_SELECTED_CONTEXT_ID());
      this.setAC_CS_NAME(copyBean.getAC_CS_NAME());
      this.setAC_CS_ID(copyBean.getAC_CS_ID());
      this.setAC_CSI_NAME(copyBean.getAC_CSI_NAME());
      this.setAC_CSI_ID(copyBean.getAC_CSI_ID());
      this.setAC_AC_CSI_VECTOR(copyBean.getAC_AC_CSI_VECTOR());
      this.setAC_AC_CSI_ID(copyBean.getAC_AC_CSI_ID());
      this.setAC_CS_CSI_ID(copyBean.getAC_CS_CSI_ID());
      this.setAC_ALT_NAMES(copyBean.getAC_ALT_NAMES());
      this.setAC_REF_DOCS(copyBean.getAC_REF_DOCS());
      this.setAC_CONCEPT_NAME(copyBean.getAC_CONCEPT_NAME());
      this.setAC_CONTACTS(copyBean.getAC_CONTACTS());
      this.setREFERENCE_DOCUMENT(copyBean.getREFERENCE_DOCUMENT());
      this.setALTERNATE_NAME(copyBean.getALTERNATE_NAME());
      
      this.setDEC_OC_CONCEPT_CODE(copyBean.getDEC_OC_CONCEPT_CODE());
			this.setDEC_OC_EVS_CUI_ORIGEN(copyBean.getDEC_OC_EVS_CUI_ORIGEN());
			this.setDEC_OC_EVS_CUI_SOURCE(copyBean.getDEC_OC_EVS_CUI_SOURCE());
			this.setDEC_OC_DEFINITION_SOURCE(copyBean.getDEC_OC_DEFINITION_SOURCE());
      
      this.setDEC_OC_QUAL_CONCEPT_CODE(copyBean.getDEC_OC_QUAL_CONCEPT_CODE());
			this.setDEC_OC_QUAL_EVS_CUI_ORIGEN(copyBean.getDEC_OC_QUAL_EVS_CUI_ORIGEN());
			this.setDEC_OC_QUAL_EVS_CUI_SOURCE(copyBean.getDEC_OC_QUAL_EVS_CUI_SOURCE());
			this.setDEC_OC_QUAL_DEFINITION_SOURCE(copyBean.getDEC_OC_QUAL_DEFINITION_SOURCE());
      
      this.setDEC_PROP_CONCEPT_CODE(copyBean.getDEC_PROP_CONCEPT_CODE());
			this.setDEC_PROP_EVS_CUI_ORIGEN(copyBean.getDEC_PROP_EVS_CUI_ORIGEN());
			this.setDEC_PROP_EVS_CUI_SOURCE(copyBean.getDEC_PROP_EVS_CUI_SOURCE());
			this.setDEC_PROP_DEFINITION_SOURCE(copyBean.getDEC_PROP_DEFINITION_SOURCE());
      
      this.setDEC_PROP_QUAL_CONCEPT_CODE(copyBean.getDEC_PROP_QUAL_CONCEPT_CODE());
			this.setDEC_PROP_QUAL_EVS_CUI_ORIGEN(copyBean.getDEC_PROP_QUAL_EVS_CUI_ORIGEN());
			this.setDEC_PROP_QUAL_EVS_CUI_SOURCE(copyBean.getDEC_PROP_QUAL_EVS_CUI_SOURCE());
			this.setDEC_PROP_QUAL_DEFINITION_SOURCE(copyBean.getDEC_PROP_QUAL_DEFINITION_SOURCE());
      
      this.setDEC_OC_QUALIFIER_NAMES(copyBean.getDEC_OC_QUALIFIER_NAMES());
      this.setDEC_PROP_QUALIFIER_NAMES(copyBean.getDEC_PROP_QUALIFIER_NAMES());
      this.setDEC_OC_QUALIFIER_CODES(copyBean.getDEC_OC_QUALIFIER_CODES());
      this.setDEC_PROP_QUALIFIER_CODES(copyBean.getDEC_PROP_QUALIFIER_CODES());
      this.setDEC_OC_QUALIFIER_DB(copyBean.getDEC_OC_QUALIFIER_DB());
      this.setDEC_PROP_QUALIFIER_DB(copyBean.getDEC_PROP_QUALIFIER_DB());
      
      this.setDEC_OC_CONDR_IDSEQ(copyBean.getDEC_OC_CONDR_IDSEQ());
      this.setDEC_PROP_CONDR_IDSEQ(copyBean.getDEC_PROP_CONDR_IDSEQ()); 
      this.setDEC_OCL_NAME_PRIMARY(copyBean.getDEC_OCL_NAME_PRIMARY());
      this.setDEC_PROPL_NAME_PRIMARY(copyBean.getDEC_PROPL_NAME_PRIMARY());
      
      this.setAC_ABBR_PREF_NAME(copyBean.getAC_ABBR_PREF_NAME());
      this.setAC_SYS_PREF_NAME(copyBean.getAC_SYS_PREF_NAME());
      this.setAC_USER_PREF_NAME(copyBean.getAC_USER_PREF_NAME());
      this.setAC_PREF_NAME_TYPE(copyBean.getAC_PREF_NAME_TYPE());

			return this;
	}

  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
   */
  public void setRETURN_CODE(String s)
  {
      this.RETURN_CODE = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_DEC_IDSEQ(String s)
  {
      this.DEC_DEC_IDSEQ = s;
  }
	/**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_PREFERRED_NAME(String s)
  {
      this.DEC_PREFERRED_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_CONTE_IDSEQ(String s)
  {
      this.DEC_CONTE_IDSEQ = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_VERSION(String s)
  {
      this.DEC_VERSION = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_PREFERRED_DEFINITION(String s)
  {
      this.DEC_PREFERRED_DEFINITION = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_LONG_NAME(String s)
  {
      this.DEC_LONG_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_ASL_NAME(String s)
  {
      this.DEC_ASL_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_CD_IDSEQ(String s)
  {
      this.DEC_CD_IDSEQ = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
   public void setDEC_CD_NAME(String s)
  {
      this.DEC_CD_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_LATEST_VERSION_IND(String s)
  {
      this.DEC_LATEST_VERSION_IND = s;
  }


  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_BEGIN_DATE(String s)
  {
      this.DEC_BEGIN_DATE = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_END_DATE(String s)
  {
      this.DEC_END_DATE = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_CHANGE_NOTE(String s)
  {
      this.DEC_CHANGE_NOTE = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_CREATED_BY(String s)
  {
      this.DEC_CREATED_BY = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_DATE_CREATED(String s)
  {
      this.DEC_DATE_CREATED = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_MODIFIED_BY(String s)
  {
      this.DEC_MODIFIED_BY = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_DATE_MODIFIED(String s)
  {
      this.DEC_DATE_MODIFIED = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_DELETED_IND(String s)
  {
      this.DEC_DELETED_IND = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_CONTEXT_NAME(String s)
  {
      this.DEC_CONTEXT_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_LANGUAGE(String s)
  {
      this.DEC_LANGUAGE = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_LANGUAGE_IDSEQ(String s)
  {
      this.DEC_LANGUAGE_IDSEQ = s;
  }
  /**
   * The setDEC_PROTOCOL_ID method sets the DEC_PROTOCOL_ID for this bean.
   *
   * @param s The DEC_PROTOCOL_ID to set
  */
  public void setDEC_PROTOCOL_ID(String s)
  {
      this.DEC_PROTOCOL_ID = s;
  }
  /**
   * The setDEC_CRF_NAME method sets the DEC_CRF_NAME for this bean.
   *
   * @param s The DEC_CRF_NAME to set
  */
  public void setDEC_CRF_NAME(String s)
  {
      this.DEC_CRF_NAME = s;
  }
  /**
   * The setDEC_TYPE_NAME method sets the DEC_TYPE_NAME for this bean.
   *
   * @param s The DEC_TYPE_NAME to set
  */
  public void setDEC_TYPE_NAME(String s)
  {
      this.DEC_TYPE_NAME = s;
  }
  /**
   * The setDEC_DES_ALIAS_ID method sets the DEC_DES_ALIAS_ID for this bean.
   *
   * @param s The DEC_DES_ALIAS_ID to set
  */
  public void setDEC_DES_ALIAS_ID(String s)
  {
      this.DEC_DES_ALIAS_ID = s;
  }
	/**
	 * The setRDEC_ALIAS_NAME method sets the ALIAS_NAME for this bean.
	 *
	 * @param s The ALIAS_NAME to set
	*/
	public void setDEC_ALIAS_NAME(String s)
	{
			this.DEC_ALIAS_NAME = s;
	}
	/**
	 * The setRDEC_USEDBY_CONTEXT method sets the USEDBY_CONTEXT for this bean.
	 *
	 * @param s The USEDBY_CONTEXT to set
	*/
	public void setDEC_USEDBY_CONTEXT(String s)
	{
			this.DEC_USEDBY_CONTEXT = s;
	}
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_OCL_IDSEQ(String s)
  {
      this.DEC_OCL_IDSEQ = s;
  }
   /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_OBJ_ASL_NAME(String s)
  {
      this.DEC_OBJ_ASL_NAME = s;
  }
   /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_PROPL_IDSEQ(String s)
  {
      this.DEC_PROPL_IDSEQ = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_OCL_NAME(String s)
  {
      this.DEC_OCL_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_PROP_ASL_NAME(String s)
  {
      this.DEC_PROP_ASL_NAME = s;
  }
  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDEC_PROPL_NAME(String s)
  {
      this.DEC_PROPL_NAME = s;
  }
   /**
   * The setDEC_Obj_Definition method sets the DEC_Obj_Definition for this bean.
   *
   * @param s The DEC_Obj_Definition to set
  */
  public void setDEC_Obj_Definition(String s)
  {
      this.DEC_Obj_Definition = s;
  }
  /**
   * The setDEC_Prop_Definition method sets the DEC_Prop_Definition for this bean.
   *
   * @param s The DEC_Prop_Definition to set
  */
  public void setDEC_Prop_Definition(String s)
  {
      this.DEC_Prop_Definition = s;
  }
  
  
  /**
   * The setDEC_DEC_ID method sets the DEC_DEC_ID for this bean.
   *
   * @param s The DEC_DEC_ID to set
  */
  public void setDEC_DEC_ID(String s)
  {
      this.DEC_DEC_ID = s;
  }
   /**
   * The setDEC_SOURCE method sets the DEC_SOURCE for this bean.
   *
   * @param s The DEC_SOURCE to set
  */
  public void setDEC_SOURCE(String s)
  {
      this.DEC_SOURCE = s;
  }
   /**
   * The setDEC_CHECKED method sets the DEC_CHECKED for this bean.
   *
   * @param b The DEC_CHECKED to set
  */
  public void setDEC_CHECKED(boolean b)
  {
      this.DEC_CHECKED = b;
  }
  /**
   * The setAC_SELECTED_CONTEXT_ID method sets the DEC_SELECTED_CONTEXT_ID for this bean.
   *
   * @param s The DEC_SELECTED_CONTEXT_ID to set
   */
  public void setAC_SELECTED_CONTEXT_ID(Vector s)
  {
      this.DEC_SELECTED_CONTEXT_ID = s;
  }
  /**
   * The setAC_CS method sets the DEC_CS for this bean.
   *
   * @param v The DEC_CS to set
  */
  public void setAC_CS_NAME(Vector v)
  {
      this.DEC_CS_NAME = v;
  }
  /**
   * The setAC_CS_ID method sets the DEC_CS_ID for this bean.
   *
   * @param v The DEC_CS_ID to set
  */
  public void setAC_CS_ID(Vector v)
  {
      this.DEC_CS_ID = v;
  }
  /**
   * The setAC_CSI method sets the DEC_CSI for this bean.
   *
   * @param v The DEC_CSI to set
  */
  public void setAC_CSI_NAME(Vector v)
  {
      this.DEC_CSI_NAME = v;
  }
  /**
   * The setAC_CSI_ID method sets the DEC_CSI_ID for this bean.
   *
   * @param v The DEC_CSI_ID to set
  */
  public void setAC_CSI_ID(Vector v)
  {
      this.DEC_CSI_ID = v;
  }
  /**
   * The setAC_AC_CSI_VECTOR method sets the DEC_AC_CSI_VECTOR for this bean.
   *
   * @param v The DEC_AC_CSI_VECTOR to set
  */
  public void setAC_AC_CSI_VECTOR(Vector<AC_CSI_Bean> v)
  {
      this.DEC_AC_CSI_VECTOR = v;
  }
  /**
   * The setAC_AC_CSI_ID method sets the DEC_AC_CSI_ID for this bean.
   *
   * @param v The DEC_AC_CSI_ID to set
  */
  public void setAC_AC_CSI_ID(Vector v)
  {
      this.DEC_AC_CSI_ID = v;
  }
  /**
   * The setAC_CS_CSI_ID method sets the DEC_CS_CSI_ID for this bean.
   *
   * @param v The DEC_CS_CSI_ID to set
  */
  public void setAC_CS_CSI_ID(Vector v)
  {
      this.DEC_CS_CSI_ID = v;
  }
  /**
   * The setAC_ALT_NAMES method sets the AC_ALT_NAMES for this bean.
   *
   * @param v The AC_ALT_NAMES to set
  */
  public void setAC_ALT_NAMES(Vector v)
  {
      this.AC_ALT_NAMES = v;
  }
  /**
   * The setAC_REF_DOCS method sets the AC_REF_DOCS for this bean.
   *
   * @param v The AC_REF_DOCS to set
  */
  public void setAC_REF_DOCS(Vector v)
  {
      this.AC_REF_DOCS = v;
  }
  /**
   * The setAC_CONCEPT_NAME method sets the AC_CONCEPT_NAME for this bean.
   *
   * @param s The AC_CONCEPT_NAME to set
  */
  public void setAC_CONCEPT_NAME(String s)
  {
      this.AC_CONCEPT_NAME = s;
  }

  /**
   * @param ac_contacts The aC_CONTACTS to set.
   */
  public void setAC_CONTACTS(Hashtable<String, AC_CONTACT_Bean> ac_contacts)
  {
    AC_CONTACTS = ac_contacts;
  }

  /**
   * The setREFERENCE_DOCUMENT_ method sets the REFERENCE_DOCUMENT for this bean.
   *
   * @param s The REFERENCE_DOCUMENT to set
  */
  public void setREFERENCE_DOCUMENT(String s)
  {
      this.REFERENCE_DOCUMENT = s;
  }

  /**
   * @param alternate_name The aLTERNATE_NAME to set.
   */
  public void setALTERNATE_NAME(String alternate_name)
  {
    ALTERNATE_NAME = alternate_name;
  }

  /**
   * The setDEC_OC_CONCEPT_CODE method sets the DEC_OC_CONCEPT_CODE for this bean.
   *
   * @param s The DEC_OC_CONCEPT_CODE to set
 */
  public void setDEC_OC_CONCEPT_CODE(String s)
  {
      this.DEC_OC_CONCEPT_CODE = s;
  }
  
/**
   * The setDEC_OC_EVS_CUI_ORIGEN method sets the DEC_OC_EVS_CUI_ORIGEN for this bean.
   *
   * @param s The DEC_OC_EVS_CUI_ORIGEN to set
 */
  public void setDEC_OC_EVS_CUI_ORIGEN(String s)
  {
      this.DEC_OC_EVS_CUI_ORIGEN = s;
  }
  
  /**
   * The setDEC_PROP_OC_EVS_CUI_SOURCE method sets the DEC_OC_EVS_CUI_SOURCE for this bean.
   *
   * @param s The DEC_OC_EVS_CUI_SOURCE to set
 */
  public void setDEC_OC_EVS_CUI_SOURCE(String s)
  {
      this.DEC_OC_EVS_CUI_SOURCE = s;
  }
  
 /**
   * The setDEC_OC_DEFINITION_SOURCE method sets the DEC_OC_DEFINITION_SOURCE for this bean.
   *
   * @param s The DEC_OC_DEFINITION_SOURCE to set
 */
  public void setDEC_OC_DEFINITION_SOURCE(String s)
  {
      this.DEC_OC_DEFINITION_SOURCE = s;
  }
  
/**
   * The setDEC_OC_QUAL_CONCEPT_CODE method sets the DEC_OC_QUAL_CONCEPT_CODE for this bean.
   *
   * @param s The DEC_OC_QUAL_CONCEPT_CODE to set
 */
  public void setDEC_OC_QUAL_CONCEPT_CODE(String s)
  {
      this.DEC_OC_QUAL_CONCEPT_CODE = s;
  }
  
/**
   * The setDEC_OC_QUAL_EVS_CUI_ORIGEN method sets the DEC_OC_QUAL_EVS_CUI_ORIGEN for this bean.
   *
   * @param s The DEC_OC_EVS_CUI_ORIGEN to set
 */
  public void setDEC_OC_QUAL_EVS_CUI_ORIGEN(String s)
  {
      this.DEC_OC_QUAL_EVS_CUI_ORIGEN = s;
  }
  
  /**
   * The setDEC_PROP_OC_QUAL_EVS_CUI_SOURCE method sets the DEC_OC_QUAL_EVS_CUI_SOURCE for this bean.
   *
   * @param s The DEC_OC_QUAL_EVS_CUI_SOURCE to set
 */
  public void setDEC_OC_QUAL_EVS_CUI_SOURCE(String s)
  {
      this.DEC_OC_QUAL_EVS_CUI_SOURCE = s;
  }
  
 /**
   * The setDEC_OC_QUAL_DEFINITION_SOURCE method sets the DEC_OC_QUAL_DEFINITION_SOURCE for this bean.
   *
   * @param s The DEC_OC_QUAL_DEFINITION_SOURCE to set
 */
  public void setDEC_OC_QUAL_DEFINITION_SOURCE(String s)
  {
      this.DEC_OC_QUAL_DEFINITION_SOURCE = s;
  }
  
/**
   * The setDEC_PROP_CONCEPT_CODE method sets the DEC_PROP_CONCEPT_CODE for this bean.
   *
   * @param s The DEC_PROP_CONCEPT_CODE to set
 */
  public void setDEC_PROP_CONCEPT_CODE(String s)
  {
      this.DEC_PROP_CONCEPT_CODE = s;
  }
  
/**
   * The setDEC_PROP_EVS_CUI_ORIGEN method sets the DEC_PROP_EVS_CUI_ORIGEN for this bean.
   *
   * @param s The DEC_PROP_EVS_CUI_ORIGEN to set
 */
  public void setDEC_PROP_EVS_CUI_ORIGEN(String s)
  {
      this.DEC_PROP_EVS_CUI_ORIGEN = s;
  }
  
  /**
   * The setDEC_PROP_PROP_EVS_CUI_SOURCE method sets the DEC_PROP_EVS_CUI_SOURCE for this bean.
   *
   * @param s The DEC_PROP_EVS_CUI_SOURCE to set
 */
  public void setDEC_PROP_EVS_CUI_SOURCE(String s)
  {
      this.DEC_PROP_EVS_CUI_SOURCE = s;
  }
  
 /**
   * The setDEC_PROP_DEFINITION_SOURCE method sets the DEC_PROP_DEFINITION_SOURCE for this bean.
   *
   * @param s The DEC_PROP_DEFINITION_SOURCE to set
 */
  public void setDEC_PROP_DEFINITION_SOURCE(String s)
  {
      this.DEC_PROP_DEFINITION_SOURCE = s;
  }
  
/**
   * The setDEC_PROP_QUAL_CONCEPT_CODE method sets the DEC_PROP_QUAL_CONCEPT_CODE for this bean.
   *
   * @param s The DEC_PROP_QUAL_CONCEPT_CODE to set
 */
  public void setDEC_PROP_QUAL_CONCEPT_CODE(String s)
  {
      this.DEC_PROP_QUAL_CONCEPT_CODE = s;
  }  
/**
   * The setDEC_PROP_QUAL_EVS_CUI_ORIGEN method sets the DEC_PROP_QUAL_EVS_CUI_ORIGEN for this bean.
   *
   * @param s The DEC_PROP_EVS_CUI_ORIGEN to set
 */
  public void setDEC_PROP_QUAL_EVS_CUI_ORIGEN(String s)
  {
      this.DEC_PROP_QUAL_EVS_CUI_ORIGEN = s;
  }
  /**
   * The setDEC_PROP_PROP_QUAL_EVS_CUI_SOURCE method sets the DEC_PROP_QUAL_EVS_CUI_SOURCE for this bean.
   *
   * @param s The DEC_PROP_QUAL_EVS_CUI_SOURCE to set
 */
  public void setDEC_PROP_QUAL_EVS_CUI_SOURCE(String s)
  {
      this.DEC_PROP_QUAL_EVS_CUI_SOURCE = s;
  }
 /**
   * The setDEC_PROP_QUAL_DEFINITION_SOURCE method sets the DEC_PROP_QUAL_DEFINITION_SOURCE for this bean.
   *
   * @param s The DEC_PROP_QUAL_DEFINITION_SOURCE to set
 */
  public void setDEC_PROP_QUAL_DEFINITION_SOURCE(String s)
  {
      this.DEC_PROP_QUAL_DEFINITION_SOURCE = s;
  } 
/**
   * The setDEC_OC_QUALIFIER_NAMES method sets the DEC_OC_QUALIFIER_NAMES for this bean.
   *
   * @param v The DEC_OC_QUALIFIER_NAMES to set
  */
  public void setDEC_OC_QUALIFIER_NAMES(Vector<String> v)
  {
      this.DEC_OC_QUALIFIER_NAMES = v;
  }
/**
   * The setDEC_OC_QUALIFIER_CODES method sets the DEC_OC_QUALIFIER_CODES for this bean.
   *
   * @param v The DEC_OC_QUALIFIER_CODES to set
  */
  public void setDEC_OC_QUALIFIER_CODES(Vector<String> v)
  {
      this.DEC_OC_QUALIFIER_CODES = v;
  }
/**
   * The setDEC_OC_QUALIFIER_DB method sets the DEC_OC_QUALIFIER_DB for this bean.
   *
   * @param v The DEC_OC_QUALIFIER_DB to set
  */
  public void setDEC_OC_QUALIFIER_DB(Vector<String> v)
  {
      this.DEC_OC_QUALIFIER_DB = v;
  }
/**
   * The setDEC_PROP_QUALIFIER_NAMES method sets the DEC_PROP_QUALIFIER_NAMES for this bean.
   *
   * @param v The DEC_PROP_QUALIFIER_NAMES to set
  */
  public void setDEC_PROP_QUALIFIER_NAMES(Vector v)
  {
      this.DEC_PROP_QUALIFIER_NAMES = v;
  }
/**
   * The setDEC_PROP_QUALIFIER_CODES method sets the DEC_PROP_QUALIFIER_CODES for this bean.
   *
   * @param v The DEC_PROP_QUALIFIER_CODES to set
  */
  public void setDEC_PROP_QUALIFIER_CODES(Vector v)
  {
      this.DEC_PROP_QUALIFIER_CODES = v;
  }
  /**
   * The setDEC_PROP_QUALIFIER_DB method sets the DEC_PROP_QUALIFIER_DB for this bean.
   *
   * @param v The DEC_PROP_QUALIFIER_DB to set
  */
  public void setDEC_PROP_QUALIFIER_DB(Vector v)
  {
      this.DEC_PROP_QUALIFIER_DB = v;
  }
/**
   * The setDEC_OC_CONDR_IDSEQ method sets the DEC_OC_CONDR_IDSEQ for this bean.
   *
   * @param s The DEC_OC_CONDR_IDSEQ to set
 */
  public void setDEC_OC_CONDR_IDSEQ(String s)
  {
      this.DEC_OC_CONDR_IDSEQ = s;
  }
/**
   * The setDEC_PROP_CONDR_IDSEQ method sets the DEC_PROP_CONDR_IDSEQ for this bean.
   *
   * @param s The DEC_PROP_CONDR_IDSEQ to set
 */
  public void setDEC_PROP_CONDR_IDSEQ(String s)
  {
      this.DEC_PROP_CONDR_IDSEQ = s;
  }
/**
   * The setDEC_OCL_NAME_PRIMARY method sets the DEC_OCL_NAME_PRIMARY for this bean.
   *
   * @param s The DEC_OCL_NAME_PRIMARY to set
 */
  public void setDEC_OCL_NAME_PRIMARY(String s)
  {
      this.DEC_OCL_NAME_PRIMARY = s;
  } 
/**
   * The setDEC_PROPL_NAME_PRIMARY method sets the DEC_PROPL_NAME_PRIMARY for this bean.
   *
   * @param s The DEC_PROPL_NAME_PRIMARY to set
 */
  public void setDEC_PROPL_NAME_PRIMARY(String s)
  {
      this.DEC_PROPL_NAME_PRIMARY = s;
  } 
  /**
   * The setAC_SYS_PREF_NAME method sets the AC_SYS_PREF_NAME for this bean.
   *
   * @param s The AC_SYS_PREF_NAME to set
   */
  public void setAC_SYS_PREF_NAME(String s)
  {
      this.AC_SYS_PREF_NAME = s;
  }
  /**
   * The setAC_ABBR_PREF_NAME method sets the AC_ABBR_PREF_NAME for this bean.
   *
   * @param s The AC_ABBR_PREF_NAME to set
   */
  public void setAC_ABBR_PREF_NAME(String s)
  {
      this.AC_ABBR_PREF_NAME = s;
  }
  /**
   * The setAC_USER_PREF_NAME method sets the AC_USER_PREF_NAME for this bean.
   *
   * @param s The AC_USER_PREF_NAME to set
   */
  public void setAC_USER_PREF_NAME(String s)
  {
      this.AC_USER_PREF_NAME = s;
  }
  /**
   * The setAC_PREF_NAME_TYPE method sets the AC_PREF_NAME_TYPE for this bean.
   *
   * @param s The AC_PREF_NAME_TYPE to set
   */
  public void setAC_PREF_NAME_TYPE(String s)
  {
      this.AC_PREF_NAME_TYPE = s;
  }
   
  

  //Get Properties
  /**
  * The getRETURN_CODE method returns the RETURN_CODE for this bean.
  *
  * @return String The RETURN_CODE
  */
  public String getRETURN_CODE()
  {
      return this.RETURN_CODE;
  }
  /**
  * The getDEC_DEC_IDSEQ method returns the DEC_DEC_IDSEQ for this bean.
  *
  * @return String The DEC_DEC_IDSEQ
  */
  public String getDEC_DEC_IDSEQ()
  {
      return this.DEC_DEC_IDSEQ;
  }
  
  /** (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getIDSEQ()
   */
  public String getIDSEQ()
  {
      return getDEC_DEC_IDSEQ();
  }
  
	/**
  * The getDEC_PREFERRED_NAME method returns the DEC_PREFERRED_NAME for this bean.
  *
  * @return String The DEC_PREFERRED_NAME
  */
  public String getDEC_PREFERRED_NAME()
  {
      return this.DEC_PREFERRED_NAME;
  }
  /**
  * The getDEC_CONTE_IDSEQ method returns the DEC_CONTE_IDSEQ for this bean.
  *
  * @return String The DEC_CONTE_IDSEQ
  */
  public String getDEC_CONTE_IDSEQ()
  {
      return this.DEC_CONTE_IDSEQ;
  }
  
  /** (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getContextIDSEQ()
   */
  @Override
  public String getContextIDSEQ()
  {
      return getDEC_CONTE_IDSEQ();
  }

  /**
  * The getDEC_VERSION method returns the DEC_VERSION for this bean.
  *
  * @return String The DEC_VERSION
  */
  public String getDEC_VERSION()
  {
      return this.DEC_VERSION;
  }
  /**
  * The getDEC_PREFERRED_DEFINITION method returns the DEC_PREFERRED_DEFINITION for this bean.
  *
  * @return String The DEC_PREFERRED_DEFINITION
  */
  public String getDEC_PREFERRED_DEFINITION()
  {
      return this.DEC_PREFERRED_DEFINITION;
  }
  /**
  * The getDEC_LONG_NAME method returns the DEC_LONG_NAME for this bean.
  *
  * @return String The DEC_LONG_NAME
  */
  public String getDEC_LONG_NAME()
  {
      return this.DEC_LONG_NAME;
  }
  /**
  * The getDEC_ASL_NAME method returns the DEC_ASL_NAME for this bean.
  *
  * @return String The DEC_ASL_NAME
  */
  public String getDEC_ASL_NAME()
  {
      return this.DEC_ASL_NAME;
  }
  /**
  * The getDEC_CD_IDSEQ method returns the DEC_CD_IDSEQ for this bean.
  *
  * @return String The DEC_CD_IDSEQ
  */
  public String getDEC_CD_IDSEQ()
  {
      return this.DEC_CD_IDSEQ;
  }
  /**
  * The getDEC_CD_NAME method returns the DEC_CD_NAME for this bean.
  *
  * @return String The DEC_CD_NAME
  */
   public String getDEC_CD_NAME()
  {
      return this.DEC_CD_NAME;
  }
  /**
  * The getDEC_LATEST_VERSION_IND method returns the DEC_LATEST_VERSION_IND for this bean.
  *
  * @return String The DEC_LATEST_VERSION_IND
  */
  public String getDEC_LATEST_VERSION_IND()
  {
      return this.DEC_LATEST_VERSION_IND;
  }
   /**
  * The getDEC_OCL_NAME method returns the DEC_OCL_NAME for this bean.
  *
  * @return String The DEC_OCL_NAME
  */
  public String getDEC_OCL_NAME()
  {
      return this.DEC_OCL_NAME;
  }
 /**
  * The getDEC_PROPL_IDSEQ method returns the DEC_PROPL_IDSEQ for this bean.
  *
  * @return String The DEC_PROPL_IDSEQ
  */
  public String getDEC_PROPL_IDSEQ()
  {
      return this.DEC_PROPL_IDSEQ;
  }
  /**
  * The getDEC_OCL_IDSEQ method returns the DEC_OCL_IDSEQ for this bean.
  *
  * @return String The DEC_OCL_IDSEQ
  */
  public String getDEC_OCL_IDSEQ()
  {
      return this.DEC_OCL_IDSEQ;
  }
  /**
  * The getDEC_OBJ_ASL_NAME method returns the DEC_OBJ_ASL_NAME for this bean.
  *
  * @return String The DEC_OBJ_ASL_NAME
  */
  public String getDEC_OBJ_ASL_NAME()
  {
      return this.DEC_OBJ_ASL_NAME;
  }
   /**
  * The getDEC_PROP_ASL_NAME method returns the DEC_PROP_ASL_NAME for this bean.
  *
  * @return String The DEC_PROP_ASL_NAME
  */
  public String getDEC_PROP_ASL_NAME()
  {
      return this.DEC_PROP_ASL_NAME;
  }
  /**
  * The getDEC_PROPL_NAME method returns the DEC_PROPL_NAME for this bean.
  *
  * @return String The DEC_PROPL_NAME
  */
  public String getDEC_PROPL_NAME()
  {
      return this.DEC_PROPL_NAME;
  }

  /**
  * The getDEC_BEGIN_DATE method returns the DEC_BEGIN_DATE for this bean.
  *
  * @return String The DEC_BEGIN_DATE
  */
  public String getDEC_BEGIN_DATE()
  {
      return this.DEC_BEGIN_DATE;
  }
  /**
  * The getDEC_END_DATE method returns the DEC_END_DATE for this bean.
  *
  * @return String The DEC_END_DATE
  */
  public String getDEC_END_DATE()
  {
      return this.DEC_END_DATE;
  }
  /**
  * The getDEC_CHANGE_NOTE method returns the DEC_CHANGE_NOTE for this bean.
  *
  * @return String The DEC_CHANGE_NOTE
  */
  public String getDEC_CHANGE_NOTE()
  {
      return this.DEC_CHANGE_NOTE;
  }
  /**
  * The getDEC_CREATED_BY method returns the DEC_CREATED_BY for this bean.
  *
  * @return String The DEC_CREATED_BY
  */
  public String getDEC_CREATED_BY()
  {
      return this.DEC_CREATED_BY;
  }
  /**
  * The getDEC_DATE_CREATED method returns the DEC_DATE_CREATED for this bean.
  *
  * @return String The DEC_DATE_CREATED
  */
  public String getDEC_DATE_CREATED()
  {
      return this.DEC_DATE_CREATED;
  }
  /**
  * The getDEC_MODIFIED_BY method returns the DEC_MODIFIED_BY for this bean.
  *
  * @return String The DEC_MODIFIED_BY
  */
  public String getDEC_MODIFIED_BY()
  {
      return this.DEC_MODIFIED_BY;
  }
  /**
  * The getDEC_DATE_MODIFIED method returns the DEC_DATE_MODIFIED for this bean.
  *
  * @return String The DEC_DATE_MODIFIED
  */
  public String getDEC_DATE_MODIFIED()
  {
      return this.DEC_DATE_MODIFIED;
  }
  /**
  * The getDEC_DELETED_IND method returns the DEC_DELETED_IND for this bean.
  *
  * @return String The DEC_DELETED_IND
  */
  public String getDEC_DELETED_IND()
  {
      return this.DEC_DELETED_IND;
  }
  /**
  * The getDEC_CONTEXT_NAME method returns the DEC_CONTEXT_NAME for this bean.
  *
  * @return String The DEC_CONTEXT_NAME
  */
  public String getDEC_CONTEXT_NAME()
  {
      return this.DEC_CONTEXT_NAME;
  }
  
  /** (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getContextName()
   */
  @Override
  public String getContextName()
  {
      return getDEC_CONTEXT_NAME();
  }

  /**
  * The getDEC_LANGUAGE method returns the DEC_LANGUAGE for this bean.
  *
  * @return String The DEC_LANGUAGE
  */
  public String getDEC_LANGUAGE()
  {
      return this.DEC_LANGUAGE;
  }
  /**
  * The getDEC_LANGUAGE_IDSEQ method returns the DEC_LANGUAGE_IDSEQ for this bean.
  *
  * @return String The DEC_LANGUAGE_IDSEQ
  */
  public String getDEC_LANGUAGE_IDSEQ()
  {
      return this.DEC_LANGUAGE_IDSEQ;
  }
  /**
  * The getDEC_PROTOCOL_ID method returns the DEC_PROTOCOL_ID for this bean.
  *
  * @return String The DEC_PROTOCOL_ID
  */
  public String getDEC_PROTOCOL_ID()
  {
      return this.DEC_PROTOCOL_ID;
  }
  /**
  * The getDEC_CRF_NAME method returns the DEC_CRF_NAME for this bean.
  *
  * @return String The DEC_CRF_NAME
  */
  public String getDEC_CRF_NAME()
  {
      return this.DEC_CRF_NAME;
  }
  /**
  * The getDEC_TYPE_NAME method returns the DEC_TYPE_NAME for this bean.
  *
  * @return String The DEC_TYPE_NAME
  */
  public String getDEC_TYPE_NAME()
  {
      return this.DEC_TYPE_NAME;
  }
  /**
  * The getDEC_DES_ALIAS_ID method returns the DEC_DES_ALIAS_ID for this bean.
  *
  * @return String The DEC_DES_ALIAS_ID
  */
  public String getDEC_DES_ALIAS_ID()
  {
      return this.DEC_DES_ALIAS_ID;
  }
  /**
  * The getDEC_ALIAS_NAME method returns the DEC_ALIAS_NAME for this bean.
  *
  * @return String The DEC_ALIAS_NAME
  */
  public String getDEC_ALIAS_NAME()
  {
      return this.DEC_ALIAS_NAME;
  }
  /**
	* The getDEC_USEDBY_CONTEXT method returns the DEC_USEDBY_CONTEXT for this bean.
  *
	* @return String The DEC_USEDBY_CONTEXT
  */
	public String getDEC_USEDBY_CONTEXT()
  {
			return this.DEC_USEDBY_CONTEXT;
	}
  /**
	* The getDEC_Obj_Definition method returns the DEC_Obj_Definition for this bean.
  *
	* @return String The DEC_Obj_Definition
  */
	public String getDEC_Obj_Definition()
  {
			return this.DEC_Obj_Definition;
	}
  /**
	* The getDEC_Prop_Definition method returns the DEC_Prop_Definition for this bean.
  *
	* @return String The DEC_Prop_Definition
  */
	public String getDEC_Prop_Definition()
  {
			return this.DEC_Prop_Definition;
	}
  
  
  /**
  * The getDEC_DEC_ID method returns the DEC_DEC_ID for this bean.
  *
  * @return String The DEC_DEC_ID
  */
  public String getDEC_DEC_ID()
  {
      return this.DEC_DEC_ID;
  }
   /**
  * The getDEC_SOURCE method returns the DEC_SOURCE for this bean.
  *
  * @return String The DEC_SOURCE
  */
  public String getDEC_SOURCE()
  {
      return this.DEC_SOURCE;
  }
   /**
  * The getDEC_CHECKED method returns the DEC_CHECKED for this bean.
  *
  * @return String The DEC_CHECKED
  */
  public boolean getDEC_CHECKED()
  {
      return this.DEC_CHECKED;
  }
   /**
  * The getAC_SELECTED_CONTEXT_ID method returns the DEC_SELECTED_CONTEXT_ID for this bean.
  *
  * @return Vector The DEC_SELECTED_CONTEXT_ID
  */
  public Vector getAC_SELECTED_CONTEXT_ID()
  {
      return this.DEC_SELECTED_CONTEXT_ID;
  }
  /**
  * The getAC_CS method returns the DEC_CS for this bean.
  *
  * @return Vector The DEC_CS
  */
  public Vector getAC_CS_NAME()
  {
      return this.DEC_CS_NAME;
  }
  /**
  * The getAC_CS_ID method returns the DEC_CS_ID for this bean.
  *
  * @return Vector The DEC_CS_ID
  */
  public Vector getAC_CS_ID()
  {
      return this.DEC_CS_ID;
  }
  /**
  * The getAC_CSI method returns the DEC_CSI for this bean.
  *
  * @return String The DEC_CSI
  */
  public Vector getAC_CSI_NAME()
  {
      return this.DEC_CSI_NAME;
  }
  /**
  * The getAC_CSI_ID method returns the DEC_CSI_ID for this bean.
  *
  * @return String The DEC_CSI_ID
  */
  public Vector getAC_CSI_ID()
  {
      return this.DEC_CSI_ID;
  }
  
  /**
  * The getAC_AC_CSI_VECTOR method returns the DEC_AC_CSI_VECTOR for this bean.
  *
  * @return Vector The DEC_AC_CSI_VECTOR
  */
  public Vector<AC_CSI_Bean> getAC_AC_CSI_VECTOR()
  {
      return this.DEC_AC_CSI_VECTOR;
  }
  /**
  * The getAC_AC_CSI_ID method returns the DEC_AC_CSI_ID for this bean.
  *
  * @return Vector The DEC_AC_CSI_ID
  */
  public Vector getAC_AC_CSI_ID()
  {
      return this.DEC_AC_CSI_ID;
  }
  
/**
  * The getAC_CS_CSI_ID method returns the DEC_CS_CSI_ID for this bean.
  *
  * @return Vector The DEC_CS_CSI_ID
  */
  public Vector getAC_CS_CSI_ID()
  {
      return this.DEC_CS_CSI_ID;
  }
  /**
   * The getAC_ALT_NAMES method returns the AC_ALT_NAMES for this bean.
   *
   * @return Vector The AC_ALT_NAMES
   */
  public Vector getAC_ALT_NAMES()
  {
       return this.AC_ALT_NAMES;
  }
  /**
   * The getAC_REF_DOCS method returns the AC_REF_DOCS for this bean.
   *
   * @return Vector The AC_REF_DOCS
   */
  public Vector getAC_REF_DOCS()
  {
       return this.AC_REF_DOCS;
  }
  /**
   * The getAC_CONCEPT_NAME method returns the AC_CONCEPT_NAME for this bean.
   *
   * @return String The AC_CONCEPT_NAME
   */
   public String getAC_CONCEPT_NAME()
   {
       return this.AC_CONCEPT_NAME;
   }
   
   /**
    * @return Returns the aC_CONTACTS.
    */
   public Hashtable<String, AC_CONTACT_Bean> getAC_CONTACTS()
   {
     return AC_CONTACTS;
   }

   /**
    * The getREFERENCE_DOCUMENT method returns the REFERENCE_DOCUMENT for this bean.
    *
    * @return String The REFERENCE_DOCUMENT
    */
    public String getREFERENCE_DOCUMENT()
    {
        return this.REFERENCE_DOCUMENT;
    }
    
    /**
     * @return Returns the aLTERNATE_NAME.
     */
    public String getALTERNATE_NAME()
    {
      return ALTERNATE_NAME;
    }

/**
  * The getDEC_OC_CONCEPT_CODE method returns the DEC_OC_CONCEPT_CODE for this bean.
  *
  * @return String The DEC_OC_CONCEPT_CODE
  */
  public String getDEC_OC_CONCEPT_CODE()
  {
      return this.DEC_OC_CONCEPT_CODE;
  }
/**
  * The getDEC_OC_EVS_CUI_ORIGEN method returns the DEC_OC_EVS_CUI_ORIGEN for this bean.
  *
  * @return String The DEC_OC_EVS_CUI_ORIGEN
  */
  public String getDEC_OC_EVS_CUI_ORIGEN()
  {
      return this.DEC_OC_EVS_CUI_ORIGEN;
  }
/**
  * The getDEC_EVS_OC_CUI_SOURCE method returns the DEC_OC_EVS_CUI_SOURCE for this bean.
  *
  * @return String The DEC_OC_EVS_CUI_SOURCE
  */
  public String getDEC_OC_EVS_CUI_SOURCE()
  {
      return this.DEC_OC_EVS_CUI_SOURCE;
  }
/**
  * The getDEC_OC_DEFINITION_SOURCE method returns the DEC_OC_DEFINITION_SOURCE for this bean.
  *
  * @return String The DEC_OC_DEFINITION_SOURCE
  */
  public String getDEC_OC_DEFINITION_SOURCE()
  {
      return this.DEC_OC_DEFINITION_SOURCE;
  }
/**
  * The getDEC_OC_QUAL_CONCEPT_CODE method returns the DEC_OC_QUAL_CONCEPT_CODE for this bean.
  *
  * @return String The DEC_OC_QUAL_CONCEPT_CODE
  */
  public String getDEC_OC_QUAL_CONCEPT_CODE()
  {
      return this.DEC_OC_QUAL_CONCEPT_CODE;
  }
/**
  * The getDEC_OC_QUAL_EVS_CUI_ORIGEN method returns the DEC_OC_QUAL_EVS_CUI_ORIGEN for this bean.
  *
  * @return String The DEC_OC_QUAL_EVS_CUI_ORIGEN
  */
  public String getDEC_OC_QUAL_EVS_CUI_ORIGEN()
  {
      return this.DEC_OC_QUAL_EVS_CUI_ORIGEN;
  }
/**
  * The getDEC_EVS_OC_QUAL_CUI_SOURCE method returns the DEC_OC_QUAL_EVS_CUI_SOURCE for this bean.
  *
  * @return String The DEC_OC_QUAL_EVS_CUI_SOURCE
  */
  public String getDEC_OC_QUAL_EVS_CUI_SOURCE()
  {
      return this.DEC_OC_QUAL_EVS_CUI_SOURCE;
  }
/**
  * The getDEC_OC_QUAL_DEFINITION_SOURCE method returns the DEC_OC_QUAL_DEFINITION_SOURCE for this bean.
  *
  * @return String The DEC_OC_QUAL_DEFINITION_SOURCE
  */
  public String getDEC_OC_QUAL_DEFINITION_SOURCE()
  {
      return this.DEC_OC_QUAL_DEFINITION_SOURCE;
  }

/**
  * The getDEC_PROP_CONCEPT_CODE method returns the DEC_PROP_CONCEPT_CODE for this bean.
  *
  * @return String The DEC_PROP_CONCEPT_CODE
  */
  public String getDEC_PROP_CONCEPT_CODE()
  {
      return this.DEC_PROP_CONCEPT_CODE;
  }
/**
  * The getDEC_PROP_EVS_CUI_ORIGEN method returns the DEC_PROP_EVS_CUI_ORIGEN for this bean.
  *
  * @return String The DEC_PROP_EVS_CUI_ORIGEN
  */
  public String getDEC_PROP_EVS_CUI_ORIGEN()
  {
      return this.DEC_PROP_EVS_CUI_ORIGEN;
  }
/**
  * The getDEC_EVS_PROP_CUI_SOURCE method returns the DEC_PROP_EVS_CUI_SOURCE for this bean.
  *
  * @return String The DEC_PROP_EVS_CUI_SOURCE
  */
  public String getDEC_PROP_EVS_CUI_SOURCE()
  {
      return this.DEC_PROP_EVS_CUI_SOURCE;
  }
/**
  * The getDEC_PROP_DEFINITION_SOURCE method returns the DEC_PROP_DEFINITION_SOURCE for this bean.
  *
  * @return String The DEC_PROP_DEFINITION_SOURCE
  */
  public String getDEC_PROP_DEFINITION_SOURCE()
  {
      return this.DEC_PROP_DEFINITION_SOURCE;
  }
/**
  * The getDEC_PROP_QUAL_CONCEPT_CODE method returns the DEC_PROP_QUAL_CONCEPT_CODE for this bean.
  *
  * @return String The DEC_PROP_QUAL_CONCEPT_CODE
  */
  public String getDEC_PROP_QUAL_CONCEPT_CODE()
  {
      return this.DEC_PROP_QUAL_CONCEPT_CODE;
  }
/**
  * The getDEC_PROP_QUAL_EVS_CUI_ORIGEN method returns the DEC_PROP_QUAL_EVS_CUI_ORIGEN for this bean.
  *
  * @return String The DEC_PROP_QUAL_EVS_CUI_ORIGEN
  */
  public String getDEC_PROP_QUAL_EVS_CUI_ORIGEN()
  {
      return this.DEC_PROP_QUAL_EVS_CUI_ORIGEN;
  }
/**
  * The getDEC_EVS_PROP_QUAL_CUI_SOURCE method returns the DEC_PROP_QUAL_EVS_CUI_SOURCE for this bean.
  *
  * @return String The DEC_PROP_QUAL_EVS_CUI_SOURCE
  */
  public String getDEC_PROP_QUAL_EVS_CUI_SOURCE()
  {
      return this.DEC_PROP_QUAL_EVS_CUI_SOURCE;
  }
/**
  * The getDEC_PROP_QUAL_DEFINITION_SOURCE method returns the DEC_PROP_QUAL_DEFINITION_SOURCE for this bean.
  *
  * @return String The DEC_PROP_QUAL_DEFINITION_SOURCE
  */
  public String getDEC_PROP_QUAL_DEFINITION_SOURCE()
  {
      return this.DEC_PROP_QUAL_DEFINITION_SOURCE;
  }
 /**
  * The getDEC_OC_QUALIFIER_NAMES method returns the DEC_OC_QUALIFIER_NAMES for this bean.
  *
  * @return Vector The DEC_OC_QUALIFIER_NAMES
  */
  public Vector<String> getDEC_OC_QUALIFIER_NAMES()
  {
      return this.DEC_OC_QUALIFIER_NAMES;
  }
/**
  * The getDEC_OC_QUALIFIER_CODES method returns the DEC_OC_QUALIFIER_CODES for this bean.
  *
  * @return Vector The DEC_OC_QUALIFIER_CODES
  */
  public Vector<String> getDEC_OC_QUALIFIER_CODES()
  {
      return this.DEC_OC_QUALIFIER_CODES;
  }
  /**
  * The getDEC_OC_QUALIFIER_DB method returns the DEC_OC_QUALIFIER_DB for this bean.
  *
  * @return Vector The DEC_OC_QUALIFIER_DB
  */
  public Vector<String> getDEC_OC_QUALIFIER_DB()
  {
      return this.DEC_OC_QUALIFIER_DB;
  }
/**
  * The getDEC_PROP_QUALIFIER_NAMES method returns the DEC_PROP_QUALIFIER_NAMES for this bean.
  *
  * @return Vector The DEC_PROP_QUALIFIER_NAMES
  */
  public Vector getDEC_PROP_QUALIFIER_NAMES()
  {
      return this.DEC_PROP_QUALIFIER_NAMES;
  }
  /**
  * The getDEC_PROP_QUALIFIER_CODES method returns the DEC_PROP_QUALIFIER_CODES for this bean.
  *
  * @return Vector The DEC_PROP_QUALIFIER_CODES
  */
  public Vector getDEC_PROP_QUALIFIER_CODES()
  {
      return this.DEC_PROP_QUALIFIER_CODES;
  }
  /**
  * The getDEC_PROP_QUALIFIER_DB method returns the DEC_PROP_QUALIFIER_DB for this bean.
  *
  * @return Vector The DEC_PROP_QUALIFIER_DB
  */
  public Vector getDEC_PROP_QUALIFIER_DB()
  {
      return this.DEC_PROP_QUALIFIER_DB;
  }
/**
  * The getDEC_OC_CONDR_IDSEQ method returns the DEC_OC_CONDR_IDSEQ for this bean.
  *
  * @return String The DEC_OC_CONDR_IDSEQ
  */
  public String getDEC_OC_CONDR_IDSEQ()
  {
      return this.DEC_OC_CONDR_IDSEQ;
  }
/**
  * The getDEC_PROP_CONDR_IDSEQ method returns the DEC_PROP_CONDR_IDSEQ for this bean.
  *
  * @return String The DEC_PROP_CONDR_IDSEQ
  */
  public String getDEC_PROP_CONDR_IDSEQ()
  {
      return this.DEC_PROP_CONDR_IDSEQ;
  }
/**
  * The getDEC_OCL_NAME_PRIMARY method returns the DEC_OCL_NAME_PRIMARY for this bean.
  *
  * @return String The DEC_OCL_NAME_PRIMARY
  */
  public String getDEC_OCL_NAME_PRIMARY()
  {
      return this.DEC_OCL_NAME_PRIMARY;
  }
/**
  * The getDEC_PROPL_NAME_PRIMARY method returns the DEC_PROPL_NAME_PRIMARY for this bean.
  *
  * @return String The DEC_PROPL_NAME_PRIMARY
  */
  public String getDEC_PROPL_NAME_PRIMARY()
  {
      return this.DEC_PROPL_NAME_PRIMARY;
  }
   /**
  * The getAC_SYS_PREF_NAME method returns the AC_SYS_PREF_NAME for this bean.
  *
  * @return String The AC_SYS_PREF_NAME
  */
  public String getAC_SYS_PREF_NAME()
  {
      return this.AC_SYS_PREF_NAME;
  }
   /**
  * The getAC_USER_PREF_NAME method returns the AC_USER_PREF_NAME for this bean.
  *
  * @return String The AC_USER_PREF_NAME
  */
  public String getAC_USER_PREF_NAME()
  {
      return this.AC_USER_PREF_NAME;
  }
   /**
  * The getAC_ABBR_PREF_NAME method returns the AC_ABBR_PREF_NAME for this bean.
  *
  * @return String The AC_ABBR_PREF_NAME
  */
  public String getAC_ABBR_PREF_NAME()
  {
      return this.AC_ABBR_PREF_NAME;
  }
   /**
  * The getAC_PREF_NAME_TYPE method returns the AC_PREF_NAME_TYPE for this bean.
  *
  * @return String The AC_PREF_NAME_TYPE
  */
  public String getAC_PREF_NAME_TYPE()
  {
      return this.AC_PREF_NAME_TYPE;
  }
}
