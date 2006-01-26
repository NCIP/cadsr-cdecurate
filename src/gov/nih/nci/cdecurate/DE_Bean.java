// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/DE_Bean.java,v 1.1 2006-01-26 15:25:12 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

import java.util.*;

/**
 * The DE_Bean encapsulates the DE information and is stored in the
 * session after the user has created a new Data Element.
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
may provide additional or different license terms and conditions in Your sublicense
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

public class DE_Bean extends AC_Bean
{
  private static final long serialVersionUID = 1004467191817830119L;

  //Attributes  IMP :  make sure these attributes gets added to clone method too.
  private String RETURN_CODE;
  private String DE_DE_IDSEQ;
  private String DE_PREFERRED_NAME;
  private String DE_CONTE_IDSEQ;
  private String DE_VERSION;
  private String DE_PREFERRED_DEFINITION;
  private String DE_LONG_NAME;
  private String DE_ASL_NAME;
  private String DE_REG_STATUS;
  private String DE_REG_STATUS_IDSEQ;
  private String DE_DEC_NAME;
  private String DE_DEC_IDSEQ;
  private String DE_DEC_PREFERRED_NAME;
  private String DE_VD_NAME;
  private String DE_VD_IDSEQ;
  private String DE_VD_PREFERRED_NAME;
  private String DE_LATEST_VERSION_IND;
  private String DE_BEGIN_DATE;
  private String DE_END_DATE;
  private String DE_CHANGE_NOTE;
  private String DE_CREATED_BY;
  private String DE_DATE_CREATED;
  private String DE_MODIFIED_BY;
  private String DE_DATE_MODIFIED;
  private String DE_DELETED_IND;
  private String DE_CONTEXT_NAME;
  private String DE_MIN_CDE_ID;
/*  private String DE_HIST_CDE_ID;
  private Integer DE_HIST_CDE_ID_COUNT;
*/
  private String DE_LANGUAGE;
  private String DE_LANGUAGE_IDSEQ;
  private String DE_SOURCE;
  private String DE_SOURCE_IDSEQ;
  private String DE_PROTOCOL_ID;
  private String DE_CRF_NAME;
  private String DE_CRF_IDSEQ;
  private Integer DE_PROTO_CRF_Count;
  private String DE_TYPE_NAME;
  private String DE_DER_RELATION;
  private String DE_DER_REL_IDSEQ;

  private String DE_DES_ALIAS_ID;
  private String DE_ALIAS_NAME;
  private String DE_USEDBY_CONTEXT;
  private Vector DE_USEDBY_CONTEXT_ID;
  private Vector DE_SELECTED_CONTEXT_ID;
  private String DE_DEC_Definition;
  private String DE_VD_Definition;
  private String DE_Question_ID;
  private String DE_Question_Name;
  private String DE_Permissible_Value;
  private Integer DE_Permissible_Value_Count;
  private boolean DE_CHECKED;

  //cs-csi relationship
  private Vector AC_CS_NAME;  //store CS name
  private Vector AC_CS_ID;  //store CS_IDSEQs
  private Vector AC_CSI_NAME; //store CSI name
  private Vector AC_CSI_ID; //store CSI_IDSEQs
  private Vector AC_AC_CSI_VECTOR;
  private Vector AC_AC_CSI_ID;
  private Vector AC_CS_CSI_ID;

  //altname ref docs
  private Vector AC_ALT_NAMES;
  private Vector AC_REF_DOCS;
  //concept name
  private String AC_CONCEPT_NAME;
  //contact inf
  private Hashtable AC_CONTACTS;
  //refdoc types text and count
  private String DOC_TEXT_PREFERRED_QUESTION;
  private String DOC_TEXT_PREFERRED_QUESTION_IDSEQ;
  /*
  private Integer DOC_TEXT_PREFERRED_QUESTION_COUNT;
  private String DOC_TEXT_HISTORIC_NAME;
  private Integer DOC_TEXT_HISTORIC_COUNT;
  private String DOC_TEXT_REFERENCE;
  private Integer DOC_TEXT_REFERENCE_COUNT;
  private String DOC_TEXT_EXAMPLE;
  private Integer DOC_TEXT_EXAMPLE_COUNT;
  private String DOC_TEXT_COMMENT;
  private Integer DOC_TEXT_COMMENT_COUNT;
  private String DOC_TEXT_NOTE;
  private Integer DOC_TEXT_NOTE_COUNT;
  private String DOC_TEXT_DESCRIPTION;
  private Integer DOC_TEXT_DESCRIPTION_COUNT;
  private String DOC_TEXT_IMAGE_FILE;
  private Integer DOC_TEXT_IMAGE_FILE_COUNT;
  private String DOC_TEXT_VALID_VALUE_SOURCE;
  private Integer DOC_TEXT_VALID_VALUE_SOURCE_COUNT;
  private String DOC_TEXT_DATA_ELEMENT_SOURCE;
  private Integer DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT;
  private String DOC_TEXT_UML_Class;
  private Integer DOC_TEXT_UML_Class_Count;
  private String DOC_TEXT_DETAIL_DESCRIPTION;
  private Integer DOC_TEXT_DETAIL_DESCRIPTION_COUNT;
  private String DOC_TEXT_TECHNICAL_GUIDE;
  private Integer DOC_TEXT_TECHNICAL_GUIDE_COUNT;
  private String DOC_TEXT_UML_Attribute;
  private Integer DOC_TEXT_UML_Attribute_Count;
  private String DOC_TEXT_LABEL;
  private Integer DOC_TEXT_LABEL_COUNT;
*/
  private String REFERENCE_DOCUMENT;
