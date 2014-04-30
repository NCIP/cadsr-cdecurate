--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  File created - Thursday-April-04-2013   
--------------------------------------------------------
--------------------------------------------------------
--  Ref Constraints for Table AC_ATT_CSCSI_EXT
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package SBREXT_SET_ROW
--------------------------------------------------------

CREATE OR REPLACE PACKAGE "SBREXT"."SBREXT_SET_ROW" AS
/******************************************************************************
   NAME:       SBREXT_SET_ROW
   PURPOSE:    This Package holds all the API's to get a single row of data
               from a table

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/18/2001  Prerna Aggarwal  1. Created this package
   2.0        07/15/2003  W. Ver Hoef      1. Added origin parameter to
                                              set_de, set_dec.
   2.0        07/22/2003  W. Ver Hoef      1. Added code for origin parameter
                                              to set_object_class.
   2.0        07/23/2003  W. Ver Hoef      1. Added origin parameter/code to
                                              set_property, set_proto, set_qc,
                                              set_representation.
   2.0        07/24/2003  W. Ver Hoef      1. Added origin parameter to
                                              set_vd, set_vd_pvs.
   2.3        10/23/2006  S. Alred         1. Added overloaded versions of set_vm
                                              and set_vm_condr to return new
                                              vm_idseq value.

******************************************************************************/

PROCEDURE SET_VD(
P_RETURN_CODE                         OUT    VARCHAR2
, P_ACTION                           IN     VARCHAR2
, P_VD_VD_IDSEQ                           IN OUT VARCHAR2
, P_VD_PREFERRED_NAME                  IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ                    IN OUT VARCHAR2
, P_VD_VERSION                        IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION            IN OUT VARCHAR2
, P_VD_CD_IDSEQ                        IN OUT VARCHAR2
, P_VD_ASL_NAME                        IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND            IN OUT VARCHAR2
, P_VD_DTL_NAME                        IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM                IN OUT NUMBER
, P_VD_LONG_NAME                    IN OUT VARCHAR2
, P_VD_FORML_NAME                     IN OUT VARCHAR2
, P_FORML_DESCRIPTION               IN OUT VARCHAR2
, P_FORML_COMMENT                    IN OUT VARCHAR2
, P_VD_UOML_NAME                     IN OUT VARCHAR2
, P_UOML_DESCRIPTION                 IN OUT VARCHAR2
, P_UOML_COMMENT                     IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM                IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM                IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM                IN OUT NUMBER
, P_VD_DECIMAL_PLACE                 IN OUT NUMBER
, P_VD_CHAR_SET_NAME                IN OUT VARCHAR2
, P_VD_BEGIN_DATE                    IN OUT VARCHAR2
, P_VD_END_DATE                        IN OUT VARCHAR2
, P_VD_CHANGE_NOTE                    IN OUT VARCHAR2
, P_VD_TYPE_FLAG                    IN OUT VARCHAR2
, P_VD_CREATED_BY                    OUT    VARCHAR2
, P_VD_DATE_CREATED                    OUT    VARCHAR2
, P_VD_MODIFIED_BY                    OUT    VARCHAR2
, P_VD_DATE_MODIFIED                OUT    VARCHAR2
, P_VD_DELETED_IND                    OUT    VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL); -- 24-JUL-2003, W. Ver Hoef

PROCEDURE SET_VD(
 P_RETURN_CODE                         OUT    VARCHAR2
,P_VD_CON_ARRAY                        IN     VARCHAR2
, P_ACTION                           IN     VARCHAR2
, P_VD_VD_IDSEQ                           IN OUT VARCHAR2
, P_VD_PREFERRED_NAME                  IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ                    IN OUT VARCHAR2
, P_VD_VERSION                        IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION            IN OUT VARCHAR2
, P_VD_CD_IDSEQ                        IN OUT VARCHAR2
, P_VD_ASL_NAME                        IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND            IN OUT VARCHAR2
, P_VD_DTL_NAME                        IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM                IN OUT NUMBER
, P_VD_LONG_NAME                    IN OUT VARCHAR2
, P_VD_FORML_NAME                     IN OUT VARCHAR2
, P_FORML_DESCRIPTION               IN OUT VARCHAR2
, P_FORML_COMMENT                    IN OUT VARCHAR2
, P_VD_UOML_NAME                     IN OUT VARCHAR2
, P_UOML_DESCRIPTION                 IN OUT VARCHAR2
, P_UOML_COMMENT                     IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM                IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM                IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM                IN OUT NUMBER
, P_VD_DECIMAL_PLACE                 IN OUT NUMBER
, P_VD_CHAR_SET_NAME                IN OUT VARCHAR2
, P_VD_BEGIN_DATE                    IN OUT VARCHAR2
, P_VD_END_DATE                        IN OUT VARCHAR2
, P_VD_CHANGE_NOTE                    IN OUT VARCHAR2
, P_VD_TYPE_FLAG                    IN OUT VARCHAR2
, P_VD_CREATED_BY                    OUT    VARCHAR2
, P_VD_DATE_CREATED                    OUT    VARCHAR2
, P_VD_MODIFIED_BY                    OUT    VARCHAR2
, P_VD_DATE_MODIFIED                OUT    VARCHAR2
, P_VD_DELETED_IND                    OUT    VARCHAR2
,  P_VD_CONDR_IDSEQ                 IN OUT VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL);
PROCEDURE SET_DEC(
 P_RETURN_CODE                    OUT    VARCHAR2
,P_ACTION                         IN     VARCHAR2
,P_DEC_DEC_IDSEQ               IN OUT VARCHAR2
,P_DEC_PREFERRED_NAME           IN OUT VARCHAR2
,P_DEC_CONTE_IDSEQ               IN OUT VARCHAR2
,P_DEC_VERSION                   IN OUT NUMBER
,P_DEC_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_DEC_CD_IDSEQ                   IN OUT VARCHAR2
,P_DEC_ASL_NAME                   IN OUT VARCHAR2
,P_DEC_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_DEC_LONG_NAME               IN OUT VARCHAR2
,P_DEC_OC_IDSEQ                IN OUT VARCHAR2
,P_DEC_PROP_IDSEQ              IN OUT VARCHAR2
,P_DEC_PROPERTY_QUALIFIER       IN OUT VARCHAR2
,P_DEC_OBJ_CLASS_QUALIFIER       IN OUT VARCHAR2
,P_DEC_BEGIN_DATE               IN OUT VARCHAR2
,P_DEC_END_DATE                   IN OUT VARCHAR2
,P_DEC_CHANGE_NOTE               IN OUT VARCHAR2
,P_DEC_CREATED_BY               OUT      VARCHAR2
,P_DEC_DATE_CREATED               OUT      VARCHAR2
,P_DEC_MODIFIED_BY               OUT      VARCHAR2
,P_DEC_DATE_MODIFIED           OUT      VARCHAR2
,P_DEC_DELETED_IND               OUT      VARCHAR2
,P_DEC_ORIGIN                  IN     VARCHAR2 DEFAULT NULL ); -- 15-Jul-2003, W. Ver Hoef


PROCEDURE SET_VM(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING            IN OUT VARCHAR2
,P_VM_DESCRIPTION            IN OUT VARCHAR2
,P_VM_COMMENTS                IN OUT VARCHAR2
,P_VM_BEGIN_DATE            IN OUT VARCHAR2
,P_VM_END_DATE                IN OUT VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2)    ;

-- overloaded version
PROCEDURE SET_VM(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING            IN OUT VARCHAR2
,P_VM_DESCRIPTION            IN OUT VARCHAR2
,P_VM_COMMENTS                IN OUT VARCHAR2
,P_VM_BEGIN_DATE            IN OUT VARCHAR2
,P_VM_END_DATE                IN OUT VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2
,P_VM_VM_IDSEQ              OUT VARCHAR2)    ;

-- another overloaded version (ScenPro, 4/24/2007)
/*PROCEDURE SET_VM(
     P_RETURN_CODE                OUT VARCHAR2
    ,P_ACTION                   IN OUT VARCHAR2
    ,P_CON_ARRAY                IN VARCHAR2
    ,P_VM_IDSEQ                    IN OUT VARCHAR2
    ,P_PREFERRED_NAME            IN OUT VARCHAR2
    ,P_LONG_NAME                IN OUT VARCHAR2
    ,P_PREFERRED_DEFINITION        IN OUT VARCHAR2
    ,P_CONTE_IDSEQ                IN OUT VARCHAR2
    ,P_ASL_NAME                    IN OUT VARCHAR2
    ,P_VERSION                    IN OUT VARCHAR2
    ,P_VM_ID                    IN OUT VARCHAR2
    ,P_LATEST_VERSION_IND        IN OUT VARCHAR2
    ,P_CONDR_IDSEQ                IN OUT VARCHAR2
    ,P_DEFINITION_SOURCE        IN OUT VARCHAR2
    ,P_ORIGIN                    IN OUT VARCHAR2
    ,P_CHANGE_NOTE                IN OUT VARCHAR2
    ,P_BEGIN_DATE                IN OUT VARCHAR2
    ,P_END_DATE                    IN OUT VARCHAR2
    ,P_CREATED_BY                OUT    VARCHAR2
    ,P_DATE_CREATED                OUT    VARCHAR2
    ,P_MODIFIED_BY                OUT    VARCHAR2
    ,P_DATE_MODIFIED            OUT    VARCHAR2
    )    ;

*/
PROCEDURE SET_PV(
P_RETURN_CODE                    OUT VARCHAR2
,P_ACTION                       IN VARCHAR2
,P_PV_PV_IDSEQ                    IN OUT VARCHAR2
,P_PV_VALUE                    IN OUT VARCHAR2
,P_PV_SHORT_MEANING             IN OUT VARCHAR2
,P_PV_BEGIN_DATE            IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION    IN OUT VARCHAR2
,P_PV_LOW_VALUE_NUM            IN OUT NUMBER
,P_PV_HIGH_VALUE_NUM            IN OUT NUMBER
,P_PV_END_DATE                    IN OUT VARCHAR2
,P_PV_CREATED_BY            OUT    VARCHAR2
,P_PV_DATE_CREATED            OUT    VARCHAR2
,P_PV_MODIFIED_BY            OUT    VARCHAR2
,P_PV_DATE_MODIFIED            OUT    VARCHAR2);


