// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/DE_COMP_Bean.java,v 1.17 2006-11-16 05:55:00 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.Serializable;
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
1.  Your redistributions of the source code for the Software must retain the above
copyright notice, this list of conditions and the disclaimer and limitation of
liability of Article 6, below.  Your redistributions in object code form must
reproduce the above copyright notice, this list of conditions and the disclaimer
of Article 6 in the documentation and/or other materials provided with the 
distribution, if any.
2.  Your end-user documentation included with the redistribution, if any, must 
include the following acknowledgment: “This product includes software developed 
by SCENPRO and the National Cancer Institute.”  If You do not include such end-user
documentation, You shall include this acknowledgment in the Software itself, 
wherever such third-party acknowledgments normally appear.
3.  You may not use the names "The National Cancer Institute", "NCI" “ScenPro, Inc.”
and "SCENPRO" to endorse or promote products derived from this Software.  
This License does not authorize You to use any trademarks, service marks, trade names,
logos or product names of either NCI or SCENPRO, except as required to comply with
the terms of this License.
4.  For sake of clarity, and not by way of limitation, You may incorporate this
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
5.  For sake of clarity, and not by way of limitation, You may add Your own 
copyright statement to Your modifications and to the derivative works, and You 
may provide additional or different license terms and conditions in Your sublicenses
of modifications of the Software, or any derivative works of the Software as a 
whole, provided Your use, reproduction, and distribution of the Work otherwise 
complies with the conditions stated in this License.
6.  THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES,
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

/**
 * @author shegde
 *
 */
public class DE_COMP_Bean implements Serializable
{
  private static final long serialVersionUID = 3552330486873056426L;

  //attributes
  private String COMP_REL_IDSEQ;
  private String COMP_NAME;
  private String COMP_IDSEQ;
  private String PARENT_IDSEQ;
  private String DISPLAY_ORDER;
  private String PUBLIC_ID;
  private String VERSION;
  private String SUBMIT_ACTION;  
  
  /**
   * construct the bean
   */
  public DE_COMP_Bean()
  {
  }

  /**
   * @return Returns the cOMP_IDSEQ.
   */
  public String getCOMP_IDSEQ()
  {
    return COMP_IDSEQ;
  }

  /**
   * @param comp_idseq The cOMP_IDSEQ to set.
   */
  public void setCOMP_IDSEQ(String comp_idseq)
  {
    COMP_IDSEQ = comp_idseq;
  }

  /**
   * @return Returns the cOMP_NAME.
   */
  public String getCOMP_NAME()
  {
    return COMP_NAME;
  }

  /**
   * @param comp_name The cOMP_NAME to set.
   */
  public void setCOMP_NAME(String comp_name)
  {
    COMP_NAME = comp_name;
  }

  /**
   * @return Returns the cOMP_REL_IDSEQ.
   */
  public String getCOMP_REL_IDSEQ()
  {
    return COMP_REL_IDSEQ;
  }

  /**
   * @param comp_rel_idseq The cOMP_REL_IDSEQ to set.
   */
  public void setCOMP_REL_IDSEQ(String comp_rel_idseq)
  {
    COMP_REL_IDSEQ = comp_rel_idseq;
  }

  /**
   * @return Returns the dISPLAY_ORDER.
   */
  public String getDISPLAY_ORDER()
  {
    return DISPLAY_ORDER;
  }

  /**
   * @param display_order The dISPLAY_ORDER to set.
   */
  public void setDISPLAY_ORDER(String display_order)
  {
    DISPLAY_ORDER = display_order;
  }

  
  /**
   * @return Returns the pARENT_IDSEQ.
   */
  public String getPARENT_IDSEQ()
  {
    return PARENT_IDSEQ;
  }

  /**
   * @param parent_idseq The pARENT_IDSEQ to set.
   */
  public void setPARENT_IDSEQ(String parent_idseq)
  {
    PARENT_IDSEQ = parent_idseq;
  }

  /**
   * @return Returns the pUBLIC_ID.
   */
  public String getPUBLIC_ID()
  {
    return PUBLIC_ID;
  }

  /**
   * @param public_id The pUBLIC_ID to set.
   */
  public void setPUBLIC_ID(String public_id)
  {
    PUBLIC_ID = public_id;
  }

  /**
   * @return Returns the sUBMIT_ACTION.
   */
  public String getSUBMIT_ACTION()
  {
    return SUBMIT_ACTION;
  }

  /**
   * @param submit_action The sUBMIT_ACTION to set.
   */
  public void setSUBMIT_ACTION(String submit_action)
  {
    SUBMIT_ACTION = submit_action;
  }

  /**
   * @return Returns the vERSION.
   */
  public String getVERSION()
  {
    return VERSION;
  }

  /**
   * @param version The vERSION to set.
   */
  public void setVERSION(String version)
  {
    VERSION = version;
  }
  
}  //end of class
