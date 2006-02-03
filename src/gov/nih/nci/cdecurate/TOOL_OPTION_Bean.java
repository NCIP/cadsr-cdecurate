// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/TOOL_OPTION_Bean.java,v 1.3 2006-02-03 20:25:19 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

import java.io.*;
import java.util.*;

/**
 * The TOOL_OPTION_Bean encapsulates the TOOL OPTION information and is stored in the
 * session after the user has logged in to database.
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

public class TOOL_OPTION_Bean implements Serializable
{
/**
   * 
   */
  private static final long serialVersionUID = 1L;
  //Attributes
  private String RETURN_CODE;
  private String TOOL_OPTION_IDSEQ;
  private String TOOL_NAME;
  private String PROPERTY;
  private String VALUE;
  private String LANGUAGE;

  /**
  * Constructor
  */
  public TOOL_OPTION_Bean() {
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
  * The setTOOL_NAME method sets the TOOL_NAME for this bean.
  *
  * @param s The TOOL_NAME to set
  */
  public void setTOOL_NAME(String s)
  {
      this.TOOL_NAME = s;
  }
  /**
  * The setTOOL_OPTION_IDSEQ method sets the TOOL_OPTION_IDSEQ for this bean.
  *
  * @param s The TOOL_OPTION_IDSEQ to set
  */
  public void setTOOL_OPTION_IDSEQ(String s)
  {
      this.TOOL_OPTION_IDSEQ = s;
  }
  /**
  * The setPROPERTY method sets the PROPERTY for this bean.
  *
  * @param s The PROPERTY to set
  */
  public void setPROPERTY(String s)
  {
      this.PROPERTY = s;
  }
  /**
  * The setVALUE method sets the VALUE for this bean.
  *
  * @param s The VALUE to set
  */
  public void setVALUE(String s)
  {
      this.VALUE = s;
  }
  /**
  * The setLANGUAGE method sets the LANGUAGE for this bean.
  *
  * @param s The LANGUAGE to set
  */
  public void setLANGUAGE(String s)
  {
      this.LANGUAGE = s;
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
  * The getTOOL_NAME method returns the TOOL_NAME for this bean.
  *
  * @return String The TOOL_NAME
  */
  public String getTOOL_NAME()
  {
      return this.TOOL_NAME;
  }
  /**
  * The getTOOL_OPTION_IDSEQ method returns the TOOL_OPTION_IDSEQ for this bean.
  *
  * @return String The TOOL_OPTION_IDSEQ
  */
  public String getTOOL_OPTION_IDSEQ()
  {
      return this.TOOL_OPTION_IDSEQ;
  }
  /**
  * The getPROPERTY method returns the PROPERTY for this bean.
  *
  * @return String The PROPERTY
  */
  public String getPROPERTY()
  {
      return this.PROPERTY;
  }
  /**
  * The getVALUE method returns the VALUE for this bean.
  *
  * @return String The VALUE
  */
  public String getVALUE()
  {
      return this.VALUE;
  }
  /**
  * The getLANGUAGE method gets the LANGUAGE for this bean.
  *
  * @return String The LANGUAGE
  */
  public String getLANGUAGE()
  {
      return this.LANGUAGE;
  }
  
}  //end class