PROCEDURE SET_VD_PVS(
 P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_VDPVS_VP_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_VD_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_PV_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_CONTE_IDSEQ        IN OUT VARCHAR2
,P_VDPVS_DATE_CREATED           OUT VARCHAR2
,P_VDPVS_CREATED_BY               OUT VARCHAR2
,P_VDPVS_MODIFIED_BY           OUT VARCHAR2
,P_VDPVS_DATE_MODIFIED           OUT VARCHAR2
,P_VDPVS_ORIGIN             IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_BEGIN_DATE            IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_END_DATE                    IN  VARCHAR2 DEFAULT NULL
,P_VDPVS_CON_IDSEQ  IN VARCHAR2 DEFAULT NULL); -- 24-JUL-2003, W. Ver Hoef


PROCEDURE SET_DE(
P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DE_DE_IDSEQ                IN OUT VARCHAR2
,P_DE_PREFERRED_NAME        IN OUT VARCHAR2
,P_DE_CONTE_IDSEQ            IN OUT VARCHAR2
,P_DE_VERSION                IN OUT NUMBER
,P_DE_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_DE_DEC_IDSEQ             IN OUT VARCHAR2
,P_DE_VD_IDSEQ                IN OUT VARCHAR2
,P_DE_ASL_NAME                IN OUT VARCHAR2
,P_DE_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_DE_LONG_NAME                IN OUT VARCHAR2
,P_DE_BEGIN_DATE            IN OUT VARCHAR2
,P_DE_END_DATE                IN OUT VARCHAR2
,P_DE_CHANGE_NOTE            IN OUT VARCHAR2
,P_DE_CREATED_BY            OUT       VARCHAR2
,P_DE_DATE_CREATED            OUT       VARCHAR2
,P_DE_MODIFIED_BY            OUT       VARCHAR2
,P_DE_DATE_MODIFIED            OUT       VARCHAR2
,P_DE_DELETED_IND            OUT       VARCHAR2
,P_DE_ORIGIN                IN     VARCHAR2 DEFAULT NULL ); -- 15-Jul-2003, W. Ver Hoef


PROCEDURE SET_RD(
P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_RD_RD_IDSEQ                IN OUT VARCHAR2
,P_RD_NAME                    IN OUT VARCHAR2
,P_RD_DCTL_NAME                IN OUT VARCHAR2
,P_RD_AC_IDSEQ                IN OUT VARCHAR2
,P_RD_ACH_IDSEQ                IN OUT VARCHAR2
,P_RD_AR_IDSEQ                IN OUT VARCHAR2
,P_RD_DOC_TEXT                IN OUT VARCHAR2
,P_RD_ORG_IDSEQ                IN OUT VARCHAR2
,P_RD_URL                      IN OUT VARCHAR2
,P_RD_CREATED_BY            OUT       VARCHAR2
,P_RD_DATE_CREATED            OUT       VARCHAR2
,P_RD_MODIFIED_BY            OUT       VARCHAR2
,P_RD_DATE_MODIFIED            OUT       VARCHAR2
,P_RD_LAE_NAME              IN VARCHAR2 DEFAULT 'ENGLISH'
,P_RD_CONTE_IDSEQ              IN VARCHAR2 DEFAULT NULL);


PROCEDURE SET_DES(
P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DES_DESIG_IDSEQ                IN OUT VARCHAR2
,P_DES_NAME                    IN OUT VARCHAR2
,P_DES_DETL_NAME                IN OUT VARCHAR2
,P_DES_AC_IDSEQ                IN OUT VARCHAR2
,P_DES_CONTE_IDSEQ                IN OUT VARCHAR2
,P_DES_LAE_NAME                IN OUT VARCHAR2
,P_DES_CREATED_BY            OUT       VARCHAR2
,P_DES_DATE_CREATED            OUT       VARCHAR2
,P_DES_MODIFIED_BY            OUT       VARCHAR2
,P_DES_DATE_MODIFIED            OUT       VARCHAR2);


