// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/CD_Bean.java,v 1.2 2006-01-31 20:16:18 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

/**
 * The CD_Bean encapsulates the CD information
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

public class CD_Bean extends AC_Bean {

  private static final long serialVersionUID = -5257694129718861644L;
  
// attributes
  private String RETURN_CODE;
  private String CD_CD_IDSEQ;
  private String CD_PREFERRED_NAME;
  private String CD_CONTE_IDSEQ;
  private String CD_CONTEXT_NAME;
  private String CD_VERSION;
  private String CD_PREFERRED_DEFINITION;
  private String CD_ASL_NAME;
  private String CD_LATEST_VERSION_IND;
  private String CD_LONG_NAME;
  private String CD_BEGIN_DATE;
  private String CD_END_DATE;
  private String CD_CHANGE_NOTE;
  private String CD_CREATED_BY;
  private String CD_DATE_CREATED;
  private String CD_MODIFIED_BY;
  private String CD_DATE_MODIFIED;
  private String CD_DELETED_IND;
  private String CD_DIMENSIONALITY;
  private String CD_CD_ID;
  private String CD_SOURCE;
  private boolean CD_CHECKED;

  /**
   * Constructor
  */
  public CD_Bean() {
  }

  /**
   * makes a copy of the bean
   *
   * @param copyBean passin the bean whose attributes  need to be copied and returned.
   *
   * @return CD_Bean returns this bean after copying its attributes
   */
  public CD_Bean cloneCD_Bean(CD_Bean copyBean)
  {
			this.setCD_PREFERRED_NAME(copyBean.getCD_PREFERRED_NAME());
			this.setCD_LONG_NAME(copyBean.getCD_LONG_NAME());
			this.setCD_PREFERRED_DEFINITION(copyBean.getCD_PREFERRED_DEFINITION());
			this.setCD_ASL_NAME(copyBean.getCD_ASL_NAME());
			this.setCD_CONTE_IDSEQ(copyBean.getCD_CONTE_IDSEQ());
			this.setCD_BEGIN_DATE(copyBean.getCD_BEGIN_DATE());
			this.setCD_END_DATE(copyBean.getCD_END_DATE());
			this.setCD_VERSION(copyBean.getCD_VERSION());
			this.setCD_CD_IDSEQ(copyBean.getCD_CD_IDSEQ());
			this.setCD_CHANGE_NOTE(copyBean.getCD_CHANGE_NOTE());
			this.setCD_CONTEXT_NAME(copyBean.getCD_CONTEXT_NAME());
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
   * The setCD_CD_IDSEQ method sets the CD_CD_IDSEQ for this bean.
   *
   * @param s The CD_CD_IDSEQ to set
  */
  public void setCD_CD_IDSEQ(String s)
  {
      this.CD_CD_IDSEQ = s;
  }
	/**
   * The setCD_PREFERRED_NAME method sets the CD_PREFERRED_NAME for this bean.
   *
   * @param s The CD_PREFERRED_NAME to set
  */
  public void setCD_PREFERRED_NAME(String s)
  {
      this.CD_PREFERRED_NAME = s;
  }
  /**
   * The setCD_CONTE_IDSEQ method sets the CD_CONTE_IDSEQ for this bean.
   *
   * @param s The CD_CONTE_IDSEQ to set
  */
  public void setCD_CONTE_IDSEQ(String s)
  {
      this.CD_CONTE_IDSEQ = s;
  }
  /**
   * The setCD_VERSION method sets the CD_VERSION for this bean.
   *
   * @param s The CD_VERSION to set
  */
  public void setCD_VERSION(String s)
  {
      this.CD_VERSION = s;
  }
  /**
   * The setCD_PREFERRED_DEFINITION method sets the CD_PREFERRED_DEFINITION for this bean.
   *
   * @param s The CD_PREFERRED_DEFINITION to set
  */
  public void setCD_PREFERRED_DEFINITION(String s)
  {
      this.CD_PREFERRED_DEFINITION = s;
  }
  /**
   * The setCD_LONG_NAME method sets the CD_LONG_NAME for this bean.
   *
   * @param s The CD_LONG_NAME to set
  */
  public void setCD_LONG_NAME(String s)
  {
      this.CD_LONG_NAME = s;
  }
  /**
   * The setCD_ASL_NAME method sets the CD_ASL_NAME for this bean.
   *
   * @param s The CD_ASL_NAME to set
  */
  public void setCD_ASL_NAME(String s)
  {
      this.CD_ASL_NAME = s;
  }
  /**
   * The setCD_LATEST_VERSION_IND method sets the CD_LATEST_VERSION_IND for this bean.
   *
   * @param s The CD_LATEST_VERSION_IND to set
  */
  public void setCD_LATEST_VERSION_IND(String s)
  {
      this.CD_LATEST_VERSION_IND = s;
  }


  /**
   * The setCD_BEGIN_DATE method sets the CD_BEGIN_DATE for this bean.
   *
   * @param s The CD_BEGIN_DATE to set
  */
  public void setCD_BEGIN_DATE(String s)
  {
      this.CD_BEGIN_DATE = s;
  }
  /**
   * The setCD_END_DATE method sets the CD_END_DATE for this bean.
   *
   * @param s The CD_END_DATE to set
  */
  public void setCD_END_DATE(String s)
  {
      this.CD_END_DATE = s;
  }
  /**
   * The setCD_CHANGE_NOTE method sets the CD_CHANGE_NOTE for this bean.
   *
   * @param s The CD_CHANGE_NOTE to set
  */
  public void setCD_CHANGE_NOTE(String s)
  {
      this.CD_CHANGE_NOTE = s;
  }
  /**
   * The setCD_CREATED_BY method sets the CD_CREATED_BY for this bean.
   *
   * @param s The CD_CREATED_BY to set
  */
  public void setCD_CREATED_BY(String s)
  {
      this.CD_CREATED_BY = s;
  }
  /**
   * The setCD_DATE_CREATED method sets the CD_DATE_CREATED for this bean.
   *
   * @param s The CD_DATE_CREATED to set
  */
  public void setCD_DATE_CREATED(String s)
  {
      this.CD_DATE_CREATED = s;
  }
  /**
   * The setCD_MODIFIED_BY method sets the CD_MODIFIED_BY for this bean.
   *
   * @param s The CD_MODIFIED_BY to set
  */
  public void setCD_MODIFIED_BY(String s)
  {
      this.CD_MODIFIED_BY = s;
  }
  /**
   * The setCD_DATE_MODIFIED method sets the CD_DATE_MODIFIED for this bean.
   *
   * @param s The CD_DATE_MODIFIED to set
  */
  public void setCD_DATE_MODIFIED(String s)
  {
      this.CD_DATE_MODIFIED = s;
  }
  /**
   * The setCD_DELETED_IND method sets the CD_DELETED_IND for this bean.
   *
   * @param s The CD_DELETED_IND to set
  */
  public void setCD_DELETED_IND(String s)
  {
      this.CD_DELETED_IND = s;
  }
  /**
   * The setCD_CONTEXT_NAME method sets the CD_CONTEXT_NAME for this bean.
   *
   * @param s The CD_CONTEXT_NAME to set
  */
  public void setCD_CONTEXT_NAME(String s)
  {
      this.CD_CONTEXT_NAME = s;
  }
  /**
   * The setCD_CD_ID method sets the CD_CD_ID for this bean.
   *
   * @param s The CD_CD_ID to set
  */
  public void setCD_CD_ID(String s)
  {
      this.CD_CD_ID = s;
  }
   /**
   * The setCD_SOURCE method sets the CD_SOURCE for this bean.
   *
   * @param s The CD_SOURCE to set
  */
  public void setCD_SOURCE(String s)
  {
      this.CD_SOURCE = s;
  }
   /**
   * The setCD_DIMENSIONALITY method sets the CD_DIMENSIONALITY for this bean.
   *
   * @param s The CD_DIMENSIONALITY to set
  */
  public void setCD_DIMENSIONALITY(String s)
  {
      this.CD_DIMENSIONALITY = s;
  }
   /**
   * The setCD_CHECKED method sets the CD_CHECKED for this bean.
   *
   * @param b The CD_CHECKED to set
  */
  public void setCD_CHECKED(boolean b)
  {
      this.CD_CHECKED = b;
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
  * The getCD_CD_IDSEQ method returns the CD_CD_IDSEQ for this bean.
  *
  * @return String The CD_CD_IDSEQ
  */
  public String getCD_CD_IDSEQ()
  {
      return this.CD_CD_IDSEQ;
  }
  
  /* (non-Javadoc)
   * @see gov.nih.nci.cdecurate.AC_Bean#getIDSEQ()
   */
  public String getIDSEQ()
  {
      return getCD_CD_IDSEQ();
  }

  /**
  * The getCD_PREFERRED_NAME method returns the CD_PREFERRED_NAME for this bean.
  *
  * @return String The CD_PREFERRED_NAME
  */
  public String getCD_PREFERRED_NAME()
  {
      return this.CD_PREFERRED_NAME;
  }
  /**
  * The getCD_CONTE_IDSEQ method returns the CD_CONTE_IDSEQ for this bean.
  *
  * @return String The CD_CONTE_IDSEQ
  */
  public String getCD_CONTE_IDSEQ()
  {
      return this.CD_CONTE_IDSEQ;
  }
  /**
  * The getCD_VERSION method returns the CD_VERSION for this bean.
  *
  * @return String The CD_VERSION
  */
  public String getCD_VERSION()
  {
      return this.CD_VERSION;
  }
  /**
  * The getCD_PREFERRED_DEFINITION method returns the CD_PREFERRED_DEFINITION for this bean.
  *
  * @return String The CD_PREFERRED_DEFINITION
  */
  public String getCD_PREFERRED_DEFINITION()
  {
      return this.CD_PREFERRED_DEFINITION;
  }
  /**
  * The getCD_LONG_NAME method returns the CD_LONG_NAME for this bean.
  *
  * @return String The CD_LONG_NAME
  */
  public String getCD_LONG_NAME()
  {
      return this.CD_LONG_NAME;
  }
  /**
  * The getCD_ASL_NAME method returns the CD_ASL_NAME for this bean.
  *
  * @return String The CD_ASL_NAME
  */
  public String getCD_ASL_NAME()
  {
      return this.CD_ASL_NAME;
  }
  /**
  * The getCD_LATEST_VERSION_IND method returns the CD_LATEST_VERSION_IND for this bean.
  *
  * @return String The CD_LATEST_VERSION_IND
  */
  public String getCD_LATEST_VERSION_IND()
  {
      return this.CD_LATEST_VERSION_IND;
  }
  /**
  * The getCD_BEGIN_DATE method returns the CD_BEGIN_DATE for this bean.
  *
  * @return String The CD_BEGIN_DATE
  */
  public String getCD_BEGIN_DATE()
  {
      return this.CD_BEGIN_DATE;
  }
  /**
  * The getCD_END_DATE method returns the CD_END_DATE for this bean.
  *
  * @return String The CD_END_DATE
  */
  public String getCD_END_DATE()
  {
      return this.CD_END_DATE;
  }
  /**
  * The getCD_CHANGE_NOTE method returns the CD_CHANGE_NOTE for this bean.
  *
  * @return String The CD_CHANGE_NOTE
  */
  public String getCD_CHANGE_NOTE()
  {
      return this.CD_CHANGE_NOTE;
  }
  /**
  * The getCD_CREATED_BY method returns the CD_CREATED_BY for this bean.
  *
  * @return String The CD_CREATED_BY
  */
  public String getCD_CREATED_BY()
  {
      return this.CD_CREATED_BY;
  }
  /**
  * The getCD_DATE_CREATED method returns the CD_DATE_CREATED for this bean.
  *
  * @return String The CD_DATE_CREATED
  */
  public String getCD_DATE_CREATED()
  {
      return this.CD_DATE_CREATED;
  }
  /**
  * The getCD_MODIFIED_BY method returns the CD_MODIFIED_BY for this bean.
  *
  * @return String The CD_MODIFIED_BY
  */
  public String getCD_MODIFIED_BY()
  {
      return this.CD_MODIFIED_BY;
  }
  /**
  * The getCD_DATE_MODIFIED method returns the CD_DATE_MODIFIED for this bean.
  *
  * @return String The CD_DATE_MODIFIED
  */
  public String getCD_DATE_MODIFIED()
  {
      return this.CD_DATE_MODIFIED;
  }
  /**
  * The getCD_DELETED_IND method returns the CD_DELETED_IND for this bean.
  *
  * @return String The CD_DELETED_IND
  */
  public String getCD_DELETED_IND()
  {
      return this.CD_DELETED_IND;
  }
  /**
  * The getCD_CONTEXT_NAME method returns the CD_CONTEXT_NAME for this bean.
  *
  * @return String The CD_CONTEXT_NAME
  */
  public String getCD_CONTEXT_NAME()
  {
      return this.CD_CONTEXT_NAME;
  }
  /**
  * The getCD_CD_ID method returns the CD_CD_ID for this bean.
  *
  * @return String The CD_CD_ID
  */
  public String getCD_CD_ID()
  {
      return this.CD_CD_ID;
  }
   /**
  * The getCD_SOURCE method returns the CD_SOURCE for this bean.
  *
  * @return String The CD_SOURCE
  */
  public String getCD_SOURCE()
  {
      return this.CD_SOURCE;
  }
   /**
  * The getCD_DIMENSIONALITY method returns the CD_DIMENSIONALITY for this bean.
  *
  * @return String The CD_DIMENSIONALITY
  */
  public String getCD_DIMENSIONALITY()
  {
      return this.CD_DIMENSIONALITY;
  }
   /**
  * The getCD_CHECKED method returns the CD_CHECKED for this bean.
  *
  * @return boolean The CD_CHECKED
  */
  public boolean getCD_CHECKED()
  {
      return this.CD_CHECKED;
  }

}
