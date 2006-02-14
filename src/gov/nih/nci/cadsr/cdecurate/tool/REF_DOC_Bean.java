// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/REF_DOC_Bean.java,v 1.2 2006-02-14 21:53:50 hardingr Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.*;
import java.util.*;

/**
 * The REF_DOC_Bean encapsulates the REFERENCE DOCUMENT information and is stored in the
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

public class REF_DOC_Bean implements Serializable
{
/**
   * 
   */
  private static final long serialVersionUID = 1L;
  //Attributes
  private String RETURN_CODE;
  private String REF_DOC_IDSEQ;
  private String CONTE_IDSEQ;
  private String CONTEXT_NAME;
  private String DOCUMENT_NAME;
  private String DOCUMENT_TEXT;
  private String DOCUMENT_URL;
  private String DOC_TYPE_NAME;
  private String AC_IDSEQ;
  private String AC_LONG_NAME;
  private String AC_LANGUAGE;
  private String REF_SUBMIT_ACTION;
  private boolean iswritable;

  /**
  * Constructor
  */
  public REF_DOC_Bean() {
  };

  /**
   * @param fromBean to copy from
   * @return REF_DOC_Bean
   */
  public REF_DOC_Bean copyRefDocs(REF_DOC_Bean fromBean)
  {
    if (fromBean != null)
    {
      this.setAC_IDSEQ(fromBean.getAC_IDSEQ());
      this.setAC_LANGUAGE(fromBean.getAC_LANGUAGE());
      this.setAC_LONG_NAME(fromBean.getAC_LONG_NAME());
      this.setCONTE_IDSEQ(fromBean.getCONTE_IDSEQ());
      this.setCONTEXT_NAME(fromBean.getCONTEXT_NAME());
      this.setDOC_TYPE_NAME(fromBean.getDOC_TYPE_NAME());
      this.setDOCUMENT_NAME(fromBean.getDOCUMENT_NAME());
      this.setDOCUMENT_TEXT(fromBean.getDOCUMENT_TEXT());
      this.setDOCUMENT_URL(fromBean.getDOCUMENT_URL());
      this.setIswritable(fromBean.getIswritable());
      this.setREF_DOC_IDSEQ(fromBean.getCONTE_IDSEQ());
      this.setREF_SUBMIT_ACTION(fromBean.getREF_SUBMIT_ACTION());
    }
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
  * The setCONTE_IDSEQ method sets the CONTE_IDSEQ for this bean.
  *
  * @param s The CONTE_IDSEQ to set
  */
  public void setCONTE_IDSEQ(String s)
  {
      this.CONTE_IDSEQ = s;
  }
  /**
  * The setCONTEXT_NAME method sets the CONTEXT_NAME for this bean.
  *
  * @param s The CONTEXT_NAME to set
  */
  public void setCONTEXT_NAME(String s)
  {
      this.CONTEXT_NAME = s;
  }
  /**
  * The setREF_DOC_IDSEQ method sets the REF_DOC_IDSEQ for this bean.
  *
  * @param s The REF_DOC_IDSEQ to set
  */
  public void setREF_DOC_IDSEQ(String s)
  {
      this.REF_DOC_IDSEQ = s;
  }
  /**
  * The setDOCUMENT_NAME method sets the DOCUMENT_NAME for this bean.
  *
  * @param s The DOCUMENT_NAME to set
  */
  public void setDOCUMENT_NAME(String s)
  {
      this.DOCUMENT_NAME = s;
  }
  /**
  * The setDOCUMENT_TEXT method sets the DOCUMENT_TEXT for this bean.
  *
  * @param s The DOCUMENT_TEXT to set
  */
  public void setDOCUMENT_TEXT(String s)
  {
      this.DOCUMENT_TEXT = s;
  }
  /**
  * The setDOCUMENT_URL method sets the DOCUMENT_URL for this bean.
  *
  * @param s The DOCUMENT_URL to set
  */
  public void setDOCUMENT_URL(String s)
  {
      this.DOCUMENT_URL = s;
  }
  /**
  * The setDOC_TYPE_NAME method sets the DOC_TYPE_NAME for this bean.
  *
  * @param s The DOC_TYPE_NAME to set
  */
  public void setDOC_TYPE_NAME(String s)
  {
      this.DOC_TYPE_NAME = s;
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
  * The setAC_LONG_NAME method sets the AC_LONG_NAME for this bean.
  *
  * @param s The AC_LONG_NAME to set
  */
  public void setAC_LONG_NAME(String s)
  {
      this.AC_LONG_NAME = s;
  }
  /**
  * The setAC_LANGUAGE method sets the AC_LANGUAGE for this bean.
  *
  * @param s The AC_LANGUAGE to set
  */
  public void setAC_LANGUAGE(String s)
  {
      this.AC_LANGUAGE = s;
  }
  /**
  * The setREF_SUBMIT_ACTION method sets the REF_SUBMIT_ACTION for this bean.
  *
  * @param s The REF_SUBMIT_ACTION to set
  */
  public void setREF_SUBMIT_ACTION(String s)
  {
      this.REF_SUBMIT_ACTION = s;
  }
  /**
   * Stores the writable state of the RD for this bean
   * @param iswritable
   */
  public void setIswritable(Boolean iswritable) {
    this.iswritable = iswritable;
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
  * The getCONTE_IDSEQ method returns the CONTE_IDSEQ for this bean.
  *
  * @return String The CONTE_IDSEQ
  */
  public String getCONTE_IDSEQ()
  {
      return this.CONTE_IDSEQ;
  }
  /**
  * The getCONTEXT_NAME method returns the CONTEXT_NAME for this bean.
  *
  * @return String The CONTEXT_NAME
  */
  public String getCONTEXT_NAME()
  {
      return this.CONTEXT_NAME;
  }
  /**
  * The getREF_DOC_IDSEQ method returns the REF_DOC_IDSEQ for this bean.
  *
  * @return String The REF_DOC_IDSEQ
  */
  public String getREF_DOC_IDSEQ()
  {
      return this.REF_DOC_IDSEQ;
  }
  /**
  * The getDOCUMENT_NAME method returns the DOCUMENT_NAME for this bean.
  *
  * @return String The DOCUMENT_NAME
  */
  public String getDOCUMENT_NAME()
  {
      return this.DOCUMENT_NAME;
  }
  /**
  * The getDOCUMENT_TEXT method returns the DOCUMENT_TEXT for this bean.
  *
  * @return String The DOCUMENT_TEXT
  */
  public String getDOCUMENT_TEXT()
  {
      return this.DOCUMENT_TEXT;
  }
  /**
  * The getDOCUMENT_URL method returns the DOCUMENT_URL for this bean.
  *
  * @return String The DOCUMENT_URL
  */
  public String getDOCUMENT_URL()
  {
      return this.DOCUMENT_URL;
  }
  /**
  * The getDOC_TYPE_NAME method returns the DOC_TYPE_NAME for this bean.
  *
  * @return String The DOC_TYPE_NAME
  */
  public String getDOC_TYPE_NAME()
  {
      return this.DOC_TYPE_NAME;
  }
  /**
  * The getAC_IDSEQ method gets the AC_IDSEQ for this bean.
  *
  * @return String The AC_IDSEQ
  */
  public String getAC_IDSEQ()
  {
      return this.AC_IDSEQ;
  }
  /**
  * The getAC_LONG_NAME method gets the AC_LONG_NAME for this bean.
  *
  * @return String The AC_LONG_NAME
  */
  public String getAC_LONG_NAME()
  {
      return this.AC_LONG_NAME;
  }
  /**
  * The getAC_LANGUAGE method gets the AC_LANGUAGE for this bean.
  *
  * @return String The AC_LANGUAGE
  */
  public String getAC_LANGUAGE()
  {
      return this.AC_LANGUAGE;
  }
  /**
  * The getREF_SUBMIT_ACTION method gets the REF_SUBMIT_ACTION for this bean.
  *
  * @return String The REF_SUBMIT_ACTION
  */
  public String getREF_SUBMIT_ACTION()
  {
      return this.REF_SUBMIT_ACTION;
  }
	/**
	 * Stores the writable state of the RD for this bean
	 * @return boolean whether writable or not
	 */
	public boolean getIswritable() {
		return iswritable;
	}

  
}  //end class