//  private Integer DOC_TEXT_OTHER_REF_TYPES_COUNT;
  private String ALTERNATE_NAME;

  private String AC_SYS_PREF_NAME;
  private String AC_ABBR_PREF_NAME;
  private String AC_USER_PREF_NAME;
  private String AC_PREF_NAME_TYPE;
  private DEC_Bean DE_DEC_Bean;
  private VD_Bean DE_VD_Bean;
  
  private boolean DEC_VD_CHANGED;
 /**
   * Constructor
  */
  public DE_Bean() {
  }

  /**
   * makes a copy of the bean
   * copies some (non edited) attributes from one bean to another if copyType is not 'Complete'.
   * when copyType is 'Complete', method makes clone of the bean
   *
   * @param copyBean passin the bean whose attributes  need to be copied and returned.
   *
   * @return DE_Bean returns this bean after copying its attributes
   */
    public DE_Bean cloneDE_Bean(DE_Bean copyBean, String copyType)
    {
      if (copyType.equals("Complete") || copyType.equals("Versioned"))
      {
        //when cloning all attributes use these
        if (copyType.equals("Complete"))
        {
          this.setDE_DE_IDSEQ(copyBean.getDE_DE_IDSEQ());
          this.setDE_VERSION(copyBean.getDE_VERSION());
          this.setDE_ASL_NAME(copyBean.getDE_ASL_NAME());          
          this.setDE_USEDBY_CONTEXT(copyBean.getDE_USEDBY_CONTEXT());
          this.setDE_USEDBY_CONTEXT_ID(copyBean.getDE_USEDBY_CONTEXT_ID());
        }
        //newly versioned workflow status is draft mod
        else
        {
          this.setDE_ASL_NAME("DRAFT MOD");
          this.setDE_USEDBY_CONTEXT("");  //remove used by for versioned
          this.setDE_USEDBY_CONTEXT_ID(new Vector());
        }
          
        this.setDE_PREFERRED_NAME(copyBean.getDE_PREFERRED_NAME());
        this.setDE_LONG_NAME(copyBean.getDE_LONG_NAME());
        this.setDE_PREFERRED_DEFINITION(copyBean.getDE_PREFERRED_DEFINITION());
        this.setDE_REG_STATUS(copyBean.getDE_REG_STATUS());
        this.setDE_REG_STATUS_IDSEQ(copyBean.getDE_REG_STATUS_IDSEQ());
        this.setDE_CONTE_IDSEQ(copyBean.getDE_CONTE_IDSEQ());
        this.setDE_BEGIN_DATE(copyBean.getDE_BEGIN_DATE());
        this.setDE_END_DATE(copyBean.getDE_END_DATE());
        this.setDE_CHANGE_NOTE(copyBean.getDE_CHANGE_NOTE());
        this.setDE_CONTEXT_NAME(copyBean.getDE_CONTEXT_NAME());
        this.setDE_DEC_NAME(copyBean.getDE_DEC_NAME());
        this.setDE_DEC_IDSEQ(copyBean.getDE_DEC_IDSEQ());
        this.setDE_DEC_PREFERRED_NAME(copyBean.getDE_PREFERRED_NAME());
        this.setDE_VD_NAME(copyBean.getDE_VD_NAME());
        this.setDE_VD_PREFERRED_NAME(copyBean.getDE_VD_PREFERRED_NAME());
        this.setDE_VD_IDSEQ(copyBean.getDE_VD_IDSEQ());
        this.setDE_SOURCE(copyBean.getDE_SOURCE());
        this.setDE_LANGUAGE(copyBean.getDE_LANGUAGE());
        this.setDE_LANGUAGE_IDSEQ(copyBean.getDE_LANGUAGE_IDSEQ());

        this.setDE_DATE_CREATED(copyBean.getDE_DATE_CREATED());
        this.setDE_DATE_MODIFIED(copyBean.getDE_DATE_MODIFIED());
        this.setDE_CREATED_BY(copyBean.getDE_CREATED_BY());
        this.setDE_MODIFIED_BY(copyBean.getDE_MODIFIED_BY());
      
        this.setAC_CS_NAME(copyBean.getAC_CS_NAME());
        this.setAC_CS_ID(copyBean.getAC_CS_ID());
        this.setAC_CSI_NAME(copyBean.getAC_CSI_NAME());
        this.setAC_CSI_ID(copyBean.getAC_CSI_ID());
        this.setAC_AC_CSI_VECTOR(copyBean.getAC_AC_CSI_VECTOR());
        this.setAC_AC_CSI_ID(copyBean.getAC_AC_CSI_ID());
        this.setAC_CS_CSI_ID(copyBean.getAC_CS_CSI_ID());
        this.setAC_ALT_NAMES(copyBean.getAC_ALT_NAMES());
        this.setAC_REF_DOCS(copyBean.getAC_REF_DOCS());
        
        this.setDE_VD_Definition(copyBean.getDE_VD_Definition());
        this.setDE_DEC_Definition(copyBean.getDE_DEC_Definition());
        this.setDE_LATEST_VERSION_IND(copyBean.getDE_LATEST_VERSION_IND());
        this.setDE_SOURCE_IDSEQ(copyBean.getDE_SOURCE_IDSEQ());

        this.setDE_MIN_CDE_ID(copyBean.getDE_MIN_CDE_ID());
        this.setDE_Question_ID(copyBean.getDE_Question_ID());
        this.setDE_Question_Name(copyBean.getDE_Question_Name());

        this.setDOC_TEXT_PREFERRED_QUESTION(copyBean.getDOC_TEXT_PREFERRED_QUESTION());
        this.setDOC_TEXT_PREFERRED_QUESTION_IDSEQ(copyBean.getDOC_TEXT_PREFERRED_QUESTION_IDSEQ());
      }

    //these would be for both copy some attributes and cloning.
      this.setAC_CONCEPT_NAME(copyBean.getAC_CONCEPT_NAME());
      this.setAC_CONTACTS(copyBean.getAC_CONTACTS());
      this.setDE_PROTOCOL_ID(copyBean.getDE_PROTOCOL_ID());
      this.setDE_CRF_NAME(copyBean.getDE_CRF_NAME());
      this.setDE_PROTO_CRF_Count(copyBean.getDE_PROTO_CRF_Count());
      this.setDE_CRF_IDSEQ(copyBean.getDE_CRF_IDSEQ());
      this.setDE_TYPE_NAME(copyBean.getDE_TYPE_NAME());
      this.setDE_DER_RELATION(copyBean.getDE_DER_RELATION());
      this.setDE_DER_REL_IDSEQ(copyBean.getDE_DER_REL_IDSEQ());
      this.setDE_DES_ALIAS_ID(copyBean.getDE_DES_ALIAS_ID());
      this.setDE_ALIAS_NAME(copyBean.getDE_ALIAS_NAME());
      this.setAC_SELECTED_CONTEXT_ID(copyBean.getAC_SELECTED_CONTEXT_ID());
/*      this.setDE_HIST_CDE_ID(copyBean.getDE_HIST_CDE_ID());
      this.setDE_HIST_CDE_ID_COUNT(copyBean.getDE_HIST_CDE_ID_COUNT());
*/      
      this.setDE_Permissible_Value(copyBean.getDE_Permissible_Value());
      this.setDE_Permissible_Value_Count(copyBean.getDE_Permissible_Value_Count());

    /*  this.setDOC_TEXT_PREFERRED_QUESTION_COUNT(copyBean.getDOC_TEXT_PREFERRED_QUESTION_COUNT());
      this.setDOC_TEXT_HISTORIC_NAME(copyBean.getDOC_TEXT_HISTORIC_NAME());
      this.setDOC_TEXT_HISTORIC_COUNT(copyBean.getDOC_TEXT_HISTORIC_COUNT());
      this.setDOC_TEXT_REFERENCE(copyBean.getDOC_TEXT_REFERENCE());
      this.setDOC_TEXT_REFERENCE_COUNT(copyBean.getDOC_TEXT_REFERENCE_COUNT());
      this.setDOC_TEXT_EXAMPLE(copyBean.getDOC_TEXT_EXAMPLE());
      this.setDOC_TEXT_EXAMPLE_COUNT(copyBean.getDOC_TEXT_EXAMPLE_COUNT());
      this.setDOC_TEXT_COMMENT(copyBean.getDOC_TEXT_COMMENT());
      this.setDOC_TEXT_COMMENT_COUNT(copyBean.getDOC_TEXT_COMMENT_COUNT());
      this.setDOC_TEXT_NOTE(copyBean.getDOC_TEXT_NOTE());
      this.setDOC_TEXT_NOTE_COUNT(copyBean.getDOC_TEXT_NOTE_COUNT());
      this.setDOC_TEXT_DESCRIPTION(copyBean.getDOC_TEXT_DESCRIPTION());
      this.setDOC_TEXT_DESCRIPTION_COUNT(copyBean.getDOC_TEXT_DESCRIPTION_COUNT());
      this.setDOC_TEXT_IMAGE_FILE(copyBean.getDOC_TEXT_IMAGE_FILE());
      this.setDOC_TEXT_IMAGE_FILE_COUNT(copyBean.getDOC_TEXT_IMAGE_FILE_COUNT());
      this.setDOC_TEXT_VALID_VALUE_SOURCE(copyBean.getDOC_TEXT_VALID_VALUE_SOURCE());
      this.setDOC_TEXT_VALID_VALUE_SOURCE_COUNT(copyBean.getDOC_TEXT_VALID_VALUE_SOURCE_COUNT());
      this.setDOC_TEXT_DATA_ELEMENT_SOURCE(copyBean.getDOC_TEXT_DATA_ELEMENT_SOURCE());
      this.setDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT(copyBean.getDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT());
      this.setDOC_TEXT_UML_Class(copyBean.getDOC_TEXT_UML_Class());
      this.setDOC_TEXT_UML_Class_Count(copyBean.getDOC_TEXT_UML_Class_Count());
      this.setDOC_TEXT_DETAIL_DESCRIPTION(copyBean.getDOC_TEXT_DETAIL_DESCRIPTION());
      this.setDOC_TEXT_DETAIL_DESCRIPTION_COUNT(copyBean.getDOC_TEXT_DETAIL_DESCRIPTION_COUNT());
      this.setDOC_TEXT_TECHNICAL_GUIDE(copyBean.getDOC_TEXT_TECHNICAL_GUIDE());
      this.setDOC_TEXT_TECHNICAL_GUIDE_COUNT(copyBean.getDOC_TEXT_TECHNICAL_GUIDE_COUNT());
      this.setDOC_TEXT_UML_Attribute(copyBean.getDOC_TEXT_UML_Attribute());
      this.setDOC_TEXT_UML_Attribute_Count(copyBean.getDOC_TEXT_UML_Attribute_Count());
      this.setDOC_TEXT_LABEL(copyBean.getDOC_TEXT_LABEL());
      this.setDOC_TEXT_LABEL_COUNT(copyBean.getDOC_TEXT_LABEL_COUNT()); */
      this.setREFERENCE_DOCUMENT(copyBean.getREFERENCE_DOCUMENT());
     // this.setDOC_TEXT_OTHER_REF_TYPES_COUNT(copyBean.getDOC_TEXT_OTHER_REF_TYPES_COUNT());
      this.setALTERNATE_NAME(copyBean.getALTERNATE_NAME());
      this.setDE_DEC_Bean(copyBean.getDE_DEC_Bean());
      this.setDE_VD_Bean(copyBean.getDE_VD_Bean());
      this.setAC_ABBR_PREF_NAME(copyBean.getAC_ABBR_PREF_NAME());
      this.setAC_SYS_PREF_NAME(copyBean.getAC_SYS_PREF_NAME());
      this.setAC_USER_PREF_NAME(copyBean.getAC_USER_PREF_NAME());
      this.setAC_PREF_NAME_TYPE(copyBean.getAC_PREF_NAME_TYPE());

      this.setDEC_VD_CHANGED(copyBean.getDEC_VD_CHANGED());
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
   * The setDE_DE_IDSEQ method sets the DE_DE_IDSEQ for this bean.
   *
   * @param s The DE_DE_IDSEQ to set
   */
  public void setDE_DE_IDSEQ(String s)
  {
      this.DE_DE_IDSEQ = s;
  }
  /**
   * The setDE_PREFERRED_NAME method sets the DE_PREFERRED_NAME for this bean.
   *
   * @param s The DE_PREFERRED_NAME to set
   */
  public void setDE_PREFERRED_NAME(String s)
  {
      this.DE_PREFERRED_NAME = s;
  }
  /**
   * The setDE_CONTE_IDSEQ method sets the DE_CONTE_IDSEQ for this bean.
   *
   * @param s The DE_CONTE_IDSEQ to set
  */
  public void setDE_CONTE_IDSEQ(String s)
  {
      this.DE_CONTE_IDSEQ = s;
  }

  /**
   * The setRETURN_CODE method sets the RETURN_CODE for this bean.
   *
   * @param s The RETURN_CODE to set
  */
  public void setDE_VERSION(String s)
  {
      this.DE_VERSION = s;
  }
  /**
   * The setDE_PREFERRED_DEFINITION method sets the DE_PREFERRED_DEFINITION for this bean.
   *
   * @param s The DE_PREFERRED_DEFINITION to set
  */
  public void setDE_PREFERRED_DEFINITION(String s)
  {
      this.DE_PREFERRED_DEFINITION = s;
  }
  /**
   * The setDE_LONG_NAME method sets the DE_LONG_NAME for this bean.
   *
   * @param s The DE_LONG_NAME to set
  */
  public void setDE_LONG_NAME(String s)
  {
      this.DE_LONG_NAME = s;
  }
  /**
   * The setDE_REG_STATUS method sets the DE_REG_STATUS for this bean.
   *
   * @param s The DE_REG_STATUS to set
  */
  public void setDE_REG_STATUS(String s)
  {
      this.DE_REG_STATUS = s;
  }
  /**
   * The setDE_REG_STATUS_IDSEQ method sets the DE_REG_STATUS_IDSEQ for this bean.
   *
   * @param s The DE_REG_STATUS_IDSEQ to set
  */
  public void setDE_REG_STATUS_IDSEQ(String s)
  {
      this.DE_REG_STATUS_IDSEQ = s;
  }
  /**
   * The setDE_ASL_NAME method sets the DE_ASL_NAME for this bean.
   *
   * @param s The DE_ASL_NAME to set
  */
  public void setDE_ASL_NAME(String s)
  {
      this.DE_ASL_NAME = s;
  }
  /**
   * The setDE_DEC_IDSEQ method sets the DE_DEC_IDSEQ for this bean.
   *
   * @param s The DE_DEC_IDSEQ to set
  */
  public void setDE_DEC_IDSEQ(String s)
  {
      this.DE_DEC_IDSEQ = s;
  }
  /**
   * The setDE_DEC_PREFERRED_NAME method sets the DE_DEC_PREFERRED_NAME for this bean.
   *
   * @param s The DE_DEC_PREFERRED_NAME to set
  */
  public void setDE_DEC_PREFERRED_NAME(String s)
  {
      this.DE_DEC_PREFERRED_NAME = s;
  }
  /**
   * The setDE_VD_PREFERRED_NAME method sets the DE_VD_PREFERRED_NAME for this bean.
   *
   * @param s The DE_VD_PREFERRED_NAME to set
  */
  public void setDE_VD_IDSEQ(String s)
  {
      this.DE_VD_IDSEQ = s;
  }
  /**
   * The setDE_VD_PREFERRED_NAME method sets the DE_VD_PREFERRED_NAME for this bean.
   *
   * @param s The DE_VD_PREFERRED_NAME to set
  */
  public void setDE_VD_PREFERRED_NAME(String s)
  {
      this.DE_VD_PREFERRED_NAME = s;
  }
  /**
   * The setDE_LATEST_VERSION_IND method sets the DE_LATEST_VERSION_IND for this bean.
   *
   * @param s The DE_LATEST_VERSION_IND to set
  */
  public void setDE_LATEST_VERSION_IND(String s)
  {
      this.DE_LATEST_VERSION_IND = s;
  }
  /**
   * The setDE_BEGIN_DATE method sets the DE_BEGIN_DATE for this bean.
   *
   * @param s The DE_BEGIN_DATE to set
  */
  public void setDE_BEGIN_DATE(String s)
  {
      this.DE_BEGIN_DATE = s;
  }
  /**
   * The setDE_END_DATE method sets the DE_END_DATE for this bean.
   *
   * @param s The DE_END_DATE to set
  */
  public void setDE_END_DATE(String s)
  {
      this.DE_END_DATE = s;
  }
  /**
   * The setDE_CHANGE_NOTE method sets the DE_CHANGE_NOTE for this bean.
   *
   * @param s The DE_CHANGE_NOTE to set
  */
  public void setDE_CHANGE_NOTE(String s)
  {
      this.DE_CHANGE_NOTE = s;
  }
  /**
   * The setDE_CREATED_BY method sets the DE_CREATED_BY for this bean.
   *
   * @param s The DE_CREATED_BY to set
  */
  public void setDE_CREATED_BY(String s)
  {
      this.DE_CREATED_BY = s;
  }
  /**
   * The setDE_DATE_CREATED method sets the DE_DATE_CREATED for this bean.
   *
   * @param s The DE_DATE_CREATED to set
  */
  public void setDE_DATE_CREATED(String s)
  {
      this.DE_DATE_CREATED = s;
  }
  /**
   * The setDE_MODIFIED_BY method sets the DE_MODIFIED_BY for this bean.
   *
   * @param s The DE_MODIFIED_BY to set
  */
  public void setDE_MODIFIED_BY(String s)
  {
      this.DE_MODIFIED_BY = s;
  }
  /**
   * The setDE_DATE_MODIFIED method sets the DE_DATE_MODIFIED for this bean.
   *
   * @param s The DE_DATE_MODIFIED to set
  */
  public void setDE_DATE_MODIFIED(String s)
  {
      this.DE_DATE_MODIFIED = s;
  }
  /**
   * The setDE_DELETED_IND method sets the DE_DELETED_IND for this bean.
   *
   * @param s The DE_DELETED_IND to set
  */
  public void setDE_DELETED_IND(String s)
  {
      this.DE_DELETED_IND = s;
  }
  /**
   * The setDE_CONTEXT_NAME method sets the DE_CONTEXT_NAME for this bean.
   *
   * @param s The DE_CONTEXT_NAME to set
  */
  public void setDE_CONTEXT_NAME(String s)
  {
      this.DE_CONTEXT_NAME = s;
  }
  /**
   * The setDE_DEC_NAME method sets the DE_DEC_NAME for this bean.
   *
   * @param s The DE_DEC_NAME to set
  */
  public void setDE_DEC_NAME(String s)
  {
      this.DE_DEC_NAME = s;
  }
  /**
   * The setDE_VD_NAME method sets the DE_VD_NAME for this bean.
   *
   * @param s The DE_VD_NAME to set
  */
  public void setDE_VD_NAME(String s)
  {
      this.DE_VD_NAME = s;
  }
  /**
   * The setDE_MIN_CDE_ID method sets the DE_MIN_CDE_ID for this bean.
   *
   * @param s The DE_MIN_CDE_ID to set
  */
  public void setDE_MIN_CDE_ID(String s)
  {
      this.DE_MIN_CDE_ID = s;
  }
/*  *//**
   * The setDE_HIST_CDE_ID method sets the DE_HIST_CDE_ID for this bean.
   *
   * @param s The DE_HIST_CDE_ID to set
  *//*
  public void setDE_HIST_CDE_ID(String s)
  {
      this.DE_HIST_CDE_ID = s;
  }
  *//**
   * The setDE_HIST_CDE_ID_COUNT method sets the DE_HIST_CDE_ID_COUNT for this bean.
   *
   * @param i The DE_HIST_CDE_ID_COUNT to set
  *//*
  public void setDE_HIST_CDE_ID_COUNT(Integer i)
  {
      this.DE_HIST_CDE_ID_COUNT = i;
  }
*/  
  /**
   * The setDE_LANGUAGE method sets the DE_LANGUAGE for this bean.
   *
   * @param s The DE_LANGUAGE to set
  */
  public void setDE_LANGUAGE(String s)
  {
      this.DE_LANGUAGE = s;
  }
  /**
   * The setDE_LANGUAGE_IDSEQ method sets the DE_LANGUAGE_IDSEQ for this bean.
   *
   * @param s The DE_LANGUAGE_IDSEQ to set
  */
  public void setDE_LANGUAGE_IDSEQ(String s)
  {
      this.DE_LANGUAGE_IDSEQ = s;
  }
  /**
   * The setDE_SOURCE method sets the DE_SOURCE for this bean.
   *
   * @param s The DE_SOURCE to set
  */
  public void setDE_SOURCE(String s)
  {
      this.DE_SOURCE = s;
  }
  /**
   * The setDE_SOURCE_IDSEQ method sets the DE_SOURCE_IDSEQ for this bean.
   *
   * @param s The DE_SOURCE_IDSEQ to set
  */
  public void setDE_SOURCE_IDSEQ(String s)
  {
      this.DE_SOURCE_IDSEQ = s;
  }
  /**
   * The setDE_PROTOCOL_ID method sets the DE_PROTOCOL_ID for this bean.
   *
   * @param s The DE_PROTOCOL_ID to set
  */
  public void setDE_PROTOCOL_ID(String s)
  {
      this.DE_PROTOCOL_ID = s;
  }
  /**
   * The setDE_CRF_IDSEQ method sets the DE_CRF_IDSEQ for this bean.
   *
   * @param s The DE_CRF_IDSEQ to set
  */
  public void setDE_CRF_IDSEQ(String s)
  {
      this.DE_CRF_IDSEQ = s;
  }
  /**
   * The setDE_CRF_NAME method sets the DE_CRF_NAME for this bean.
   *
   * @param s The DE_CRF_NAME to set
  */
  public void setDE_CRF_NAME(String s)
  {
      this.DE_CRF_NAME = s;
  }
  /**
   * The setDE_PROTO_CRF_Count method sets the DE_PROTO_CRF_Count for this bean.
   *
   * @param i The DE_PROTO_CRF_Count to set
  */
  public void setDE_PROTO_CRF_Count(Integer i)
  {
      this.DE_PROTO_CRF_Count = i;
  }
  /**
   * The setDE_TYPE_NAME method sets the DE_TYPE_NAME for this bean.
   *
   * @param s The DE_TYPE_NAME to set
  */
  public void setDE_TYPE_NAME(String s)
  {
      this.DE_TYPE_NAME = s;
  }
  /**
   * The setDE_DER_RELATION method sets the DE_DER_RELATION for this bean.
   *
   * @param s The DE_DER_RELATION to set
  */
  public void setDE_DER_RELATION(String s)
  {
      this.DE_DER_RELATION = s;
  }
  /**
   * @param de_der_rel_idseq The dE_DER_REL_IDSEQ to set.
   */
  public void setDE_DER_REL_IDSEQ(String de_der_rel_idseq)
  {
    DE_DER_REL_IDSEQ = de_der_rel_idseq;
  }

  /**
   * The setDE_DES_ALIAS_ID method sets the DE_DES_ALIAS_ID for this bean.
   *
   * @param s The DE_DES_ALIAS_ID to set
  */
  public void setDE_DES_ALIAS_ID(String s)
  {
      this.DE_DES_ALIAS_ID = s;
  }
  /**
   * The setDE_ALIAS_NAME method sets the DE_ALIAS_NAME for this bean.
   *
   * @param s The DE_ALIAS_NAME to set
   */
  public void setDE_ALIAS_NAME(String s)
  {
      this.DE_ALIAS_NAME = s;
  }
  /**
   * The setDE_USEDBY_CONTEXT method sets the DE_USEDBY_CONTEXT for this bean.
   *
   * @param s The DE_USEDBY_CONTEXT to set
   */
  public void setDE_USEDBY_CONTEXT(String s)
  {
      this.DE_USEDBY_CONTEXT = s;
  }
  /**
   * The setDE_USEDBY_CONTEXT_ID method sets the DE_USEDBY_CONTEXT_ID for this bean.
   *
   * @param s The DE_USEDBY_CONTEXT_ID to set
   */
  public void setDE_USEDBY_CONTEXT_ID(Vector s)
  {
      this.DE_USEDBY_CONTEXT_ID = s;
  }
  /**
   * The setAC_SELECTED_CONTEXT_ID method sets the DE_SELECTED_CONTEXT_ID for this bean.
   *
   * @param s The DE_SELECTED_CONTEXT_ID to set
   */
  public void setAC_SELECTED_CONTEXT_ID(Vector s)
  {
      this.DE_SELECTED_CONTEXT_ID = s;
  }
   /**
   * The setDE_DEC_Definition method sets the DE_DEC_Definition for this bean.
   *
   * @param s The DE_DEC_Definition to set
  */
  public void setDE_DEC_Definition(String s)
  {
      this.DE_DEC_Definition = s;
  }
  /**
   * The setDE_VD_Definition method sets the DE_VD_Definition for this bean.
   *
   * @param s The DE_VD_Definition to set
  */
  public void setDE_VD_Definition(String s)
  {
      this.DE_VD_Definition = s;
  }
   /**
   * The setDE_Question_ID method sets the DE_Question_ID for this bean.
   *
   * @param s The DE_Question_ID to set
  */
  public void setDE_Question_ID(String s)
  {
      this.DE_Question_ID = s;
  }
   /**
   * The setDE_Question_Name method sets the DE_Question_Name for this bean.
   *
   * @param s The DE_Question_Name to set
  */
  public void setDE_Question_Name(String s)
  {
      this.DE_Question_Name = s;
  }
   /**
   * The setDE_Permissible_Value method sets the DE_Permissible_Value for this bean.
   *
   * @param s The DE_Permissible_Value to set
  */
  public void setDE_Permissible_Value(String s)
  {
      this.DE_Permissible_Value = s;
  }
   /**
   * The setDE_Permissible_Value method_Count sets the DE_Permissible_Value_Count for this bean.
   *
   * @param i The DE_Permissible_Value_Count to set
  */
  public void setDE_Permissible_Value_Count(Integer i)
  {
      this.DE_Permissible_Value_Count = i;
  }
  /**
   * The setDE_CHECKED method sets the DE_CHECKED for this bean.
   *
   * @param b The DE_CHECKED to set
  */
  public void setDE_CHECKED(boolean b)
  {
      this.DE_CHECKED = b;
  }
  /**
   * The setAC_CS method sets the AC_CS for this bean.
   *
   * @param s The AC_CS to set
  */
  public void setAC_CS_NAME(Vector v)
  {
      this.AC_CS_NAME = v;
  }
  /**
   * The setAC_CS_ID method sets the AC_CS_ID for this bean.
   *
   * @param s The AC_CS_ID to set
  */
  public void setAC_CS_ID(Vector v)
  {
      this.AC_CS_ID = v;
  }
  /**
   * The setAC_CSI method sets the AC_CSI for this bean.
   *
   * @param s The AC_CSI to set
  */
  public void setAC_CSI_NAME(Vector v)
  {
      this.AC_CSI_NAME = v;
  }
  /**
   * The setAC_CSI_ID method sets the AC_CSI_ID for this bean.
   *
   * @param s The AC_CSI_ID to set
  */
  public void setAC_CSI_ID(Vector v)
  {
      this.AC_CSI_ID = v;
  }
  /**
   * The setAC_AC_CSI_VECTOR method sets the AC_AC_CSI_VECTOR for this bean.
   *
   * @param s The AC_AC_CSI_VECTOR to set
  */
  public void setAC_AC_CSI_VECTOR(Vector v)
  {
      this.AC_AC_CSI_VECTOR = v;
  }
  /**
   * The setAC_AC_CSI_ID method sets the AC_AC_CSI_ID for this bean.
   *
   * @param s The AC_AC_CSI_ID to set
  */
  public void setAC_AC_CSI_ID(Vector v)
  {
      this.AC_AC_CSI_ID = v;
  }
  /**
   * The setAC_CS_CSI_ID method sets the AC_CS_CSI_ID for this bean.
   *
   * @param s The AC_CS_CSI_ID to set
  */
  public void setAC_CS_CSI_ID(Vector v)
  {
      this.AC_CS_CSI_ID = v;
  }
  /**
   * The setAC_ALT_NAMES method sets the AC_ALT_NAMES for this bean.
   *
   * @param s The AC_ALT_NAMES to set
  */
  public void setAC_ALT_NAMES(Vector v)
  {
      this.AC_ALT_NAMES = v;
  }
  /**
   * The setAC_REF_DOCS method sets the AC_REF_DOCS for this bean.
   *
   * @param s The AC_REF_DOCS to set
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
  public void setAC_CONTACTS(Hashtable ac_contacts)
  {
    AC_CONTACTS = ac_contacts;
  }

  /**
   * The setDOC_TEXT_PREFERRED_QUESTION method sets the DOC_TEXT_PREFERRED_QUESTION for this bean.
   *
   * @param s The DOC_TEXT_PREFERRED_QUESTION to set
  */
  public void setDOC_TEXT_PREFERRED_QUESTION(String s)
  {
      this.DOC_TEXT_PREFERRED_QUESTION = s;
  }
  /**
   * The setDOC_TEXT_PREFERRED_QUESTION_IDSEQ method sets the DOC_TEXT_PREFERRED_QUESTION_IDSEQ for this bean.
   *
   * @param s The DOC_TEXT_PREFERRED_QUESTION_IDSEQ to set
  */
  public void setDOC_TEXT_PREFERRED_QUESTION_IDSEQ(String s)
  {
      this.DOC_TEXT_PREFERRED_QUESTION_IDSEQ = s;
  }
  /**
   * The setDOC_TEXT_PREFERRED_QUESTION_COUNT method sets the DOC_TEXT_PREFERRED_QUESTION_COUNT for this bean.
   *
   * @param i The DOC_TEXT_PREFERRED_QUESTION_COUNT to set
  *//*
  public void setDOC_TEXT_PREFERRED_QUESTION_COUNT(Integer i)
  {
      this.DOC_TEXT_PREFERRED_QUESTION_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_HISTORIC_NAME method sets the DOC_TEXT_HISTORIC_NAME for this bean.
   *
   * @param s The DOC_TEXT_HISTORIC_NAME to set
  *//*
  public void setDOC_TEXT_HISTORIC_NAME(String s)
  {
      this.DOC_TEXT_HISTORIC_NAME = s;
  }
  *//**
   * The setDOC_TEXT_HISTORIC_COUNT method sets the DOC_TEXT_HISTORIC_COUNT for this bean.
   *
   * @param i The DOC_TEXT_HISTORIC_COUNT to set
  *//*
  public void setDOC_TEXT_HISTORIC_COUNT(Integer i)
  {
      this.DOC_TEXT_HISTORIC_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_REFERENCE method sets the DOC_TEXT_REFERENCE for this bean.
   *
   * @param s The DOC_TEXT_REFERENCE to set
  *//*
  public void setDOC_TEXT_REFERENCE(String s)
  {
      this.DOC_TEXT_REFERENCE = s;
  }
  *//**
   * The setDOC_TEXT_REFERENCE_COUNT method sets the DOC_TEXT_REFERENCE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_REFERENCE_COUNT to set
  *//*
  public void setDOC_TEXT_REFERENCE_COUNT(Integer i)
  {
      this.DOC_TEXT_REFERENCE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_EXAMPLE method sets the DOC_TEXT_EXAMPLE for this bean.
   *
   * @param s The DOC_TEXT_EXAMPLE to set
  *//*
  public void setDOC_TEXT_EXAMPLE(String s)
  {
      this.DOC_TEXT_EXAMPLE = s;
  }
  *//**
   * The setDOC_TEXT_EXAMPLE_COUNT method sets the DOC_TEXT_EXAMPLE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_EXAMPLE_COUNT to set
  *//*
  public void setDOC_TEXT_EXAMPLE_COUNT(Integer i)
  {
      this.DOC_TEXT_EXAMPLE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_COMMENT method sets the DOC_TEXT_COMMENT for this bean.
   *
   * @param s The DOC_TEXT_COMMENT to set
  *//*
  public void setDOC_TEXT_COMMENT(String s)
  {
      this.DOC_TEXT_COMMENT = s;
  }
  *//**
   * The setDOC_TEXT_COMMENT_COUNT method sets the DOC_TEXT_COMMENT_COUNT for this bean.
   *
   * @param i The DOC_TEXT_COMMENT_COUNT to set
  *//*
  public void setDOC_TEXT_COMMENT_COUNT(Integer i)
  {
      this.DOC_TEXT_COMMENT_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_NOTE method sets the DOC_TEXT_NOTE for this bean.
   *
   * @param s The DOC_TEXT_NOTE to set
  *//*
  public void setDOC_TEXT_NOTE(String s)
  {
      this.DOC_TEXT_NOTE = s;
  }
  *//**
   * The setDOC_TEXT_NOTE_COUNT method sets the DOC_TEXT_NOTE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_NOTE_COUNT to set
  *//*
  public void setDOC_TEXT_NOTE_COUNT(Integer i)
  {
      this.DOC_TEXT_NOTE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_DESCRIPTION method sets the DOC_TEXT_DESCRIPTION for this bean.
   *
   * @param s The DOC_TEXT_DESCRIPTION to set
  *//*
  public void setDOC_TEXT_DESCRIPTION(String s)
  {
      this.DOC_TEXT_DESCRIPTION = s;
  }
  *//**
   * The setDOC_TEXT_DESCRIPTION_COUNT method sets the DOC_TEXT_DESCRIPTION_COUNT for this bean.
   *
   * @param i The DOC_TEXT_DESCRIPTION_COUNT to set
  *//*
  public void setDOC_TEXT_DESCRIPTION_COUNT(Integer i)
  {
      this.DOC_TEXT_DESCRIPTION_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_IMAGE_FILE method sets the DOC_TEXT_IMAGE_FILE for this bean.
   *
   * @param s The DOC_TEXT_IMAGE_FILE to set
  *//*
  public void setDOC_TEXT_IMAGE_FILE(String s)
  {
      this.DOC_TEXT_IMAGE_FILE = s;
  }
  *//**
   * The setDOC_TEXT_IMAGE_FILE_COUNT method sets the DOC_TEXT_IMAGE_FILE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_IMAGE_FILE_COUNT to set
  *//*
  public void setDOC_TEXT_IMAGE_FILE_COUNT(Integer i)
  {
      this.DOC_TEXT_IMAGE_FILE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_VALID_VALUE_SOURCE method sets the DOC_TEXT_VALID_VALUE_SOURCE for this bean.
   *
   * @param s The DOC_TEXT_VALID_VALUE_SOURCE to set
  *//*
  public void setDOC_TEXT_VALID_VALUE_SOURCE(String s)
  {
      this.DOC_TEXT_VALID_VALUE_SOURCE = s;
  }
  *//**
   * The setDOC_TEXT_VALID_VALUE_SOURCE_COUNT method sets the DOC_TEXT_VALID_VALUE_SOURCE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_VALID_VALUE_SOURCE_COUNT to set
  *//*
  public void setDOC_TEXT_VALID_VALUE_SOURCE_COUNT(Integer i)
  {
      this.DOC_TEXT_VALID_VALUE_SOURCE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_DATA_ELEMENT_SOURCE method sets the DOC_TEXT_DATA_ELEMENT_SOURCE for this bean.
   *
   * @param s The DOC_TEXT_DATA_ELEMENT_SOURCE to set
  *//*
  public void setDOC_TEXT_DATA_ELEMENT_SOURCE(String s)
  {
      this.DOC_TEXT_DATA_ELEMENT_SOURCE = s;
  }
  *//**
   * The setDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT method sets the DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT to set
  *//*
  public void setDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT(Integer i)
  {
      this.DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_UML_Class method sets the DOC_TEXT_UML_Class for this bean.
   *
   * @param s The DOC_TEXT_UML_Class to set
  *//*
  public void setDOC_TEXT_UML_Class(String s)
  {
      this.DOC_TEXT_UML_Class = s;
  }
  *//**
   * The setDOC_TEXT_UML_Class_Count method sets the DOC_TEXT_UML_Class_Count for this bean.
   *
   * @param i The DOC_TEXT_UML_Class_Count to set
  *//*
  public void setDOC_TEXT_UML_Class_Count(Integer i)
  {
      this.DOC_TEXT_UML_Class_Count = i;
  }
  *//**
   * The setDOC_TEXT_DETAIL_DESCRIPTION method sets the DOC_TEXT_DETAIL_DESCRIPTION for this bean.
   *
   * @param s The DOC_TEXT_DETAIL_DESCRIPTION to set
  *//*
  public void setDOC_TEXT_DETAIL_DESCRIPTION(String s)
  {
      this.DOC_TEXT_DETAIL_DESCRIPTION = s;
  }
  *//**
   * The setDOC_TEXT_DETAIL_DESCRIPTION_COUNT method sets the DOC_TEXT_DETAIL_DESCRIPTION_COUNT for this bean.
   *
   * @param i The DOC_TEXT_DETAIL_DESCRIPTION_COUNT to set
  *//*
  public void setDOC_TEXT_DETAIL_DESCRIPTION_COUNT(Integer i)
  {
      this.DOC_TEXT_DETAIL_DESCRIPTION_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_TECHNICAL_GUIDE method sets the DOC_TEXT_TECHNICAL_GUIDE for this bean.
   *
   * @param s The DOC_TEXT_TECHNICAL_GUIDE to set
  *//*
  public void setDOC_TEXT_TECHNICAL_GUIDE(String s)
  {
      this.DOC_TEXT_TECHNICAL_GUIDE = s;
  }
  *//**
   * The setDOC_TEXT_TECHNICAL_GUIDE_COUNT method sets the DOC_TEXT_TECHNICAL_GUIDE_COUNT for this bean.
   *
   * @param i The DOC_TEXT_TECHNICAL_GUIDE_COUNT to set
  *//*
  public void setDOC_TEXT_TECHNICAL_GUIDE_COUNT(Integer i)
  {
      this.DOC_TEXT_TECHNICAL_GUIDE_COUNT = i;
  }
  *//**
   * The setDOC_TEXT_UML_Attribute method sets the DOC_TEXT_UML_Attribute for this bean.
   *
   * @param s The DOC_TEXT_UML_Attribute to set
  *//*
  public void setDOC_TEXT_UML_Attribute(String s)
  {
      this.DOC_TEXT_UML_Attribute = s;
  }
  *//**
   * The setDOC_TEXT_UML_Attribute_Count method sets the DOC_TEXT_UML_Attribute_Count for this bean.
   *
   * @param i The DOC_TEXT_UML_Attribute_Count to set
  *//*
  public void setDOC_TEXT_UML_Attribute_Count(Integer i)
  {
      this.DOC_TEXT_UML_Attribute_Count = i;
  }
  *//**
   * The setDOC_TEXT_LABEL method sets the DOC_TEXT_LABEL for this bean.
   *
   * @param s The DOC_TEXT_LABEL to set
  *//*
  public void setDOC_TEXT_LABEL(String s)
  {
      this.DOC_TEXT_LABEL = s;
  }
  *//**
   * The setDOC_TEXT_LABEL_COUNT method sets the DOC_TEXT_LABEL_COUNT for this bean.
   *
   * @param i The DOC_TEXT_LABEL_COUNT to set
  *//*
  public void setDOC_TEXT_LABEL_COUNT(Integer i)
  {
      this.DOC_TEXT_LABEL_COUNT = i;
  }
  */
  /**
   * The setREFERENCE_DOCUMENT_ method sets the REFERENCE_DOCUMENT for this bean.
   *
   * @param s The REFERENCE_DOCUMENT to set
  */
  public void setREFERENCE_DOCUMENT(String s)
  {
      this.REFERENCE_DOCUMENT = s;
  }
/*  *//**
   * The setDOC_TEXT_OTHER_REF_TYPES_COUNT method sets the DOC_TEXT_OTHER_REF_TYPES_COUNT for this bean.
   *
   * @param i The DOC_TEXT_OTHER_REF_TYPES_COUNT to set
  *//*
  public void setDOC_TEXT_OTHER_REF_TYPES_COUNT(Integer i)
  {
      this.DOC_TEXT_OTHER_REF_TYPES_COUNT = i;
  }
*/  

  /**
   * @param alternate_name The aLTERNATE_NAME to set.
   */
  public void setALTERNATE_NAME(String alternate_name)
  {
    ALTERNATE_NAME = alternate_name;
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
  /**
   * The setDE_DEC_Bean method sets the DE_DEC_Bean for this bean.
   *
   * @param bean The DE_DEC_Bean to set
   */
  public void setDE_DEC_Bean(DEC_Bean bean)
  {
      this.DE_DEC_Bean = bean;
  }
  /**
   * The setDE_VD_Bean method sets the DE_VD_Bean for this bean.
   *
   * @param bean The DE_VD_Bean to set
   */
  public void setDE_VD_Bean(VD_Bean bean)
  {
      this.DE_VD_Bean = bean;
  }
  /**
   * The setDEC_VD_CHANGED method sets the DEC_VD_CHANGED for this bean.
   *
   * @param b The DEC_VD_CHANGED to set
  */
  public void setDEC_VD_CHANGED(boolean b)
  {
      this.DEC_VD_CHANGED = b;
  }



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
  * The getDE_DE_IDSEQ method returns the DE_DE_IDSEQ for this bean.
  *
  * @return String The DE_DE_IDSEQ
  */
  public String getDE_DE_IDSEQ()
  {
      return this.DE_DE_IDSEQ;
  }
  
  public String getIDSEQ()
  {
      return getDE_DE_IDSEQ();
  }
  
   /**
  * The getDE_PREFERRED_NAME method returns the DE_PREFERRED_NAME for this bean.
  *
  * @return String The DE_PREFERRED_NAME
  */
  public String getDE_PREFERRED_NAME()
  {
      return this.DE_PREFERRED_NAME;
  }
   /**
  * The getDE_CONTE_IDSEQ method returns the DE_CONTE_IDSEQ for this bean.
  *
  * @return String The DE_CONTE_IDSEQ
  */
  public String getDE_CONTE_IDSEQ()
  {
      return this.DE_CONTE_IDSEQ;
  }

   /**
  * The getDE_VERSION method returns the DE_VERSION for this bean.
  *
  * @return String The DE_VERSION
  */
  public String getDE_VERSION()
  {
      return this.DE_VERSION;
  }
   /**
  * The getDE_PREFERRED_DEFINITION method returns the DE_PREFERRED_DEFINITION for this bean.
  *
  * @return String The DE_PREFERRED_DEFINITION
  */
  public String getDE_PREFERRED_DEFINITION()
  {
      return this.DE_PREFERRED_DEFINITION;
  }
   /**
  * The getDE_LONG_NAME method returns the DE_LONG_NAME for this bean.
  *
  * @return String The DE_LONG_NAME
  */
  public String getDE_LONG_NAME()
  {
      return this.DE_LONG_NAME;
  }
   /**
  * The getDE_ASL_NAME method returns the DE_ASL_NAME for this bean.
  *
  * @return String The DE_ASL_NAME
  */
  public String getDE_ASL_NAME()
  {
      return this.DE_ASL_NAME;
  }
   /**
  * The getDE_REG_STATUS method returns the DE_REG_STATUS for this bean.
  *
  * @return String The DE_REG_STATUS
  */
  public String getDE_REG_STATUS()
  {
      return this.DE_REG_STATUS;
  }
   /**
  * The getDE_REG_STATUS_IDSEQ method returns the DE_REG_STATUS_IDSEQ for this bean.
  *
  * @return String The DE_REG_STATUS_IDSEQ
  */
  public String getDE_REG_STATUS_IDSEQ()
  {
      return this.DE_REG_STATUS_IDSEQ;
  }
   /**
  * The getDE_DEC_IDSEQ method returns the DE_DEC_IDSEQ for this bean.
  *
  * @return String The DE_DEC_IDSEQ
  */
  public String getDE_DEC_IDSEQ()
  {
      return this.DE_DEC_IDSEQ;
  }
   /**
  * The getDE_DEC_PREFERRED_NAME method returns the DE_DEC_PREFERRED_NAME for this bean.
  *
  * @return String The DE_DEC_PREFERRED_NAME
  */
  public String getDE_DEC_PREFERRED_NAME()
  {
      return this.DE_DEC_PREFERRED_NAME;
  }
   /**
  * The getDE_VD_IDSEQ method returns the DE_VD_IDSEQ for this bean.
  *
  * @return String The DE_VD_IDSEQ
  */
  public String getDE_VD_IDSEQ()
  {
      return this.DE_VD_IDSEQ;
  }
   /**
  * The getDE_VD_PREFERRED_NAME method returns the DE_VD_PREFERRED_NAME for this bean.
  *
  * @return String The DE_VD_PREFERRED_NAME
  */
  public String getDE_VD_PREFERRED_NAME()
  {
      return this.DE_VD_PREFERRED_NAME;
  }
   /**
  * The getDE_LATEST_VERSION_IND method returns the DE_LATEST_VERSION_IND for this bean.
  *
  * @return String The DE_LATEST_VERSION_IND
  */
  public String getDE_LATEST_VERSION_IND()
  {
      return this.DE_LATEST_VERSION_IND;
  }
   /**
  * The getDE_BEGIN_DATE method returns the DE_BEGIN_DATE for this bean.
  *
  * @return String The DE_BEGIN_DATE
  */
  public String getDE_BEGIN_DATE()
  {
      return this.DE_BEGIN_DATE;
  }
   /**
  * The getDE_END_DATE method returns the DE_END_DATE for this bean.
  *
  * @return String The DE_END_DATE
  */
  public String getDE_END_DATE()
  {
      return this.DE_END_DATE;
  }
   /**
  * The getDE_CHANGE_NOTE method returns the DE_CHANGE_NOTE for this bean.
  *
  * @return String The DE_CHANGE_NOTE
  */
  public String getDE_CHANGE_NOTE()
  {
      return this.DE_CHANGE_NOTE;
  }
   /**
  * The getDE_CREATED_BY method returns the DE_CREATED_BY for this bean.
  *
  * @return String The DE_CREATED_BY
  */
  public String getDE_CREATED_BY()
  {
      return this.DE_CREATED_BY;
  }
   /**
  * The getDE_DATE_CREATED method returns the DE_DATE_CREATED for this bean.
  *
  * @return String The DE_DATE_CREATED
  */
  public String getDE_DATE_CREATED()
  {
      return this.DE_DATE_CREATED;
  }
  /**
  * The getDE_MODIFIED_BY method returns the DE_MODIFIED_BY for this bean.
  *
  * @return String The DE_MODIFIED_BY
  */
  public String getDE_MODIFIED_BY()
  {
      return this.DE_MODIFIED_BY;
  }
  /**
  * The getDE_DATE_MODIFIED method returns the DE_DATE_MODIFIED for this bean.
  *
  * @return String The DE_DATE_MODIFIED
  */
  public String getDE_DATE_MODIFIED()
  {
      return this.DE_DATE_MODIFIED;
  }
  /**
  * The getDE_DELETED_IND method returns the DE_DELETED_IND for this bean.
  *
  * @return String The DE_DELETED_IND
  */
  public String getDE_DELETED_IND()
  {
      return this.DE_DELETED_IND;
  }
  /**
  * The getDE_CONTEXT_NAME method returns the DE_CONTEXT_NAME for this bean.
  *
  * @return String The DE_CONTEXT_NAME
  */
  public String getDE_CONTEXT_NAME()
  {
      return this.DE_CONTEXT_NAME;
  }
  /**
  * The getDE_DEC_NAME method returns the DE_DEC_NAME for this bean.
  *
  * @return String The DE_DEC_NAME
  */
  public String getDE_DEC_NAME()
  {
      return this.DE_DEC_NAME;
  }
  /**
  * The getDE_VD_NAME method returns the DE_VD_NAME for this bean.
  *
  * @return String The DE_VD_NAME
  */
  public String getDE_VD_NAME()
  {
      return this.DE_VD_NAME;
  }
  /**
  * The getDE_MIN_CDE_ID method returns the DE_MIN_CDE_ID for this bean.
  *
  * @return String The DE_MIN_CDE_ID
  */
  public String getDE_MIN_CDE_ID()
  {
      return this.DE_MIN_CDE_ID;
  }
/*  *//**
  * The getDE_HIST_CDE_ID method returns the DE_HIST_CDE_ID for this bean.
  *
  * @return String The DE_HIST_CDE_ID
  *//*
  public String getDE_HIST_CDE_ID()
  {
      return this.DE_HIST_CDE_ID;
  }
  *//**
  * The getDE_HIST_CDE_ID_COUNT method returns the DE_HIST_CDE_ID_COUNT for this bean.
  *
  * @return Integer The DE_HIST_CDE_ID_COUNT
  *//*
  public Integer getDE_HIST_CDE_ID_COUNT()
  {
      return this.DE_HIST_CDE_ID_COUNT;
  }
*/  
  /**
  * The getDE_LANGUAGE method returns the DE_LANGUAGE for this bean.
  *
  * @return String The DE_LANGUAGE
  */
  public String getDE_LANGUAGE()
  {
      return this.DE_LANGUAGE;
  }
  /**
  * The getDE_LANGUAGE_IDSEQ method returns the DE_LANGUAGE_IDSEQ for this bean.
  *
  * @return String The DE_LANGUAGE_IDSEQ
  */
  public String getDE_LANGUAGE_IDSEQ()
  {
      return this.DE_LANGUAGE_IDSEQ;
  }
  /**
  * The getDE_SOURCE method returns the DE_SOURCE for this bean.
  *
  * @return String The DE_SOURCE
  */
  public String getDE_SOURCE()
  {
      return this.DE_SOURCE;
  }
  /**
  * The getDE_SOURCE_IDSEQ method returns the DE_SOURCE_IDSEQ for this bean.
  *
  * @return String The DE_SOURCE_IDSEQ
  */
  public String getDE_SOURCE_IDSEQ()
  {
      return this.DE_SOURCE_IDSEQ;
  }
  /**
  * The getDE_PROTOCOL_ID method returns the DE_PROTOCOL_ID for this bean.
  *
  * @return String The DE_PROTOCOL_ID
  */
  public String getDE_PROTOCOL_ID()
  {
      return this.DE_PROTOCOL_ID;
  }
  /**
  * The getDE_CRF_NAME method returns the DE_CRF_NAME for this bean.
  *
  * @return String The DE_CRF_NAME
  */
  public String getDE_CRF_NAME()
  {
      return this.DE_CRF_NAME;
  }
  /**
  * The getDE_PROTO_CRF_Count method returns the DE_PROTO_CRF_Count for this bean.
  *
  * @return Integer The DE_PROTO_CRF_Count
  */
  public Integer getDE_PROTO_CRF_Count()
  {
      return this.DE_PROTO_CRF_Count;
  }
  /**
  * The getDE_CRF_IDSEQ method returns the DE_CRF_IDSEQ for this bean.
  *
  * @return String The DE_CRF_IDSEQ
  */
  public String getDE_CRF_IDSEQ()
  {
      return this.DE_CRF_IDSEQ;
  }
  /**
  * The getDE_TYPE_NAME method returns the DE_TYPE_NAME for this bean.
  *
  * @return String The DE_TYPE_NAME
  */
  public String getDE_TYPE_NAME()
  {
      return this.DE_TYPE_NAME;
  }
  /**
  * The getDE_DER_RELATION method returns the DE_DER_RELATION for this bean.
  *
  * @return String The DE_DER_RELATION
  */
  public String getDE_DER_RELATION()
  {
      return this.DE_DER_RELATION;
  }

  /**
   * @return Returns the dE_DER_REL_IDSEQ.
   */
  public String getDE_DER_REL_IDSEQ()
  {
    return DE_DER_REL_IDSEQ;
  }

  /**
  * The getDE_DES_ALIAS_ID method returns the DE_DES_ALIAS_ID for this bean.
  *
  * @return String The DE_DES_ALIAS_ID
  */
  public String getDE_DES_ALIAS_ID()
  {
      return this.DE_DES_ALIAS_ID;
  }
   /**
  * The getDE_ALIAS_NAME method returns the DE_ALIAS_NAME for this bean.
  *
  * @return String The DE_ALIAS_NAME
  */
  public String getDE_ALIAS_NAME()
  {
      return this.DE_ALIAS_NAME;
  }
   /**
  * The getDE_USEDBY_CONTEXT method returns the DE_USEDBY_CONTEXT for this bean.
  *
  * @return String The DE_USEDBY_CONTEXT
  */
  public String getDE_USEDBY_CONTEXT()
  {
      return this.DE_USEDBY_CONTEXT;
  }
   /**
  * The getDE_USEDBY_CONTEXT_ID method returns the DE_USEDBY_CONTEXT_ID for this bean.
  *
  * @return Vector The DE_USEDBY_CONTEXT_ID
  */
  public Vector getDE_USEDBY_CONTEXT_ID()
  {
      return this.DE_USEDBY_CONTEXT_ID;
  }
   /**
  * The getAC_SELECTED_CONTEXT_ID method returns the DE_SELECTED_CONTEXT_ID for this bean.
  *
  * @return Vector The DE_SELECTED_CONTEXT_ID
  */
  public Vector getAC_SELECTED_CONTEXT_ID()
  {
      return this.DE_SELECTED_CONTEXT_ID;
  }
  /**
	* The getDE_DEC_Definition method returns the DE_DEC_Definition for this bean.
  *
	* @return String The DE_DEC_Definition
  */
	public String getDE_DEC_Definition()
  {
			return this.DE_DEC_Definition;
	}
  /**
	* The getDE_VD_Definition method returns the DE_VD_Definition for this bean.
  *
	* @return String The DE_VD_Definition
  */
	public String getDE_VD_Definition()
  {
			return this.DE_VD_Definition;
	}
  /**
	* The getDE_Question_ID method returns the DE_Question_ID for this bean.
  *
	* @return String The DE_Question_ID
  */
	public String getDE_Question_ID()
  {
			return this.DE_Question_ID;
	}
  /**
	* The getDE_Question_Name method returns the DE_Question_Name for this bean.
  *
	* @return String The DE_Question_Name
  */
	public String getDE_Question_Name()
   {
			return this.DE_Question_Name;
	}
  /**
	* The getDE_Permissible_Value method returns the DE_Permissible_Value for this bean.
  *
	* @return String The DE_Permissible_Value
  */
	public String getDE_Permissible_Value()
   {
			return this.DE_Permissible_Value;
	}
  /**
	* The getDE_Permissible_Value_Count method returns the DE_Permissible_Value_Count for this bean.
  *
	* @return Integer The DE_Permissible_Value_Count
  */
	public Integer getDE_Permissible_Value_Count()
   {
			return this.DE_Permissible_Value_Count;
	}
  /**
  * The getDE_CHECKED method returns the DE_CHECKED for this bean.
  *
  * @return boolean The DE_CHECKED
  */
  public boolean getDE_CHECKED()
  {
      return this.DE_CHECKED;
  }
  /**
  * The getAC_CS method returns the AC_CS for this bean.
  *
  * @return Vector The AC_CS
  */
  public Vector getAC_CS_NAME()
  {
      return this.AC_CS_NAME;
  }
  /**
  * The getAC_CS_ID method returns the AC_CS_ID for this bean.
  *
  * @return Vector The AC_CS_ID
  */
  public Vector getAC_CS_ID()
  {
      return this.AC_CS_ID;
  }
  /**
  * The getAC_CSI method returns the AC_CSI for this bean.
  *
  * @return String The AC_CSI
  */
  public Vector getAC_CSI_NAME()
  {
      return this.AC_CSI_NAME;
  }
  /**
  * The getAC_CSI_ID method returns the AC_CSI_ID for this bean.
  *
  * @return String The AC_CSI_ID
  */
  public Vector getAC_CSI_ID()
  {
      return this.AC_CSI_ID;
  }
  
  /**
  * The getAC_AC_CSI_VECTOR method returns the AC_AC_CSI_VECTOR for this bean.
  *
  * @return Vector The AC_AC_CSI_VECTOR
  */
  public Vector getAC_AC_CSI_VECTOR()
  {
      return this.AC_AC_CSI_VECTOR;
  }
  /**
  * The getAC_AC_CSI_ID method returns the AC_AC_CSI_ID for this bean.
  *
  * @return Vector The AC_AC_CSI_ID
  */
  public Vector getAC_AC_CSI_ID()
  {
      return this.AC_AC_CSI_ID;
  }
   /**
  * The getAC_CS_CSI_ID method returns the AC_CS_CSI_ID for this bean.
  *
  * @return Vector The AC_CS_CSI_ID
  */
  public Vector getAC_CS_CSI_ID()
  {
      return this.AC_CS_CSI_ID;
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
  public Hashtable getAC_CONTACTS()
  {
    return AC_CONTACTS;
  }

  /**
  * The getDOC_TEXT_PREFERRED_QUESTION method returns the DOC_TEXT_PREFERRED_QUESTION for this bean.
  *
  * @return String The DOC_TEXT_PREFERRED_QUESTION
  */
  public String getDOC_TEXT_PREFERRED_QUESTION()
  {
      return this.DOC_TEXT_PREFERRED_QUESTION;
  }
  /**
  * The getDOC_TEXT_PREFERRED_QUESTION_IDSEQ method returns the DOC_TEXT_PREFERRED_QUESTION_IDSEQ for this bean.
  *
  * @return String The DOC_TEXT_PREFERRED_QUESTION_IDSEQ
  */
  public String getDOC_TEXT_PREFERRED_QUESTION_IDSEQ()
  {
      return this.DOC_TEXT_PREFERRED_QUESTION_IDSEQ;
  }
  /**
  * The getDOC_TEXT_PREFERRED_QUESTION_COUNT method returns the DOC_TEXT_PREFERRED_QUESTION_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_PREFERRED_QUESTION_COUNT
  *//*
  public Integer getDOC_TEXT_PREFERRED_QUESTION_COUNT()
  {
      return this.DOC_TEXT_PREFERRED_QUESTION_COUNT;
  }
  *//**
  * The getDOC_TEXT_HISTORIC_NAME method returns the DOC_TEXT_HISTORIC_NAME for this bean.
  *
  * @return String The DOC_TEXT_HISTORIC_NAME
  *//*
  public String getDOC_TEXT_HISTORIC_NAME()
  {
      return this.DOC_TEXT_HISTORIC_NAME;
  }
  *//**
  * The getDOC_TEXT_HISTORIC_COUNT method returns the DOC_TEXT_HISTORIC_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_HISTORIC_COUNT
  *//*
  public Integer getDOC_TEXT_HISTORIC_COUNT()
  {
      return this.DOC_TEXT_HISTORIC_COUNT;
  }
  *//**
  * The getDOC_TEXT_REFERENCE method returns the DOC_TEXT_REFERENCE for this bean.
  *
  * @return String The DOC_TEXT_REFERENCE
  *//*
  public String getDOC_TEXT_REFERENCE()
  {
      return this.DOC_TEXT_REFERENCE;
  }
  *//**
  * The getDOC_TEXT_REFERENCE_COUNT method returns the DOC_TEXT_REFERENCE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_REFERENCE_COUNT
  *//*
  public Integer getDOC_TEXT_REFERENCE_COUNT()
  {
      return this.DOC_TEXT_REFERENCE_COUNT;
  }
  *//**
  * The getDOC_TEXT_EXAMPLE method returns the DOC_TEXT_EXAMPLE for this bean.
  *
  * @return String The DOC_TEXT_EXAMPLE
  *//*
  public String getDOC_TEXT_EXAMPLE()
  {
      return this.DOC_TEXT_EXAMPLE;
  }
  *//**
  * The getDOC_TEXT_EXAMPLE_COUNT method returns the DOC_TEXT_EXAMPLE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_EXAMPLE_COUNT
  *//*
  public Integer getDOC_TEXT_EXAMPLE_COUNT()
  {
      return this.DOC_TEXT_EXAMPLE_COUNT;
  }
  *//**
  * The getDOC_TEXT_COMMENT method returns the DOC_TEXT_COMMENT for this bean.
  *
  * @return String The DOC_TEXT_COMMENT
  *//*
  public String getDOC_TEXT_COMMENT()
  {
      return this.DOC_TEXT_COMMENT;
  }
  *//**
  * The getDOC_TEXT_COMMENT_COUNT method returns the DOC_TEXT_COMMENT_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_COMMENT_COUNT
  *//*
  public Integer getDOC_TEXT_COMMENT_COUNT()
  {
      return this.DOC_TEXT_COMMENT_COUNT;
  }
  *//**
  * The getDOC_TEXT_NOTE method returns the DOC_TEXT_NOTE for this bean.
  *
  * @return String The DOC_TEXT_NOTE
  *//*
  public String getDOC_TEXT_NOTE()
  {
      return this.DOC_TEXT_NOTE;
  }
  *//**
  * The getDOC_TEXT_NOTE_COUNT method returns the DOC_TEXT_NOTE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_NOTE_COUNT
  *//*
  public Integer getDOC_TEXT_NOTE_COUNT()
  {
      return this.DOC_TEXT_NOTE_COUNT;
  }
  *//**
  * The getDOC_TEXT_DESCRIPTION method returns the DOC_TEXT_DESCRIPTION for this bean.
  *
  * @return String The DOC_TEXT_DESCRIPTION
  *//*
  public String getDOC_TEXT_DESCRIPTION()
  {
      return this.DOC_TEXT_DESCRIPTION;
  }
  *//**
  * The getDOC_TEXT_DESCRIPTION_COUNT method returns the DOC_TEXT_DESCRIPTION_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_DESCRIPTION_COUNT
  *//*
  public Integer getDOC_TEXT_DESCRIPTION_COUNT()
  {
      return this.DOC_TEXT_DESCRIPTION_COUNT;
  }
  *//**
  * The getDOC_TEXT_IMAGE_FILE method returns the DOC_TEXT_IMAGE_FILE for this bean.
  *
  * @return String The DOC_TEXT_IMAGE_FILE
  *//*
  public String getDOC_TEXT_IMAGE_FILE()
  {
      return this.DOC_TEXT_IMAGE_FILE;
  }
  *//**
  * The getDOC_TEXT_IMAGE_FILE_COUNT method returns the DOC_TEXT_IMAGE_FILE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_IMAGE_FILE_COUNT
  *//*
  public Integer getDOC_TEXT_IMAGE_FILE_COUNT()
  {
      return this.DOC_TEXT_IMAGE_FILE_COUNT;
  }
  *//**
  * The getDOC_TEXT_VALID_VALUE_SOURCE method returns the DOC_TEXT_VALID_VALUE_SOURCE for this bean.
  *
  * @return String The DOC_TEXT_VALID_VALUE_SOURCE
  *//*
  public String getDOC_TEXT_VALID_VALUE_SOURCE()
  {
      return this.DOC_TEXT_VALID_VALUE_SOURCE;
  }
  *//**
  * The getDOC_TEXT_VALID_VALUE_SOURCE_COUNT method returns the DOC_TEXT_VALID_VALUE_SOURCE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_VALID_VALUE_SOURCE_COUNT
  *//*
  public Integer getDOC_TEXT_VALID_VALUE_SOURCE_COUNT()
  {
      return this.DOC_TEXT_VALID_VALUE_SOURCE_COUNT;
  }
  *//**
  * The getDOC_TEXT_DATA_ELEMENT_SOURCE method returns the DOC_TEXT_DATA_ELEMENT_SOURCE for this bean.
  *
  * @return String The DOC_TEXT_DATA_ELEMENT_SOURCE
  *//*
  public String getDOC_TEXT_DATA_ELEMENT_SOURCE()
  {
      return this.DOC_TEXT_DATA_ELEMENT_SOURCE;
  }
  *//**
  * The getDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT method returns the DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT
  *//*
  public Integer getDOC_TEXT_DATA_ELEMENT_SOURCE_COUNT()
  {
      return this.DOC_TEXT_DATA_ELEMENT_SOURCE_COUNT;
  }
  *//**
  * The getDOC_TEXT_UML_Class method returns the DOC_TEXT_UML_Class for this bean.
  *
  * @return String The DOC_TEXT_UML_Class
  *//*
  public String getDOC_TEXT_UML_Class()
  {
      return this.DOC_TEXT_UML_Class;
  }
  *//**
  * The getDOC_TEXT_UML_Class_Count method returns the DOC_TEXT_UML_Class_Count for this bean.
  *
  * @return Integer The DOC_TEXT_UML_Class_Count
  *//*
  public Integer getDOC_TEXT_UML_Class_Count()
  {
      return this.DOC_TEXT_UML_Class_Count;
  }
  *//**
  * The getDOC_TEXT_DETAIL_DESCRIPTION method returns the DOC_TEXT_DETAIL_DESCRIPTION for this bean.
  *
  * @return String The DOC_TEXT_DETAIL_DESCRIPTION
  *//*
  public String getDOC_TEXT_DETAIL_DESCRIPTION()
  {
      return this.DOC_TEXT_DETAIL_DESCRIPTION;
  }
  *//**
  * The getDOC_TEXT_DETAIL_DESCRIPTION_COUNT method returns the DOC_TEXT_DETAIL_DESCRIPTION_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_DETAIL_DESCRIPTION_COUNT
  *//*
  public Integer getDOC_TEXT_DETAIL_DESCRIPTION_COUNT()
  {
      return this.DOC_TEXT_DETAIL_DESCRIPTION_COUNT;
  }
  *//**
  * The getDOC_TEXT_TECHNICAL_GUIDE method returns the DOC_TEXT_TECHNICAL_GUIDE for this bean.
  *
  * @return String The DOC_TEXT_TECHNICAL_GUIDE
  *//*
  public String getDOC_TEXT_TECHNICAL_GUIDE()
  {
      return this.DOC_TEXT_TECHNICAL_GUIDE;
  }
  *//**
  * The getDOC_TEXT_TECHNICAL_GUIDE_COUNT method returns the DOC_TEXT_TECHNICAL_GUIDE_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_TECHNICAL_GUIDE_COUNT
  *//*
  public Integer getDOC_TEXT_TECHNICAL_GUIDE_COUNT()
  {
      return this.DOC_TEXT_TECHNICAL_GUIDE_COUNT;
  }
  *//**
  * The getDOC_TEXT_UML_Attribute method returns the DOC_TEXT_UML_Attribute for this bean.
  *
  * @return String The DOC_TEXT_UML_Attribute
  *//*
  public String getDOC_TEXT_UML_Attribute()
  {
      return this.DOC_TEXT_UML_Attribute;
  }
  *//**
  * The getDOC_TEXT_UML_Attribute_Count method returns the DOC_TEXT_UML_Attribute_Count for this bean.
  *
  * @return Integer The DOC_TEXT_UML_Attribute_Count
  *//*
  public Integer getDOC_TEXT_UML_Attribute_Count()
  {
      return this.DOC_TEXT_UML_Attribute_Count;
  }
  *//**
  * The getDOC_TEXT_LABEL method returns the DOC_TEXT_LABEL for this bean.
  *
  * @return String The DOC_TEXT_LABEL
  *//*
  public String getDOC_TEXT_LABEL()
  {
      return this.DOC_TEXT_LABEL;
  }
  *//**
  * The getDOC_TEXT_LABEL_COUNT method returns the DOC_TEXT_LABEL_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_LABEL_COUNT
  *//*
  public Integer getDOC_TEXT_LABEL_COUNT()
  {
      return this.DOC_TEXT_LABEL_COUNT;
  }
  */
  
  /**
  * The getREFERENCE_DOCUMENT method returns the REFERENCE_DOCUMENT for this bean.
  *
  * @return String The REFERENCE_DOCUMENT
  */
  public String getREFERENCE_DOCUMENT()
  {
      return this.REFERENCE_DOCUMENT;
  }
/*  *//**
  * The getDOC_TEXT_OTHER_REF_TYPES_COUNT method returns the DOC_TEXT_OTHER_REF_TYPES_COUNT for this bean.
  *
  * @return Integer The DOC_TEXT_OTHER_REF_TYPES_COUNT
  *//*
  public Integer getDOC_TEXT_OTHER_REF_TYPES_COUNT()
  {
      return this.DOC_TEXT_OTHER_REF_TYPES_COUNT;
  }
*/
  
  /**
   * @return Returns the aLTERNATE_NAME.
   */
  public String getALTERNATE_NAME()
  {
    return ALTERNATE_NAME;
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
  /**
   * The getDE_DEC_Bean method returns the DE_DEC_Bean for this bean.
   *
   * @return bean The DE_DEC_Bean
   */
  public DEC_Bean getDE_DEC_Bean()
  {
      return this.DE_DEC_Bean;
  }
  /**
   * The getDE_VD_Bean method returns the DE_VD_Bean for this bean.
   *
   * @return bean The DE_VD_Bean
   */
  public VD_Bean getDE_VD_Bean()
  {
      return this.DE_VD_Bean;
  }
  /**
  * The getDEC_VD_CHANGED method returns the DEC_VD_CHANGED for this bean.
  *
  * @return boolean The DEC_VD_CHANGED
  */
  public boolean getDEC_VD_CHANGED()
  {
      return this.DEC_VD_CHANGED;
  }

//end of class
}
