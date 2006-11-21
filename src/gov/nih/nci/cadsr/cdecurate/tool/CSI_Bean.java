// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/CSI_Bean.java,v 1.29 2006-11-21 05:52:22 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

/**
 * The CSI_Bean encapsulates the CSI (Class Scheme Items) information
 * <P>
 * @author Sumana Hegde
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

public class CSI_Bean extends AC_Bean {

  private static final long serialVersionUID = -3242503965389977233L;
  
// attributes
  private String RETURN_CODE;
  private String CSI_CSCSI_IDSEQ;
  private String CSI_CSI_IDSEQ;
  private String CSI_NAME;
  private String CSI_CONTE_IDSEQ;
  private String CSI_CONTEXT_NAME;
  private String CSI_DEFINITION;
  private String CSI_ASL_NAME;
  private String CSI_LATEST_VERSION_IND;
  private String CSI_BEGIN_DATE;
  private String CSI_END_DATE;
  private String CSI_CHANGE_NOTE;
  private String CSI_CREATED_BY;
  private String CSI_DATE_CREATED;
  private String CSI_MODIFIED_BY;
  private String CSI_DATE_MODIFIED;
  private String CSI_DELETED_IND;
  private String CSI_DIMENSIONALITY;
  private String CSI_CS_IDSEQ;
  private String CSI_CS_NAME;
  private String CSI_CS_LONG_NAME;
  private String CSI_CSITL_NAME;
  private boolean CSI_CHECKED;
  private String P_CSCSI_IDSEQ;
  private String CSI_DISPLAY_ORDER;
  private String CSI_LABEL;
  private String CSI_LEVEL;

  /**
   * Constructor
  */
  public CSI_Bean() {
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
   * The setCSI_CSCSI_IDSEQ method sets the CSI_CSCSI_IDSEQ for this bean.
   *
   * @param s The CSI_CSCSI_IDSEQ to set
  */
  public void setCSI_CSCSI_IDSEQ(String s)
  {
      this.CSI_CSCSI_IDSEQ = s;
  }
  /**
   * The setCSI_CSI_IDSEQ method sets the CSI_CSI_IDSEQ for this bean.
   *
   * @param s The CSI_CSI_IDSEQ to set
  */
  public void setCSI_CSI_IDSEQ(String s)
  {
      this.CSI_CSI_IDSEQ = s;
  }
	/**
   * The setCSI_NAME method sets the CSI_NAME for this bean.
   *
   * @param s The CSI_NAME to set
  */
  public void setCSI_NAME(String s)
  {
      this.CSI_NAME = s;
  }
  /**
   * The setCSI_CONTE_IDSEQ method sets the CSI_CONTE_IDSEQ for this bean.
   *
   * @param s The CSI_CONTE_IDSEQ to set
  */
  public void setCSI_CONTE_IDSEQ(String s)
  {
      this.CSI_CONTE_IDSEQ = s;
  }
  /**
   * The setCSI_DEFINITION method sets the CSI_DEFINITION for this bean.
   *
   * @param s The CSI_DEFINITION to set
  */
  public void setCSI_DEFINITION(String s)
  {
      this.CSI_DEFINITION = s;
  }
  /**
   * The setCSI_CS_NAME method sets the CSI_CS_NAME for this bean.
   *
   * @param s The CSI_CS_NAME to set
  */
  public void setCSI_CS_NAME(String s)
  {
      this.CSI_CS_NAME = s;
  }
  /**
   * The setCSI_CS_LONG_NAME method sets the CSI_CS_LONG_NAME for this bean.
   *
   * @param s The CSI_CS_LONG_NAME to set
  */
  public void setCSI_CS_LONG_NAME(String s)
  {
      this.CSI_CS_LONG_NAME = s;
  }
  /**
   * The setCSI_ASL_NAME method sets the CSI_ASL_NAME for this bean.
   *
   * @param s The CSI_ASL_NAME to set
  */
  public void setCSI_ASL_NAME(String s)
  {
      this.CSI_ASL_NAME = s;
  }
  /**
   * The setCSI_LATEST_VERSION_IND method sets the CSI_LATEST_VERSION_IND for this bean.
   *
   * @param s The CSI_LATEST_VERSION_IND to set
  */
  public void setCSI_LATEST_VERSION_IND(String s)
  {
      this.CSI_LATEST_VERSION_IND = s;
  }
  /**
   * The setCSI_BEGIN_DATE method sets the CSI_BEGIN_DATE for this bean.
   *
   * @param s The CSI_BEGIN_DATE to set
  */
  public void setCSI_BEGIN_DATE(String s)
  {
      this.CSI_BEGIN_DATE = s;
  }
  /**
   * The setCSI_END_DATE method sets the CSI_END_DATE for this bean.
   *
   * @param s The CSI_END_DATE to set
  */
  public void setCSI_END_DATE(String s)
  {
      this.CSI_END_DATE = s;
  }
  /**
   * The setCSI_CHANGE_NOTE method sets the CSI_CHANGE_NOTE for this bean.
   *
   * @param s The CSI_CHANGE_NOTE to set
  */
  public void setCSI_CHANGE_NOTE(String s)
  {
      this.CSI_CHANGE_NOTE = s;
  }
  /**
   * The setCSI_CREATED_BY method sets the CSI_CREATED_BY for this bean.
   *
   * @param s The CSI_CREATED_BY to set
  */
  public void setCSI_CREATED_BY(String s)
  {
      this.CSI_CREATED_BY = s;
  }
  /**
   * The setCSI_DATE_CREATED method sets the CSI_DATE_CREATED for this bean.
   *
   * @param s The CSI_DATE_CREATED to set
  */
  public void setCSI_DATE_CREATED(String s)
  {
      this.CSI_DATE_CREATED = s;
  }
  /**
   * The setCSI_MODIFIED_BY method sets the CSI_MODIFIED_BY for this bean.
   *
   * @param s The CSI_MODIFIED_BY to set
  */
  public void setCSI_MODIFIED_BY(String s)
  {
      this.CSI_MODIFIED_BY = s;
  }
  /**
   * The setCSI_DATE_MODIFIED method sets the CSI_DATE_MODIFIED for this bean.
   *
   * @param s The CSI_DATE_MODIFIED to set
  */
  public void setCSI_DATE_MODIFIED(String s)
  {
      this.CSI_DATE_MODIFIED = s;
  }
  /**
   * The setCSI_DELETED_IND method sets the CSI_DELETED_IND for this bean.
   *
   * @param s The CSI_DELETED_IND to set
  */
  public void setCSI_DELETED_IND(String s)
  {
      this.CSI_DELETED_IND = s;
  }
  /**
   * The setCSI_CONTEXT_NAME method sets the CSI_CONTEXT_NAME for this bean.
   *
   * @param s The CSI_CONTEXT_NAME to set
  */
  public void setCSI_CONTEXT_NAME(String s)
  {
      this.CSI_CONTEXT_NAME = s;
  }
  /**
   * The setCSI_CS_IDSEQ method sets the CSI_CS_IDSEQ for this bean.
   *
   * @param s The CSI_CS_IDSEQ to set
  */
  public void setCSI_CS_IDSEQ(String s)
  {
      this.CSI_CS_IDSEQ = s;
  }
   /**
   * The setCSI_CSITL_NAME method sets the CSI_CSITL_NAME for this bean.
   *
   * @param s The CSI_CSITL_NAME to set
  */
  public void setCSI_CSITL_NAME(String s)
  {
      this.CSI_CSITL_NAME = s;
  }
   /**
   * The setCSI_DIMENSIONALITY method sets the CSI_DIMENSIONALITY for this bean.
   *
   * @param s The CSI_DIMENSIONALITY to set
  */
  public void setCSI_DIMENSIONALITY(String s)
  {
      this.CSI_DIMENSIONALITY = s;
  }
   /**
   * The setCSI_CHECKED method sets the CSI_CHECKED for this bean.
   *
   * @param b The CSI_CHECKED to set
  */
  public void setCSI_CHECKED(boolean b)
  {
      this.CSI_CHECKED = b;
  }
   /**
   * The setP_CSCSI_IDSEQ method sets the P_CSCSI_IDSEQ for this bean.
   *
   * @param s The P_CSCSI_IDSEQ to set
  */
  public void setP_CSCSI_IDSEQ(String s)
  {
      this.P_CSCSI_IDSEQ = s;
  }
	/**
   * The setCSI_DISPLAY_ORDER method sets the CSI_DISPLAY_ORDER for this bean.
   *
   * @param s The CSI_DISPLAY_ORDER to set
  */
  public void setCSI_DISPLAY_ORDER(String s)
  {
      this.CSI_DISPLAY_ORDER = s;
  }
	/**
   * The setCSI_LABEL method sets the CSI_LABEL for this bean.
   *
   * @param s The CSI_LABEL to set
  */
  public void setCSI_LABEL(String s)
  {
      this.CSI_LABEL = s;
  }
	/**
   * The setCSI_LEVEL method sets the CSI_LEVEL for this bean.
   *
   * @param s The CSI_LEVEL to set
  */
  public void setCSI_LEVEL(String s)
  {
      this.CSI_LEVEL = s;
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
  * The getCSI_CSCSI_IDSEQ method returns the CSI_CSCSI_IDSEQ for this bean.
  *
  * @return String The CSI_CSCSI_IDSEQ
  */
  public String getCSI_CSCSI_IDSEQ()
  {
      return this.CSI_CSCSI_IDSEQ;
  }
  /**
  * The getCSI_CSI_IDSEQ method returns the CSI_CSI_IDSEQ for this bean.
  *
  * @return String The CSI_CSI_IDSEQ
  */
  public String getCSI_CSI_IDSEQ()
  {
      return this.CSI_CSI_IDSEQ;
  }
  
  /* (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getIDSEQ()
   */
  public String getIDSEQ()
  {
      return getCSI_CSI_IDSEQ();
  }

  /**
  * The getCSI_NAME method returns the CSI_NAME for this bean.
  *
  * @return String The CSI_NAME
  */
  public String getCSI_NAME()
  {
      return this.CSI_NAME;
  }
  /**
  * The getCSI_CONTE_IDSEQ method returns the CSI_CONTE_IDSEQ for this bean.
  *
  * @return String The CSI_CONTE_IDSEQ
  */
  public String getCSI_CONTE_IDSEQ()
  {
      return this.CSI_CONTE_IDSEQ;
  }
  
  @Override
  public String getContextIDSEQ()
  {
      return getCSI_CONTE_IDSEQ();
  }

  /**
  * The getCSI_DEFINITION method returns the CSI_DEFINITION for this bean.
  *
  * @return String The CSI_DEFINITION
  */
  public String getCSI_DEFINITION()
  {
      return this.CSI_DEFINITION;
  }
  /**
  * The getCSI_CS_NAME method returns the CSI_CS_NAME for this bean.
  *
  * @return String The CSI_CS_NAME
  */
  public String getCSI_CS_NAME()
  {
      return this.CSI_CS_NAME;
  }
  /**
  * The getCSI_CS_LONG_NAME method returns the CSI_CS_LONG_NAME for this bean.
  *
  * @return String The CSI_CS_LONG_NAME
  */
  public String getCSI_CS_LONG_NAME()
  {
      return this.CSI_CS_LONG_NAME;
  }
  /**
  * The getCSI_ASL_NAME method returns the CSI_ASL_NAME for this bean.
  *
  * @return String The CSI_ASL_NAME
  */
  public String getCSI_ASL_NAME()
  {
      return this.CSI_ASL_NAME;
  }
  /**
  * The getCSI_LATEST_VERSION_IND method returns the CSI_LATEST_VERSION_IND for this bean.
  *
  * @return String The CSI_LATEST_VERSION_IND
  */
  public String getCSI_LATEST_VERSION_IND()
  {
      return this.CSI_LATEST_VERSION_IND;
  }
  /**
  * The getCSI_BEGIN_DATE method returns the CSI_BEGIN_DATE for this bean.
  *
  * @return String The CSI_BEGIN_DATE
  */
  public String getCSI_BEGIN_DATE()
  {
      return this.CSI_BEGIN_DATE;
  }
  /**
  * The getCSI_END_DATE method returns the CSI_END_DATE for this bean.
  *
  * @return String The CSI_END_DATE
  */
  public String getCSI_END_DATE()
  {
      return this.CSI_END_DATE;
  }
  /**
  * The getCSI_CHANGE_NOTE method returns the CSI_CHANGE_NOTE for this bean.
  *
  * @return String The CSI_CHANGE_NOTE
  */
  public String getCSI_CHANGE_NOTE()
  {
      return this.CSI_CHANGE_NOTE;
  }
  /**
  * The getCSI_CREATED_BY method returns the CSI_CREATED_BY for this bean.
  *
  * @return String The CSI_CREATED_BY
  */
  public String getCSI_CREATED_BY()
  {
      return this.CSI_CREATED_BY;
  }
  /**
  * The getCSI_DATE_CREATED method returns the CSI_DATE_CREATED for this bean.
  *
  * @return String The CSI_DATE_CREATED
  */
  public String getCSI_DATE_CREATED()
  {
      return this.CSI_DATE_CREATED;
  }
  /**
  * The getCSI_MODIFIED_BY method returns the CSI_MODIFIED_BY for this bean.
  *
  * @return String The CSI_MODIFIED_BY
  */
  public String getCSI_MODIFIED_BY()
  {
      return this.CSI_MODIFIED_BY;
  }
  /**
  * The getCSI_DATE_MODIFIED method returns the CSI_DATE_MODIFIED for this bean.
  *
  * @return String The CSI_DATE_MODIFIED
  */
  public String getCSI_DATE_MODIFIED()
  {
      return this.CSI_DATE_MODIFIED;
  }
  /**
  * The getCSI_DELETED_IND method returns the CSI_DELETED_IND for this bean.
  *
  * @return String The CSI_DELETED_IND
  */
  public String getCSI_DELETED_IND()
  {
      return this.CSI_DELETED_IND;
  }
  /**
  * The getCSI_CONTEXT_NAME method returns the CSI_CONTEXT_NAME for this bean.
  *
  * @return String The CSI_CONTEXT_NAME
  */
  public String getCSI_CONTEXT_NAME()
  {
      return this.CSI_CONTEXT_NAME;
  }
  
  @Override
  public String getContextName()
  {
      return getCSI_CONTEXT_NAME();
  }

  /**
  * The getCSI_CS_IDSEQ method returns the CSI_CS_IDSEQ for this bean.
  *
  * @return String The CSI_CS_IDSEQ
  */
  public String getCSI_CS_IDSEQ()
  {
      return this.CSI_CS_IDSEQ;
  }
   /**
  * The getCSI_CSITL_NAME method returns the CSI_CSITL_NAME for this bean.
  *
  * @return String The CSI_CSITL_NAME
  */
  public String getCSI_CSITL_NAME()
  {
      return this.CSI_CSITL_NAME;
  }
   /**
  * The getCSI_DIMENSIONALITY method returns the CSI_DIMENSIONALITY for this bean.
  *
  * @return String The CSI_DIMENSIONALITY
  */
  public String getCSI_DIMENSIONALITY()
  {
      return this.CSI_DIMENSIONALITY;
  }
   /**
  * The getCSI_CHECKED method returns the CSI_CHECKED for this bean.
  *
  * @return boolean The CSI_CHECKED
  */
  public boolean getCSI_CHECKED()
  {
      return this.CSI_CHECKED;
  }
  /**
  * The getP_CSCSI_IDSEQ method returns the P_CSCSI_IDSEQ for this bean.
  *
  * @return String The P_CSCSI_IDSEQ
  */
  public String getP_CSCSI_IDSEQ()
  {
      return this.P_CSCSI_IDSEQ;
  }
  /**
  * The getCSI_DISPLAY_ORDER method returns the CSI_DISPLAY_ORDER for this bean.
  *
  * @return String The CSI_DISPLAY_ORDER
  */
  public String getCSI_DISPLAY_ORDER()
  {
      return this.CSI_DISPLAY_ORDER;
  }
  /**
  * The getCSI_LABEL method returns the CSI_LABEL for this bean.
  *
  * @return String The CSI_LABEL
  */
  public String getCSI_LABEL()
  {
      return this.CSI_LABEL;
  }
  /**
  * The getCSI_LEVEL method returns the CSI_LEVEL for this bean.
  *
  * @return String The CSI_LEVEL
  */
  public String getCSI_LEVEL()
  {
      return this.CSI_LEVEL;
  }

}
