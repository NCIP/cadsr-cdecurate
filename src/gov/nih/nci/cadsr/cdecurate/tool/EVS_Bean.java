// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/EVS_Bean.java,v 1.48 2008-12-26 19:13:25 chickerura Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import java.util.*;
import java.io.Serializable;
import javax.servlet.http.HttpSession;
import org.apache.log4j.*;

/**
 * The DEC_Bean encapsulates the DE information and is stored in the
 * session after the user has created a new Data Element Concept.
 * <P>
 * @author Tom Phillips
 * @version 3.0.1
 */

 /*
The CaCORE Software License, Version 3.0 Copyright 2002-2005 ScenPro, Inc. ("ScenPro")
Copyright Notice.  The software subject to this notice and license includes both
human readable source code form and machine readable, binary, object code form
("the CaCORE Software").  The CaCORE Software was developed in conjunction with
the National Cancer Institute ("NCI") by NCI employees and employees of SCENPRO.
To the extent government employees are authors, any rights in such works shall
be subject to Title 17 of the United States Code, section 105.
This CaCORE Software License (the "License") is between NCI and You.  "You (or "Your")
shall mean a person or an entity, and all other entities that control, are
controlled by, or are under common control with the entity.  "Control" for purposes
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
include the following acknowledgment: "This product includes software developed
by SCENPRO and the National Cancer Institute."  If You do not include such end-user
documentation, You shall include this acknowledgment in the Software itself,
wherever such third-party acknowledgments normally appear.
3.	You may not use the names "The National Cancer Institute", "NCI" "ScenPro, Inc."
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

public class EVS_Bean implements Serializable
{
  private static final long serialVersionUID = 1L;

  /**
   * init the logger
   */
  Logger logger = Logger.getLogger(EVS_Bean.class.getName());

