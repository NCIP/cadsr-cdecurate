package com.scenpro.NCICuration;

import java.io.*;
import java.util.*;

/**
 * The PV_Bean encapsulates the PV information and is stored in the
 * session after the user has created a new Permissable Value.
 * <P>
 * @author Tom Phillips
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

public class PV_Bean implements Serializable
{
//Attributes
  private String RETURN_CODE;
  private String PV_PV_IDSEQ;
  private String PV_VDPVS_IDSEQ;
  private String PV_VALUE;
  private String PV_SHORT_MEANING;
  private String PV_CONCEPTUAL_DOMAIN;
  private String PV_BEGIN_DATE;
  private String PV_MEANING_DESCRIPTION;
  private String PV_VALUE_DESCRIPTION;
  private String PV_VALUE_ORIGIN;
  private String PV_LOW_VALUE_NUM;
  private String PV_HIGH_VALUE_NUM;
  private String PV_END_DATE;
  private String PV_CREATED_BY;
  private String PV_DATE_CREATED;
  private String PV_MODIFIED_BY;
  private String PV_DATE_MODIFIED;
  private String QUESTION_VALUE;
  private String QUESTION_VALUE_IDSEQ;
  private boolean PV_CHECKED = false;
  private String VP_SUBMIT_ACTION;
  private EVS_Bean VM_CONCEPT;
  private EVS_Bean PARENT_CONCEPT;
  
  private String PV_NCI_CC_TYPE;
  private String PV_NCI_CC_VAL;
  private String PV_UMLS_CUI_VAL;
  private String PV_UMLS_CUI_TYPE;
  private String PV_TEMP_CUI_VAL;
  private String PV_TEMP_CUI_TYPE;
  private String PV_EVS_DATABASE;
  private String PV_EVS_SOURCE;
  
  private String PV_VM_CONDR_IDSEQ;


  /**
   * Constructor
  */
  public void PV_Bean() {
  };
  
  public PV_Bean copyBean(PV_Bean fromBean)
  {
    this.setPV_PV_IDSEQ(fromBean.getPV_PV_IDSEQ());
    this.setQUESTION_VALUE(fromBean.getQUESTION_VALUE());
    this.setQUESTION_VALUE_IDSEQ(fromBean.getQUESTION_VALUE_IDSEQ());
    this.setPV_VALUE(fromBean.getPV_VALUE());
    this.setPV_SHORT_MEANING(fromBean.getPV_SHORT_MEANING());
    this.setPV_MEANING_DESCRIPTION(fromBean.getPV_MEANING_DESCRIPTION());
    EVS_Bean vmBean = fromBean.getVM_CONCEPT();
    if (vmBean == null) vmBean = new EVS_Bean();
    this.setVM_CONCEPT(vmBean);
    this.setPV_VALUE_ORIGIN(fromBean.getPV_VALUE_ORIGIN());
    this.setPV_BEGIN_DATE(fromBean.getPV_BEGIN_DATE());
    this.setPV_END_DATE(fromBean.getPV_END_DATE());
    
    //send the to bean back
    return this;
  }
  //Set properties
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
  * The setPV_PV_IDSEQ method sets the PV_PV_IDSEQ for this bean.
  *
  * @param s The PV_PV_IDSEQ to set
  */
  public void setPV_PV_IDSEQ(String s)
  {
      this.PV_PV_IDSEQ = s;
  }
  /**
  * The setPV_VDPVS_IDSEQ method sets the PV_VDPVS_IDSEQ for this bean.
  *
  * @param s The PV_VDPVS_IDSEQ to set
  */
  public void setPV_VDPVS_IDSEQ(String s)
  {
      this.PV_VDPVS_IDSEQ = s;
  }
  /**
  * The setPV_VALUE method sets the PV_VALUE for this bean.
  *
  * @param s The PV_VALUE to set
  */
  public void setPV_VALUE(String s)
  {
      this.PV_VALUE = s;
  }
  /**
  * The setPV_SHORT_MEANING method sets the PV_SHORT_MEANING for this bean.
  *
  * @param s The PV_SHORT_MEANING to set
  */
  public void setPV_SHORT_MEANING(String s)
  {
      this.PV_SHORT_MEANING = s;
  }
  /**
  * The setPV_CONCEPTUAL_DOMAIN method sets the PV_CONCEPTUAL_DOMAIN for this bean.
  *
  * @param s The PV_CONCEPTUAL_DOMAIN to set
  */
  public void setPV_CONCEPTUAL_DOMAIN(String s)
  {
      this.PV_CONCEPTUAL_DOMAIN = s;
  }
  /**
  * The setPV_BEGIN_DATE method sets the PV_BEGIN_DATE for this bean.
  *
  * @param s The PV_BEGIN_DATE to set
  */
  public void setPV_BEGIN_DATE(String s)
  {
      this.PV_BEGIN_DATE = s;
  }
  /**
  * The setPV_MEANING_DESCRIPTION method sets the PV_MEANING_DESCRIPTION for this bean.
  *
  * @param s The PV_MEANING_DESCRIPTION to set
  */
  public void setPV_MEANING_DESCRIPTION(String s)
  {
      this.PV_MEANING_DESCRIPTION = s;
  }
  /**
  * The setPV_VALUE_DESCRIPTION method sets the PV_VALUE_DESCRIPTION for this bean.
  *
  * @param s The PV_VALUE_DESCRIPTION to set
  */
  public void setPV_VALUE_DESCRIPTION(String s)
  {
      this.PV_VALUE_DESCRIPTION = s;
  }
  /**
  * The setPV_VALUE_ORIGIN method sets the PV_VALUE_ORIGIN for this bean.
  *
  * @param s The PV_VALUE_ORIGIN to set
  */
  public void setPV_VALUE_ORIGIN(String s)
  {
      this.PV_VALUE_ORIGIN = s;
  }
  /**
  * The setPV_LOW_VALUE_NUM method sets the PV_LOW_VALUE_NUM for this bean.
  *
  * @param s The PV_LOW_VALUE_NUM to set
  */
  public void setPV_LOW_VALUE_NUM(String s)
  {
      this.PV_LOW_VALUE_NUM = s;
  }
  /**
  * The setPV_HIGH_VALUE_NUM method sets the PV_HIGH_VALUE_NUM for this bean.
  *
  * @param s The PV_HIGH_VALUE_NUM to set
  */
  public void setPV_HIGH_VALUE_NUM(String s)
  {
      this.PV_HIGH_VALUE_NUM = s;
  }
  /**
  * The setPV_END_DATE method sets the PV_END_DATE for this bean.
  *
  * @param s The PV_END_DATE to set
  */
  public void setPV_END_DATE(String s)
  {
      this.PV_END_DATE = s;
  }
  /**
  * The setPV_CREATED_BY method sets the PV_CREATED_BY for this bean.
  *
  * @param s The PV_CREATED_BY to set
  */
  public void setPV_CREATED_BY(String s)
  {
      this.PV_CREATED_BY = s;
  }
  /**
  * The setPV_DATE_CREATED method sets the PV_DATE_CREATED for this bean.
  *
  * @param s The PV_DATE_CREATED to set
  */
  public void setPV_DATE_CREATED(String s)
  {
      this.PV_DATE_CREATED = s;
  }
  /**
  * The setPV_MODIFIED_BY method sets the PV_MODIFIED_BY for this bean.
  *
  * @param s The PV_MODIFIED_BY to set
  */
  public void setPV_MODIFIED_BY(String s)
  {
      this.PV_MODIFIED_BY = s;
  }
  /**
  * The setPV_DATE_MODIFIED method sets the PV_DATE_MODIFIED for this bean.
  *
  * @param s The PV_DATE_MODIFIED to set
  */
  public void setPV_DATE_MODIFIED(String s)
  {
      this.PV_DATE_MODIFIED = s;
  }
  /**
  * The setQUESTION_VALUE method sets the QUESTION_VALUE for this bean.
  *
  * @param s The QUESTION_VALUE to set
  */
  public void setQUESTION_VALUE(String s)
  {
      this.QUESTION_VALUE = s;
  }
  /**
  * The setQUESTION_VALUE_IDSEQ method sets the QUESTION_VALUE_IDSEQ for this bean.
  *
  * @param s The QUESTION_VALUE_IDSEQ to set
  */
  public void setQUESTION_VALUE_IDSEQ(String s)
  {
      this.QUESTION_VALUE_IDSEQ = s;
  }
  /**
  * The setPV_CHECKED method sets the PV_CHECKED for this bean.
  *
  * @param b The PV_CHECKED to set
  */
  public void setPV_CHECKED(boolean b)
  {
      this.PV_CHECKED = b;
  }
  /**
  * The setVP_SUBMIT_ACTION method sets the VP_SUBMIT_ACTION for this bean.
  *
  * @param s The VP_SUBMIT_ACTION to set
  */
  public void setVP_SUBMIT_ACTION(String s)
  {
      this.VP_SUBMIT_ACTION = s;
  }
  /**
  * The setVM_CONCEPT method sets the VM_CONCEPT for this bean.
  *
  * @param s The VM_CONCEPT to set
  */
  public void setVM_CONCEPT(EVS_Bean s)
  {
      this.VM_CONCEPT = s;
  }
  /**
  * The setPARENT_CONCEPT method sets the PARENT_CONCEPT for this bean.
  *
  * @param s The PARENT_CONCEPT to set
  */
  public void setPARENT_CONCEPT(EVS_Bean s)
  {
      this.PARENT_CONCEPT = s;
  }
  /**
  * The setPV_NCI_CC_TYPE method sets the PV_NCI_CC_TYPE for this bean.
  *
  * @param s The PV_NCI_CC_TYPE to set
  */
  public void setPV_NCI_CC_TYPE(String s)
  {
      this.PV_NCI_CC_TYPE = s;
  }
  /**
  * The setPV_NCI_CC_VAL method sets the PV_NCI_CC_VAL for this bean.
  *
  * @param s The PV_NCI_CC_VAL to set
  */
  public void setPV_NCI_CC_VAL(String s)
  {
      this.PV_NCI_CC_VAL = s;
  }
  /**
  * The setPV_UMLS_CUI_VAL method sets the PV_UMLS_CUI_VAL for this bean.
  *
  * @param s The PV_UMLS_CUI_VAL to set
  */
  public void setPV_UMLS_CUI_VAL(String s)
  {
      this.PV_UMLS_CUI_VAL = s;
  }
  /**
  * The setPV_UMLS_CUI_TYPE method sets the PV_UMLS_CUI_TYPE for this bean.
  *
  * @param s The PV_UMLS_CUI_TYPE to set
  */
  public void setPV_UMLS_CUI_TYPE(String s)
  {
      this.PV_UMLS_CUI_TYPE = s;
  }
  /**
  * The setPV_TEMP_CUI_VAL method sets the PV_TEMP_CUI_VAL for this bean.
  *
  * @param s The PV_TEMP_CUI_VAL to set
  */
  public void setPV_TEMP_CUI_VAL(String s)
  {
      this.PV_TEMP_CUI_VAL = s;
  }
  /**
  * The setPV_TEMP_CUI_TYPE method sets the PV_TEMP_CUI_TYPE for this bean.
  *
  * @param s The PV_TEMP_CUI_TYPE to set
  */
  public void setPV_TEMP_CUI_TYPE(String s)
  {
      this.PV_TEMP_CUI_TYPE = s;
  }
  /**
  * The setPV_EVS_SOURCE method sets the PV_EVS_SOURCE for this bean.
  *
  * @param s The PV_EVS_SOURCE to set
  */
  public void setPV_EVS_SOURCE(String s)
  {
      this.PV_EVS_SOURCE = s;
  }
  /**
  * The setPV_EVS_DATABASE method sets the PV_EVS_DATABASE for this bean.
  *
  * @param s The PV_EVS_DATABASE to set
  */
  public void setPV_EVS_DATABASE(String s)
  {
      this.PV_EVS_DATABASE = s;
  }
  /**
  * The setPV_VM_CONDR_IDSEQ method sets the PV_VM_CONDR_IDSEQ for this bean.
  *
  * @param s The PV_VM_CONDR_IDSEQ to set
  */
  public void setPV_VM_CONDR_IDSEQ(String s)
  {
      this.PV_VM_CONDR_IDSEQ = s;
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
  * The getPV_PV_IDSEQ method returns the PV_PV_IDSEQ for this bean.
  *
  * @return String The PV_PV_IDSEQ
  */
  public String getPV_PV_IDSEQ()
  {
      return this.PV_PV_IDSEQ;
  }
  /**
  * The getPV_VDPVS_IDSEQ method returns the PV_VDPVS_IDSEQ for this bean.
  *
  * @return String The PV_VDPVS_IDSEQ
  */
  public String getPV_VDPVS_IDSEQ()
  {
      return this.PV_VDPVS_IDSEQ;
  }
  /**
  * The getPV_VALUE method returns the PV_VALUE for this bean.
  *
  * @return String The PV_VALUE
  */
  public String getPV_VALUE()
  {
      return this.PV_VALUE;
  }
  /**
  * The getPV_SHORT_MEANING method returns the PV_SHORT_MEANING for this bean.
  *
  * @return String The PV_SHORT_MEANING
  */
  public String getPV_SHORT_MEANING()
  {
      return this.PV_SHORT_MEANING;
  }
  /**
  * The getPV_CONCEPTUAL_DOMAIN method returns the PV_CONCEPTUAL_DOMAIN for this bean.
  *
  * @return String The PV_CONCEPTUAL_DOMAIN
  */
  public String getPV_CONCEPTUAL_DOMAIN()
  {
      return this.PV_CONCEPTUAL_DOMAIN;
  }
  /**
  * The getPV_BEGIN_DATE method returns the PV_BEGIN_DATE for this bean.
  *
  * @return String The PV_BEGIN_DATE
  */
  public String getPV_BEGIN_DATE()
  {
      return this.PV_BEGIN_DATE;
  }
  /**
  * The getPV_MEANING_DESCRIPTION method returns the PV_MEANING_DESCRIPTION for this bean.
  *
  * @return String The PV_MEANING_DESCRIPTION
  */
  public String getPV_MEANING_DESCRIPTION()
  {
      return this.PV_MEANING_DESCRIPTION;
  }
  /**
  * The getPV_VALUE_DESCRIPTION method returns the PV_VALUE_DESCRIPTION for this bean.
  *
  * @return String The PV_VALUE_DESCRIPTION
  */
  public String getPV_VALUE_DESCRIPTION()
  {
      return this.PV_VALUE_DESCRIPTION;
  }
  /**
  * The getPV_VALUE_ORIGIN method returns the PV_VALUE_ORIGIN for this bean.
  *
  * @return String The PV_VALUE_ORIGIN
  */
  public String getPV_VALUE_ORIGIN()
  {
      return this.PV_VALUE_ORIGIN;
  }
  /**
  * The getPV_LOW_VALUE_NUM method returns the PV_LOW_VALUE_NUM for this bean.
  *
  * @return String The PV_LOW_VALUE_NUM
  */
  public String getPV_LOW_VALUE_NUM()
  {
      return this.PV_LOW_VALUE_NUM;
  }
  /**
  * The getPV_HIGH_VALUE_NUM method returns the PV_HIGH_VALUE_NUM for this bean.
  *
  * @return String The PV_HIGH_VALUE_NUM
  */
  public String getPV_HIGH_VALUE_NUM()
  {
      return this.PV_HIGH_VALUE_NUM;
  }
  /**
  * The getPV_END_DATE method returns the PV_END_DATE for this bean.
  *
  * @return String The PV_END_DATE
  */
  public String getPV_END_DATE()
  {
      return this.PV_END_DATE;
  }
  /**
  * The getPV_CREATED_BY method returns the PV_CREATED_BY for this bean.
  *
  * @return String The PV_CREATED_BY
  */
  public String getPV_CREATED_BY()
  {
      return this.PV_CREATED_BY;
  }
  /**
  * The getPV_DATE_CREATED method returns the PV_DATE_CREATED for this bean.
  *
  * @return String The PV_DATE_CREATED
  */
  public String getPV_DATE_CREATED()
  {
      return this.PV_DATE_CREATED;
  }
  /**
  * The getPV_MODIFIED_BY method returns the PV_MODIFIED_BY for this bean.
  *
  * @return String The PV_MODIFIED_BY
  */
  public String getPV_MODIFIED_BY()
  {
      return this.PV_MODIFIED_BY;
  }
  /**
  * The getPV_DATE_MODIFIED method returns the PV_DATE_MODIFIED for this bean.
  *
  * @return String The PV_DATE_MODIFIED
  */
  public String getPV_DATE_MODIFIED()
  {
      return this.PV_DATE_MODIFIED;
  }
  /**
  * The getQUESTION_VALUE method returns the QUESTION_VALUE for this bean.
  *
  * @return String The QUESTION_VALUE
  */
  public String getQUESTION_VALUE()
  {
      return this.QUESTION_VALUE;
  }
  /**
  * The getQUESTION_VALUE_IDSEQ method returns the QUESTION_VALUE_IDSEQ for this bean.
  *
  * @return String The QUESTION_VALUE_IDSEQ
  */
  public String getQUESTION_VALUE_IDSEQ()
  {
      return this.QUESTION_VALUE_IDSEQ;
  }
  /**
  * The getPV_CHECKED method returns the PV_CHECKED for this bean.
  *
  * @return boolean The PV_CHECKED
  */
  public boolean getPV_CHECKED()
  {
      return this.PV_CHECKED;
  }
  /**
  * The getVP_SUBMIT_ACTION method returns the VP_SUBMIT_ACTION for this bean.
  *
  * @return String The VP_SUBMIT_ACTION
  */
  public String getVP_SUBMIT_ACTION()
  {
      return this.VP_SUBMIT_ACTION;
  }
  /**
  * The getVM_CONCEPT method returns the VM_CONCEPT for this bean.
  *
  * @return EVS_Bean The VM_CONCEPT
  */
  public EVS_Bean getVM_CONCEPT()
  {
      return this.VM_CONCEPT;
  }
  /**
  * The getPARENT_CONCEPT method returns the PARENT_CONCEPT for this bean.
  *
  * @return EVS_Bean The PARENT_CONCEPT
  */
  public EVS_Bean getPARENT_CONCEPT()
  {
      return this.PARENT_CONCEPT;
  }
  /**
  * The getPV_NCI_CC_TYPE method returns the PV_NCI_CC_TYPE for this bean.
  *
  * @return String The PV_NCI_CC_TYPE
  */
  public String getPV_NCI_CC_TYPE()
  {
      return this.PV_NCI_CC_TYPE;
  }
  /**
  * The getPV_NCI_CC_VAL method returns the PV_NCI_CC_VAL for this bean.
  *
  * @return String The PV_NCI_CC_VAL
  */
  public String getPV_NCI_CC_VAL()
  {
      return this.PV_NCI_CC_VAL;
  }
  /**
  * The getPV_UMLS_CUI_VAL method returns the PV_UMLS_CUI_VAL for this bean.
  *
  * @return String The PV_UMLS_CUI_VAL
  */
  public String getPV_UMLS_CUI_VAL()
  {
      return this.PV_UMLS_CUI_VAL;
  }
  /**
  * The getPV_UMLS_CUI_TYPE method returns the PV_UMLS_CUI_TYPE for this bean.
  *
  * @return String The PV_UMLS_CUI_TYPE
  */
  public String getPV_UMLS_CUI_TYPE()
  {
      return this.PV_UMLS_CUI_TYPE;
  }
  /**
  * The getPV_TEMP_CUI_VAL method returns the PV_TEMP_CUI_VAL for this bean.
  *
  * @return String The PV_TEMP_CUI_VAL
  */
  public String getPV_TEMP_CUI_VAL()
  {
      return this.PV_TEMP_CUI_VAL;
  }
  /**
  * The getPV_TEMP_CUI_TYPE method returns the PV_TEMP_CUI_TYPE for this bean.
  *
  * @return String The PV_TEMP_CUI_TYPE
  */
  public String getPV_TEMP_CUI_TYPE()
  {
      return this.PV_TEMP_CUI_TYPE;
  }
 
  /**
  * The getPV_EVS_DATABASE method returns the PV_EVS_DATABASE for this bean.
  *
  * @return String The PV_EVS_DATABASE
  */
  public String getPV_EVS_DATABASE()
  {
      return this.PV_EVS_DATABASE;
  }
  /**
  * The getPV_EVS_SOURCE method returns the PV_EVS_SOURCE for this bean.
  *
  * @return String The PV_EVS_SOURCE
  */
  public String getPV_EVS_SOURCE()
  {
      return this.PV_EVS_SOURCE;
  }
  /**
  * The getPV_VM_CONDR_IDSEQ method returns the PV_VM_CONDR_IDSEQ for this bean.
  *
  * @return String The PV_VM_CONDR_IDSEQ
  */
  public String getPV_VM_CONDR_IDSEQ()
  {
      return this.PV_VM_CONDR_IDSEQ;
  }
  

} //end of class
