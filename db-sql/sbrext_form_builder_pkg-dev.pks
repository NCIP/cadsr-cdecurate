CREATE OR REPLACE PACKAGE SBREXT.Sbrext_Form_Builder_Pkg IS

/******************************************************************************
   PROCEDURE:  ins_crf
   PURPOSE:    To insert a CRF row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_crf ( p_version              IN  VARCHAR2,
                      p_preferred_name       IN  VARCHAR2,
                      p_long_name            IN  VARCHAR2,
                      p_preferred_definition IN  VARCHAR2,
                      p_conte_idseq          IN  VARCHAR2,
                      p_proto_idseq          IN  VARCHAR2 default null,
                      p_asl_name             IN  VARCHAR2,
                      p_qcdl_name            IN  VARCHAR2,
                      p_created_by           IN  VARCHAR2,
                      p_change_note           IN  VARCHAR2 default null,
                      p_crf_idseq            OUT VARCHAR2,
                      p_return_code          OUT VARCHAR2,
                      p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_template
   PURPOSE:    To insert a TEMPLATE row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_template ( p_version              IN  VARCHAR2,
                           p_preferred_name       IN  VARCHAR2,
                           p_long_name            IN  VARCHAR2,
                           p_preferred_definition IN  VARCHAR2,
                           p_conte_idseq          IN  VARCHAR2,
                           p_proto_idseq          IN  VARCHAR2 default null,
                           p_asl_name             IN  VARCHAR2,
                           p_qcdl_name            IN  VARCHAR2,
                           p_created_by           IN  VARCHAR2,
                          p_change_note           IN  VARCHAR2 default null,
                           p_tmplt_idseq          OUT VARCHAR2,
                           p_return_code          OUT VARCHAR2,
                           p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_module
   PURPOSE:    To insert a Module row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_module ( p_crf_idseq            IN  VARCHAR2,
                         p_version              IN  VARCHAR2,
                         p_preferred_name       IN  VARCHAR2,
                         p_long_name            IN  VARCHAR2,
                         p_preferred_definition IN  VARCHAR2,
                         p_conte_idseq          IN  VARCHAR2,
                         p_proto_idseq          IN  VARCHAR2 default null,
                         p_asl_name             IN  VARCHAR2,
                         p_created_by           IN  VARCHAR2,
                         p_display_order        IN  NUMBER,
					     p_repeat_number    IN NUMBER default null,
                         p_mod_idseq            OUT VARCHAR2,
                         p_qr_idseq             OUT VARCHAR2,
                         p_return_code          OUT VARCHAR2,
                         p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_question
   PURPOSE:    To insert a Question row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_question ( p_mod_idseq            IN  VARCHAR2,
                           p_version              IN  VARCHAR2,
                           p_preferred_name       IN  VARCHAR2,
                           p_long_name            IN  VARCHAR2,
                           p_preferred_definition IN  VARCHAR2,
                           p_conte_idseq          IN  VARCHAR2,
                           p_proto_idseq          IN  VARCHAR2 default null,
                           p_asl_name             IN  VARCHAR2,
                           p_de_idseq             IN  VARCHAR2,
                           p_created_by           IN  VARCHAR2,
                           p_display_order        IN  NUMBER,
                           p_ques_idseq           OUT VARCHAR2,
                           p_qr_idseq             OUT VARCHAR2,
                           p_return_code          OUT VARCHAR2,
                           p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_value
   PURPOSE:    To insert a Value row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_value ( p_ques_idseq           IN  VARCHAR2,
                        p_version              IN  VARCHAR2,
                        p_preferred_name       IN  VARCHAR2,
                        p_long_name            IN  VARCHAR2,
                        p_preferred_definition IN  VARCHAR2,
                        p_conte_idseq          IN  VARCHAR2,
                        p_proto_idseq          IN  VARCHAR2 default null,
                        p_asl_name             IN  VARCHAR2,
                        p_vp_idseq             IN  VARCHAR2,
                        p_created_by           IN  VARCHAR2,
                        p_display_order        IN  NUMBER,
                        p_val_idseq            OUT VARCHAR2,
                        p_qr_idseq             OUT VARCHAR2,
                        p_return_code          OUT VARCHAR2,
                        p_return_desc          OUT VARCHAR2,
						p_meaning_text         in varchar2 default null );

/******************************************************************************
   PROCEDURE:  ins_form_instr
   PURPOSE:    To insert a FORM_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_form_instr ( p_crf_idseq            IN  VARCHAR2,
                             p_version              IN  VARCHAR2,
                             p_preferred_name       IN  VARCHAR2,
                             p_long_name            IN  VARCHAR2,
                             p_preferred_definition IN  VARCHAR2,
                             p_conte_idseq          IN  VARCHAR2,
                             p_proto_idseq          IN  VARCHAR2 default null,
                             p_asl_name             IN  VARCHAR2,
                             p_created_by           IN  VARCHAR2,
                             p_display_order        IN  NUMBER,
                             p_form_instr_idseq     OUT VARCHAR2,
                             p_qr_idseq             OUT VARCHAR2,
                             p_return_code          OUT VARCHAR2,
                             p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_mod_instr
   PURPOSE:    To insert a MODULE_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_mod_instr ( p_mod_idseq            IN  VARCHAR2,
                            p_version              IN  VARCHAR2,
                            p_preferred_name       IN  VARCHAR2,
                            p_long_name            IN  VARCHAR2,
                            p_preferred_definition IN  VARCHAR2,
                            p_conte_idseq          IN  VARCHAR2,
                            p_proto_idseq          IN  VARCHAR2 default null,
                            p_asl_name             IN  VARCHAR2,
                            p_created_by           IN  VARCHAR2,
                            p_display_order        IN  NUMBER,
                            p_mod_instr_idseq      OUT VARCHAR2,
                            p_qr_idseq             OUT VARCHAR2,
                            p_return_code          OUT VARCHAR2,
                            p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_ques_instr
   PURPOSE:    To insert a QUESTION_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_ques_instr ( p_ques_idseq           IN  VARCHAR2,
                             p_version              IN  VARCHAR2,
                             p_preferred_name       IN  VARCHAR2,
                             p_long_name            IN  VARCHAR2,
                             p_preferred_definition IN  VARCHAR2,
                             p_conte_idseq          IN  VARCHAR2,
                             p_proto_idseq          IN  VARCHAR2 default null,
                             p_asl_name             IN  VARCHAR2,
                             p_created_by           IN  VARCHAR2,
                             p_display_order        IN  NUMBER,
                             p_ques_instr_idseq     OUT VARCHAR2,
                             p_qr_idseq             OUT VARCHAR2,
                             p_return_code          OUT VARCHAR2,
                             p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  ins_val_instr
   PURPOSE:    To insert a VALUE_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE ins_val_instr ( p_val_idseq           IN  VARCHAR2,
                            p_version              IN  VARCHAR2,
                            p_preferred_name       IN  VARCHAR2,
                            p_long_name            IN  VARCHAR2,
                            p_preferred_definition IN  VARCHAR2,
                            p_conte_idseq          IN  VARCHAR2,
                            p_proto_idseq          IN  VARCHAR2 default null,
                            p_asl_name             IN  VARCHAR2,
                            p_created_by           IN  VARCHAR2,
                            p_display_order        IN  NUMBER,
                            p_val_instr_idseq      OUT VARCHAR2,
                            p_qr_idseq             OUT VARCHAR2,
                            p_return_code          OUT VARCHAR2,
                            p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  delete_child_records
   PURPOSE:    To delete all child records associated to a QC.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/25/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE delete_child_records(p_qc_idseq    IN  CHAR,
                                 p_return_code OUT VARCHAR2,
					             p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_crf
   PURPOSE:    To delete a CRF, all it's modules, questions, values and instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Moved this procedure from
   			  			  	 	 		      sbrext_version_pkg to new package
											  sbrext_form_builder_pkg.
   2.1        2/26/2004   W. Ver Hoef      1. Updated using delete_child_records.

******************************************************************************/
  PROCEDURE Remove_Crf(p_crf_idseq   IN  CHAR,
                       p_return_code OUT VARCHAR2,
					   p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_module
   PURPOSE:    To delete a module, all it's questions, values and instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_module(p_mod_idseq   IN  CHAR,
                          p_return_code OUT VARCHAR2,
					      p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_question
   PURPOSE:    To delete a question, all it's values and instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/25/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_question(p_ques_idseq  IN  CHAR,
                            p_return_code OUT VARCHAR2,
					        p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_value
   PURPOSE:    To delete a value, all it's instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/24/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_value(p_val_idseq   IN  CHAR,
                         p_return_code OUT VARCHAR2,
					     p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  delete_crfs
   PURPOSE:    To delete all CRFs that match a given long name.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Moved this procedure from
   			  			  	 	 		      sbrext_version_pkg to new package
											  sbrext_form_builder_pkg.

******************************************************************************/
  PROCEDURE delete_crfs(p_long_name   IN  VARCHAR2,
                        p_return_code OUT VARCHAR2,
					    p_return_desc OUT VARCHAR2);

/******************************************************************************
   NAME:       copy_crf
   PURPOSE:    To copy an existing CRF and all its components.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this package.

******************************************************************************/
  PROCEDURE copy_crf ( p_src_crf_idseq        IN  VARCHAR2,
                       p_qtl_name             IN  VARCHAR2,
                       p_version              IN  VARCHAR2 DEFAULT '1',
                       p_preferred_name       IN  VARCHAR2,
                       p_long_name            IN  VARCHAR2,
                       p_preferred_definition IN  VARCHAR2,
                       p_conte_idseq          IN  VARCHAR2,
                       p_proto_idseq          IN  VARCHAR2,
                       p_asl_name             IN  VARCHAR2 DEFAULT Sbrext_Common_Routines.get_default_Asl('INS') ,/* Changed to draft new to keep with the current rules 'UNDER DEVELOPMENT'*/
                       p_created_by           IN  VARCHAR2,
                       p_new_crf_idseq        OUT VARCHAR2,
                       p_return_code          OUT VARCHAR2,
                       p_return_desc          OUT VARCHAR2 );

/******************************************************************************
   NAME:       update_de
   PURPOSE:    To copy an existing CRF and all its components.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1       3/23/2004   Prerna Aggarwal    1. Created this package.

******************************************************************************/
  PROCEDURE update_de (p_prm_qc_idseq IN  VARCHAR2,
                       p_de_idseq     IN  VARCHAR2,
                       p_created_by   IN  VARCHAR2,
					   p_return_code  OUT VARCHAR2,
					   p_return_desc  OUT VARCHAR2 );

/******************************************************************************
   PROCEDURE:  remove_comp
   PURPOSE:    To delete components with no children
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        3/24/2004   Prerna Aggarwal     1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_comp(p_idseq       IN  CHAR,
                        p_return_code OUT VARCHAR2,
					    p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_instr
   PURPOSE:    To delete an instruction.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        4/2/2004    W. Ver Hoef      1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_instr(p_qc_idseq    IN  CHAR,
                         p_return_code OUT VARCHAR2,
					     p_return_desc OUT VARCHAR2);

/******************************************************************************
   PROCEDURE:  remove_rd
   PURPOSE:    To delete a reference document.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        1/16/2005   P Aggarwal       1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_rd(p_rd_idseq    IN  CHAR,
                         p_return_code OUT VARCHAR2,
					     p_return_desc OUT VARCHAR2);
/******************************************************************************
   PROCEDURE:  remove_rb
   PURPOSE:    To delete an attachment.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        1/16/2005   P Aggarwal       1. Created this procedure.

******************************************************************************/
  PROCEDURE remove_rb(p_name    IN  varchar2,
                         p_return_code OUT VARCHAR2,
					     p_return_desc OUT VARCHAR2);



type fb_idseq_List is table of fb_idseq;

PROCEDURE ins_multi_values ( p_vv                   IN fb_validvalueList,
						p_return_code         OUT varchar2,
						p_return_desc         OUT varchar2);

PROCEDURE ins_proto_qc ( p_qc_idseq                   IN varchar2,
                        p_proto_idseq                   IN varchar2);

Procedure CRF_VERSION (P_Idseq          IN Admin_components_view.ac_idseq%TYPE,
                        p_version         IN admin_components_View.version%TYPE,
						p_change_note     IN admin_components_View.change_note%TYPE,
						p_Created_by      IN admin_components_View.created_by%TYPE,
						p_new_idseq       OUT VARCHAR2, -- 02/13/2006 was admin_components_View.ac_idseq%TYPE,
                       P_RETURN_CODE      OUT    VARCHAR2,
                       P_RETURN_DESC      OUT    VARCHAR2);

Type ref_rec is  record(old_idseq char(36)
,new_idseq char(36));

Type id_reference is table of ref_rec index by binary_integer;


Procedure copy_triggered_action(p_user in varchar2
,p_ref in id_reference);
Procedure copy_qa(p_user in varchar2
,p_ref in id_reference);
Procedure copy_quest_rep(p_user in varchar2
,p_ref in id_reference);
Procedure copy_va(p_user in varchar2
,p_ref in id_reference);

procedure delete_quest_cond(prm_qcon_idseq in varchar2);

END Sbrext_Form_Builder_Pkg;
/
