// Copyright (c) 2005 ScenPro, Inc.
// $Header: /CVSNT/cdecurate/src/gov/nih/nci/cadsr/cdecurate/tool/VD_Bean.java,v 1.2 2006/09/19
// 16:06:36 shegde Exp $
// $Name: not supported by cvs2svn $

package gov.nih.nci.cadsr.cdecurate.tool;

import gov.nih.nci.cadsr.cdecurate.database.ACTypes;
import java.util.*;

/**
 * The VD_Bean encapsulates the VD information and is stored in the session after the user has created a new Value
 * Domain.
 * <P>
 * 
 * @author Tom Phillips
 * @version 3.0
 */
/*
 * The CaCORE Software License, Version 3.0 Copyright 2002-2005 ScenPro, Inc. (“ScenPro”) Copyright Notice. The software
 * subject to this notice and license includes both human readable source code form and machine readable, binary, object
 * code form (“the CaCORE Software”). The CaCORE Software was developed in conjunction with the National Cancer
 * Institute (“NCI”) by NCI employees and employees of SCENPRO. To the extent government employees are authors, any
 * rights in such works shall be subject to Title 17 of the United States Code, section 105. This CaCORE Software
 * License (the “License”) is between NCI and You. “You (or “Your”) shall mean a person or an entity, and all other
 * entities that control, are controlled by, or are under common control with the entity. “Control” for purposes of this
 * definition means (i) the direct or indirect power to cause the direction or management of such entity, whether by
 * contract or otherwise, or (ii) ownership of fifty percent (50%) or more of the outstanding shares, or (iii)
 * beneficial ownership of such entity. This License is granted provided that You agree to the conditions described
 * below. NCI grants You a non-exclusive, worldwide, perpetual, fully-paid-up, no-charge, irrevocable, transferable and
 * royalty-free right and license in its rights in the CaCORE Software to (i) use, install, access, operate, execute,
 * copy, modify, translate, market, publicly display, publicly perform, and prepare derivative works of the CaCORE
 * Software; (ii) distribute and have distributed to and by third parties the CaCORE Software and any modifications and
 * derivative works thereof; and (iii) sublicense the foregoing rights set out in (i) and (ii) to third parties,
 * including the right to license such rights to further third parties. For sake of clarity, and not by way of
 * limitation, NCI shall have no right of accounting or right of payment from You or Your sublicensees for the rights
 * granted under this License. This License is granted at no charge to You. 1. Your redistributions of the source code
 * for the Software must retain the above copyright notice, this list of conditions and the disclaimer and limitation of
 * liability of Article 6, below. Your redistributions in object code form must reproduce the above copyright notice,
 * this list of conditions and the disclaimer of Article 6 in the documentation and/or other materials provided with the
 * distribution, if any. 2. Your end-user documentation included with the redistribution, if any, must include the
 * following acknowledgment: “This product includes software developed by SCENPRO and the National Cancer Institute.” If
 * You do not include such end-user documentation, You shall include this acknowledgment in the Software itself,
 * wherever such third-party acknowledgments normally appear. 3. You may not use the names "The National Cancer
 * Institute", "NCI" “ScenPro, Inc.” and "SCENPRO" to endorse or promote products derived from this Software. This
 * License does not authorize You to use any trademarks, service marks, trade names, logos or product names of either
 * NCI or SCENPRO, except as required to comply with the terms of this License. 4. For sake of clarity, and not by way
 * of limitation, You may incorporate this Software into Your proprietary programs and into any third party proprietary
 * programs. However, if You incorporate the Software into third party proprietary programs, You agree that You are
 * solely responsible for obtaining any permission from such third parties required to incorporate the Software into
 * such third party proprietary programs and for informing Your sublicensees, including without limitation Your
 * end-users, of their obligation to secure any required permissions from such third parties before incorporating the
 * Software into such third party proprietary software programs. In the event that You fail to obtain such permissions,
 * You agree to indemnify NCI for any claims against NCI by such third parties, except to the extent prohibited by law,
 * resulting from Your failure to obtain such permissions. 5. For sake of clarity, and not by way of limitation, You may
 * add Your own copyright statement to Your modifications and to the derivative works, and You may provide additional or
 * different license terms and conditions in Your sublicenses of modifications of the Software, or any derivative works
 * of the Software as a whole, provided Your use, reproduction, and distribution of the Work otherwise complies with the
 * conditions stated in this License. 6. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 * (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A
 * PARTICULAR PURPOSE) ARE DISCLAIMED. IN NO EVENT SHALL THE NATIONAL CANCER INSTITUTE, SCENPRO, OR THEIR AFFILIATES BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
public class VD_Bean extends AC_Bean
{
    private static final long    serialVersionUID = -2456878461098933694L;

    // Attributes
    private String               RETURN_CODE;

    private String               VD_VD_IDSEQ;

    private String               VD_PREFERRED_NAME;

    private String               VD_CONTE_IDSEQ;

    private String               VD_VERSION;

    private String               VD_PREFERRED_DEFINITION;

    private String               VD_CD_IDSEQ;

    private String               VD_ASL_NAME;

    private String               VD_LATEST_VERSION_IND;

    private String               VD_DTL_NAME;

    private String               VD_MAX_LENGTH_NUM;

    private String               VD_LONG_NAME;

    private String               VD_FORML_NAME;

    private String               VD_FORML_DESCRIPTION;

    private String               VD_FORML_COMMENT;

    private String               VD_UOML_NAME;

    private String               VD_UOML_DESCRIPTION;

    private String               VD_UOML_COMMENT;

    private String               VD_LOW_VALUE_NUM;

    private String               VD_HIGH_VALUE_NUM;

    private String               VD_MIN_LENGTH_NUM;

    private String               VD_DECIMAL_PLACE;

    private String               VD_CHAR_SET_NAME;

    private String               VD_BEGIN_DATE;

    private String               VD_END_DATE;

    private String               VD_CHANGE_NOTE;

    private String               VD_TYPE_FLAG;

    private String               VD_CREATED_BY;

    private String               VD_DATE_CREATED;

    private String               VD_MODIFIED_BY;

    private String               VD_DATE_MODIFIED;

    private String               VD_DELETED_IND;

    private String               VD_PROTOCOL_ID;

    private String               VD_CRF_NAME;

    private String               VD_TYPE_NAME;

    private String               VD_DES_ALIAS_ID;

    private String               VD_ALIAS_NAME;

    private String               VD_USEDBY_CONTEXT;

    private String               VD_VD_ID;

    private String               VD_Permissible_Value;                    // used for the search

    private Integer              VD_Permissible_Value_Count;              // for more link

    private String               VD_CONTEXT_NAME;

    private String               VD_LANGUAGE;

    private String               VD_LANGUAGE_IDSEQ;

    private String               VD_CD_NAME;

    private String               VD_DATA_TYPE;

    private Vector               VD_PV_ID;

    private Vector               VD_PV_NAME;

    private Vector               VD_PV_MEANING;

    private Vector               VD_PV_MEANING_DESCRIPTION;

    private Vector               VD_PV_ORIGIN;

    private String               VD_OBJ_QUAL;

    private String               VD_OBJ_CLASS;

    private String               VD_OBJ_IDSEQ;

    private String               VD_PROP_QUAL;

    private String               VD_PROP_CLASS;

    private String               VD_PROP_IDSEQ;

    private String               VD_REP_ASL_NAME;

    private String               VD_REP_TERM;

    private String               VD_REP_IDSEQ;

    private String               VD_Obj_Definition;

    private String               VD_Prop_Definition;

    private String               VD_Rep_Definition;

    private String               VD_SOURCE;

    private boolean              VD_CHECKED;

    /*
     * private String VD_REF_VALUE; private String VD_REF_CONCEPT_CODE; private String VD_REF_UMLS_CUI; private String
     * VD_REF_TEMP_CUI;
     */
    // cs-csi relationship
    private Vector               VD_SELECTED_CONTEXT_ID;

    private Vector               VD_CS_NAME;                              // store CS name

    private Vector               VD_CS_ID;                                // store CS_IDSEQs

    private Vector               VD_CSI_NAME;                             // store CSI name

    private Vector               VD_CSI_ID;                               // store CSI_IDSEQs

    private Vector               VD_AC_CSI_VECTOR;

    private Vector               VD_AC_CSI_ID;

    private Vector               VD_CS_CSI_ID;

    // altname ref docs
    private Vector               AC_ALT_NAMES;

    private Vector               AC_REF_DOCS;

    // concept name
    private String               AC_CONCEPT_NAME;

    // contact inf
    private Hashtable            AC_CONTACTS;

    private String               REFERENCE_DOCUMENT;

    private String               ALTERNATE_NAME;

    private String               VD_REP_CONCEPT_CODE;

    private String               VD_REP_EVS_CUI_ORIGEN;

    private String               VD_REP_EVS_CUI_SOURCE;

    private String               VD_REP_DEFINITION_SOURCE;

    private String               VD_REP_QUAL_CONCEPT_CODE;

    private String               VD_REP_QUAL_EVS_CUI_ORIGEN;

    private String               VD_REP_QUAL_EVS_CUI_SOURCE;

    private String               VD_REP_QUAL_DEFINITION_SOURCE;

    private Vector               VD_REP_QUALIFIER_NAMES;

    private Vector               VD_REP_QUALIFIER_CODES;

    private Vector               VD_REP_QUALIFIER_DB;

    private Vector               VD_PARENT_CODES;

    private Vector               VD_PARENT_NAMES;

    private Vector               VD_PARENT_DB;

    private Vector               VD_PARENT_LIST;

    private Vector               VD_PARENT_META_SOURCE;

    private String               VD_REP_CONDR_IDSEQ;

    private String               VD_PAR_CONDR_IDSEQ;

    private String               VD_REP_NAME_PRIMARY;

    private String               AC_SYS_PREF_NAME;

    private String               AC_ABBR_PREF_NAME;

    private String               AC_USER_PREF_NAME;

    private String               AC_PREF_NAME_TYPE;

    private boolean              VDNAME_CHANGED;

    private Vector<ValidateBean> ValidateList;

    private Vector<PV_Bean>      VD_PV_List;

    private Vector<EVS_Bean>     ReferenceConceptList;

    private Vector<PV_Bean>      removed_VDPVList;

    /**
     * Constructor
     */
    public VD_Bean()
    {
        super();
        
        _type = ACTypes.ValueDomain;
    }

    /**
     * makes a copy of the bean
     * 
     * @param copyBean
     *            passin the bean whose attributes need to be copied and returned.
     * @return VD_Bean returns this bean after copying its attributes
     */
    public VD_Bean cloneVD_Bean(VD_Bean copyBean)
    {
        this.setVD_PREFERRED_NAME(copyBean.getVD_PREFERRED_NAME());
        this.setVD_LONG_NAME(copyBean.getVD_LONG_NAME());
        this.setVD_PREFERRED_DEFINITION(copyBean.getVD_PREFERRED_DEFINITION());
        this.setVD_ASL_NAME(copyBean.getVD_ASL_NAME());
        this.setVD_CONTE_IDSEQ(copyBean.getVD_CONTE_IDSEQ());
        this.setVD_BEGIN_DATE(copyBean.getVD_BEGIN_DATE());
        this.setVD_END_DATE(copyBean.getVD_END_DATE());
        this.setVD_VERSION(copyBean.getVD_VERSION());
        this.setVD_VD_IDSEQ(copyBean.getVD_VD_IDSEQ());
        this.setVD_CHANGE_NOTE(copyBean.getVD_CHANGE_NOTE());
        this.setVD_CONTEXT_NAME(copyBean.getVD_CONTEXT_NAME());
        this.setVD_CD_NAME(copyBean.getVD_CD_NAME());
        this.setVD_CD_IDSEQ(copyBean.getVD_CD_IDSEQ());
        this.setVD_OBJ_CLASS(copyBean.getVD_OBJ_CLASS());
        this.setVD_OBJ_QUAL(copyBean.getVD_OBJ_QUAL());
        this.setVD_PROP_CLASS(copyBean.getVD_PROP_CLASS());
        this.setVD_PROP_QUAL(copyBean.getVD_PROP_QUAL());
        this.setVD_REP_TERM(copyBean.getVD_REP_TERM());
        this.setVD_REP_ASL_NAME(copyBean.getVD_REP_ASL_NAME());
        this.setVD_LANGUAGE(copyBean.getVD_LANGUAGE());
        this.setVD_LANGUAGE_IDSEQ(copyBean.getVD_LANGUAGE_IDSEQ());
        this.setVD_CHAR_SET_NAME(copyBean.getVD_CHAR_SET_NAME());
        this.setVD_DECIMAL_PLACE(copyBean.getVD_DECIMAL_PLACE());
        this.setVD_DATA_TYPE(copyBean.getVD_DATA_TYPE());
        this.setVD_DTL_NAME(copyBean.getVD_DTL_NAME());
        this.setVD_FORML_NAME(copyBean.getVD_FORML_NAME());
        this.setVD_UOML_NAME(copyBean.getVD_UOML_NAME());
        this.setVD_HIGH_VALUE_NUM(copyBean.getVD_HIGH_VALUE_NUM());
        this.setVD_LOW_VALUE_NUM(copyBean.getVD_LOW_VALUE_NUM());
        this.setVD_MAX_LENGTH_NUM(copyBean.getVD_MAX_LENGTH_NUM());
        this.setVD_MIN_LENGTH_NUM(copyBean.getVD_MIN_LENGTH_NUM());
        this.setVD_PV_ID(copyBean.getVD_PV_ID());
        this.setVD_PV_MEANING(copyBean.getVD_PV_MEANING());
        this.setVD_PV_MEANING_DESCRIPTION(copyBean.getVD_PV_MEANING_DESCRIPTION());
        this.setVD_PV_NAME(copyBean.getVD_PV_NAME());
        this.setVD_TYPE_FLAG(copyBean.getVD_TYPE_FLAG());
        this.setVD_PROTOCOL_ID(copyBean.getVD_PROTOCOL_ID());
        this.setVD_CRF_NAME(copyBean.getVD_CRF_NAME());
        this.setVD_TYPE_NAME(copyBean.getVD_TYPE_NAME());
        this.setVD_DES_ALIAS_ID(copyBean.getVD_DES_ALIAS_ID());
        this.setVD_ALIAS_NAME(copyBean.getVD_ALIAS_NAME());
        this.setVD_VD_ID(copyBean.getVD_VD_ID());
        this.setVD_Permissible_Value(copyBean.getVD_Permissible_Value());
        this.setVD_Permissible_Value_Count(copyBean.getVD_Permissible_Value_Count());
        this.setVD_SOURCE(copyBean.getVD_SOURCE());
        this.setVD_USEDBY_CONTEXT(copyBean.getVD_USEDBY_CONTEXT());
        this.setVD_LATEST_VERSION_IND(copyBean.getVD_LATEST_VERSION_IND());
        this.setVD_PV_ORIGIN(copyBean.getVD_PV_ORIGIN());
        this.setVD_OBJ_IDSEQ(copyBean.getVD_OBJ_IDSEQ());
        this.setVD_PROP_IDSEQ(copyBean.getVD_PROP_IDSEQ());
        this.setVD_REP_IDSEQ(copyBean.getVD_REP_IDSEQ());
        this.setVD_Obj_Definition(copyBean.getVD_Obj_Definition());
        this.setVD_Prop_Definition(copyBean.getVD_Prop_Definition());
        this.setVD_Rep_Definition(copyBean.getVD_Rep_Definition());
        this.setVD_DATE_CREATED(copyBean.getVD_DATE_CREATED());
        this.setVD_CREATED_BY(copyBean.getVD_CREATED_BY());
        this.setVD_DATE_MODIFIED(copyBean.getVD_DATE_MODIFIED());
        this.setVD_MODIFIED_BY(copyBean.getVD_MODIFIED_BY());
        this.setAC_SELECTED_CONTEXT_ID(copyBean.getAC_SELECTED_CONTEXT_ID());
        this.setAC_CS_NAME(copyBean.getAC_CS_NAME());
        this.setAC_CS_ID(copyBean.getAC_CS_ID());
        this.setAC_CSI_NAME(copyBean.getAC_CSI_NAME());
        this.setAC_CSI_ID(copyBean.getAC_CSI_ID());
        this.setAC_AC_CSI_VECTOR(copyBean.getAC_AC_CSI_VECTOR());
        this.setAC_AC_CSI_ID(copyBean.getAC_AC_CSI_ID());
        this.setAC_CS_CSI_ID(copyBean.getAC_CS_CSI_ID());
        this.setAC_ALT_NAMES(copyBean.getAC_ALT_NAMES());
        this.setAC_REF_DOCS(copyBean.getAC_REF_DOCS());
        this.setAC_CONCEPT_NAME(copyBean.getAC_CONCEPT_NAME());
        this.setAC_CONTACTS(copyBean.getAC_CONTACTS());
        this.setREFERENCE_DOCUMENT(copyBean.getREFERENCE_DOCUMENT());
        this.setALTERNATE_NAME(copyBean.getALTERNATE_NAME());
        this.setVD_REP_CONCEPT_CODE(copyBean.getVD_REP_CONCEPT_CODE());
        this.setVD_REP_EVS_CUI_ORIGEN(copyBean.getVD_REP_EVS_CUI_ORIGEN());
        this.setVD_REP_EVS_CUI_SOURCE(copyBean.getVD_REP_EVS_CUI_SOURCE());
        this.setVD_REP_DEFINITION_SOURCE(copyBean.getVD_REP_DEFINITION_SOURCE());
        this.setVD_REP_CONDR_IDSEQ(copyBean.getVD_REP_CONDR_IDSEQ());
        this.setVD_PAR_CONDR_IDSEQ(copyBean.getVD_PAR_CONDR_IDSEQ());
        this.setVD_REP_NAME_PRIMARY(copyBean.getVD_REP_NAME_PRIMARY());
        this.setVD_REP_QUALIFIER_NAMES(copyBean.getVD_REP_QUALIFIER_NAMES());
        this.setVD_REP_QUALIFIER_CODES(copyBean.getVD_REP_QUALIFIER_CODES());
        this.setVD_REP_QUALIFIER_DB(copyBean.getVD_REP_QUALIFIER_DB());
        this.setAC_ABBR_PREF_NAME(copyBean.getAC_ABBR_PREF_NAME());
        this.setAC_SYS_PREF_NAME(copyBean.getAC_SYS_PREF_NAME());
        this.setAC_USER_PREF_NAME(copyBean.getAC_USER_PREF_NAME());
        this.setAC_PREF_NAME_TYPE(copyBean.getAC_PREF_NAME_TYPE());
        this.setVDNAME_CHANGED(copyBean.getVDNAME_CHANGED());
        this.setValidateList(copyBean.getValidateList());
        this.setVD_PV_List(copyBean.cloneVDPVVector(copyBean.getVD_PV_List()));
        this.setReferenceConceptList(copyBean.getReferenceConceptList());
        this.setRemoved_VDPVList(copyBean.cloneVDPVVector(copyBean.getRemoved_VDPVList()));
        return this;
    }

    /**
     * @param vdpvs
     *            PVBEan vector to make copy from
     * @return VEctor pvbean to return back
     */
    public Vector<PV_Bean> cloneVDPVVector(Vector<PV_Bean> vdpvs)
    {
        Vector<PV_Bean> cloneVDPV = new Vector<PV_Bean>();
        for (int i = 0; i < vdpvs.size(); i++)
        {
            PV_Bean pv = new PV_Bean().copyBean((PV_Bean) vdpvs.elementAt(i));
            cloneVDPV.addElement(pv);
        }
        return cloneVDPV;
    }

    // Set Properties
    /**
     * The setRETURN_CODE method sets the RETURN_CODE for this bean.
     * 
     * @param s
     *            The RETURN_CODE to set
     */
    public void setRETURN_CODE(String s)
    {
        this.RETURN_CODE = s;
    }

    /**
     * The setVD_VD_IDSEQ method sets the VD_VD_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_VD_IDSEQ to set
     */
    public void setVD_VD_IDSEQ(String s)
    {
        this.VD_VD_IDSEQ = s;
    }

    /**
     * The setVD_PREFERRED_NAME method sets the VD_PREFERRED_NAME for this bean.
     * 
     * @param s
     *            The VD_PREFERRED_NAME to set
     */
    public void setVD_PREFERRED_NAME(String s)
    {
        this.VD_PREFERRED_NAME = s;
    }

    /**
     * The setVD_CONTE_IDSEQ method sets the VD_CONTE_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_CONTE_IDSEQ to set
     */
    public void setVD_CONTE_IDSEQ(String s)
    {
        this.VD_CONTE_IDSEQ = s;
    }

    /**
     * The setVD_VERSION method sets the VD_VERSION for this bean.
     * 
     * @param s
     *            The VD_VERSION to set
     */
    public void setVD_VERSION(String s)
    {
        this.VD_VERSION = s;
    }

    /**
     * The setVD_PREFERRED_DEFINITION method sets the VD_PREFERRED_DEFINITION for this bean.
     * 
     * @param s
     *            The VD_PREFERRED_DEFINITION to set
     */
    public void setVD_PREFERRED_DEFINITION(String s)
    {
        this.VD_PREFERRED_DEFINITION = s;
    }

    /**
     * The setVD_CD_IDSEQ method sets the VD_CD_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_CD_IDSEQ to set
     */
    public void setVD_CD_IDSEQ(String s)
    {
        this.VD_CD_IDSEQ = s;
    }

    /**
     * The setVD_ASL_NAME method sets the VD_ASL_NAME for this bean.
     * 
     * @param s
     *            The VD_ASL_NAME to set
     */
    public void setVD_ASL_NAME(String s)
    {
        this.VD_ASL_NAME = s;
    }

    /**
     * The setVD_LATEST_VERSION_IND method sets the VD_LATEST_VERSION_IND for this bean.
     * 
     * @param s
     *            The VD_LATEST_VERSION_IND to set
     */
    public void setVD_LATEST_VERSION_IND(String s)
    {
        this.VD_LATEST_VERSION_IND = s;
    }

    /**
     * The setVD_DTL_NAME method sets the VD_DTL_NAME for this bean.
     * 
     * @param s
     *            The VD_DTL_NAME to set
     */
    public void setVD_DTL_NAME(String s)
    {
        this.VD_DTL_NAME = s;
    }

    /**
     * The setVD_MAX_LENGTH_NUM method sets the VD_MAX_LENGTH_NUM for this bean.
     * 
     * @param s
     *            The VD_MAX_LENGTH_NUM to set
     */
    public void setVD_MAX_LENGTH_NUM(String s)
    {
        this.VD_MAX_LENGTH_NUM = s;
    }

    /**
     * The setVD_LONG_NAME method sets the VD_LONG_NAME for this bean.
     * 
     * @param s
     *            The VD_LONG_NAME to set
     */
    public void setVD_LONG_NAME(String s)
    {
        this.VD_LONG_NAME = s;
    }

    /**
     * The setVD_FORML_NAME method sets the VD_FORML_NAME for this bean.
     * 
     * @param s
     *            The VD_FORML_NAME to set
     */
    public void setVD_FORML_NAME(String s)
    {
        this.VD_FORML_NAME = s;
    }

    /**
     * The setVD_FORML_DESCRIPTION method sets the VD_FORML_DESCRIPTION for this bean.
     * 
     * @param s
     *            The VD_FORML_DESCRIPTION to set
     */
    public void setVD_FORML_DESCRIPTION(String s)
    {
        this.VD_FORML_DESCRIPTION = s;
    }

    /**
     * The setVD_FORML_COMMENT method sets the VD_FORML_COMMENT for this bean.
     * 
     * @param s
     *            The VD_FORML_COMMENT to set
     */
    public void setVD_FORML_COMMENT(String s)
    {
        this.VD_FORML_COMMENT = s;
    }

    /**
     * The setVD_UOML_NAME method sets the VD_UOML_NAME for this bean.
     * 
     * @param s
     *            The VD_UOML_NAME to set
     */
    public void setVD_UOML_NAME(String s)
    {
        this.VD_UOML_NAME = s;
    }

    /**
     * The setVD_UOML_DESCRIPTION method sets the VD_UOML_DESCRIPTION for this bean.
     * 
     * @param s
     *            The VD_UOML_DESCRIPTION to set
     */
    public void setVD_UOML_DESCRIPTION(String s)
    {
        this.VD_UOML_DESCRIPTION = s;
    }

    /**
     * The setVD_UOML_COMMENT method sets the VD_UOML_COMMENT for this bean.
     * 
     * @param s
     *            The VD_UOML_COMMENT to set
     */
    public void setVD_UOML_COMMENT(String s)
    {
        this.VD_UOML_COMMENT = s;
    }

    /**
     * The setVD_LOW_VALUE_NUM method sets the VD_LOW_VALUE_NUM for this bean.
     * 
     * @param s
     *            The VD_LOW_VALUE_NUM to set
     */
    public void setVD_LOW_VALUE_NUM(String s)
    {
        this.VD_LOW_VALUE_NUM = s;
    }

    /**
     * The setVD_HIGH_VALUE_NUM method sets the VD_HIGH_VALUE_NUM for this bean.
     * 
     * @param s
     *            The VD_HIGH_VALUE_NUM to set
     */
    public void setVD_HIGH_VALUE_NUM(String s)
    {
        this.VD_HIGH_VALUE_NUM = s;
    }

    /**
     * The setVD_MIN_LENGTH_NUM method sets the VD_MIN_LENGTH_NUM for this bean.
     * 
     * @param s
     *            The VD_MIN_LENGTH_NUM to set
     */
    public void setVD_MIN_LENGTH_NUM(String s)
    {
        this.VD_MIN_LENGTH_NUM = s;
    }

    /**
     * The setVD_DECIMAL_PLACE method sets the VD_DECIMAL_PLACE for this bean.
     * 
     * @param s
     *            The VD_DECIMAL_PLACE to set
     */
    public void setVD_DECIMAL_PLACE(String s)
    {
        this.VD_DECIMAL_PLACE = s;
    }

    /**
     * The setVD_CHAR_SET_NAME method sets the VD_CHAR_SET_NAME for this bean.
     * 
     * @param s
     *            The VD_CHAR_SET_NAME to set
     */
    public void setVD_CHAR_SET_NAME(String s)
    {
        this.VD_CHAR_SET_NAME = s;
    }

    /**
     * The setVD_BEGIN_DATE method sets the VD_BEGIN_DATE for this bean.
     * 
     * @param s
     *            The VD_BEGIN_DATE to set
     */
    public void setVD_BEGIN_DATE(String s)
    {
        this.VD_BEGIN_DATE = s;
    }

    /**
     * The setVD_END_DATE method sets the VD_END_DATE for this bean.
     * 
     * @param s
     *            The VD_END_DATE to set
     */
    public void setVD_END_DATE(String s)
    {
        this.VD_END_DATE = s;
    }

    /**
     * The setVD_CHANGE_NOTE method sets the VD_CHANGE_NOTE for this bean.
     * 
     * @param s
     *            The VD_CHANGE_NOTE to set
     */
    public void setVD_CHANGE_NOTE(String s)
    {
        this.VD_CHANGE_NOTE = s;
    }

    /**
     * The setVD_TYPE_FLAG method sets the VD_TYPE_FLAG for this bean.
     * 
     * @param s
     *            The VD_TYPE_FLAG to set
     */
    public void setVD_TYPE_FLAG(String s)
    {
        this.VD_TYPE_FLAG = s;
    }

    /**
     * The setVD_CREATED_BY method sets the VD_CREATED_BY for this bean.
     * 
     * @param s
     *            The VD_CREATED_BY to set
     */
    public void setVD_CREATED_BY(String s)
    {
        this.VD_CREATED_BY = s;
    }

    /**
     * The setVD_DATE_CREATED method sets the VD_DATE_CREATED for this bean.
     * 
     * @param s
     *            The VD_DATE_CREATED to set
     */
    public void setVD_DATE_CREATED(String s)
    {
        this.VD_DATE_CREATED = s;
    }

    /**
     * The setVD_MODIFIED_BY method sets the VD_MODIFIED_BY for this bean.
     * 
     * @param s
     *            The VD_MODIFIED_BY to set
     */
    public void setVD_MODIFIED_BY(String s)
    {
        this.VD_MODIFIED_BY = s;
    }

    /**
     * The setVD_DATE_MODIFIED method sets the VD_DATE_MODIFIED for this bean.
     * 
     * @param s
     *            The VD_DATE_MODIFIED to set
     */
    public void setVD_DATE_MODIFIED(String s)
    {
        this.VD_DATE_MODIFIED = s;
    }

    /**
     * The setVD_DELETED_IND method sets the VD_DELETED_IND for this bean.
     * 
     * @param s
     *            The VD_DELETED_IND to set
     */
    public void setVD_DELETED_IND(String s)
    {
        this.VD_DELETED_IND = s;
    }

    // Not required by SET_VD
    /**
     * The setVD_CONTEXT_NAME method sets the VD_CONTEXT_NAME for this bean.
     * 
     * @param s
     *            The VD_CONTEXT_NAME to set
     */
    public void setVD_CONTEXT_NAME(String s)
    {
        this.VD_CONTEXT_NAME = s;
    }

    /**
     * The setVD_CD_NAME method sets the VD_CD_NAME for this bean.
     * 
     * @param s
     *            The VD_CD_NAME to set
     */
    public void setVD_CD_NAME(String s)
    {
        this.VD_CD_NAME = s;
    }

    /**
     * The setVD_LANGUAGE method sets the VD_LANGUAGE for this bean.
     * 
     * @param s
     *            The VD_LANGUAGE to set
     */
    public void setVD_LANGUAGE(String s)
    {
        this.VD_LANGUAGE = s;
    }

    /**
     * The setVD_LANGUAGE_IDSEQ method sets the VD_LANGUAGE_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_LANGUAGE_IDSEQ to set
     */
    public void setVD_LANGUAGE_IDSEQ(String s)
    {
        this.VD_LANGUAGE_IDSEQ = s;
    }

    /**
     * The setVD_DATA_TYPE method sets the VD_DATA_TYPE for this bean.
     * 
     * @param s
     *            The VD_DATA_TYPE to set
     */
    public void setVD_DATA_TYPE(String s)
    {
        this.VD_DATA_TYPE = s;
    }

    /**
     * The setVD_PV_ID method sets the VD_PV_ID for this bean.
     * 
     * @param v
     *            VEctor to set
     */
    public void setVD_PV_ID(Vector v)
    {
        this.VD_PV_ID = v;
    }

    /**
     * The setVD_PV_NAME method sets the VD_PV_NAME for this bean.
     * 
     * @param v
     *            VEctor to set
     */
    public void setVD_PV_NAME(Vector v)
    {
        this.VD_PV_NAME = v;
    }

    /**
     * The setVD_PV_MEANING method sets the VD_PV_MEANING for this bean.
     * 
     * @param v
     *            VEctor to set
     */
    public void setVD_PV_MEANING(Vector v)
    {
        this.VD_PV_MEANING = v;
    }

    /**
     * The setVD_PV_MEANING_DESCRIPTION method sets the VD_PV_MEANING_DESCRIPTION for this bean.
     * 
     * @param v
     *            The VD_PV_MEANING_DESCRIPTION to set
     */
    public void setVD_PV_MEANING_DESCRIPTION(Vector v)
    {
        this.VD_PV_MEANING_DESCRIPTION = v;
    }

    /**
     * The setVD_PV_ORIGIN method sets the VD_PV_ORIGIN for this bean.
     * 
     * @param v
     *            The VD_PV_ORIGIN to set
     */
    public void setVD_PV_ORIGIN(Vector v)
    {
        this.VD_PV_ORIGIN = v;
    }

    /**
     * The setVD_OBJ_QUAL method sets the VD_OBJ_QUAL for this bean.
     * 
     * @param s
     *            The VD_OBJ_QUAL to set
     */
    public void setVD_OBJ_QUAL(String s)
    {
        this.VD_OBJ_QUAL = s;
    }

    /**
     * The setVD_OBJ_CLASS method sets the VD_OBJ_CLASS for this bean.
     * 
     * @param s
     *            The VD_OBJ_CLASS to set
     */
    public void setVD_OBJ_CLASS(String s)
    {
        this.VD_OBJ_CLASS = s;
    }

    /**
     * The setVD_OBJ_IDSEQ method sets the VD_OBJ_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_OBJ_IDSEQ to set
     */
    public void setVD_OBJ_IDSEQ(String s)
    {
        this.VD_OBJ_IDSEQ = s;
    }

    /**
     * The setVD_PROP_QUAL method sets the VD_PROP_QUAL for this bean.
     * 
     * @param s
     *            The VD_PROP_QUAL to set
     */
    public void setVD_PROP_QUAL(String s)
    {
        this.VD_PROP_QUAL = s;
    }

    /**
     * The setVD_PROP_CLASS method sets the VD_PROP_CLASS for this bean.
     * 
     * @param s
     *            The VD_PROP_CLASS to set
     */
    public void setVD_PROP_CLASS(String s)
    {
        this.VD_PROP_CLASS = s;
    }

    /**
     * The setVD_PROP_IDSEQ method sets the VD_PROP_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_PROP_IDSEQ to set
     */
    public void setVD_PROP_IDSEQ(String s)
    {
        this.VD_PROP_IDSEQ = s;
    }

    /**
     * The setVD_REP_ASL_NAME method sets the VD_REP_ASL_NAME for this bean.
     * 
     * @param s
     *            The VD_REP_ASL_NAME to set
     */
    public void setVD_REP_ASL_NAME(String s)
    {
        this.VD_REP_ASL_NAME = s;
    }

    /**
     * The setVD_REP_TERM method sets the VD_REP_TERM for this bean.
     * 
     * @param s
     *            The VD_REP_TERM to set
     */
    public void setVD_REP_TERM(String s)
    {
        this.VD_REP_TERM = s;
    }

    /**
     * The setVD_REP_IDSEQ method sets the VD_REP_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_REP_IDSEQ to set
     */
    public void setVD_REP_IDSEQ(String s)
    {
        this.VD_REP_IDSEQ = s;
    }

    /**
     * The setVD_PROTOCOL_ID method sets the VD_PROTOCOL_ID for this bean.
     * 
     * @param s
     *            The VD_PROTOCOL_ID to set
     */
    public void setVD_PROTOCOL_ID(String s)
    {
        this.VD_PROTOCOL_ID = s;
    }

    /**
     * The setVD_CRF_NAME method sets the VD_CRF_NAME for this bean.
     * 
     * @param s
     *            The VD_CRF_NAME to set
     */
    public void setVD_CRF_NAME(String s)
    {
        this.VD_CRF_NAME = s;
    }

    /**
     * The setVD_TYPE_NAME method sets the VD_TYPE_NAME for this bean.
     * 
     * @param s
     *            The VD_TYPE_NAME to set
     */
    public void setVD_TYPE_NAME(String s)
    {
        this.VD_TYPE_NAME = s;
    }

    /**
     * The setVD_DES_ALIAS_ID method sets the VD_DES_ALIAS_ID for this bean.
     * 
     * @param s
     *            The VD_DES_ALIAS_ID to set
     */
    public void setVD_DES_ALIAS_ID(String s)
    {
        this.VD_DES_ALIAS_ID = s;
    }

    /**
     * The setVD_ALIAS_NAME method sets the VD_ALIAS_NAME for this bean.
     * 
     * @param s
     *            The VD_ALIAS_NAME to set
     */
    public void setVD_ALIAS_NAME(String s)
    {
        this.VD_ALIAS_NAME = s;
    }

    /**
     * The setVD_USEDBY_CONTEXT method sets the VD_USEDBY_CONTEXT for this bean.
     * 
     * @param s
     *            The VD_USEDBY_CONTEXT to set
     */
    public void setVD_USEDBY_CONTEXT(String s)
    {
        this.VD_USEDBY_CONTEXT = s;
    }

    /**
     * The setVD_Obj_Definition method sets the VD_Obj_Definition for this bean.
     * 
     * @param s
     *            The VD_Obj_Definition to set
     */
    public void setVD_Obj_Definition(String s)
    {
        this.VD_Obj_Definition = s;
    }

    /**
     * The setVD_Prop_Definition method sets the VD_Prop_Definition for this bean.
     * 
     * @param s
     *            The VD_Prop_Definition to set
     */
    public void setVD_Prop_Definition(String s)
    {
        this.VD_Prop_Definition = s;
    }

    /**
     * The setVD_Rep_Definition method sets the VD_Rep_Definition for this bean.
     * 
     * @param s
     *            The VD_Rep_Definition to set
     */
    public void setVD_Rep_Definition(String s)
    {
        this.VD_Rep_Definition = s;
    }

    /**
     * The setVD_VD_ID method sets the VD_VD_ID for this bean.
     * 
     * @param s
     *            The VD_VD_ID to set
     */
    public void setVD_VD_ID(String s)
    {
        this.VD_VD_ID = s;
    }

    /**
     * The setVD_Permissible_Value method sets the VD_Permissible_Value for this bean.
     * 
     * @param s
     *            The VD_Permissible_Value to set
     */
    public void setVD_Permissible_Value(String s)
    {
        this.VD_Permissible_Value = s;
    }

    /**
     * The setVD_Permissible_Value method_Count sets the VD_Permissible_Value_Count for this bean.
     * 
     * @param i
     *            The VD_Permissible_Value_Count to set
     */
    public void setVD_Permissible_Value_Count(Integer i)
    {
        this.VD_Permissible_Value_Count = i;
    }

    /**
     * The setVD_SOURCE method sets the VD_SOURCE for this bean.
     * 
     * @param s
     *            The VD_SOURCE to set
     */
    public void setVD_SOURCE(String s)
    {
        this.VD_SOURCE = s;
    }

    /**
     * The setVD_CHECKED method sets the VD_CHECKED for this bean.
     * 
     * @param b
     *            The VD_CHECKED to set
     */
    public void setVD_CHECKED(boolean b)
    {
        this.VD_CHECKED = b;
    }

    /**
     * The setAC_SELECTED_CONTEXT_ID method sets the VD_SELECTED_CONTEXT_ID for this bean.
     * 
     * @param s
     *            The VD_SELECTED_CONTEXT_ID to set
     */
    public void setAC_SELECTED_CONTEXT_ID(Vector s)
    {
        this.VD_SELECTED_CONTEXT_ID = s;
    }

    /**
     * The setAC_CS method sets the VD_CS for this bean.
     * 
     * @param v
     *            The VD_CS to set
     */
    public void setAC_CS_NAME(Vector v)
    {
        this.VD_CS_NAME = v;
    }

    /**
     * The setAC_CS_ID method sets the VD_CS_ID for this bean.
     * 
     * @param v
     *            The VD_CS_ID to set
     */
    public void setAC_CS_ID(Vector v)
    {
        this.VD_CS_ID = v;
    }

    /**
     * The setAC_CSI method sets the VD_CSI for this bean.
     * 
     * @param v
     *            The VD_CSI to set
     */
    public void setAC_CSI_NAME(Vector v)
    {
        this.VD_CSI_NAME = v;
    }

    /**
     * The setAC_CSI_ID method sets the VD_CSI_ID for this bean.
     * 
     * @param v
     *            The VD_CSI_ID to set
     */
    public void setAC_CSI_ID(Vector v)
    {
        this.VD_CSI_ID = v;
    }

    /**
     * The setAC_AC_CSI_VECTOR method sets the VD_AC_CSI_VECTOR for this bean.
     * 
     * @param v
     *            The VD_AC_CSI_VECTOR to set
     */
    public void setAC_AC_CSI_VECTOR(Vector v)
    {
        this.VD_AC_CSI_VECTOR = v;
    }

    /**
     * The setAC_AC_CSI_ID method sets the VD_AC_CSI_ID for this bean.
     * 
     * @param v
     *            The VD_AC_CSI_ID to set
     */
    public void setAC_AC_CSI_ID(Vector v)
    {
        this.VD_AC_CSI_ID = v;
    }

    /**
     * The setAC_CS_CSI_ID method sets the VD_CS_CSI_ID for this bean.
     * 
     * @param v
     *            The VD_CS_CSI_ID to set
     */
    public void setAC_CS_CSI_ID(Vector v)
    {
        this.VD_CS_CSI_ID = v;
    }

    /**
     * The setAC_ALT_NAMES method sets the AC_ALT_NAMES for this bean.
     * 
     * @param v
     *            The AC_ALT_NAMES to set
     */
    public void setAC_ALT_NAMES(Vector v)
    {
        this.AC_ALT_NAMES = v;
    }

    /**
     * The setAC_REF_DOCS method sets the AC_REF_DOCS for this bean.
     * 
     * @param v
     *            The AC_REF_DOCS to set
     */
    public void setAC_REF_DOCS(Vector v)
    {
        this.AC_REF_DOCS = v;
    }

    /**
     * The setAC_CONCEPT_NAME method sets the AC_CONCEPT_NAME for this bean.
     * 
     * @param s
     *            The AC_CONCEPT_NAME to set
     */
    public void setAC_CONCEPT_NAME(String s)
    {
        this.AC_CONCEPT_NAME = s;
    }

    /**
     * @param ac_contacts
     *            The aC_CONTACTS to set.
     */
    public void setAC_CONTACTS(Hashtable ac_contacts)
    {
        AC_CONTACTS = ac_contacts;
    }

    /**
     * The setREFERENCE_DOCUMENT_ method sets the REFERENCE_DOCUMENT for this bean.
     * 
     * @param s
     *            The REFERENCE_DOCUMENT to set
     */
    public void setREFERENCE_DOCUMENT(String s)
    {
        this.REFERENCE_DOCUMENT = s;
    }

    /**
     * @param alternate_name
     *            The aLTERNATE_NAME to set.
     */
    public void setALTERNATE_NAME(String alternate_name)
    {
        ALTERNATE_NAME = alternate_name;
    }

    /**
     * The setVD_REP_CONCEPT_CODE method sets the VD_REP_CONCEPT_CODE for this bean.
     * 
     * @param s
     *            The VD_REP_CONCEPT_CODE to set
     */
    public void setVD_REP_CONCEPT_CODE(String s)
    {
        this.VD_REP_CONCEPT_CODE = s;
    }

    /**
     * The setVD_REP_EVS_CUI_ORIGEN method sets the VD_REP_EVS_CUI_ORIGEN for this bean.
     * 
     * @param s
     *            The VD_EVS_CUI_ORIGEN to set
     */
    public void setVD_REP_EVS_CUI_ORIGEN(String s)
    {
        this.VD_REP_EVS_CUI_ORIGEN = s;
    }

    /**
     * The setVD_REP_EVS_CUI_SOURCE method sets the VD_REP_EVS_CUI_SOURCE for this bean.
     * 
     * @param s
     *            The VD_REP_EVS_CUI_SOURCE to set
     */
    public void setVD_REP_EVS_CUI_SOURCE(String s)
    {
        this.VD_REP_EVS_CUI_SOURCE = s;
    }

    /**
     * The setVD_REP_DEFINITION_SOURCE method sets the VD_REP_DEFINITION_SOURCE for this bean.
     * 
     * @param s
     *            The VD_REP_DEFINITION_SOURCE to set
     */
    public void setVD_REP_DEFINITION_SOURCE(String s)
    {
        this.VD_REP_DEFINITION_SOURCE = s;
    }

    /**
     * The setVD_REP_ASL_NAME_CONCEPT_CODE method sets the VD_REP_QUAL_CONCEPT_CODE for this bean.
     * 
     * @param s
     *            The VD_REP_QUAL_CONCEPT_CODE to set
     */
    public void setVD_REP_QUAL_CONCEPT_CODE(String s)
    {
        this.VD_REP_QUAL_CONCEPT_CODE = s;
    }

    /**
     * The setVD_REP_QUAL_EVS_CUI_ORIGEN method sets the VD_REP_QUAL_EVS_CUI_ORIGEN for this bean.
     * 
     * @param s
     *            The VD_REP_QUAL_EVS_CUI_ORIGEN to set
     */
    public void setVD_REP_QUAL_EVS_CUI_ORIGEN(String s)
    {
        this.VD_REP_EVS_CUI_ORIGEN = s;
    }

    /**
     * The setVD_REP_QUAL_EVS_CUI_SOURCE method sets the VD_REP_QUAL_EVS_CUI_SOURCE for this bean.
     * 
     * @param s
     *            The VD_REP_QUAL_EVS_CUI_SOURCE to set
     */
    public void setVD_REP_QUAL_EVS_CUI_SOURCE(String s)
    {
        this.VD_REP_QUAL_EVS_CUI_SOURCE = s;
    }

    /**
     * The setVD_REP_QUAL_DEFINITION_SOURCE method sets the VD_REP_QUAL_DEFINITION_SOURCE for this bean.
     * 
     * @param s
     *            The VD_REP_QUAL_DEFINITION_SOURCE to set
     */
    public void setVD_REP_QUAL_DEFINITION_SOURCE(String s)
    {
        this.VD_REP_QUAL_DEFINITION_SOURCE = s;
    }

    /**
     * The setVD_PARENT_CODES method sets the VD_PARENT_CODES for this bean.
     * 
     * @param v
     *            The VD_PARENT_CODES to set
     */
    public void setVD_PARENT_CODES(Vector v)
    {
        this.VD_PARENT_CODES = v;
    }

    /**
     * The setVD_PARENT_NAMES method sets the VD_PARENT_NAMES for this bean.
     * 
     * @param v
     *            The VD_PARENT_NAMES to set
     */
    public void setVD_PARENT_NAMES(Vector v)
    {
        this.VD_PARENT_NAMES = v;
    }

    /**
     * The setVD_PARENT_META_SOURCE method sets the VD_PARENT_META_SOURCE for this bean.
     * 
     * @param v
     *            The VD_PARENT_META_SOURCE to set
     */
    public void setVD_PARENT_META_SOURCE(Vector v)
    {
        this.VD_PARENT_META_SOURCE = v;
    }

    /**
     * The setVD_PARENT_DB method sets the VD_PARENT_DB for this bean.
     * 
     * @param v
     *            The VD_PARENT_DB to set
     */
    public void setVD_PARENT_DB(Vector v)
    {
        this.VD_PARENT_DB = v;
    }

    /**
     * The setVD_PARENT_LIST method sets the VD_PARENT_LIST for this bean.
     * 
     * @param v
     *            The VD_PARENT_LIST to set
     */
    public void setVD_PARENT_LIST(Vector v)
    {
        this.VD_PARENT_LIST = v;
    }

    /**
     * The setVD_REP_CONDR_IDSEQ method sets the VD_REP_CONDR_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_REP_CONDR_IDSEQ to set
     */
    public void setVD_REP_CONDR_IDSEQ(String s)
    {
        this.VD_REP_CONDR_IDSEQ = s;
    }

    /**
     * The setVD_PAR_CONDR_IDSEQ method sets the VD_PAR_CONDR_IDSEQ for this bean.
     * 
     * @param s
     *            The VD_PAR_CONDR_IDSEQ to set
     */
    public void setVD_PAR_CONDR_IDSEQ(String s)
    {
        this.VD_PAR_CONDR_IDSEQ = s;
    }

    /**
     * The setVD_REP_NAME_PRIMARY method sets the VD_REP_NAME_PRIMARY for this bean.
     * 
     * @param s
     *            The VD_REP_NAME_PRIMARY to set
     */
    public void setVD_REP_NAME_PRIMARY(String s)
    {
        this.VD_REP_NAME_PRIMARY = s;
    }

    /**
     * The setVD_REP_QUALIFIER_NAMES method sets the VD_REP_QUALIFIER_NAMES for this bean.
     * 
     * @param v
     *            The VD_REP_QUALIFIER_NAMES to set
     */
    public void setVD_REP_QUALIFIER_NAMES(Vector v)
    {
        this.VD_REP_QUALIFIER_NAMES = v;
    }

    /**
     * The setVD_REP_QUALIFIER_CODES method sets the VD_REP_QUALIFIER_CODES for this bean.
     * 
     * @param v
     *            The VD_REP_QUALIFIER_CODES to set
     */
    public void setVD_REP_QUALIFIER_CODES(Vector v)
    {
        this.VD_REP_QUALIFIER_CODES = v;
    }

    /**
     * The setVD_REP_QUALIFIER_DB method sets the VD_REP_QUALIFIER_DB for this bean.
     * 
     * @param v
     *            The VD_REP_QUALIFIER_DB to set
     */
    public void setVD_REP_QUALIFIER_DB(Vector v)
    {
        this.VD_REP_QUALIFIER_DB = v;
    }

    /**
     * The setAC_SYS_PREF_NAME method sets the AC_SYS_PREF_NAME for this bean.
     * 
     * @param s
     *            The AC_SYS_PREF_NAME to set
     */
    public void setAC_SYS_PREF_NAME(String s)
    {
        this.AC_SYS_PREF_NAME = s;
    }

    /**
     * The setAC_ABBR_PREF_NAME method sets the AC_ABBR_PREF_NAME for this bean.
     * 
     * @param s
     *            The AC_ABBR_PREF_NAME to set
     */
    public void setAC_ABBR_PREF_NAME(String s)
    {
        this.AC_ABBR_PREF_NAME = s;
    }

    /**
     * The setAC_USER_PREF_NAME method sets the AC_USER_PREF_NAME for this bean.
     * 
     * @param s
     *            The AC_USER_PREF_NAME to set
     */
    public void setAC_USER_PREF_NAME(String s)
    {
        this.AC_USER_PREF_NAME = s;
    }

    /**
     * The setAC_PREF_NAME_TYPE method sets the AC_PREF_NAME_TYPE for this bean.
     * 
     * @param s
     *            The AC_PREF_NAME_TYPE to set
     */
    public void setAC_PREF_NAME_TYPE(String s)
    {
        this.AC_PREF_NAME_TYPE = s;
    }

    /**
     * The setVDNAME_CHANGED method sets the VDNAME_CHANGED for this bean.
     * 
     * @param b
     *            The VDNAME_CHANGED to set
     */
    public void setVDNAME_CHANGED(boolean b)
    {
        this.VDNAME_CHANGED = b;
    }

    // Get Properties
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
     * The getVD_VD_IDSEQ method returns the VD_VD_IDSEQ for this bean.
     * 
     * @return String The VD_VD_IDSEQ
     */
    public String getVD_VD_IDSEQ()
    {
        return this.VD_VD_IDSEQ;
    }

    /**
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getIDSEQ()
     */
    public String getIDSEQ()
    {
        return getVD_VD_IDSEQ();
    }

    /**
     * The getVD_PREFERRED_NAME method returns the VD_PREFERRED_NAME for this bean.
     * 
     * @return String The VD_PREFERRED_NAME
     */
    public String getVD_PREFERRED_NAME()
    {
        return this.VD_PREFERRED_NAME;
    }

    /**
     * The getVD_CONTE_IDSEQ method returns the VD_CONTE_IDSEQ for this bean.
     * 
     * @return String The VD_CONTE_IDSEQ
     */
    public String getVD_CONTE_IDSEQ()
    {
        return this.VD_CONTE_IDSEQ;
    }

    /**
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getContextIDSEQ()
     */
    @Override
    public String getContextIDSEQ()
    {
        return getVD_CONTE_IDSEQ();
    }

    /**
     * The getVD_VERSION method returns the VD_VERSION for this bean.
     * 
     * @return String The VD_VERSION
     */
    public String getVD_VERSION()
    {
        return this.VD_VERSION;
    }

    /**
     * The getVD_PREFERRED_DEFINITION method returns the VD_PREFERRED_DEFINITION for this bean.
     * 
     * @return String The VD_PREFERRED_DEFINITION
     */
    public String getVD_PREFERRED_DEFINITION()
    {
        return this.VD_PREFERRED_DEFINITION;
    }

    /**
     * The getVD_CD_IDSEQ method returns the VD_CD_IDSEQ for this bean.
     * 
     * @return String The VD_CD_IDSEQ
     */
    public String getVD_CD_IDSEQ()
    {
        return this.VD_CD_IDSEQ;
    }

    /**
     * The getVD_ASL_NAME method returns the VD_ASL_NAME for this bean.
     * 
     * @return String The VD_ASL_NAME
     */
    public String getVD_ASL_NAME()
    {
        return this.VD_ASL_NAME;
    }

    /**
     * The getVD_LATEST_VERSION_IND method returns the VD_LATEST_VERSION_IND for this bean.
     * 
     * @return String The VD_LATEST_VERSION_IND
     */
    public String getVD_LATEST_VERSION_IND()
    {
        return this.VD_LATEST_VERSION_IND;
    }

    /**
     * The getVD_DTL_NAME method returns the VD_DTL_NAME for this bean.
     * 
     * @return String The VD_DTL_NAME
     */
    public String getVD_DTL_NAME()
    {
        return this.VD_DTL_NAME;
    }

    /**
     * The getVD_MAX_LENGTH_NUM method returns the VD_MAX_LENGTH_NUM for this bean.
     * 
     * @return String The VD_MAX_LENGTH_NUM
     */
    public String getVD_MAX_LENGTH_NUM()
    {
        return this.VD_MAX_LENGTH_NUM;
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
     * The getVD_FORML_NAME method returns the VD_FORML_NAME for this bean.
     * 
     * @return String The VD_FORML_NAME
     */
    public String getVD_FORML_NAME()
    {
        return this.VD_FORML_NAME;
    }

    /**
     * The getVD_FORML_DESCRIPTION method returns the VD_FORML_DESCRIPTION for this bean.
     * 
     * @return String The VD_FORML_DESCRIPTION
     */
    public String getVD_FORML_DESCRIPTION()
    {
        return this.VD_FORML_DESCRIPTION;
    }

    /**
     * The getVD_FORML_COMMENT method returns the VD_FORML_COMMENT for this bean.
     * 
     * @return String The VD_FORML_COMMENT
     */
    public String getVD_FORML_COMMENT()
    {
        return this.VD_FORML_COMMENT;
    }

    /**
     * The getVD_UOML_NAME method returns the VD_UOML_NAME for this bean.
     * 
     * @return String The VD_UOML_NAME
     */
    public String getVD_UOML_NAME()
    {
        return this.VD_UOML_NAME;
    }

    /**
     * The getVD_UOML_DESCRIPTION method returns the VD_UOML_DESCRIPTION for this bean.
     * 
     * @return String The VD_UOML_DESCRIPTION
     */
    public String getVD_UOML_DESCRIPTION()
    {
        return this.VD_UOML_DESCRIPTION;
    }

    /**
     * The getVD_UOML_COMMENT method returns the VD_UOML_COMMENT for this bean.
     * 
     * @return String The VD_UOML_COMMENT
     */
    public String getVD_UOML_COMMENT()
    {
        return this.VD_UOML_COMMENT;
    }

    /**
     * The getVD_LOW_VALUE_NUM method returns the VD_LOW_VALUE_NUM for this bean.
     * 
     * @return String The VD_LOW_VALUE_NUM
     */
    public String getVD_LOW_VALUE_NUM()
    {
        return this.VD_LOW_VALUE_NUM;
    }

    /**
     * The getVD_HIGH_VALUE_NUM method returns the VD_HIGH_VALUE_NUM for this bean.
     * 
     * @return String The VD_HIGH_VALUE_NUM
     */
    public String getVD_HIGH_VALUE_NUM()
    {
        return this.VD_HIGH_VALUE_NUM;
    }

    /**
     * The getVD_MIN_LENGTH_NUM method returns the VD_MIN_LENGTH_NUM for this bean.
     * 
     * @return String The VD_MIN_LENGTH_NUM
     */
    public String getVD_MIN_LENGTH_NUM()
    {
        return this.VD_MIN_LENGTH_NUM;
    }

    /**
     * The getVD_DECIMAL_PLACE method returns the VD_DECIMAL_PLACE for this bean.
     * 
     * @return String The VD_DECIMAL_PLACE
     */
    public String getVD_DECIMAL_PLACE()
    {
        return this.VD_DECIMAL_PLACE;
    }

    /**
     * The getVD_CHAR_SET_NAME method returns the VD_CHAR_SET_NAME for this bean.
     * 
     * @return String The VD_CHAR_SET_NAME
     */
    public String getVD_CHAR_SET_NAME()
    {
        return this.VD_CHAR_SET_NAME;
    }

    /**
     * The getVD_BEGIN_DATE method returns the VD_BEGIN_DATE for this bean.
     * 
     * @return String The VD_BEGIN_DATE
     */
    public String getVD_BEGIN_DATE()
    {
        return this.VD_BEGIN_DATE;
    }

    /**
     * The getVD_END_DATE method returns the VD_END_DATE for this bean.
     * 
     * @return String The VD_END_DATE
     */
    public String getVD_END_DATE()
    {
        return this.VD_END_DATE;
    }

    /**
     * The getVD_CHANGE_NOTE method returns the VD_CHANGE_NOTE for this bean.
     * 
     * @return String The VD_CHANGE_NOTE
     */
    public String getVD_CHANGE_NOTE()
    {
        return this.VD_CHANGE_NOTE;
    }

    /**
     * The getVD_TYPE_FLAG method returns the VD_TYPE_FLAG for this bean.
     * 
     * @return String The VD_TYPE_FLAG
     */
    public String getVD_TYPE_FLAG()
    {
        return (VD_TYPE_FLAG == null) ? "" : this.VD_TYPE_FLAG;
    }

    /**
     * The getVD_CREATED_BY method returns the VD_CREATED_BY for this bean.
     * 
     * @return String The VD_CREATED_BY
     */
    public String getVD_CREATED_BY()
    {
        return this.VD_CREATED_BY;
    }

    /**
     * The getVD_DATE_CREATED method returns the VD_DATE_CREATED for this bean.
     * 
     * @return String The VD_DATE_CREATED
     */
    public String getVD_DATE_CREATED()
    {
        return this.VD_DATE_CREATED;
    }

    /**
     * The getVD_MODIFIED_BY method returns the VD_MODIFIED_BY for this bean.
     * 
     * @return String The VD_MODIFIED_BY
     */
    public String getVD_MODIFIED_BY()
    {
        return this.VD_MODIFIED_BY;
    }

    /**
     * The getVD_DATE_MODIFIED method returns the VD_DATE_MODIFIED for this bean.
     * 
     * @return String The VD_DATE_MODIFIED
     */
    public String getVD_DATE_MODIFIED()
    {
        return this.VD_DATE_MODIFIED;
    }

    /**
     * The getVD_DELETED_IND method returns the VD_DELETED_IND for this bean.
     * 
     * @return String The VD_DELETED_IND
     */
    public String getVD_DELETED_IND()
    {
        return this.VD_DELETED_IND;
    }

    /**
     * The getVD_CD_NAME method returns the VD_CD_NAME for this bean.
     * 
     * @return String The VD_CD_NAME
     */
    public String getVD_CD_NAME()
    {
        return this.VD_CD_NAME;
    }

    /**
     * The getVD_CONTEXT_NAME method returns the VD_CONTEXT_NAME for this bean.
     * 
     * @return String The VD_CONTEXT_NAME
     */
    public String getVD_CONTEXT_NAME()
    {
        return this.VD_CONTEXT_NAME;
    }

    /**
     * The getVD_LANGUAGE method returns the VD_LANGUAGE for this bean.
     * 
     * @return String The VD_LANGUAGE
     */
    public String getVD_LANGUAGE()
    {
        return this.VD_LANGUAGE;
    }

    /**
     * The getVD_LANGUAGE_IDSEQ method returns the VD_LANGUAGE_IDSEQ for this bean.
     * 
     * @return String The VD_LANGUAGE_IDSEQ
     */
    public String getVD_LANGUAGE_IDSEQ()
    {
        return this.VD_LANGUAGE_IDSEQ;
    }

    /**
     * The getVD_PV_ID method returns the VD_PV_ID for this bean.
     * 
     * @return String The VD_PV_ID
     */
    public Vector getVD_PV_ID()
    {
        return this.VD_PV_ID;
    }

    /**
     * The getVD_PV_NAME method returns the VD_PV_NAME for this bean.
     * 
     * @return String The VD_PV_NAME
     */
    public Vector getVD_PV_NAME()
    {
        return this.VD_PV_NAME;
    }

    /**
     * The getVD_PV_MEANING method returns the VD_PV_MEANING for this bean.
     * 
     * @return String The VD_PV_MEANING
     */
    public Vector getVD_PV_MEANING()
    {
        return this.VD_PV_MEANING;
    }

    /**
     * The getVD_PV_MEANING_DESCRIPTION method returns the VD_PV_MEANING_DESCRIPTION for this bean.
     * 
     * @return String The VD_PV_MEANING_DESCRIPTION
     */
    public Vector getVD_PV_MEANING_DESCRIPTION()
    {
        return this.VD_PV_MEANING_DESCRIPTION;
    }

    /**
     * The getVD_PV_ORIGIN method returns the VD_PV_ORIGIN for this bean.
     * 
     * @return String The VD_PV_ORIGIN
     */
    public Vector getVD_PV_ORIGIN()
    {
        return this.VD_PV_ORIGIN;
    }

    /**
     * The getVD_DATA_TYPE method returns the VD_DATA_TYPE for this bean.
     * 
     * @return String The VD_DATA_TYPE
     */
    public String getVD_DATA_TYPE()
    {
        return this.VD_DATA_TYPE;
    }

    /**
     * The getVD_OBJ_QUAL method returns the VD_OBJ_QUAL for this bean.
     * 
     * @return String The VD_OBJ_QUAL
     */
    public String getVD_OBJ_QUAL()
    {
        return this.VD_OBJ_QUAL;
    }

    /**
     * The getVD_OBJ_CLASS method returns the VD_OBJ_CLASS for this bean.
     * 
     * @return String The VD_OBJ_CLASS
     */
    public String getVD_OBJ_CLASS()
    {
        return this.VD_OBJ_CLASS;
    }

    /**
     * The getVD_OBJ_IDSEQ method returns the VD_OBJ_IDSEQ for this bean.
     * 
     * @return String The VD_OBJ_IDSEQ
     */
    public String getVD_OBJ_IDSEQ()
    {
        return this.VD_OBJ_IDSEQ;
    }

    /**
     * The getVD_PROP_QUAL method returns the VD_PROP_QUAL for this bean.
     * 
     * @return String The VD_PROP_QUAL
     */
    public String getVD_PROP_QUAL()
    {
        return this.VD_PROP_QUAL;
    }

    /**
     * The getVD_PROP_CLASS method returns the VD_PROP_CLASS for this bean.
     * 
     * @return String The VD_PROP_CLASS
     */
    public String getVD_PROP_CLASS()
    {
        return this.VD_PROP_CLASS;
    }

    /**
     * The getVD_PROP_IDSEQ method returns the VD_PROP_IDSEQ for this bean.
     * 
     * @return String The VD_PROP_IDSEQ
     */
    public String getVD_PROP_IDSEQ()
    {
        return this.VD_PROP_IDSEQ;
    }

    /**
     * The getVD_REP_ASL_NAME method returns the VD_REP_ASL_NAME for this bean.
     * 
     * @return String The VD_REP_ASL_NAME
     */
    public String getVD_REP_ASL_NAME()
    {
        return this.VD_REP_ASL_NAME;
    }

    /**
     * The getVD_REP_TERM method returns the VD_REP_TERM for this bean.
     * 
     * @return String The VD_REP_TERM
     */
    public String getVD_REP_TERM()
    {
        return this.VD_REP_TERM;
    }

    /**
     * The getVD_REP_IDSEQ method returns the VD_REP_IDSEQ for this bean.
     * 
     * @return String The VD_REP_IDSEQ
     */
    public String getVD_REP_IDSEQ()
    {
        return this.VD_REP_IDSEQ;
    }

    /**
     * The getVD_PROTOCOL_ID method returns the VD_PROTOCOL_ID for this bean.
     * 
     * @return String The VD_PROTOCOL_ID
     */
    public String getVD_PROTOCOL_ID()
    {
        return this.VD_PROTOCOL_ID;
    }

    /**
     * The getVD_CRF_NAME method returns the VD_CRF_NAME for this bean.
     * 
     * @return String The VD_CRF_NAME
     */
    public String getVD_CRF_NAME()
    {
        return this.VD_CRF_NAME;
    }

    /**
     * The getVD_TYPE_NAME method returns the VD_TYPE_NAME for this bean.
     * 
     * @return String The VD_TYPE_NAME
     */
    public String getVD_TYPE_NAME()
    {
        return this.VD_TYPE_NAME;
    }

    /**
     * The getVD_DES_ALIAS_ID method returns the VD_DES_ALIAS_ID for this bean.
     * 
     * @return String The VD_DES_ALIAS_ID
     */
    public String getVD_DES_ALIAS_ID()
    {
        return this.VD_DES_ALIAS_ID;
    }

    /**
     * The getVD_ALIAS_NAME method returns the VD_ALIAS_NAME for this bean.
     * 
     * @return String The VD_ALIAS_NAME
     */
    public String getVD_ALIAS_NAME()
    {
        return this.VD_ALIAS_NAME;
    }

    /**
     * The getVD_USEDBY_CONTEXT method returns the VD_USEDBY_CONTEXT for this bean.
     * 
     * @return String The VD_USEDBY_CONTEXT
     */
    public String getVD_USEDBY_CONTEXT()
    {
        return this.VD_USEDBY_CONTEXT;
    }

    /**
     * The getVD_Obj_Definition method returns the VD_Obj_Definition for this bean.
     * 
     * @return String The VD_Obj_Definition
     */
    public String getVD_Obj_Definition()
    {
        return this.VD_Obj_Definition;
    }

    /**
     * The getVD_Prop_Definition method returns the VD_Prop_Definition for this bean.
     * 
     * @return String The VD_Prop_Definition
     */
    public String getVD_Prop_Definition()
    {
        return this.VD_Prop_Definition;
    }

    /**
     * The getVD_Rep_Definition method returns the VD_Rep_Definition for this bean.
     * 
     * @return String The VD_Rep_Definition
     */
    public String getVD_Rep_Definition()
    {
        return this.VD_Rep_Definition;
    }

    /**
     * The getVD_VD_ID method returns the VD_VD_ID for this bean.
     * 
     * @return String The VD_VD_ID
     */
    public String getVD_VD_ID()
    {
        return this.VD_VD_ID;
    }

    /**
     * The getVD_Permissible_Value method returns the VD_Permissible_Value for this bean.
     * 
     * @return String The VD_Permissible_Value
     */
    public String getVD_Permissible_Value()
    {
        return this.VD_Permissible_Value;
    }

    /**
     * The getVD_Permissible_Value_Count method returns the VD_Permissible_Value_Count for this bean.
     * 
     * @return Integer The VD_Permissible_Value_Count
     */
    public Integer getVD_Permissible_Value_Count()
    {
        return this.VD_Permissible_Value_Count;
    }

    /**
     * The getVD_SOURCE method returns the VD_SOURCE for this bean.
     * 
     * @return String The VD_SOURCE
     */
    public String getVD_SOURCE()
    {
        return this.VD_SOURCE;
    }

    /**
     * The getVD_CHECKED method returns the VD_CHECKED for this bean.
     * 
     * @return boolean The VD_CHECKED
     */
    public boolean getVD_CHECKED()
    {
        return this.VD_CHECKED;
    }

    /**
     * The getAC_SELECTED_CONTEXT_ID method returns the VD_SELECTED_CONTEXT_ID for this bean.
     * 
     * @return Vector The VD_SELECTED_CONTEXT_ID
     */
    public Vector getAC_SELECTED_CONTEXT_ID()
    {
        return this.VD_SELECTED_CONTEXT_ID;
    }

    /**
     * The getAC_CS method returns the VD_CS for this bean.
     * 
     * @return Vector The VD_CS
     */
    public Vector getAC_CS_NAME()
    {
        return this.VD_CS_NAME;
    }

    /**
     * The getAC_CS_ID method returns the VD_CS_ID for this bean.
     * 
     * @return Vector The VD_CS_ID
     */
    public Vector getAC_CS_ID()
    {
        return this.VD_CS_ID;
    }

    /**
     * The getAC_CSI method returns the VD_CSI for this bean.
     * 
     * @return String The VD_CSI
     */
    public Vector getAC_CSI_NAME()
    {
        return this.VD_CSI_NAME;
    }

    /**
     * The getAC_CSI_ID method returns the VD_CSI_ID for this bean.
     * 
     * @return String The VD_CSI_ID
     */
    public Vector getAC_CSI_ID()
    {
        return this.VD_CSI_ID;
    }

    /**
     * The getAC_AC_CSI_VECTOR method returns the VD_AC_CSI_VECTOR for this bean.
     * 
     * @return Vector The VD_AC_CSI_VECTOR
     */
    public Vector getAC_AC_CSI_VECTOR()
    {
        return this.VD_AC_CSI_VECTOR;
    }

    /**
     * The getAC_AC_CSI_ID method returns the VD_AC_CSI_ID for this bean.
     * 
     * @return Vector The VD_AC_CSI_ID
     */
    public Vector getAC_AC_CSI_ID()
    {
        return this.VD_AC_CSI_ID;
    }

    /**
     * The getAC_CS_CSI_ID method returns the VD_CS_CSI_ID for this bean.
     * 
     * @return Vector The VD_CS_CSI_ID
     */
    public Vector getAC_CS_CSI_ID()
    {
        return this.VD_CS_CSI_ID;
    }

    /**
     * The getAC_ALT_NAMES method returns the AC_ALT_NAMES for this bean.
     * 
     * @return Vector The AC_ALT_NAMES
     */
    public Vector getAC_ALT_NAMES()
    {
        return this.AC_ALT_NAMES;
    }

    /**
     * The getAC_REF_DOCS method returns the AC_REF_DOCS for this bean.
     * 
     * @return Vector The AC_REF_DOCS
     */
    public Vector getAC_REF_DOCS()
    {
        return this.AC_REF_DOCS;
    }

    /**
     * The getAC_CONCEPT_NAME method returns the AC_CONCEPT_NAME for this bean.
     * 
     * @return String The AC_CONCEPT_NAME
     */
    public String getAC_CONCEPT_NAME()
    {
        return this.AC_CONCEPT_NAME;
    }

    /**
     * (non-Javadoc)
     * 
     * @see gov.nih.nci.cadsr.cdecurate.tool.AC_Bean#getContextName()
     */
    @Override
    public String getContextName()
    {
        return getVD_CONTEXT_NAME();
    }

    /**
     * @return Returns the aC_CONTACTS.
     */
    public Hashtable getAC_CONTACTS()
    {
        return AC_CONTACTS;
    }

    /**
     * The getREFERENCE_DOCUMENT method returns the REFERENCE_DOCUMENT for this bean.
     * 
     * @return String The REFERENCE_DOCUMENT
     */
    public String getREFERENCE_DOCUMENT()
    {
        return this.REFERENCE_DOCUMENT;
    }

    /**
     * @return Returns the aLTERNATE_NAME.
     */
    public String getALTERNATE_NAME()
    {
        return ALTERNATE_NAME;
    }

    /**
     * The getVD_REP_CONCEPT_CODE method returns the VD_REP_CONCEPT_CODE for this bean.
     * 
     * @return String The VD_REP_CONCEPT_CODE
     */
    public String getVD_REP_CONCEPT_CODE()
    {
        return this.VD_REP_CONCEPT_CODE;
    }

    /**
     * The getVD_REP_EVS_CUI_ORIGEN method returns the VD_REP_EVS_CUI_ORIGEN for this bean.
     * 
     * @return String The VD_REP_EVS_CUI_ORIGEN
     */
    public String getVD_REP_EVS_CUI_ORIGEN()
    {
        return this.VD_REP_EVS_CUI_ORIGEN;
    }

    /**
     * The getVD_REP_EVS_CUI_SOURCE method returns the VD_REP_EVS_CUI_SOURCE for this bean.
     * 
     * @return String The VD_REP_EVS_CUI_SOURCE
     */
    public String getVD_REP_EVS_CUI_SOURCE()
    {
        return this.VD_REP_EVS_CUI_SOURCE;
    }

    /**
     * The getVD_REP_DEFINITION_SOURCE method returns the VD_REP_DEFINITION_SOURCE for this bean.
     * 
     * @return String The VD_REP_DEFINITION_SOURCE
     */
    public String getVD_REP_DEFINITION_SOURCE()
    {
        return this.VD_REP_DEFINITION_SOURCE;
    }

    /**
     * The getVD_REP_QUAL_CONCEPT_CODE method returns the VD_REP_QUAL_CONCEPT_CODE for this bean.
     * 
     * @return String The VD_REP_QUAL_CONCEPT_CODE
     */
    public String getVD_REP_QUAL_CONCEPT_CODE()
    {
        return this.VD_REP_QUAL_CONCEPT_CODE;
    }

    /**
     * The getVD_REP_QUAL_EVS_CUI_ORIGEN method returns the VD_REP_QUAL_EVS_CUI_ORIGEN for this bean.
     * 
     * @return String The VD_REP_QUAL_EVS_CUI_ORIGEN
     */
    public String getVD_REP_QUAL_EVS_CUI_ORIGEN()
    {
        return this.VD_REP_QUAL_EVS_CUI_ORIGEN;
    }

    /**
     * The getVD_REP_QUAL_EVS_CUI_SOURCE method returns the VD_REP_QUAL_EVS_CUI_SOURCE for this bean.
     * 
     * @return String The VD_REP_QUAL_EVS_CUI_SOURCE
     */
    public String getVD_REP_QUAL_EVS_CUI_SOURCE()
    {
        return this.VD_REP_QUAL_EVS_CUI_SOURCE;
    }

    /**
     * The getVD_REP_QUAL_DEFINITION_SOURCE method returns the VD_REP_QUAL_DEFINITION_SOURCE for this bean.
     * 
     * @return String The VD_REP_QUAL_DEFINITION_SOURCE
     */
    public String getVD_REP_QUAL_DEFINITION_SOURCE()
    {
        return this.VD_REP_QUAL_DEFINITION_SOURCE;
    }

    /**
     * The getVD_PARENT_CODES method returns the VD_PARENT_CODES for this bean.
     * 
     * @return Vector The VD_PARENT_CODES
     */
    public Vector getVD_PARENT_CODES()
    {
        return this.VD_PARENT_CODES;
    }

    /**
     * The getVD_PARENT_NAMES method returns the VD_PARENT_NAMES for this bean.
     * 
     * @return Vector The VD_PARENT_NAMES
     */
    public Vector getVD_PARENT_NAMES()
    {
        return this.VD_PARENT_NAMES;
    }

    /**
     * The getVD_PARENT_META_SOURCE method returns the VD_PARENT_META_SOURCE for this bean.
     * 
     * @return Vector The VD_PARENT_META_SOURCE
     */
    public Vector getVD_PARENT_META_SOURCE()
    {
        return this.VD_PARENT_META_SOURCE;
    }

    /**
     * The getVD_PARENT_DB method returns the VD_PARENT_DB for this bean.
     * 
     * @return Vector The VD_PARENT_DB
     */
    public Vector getVD_PARENT_DB()
    {
        return this.VD_PARENT_DB;
    }

    /**
     * The getVD_PARENT_LIST method returns the VD_PARENT_LIST for this bean.
     * 
     * @return Vector The VD_PARENT_LIST
     */
    public Vector getVD_PARENT_LIST()
    {
        return this.VD_PARENT_LIST;
    }

    /**
     * The getVD_REP_CONDR_IDSEQ method returns the VD_REP_CONDR_IDSEQ for this bean.
     * 
     * @return String The VD_REP_CONDR_IDSEQ
     */
    public String getVD_REP_CONDR_IDSEQ()
    {
        return this.VD_REP_CONDR_IDSEQ;
    }

    /**
     * The getVD_PAR_CONDR_IDSEQ method returns the VD_PAR_CONDR_IDSEQ for this bean.
     * 
     * @return String The VD_PAR_CONDR_IDSEQ
     */
    public String getVD_PAR_CONDR_IDSEQ()
    {
        return this.VD_PAR_CONDR_IDSEQ;
    }

    /**
     * The getVD_REP_NAME_PRIMARY method returns the VD_REP_NAME_PRIMARY for this bean.
     * 
     * @return String The VD_REP_NAME_PRIMARY
     */
    public String getVD_REP_NAME_PRIMARY()
    {
        return this.VD_REP_NAME_PRIMARY;
    }

    /**
     * The getVD_REP_QUALIFIER_NAMES method returns the VD_REP_QUALIFIER_NAMES for this bean.
     * 
     * @return Vector The VD_REP_QUALIFIER_NAMES
     */
    public Vector getVD_REP_QUALIFIER_NAMES()
    {
        return this.VD_REP_QUALIFIER_NAMES;
    }

    /**
     * The getVD_REP_QUALIFIER_CODES method returns the VD_REP_QUALIFIER_CODES for this bean.
     * 
     * @return Vector The VD_REP_QUALIFIER_CODES
     */
    public Vector getVD_REP_QUALIFIER_CODES()
    {
        return this.VD_REP_QUALIFIER_CODES;
    }

    /**
     * The getVD_REP_QUALIFIER_DB method returns the VD_REP_QUALIFIER_DB for this bean.
     * 
     * @return Vector The VD_REP_QUALIFIER_DB
     */
    public Vector getVD_REP_QUALIFIER_DB()
    {
        return this.VD_REP_QUALIFIER_DB;
    }

    /**
     * The getAC_SYS_PREF_NAME method returns the AC_SYS_PREF_NAME for this bean.
     * 
     * @return String The AC_SYS_PREF_NAME
     */
    public String getAC_SYS_PREF_NAME()
    {
        return this.AC_SYS_PREF_NAME;
    }

    /**
     * The getAC_USER_PREF_NAME method returns the AC_USER_PREF_NAME for this bean.
     * 
     * @return String The AC_USER_PREF_NAME
     */
    public String getAC_USER_PREF_NAME()
    {
        return this.AC_USER_PREF_NAME;
    }

    /**
     * The getAC_ABBR_PREF_NAME method returns the AC_ABBR_PREF_NAME for this bean.
     * 
     * @return String The AC_ABBR_PREF_NAME
     */
    public String getAC_ABBR_PREF_NAME()
    {
        return this.AC_ABBR_PREF_NAME;
    }

    /**
     * The getAC_PREF_NAME_TYPE method returns the AC_PREF_NAME_TYPE for this bean.
     * 
     * @return String The AC_PREF_NAME_TYPE
     */
    public String getAC_PREF_NAME_TYPE()
    {
        return this.AC_PREF_NAME_TYPE;
    }

    /**
     * The getVDNAME_CHANGED method returns the VDNAME_CHANGED for this bean.
     * 
     * @return boolean The VDNAME_CHANGED
     */
    public boolean getVDNAME_CHANGED()
    {
        return this.VDNAME_CHANGED;
    }

    /**
     * @return Returns the validateList.
     */
    public Vector<ValidateBean> getValidateList()
    {
        return (ValidateList == null) ? new Vector<ValidateBean>() : ValidateList;
    }

    /**
     * @param validateList
     *            The validateList to set.
     */
    public void setValidateList(Vector<ValidateBean> validateList)
    {
        ValidateList = validateList;
    }

    /**
     * @return Returns the vD_PV_List.
     */
    public Vector<PV_Bean> getVD_PV_List()
    {
        return (VD_PV_List == null) ? new Vector<PV_Bean>() : VD_PV_List;
    }

    /**
     * @param list
     *            The vD_PV_List to set.
     */
    public void setVD_PV_List(Vector<PV_Bean> list)
    {
        VD_PV_List = list;
    }

    /**
     * @return Returns the referenceConceptList.
     */
    public Vector<EVS_Bean> getReferenceConceptList()
    {
        return (ReferenceConceptList == null) ? new Vector<EVS_Bean>() : ReferenceConceptList;
    }

    /**
     * @param referenceConceptList
     *            The referenceConceptList to set.
     */
    public void setReferenceConceptList(Vector<EVS_Bean> referenceConceptList)
    {
        ReferenceConceptList = referenceConceptList;
    }

    /**
     * @return Returns the removed_VDPVList.
     */
    public Vector<PV_Bean> getRemoved_VDPVList()
    {
        return (removed_VDPVList == null) ? new Vector<PV_Bean>() : removed_VDPVList;
    }

    /**
     * @param removed_VDPVList
     *            The removed_VDPVList to set.
     */
    public void setRemoved_VDPVList(Vector<PV_Bean> removed_VDPVList)
    {
        this.removed_VDPVList = removed_VDPVList;
    }
    
    public String getDisplayName()
    {
    	String displayName = this.VD_LONG_NAME + "   "+ this.VD_VD_ID+ " v " + this.VD_VERSION;
    	return displayName;
    }
}