PROCEDURE  SET_CSCSI(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CSCSI_CS_CSI_IDSEQ        IN OUT VARCHAR2
,P_CSCSI_CS_IDSEQ            IN OUT VARCHAR2
,P_CSCSI_LABEL               IN OUT VARCHAR2
,P_CSCSI_CSI_IDSEQ            IN OUT    VARCHAR2
,P_CSCSI_P_CS_CSI_IDSEQ        IN OUT VARCHAR2
,P_CSCSI_LINK_CS_CSI_IDSEQ    IN OUT VARCHAR2
,P_CSCSI_DISPLAY_ORDER        IN OUT NUMBER
,P_CSCSI_DATE_CREATED        OUT    VARCHAR2
,P_CSCSI_CREATED_BY            OUT    VARCHAR2
,P_CSCSI_MODIFIED_BY        OUT    VARCHAR2
,P_CSCSI_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE  SET_ACCSI(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACCSI_AC_CSI_IDSEQ        IN OUT VARCHAR2
,P_ACCSI_AC_IDSEQ            IN OUT VARCHAR2
,P_ACCSI_CS_CSI_IDSEQ        IN OUT    VARCHAR2
,P_ACCSI_DATE_CREATED        OUT    VARCHAR2
,P_ACCSI_CREATED_BY            OUT    VARCHAR2
,P_ACCSI_MODIFIED_BY        OUT    VARCHAR2
,P_ACCSI_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_SRC(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_SRC_SRC_NAME                IN OUT VARCHAR2
,P_SRC_DESCRIPTION            IN OUT VARCHAR2
,P_SRC_CREATED_BY            OUT    VARCHAR2
,P_SRC_DATE_CREATED            OUT    VARCHAR2
,P_SRC_MODIFIED_BY            OUT    VARCHAR2
,P_SRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_TS(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN  VARCHAR2
,P_TS_TS_IDSEQ                IN OUT VARCHAR2
,P_TS_QC_IDSEQ                IN OUT VARCHAR2
,P_TS_TSTL_NAME             IN OUT VARCHAR2
,P_TS_TS_TEXT                IN OUT VARCHAR2
,P_TS_TS_SEQ                IN OUT    NUMBER
,P_TS_CREATED_BY            OUT    VARCHAR2
,P_TS_DATE_CREATED            OUT    VARCHAR2
,P_TS_MODIFIED_BY            OUT    VARCHAR2
,P_TS_DATE_MODIFIED            OUT    VARCHAR2);


PROCEDURE SET_ACSRC(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACSRC_ACS_IDSEQ            IN OUT VARCHAR2
,P_ACSRC_AC_IDSEQ            IN OUT VARCHAR2
,P_ACSRC_SRC_NAME           IN OUT VARCHAR2
,P_ACSRC_DATE_SUBMITTED        IN OUT    VARCHAR2
,P_ACSRC_CREATED_BY            OUT    VARCHAR2
,P_ACSRC_DATE_CREATED        OUT    VARCHAR2
,P_ACSRC_MODIFIED_BY        OUT    VARCHAR2
,P_ACSRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_VPSRC(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VPSRC_VPS_IDSEQ            IN OUT VARCHAR2
,P_VPSRC_VP_IDSEQ            IN OUT VARCHAR2
,P_VPSRC_SRC_NAME           IN OUT VARCHAR2
,P_VPSRC_DATE_SUBMITTED        IN OUT    VARCHAR2
,P_VPSRC_CREATED_BY            OUT    VARCHAR2
,P_VPSRC_DATE_CREATED        OUT    VARCHAR2
,P_VPSRC_MODIFIED_BY        OUT    VARCHAR2
,P_VPSRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_QC(
 P_RETURN_CODE                     OUT    VARCHAR2
,P_ACTION                       IN     VARCHAR2
,P_QC_QC_IDSEQ                    IN OUT VARCHAR2
,P_QC_VERSION                    IN OUT NUMBER
,P_QC_PREFERRED_NAME            IN OUT VARCHAR2
,P_QC_PREFERRED_DEFINITION      IN OUT VARCHAR2
,P_QC_CONTE_IDSEQ                IN OUT VARCHAR2
,P_QC_ASL_NAME                    IN OUT VARCHAR2
,P_QC_QTL_NAME                    IN OUT VARCHAR2
,P_QC_LONG_NAME                    IN OUT VARCHAR2
,P_QC_LATEST_VERSION_IND        IN OUT VARCHAR2
,P_QC_PROTO_IDSEQ                IN OUT VARCHAR2
,P_QC_DE_IDSEQ                     IN OUT VARCHAR2
,P_QC_VP_IDSEQ                    IN OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ              IN OUT VARCHAR2
,P_QC_QCDL_NAME                 IN OUT VARCHAR2
,P_QC_QC_IDENTIFIER                IN OUT VARCHAR2
,P_QC_MATCH_IND                    IN OUT VARCHAR2
,P_QC_NEW_QC_IND                IN OUT VARCHAR2
,P_QC_HIGHLIGHT_IND                IN OUT VARCHAR2
,P_QC_CDE_DICTIONARY_ID            IN OUT VARCHAR2
,P_QC_SYSTEM_MSGS                IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_EXT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_INT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_ACT      IN OUT VARCHAR2
,P_QC_REVIEWED_BY               IN OUT VARCHAR2
,P_QC_REVIEWED_DATE                IN OUT VARCHAR2
,P_QC_APPROVED_BY                 IN OUT VARCHAR2
,P_QC_APPROVED_DATE                IN OUT VARCHAR2
,P_QC_BEGIN_DATE                IN OUT VARCHAR2
,P_QC_END_DATE                  IN OUT VARCHAR2
,P_QC_CHANGE_NOTE                IN OUT VARCHAR2
,P_QC_SUB_LONG_NAME             IN OUT VARCHAR2
,P_QC_GROUP_COMMENTS            IN OUT VARCHAR2
,P_QC_VD_IDSEQ                    IN OUT VARCHAR2
,P_QC_CREATED_BY                OUT       VARCHAR2
,P_QC_DATE_CREATED                OUT       VARCHAR2
,P_QC_MODIFIED_BY                OUT       VARCHAR2
,P_QC_DATE_MODIFIED                OUT       VARCHAR2
,P_QC_DELETED_IND                OUT       VARCHAR2
,P_QC_SRC_NAME                  IN     VARCHAR2 DEFAULT NULL
,P_QC_P_MOD_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_P_QST_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_P_VAL_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_DN_CRF_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_DISPALY_IND                  IN     VARCHAR2 DEFAULT NULL
,P_QC_GROUP_ACTION              IN     VARCHAR2 DEFAULT NULL
,P_QC_DE_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_VD_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_DEC_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_ORIGIN                    IN     VARCHAR2 DEFAULT NULL); -- 23-Jul-2003, W. Ver Hoef


PROCEDURE SET_REL(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_REL_TABLE                IN VARCHAR2
,P_REL_REL_IDSEQ            IN OUT VARCHAR2
,P_REL_P_IDSEQ                IN OUT VARCHAR2
,P_REL_C_IDSEQ                IN OUT VARCHAR2
,P_REL_RL_NAME                IN OUT VARCHAR2
,P_REL_DISPLAY_ORDER        IN OUT NUMBER
,P_REL_CREATED_BY            OUT    VARCHAR2
,P_REL_DATE_CREATED            OUT    VARCHAR2
,P_REL_MODIFIED_BY            OUT    VARCHAR2
,P_REL_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_PROTO(P_RETURN_CODE                  OUT VARCHAR2,
                      P_ACTION                IN       VARCHAR2,
                      P_PROTO_IDSEQ           IN OUT VARCHAR2,
                        P_VERSION               IN OUT NUMBER,
                      P_CONTE_IDSEQ           IN OUT VARCHAR2,
                      P_PREFERRED_NAME        IN OUT VARCHAR2,
                      P_PREFERRED_DEFINITION  IN OUT VARCHAR2,
                      P_ASL_NAME              IN OUT VARCHAR2,
                      P_LONG_NAME             IN OUT VARCHAR2,
                      P_LATEST_VERSION_IND    IN OUT VARCHAR2,
                      P_DELETED_IND           IN OUT VARCHAR2,
                      P_BEGIN_DATE            IN OUT DATE,
                      P_END_DATE              IN OUT DATE,
                      P_PROTOCOL_ID           IN OUT VARCHAR2,
                      P_TYPE                  IN OUT VARCHAR2,
                      P_PHASE                 IN OUT VARCHAR2,
                      P_LEAD_ORG              IN OUT VARCHAR2,
                      P_CHANGE_TYPE           IN OUT VARCHAR2,
                      P_CHANGE_NUMBER         IN OUT NUMBER,
                      P_REVIEWED_DATE         IN OUT DATE,
                      P_REVIEWED_BY           IN OUT VARCHAR2,
                      P_APPROVED_DATE         IN OUT DATE,
                      P_APPROVED_BY           IN OUT VARCHAR2,
                      P_DATE_CREATED          IN OUT DATE,
                      P_CREATED_BY            IN OUT VARCHAR2,
                      P_DATE_MODIFIED         IN OUT DATE,
                      P_MODIFIED_BY           IN OUT VARCHAR2,
                      P_CHANGE_NOTE           IN OUT VARCHAR2,
                    P_ORIGIN                IN     VARCHAR2 DEFAULT NULL); -- 23-Jul-2003, W. Ver Hoef


PROCEDURE SET_CD_VMS(
P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CDVMS_CV_IDSEQ            IN OUT VARCHAR2
,P_CDVMS_CD_IDSEQ            IN OUT VARCHAR2
,P_CDVMS_SHORT_MEANING      IN OUT VARCHAR2
,P_CDVMS_DESCRIPTION        IN OUT VARCHAR2
,P_CDVMS_DATE_CREATED        OUT    VARCHAR2
,P_CDVMS_CREATED_BY            OUT    VARCHAR2
,P_CDVMS_MODIFIED_BY        OUT    VARCHAR2
,P_CDVMS_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_PROPERTY(
P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_PROP_IDSEQ                  IN OUT VARCHAR2
,P_PROP_PREFERRED_NAME      IN OUT VARCHAR2
,P_PROP_LONG_NAME               IN OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_PROP_CONTE_IDSEQ            IN OUT VARCHAR2
,P_PROP_VERSION               IN OUT VARCHAR2
,P_PROP_ASL_NAME              IN OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_PROP_CHANGE_NOTE         IN OUT VARCHAR2
,P_PROP_ORIGIN      IN OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_PROP_BEGIN_DATE            IN OUT VARCHAR2
,P_PROP_END_DATE                IN OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY             OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_DESIG_NCI_CC_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_NCI_CC_VAL IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_UMLS_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_UMLS_CUI_VAL IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_TEMP_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_TEMP_CUI_VAL IN VARCHAR2  DEFAULT NULL);

PROCEDURE SET_PROP_CONDR(
P_PROP_con_array           IN VARCHAR2
,P_PROP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_PROP_PROP_IDSEQ                   OUT VARCHAR2
,P_PROP_PREFERRED_NAME           OUT VARCHAR2
,P_PROP_LONG_NAME              OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_PROP_VERSION                OUT VARCHAR2
,P_PROP_ASL_NAME               OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND     OUT VARCHAR2
,P_PROP_CHANGE_NOTE               OUT VARCHAR2
,P_PROP_ORIGIN                   OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE      OUT VARCHAR2
,P_PROP_BEGIN_DATE             OUT VARCHAR2
,P_PROP_END_DATE               OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY               OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_CONDR_IDSEQ             OUT VARCHAR2
,P_PROP_ID             OUT VARCHAR2);



PROCEDURE SET_CONCEPT(
P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_CON_IDSEQ                   OUT VARCHAR2
,P_CON_PREFERRED_NAME      IN OUT VARCHAR2
,P_CON_LONG_NAME               IN OUT VARCHAR2
,P_CON_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_CON_CONTE_IDSEQ            IN OUT VARCHAR2
,P_CON_VERSION               IN OUT VARCHAR2
,P_CON_ASL_NAME              IN OUT VARCHAR2
,P_CON_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_CON_CHANGE_NOTE         IN OUT VARCHAR2
,P_CON_ORIGIN      IN OUT VARCHAR2
,P_CON_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_CON_EVS_SOURCE         IN OUT VARCHAR2
,P_CON_BEGIN_DATE            IN OUT VARCHAR2
,P_CON_END_DATE                IN OUT VARCHAR2
,P_CON_DATE_CREATED            OUT VARCHAR2
,P_CON_CREATED_BY             OUT VARCHAR2
,P_CON_DATE_MODIFIED           OUT VARCHAR2
,P_CON_MODIFIED_BY             OUT VARCHAR2
,P_CON_DELETED_IND             OUT VARCHAR2);


PROCEDURE SET_OBJECT_CLASS(
P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                     IN     VARCHAR2
,P_OC_IDSEQ                 IN OUT VARCHAR2
,P_OC_PREFERRED_NAME         IN OUT VARCHAR2
,P_OC_LONG_NAME            IN OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_OC_CONTE_IDSEQ          IN OUT VARCHAR2
,P_OC_VERSION              IN OUT VARCHAR2
,P_OC_ASL_NAME             IN OUT VARCHAR2
,P_OC_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_OC_CHANGE_NOTE            IN OUT VARCHAR2
,P_OC_ORIGIN                 IN OUT VARCHAR2
,P_OC_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_OC_BEGIN_DATE           IN OUT VARCHAR2
,P_OC_END_DATE             IN OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY               OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_DESIG_NCI_CC_TYPE    IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_NCI_CC_VAL     IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_UMLS_CUI_VAL   IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_TEMP_CUI_VAL   IN     VARCHAR2  DEFAULT NULL);

PROCEDURE SET_OC_CONDR(
P_OC_con_array           IN VARCHAR2
,P_OC_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_OC_OC_IDSEQ                   OUT VARCHAR2
,P_OC_PREFERRED_NAME           OUT VARCHAR2
,P_OC_LONG_NAME              OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_OC_VERSION                OUT VARCHAR2
,P_OC_ASL_NAME               OUT VARCHAR2
,P_OC_LATEST_VERSION_IND     OUT VARCHAR2
,P_OC_CHANGE_NOTE               OUT VARCHAR2
,P_OC_ORIGIN                   OUT VARCHAR2
,P_OC_DEFINITION_SOURCE      OUT VARCHAR2
,P_OC_BEGIN_DATE             OUT VARCHAR2
,P_OC_END_DATE               OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY               OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_CONDR_IDSEQ             OUT VARCHAR2
,P_OC_ID                      OUT VARCHAR2);

PROCEDURE SET_REPRESENTATION(
P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_REP_IDSEQ                  IN OUT VARCHAR2
,P_REP_PREFERRED_NAME      IN OUT VARCHAR2
,P_REP_LONG_NAME               IN OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_REP_CONTE_IDSEQ            IN OUT VARCHAR2
,P_REP_VERSION               IN OUT VARCHAR2
,P_REP_ASL_NAME              IN OUT VARCHAR2
,P_REP_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_REP_CHANGE_NOTE         IN OUT VARCHAR2
,P_REP_ORIGIN      IN OUT VARCHAR2
,P_REP_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_REP_BEGIN_DATE            IN OUT VARCHAR2
,P_REP_END_DATE                IN OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY             OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_DESIG_NCI_CC_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_NCI_CC_VAL IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_UMLS_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_UMLS_CUI_VAL IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_TEMP_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_TEMP_CUI_VAL IN VARCHAR2  DEFAULT NULL);

PROCEDURE SET_REP_CONDR(
P_REP_con_array           IN VARCHAR2
,P_REP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_REP_REP_IDSEQ                   OUT VARCHAR2
,P_REP_PREFERRED_NAME           OUT VARCHAR2
,P_REP_LONG_NAME              OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_REP_VERSION                OUT VARCHAR2
,P_REP_ASL_NAME               OUT VARCHAR2
,P_REP_LATEST_VERSION_IND     OUT VARCHAR2
,P_REP_CHANGE_NOTE               OUT VARCHAR2
,P_REP_ORIGIN                   OUT VARCHAR2
,P_REP_DEFINITION_SOURCE      OUT VARCHAR2
,P_REP_BEGIN_DATE             OUT VARCHAR2
,P_REP_END_DATE               OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY               OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_CONDR_IDSEQ             OUT VARCHAR2
,P_REP_ID             OUT VARCHAR2);

PROCEDURE SET_QUAL(
 P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_QUAL_qualifier_name        IN OUT VARCHAR2
,P_QUAL_DESCRIPTION            IN OUT VARCHAR2
,P_QUAL_COMMENTS            IN OUT VARCHAR2
,P_QUAL_CREATED_BY               OUT VARCHAR2
,P_QUAL_DATE_CREATED           OUT VARCHAR2
,P_QUAL_MODIFIED_BY               OUT VARCHAR2
,P_QUAL_DATE_MODIFIED           OUT VARCHAR2
,P_QUAL_CON_IDSEQ           IN VARCHAR2 DEFAULT NULL);


PROCEDURE set_cd(
  p_action                  IN     VARCHAR2
 ,p_cd_idseq                IN OUT VARCHAR2
 ,p_cd_version              IN OUT VARCHAR2
 ,p_cd_preferred_name       IN OUT VARCHAR2
 ,p_cd_conte_idseq          IN OUT VARCHAR2
 ,p_cd_long_name            IN OUT VARCHAR2
 ,p_cd_preferred_definition IN OUT VARCHAR2
 ,p_cd_dimensionality       IN OUT VARCHAR2
 ,p_cd_asl_name             IN OUT VARCHAR2
 ,p_cd_latest_version_ind   IN OUT VARCHAR2
 ,p_cd_begin_date           IN OUT DATE
 ,p_cd_end_date             IN OUT DATE
 ,p_cd_change_note          IN OUT VARCHAR2
 ,p_cd_origin               IN OUT VARCHAR2
 ,p_cd_created_by              OUT VARCHAR2
 ,p_cd_date_created            OUT VARCHAR2
 ,p_cd_modified_by             OUT VARCHAR2
 ,p_cd_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
 );


-- 16-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06
PROCEDURE set_complex_de(
  p_action            IN  VARCHAR2
 ,p_cdt_p_de_idseq    IN  VARCHAR2
 ,p_cdt_methods       IN  VARCHAR2
 ,p_cdt_rule          IN  VARCHAR2
 ,p_cdt_concat_char   IN  VARCHAR2
 ,p_cdt_crtl_name     IN  VARCHAR2
 ,p_cdt_created_by    OUT VARCHAR2
 ,p_cdt_date_created  OUT VARCHAR2
 ,p_cdt_modified_by   OUT VARCHAR2
 ,p_cdt_date_modified OUT VARCHAR2
 ,p_return_code       OUT VARCHAR2
 );


-- 17-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06a
PROCEDURE set_cde_relationship(
  p_action             IN     VARCHAR2
 ,p_cdr_idseq          IN OUT VARCHAR2
 ,p_cdr_p_de_idseq     IN OUT VARCHAR2
 ,p_cdr_c_de_idseq     IN OUT VARCHAR2
 ,p_cdr_display_order  IN OUT VARCHAR2
 ,p_cdr_created_by        OUT VARCHAR2
 ,p_cdr_date_created      OUT VARCHAR2
 ,p_cdr_modified_by       OUT VARCHAR2
 ,p_cdr_date_modified     OUT VARCHAR2
 ,p_return_code           OUT VARCHAR2
 );


-- 19-Mar-2004, W. Ver Hoef - added per SPRF_2.1_03
PROCEDURE set_registration(
  p_action                  IN     VARCHAR2
 ,p_ar_idseq                IN OUT VARCHAR2
 ,p_ar_ac_idseq             IN OUT VARCHAR2
 ,p_ar_registration_status  IN OUT VARCHAR2
 ,p_ar_created_by              OUT VARCHAR2
 ,p_ar_date_created            OUT VARCHAR2
 ,p_ar_modified_by             OUT VARCHAR2
 ,p_ar_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
 );

PROCEDURE SET_VM_CONDR(
P_vm_con_array           IN VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_VM_SHORT_MEANING         IN  OUT VARCHAR2
,P_VM_DESCRIPTION             OUT VARCHAR2
,P_VM_COMMENTS                 OUT    VARCHAR2
,P_VM_BEGIN_DATE             OUT    VARCHAR2
,P_VM_END_DATE                 OUT    VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2
,P_VM_CONDR_IDSEQ           out  VARCHAR2 );


-- overloaded version return vm_idseq
PROCEDURE SET_VM_CONDR(
P_vm_con_array               IN     VARCHAR2
,P_RETURN_CODE                 OUT    VARCHAR2
,P_VM_SHORT_MEANING         IN  OUT    VARCHAR2
,P_VM_DESCRIPTION             OUT    VARCHAR2
,P_VM_COMMENTS                 OUT    VARCHAR2
,P_VM_BEGIN_DATE             OUT    VARCHAR2
,P_VM_END_DATE                 OUT    VARCHAR2
,P_VM_CREATED_BY             OUT    VARCHAR2
,P_VM_DATE_CREATED             OUT    VARCHAR2
,P_VM_MODIFIED_BY             OUT    VARCHAR2
,P_VM_DATE_MODIFIED             OUT    VARCHAR2
,P_VM_CONDR_IDSEQ            out    VARCHAR2
,P_VM_VM_IDSEQ               OUT    VARCHAR2 );



-- SPRF_3.1_16i (TT#1001)
PROCEDURE set_contact_comm (
     p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_ccomm_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ctl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_cyber_address          in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2);

-- SPRF_3.1_16j (TT#1001)
PROCEDURE set_contact_addr (
     p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_caddr_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_atl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_addr_line1             in  out   varchar2
    ,p_addr_line2             in  out   varchar2
    ,p_city                   in  out   varchar2
    ,p_state_prov             in  out   varchar2
    ,p_postal_code            in  out   varchar2
    ,p_country                in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2);

-- SPRF_3.1_16k (TT#1001)
/*PROCEDURE set_ac_contact (
     p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_acc_idseq              in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ac_idseq               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2
    ,p_cs_csi_idseq           in  out   varchar2
    ,p_ar_idseq              in  out   varchar2
    ,p_contact_role           in  out   varchar2);*/

    PROCEDURE SET_VD(
  P_UA_NAME              IN  VARCHAR2
, P_RETURN_CODE                     OUT VARCHAR2
, P_ACTION                           IN  VARCHAR2
, P_VD_VD_IDSEQ                       IN OUT VARCHAR2
, P_VD_PREFERRED_NAME                  IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ                IN OUT VARCHAR2
, P_VD_VERSION                        IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION        IN OUT VARCHAR2
, P_VD_CD_IDSEQ                        IN OUT VARCHAR2
, P_VD_ASL_NAME                        IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND            IN OUT VARCHAR2
, P_VD_DTL_NAME                        IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM                IN OUT NUMBER
, P_VD_LONG_NAME                    IN OUT VARCHAR2
, P_VD_FORML_NAME                 IN OUT VARCHAR2
, P_FORML_DESCRIPTION               IN OUT VARCHAR2
, P_FORML_COMMENT                    IN OUT VARCHAR2
, P_VD_UOML_NAME                     IN OUT VARCHAR2
, P_UOML_DESCRIPTION                 IN OUT VARCHAR2
, P_UOML_COMMENT                     IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM                IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM                IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM                IN OUT NUMBER
, P_VD_DECIMAL_PLACE                 IN OUT NUMBER
, P_VD_CHAR_SET_NAME                IN OUT VARCHAR2
, P_VD_BEGIN_DATE                IN OUT VARCHAR2
, P_VD_END_DATE                        IN OUT VARCHAR2
, P_VD_CHANGE_NOTE                IN OUT VARCHAR2
, P_VD_TYPE_FLAG                    IN OUT VARCHAR2
, P_VD_CREATED_BY                   OUT VARCHAR2
, P_VD_DATE_CREATED                   OUT VARCHAR2
, P_VD_MODIFIED_BY                   OUT VARCHAR2
, P_VD_DATE_MODIFIED                   OUT VARCHAR2
, P_VD_DELETED_IND                   OUT VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL); -- 24-JUL-2003, W. Ver Hoef

PROCEDURE SET_VD(
  P_UA_NAME              IN  VARCHAR2
, P_RETURN_CODE                         OUT    VARCHAR2
, P_VD_CON_ARRAY                        IN     VARCHAR2
, P_ACTION                           IN     VARCHAR2
, P_VD_VD_IDSEQ                           IN OUT VARCHAR2
, P_VD_PREFERRED_NAME                  IN OUT VARCHAR2
, P_VD_CONTE_IDSEQ                    IN OUT VARCHAR2
, P_VD_VERSION                        IN OUT NUMBER
, P_VD_PREFERRED_DEFINITION            IN OUT VARCHAR2
, P_VD_CD_IDSEQ                        IN OUT VARCHAR2
, P_VD_ASL_NAME                        IN OUT VARCHAR2
, P_VD_LATEST_VERSION_IND            IN OUT VARCHAR2
, P_VD_DTL_NAME                        IN OUT VARCHAR2
, P_VD_MAX_LENGTH_NUM                IN OUT NUMBER
, P_VD_LONG_NAME                    IN OUT VARCHAR2
, P_VD_FORML_NAME                     IN OUT VARCHAR2
, P_FORML_DESCRIPTION               IN OUT VARCHAR2
, P_FORML_COMMENT                    IN OUT VARCHAR2
, P_VD_UOML_NAME                     IN OUT VARCHAR2
, P_UOML_DESCRIPTION                 IN OUT VARCHAR2
, P_UOML_COMMENT                     IN OUT VARCHAR2
, P_VD_LOW_VALUE_NUM                IN OUT VARCHAR2
, P_VD_HIGH_VALUE_NUM                IN OUT VARCHAR2
, P_VD_MIN_LENGTH_NUM                IN OUT NUMBER
, P_VD_DECIMAL_PLACE                 IN OUT NUMBER
, P_VD_CHAR_SET_NAME                IN OUT VARCHAR2
, P_VD_BEGIN_DATE                    IN OUT VARCHAR2
, P_VD_END_DATE                        IN OUT VARCHAR2
, P_VD_CHANGE_NOTE                    IN OUT VARCHAR2
, P_VD_TYPE_FLAG                    IN OUT VARCHAR2
, P_VD_CREATED_BY                    OUT    VARCHAR2
, P_VD_DATE_CREATED                    OUT    VARCHAR2
, P_VD_MODIFIED_BY                    OUT    VARCHAR2
, P_VD_DATE_MODIFIED                OUT    VARCHAR2
, P_VD_DELETED_IND                    OUT    VARCHAR2
,  P_VD_CONDR_IDSEQ                 IN OUT VARCHAR2
, P_VD_REP_IDSEQ                    IN VARCHAR2 DEFAULT NULL
, P_VD_QUALIFIER_NAME               IN VARCHAR2 DEFAULT NULL
, P_VD_ORIGIN                       IN VARCHAR2 DEFAULT NULL);

PROCEDURE SET_DEC(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                    OUT    VARCHAR2
,P_ACTION                         IN     VARCHAR2
,P_DEC_DEC_IDSEQ               IN OUT VARCHAR2
,P_DEC_PREFERRED_NAME           IN OUT VARCHAR2
,P_DEC_CONTE_IDSEQ               IN OUT VARCHAR2
,P_DEC_VERSION                   IN OUT NUMBER
,P_DEC_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_DEC_CD_IDSEQ                   IN OUT VARCHAR2
,P_DEC_ASL_NAME                   IN OUT VARCHAR2
,P_DEC_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_DEC_LONG_NAME               IN OUT VARCHAR2
,P_DEC_OC_IDSEQ                IN OUT VARCHAR2
,P_DEC_PROP_IDSEQ              IN OUT VARCHAR2
,P_DEC_PROPERTY_QUALIFIER       IN OUT VARCHAR2
,P_DEC_OBJ_CLASS_QUALIFIER       IN OUT VARCHAR2
,P_DEC_BEGIN_DATE               IN OUT VARCHAR2
,P_DEC_END_DATE                   IN OUT VARCHAR2
,P_DEC_CHANGE_NOTE               IN OUT VARCHAR2
,P_DEC_CREATED_BY               OUT      VARCHAR2
,P_DEC_DATE_CREATED               OUT      VARCHAR2
,P_DEC_MODIFIED_BY               OUT      VARCHAR2
,P_DEC_DATE_MODIFIED           OUT      VARCHAR2
,P_DEC_DELETED_IND               OUT      VARCHAR2
,P_DEC_ORIGIN                  IN     VARCHAR2 DEFAULT NULL ); -- 15-Jul-2003, W. Ver Hoef


PROCEDURE SET_VM(
 P_UA_NAME            IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING            IN OUT VARCHAR2
,P_VM_DESCRIPTION            IN OUT VARCHAR2
,P_VM_COMMENTS                IN OUT VARCHAR2
,P_VM_BEGIN_DATE            IN OUT VARCHAR2
,P_VM_END_DATE                IN OUT VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2)    ;

-- overloaded version
PROCEDURE SET_VM(
 P_UA_NAME            IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VM_SHORT_MEANING        IN OUT VARCHAR2
,P_VM_DESCRIPTION        IN OUT VARCHAR2
,P_VM_COMMENTS                IN OUT VARCHAR2
,P_VM_BEGIN_DATE            IN OUT VARCHAR2
,P_VM_END_DATE                IN OUT VARCHAR2
,P_VM_CREATED_BY            OUT    VARCHAR2
,P_VM_DATE_CREATED            OUT    VARCHAR2
,P_VM_MODIFIED_BY            OUT    VARCHAR2
,P_VM_DATE_MODIFIED            OUT    VARCHAR2
,P_VM_VM_IDSEQ              OUT VARCHAR2)    ;

-- another overloaded version (ScenPro, 4/24/2007)
    PROCEDURE SET_VM(
     P_UA_NAME              IN  VARCHAR2
        ,P_RETURN_CODE                OUT VARCHAR2
    ,P_ACTION                   IN OUT VARCHAR2
    ,P_CON_ARRAY                IN VARCHAR2
    ,P_VM_IDSEQ                    IN OUT VARCHAR2
    ,P_PREFERRED_NAME            IN OUT VARCHAR2
    ,P_LONG_NAME                IN OUT VARCHAR2
    ,P_PREFERRED_DEFINITION        IN OUT VARCHAR2
    ,P_CONTE_IDSEQ                IN OUT VARCHAR2
    ,P_ASL_NAME                    IN OUT VARCHAR2
    ,P_VERSION                    IN OUT VARCHAR2
    ,P_VM_ID                    IN OUT VARCHAR2
    ,P_LATEST_VERSION_IND        IN OUT VARCHAR2
    ,P_CONDR_IDSEQ                IN OUT VARCHAR2
    ,P_DEFINITION_SOURCE        IN OUT VARCHAR2
    ,P_ORIGIN                    IN OUT VARCHAR2
    ,P_CHANGE_NOTE                IN OUT VARCHAR2
    ,P_BEGIN_DATE                IN OUT VARCHAR2
    ,P_END_DATE                    IN OUT VARCHAR2
    ,P_CREATED_BY                OUT    VARCHAR2
    ,P_DATE_CREATED                OUT    VARCHAR2
    ,P_MODIFIED_BY                OUT    VARCHAR2
    ,P_DATE_MODIFIED            OUT    VARCHAR2
    )    ;


PROCEDURE SET_PV(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                    OUT VARCHAR2
,P_ACTION                       IN VARCHAR2
,P_PV_PV_IDSEQ                    IN OUT VARCHAR2
,P_PV_VALUE                    IN OUT VARCHAR2
,P_PV_SHORT_MEANING             IN OUT VARCHAR2
,P_PV_BEGIN_DATE            IN OUT VARCHAR2
,P_PV_MEANING_DESCRIPTION    IN OUT VARCHAR2
,P_PV_LOW_VALUE_NUM            IN OUT NUMBER
,P_PV_HIGH_VALUE_NUM            IN OUT NUMBER
,P_PV_END_DATE                    IN OUT VARCHAR2
,P_PV_VM_IDSEQ                    IN OUT VARCHAR2
,P_PV_CREATED_BY            OUT    VARCHAR2
,P_PV_DATE_CREATED            OUT    VARCHAR2
,P_PV_MODIFIED_BY            OUT    VARCHAR2
,P_PV_DATE_MODIFIED            OUT    VARCHAR2);


PROCEDURE SET_VD_PVS(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_VDPVS_VP_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_VD_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_PV_IDSEQ            IN OUT VARCHAR2
,P_VDPVS_CONTE_IDSEQ        IN OUT VARCHAR2
,P_VDPVS_DATE_CREATED           OUT VARCHAR2
,P_VDPVS_CREATED_BY               OUT VARCHAR2
,P_VDPVS_MODIFIED_BY           OUT VARCHAR2
,P_VDPVS_DATE_MODIFIED           OUT VARCHAR2
,P_VDPVS_ORIGIN             IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_BEGIN_DATE            IN     VARCHAR2 DEFAULT NULL
,P_VDPVS_END_DATE                    IN  VARCHAR2 DEFAULT NULL
,P_VDPVS_CON_IDSEQ  IN VARCHAR2 DEFAULT NULL); -- 24-JUL-2003, W. Ver Hoef


PROCEDURE SET_DE(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DE_DE_IDSEQ                IN OUT VARCHAR2
,P_DE_PREFERRED_NAME        IN OUT VARCHAR2
,P_DE_CONTE_IDSEQ            IN OUT VARCHAR2
,P_DE_VERSION                IN OUT NUMBER
,P_DE_PREFERRED_DEFINITION  IN OUT VARCHAR2
,P_DE_DEC_IDSEQ             IN OUT VARCHAR2
,P_DE_VD_IDSEQ                IN OUT VARCHAR2
,P_DE_ASL_NAME                IN OUT VARCHAR2
,P_DE_LATEST_VERSION_IND    IN OUT VARCHAR2
,P_DE_LONG_NAME                IN OUT VARCHAR2
,P_DE_BEGIN_DATE            IN OUT VARCHAR2
,P_DE_END_DATE                IN OUT VARCHAR2
,P_DE_CHANGE_NOTE            IN OUT VARCHAR2
,P_DE_CREATED_BY            OUT       VARCHAR2
,P_DE_DATE_CREATED            OUT       VARCHAR2
,P_DE_MODIFIED_BY            OUT       VARCHAR2
,P_DE_DATE_MODIFIED            OUT       VARCHAR2
,P_DE_DELETED_IND            OUT       VARCHAR2
,P_DE_ORIGIN                IN     VARCHAR2 DEFAULT NULL ); -- 15-Jul-2003, W. Ver Hoef


PROCEDURE SET_RD(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_RD_RD_IDSEQ                IN OUT VARCHAR2
,P_RD_NAME                    IN OUT VARCHAR2
,P_RD_DCTL_NAME                IN OUT VARCHAR2
,P_RD_AC_IDSEQ                IN OUT VARCHAR2
,P_RD_ACH_IDSEQ                IN OUT VARCHAR2
,P_RD_AR_IDSEQ                IN OUT VARCHAR2
,P_RD_DOC_TEXT                IN OUT VARCHAR2
,P_RD_ORG_IDSEQ                IN OUT VARCHAR2
,P_RD_URL                      IN OUT VARCHAR2
,P_RD_CREATED_BY            OUT       VARCHAR2
,P_RD_DATE_CREATED            OUT       VARCHAR2
,P_RD_MODIFIED_BY            OUT       VARCHAR2
,P_RD_DATE_MODIFIED            OUT       VARCHAR2
,P_RD_LAE_NAME              IN VARCHAR2 DEFAULT 'ENGLISH'
,P_RD_CONTE_IDSEQ              IN VARCHAR2 DEFAULT NULL);


PROCEDURE SET_DES(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                 OUT    VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_DES_DESIG_IDSEQ                IN OUT VARCHAR2
,P_DES_NAME                    IN OUT VARCHAR2
,P_DES_DETL_NAME                IN OUT VARCHAR2
,P_DES_AC_IDSEQ                IN OUT VARCHAR2
,P_DES_CONTE_IDSEQ                IN OUT VARCHAR2
,P_DES_LAE_NAME                IN OUT VARCHAR2
,P_DES_CREATED_BY            OUT       VARCHAR2
,P_DES_DATE_CREATED            OUT       VARCHAR2
,P_DES_MODIFIED_BY            OUT       VARCHAR2
,P_DES_DATE_MODIFIED            OUT       VARCHAR2);


PROCEDURE  SET_CSCSI(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CSCSI_CS_CSI_IDSEQ        IN OUT VARCHAR2
,P_CSCSI_CS_IDSEQ            IN OUT VARCHAR2
,P_CSCSI_LABEL               IN OUT VARCHAR2
,P_CSCSI_CSI_IDSEQ            IN OUT    VARCHAR2
,P_CSCSI_P_CS_CSI_IDSEQ        IN OUT VARCHAR2
,P_CSCSI_LINK_CS_CSI_IDSEQ    IN OUT VARCHAR2
,P_CSCSI_DISPLAY_ORDER        IN OUT NUMBER
,P_CSCSI_DATE_CREATED        OUT    VARCHAR2
,P_CSCSI_CREATED_BY            OUT    VARCHAR2
,P_CSCSI_MODIFIED_BY        OUT    VARCHAR2
,P_CSCSI_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE  SET_ACCSI(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACCSI_AC_CSI_IDSEQ        IN OUT VARCHAR2
,P_ACCSI_AC_IDSEQ            IN OUT VARCHAR2
,P_ACCSI_CS_CSI_IDSEQ        IN OUT    VARCHAR2
,P_ACCSI_DATE_CREATED        OUT    VARCHAR2
,P_ACCSI_CREATED_BY            OUT    VARCHAR2
,P_ACCSI_MODIFIED_BY        OUT    VARCHAR2
,P_ACCSI_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_SRC(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_SRC_SRC_NAME                IN OUT VARCHAR2
,P_SRC_DESCRIPTION            IN OUT VARCHAR2
,P_SRC_CREATED_BY            OUT    VARCHAR2
,P_SRC_DATE_CREATED            OUT    VARCHAR2
,P_SRC_MODIFIED_BY            OUT    VARCHAR2
,P_SRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_TS(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN  VARCHAR2
,P_TS_TS_IDSEQ                IN OUT VARCHAR2
,P_TS_QC_IDSEQ                IN OUT VARCHAR2
,P_TS_TSTL_NAME             IN OUT VARCHAR2
,P_TS_TS_TEXT                IN OUT VARCHAR2
,P_TS_TS_SEQ                IN OUT    NUMBER
,P_TS_CREATED_BY            OUT    VARCHAR2
,P_TS_DATE_CREATED            OUT    VARCHAR2
,P_TS_MODIFIED_BY            OUT    VARCHAR2
,P_TS_DATE_MODIFIED            OUT    VARCHAR2);


PROCEDURE SET_ACSRC(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_ACSRC_ACS_IDSEQ            IN OUT VARCHAR2
,P_ACSRC_AC_IDSEQ            IN OUT VARCHAR2
,P_ACSRC_SRC_NAME           IN OUT VARCHAR2
,P_ACSRC_DATE_SUBMITTED        IN OUT    VARCHAR2
,P_ACSRC_CREATED_BY            OUT    VARCHAR2
,P_ACSRC_DATE_CREATED        OUT    VARCHAR2
,P_ACSRC_MODIFIED_BY        OUT    VARCHAR2
,P_ACSRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_VPSRC(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_VPSRC_VPS_IDSEQ            IN OUT VARCHAR2
,P_VPSRC_VP_IDSEQ            IN OUT VARCHAR2
,P_VPSRC_SRC_NAME           IN OUT VARCHAR2
,P_VPSRC_DATE_SUBMITTED        IN OUT    VARCHAR2
,P_VPSRC_CREATED_BY            OUT    VARCHAR2
,P_VPSRC_DATE_CREATED        OUT    VARCHAR2
,P_VPSRC_MODIFIED_BY        OUT    VARCHAR2
,P_VPSRC_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_QC(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                     OUT    VARCHAR2
,P_ACTION                       IN     VARCHAR2
,P_QC_QC_IDSEQ                    IN OUT VARCHAR2
,P_QC_VERSION                    IN OUT NUMBER
,P_QC_PREFERRED_NAME            IN OUT VARCHAR2
,P_QC_PREFERRED_DEFINITION      IN OUT VARCHAR2
,P_QC_CONTE_IDSEQ                IN OUT VARCHAR2
,P_QC_ASL_NAME                    IN OUT VARCHAR2
,P_QC_QTL_NAME                    IN OUT VARCHAR2
,P_QC_LONG_NAME                    IN OUT VARCHAR2
,P_QC_LATEST_VERSION_IND        IN OUT VARCHAR2
,P_QC_PROTO_IDSEQ                IN OUT VARCHAR2
,P_QC_DE_IDSEQ                     IN OUT VARCHAR2
,P_QC_VP_IDSEQ                    IN OUT VARCHAR2
,P_QC_QC_MATCH_IDSEQ              IN OUT VARCHAR2
,P_QC_QCDL_NAME                 IN OUT VARCHAR2
,P_QC_QC_IDENTIFIER                IN OUT VARCHAR2
,P_QC_MATCH_IND                    IN OUT VARCHAR2
,P_QC_NEW_QC_IND                IN OUT VARCHAR2
,P_QC_HIGHLIGHT_IND                IN OUT VARCHAR2
,P_QC_CDE_DICTIONARY_ID            IN OUT VARCHAR2
,P_QC_SYSTEM_MSGS                IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_EXT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_INT     IN OUT VARCHAR2
,P_QC_REVIEWER_FEEDBACK_ACT      IN OUT VARCHAR2
,P_QC_REVIEWED_BY               IN OUT VARCHAR2
,P_QC_REVIEWED_DATE                IN OUT VARCHAR2
,P_QC_APPROVED_BY                 IN OUT VARCHAR2
,P_QC_APPROVED_DATE                IN OUT VARCHAR2
,P_QC_BEGIN_DATE                IN OUT VARCHAR2
,P_QC_END_DATE                  IN OUT VARCHAR2
,P_QC_CHANGE_NOTE                IN OUT VARCHAR2
,P_QC_SUB_LONG_NAME             IN OUT VARCHAR2
,P_QC_GROUP_COMMENTS            IN OUT VARCHAR2
,P_QC_VD_IDSEQ                    IN OUT VARCHAR2
,P_QC_CREATED_BY                OUT       VARCHAR2
,P_QC_DATE_CREATED                OUT       VARCHAR2
,P_QC_MODIFIED_BY                OUT       VARCHAR2
,P_QC_DATE_MODIFIED                OUT       VARCHAR2
,P_QC_DELETED_IND                OUT       VARCHAR2
,P_QC_SRC_NAME                  IN     VARCHAR2 DEFAULT NULL
,P_QC_P_MOD_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_P_QST_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_P_VAL_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_DN_CRF_IDSEQ                IN     VARCHAR2 DEFAULT NULL
,P_QC_DISPALY_IND                  IN     VARCHAR2 DEFAULT NULL
,P_QC_GROUP_ACTION              IN     VARCHAR2 DEFAULT NULL
,P_QC_DE_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_VD_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_DEC_LONG_NAME              IN     VARCHAR2 DEFAULT NULL
,P_QC_ORIGIN                    IN     VARCHAR2 DEFAULT NULL); -- 23-Jul-2003, W. Ver Hoef


PROCEDURE SET_REL(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_REL_TABLE                IN VARCHAR2
,P_REL_REL_IDSEQ            IN OUT VARCHAR2
,P_REL_P_IDSEQ                IN OUT VARCHAR2
,P_REL_C_IDSEQ                IN OUT VARCHAR2
,P_REL_RL_NAME                IN OUT VARCHAR2
,P_REL_DISPLAY_ORDER        IN OUT NUMBER
,P_REL_CREATED_BY            OUT    VARCHAR2
,P_REL_DATE_CREATED            OUT    VARCHAR2
,P_REL_MODIFIED_BY            OUT    VARCHAR2
,P_REL_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_PROTO(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                  OUT VARCHAR2,
P_ACTION                IN       VARCHAR2,
P_PROTO_IDSEQ           IN OUT VARCHAR2,
P_VERSION               IN OUT NUMBER,
P_CONTE_IDSEQ           IN OUT VARCHAR2,
P_PREFERRED_NAME        IN OUT VARCHAR2,
P_PREFERRED_DEFINITION  IN OUT VARCHAR2,
P_ASL_NAME              IN OUT VARCHAR2,
P_LONG_NAME             IN OUT VARCHAR2,
P_LATEST_VERSION_IND    IN OUT VARCHAR2,
P_DELETED_IND           IN OUT VARCHAR2,
P_BEGIN_DATE            IN OUT DATE,
P_END_DATE              IN OUT DATE,
P_PROTOCOL_ID           IN OUT VARCHAR2,
P_TYPE                  IN OUT VARCHAR2,
P_PHASE                 IN OUT VARCHAR2,
P_LEAD_ORG              IN OUT VARCHAR2,
P_CHANGE_TYPE           IN OUT VARCHAR2,
P_CHANGE_NUMBER         IN OUT NUMBER,
P_REVIEWED_DATE         IN OUT DATE,
P_REVIEWED_BY           IN OUT VARCHAR2,
P_APPROVED_DATE         IN OUT DATE,
P_APPROVED_BY           IN OUT VARCHAR2,
P_DATE_CREATED          IN OUT DATE,
P_CREATED_BY            IN OUT VARCHAR2,
P_DATE_MODIFIED         IN OUT DATE,
P_MODIFIED_BY           IN OUT VARCHAR2,
P_CHANGE_NOTE           IN OUT VARCHAR2,
P_ORIGIN                IN     VARCHAR2 DEFAULT NULL); -- 23-Jul-2003, W. Ver Hoef


PROCEDURE SET_CD_VMS(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                OUT VARCHAR2
,P_ACTION                   IN VARCHAR2
,P_CDVMS_CV_IDSEQ            IN OUT VARCHAR2
,P_CDVMS_CD_IDSEQ            IN OUT VARCHAR2
,P_CDVMS_SHORT_MEANING      IN OUT VARCHAR2
,P_CDVMS_DESCRIPTION        IN OUT VARCHAR2
,P_CDVMS_VM_IDSEQ       IN OUT VARCHAR2
,P_CDVMS_DATE_CREATED        OUT    VARCHAR2
,P_CDVMS_CREATED_BY            OUT    VARCHAR2
,P_CDVMS_MODIFIED_BY        OUT    VARCHAR2
,P_CDVMS_DATE_MODIFIED        OUT    VARCHAR2);


PROCEDURE SET_PROPERTY(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_PROP_IDSEQ                  IN OUT VARCHAR2
,P_PROP_PREFERRED_NAME      IN OUT VARCHAR2
,P_PROP_LONG_NAME               IN OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_PROP_CONTE_IDSEQ            IN OUT VARCHAR2
,P_PROP_VERSION               IN OUT VARCHAR2
,P_PROP_ASL_NAME              IN OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_PROP_CHANGE_NOTE         IN OUT VARCHAR2
,P_PROP_ORIGIN      IN OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_PROP_BEGIN_DATE            IN OUT VARCHAR2
,P_PROP_END_DATE                IN OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY             OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_DESIG_NCI_CC_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_NCI_CC_VAL IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_UMLS_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_UMLS_CUI_VAL IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_TEMP_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_PROP_DESIG_TEMP_CUI_VAL IN VARCHAR2  DEFAULT NULL);

PROCEDURE SET_PROP_CONDR(
  P_UA_NAME              IN  VARCHAR2
 ,P_PROP_con_array           IN VARCHAR2
,P_PROP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_PROP_PROP_IDSEQ                   OUT VARCHAR2
,P_PROP_PREFERRED_NAME           OUT VARCHAR2
,P_PROP_LONG_NAME              OUT VARCHAR2
,P_PROP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_PROP_VERSION                OUT VARCHAR2
,P_PROP_ASL_NAME               OUT VARCHAR2
,P_PROP_LATEST_VERSION_IND     OUT VARCHAR2
,P_PROP_CHANGE_NOTE               OUT VARCHAR2
,P_PROP_ORIGIN                   OUT VARCHAR2
,P_PROP_DEFINITION_SOURCE      OUT VARCHAR2
,P_PROP_BEGIN_DATE             OUT VARCHAR2
,P_PROP_END_DATE               OUT VARCHAR2
,P_PROP_DATE_CREATED            OUT VARCHAR2
,P_PROP_CREATED_BY               OUT VARCHAR2
,P_PROP_DATE_MODIFIED           OUT VARCHAR2
,P_PROP_MODIFIED_BY             OUT VARCHAR2
,P_PROP_DELETED_IND             OUT VARCHAR2
,P_PROP_CONDR_IDSEQ             OUT VARCHAR2
,P_PROP_ID             OUT VARCHAR2
,P_DEFAULT_CONTE_NAME           IN VARCHAR2   /* GF32649 */
);



PROCEDURE SET_CONCEPT(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_CON_IDSEQ                   OUT VARCHAR2
,P_CON_PREFERRED_NAME      IN OUT VARCHAR2
,P_CON_LONG_NAME               IN OUT VARCHAR2
,P_CON_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_CON_CONTE_IDSEQ            IN OUT VARCHAR2
,P_CON_VERSION               IN OUT VARCHAR2
,P_CON_ASL_NAME              IN OUT VARCHAR2
,P_CON_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_CON_CHANGE_NOTE         IN OUT VARCHAR2
,P_CON_ORIGIN      IN OUT VARCHAR2
,P_CON_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_CON_EVS_SOURCE         IN OUT VARCHAR2
,P_CON_BEGIN_DATE            IN OUT VARCHAR2
,P_CON_END_DATE                IN OUT VARCHAR2
,P_CON_DATE_CREATED            OUT VARCHAR2
,P_CON_CREATED_BY             OUT VARCHAR2
,P_CON_DATE_MODIFIED           OUT VARCHAR2
,P_CON_MODIFIED_BY             OUT VARCHAR2
,P_CON_DELETED_IND             OUT VARCHAR2
,P_DEFAULT_CONTE_NAME           IN VARCHAR2   /* GF32649 */
);


PROCEDURE SET_OBJECT_CLASS(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                     IN     VARCHAR2
,P_OC_IDSEQ                 IN OUT VARCHAR2
,P_OC_PREFERRED_NAME         IN OUT VARCHAR2
,P_OC_LONG_NAME            IN OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION IN OUT VARCHAR2
,P_OC_CONTE_IDSEQ          IN OUT VARCHAR2
,P_OC_VERSION              IN OUT VARCHAR2
,P_OC_ASL_NAME             IN OUT VARCHAR2
,P_OC_LATEST_VERSION_IND   IN OUT VARCHAR2
,P_OC_CHANGE_NOTE            IN OUT VARCHAR2
,P_OC_ORIGIN                 IN OUT VARCHAR2
,P_OC_DEFINITION_SOURCE    IN OUT VARCHAR2
,P_OC_BEGIN_DATE           IN OUT VARCHAR2
,P_OC_END_DATE             IN OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY               OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_DESIG_NCI_CC_TYPE    IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_NCI_CC_VAL     IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_UMLS_CUI_TYPE  IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_UMLS_CUI_VAL   IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_TEMP_CUI_TYPE  IN     VARCHAR2  DEFAULT NULL
,P_OC_DESIG_TEMP_CUI_VAL   IN     VARCHAR2  DEFAULT NULL);

PROCEDURE SET_OC_CONDR(
  P_UA_NAME              IN  VARCHAR2
 ,P_OC_con_array           IN VARCHAR2
,P_OC_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_OC_OC_IDSEQ                   OUT VARCHAR2
,P_OC_PREFERRED_NAME           OUT VARCHAR2
,P_OC_LONG_NAME              OUT VARCHAR2
,P_OC_PREFERRED_DEFINITION    OUT VARCHAR2
,P_OC_VERSION                OUT VARCHAR2
,P_OC_ASL_NAME               OUT VARCHAR2
,P_OC_LATEST_VERSION_IND     OUT VARCHAR2
,P_OC_CHANGE_NOTE               OUT VARCHAR2
,P_OC_ORIGIN                   OUT VARCHAR2
,P_OC_DEFINITION_SOURCE      OUT VARCHAR2
,P_OC_BEGIN_DATE             OUT VARCHAR2
,P_OC_END_DATE               OUT VARCHAR2
,P_OC_DATE_CREATED            OUT VARCHAR2
,P_OC_CREATED_BY               OUT VARCHAR2
,P_OC_DATE_MODIFIED           OUT VARCHAR2
,P_OC_MODIFIED_BY             OUT VARCHAR2
,P_OC_DELETED_IND             OUT VARCHAR2
,P_OC_CONDR_IDSEQ             OUT VARCHAR2
,P_OC_ID                      OUT VARCHAR2
,P_DEFAULT_CONTE_NAME           IN VARCHAR2   /* GF32649 */
);

PROCEDURE SET_REPRESENTATION(
  P_UA_NAME              IN  VARCHAR2
 ,P_RETURN_CODE                 OUT VARCHAR2
,P_ACTION                  IN VARCHAR2
,P_REP_IDSEQ                  IN OUT VARCHAR2
,P_REP_PREFERRED_NAME      IN OUT VARCHAR2
,P_REP_LONG_NAME               IN OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    IN OUT VARCHAR2
,P_REP_CONTE_IDSEQ            IN OUT VARCHAR2
,P_REP_VERSION               IN OUT VARCHAR2
,P_REP_ASL_NAME              IN OUT VARCHAR2
,P_REP_LATEST_VERSION_IND      IN OUT VARCHAR2
,P_REP_CHANGE_NOTE         IN OUT VARCHAR2
,P_REP_ORIGIN      IN OUT VARCHAR2
,P_REP_DEFINITION_SOURCE         IN OUT VARCHAR2
,P_REP_BEGIN_DATE            IN OUT VARCHAR2
,P_REP_END_DATE                IN OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY             OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_DESIG_NCI_CC_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_NCI_CC_VAL IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_UMLS_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_UMLS_CUI_VAL IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_TEMP_CUI_TYPE IN VARCHAR2  DEFAULT NULL
,P_REP_DESIG_TEMP_CUI_VAL IN VARCHAR2  DEFAULT NULL);

PROCEDURE SET_REP_CONDR(
  P_UA_NAME              IN  VARCHAR2
 ,P_REP_con_array           IN VARCHAR2
,P_REP_CONTE_IDSEQ            IN VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_REP_REP_IDSEQ                   OUT VARCHAR2
,P_REP_PREFERRED_NAME           OUT VARCHAR2
,P_REP_LONG_NAME              OUT VARCHAR2
,P_REP_PREFERRED_DEFINITION    OUT VARCHAR2
,P_REP_VERSION                OUT VARCHAR2
,P_REP_ASL_NAME               OUT VARCHAR2
,P_REP_LATEST_VERSION_IND     OUT VARCHAR2
,P_REP_CHANGE_NOTE               OUT VARCHAR2
,P_REP_ORIGIN                   OUT VARCHAR2
,P_REP_DEFINITION_SOURCE      OUT VARCHAR2
,P_REP_BEGIN_DATE             OUT VARCHAR2
,P_REP_END_DATE               OUT VARCHAR2
,P_REP_DATE_CREATED            OUT VARCHAR2
,P_REP_CREATED_BY               OUT VARCHAR2
,P_REP_DATE_MODIFIED           OUT VARCHAR2
,P_REP_MODIFIED_BY             OUT VARCHAR2
,P_REP_DELETED_IND             OUT VARCHAR2
,P_REP_CONDR_IDSEQ             OUT VARCHAR2
,P_REP_ID             OUT VARCHAR2
,P_DEFAULT_CONTE_NAME           IN VARCHAR2   /* GF32649 */
);

PROCEDURE SET_QUAL(
 P_UA_NAME              IN  VARCHAR2
,P_RETURN_CODE                   OUT VARCHAR2
,P_ACTION                   IN     VARCHAR2
,P_QUAL_qualifier_name        IN OUT VARCHAR2
,P_QUAL_DESCRIPTION            IN OUT VARCHAR2
,P_QUAL_COMMENTS            IN OUT VARCHAR2
,P_QUAL_CREATED_BY               OUT VARCHAR2
,P_QUAL_DATE_CREATED           OUT VARCHAR2
,P_QUAL_MODIFIED_BY               OUT VARCHAR2
,P_QUAL_DATE_MODIFIED           OUT VARCHAR2
,P_QUAL_CON_IDSEQ           IN VARCHAR2 DEFAULT NULL);


PROCEDURE set_cd(
  p_ua_name              IN  VARCHAR2
 ,p_action                  IN     VARCHAR2
 ,p_cd_idseq                IN OUT VARCHAR2
 ,p_cd_version              IN OUT VARCHAR2
 ,p_cd_preferred_name       IN OUT VARCHAR2
 ,p_cd_conte_idseq          IN OUT VARCHAR2
 ,p_cd_long_name            IN OUT VARCHAR2
 ,p_cd_preferred_definition IN OUT VARCHAR2
 ,p_cd_dimensionality       IN OUT VARCHAR2
 ,p_cd_asl_name             IN OUT VARCHAR2
 ,p_cd_latest_version_ind   IN OUT VARCHAR2
 ,p_cd_begin_date           IN OUT DATE
 ,p_cd_end_date             IN OUT DATE
 ,p_cd_change_note          IN OUT VARCHAR2
 ,p_cd_origin               IN OUT VARCHAR2
 ,p_cd_created_by              OUT VARCHAR2
 ,p_cd_date_created            OUT VARCHAR2
 ,p_cd_modified_by             OUT VARCHAR2
 ,p_cd_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
 );


-- 16-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06
PROCEDURE set_complex_de(
  p_ua_name              IN  VARCHAR2
 ,p_action            IN  VARCHAR2
 ,p_cdt_p_de_idseq    IN  VARCHAR2
 ,p_cdt_methods       IN  VARCHAR2
 ,p_cdt_rule          IN  VARCHAR2
 ,p_cdt_concat_char   IN  VARCHAR2
 ,p_cdt_crtl_name     IN  VARCHAR2
 ,p_cdt_created_by    OUT VARCHAR2
 ,p_cdt_date_created  OUT VARCHAR2
 ,p_cdt_modified_by   OUT VARCHAR2
 ,p_cdt_date_modified OUT VARCHAR2
 ,p_return_code       OUT VARCHAR2
 );


-- 17-Mar-2004, W. Ver Hoef - added per SPRF_2.1_06a
PROCEDURE set_cde_relationship(
  p_ua_name              IN  VARCHAR2
 ,p_action             IN     VARCHAR2
 ,p_cdr_idseq          IN OUT VARCHAR2
 ,p_cdr_p_de_idseq     IN OUT VARCHAR2
 ,p_cdr_c_de_idseq     IN OUT VARCHAR2
 ,p_cdr_display_order  IN OUT VARCHAR2
 ,p_cdr_created_by        OUT VARCHAR2
 ,p_cdr_date_created      OUT VARCHAR2
 ,p_cdr_modified_by       OUT VARCHAR2
 ,p_cdr_date_modified     OUT VARCHAR2
 ,p_return_code           OUT VARCHAR2
 );


-- 19-Mar-2004, W. Ver Hoef - added per SPRF_2.1_03
PROCEDURE set_registration(
  p_ua_name              IN  VARCHAR2
 ,p_action                  IN     VARCHAR2
 ,p_ar_idseq                IN OUT VARCHAR2
 ,p_ar_ac_idseq             IN OUT VARCHAR2
 ,p_ar_registration_status  IN OUT VARCHAR2
 ,p_ar_created_by              OUT VARCHAR2
 ,p_ar_date_created            OUT VARCHAR2
 ,p_ar_modified_by             OUT VARCHAR2
 ,p_ar_date_modified           OUT VARCHAR2
 ,p_return_code                OUT VARCHAR2
 );

-- SPRF_3.1_16i (TT#1001)
PROCEDURE set_contact_comm (
     p_ua_name              IN  VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_ccomm_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ctl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_cyber_address          in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2);

-- SPRF_3.1_16j (TT#1001)
PROCEDURE set_contact_addr (
     p_ua_name              IN  VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_caddr_idseq            in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_atl_name               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_addr_line1             in  out   varchar2
    ,p_addr_line2             in  out   varchar2
    ,p_city                   in  out   varchar2
    ,p_state_prov             in  out   varchar2
    ,p_postal_code            in  out   varchar2
    ,p_country                in  out   varchar2
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2);

-- SPRF_3.1_16k (TT#1001)
PROCEDURE set_ac_contact (
     p_ua_name              IN  VARCHAR2
    ,p_return_code            OUT       VARCHAR2
    ,p_action                 IN        VARCHAR2
    ,p_acc_idseq              in  out   varchar2
    ,p_org_idseq              in  out   varchar2
    ,p_per_idseq              in  out   varchar2
    ,p_ac_idseq               in  out   varchar2
    ,p_rank_order             in  out   number
    ,p_date_created           in  out   date
    ,p_created_by             in  out   varchar2
    ,p_date_modified          in  out   date
    ,p_modified_by            in  out   varchar2
    ,p_cs_csi_idseq           in  out   varchar2
    ,p_ar_idseq              in  out   varchar2
    ,p_contact_role           in  out   varchar2);


END SBREXT_SET_ROW;

/

  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO PUBLIC;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_SET_ROW" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_SET_ROW" TO "DER_USER";
