CREATE OR REPLACE PACKAGE BODY SBREXT."SBREXT_FORM_BUILDER_PKG"
AS
/******************************************************************************
   PROCEDURE:  ins_crf
   PURPOSE:    To insert a CRF row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.
   2.0        7/15/2003   W. Ver Hoef      1. Changed from inserting into
                                              quest_contents_view_ext to
                                   quest_contents_ext
   2.1        2/19/2004   W. Ver Hoef      1. Took out debug messages after testing

******************************************************************************/
   PROCEDURE ins_crf (
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_qcdl_name              IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_change_note            IN       VARCHAR2,
      p_crf_idseq              OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq      VARCHAR2 (36)   := admincomponent_crud.cmr_guid;
      v_proto_idseq   VARCHAR2 (36);
      v_string        VARCHAR2 (2000);
      i               NUMBER          := 1;
   BEGIN
      -- insert the CRF into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, asl_name,
                   qcdl_name, created_by, qtl_name, change_note, qc_id
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_asl_name,
                   p_qcdl_name, p_created_by, 'CRF', p_change_note, 0
                  );

      v_string := p_proto_idseq;

      IF v_string IS NOT NULL
      THEN
         WHILE i <> 0
         LOOP
            i := INSTR (v_string, ',');

            IF i = 0
            THEN
               v_proto_idseq := v_string;
            ELSE
               v_proto_idseq := SUBSTR (v_string, 1, i - 1);
            END IF;

            v_string := SUBSTR (v_string, i + 1);
            ins_proto_qc (v_qc_idseq, v_proto_idseq);
         END LOOP;
      END IF;

      p_crf_idseq := v_qc_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_crf;



/******************************************************************************
   PROCEDURE:  ins_template
   PURPOSE:    To insert a TEMPLATE row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_template (
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_qcdl_name              IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_change_note            IN       VARCHAR2,
      p_tmplt_idseq            OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
   BEGIN
      -- insert the CRF into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, qcdl_name, created_by, qtl_name, qc_id
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_qcdl_name, p_created_by, 'TEMPLATE', 0
                  );

      --ins_proto_qc(v_qc_idseq,p_proto_idseq);
      p_tmplt_idseq := v_qc_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_template;


/******************************************************************************
   PROCEDURE:  ins_module
   PURPOSE:    To insert a Module row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.
   2.0        7/15/2003   W. Ver Hoef      1. Changed from inserting into
                                              quest_contents_view_ext to
                                   quest_contents_ext and from
                                   qc_recs_view_ext to qc_recs_ext

******************************************************************************/
   PROCEDURE ins_module (
      p_crf_idseq              IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_repeat_number          IN       NUMBER,
      p_mod_idseq              OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_qr_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
   BEGIN
      -- insert the module into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, created_by, qtl_name, repeat_no
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_created_by, 'MODULE', p_repeat_number
                  );

      -- insert the association between CRF and module into qc_recs_view_ext
      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_crf_idseq, v_qc_idseq, p_display_order,
                   'FORM_MODULE', p_created_by
                  );

      p_mod_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_module;

/******************************************************************************
   PROCEDURE:  ins_question
   PURPOSE:    To insert a CRF row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.
   2.0        7/15/2003   W. Ver Hoef      1. Changed from inserting into
                                              quest_contents_view_ext to
                                   quest_contents_ext and from
                                   qc_recs_view_ext to qc_recs_ext

******************************************************************************/
   PROCEDURE ins_question (
      p_mod_idseq              IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_de_idseq               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_ques_idseq             OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq         VARCHAR2 (36)        := admincomponent_crud.cmr_guid;
      v_qr_idseq         VARCHAR2 (36)        := admincomponent_crud.cmr_guid;
      v_table            VARCHAR2 (30);
      v_preferred_name   administered_components.preferred_name%TYPE;
   BEGIN
      -- insert the question into quest_contents_view_ext
      IF p_preferred_name IS NULL
      THEN
         v_preferred_name := set_name.set_qc_name (p_long_name);
      ELSE
         v_preferred_name := p_preferred_name;
      END IF;

      -- insert the question into quest_contents_view_ext
      v_table := 'quest_contents_view_ext';

      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, de_idseq, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, v_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_de_idseq, p_created_by, 'QUESTION'
                  );

      -- insert the association between module and question into qc_recs_view_ext
      v_table := 'qc_recs_view_ext';

      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_mod_idseq, v_qc_idseq, p_display_order,
                   'MODULE_ELEMENT', p_created_by
                  );

      p_ques_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := '(' || v_table || ')' || SQLCODE;
         p_return_desc := SQLERRM;
   END ins_question;

/******************************************************************************
   PROCEDURE:  ins_value
   PURPOSE:    To insert a CRF row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this procedure.
   2.0        7/15/2003   W. Ver Hoef      1. Changed from inserting into
                                              quest_contents_view_ext to
                                   quest_contents_ext and from
                                   qc_recs_view_ext to qc_recs_ext

******************************************************************************/
   PROCEDURE ins_value (
      p_ques_idseq             IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_vp_idseq               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_val_idseq              OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2,
      p_meaning_text           IN       VARCHAR2
   )
   IS
      v_qc_idseq         VARCHAR2 (36)        := admincomponent_crud.cmr_guid;
      v_qr_idseq         VARCHAR2 (36)        := admincomponent_crud.cmr_guid;
      v_preferred_name   administered_components.preferred_name%TYPE;
      v_count            NUMBER;
   BEGIN
      -- insert the question into quest_contents_view_ext
      IF p_preferred_name IS NULL
      THEN
         v_preferred_name := set_name.set_qc_name (p_long_name);
      ELSE
         v_preferred_name := p_preferred_name;
      END IF;

      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, vp_idseq, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, v_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_vp_idseq, p_created_by, 'VALID_VALUE'
                  );

      -- insert the association between module and question into qc_recs_view_ext
      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_ques_idseq, v_qc_idseq, p_display_order,
                   'ELEMENT_VALUE', p_created_by
                  );

      -- insert message text
      IF p_meaning_text IS NOT NULL
      THEN
         INSERT INTO valid_values_att_ext
                     (qc_idseq, meaning_text, created_by
                     )
              VALUES (v_qc_idseq, p_meaning_text, p_created_by
                     );
      END IF;

      p_val_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_value;

