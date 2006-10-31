// Copyright (c) 2005 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/AC_CSI_Bean.java,v 1.14 2006-10-31 06:54:53 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.*;

/**
 * The AC_CSI_Bean encapsulates the AC_CSI information and is stored in the
 * session after the user has created a new Value Meaning.
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

public class AC_CSI_Bean extends AC_Bean
{
  private static final long serialVersionUID = -5004129867157197225L;
  
//Attributes
  private String RETURN_CODE;
  private String AC_CSI_IDSEQ;
  private String CSCSI_IDSEQ;
  private String AC_IDSEQ;
  private String AC_PREFERRED_NAME;
  private String AC_LONG_NAME;
  private String AC_TYPE_NAME;
  private String CS_IDSEQ;
  private String CS_LONG_NAME;
  private String CSI_IDSEQ;
  private String CSI_NAME;
  private String CSI_LEVEL;
  private String CSI_LABEL;
  private String P_CSCSI_IDSEQ;
  private CSI_Bean CSI_BEAN;

  /**
  * Constructor
  */
  public AC_CSI_Bean() {
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
  * The setCSCSI_IDSEQ method sets the CSCSI_IDSEQ for this bean.
  *
  * @param s The CSCSI_IDSEQ to set
  */
  public void setCSCSI_IDSEQ(String s)
  {
      this.CSCSI_IDSEQ = s;
  }
  /**
  * The setAC_IDSEQ method sets the AC_IDSEQ for this bean.
  *
  * @param s The AC_IDSEQ to set
  */
  public void setAC_IDSEQ(String s)
  {
      this.AC_IDSEQ = s;
  }
  /**
  * The setAC_PREFERRED_NAME method sets the AC_PREFERRED_NAME for this bean.
  *
  * @param s The AC_PREFERRED_NAME to set
  */
  public void setAC_PREFERRED_NAME(String s)
  {
      this.AC_PREFERRED_NAME = s;
  }
  /**
  * The setAC_CSI_IDSEQ method sets the AC_CSI_IDSEQ for this bean.
  *
  * @param s The AC_CSI_IDSEQ to set
  */
  public void setAC_CSI_IDSEQ(String s)
  {
      this.AC_CSI_IDSEQ = s;
  }
  /**
  * The setAC_LONG_NAME method sets the AC_LONG_NAME for this bean.
  *
  * @param s The AC_LONG_NAME to set
  */
  public void setAC_LONG_NAME(String s)
  {
      this.AC_LONG_NAME = s;
  }
  /**
  * The setAC_TYPE_NAME method sets the AC_TYPE_NAME for this bean.
  *
  * @param s The AC_TYPE_NAME to set
  */
  public void setAC_TYPE_NAME(String s)
  {
      this.AC_TYPE_NAME = s;
  }
  /**
  * The setCS_IDSEQ method sets the CS_IDSEQ for this bean.
  *
  * @param s The CS_IDSEQ to set
  */
  public void setCS_IDSEQ(String s)
  {
      this.CS_IDSEQ = s;
  }
  /**
  * The setCS_LONG_NAME method sets the CS_LONG_NAME for this bean.
  *
  * @param s The CS_LONG_NAME to set
  */
  public void setCS_LONG_NAME(String s)
  {
      this.CS_LONG_NAME = s;
  }
  /**
  * The setCSI_IDSEQ method sets the CSI_IDSEQ for this bean.
  *
  * @param s The CSI_IDSEQ to set
  */
  public void setCSI_IDSEQ(String s)
  {
      this.CSI_IDSEQ = s;
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
  * The setCSI_LEVEL method sets the CSI_LEVEL for this bean.
  *
  * @param s The CSI_LEVEL to set
  */
  public void setCSI_LEVEL(String s)
  {
      this.CSI_LEVEL = s;
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
  * The setP_CSCSI_IDSEQ  method sets the P_CSCSI_IDSEQ  for this bean.
  *
  * @param s The P_CSCSI_IDSEQ  to set
  */
  public void setP_CSCSI_IDSEQ (String s)
  {
      this.P_CSCSI_IDSEQ  = s;
  }
  /**
  * The setCSI_BEAN  method sets the CSI_BEAN  for this bean.
  *
  * @param csiBean The CSI_Bean  to set
  */
  public void setCSI_BEAN (CSI_Bean csiBean)
  {
      this.CSI_BEAN  = csiBean;
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
  * The getCSCSI_IDSEQ method returns the CSCSI_IDSEQ for this bean.
  *
  * @return String The CSCSI_IDSEQ
  */
  public String getCSCSI_IDSEQ()
  {
      return this.CSCSI_IDSEQ;
  }
  /**
  * The getAC_IDSEQ method returns the AC_IDSEQ for this bean.
  *
  * @return String The AC_IDSEQ
  */
  public String getAC_IDSEQ()
  {
      return this.AC_IDSEQ;
  }
  /**
  * The getAC_PREFERRED_NAME method returns the AC_PREFERRED_NAME for this bean.
  *
  * @return String The AC_PREFERRED_NAME
  */
  public String getAC_PREFERRED_NAME()
  {
      return this.AC_PREFERRED_NAME;
  }
  /**
  * The getAC_CSI_IDSEQ method returns the AC_CSI_IDSEQ for this bean.
  *
  * @return String The AC_CSI_IDSEQ
  */
  public String getAC_CSI_IDSEQ()
  {
      return this.AC_CSI_IDSEQ;
  }
  
  /* (non-Javadoc)
   * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getIDSEQ()
   */
  public String getIDSEQ()
  {
      return getAC_CSI_IDSEQ();
  }
  
  /**
  * The getAC_LONG_NAME method returns the AC_LONG_NAME for this bean.
  *
  * @return String The AC_LONG_NAME
  */
  public String getAC_LONG_NAME()
  {
      return this.AC_LONG_NAME;
  }
  /**
  * The getAC_TYPE_NAME method returns the AC_TYPE_NAME for this bean.
  *
  * @return String The AC_TYPE_NAME
  */
  public String getAC_TYPE_NAME()
  {
      return this.AC_TYPE_NAME;
  }
  /**
  * The getCS_IDSEQ method gets the CS_IDSEQ for this bean.
  *
  * @return String The CS_IDSEQ
  */
  public String getCS_IDSEQ()
  {
      return this.CS_IDSEQ;
  }
  /**
  * The getCS_LONG_NAME method gets the CS_LONG_NAME for this bean.
  *
  * @return String The CS_LONG_NAME
  */
  public String getCS_LONG_NAME()
  {
      return this.CS_LONG_NAME;
  }
  /**
  * The getCSI_IDSEQ method gets the CSI_IDSEQ for this bean.
  *
  * @return String The CSI_IDSEQ
  */
  public String getCSI_IDSEQ()
  {
      return this.CSI_IDSEQ;
  }
  /**
  * The getCSI_NAME method sets the CSI_NAME for this bean.
  *
  * @return String The CSI_NAME
  */
  public String getCSI_NAME()
  {
      return this.CSI_NAME;
  }
  /**
  * The getCSI_LEVEL method sets the CSI_LEVEL for this bean.
  *
  * @return String The CSI_LEVEL
  */
  public String getCSI_LEVEL()
  {
      return this.CSI_LEVEL;
  }
  /**
  * The getCSI_LABEL method sets the CSI_LABEL for this bean.
  *
  * @return String The CSI_LABEL
  */
  public String getCSI_LABEL()
  {
      return this.CSI_LABEL;
  }
  /**
  * The getP_CSCSI_IDSEQ  method returns the P_CSCSI_IDSEQ  for this bean.
  *
  * @return String The P_CSCSI_IDSEQ 
  */
  public String getP_CSCSI_IDSEQ()
  {
      return this.P_CSCSI_IDSEQ ;
  }
  /**
  * The getCSI_BEAN  method returns the CSI_BEAN  for this bean.
  *
  * @return CSI_Bean The CSI_BEAN 
  */
  public CSI_Bean getCSI_BEAN()
  {
      return this.CSI_BEAN;
  }

}//end of class