// attributes
  private String RETURN_CODE;
  private String IDSEQ;
  private String CONCEPT_NAME;
  private String LONG_NAME;
  private String CONTE_IDSEQ;
  private String CONTEXT_NAME;
  private String VERSION;
  private String PREFERRED_DEFINITION;
  private String ASL_NAME;
  private String NCI_CC_TYPE;
  private String NCI_CC_VAL;  //referenced by non using jsp
  private String META_CODE_TYPE;
  private String META_CODE_VAL;
  private String TEMP_CUI_TYPE;
  private String EVS_SEMANTIC;
  private String EVS_DEF_SOURCE;
  private String EVS_CONCEPT_SOURCE;
  private String EVS_DATABASE;
  private String EVS_ORIGIN;
  private String caDSR_COMPONENT;
  private String ID;
  private boolean CHECKED;
  //private String DESCRIPTION;
  private String COMMENTS;
  private String DEC_USING;
  private int LEVEL;
  private String CONDR_IDSEQ;
 // private String CON_IDSEQ;
  private String DISPLAY_ORDER;
  private String PRIMARY_FLAG;
  private String CON_AC_SUBMIT_ACTION;
  private String PREF_VOCAB_CODE;
  private int NAME_VALUE_PAIR_IND;
  private String NVP_CONCEPT_VALUE;
  private String CONCEPT_IDENTIFIER;

  /**
   * Constructor
  */
  public EVS_Bean() {
  };

  /**
   * @param copyBean evs bean object ot copy to
   */
  public EVS_Bean(EVS_Bean copyBean)
  {
    this.setLONG_NAME(copyBean.getLONG_NAME());
    this.setCONDR_IDSEQ(copyBean.getCONDR_IDSEQ());
    this.setCON_AC_SUBMIT_ACTION(copyBean.getCON_AC_SUBMIT_ACTION());
    this.setCONCEPT_NAME(copyBean.getCONCEPT_NAME());
    this.setCONTE_IDSEQ(copyBean.getCONTE_IDSEQ());
    this.setDISPLAY_ORDER(copyBean.getDISPLAY_ORDER());
    this.setPREFERRED_DEFINITION(copyBean.getPREFERRED_DEFINITION());
    this.setEVS_CONCEPT_SOURCE(copyBean.getEVS_CONCEPT_SOURCE());
    this.setEVS_DATABASE(copyBean.getEVS_DATABASE());
    this.setEVS_DEF_SOURCE(copyBean.getEVS_DEF_SOURCE());
    this.setEVS_ORIGIN(copyBean.getEVS_ORIGIN());
    this.setEVS_SEMANTIC(copyBean.getEVS_SEMANTIC());
    this.setID(copyBean.getID());
    this.setIDSEQ(copyBean.getIDSEQ());
    this.setASL_NAME(copyBean.getASL_NAME());
    this.setLEVEL(copyBean.getLEVEL());
    this.setDEC_USING(copyBean.getDEC_USING());
    this.setCONCEPT_IDENTIFIER(copyBean.getCONCEPT_IDENTIFIER());
    this.setNCI_CC_TYPE(copyBean.getNCI_CC_TYPE());
    this.setNAME_VALUE_PAIR_IND(copyBean.getNAME_VALUE_PAIR_IND());
    this.setNVP_CONCEPT_VALUE(copyBean.getNVP_CONCEPT_VALUE());
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
   * The setIDSEQ method sets the IDSEQ for this bean.
   *
   * @param s The IDSEQ to set
  */
  public void setIDSEQ(String s)
  {
      this.IDSEQ = s;
  }
  /**
   * The setCONCEPT_NAME method sets the CONCEPT_NAME for this bean.
   *
   * @param s The CONCEPT_NAME to set
  */
  public void setCONCEPT_NAME(String s)
  {
      this.CONCEPT_NAME = s;
  }
  /**
   * The setLONG_NAME method sets the LONG_NAME for this bean.
   *
   * @param s The LONG_NAME to set
  */
  public void setLONG_NAME(String s)
  {
      this.LONG_NAME = s;
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
   * The setCOMMENTS method sets the COMMENTS for this bean.
   *
   * @param s The COMMENTS to set
  */
  public void setCOMMENTS(String s)
  {
      this.COMMENTS = s;
  }

/*   *//**
   * The setDESCRIPTION method sets the DESCRIPTION for this bean.
   *
   * @param s The DESCRIPTION to set
  *//*
  public void setDESCRIPTION(String s)
  {
      this.DESCRIPTION = s;
  }
*/  /**
   * The setVERSION method sets the VERSION for this bean.
   *
   * @param s The VERSION to set
  */
  public void setVERSION(String s)
  {
      this.VERSION = s;
  }
  /**
   * The setPREFERRED_DEFINITION method sets the PREFERRED_DEFINITION for this bean.
   *
   * @param s The PREFERRED_DEFINITION to set
  */
  public void setPREFERRED_DEFINITION(String s)
  {
      this.PREFERRED_DEFINITION = s;
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
   * The setCONTEXT_NAME method sets the CONTEXT_NAME for this bean.
   *
   * @param s The CONTEXT_NAME to set
  */
  public void setCONTEXT_NAME(String s)
  {
      this.CONTEXT_NAME = s;
  }
  /**
   * The setNCI_CC_TYPE method sets the NCI_CC_TYPE for this bean.
   *
   * @param s The NCI_CC_TYPE to set
  */
  public void setNCI_CC_TYPE(String s)
  {
      this.NCI_CC_TYPE = s;
  }
  /**
   * The setNCI_CC_VAL method sets the NCI_CC_VAL for this bean.
   *
   * @param s The NCI_CC_VAL to set
  */
  public void setNCI_CC_VAL(String s)
  {
      this.NCI_CC_VAL = s;
  }

  /**
   * The setCONCEPT_IDENTIFIER method sets the CONCEPT_IDENTIFIER for this bean.
   *
   * @param s The CONCEPT_IDENTIFIER to set
  */
  public void setCONCEPT_IDENTIFIER(String s)
  {
      this.CONCEPT_IDENTIFIER = s;
  }
  /**
   * The setMETA_CODE_TYPE method sets the META_CODE_TYPE for this bean.
   *
   * @param s The META_CODE_TYPE to set
  */
  public void setMETA_CODE_TYPE(String s)
  {
      this.META_CODE_TYPE = s;
  }
  /**
   * The setMETA_CODE_VAL method sets the META_CODE_VAL for this bean.
   *
   * @param s The META_CODE_VAL to set
  */
  public void setMETA_CODE_VAL(String s)
  {
      this.META_CODE_VAL = s;
  }
   /**
   * The setTEMP_CUI_TYPE method sets the TEMP_CUI_TYPE for this bean.
   *
   * @param s The TEMP_CUI_TYPE to set
  */
  public void setTEMP_CUI_TYPE(String s)
  {
      this.TEMP_CUI_TYPE = s;
  }
  /**
   * The setEVS_SEMANTIC method sets the EVS_SEMANTIC for this bean.
   *
   * @param s The EVS_SEMANTIC to set
  */
  public void setEVS_SEMANTIC(String s)
  {
      this.EVS_SEMANTIC = s;
  }
   /**
   * The setEVS_DEF_SOURCE method sets the EVS_DEF_SOURCE for this bean.
   *
   * @param s The EVS_DEF_SOURCE to set
  */

  public void setEVS_DEF_SOURCE(String s)
  {
      this.EVS_DEF_SOURCE = s;
  }
   /**
   * The setEVS_CONCEPT_SOURCE method sets the EVS_CONCEPT_SOURCE for this bean.
   *
   * @param s The EVS_CONCEPT_SOURCE to set
  */

  public void setEVS_CONCEPT_SOURCE(String s)
  {
      this.EVS_CONCEPT_SOURCE = s;
  }
   /**
   * The setEVS_DATABASE method sets the EVS_DATABASE for this bean.
   *
   * @param s The EVS_DATABASE to set
  */
  public void setEVS_DATABASE(String s)
  {
      this.EVS_DATABASE = s;
  }
   /**
   * The setEVS_ORIGIN method sets the EVS_ORIGIN for this bean.
   *
   * @param s The EVS_ORIGIN to set
  */
  public void setEVS_ORIGIN(String s)
  {
      this.EVS_ORIGIN = s;
  }
   /**
   * The setcaDSR_COMPONENT method sets the caDSR_COMPONENT for this bean.
   *
   * @param s The caDSR_COMPONENT to set
  */
  public void setcaDSR_COMPONENT(String s)
  {
      this.caDSR_COMPONENT = s;
  }
  /**
   * The setID method sets the ID for this bean.
   *
   * @param s The ID to set
  */
  public void setID(String s)
  {
      this.ID = s;
  }
/**
   * The setCHECKED method sets the CHECKED for this bean.
   *
   * @param b The CHECKED to set
  */
  public void setCHECKED(boolean b)
  {
      this.CHECKED = b;
  }

/**
   * The setDEC_USING method sets the DEC_USING for this bean.
   *
   * @param b The DEC_USING to set
  */
  public void setDEC_USING(String b)
  {
      this.DEC_USING = b;
  }
/**
   * The setLEVEL method sets the LEVEL for this bean.
   *
   * @param b The LEVEL to set
  */
  public void setLEVEL(int b)
  {
      this.LEVEL = b;
  }
/**
   * The setCONDR_IDSEQ method sets the CONDR_IDSEQ for this bean.
   *
   * @param b The CONDR_IDSEQ to set
  */
  public void setCONDR_IDSEQ(String b)
  {
      this.CONDR_IDSEQ = b;
  }
/*/**
   * The setCON_IDSEQ method sets the CON_IDSEQ for this bean.
   *
   * @param b The CON_IDSEQ to set
  */
/*  public void setCON_IDSEQ(String b)
  {
      this.CON_IDSEQ = b;
  }
*//**
   * The setDISPLAY_ORDER method sets the DISPLAY_ORDER for this bean.
   *
   * @param b The DISPLAY_ORDER to set
  */
  public void setDISPLAY_ORDER(String b)
  {
      this.DISPLAY_ORDER = b;
  }
/**
   * The setPRIMARY_FLAG method sets the PRIMARY_FLAG for this bean.
   *
   * @param b The PRIMARY_FLAG to set
  */
  public void setPRIMARY_FLAG(String b)
  {
      this.PRIMARY_FLAG = b;
  }
/**
   * The setCON_AC_SUBMIT_ACTION method sets the CON_AC_SUBMIT_ACTION for this bean.
   *
   * @param b The CON_AC_SUBMIT_ACTION to set
  */
  public void setCON_AC_SUBMIT_ACTION(String b)
  {
      this.CON_AC_SUBMIT_ACTION = b;
  }

  /**
   * @param pref_vocab_code The pREF_VOCAB_CODE to set.
   */
  public void setPREF_VOCAB_CODE(String pref_vocab_code)
  {
    PREF_VOCAB_CODE = pref_vocab_code;
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
  * The getIDSEQ method returns the IDSEQ for this bean.
  *
  * @return String The IDSEQ
  */
  public String getIDSEQ()
  {
      return (IDSEQ == null) ? "" : this.IDSEQ;
  }
  /**
  * The getCONCEPT_NAME method returns the CONCEPT_NAME for this bean.
  *
  * @return String The CONCEPT_NAME
  */
  public String getCONCEPT_NAME()
  {
      return this.CONCEPT_NAME;
  }
  /**
  * The getLONG_NAME method returns the LONG_NAME for this bean.
  *
  * @return String The LONG_NAME
  */
  public String getLONG_NAME()
  {
      return this.LONG_NAME;
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
  * The getVERSION method returns the VERSION for this bean.
  *
  * @return String The VERSION
  */
  public String getVERSION()
  {
      return this.VERSION;
  }
  /**
  * The getPREFERRED_DEFINITION method returns the PREFERRED_DEFINITION for this bean.
  *
  * @return String The PREFERRED_DEFINITION
  */
  public String getPREFERRED_DEFINITION()
  {
      return this.PREFERRED_DEFINITION;
  }
/*  *//**
  * The getDESCRIPTION method returns the DESCRIPTION for this bean.
  *
  * @return String The DESCRIPTION
  *//*
  public String getDESCRIPTION()
  {
      return this.DESCRIPTION;
  }
*/  /**
  * The getASL_NAME method returns the ASL_NAME for this bean.
  *
  * @return String The ASL_NAME
  */
  public String getASL_NAME()
  {
      return this.ASL_NAME;
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
  * The getNCI_CC_TYPE method returns the NCI_CC_TYPE for this bean.
  *
  * @return String The NCI_CC_TYPE
  */
  public String getNCI_CC_TYPE()
  {
      return this.NCI_CC_TYPE;
  }
  /**
   * The getNCI_CC_VAL method returns the NCI_CC_VAL for this bean.
   *
   * @return String The NCI_CC_VAL
   */
   public String getNCI_CC_VAL()
   {
       return this.NCI_CC_VAL;
   }

  /**
  * The getCONCEPT_IDENTIFIER method returns the CONCEPT_IDENTIFIER for this bean.
  *
  * @return String The CONCEPT_IDENTIFIER
  */
  public String getCONCEPT_IDENTIFIER()
  {
      return (CONCEPT_IDENTIFIER == null) ? "" : this.CONCEPT_IDENTIFIER;
  }
  /**
  * The getMETA_CODE_TYPE method returns the META_CODE_TYPE for this bean.
  *
  * @return String The META_CODE_TYPE
  */
  public String getMETA_CODE_TYPE()
  {
      return this.META_CODE_TYPE;
  }
  /**
  * The getMETA_CODE_VAL method returns the META_CODE_VAL for this bean.
  *
  * @return String The META_CODE_VAL
  */
  public String getMETA_CODE_VAL()
  {
      return this.META_CODE_VAL;
  }
  /**
  * The getCOMMENTS method returns the COMMENTS for this bean.
  *
  * @return String The COMMENTS
  */
  public String getCOMMENTS()
  {
      return this.COMMENTS;
  }
  /**
  * The getTEMP_CUI_TYPE method returns the TEMP_CUI_TYPE for this bean.
  *
  * @return String The TEMP_CUI_TYPE
  */
  public String getTEMP_CUI_TYPE()
  {
      return this.TEMP_CUI_TYPE;
  }
  /**
  * The getEVS_SEMANTIC method returns the EVS_SEMANTIC for this bean.
  *
  * @return String The EVS_SEMANTIC
  */
  public String getEVS_SEMANTIC()
  {
      return this.EVS_SEMANTIC;
  }
  /**
  * The getEVS_DEF_SOURCE method returns the EVS_DEF_SOURCE for this bean.
  *
  * @return String The EVS_DEF_SOURCE
  */
  public String getEVS_DEF_SOURCE()
  {
      return (EVS_DEF_SOURCE == null) ? "" : this.EVS_DEF_SOURCE;
  }
   /**
  * The getEVS_CONCEPT_SOURCE method returns the EVS_CONCEPT_SOURCE for this bean.
  *
  * @return String The EVS_CONCEPT_SOURCE
  */
  public String getEVS_CONCEPT_SOURCE()
  {
      return this.EVS_CONCEPT_SOURCE;
  }
   /**
  * The getEVS_DATABASE method returns the EVS_EVS_DATABASE for this bean.
  *
  * @return String The EVS_EVS_DATABASE
  */
  public String getEVS_DATABASE()
  {
      return (EVS_DATABASE == null) ? "" : this.EVS_DATABASE;
  }
   /**
  * The getEVS_ORIGIN method returns the EVS_ORIGIN for this bean.
  *
  * @return String The EVS_ORIGIN
  */
  public String getEVS_ORIGIN()
  {
      return this.EVS_ORIGIN;
  }
   /**
  * The getcaDSR_COMPONENT method returns the caDSR_COMPONENT for this bean.
  *
  * @return String The caDSR_COMPONENT
  */
  public String getcaDSR_COMPONENT()
  {
      return this.caDSR_COMPONENT;
  }
  /**
  * The getID method returns the ID for this bean.
  *
  * @return String The ID
  */
  public String getID()
  {
      return this.ID;
  }
/**
  * The getCHECKED method returns the CHECKED for this bean.
  *
  * @return boolean The CHECKED
  */
  public boolean getCHECKED()
  {
      return this.CHECKED;
  }
  /**
  * The getDEC_USING method returns the DEC_USING for this bean.
  *
  * @return String DEC_USING
  */
  public String getDEC_USING()
  {
      return this.DEC_USING;
  }
 /**
  * The getLEVEL method returns the LEVEL for this bean.
  *
  * @return int LEVEL
  */
  public int getLEVEL()
  {
      return this.LEVEL;
  }
/**
  * The getCONDR_IDSEQ method returns the CONDR_IDSEQ for this bean.
  *
  * @return String CONDR_IDSEQ
  */
  public String getCONDR_IDSEQ()
  {
      return this.CONDR_IDSEQ;
  }
/*/**
  * The getCON_IDSEQ method returns the CON_IDSEQ for this bean.
  *
  * @return String CON_IDSEQ
  */
/*  public String getCON_IDSEQ()
  {
      return this.CON_IDSEQ;
  }
*//**
  * The getDISPLAY_ORDER method returns the DISPLAY_ORDER for this bean.
  *
  * @return String DISPLAY_ORDER
  */
  public String getDISPLAY_ORDER()
  {
      return this.DISPLAY_ORDER;
  }
/**
  * The getPRIMARY_FLAG method returns the PRIMARY_FLAG for this bean.
  *
  * @return String PRIMARY_FLAG
  */
  public String getPRIMARY_FLAG()
  {
      return this.PRIMARY_FLAG;
  }
/**
  * The getCON_AC_SUBMIT_ACTION method returns the CON_AC_SUBMIT_ACTION for this bean.
  *
  * @return String CON_AC_SUBMIT_ACTION
  */
  public String getCON_AC_SUBMIT_ACTION()
  {
      return this.CON_AC_SUBMIT_ACTION;
  }

  /**
 * @return Returns the pREF_VOCAB_CODE.
 */
  public String getPREF_VOCAB_CODE()
  {
    return PREF_VOCAB_CODE;
  }

  /**
   * get the vocab attributes from teh user bean using filter attr and filter value to check and return its equivaltnt attrs
   * @param eUser EVS_userbean obtained from the database at login
   * @param sFilterValue string existing value
   * @param filterAttr int existing vocab name
   * @param retAttr int returning vocab name
   * @return value from returning vocab
   */
  public String getVocabAttr(EVS_UserBean eUser, String sFilterValue, int filterAttr, int retAttr)  // String sFilterAttr, String sRetAttr)
  {
    //go back if origin is emtpy
    if (sFilterValue == null || sFilterValue.equals(""))
      return "";

    String sRetValue = sFilterValue;
    Hashtable eHash = eUser.getVocab_Attr();
    Vector vVocabs = eUser.getVocabNameList();
    if (vVocabs == null) vVocabs = new Vector();
    //handle teh special case to make sure vocab for api query is valid
    if (filterAttr == EVSSearch.VOCAB_NULL)  //(sFilterAttr == null || sFilterAttr.equals(""))
    {
      //it is valid vocab name
      if (vVocabs.contains(sFilterValue))
        return sFilterValue; //found it
      //first check if filter value is from diplay vocab list
      Vector vDisplay = eUser.getVocabDisplayList();
      if (vDisplay != null && vDisplay.contains(sFilterValue))
      {
        int iIndex = vDisplay.indexOf(sFilterValue);
        sRetValue = (String)vVocabs.elementAt(iIndex);
        return sRetValue;  //found it
      }
      //filter it as dborigin
      filterAttr = EVSSearch.VOCAB_DBORIGIN;  //sFilterAttr = "vocabDBOrigin";
    }
    for (int i=0; i<vVocabs.size(); i++)
    {
      String sName = (String)vVocabs.elementAt(i);
      EVS_UserBean usrVocab = (EVS_UserBean)eHash.get(sName);
      String sValue = "";
      //check if the vocab is meta thesaurus
      String sMeta = usrVocab.getIncludeMeta();
      if (sMeta != null && !sMeta.equals("") && sMeta.equals(sFilterValue))
        return EVSSearch.META_VALUE;  // "MetaValue";
      //get teh data from teh bean to match search
      if (filterAttr == EVSSearch.VOCAB_DISPLAY)  // (sFilterAttr.equalsIgnoreCase("vocabDisplay"))
        sValue = usrVocab.getVocabDisplay();
      else if (filterAttr == EVSSearch.VOCAB_DBORIGIN)  //(sFilterAttr.equalsIgnoreCase("vocabDBOrigin"))
        sValue = usrVocab.getVocabDBOrigin();
      else if (filterAttr == EVSSearch.VOCAB_NAME)  //(sFilterAttr.equalsIgnoreCase("vocabName"))
        sValue = usrVocab.getVocabName();
      //do matching and return the value
     // System.out.println(sFilterValue + " getvocab " + sValue);
    //  if (sFilterValue.equalsIgnoreCase(sValue))  //check it later
      if (sFilterValue.contains(sValue))
      {
        //get its value from teh bean for the return attr
        if (retAttr == EVSSearch.VOCAB_DISPLAY)  // (sRetAttr.equalsIgnoreCase("vocabDisplay"))
          sRetValue = usrVocab.getVocabDisplay();
        else if (retAttr == EVSSearch.VOCAB_DBORIGIN)  // (sRetAttr.equalsIgnoreCase("vocabDBOrigin"))
          sRetValue = usrVocab.getVocabDBOrigin();
        else if (retAttr == EVSSearch.VOCAB_NAME)  // (sRetAttr.equalsIgnoreCase("vocabName"))
          sRetValue = usrVocab.getVocabName();
        break;
      }
    }
    //return the first vocab if null
  //  if ((sRetValue == null || sRetValue.equals("")) && vVocabs != null)
  //    sRetValue = (String)vVocabs.elementAt(0);
//System.out.println(sRetValue + sFilterValue + filterAttr + retAttr);
    if (sRetValue == null) sRetValue = "";
    return sRetValue;
  }

  /**
   * sets the evsbean with the data
   * @param definition string to store concept definition
   * @param defSource string to store concept definition source
   * @param conName string to store concept name
   * @param dispName string to store concept display name
   * @param sMetaCodeType string to store concept meta code type (evs source)
   * @param conCode string to store concept id
   * @param dtsVocab string to store concept vocab name for evs
   * @param dbVocab string to store concept vocab name stored in cadsr
   * @param iLevel string to store concept level number with respect to parent
   * @param condr_idseq string to store concept relationship idseq in cadsr
   * @param CONTE_IDSEQ string to store concept context idseq
   * @param sConceptSource string to store concept source
   * @param aslName string to store concept workflow status
   * @param semType string to store concept semantic type
   * @param vocabMetaType string to store meta concept code type (umls cui or meta cui)
   * @param vocabMetaCode string to store meta concept code value to filter (CL etc)
   */
  public void setEVSBean(String definition, String defSource, String conName, String dispName, String sMetaCodeType,
  String conCode, String dtsVocab, String dbVocab, int iLevel, String condr_idseq, String CONTE_IDSEQ,
  String sConceptSource, String aslName, String semType, String vocabMetaType, String vocabMetaCode)
  {
    try
    {
      UtilService util = new UtilService();  //make sure new line character trimmed out
      if (definition == null || definition.equals("")) definition = "No Value Exists.";
      definition = util.removeNewLineChar(definition);
      this.setPREFERRED_DEFINITION(definition);
      if (defSource != null)
        defSource = defSource.trim();
      this.setEVS_DEF_SOURCE(defSource);
      conName = util.removeNewLineChar(conName);
      this.setCONCEPT_NAME(conName);
      dispName = util.removeNewLineChar(dispName);
      this.setLONG_NAME(dispName);
      this.setNCI_CC_TYPE(sMetaCodeType);
   //System.out.println(" set evs bean before " + conCode + ";");
      conCode = util.removeNewLineChar(conCode);
   //System.out.println(" set evs bean after " + conCode + ";");
      this.setCONCEPT_IDENTIFIER(conCode);
      this.setMETA_CODE_TYPE(vocabMetaType);
      this.setMETA_CODE_VAL(vocabMetaCode);
     // this.setTEMP_CUI_TYPE("NCI_META_CUI");
     // this.setTEMP_CUI_VAL(tempCuiVal);
   //   if (database != null && database.equals("NCI_Thesaurus")) database = "NCI Thesaurus";
   //   else if(database != null && database.equals("MGED_Ontology")) database = "MGED";
      this.setEVS_ORIGIN(dtsVocab);
      if (dbVocab == null || dbVocab.equals("")) dbVocab = dtsVocab; //add database origin format here.
      this.setEVS_DATABASE(dbVocab);
      this.setDEC_USING("");
      this.setLEVEL(iLevel);
      this.setCONDR_IDSEQ(condr_idseq);
      this.setCONTE_IDSEQ(CONTE_IDSEQ);
      this.setEVS_CONCEPT_SOURCE(sConceptSource);
      this.setASL_NAME(aslName);
      semType = util.removeNewLineChar(semType);
      this.setEVS_SEMANTIC(semType);
    }
    catch(Exception e)
    {
       logger.error("EVS_Bean.java setEVS " + e.toString(), e);
    }
  }


  /**
   * @return Returns the nAME_VALUE_PAIR_IND.
   */
  public int getNAME_VALUE_PAIR_IND()
  {
    return NAME_VALUE_PAIR_IND;
  }

  /**
   * @param name_value_pair_ind The nAME_VALUE_PAIR_IND to set.
   */
  public void setNAME_VALUE_PAIR_IND(int name_value_pair_ind)
  {
    NAME_VALUE_PAIR_IND = name_value_pair_ind;
  }

  /**
   * @return Returns the nVP_CONCEPT_VALUE.
   */
  public String getNVP_CONCEPT_VALUE()
  {
    return (NVP_CONCEPT_VALUE == null) ? "" : NVP_CONCEPT_VALUE;
  }

  /**
   * @param nvp_concept_value The nVP_CONCEPT_VALUE to set.
   */
  public void setNVP_CONCEPT_VALUE(String nvp_concept_value)
  {
    NVP_CONCEPT_VALUE = nvp_concept_value;
  }

  /**mark the pv if NVP concept
   * @param curBean evs bean object
   * @param session HttpSession object
   */
  @SuppressWarnings("unchecked")
  public void markNVPConcept(EVS_Bean curBean, HttpSession session)
  {
    Vector<String> vNVP = (Vector)session.getAttribute("NVPConcepts");
    if (vNVP == null) vNVP = new Vector<String>();
    String conID = curBean.getCONCEPT_IDENTIFIER();
    if (conID != null && vNVP.contains(conID))
      curBean.setNAME_VALUE_PAIR_IND(1);
    else
      curBean.setNAME_VALUE_PAIR_IND(0);
  }
}
