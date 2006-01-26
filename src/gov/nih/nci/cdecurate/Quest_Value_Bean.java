// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cdecurate/Quest_Value_Bean.java,v 1.1 2006-01-26 15:25:12 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cdecurate;

import java.io.*;
import java.util.*;

/**
 * The Quest_Value_Bean encapsulates the Quest_Value information and is stored in the
 * session after the search.
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

public class Quest_Value_Bean implements Serializable
{
//Attributes
  private String QUESTION_VALUE;
  private String QUESTION_VALUE_IDSEQ;
  private String PERM_VALUE_IDSEQ;
  private String PERMISSIBLE_VALUE;
  private String VALUE_MEANING;
  private String VP_IDSEQ;
  private String QUESTION_NAME;
  private String QUESTION_IDSEQ;

  /**
   * Constructor
  */
  public void Quest_Value_Bean() {
  };
  
  //Set properties
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
  * The setPERM_VALUE_IDSEQ method sets the PERM_VALUE_IDSEQ for this bean.
  *
  * @param s The PERM_VALUE_IDSEQ to set
  */
  public void setPERM_VALUE_IDSEQ(String s)
  {
      this.PERM_VALUE_IDSEQ = s;
  }
  /**
  * The setPERMISSIBLE_VALUE method sets the PERMISSIBLE_VALUE for this bean.
  *
  * @param s The PERMISSIBLE_VALUE to set
  */
  public void setPERMISSIBLE_VALUE(String s)
  {
      this.PERMISSIBLE_VALUE = s;
  }
  /**
  * The setVALUE_MEANING method sets the VALUE_MEANING for this bean.
  *
  * @param s The VALUE_MEANING to set
  */
  public void setVALUE_MEANING(String s)
  {
      this.VALUE_MEANING = s;
  }
  /**
  * The setVP_IDSEQ method sets the VP_IDSEQ for this bean.
  *
  * @param s The VP_IDSEQ to set
  */
  public void setVP_IDSEQ(String s)
  {
      this.VP_IDSEQ = s;
  }
  /**
  * The setQUESTION_NAME method sets the QUESTION_NAME for this bean.
  *
  * @param s The QUESTION_NAME to set
  */
  public void setQUESTION_NAME(String s)
  {
      this.QUESTION_NAME = s;
  }
  /**
  * The setQUESTION_IDSEQ method sets the QUESTION_IDSEQ for this bean.
  *
  * @param s The QUESTION_IDSEQ to set
  */
  public void setQUESTION_IDSEQ(String s)
  {
      this.QUESTION_IDSEQ = s;
  }


  //Get Properties
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
  * The getPERM_VALUE_IDSEQ method returns the PERM_VALUE_IDSEQ for this bean.
  *
  * @return String The PERM_VALUE_IDSEQ
  */
  public String getPERM_VALUE_IDSEQ()
  {
      return this.PERM_VALUE_IDSEQ;
  }
  /**
  * The getPERMISSIBLE_VALUE method returns the PERMISSIBLE_VALUE for this bean.
  *
  * @return String The PERMISSIBLE_VALUE
  */
  public String getPERMISSIBLE_VALUE()
  {
      return this.PERMISSIBLE_VALUE;
  }
  /**
  * The getVALUE_MEANING method returns the VALUE_MEANING for this bean.
  *
  * @return String The VALUE_MEANING
  */
  public String getVALUE_MEANING()
  {
      return this.VALUE_MEANING;
  }
  /**
  * The getVP_IDSEQ method returns the VP_IDSEQ for this bean.
  *
  * @return String The VP_IDSEQ
  */
  public String getVP_IDSEQ()
  {
      return this.VP_IDSEQ;
  }
  /**
  * The getQUESTION_NAME method returns the QUESTION_NAME for this bean.
  *
  * @return String The QUESTION_NAME
  */
  public String getQUESTION_NAME()
  {
      return this.QUESTION_NAME;
  }
  /**
  * The getQUESTION_IDSEQ method returns the QUESTION_IDSEQ for this bean.
  *
  * @return String The QUESTION_IDSEQ
  */
  public String getQUESTION_IDSEQ()
  {
      return this.QUESTION_IDSEQ;
  }
}
 