/******************************************************************************
   PROCEDURE:  ins_form_instr
   PURPOSE:    To insert a FORM_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_form_instr (
      p_crf_idseq              IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_form_instr_idseq       OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_qr_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
   BEGIN
      -- insert the instruction into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_created_by, 'FORM_INSTR'
                  );

      -- insert the association between CRF and module into qc_recs_view_ext
      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_crf_idseq, v_qc_idseq, p_display_order,
                   'FORM_INSTRUCTION', p_created_by
                  );

      p_form_instr_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_form_instr;

/******************************************************************************
   PROCEDURE:  ins_mod_instr
   PURPOSE:    To insert a MODULE_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_mod_instr (
      p_mod_idseq              IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_mod_instr_idseq        OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_qr_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_table      VARCHAR2 (30);
   BEGIN
      -- insert the question into quest_contents_view_ext
      v_table := 'quest_contents_view_ext';

      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_created_by, 'MODULE_INSTR'
                  );

      -- insert the association between module and question into qc_recs_view_ext
      v_table := 'qc_recs_view_ext';

      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_mod_idseq, v_qc_idseq, p_display_order,
                   'MODULE_INSTRUCTION', p_created_by
                  );

      p_mod_instr_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := '(' || v_table || ')' || SQLCODE;
         p_return_desc := SQLERRM;
   END ins_mod_instr;

/******************************************************************************
   PROCEDURE:  ins_ques_instr
   PURPOSE:    To insert a QUESTION_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_ques_instr (
      p_ques_idseq             IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_ques_instr_idseq       OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_qr_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
   BEGIN
      -- insert the question into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_created_by, 'QUESTION_INSTR'
                  );

      -- insert the association between module and question into qc_recs_view_ext
      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_ques_idseq, v_qc_idseq, p_display_order,
                   'ELEMENT_INSTRUCTION', p_created_by
                  );

      p_ques_instr_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_ques_instr;

/******************************************************************************
   PROCEDURE:  ins_val_instr
   PURPOSE:    To insert a VALUE_INSTR row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/23/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_val_instr (
      p_val_idseq              IN       VARCHAR2,
      p_version                IN       VARCHAR2,
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
      p_created_by             IN       VARCHAR2,
      p_display_order          IN       NUMBER,
      p_val_instr_idseq        OUT      VARCHAR2,
      p_qr_idseq               OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
      v_qc_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
      v_qr_idseq   VARCHAR2 (36) := admincomponent_crud.cmr_guid;
   BEGIN
      -- insert the question into quest_contents_view_ext
      INSERT INTO quest_contents_ext
                  (qc_idseq, VERSION, preferred_name, long_name,
                   preferred_definition, conte_idseq, proto_idseq,
                   asl_name, created_by, qtl_name
                  )
           VALUES (v_qc_idseq, p_version, p_preferred_name, p_long_name,
                   p_preferred_definition, p_conte_idseq, p_proto_idseq,
                   p_asl_name, p_created_by, 'VALUE_INSTR'
                  );

      -- insert the association between module and question into qc_recs_view_ext
      INSERT INTO qc_recs_ext
                  (qr_idseq, p_qc_idseq, c_qc_idseq, display_order,
                   rl_name, created_by
                  )
           VALUES (v_qr_idseq, p_val_idseq, v_qc_idseq, p_display_order,
                   'VALUE_INSTRUCTION', p_created_by
                  );

      p_val_instr_idseq := v_qc_idseq;
      p_qr_idseq := v_qr_idseq;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code := 'API_QC_800';
         p_return_desc := SQLERRM;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END ins_val_instr;

/******************************************************************************
   PROCEDURE:  delete_child_records
   PURPOSE:    To delete all child records associated to a QC.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/25/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE delete_child_records (
      p_qc_idseq      IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_qc_idseq           CHAR (36)     := p_qc_idseq;
      v_table_errored_on   VARCHAR2 (30);

      CURSOR qcon
      IS
         SELECT p_qcon_idseq
           FROM condition_components_ext
          WHERE qc_idseq = p_qc_idseq OR vv_idseq = p_qc_idseq;
   BEGIN
      v_table_errored_on := 'QC_RECS_EXT';

      BEGIN
         --remove forward  and backward relationships
         DELETE FROM qc_recs_ext
               WHERE p_qc_idseq = v_qc_idseq OR c_qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'MATCH_RESULTS_EXT';

      BEGIN
         --remove match results for children
         DELETE FROM match_results_ext
               WHERE qc_crf_idseq = v_qc_idseq
                  OR qc_submit_idseq = v_qc_idseq
                  OR qc_match_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'AC_CSI';

      BEGIN
         --remove classification
         DELETE FROM ac_csi
               WHERE ac_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'DESIGNATIONS';

      BEGIN
         --remove designations
         DELETE FROM designations
               WHERE ac_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'REFERENCE_BLOBS';

      BEGIN
         --remove reference_documents
         DELETE FROM reference_blobs
               WHERE rd_idseq IN (SELECT rd_idseq
                                    FROM reference_documents
                                   WHERE ac_idseq = v_qc_idseq);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'REFERENCE_DOCUMENTS';

      BEGIN
         --remove reference_documents
         DELETE FROM reference_documents
               WHERE ac_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'CRF_TOOL_PARAMETER_EXT';

      BEGIN
         --remove cpt
         DELETE FROM crf_tool_parameter_ext
               WHERE qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'TRIGGERED_ACTIONS_EXT';

      BEGIN
         --remove ta
         DELETE FROM ta_proto_csi_ext
               WHERE ta_idseq IN (
                        SELECT ta_idseq
                          FROM triggered_actions_ext
                         WHERE s_qc_idseq = v_qc_idseq
                            OR t_qc_idseq = v_qc_idseq);

         DELETE FROM triggered_actions_ext
               WHERE s_qc_idseq = v_qc_idseq OR t_qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'CONDITION_COMPONENTS_EXT';

      BEGIN
         --remove ta
         FOR q_rec IN qcon
         LOOP
            delete_quest_cond (q_rec.p_qcon_idseq);
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'PROTOCOL_QC_EXT';

      BEGIN
         --remove pq
         DELETE FROM protocol_qc_ext
               WHERE qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'QUEST_ATTRIBUTES_EXT';

      BEGIN
         --remove qa
         DELETE FROM quest_attributes_ext
               WHERE qc_idseq = v_qc_idseq OR vv_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'VALID_VALUES_ATT_EXT';

      BEGIN
         --remove qa
         DELETE FROM valid_values_att_ext
               WHERE qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'QUEST_VV_EXT';

      BEGIN
         --remove qv
         DELETE FROM quest_vv_ext
               WHERE quest_idseq = v_qc_idseq OR vv_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'AC_HISTORIES';

      BEGIN
         --remove ac
         DELETE FROM ac_histories
               WHERE ac_idseq = v_qc_idseq OR source_ac_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      v_table_errored_on := 'ADMINISTERED_COMPONENTS';

      BEGIN
         --remove ac
         DELETE FROM administered_components
               WHERE ac_idseq = v_qc_idseq;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc :=
               SQLERRM
            || ' (Table Error Occured On = '
            || v_table_errored_on
            || ')';
   END delete_child_records;

/******************************************************************************
   PROCEDURE:  remove_crf
   PURPOSE:    To delete a CRF, all it's modules, questions and values.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Moved this procedure from
                                       sbrext_version_pkg to new package
                                   sbrext_form_builder_pkg.
   2.1        2/19/2004   W. Ver Hoef      1. added return code/desc parameters
                                              and exception handling
   2.1        2/26/2004   W. Ver Hoef      1. Updated using delete_child_records

******************************************************************************/
   PROCEDURE remove_crf (
      p_crf_idseq     IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      CURSOR crf_child
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_crf_idseq;

      CURSOR mod_child (p_mod_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_mod_idseq AND rl_name NOT IN ('MODULE_FORM');

      CURSOR element_child (p_ques_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_ques_idseq
            AND rl_name NOT IN ('ELEMENT_MODULE');

      CURSOR val_child (p_val_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_val_idseq AND rl_name NOT IN ('VALUE_ELEMENT');

      v_crf_idseq        CHAR (36)       := p_crf_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
      v_count            NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM quest_contents_ext
       WHERE qc_idseq = p_crf_idseq;

      IF v_count = 0
      THEN
         p_return_code := 1;
         p_return_desc := 'Form does not exist. Please Requery';
         RETURN;
      END IF;

      FOR c_rec IN crf_child
      LOOP
         --if child is a module then find it's children
         IF c_rec.rl_name = 'FORM_MODULE'
         THEN
            FOR m_rec IN mod_child (c_rec.c_qc_idseq)
            LOOP
               IF m_rec.rl_name = 'MODULE_ELEMENT'
               THEN
                  --if child is a question then find it's children
                  FOR e_rec IN element_child (m_rec.c_qc_idseq)
                  LOOP
                     IF e_rec.rl_name = 'ELEMENT_VALUE'
                     THEN
                        --if child is a value then find it's children
                        FOR v_rec IN val_child (e_rec.c_qc_idseq)
                        LOOP
                           sbrext_form_builder_pkg.delete_child_records
                                                           (v_rec.c_qc_idseq,
                                                            v_return_code,
                                                            v_return_desc
                                                           );

                           IF v_return_code IS NOT NULL
                           THEN
                              p_return_code := v_return_code;
                              p_return_desc := v_return_desc;
                              RAISE e_deleting_child;
                           END IF;

                           --remove children record
                           BEGIN
                              DELETE FROM quest_contents_ext
                                    WHERE qc_idseq = v_rec.c_qc_idseq;
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 p_return_code := SQLCODE;
                                 p_return_desc := SQLERRM;
                                 DBMS_OUTPUT.put_line
                                    (   'Errored out while processing value child '
                                     || v_rec.c_qc_idseq
                                     || ' '
                                     || v_rec.rl_name
                                    );
                                 DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
                           END;
                        END LOOP;
                     END IF;

                     sbrext_form_builder_pkg.delete_child_records
                                                            (e_rec.c_qc_idseq,
                                                             v_return_code,
                                                             v_return_desc
                                                            );

                     IF v_return_code IS NOT NULL
                     THEN
                        p_return_code := v_return_code;
                        p_return_desc := v_return_desc;
                        RAISE e_deleting_child;
                     END IF;

                     BEGIN
                        DELETE FROM quest_contents_ext
                              WHERE qc_idseq = e_rec.c_qc_idseq;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           p_return_code := SQLCODE;
                           p_return_desc := SQLERRM;
                           DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || e_rec.c_qc_idseq
                               || ' '
                               || e_rec.rl_name
                              );
                           DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
                     END;
                  END LOOP;
               END IF;

               sbrext_form_builder_pkg.delete_child_records (m_rec.c_qc_idseq,
                                                             v_return_code,
                                                             v_return_desc
                                                            );

               IF v_return_code IS NOT NULL
               THEN
                  p_return_code := v_return_code;
                  p_return_desc := v_return_desc;
                  RAISE e_deleting_child;
               END IF;

               BEGIN
                  DELETE FROM quest_contents_ext
                        WHERE qc_idseq = m_rec.c_qc_idseq;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     p_return_code := SQLCODE;
                     p_return_desc := SQLERRM;
                     DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || m_rec.c_qc_idseq
                               || ' '
                               || m_rec.rl_name
                              );
                     DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
               END;
            END LOOP;
         END IF;

         sbrext_form_builder_pkg.delete_child_records (c_rec.c_qc_idseq,
                                                       v_return_code,
                                                       v_return_desc
                                                      );

         IF v_return_code IS NOT NULL
         THEN
            p_return_code := v_return_code;
            p_return_desc := v_return_desc;
            RAISE e_deleting_child;
         END IF;

         --remove children record
         BEGIN
            DELETE FROM quest_contents_ext
                  WHERE qc_idseq = c_rec.c_qc_idseq;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := SQLCODE;
               p_return_desc := SQLERRM;
               DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || c_rec.c_qc_idseq
                               || ' '
                               || c_rec.rl_name
                              );
               DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
         END;
      END LOOP;

      sbrext_form_builder_pkg.delete_child_records (v_crf_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_crf_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line (   'Errored out while processing CRF '
                                  || v_crf_idseq
                                 );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
         DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
         DBMS_OUTPUT.put_line (   'Error deleting CRF '
                               || v_crf_idseq
                               || ' and it''s components: '
                              );
         DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
   END remove_crf;

/******************************************************************************
   PROCEDURE:  remove_module
   PURPOSE:    To delete a module, all it's questions and values.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Created this procedure
   2.1        2/19/2004   W. Ver Hoef      1. added return code/desc parameters
                                              and exception handling

******************************************************************************/
   PROCEDURE remove_module (
      p_mod_idseq     IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_mod_idseq        CHAR (36)       := p_mod_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;

      CURSOR mod_child
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = v_mod_idseq AND rl_name NOT IN ('MODULE_FORM');

      CURSOR element_child (p_ques_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_ques_idseq
            AND rl_name NOT IN ('ELEMENT_MODULE');

      CURSOR val_child (p_val_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_val_idseq AND rl_name NOT IN ('VALUE_ELEMENT');

      v_count            NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM quest_contents_ext
       WHERE qc_idseq = p_mod_idseq;

      IF v_count = 0
      THEN
         p_return_code := 1;
         p_return_desc := 'Module does not exist. Please Requery';
         RETURN;
      END IF;

      FOR m_rec IN mod_child
      LOOP
         IF m_rec.rl_name IN ('MODULE_ELEMENT', 'MODULE_INSTRUCTION')
         THEN            -- 24-Feb-2004, W. Ver Hoef - added FORM_INSTRUCTION
            --if child is a question then find it's children
            FOR e_rec IN element_child (m_rec.c_qc_idseq)
            LOOP
               IF e_rec.rl_name IN ('ELEMENT_VALUE', 'ELEMENT_INSTRUCTION')
               THEN   -- 24-Feb-2004, W. Ver Hoef - added ELEMENT_INSTRUCTION
                  --if child is a value then find it's children
                  FOR v_rec IN val_child (e_rec.c_qc_idseq)
                  LOOP
                     sbrext_form_builder_pkg.delete_child_records
                                                           (v_rec.c_qc_idseq,
                                                            v_return_code,
                                                            v_return_desc
                                                           );

                     IF v_return_code IS NOT NULL
                     THEN
                        p_return_code := v_return_code;
                        p_return_desc := v_return_desc;
                        RAISE e_deleting_child;
                     END IF;

                     --remove child record
                     BEGIN
                        DELETE FROM quest_contents_ext
                              WHERE qc_idseq = v_rec.c_qc_idseq;
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           p_return_code := SQLCODE;
                           p_return_desc := SQLERRM;
                           DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || v_rec.c_qc_idseq
                               || ' '
                               || v_rec.rl_name
                              );
                           DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
                     END;

                     DBMS_OUTPUT.put_line ('value child done');
                  END LOOP;                                       -- val_child
               END IF;

               sbrext_form_builder_pkg.delete_child_records (e_rec.c_qc_idseq,
                                                             v_return_code,
                                                             v_return_desc
                                                            );

               IF v_return_code IS NOT NULL
               THEN
                  p_return_code := v_return_code;
                  p_return_desc := v_return_desc;
                  RAISE e_deleting_child;
               END IF;

               BEGIN
                  DELETE FROM quest_contents_ext
                        WHERE qc_idseq = e_rec.c_qc_idseq;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     p_return_code := SQLCODE;
                     p_return_desc := SQLERRM;
                     DBMS_OUTPUT.put_line
                            (   'Errored out while processing element child '
                             || e_rec.c_qc_idseq
                             || ' '
                             || e_rec.rl_name
                            );
                     DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
               END;

               DBMS_OUTPUT.put_line ('element child done');
            END LOOP;                                         -- element_child
         END IF;

         sbrext_form_builder_pkg.delete_child_records (m_rec.c_qc_idseq,
                                                       v_return_code,
                                                       v_return_desc
                                                      );

         IF v_return_code IS NOT NULL
         THEN
            p_return_code := v_return_code;
            p_return_desc := v_return_desc;
            RAISE e_deleting_child;
         END IF;

         BEGIN
            DELETE FROM quest_contents_ext
                  WHERE qc_idseq = m_rec.c_qc_idseq;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := SQLCODE;
               p_return_desc := SQLERRM;
               DBMS_OUTPUT.put_line
                             (   'Errored out while processing module child '
                              || m_rec.c_qc_idseq
                              || ' '
                              || m_rec.rl_name
                             );
               DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
         END;

         DBMS_OUTPUT.put_line ('module child done');
      END LOOP;                                                   -- mod_child

      sbrext_form_builder_pkg.delete_child_records (v_mod_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_mod_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line (   'Errored out while processing module '
                                  || v_mod_idseq
                                 );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
         DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
         DBMS_OUTPUT.put_line (   'Error deleting module '
                               || p_mod_idseq
                               || ' and it''s components: '
                              );
         DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
   END remove_module;

/******************************************************************************
   PROCEDURE:  remove_question
   PURPOSE:    To delete a question, all it's values and instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/25/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_question (
      p_ques_idseq    IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      CURSOR element_child (p_ques_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_ques_idseq
            AND rl_name NOT IN ('ELEMENT_MODULE');

      CURSOR val_child (p_val_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_val_idseq AND rl_name NOT IN ('VALUE_ELEMENT');

      v_ques_idseq       CHAR (36)       := p_ques_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
      v_count            NUMBER;
   BEGIN
      SELECT COUNT (*)
        INTO v_count
        FROM quest_contents_ext
       WHERE qc_idseq = p_ques_idseq;

      IF v_count = 0
      THEN
         p_return_code := 1;
         p_return_desc := 'Question does not exist. Please Requery';
         RETURN;
      END IF;

      FOR e_rec IN element_child (v_ques_idseq)
      LOOP
         IF e_rec.rl_name = 'ELEMENT_VALUE'
         THEN
            --if child is a value then find it's children
            FOR v_rec IN val_child (e_rec.c_qc_idseq)
            LOOP
               sbrext_form_builder_pkg.delete_child_records
                                                           (v_rec.c_qc_idseq,
                                                            v_return_code,
                                                            v_return_desc
                                                           );

               IF v_return_code IS NOT NULL
               THEN
                  p_return_code := v_return_code;
                  p_return_desc := v_return_desc;
                  RAISE e_deleting_child;
               END IF;

               --remove children record
               BEGIN
                  DELETE FROM quest_contents_ext
                        WHERE qc_idseq = v_rec.c_qc_idseq;
               EXCEPTION
                  WHEN OTHERS
                  THEN
                     p_return_code := SQLCODE;
                     p_return_desc := SQLERRM;
                     DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || v_rec.c_qc_idseq
                               || ' '
                               || v_rec.rl_name
                              );
                     DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
               END;
            END LOOP;
         END IF;

         sbrext_form_builder_pkg.delete_child_records (e_rec.c_qc_idseq,
                                                       v_return_code,
                                                       v_return_desc
                                                      );

         IF v_return_code IS NOT NULL
         THEN
            p_return_code := v_return_code;
            p_return_desc := v_return_desc;
            RAISE e_deleting_child;
         END IF;

         BEGIN
            DELETE FROM quest_contents_ext
                  WHERE qc_idseq = e_rec.c_qc_idseq;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := SQLCODE;
               p_return_desc := SQLERRM;
               DBMS_OUTPUT.put_line
                            (   'Errored out while processing element child '
                             || e_rec.c_qc_idseq
                             || ' '
                             || e_rec.rl_name
                            );
               DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
         END;
      END LOOP;

      sbrext_form_builder_pkg.delete_child_records (v_ques_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_ques_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line (   'Errored out while deleting question '
                                  || v_ques_idseq
                                 );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_question;

/******************************************************************************
   PROCEDURE:  remove_value
   PURPOSE:    To delete a value, all it's instructions.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        2/25/2004   W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_value (
      p_val_idseq     IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      CURSOR val_child (p_val_idseq IN CHAR)
      IS
         SELECT c_qc_idseq, rl_name
           FROM qc_recs_ext
          WHERE p_qc_idseq = p_val_idseq AND rl_name NOT IN
                                                           ('VALUE_ELEMENT');

      v_val_idseq        CHAR (36)       := p_val_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
      v_count            NUMBER;
   BEGIN
      /*SELECT COUNT(*) INTO v_count
      FROM QUEST_CONTENTS_EXT
      WHERE qc_idseq = p_val_idseq;

      IF v_count = 0 THEN
         p_return_code := 1;
         p_return_desc := 'Valid Value does not exist. Please Requery';
        RETURN;
      END IF;*/ --Removed on 5/4/05. Check not needed Prerna
      FOR v_rec IN val_child (v_val_idseq)
      LOOP
         sbrext_form_builder_pkg.delete_child_records (v_rec.c_qc_idseq,
                                                       v_return_code,
                                                       v_return_desc
                                                      );

         IF v_return_code IS NOT NULL
         THEN
            p_return_code := v_return_code;
            p_return_desc := v_return_desc;
            RAISE e_deleting_child;
         END IF;

         --remove child record
         BEGIN
            DELETE FROM quest_contents_ext
                  WHERE qc_idseq = v_rec.c_qc_idseq;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := SQLCODE;
               p_return_desc := SQLERRM;
               DBMS_OUTPUT.put_line
                              (   'Errored out while processing value child '
                               || v_rec.c_qc_idseq
                               || ' '
                               || v_rec.rl_name
                              );
               DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
         END;
      END LOOP;

      sbrext_form_builder_pkg.delete_child_records (v_val_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_val_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line (   'Errored out while deleting value '
                                  || v_val_idseq
                                 );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_value;

/******************************************************************************
   PROCEDURE:  delete_crfs
   PURPOSE:    To delete all CRFs that match a given long name.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/25/2003   W. Ver Hoef      1. Moved this procedure from
                                       sbrext_version_pkg to new package
                                   sbrext_form_builder_pkg.
   2.1        2/19/2004   W. Ver Hoef      1. added return code/desc parameters
                                              and exception handling

******************************************************************************/
   PROCEDURE delete_crfs (
      p_long_name     IN       VARCHAR2,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;

      CURSOR crf_cur (qc_long_name IN VARCHAR2)
      IS
         SELECT qc_idseq
           FROM quest_contents_ext
          WHERE long_name = qc_long_name;
   BEGIN
      FOR crf_rec IN crf_cur (p_long_name)
      LOOP
         remove_crf (crf_rec.qc_idseq, v_return_code, v_return_desc);

         IF v_return_code IS NOT NULL
         THEN
            p_return_code := v_return_code;
            p_return_desc := v_return_desc;
            RAISE e_deleting_child;
         END IF;
      END LOOP;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END;

/******************************************************************************
   NAME:       copy_crf
   PURPOSE:    To copy an existing CRF and all its components.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        7/10/2003   W. Ver Hoef      1. Created this package.
   2.0        7/14/2003   W. Ver Hoef      1. Dropped use of get_uniq_pref_name
                                              in favor of generating unique
                                   preferred names using qc_seq.nextval
   2.0        7/25/2003   W. Ver Hoef      1. Moved this procedure from package
                                              sbrext_copy_qc_pkg to new package
                                   sbrext_form_builder_pkg (this pkg)
   2.1        3/15/2004   W. Ver Hoef      1. took out commit at end of procedure
                                           2. added where clauses for rl_name to
                                    cursors
                                 3. took out else condition in the if-then
                                    in the c_src_val_instr loop since it's
                                   unnecessary now.

******************************************************************************/
   PROCEDURE copy_crf (
      p_src_crf_idseq          IN       VARCHAR2,
      p_qtl_name               IN       VARCHAR2,
      p_version                IN       VARCHAR2 DEFAULT '1',
      p_preferred_name         IN       VARCHAR2,
      p_long_name              IN       VARCHAR2,
      p_preferred_definition   IN       VARCHAR2,
      p_conte_idseq            IN       VARCHAR2,
      p_proto_idseq            IN       VARCHAR2,
      p_asl_name               IN       VARCHAR2,
  /* Changed to draft new to keep with the current rules 'UNDER DEVELOPMENT'*/
      p_created_by             IN       VARCHAR2,
      p_new_crf_idseq          OUT      VARCHAR2,
      p_return_code            OUT      VARCHAR2,
      p_return_desc            OUT      VARCHAR2
   )
   IS
-- Date:  31-Mar-2004
-- Modified By:  W. Ver Hoef
-- Reason:  corrected erroneous display order assignment for new records; added c_src_accsi
--          cursor and associated code to copy the classification scheme associations
      v_src_crf_idseq          VARCHAR2 (36)   := p_src_crf_idseq;
      v_src_mod_idseq          VARCHAR2 (36);
      v_src_ques_idseq         VARCHAR2 (36);
      v_src_val_idseq          VARCHAR2 (36);

      -- 31-Mar-2004, W. Ver Hoef - added cursor
      CURSOR c_src_accsi
-- classification scheme associates for CRF or TEMPLATE indicated by idseq parameter
      IS
         SELECT cs_csi_idseq
           FROM ac_csi
          WHERE ac_idseq = v_src_crf_idseq;

      CURSOR c_src_crf
    -- level 1, may return a CRF or TEMPLATE depending on the idseq parameter
      IS
         SELECT qc_idseq crf_idseq, qcdl_name
           FROM quest_contents_ext
          WHERE qc_idseq = v_src_crf_idseq;

      CURSOR c_src_mod           -- level 2, includes MODULEs and FORM_INSTRs
      IS
         SELECT qr.p_qc_idseq crf_idseq, qr.c_qc_idseq mod_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.repeat_no
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_crf_idseq
            AND qr.rl_name != 'MODULE_FORM'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                         'INSTRUCTION_FORM'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_ques       -- level 3, includes QUESTIONs and MODULE_INSTRs
      IS
         SELECT qr.p_qc_idseq mod_idseq, qr.c_qc_idseq ques_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.de_idseq
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_mod_idseq
            AND qr.rl_name !=
                           'ELEMENT_MODULE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                       'INSTRUCTION_MODULE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_val   -- level 4, includes VALID_VALUEs and QUESTION_INSTRs
      IS
         SELECT qr.p_qc_idseq ques_idseq, qr.c_qc_idseq val_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.vp_idseq
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_ques_idseq
            AND qr.rl_name !=
                            'VALUE_ELEMENT'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                      'INSTRUCTION_ELEMENT'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_val_instr                 -- level 5, includes VALUE_INSTRs
      IS
         SELECT qr.p_qc_idseq val_idseq, qr.c_qc_idseq val_instr_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_val_idseq
            AND qr.rl_name !=
                        'INSTRUCTION_VALUE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      v_qtl_name               VARCHAR2 (2000) := p_qtl_name;
      v_version                VARCHAR2 (2000) := p_version;
      v_preferred_name         VARCHAR2 (2000) := p_preferred_name;
      v_long_name              VARCHAR2 (2000) := p_long_name;
      v_preferred_definition   VARCHAR2 (2000) := p_preferred_definition;
      v_conte_idseq            VARCHAR2 (2000) := p_conte_idseq;
      v_proto_idseq            VARCHAR2 (2000) := p_proto_idseq;
      v_asl_name               VARCHAR2 (2000) := p_asl_name;
      v_created_by             VARCHAR2 (2000) := p_created_by;
      v_new_crf_idseq          VARCHAR2 (36);
      v_new_mod_idseq          VARCHAR2 (36);
      v_new_ques_idseq         VARCHAR2 (36);
      v_new_val_idseq          VARCHAR2 (36);
      v_new_form_instr_idseq   VARCHAR2 (36);
      v_new_mod_instr_idseq    VARCHAR2 (36);
      v_new_ques_instr_idseq   VARCHAR2 (36);
      v_new_val_instr_idseq    VARCHAR2 (36);
      v_qr_idseq               VARCHAR2 (36);
      v_return_code            VARCHAR2 (2000);
      v_return_desc            VARCHAR2 (2000);
      v_qtl_name_for_msg       VARCHAR2 (2000);
      v_src_count              NUMBER          DEFAULT 0;
      -- 31-Mar-2004, W. Ver Hoef - added variables for copying ac_csi
      v_new_ac_csi_idseq       VARCHAR2 (36);
      v_src_cs_csi_idseq       VARCHAR2 (36);
      v_accsi_date_created     DATE;
      v_accsi_created_by       VARCHAR2 (2000);
      v_accsi_date_modified    DATE;
      v_accsi_modified_by      VARCHAR2 (2000);
      e_crf_error              EXCEPTION;
      e_mod_error              EXCEPTION;
      e_ques_error             EXCEPTION;
      e_val_error              EXCEPTION;
      e_val_instr_error        EXCEPTION;
      -- 31-Mar-2004, W. Ver Hoef - added exception for copying ac_csi
      e_accsi_error            EXCEPTION;
      v_id_reference           id_reference;
      i                        NUMBER          := 1;
   BEGIN
      -- validate presence of required input parameters
      IF v_src_crf_idseq IS NULL
      THEN
         p_return_code := 'API_QC_xxx';
         p_return_desc := 'Source CRF idseq is mandatory';
         RETURN;
      ELSE
         SELECT COUNT (1)
           INTO v_src_count
           FROM quest_contents_ext
          WHERE qc_idseq = v_src_crf_idseq;

         IF v_src_count = 0
         THEN
            p_return_code := 'API_QC_xxx';
            p_return_desc :=
               'Source QC_IDSEQ does not match an existing QUEST_CONTENTS_EXT.QC_IDSEQ';
            RETURN;
         END IF;

         IF v_qtl_name NOT IN ('CRF', 'TEMPLATE')
         THEN
            p_return_code := 'API_QC_xxx'; -- PROTO_IDSEQ cannot be null here
            p_return_desc := 'P_QTL_NAME must be CRF or TEMPLATE';
            RETURN;
         END IF;

         --Check to see that all mandatory parameters are either not NULL or have a default value.
         IF v_preferred_name IS NULL
         THEN
            p_return_code := 'API_QC_101';
                                        -- Preferred Name cannot be null here
            p_return_desc := 'Preferred Name is mandatory for inserts';
            RETURN;
         END IF;

         IF v_long_name IS NULL
         THEN
            p_return_code := 'API_QC_xxx';   -- Long Name cannot be null here
            p_return_desc := 'Long Name is mandatory for inserts';
            RETURN;
         END IF;

         IF v_preferred_definition IS NULL
         THEN
            p_return_code := 'API_QC_103';
                                  -- Preferred Definition cannot be null here
            p_return_desc := 'Preferred Definition is mandatory for inserts';
            RETURN;
         END IF;

         IF v_conte_idseq IS NULL
         THEN
            p_return_code := 'API_QC_102'; -- CONTE_IDSEQ cannot be null here
            p_return_desc := 'CONTE_IDSEQ cannot be null here';
            RETURN;
         END IF;
      /*IF v_proto_idseq IS NULL AND v_qtl_name = 'CRF'  THEN
        p_return_code := 'API_QC_xxx'; -- PROTO_IDSEQ cannot be null here
        p_return_desc := 'Protocol IDSEQ is mandatory for CRF inserts';
        RETURN;
      END IF;*/
      END IF;

      -- Query for CRF's qcdl_name
      FOR crf_rec IN c_src_crf
      LOOP
         v_qtl_name_for_msg := v_qtl_name;
         DBMS_OUTPUT.put_line (   'length v_version              = '
                               || TO_CHAR (LENGTH (v_version))
                              );
         DBMS_OUTPUT.put_line (   'length v_preferred_name       = '
                               || TO_CHAR (LENGTH (v_preferred_name))
                              );
         DBMS_OUTPUT.put_line (   'length v_long_name            = '
                               || TO_CHAR (LENGTH (v_long_name))
                              );
         DBMS_OUTPUT.put_line (   'length v_preferred_definition = '
                               || TO_CHAR (LENGTH (v_preferred_definition))
                              );
         DBMS_OUTPUT.put_line (   'length v_conte_idseq          = '
                               || TO_CHAR (LENGTH (v_conte_idseq))
                              );
         DBMS_OUTPUT.put_line (   'length v_proto_idseq          = '
                               || TO_CHAR (LENGTH (v_proto_idseq))
                              );
         DBMS_OUTPUT.put_line (   'length v_asl_name             = '
                               || TO_CHAR (LENGTH (v_asl_name))
                              );
         DBMS_OUTPUT.put_line (   'length crf_rec.qcdl_name      = '
                               || TO_CHAR (LENGTH (crf_rec.qcdl_name))
                              );
         DBMS_OUTPUT.put_line (   'length v_created_by           = '
                               || TO_CHAR (LENGTH (v_created_by))
                              );

         -- insert form (level 1) record
         IF v_qtl_name = 'CRF'
         THEN
            ins_crf (p_version                   => v_version,
                     p_preferred_name            => v_preferred_name,
                     p_long_name                 => v_long_name,
                     p_preferred_definition      => v_preferred_definition,
                     p_conte_idseq               => v_conte_idseq,
                     --p_proto_idseq          => v_proto_idseq,
                     p_asl_name                  => v_asl_name,
                     p_qcdl_name                 => crf_rec.qcdl_name,
                     p_created_by                => v_created_by,
                     p_crf_idseq                 => v_new_crf_idseq,
                     p_return_code               => v_return_code,
                     p_return_desc               => v_return_desc
                    );
         ELSE                                       -- v_qtl_name = 'TEMPLATE'
            ins_template (p_version                   => v_version,
                          p_preferred_name            => v_preferred_name,
                          p_long_name                 => v_long_name,
                          p_preferred_definition      => v_preferred_definition,
                          p_conte_idseq               => v_conte_idseq,
                          --p_proto_idseq          => v_proto_idseq,
                          p_asl_name                  => v_asl_name,
                          p_qcdl_name                 => crf_rec.qcdl_name,
                          p_created_by                => v_created_by,
                          p_tmplt_idseq               => v_new_crf_idseq,
                          p_return_code               => v_return_code,
                          p_return_desc               => v_return_desc
                         );
         END IF;

         IF v_return_code IS NOT NULL
         THEN
            DBMS_OUTPUT.put_line (SUBSTR (v_return_desc, 1, 200));
            DBMS_OUTPUT.put_line ('v_return_code = ' || v_return_code);
            DBMS_OUTPUT.put_line (   'v_return_desc = '
                                  || SUBSTR (v_return_desc, 1, 255)
                                 );
            RAISE e_crf_error;
         END IF;

         DBMS_OUTPUT.put_line (   'inserted '
                               || v_qtl_name
                               || ' = "'
                               || v_preferred_name
                               || '" qc_idseq = "'
                               || v_new_crf_idseq
                               || '"'
                              );
         p_new_crf_idseq := v_new_crf_idseq;

         -- 31-Mar-2004, W. Ver Hoef - added FOR LOOP to copy ac_csi assignments
         FOR accsi_rec IN c_src_accsi
         LOOP
            v_src_cs_csi_idseq := accsi_rec.cs_csi_idseq;
            v_new_ac_csi_idseq := NULL;
            sbrext_set_row.set_accsi
                             (p_return_code              => v_return_code,
                              p_action                   => 'INS',
                              p_accsi_ac_csi_idseq       => v_new_ac_csi_idseq,
                              p_accsi_ac_idseq           => v_new_crf_idseq,
                              p_accsi_cs_csi_idseq       => v_src_cs_csi_idseq,
                              p_accsi_date_created       => v_accsi_date_created,
                              p_accsi_created_by         => v_accsi_created_by,
                              p_accsi_date_modified      => v_accsi_date_modified,
                              p_accsi_modified_by        => v_accsi_modified_by
                             );

            IF v_return_code IS NOT NULL
            THEN
               DBMS_OUTPUT.put_line ('v_return_code = ' || v_return_code);
               RAISE e_accsi_error;
            END IF;

            v_id_reference (i).old_idseq := p_src_crf_idseq;
            v_id_reference (i).new_idseq := v_new_crf_idseq;
            i := i + 1;
         END LOOP;

         -- loop through CRF's modules
         FOR mod_rec IN c_src_mod
         LOOP
            v_qtl_name_for_msg := mod_rec.qtl_name;

            -- create a unique preferred name for the new module
            SELECT SUBSTR (mod_rec.preferred_name, 1, 20) || qc_seq.NEXTVAL
              INTO v_preferred_name
              FROM DUAL;

            IF mod_rec.qtl_name = 'MODULE'
            THEN
               -- insert the CRF's modules
               ins_module
                     (p_crf_idseq                 => v_new_crf_idseq,
                      p_version                   => v_version,
                      p_preferred_name            => v_preferred_name,
                      p_long_name                 => mod_rec.long_name,
                      p_preferred_definition      => mod_rec.preferred_definition,
                      p_conte_idseq               => v_conte_idseq,
                      p_proto_idseq               => v_proto_idseq,
                      p_asl_name                  => v_asl_name,
                      p_created_by                => v_created_by,
                      p_display_order             => mod_rec.display_order,
                      p_mod_idseq                 => v_new_mod_idseq,
                      p_repeat_number             => mod_rec.repeat_no,
                      p_qr_idseq                  => v_qr_idseq,
                      p_return_code               => v_return_code,
                      p_return_desc               => v_return_desc
                     );
            ELSIF mod_rec.qtl_name IN ('FORM_INSTR', 'CRF_INSTR')
            THEN
               -- insert the form's instructions
               ins_form_instr
                     (p_crf_idseq                 => v_new_crf_idseq,
                      p_version                   => v_version,
                      p_preferred_name            => v_preferred_name,
                      p_long_name                 => mod_rec.long_name,
                      p_preferred_definition      => mod_rec.preferred_definition,
                      p_conte_idseq               => v_conte_idseq,
                      p_proto_idseq               => v_proto_idseq,
                      p_asl_name                  => v_asl_name,
                      p_created_by                => v_created_by,
                      p_display_order             => mod_rec.display_order,
                      p_form_instr_idseq          => v_new_form_instr_idseq,
                      p_qr_idseq                  => v_qr_idseq,
                      p_return_code               => v_return_code,
                      p_return_desc               => v_return_desc
                     );
            END IF;

            IF v_return_code IS NOT NULL
            THEN
               RAISE e_mod_error;
            END IF;

            DBMS_OUTPUT.put_line (   'inserted '
                                  || mod_rec.qtl_name
                                  || ' = "'
                                  || mod_rec.preferred_name
                                  || '"'
                                 );
            v_id_reference (i).old_idseq := mod_rec.mod_idseq;
            v_id_reference (i).new_idseq :=
                                 NVL (v_new_mod_idseq, v_new_form_instr_idseq);
            i := i + 1;

            IF mod_rec.qtl_name = 'MODULE'
            THEN
               v_src_mod_idseq := mod_rec.mod_idseq;

               -- loop through the module's questions
               FOR ques_rec IN c_src_ques
               LOOP
                  v_qtl_name_for_msg := ques_rec.qtl_name;

                  -- create a unique preferred name for the new question
                  SELECT    SUBSTR (ques_rec.preferred_name, 1, 20)
                         || qc_seq.NEXTVAL
                    INTO v_preferred_name
                    FROM DUAL;

                  IF TRIM (ques_rec.qtl_name) = 'QUESTION'
                  THEN
                     -- insert the module's questions
                     -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to ques_req.display_order below
                     ins_question
                        (p_mod_idseq                 => v_new_mod_idseq,
                         p_version                   => v_version,
                         p_preferred_name            => v_preferred_name,
                         p_long_name                 => ques_rec.long_name,
                         p_preferred_definition      => ques_rec.preferred_definition,
                         p_conte_idseq               => v_conte_idseq,
                         p_proto_idseq               => v_proto_idseq,
                         p_asl_name                  => v_asl_name,
                         p_de_idseq                  => ques_rec.de_idseq,
                         p_created_by                => v_created_by,
                         p_display_order             => ques_rec.display_order,
                         p_ques_idseq                => v_new_ques_idseq,
                         p_qr_idseq                  => v_qr_idseq,
                         p_return_code               => v_return_code,
                         p_return_desc               => v_return_desc
                        );
                  ELSIF ques_rec.qtl_name = 'MODULE_INSTR'
                  THEN
                     -- insert the module's instructions
                     -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to ques_req.display_order below
                     ins_mod_instr
                        (p_mod_idseq                 => v_new_mod_idseq,
                         p_version                   => v_version,
                         p_preferred_name            => v_preferred_name,
                         p_long_name                 => ques_rec.long_name,
                         p_preferred_definition      => ques_rec.preferred_definition,
                         p_conte_idseq               => v_conte_idseq,
                         p_proto_idseq               => v_proto_idseq,
                         p_asl_name                  => v_asl_name,
                         p_created_by                => v_created_by,
                         p_display_order             => ques_rec.display_order,
                         p_mod_instr_idseq           => v_new_mod_instr_idseq,
                         p_qr_idseq                  => v_qr_idseq,
                         p_return_code               => v_return_code,
                         p_return_desc               => v_return_desc
                        );
                  END IF;

                  IF v_return_code IS NOT NULL
                  THEN
                     RAISE e_ques_error;
                  END IF;

                  DBMS_OUTPUT.put_line (   'inserted '
                                        || ques_rec.qtl_name
                                        || ' = "'
                                        || ques_rec.preferred_name
                                        || '"'
                                       );
                  v_id_reference (i).old_idseq := ques_rec.ques_idseq;
                  v_id_reference (i).new_idseq :=
                                 NVL (v_new_ques_idseq, v_new_mod_instr_idseq);
                  i := i + 1;

                  IF ques_rec.qtl_name = 'QUESTION'
                  THEN
                     v_src_ques_idseq := ques_rec.ques_idseq;

                     -- loop through the question's values
                     FOR val_rec IN c_src_val
                     LOOP
                        v_qtl_name_for_msg := val_rec.qtl_name;

                        -- create a unique preferred name for the new value
                        SELECT    SUBSTR (val_rec.preferred_name, 1, 20)
                               || qc_seq.NEXTVAL
                          INTO v_preferred_name
                          FROM DUAL;

                        IF val_rec.qtl_name = 'VALID_VALUE'
                        THEN
                             -- insert the question's values
                           -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to val_req.display_order below
                           ins_value
                              (p_ques_idseq                => v_new_ques_idseq,
                               p_version                   => v_version,
                               p_preferred_name            => v_preferred_name,
                               p_long_name                 => val_rec.long_name,
                               p_preferred_definition      => val_rec.preferred_definition,
                               p_conte_idseq               => v_conte_idseq,
                               p_proto_idseq               => v_proto_idseq,
                               p_asl_name                  => v_asl_name,
                               p_vp_idseq                  => val_rec.vp_idseq,
                               p_created_by                => v_created_by,
                               p_display_order             => val_rec.display_order,
                               p_val_idseq                 => v_new_val_idseq,
                               p_qr_idseq                  => v_qr_idseq,
                               p_return_code               => v_return_code,
                               p_return_desc               => v_return_desc
                              );
                        ELSIF val_rec.qtl_name = 'QUESTION_INSTR'
                        THEN
                            -- insert the question's instructions
                           -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to val_req.display_order below
                           ins_ques_instr
                              (p_ques_idseq                => v_new_ques_idseq,
                               p_version                   => v_version,
                               p_preferred_name            => v_preferred_name,
                               p_long_name                 => val_rec.long_name,
                               p_preferred_definition      => val_rec.preferred_definition,
                               p_conte_idseq               => v_conte_idseq,
                               p_proto_idseq               => v_proto_idseq,
                               p_asl_name                  => v_asl_name,
                               p_created_by                => v_created_by,
                               p_display_order             => val_rec.display_order,
                               p_ques_instr_idseq          => v_new_ques_instr_idseq,
                               p_qr_idseq                  => v_qr_idseq,
                               p_return_code               => v_return_code,
                               p_return_desc               => v_return_desc
                              );
                        END IF;

                        IF v_return_code IS NOT NULL
                        THEN
                           RAISE e_val_error;
                        END IF;

                        DBMS_OUTPUT.put_line (   'inserted '
                                              || val_rec.qtl_name
                                              || ' = "'
                                              || val_rec.preferred_name
                                              || '"'
                                             );
                        v_id_reference (i).old_idseq := val_rec.val_idseq;
                        v_id_reference (i).new_idseq :=
                                 NVL (v_new_val_idseq, v_new_ques_instr_idseq);
                        i := i + 1;

                        IF val_rec.qtl_name = 'VALID_VALUE'
                        THEN
                           v_src_val_idseq := val_rec.val_idseq;

                           -- loop through the question's values
                           FOR val_instr_rec IN c_src_val_instr
                           LOOP
                              v_qtl_name_for_msg := val_instr_rec.qtl_name;

                              -- create a unique preferred name for the new value
                              SELECT    SUBSTR (val_instr_rec.preferred_name,
                                                1,
                                                20
                                               )
                                     || qc_seq.NEXTVAL
                                INTO v_preferred_name
                                FROM DUAL;

                              IF val_instr_rec.qtl_name = 'VALUE_INSTR'
                              THEN
                                 -- insert the question's values
                                 ins_val_instr
                                    (p_val_idseq                 => v_new_val_idseq,
                                     p_version                   => v_version,
                                     p_preferred_name            => v_preferred_name,
                                     p_long_name                 => val_instr_rec.long_name,
                                     p_preferred_definition      => val_instr_rec.preferred_definition,
                                     p_conte_idseq               => v_conte_idseq,
                                     p_proto_idseq               => v_proto_idseq,
                                     p_asl_name                  => v_asl_name,
                                     p_created_by                => v_created_by,
                                     p_display_order             => val_instr_rec.display_order,
                                     p_val_instr_idseq           => v_new_val_instr_idseq,
                                     p_qr_idseq                  => v_qr_idseq,
                                     p_return_code               => v_return_code,
                                     p_return_desc               => v_return_desc
                                    );
                              END IF;

                              IF v_return_code IS NOT NULL
                              THEN
                                 RAISE e_val_instr_error;
                              END IF;

                              DBMS_OUTPUT.put_line
                                              (   'inserted '
                                               || val_instr_rec.qtl_name
                                               || ' = "'
                                               || val_instr_rec.preferred_name
                                               || '"'
                                              );
                              v_id_reference (i).old_idseq :=
                                                 val_instr_rec.val_instr_idseq;
                              v_id_reference (i).new_idseq :=
                                                         v_new_val_instr_idseq;
                              i := i + 1;
                           END LOOP;     -- end of the value instructions loop
                        END IF;
       -- if val_rec.qtl_name = 'VALID_VALUE' - finished copying child records
                     END LOOP;                       -- end of the values loop
                  END IF;
         -- if ques_rec.qtl_name = 'QUESTION' - finished copying child records
               END LOOP;                             -- end the questions loop
            END IF;
            -- if mod_rec.qtl_name = 'MODULE' - finished copying child records
         END LOOP;                                     -- end the modules loop
      END LOOP;                                         -- end of the CRF loop

      copy_triggered_action (p_created_by, v_id_reference);
      copy_qa (p_created_by, v_id_reference);
      copy_quest_rep (p_created_by, v_id_reference);
      copy_va (p_created_by, v_id_reference);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code :=
                  'Error occurred while querying - exception = NO_DATA_FOUND';
         p_return_desc := SQLERRM;
         ROLLBACK;
      WHEN e_crf_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_mod_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_ques_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_val_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_val_instr_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      -- 31-Mar-2003, W. Ver Hoef - added exception for copying ac_csi
      WHEN e_accsi_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert AC_CSI for source record with cs_csi_idseq = '
            || v_src_cs_csi_idseq
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
         ROLLBACK;
   END copy_crf;

/******************************************************************************
   NAME:       update_de
   PURPOSE:    To copy an existing CRF and all its components.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1       3/23/2004   Prerna Aggarwal    1. Created this package.

******************************************************************************/
   PROCEDURE update_de (
      p_prm_qc_idseq   IN       VARCHAR2,
      p_de_idseq       IN       VARCHAR2,
      p_created_by     IN       VARCHAR2,
      p_return_code    OUT      VARCHAR2,
      p_return_desc    OUT      VARCHAR2
   )
   IS
      CURSOR qc_val
      IS
         SELECT c_qc_idseq
           FROM qc_recs_view_ext
          WHERE p_qc_idseq = p_prm_qc_idseq AND rl_name = 'ELEMENT_VALUE';

      CURSOR de_val
      IS
         SELECT   VALUE, vm.long_name, vp_idseq
             FROM data_elements_view d,
                  vd_pvs_view vp,
                  permissible_values_view pv,
                  value_meanings_view vm
            WHERE d.vd_idseq = vp.vd_idseq
              AND vp.pv_idseq = pv.pv_idseq
              AND de_idseq = p_de_idseq
              AND pv.vm_idseq = vm.vm_idseq
         ORDER BY UPPER (VALUE), UPPER (long_name);

      v_conte_idseq     VARCHAR2 (2000) DEFAULT NULL;
      v_proto_idseq     VARCHAR2 (2000) DEFAULT NULL;
      v_version         VARCHAR2 (2000) DEFAULT NULL;
      v_asl_name        VARCHAR2 (2000) DEFAULT NULL;
      v_crf_idseq       VARCHAR2 (2000) DEFAULT NULL;
      v_return_code     VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc     VARCHAR2 (2000) DEFAULT NULL;
      v_display_order   NUMBER          := 0;
      v_val_idseq       VARCHAR2 (2000) DEFAULT NULL;
      v_qr_idseq        VARCHAR2 (2000) DEFAULT NULL;
   BEGIN
-- delete old values of the  question
      FOR qv_rec IN qc_val
      LOOP
         remove_value (qv_rec.c_qc_idseq, v_return_code, v_return_desc);
      END LOOP;

      IF v_return_code IS NULL
      THEN
-- add new values to the question
         BEGIN
            SELECT dn_crf_idseq
              INTO v_crf_idseq
              FROM quest_contents_view_ext q
             WHERE qc_idseq = p_prm_qc_idseq;

            BEGIN
               SELECT conte_idseq, proto_idseq, VERSION, asl_name
                 INTO v_conte_idseq, v_proto_idseq, v_version, v_asl_name
                 FROM quest_contents_view_ext
                WHERE qc_idseq = v_crf_idseq;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_return_code := SQLCODE;
                  p_return_desc := SQLERRM;
            END;
         EXCEPTION
            WHEN OTHERS
            THEN
               p_return_code := SQLCODE;
               p_return_desc := SQLERRM;
         END;

         IF v_return_code IS NULL
         THEN
            FOR d_rec IN de_val
            LOOP
               v_display_order := v_display_order + 1;
               ins_value (p_prm_qc_idseq,
                          v_version,
                          set_name.set_qc_name (d_rec.VALUE),
                          d_rec.VALUE,
                          d_rec.long_name,
                          v_conte_idseq,
                          v_proto_idseq,
                          v_asl_name,
                          d_rec.vp_idseq,
                          p_created_by,
                          v_display_order,
                          v_val_idseq,
                          v_qr_idseq,
                          v_return_code,
                          v_return_desc
                         );
            END LOOP;
         END IF;

         IF v_return_code IS NULL
         THEN
            --update the de_idseq for the question
            BEGIN
               UPDATE quest_contents_view_ext
                  SET de_idseq = p_de_idseq,
                      modified_by = p_created_by
                WHERE qc_idseq = p_prm_qc_idseq;
            EXCEPTION
               WHEN OTHERS
               THEN
                  p_return_code := SQLCODE;
                  p_return_desc := SQLERRM;
            END;
         END IF;
      END IF;

      p_return_code := v_return_code;
      p_return_desc := v_return_desc;
   END update_de;

/******************************************************************************
   PROCEDURE:  remove_comp
   PURPOSE:    To delete components with no children
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        3/24/2004   Prerna Aggarwal     1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_comp (
      p_idseq         IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_idseq            CHAR (36)       := p_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
   BEGIN
      sbrext_form_builder_pkg.delete_child_records (v_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line (   'Errored out while deleting component '
                                  || v_idseq
                                 );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_comp;

/******************************************************************************
   PROCEDURE:  remove_instr
   PURPOSE:    To delete an instruction.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.1        4/2/2004    W. Ver Hoef      1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_instr (
      p_qc_idseq      IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_qc_idseq         CHAR (36)       := p_qc_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
   BEGIN
      -- delete_child_records is used here only to delete the qc_recs_ext record(s)
      sbrext_form_builder_pkg.delete_child_records (v_qc_idseq,
                                                    v_return_code,
                                                    v_return_desc
                                                   );

      IF v_return_code IS NOT NULL
      THEN
         p_return_code := v_return_code;
         p_return_desc := v_return_desc;
         RAISE e_deleting_child;
      END IF;

      BEGIN
         DELETE FROM quest_contents_ext
               WHERE qc_idseq = v_qc_idseq;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            DBMS_OUTPUT.put_line
                                (   'Errored out while deleting instruction '
                                 || v_qc_idseq
                                );
            DBMS_OUTPUT.put_line ('SQLERRM = ' || SQLERRM);
      END;
   EXCEPTION
      WHEN e_deleting_child
      THEN
         NULL;
             -- p_return_code and desc are already set, just need to exit now
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_instr;

/******************************************************************************
   PROCEDURE:  remove_rd
   PURPOSE:    To delete a reference Document.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        1/15/2004    Prerna Aggarwal 1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_rd (
      p_rd_idseq      IN       CHAR,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_rd_idseq         CHAR (36)       := p_rd_idseq;
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
   BEGIN
      -- delete_child_records is used here only to delete the qc_recs_ext record(s)
      DELETE FROM reference_blobs
            WHERE rd_idseq = v_rd_idseq;

      DELETE FROM reference_documents
            WHERE rd_idseq = v_rd_idseq;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_rd;

/******************************************************************************
   PROCEDURE:  remove_rd
   PURPOSE:    To delete an attachment.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        1/15/2004    Prerna Aggarwal 1. Created this procedure.

******************************************************************************/
   PROCEDURE remove_rb (
      p_name          IN       VARCHAR2,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_return_code      VARCHAR2 (2000) DEFAULT NULL;
      v_return_desc      VARCHAR2 (2000) DEFAULT NULL;
      e_deleting_child   EXCEPTION;
   BEGIN
      -- delete_child_records is used here only to delete the qc_recs_ext record(s)
      DELETE FROM reference_blobs
            WHERE NAME = p_name;
   EXCEPTION
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
   END remove_rb;

/******************************************************************************
   PROCEDURE:  ins_multi_values
   PURPOSE:    To insert a Value row into quest_contents_ext.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   3.0        4/25/2005   Prerna Aggarweal     1. Created this procedure.

******************************************************************************/
   PROCEDURE ins_multi_values (
      p_vv            IN       fb_validvaluelist,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_created_by       VARCHAR2 (30);
      v_vv_idseq         fb_idseq_list;
      v_qr_idseq         fb_idseq_list;
      v_instr_idseq      fb_idseq_list;
      v_instr_qr_idseq   fb_idseq_list;
   BEGIN
      FOR i IN 1 .. p_vv.COUNT
      LOOP
         IF i = 1
         THEN
            BEGIN
               SELECT created_by
                 INTO v_created_by
                 FROM quest_contents_ext
                WHERE qc_idseq = p_vv (i).parentidseq;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  p_return_code := 'API_QC_800';
                  p_return_desc := SQLERRM;
            END;
         END IF;

         IF p_return_code = NULL
         THEN
            ins_value (p_vv (i).parentidseq,
                       p_vv (i).VERSION,
                       p_vv (i).preferredname,
                       p_vv (i).longname,
                       p_vv (i).preferreddefinition,
                       p_vv (i).conte_idseq,
                       NULL,
                       p_vv (i).aslname,
                       p_vv (i).vpidseq,
                       v_created_by,
                       i,
                       v_vv_idseq (i).idseq,
                       v_qr_idseq (i).idseq,
                       p_return_code,
                       p_return_desc,
                       p_vv (i).meaningtext
                      );
         END IF;

         IF p_return_code IS NOT NULL
         THEN
            EXIT;
         END IF;

         IF p_vv (i).validvalueinstrlongname IS NOT NULL
         THEN
            ins_val_instr
                      (v_vv_idseq (i).idseq,
                       p_vv (i).VERSION,
                       set_name.set_qc_name (p_vv (i).validvalueinstrlongname),
                       p_vv (i).validvalueinstrlongname,
                       p_vv (i).validvalueinstrlongname,
                       p_vv (i).conte_idseq,
                       NULL,
                       p_vv (i).aslname,
                       v_created_by,
                       1,
                       v_instr_idseq (i).idseq,
                       v_instr_qr_idseq (i).idseq,
                       p_return_code,
                       p_return_desc
                      );
         END IF;

         IF p_return_code IS NOT NULL
         THEN
            EXIT;
         END IF;
      END LOOP;
   END;

   PROCEDURE ins_proto_qc (p_qc_idseq IN VARCHAR2, p_proto_idseq IN VARCHAR2)
   IS
   BEGIN
      IF p_proto_idseq IS NOT NULL
      THEN
         INSERT INTO protocol_qc_ext
                     (qc_idseq, proto_idseq
                     )
              VALUES (p_qc_idseq, p_proto_idseq
                     );
      END IF;
   END;

   PROCEDURE crf_version (
      p_idseq         IN       admin_components_view.ac_idseq%TYPE,
      p_version       IN       admin_components_view.VERSION%TYPE,
      p_change_note   IN       admin_components_view.change_note%TYPE,
      p_created_by    IN       admin_components_view.created_by%TYPE,
      p_new_idseq     OUT      VARCHAR2,
                      -- 02/13/2006  was  admin_components_View.ac_idseq%TYPE,
      p_return_code   OUT      VARCHAR2,
      p_return_desc   OUT      VARCHAR2
   )
   IS
      v_src_crf_idseq          VARCHAR2 (36)                       := p_idseq;
      v_src_mod_idseq          VARCHAR2 (36);
      v_src_ques_idseq         VARCHAR2 (36);
      v_src_val_idseq          VARCHAR2 (36);
      v_id_reference           id_reference;
      i                        NUMBER                                   := 1;

      CURSOR c_src_crf
    -- level 1, may return a CRF or TEMPLATE depending on the idseq parameter
      IS
         SELECT qc_idseq crf_idseq, qcdl_name
           FROM quest_contents_ext
          WHERE qc_idseq = v_src_crf_idseq;

      CURSOR c_src_mod           -- level 2, includes MODULEs and FORM_INSTRs
      IS
         SELECT qr.p_qc_idseq crf_idseq, qr.c_qc_idseq mod_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.repeat_no
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_crf_idseq
            AND qr.rl_name != 'MODULE_FORM'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                         'INSTRUCTION_FORM'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_ques       -- level 3, includes QUESTIONs and MODULE_INSTRs
      IS
         SELECT qr.p_qc_idseq mod_idseq, qr.c_qc_idseq ques_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.de_idseq
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_mod_idseq
            AND qr.rl_name !=
                           'ELEMENT_MODULE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                       'INSTRUCTION_MODULE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_val   -- level 4, includes VALID_VALUEs and QUESTION_INSTRs
      IS
         SELECT qr.p_qc_idseq ques_idseq, qr.c_qc_idseq val_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition, qc.vp_idseq
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_ques_idseq
            AND qr.rl_name !=
                            'VALUE_ELEMENT'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.rl_name !=
                      'INSTRUCTION_ELEMENT'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR c_src_val_instr                 -- level 5, includes VALUE_INSTRs
      IS
         SELECT qr.p_qc_idseq val_idseq, qr.c_qc_idseq val_instr_idseq,
                qr.display_order, qc.qtl_name, qc.preferred_name,
                qc.long_name, qc.preferred_definition
           FROM quest_contents_ext qc, qc_recs_ext qr
          WHERE qr.p_qc_idseq = v_src_val_idseq
            AND qr.rl_name !=
                        'INSTRUCTION_VALUE'
                                           -- 15-Mar-2004, W. Ver Hoef - added
            AND qr.c_qc_idseq = qc.qc_idseq
            AND qc.deleted_ind = 'No';

      CURSOR pq
      IS
         SELECT *
           FROM protocol_qc_ext
          WHERE qc_idseq = p_idseq;

      v_qtl_name               VARCHAR2 (2000);               --:= p_qtl_name;
      v_version                VARCHAR2 (2000)                    := p_version;
      v_preferred_name         VARCHAR2 (2000);
      v_crf_preferred_name     quest_contents_ext.preferred_name%TYPE;
      v_long_name              VARCHAR2 (2000);
      v_preferred_definition   VARCHAR2 (2000);
      v_conte_idseq            VARCHAR2 (36);                  -- scc was 2000
      v_proto_idseq            VARCHAR2 (2000);
      v_asl_name               VARCHAR2 (2000);
      v_created_by             VARCHAR2 (2000)                 := p_created_by;
      v_new_crf_idseq          VARCHAR2 (36);
      v_new_mod_idseq          VARCHAR2 (36);
      v_new_ques_idseq         VARCHAR2 (36);
      v_new_val_idseq          VARCHAR2 (36);
      v_new_form_instr_idseq   VARCHAR2 (36);
      v_new_mod_instr_idseq    VARCHAR2 (36);
      v_new_ques_instr_idseq   VARCHAR2 (36);
      v_new_val_instr_idseq    VARCHAR2 (36);
      v_qr_idseq               VARCHAR2 (36);
      v_return_code            VARCHAR2 (2000);
      v_return_desc            VARCHAR2 (2000);
      v_qtl_name_for_msg       VARCHAR2 (2000);
      v_src_count              NUMBER                                DEFAULT 0;
      -- 31-Mar-2004, W. Ver Hoef - added variables for copying ac_csi
      v_new_ac_csi_idseq       VARCHAR2 (36);
      v_src_cs_csi_idseq       VARCHAR2 (36);
      v_accsi_date_created     DATE;
      v_accsi_created_by       VARCHAR2 (2000);
      v_accsi_date_modified    DATE;
      v_accsi_modified_by      VARCHAR2 (2000);
      v_qc_id                  NUMBER;
      e_crf_error              EXCEPTION;
      e_mod_error              EXCEPTION;
      e_ques_error             EXCEPTION;
      e_val_error              EXCEPTION;
      e_val_instr_error        EXCEPTION;
      -- 31-Mar-2004, W. Ver Hoef - added exception for copying ac_csi
      e_accsi_error            EXCEPTION;
      v_scc_msg                VARCHAR2 (2000);                     -- TESTING
   BEGIN
      IF v_src_crf_idseq IS NULL
      THEN
         p_return_code := 'API_QC_xxx';
         p_return_desc := 'Source CRF idseq is mandatory';
         RETURN;
      ELSE
         SELECT COUNT (1)
           INTO v_src_count
           FROM quest_contents_ext
          WHERE qc_idseq = v_src_crf_idseq;

         IF v_src_count = 0
         THEN
            p_return_code := 'API_QC_xxx';
            p_return_desc :=
               'Source QC_IDSEQ does not match an existing QUEST_CONTENTS_EXT.QC_IDSEQ';
            RETURN;
         END IF;

         IF v_qtl_name NOT IN ('CRF', 'TEMPLATE')
         THEN
            p_return_code := 'API_QC_xxx'; -- PROTO_IDSEQ cannot be null here
            p_return_desc := 'P_QTL_NAME must be CRF or TEMPLATE';
            RETURN;
         END IF;
      END IF;

      -- Query for CRF's qcdl_name
      FOR crf_rec IN c_src_crf
      LOOP
         v_qtl_name_for_msg := v_qtl_name;

         SELECT qtl_name, preferred_name, preferred_definition,
                long_name, conte_idseq, qc_id
           INTO v_qtl_name, v_crf_preferred_name, v_preferred_definition,
                v_long_name, v_conte_idseq, v_qc_id
           FROM quest_contents_ext
          WHERE qc_idseq = p_idseq;

         FOR p_rec IN pq
         LOOP
            IF v_proto_idseq IS NULL
            THEN
               v_proto_idseq := p_rec.proto_idseq;
            ELSE
               v_proto_idseq := v_proto_idseq || ',' || p_rec.proto_idseq;
            END IF;
         END LOOP;

         v_asl_name := 'DRAFT NEW';
         meta_global_pkg.transaction_type := 'VERSION';

         -- insert form (level 1) record
         IF v_qtl_name = 'CRF'
         THEN
            ins_crf (p_version                   => v_version,
                     p_preferred_name            => v_crf_preferred_name,
                     p_long_name                 => v_long_name,
                     p_preferred_definition      => v_preferred_definition,
                     p_conte_idseq               => v_conte_idseq,
                     p_proto_idseq               => v_proto_idseq,
                     p_asl_name                  => 'DRAFT NEW',
                     p_qcdl_name                 => crf_rec.qcdl_name,
                     p_change_note               => p_change_note,
                     p_created_by                => v_created_by,
                     p_crf_idseq                 => v_new_crf_idseq,
                     p_return_code               => v_return_code,
                     p_return_desc               => v_return_desc
                    );
         ELSE                                       -- v_qtl_name = 'TEMPLATE'
            ins_template (p_version                   => v_version,
                          p_preferred_name            => v_crf_preferred_name,
                          p_long_name                 => v_long_name,
                          p_preferred_definition      => v_preferred_definition,
                          p_conte_idseq               => v_conte_idseq,
                          p_proto_idseq               => v_proto_idseq,
                          p_asl_name                  => 'DRAFT NEW',
                          p_qcdl_name                 => crf_rec.qcdl_name,
                          p_change_note               => p_change_note,
                          p_created_by                => v_created_by,
                          p_tmplt_idseq               => v_new_crf_idseq,
                          p_return_code               => v_return_code,
                          p_return_desc               => v_return_desc
                         );
         END IF;

         UPDATE quest_contents_ext
            SET qc_id = v_qc_id
          WHERE qc_idseq = v_new_crf_idseq;

         meta_global_pkg.transaction_type := NULL;

         --meta_config_mgmt.COPYPROTO(p_idseq,v_new_crf_idseq);
         IF v_return_code IS NOT NULL
         THEN
            RAISE e_crf_error;
         END IF;

         p_new_idseq := v_new_crf_idseq;
         meta_config_mgmt.latest_version_ind
                                     (p_ac_idseq            => p_new_idseq,
                                      p_component_type      => 'QUEST_CONTENT',
                                      p_preferred_name      => v_crf_preferred_name
                                     );
         meta_config_mgmt.create_ac_histories (p_idseq,
                                               p_new_idseq,
                                               'VERSIONED',
                                               'QUEST_CONTENT'
                                              );
          -- Now make a copy of all detail items (NOTE: having the transaction type
         -- set to version causes the security triggers for the following actions
         -- to be ignored).
         meta_config_mgmt.copyacnamescopy (p_idseq, p_new_idseq);
         meta_config_mgmt.copyacdefs (p_idseq, p_new_idseq);
         meta_config_mgmt.copyacdocs (p_idseq, p_new_idseq);
         meta_config_mgmt.copyaccsi (p_idseq, p_new_idseq);
         v_id_reference (i).old_idseq := p_idseq;
         v_id_reference (i).new_idseq := v_new_crf_idseq;
         i := i + 1;

         -- loop through CRF's modules
         FOR mod_rec IN c_src_mod
         LOOP
            v_qtl_name_for_msg := mod_rec.qtl_name;

            -- create a unique preferred name for the new module
            SELECT SUBSTR (mod_rec.preferred_name, 1, 20) || qc_seq.NEXTVAL
              INTO v_preferred_name
              FROM DUAL;

            IF mod_rec.qtl_name = 'MODULE'
            THEN
               -- insert the CRF's modules
               ins_module
                     (p_crf_idseq                 => v_new_crf_idseq,
                      p_version                   => v_version,
                      p_preferred_name            => v_preferred_name,
                      p_long_name                 => mod_rec.long_name,
                      p_preferred_definition      => mod_rec.preferred_definition,
                      p_conte_idseq               => v_conte_idseq,
                      --p_proto_idseq          => v_proto_idseq,
                      p_asl_name                  => v_asl_name,
                      p_created_by                => v_created_by,
                      p_display_order             => mod_rec.display_order,
                      p_repeat_number             => mod_rec.repeat_no,
                      p_mod_idseq                 => v_new_mod_idseq,
                      p_qr_idseq                  => v_qr_idseq,
                      p_return_code               => v_return_code,
                      p_return_desc               => v_return_desc
                     );
            ELSIF mod_rec.qtl_name IN ('FORM_INSTR', 'CRF_INSTR')
            THEN
               -- insert the form's instructions
               ins_form_instr
                     (p_crf_idseq                 => v_new_crf_idseq,
                      p_version                   => v_version,
                      p_preferred_name            => v_preferred_name,
                      p_long_name                 => mod_rec.long_name,
                      p_preferred_definition      => mod_rec.preferred_definition,
                      p_conte_idseq               => v_conte_idseq,
                      --p_proto_idseq          => v_proto_idseq,
                      p_asl_name                  => v_asl_name,
                      p_created_by                => v_created_by,
                      p_display_order             => mod_rec.display_order,
                      p_form_instr_idseq          => v_new_form_instr_idseq,
                      p_qr_idseq                  => v_qr_idseq,
                      p_return_code               => v_return_code,
                      p_return_desc               => v_return_desc
                     );
            END IF;

            IF v_return_code IS NOT NULL
            THEN
               RAISE e_mod_error;
            END IF;

            v_id_reference (i).old_idseq := mod_rec.mod_idseq;
            v_id_reference (i).new_idseq :=
                                 NVL (v_new_mod_idseq, v_new_form_instr_idseq);
            i := i + 1;

            IF mod_rec.qtl_name = 'MODULE'
            THEN
               v_src_mod_idseq := mod_rec.mod_idseq;

               -- loop through the module's questions
               FOR ques_rec IN c_src_ques
               LOOP
                  v_qtl_name_for_msg := ques_rec.qtl_name;

                  -- create a unique preferred name for the new question
                  SELECT    SUBSTR (ques_rec.preferred_name, 1, 20)
                         || qc_seq.NEXTVAL
                    INTO v_preferred_name
                    FROM DUAL;

                  IF TRIM (ques_rec.qtl_name) = 'QUESTION'
                  THEN
                     -- insert the module's questions
                     -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to ques_req.display_order below
                     ins_question
                        (p_mod_idseq                 => v_new_mod_idseq,
                         p_version                   => v_version,
                         p_preferred_name            => v_preferred_name,
                         p_long_name                 => ques_rec.long_name,
                         p_preferred_definition      => ques_rec.preferred_definition,
                         p_conte_idseq               => v_conte_idseq,
                         -- p_proto_idseq          => v_proto_idseq,
                         p_asl_name                  => v_asl_name,
                         p_de_idseq                  => ques_rec.de_idseq,
                         p_created_by                => v_created_by,
                         p_display_order             => ques_rec.display_order,
                         p_ques_idseq                => v_new_ques_idseq,
                         p_qr_idseq                  => v_qr_idseq,
                         p_return_code               => v_return_code,
                         p_return_desc               => v_return_desc
                        );
                  ELSIF ques_rec.qtl_name = 'MODULE_INSTR'
                  THEN
                     -- insert the module's instructions
                     -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to ques_req.display_order below
                     ins_mod_instr
                        (p_mod_idseq                 => v_new_mod_idseq,
                         p_version                   => v_version,
                         p_preferred_name            => v_preferred_name,
                         p_long_name                 => ques_rec.long_name,
                         p_preferred_definition      => ques_rec.preferred_definition,
                         p_conte_idseq               => v_conte_idseq,
                         --p_proto_idseq          => v_proto_idseq,
                         p_asl_name                  => v_asl_name,
                         p_created_by                => v_created_by,
                         p_display_order             => ques_rec.display_order,
                         p_mod_instr_idseq           => v_new_mod_instr_idseq,
                         p_qr_idseq                  => v_qr_idseq,
                         p_return_code               => v_return_code,
                         p_return_desc               => v_return_desc
                        );
                  END IF;

                  IF v_return_code IS NOT NULL
                  THEN
                     RAISE e_ques_error;
                  END IF;

                  v_id_reference (i).old_idseq := ques_rec.ques_idseq;
                  v_id_reference (i).new_idseq :=
                                 NVL (v_new_ques_idseq, v_new_mod_instr_idseq);
                  i := i + 1;

                  IF ques_rec.qtl_name = 'QUESTION'
                  THEN
                     v_src_ques_idseq := ques_rec.ques_idseq;

                     -- loop through the question's values
                     FOR val_rec IN c_src_val
                     LOOP
                        v_qtl_name_for_msg := val_rec.qtl_name;

                        -- create a unique preferred name for the new value
                        SELECT    SUBSTR (val_rec.preferred_name, 1, 20)
                               || qc_seq.NEXTVAL
                          INTO v_preferred_name
                          FROM DUAL;

                        IF val_rec.qtl_name = 'VALID_VALUE'
                        THEN
                             -- insert the question's values
                           -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to val_req.display_order below
                           ins_value
                              (p_ques_idseq                => v_new_ques_idseq,
                               p_version                   => v_version,
                               p_preferred_name            => v_preferred_name,
                               p_long_name                 => val_rec.long_name,
                               p_preferred_definition      => val_rec.preferred_definition,
                               p_conte_idseq               => v_conte_idseq,
                               --p_proto_idseq          => v_proto_idseq,
                               p_asl_name                  => v_asl_name,
                               p_vp_idseq                  => val_rec.vp_idseq,
                               p_created_by                => v_created_by,
                               p_display_order             => val_rec.display_order,
                               p_val_idseq                 => v_new_val_idseq,
                               p_qr_idseq                  => v_qr_idseq,
                               p_return_code               => v_return_code,
                               p_return_desc               => v_return_desc
                              );
                        ELSIF val_rec.qtl_name = 'QUESTION_INSTR'
                        THEN
                            -- insert the question's instructions
                           -- 31-Mar-2004, W. Ver Hoef - changed mod_rec.display_order to val_req.display_order below
                           ins_ques_instr
                              (p_ques_idseq                => v_new_ques_idseq,
                               p_version                   => v_version,
                               p_preferred_name            => v_preferred_name,
                               p_long_name                 => val_rec.long_name,
                               p_preferred_definition      => val_rec.preferred_definition,
                               p_conte_idseq               => v_conte_idseq,
                               -- p_proto_idseq          => v_proto_idseq,
                               p_asl_name                  => v_asl_name,
                               p_created_by                => v_created_by,
                               p_display_order             => val_rec.display_order,
                               p_ques_instr_idseq          => v_new_ques_instr_idseq,
                               p_qr_idseq                  => v_qr_idseq,
                               p_return_code               => v_return_code,
                               p_return_desc               => v_return_desc
                              );
                        END IF;

                        IF v_return_code IS NOT NULL
                        THEN
                           RAISE e_val_error;
                        END IF;

                        v_id_reference (i).old_idseq := val_rec.val_idseq;
                        v_id_reference (i).new_idseq :=
                                 NVL (v_new_val_idseq, v_new_ques_instr_idseq);
                        i := i + 1;

                        IF val_rec.qtl_name = 'VALID_VALUE'
                        THEN
                           v_src_val_idseq := val_rec.val_idseq;

                           -- loop through the question's values
                           FOR val_instr_rec IN c_src_val_instr
                           LOOP
                              v_qtl_name_for_msg := val_instr_rec.qtl_name;

                              -- create a unique preferred name for the new value
                              SELECT    SUBSTR (val_instr_rec.preferred_name,
                                                1,
                                                20
                                               )
                                     || qc_seq.NEXTVAL
                                INTO v_preferred_name
                                FROM DUAL;

                              IF val_instr_rec.qtl_name = 'VALUE_INSTR'
                              THEN
                                 -- insert the question's values
                                 ins_val_instr
                                    (p_val_idseq                 => v_new_val_idseq,
                                     p_version                   => v_version,
                                     p_preferred_name            => v_preferred_name,
                                     p_long_name                 => val_instr_rec.long_name,
                                     p_preferred_definition      => val_instr_rec.preferred_definition,
                                     p_conte_idseq               => v_conte_idseq,
                                     -- p_proto_idseq          => v_proto_idseq,
                                     p_asl_name                  => v_asl_name,
                                     p_created_by                => v_created_by,
                                     p_display_order             => val_instr_rec.display_order,
                                     p_val_instr_idseq           => v_new_val_instr_idseq,
                                     p_qr_idseq                  => v_qr_idseq,
                                     p_return_code               => v_return_code,
                                     p_return_desc               => v_return_desc
                                    );
                              END IF;

                              IF v_return_code IS NOT NULL
                              THEN
                                 RAISE e_val_instr_error;
                              END IF;

                              v_id_reference (i).old_idseq :=
                                                 val_instr_rec.val_instr_idseq;
                              v_id_reference (i).new_idseq :=
                                                         v_new_val_instr_idseq;
                              i := i + 1;
                           END LOOP;     -- end of the value instructions loop
                        END IF;
       -- if val_rec.qtl_name = 'VALID_VALUE' - finished copying child records
                     END LOOP;                       -- end of the values loop
                  END IF;
         -- if ques_rec.qtl_name = 'QUESTION' - finished copying child records
               END LOOP;                             -- end the questions loop
            END IF;
            -- if mod_rec.qtl_name = 'MODULE' - finished copying child records
         END LOOP;                                     -- end the modules loop
      END LOOP;                                         -- end of the CRF loop

      copy_triggered_action (p_created_by, v_id_reference);
      copy_qa (p_created_by, v_id_reference);
      copy_va (p_created_by, v_id_reference);
      copy_quest_rep (p_created_by, v_id_reference);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_return_code :=
                  'Error occurred while querying - exception = NO_DATA_FOUND';
         p_return_desc := SQLERRM;
         ROLLBACK;
      WHEN e_crf_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_mod_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_ques_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_val_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN e_val_instr_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert '
            || v_qtl_name_for_msg
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      -- 31-Mar-2003, W. Ver Hoef - added exception for copying ac_csi
      WHEN e_accsi_error
      THEN
         p_return_code :=
               'Error occurred while trying to insert AC_CSI for source record with cs_csi_idseq = '
            || v_src_cs_csi_idseq
            || ': '
            || v_return_code;
         p_return_desc := v_return_desc;
         ROLLBACK;
      WHEN OTHERS
      THEN
         p_return_code := SQLCODE;
         p_return_desc := SQLERRM;
         ROLLBACK;
   END;

   PROCEDURE copy_triggered_action (p_user IN VARCHAR2, p_ref IN id_reference)
   IS
      CURSOR triggered_action (p_src_idseq IN VARCHAR2)
      IS
         SELECT *
           FROM triggered_actions_ext
          WHERE s_qc_idseq = p_src_idseq;
   BEGIN
      DBMS_OUTPUT.put_line (1);

      FOR i IN 1 .. p_ref.COUNT
      LOOP
         FOR t_rec IN triggered_action (p_ref (i).old_idseq)
         LOOP
            FOR j IN 1 .. p_ref.COUNT
            LOOP
               IF t_rec.t_qc_idseq = p_ref (j).old_idseq
               THEN
                  INSERT INTO triggered_actions_ext
                              (ta_idseq,
                               s_qc_idseq, t_qc_idseq,
                               action, criterion_value,
                               trigger_realtionship,
                               forced_value, date_created,
                               created_by, ta_instruction,
                               t_qtl_name, s_qtl_name,
                               t_de_idseq, t_module_name,
                               t_question_name, t_cde_id,
                               t_de_version
                              )
                       VALUES (admincomponent_crud.cmr_guid,
                               p_ref (i).new_idseq, p_ref (j).new_idseq,
                               t_rec.action, t_rec.criterion_value,
                               t_rec.trigger_realtionship,
                               t_rec.forced_value, SYSDATE,
                               t_rec.created_by, t_rec.ta_instruction,
                               t_rec.t_qtl_name, t_rec.t_qtl_name,
                               t_rec.t_de_idseq, t_rec.t_module_name,
                               t_rec.t_question_name, t_rec.t_cde_id,
                               t_rec.t_de_version
                              );
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line (2);
   END;

   PROCEDURE copy_qa (p_user IN VARCHAR2, p_ref IN id_reference)
   IS
      CURSOR quest_att (p_src_idseq IN VARCHAR2)
      IS
         SELECT *
           FROM quest_attributes_ext
          WHERE qc_idseq = p_src_idseq;

      v_vv_idseq     CHAR (36);
      v_found        BOOLEAN        := FALSE;
      v_long_name    VARCHAR2 (255);
      vv_long_name   VARCHAR2 (255);
   BEGIN
      FOR i IN 1 .. p_ref.COUNT
      LOOP
         FOR q_rec IN quest_att (p_ref (i).old_idseq)
         LOOP
            v_vv_idseq := NULL;
            v_found := FALSE;

            FOR j IN 1 .. p_ref.COUNT
            LOOP
               IF q_rec.vv_idseq = p_ref (j).old_idseq AND NOT v_found
               THEN
                  v_found := TRUE;
                  v_vv_idseq := p_ref (j).new_idseq;
               END IF;
            /* if (v_vv_idseq is not null) then
              insert into QUEST_ATTRIBUTES_EXT(VV_IDSEQ
                                                  ,QC_IDSEQ
                                                  ,QUEST_IDSEQ
                                                   ,EDITABLE_IND
                                                   ,DATE_CREATED
                                                   ,CREATED_BY
                                                   ,DEFAULT_VALUE
                                         ,MANDATORY_IND            )
              values(v_vv_idseq
                       ,p_ref(i).new_idseq
                     ,admincomponent_crud.cmr_guid
                       ,q_rec.EDITABLE_IND
                       ,sysdate
                       ,p_user
                       ,q_rec.DEFAULT_VALUE
                       ,q_rec.MANDATORY_IND  )   ;
              end if;*/
            END LOOP;

            IF (   q_rec.DEFAULT_VALUE IS NOT NULL
                OR v_found
                OR q_rec.editable_ind IS NOT NULL
                OR q_rec.mandatory_ind IS NOT NULL
               )
            THEN
               INSERT INTO quest_attributes_ext
                           (qc_idseq,
                            quest_idseq,
                            editable_ind, date_created, created_by,
                            DEFAULT_VALUE, mandatory_ind,
                            vv_idseq
                           )
                    VALUES (p_ref (i).new_idseq,
                            admincomponent_crud.cmr_guid,
                            q_rec.editable_ind, SYSDATE, p_user,
                            q_rec.DEFAULT_VALUE, q_rec.mandatory_ind,
                            v_vv_idseq
                           );
            END IF;
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line ('finished copy_qa');
   END;

   PROCEDURE copy_quest_rep (p_user IN VARCHAR2, p_ref IN id_reference)
   IS
      CURSOR quest_vv (p_src_idseq IN VARCHAR2)
      IS
         SELECT *
           FROM quest_vv_ext
          WHERE quest_idseq = p_src_idseq;

      v_found      BOOLEAN   := FALSE;
      v_vv_idseq   CHAR (36);
   BEGIN
      FOR i IN 1 .. p_ref.COUNT
      LOOP
         FOR q_rec IN quest_vv (p_ref (i).old_idseq)
         LOOP
            v_vv_idseq := NULL;
            v_found := FALSE;

            FOR j IN 1 .. p_ref.COUNT
            LOOP
               IF q_rec.vv_idseq = p_ref (j).old_idseq AND NOT v_found
               THEN
                  v_found := TRUE;
                  v_vv_idseq := p_ref (j).new_idseq;
               END IF;

               IF (v_vv_idseq IS NOT NULL OR q_rec.VALUE IS NOT NULL)
               THEN
                  INSERT INTO quest_vv_ext
                              (qv_idseq,
                               quest_idseq, vv_idseq, VALUE,
                               editable_ind, repeat_sequence,
                               date_created, created_by
                              )
                       VALUES (admincomponent_crud.cmr_guid,
                               p_ref (i).new_idseq, v_vv_idseq, q_rec.VALUE,
                               q_rec.editable_ind, q_rec.repeat_sequence,
                               SYSDATE, p_user
                              );
               END IF;
            END LOOP;
         END LOOP;
      END LOOP;
   END;

   PROCEDURE copy_va (p_user IN VARCHAR2, p_ref IN id_reference)
   IS
      CURSOR vv_att (p_src_idseq IN VARCHAR2)
      IS
         SELECT *
           FROM valid_values_att_ext
          WHERE qc_idseq = p_src_idseq;

      v_meaning_text   VARCHAR2 (36);
      v_found          BOOLEAN        := FALSE;
      v_long_name      VARCHAR2 (255);
      vv_long_name     VARCHAR2 (255);
   BEGIN
      FOR i IN 1 .. p_ref.COUNT
      LOOP
         FOR v_rec IN vv_att (p_ref (i).old_idseq)
         LOOP
            INSERT INTO valid_values_att_ext
                        (qc_idseq, date_created, created_by,
                         meaning_text, description_text
                        )
                 VALUES (p_ref (i).new_idseq, SYSDATE, p_user,
                         v_rec.meaning_text, v_rec.description_text
                        );
         END LOOP;
      END LOOP;

      DBMS_OUTPUT.put_line ('finished copy_vv');
   END;

   PROCEDURE delete_quest_cond (prm_qcon_idseq IN VARCHAR2)
   IS
      CURSOR qcon
      IS
         SELECT     p_qcon_idseq
               FROM condition_components_ext
         START WITH p_qcon_idseq = prm_qcon_idseq
         CONNECT BY PRIOR p_qcon_idseq = c_qcon_idseq;
   BEGIN
      FOR q_rec IN qcon
      LOOP
         DELETE FROM condition_message_ext
               WHERE qcon_idseq = q_rec.p_qcon_idseq;

         DELETE FROM condition_components_ext
               WHERE c_qcon_idseq = prm_qcon_idseq
                  OR p_qcon_idseq = q_rec.p_qcon_idseq;

         DELETE      quest_attributes_ext
               WHERE qcon_idseq = q_rec.p_qcon_idseq;

         DELETE FROM question_conditions_ext
               WHERE qcon_idseq = q_rec.p_qcon_idseq;
      END LOOP;
   END;
END sbrext_form_builder_pkg;
/
