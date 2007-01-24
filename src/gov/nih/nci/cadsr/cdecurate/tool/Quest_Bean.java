// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/Quest_Bean.java,v 1.34 2007-01-24 06:12:12 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.*;

/**
 * The Quest_Bean encapsulates the Quest information and is stored in the
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

public class Quest_Bean implements Serializable
{
/**
   * 
   */
  private static final long serialVersionUID = 1L;
  //Attributes
  private String PROTO_IDSEQ;
  private String PROTOCOL_ID;
  private String PROTOCOL_NAME;
  private String CRF_IDSEQ;
  private String CRF_NAME;
  private String QC_IDSEQ;
  private String QUEST_NAME;
  private String QUEST_DEFINITION;
  private String SUBMITTED_LONG_NAME;
  private String CONTE_IDSEQ;
  private String CONTEXT_NAME;
  private String ASL_NAME;
  private String DE_IDSEQ;
  private String DE_LONG_NAME;
  private String DE_VD_IDSEQ;
  private String VD_IDSEQ;
  private String VD_LONG_NAME;
  private String VD_PREF_NAME;
  private String VD_DEFINITION;
  private String VDid;
  private String VDversion;
  private String CDE_ID;
  private String HIGH_LIGHT_INDICATOR;
  private String STATUS_INDICATOR;
  private String QUEST_ORIGIN;
  private String QC_ID;
  private boolean QUEST_CHECKED;
  /**
   * Constructor
  */
  public Quest_Bean(){
  };
  
  //Set properties
  /**
  * The setPROTO_IDSEQ method sets the PROTO_IDSEQ for this bean.
  *
  * @param s The PROTO_IDSEQ to set
  */
  public void setPROTO_IDSEQ(String s)
  {
      this.PROTO_IDSEQ = s;
  }
  /**
  * The setPROTOCOL_ID method sets the PROTOCOL_ID for this bean.
  *
  * @param s The PROTOCOL_ID to set
  */
  public void setPROTOCOL_ID(String s)
  {
      this.PROTOCOL_ID = s;
  }
  /**
  * The setPROTOCOL_NAME method sets the PROTOCOL_NAME for this bean.
  *
  * @param s The PROTOCOL_NAME to set
  */
  public void setPROTOCOL_NAME(String s)
  {
      this.PROTOCOL_NAME = s;
  }
  /**
  * The setCRF_IDSEQ method sets the CRF_IDSEQ for this bean.
  *
  * @param s The CRF_IDSEQ to set
  */
  public void setCRF_IDSEQ(String s)
  {
      this.CRF_IDSEQ = s;
  }
  /**
  * The setCRF_NAME method sets the CRF_NAME for this bean.
  *
  * @param s The CRF_NAME to set
  */
  public void setCRF_NAME(String s)
  {
      this.CRF_NAME = s;
  }
  /**
  * The setQC_IDSEQ method sets the QC_IDSEQ for this bean.
  *
  * @param s The QC_IDSEQ to set
  */
  public void setQC_IDSEQ(String s)
  {
      this.QC_IDSEQ = s;
  }
  /**
  * The setQUEST_NAME method sets the QUEST_NAME for this bean.
  *
  * @param s The QUEST_NAME to set
  */
  public void setQUEST_NAME(String s)
  {
      this.QUEST_NAME = s;
  }
  /**
  * The setQUEST_DEFINITION method sets the QUEST_DEFINITION for this bean.
  *
  * @param s The QUEST_DEFINITION to set
  */
  public void setQUEST_DEFINITION(String s)
  {
      this.QUEST_DEFINITION = s;
  }
  /**
  * The setSUBMITTED_LONG_NAME method sets the SUBMITTED_LONG_NAME for this bean.
  *
  * @param s The SUBMITTED_LONG_NAME to set
  */
  public void setSUBMITTED_LONG_NAME(String s)
  {
      this.SUBMITTED_LONG_NAME = s;
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
  * The setASL_NAME method sets the ASL_NAME for this bean.
  *
  * @param s The ASL_NAME to set
  */
  public void setASL_NAME(String s)
  {
      this.ASL_NAME = s;
  }
  /**
  * The setDE_IDSEQ method sets the DE_IDSEQ for this bean.
  *
  * @param s The DE_IDSEQ to set
  */
  public void setDE_IDSEQ(String s)
  {
      this.DE_IDSEQ = s;
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
  * The setDE_VD_IDSEQ method sets the DE_VD_IDSEQ for this bean.
  *
  * @param s The DE_VD_IDSEQ to set
  */
  public void setDE_VD_IDSEQ(String s)
  {
      this.DE_VD_IDSEQ = s;
  }
  /**
  * The setVD_IDSEQ method sets the VD_IDSEQ for this bean.
  *
  * @param s The VD_IDSEQ to set
  */
  public void setVD_IDSEQ(String s)
  {
      this.VD_IDSEQ = s;
  }
  /**
  * The setVD_LONG_NAME method sets the VD_LONG_NAME for this bean.
  *
  * @param s The VD_LONG_NAME to set
  */
  public void setVD_LONG_NAME(String s)
  {
      this.VD_LONG_NAME = s;
  }
  /**
  * The setVD_PREF_NAME method sets the VD_PREF_NAME for this bean.
  *
  * @param s The VD_PREF_NAME to set
  */
  public void setVD_PREF_NAME(String s)
  {
      this.VD_PREF_NAME = s;
  }
  /**
  * The setVD_DEFINITION method sets the VD_DEFINITION for this bean.
  *
  * @param s The VD_DEFINITION to set
  */
  public void setVD_DEFINITION(String s)
  {
      this.VD_DEFINITION = s;
  }
  /**
  * The setCDE_ID method sets the CDE_ID for this bean.
  *
  * @param s The CDE_ID to set
  */
  public void setCDE_ID(String s)
  {
      this.CDE_ID = s;
  }
  /**
  * The setHIGH_LIGHT_INDICATOR method sets the HIGH_LIGHT_INDICATOR for this bean.
  *
  * @param s The HIGH_LIGHT_INDICATOR to set
  */
  public void setHIGH_LIGHT_INDICATOR(String s)
  {
      this.HIGH_LIGHT_INDICATOR = s;
  }
  /**
  * The setSTATUS_INDICATOR method sets the STATUS_INDICATOR for this bean.
  *
  * @param s The STATUS_INDICATOR to set
  */
  public void setSTATUS_INDICATOR(String s)
  {
      this.STATUS_INDICATOR = s;
  }
  /**
  * The setQUEST_ORIGIN method sets the QUEST_ORIGIN for this bean.
  *
  * @param s The QUEST_ORIGIN to set
  */
  public void setQUEST_ORIGIN(String s)
  {
      this.QUEST_ORIGIN = s;
  }
  /**
  * The setQC_ID method sets the QC_ID for this bean.
  *
  * @param s The QC_ID to set
  */
  public void setQC_ID(String s)
  {
      this.QC_ID = s;
  }
  /**
  * The setQUEST_CHECKED method sets the QUEST_CHECKED for this bean.
  *
  * @param b The QUEST_CHECKED to set
  */
  public void setQUEST_CHECKED(boolean b)
  {
      this.QUEST_CHECKED = b;
  }


  //Get Properties
  /**
  * The getPROTO_IDSEQ method returns the PROTO_IDSEQ for this bean.
  *
  * @return String The PROTO_IDSEQ
  */
  public String getPROTO_IDSEQ()
  {
      return this.PROTO_IDSEQ;
  }
  /**
  * The getPROTOCOL_ID method returns the PROTOCOL_ID for this bean.
  *
  * @return String The PROTOCOL_ID
  */
  public String getPROTOCOL_ID()
  {
      return this.PROTOCOL_ID;
  }
  /**
  * The getPROTOCOL_NAME method returns the PROTOCOL_NAME for this bean.
  *
  * @return String The PROTOCOL_NAME
  */
  public String getPROTOCOL_NAME()
  {
      return this.PROTOCOL_NAME;
  }
  /**
  * The getCRF_IDSEQ method returns the CRF_IDSEQ for this bean.
  *
  * @return String The CRF_IDSEQ
  */
  public String getCRF_IDSEQ()
  {
      return this.CRF_IDSEQ;
  }
  /**
  * The getCRF_NAME method returns the CRF_NAME for this bean.
  *
  * @return String The CRF_NAME
  */
  public String getCRF_NAME()
  {
      return this.CRF_NAME;
  }
  /**
  * The getQC_IDSEQ method returns the QC_IDSEQ for this bean.
  *
  * @return String The QC_IDSEQ
  */
  public String getQC_IDSEQ()
  {
      return this.QC_IDSEQ;
  }
  /**
  * The getQUEST_NAME method returns the QUEST_NAME for this bean.
  *
  * @return String The QUEST_NAME
  */
  public String getQUEST_NAME()
  {
      return this.QUEST_NAME;
  }
  /**
  * The getQUEST_DEFINITION method returns the QUEST_DEFINITION for this bean.
  *
  * @return String The QUEST_DEFINITION
  */
  public String getQUEST_DEFINITION()
  {
      return this.QUEST_DEFINITION;
  }
  /**
  * The getSUBMITTED_LONG_NAME method returns the SUBMITTED_LONG_NAME for this bean.
  *
  * @return String The SUBMITTED_LONG_NAME
  */
  public String getSUBMITTED_LONG_NAME()
  {
      return this.SUBMITTED_LONG_NAME;
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
  * The getASL_NAME method returns the ASL_NAME for this bean.
  *
  * @return String The ASL_NAME
  */
  public String getASL_NAME()
  {
      return this.ASL_NAME;
  }
  /**
  * The getDE_IDSEQ method returns the DE_IDSEQ for this bean.
  *
  * @return String The DE_IDSEQ
  */
  public String getDE_IDSEQ()
  {
      return this.DE_IDSEQ;
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
  * The getDE_VD_IDSEQ method returns the DE_VD_IDSEQ for this bean.
  *
  * @return String The DE_VD_IDSEQ
  */
  public String getDE_VD_IDSEQ()
  {
      return this.DE_VD_IDSEQ;
  }
  /**
  * The getVD_IDSEQ method returns the VD_IDSEQ for this bean.
  *
  * @return String The VD_IDSEQ
  */
  public String getVD_IDSEQ()
  {
      return this.VD_IDSEQ;
  }
  /**
  * The getVD_LONG_NAME method returns the VD_LONG_NAME for this bean.
  *
  * @return String The VD_LONG_NAME
  */
  public String getVD_LONG_NAME()
  {
      return this.VD_LONG_NAME;
  }
  /**
  * The getVD_PREF_NAME method returns the VD_PREF_NAME for this bean.
  *
  * @return String The VD_PREF_NAME
  */
  public String getVD_PREF_NAME()
  {
      return this.VD_PREF_NAME;
  }
  /**
  * The getVD_DEFINITION method returns the VD_DEFINITION for this bean.
  *
  * @return String The VD_DEFINITION
  */
  public String getVD_DEFINITION()
  {
      return this.VD_DEFINITION;
  }
  /**
  * The getCDE_ID method returns the CDE_ID for this bean.
  *
  * @return String The CDE_ID
  */
  public String getCDE_ID()
  {
      return this.CDE_ID;
  }
  /**
  * The getHIGH_LIGHT_INDICATOR method returns the HIGH_LIGHT_INDICATOR for this bean.
  *
  * @return String The HIGH_LIGHT_INDICATOR
  */
  public String getHIGH_LIGHT_INDICATOR()
  {
      return this.HIGH_LIGHT_INDICATOR;
  }
  /**
  * The getSTATUS_INDICATOR method returns the STATUS_INDICATOR for this bean.
  *
  * @return String The STATUS_INDICATOR
  */
  public String getSTATUS_INDICATOR()
  {
      return this.STATUS_INDICATOR;
  }
  /**
  * The getQUEST_ORIGIN method returns the QUEST_ORIGIN for this bean.
  *
  * @return String The QUEST_ORIGIN
  */
  public String getQUEST_ORIGIN()
  {
      return this.QUEST_ORIGIN;
  }
  /**
  * The getQC_ID method returns the QC_ID for this bean.
  *
  * @return String The QC_ID
  */
  public String getQC_ID()
  {
      return this.QC_ID;
  }
  /**
  * The getQUEST_CHECKED method returns the QUEST_CHECKED for this bean.
  *
  * @return boolean The QUEST_CHECKED
  */
  public boolean getQUEST_CHECKED()
  {
      return this.QUEST_CHECKED;
  }

  /**
   * @return Returns the vDid.
   */
  public String getVDid()
  {
    return VDid;
  }

  /**
   * @param did The vDid to set.
   */
  public void setVDid(String did)
  {
    VDid = did;
  }

  /**
   * @return Returns the vDversion.
   */
  public String getVDversion()
  {
    return VDversion;
  }

  /**
   * @param dversion The vDversion to set.
   */
  public void setVDversion(String dversion)
  {
    VDversion = dversion;
  }


}  //end of class
 