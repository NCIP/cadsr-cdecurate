--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package CADSR_XLS_LOADER_PKG_WORK3
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" IS

/******************************************************************************
   NAME:       caDSR_XML_LOADER_PKG
   PURPOSE:    To load data from XML staging into data tables.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/23/2002    Judy Pai,
                          Prerna Aggarwal    Created this package.
******************************************************************************/
   PROCEDURE load_de;
   PROCEDURE load_dec;
   PROCEDURE load_dec_recs;
   PROCEDURE load_vd;
   PROCEDURE load_cd;
   PROCEDURE load_decr;
   PROCEDURE load_oc;
   PROCEDURE load_pt;
   PROCEDURE load_rep;
   PROCEDURE load_cs;
   PROCEDURE load_csir;
   PROCEDURE load_con;
   PROCEDURE XML_LOAD_ERR_HANDLE (P_AC_ID IN VARCHAR2 ,P_ERROR_TEXT IN VARCHAR2 );

   FUNCTION GET_NAME(P_TYPE IN VARCHAR2) return varchar2;
   FUNCTION load_definitions(p_ac_id in varchar2, p_ac_idseq in varchar2) RETURN NUMBER;
   FUNCTION load_designations(p_ac_id in varchar2, p_ac_idseq in varchar2) RETURN NUMBER;
   FUNCTION load_ref_docs(p_ac_id in varchar2, p_ac_idseq in varchar2) RETURN NUMBER;
   FUNCTION load_docs(p_ac_id in varchar2,p_ac_idseq in varchar2, p_dctl_name in varchar2,p_doc_text in varchar2,p_name in varchar2) RETURN NUMBER;
   FUNCTION check_cmt_note_exmp (p_ac_idseq in varchar2, p_doc_text in varchar2) return number;
   FUNCTION load_ac_class(p_ac_id in varchar2, p_ac_idseq in varchar2) return number;
   FUNCTION get_cs_csi_idseq(p_csi_idseq in varchar2, p_cs_idseq in varchar2) return varchar2;
   FUNCTION get_conte_idseq(p_conte_name in varchar2, p_conte_version in number) return varchar2;
   FUNCTION get_ac_idseq(p_preferred_name in varchar2, p_conte_idseq in varchar2,
                      p_version in number,p_actl_name in varchar2) return varchar2;
   FUNCTION get_csi_idseq(p_csi_name in varchar2, p_csi_type in varchar2) return varchar2;
   FUNCTION get_rl_name(p_rl_name in varchar2) return boolean;

   FUNCTION load_acreg(p_ac_id in varchar2,p_ac_idseq in varchar2) RETURN NUMBER;
   -- HSK added additional parameters.
   /*
   FUNCTION load_perm_val(p_vd_id in varchar2,p_vd_idseq in varchar2, p_conte_idseq in varchar2) return number;
   FUNCTION load_perm_val(p_vd_idseq in varchar2, p_conte_idseq in varchar2,
		 			   P_VD_CONTE_NAME in varchar2, P_VD_CONTE_VERSION in varchar2,
					   P_VD_VERSION in varchar2, P_VD_PREFERRED_NAME in varchar2) return number;
   */
   PROCEDURE load_perm_val;

   CURSOR cur_ac_stg IS
    SELECT     *
	FROM       ADMIN_COMPONENTS_STAGING;
   TYPE type_ac_stg IS REF CURSOR RETURN cur_ac_stg%ROWTYPE;

   PROCEDURE get_ac_staging(p_ac_id   IN  VARCHAR2,
                            p_ac_cursor OUT type_ac_stg);
   FUNCTION get_sub_idseq(p_name in varchar2,p_org_idseq in varchar2) return varchar2;
   FUNCTION get_dtl_name(p_name in varchar2,p_description in varchar2, p_comments in varchar2) return varchar2;
   FUNCTION get_char_set_name(p_name in varchar2, p_description in varchar2) return varchar2;
   FUNCTION get_forml_name(p_name in varchar2,p_description in varchar2, p_comments in varchar2) return varchar2;
   FUNCTION get_uoml_name(p_name in varchar2, p_precision in varchar2,
          p_description in varchar2,p_comments in varchar2) return varchar2;
   FUNCTION get_value_meaning(p_short_meaning in varchar2,p_begin_date in varchar2,p_end_date in varchar2,p_con_array in varchar2 default null)
    return varchar2;
   FUNCTION get_pv(p_value in varchar2, p_short_meaning varchar2) return varchar2;
   FUNCTION get_dec_rel(p_d_idseq in varchar2, p_decr_idseq in varchar2) return boolean;
   PROCEDURE clean_staging_tables(p_datatype IN VARCHAR2);
   PROCEDURE delete_dup_doc;
   FUNCTION get_cs_types(p_cstl_name in varchar2) return varchar2;
   FUNCTION get_csi_types(p_cstl_name in varchar2) return varchar2;
   FUNCTION cs_item_exists(p_csi_name in varchar2,p_csitl_name in varchar2) return boolean;
   FUNCTION get_csi_rel(p_d_idseq in varchar2, p_csi_idseq in varchar2) return boolean;
   FUNCTION get_con_array(p_con_array in varchar2) return varchar2;

END caDSR_XLS_LOADER_PKG_WORK3;

 
/

  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."CADSR_XLS_LOADER_PKG_WORK3" TO "DER_USER";
