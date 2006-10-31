// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/DEF_Bean.java,v 1.13 2006-10-31 06:26:29 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

/**
 * The DEF_Bean encapsulates the DEFINITION information and is stored in the
 * session.
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

public class DEF_Bean extends AC_Bean {

  private static final long serialVersionUID = 1622023626619349808L;
  
// attributes
  private String RETURN_CODE;
  private String DEF_DEF_IDSEQ;
  private String DEF_PREFERRED_NAME;
  private String DEF_LONG_NAME;
  private String DEF_CONTE_IDSEQ;
  private String DEF_CONTEXT_NAME;
  private String DEF_VERSION;
  private String DEF_PREFERRED_DEFINITION;
  private String DEF_ASL_NAME;
  private String DEF_NCI_CC_TYPE;
  private String DEF_CONCEPT_IDENTIFIER;
  private String DEF_UMLS_CUI_TYPE;
  private String DEF_UMLS_CUI_VAL;
  private String DEF_TEMP_CUI_TYPE;
  private String DEF_TEMP_CUI_VAL;
  private String DEF_EVS_SOURCE;
  private String DEF_EVS_DATABASE;
  private String DEF_DEF_ID;

  /**
   * Constructor
  */
  public DEF_Bean() {
  };

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
   * The setDEF_DEF_IDSEQ method sets the DEF_DEF_IDSEQ for this bean.
   *
   * @param s The DEF_DEF_IDSEQ to set
  */
  public void setDEF_DEF_IDSEQ(String s)
  {
      this.DEF_DEF_IDSEQ = s;
  }
  /**
   * The setDEF_PREFERRED_NAME method sets the DEF_PREFERRED_NAME for this bean.
   *
   * @param s The DEF_PREFERRED_NAME to set
  */
  public void setDEF_PREFERRED_NAME(String s)
  {
      this.DEF_PREFERRED_NAME = s;
  }
  /**
   * The setDEF_LONG_NAME method sets the DEF_LONG_NAME for this bean.
   *
   * @param s The DEF_LONG_NAME to set
  */
  public void setDEF_LONG_NAME(String s)
  {
      this.DEF_LONG_NAME = s;
  }
  /**
   * The setDEF_CONTE_IDSEQ method sets the DEF_CONTE_IDSEQ for this bean.
   *
   * @param s The DEF_CONTE_IDSEQ to set
  */
  public void setDEF_CONTE_IDSEQ(String s)
  {
      this.DEF_CONTE_IDSEQ = s;
  }
  /**
   * The setDEF_VERSION method sets the DEF_VERSION for this bean.
   *
   * @param s The DEF_VERSION to set
  */
  public void setDEF_VERSION(String s)
  {
      this.DEF_VERSION = s;
  }
  /**
   * The setDEF_PREFERRED_DEFINITION method sets the DEF_PREFERRED_DEFINITION for this bean.
   *
   * @param s The DEF_PREFERRED_DEFINITION to set
  */
  public void setDEF_PREFERRED_DEFINITION(String s)
  {
      this.DEF_PREFERRED_DEFINITION = s;
  }
  /**
   * The setDEF_ASL_NAME method sets the DEF_ASL_NAME for this bean.
   *
   * @param s The DEF_ASL_NAME to set
  */
  public void setDEF_ASL_NAME(String s)
  {
      this.DEF_ASL_NAME = s;
  }
   /**
   * The setDEF_CONTEXT_NAME method sets the DEF_CONTEXT_NAME for this bean.
   *
   * @param s The DEF_CONTEXT_NAME to set
  */
  public void setDEF_CONTEXT_NAME(String s)
  {
      this.DEF_CONTEXT_NAME = s;
  }
  /**
   * The setNCI_CC_TYPE method sets the NCI_CC_TYPE for this bean.
   *
   * @param s The NCI_CC_TYPE to set
  */
  public void setDEF_NCI_CC_TYPE(String s)
  {
      this.DEF_NCI_CC_TYPE = s;
  }
  /**
   * The setCONCEPT_IDENTIFIER method sets the CONCEPT_IDENTIFIER for this bean.
   *
   * @param s The CONCEPT_IDENTIFIER to set
  */
  public void setDEF_CONCEPT_IDENTIFIER(String s)
  {
      this.DEF_CONCEPT_IDENTIFIER = s;
  }
  /**
   * The setUMLS_CUI_TYPE method sets the UMLS_CUI_TYPE for this bean.
   *
   * @param s The UMLS_CUI_TYPE to set
  */
  public void setDEF_UMLS_CUI_TYPE(String s)
  {
      this.DEF_UMLS_CUI_TYPE = s;
  }
  /**
   * The setUMLS_CUI_VAL method sets the UMLS_CUI_VAL for this bean.
   *
   * @param s The UMLS_CUI_VAL to set
  */
  public void setDEF_UMLS_CUI_VAL(String s)
  {
      this.DEF_UMLS_CUI_VAL = s;
  }
   /**
   * The setTEMP_CUI_TYPE method sets the TEMP_CUI_TYPE for this bean.
   *
   * @param s The TEMP_CUI_TYPE to set
  */
  public void setDEF_TEMP_CUI_TYPE(String s)
  {
      this.DEF_TEMP_CUI_TYPE = s;
  }
  /**
   * The setTEMP_CUI_VAL method sets the TEMP_CUI_VAL for this bean.
   *
   * @param s The TEMP_CUI_VAL to set
  */
  public void setDEF_TEMP_CUI_VAL(String s)
  {
      this.DEF_TEMP_CUI_VAL = s;
  }
   /**
   * The setDEF_EVS_SOURCE method sets the DEF_EVS_SOURCE for this bean.
   *
   * @param s The DEF_EVS_SOURCE to set
  */

  public void setDEF_EVS_SOURCE(String s)
  {
      this.DEF_EVS_SOURCE = s;
  }
   /**
   * The setDEF_EVS_DATABASE method sets the EVS_DATABASE for this bean.
   *
   * @param s The EVS_DATABASE to set
  */
  public void setDEF_EVS_DATABASE(String s)
  {
      this.DEF_EVS_DATABASE = s;
  }
  /**
   * The setDEF_DEF_ID method sets the DEF_DEF_ID for this bean.
   *
   * @param s The DEF_DEF_ID to set
  */
  public void setDEF_DEF_ID(String s)
  {
      this.DEF_DEF_ID = s;
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
  * The getDEF_DEF_IDSEQ method returns the DEF_DEF_IDSEQ for this bean.
  *
  * @return String The DEF_DEF_IDSEQ
  */
  public String getDEF_DEF_IDSEQ()
  {
      return this.DEF_DEF_IDSEQ;
  }
  
  /* (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getIDSEQ()
   */
  public String getIDSEQ()
  {
      return getDEF_DEF_IDSEQ();
  }

  /**
  * The getDEF_PREFERRED_NAME method returns the DEF_PREFERRED_NAME for this bean.
  *
  * @return String The DEF_PREFERRED_NAME
  */
  public String getDEF_PREFERRED_NAME()
  {
      return this.DEF_PREFERRED_NAME;
  }
  /**
  * The getDEF_LONG_NAME method returns the DEF_LONG_NAME for this bean.
  *
  * @return String The DEF_LONG_NAME
  */
  public String getDEF_LONG_NAME()
  {
      return this.DEF_LONG_NAME;
  }
  /**
  * The getDEF_CONTE_IDSEQ method returns the DEF_CONTE_IDSEQ for this bean.
  *
  * @return String The DEF_CONTE_IDSEQ
  */
  public String getDEF_CONTE_IDSEQ()
  {
      return this.DEF_CONTE_IDSEQ;
  }
  /**
  * The getDEF_VERSION method returns the DEF_VERSION for this bean.
  *
  * @return String The DEF_VERSION
  */
  public String getDEF_VERSION()
  {
      return this.DEF_VERSION;
  }
  /**
  * The getDEF_PREFERRED_DEFINITION method returns the DEF_PREFERRED_DEFINITION for this bean.
  *
  * @return String The DEF_PREFERRED_DEFINITION
  */
  public String getDEF_PREFERRED_DEFINITION()
  {
      return this.DEF_PREFERRED_DEFINITION;
  }

  /**
  * The getDEF_ASL_NAME method returns the DEF_ASL_NAME for this bean.
  *
  * @return String The DEF_ASL_NAME
  */
  public String getDEF_ASL_NAME()
  {
      return this.DEF_ASL_NAME;
  }
   /**
  * The getDEF_CONTEXT_NAME method returns the DEF_CONTEXT_NAME for this bean.
  *
  * @return String The DEF_CONTEXT_NAME
  */
  public String getDEF_CONTEXT_NAME()
  {
      return this.DEF_CONTEXT_NAME;
  }
  /**
  * The getDEF_NCI_CC_TYPE method returns the DEF_NCI_CC_TYPE for this bean.
  *
  * @return String The DEF_NCI_CC_TYPE
  */
  public String getDEF_NCI_CC_TYPE()
  {
      return this.DEF_NCI_CC_TYPE;
  }
  /**
  * The getDEF_CONCEPT_IDENTIFIER method returns the DEF_CONCEPT_IDENTIFIER for this bean.
  *
  * @return String The DEF_CONCEPT_IDENTIFIER
  */
  public String getDEF_CONCEPT_IDENTIFIER()
  {
      return this.DEF_CONCEPT_IDENTIFIER;
  }
  /**
  * The getDEF_UMLS_CUI_TYPE method returns the DEF_UMLS_CUI_TYPE for this bean.
  *
  * @return String The DEF_UMLS_CUI_TYPE
  */
  public String getDEF_UMLS_CUI_TYPE()
  {
      return this.DEF_UMLS_CUI_TYPE;
  }
  /**
  * The getDEF_UMLS_CUI_VAL method returns the DEF_UMLS_CUI_VAL for this bean.
  *
  * @return String The DEF_UMLS_CUI_VAL
  */
  public String getDEF_UMLS_CUI_VAL()
  {
      return this.DEF_UMLS_CUI_VAL;
  }
  /**
  * The getDEF_TEMP_CUI_TYPE method returns the DEF_TEMP_CUI_TYPE for this bean.
  *
  * @return String The DEF_TEMP_CUI_TYPE
  */
  public String getDEF_TEMP_CUI_TYPE()
  {
      return this.DEF_TEMP_CUI_TYPE;
  }
  /**
  * The getDEF_TEMP_CUI_VAL method returns the DEF_TEMP_CUI_VAL for this bean.
  *
  * @return String The DEF_TEMP_CUI_VAL
  */
  public String getDEF_TEMP_CUI_VAL()
  {
      return this.DEF_TEMP_CUI_VAL;
  }
  /**
  * The getDEF_EVS_SOURCE method returns the DEF_EVS_SOURCE for this bean.
  *
  * @return String The DEF_EVS_SOURCE
  */
  public String getDEF_EVS_SOURCE()
  {
      return this.DEF_EVS_SOURCE;
  }
   /**
  * The getDEF_EVS_DATABASE method returns the EVS_EVS_DATABASE for this bean.
  *
  * @return String The EVS_EVS_DATABASE
  */
  public String getDEF_EVS_DATABASE()
  {
      return this.DEF_EVS_DATABASE;
  }
  /**
  * The getDEF_DEF_ID method returns the DEF_DEF_ID for this bean.
  *
  * @return String The DEF_DEF_ID
  */
  public String getDEF_DEF_ID()
  {
      return this.DEF_DEF_ID;
  }

}
