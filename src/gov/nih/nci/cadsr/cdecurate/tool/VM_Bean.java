// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VM_Bean.java,v 1.12 2006-10-30 18:53:37 hegdes Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.io.*;
import java.util.Vector;

/**
 * The VM_Bean encapsulates the VM information and is stored in the
 * session after the user has created a new Value Meaning.
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

public class VM_Bean implements Serializable
{
/**
   * 
   */
  private static final long serialVersionUID = 1L;
  //Attributes
  private String RETURN_CODE;
  private String VM_COMMENTS;
  private String VM_SHORT_MEANING;
  private String VM_BEGIN_DATE;
  private String VM_DESCRIPTION;
  private String VM_END_DATE;
  private String VM_CREATED_BY;
  private String VM_DATE_CREATED;
  private String VM_MODIFIED_BY;
  private String VM_DATE_MODIFIED;
  private String VM_CD_IDSEQ;
  private String VM_CD_NAME;
  private boolean VM_CHECKED;
  private EVS_Bean VM_CONCEPT;
  private String VM_IDSEQ;
  private String VM_CONTE_IDSEQ;
  private String ASL_NAME;
  private String VM_LONG_NAME;
  private String VM_PREF_NAME;
  private String VM_ID;
  private String VM_DEFINITION;
  private String VM_ORIGIN;
  private String VM_CHANGE_NOTE;
  private String VM_VERSION;
  private String VM_SUBMIT_ACTION;
  private String VM_CONDR_IDSEQ;
  private Vector<EVS_Bean> VM_CONCEPT_LIST;
  private Vector<VD_Bean> VM_VD_LIST;
  

  /**
  * Constructor
  */
  public VM_Bean() {
  };

  public VM_Bean copyVMBean(VM_Bean cBean)
  {
    this.setVM_SHORT_MEANING(cBean.getVM_SHORT_MEANING());
    this.setVM_DESCRIPTION(cBean.getVM_DESCRIPTION());
    this.setVM_LONG_NAME(cBean.getVM_LONG_NAME());
    this.setVM_CONCEPT_LIST(cloneVMConVector(cBean.getVM_CONCEPT_LIST()));
    this.setVM_CONDR_IDSEQ(cBean.getVM_CONDR_IDSEQ());
    this.setVM_IDSEQ(cBean.getVM_IDSEQ());
    this.setVM_SUBMIT_ACTION(cBean.getVM_SUBMIT_ACTION());
    
    return this;
  }

  public Vector<EVS_Bean> cloneVMConVector(Vector<EVS_Bean> vmcon)
  {
    Vector<EVS_Bean> cloneVMCon = new Vector<EVS_Bean>();
    for (int i =0; i<vmcon.size(); i++)
    {
      EVS_Bean con = new EVS_Bean((EVS_Bean)vmcon.elementAt(i));
      cloneVMCon.addElement(con);
    }
    return cloneVMCon;
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
  * The setVM_SHORT_MEANING method sets the VM_SHORT_MEANING for this bean.
  *
  * @param s The VM_SHORT_MEANING to set
  */
  public void setVM_SHORT_MEANING(String s)
  {
      this.VM_SHORT_MEANING = s;
  }
  /**
  * The setVM_BEGIN_DATE method sets the VM_BEGIN_DATE for this bean.
  *
  * @param s The VM_BEGIN_DATE to set
  */
  public void setVM_BEGIN_DATE(String s)
  {
      this.VM_BEGIN_DATE = s;
  }
  /**
  * The setVM_DESCRIPTION method sets the VM_DESCRIPTION for this bean.
  *
  * @param s The VM_DESCRIPTION to set
  */
  public void setVM_DESCRIPTION(String s)
  {
      this.VM_DESCRIPTION = s;
  }
  /**
  * The setVM_COMMENTS method sets the VM_COMMENTS for this bean.
  *
  * @param s The VM_COMMENTS to set
  */
  public void setVM_COMMENTS(String s)
  {
      this.VM_COMMENTS = s;
  }
  /**
  * The setVM_END_DATE method sets the VM_END_DATE for this bean.
  *
  * @param s The VM_END_DATE to set
  */
  public void setVM_END_DATE(String s)
  {
      this.VM_END_DATE = s;
  }
  /**
  * The setVM_CREATED_BY method sets the VM_CREATED_BY for this bean.
  *
  * @param s The VM_CREATED_BY to set
  */
  public void setVM_CREATED_BY(String s)
  {
      this.VM_CREATED_BY = s;
  }
  /**
  * The setVM_DATE_CREATED method sets the VM_DATE_CREATED for this bean.
  *
  * @param s The VM_DATE_CREATED to set
  */
  public void setVM_DATE_CREATED(String s)
  {
      this.VM_DATE_CREATED = s;
  }
  /**
  * The setVM_MODIFIED_BY method sets the VM_MODIFIED_BY for this bean.
  *
  * @param s The VM_MODIFIED_BY to set
  */
  public void setVM_MODIFIED_BY(String s)
  {
      this.VM_MODIFIED_BY = s;
  }
  /**
  * The setVM_DATE_MODIFIED method sets the VM_DATE_MODIFIED for this bean.
  *
  * @param s The VM_DATE_MODIFIED to set
  */
  public void setVM_DATE_MODIFIED(String s)
  {
      this.VM_DATE_MODIFIED = s;
  }
  /**
  * The setVM_CD_IDSEQ method sets the VM_CD_IDSEQ for this bean.
  *
  * @param s The VM_CD_IDSEQ to set
  */
  public void setVM_CD_IDSEQ(String s)
  {
      this.VM_CD_IDSEQ = s;
  }
   /**
  * The setVM_CD_NAME method sets the VM_CD_NAME for this bean.
  *
  * @param s The VM_CD_NAME to set
  */
  public void setVM_CD_NAME(String s)
  {
      this.VM_CD_NAME = s;
  }
   /**
   * The setVM_CHECKED method sets the VM_CHECKED for this bean.
   *
   * @param b The VM_CHECKED to set
  */
  public void setVM_CHECKED(boolean b)
  {
      this.VM_CHECKED = b;
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
  * The getRETURN_CODE method returns the RETURN_CODE for this bean.
  *
  * @return String The RETURN_CODE
  */
  public String getRETURN_CODE()
  {
      return this.RETURN_CODE;
  }
  /**
  * The getRETURN_CODE method returns the VM_SHORT_MEANING for this bean.
  *
  * @return String The VM_SHORT_MEANING
  */
  public String getVM_SHORT_MEANING()
  {
      return (VM_SHORT_MEANING == null) ? "" : this.VM_SHORT_MEANING;
  }
  /**
  * The getVM_BEGIN_DATE method returns the VM_BEGIN_DATE for this bean.
  *
  * @return String The VM_BEGIN_DATE
  */
  public String getVM_BEGIN_DATE()
  {
      return this.VM_BEGIN_DATE;
  }
  /**
  * The getVM_DESCRIPTION method returns the VM_DESCRIPTION for this bean.
  *
  * @return String The VM_DESCRIPTION
  */
  public String getVM_DESCRIPTION()
  {
      return (this.VM_DESCRIPTION == null) ? "" : this.VM_DESCRIPTION.trim();
  }
  /**
  * The getVM_COMMENTS method returns the VM_COMMENTS for this bean.
  *
  * @return String The VM_COMMENTS
  */
  public String getVM_COMMENTS()
  {
      return this.VM_COMMENTS;
  }
  /**
  * The getVM_END_DATE method returns the VM_END_DATE for this bean.
  *
  * @return String The VM_END_DATE
  */
  public String getVM_END_DATE()
  {
      return this.VM_END_DATE;
  }
  /**
  * The getVM_CREATED_BY method returns the VM_CREATED_BY for this bean.
  *
  * @return String The VM_CREATED_BY
  */
  public String getVM_CREATED_BY()
  {
      return this.VM_CREATED_BY;
  }
  /**
  * The getVM_DATE_CREATED method returns the VM_DATE_CREATED for this bean.
  *
  * @return String The VM_DATE_CREATED
  */
  public String getVM_DATE_CREATED()
  {
      return this.VM_DATE_CREATED;
  }
  /**
  * The getVM_MODIFIED_BY method returns the VM_MODIFIED_BY for this bean.
  *
  * @return String The VM_MODIFIED_BY
  */
  public String getVM_MODIFIED_BY()
  {
      return this.VM_MODIFIED_BY;
  }
  /**
  * The getVM_DATE_MODIFIED method returns the VM_DATE_MODIFIED for this bean.
  *
  * @return String The VM_DATE_MODIFIED
  */
  public String getVM_DATE_MODIFIED()
  {
      return this.VM_DATE_MODIFIED;
  }
  /**
  * The getVM_CD_IDSEQ method returns the VM_CD_IDSEQ for this bean.
  *
  * @return String The VM_CD_IDSEQ
  */
  public String getVM_CD_IDSEQ()
  {
      return (VM_CD_IDSEQ == null) ? "" : this.VM_CD_IDSEQ;
  }
  /**
  * The getVM_CD_NAME method returns the VM_CD_NAME for this bean.
  *
  * @return String The VM_CD_NAME
  */
  public String getVM_CD_NAME()
  {
      return this.VM_CD_NAME;
  }
   /**
  * The getVM_CHECKED method returns the VM_CHECKED for this bean.
  *
  * @return boolean The VM_CHECKED
  */
  public boolean getVM_CHECKED()
  {
      return this.VM_CHECKED;
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
   * @return Returns the aSL_NAME.
   */
  public String getASL_NAME()
  {
    return (ASL_NAME == null) ? "": ASL_NAME;
  }


  /**
   * @param asl_name The aSL_NAME to set.
   */
  public void setASL_NAME(String asl_name)
  {
    ASL_NAME = asl_name;
  }

  /**
   * @return Returns the cONTE_IDSEQ.
   */
  public String getVM_CONTE_IDSEQ()
  {
    return VM_CONTE_IDSEQ;
  }

  /**
   * @param conte_idseq The cONTE_IDSEQ to set.
   */
  public void setVM_CONTE_IDSEQ(String conte_idseq)
  {
    VM_CONTE_IDSEQ = conte_idseq;
  }

  /**
   * @return Returns the vM_CHANGE_NOTE.
   */
  public String getVM_CHANGE_NOTE()
  {
    return VM_CHANGE_NOTE;
  }

  /**
   * @param vm_change_note The vM_CHANGE_NOTE to set.
   */
  public void setVM_CHANGE_NOTE(String vm_change_note)
  {
    VM_CHANGE_NOTE = vm_change_note;
  }

/*  *//**
   * @return Returns the vM_DEFINITION.
   *//*
  public String getVM_DEFINITION()
  {
    return VM_DEFINITION;
  }

  *//**
   * @param vm_definition The vM_DEFINITION to set.
   *//*
  public void setVM_DEFINITION(String vm_definition)
  {
    VM_DEFINITION = vm_definition;
  }
*/
  /**
   * @return Returns the vM_ID.
   */
  public String getVM_ID()
  {
    return VM_ID;
  }

  /**
   * @param vm_id The vM_ID to set.
   */
  public void setVM_ID(String vm_id)
  {
    VM_ID = vm_id;
  }

  /**
   * @return Returns the vM_IDSEQ.
   */
  public String getVM_IDSEQ()
  {
    return VM_IDSEQ;
  }

  /**
   * @param vm_idseq The vM_IDSEQ to set.
   */
  public void setVM_IDSEQ(String vm_idseq)
  {
    VM_IDSEQ = vm_idseq;
  }

  /**
   * @return Returns the vM_LONG_NAME.
   */
  public String getVM_LONG_NAME()
  {
    return (VM_LONG_NAME == null) ? "" : VM_LONG_NAME;
  }

  /**
   * @param vm_long_name The vM_LONG_NAME to set.
   */
  public void setVM_LONG_NAME(String vm_long_name)
  {
    VM_LONG_NAME = vm_long_name;
  }

  /**
   * @return Returns the vM_ORIGIN.
   */
  public String getVM_ORIGIN()
  {
    return VM_ORIGIN;
  }

  /**
   * @param vm_origin The vM_ORIGIN to set.
   */
  public void setVM_ORIGIN(String vm_origin)
  {
    VM_ORIGIN = vm_origin;
  }

  /**
   * @return Returns the vM_PREF_NAME.
   */
  public String getVM_PREF_NAME()
  {
    return VM_PREF_NAME;
  }

  /**
   * @param vm_pref_name The vM_PREF_NAME to set.
   */
  public void setVM_PREF_NAME(String vm_pref_name)
  {
    VM_PREF_NAME = vm_pref_name;
  }

  /**
   * @return Returns the vM_VERSION.
   */
  public String getVM_VERSION()
  {
    return VM_VERSION;
  }

  /**
   * @param vm_version The vM_VERSION to set.
   */
  public void setVM_VERSION(String vm_version)
  {
    VM_VERSION = vm_version;
  }
  /**
   * @return Returns the vM_SUBMIT_ACTION.
   */
  public String getVM_SUBMIT_ACTION()
  {
    return (VM_SUBMIT_ACTION == null) ? "" : VM_SUBMIT_ACTION;
  }
  /**
   * @param vm_submit_action The vM_SUBMIT_ACTION to set.
   */
  public void setVM_SUBMIT_ACTION(String vm_submit_action)
  {
    VM_SUBMIT_ACTION = vm_submit_action;
  }

  /**
   * @return Returns the vM_CONDR_IDSEQ.
   */
  public String getVM_CONDR_IDSEQ()
  {
    return (VM_CONDR_IDSEQ == null) ? "" : VM_CONDR_IDSEQ;
  }

  /**
   * @param vm_condr_idseq The vM_CONDR_IDSEQ to set.
   */
  public void setVM_CONDR_IDSEQ(String vm_condr_idseq)
  {
    VM_CONDR_IDSEQ = vm_condr_idseq;
  }

  /**
   * @return Returns the vM_CONCEPT_LIST.
   */
  public Vector<EVS_Bean> getVM_CONCEPT_LIST()
  {
    return (VM_CONCEPT_LIST == null) ? new Vector<EVS_Bean>(): VM_CONCEPT_LIST;
  }

  /**
   * @param vm_concept_list The vM_CONCEPT_LIST to set.
   */
  public void setVM_CONCEPT_LIST(Vector<EVS_Bean> vm_concept_list)
  {
    VM_CONCEPT_LIST = vm_concept_list;
  }

  /**
   * @return Returns the vM_VD_LIST.
   */
  public Vector<VD_Bean> getVM_VD_LIST()
  {
    return (VM_VD_LIST == null) ? new Vector<VD_Bean>() : VM_VD_LIST;
  }

  /**
   * @param vm_vd_list The vM_VD_LIST to set.
   */
  public void setVM_VD_LIST(Vector<VD_Bean> vm_vd_list)
  {
    VM_VD_LIST = vm_vd_list;
  }

  
}
