-- run with SBREXT user
--------------------------------------------------------
--  DDL for Package SBREXT_CDE_CURATOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SBREXT"."SBREXT_CDE_CURATOR_PKG" AS
    PROCEDURE set_de(
        p_return_code               OUT      VARCHAR2
       ,p_action                    IN       VARCHAR2
       ,p_de_de_idseq               IN OUT   VARCHAR2
       ,p_de_preferred_name         IN OUT   VARCHAR2
       ,p_de_conte_idseq            IN OUT   VARCHAR2
       ,p_de_version                IN OUT   NUMBER
       ,p_de_preferred_definition   IN OUT   VARCHAR2
       ,p_de_dec_idseq              IN OUT   VARCHAR2
       ,p_de_vd_idseq               IN OUT   VARCHAR2
       ,p_de_asl_name               IN OUT   VARCHAR2
       ,p_de_latest_version_ind     IN OUT   VARCHAR2
       ,p_de_long_name              IN OUT   VARCHAR2
       ,p_de_begin_date             IN OUT   VARCHAR2
       ,p_de_end_date               IN OUT   VARCHAR2
       ,p_de_change_note            IN OUT   VARCHAR2
       ,p_de_created_by             OUT      VARCHAR2
       ,p_de_date_created           OUT      VARCHAR2
       ,p_de_modified_by            OUT      VARCHAR2
       ,p_de_date_modified          OUT      VARCHAR2
       ,p_de_deleted_ind            OUT      VARCHAR2
       ,p_de_language               IN       VARCHAR2
       ,p_cde_id                    OUT      VARCHAR2
       ,p_de_origin                 IN       VARCHAR2 DEFAULT NULL );   -- 16-Jul-2003, W. Ver Hoef

    PROCEDURE set_de_version(
        p_return_code               OUT      VARCHAR2
       ,p_de_de_idseq               IN OUT   VARCHAR2
       ,p_de_preferred_name         IN OUT   VARCHAR2
       ,p_de_version                IN OUT   NUMBER
       ,p_de_preferred_definition   IN OUT   VARCHAR2
       ,p_de_dec_idseq              IN OUT   VARCHAR2
       ,p_de_vd_idseq               IN OUT   VARCHAR2
       ,p_de_asl_name               IN OUT   VARCHAR2
       ,p_de_latest_version_ind     IN OUT   VARCHAR2
       ,p_de_long_name              IN OUT   VARCHAR2
       ,p_de_begin_date             IN OUT   VARCHAR2
       ,p_de_end_date               IN OUT   VARCHAR2
       ,p_de_change_note            IN OUT   VARCHAR2
       ,p_de_created_by             OUT      VARCHAR2
       ,p_de_date_created           OUT      VARCHAR2
       ,p_de_modified_by            OUT      VARCHAR2
       ,p_de_date_modified          OUT      VARCHAR2
       ,p_de_deleted_ind            OUT      VARCHAR2
       ,p_cde_id                    OUT      VARCHAR2
       ,p_new_de_idseq              OUT      VARCHAR2
       ,p_de_origin                 IN       VARCHAR2 DEFAULT NULL );   -- 31-Jul-2003, Prerna Aggarwal


    --select * from de_view_ext;
    TYPE type_de_search IS REF CURSOR;   --RETURN de_search_result%ROWTYPE;

    PROCEDURE search_de(
        p_de_idseq                 IN       VARCHAR2 DEFAULT NULL
       ,p_search_string            IN       VARCHAR2 DEFAULT NULL
       ,p_conte_idseq              IN       VARCHAR2 DEFAULT NULL
       ,p_context                  IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name                 IN       VARCHAR2 DEFAULT NULL
       ,p_cde_id                   IN       VARCHAR2 DEFAULT NULL
       ,p_de_search_res            OUT      type_de_search
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_03b
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_created_starting_date    IN       VARCHAR2 DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params per SPRF_2.1_10a
       ,p_permissible_value        IN       VARCHAR2 DEFAULT NULL   -- 03-Mar-2004, W. Ver Hoef  added per SPRF_2.1_09
       ,p_doc_text                 IN       VARCHAR2 DEFAULT NULL   -- 04-Mar-2004, W. Ver Hoef added per SPRF_2.1_16
       ,p_historical_cde_id        IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_12
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL
                    -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       -- 10-Mar-2004, W. Ver Hoef changed default to null from 'Yes'
    ,   p_doc_types                IN       VARCHAR2 DEFAULT NULL
       -- 15-Mar-2004, W. Ver Hoef added per mod to SPRF_2.1_16
    ,   p_context_use              IN       VARCHAR2 DEFAULT NULL   -- 18-Mar-2004, W. Ver Hoef added per SPRF_2.1_15
       ,p_protocol_id              IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_crf_name                 IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_version                  IN       NUMBER DEFAULT 0   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_pv_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_dec_idseq                IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_vd_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_cs_csi_idseq             IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_cd_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_crtl_name                IN       VARCHAR2 DEFAULT NULL   -- 01-Nov-2005, S. Alred (TT#1716)
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 23-Nov-2005, S. Alred (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 23-Nov-2005, S. Alred (TT1780)
       ,p_vm_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 11-Mar-2008, PAGGARWA
                                                                 );

    -- 22-Jul-2003, W. Ver Hoef added type and get_associated_de per SPRF_2.0_07
    TYPE type_assoc_de IS REF CURSOR;

    PROCEDURE get_associated_de(
        p_pv_idseq       IN       VARCHAR2
       ,p_dec_idseq      IN       VARCHAR2
       ,p_vd_idseq       IN       VARCHAR2
       ,p_cd_idseq       IN       VARCHAR2
       ,p_cs_csi_idseq   IN       VARCHAR2   --added on 7/30/03 by Prerna Aggarwal for SPRF_2.0_20
       ,p_return_code    OUT      VARCHAR2
       ,p_return_desc    OUT      VARCHAR2
       ,p_assoc_de_res   OUT      type_assoc_de );

    CURSOR de_crf_search_result IS
        SELECT d.preferred_name
              ,d.long_name
              ,d.preferred_definition
              ,d.asl_name
              ,d.conte_idseq
              ,d.begin_date
              ,d.end_date
              ,c.NAME
              ,d.dec_idseq
              ,NVL( DEC.long_name, DEC.preferred_name ) dec_name
              ,d.vd_idseq
              ,NVL( vd.long_name, vd.preferred_name ) vd_name
              ,d.VERSION
              ,r.doc_text
              ,d.cde_id   --  ,i.min_cde_id -- 30-Mar-2004, W. Ver Hoef per Prerna's request
              ,d.change_note
              --,d.origin de_source_name
        ,      sn.doc_text de_source_name
              ,des.lae_name LANGUAGE
              ,d.de_idseq
              ,des.desig_idseq
              ,r.rd_idseq doc_rd_idseq
              ,sn.rd_idseq de_sn_rd_idseq
              ,DEC.preferred_name dec_pref_name
              ,vd.preferred_name vd_pref_name
              ,hsn.doc_text historic_short_cde_name
              ,q.crf crf_name
              ,p.protocol_id
          FROM data_elements_view d
              ,data_element_concepts_view DEC
              ,value_domains_view vd
              ,contexts c
              ,de_long_name_view r
              ,de_source_name_view sn
              ,de_cn_language_view des
              ,de_short_name_view hsn
              ,quest_crf_view_ext q
              ,protocols_view_ext p
         WHERE d.conte_idseq = c.conte_idseq
           AND d.dec_idseq = DEC.dec_idseq
           AND d.vd_idseq = vd.vd_idseq
           AND d.de_idseq = r.ac_idseq(+)
           --    AND         d.de_idseq = i.ac_idseq(+) -- 30-Mar-2004, W. Ver Hoef per Prerna's request
             -- AND         d.de_idseq = sn.ac_idseq(+)
           AND d.de_idseq = des.ac_idseq(+)
           AND d.de_idseq = hsn.ac_idseq(+)
           AND d.de_idseq = q.de_idseq(+)
           AND q.proto_idseq = p.proto_idseq(+);

    TYPE type_de_crf_search IS REF CURSOR;   -- RETURN de_crf_search_result%ROWTYPE;

    PROCEDURE search_crf_de(
        p_context                  IN       VARCHAR2 DEFAULT NULL
       ,p_crf_name                 IN       VARCHAR2 DEFAULT NULL
       ,p_protocol_id              IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name                 IN       VARCHAR2
       ,p_cde_id                   IN       VARCHAR2
       ,p_de_crf_search_res        OUT      type_de_crf_search
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added "by" per SPRF_2.1_10a
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 10-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 25-Mar-2004, W. Ver Hoef added per SPRF_21_03b
       ,p_crtl_name                IN       VARCHAR2 DEFAULT NULL   -- 01-Nov-2005, S. Alred (TT#1716)
                                                                 );

    /* 03-Jul-2003, W. Ver Hoef commented out cursor and return type below, also added
                                  p_qc_id and p_asl_name parameters to procedure search_crfvalue
    CURSOR quest_vv_search_result IS
        SELECT    qv.qc_idseq,
                  qv.long_name value,
                  qv.vp_idseq,
                  pv.value permissible_Value,
                  pv.short_meaning value_meaning
        FROM       quest_contents_view_ext qv,
                       quest_contents_view_ext qq,
                       vd_pvs_view vp,
                       permissible_values_view pv
       WHERE       qv.p_qst_idseq = qq.qc_idseq
       AND         qv.vp_idseq  = vp.vp_idseq(+)
       AND         vp.pv_idseq  = pv.pv_idseq(+)
       AND         qv.qtl_name = 'VALID_VALUE';
    */
    TYPE type_quest_vv_search IS REF CURSOR;   -- RETURN quest_vv_search_result%ROWTYPE;

    PROCEDURE search_crfvalue(
        p_quest_idseq     IN       VARCHAR2
       ,p_qc_id           IN       VARCHAR2   -- 03-Jul-2003, W. Ver Hoef
       ,p_asl_name        IN       VARCHAR2
       ,p_vv_search_res   OUT      type_quest_vv_search );

    --012203 add
    CURSOR pvvm_search_result IS
         /*select pv_idseq,
                value,
                short_meaning,
                begin_date,
                end_date
         from permissible_values;*/
        --changed on 8/8/2003 to include cd_idseq search criteris for SPRF_2.0_22 Prerna Aggarwal
        -- 16-Feb-2004, W. Ver Hoef added vm_description per SPRF_2.1_20
        SELECT pv_idseq
              ,p.VALUE
              ,vm.long_name short_meaning
              ,p.begin_date
              ,p.end_date
              ,p.meaning_description
              ,NVL( c.long_name, c.preferred_name )   -- added preferred_name on 9/04/2003
              ,c.VERSION
              -- added on 9/04/2003
        ,      vm.preferred_definition vm_description   -- 16-Feb-2004, W. Ver Hoef added
          FROM permissible_values p
              ,cd_vms d
              ,conceptual_domains c
              ,value_meanings vm   -- 16-Feb-2004, W. Ver Hoef added
         WHERE p.vm_idseq = d.vm_idseq
         AND d.cd_idseq = c.cd_idseq
         AND p.vm_idseq = vm.vm_idseq;

    -- 16-Feb-2004, W. Ver Hoef added
    TYPE type_pvname_search IS REF CURSOR;   -- RETURN pvvm_search_result%ROWTYPE;

    PROCEDURE search_pvvm(
        p_search_string     IN       VARCHAR2
       ,p_cd_idseq          IN       VARCHAR2
       ,p_pvvm_search_res   OUT      type_pvname_search
       ,p_con_name          IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq         IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                          );

    TYPE type_vm_search IS REF CURSOR;

    PROCEDURE search_vm(
        p_search_string   IN       VARCHAR2 DEFAULT NULL
       ,p_cd_idseq        IN       VARCHAR2 DEFAULT NULL
       ,p_description     IN       VARCHAR2 DEFAULT NULL
       ,p_condr_idseq     IN       VARCHAR2 DEFAULT NULL
       ,p_vm_search_res   OUT      type_vm_search
       ,p_con_name        IN       VARCHAR2 DEFAULT NULL
       ,p_con_idseq       IN       VARCHAR2 DEFAULT NULL
           ,p_id       IN       VARCHAR2 DEFAULT NULL
           ,p_version_ind IN     VARCHAR2 DEFAULT NULL
          ,p_version IN NUMBER DEFAULT NULL);

    CURSOR cs_name_de_search_result IS
        SELECT cs.cs_idseq
              ,NVL( cs.long_name, cs.preferred_name ) long_name
              ,csi.csi_idseq
              ,csi.csi_name
              ,acsi.ac_csi_idseq   --31-jul-2003 Prerna Aggarwal
              ,acsi.cs_csi_idseq   --08/01/03 PRerna Aggarwal
          FROM classification_schemes cs
              ,class_scheme_items csi
              ,cs_csi
              ,ac_csi acsi
         WHERE acsi.cs_csi_idseq = cs_csi.cs_csi_idseq
           AND cs_csi.cs_idseq = cs.cs_idseq
           AND cs_csi.csi_idseq = csi.csi_idseq;

    TYPE type_csname_search IS REF CURSOR;   -- RETURN cs_name_de_search_result%ROWTYPE;

    PROCEDURE search_de_cs_name( p_de_idseq IN VARCHAR2, p_cs_search_res OUT type_csname_search );

    -- Search DEC new requirement
    CURSOR dec_search_result IS
        SELECT DEC.preferred_name
              ,DEC.long_name
              ,DEC.preferred_definition
              ,DEC.asl_name
              ,DEC.conte_idseq
              ,DEC.begin_date
              ,DEC.end_date
              ,DEC.VERSION
              ,DEC.dec_idseq
              ,DEC.change_note
              ,c.NAME CONTEXT
              ,NVL( cd.long_name, cd.preferred_name ) cd_name
              ,NVL( oc.long_name, oc.preferred_name ) ocl_name
              ,NVL( prop.long_name, prop.preferred_name ) propl_name
              ,DEC.obj_class_qualifier
              ,DEC.property_qualifier
              ,des.lae_name LANGUAGE
              ,des.desig_idseq lae_des_idseq
              ,cd.cd_idseq
              ,DEC.oc_idseq
              ,DEC.prop_idseq
              ,u.NAME alias_name
              ,uc.NAME used_by_context
              ,u.desig_idseq
          FROM data_element_concepts_view DEC
              ,conceptual_domains_view cd
              ,contexts_view c
              ,object_classes_view_ext oc
              ,properties_view_ext prop
              ,de_cn_language_view des
              ,used_by_view u
              ,contexts_view uc
         WHERE DEC.conte_idseq = c.conte_idseq
           AND DEC.cd_idseq = cd.cd_idseq
           AND DEC.oc_idseq = oc.oc_idseq(+)
           AND DEC.prop_idseq = prop.prop_idseq(+)
           AND DEC.dec_idseq = des.ac_idseq(+)
           AND DEC.dec_idseq = u.ac_idseq(+)
           AND u.conte_idseq = uc.conte_idseq(+);

    TYPE type_dec_search IS REF CURSOR;   --RETURN dec_search_result%ROWTYPE;

    PROCEDURE search_dec(
        p_conte_idseq              IN       VARCHAR2 DEFAULT NULL
       ,p_search_string            IN       VARCHAR2
       ,p_context                  IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name                 IN       VARCHAR2
       ,p_dec_idseq                IN       VARCHAR2
       ,p_dec_id                   IN       VARCHAR2
       ,p_dec_search_res           OUT      type_dec_search
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 07-Feb-2013, for //GF32398
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_oc_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_14
       ,p_prop_idseq               IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_14
       ,p_created_starting_date    IN       VARCHAR2 DEFAULT NULL
       -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
    ,   p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params per SPRF_2.1_10a
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_version                  IN       NUMBER DEFAULT 0   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_cd_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_de_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_3a
       ,p_cscsi_idseq              IN       VARCHAR2 DEFAULT NULL   -- 10-Nov-2005; SAlred; TT1098
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                                 );

    -- 10-Mar-2004, W. Ver Hoef changed default from Yes to null

    -- end search dec

    --30-JUL-2003 PRerna Aggarwal added new package per SPRF_2.0_19
    TYPE type_csi_search IS REF CURSOR;

    PROCEDURE search_csi(
        p_search_string   IN       class_scheme_items_view.csi_name%TYPE DEFAULT NULL
       --,p_cs_long_name      in varchar2 default null changed on 8/4/03 on request by Scenpro Prerna Aggarwal
    ,   p_cs_idseq        IN       VARCHAR2
       ,p_conte_name      IN       VARCHAR2 DEFAULT NULL
       ,p_csi_res         OUT      type_csi_search );

    -- 22-Jul-2003, W. Ver Hoef added type and get_associated_dec per SPRF_2.0_07
    TYPE type_assoc_dec IS REF CURSOR;

    PROCEDURE get_associated_dec(
        p_de_idseq        IN       VARCHAR2
       ,p_cd_idseq        IN       VARCHAR2
       ,p_return_code     OUT      VARCHAR2
       ,p_return_desc     OUT      VARCHAR2
       ,p_assoc_dec_res   OUT      type_assoc_dec
       ,p_prop_idseq      IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_oc_idseq        IN       VARCHAR2 DEFAULT NULL );   -- added p_prop_idseq and p_oc_idseq

    -- Search vd new requirement
    CURSOR vd_search_result IS
        SELECT vd.preferred_name
              ,vd.long_name
              ,vd.preferred_definition
              ,vd.conte_idseq
              ,vd.asl_name
              ,vd.vd_idseq
              ,vd.VERSION
              ,vd.dtl_name
              ,vd.begin_date
              ,vd.end_date
              ,vd.vd_type_flag
              ,vd.change_note
              ,vd.uoml_name
              ,vd.forml_name
              ,vd.max_length_num
              ,vd.min_length_num
              ,vd.decimal_place
              ,vd.char_set_name
              ,vd.high_value_num
              ,vd.low_value_num
              ,NVL( r.long_name, r.preferred_name ) rep_term
              ,vd.rep_idseq
              ,vd.qualifier_name
              ,c.NAME CONTEXT
              ,vd.cd_idseq
              ,NVL( cd.long_name, cd.preferred_name ) cd_name
              ,des.lae_name LANGUAGE
              ,des.desig_idseq lae_des_idseq
              ,u.NAME usedby_name
              ,uc.NAME used_by_context
              ,u.desig_idseq u_desig_idseq
          FROM value_domains_view vd
              ,conceptual_domains_view cd
              ,contexts_view c
              ,de_cn_language_view des
              ,used_by_view u
              ,contexts_view uc
              ,REPRESENTATIONS_EXT r
         WHERE vd.conte_idseq = c.conte_idseq
           AND vd.cd_idseq = cd.cd_idseq
           AND vd.vd_idseq = des.ac_idseq(+)
           AND vd.rep_idseq = r.rep_idseq(+)
           AND vd.vd_idseq = u.ac_idseq(+)
           AND u.conte_idseq = uc.conte_idseq(+);

    TYPE type_vd_search IS REF CURSOR;   --RETURN vd_search_result%ROWTYPE;

    PROCEDURE search_vd(
        p_conte_idseq              IN       VARCHAR2 DEFAULT NULL
       ,p_search_string            IN       VARCHAR2
       ,p_context                  IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name                 IN       VARCHAR2
       ,p_vd_idseq                 IN       VARCHAR2
       ,p_vd_id                    IN       VARCHAR2
       ,p_vd_search_res            OUT      type_vd_search
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 12-Feb-2013, for GF32398
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params per SPRF_2.1_10a
       ,p_permissible_value        IN       VARCHAR2 DEFAULT NULL   -- 03-Mar-2004, W. Ver Hoef added per SPRF_2.1_09
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_vd_type_flag             IN       VARCHAR2 DEFAULT NULL   -- 23-Mar-2004, W. Ver Hoef added per SPRF_2.1_13
       ,p_version                  IN       NUMBER DEFAULT 0   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_cd_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_pv_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_de_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_3a
       ,p_datatype                 IN       VARCHAR2 DEFAULT NULL   -- 31-Oct-2005, S. Alred; added per TT#1684
       ,p_cscsi_idseq              IN       VARCHAR2 DEFAULT NULL   -- 10-Nov-2005, S. Alred; added per TT#1098
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_vm_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 11-Mar-2008, PAGGARWA
                                                                 );

    -- end search vd

    -- 22-Jul-2003, W. Ver Hoef added type and get_associated_vd per SPRF_2.0_08
    TYPE type_assoc_vd IS REF CURSOR;

    -- 16-Feb-2004, W. Ver Hoef added paramter p_de_idseq per SPRF_2.1_19
    PROCEDURE get_associated_vd(
        p_pv_idseq       IN       VARCHAR2
       ,p_cd_idseq       IN       VARCHAR2
       ,p_return_code    OUT      VARCHAR2
       ,p_return_desc    OUT      VARCHAR2
       ,p_assoc_vd_res   OUT      type_assoc_vd
       ,p_de_idseq       IN       VARCHAR2 DEFAULT NULL );

    -- Search vd new requirement
    CURSOR vd_search_crf_result IS
        SELECT vd.preferred_name
              ,vd.long_name
              ,vd.preferred_definition
              ,vd.conte_idseq
              ,vd.asl_name
              ,vd.vd_idseq
              ,vd.VERSION
              ,vd.dtl_name
              ,vd.begin_date
              ,vd.end_date
              ,vd.vd_type_flag
              ,vd.change_note
              ,vd.uoml_name
              ,vd.forml_name
              ,vd.max_length_num
              ,vd.min_length_num
              ,vd.decimal_place
              ,vd.char_set_name
              ,vd.high_value_num
              ,vd.low_value_num
              ,NVL( r.long_name, r.preferred_name ) rep_term
              ,vd.rep_idseq
              ,vd.qualifier_name
              ,c.NAME CONTEXT
              ,vd.cd_idseq
              ,NVL( cd.long_name, cd.preferred_name ) cd_name
              ,des.lae_name LANGUAGE
              ,des.desig_idseq lae_des_idseq
              ,q.crf crf_name
              ,p.protocol_id
          FROM value_domains_view vd
              ,conceptual_domains_view cd
              ,contexts_view c
              ,de_cn_language_view des
              ,quest_crf_view_ext q
              ,protocols_view_ext p
              ,REPRESENTATIONS_EXT r
         WHERE vd.conte_idseq = c.conte_idseq
           AND vd.cd_idseq = cd.cd_idseq
           AND vd.vd_idseq = des.ac_idseq(+)
           AND vd.rep_idseq = r.rep_idseq(+)
           AND vd.vd_idseq = q.vd_idseq(+)
           AND q.proto_idseq = p.proto_idseq(+);

    TYPE type_vd_crf_search IS REF CURSOR;   -- RETURN vd_search_crf_result%ROWTYPE;

    PROCEDURE search_crf_vd(
        p_context             IN       VARCHAR2 DEFAULT NULL
       ,p_crf_name            IN       VARCHAR2 DEFAULT NULL
       ,p_protocol_id         IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name            IN       VARCHAR2
       ,p_vd_id               IN       VARCHAR2   -- 03-Jul-2003, W. Ver Hoef
       ,p_vd_crf_search_res   OUT      type_vd_crf_search );

    -- end search vd

    -- Search pv new requirement
    /*CURSOR pv_search_result IS
       SELECT   pv.pv_idseq,
                pv.value,
                pv.short_meaning ,
                vp.vp_idseq,
                vp.origin, -- 01-Jul-2003, W. Ver Hoef added origin to cursor
    --          pv.meaning_description pv_meaning_description -- 01-Apr-2004, W. Ver Hoef added
                vm.description vm_description -- 08-Apr-2004, W. Ver Hoef added to replace pv desc
       FROM     value_domains_view vd
               ,vd_pvs vp
               ,permissible_values_view pv
               ,value_meanings_lov_view vm -- 08-Apr-2004, W. Ver Hoef added
       WHERE    vd.vd_idseq      = vp.vd_idseq
       AND      vp.pv_idseq      = pv.pv_idseq
       AND      pv.short_meaning = vm.short_meaning; -- 08-Apr-2004, W. Ver Hoef added
    */
    TYPE type_pv_search IS REF CURSOR;   -- RETURN pv_search_result%ROWTYPE;

    PROCEDURE search_pv( p_vd_idseq IN VARCHAR2, p_pv_search_res OUT type_pv_search );

    -- end search vd

    -- Search doc source new requirement
    CURSOR docscr_search_result IS
        SELECT desv.ac_idseq
              ,desv.doc_text
          FROM de_source_name_view desv
              ,administered_components ac
         WHERE desv.ac_idseq = ac.ac_idseq;

    TYPE type_docscr_search IS REF CURSOR
        RETURN docscr_search_result%ROWTYPE;

    PROCEDURE search_docscr( p_conte_idseq IN VARCHAR2 DEFAULT NULL, p_docscr_search_res OUT type_docscr_search );

    -- end search vd
    CURSOR de_vv_list IS
        SELECT VALUE
              ,vm.long_name short_meaning
              ,meaning_description
              ,vp.origin   -- 02-Jul-2003, W. Ver Hoef added origin to cursor
          FROM data_elements_view d
              ,vd_pvs_view vp
              ,permissible_values_view pv
              ,value_meanings_view vm
         WHERE d.vd_idseq = vp.vd_idseq
         AND vp.pv_idseq = pv.pv_idseq
         AND pv.vm_idseq = vm.vm_idseq;

    TYPE type_de_vv IS REF CURSOR
        RETURN de_vv_list%ROWTYPE;

    PROCEDURE search_vv( p_de_idseq IN VARCHAR2, p_vv_cur OUT type_de_vv );

    /* 01-Jul-2003, W. Ver Hoef commented out definition of cursor since not needed anymore
    CURSOR de_csi_list IS
        SELECT     cs.cs_idseq
                   ,cs.preferred_name
                   ,csi.csi_idseq
                   ,csi.csi_name
                   ,csi.csitl_name
                   ,nvl(vd.long_name, vd.preferred_name) vd_name
         FROM      data_elements_view d
                  ,value_domains_view vd
                  ,ac_csi_view ac
                  ,cs_csi_view c
                  ,classification_schemes_view cs
                  ,class_scheme_items_view csi
       WHERE       d.vd_idseq = vd.vd_idseq
       AND         d.de_idseq = ac.ac_idseq
       AND         ac.cs_csi_idseq = c.cs_csi_idseq
       AND         c.cs_idseq = cs.cs_idseq
       AND         c.csi_idseq = csi.csi_idseq ;
    */

    -- 01-Jul-2003, W. Ver Hoef commented out reference to prop_search_result since
    --                            this is being converted to dynamic sql
    TYPE type_de_csi IS REF CURSOR;   -- RETURN de_csi_list%ROWTYPE;

    PROCEDURE search_cs(
        p_de_idseq   IN       VARCHAR2
       ,p_asl_name   IN       VARCHAR2   -- 01-Jul-2003, W. Ver Hoef
       ,p_cs_id      IN       VARCHAR2   -- 01-Jul-2003, W. Ver Hoef
       ,p_csi_cur    OUT      type_de_csi );

    PROCEDURE upd_cs(
        p_de_idseq      IN       VARCHAR2
       ,new_cs_idseq    IN       VARCHAR2
       ,new_csi_idseq   IN       VARCHAR2
       ,old_cs_idseq    IN       VARCHAR2 DEFAULT NULL
       ,old_csi_idseq   IN       VARCHAR2 DEFAULT NULL
       ,p_error_code    OUT      VARCHAR2 );

    PROCEDURE upd_de_context( p_de_idseq IN VARCHAR2, p_context_id IN VARCHAR2 );

    CURSOR vd_list IS
        SELECT vd.vd_idseq
              ,vd.preferred_name
              ,NVL( vd.long_name, vd.preferred_name ) long_name
              ,vd.asl_name
          FROM value_domains_view vd
              ,contexts_view c
         WHERE vd.conte_idseq = c.conte_idseq;

    TYPE type_vd IS REF CURSOR
        RETURN vd_list%ROWTYPE;

    PROCEDURE get_value_domain_list( p_context IN VARCHAR2 DEFAULT NULL, p_vd_cur OUT type_vd );

    CURSOR dec_list IS
        SELECT DEC.dec_idseq
              ,DEC.preferred_name
              ,NVL( DEC.long_name, DEC.preferred_name ) long_name
              ,DEC.asl_name
          FROM data_element_concepts_view DEC
              ,contexts_view c
         WHERE DEC.conte_idseq = c.conte_idseq;

    TYPE type_dec IS REF CURSOR
        RETURN dec_list%ROWTYPE;

    PROCEDURE get_data_element_concept_list( p_context IN VARCHAR2 DEFAULT NULL, p_dec_cur OUT type_dec );

    CURSOR cs_list IS
        SELECT cs.cs_idseq
              ,NVL( cs.long_name, cs.preferred_name ) long_name
              ,cs.asl_name
              ,c.NAME context_name
              ,cs.version
              ,cs.cs_id
          FROM classification_schemes_view cs
              ,contexts_view c
         WHERE cs.conte_idseq = c.conte_idseq;

    TYPE type_cs IS REF CURSOR
        RETURN cs_list%ROWTYPE;

    PROCEDURE get_class_scheme_list( p_context IN VARCHAR2 DEFAULT NULL, p_cs_cur OUT type_cs );

    CURSOR prop_list IS
        SELECT NVL( p.long_name, p.preferred_name ) long_name
              ,p.prop_idseq
          FROM properties_view_ext p
              ,contexts_view c
         WHERE p.conte_idseq = c.conte_idseq;

    TYPE type_prop IS REF CURSOR
        RETURN prop_list%ROWTYPE;

    PROCEDURE get_properties_list( p_context IN VARCHAR2 DEFAULT NULL, p_prop_cur OUT type_prop );

    CURSOR obj_list IS
        SELECT NVL( o.long_name, o.preferred_name ) long_name
              ,o.oc_idseq
          FROM object_classes_view_ext o
              ,contexts_view c
         WHERE o.conte_idseq = c.conte_idseq;

    TYPE type_obj IS REF CURSOR
        RETURN obj_list%ROWTYPE;

    PROCEDURE get_object_classes_list( p_context IN VARCHAR2 DEFAULT NULL, p_obj_cur OUT type_obj );

    CURSOR qual_list IS
        SELECT q.qualifier_name
          FROM qualifier_lov_view_ext q;

    TYPE type_qual IS REF CURSOR
        RETURN qual_list%ROWTYPE;

    PROCEDURE get_qualifiers_list( p_qual_cur OUT type_qual );

    --Representation 09DEC2002
    CURSOR rep_list IS
        SELECT r.representation_name
          FROM representation_lov_view_ext r;

    TYPE type_rep IS REF CURSOR
        RETURN rep_list%ROWTYPE;

    PROCEDURE get_representation_list( p_rep_cur OUT type_rep );

    CURSOR csi_list IS
        SELECT csi.csi_idseq
              ,csi.csi_name
          FROM class_scheme_items_view csi;

    TYPE type_csi IS REF CURSOR
        RETURN csi_list%ROWTYPE;

    PROCEDURE get_class_scheme_items_list( p_csi_cur OUT type_csi );

    CURSOR pv_list IS
        SELECT pv.pv_idseq
              ,pv.VALUE
              ,vm.long_name short_meaning
          FROM permissible_values_view pv
               ,value_meanings vm
          WHERE  pv.vm_idseq = vm.vm_idseq;

    TYPE type_pv IS REF CURSOR
        RETURN pv_list%ROWTYPE;

    PROCEDURE get_valid_values_list( p_pv_cur OUT type_pv );

    CURSOR sub_list IS
        SELECT content
              ,substitution
          FROM substitutions_view_ext
         WHERE TYPE = 'Abbreviation';

    TYPE type_sub IS REF CURSOR
        RETURN sub_list%ROWTYPE;

    PROCEDURE get_abbreviations_list( p_sub_cur OUT type_sub );

    FUNCTION get_de_dec_vd_count(
        p_contex_name   IN   VARCHAR2
       ,p_vd_idseq      IN   VARCHAR2
       ,p_dec_idseq     IN   VARCHAR2
       ,p_version       IN   NUMBER )
        RETURN NUMBER;

    --new gets procedure
    --CDE
    CURSOR cd_list IS
        SELECT cde.cd_idseq
              ,NVL( cde.long_name, cde.preferred_name ) long_name
              ,cde.asl_name
              ,c.NAME context_name
          FROM conceptual_domains_view cde
              ,contexts_view c
         WHERE cde.conte_idseq = c.conte_idseq;

    TYPE type_cd IS REF CURSOR
        RETURN cd_list%ROWTYPE;

    PROCEDURE get_conceptual_domain_list( p_context IN VARCHAR2 DEFAULT NULL, p_cd_cur OUT type_cd );

    -- 20-Feb-2004. W. Ver Hoef added functions and cs, csi names to cursor per SPRF_2.1_04
    FUNCTION get_cs_name( p_cs_idseq IN CHAR )
        RETURN VARCHAR2;

    FUNCTION get_csi_name( p_csi_idseq IN CHAR )
        RETURN VARCHAR2;

    CURSOR cscsi_list IS
        SELECT cc.cs_csi_idseq   -- 20-Feb-2003, W. Ver Hoef reordered so can use distinct function
              ,cc.cs_idseq   --                            in query in procedure body
              ,cc.csi_idseq
              ,cc.p_cs_csi_idseq   -- 12-Feb-2004, W. Ver Hoef added 4 columns per SPRF_2.1_04:
              ,cc.display_order   -- cs_csi_idseq, p_cs_csi_idseq, display_order, and label
              ,cc.label
              ,NVL( cs.long_name, cs.preferred_name ) cs_name   -- 20-Feb-2004, W. Ver Hoef
              ,csi.csi_name
              ,1 LEVEL   -- 04-Mar-2004, W. Ver Hoef added to help with indenting
          FROM cs_csi_view cc
              ,classification_schemes_view cs   -- 20-Feb-2004, W. Ver Hoef
              ,class_scheme_items_view csi
         WHERE cc.cs_idseq = cs.cs_idseq AND cc.csi_idseq = csi.csi_idseq;

    TYPE type_cscsi IS REF CURSOR
        RETURN cscsi_list%ROWTYPE;

    PROCEDURE get_cscsi_list( p_cscsi_cur OUT type_cscsi );

    CURSOR languages_list IS
        SELECT NAME
          FROM languages_lov_view;

    TYPE type_languages IS REF CURSOR
        RETURN languages_list%ROWTYPE;

    PROCEDURE get_languages_list( p_languages_cur OUT type_languages );

    /*CURSOR datatypes_list IS
        SELECT dtl_name
        FROM   datatypes_lov_view;*/
    TYPE type_datatypes IS REF CURSOR;   -- RETURN datatypes_list%ROWTYPE;

    PROCEDURE get_datatypes_list( p_datatypes_cur OUT type_datatypes );

    CURSOR uoml_list IS
        SELECT uoml_name
          FROM unit_of_measures_lov_view;

    TYPE type_uoml IS REF CURSOR
        RETURN uoml_list%ROWTYPE;

    PROCEDURE get_unit_of_measures_list( p_uoml_cur OUT type_uoml );

    CURSOR formats_list IS
        SELECT forml_name
          FROM formats_lov_view;

    TYPE type_formats IS REF CURSOR
        RETURN formats_list%ROWTYPE;

    PROCEDURE get_formats_list( p_formats_cur OUT type_formats );

    CURSOR cs_cscsi_list IS
        SELECT cs_csi_idseq
          FROM cs_csi_view;

    TYPE type_cs_cscsi IS REF CURSOR
        RETURN cs_cscsi_list%ROWTYPE;

    PROCEDURE get_cscsi( p_cs_idseq IN VARCHAR2, p_csi_idseq IN VARCHAR2, p_cs_cscsi_cur OUT type_cs_cscsi );

    CURSOR valuemeaning_list IS
        SELECT long_name short_meaning
              ,preferred_Definition description
              ,comments
          FROM value_meanings_view;

    TYPE type_valuemeaning IS REF CURSOR
        RETURN valuemeaning_list%ROWTYPE;

    -- 08-Jul-2003, W. Ver Hoef added parameter p_cd_idseq
    PROCEDURE get_valuemeaning_list( p_cd_idseq IN VARCHAR2, p_valuemeaning_cur OUT type_valuemeaning );

    --create de_version
    PROCEDURE de_version( p_ac_idseq IN admin_components_view.ac_idseq%TYPE, p_return_code OUT VARCHAR2 );

    --create vd_version
    PROCEDURE vd_version( p_ac_idseq IN admin_components_view.ac_idseq%TYPE, p_return_code OUT VARCHAR2 );

    /* 01-Jul-2003, W. Ver Hoef commented out definition of cursor since not needed anymore
    -- Search oc new requirement
    CURSOR oc_search_result IS
            SELECT     oc.preferred_name
                  ,oc.long_name
                  ,oc.preferred_definition
                  ,oc.conte_idseq
                  ,oc.asl_name
                  ,oc.oc_idseq
                  ,oc.version
                  ,oc.begin_date
                  ,oc.end_date
                  ,oc.change_note
                  ,oc.origin
                  ,oc.definition_source
                  ,c.name context
                  ,des.LAE_NAME language
                  ,des.DESIG_IDSEQ  lae_des_idseq
        FROM       object_classes_view_ext oc
                  ,contexts_view c
                  ,de_cn_language_view des
       WHERE       oc.conte_idseq = c.conte_idseq
       and         oc.oc_idseq = des.ac_idseq(+);
    */

    -- 01-Jul-2003, W. Ver Hoef replaced oc_search_result with dynamic sql cursor
    --                            in search_oc procedure body
    TYPE type_oc_search IS REF CURSOR;   -- RETURN oc_search_result%ROWTYPE;

    PROCEDURE search_oc(
        p_search_string   IN       VARCHAR2
       ,p_asl_name        IN       VARCHAR2
       ,p_context         IN       VARCHAR2 DEFAULT NULL
       ,p_oc_id           IN       VARCHAR2   -- 01-Jul-2003, W. Ver Hoef
       ,p_oc_search_res   OUT      type_oc_search
       ,p_con_name        IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq       IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                        );

    -- end search oc

    /* 01-Jul-2003, W. Ver Hoef commented out definition of cursor since not needed anymore
    -- Search prop new requirement
    CURSOR prop_search_result IS
            SELECT     prop.preferred_name
                  ,prop.long_name
                  ,prop.preferred_definition
                  ,prop.conte_idseq
                  ,prop.asl_name
                  ,prop.prop_idseq
                  ,prop.version
                  ,prop.begin_date
                  ,prop.end_date
                  ,prop.change_note
                  ,prop.origin
                  ,prop.definition_source
                  ,c.name context
                  ,des.LAE_NAME language
                  ,des.DESIG_IDSEQ  lae_des_idseq
        FROM       properties_view_ext prop
                  ,contexts_view c
                   ,de_cn_language_view des
       WHERE       prop.conte_idseq = c.conte_idseq
       and         prop.prop_idseq = des.ac_idseq(+);
    */

    -- 01-Jul-2003, W. Ver Hoef commented out reference to prop_search_result since
    --                            this is being converted to dynamic sql
    TYPE type_prop_search IS REF CURSOR;   -- RETURN prop_search_result%ROWTYPE;

    PROCEDURE search_prop(
        p_search_string     IN       VARCHAR2
       ,p_asl_name          IN       VARCHAR2 DEFAULT NULL
       ,p_context           IN       VARCHAR2 DEFAULT NULL
       ,p_prop_id           IN       VARCHAR2 DEFAULT NULL   -- 01-Jul-2003, W. Ver Hoef
       ,p_prop_search_res   OUT      type_prop_search
       ,p_con_name          IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq         IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                          );

    -- end search prop

    -- Search qual new requirement
    CURSOR qual_search_result IS
        SELECT qualifier_name
              ,description
              ,comments
          FROM qualifier_lov_view_ext qual;

    TYPE type_qual_search IS REF CURSOR;   -- RETURN qual_search_result%ROWTYPE;

    PROCEDURE search_qual( p_search_string IN VARCHAR2, p_qual_search_res OUT type_qual_search );

    -- end search qual

    /* 01-Jul-2003, W. Ver Hoef commented out definition of cursor since not needed anymore
    -- Search rep new requirement
    CURSOR rep_search_result IS
            SELECT     rep.preferred_name
                  ,rep.long_name
                  ,rep.preferred_definition
                  ,rep.conte_idseq
                  ,rep.asl_name
                  ,rep.rep_idseq
                  ,rep.version
                  ,rep.begin_date
                  ,rep.end_date
                  ,rep.change_note
                  ,rep.origin
                  ,rep.definition_source
                  ,c.name context
                  ,des.LAE_NAME language
                  ,des.DESIG_IDSEQ  lae_des_idseq
        FROM       representations_view_ext rep
                  ,contexts_view c
                   ,de_cn_language_view des
       WHERE       rep.conte_idseq = c.conte_idseq
       and         rep.rep_idseq = des.ac_idseq(+);
    */

    -- 01-Jul-2003, W. Ver Hoef commented out reference to rep_search_result since
    --                            this is being converted to dynamic sql
    TYPE type_rep_search IS REF CURSOR;   -- RETURN rep_search_result%ROWTYPE;

    PROCEDURE search_rep(
        p_search_string    IN       VARCHAR2
       ,p_asl_name         IN       VARCHAR2
       ,p_context          IN       VARCHAR2 DEFAULT NULL
       ,p_rep_id           IN       VARCHAR2 DEFAULT NULL   -- 01-Jul-2003, W. Ver Hoef
       ,p_rep_search_res   OUT      type_rep_search
       ,p_con_name         IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq        IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                         );

    TYPE type_con_res IS REF CURSOR;

    PROCEDURE get_ac_concepts( p_condr_idseq IN VARCHAR2, p_con_res OUT type_con_res );

    -- end search rep

    --  de count
    FUNCTION get_de_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_de_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_de_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER;

    --  vd count
    FUNCTION get_vd_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_vd_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_vd_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER;

    --  dec count
    FUNCTION get_dec_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_dec_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER;

    FUNCTION get_dec_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER;

    PROCEDURE delete_vd_pvs( p_vd_idseq IN VARCHAR2, p_return_code OUT VARCHAR2 );

    /*  03-Jul-2003, W. Ver Hoef commented out cursor and return spec for type_quest_search,
                                   also added parameter p_qc_id
    CURSOR quest_search_result IS
            SELECT  p.proto_idseq
                    ,p.protocol_id
                    ,crf.qc_idseq crf_idseq
                    ,nvl(crf.long_name,crf.preferred_name) crf_name
                    ,q.qc_idseq question_idseq
                    ,nvl(q.long_name,q.long_name) question
                    ,q.conte_idseq
                    ,c.name context
                    ,q.asl_name
                    ,q.de_idseq
                    ,nvl(d.long_name,d.preferred_name) de_long_name
                    ,d.vd_idseq de_vd_idseq
                    ,q.dn_vd_idseq ques_vd_idseq
                    ,nvl(v.long_name,v.preferred_name) value_domain_name
                    ,v.preferred_name vd_preferred_name
                    ,v.preferred_definition vd_preferred_definition
                    ,r.min_cde_id cde_id
                    ,q.highlight_ind
        FROM       quest_contents_view_ext q
                   ,protocols_view_ext p
                   ,data_elements_view d
                   ,contexts_view c
                   ,quest_contents_ext crf
                   ,de_cde_id_view  r
                   ,value_domains v
       WHERE      q.proto_idseq = p.proto_idseq(+)
       AND        q.dn_crf_idseq = crf.qc_idseq(+)
       AND        q.conte_idseq = c.conte_idseq
       AND        q.de_idseq = d.de_idseq(+)
       AND        d.de_idseq = r.ac_idseq(+)
       AND        q.dn_vd_idseq = v.vd_idseq(+)
       AND        q.qtl_name = 'QUESTION';
    */
    TYPE type_quest_search IS REF CURSOR;   -- RETURN quest_search_result%ROWTYPE;

    -- 19-Mar-2004, W. Ver Hoef substituted DRAFT NEW with function call below
    PROCEDURE search_question(
        p_user               IN       VARCHAR2
       ,p_asl_name           IN       VARCHAR2 DEFAULT Sbrext_Common_Routines.get_default_asl( 'INS' )
       ,   -- 'DRAFT NEW',
        p_qc_id              IN       VARCHAR2
       ,   -- 03-Jul-2003, W. Ver Hoef
        p_valid_crf          OUT      VARCHAR2
       ,p_quest_search_res   OUT      type_quest_search );

    -- Search CD - new requirement added 09-Jul-2003, by W. Ver Hoef
    TYPE type_cd_search IS REF CURSOR;

    PROCEDURE search_cd(
        p_search_string            IN       VARCHAR2
       ,p_conte_idseq              IN       VARCHAR2 DEFAULT NULL
       ,p_context                  IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name                 IN       VARCHAR2
       ,p_cd_idseq                 IN       VARCHAR2
       ,p_cd_id                    IN       VARCHAR2
       ,p_cd_search_res            OUT      type_cd_search
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL
       -- 20-Feb-2004, W. Ver Hoef added param per SPRF_2.1_17
    ,   p_created_by               IN       VARCHAR2
                DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef added create/mod by per SPRF_2.1_10a
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_version                  IN       NUMBER   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_value_meaning            IN       value_meanings_view.long_name%TYPE
                DEFAULT NULL   -- 13-Dec-2005; S. Alred; TT#1667
                            );   -- 10-Mar-2004, W. Ver Hoef changed default from Yes to null

    -- End Search CD

    -- 10-Mar-2004. W. Ver Hoef added function per mod to SPRF_2.1_10a
    -- which requested that created_by and modified_by output be the user's full
    -- name rather than login id
    FUNCTION get_ua_full_name( p_ua_name IN VARCHAR2 )
        RETURN VARCHAR2;

    -- 10-Mar-2004, W. Ver Hoef added procedure and type definition per SPRF_2.1_10b
    TYPE type_user_list IS REF CURSOR;

    PROCEDURE get_user_list( p_user_list_cur OUT type_user_list );

    -- 15-Mar-2004, W. Ver Hoef added procedure and type definition per SPRF_2.1_16a
    TYPE type_doc_types_list IS REF CURSOR;

    PROCEDURE get_doc_types_list( p_doc_types_list_cur OUT type_doc_types_list );

    -- 17-Mar-2004, W. Ver Hoef added procedure and type definition per SPRF_2.1_24
    TYPE type_complex_rep_types IS REF CURSOR;

    PROCEDURE get_complex_rep_type( p_complex_rep_types_cur OUT type_complex_rep_types );

    -- 17-Mar-2004, W. Ver Hoef added procedure and type definition per SPRF_2.1_06b
    TYPE type_cdt_components_types IS REF CURSOR;

    PROCEDURE get_complex_de(
        p_de_idseq             IN       VARCHAR2
       ,p_methods              OUT      VARCHAR2
       ,p_rule                 OUT      VARCHAR2
       ,p_concat_char          OUT      VARCHAR2
       ,p_crtl_name            OUT      VARCHAR2
       ,p_cdt_components_cur   OUT      type_cdt_components_types
       ,p_de_name               OUT      VARCHAR2
       ,p_de_id                   OUT      VARCHAR2
       ,p_de_version           OUT      VARCHAR2 );

    -- 30-Mar-2004, W. Ver Hoef added procedure and type definition per SPRF_2.1_16b
    TYPE type_ref_docs IS REF CURSOR;

    PROCEDURE get_reference_documents( p_ac_idseq IN VARCHAR2, p_dctl_name IN VARCHAR2, p_ref_docs_cur OUT type_ref_docs );

    -- This procedure was originally in sbrext_ss_api and was moved here on 31-Mar-2004
    -- 11-Feb-2004, W. Ver Hoef added type, cursor, and procedure per SPRF_2.1_21
    -- 31-Mar-2004, W. Ver Hoef added p_detl_name parameter per SPRF_2.1_21 mod
    -- 05-Apr-2004, W. Ver Hoef added d.ac_idseq and ac.long_name per another mod to SPRF_2.1_21
    CURSOR alt_name_cur IS
        SELECT d.desig_idseq
              ,d.conte_idseq
              ,c.NAME context_name
              ,d.NAME
              ,d.detl_name
              ,d.lae_name
              ,d.ac_idseq
              ,ac.long_name ac_long_name
          FROM designations_view d
              ,contexts_view c
              ,admin_components_view ac
         WHERE d.conte_idseq = c.conte_idseq AND d.ac_idseq = ac.ac_idseq;

    TYPE type_alt_name IS REF CURSOR;   -- RETURN alt_name_cur%ROWTYPE;

    PROCEDURE get_alternate_names( p_ac_idseq IN CHAR, p_detl_name IN VARCHAR2, p_alt_name_cur OUT type_alt_name );

    -- 23-Aug-2004, D Ladino - Added function to return protocol and crf related attributes for
    --                         the Data Element sent
    TYPE type_protocol_crf IS REF CURSOR;

    PROCEDURE get_protocol_crf( p_de_idseq IN CHAR, p_protocol_crf_cur OUT type_protocol_crf );

    TYPE type_con_search IS REF CURSOR;   -- RETURN oc_search_result%ROWTYPE;

        PROCEDURE search_con(
        p_search_string    IN       VARCHAR2 DEFAULT NULL
       ,p_asl_name         IN       VARCHAR2 DEFAULT NULL
       ,p_context          IN       VARCHAR2 DEFAULT NULL
       ,p_con_id           IN       VARCHAR2 DEFAULT NULL
       ,p_con_idseq        IN       VARCHAR2 DEFAULT NULL
       ,p_con_search_res   OUT      type_con_search
       ,p_dec_idseq        IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_vd_idseq         IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_definition       IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (GF634)
                                                         );

    -- TT1824; 11/10/2005
    PROCEDURE add_to_sentinel_cs( p_id_seq IN VARCHAR2, p_ua_name IN VARCHAR2, p_csi_idseq OUT VARCHAR2 );

    -- TT1824
    PROCEDURE remove_from_sentinel_cs( p_id_seq IN VARCHAR2, p_ua_name IN VARCHAR2 );

    -- TT1627; 11/11/2005
    TYPE type_toolopt_search IS REF CURSOR;

    PROCEDURE search_tool_options(
        p_tool_name            IN       VARCHAR2
       ,p_property             IN       VARCHAR2
       ,p_value                IN       VARCHAR2
       ,p_toolopt_search_res   OUT      type_toolopt_search
       ,p_return_code          OUT      VARCHAR2 );

    FUNCTION count_cds( p_pv_idseq IN permissible_values_view.pv_idseq%TYPE )
        RETURN NUMBER;

    PRAGMA RESTRICT_REFERENCES( count_cds, WNDS, RNPS );

    FUNCTION get_one_rd_name( p_ac_idseq IN reference_documents_view.ac_idseq%TYPE )
        RETURN VARCHAR2;

    FUNCTION get_one_alt_name( p_ac_idseq IN designations_view.ac_idseq%TYPE )
        RETURN VARCHAR2;

    FUNCTION get_one_cd_name( p_short_meaning IN value_meanings.long_name%TYPE )
        RETURN VARCHAR2;

    PRAGMA RESTRICT_REFERENCES( get_one_cd_name, WNDS, RNPS );

    FUNCTION Get_One_Con_Name(
        p_dec_idseq   IN   data_element_concepts_view.dec_idseq%TYPE
       ,p_vd_idseq    IN   value_domains_view.vd_idseq%TYPE )
        RETURN VARCHAR2;

    --    PRAGMA restrict_references(get_one_con_name, WNDS, RNPS);

    -- Set of REF CURSORs and related search procedures for TT#1001)
    --  S. Alred; 12/9/2005
    TYPE type_ac_contact IS REF CURSOR;

    PROCEDURE Search_Ac_Contact(
        p_ac_idseq            IN       ac_contacts_view.ac_idseq%TYPE
       ,p_acc_idseq           IN       ac_contacts_view.acc_idseq%TYPE
       ,p_ac_con_search_res   OUT      type_ac_contact );

    -- SPRF_3.1_16b (TT#1001)
    TYPE type_con_comm IS REF CURSOR;

    PROCEDURE search_contact_comm(
        p_org_idseq            IN       contact_comms_view.org_idseq%TYPE
       ,p_per_idseq            IN       contact_comms_view.per_idseq%TYPE
       ,p_ccomm_idseq          IN       contact_comms_view.ccomm_idseq%TYPE
       ,p_con_com_search_res   OUT      type_con_comm );

    -- SPRF_3.1_16c (TT#1001)
    TYPE type_con_addr IS REF CURSOR;

    PROCEDURE search_contact_addr(
        p_org_idseq             IN       contact_addresses_view.org_idseq%TYPE
       ,p_per_idseq             IN       contact_addresses_view.per_idseq%TYPE
       ,p_caddr_idseq           IN       contact_addresses_view.caddr_idseq%TYPE
       ,p_con_addr_search_res   OUT      type_con_addr );

    -- SPRF_3.1_16d (TT#1001)
    TYPE type_con_role IS REF CURSOR;

    PROCEDURE get_contact_roles_list( p_con_role_res OUT type_con_role );

    -- SPRF_3.1_16e (TT#1001)
    TYPE type_org_name IS REF CURSOR;

    PROCEDURE get_organization_list( p_org_name_res OUT type_org_name );

    -- SPRF_3.1_16f (TT#1001)
    TYPE type_per_name IS REF CURSOR;

    PROCEDURE get_persons_list( p_per_name_res OUT type_per_name );

    -- SPRF_3.1_16g (TT#1001)
    TYPE type_comm_type IS REF CURSOR;

    PROCEDURE get_comm_type_list( p_comm_type_res OUT type_comm_type );

    -- SPRF_3.1_16h (TT#1001)
    TYPE type_addr_type IS REF CURSOR;

    PROCEDURE get_addr_type_list( p_addr_type_res OUT type_addr_type );

    -- SPRF_3.1_2 (TT1716)
    FUNCTION Get_Crtl_Name( p_de_idseq IN data_elements_view.de_idseq%TYPE )
        RETURN VARCHAR2;

    PRAGMA RESTRICT_REFERENCES( Get_Crtl_Name, WNDS, RNPS );

END;
 
/

  GRANT EXECUTE ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."SBREXT_CDE_CURATOR_PKG" TO "DER_USER";
