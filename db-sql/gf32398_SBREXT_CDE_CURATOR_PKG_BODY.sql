-- run with SBREXT user
--------------------------------------------------------
--  DDL for Package Body SBREXT_CDE_CURATOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SBREXT"."SBREXT_CDE_CURATOR_PKG" AS
    -- function to count CDs
    FUNCTION count_cds( p_pv_idseq IN permissible_values_view.pv_idseq%TYPE )
        RETURN NUMBER IS
        -- return the count of the number of Conceptual Domains
        --  associated with a given permissible value
        -- S. Alred; 12/9/2005
        v_return   NUMBER := 0;
        CURSOR c_count_cds( p_pv_idseq permissible_values_view.pv_idseq%TYPE ) IS
            SELECT COUNT( cvv.cd_idseq )
              FROM cd_vms_view cvv
                  ,permissible_values_view pvv
             WHERE pvv.pv_idseq = p_pv_idseq
               AND pvv.vm_idseq = cvv.vm_idseq;
    BEGIN
        OPEN c_count_cds( p_pv_idseq );
        FETCH c_count_cds
         INTO v_return;
        CLOSE c_count_cds;
        RETURN( v_return );
    END count_cds;
        --  function to return one doc text from RD
    FUNCTION get_one_rd_name( p_ac_idseq IN reference_documents_view.ac_idseq%TYPE )
        RETURN VARCHAR2 IS
        /*
        ** Return one arbitrary referecne document text
        ** Parameter:
        **  ac_idseq
        ** S. Hegde 1/4/06
        **
        */
        v_return   reference_documents_view.doc_text%TYPE;
    BEGIN
        SELECT MIN( NVL(rdv.doc_text,rdv.name) )
          INTO v_return
          FROM reference_documents_view rdv
         WHERE rdv.ac_idseq = p_ac_idseq;
        RETURN v_return;
    END get_one_rd_name;
    --  function to return one alt name  from designations
    FUNCTION get_one_alt_name( p_ac_idseq IN designations_view.ac_idseq%TYPE )
        RETURN VARCHAR2 IS
        /*
        ** Return one arbitrary alternate name
        ** Parameter:
        **  ac_idseq
        ** S. Hegde 1/4/06
        **
        */
        v_return   designations_view.name%TYPE;
    BEGIN
        SELECT MIN( dv.name )
          INTO v_return
          FROM designations_view dv
         WHERE dv.ac_idseq = p_ac_idseq
         AND dv.detl_name <> 'USED_BY';
        RETURN v_return;
    END get_one_alt_name;
    --  function to return one CD name
    FUNCTION get_one_cd_name( p_short_meaning IN value_meanings.long_name%TYPE )
        RETURN VARCHAR2 IS
        /*
        ** Return one arbitrary conceptual domain name based on a PV short meaning value
        ** Parameter:
        **  p_short_meaning: permissible value value meaning
        ** S. Alred 12/9/2005
        **
        */
        v_return   conceptual_domains_view.preferred_name%TYPE;
    BEGIN
        SELECT MIN( cdv.preferred_name )
          INTO v_return
          FROM cd_vms_view cvv
              ,value_meanings_view vmv
              ,conceptual_domains_view cdv
         WHERE vmv.long_name = p_short_meaning
           AND vmv.vm_idseq = cvv.vm_idseq
           AND cvv.cd_idseq = cdv.cd_idseq;
        RETURN v_return;
    END get_one_cd_name;
    -- function to return one concept name
    FUNCTION Get_One_Con_Name(
        p_dec_idseq   IN   data_element_concepts_view.dec_idseq%TYPE
       ,p_vd_idseq    IN   value_domains_view.vd_idseq%TYPE )
        RETURN VARCHAR2 IS
        /*
        ** Return one arbitrary concept name based on a CDE primary key value
        ** Parameter:
        ** p_dec_idseq: data element concept primary key value
        ** p_vd_idseq: value domain primary key value
        ** S. Alred 11/23/2005
        ** S. Hegde 12/5/2005
        **
        */
        v_return   concepts_view_ext.long_name%TYPE;
    BEGIN
        -- get concept relationship from object class for dec
        IF p_dec_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM data_element_concepts_view DEC
                  ,object_classes_view_ext oc
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE DEC.oc_idseq = oc.oc_idseq
               AND oc.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND DEC.dec_idseq = p_dec_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from property for dec if not found in object class
        IF v_return IS NULL AND p_dec_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM data_element_concepts_view DEC
                  ,properties_view_ext prop
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE DEC.prop_idseq = prop.prop_idseq
               AND prop.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND DEC.dec_idseq = p_dec_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from conceptual domain for dec if not found in oc or property
        IF v_return IS NULL AND p_dec_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM data_element_concepts_view DEC
                  ,conceptual_domains_view cd
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE DEC.cd_idseq = cd.cd_idseq
               AND cd.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND DEC.dec_idseq = p_dec_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from referenced value domain for vd if not found in oc or property or dec_cd
        IF v_return IS NULL AND p_vd_idseq IS NOT NULL THEN   -- parent concept relationship
            SELECT MIN( con.long_name )
              INTO v_return
              FROM value_domains_view vd
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE vd.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND vd.vd_idseq = p_vd_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from rep term for vd if not found in oc or property or dec_cd or parent vd
        IF v_return IS NULL AND p_vd_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM value_domains_view vd
                  ,representations_view_ext rep
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE vd.rep_idseq = rep.rep_idseq
               AND rep.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND vd.vd_idseq = p_vd_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from value meaning for vd if not found in oc or prop or dec_cd or parent vd or rep term
        IF v_return IS NULL AND p_vd_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM vd_pvs_view vdpvs
                  ,permissible_values_view pv
                  ,value_meanings_view vm
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE vdpvs.pv_idseq = pv.pv_idseq
               AND pv.vm_idseq = vm.vm_idseq
               AND vm.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND vdpvs.vd_idseq = p_vd_idseq;
        END IF;
        IF v_return IS NOT NULL THEN
            RETURN v_return;
        END IF;
        -- get concept relationship from conceptual domain for vd if not found in oc or property or dec_cd or parent vd or rep term or vm
        IF v_return IS NULL AND p_vd_idseq IS NOT NULL THEN
            SELECT MIN( con.long_name )
              INTO v_return
              FROM value_domains_view vd
                  ,conceptual_domains_view cd
                  ,con_derivation_rules_view_ext condr
                  ,component_concepts_view_ext cc
                  ,concepts_view_ext con
             WHERE vd.cd_idseq = cd.cd_idseq
               AND cd.condr_idseq = condr.condr_idseq
               AND condr.condr_idseq = cc.condr_idseq
               AND cc.con_idseq = con.con_idseq
               AND vd.vd_idseq = p_vd_idseq;
        END IF;
        RETURN v_return;
    END Get_One_Con_Name;
    -- Return one of: a crt0_name; a set of parent CDE's, or NULL depending on whether a CDE
    -- is a complex CDE/ a child in a complex CDE relationship/ or a regular CDE respectively
    -- SPRF_3.1_2 (TT1716)
    -- S. Alred; 12/19/2005
    FUNCTION Get_Crtl_Name( p_de_idseq IN data_elements_view.de_idseq%TYPE )
        RETURN VARCHAR2 IS
        /*
        ** For TT1716:
        **     IF the CDE is a complex CDE then return its CRT name
        **     IF the CDE is not complex and is not a child in a CRT then return NULL
        **     IF the CDE is a child in a CRT, then return the set of
        **       partent CDE(s) as a comma delimited string
        **  S. Alred; 12/16/2005
        */
        v_return   VARCHAR2( 2000 ) := NULL;   -- needs to be big enough for multiple IDSEQ's
        i          NUMBER( 3, 0 )   := 0;   -- loop counter
        v_concat   VARCHAR2( 1 )    := ',';   -- variable for concatenation character
        CURSOR c_crtl_name( p_in data_elements_view.de_idseq%TYPE ) IS
            SELECT cxd.crtl_name
              FROM complex_data_elements cxd
             WHERE cxd.p_de_idseq = p_in;
        CURSOR c_parent_cdes( p_parent data_elements_view.de_idseq%TYPE ) IS
            SELECT cdr.p_de_idseq
              FROM complex_de_relationships cdr
             WHERE cdr.c_de_idseq = p_parent;
    BEGIN
        -- case 1: get the crtl_name for a complex DE
        OPEN c_crtl_name( p_de_idseq );
        FETCH c_crtl_name
         INTO v_return;
        IF c_crtl_name%NOTFOUND THEN
            -- if the cursor found nothing, then find the parents for a CDE that
            -- has parents in a complex relationship; if none are found, then the CDE
            -- is "regular" and return NULL
            FOR r_parent_cdes IN c_parent_cdes( p_de_idseq ) LOOP
                i := i + 1;
                IF i = 1 THEN
                    v_return := r_parent_cdes.p_de_idseq;
                ELSE
                    v_return := v_return || v_concat || r_parent_cdes.p_de_idseq;
                END IF;
            END LOOP;
        END IF;
        CLOSE c_crtl_name;
        RETURN v_return;
    END Get_Crtl_Name;
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
       ,p_de_origin                 IN       VARCHAR2 )   -- 16-Jul-2003, W. Ver Hoef
                                                       IS
        --
        -- Date:  16-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_de_origin to this procedure and to the call to
        --          sbrext_set_row.set_de; also added extra condition of p_action =
        --          'INS' prior to calling sbrext_set_row.set_des and commented out
        --          default values for v_de_idseq and v_desig_idseq because
        --          sbrext_set_row.set_de and set_des will generate values; replaced
        --          query to de_cde_id_view with data_elements_view because the view
        --          was not successfully returning the cde_id.
        --
        v_de_idseq            CHAR( 36 );   -- := admincomponent_crud.cmr_guid; - 16-JUL-2003, W. Ver Hoef
        v_desig_idseq         CHAR( 36 );   -- := admincomponent_crud.cmr_guid;
        v_des_name            VARCHAR2( 2000 );
        v_detl_name           VARCHAR2( 20 )  := 'CONTEXT NAME';
        v_des_date_created    VARCHAR2( 30 );
        v_des_created_by      VARCHAR2( 30 );
        v_des_date_modified   VARCHAR2( 30 );
        v_des_modified_by     VARCHAR2( 30 );
        v_deleted_ind         VARCHAR2( 3 );
        v_language            VARCHAR2( 30 )  := p_de_language;
    BEGIN
        IF p_action = 'INS' THEN   -- 16-Jul-2003, W. Ver Hoef
            v_de_idseq := NULL;
        ELSE
            v_de_idseq := p_de_de_idseq;
            admin_security_util.g_effective_user := p_de_modified_by;
        END IF;
        Sbrext_Set_Row.set_de( p_return_code
                              ,p_action
                              ,v_de_idseq
                              ,p_de_preferred_name
                              ,p_de_conte_idseq
                              ,p_de_version
                              ,p_de_preferred_definition
                              ,p_de_dec_idseq
                              ,p_de_vd_idseq
                              ,p_de_asl_name
                              ,p_de_latest_version_ind
                              ,p_de_long_name
                              ,p_de_begin_date
                              ,p_de_end_date
                              ,p_de_change_note
                              ,p_de_created_by
                              ,p_de_date_created
                              ,p_de_modified_by
                              ,p_de_date_modified
                              ,p_de_deleted_ind
                              ,p_de_origin );   -- 16-Jul-2003, W. Ver Hoef
        IF p_return_code IS NULL AND p_action = 'INS' THEN   -- 16-Jul-2003, W. Ver Hoef
            p_de_de_idseq := v_de_idseq;   -- 16-Jul-2003, W. Ver Hoef
            v_des_name := p_de_preferred_name;
            Sbrext_Set_Row.set_des( p_return_code
                                   ,'INS'
                                   ,v_desig_idseq
                                   ,v_des_name
                                   ,v_detl_name
                                   ,v_de_idseq
                                   ,p_de_conte_idseq
                                   ,v_language
                                   ,v_des_created_by
                                   ,v_des_date_created
                                   ,v_des_modified_by
                                   ,v_des_date_modified );
            BEGIN
                SELECT cde_id   -- min_cde_id  - 16-Jul-2003, W. Ver Hoef
                  INTO p_cde_id
                  FROM data_elements_view   -- de_cde_id_view
                 WHERE de_idseq = v_de_idseq;   -- ac_idseq = v_de_idseq;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_cde_id := NULL;
            END;
        END IF;
    END;
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
       ,p_de_origin                 IN       VARCHAR2 )   -- 31-Jul-2003, Prerna Aggarwal
                                                       IS
        --
        -- Date:  31-Jul-2003
        -- Created By:  Prerna Aggarwal
        -- Reason:  This procedure will create a new version of the data element with updated fields
        --
        v_conte_idseq   CHAR( 36 );
    BEGIN
        meta_config_mgmt.de_version( p_de_de_idseq, p_de_version, p_new_de_idseq, p_return_code );
        p_de_latest_version_ind := 'Yes';
        DBMS_OUTPUT.put_line( p_new_de_idseq || 'a' );
        SELECT conte_idseq
          INTO v_conte_idseq
          FROM data_elements_view
         WHERE de_idseq = p_new_de_idseq;
        IF p_return_code IS NULL THEN
            Sbrext_Set_Row.set_de( p_return_code
                                  ,'UPD'
                                  ,p_new_de_idseq
                                  ,p_de_preferred_name
                                  ,v_conte_idseq
                                  ,p_de_version
                                  ,p_de_preferred_definition
                                  ,p_de_dec_idseq
                                  ,p_de_vd_idseq
                                  ,p_de_asl_name
                                  ,p_de_latest_version_ind
                                  ,p_de_long_name
                                  ,p_de_begin_date
                                  ,p_de_end_date
                                  ,p_de_change_note
                                  ,p_de_created_by
                                  ,p_de_date_created
                                  ,p_de_modified_by
                                  ,p_de_date_modified
                                  ,p_de_deleted_ind
                                  ,p_de_origin );
            DBMS_OUTPUT.put_line( p_return_code || 'a' );
            BEGIN
                SELECT cde_id
                  INTO p_cde_id
                  FROM data_elements_view
                 WHERE de_idseq = p_new_de_idseq;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_cde_id := NULL;
            END;
        END IF;
    END;
    PROCEDURE search_de(
        p_de_idseq                 IN       VARCHAR2
       ,p_search_string            IN       VARCHAR2
       ,p_conte_idseq              IN       VARCHAR2
       ,p_context                  IN       VARCHAR2
       ,p_asl_name                 IN       VARCHAR2
       ,p_cde_id                   IN       VARCHAR2   -- 30-Jun-2003, W. Ver Hoef
       ,p_de_search_res            OUT      type_de_search
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_03b
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_created_starting_date    IN       VARCHAR2 DEFAULT NULL   -- 18-Feb-2004, W. Ver Hoef added per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params per SPRF_2.1_10a
       ,p_permissible_value        IN       VARCHAR2 DEFAULT NULL   -- 03-Mar-2004, W. Ver Hoef added per SPRF_2.1_09
       ,p_doc_text                 IN       VARCHAR2 DEFAULT NULL   -- 04-Mar-2004, W. Ver Hoef added per SPRF_2.1_16
       ,p_historical_cde_id        IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_12
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       -- 10-Mar-2004, W. Ver Hoef changed default to null from 'Yes'
    ,   p_doc_types                IN       VARCHAR2
                DEFAULT NULL   -- 15-Mar-2004, W. Ver Hoef added per mod to SPRF_2.1_16
       ,p_context_use              IN       VARCHAR2 DEFAULT NULL   -- 18-Mar-2004, W. Ver Hoef added per SPRF_2.1_15
       ,p_protocol_id              IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_crf_name                 IN       VARCHAR2 DEFAULT NULL   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_version                  IN       NUMBER   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_pv_idseq                 IN       VARCHAR2   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_dec_idseq                IN       VARCHAR2   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_vd_idseq                 IN       VARCHAR2   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_cs_csi_idseq             IN       VARCHAR2   -- 23-Aug-2004, DLadino added per SPRF_2.1.1_1
       ,p_cd_idseq                 IN       VARCHAR2   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_crtl_name                IN       VARCHAR2 DEFAULT NULL   -- 01-Nov-2005, S. Alred (TT#1716)
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 23-Nov-2005, S. Alred (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 23-Nov-2005, S. Alred (TT1780)
       ,p_vm_idseq                 IN       VARCHAR2 DEFAULT NULL  -- 11-Mar-2008, PAGGARWA
                                                                 ) IS
        -- Date:  30-Jun-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out references to de_ced_id_view.min_cde_id and replaced with
        --          data_elements_view.cde_id; substituted a block of code for the simple
        --          where clause addition for p_asl_name to handle possibility of multiple
        --          comma-separated values; added comparison based on p_cde_id; added
        --          origin to query result (per SPRF_2.0_12)
        --
        -- Date:  14-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out de_source_name since origin is replacing it (per ScenPro
        --          request regarding testing changes for SPRF_2.0_12)
        --
        -- Date:  16-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  (1) added parameter p_reg_status to filter results by registration status and
        --          added ar_idseq, registration_status, sub_idseq and sub_name (for submitter)
        --          to the return cursor per SPRF_2.1_03b
        --          (2) added parameter p_origin to filter results by origin per SPRF_2.1_17
        --
        -- Date:  19-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_starting_date, p_created_ending_date,
        --          p_modified_starting_date, p_modified_ending_date and related code
        --          to filter by date, also included date_created and date_modified in
        --          return cursor per SPRF_2.1_10
        --
        -- Date:  20-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added v_origin to be able to replace * with % and added upper function
        --          in comparison per SPRF_2.1_17
        --
        -- Date:  01-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_by and p_modified_by and related code per SPRF_2.1_10a
        --
        -- Date:  03-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_permissible_value and related code per SPRF_2.1_09
        --
        -- Date:  04-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_doc_text and related code per SPRF_2.1_16
        --
        -- Date:  05-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_historical_cde_id and related code per SPRF_2.1_12
        --
        -- Date:  05-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_latest_version_ind and related code per SPRF_2.1_08
        --
        -- Date:  10-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added get_ua_full_name function to created/modified_by per SPRF_2.1_10a
        --          mod; changed default value of p_latest_version_ind from 'Yes' to null
        --          and changed code to 'Yes' = latest only, null = all versions per mod on
        --          SPRF_2.1_08
        --
        -- Date:  15-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added p_doc_types and related code per mod to SPRF_2.1_16
        --
        -- Date:  18-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added p_context_use and related code per mod to SPRF_2.1_15
        --
        -- Date:  22-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out AC Registration submitter-related parts of query
        --
        -- Date:  30-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added columns, view, join for reference document counts/min doc text by doc type;
        --          commented out string comparison for doc_text cols per SPRF_2.1_16 mod
        --
        -- Date:  31-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added hist_cde_count and min_hist_cde_name and associated pseudo-table query in
        --          the FROM clause, a join in the WHERE clause, and modified the if-then for
        --          the p_historical_cde_id search criteria per a SPRF_2.1_12 mod ;
        --          added min_value and value_count columns and associated pseudo-table sub-query and
        --          join; redesigned parameter comparison for p_permissible_value per SPRF_2.1_09 mod ;
        --          TOOK OUT WHITE SPACE BECAUSE THE DYNAMIC SQL WAS MORE THAN 4000 CHARACTERS LONG!!
        --
        -- Date:  01-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  took out hsn.doc_text historic_short_cde_name, r.doc_text, r.rd_idseq doc_rd_idseq
        --          per mod to SPRF_2.1_16
        --
        -- Date:  12-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  took off upper function on latest version ind comparison for
        --          performance reasons
        --
        -- Date:  16-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added u.conte_idseq to select list per SPRF_2.1_30
        --
        -- Date:  23-Aug-2004
        -- Modified By:  DLadino
        -- Reason:  added protocol_id, crf_name to list of parameters per SPRF_2.1.1_1
        --          Modified search to do the wildcard search in protocol_id if not null, or
        --          wildcard search in crf_name if not null.
        -- Date:  29-DEC-2004
        -- Modified By: Prerna
        -- Reason:  added dec_idseq,pv_idseq,vd_idseq,cs_Csi_idseq as search criteria.
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_sql             VARCHAR2( 8000 );
        v_where           VARCHAR2( 6000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_origin          VARCHAR2( 240 )  := UPPER( REPLACE( p_origin, '*', '%' ));   -- 20-Feb-2004, W. Ver Hoef added
        v_created_by      VARCHAR2( 255 )  := p_created_by;   -- 02-Mar-2004, W. Ver Hoef DLadino removed the replace and upper functions
        v_modified_by     VARCHAR2( 255 )  := p_modified_by;   -- added "by" vars DLadino removed the replace and upper functions
        v_perm_value      VARCHAR2( 255 )  := UPPER( REPLACE( p_permissible_value, '*', '%' ));   -- 03-Mar-2004, W. Ver Hoef
        v_select          VARCHAR2( 4000 );   -- 03-Mar-2004, W. Ver Hoef added to hold parts of query
        v_from            VARCHAR2( 4000 );
        v_doc_text        VARCHAR2( 2000 ) := UPPER( REPLACE( p_doc_text, '*', '%' ));   -- 04-Mar-2004, W. Ver Hoef added
        v_hist_cde_id     VARCHAR2( 2000 ) := UPPER( REPLACE( p_historical_cde_id, '*', '%' ));   -- 05-Mar-2004, W. Ver Hoef added
        -- 12-Apr-2004, W. Ver Hoef took off upper func on latest version ind
        v_lat_vers_ind    VARCHAR2( 2000 ) := p_latest_version_ind;   -- 05-Mar-2004, W. Ver Hoef added
        v_doc_types       VARCHAR2( 2000 );   -- 15-Mar-2004, W. Ver Hoef added
        v_doc_type_list   VARCHAR2( 2000 );   -- 15-Mar-2004, W. Ver Hoef added
        v_context_use     VARCHAR2( 2000 ) := p_context_use;   -- 18-Mar-2004, W. Ver Hoef added
        v_crf_name        VARCHAR2( 2000 ) := UPPER( REPLACE( p_crf_name, '*', '%' ));
        v_protocol_id     VARCHAR2( 2000 ) := UPPER( REPLACE( p_protocol_id, '*', '%' ));
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
    BEGIN
        IF p_de_search_res%ISOPEN THEN
            CLOSE p_de_search_res;
        END IF;
        -- 30-Jun-2003, W. Ver Hoef replaced ".min_cde_id" with "d.cde_id"
        -- 14-Jul-2003, W. Ver Hoef commented out ",sn.doc_text de_source_name "
        -- 14-Jul-2003, W. Ver Hoef commented out ",sn.RD_IDSEQ de_sn_rd_idseq "
        -- 16-Feb-2004, W. Ver Hoef added ar_idseq and registration_status
        -- 22_mar-2004, W. Ver Hoef commented out ",s.sub_idseq" and ", s.name"
        -- 19-Feb-2004, W. Ver Hoef added date created/modified
        -- 01-Mar-2004, W. Ver Hoef added created/modified by
        -- 10-Mar-2004, W. Ver Hoef get func. added on created/modified by
        -- 30-mar-2004, W. Ver Hoef added counts and min text per doc type per SPRF_2.1_16 mod
        -- 31-Mar-2004, W. Ver Hoef added count and min name for hist cde per SPRF_2.1_12 mod
        -- 01-Apr-2004, W. Ver Hoef removed "hsn.doc_text historic_short_cde_name, r.doc_text,
        --                            r.RD_IDSEQ doc_rd_idseq," per mod to SPRF_2.1_16
        -- 16-Apr-2004, W. Ver Hoef added u.conte_idseq (used by conte_idseq) per SPRF_2.1_30
        -- 12-May-2004  DLadino    Due to performance issues with this query we need to use
        --                            the RULE based optimizer
        v_select :=
            'SELECT
 d.preferred_name
 ,d.long_name
 ,d.preferred_definition
 ,d.asl_name
 ,d.conte_idseq
 ,d.begin_date
 ,d.end_date
 ,c.name
 ,d.dec_idseq
 ,NVL(DEC.long_name, DEC.preferred_name) dec_name
 ,DEC.preferred_definition dec_preferred_definition
 ,d.vd_idseq
 ,NVL(vd.long_name, vd.preferred_name) vd_name
 ,vd.preferred_definition vd_preferred_definition
 ,d.version
 ,d.cde_id
 ,d.change_note
 ,des.LAE_NAME LANGUAGE
 ,d.de_idseq
 ,des.desig_idseq
 ,DEC.preferred_name dec_pref_name
 ,vd.preferred_NAME vd_pref_name
 ,u.name usedby_name
 ,uc.name used_by_context
 ,u.desig_idseq u_desig_idseq
 ,d.origin
 ,ar.ar_idseq
 ,ar.registration_status
 ,d.date_created
 ,d.date_modified
 ,sbrext_cde_curator_pkg.get_ua_full_name(d.created_by)  created_by
 ,sbrext_cde_curator_pkg.get_ua_full_name(d.modified_by) modified_by
 ,v2.doc_text long_name_doc_text
 --,v1.doc_text hist_cde_doc_text
 --,hc.hist_cde_count
 --,hc.min_hist_cde_name
 ,vc.min_value
 ,vc.value_count
 ,rsl.display_order
 ,rsl.registration_status
 ,asl.display_order
 ,asl.asl_name
 ,sbrext_cde_curator_pkg.Get_Crtl_Name(d.de_idseq) derivation_type
 ,u.conte_idseq used_by_conte_idseq
 ,sbrext_cde_curator_pkg.Get_One_Con_Name(DEC.dec_idseq, vd.vd_idseq) con_name
 ,sbrext_cde_curator_pkg.get_one_alt_name(d.de_idseq) alt_name
 ,sbrext_cde_curator_pkg.get_one_rd_name(d.de_idseq) rd_name ' ;
  v_from :=
               '
FROM
 data_elements_view d
 ,data_element_concepts_view DEC
 ,value_domains_view vd
 ,contexts c
 ,sbrext.de_cn_language_view des
 ,complex_data_elements_view cxd
 ,used_by_view  u
 ,contexts_view uc
 ,ac_registrations_view ar
 ,sbr.ac_status_lov_view asl
 ,sbr.reg_status_lov_view rsl
-- ,(SELECT ac_idseq, doc_text
--   FROM reference_documents
--   WHERE dctl_name = ''HISTORIC SHORT CDE NAME'') v1
 ,(SELECT ac_idseq, doc_text
   FROM reference_documents
   WHERE dctl_name = ''Preferred Question Text'') v2 ';
/* ,(SELECT ac_idseq,
     COUNT(1)  hist_cde_count,
     MIN(name) min_hist_cde_name
   FROM   designations_view
   WHERE  detl_name = ''HISTORICAL_CDE_ID''
     AND    UPPER(name) LIKE '''
            || NVL( v_hist_cde_id, '%' )
            || '''
   GROUP BY ac_idseq) hc '; */
        -- ,de_cde_id_view i       -- 30-Jun-2003, W. Ver Hoef commented
        -- ,de_source_name_view sn -- 14-Jul-2003, W. Ver Hoef commented
        -- ,submitters_view s ';   -- 22-Mar-2004, W. Ver Hoef commented submitters
        -- 16-Feb-2004, W. Ver Hoef added ac_registrations
        -- 30-mar-2004, W. Ver Hoef added ref_docs_sum_by_type_view
        -- 31-Mar-2004, W. Ver Hoef added pseudo-table subquery on designations_view for hist cde count and min cde
        -- 01-Apr-2004, W. Ver Hoef removed ",de_short_name_view hsn ,de_long_name_view r " per mod to SPRF_2.1_16
        v_where :=
            '
d.conte_idseq = c.conte_idseq
 AND asl.asl_name = d.asl_name
 AND ar.ac_idseq (+)= d.de_idseq
 AND rsl.registration_status (+)= ar.registration_status
 AND d.dec_idseq   = DEC.dec_idseq
 AND d.vd_idseq    = vd.vd_idseq
 AND d.de_idseq    = des.ac_idseq (+)
 AND d.de_idseq    = u.ac_idseq (+)
 AND u.conte_idseq = uc.conte_idseq (+)
 AND d.de_idseq    = ar.ac_idseq (+)
-- AND d.de_idseq    = v1.ac_idseq (+)
 AND d.de_idseq    = v2.ac_idseq (+)
-- AND d.de_idseq    = hc.ac_idseq (+)
 AND d.de_idseq    = cxd.p_de_idseq (+)'
;
        -- 16-Feb-2004, W. Ver Hoef added ar join
        -- 30-Mar-2004, W. Ver Hoef added v join
        -- 31-Mar-2004, W. Ver Hoef added hc join
        --   AND         d.de_idseq = i.ac_idseq(+) 30-Jun-2003, W. Ver Hoef
        --   AND         d.de_idseq = sn.ac_idseq(+)14-Jul-2003, W. Ver Hoef
        --   AND         ar.sub_idseq          = s.sub_idseq (+) '; -- 22-Mar-2004, W. Ver Hoef commented
        -- 01-Apr-2004, W. Ver Hoef removed the following hsn and r joins:
        -- AND   d.de_idseq    = hsn.ac_idseq (+)
        -- AND   d.de_idseq    = r.ac_idseq (+)
          -- 12-Apr-2004, W. Ver Hoef added conditional parenthesis
        IF v_search_string IS NOT NULL OR( p_doc_text IS NOT NULL AND p_doc_types IS NOT NULL ) THEN
            v_where := v_where || ' AND ( ';
        END IF;
        IF v_search_string IS NOT NULL THEN
            v_where :=
                   v_where
                || ' -- AND -- 12-Apr-2004, W. Ver Hoef commented out AND since moved above
  (  UPPER(d.preferred_name) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR UPPER(NVL(d.long_name,'
                || ''''
                || ' '
                || ''''
                || ' )) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR UPPER(d.preferred_definition) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 /*OR UPPER(NVL(u.name,1)) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '*/ --SPRF_3.0.1_8
 ) ';   -- 30-Mar-2004, W. Ver Hoef commented out string comparison for doc_text cols per SPRF_2.1_16 mod.
        -- OR upper(nvl(r.doc_text,1)) like '||''''||v_search_string||''''||'
        -- OR upper(nvl(hsn.doc_text,1)) like '||''''||v_search_string||''''||'
        END IF;
        -- 04-Mar-2004, W. Ver Hoef added if-then stmt for doc_text
        -- 15-Mar-2004, W. Ver Hoef added inner if-then-elsif for doc_types
        -- 12-Apr-2004, W. Ver Hoef moved doc text/type where handling together with
        --                            string so they can be conditionally OR'd if both
        --                            are passed in
        IF p_doc_text IS NOT NULL THEN
            -- 12-Apr-2004, W. Ver Hoef added conditional OR
            IF v_search_string IS NOT NULL AND p_doc_types IS NOT NULL THEN
                v_where := v_where || ' OR ';
            END IF;
            IF p_doc_types = 'ALL' THEN
                v_where :=
                       v_where
                    || ' -- AND -- 12-Apr-2004, W. Ver Hoef commented out AND
         EXISTS (SELECT rd.ac_idseq
                 FROM   reference_documents_view rd
              WHERE  d.de_idseq = rd.ac_idseq
                    AND    UPPER(rd.doc_text) LIKE '''
                    || v_doc_text
                    || ''')';
            ELSIF p_doc_types IS NOT NULL THEN
                v_doc_types := p_doc_types;
                WHILE( i != 0 AND v_doc_types IS NOT NULL ) LOOP
                    i := INSTR( v_doc_types, ',' );
                    IF i = 0 THEN
                        v_doc_type_list := v_doc_type_list || ',''' || LTRIM( RTRIM( v_doc_types )) || '''';
                    ELSE
                        v_doc_type_list :=
                                     v_doc_type_list || ',''' || LTRIM( RTRIM( SUBSTR( v_doc_types, 1, i - 1 )))
                                     || '''';
                    END IF;
                    v_doc_types := SUBSTR( v_doc_types, i + 1 );
                END LOOP;
                v_doc_type_list := SUBSTR( v_doc_type_list, 2, LENGTH( v_doc_type_list ));
                v_where :=
                       v_where
                    || ' -- AND -- 12-Apr-2004, W. Ver Hoef commented out AND
         EXISTS (SELECT rd.ac_idseq
                 FROM   reference_documents_view rd
              WHERE  d.de_idseq = rd.ac_idseq
                    AND    UPPER(rd.doc_text) LIKE '''
                    || v_doc_text
                    || '''
           AND    rd.dctl_name IN ('
                    || v_doc_type_list
                    || ') )';
            END IF;
        ELSE   -- p_doc_text is null
            NULL;   -- no criteria to apply
        END IF;
        -- 12-Apr-2004, W. Ver Hoef added conditional parenthesis
        IF v_search_string IS NOT NULL OR( p_doc_text IS NOT NULL AND p_doc_types IS NOT NULL ) THEN
            v_where := v_where || ' ) ';
        END IF;
        IF ( p_conte_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND d.conte_idseq = ''' || p_conte_idseq || ''' ';
        END IF;
        -- 18-Mar-2004, W. Ver Hoef added code for v_context_use to existing code which
        --                            effectively defaulted to both
        IF ( p_context IS NOT NULL ) THEN
            i := 1;
            --v_where := v_where||' AND c.name= '||''''||p_context||''''||'  ';
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            --v_where := v_where||' AND upper(c.name) in ('||v_context_list||')';
            IF v_context_use = 'OWNED_BY' THEN
                   -- v_where := v_where||'
                -- AND (c.name = '''||p_context||''') ';
                v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
            ELSIF v_context_use = 'USED_BY' THEN
                  -- v_where := v_where||'
                --AND (uc.name = '''||p_context||''') ';
                v_where := v_where || ' AND upper(uc.name) in (' || v_context_list || ')';
            ELSE   -- v_context_use = 'BOTH' or is null
                   -- v_where := v_where||'
                -- AND (c.name = '''||p_context||''' or uc.name = '''||p_context||''') ';
                v_where :=
                       v_where
                    || ' AND (upper(c.name) in ('
                    || v_context_list
                    || ') or upper(uc.name) in ('
                    || v_context_list
                    || '))';
            END IF;
        END IF;
        i := 1;
        -- 30-Jun-2003, W. Ver Hoef
        -- substituted the following section for the commented out one below
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || '
 AND UPPER(d.asl_name) IN (' || v_asl_list || ')';
        END IF;
        -- IF (p_asl_name IS NOT NULL ) THEN
        --  v_where := v_where||' AND d.asl_name = '||''''||p_asl_name||'''';
        -- END IF;
        IF ( p_cde_id IS NOT NULL ) THEN
            -- 30-Jun-2003, W. Ver Hoef replaced comparison
            -- v_where := v_where||' AND nvl(i.min_cde_id,'||''''||'-1'||''''||') = '||''''||p_cde_id||'''';
            v_where := v_where || '
 AND NVL(d.cde_id,' || '''' || '-1' || '''' || ') = ' || '''' || p_cde_id || '''';
        END IF;
        IF ( p_de_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND d.de_idseq = ' || '''' || p_de_idseq || '''';
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_reg_status IS NOT NULL ) THEN
            v_where := v_where || '
 AND ar.registration_status = ''' || p_reg_status || '''';
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_origin IS NOT NULL ) THEN
            v_where := v_where || '
 AND UPPER(d.origin) LIKE ''' || v_origin || '''';   -- 20-Feb-2004, W. Ver Hoef added upper, switched to v_origin
        END IF;
        -- 19-Feb-2004, W. Ver Hoef added if-then stmts for dates
        IF p_created_starting_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_created) >= TO_DATE(''' || p_created_starting_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_created_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_created) <= TO_DATE(''' || p_created_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(d.date_modified) >= TO_DATE('''
                || p_modified_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_modified) <= TO_DATE(''' || p_modified_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        -- 01-Mar-2004, W. Ver Hoef added if-then stmts for created/mod by
        IF p_created_by IS NOT NULL THEN
            v_where := v_where || '
 AND d.created_by = ''' || v_created_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        IF p_modified_by IS NOT NULL THEN
            v_where := v_where || '
 AND d.modified_by = ''' || v_modified_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        /*
          -- 03-Mar-2004, W. Ver Hoef added if-then stmt for permissible value
          IF p_permissible_value IS NOT NULL THEN
            v_from  := v_from||'
                      ,vd_pvs_view vp
                      ,permissible_values_view pv ';
            v_where := v_where||'
            AND vd.vd_idseq = vp.vd_idseq
            AND vp.pv_idseq = pv.pv_idseq
            AND upper(pv.value) like '''||v_perm_value||'''';
          END IF;
        */-- 31-Mar-2004, W. Ver Hoef replaced original if-then for permissible value above
          --                            with the following
        IF p_permissible_value IS NOT NULL THEN
            v_from :=
                   v_from
                || '
   ,(SELECT vd_idseq,
            MIN(value)               min_value,
            COUNT(1)                 value_count
     FROM   vd_pvs_view              vp,
         permissible_values_view  pv
     WHERE  vp.pv_idseq = pv.pv_idseq
  AND    UPPER(pv.value) LIKE '''
                || v_perm_value
                || '''
  GROUP BY vd_idseq) vc ';
            v_where := v_where || '
   AND vd.vd_idseq = vc.vd_idseq ';
        ELSE
            v_from :=
                   v_from
                || '
   ,(SELECT vd_idseq,
            MIN(value)               min_value,
            COUNT(1)                 value_count
     FROM   vd_pvs_view              vp,
         permissible_values_view  pv
     WHERE  vp.pv_idseq = pv.pv_idseq
  GROUP BY vd_idseq) vc ';
            v_where := v_where || '
   AND vd.vd_idseq = vc.vd_idseq (+) ';
        END IF;
        -- 23-Aug-2004, D. Ladino added search criteria for protocol_id and
        --                          crf_name.  (SPRF_2.1.1_1)
        IF ( p_protocol_id IS NOT NULL OR p_crf_name IS NOT NULL ) THEN
            v_select :=
                   v_select
                || ',
                   qce.protocol_id,
                   qce.crf_name,
                   qce.protocol_crf_count ';
            v_from :=
                   v_from
                || ',
                 (SELECT Q.de_idseq,
                         MIN(NVL(P.protocol_id, P.preferred_name))  protocol_id,
                         MIN(crf) crf_name,
                         COUNT(*) protocol_crf_count
                  FROM quest_crf_view2_ext Q, PROTOCOLS_EXT P
                  WHERE P.proto_idseq = Q.proto_idseq ';
            IF ( p_crf_name IS NOT NULL ) THEN
                v_from := v_from || '
                    AND UPPER(q.crf) LIKE ''' || v_crf_name || '''';
            END IF;
            IF ( p_protocol_id IS NOT NULL ) THEN
                v_from :=
                       v_from
                    || '
                    AND UPPER(NVL(protocol_id,P.preferred_name)) LIKE '''
                    || v_protocol_id
                    || '''';
            END IF;
            v_from := v_from || '
                  GROUP BY Q.de_idseq) qce ';
            v_where := v_where || '
                 AND d.de_idseq = qce.de_idseq  ';
        END IF;
        -- 05-Mar-2004, W. Ver Hoef added if-then stmt for historical_cde_id
        -- 31-Mar-2004, W. Ver Hoef changed where clause from sub-query to simple comparison on
        --                            hist_cde_count because the pseudo-table will count based on
        --                            the historical cde parameter
        IF p_historical_cde_id IS NOT NULL THEN
   --         v_where := v_where || '
   -- AND hc.hist_cde_count >= 1 ';
              v_where := v_where||'
              AND exists (select h.ac_idseq
                      from   designations_view h
              where  h.ac_idseq  = d.de_idseq
                        and    h.detl_name = ''HISTORICAL_CDE_ID''
              and    upper(h.name) like '''||v_hist_cde_id||''')';
        END IF;
        -- 10-Mar-2004, W. Ver Hoef added to apply only when param is not null
        IF p_latest_version_ind IS NOT NULL THEN
            -- 12-Apr-2004, W. Ver Hoef took off upper func on d.latest_version_ind
            v_where := v_where || '
 AND         d.latest_version_ind = ''' || v_lat_vers_ind || ''' ';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_version <> 0 THEN
            v_where := v_where || '
 AND         d.version = ' || p_version || ' ';
        END IF;
        IF p_pv_idseq IS NOT NULL THEN
            v_from := v_from || '  ,vd_pvs_view              vp  ';
            v_where := v_where || '
   AND vp.pv_idseq = ''' || p_pv_idseq || '''
   AND vp.vd_idseq = vd.vd_idseq ';
        END IF;
        IF p_dec_idseq IS NOT NULL THEN
            v_where := v_where || '
   AND d.dec_idseq = ''' || p_dec_idseq || ''' ';
        END IF;
        IF p_vd_idseq IS NOT NULL THEN
            v_where := v_where || '
   AND d.vd_idseq = ''' || p_vd_idseq || ''' ';
        END IF;
        IF p_cs_csi_idseq IS NOT NULL THEN
            v_from := v_from || '  ,ac_csi accsi
                        ,cs_csi cscsi  ';
            v_where :=
                   v_where
                || ' AND d.de_idseq = accsi.ac_idseq
                       AND accsi.cs_csi_idseq = cscsi.cs_csi_idseq
                       AND cscsi.cs_csi_idseq = '''
                || p_cs_csi_idseq
                || ''' ';
        END IF;
        IF p_cd_idseq IS NOT NULL THEN
            v_where := v_where || ' AND dec.cd_idseq = ''' || p_cd_idseq || ''' ';
        END IF;

        if p_vm_idseq is not null then
          v_from := v_from||' '||'
          ,sbr.vd_pvs_view vp
          ,sbr.permissible_values_view pv';
          v_where := v_where||' '||'
          AND vd.vd_idseq = vp.vd_idseq
          AND vp.pv_idseq = pv.pv_idseq
          AND pv.vm_idseq = '||''''||p_vm_idseq||'''';
        end if;
        -- 01-Nov-2005, S. Alred; added for TT1716
        IF ( p_crtl_name IS NOT NULL ) THEN
            v_where := v_where || '
    AND cxd.crtl_name = ''' || p_crtl_name || ''' ';
        END IF;
        -- 23-Nov-2005, S. Alred; added for TT1780
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            --separate the con name and con idseq filters
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_IDSEQ = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 d.de_idseq IN (
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbrext.OBJECT_CLASSES_VIEW_EXT       OC
    , sbr.data_element_concepts_view       DEC
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND OC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND DEC.OC_IDSEQ = OC.OC_IDSEQ
  AND de.dec_idseq = DEC.dec_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbrext.properties_VIEW_EXT           prop
    , sbr.data_element_concepts_view       DEC
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND prop.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND DEC.prop_IDSEQ = prop.prop_IDSEQ
  AND de.dec_idseq = DEC.dec_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbr.conceptual_domains_view          cd
    , sbr.data_element_concepts_view       DEC
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND cd.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND DEC.cd_IDSEQ = cd.cd_IDSEQ
  AND de.dec_idseq = DEC.dec_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbr.value_domains_view               vd
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND vd.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND de.vd_idseq = vd.vd_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbrext.REPRESENTATIONS_VIEW_EXT      rep
    , sbr.value_domains_view               vd
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND rep.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND vd.rep_idseq = rep.rep_idseq
  AND de.vd_idseq = vd.vd_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbr.conceptual_domains_view          cd
    , sbr.value_domains_view               vd
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND cd.CONDR_IDSEQ = CDR.CONDR_IDSEQ
  AND vd.cd_idseq = cd.cd_idseq
  AND de.vd_idseq = vd.vd_idseq
 UNION
 SELECT de.de_idseq
 FROM sbr.data_elements_view               de
    , sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
    , sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
    , sbrext.CONCEPTS_VIEW_EXT             CON
    , sbr.VD_PVS_VIEW                      vp
    , sbr.permissible_values_view          pv
    , sbr.value_meanings_view          vm
    , sbr.value_domains_view               vd
 WHERE '
                || v_con_name
                || '
  AND CC.CON_IDSEQ = CON.CON_IDSEQ
  AND CDR.CONDR_IDSEQ = CC.CONDR_IDSEQ
  AND vm.condr_idseq = CDR.CONDR_IDSEQ
  AND pv.vm_idseq = vm.vm_idseq
  AND vp.pv_idseq = pv.pv_idseq
  AND vd.vd_idseq = vp.vd_idseq
  AND de.vd_idseq = vd.vd_idseq
 ) AND '
                || v_where;
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added for debugging purposes, modified later
        -- dbms_output.put_line('length(v_from) = '||TO_CHAR(LENGTH(v_from)));
        -- dbms_output.put_line('length(v_where) = '||TO_CHAR(LENGTH(v_where)));
        -- dbms_output.put_line('from  ending = '||SUBSTR(v_from,(LENGTH(v_from)-110)));
        -- dbms_output.put_line('where ending = '||SUBSTR(v_where,LENGTH(v_where)-675,225));
        -- dbms_output.put_line(SUBSTR(v_where,LENGTH(v_where)-450,225));
        -- dbms_output.put_line(SUBSTR(v_where,LENGTH(v_where)-225));
        --dbms_output.put_line(SUBSTR(v_select);
        -- dbms_output.put_line('from clause '||SUBSTR(v_from, 1, 200));
        -- dbms_output.put_line(SUBSTR(v_from, 201, 210));
        --  dbms_output.put_line(SUBSTR(v_from, 411, 210));
        -- dbms_output.put_line(SUBSTR(v_from, 621, 210));
        -- dbms_output.put_line(SUBSTR(v_from, 831, 210));
        -- dbms_output.put_line('where clause '||SUBSTR(v_where, 1, 200));
        -- dbms_output.put_line(SUBSTR(v_where, 201, 210));
        -- dbms_output.put_line(SUBSTR(v_where, 411, 210));
        -- dbms_output.put_line(SUBSTR(v_where, 621, 210));
        -- dbms_output.put_line(SUBSTR(v_where, 831, 210));
        v_sql := v_select || v_from || ' WHERE ' || v_where || '  ORDER BY rsl.display_order, asl.display_order, upper(d.long_name)';   -- 03-Mar-2004, W. Ver Hoef
        /*
          i := 1;
          WHILE (i < LENGTH(v_sql)) LOOP
              dbms_output.put_line(SUBSTR(v_sql, i, 200));
              i := i + 200;
          END LOOP;
        */
        OPEN p_de_search_res FOR v_sql;
    END search_de;
    -- 22-Jul-2003, W. Ver Hoef added get_associated_de per SPRF_2.0_07
    PROCEDURE get_associated_de(
        p_pv_idseq       IN       VARCHAR2
       ,p_dec_idseq      IN       VARCHAR2
       ,p_vd_idseq       IN       VARCHAR2
       ,p_cd_idseq       IN       VARCHAR2
       ,p_cs_csi_idseq   IN       VARCHAR2   -- added on 7/30/03 by Prerna Aggarwal for SPRF_2.0_20
       ,p_return_code    OUT      VARCHAR2
       ,p_return_desc    OUT      VARCHAR2
       ,p_assoc_de_res   OUT      type_assoc_de ) IS
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added created/modified/registration columns per SPRF_2.1_22
        --
        -- Date:  30-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added columns, view, join for reference document counts/min doc text by doc type
        --          per SPRF_2.1_16 mod
        --
        -- Date:  31-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added hist_cde_count and min_hist_cde_name and associated pseudo-table query in
        --          the FROM clause, a join in the WHERE clause per a SPRF_2.1_12 mod ;
        --          added min_value and value_count, vc pseudo-table and join per SPRF_2.1_09 mod ;
        --          TOOK OUT WHITE SPACE BECAUSE THE DYNAMIC SQL WAS MORE THAN 4000 CHARACTERS LONG!!
        --
        -- Date:  01-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out hsn.doc_text historic_short_cde_name, r.doc_text,
        --          r.rd_idseq doc_rd_idseqper mod to SPRF_2.1_16
        --
        -- Date:  16-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added used by context idseq per SPRF_2.1_30
        v_param_count   NUMBER           := 0;
        v_select        VARCHAR2( 4000 ) := ' ';
        v_from          VARCHAR2( 4000 ) := ' ';
        v_where         VARCHAR2( 4000 ) := ' ';
        v_sql           VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_assoc_de_res%ISOPEN THEN
            CLOSE p_assoc_de_res;
        END IF;
        p_return_code := 0;
        p_return_desc := NULL;
        -- validate parameter values only 1 is allowed
        IF p_pv_idseq IS NOT NULL THEN
            v_param_count := v_param_count + 1;
        END IF;
        IF p_dec_idseq IS NOT NULL THEN
            v_param_count := v_param_count + 1;
        END IF;
        IF p_vd_idseq IS NOT NULL THEN
            v_param_count := v_param_count + 1;
        END IF;
        IF p_cd_idseq IS NOT NULL THEN
            v_param_count := v_param_count + 1;
        END IF;
        -- added on 8/8/03 to include cs_Csi_idseq by Prerna Aggarwal
        IF p_cs_csi_idseq IS NOT NULL THEN
            v_param_count := v_param_count + 1;
        END IF;
        IF v_param_count = 0 THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass a value for either P_PV_IDSEQ or '
                || 'P_DEC_IDSEQ or P_VD_IDSEQ or P_CD_IDSEQ or P_CS_CSI_IDSEQ, but only one is required';
            RETURN;
        ELSIF v_param_count > 1 THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass a value for either P_PV_IDSEQ or '
                || 'P_DEC_IDSEQ or P_VD_IDSEQ or P_CD_IDSEQ or P_CS_CSI_IDSEQ, but only one is allowed';
            RETURN;
        END IF;
        -- define the basic query
        -- 25-Mar-2004, W. Ver Hoef added created/modified/registration cols
        -- 30-Mar-2004, W. Ver Hoef added doc type counts/min doc text
        -- 31-Mar-2004, W. Ver Hoef added hist_cde_count and min_hist_cde_name
        -- 01-Apr-2004, W. Ver Hoef commented out r.doc_text, r.rd_idseq doc_rd_idseq,
        --                            hsn.doc_text historic_short_cde_name per mod to SPRF_1.2_16
        -- 16-Apr-2004, W. Ver Hoef added used by context idseq per SPRF_2.1_30
        v_select :=
            'SELECT
 DISTINCT d.de_idseq -- should eliminate potential for cartesian product when using p_pv_idseq
,d.preferred_name
,d.long_name
,d.preferred_definition
,d.asl_name
,d.conte_idseq
,d.begin_date
,d.end_date
,c.name
,d.dec_idseq
,NVL(DEC.long_name,DEC.preferred_name) dec_name
,DEC.preferred_definition dec_preferred_definition
,d.vd_idseq
,NVL(vd.long_name,vd.preferred_name) vd_name
,vd.preferred_definition   vd_preferred_definition
,d.version
--,r.doc_text
,d.cde_id
,d.change_note
,des.LAE_NAME LANGUAGE
,des.desig_idseq
--,r.RD_IDSEQ doc_rd_idseq
,DEC.preferred_name dec_pref_name
,vd.preferred_NAME vd_pref_name
--,hsn.doc_text historic_short_cde_name
,u.name usedby_name
,uc.name  used_by_context
,u.desig_idseq u_desig_idseq
,d.origin
,d.date_created
,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(d.created_by)  created_by
,d.date_modified
,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(d.modified_by) modified_by
,ar.ar_idseq
,ar.registration_status
,v1.doc_text long_name_doc_text
,v2.doc_text hist_cde_doc_text
,hc.hist_cde_count
,hc.min_hist_cde_name
,vc.min_value
,vc.value_count
,u.conte_idseq used_by_conte_idseq ';
        -- added ac_csi on 7/30/03 by Prerna Aggarwal
        -- 25-Mar-2004, W. Ver Hoef added ac_registrations
        -- 31-Mar-2004, W. Ver Hoef added hc pseudo-table sub-query for hist cde data
        -- 01-Apr-2004, W. Ver Hoef commented out r and hsn tables per mod to SPRF_1.2_16
        v_from :=
            '
FROM data_elements_view d
 ,data_element_concepts_view DEC
 ,value_domains_view vd
 ,contexts c
-- ,de_long_name_view r
 ,sbrext.de_cn_language_view des
-- ,de_short_name_view hsn
 ,used_by_view u
 ,contexts_view uc
 ,ac_csi a
 ,ac_registrations ar
    ,(SELECT ac_idseq, doc_text
      FROM reference_documents
      WHERE dctl_name = ''Preferred Question Text'') v1
    ,(SELECT ac_idseq, doc_text
      FROM reference_documents
      WHERE dctl_name = ''HISTORIC SHORT CDE NAME'')  v2
    ,(SELECT ac_idseq, COUNT(1) hist_cde_count, MIN(name) min_hist_cde_name
      FROM   designations_view WHERE detl_name = ''HISTORICAL_CDE_ID'' GROUP BY ac_idseq) hc
-- ,representations_ext       r
 ,(SELECT vd_idseq, MIN(value) min_value, COUNT(1) value_count
   FROM   vd_pvs_view vp, permissible_values_view pv
   WHERE  vp.pv_idseq = pv.pv_idseq GROUP BY vd_idseq) vc  ';   -- 31-Mar-2004, W. Ver Hoef added vc pseudo-table
        -- added de/ac_csi join on 7/30/03 by Prerna Aggarwal
        -- 25-Mar-2004, W. Ver Hoef added de/ar join
        -- 30-Mar-2004, W. Ver Hoef added de/ref doc view join
        -- 31-Mar-2004, W. Ver Hoef added join for hc pseudo-table for hist cde data
        -- 01-Apr-2004, W. Ver Hoef commented out r and hsn joins per mod to SPRF_1.2_16
        v_where :=
            '
WHERE d.conte_idseq = c.conte_idseq
AND   d.dec_idseq   = DEC.dec_idseq
AND   d.vd_idseq    = vd.vd_idseq
--AND   d.de_idseq    = r.ac_idseq     (+)
AND   d.de_idseq    = des.ac_idseq   (+)
--AND   d.de_idseq    = hsn.ac_idseq   (+)
AND   d.de_idseq    = u.ac_idseq     (+)
AND   u.conte_idseq = uc.conte_idseq (+)
AND   d.de_idseq    = a.ac_idseq     (+)
AND   d.de_idseq    = ar.ac_idseq    (+)
AND   d.de_idseq    = v1.ac_idseq    (+)
AND   d.de_idseq    = v2.ac_idseq    (+)
AND   d.de_idseq    = hc.ac_idseq    (+)
AND   vd.vd_idseq   = vc.vd_idseq    (+) ';   -- 31-Mar-2003, W. Ver Hoef added vc join
        -- apply the appropriate parameter to the query
        IF p_pv_idseq IS NOT NULL THEN
            v_from := v_from || '
              ,vd_pvs pv ';
            v_where :=
                   v_where
                || '
              AND d.vd_idseq = pv.vd_idseq (+)
              AND pv.pv_idseq = '
                || ''''
                || p_pv_idseq
                || '''';
        ELSIF p_dec_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND d.dec_idseq = ' || '''' || p_dec_idseq || '''';
        ELSIF p_vd_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND d.vd_idseq = ' || '''' || p_vd_idseq || '''';
        ELSIF p_cs_csi_idseq IS NOT NULL THEN   -- added on 7/30/03 by Prerna Aggarwal
            v_where := v_where || '
              AND a.cs_csi_idseq = ' || '''' || p_cs_csi_idseq || '''';
        ELSE   -- p_cd_idseq IS NOT NULL
            v_where :=
                   v_where
                || '
              AND (DEC.cd_idseq = '
                || ''''
                || p_cd_idseq
                || ''''
                || '
     OR vd.cd_idseq = '
                || ''''
                || p_cd_idseq
                || ''''
                || ')';
        END IF;
        DBMS_OUTPUT.put_line( 'length(v_select) = ' || TO_CHAR( LENGTH( v_select )));
        DBMS_OUTPUT.put_line( 'length(v_from)   = ' || TO_CHAR( LENGTH( v_from )));
        DBMS_OUTPUT.put_line( 'length(v_where)  = ' || TO_CHAR( LENGTH( v_where )));
        DBMS_OUTPUT.put_line( 'length(all 3)    = ' || TO_CHAR( LENGTH( v_select ) + LENGTH( v_from )
                                                                + LENGTH( v_where )));
        -- assemble the parts of the query
        v_sql := v_select || v_from || v_where || '
             ORDER BY UPPER(d.long_name )';
        -- get the data
        OPEN p_assoc_de_res FOR v_sql;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 0;
            p_return_desc := 'No Data Found';
            RETURN;
        WHEN OTHERS THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            RETURN;
    END get_associated_de;
    PROCEDURE search_crf_de(
        p_context                  IN       VARCHAR2
       ,p_crf_name                 IN       VARCHAR2
       ,p_protocol_id              IN       VARCHAR2
       ,p_asl_name                 IN       VARCHAR2
       ,p_cde_id                   IN       VARCHAR2   -- 02-Jul-2003, W. Ver Hoef
       ,p_de_crf_search_res        OUT      type_de_crf_search
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added "by"s per SPRF_2.1_10a
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 10-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 25-Mar-2004, W. Ver Hoef added per SPRF_21_03b
       ,p_crtl_name                IN       VARCHAR2 DEFAULT NULL   -- 01-Nov-2005, S. Alred (TT#1716)
                                                                 ) IS
        -- Date:  02-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_cde_id and associated comparison code to query by public
        --          id; substituted original asl_name comparison for code that handles multiple
        --          comma-separated values; replaced i.min_cde_id with d.cde_id and added origin
        --          to query result  (per SPRF_2.0_12)
        --
        -- Date:  14-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out de_source_name since origin is replacing it (per ScenPro
        --          request regarding testing changes for SPRF_2.0_12)
        --
        -- Date:  15-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  substituted like for = in comparison on q.crf where p_crf_name is ultimately
        --          used (per ScenPro request regarding testing changes for SPRF_2.0_12)
        --
        -- Date:  21-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  eliminated use of de_long_name_view in query and replaced quest_crf_view_ext
        --          with quest_crf_view2_ext which has 1 less table join and fewer columns which
        --          aren't needed here anyway
        --
        -- Date:  16-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added ar_idseq, registration_status, sub_idseq and sub_name (for submitter)
        --          to the return cursor per SPRF_2.1_03b
        --
        -- Date:  19-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_starting_date, p_created_ending_date,
        --          p_modified_starting_date, p_modified_ending_date and related code
        --          to filter by date, also included date_created and date_modified in
        --          return cursor per SPRF_2.1_10
        --
        -- Date:  02-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_by and p_modified_by and related code per SPRF_2.1_10a
        --
        -- Date:  04-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added v_protocol_id and modified comparison so users can use wildcard per SPRF_2.1_11
        --
        -- Date:  10-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added get_ua_full_name function to created/modified_by per SPRF_2.1_10a
        --          mod; added p_latest_version_ind and associated code per SPRF_2.1_08
        --
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added p_reg_status and associated code per SPRF_2.1_03b
        --
        -- Date:  30-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added columns, view, join for reference document counts/min doc text by doc type
        --          per SPRF_2.1_16 mod
        --
        -- Date:  31-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added hist_cde_count and min_hist_cde_name and associated pseudo-table query in
        --          the FROM clause, a join in the WHERE clause per a SPRF_2.1_12 mod
        --
        -- Date:  01-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added min_value and value_count, vc pseudo-table and join per SPRF_2.1_09 mod
        --
        -- Date:  01-Apr-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  took out hsn.doc_text historic_short_cde_name per mod to SPRF_2.1_16
        --
        -- Date:  12-May-2004
        -- Modified By: D Ladino
        -- Reason: Due to performance issues with the dynamic query we need to use the RULE based optimizer
        v_sql            VARCHAR2( 4000 );
        v_where          VARCHAR2( 2000 ) := ' ';
        v_crf            VARCHAR2( 255 )  := UPPER( REPLACE( p_crf_name, '*', '%' ));
        v_asl_name       VARCHAR2( 2000 );
        v_asl_list       VARCHAR2( 2000 );
        i                NUMBER           := 1;
        v_created_by     VARCHAR2( 255 )  := p_created_by;   -- 02-Mar-2004, W. Ver Hoef
        v_modified_by    VARCHAR2( 255 )  := p_modified_by;   -- added "by" vars
        v_protocol_id    VARCHAR2( 255 )  := UPPER( REPLACE( p_protocol_id, '*', '%' ));   -- 04-Mar-2004, W. Ver Hoef added
        v_lat_vers_ind   VARCHAR2( 2000 ) := p_latest_version_ind;   -- 10-Mar-2004, W. Ver Hoef added
    BEGIN
        IF p_de_crf_search_res%ISOPEN THEN
            CLOSE p_de_crf_search_res;
        END IF;
        -- CHANGES IN THE SELECT LIST:
        -- 02-Jul-2003, W. Ver Hoef replaced "i.min_cde_id" with ",d.cde_id"
        -- 02-Jul-2003, W. Ver Hoef added "d.origin"
        -- 14-Jul-2003, W. Ver Hoef took out ",sn.doc_text de_source_name "
        -- 14-Jul-2003, W. Ver Hoef took out ",sn.RD_IDSEQ de_sn_rd_idseq "
        -- 21-Jul-2003, W. Ver Hoef replaced ",r.doc_text" with ",d.question"
        -- 21-Jul-2003, W. Ver Hoef replaced ",r.RD_IDSEQ doc_rd_idseq" with "null"
        -- 16-Feb-2004, W. Ver Hoef added ar_idseq and registration_status
        -- 19-Feb-2004, W. Ver Hoef added date created/modified
        -- 02-Mar-2004, W. Ver Hoef added created/modified by
        -- 10-Mar-2004, W. Ver Hoef added get func. on created/modified by
        -- 25-Mar-2004, W. Ver Hoef took out ",s.sub_idseq" and ",s.name"
        -- 30-Mar-2004, W. Ver Hoef added doc type counts/min doc text
        -- 31-Mar-2004, W. Ver Hoef added hist_cde_count and min_hist_cde_name
        -- 01-Apr-2004, W. Ver Hoef added min_value, value_count; removed
        --                            ",hsn.doc_Text historic_short_cde_name"
        --
        -- CHANGES IN THE FROM LIST:
        -- 21-Jul-2003, W. Ver Hoef  took out ",de_long_name_view r "
        -- 21-Jul-2003, W. Ver Hoef added ",quest_crf_view2_ext"
        -- 02-Jul-2003, W. Ver Hoef took out ",de_cde_id_view i "
        -- 14-Jul-2003, W. Ver Hoef took out ",de_source_name_view sn "
        -- 16-Feb-2004, W. Ver Hoef added ",ac_registrations_view ar"
        -- 25-Mar-2004, W. Ver Hoef took out ",submitters_view s "
        -- 30-Mar-2004, W. Ver Hoef added ",ref_docs_sum_by_type_view v"
        -- 31-Mar-2004, W. Ver Hoef added hc pseudo-table sub-query for hist cde data
        -- 01-Apr-2004, W. Ver Hoef added vc pseudo-table; removed ",de_short_name_view hsn"
        -- CHANGES IN THE WHERE CLAUSE:
        -- 21-Jul-2003, W. Ver Hoef took out "AND d.de_idseq = r.ac_idseq(+) "
        -- 02-Jul-2003, W. Ver Hoef took out "AND d.de_idseq = i.ac_idseq(+) "
        -- 14-Jul-2003, W. Ver Hoef took out "AND d.de_idseq = sn.ac_idseq(+) "
        -- 16-Feb-2004, W. Ver Hoef added "AND d.de_idseq = ar.ac_idseq (+) "
        -- 25-Mar-2004, W. Ver Hoef took out "AND ar.sub_idseq = s.sub_idseq (+) "
        -- 30-Mar-2004, W. Ver Hoef added "AND d.de_idseq = v.ac_idseq (+) "
        -- 31-Mar-2004, W. Ver Hoef added join for hc pseudo-table for hist cde data
        -- 01-Apr-2003, W. Ver Hoef added vc join ; removed "AND d.de_idseq = hsn.ac_idseq (+)"
        v_sql :=
            'SELECT  d.preferred_name
           ,d.long_name
     ,d.preferred_definition
     ,d.asl_name
     ,d.conte_idseq
     ,d.begin_date
     ,d.end_date
     ,c.name
     ,d.dec_idseq
     ,NVL(DEC.long_name,DEC.preferred_name)  dec_name
     ,d.vd_idseq
     ,NVL(vd.long_name,vd.preferred_name)    vd_name
     ,d.version
     ,d.question
     ,d.cde_id
     ,d.change_note
     ,des.LAE_NAME   LANGUAGE
     ,d.de_idseq
       ,des.desig_idseq
     ,NULL
     ,DEC.preferred_name   dec_pref_name
     ,vd.preferred_name    vd_pref_name
     ,q.crf  crf_name
     ,p.protocol_id
     ,d.origin
     ,ar.ar_idseq             ar_idseq
     ,ar.registration_status  registration_status
     ,d.date_created
     ,d.date_modified
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(d.created_by)  created_by
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(d.modified_by) modified_by
              ,v2.doc_text long_name_doc_text
              ,v1.doc_text hist_cde_doc_text
              ,hc.hist_cde_count
              ,hc.min_hist_cde_name
     ,vc.min_value
     ,vc.value_count
        ,cxd.crtl_name derivation_type
 FROM       data_elements_view          d
           ,data_element_concepts_view  DEC
     ,value_domains_View          vd
     ,contexts                    c
     ,sbrext.de_cn_language_view         des
        ,complex_data_elements_view  cxd
     ,quest_crf_view2_ext         q
     ,protocols_view_ext          p
     ,ac_registrations_view       ar
              ,(SELECT ac_idseq, doc_text
                FROM reference_documents
                WHERE dctl_name = ''HISTORIC SHORT CDE NAME'')  v1
              ,(SELECT ac_idseq, doc_text
                FROM reference_documents
                WHERE dctl_name = ''Preferred Question Text'') v2
              ,(SELECT ac_idseq,
                       COUNT(1)            hist_cde_count,
                 MIN(name)           min_hist_cde_name
                FROM   designations_view
             WHERE  detl_name = ''HISTORICAL_CDE_ID''
             GROUP BY ac_idseq)         hc
     ,(SELECT vd_idseq, MIN(value) min_value, COUNT(1) value_count
       FROM   vd_pvs_view vp, permissible_values_view pv
    WHERE  vp.pv_idseq = pv.pv_idseq GROUP BY vd_idseq) vc
   WHERE       d.conte_idseq = c.conte_idseq
   AND         d.dec_idseq   = DEC.dec_idseq
   AND         d.vd_idseq    = vd.vd_idseq
   AND         d.de_idseq    = des.ac_idseq  (+)
   AND         d.de_idseq    = q.de_idseq    (+)
   AND         q.proto_idseq = p.proto_idseq (+)
   AND         d.de_idseq    = ar.ac_idseq   (+)
   AND         d.de_idseq    = v1.ac_idseq   (+)
   AND         d.de_idseq    = v2.ac_idseq   (+)
   AND         d.de_idseq    = hc.ac_idseq   (+)
   AND         vd.vd_idseq   = vc.vd_idseq   (+)
   AND         d.de_idseq    = cxd.p_de_idseq (+)';
        IF ( p_context IS NOT NULL ) THEN
            v_where := v_where || ' AND c.name = ' || '''' || p_context || '''';
        END IF;
        -- 02-Jul-2003, W. Ver Hoef
        -- substituted the following section for the commented out one below
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(d.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- IF (p_asl_name IS NOT NULL ) THEN
        --   v_where := v_where||' AND d.asl_name = '||''''||p_asl_name||'''';
        -- END IF;
        IF ( p_protocol_id IS NOT NULL ) THEN   -- 04-Mar-2004, W. Ver Hoef change from exact to like comparison
            v_where := v_where || ' AND upper(nvl(protocol_id,''-1'')) like upper(''' || v_protocol_id || ''')';
        END IF;
        IF ( v_crf IS NOT NULL ) THEN   -- 15-Jul-2003, W. Ver Hoef substituted like for = in comparison below
            v_where := v_where || ' AND upper(nvl(q.crf,''-1'')) like ''' || v_crf || '''';
        END IF;
        -- 02-Jul-2003, W. Ver Hoef added comparison
        IF ( p_cde_id IS NOT NULL ) THEN
            v_where := v_where || ' AND nvl(d.cde_id,''-1'') = ''' || p_cde_id || '''';
        END IF;
        -- 19-Feb-2004, W. Ver Hoef added if-then stmts for dates
        IF p_created_starting_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_created) >= TO_DATE(''' || p_created_starting_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_created_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_created) <= TO_DATE(''' || p_created_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(d.date_modified) >= TO_DATE('''
                || p_modified_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(d.date_modified) <= TO_DATE(''' || p_modified_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        -- 02-Mar-2004, W. Ver Hoef added if-then stmts for by's
        IF p_created_by IS NOT NULL THEN
            v_where := v_where || '
 AND d.created_by = ''' || v_created_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        IF p_modified_by IS NOT NULL THEN
            v_where := v_where || '
 AND d.modified_by = ''' || v_modified_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        -- 10-Mar-2004, W. Ver Hoef added to apply only when param is not null
        IF p_latest_version_ind IS NOT NULL THEN
            v_where := v_where || '
 AND d.latest_version_ind = ''' || v_lat_vers_ind || ''' ';
        END IF;
        -- 25-Mar-2004, W. Ver Hoef added if-then stmt
        IF ( p_reg_status IS NOT NULL ) THEN
            v_where := v_where || '
 AND ar.registration_status = ''' || p_reg_status || ''' ';
        END IF;
        -- 01-Nov-2005, S. Alred; added for TT1716
        IF ( p_crtl_name IS NOT NULL ) THEN
            v_where := v_where || '
  AND cxd.crtl_name = ''' || p_crtl_name || ''' ';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '  ORDER BY   upper(long_name )';
        DBMS_OUTPUT.put_line( TO_CHAR( LENGTH( v_sql )));
        DBMS_OUTPUT.put_line( TO_CHAR( LENGTH( v_where )));
        --dbms_output.put_line(substr(replace(v_where,'''',''''''),1,200));
        --dbms_output.put_line(substr(replace(v_where,'''',''''''),201,400));
        OPEN p_de_crf_search_res FOR v_sql;
    END;
    PROCEDURE search_de_cs_name( p_de_idseq IN VARCHAR2, p_cs_search_res OUT type_csname_search ) IS
    -- 16-Apr-2004, W. Ver Hoef added context name on the end of the cs name per SPRF_2.1_31
    BEGIN
        IF p_cs_search_res%ISOPEN THEN
            CLOSE p_cs_search_res;
        END IF;
        OPEN p_cs_search_res FOR
            SELECT   cs.cs_idseq
                    , NVL( cs.long_name, cs.preferred_name ) || ' - ' || c.NAME ||' - ' || cs_id || ' v' || cs.version long_name
                    ,   -- 16-Apr-2004, W. Ver Hoef
                     csi.csi_idseq
                    ,csi.csi_name
                    ,acsi.ac_csi_idseq   --31-jul-2003 Prerna Aggarwal
                    ,acsi.cs_csi_idseq   --08/01/03 Prerna Aggarwal
                    ,cs_csi.p_cs_csi_idseq
                    ,cs_csi.label
                    ,cs_csi.display_order
                    ,Sbrext_Common_Routines.get_csi_level( acsi.cs_csi_idseq ) csi_level
                    ,Sbrext_Common_Routines.get_cs_csi_do( cs.cs_idseq, cs_csi.cs_csi_idseq ) hier_level
                FROM classification_schemes cs
                    ,class_scheme_items csi
                    ,cs_csi
                    ,ac_csi acsi
                    ,contexts_view c   -- 16-Apr-2004, W. Ver Hoef
               WHERE acsi.cs_csi_idseq = cs_csi.cs_csi_idseq
                 AND cs_csi.cs_idseq = cs.cs_idseq
                 AND cs_csi.csi_idseq = csi.csi_idseq
                 AND acsi.ac_idseq = NVL( p_de_idseq, acsi.ac_idseq )
                 AND cs.conte_idseq = c.conte_idseq   -- 16-Apr-2004, W. Ver Hoef
            ORDER BY UPPER( cs.long_name )
                    ,hier_level;
    END;
    --New requirement
    PROCEDURE search_dec(
        p_conte_idseq              IN       VARCHAR2
       ,p_search_string            IN       VARCHAR2
       ,p_context                  IN       VARCHAR2
       ,p_asl_name                 IN       VARCHAR2
       ,p_dec_idseq                IN       VARCHAR2
       ,p_dec_id                   IN       VARCHAR2   -- 30-Jun-2003, W. Ver Hoef
       ,p_dec_search_res           OUT      type_dec_search
       ,p_reg_status               IN       VARCHAR2 DEFAULT NULL   -- 07-Feb-2013, for GF32398.
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_oc_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_14
       ,p_prop_idseq               IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_14
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_version                  IN       NUMBER   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_cd_idseq                 IN       VARCHAR2   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_de_idseq                 IN       VARCHAR2   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_3a
       ,p_cscsi_idseq              IN       VARCHAR2 DEFAULT NULL   -- 10-Nov-2005, S. Alred; added per TT#1098
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                                 )   -- 10-Mar-2004, W. Ver Hoef changed default from Yes to null
                                                                  IS
        -- Date:  30-Jun-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_dec_id to allow query by the public id; substituted
        --          a block of code for the simple where clause addition for p_asl_name
        --          to handle possibility of multiple comma-separated values; added
        --          comparison for dec_id to where clause and added origin and dec_id
        --          to query result   (per SPRF_2.0_12)
        --
        -- Date:  16-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  (1) added parameter p_origin to filter results by origin per SPRF_2.1_17
        --          (2) added parameters p_oc_idseq and p_prop_idseq to filter by object class
        --          and property per SPRF_2.1_14
        --
        -- Date:  19-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_starting_date, p_created_ending_date,
        --          p_modified_starting_date, p_modified_ending_date and related code
        --          to filter by date, also included date_created and date_modified in
        --          return cursor per SPRF_2.1_10
        --
        -- Date:  20-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added v_origin to be able to replace * with % and added upper function
        --          in comparison per SPRF_2.1_17
        --
        -- Date:  01-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_by and p_modified_by and related code per SPRF_2.1_10a
        --
        -- Date:  05-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_latest_version_ind and related code per SPRF_2.1_08
        --
        -- Date:  10-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added get_ua_full_name function to created/modified_by per SPRF_2.1_10a mod,
        --          also changed default of p_latest_version_ind from Yes to null and modififed
        --          code to handle Yes = latest version only, null = all versions (no restriction
        --          applied) per mod to SPRF_2.1_08
        --
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out used by cols, tabs, joins, comparison per SRPF_2.1_23
        --
        -- Date:  12-May-2004
        -- Modified By: D Ladino
        -- Reason: Due to performance issues with the dynamic query we need to use the RULE based optimizer
        -- 14-Nov-2005; S. Alred; Addec p_cs_csi parameter and related logic (TT1098)
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_sql             VARCHAR2( 6000 );
        v_where           VARCHAR2( 4000 ) := ' ';
        v_from            VARCHAR2( 2000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );   -- 30-Jun-2003, W. Ver Hoef
        v_asl_list        VARCHAR2( 2000 );
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_origin          VARCHAR2( 240 )  := UPPER( REPLACE( p_origin, '*', '%' ));   -- 20-Feb-2004, W. Ver Hoef added
        v_created_by      VARCHAR2( 255 )  := p_created_by;   -- 02-Mar-2004, W. Ver Hoef
        v_modified_by     VARCHAR2( 255 )  := p_modified_by;   -- added "by" vars
        v_lat_vers_ind    VARCHAR2( 2000 ) := p_latest_version_ind;   -- 05-Mar-2004, W. Ver Hoef added
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
    BEGIN
        IF p_dec_search_res%ISOPEN THEN
            CLOSE p_dec_search_res;
        END IF;
        --11/18/04 Prerna Aggarwal Added concept information SPRF_3.0_6a
        -- 30-Jun-2003, W. Ver Hoef
        -- 19-Feb-2004, W. Ver Hoef added dates
        -- 01-Mar-2004, W. Ver Hoef bys added
        v_sql :=
            'SELECT
 DEC.preferred_name
 ,DEC.long_name
 ,DEC.preferred_definition
 ,DEC.asl_name
 ,DEC.conte_idseq
 ,DEC.begin_date
 ,DEC.end_date
 ,DEC.version
 ,DEC.dec_idseq
 ,DEC.change_note
 ,c.name CONTEXT
 ,NVL(cd.long_name,cd.preferred_name) cd_name
 ,NVL(oc.long_name,oc.preferred_name) ocl_name
 ,NVL(prop.long_name,prop.preferred_name) propl_name
 ,oc.condr_idseq  oc_condr_idseq
 ,prop.condr_idseq prop_condr_idseq
 ,DEC.obj_class_qualifier
 ,DEC.property_qualifier
 ,des.LAE_NAME LANGUAGE
 ,des.DESIG_IDSEQ lae_des_idseq
 ,cd.CD_IDSEQ
 ,DEC.OC_IDSEQ
 ,DEC.PROP_IDSEQ
 ,DEC.dec_id
 ,DEC.ORIGIN
 ,ar.ar_idseq
 ,ar.registration_status
 ,DEC.date_created
 ,DEC.date_modified
 ,sbrext_cde_curator_pkg.get_ua_full_name(DEC.created_by)  created_by
 ,sbrext_cde_curator_pkg.get_ua_full_name(DEC.modified_by) modified_by
 ,prop.asl_name prop_asl_name
 ,oc.asl_name oc_asl_name
 ,rsl.display_order
 ,rsl.registration_status
 ,asl.display_order
 ,asl.asl_name
 ,sbrext_cde_curator_pkg.Get_One_Con_Name(DEC.dec_idseq, NULL) con_name
 ,sbrext_cde_curator_pkg.get_one_alt_name(DEC.dec_idseq) alt_name
 ,sbrext_cde_curator_pkg.get_one_rd_name(DEC.dec_idseq) rd_name ';
        v_from :=
            '
 FROM sbr.data_element_concepts_view  DEC
     ,sbr.conceptual_domains_view     cd
     ,sbr.contexts_view               c
     ,ac_registrations_view ar
     ,sbr.ac_status_lov_view asl
     ,sbr.reg_status_lov_view rsl
     ,sbrext.object_classes_view_ext  oc
     ,sbrext.properties_view_ext      prop
     ,sbrext.de_cn_language_view      des ';
        v_where :=
            '
 DEC.conte_idseq     = c.conte_idseq
 AND asl.asl_name = DEC.asl_name
 AND ar.ac_idseq (+)= DEC.de_idseq
 AND DEC.cd_idseq    = cd.cd_idseq
 AND DEC.oc_idseq    = oc.oc_idseq     (+)
 AND DEC.prop_idseq  = prop.prop_idseq (+)
 AND DEC.de_idseq    = ar.ac_idseq (+)
 AND DEC.dec_idseq   = des.ac_idseq    (+) ';
        IF v_search_string IS NOT NULL THEN
            -- 25-Mar-2004, W. Ver Hoef commented out comparison to u.name
            v_where :=
                   v_where
                || '
 AND ( UPPER(DEC.preferred_name) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR UPPER(NVL(DEC.long_name,'
                || ''''
                || ' '
                || ''''
                || ' )) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR    UPPER(DEC.preferred_definition) LIKE '
                || ''''
                || v_search_string
                || ''''
                || ') ';   -- '
        -- OR    upper(nvl(u.name,1)) like '||''''||v_search_string||''''||') ';
        END IF;
        IF ( p_conte_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND DEC.conte_idseq = ' || '''' || p_conte_idseq || '''';
        END IF;
        IF ( p_context IS NOT NULL ) THEN
               -- 25-Mar-2004, W. Ver Hoef commented out comparison to uc.name
               --v_where := v_where||'
            --AND c.name = '''||p_context||''''; --  or upper(uc.name) = upper('||''''||p_context||''''||')) ';
                --v_where := v_where||' AND c.name= '||''''||p_context||''''||'  ';
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        -- 30-Jun-2003, W. Ver Hoef
        -- substituted the following section for the commented out one below
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || '
 AND UPPER(DEC.asl_name) IN (' || v_asl_list || ')';
        END IF;
        -- IF (p_asl_name IS NOT NULL ) THEN
        --  v_where := v_where||' AND dec.asl_name = '||''''||p_asl_name||'''';
        -- END IF;
        IF ( p_dec_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND DEC.dec_idseq = ' || '''' || p_dec_idseq || '''';
        END IF;
        -- 30-Jun-2003, W. Ver Hoef
        IF ( p_dec_id IS NOT NULL ) THEN
            v_where := v_where || '
 AND DEC.dec_id = ''' || p_dec_id || '''';
        END IF;
        -- 07-Feb-2013 FRO GF32398
        IF ( p_reg_status IS NOT NULL ) THEN
            v_where := v_where || '
 AND ar.registration_status = ''' || p_reg_status || '''';
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_origin IS NOT NULL ) THEN
            v_where := v_where || '
 AND UPPER(DEC.origin) LIKE ''' || v_origin || '''';   -- 20-Feb-2004, W. Ver Hoef added upper, switched to v_origin
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_oc_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND DEC.oc_idseq = ''' || p_oc_idseq || '''';
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_prop_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND DEC.prop_idseq = ''' || p_prop_idseq || '''';
        END IF;
        -- 19-Feb-2004, W. Ver Hoef added if-then stmts for dates
        IF p_created_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(DEC.date_created) >= TO_DATE('''
                || p_created_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_created_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(DEC.date_created) <= TO_DATE(''' || p_created_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(DEC.date_modified) >= TO_DATE('''
                || p_modified_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_ending_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(DEC.date_modified) <= TO_DATE('''
                || p_modified_ending_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        -- 01-Mar-2004, W. Ver Hoef added if-then stmts for by's
        IF p_created_by IS NOT NULL THEN
            v_where := v_where || '
 AND DEC.created_by = ''' || v_created_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        IF p_modified_by IS NOT NULL THEN
            v_where := v_where || '
 AND DEC.modified_by = ''' || v_modified_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        -- 10-Mar-2004, W. Ver Hoef added per SPRF_2.1_08 mod
        IF p_latest_version_ind IS NOT NULL THEN
            v_where := v_where || '
 AND DEC.latest_version_ind = ''' || v_lat_vers_ind || ''' ';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_version <> 0 THEN
            v_where := v_where || '
 AND         DEC.version  = ' || p_version || ' ';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_cd_idseq IS NOT NULL THEN
            v_where := v_where || '
 AND         DEC.cd_idseq  = ''' || p_cd_idseq || '''';
        END IF;
        IF p_de_idseq IS NOT NULL THEN
            v_from := v_from || ' ,data_elements de ';
            v_where :=
                   v_where
                || ' and de.dec_idseq = dec.dec_idseq
                       AND de.de_idseq = '''
                || p_de_idseq
                || '''';
        END IF;
        -- 14-Nov-2005; S. Alred; added to apply only when parameter is not null
        IF p_cscsi_idseq IS NOT NULL THEN
            v_from := v_from || '
    ,cs_csi_view              csi
    ,ac_csi_view              aci';
            v_where :=
                   v_where
                || '
               AND         csi.cs_csi_idseq = aci.cs_csi_idseq
               AND         DEC.dec_idseq    = aci.ac_idseq
               AND         csi.cs_csi_idseq = '''
                || p_cscsi_idseq
                || '''';
        END IF;
        -- 6-dec-2005, S. Hegde; added for TT1780 for con name OR con idseq filter
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 DEC.dec_idseq IN (
 SELECT decv.dec_idseq
 FROM sbr.conceptual_domains_view          cdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,sbr.data_element_concepts_view       decv
 WHERE '
                || v_con_name
                || '
   AND CON.CON_IDSEQ = CC.CON_IDSEQ
   AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
   AND CDR.CONDR_IDSEQ = cdv.CONDR_IDSEQ
   AND cdv.cd_idseq = decv.cd_idseq
 UNION
 SELECT decv.dec_idseq
 FROM sbrext.object_classes_view_ext       OCV
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,sbr.data_element_concepts_view       decv
 WHERE '
                || v_con_name
                || '
   AND CON.CON_IDSEQ = CC.CON_IDSEQ
   AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
   AND CDR.CONDR_IDSEQ = OCV.CONDR_IDSEQ
   AND ocv.oc_idseq = decv.oc_idseq
 UNION
 SELECT decv.dec_idseq
 FROM sbrext.properties_view_ext           PROPV
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,sbr.data_element_concepts_view       decv
 WHERE '
                || v_con_name
                || '
   AND CON.CON_IDSEQ = CC.CON_IDSEQ
   AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
   AND CDR.CONDR_IDSEQ = PROPV.CONDR_IDSEQ
   AND propv.prop_idseq = decv.prop_idseq
) AND '
                || v_where;
        --separate the con name and con idseq filters
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '  ORDER BY rsl.display_order, asl.display_order, upper(long_name )';
        /*
          i := 1;
          WHILE (i < LENGTH(v_sql)) LOOP
              dbms_output.put_line(SUBSTR(v_sql, i, 200));
              i := i + 200;
          END LOOP;
        */
        -- 01-Jul-2003, W. Ver Hoef added for debugging purposes
        -- dbms_output.put_line(SUBSTR(v_where,1,200));
        -- dbms_output.put_line(SUBSTR(v_where,201,400));
        OPEN p_dec_search_res FOR v_sql;
    END;
    -- 22-Jul-2003, W. Ver Hoef added get_associated_dec per SPRF_2.0_07
    PROCEDURE get_associated_dec(
        p_de_idseq        IN       VARCHAR2
       ,p_cd_idseq        IN       VARCHAR2
       ,p_return_code     OUT      VARCHAR2
       ,p_return_desc     OUT      VARCHAR2
       ,p_assoc_dec_res   OUT      type_assoc_dec
       ,p_prop_idseq      IN       VARCHAR2 DEFAULT NULL   -- 01-Mar-2004, W. Ver Hoef
       ,p_oc_idseq        IN       VARCHAR2 DEFAULT NULL )   -- added prop and oc params
                                                          IS
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added created/modified columns per SPRF_2.1_22;
        --          commented out used by cols, tabs, joins, comparison per SRPF_2.1_23
        v_select   VARCHAR2( 2000 ) := ' ';
        v_from     VARCHAR2( 2000 ) := ' ';
        v_where    VARCHAR2( 2000 ) := ' ';
        v_sql      VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_assoc_dec_res%ISOPEN THEN
            CLOSE p_assoc_dec_res;
        END IF;
        p_return_code := 0;
        p_return_desc := NULL;
        -- validate parameter values only 1 is allowed
        IF    ( p_de_idseq IS NOT NULL AND p_cd_idseq IS NOT NULL )
           OR ( p_de_idseq IS NOT NULL AND p_prop_idseq IS NOT NULL )
           OR   -- 01-May-2004, W. Ver Hoef
              ( p_de_idseq IS NOT NULL AND p_oc_idseq IS NOT NULL )
           OR   -- added prop/oc combinations
              ( p_cd_idseq IS NOT NULL AND p_prop_idseq IS NOT NULL )
           OR ( p_cd_idseq IS NOT NULL AND p_oc_idseq IS NOT NULL )
           OR ( p_prop_idseq IS NOT NULL AND p_oc_idseq IS NOT NULL ) THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass a value for either P_DE_IDSEQ or '
                || 'P_CD_IDSEQ or P_PROP_IDSEQ or P_OC_IDSEQ, but not more than one';
            RETURN;
        ELSIF p_de_idseq IS NULL AND p_cd_idseq IS NULL AND p_prop_idseq IS NULL AND p_oc_idseq IS NULL THEN   -- 01-Mar-2004, W. Ver Hoef added prop/oc
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass a value for either P_DE_IDSEQ or '
                || 'P_CD_IDSEQ or P_PROP_IDSEQ or P_OC_IDSEQ, but one or the other is required';
            RETURN;
        END IF;
        -- define the basic query
        v_select :=
            'SELECT distinct dec.dec_idseq -- should eliminate potential for cartesian product when using p_de_idseq
     ,DEC.preferred_name
           ,DEC.long_name
        ,DEC.preferred_definition
     ,DEC.asl_name
     ,DEC.conte_idseq
     ,DEC.begin_date
     ,DEC.end_date
     ,DEC.version
     ,DEC.change_note
     ,c.name CONTEXT
     ,NVL(cd.long_name,cd.preferred_name)  cd_name
     ,oc.preferred_name  ocl_name
     ,prop.preferred_name  propl_name
     ,DEC.obj_class_qualifier
     ,DEC.property_qualifier
     ,des.LAE_NAME  LANGUAGE
     ,des.DESIG_IDSEQ  lae_des_idseq
     ,cd.CD_IDSEQ
     ,DEC.OC_IDSEQ
     ,DEC.PROP_IDSEQ
     -- ,u.name  usedby_name -- 25-Mar-2004, W. Ver Hoef commented out used by cols
     -- ,uc.name  used_by_context
     -- ,u.desig_idseq  u_desig_idseq
     ,DEC.dec_id
     ,DEC.ORIGIN
     ,DEC.date_created -- 25- Mar-2004, W. Ver Hoef added created/modified cols
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(DEC.created_by)  created_by
     ,DEC.date_modified
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(DEC.modified_by) modified_by ';
        v_from :=
            '
 FROM       data_element_concepts_view DEC
            ,conceptual_domains_view cd
      ,contexts_view c
      ,object_classes_view_ext oc
      ,properties_view_ext prop
      ,sbrext.de_cn_language_view des ';
        -- ,used_by_view u -- 25-Mar-2004, W. Ver Hoef commented out used by tabs
        -- ,contexts_view uc ';
        v_where :=
            '
    WHERE       DEC.conte_idseq = c.conte_idseq
    AND         DEC.cd_idseq    = cd.cd_idseq
    AND         DEC.oc_idseq    = oc.oc_idseq (+)
    AND         DEC.prop_idseq  = prop.prop_idseq (+)
    AND         DEC.dec_idseq   = des.ac_idseq (+) ';
        --    AND         dec.dec_idseq   = u.ac_idseq (+) -- 25-Mar-2004, W. Ver Hoef commented out used by joins
        --    AND         u.conte_idseq   = uc.conte_idseq (+) ';
          -- apply the appropriate parameter to the query
        IF p_de_idseq IS NOT NULL THEN
            v_from := v_from || '
              ,data_elements_view de ';
            v_where :=
                   v_where
                || '
              AND DEC.dec_idseq = de.dec_idseq (+)
              AND de.de_idseq = '''
                || p_de_idseq
                || '''';
        ELSIF p_cd_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND DEC.cd_idseq = ''' || p_cd_idseq || '''';
        ELSIF p_prop_idseq IS NOT NULL THEN   -- 01-Mar-2004, W. Ver Hoef added conditions for prop and oc
            v_where := v_where || '
              AND DEC.prop_idseq = ''' || p_prop_idseq || '''';
        ELSE   -- p_oc_idseq is not null
            v_where := v_where || '
              AND DEC.oc_idseq = ''' || p_oc_idseq || '''';
        END IF;
        -- assemble the parts of the query
        v_sql := v_select || v_from || v_where || '
             ORDER BY UPPER(DEC.long_name )';
        -- get the data
        OPEN p_assoc_dec_res FOR v_sql;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 0;
            p_return_desc := 'No Data Found';
            RETURN;
        WHEN OTHERS THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            RETURN;
    END get_associated_dec;
    PROCEDURE search_vd(
        p_conte_idseq              IN       VARCHAR2
       ,p_search_string            IN       VARCHAR2
       ,p_context                  IN       VARCHAR2
       ,p_asl_name                 IN       VARCHAR2
       ,p_vd_idseq                 IN       VARCHAR2
       ,p_vd_id                    IN       VARCHAR2   -- 01-Jul-2003, W. Ver Hoef
       ,p_vd_search_res            OUT      type_vd_search
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 16-Feb-2004, W. Ver Hoef added per SPRF_2.1_17
       ,p_created_starting_date    IN       VARCHAR2
                DEFAULT NULL   -- 19-Feb-2004, W. Ver Hoef added params per SPRF_2.1_10
       ,p_created_ending_date      IN       VARCHAR2 DEFAULT NULL
       ,p_modified_starting_date   IN       VARCHAR2 DEFAULT NULL
       ,p_modified_ending_date     IN       VARCHAR2 DEFAULT NULL
       ,p_created_by               IN       VARCHAR2 DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL   -- added created/mod by params
       ,p_permissible_value        IN       VARCHAR2 DEFAULT NULL   -- 03-Mar-2004, W. Ver Hoef added per SPRF_2.1_09
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_vd_type_flag             IN       VARCHAR2 DEFAULT NULL   -- 23-Mar-2004, W. Ver Hoef added per SPRF_2.1_13
       ,p_version                  IN       NUMBER   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_cd_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_pv_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_de_idseq                 IN       VARCHAR2 DEFAULT NULL   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_3a
       ,p_datatype                 IN       VARCHAR2 DEFAULT NULL   -- 31-Oct-2005, S. Alred; added per TT#1684
       ,p_cscsi_idseq              IN       VARCHAR2 DEFAULT NULL   -- 10-Nov-2005, S. Alred; added per TT#1098
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_vm_idseq                 IN       VARCHAR2 DEFAULT NULL  -- 11-Mar-2008, PAGGARWA
                                                                 ) IS
        -- Date:  01-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_vd_id to allow query by the public id; substituted
        --          a block of code for the simple where clause addition for p_asl_name
        --          to handle possibility of multiple comma-separated values; added
        --          vd_id comparison to where clause; added origin and vd_id to query
        --          result  (per SPRF_2.0_12)
        --
        -- Date:  16-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_origin to filter results by origin per SPRF_2.1_17
        --
        -- Date:  19-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_starting_date, p_created_ending_date,
        --          p_modified_starting_date, p_modified_ending_date and related code
        --          to filter by date, also included date_created and date_modified in
        --          return cursor per SPRF_2.1_10
        --
        -- Date:  20-Feb-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added v_origin to be able to replace * with % and added upper function
        --          in comparison per SPRF_2.1_17
        --
        -- Date:  02-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameters p_created_by and p_modified_by and related code per SPRF_2.1_10a
        --
        -- Date:  03-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_permissible_value and related code per SPRF_2.1_09
        --
        -- Date:  05-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_latest_version_ind and related code per SPRF_2.1_08
        --
        -- Date:  10-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added get_ua_full_name function to created/modified_by per SPRF_2.1_10a
        --          mod; moved where clause for latest_version_ind to if-then stmtm per mod
        --          to SPRF_2.1_08
        --
        -- Date:  23-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_vd_type_flag and related code per SPRF_2.1_13
        --
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out used by cols, tabs, joins, comparison per SRPF_2.1_23
        --
        -- Date:  31-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added min_value and value_count columns and associated pseudo-table sub-query and
        --          join; redesigned parameter comparison for p_permissible_value per SPRF_2.1_09 mod
        --
        -- Date:  12-May-2004
        -- Modified By: D Ladino
        -- Reason: Due to performance issues with the dynamic query we need to use the RULE based optimizer
        -- Date:  31-Oct-2005
        -- Modified By: Steve Alred
        -- Reason: TT#1684 -- add VD datatype as a query filter parameter (p_datatype)
        --
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_sql             VARCHAR2( 6000 );
        v_where           VARCHAR2( 4000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );   -- 01-Jul-2003, W. Ver Hoef
        v_asl_list        VARCHAR2( 2000 );
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_origin          VARCHAR2( 240 )  := UPPER( REPLACE( p_origin, '*', '%' ));   -- 20-Feb-2004, W. Ver Hoef added
        v_created_by      VARCHAR2( 255 )  := p_created_by;   -- 02-Mar-2004, W. Ver Hoef
        v_modified_by     VARCHAR2( 255 )  := p_modified_by;   -- added "by" vars
        v_perm_value      VARCHAR2( 255 )  := UPPER( REPLACE( p_permissible_value, '*', '%' ));   -- 03-Mar-2004, W. Ver Hoef
        v_select          VARCHAR2( 2000 );   -- 03-Mar-2004, W. Ver Hoef added to hold parts of query
        v_from            VARCHAR2( 2000 );
        v_lat_vers_ind    VARCHAR2( 2000 ) := NVL( p_latest_version_ind, 'Yes' );   -- 05-Mar-2004, W. Ver Hoef added
        v_vd_type_flag    VARCHAR2( 20 );   -- 23-Mar-2004, W. Ver Hoef added per SPRF_21_13
        v_vd_type_list    VARCHAR2( 20 );   -- 23-Mar-2004, W. Ver Hoef added per SPRF_21_13
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
    BEGIN
        IF p_vd_search_res%ISOPEN THEN
            CLOSE p_vd_search_res;
        END IF;
         --11/18/04 Prerna Aggarwal Added concept information SPRF_3.0_6a
        -- 01-Jul-2003, W. Ver Hoef
        -- 19-Feb-2004, W. Ver Hoef added dates
        -- 02-Mar-2004, W. Ver Hoef added bys
        -- 10-Mar-2004, W. Ver Hoef added get func.
        v_select :=
            'SELECT
 vd.preferred_name
 ,vd.long_name
 ,vd.preferred_definition
 ,vd.conte_idseq
 ,vd.asl_name
 ,vd.vd_idseq
 ,vd.version
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
 ,r.preferred_name                    rep_term
 ,vd.rep_idseq
 ,vd.qualifier_name
 ,c.name CONTEXT
 ,vd.cd_idseq
 ,NVL(cd.long_name, cd.preferred_name) cd_name
 ,des.LAE_NAME                        LANGUAGE
 ,des.DESIG_IDSEQ                     lae_des_idseq
 ,vd.vd_id
 ,vd.origin
 ,vd.date_created
 ,vd.date_modified
 ,sbrext_cde_curator_pkg.get_ua_full_name(vd.created_by)  created_by
 ,sbrext_cde_curator_pkg.get_ua_full_name(vd.modified_by) modified_by
 ,vc.min_value
 ,vc.value_count
 ,r.condr_idseq rep_condr_idseq
 ,vd.condr_idseq vd_condr_idseq
 ,NVL(r.long_name,r.preferred_name) rep_long_name
 ,r.asl_name rep_asl_name
 ,asl.display_order
 ,asl.asl_name
 ,sbrext_cde_curator_pkg.Get_One_Con_Name(NULL, vd.vd_idseq) con_name
 ,sbrext_cde_curator_pkg.get_one_alt_name(vd.vd_idseq) alt_name
 ,sbrext_cde_curator_pkg.get_one_rd_name(vd.vd_idseq) rd_name ';
        -- NOTE: pseudo-table sub-query and join for vc defined below with p_permissible_value condition
        v_from :=
            '
 FROM
     sbr.value_domains_view       vd
    ,sbr.conceptual_domains_view  cd
    ,sbr.contexts_view            c
    ,sbr.ac_status_lov_view asl
    ,sbrext.de_cn_language_view   des
    ,sbrext.REPRESENTATIONS_EXT   r ';
        v_where :=
            '
 vd.conte_idseq   = c.conte_idseq
 AND asl.asl_name = vd.asl_name
 AND vd.cd_idseq  = cd.cd_idseq
 AND vd.vd_idseq  = des.ac_idseq (+)
 AND vd.rep_idseq = r.rep_idseq  (+) ';
        IF v_search_string IS NOT NULL THEN
            -- 25-Mar-2004, W. Ver Hoef commented out comparison to u.name
            v_where :=
                   v_where
                || '
 AND ( UPPER(vd.preferred_name) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR UPPER(NVL(vd.long_name,'
                || ''''
                || ' '
                || ''''
                || ' )) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
 OR UPPER(vd.preferred_definition) LIKE '
                || ''''
                || v_search_string
                || ''''
                || ') ';   --'
        -- OR upper(nvl(u.name,1)) like '||''''||v_search_string||''''||') ';
        END IF;
        IF ( p_conte_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND vd.conte_idseq = ' || '''' || p_conte_idseq || '''';
        END IF;
        IF ( p_context IS NOT NULL ) THEN
               -- 25-Mar-2004, W. Ver Hoef commented out comparison to uc.name
              -- v_where := v_where||'
            --AND upper(c.name) = upper('||''''||p_context||''''||')'; --  or upper(uc.name) = upper('||''''||p_context||''''||')) ';
               --v_where := v_where||' AND c.name= '||''''||p_context||''''||'  ';
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        -- 30-Jun-2003, W. Ver Hoef
        -- substituted the following section for the commented out one below
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || '
 AND UPPER(vd.asl_name) IN (' || v_asl_list || ')';
        END IF;
        --  IF (p_asl_name IS NOT NULL ) THEN
        --    v_where := v_where||' AND vd.asl_name = '||''''||p_asl_name||'''';
        --  END IF;
        IF ( p_vd_idseq IS NOT NULL ) THEN
            v_where := v_where || '
 AND vd.vd_idseq = ' || '''' || p_vd_idseq || '''';
        END IF;
        IF ( p_pv_idseq IS NOT NULL ) THEN
            v_from := v_from || ' ,vd_pvs vp ';
            v_where := v_where || '
 AND vd.vd_idseq = vp.vd_idseq
 AND vp.pv_idseq = ' || '''' || p_pv_idseq || '''';
        END IF;
        IF ( p_de_idseq IS NOT NULL ) THEN
            v_from := v_from || ' ,data_elements d ';
            v_where := v_where || '
 AND vd.vd_idseq = d.vd_idseq
 AND d.de_idseq = ' || '''' || p_de_idseq || '''';
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added comparison
        IF ( p_vd_id IS NOT NULL ) THEN
            v_where := v_where || '
 AND vd.vd_id = ' ||   '''' || p_vd_id || '''';
        END IF;
        -- 16-Feb-2004, W. Ver Hoef added comparison
        IF ( p_origin IS NOT NULL ) THEN
            v_where := v_where || '
 AND UPPER(vd.origin) LIKE ''' || v_origin || '''';   -- 20-Feb-2004, W. Ver Hoef added upper function, switched to v_origin
        END IF;
        -- 19-Feb-2004, W. Ver Hoef added if-then stmts for dates
        IF p_created_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(vd.date_created) >= TO_DATE('''
                || p_created_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_created_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(vd.date_created) <= TO_DATE(''' || p_created_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(vd.date_modified) >= TO_DATE('''
                || p_modified_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_ending_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(vd.date_modified) <= TO_DATE('''
                || p_modified_ending_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        -- 02-Mar-2004, W. Ver Hoef added if-then stmts for by's
        IF p_created_by IS NOT NULL THEN
            v_where := v_where || '
 AND vd.created_by = ''' || v_created_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        IF p_modified_by IS NOT NULL THEN
            v_where := v_where || '
 AND vd.modified_by = ''' || v_modified_by || '''';   -- 10-Mar-2004, W. Ver Hoef changed like to =
        END IF;
        /*
          -- 03-Mar-2004, W. Ver Hoef added if-then stmt for permissible value
          IF p_permissible_value IS NOT NULL THEN
            v_from  := v_from||'
                      ,vd_pvs_view vp
                      ,permissible_values_view pv ';
            v_where := v_where||'
            AND vd.vd_idseq = vp.vd_idseq
            AND vp.pv_idseq = pv.pv_idseq
            AND upper(pv.value) like '''||v_perm_value||'''';
          END IF;
        */-- 31-Mar-2004, W. Ver Hoef replaced original if-then for permissible value above
          --                            with the following
        IF p_permissible_value IS NOT NULL THEN
            v_from :=
                   v_from
                || '
   ,(SELECT vd_idseq,
            MIN(value)               min_value,
            COUNT(1)                 value_count
     FROM   vd_pvs_view              vp,
         permissible_values_view  pv
     WHERE  vp.pv_idseq = pv.pv_idseq
  AND    UPPER(pv.value) LIKE '''
                || v_perm_value
                || '''
  GROUP BY vd_idseq) vc ';
            v_where := v_where || '
   AND vd.vd_idseq = vc.vd_idseq ';
        ELSE
            v_from :=
                   v_from
                || '
   ,(SELECT vd_idseq,
            MIN(value)               min_value,
            COUNT(1)                 value_count
     FROM   vd_pvs_view              vp,
         permissible_values_view  pv
     WHERE  vp.pv_idseq = pv.pv_idseq
  GROUP BY vd_idseq) vc ';
            v_where := v_where || '
   AND vd.vd_idseq = vc.vd_idseq (+) ';
        END IF;
        IF p_latest_version_ind IS NOT NULL THEN
            v_where := v_where || '
    AND vd.latest_version_ind = ''' || v_lat_vers_ind || ''' ';
        END IF;
        -- 23-Mar-2004, W. Ver Hoef added per SPRF_21_13
        -- 24-Jun-2004, D. Ladino reset the i variable
        i := 1;
        IF ( p_vd_type_flag IS NOT NULL ) THEN
            v_vd_type_flag := UPPER( p_vd_type_flag );
            WHILE( i != 0 AND v_vd_type_flag IS NOT NULL ) LOOP
                i := INSTR( v_vd_type_flag, ',' );
                IF i = 0 THEN
                    v_vd_type_list := v_vd_type_list || ',''' || LTRIM( RTRIM( v_vd_type_flag )) || '''';
                ELSE
                    v_vd_type_list :=
                                   v_vd_type_list || ',''' || LTRIM( RTRIM( SUBSTR( v_vd_type_flag, 1, i - 1 )))
                                   || '''';
                END IF;
                v_vd_type_flag := SUBSTR( v_vd_type_flag, i + 1 );
            END LOOP;
            v_vd_type_list := SUBSTR( v_vd_type_list, 2, LENGTH( v_vd_type_list ));
            v_where := v_where || '
 AND UPPER(vd.vd_type_flag) IN (' || v_vd_type_list || ')';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_version <> 0 THEN
            v_where := v_where || '
 AND         vd.version  = ' || p_version || ' ';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_cd_idseq IS NOT NULL THEN
            v_where := v_where || '
 AND         vd.cd_idseq  = ''' || p_cd_idseq || '''';
        END IF;
        -- 31-Oct-2005; S. Alred; added to apply only when parameter is not null
        IF p_datatype IS NOT NULL THEN
            v_where := v_where || '
  AND         vd.dtl_name = ''' || p_datatype || '''';
        END IF;

         if p_vm_idseq is not null then
          v_from := v_from||' '||'
          ,sbr.vd_pvs_view vp
          ,sbr.permissible_values_view pv';
          v_where := v_where||' '||'
          AND vd.vd_idseq = vp.vd_idseq
          AND vp.pv_idseq = pv.pv_idseq
          AND pv.vm_idseq = '||''''||p_vm_idseq||'''';
        end if;
        -- 11-Nov-2005; S. Alred; added to apply only when parameter is not null
        IF p_cscsi_idseq IS NOT NULL THEN
            v_from := v_from || '
    ,cs_csi_view              csi
    ,ac_csi_view              aci';
            v_where :=
                   v_where
                || '
               AND         csi.cs_csi_idseq   = aci.cs_csi_idseq
               AND         vd.vd_idseq        = aci.ac_idseq
               AND         csi.cs_csi_idseq = '''
                || p_cscsi_idseq
                || '''';
        END IF;
        -- 6-dec-2005, S. Hegde; added for TT1780 for con name OR con idseq filter
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_IDSEQ = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 vd.vd_idseq IN (
 SELECT vdv.vd_idseq
 FROM sbr.value_domains_view               vdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = vdv.CONDR_IDSEQ
 UNION
 SELECT vdv.vd_idseq
 FROM sbr.value_domains_view               vdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,sbrext.REPRESENTATIONS_EXT           rep
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = rep.CONDR_IDSEQ
 AND rep.rep_idseq = vdv.rep_idseq
 UNION
 SELECT vdv.vd_idseq
 FROM sbr.value_domains_view               vdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,sbr.conceptual_domains_view          cdv
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = cdv.CONDR_IDSEQ
 AND cdv.cd_idseq = vdv.cd_idseq
 UNION
 SELECT vdv.vd_idseq
 FROM sbr.value_domains_view               vdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
     ,VD_PVS_VIEW                          cvp
     ,permissible_values_view              cpv
     ,value_meanings_view              cvm
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.condr_idseq = cvm.condr_idseq
 AND cvm.vm_idseq = cpv.vm_idseq
 AND cpv.pv_idseq = cvp.pv_idseq
 AND cvp.vd_IDSEQ = vdv.vd_IDSEQ
 ) AND '
                || v_where;
        END IF;
        v_sql := v_select || v_from || ' WHERE ' || v_where || '  ORDER BY asl.display_order, upper(vd.long_name )';   -- 03-Mar-2004, W. Ver Hoef
        /*
          i := 1;
          WHILE (i < LENGTH(v_sql)) LOOP
              dbms_output.put_line(SUBSTR(v_sql, i, 200));
              i := i + 200;
          END LOOP;
        */
        -- 01-Jul-2003, W. Ver Hoef added for debugging purposes
          /*dbms_output.put_line(substr(v_where,1,100));
            dbms_output.put_line(substr(v_where,101,100));
            dbms_output.put_line(substr(v_where,201,100));
            dbms_output.put_line(substr(v_where,301,100));
            dbms_output.put_line(substr(v_where,401,100));
           */
        OPEN p_vd_search_res FOR v_sql;
    END;
    -- 22-Jul-2003, W. Ver Hoef added get_associated_vd per SPRF_2.0_08
    -- 16-Feb-2004, W. Ver Hoef added paramter p_de_idseq and associated code per SPRF_2.1_19
    PROCEDURE get_associated_vd(
        p_pv_idseq       IN       VARCHAR2
       ,p_cd_idseq       IN       VARCHAR2
       ,p_return_code    OUT      VARCHAR2
       ,p_return_desc    OUT      VARCHAR2
       ,p_assoc_vd_res   OUT      type_assoc_vd
       ,p_de_idseq       IN       VARCHAR2 DEFAULT NULL ) IS
        -- Date:  25-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added created/modified columns per SPRF_2.1_22;
        --          commented out used by cols, tabs, joins, comparison per SRPF_2.1_23
        --
        -- Date:  31-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  added min_value and value_count, vc pseudo-table and join per SPRF_2.1_09 mod
        v_select   VARCHAR2( 2000 ) := ' ';
        v_from     VARCHAR2( 2000 ) := ' ';
        v_where    VARCHAR2( 2000 ) := ' ';
        v_sql      VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_assoc_vd_res%ISOPEN THEN
            CLOSE p_assoc_vd_res;
        END IF;
        p_return_code := 0;
        p_return_desc := NULL;
        -- validate parameter values only 1 is allowed
        IF p_pv_idseq IS NOT NULL AND p_cd_idseq IS NOT NULL AND p_de_idseq IS NOT NULL THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass one value for either P_PV_IDSEQ or '
                || 'P_CD_IDSEQ or P_DE_IDSEQ, but not all three';
            RETURN;
        ELSIF p_pv_idseq IS NULL AND p_cd_idseq IS NULL AND p_de_idseq IS NULL THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass one value for either P_PV_IDSEQ or '
                || 'P_CD_IDSEQ or P_DE_IDSEQ, but one or the other is required';
            RETURN;
        ELSIF     NOT( p_pv_idseq IS NOT NULL AND p_cd_idseq IS NULL AND p_de_idseq IS NULL )
              AND NOT( p_pv_idseq IS NULL AND p_cd_idseq IS NOT NULL AND p_de_idseq IS NULL )
              AND NOT( p_pv_idseq IS NULL AND p_cd_idseq IS NULL AND p_de_idseq IS NOT NULL ) THEN
            p_return_code := '-1';
            p_return_desc :=
                   'Parameter Error:  Must pass one value for either P_PV_IDSEQ or '
                || 'P_CD_IDSEQ or P_DE_IDSEQ, but not more than one at a time';
        END IF;
        -- define the basic query
        v_select :=
            'SELECT   distinct vd.vd_idseq -- should eliminate potential for cartesian product when using p_pv_idseq
     ,vd.preferred_name
           ,vd.long_name
        ,vd.preferred_definition
     ,vd.conte_idseq
     ,vd.asl_name
     ,vd.version
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
     ,r.preferred_name rep_term
     ,vd.rep_idseq
     ,vd.qualifier_name
     ,c.name CONTEXT
              ,vd.cd_idseq
     ,NVL(cd.long_name,cd.preferred_name) cd_name
     ,des.LAE_NAME LANGUAGE
     ,des.DESIG_IDSEQ lae_des_idseq
     -- ,u.name usedby_name -- 25-Mar-2004, W. Ver Hoef commented out used by cols
     -- ,uc.name  used_by_context
     -- ,u.desig_idseq u_desig_idseq
     ,vd.vd_id
     ,vd.origin
     ,vd.date_created  -- 25-Mar-2004, W. Ver Hoef added created/modified cols
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(vd.created_by)  created_by
     ,vd.date_modified
     ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(vd.modified_by) modified_by
     ,vc.min_value
     ,vc.value_count ';   -- 31-Mar-2004, W. Ver Hoef added min_value value_count
        v_from :=
            '
 FROM       value_domains_view      vd
           ,conceptual_domains_view cd
     ,contexts_view           c
     ,sbrext.de_cn_language_view     des
     -- ,used_by_view u -- 25-Mar-2004, W. Ver Hoef commented out used by tabs
     -- ,contexts_view uc
     ,REPRESENTATIONS_EXT     r
     ,(SELECT vd_idseq,
                    MIN(value)               min_value,
                    COUNT(1)                 value_count
             FROM   vd_pvs_view              vp,
                 permissible_values_view  pv
             WHERE  vp.pv_idseq = pv.pv_idseq
          GROUP BY vd_idseq)     vc  ';   -- 31-Mar-2004, W. Ver Hoef added vc pseudo-table
        v_where :=
            '
   WHERE       vd.conte_idseq = c.conte_idseq
   AND         vd.cd_idseq    = cd.cd_idseq
   AND         vd.vd_idseq    = des.ac_idseq (+)
   AND         vd.rep_idseq   = r.rep_idseq  (+)
   AND         vd.vd_idseq    = vc.vd_idseq  (+) ';   -- 31-Mar-2003, W. Ver Hoef added vc join
        --   AND         vd.vd_idseq    = u.ac_idseq (+) -- 25-Mar-2004, W. Ver Hoef commented out used by joins
        --   AND         u.conte_idseq  = uc.conte_idseq (+) ';
          -- apply the appropriate parameter to the query
        IF p_pv_idseq IS NOT NULL THEN
            v_from := v_from || '
              ,vd_pvs pv ';
            v_where :=
                   v_where
                || '
              AND vd.vd_idseq = pv.vd_idseq (+)
              AND pv.pv_idseq = '
                || ''''
                || p_pv_idseq
                || '''';
        ELSIF p_cd_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND vd.cd_idseq = ' || '''' || p_cd_idseq || '''';
        ELSE   -- p_de_idseq IS NOT NULL
            v_from := v_from || '
              ,data_elements_view de ';
            v_where :=
                   v_where
                || '
              AND vd.vd_idseq = de.vd_idseq (+)
              AND de.de_idseq = '
                || ''''
                || p_de_idseq
                || '''';
        END IF;
        -- assemble the parts of the query
        v_sql := v_select || v_from || v_where || '
             ORDER BY UPPER(vd.long_name)';
        -- get the data
        OPEN p_assoc_vd_res FOR v_sql;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_return_code := 0;
            p_return_desc := 'No Data Found';
            RETURN;
        WHEN OTHERS THEN
            p_return_code := SQLCODE;
            p_return_desc := SQLERRM;
            RETURN;
    END get_associated_vd;
    PROCEDURE search_crf_vd(
        p_context             IN       VARCHAR2
       ,p_crf_name            IN       VARCHAR2
       ,p_protocol_id         IN       VARCHAR2
       ,p_asl_name            IN       VARCHAR2
       ,p_vd_id               IN       VARCHAR2   -- 03-Jul-2003, W. Ver Hoef
       ,p_vd_crf_search_res   OUT      type_vd_crf_search ) IS
        -- Date:  03-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  added parameter p_vd_id and associated comparison code to query by public
        --          id; substituted original asl_name comparison for code that handles multiple
        --          comma-separated values; added vd_id and origin to query result
        --          (per SPRF_2.0_12)
        v_sql        VARCHAR2( 4000 );
        v_where      VARCHAR2( 2000 ) := ' ';
        v_crf        VARCHAR2( 255 )  := UPPER( REPLACE( p_crf_name, '*', '%' ));
        v_asl_name   VARCHAR2( 2000 );   --03-Jul-2003, W. Ver Hoef
        v_asl_list   VARCHAR2( 2000 );
        i            NUMBER           := 1;
    BEGIN
        IF p_vd_crf_search_res%ISOPEN THEN
            CLOSE p_vd_crf_search_res;
        END IF;
        v_sql :=
            'SELECT    vd.preferred_name
           ,vd.long_name
        ,vd.preferred_definition
     ,vd.conte_idseq
     ,vd.asl_name
     ,vd.vd_idseq
     ,vd.version
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
     ,NVL(r.long_name,r.preferred_name) rep_term
     ,r.preferred_name rep_term
     ,vd.rep_idseq
     ,vd.qualifier_name
     ,c.name CONTEXT
              ,vd.cd_idseq
     ,NVL(cd.long_name,cd.preferred_name) cd_name
     ,des.LAE_NAME LANGUAGE
     ,des.DESIG_IDSEQ lae_des_idseq
     ,q.crf  crf_name
     ,p.protocol_id
     ,vd.vd_id    --03-Jul-2003, W. Ver Hoef
     ,vd.origin
 FROM       value_domains_view vd
           ,conceptual_domains_view cd
     ,contexts_view c
     ,sbrext.de_cn_language_view des
     ,quest_crf_view_ext q
     ,protocols_view_ext p
     ,REPRESENTATIONS_EXT r
   WHERE       vd.conte_idseq = c.conte_idseq
   AND         vd.cd_idseq = cd.cd_idseq
   AND         vd.vd_idseq = des.ac_idseq(+)
   AND         vd.rep_idseq = r.rep_idseq(+)
   AND         vd.vd_idseq = q.vd_idseq(+)
   AND         q.proto_idseq = p.proto_idseq(+)';
        IF ( p_context IS NOT NULL ) THEN
            v_where := v_where || ' AND c.name = ' || '''' || p_context || '''';
        END IF;
        -- 03-Jul-2003, W. Ver Hoef
        -- substituted the following section for the commented out one below
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(vd.asl_name) in (' || v_asl_list || ')';
        END IF;
        IF ( p_protocol_id IS NOT NULL ) THEN
            v_where :=
                   v_where
                || ' AND upper(nvl(protocol_id,'
                || ''''
                || '-1'
                || ''''
                || ')) = upper('
                || ''''
                || p_protocol_id
                || ''''
                || ')';
        END IF;
        IF ( v_crf IS NOT NULL ) THEN
            v_where := v_where || ' AND upper(nvl(q.crf,' || '''' || '-1' || '''' || ')) = ' || '''' || v_crf || '''';
        END IF;
        -- 03-Jul-2003, W. Ver Hoef added comparison
        IF ( p_vd_id IS NOT NULL ) THEN
            v_where := v_where || ' AND nvl(vd.vd_id,' || '''' || '-1' || '''' || ') = ' || '''' || p_vd_id || '''';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '  ORDER BY   upper(long_name )';
        OPEN p_vd_crf_search_res FOR v_sql;
    END;
    PROCEDURE search_vv( p_de_idseq IN VARCHAR2, p_vv_cur OUT type_de_vv ) IS
    -- Date:  02-Jul-2003
    -- Modified By:  W. Ver Hoef
    -- Reason:  SPRF_2.0_12 indicates that origin needs to be added
    BEGIN
        IF p_vv_cur%ISOPEN THEN
            CLOSE p_vv_cur;
        END IF;
        OPEN p_vv_cur FOR
            SELECT   VALUE
                    ,vm.long_name short_meaning
                    ,meaning_description
                    ,vp.origin   -- 02-Jul-2003, W. Ver Hoef added origin to cursor
                FROM data_elements_view d
                    ,vd_pvs_view vp
                    ,permissible_values pv
                    ,value_meanings_view vm
               WHERE d.vd_idseq = vp.vd_idseq
               AND vp.pv_idseq = pv.pv_idseq
               AND d.de_idseq = p_de_idseq
               AND pv.vm_idseq = vm.vm_idseq
            ORDER BY UPPER( VALUE );
    END;
    PROCEDURE search_cs( p_de_idseq IN VARCHAR2, p_asl_name IN VARCHAR2, p_cs_id IN VARCHAR2, p_csi_cur OUT type_de_csi ) IS
        -- Date:  01-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted procedure from straight query to dynamic sql; added
        --          parameters p_asl_name and p_cs_id to allow query by the public id;
        --          added a block of code to handle possibility of multiple
        --          comma-separated values in p_asl_name; added cs.asl_name,
        --          cs_id and cs.origin to query result  (per SPRF_2.0_12)
        -- 01-Jul-2003, W. Ver Hoef added variable definitions to support new code
        v_sql        VARCHAR2( 4000 );
        v_where      VARCHAR2( 2000 ) := ' ';
        v_asl_name   VARCHAR2( 2000 );
        v_asl_list   VARCHAR2( 2000 );
        i            NUMBER           := 1;
    BEGIN
        IF p_csi_cur%ISOPEN THEN
            CLOSE p_csi_cur;
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added code to build dynamic sql
        v_sql :=
               'SELECT cs.cs_idseq
            ,cs.preferred_name
      ,csi.csi_idseq
      ,csi.csi_name
      ,csi.csitl_name
      ,NVL(vd.long_name, vd.preferred_name) vd_name
      ,cs.CS_ID  -- 01-Jul-2003, W. Ver Hoef
      ,cs.asl_name cs_asl_name
      ,cs.origin   cs_origin
      ,c.cs_csi_idseq -- 30-jul-2003 Prerna Aggarwal
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
   AND         c.csi_idseq = csi.csi_idseq
   AND         d.de_idseq = '''
            || p_de_idseq
            || '''';
        -- handle multiple values in p_asl_name, parsing value to make a list for "in" comparison
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(cs.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added comparison
        IF ( p_cs_id IS NOT NULL ) THEN
            v_where := v_where || ' AND cs.cs_id = ' || '''' || p_cs_id || '''';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '  ORDER BY   upper(cs.preferred_name)';
        -- dbms_output.put_line(substr(v_where,1,200));
        -- dbms_output.put_line(substr(v_where,201,400));
        OPEN p_csi_cur FOR v_sql;
    /*
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
       AND         c.csi_idseq = csi.csi_idseq
       AND         d.de_idseq = p_de_idseq
       order by upper(cs.preferred_name) ;
    */
    END;
    PROCEDURE upd_cs(
        p_de_idseq      IN       VARCHAR2
       ,new_cs_idseq    IN       VARCHAR2
       ,new_csi_idseq   IN       VARCHAR2
       ,old_cs_idseq    IN       VARCHAR2 DEFAULT NULL
       ,old_csi_idseq   IN       VARCHAR2 DEFAULT NULL
       ,p_error_code    OUT      VARCHAR2 ) IS
        v_old_cscsi_idseq   CHAR( 36 ) := NULL;
        v_new_cscsi_idseq   CHAR( 36 ) := NULL;
    BEGIN
        p_error_code := NULL;
        BEGIN
            SELECT cs_csi_idseq
              INTO v_new_cscsi_idseq
              FROM cs_csi_view
             WHERE cs_idseq = new_cs_idseq AND csi_idseq = new_csi_idseq;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_error_code := 'API_UPDCS_001';
                RETURN;
        END;
        IF old_cs_idseq IS NOT NULL AND old_csi_idseq IS NOT NULL THEN
            BEGIN
                SELECT cs_csi_idseq
                  INTO v_old_cscsi_idseq
                  FROM cs_csi_view
                 WHERE cs_idseq = old_cs_idseq AND csi_idseq = old_csi_idseq;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    p_error_code := 'API_UPDCS_002';
                    RETURN;
            END;
        END IF;
        UPDATE ac_csi_view
           SET cs_csi_idseq = v_new_cscsi_idseq
         WHERE ac_idseq = p_de_idseq AND cs_csi_idseq = NVL( v_old_cscsi_idseq, cs_csi_idseq );
    END;
    PROCEDURE upd_de_context( p_de_idseq IN VARCHAR2, p_context_id IN VARCHAR2 ) IS
    BEGIN
        UPDATE data_elements_view
           SET conte_idseq = p_context_id
         WHERE de_idseq = p_de_idseq;
    END;
    PROCEDURE get_value_domain_list( p_context IN VARCHAR2, p_vd_cur OUT type_vd ) IS
    BEGIN
        IF p_vd_cur%ISOPEN THEN
            CLOSE p_vd_cur;
        END IF;
        OPEN p_vd_cur FOR
            SELECT   vd.vd_idseq
                    ,vd.preferred_name
                    ,NVL( vd.long_name, vd.preferred_name ) long_name
                    ,vd.asl_name
                FROM value_domains_view vd
                    ,contexts_view c
               WHERE vd.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    PROCEDURE get_data_element_concept_list( p_context IN VARCHAR2, p_dec_cur OUT type_dec ) IS
    BEGIN
        IF p_dec_cur%ISOPEN THEN
            CLOSE p_dec_cur;
        END IF;
        OPEN p_dec_cur FOR
            SELECT   DEC.dec_idseq
                    ,DEC.preferred_name
                    ,NVL( DEC.long_name, DEC.preferred_name ) long_name
                    ,DEC.asl_name
                FROM data_element_concepts_view DEC
                    ,contexts_view c
               WHERE DEC.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    PROCEDURE get_class_scheme_list( p_context IN VARCHAR2, p_cs_cur OUT type_cs ) IS
    BEGIN
        IF p_cs_cur%ISOPEN THEN
            CLOSE p_cs_cur;
        END IF;
        OPEN p_cs_cur FOR
            SELECT   cs.cs_idseq
                    ,NVL( cs.long_name, cs.preferred_name ) long_name
                    ,cs.asl_name
                    ,c.NAME context_name
                    ,cs.version
                    ,cs.cs_id public_id
                FROM classification_schemes_view cs
                    ,contexts_view c
               WHERE cs.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    PROCEDURE get_properties_list( p_context IN VARCHAR2 DEFAULT NULL, p_prop_cur OUT type_prop ) IS
    BEGIN
        IF p_prop_cur%ISOPEN THEN
            CLOSE p_prop_cur;
        END IF;
        OPEN p_prop_cur FOR
            SELECT   NVL( p.long_name, p.preferred_name ) long_name
                    ,p.prop_idseq
                FROM properties_view_ext p
                    ,contexts_view c
               WHERE p.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    PROCEDURE get_object_classes_list( p_context IN VARCHAR2 DEFAULT NULL, p_obj_cur OUT type_obj ) IS
    BEGIN
        IF p_obj_cur%ISOPEN THEN
            CLOSE p_obj_cur;
        END IF;
        OPEN p_obj_cur FOR
            SELECT   NVL( o.long_name, preferred_name ) long_name
                    ,o.oc_idseq
                FROM object_classes_view_ext o
                    ,contexts_view c
               WHERE o.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    PROCEDURE get_qualifiers_list( p_qual_cur OUT type_qual ) IS
    BEGIN
        IF p_qual_cur%ISOPEN THEN
            CLOSE p_qual_cur;
        END IF;
        OPEN p_qual_cur FOR
            SELECT   q.qualifier_name
                FROM qualifier_lov_view_ext q
            ORDER BY q.qualifier_name;
    END;
    --representation  09DEC2002
    PROCEDURE get_representation_list( p_rep_cur OUT type_rep ) IS
    BEGIN
        IF p_rep_cur%ISOPEN THEN
            CLOSE p_rep_cur;
        END IF;
        OPEN p_rep_cur FOR
            SELECT   r.representation_name
                FROM representation_lov_view_ext r
            ORDER BY UPPER( r.representation_name );
    END;
    PROCEDURE get_class_scheme_items_list( p_csi_cur OUT type_csi ) IS
    BEGIN
        IF p_csi_cur%ISOPEN THEN
            CLOSE p_csi_cur;
        END IF;
        OPEN p_csi_cur FOR
            SELECT   csi.csi_idseq
                    ,csi.csi_name
                FROM class_scheme_items_view csi
            ORDER BY UPPER( csi.csi_name );
    END;
    PROCEDURE get_valid_values_list( p_pv_cur OUT type_pv ) IS
    BEGIN
        IF p_pv_cur%ISOPEN THEN
            CLOSE p_pv_cur;
        END IF;
        OPEN p_pv_cur FOR
            SELECT   pv.pv_idseq
                    ,pv.VALUE
                    ,vm.long_name short_meaning
                FROM permissible_values_view pv,
                     value_meanings_view vm
                WHERE vm.vm_idseq=pv.vm_idseq
            ORDER BY UPPER( VALUE );
    END;
    PROCEDURE get_abbreviations_list( p_sub_cur OUT type_sub ) IS
    BEGIN
        IF p_sub_cur%ISOPEN THEN
            CLOSE p_sub_cur;
        END IF;
        OPEN p_sub_cur FOR
            SELECT   content
                    ,substitution
                FROM substitutions_view_ext
               WHERE TYPE = 'Abbreviation'
            ORDER BY UPPER( content );
    END;
    FUNCTION get_de_dec_vd_count(
        p_contex_name   IN   VARCHAR2
       ,p_vd_idseq      IN   VARCHAR2
       ,p_dec_idseq     IN   VARCHAR2
       ,p_version       IN   NUMBER )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_elements_view
         WHERE vd_idseq = p_vd_idseq
           AND dec_idseq = p_dec_idseq
           AND VERSION = p_version
           AND conte_idseq = ( SELECT conte_idseq
                                FROM contexts_view
                               WHERE NAME = p_contex_name );
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    PROCEDURE search_pv( p_vd_idseq IN VARCHAR2, p_pv_search_res OUT type_pv_search ) IS
    -- Date:  01-Jul-2003
    -- Modified By:  W. Ver Hoef
    -- Reason:  added origin to query (per SPRF_2.0_12)
    --
    -- Date: 01-Apr-2004
    -- Modified By:  W. Ver Hoef
    -- Reason:  added pv_meaning_description per SPRF_2.1_09a
    --
    -- Date: 08-Apr-2004
    -- Modified By:  W. Ver Hoef
    -- Reason:  replaced pv_meaning_description with vm_description per mod to SPRF_2.1_09a
    --
    BEGIN
        IF p_pv_search_res%ISOPEN THEN
            CLOSE p_pv_search_res;
        END IF;

        OPEN p_pv_search_res FOR
            SELECT   pv.pv_idseq
                    ,pv.VALUE
                    ,vm.long_name short_meaning
                    ,vp.vp_idseq
                    ,vp.origin
                    ,vm.description vm_description   -- 08-Apr-2004, W. Ver Hoef added to replace pv desc
                    ,vp.begin_date
                    ,vp.end_date
                    ,vp.con_idseq
                     ,vm.VM_IDSEQ
                    ,vm.LONG_NAME
                    ,vm.PREFERRED_DEFINITION
                    ,vm.VERSION
                    ,vm.condr_idseq
                    ,vm.vm_id
                     ,vm.conte_idseq
                     ,vm.asl_name
                     ,vm.change_note
                     ,vm.comments
                     ,vm.latest_version_ind

                FROM value_domains_view vd
                    ,vd_pvs vp
                    ,permissible_values_view pv
                    ,value_meanings_view vm   -- 08-Apr-2004, W. Ver Hoef added
            WHERE    vd.vd_idseq = vp.vd_idseq
                 AND vp.pv_idseq = pv.pv_idseq
                 AND pv.vm_idseq = vm.vm_idseq   -- 08-Apr-2004, W. Ver Hoef added
                 AND vd.vd_idseq = NVL( p_vd_idseq, vd.vd_idseq )
            ORDER BY UPPER( pv.VALUE );
    END;
    PROCEDURE search_csi(
        p_search_string   IN       class_scheme_items_view.csi_name%TYPE
       --,p_cs_long_name      in varchar2 default null changed on 8/4/03 on request by Scenpro Prerna Aggarwal
    ,   p_cs_idseq        IN       VARCHAR2
       ,p_conte_name      IN       VARCHAR2
       ,p_csi_res         OUT      type_csi_search ) IS
        -- Date:  30-Jul-2003
        -- Created By:  Prerna Aggarwal
        v_search_string   class_scheme_items_view.csi_name%TYPE  := ' ';
        v_where           VARCHAR2( 2000 );
        v_sql             VARCHAR2( 4000 );
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
        i                 NUMBER           := 1;
    BEGIN
        IF p_csi_res%ISOPEN THEN
            CLOSE p_csi_res;
        END IF;
        v_sql :=
            'SELECT cs.cs_idseq
            ,cs.preferred_name
      ,cs.long_name
      ,cs.version
      ,cs.cs_id
      ,cx.name CONTEXT
      ,csi.csi_idseq
      ,csi.csi_name
      ,csi.csitl_name
      ,csi.description
      ,c.cs_csi_idseq -- Added on 8/4/2003 per Scenpro request Prerna Aggarwal
  FROM      cs_csi_view c
     ,classification_schemes_view cs
     ,class_scheme_items_view csi
     ,contexts cx
   WHERE      c.cs_idseq = cs.cs_idseq
   AND         c.csi_idseq = csi.csi_idseq
   AND        cs.conte_idseq = cx.conte_idseq ';
        /* if p_cs_long_name is not null then
           v_where := v_where||' AND  upper(cs.long_name) = '||''''||upper(p_cs_long_name)||'''';
         end if;*/ --p_cs_long_name      in varchar2 default null changed on 8/4/03 on request by Scenpro Prerna Aggarwal
        IF p_cs_idseq IS NOT NULL THEN
            v_where := v_where || ' AND  cs.cs_idseq = ' || '''' || p_cs_idseq || '''';
        END IF;
        /*IF p_conte_name IS NOT NULL THEN
          v_where := v_where||' AND  upper(cx.name) = '||''''||UPPER(p_conte_name) ||'''';
        END IF;*/
        IF p_conte_name IS NOT NULL THEN
            v_context := UPPER( p_conte_name );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(cx.name) in (' || v_context_list || ')';
        END IF;
        IF p_search_string IS NOT NULL THEN
            v_search_string := UPPER( REPLACE( p_search_string, '*', '%' ));
            v_where := v_where || ' AND  upper(csi.csi_name) like  ' || '''' || v_search_string || '''';
        END IF;
        v_sql := v_sql || v_where || ' order by upper(csi.csi_name) ';
        OPEN p_csi_res FOR v_sql;
    END;
    PROCEDURE search_docscr( p_conte_idseq IN VARCHAR2 DEFAULT NULL, p_docscr_search_res OUT type_docscr_search ) IS
    BEGIN
        IF p_docscr_search_res%ISOPEN THEN
            CLOSE p_docscr_search_res;
        END IF;
        OPEN p_docscr_search_res FOR
            SELECT   desv.ac_idseq
                    ,desv.doc_text
                FROM de_source_name_view desv
                    ,administered_components ac
               WHERE desv.ac_idseq = ac.ac_idseq AND ac.conte_idseq = NVL( p_conte_idseq, ac.conte_idseq )
            ORDER BY UPPER( doc_text );
    END;
    PROCEDURE get_conceptual_domain_list( p_context IN VARCHAR2 DEFAULT NULL, p_cd_cur OUT type_cd ) IS
    BEGIN
        IF p_cd_cur%ISOPEN THEN
            CLOSE p_cd_cur;
        END IF;
        OPEN p_cd_cur FOR
            SELECT   cde.cd_idseq
                    ,NVL( cde.long_name, cde.preferred_name ) long_name
                    ,cde.asl_name
                    ,c.NAME context_name
                FROM conceptual_domains_view cde
                    ,contexts_view c
               WHERE cde.conte_idseq = c.conte_idseq AND UPPER( c.NAME ) = UPPER( NVL( p_context, c.NAME ))
            ORDER BY UPPER( long_name );
    END;
    -- 20-Feb-2004. W. Ver Hoef added functions and cs, csi names to get_cscsi_list to cursor per SPRF_2.1_04
    FUNCTION get_cs_name( p_cs_idseq IN CHAR )   -- 20-Feb-2004, W. Ver Hoef
        RETURN VARCHAR2 IS
        -- 16-Apr-2004, W. Ver Hoef added context name on the cs name value returned per SPRF_2.1_31
        v_cs_name   VARCHAR2( 255 );
    BEGIN
        SELECT NVL( cs.long_name, cs.preferred_name ) || ' - ' || c.NAME ||' - '||cs_id||'v' || cs.version
          INTO v_cs_name
          FROM classification_schemes_view cs
              ,contexts_view c
         WHERE cs.conte_idseq = c.conte_idseq AND cs.cs_idseq = p_cs_idseq;
        RETURN v_cs_name;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_csi_name( p_csi_idseq IN CHAR )   -- 20-Feb-2004, W. Ver Hoef
        RETURN VARCHAR2 IS
        v_csi_name   VARCHAR2( 255 );
    BEGIN
        SELECT csi.long_name || '  (' || csi.csi_id || ' v ' || csi.version || ')'
          INTO v_csi_name
          FROM cs_items_view csi
         WHERE csi.csi_idseq = p_csi_idseq;
        RETURN v_csi_name;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    PROCEDURE get_cscsi_list( p_cscsi_cur OUT type_cscsi ) IS
    -- 11/14/2005; S. Alred: added alias "lvl" for LEVEL pseudo-column
    BEGIN
        IF p_cscsi_cur%ISOPEN THEN
            CLOSE p_cscsi_cur;
        END IF;
        OPEN p_cscsi_cur FOR
               -- 12-Feb-2004, W. Ver Hoef added 4 columns per SPRF_2.1_04:  cs_csi_idseq,
            --                            p_cs_csi_idseq, display_order, and label
            SELECT     cs_csi_idseq
                      ,cs_idseq
                      ,csi_idseq
                      ,p_cs_csi_idseq
                      ,display_order
                      ,label
                      ,SBREXT_CDE_CURATOR_PKG.get_cs_name( cs_idseq ) cs_name   -- 20-Feb-2004, W. Ver Hoef
                      ,SBREXT_CDE_CURATOR_PKG.get_csi_name( csi_idseq ) csi_name   -- 20-Feb-2004, W. Ver Hoef
                      ,LEVEL lvl
                  FROM cs_csi_view
            CONNECT BY PRIOR cs_csi_idseq = p_cs_csi_idseq   -- 20-Feb-2004, W. Ver Hoef
            START WITH p_cs_csi_idseq IS NULL   -- 04-Mar-2004, W. Ver Hoef  added start with
                                             ;
    END;
    PROCEDURE get_languages_list( p_languages_cur OUT type_languages ) IS
    BEGIN
        IF p_languages_cur%ISOPEN THEN
            CLOSE p_languages_cur;
        END IF;
        OPEN p_languages_cur FOR
            SELECT   NAME
                FROM languages_lov_view
            ORDER BY UPPER( NAME );
    END;
    PROCEDURE get_datatypes_list( p_datatypes_cur OUT type_datatypes ) IS
    BEGIN
        IF p_datatypes_cur%ISOPEN THEN
            CLOSE p_datatypes_cur;
        END IF;
        OPEN p_datatypes_cur FOR
            SELECT   dtl_name
                    ,description
                    ,comments
                FROM datatypes_lov_view
            ORDER BY UPPER( dtl_name );
    END;
    PROCEDURE get_unit_of_measures_list( p_uoml_cur OUT type_uoml ) IS
    BEGIN
        IF p_uoml_cur%ISOPEN THEN
            CLOSE p_uoml_cur;
        END IF;
        OPEN p_uoml_cur FOR
            SELECT   uoml_name
                FROM unit_of_measures_lov_view
            ORDER BY UPPER( uoml_name );
    END;
    PROCEDURE get_formats_list( p_formats_cur OUT type_formats ) IS
    BEGIN
        IF p_formats_cur%ISOPEN THEN
            CLOSE p_formats_cur;
        END IF;
        OPEN p_formats_cur FOR
            SELECT   forml_name
                FROM formats_lov_view
            ORDER BY UPPER( forml_name );
    END;
    PROCEDURE get_cscsi( p_cs_idseq IN VARCHAR2, p_csi_idseq IN VARCHAR2, p_cs_cscsi_cur OUT type_cs_cscsi ) IS
    BEGIN
        IF p_cs_cscsi_cur%ISOPEN THEN
            CLOSE p_cs_cscsi_cur;
        END IF;
        OPEN p_cs_cscsi_cur FOR
            SELECT cs_csi_idseq
              FROM cs_csi_view
             WHERE cs_idseq = p_cs_idseq AND csi_idseq = p_csi_idseq;
    END;
    PROCEDURE get_valuemeaning_list( p_cd_idseq IN VARCHAR2, p_valuemeaning_cur OUT type_valuemeaning ) IS
    -- Date:  08-Jul-2003
    -- Modified By:  W. Ver Hoef
    -- Reason:  SPRF_2.0_14 requests addition of conceptual domain input parameter.
    --          Changes implemented include new parameter p_cd_idseq, and addition of
    --          cd_vms_view to the query via a join based on short_meaning to be
    --          able to optionally filter on cd_idseq.
    BEGIN
        IF p_valuemeaning_cur%ISOPEN THEN
            CLOSE p_valuemeaning_cur;
        END IF;
        OPEN p_valuemeaning_cur FOR
            SELECT DISTINCT v.long_name short_meaning
                           ,v.description
                           ,v.comments
                       FROM value_meanings_view v
                           ,cd_vms_view c
                      WHERE v.vm_idseq = c.vm_idseq(+)
                            AND NVL( c.cd_idseq, '1' ) = NVL( p_cd_idseq, NVL( c.cd_idseq, '1' ))
                   ORDER BY UPPER( v.long_name );
    END;
    PROCEDURE search_oc(
        p_search_string   IN       VARCHAR2
       ,p_asl_name        IN       VARCHAR2
       ,p_context         IN       VARCHAR2 DEFAULT NULL
       ,p_oc_id           IN       VARCHAR2   -- 01-Jul-2003, W. Ver Hoef
       ,p_oc_search_res   OUT      type_oc_search
       ,p_con_name        IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq       IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
                                                        ) IS
        -- Date:  01-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted procedure from straight query to dynamic sql; added
        --          parameter p_oc_id to allow query by the public id; substituted
        --          a block of code for the simple where clause addition for p_asl_name
        --          to handle possibility of multiple comma-separated values; added
        --          oc_id to query result (origin was already there)  (per SPRF_2.0_12)
        -- 01-Jul-2003, W. Ver Hoef replaced variable definition for v_search_string and
        --                            added other variables to support new code
        -- v_search_string varchar2(255) := replace(p_search_string,'*','%');
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 4000 );
        v_where           VARCHAR2( 2000 ) := ' ';
        v_from            VARCHAR2( 2000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
    BEGIN
        IF p_oc_search_res%ISOPEN THEN
            CLOSE p_oc_search_res;
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added code to build dynamic sql
        --11/18/04 PRerna Aggarwal Added concept information SPRF_3.0_6a
        v_sql :=
            'SELECT
 oc.preferred_name
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
 ,c.name CONTEXT
 ,des.LAE_NAME LANGUAGE
 ,des.DESIG_IDSEQ  lae_des_idseq
 ,oc.OC_ID
 ,oc.condr_idseq
 ,asl.display_order
 ,asl.asl_name
 ,Sbrext_Common_Routines.get_oc_dec_count(oc.oc_idseq) dec_count';   --SPRF_3.0.1_7
        v_from :=
             '
 FROM
 object_classes_view_ext    oc
 ,contexts_view              c
 ,sbr.ac_status_lov_view asl
 ,sbrext.de_cn_language_view des';   --,concepts_ext con
        v_where :=
               '
 oc.conte_idseq = c.conte_idseq
 AND asl.asl_name = oc.asl_name
 AND oc.oc_idseq = des.ac_idseq(+)
 AND (UPPER(oc.preferred_name) LIKE UPPER(NVL('''
            || v_search_string
            || ''',oc.preferred_name))
         OR UPPER(NVL(oc.long_name,'
            || ''''
            || ' '
            || ''''
            || ' )) LIKE '
            || ''''
            || v_search_string
            || ''''
            || '
         OR UPPER(oc.preferred_definition) LIKE UPPER(NVL('''
            || v_search_string
            || ''',oc.preferred_definition)))';
        IF p_context IS NOT NULL THEN
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        -- 01-Jul-2003, W. Ver Hoef
        -- handle multiple values in p_asl_name, parsing value to make a list for "in" comparison
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(oc.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added comparison
        IF ( p_oc_id IS NOT NULL ) THEN
            v_where := v_where || ' AND oc.oc_id = ' || '''' || p_oc_id || '''';
        END IF;
        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 oc.oc_idseq IN (
 SELECT ocv.oc_idseq
 FROM sbrext.object_classes_view_ext       ocv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = OCV.CONDR_IDSEQ
 ) AND '
                || v_where;
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '  ORDER BY  asl.display_order, upper(oc.long_name)';
        -- 01-Jul-2003, W. Ver Hoef added for debugging purposes
        /*
        dbms_output.put_line(substr(v_sql,1,200));
        dbms_output.put_line(substr(v_sql,201,400));
        dbms_output.put_line(substr(v_sql,401,600));
        dbms_output.put_line(substr(v_sql,601,800));
        dbms_output.put_line(substr(v_sql,801,1000));
        dbms_output.put_line(substr(v_sql,1001,1200));
        dbms_output.put_line(substr(v_sql,1201,1400));
        dbms_output.put_line(substr(v_sql,1401,1600));
        dbms_output.put_line(substr(v_sql,1601,1800));
        dbms_output.put_line(substr(v_sql,1801,2000));
        dbms_output.put_line(substr(v_where,1,200));
        dbms_output.put_line(substr(v_where,201,400));
        */
        OPEN p_oc_search_res FOR v_sql;
    /*
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
          ,sbrext.de_cn_language_view des
       WHERE       oc.conte_idseq = c.conte_idseq
       and         oc.oc_idseq = des.ac_idseq(+)
       and         (upper(oc.preferred_name) like upper(nvl(v_search_string,oc.preferred_name))
                    or upper(nvl(oc.long_name,'1')) like upper(nvl(v_search_string,nvl(oc.long_name,'1')))
                    or upper(oc.preferred_definition) like upper(nvl(v_search_string,oc.preferred_definition)))
       and         upper(c.name) = upper(nvl(p_context,c.name))
       and         oc.asl_name= nvl(p_asl_name,oc.asl_name)
       order by    oc.long_name;
    */
    END;
    PROCEDURE search_prop(
        p_search_string     IN       VARCHAR2
       ,p_asl_name          IN       VARCHAR2
       ,p_context           IN       VARCHAR2 DEFAULT NULL
       ,p_prop_id           IN       VARCHAR2   -- 01-JUL-2003, W. Ver Hoef
       ,p_prop_search_res   OUT      type_prop_search
       ,p_con_name          IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq         IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
                                                          ) IS
        -- Date:  01-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted procedure from straight query to dynamic sql; added
        --          parameter p_prop_id to allow query by the public id; substituted
        --          a block of code for the simple where clause addition for p_asl_name
        --          to handle possibility of multiple comma-separated values; added
        --          prop_id to query result (origin was already there)  (per SPRF_2.0_12)
        -- 01-Jul-2003, W. Ver Hoef replaced variable definition for v_search_string and
        --                            added other variables to support new code
        -- v_search_string varchar2(255) := replace(p_search_string,'*','%');
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 4000 );
        v_where           VARCHAR2( 2000 ) := ' ';
        v_from            VARCHAR2( 2000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
    BEGIN
        IF p_prop_search_res%ISOPEN THEN
            CLOSE p_prop_search_res;
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added code to build dynamic sql
        --11/18/04 PRerna Aggarwal Added concept information SPRF_3.0_6a
        v_sql :=
            'SELECT
 prop.preferred_name
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
 ,c.name CONTEXT
 ,des.LAE_NAME LANGUAGE
 ,des.DESIG_IDSEQ  lae_des_idseq
 ,prop.prop_id
 ,prop.condr_idseq
 ,asl.display_order
 ,asl.asl_name
  ,Sbrext_Common_Routines.get_prop_dec_count(prop.prop_idseq) dec_count';   --SPRF_3.0.1_7
        v_from :=
            '
 FROM
   properties_view_ext        prop
  ,contexts_view              c
  ,sbr.ac_status_lov_view asl
   ,sbrext.de_cn_language_view des';   -- ,concepts_ext con
        v_where :=
               '
 prop.conte_idseq = c.conte_idseq
 AND asl.asl_name = prop.asl_name
 AND prop.prop_idseq = des.ac_idseq(+)
 AND (UPPER(prop.preferred_name) LIKE UPPER(NVL('''
            || v_search_string
            || ''',prop.preferred_name))
        OR UPPER(NVL(prop.long_name,'
            || ''''
            || ' '
            || ''''
            || ' )) LIKE '
            || ''''
            || v_search_string
            || ''''
            || '
        OR UPPER(prop.preferred_definition) LIKE UPPER(NVL('''
            || v_search_string
            || ''',prop.preferred_definition)))';
        IF p_context IS NOT NULL THEN
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        -- 01-Jul-2003, W. Ver Hoef
        -- handle multiple values in p_asl_name, parsing value to make a list for "in" comparison
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(prop.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added comparison
        IF ( p_prop_id IS NOT NULL ) THEN
            v_where := v_where || ' AND prop.prop_id = ' || '''' || p_prop_id || '''';
        END IF;
        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 prop.prop_idseq IN (
 SELECT propv.prop_idseq
 FROM sbrext.properties_view_ext           propv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = propv.CONDR_IDSEQ
 ) AND '
                || v_where;
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '  ORDER BY asl.display_order, upper(prop.long_name)';
        --dbms_output.put_line(SUBSTR(v_where,1,200));
        --dbms_output.put_line(SUBSTR(v_where,201,400));
        OPEN p_prop_search_res FOR v_sql;
    /*
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
          ,sbrext.de_cn_language_view des
       WHERE       prop.conte_idseq = c.conte_idseq
       and         prop.prop_idseq = des.ac_idseq(+)
       and         (upper(prop.preferred_name) like upper(nvl(v_search_string,prop.preferred_name))
                    or upper(nvl(prop.long_name,'1')) like upper(nvl(v_search_string,nvl(prop.long_name,'1')))
                    or upper(prop.preferred_definition) like upper(nvl(v_search_string,prop.preferred_definition)))
       and          upper(c.name) = upper(nvl(p_context,c.name))
       and         upper(prop.asl_name)= upper(nvl(p_asl_name,prop.asl_name))
       order by    prop.long_name;
    */
    END;
    PROCEDURE search_qual( p_search_string IN VARCHAR2, p_qual_search_res OUT type_qual_search ) IS
        v_search_string   VARCHAR2( 255 ) := REPLACE( p_search_string, '*', '%' );
    BEGIN
        IF p_qual_search_res%ISOPEN THEN
            CLOSE p_qual_search_res;
        END IF;
        --11/18/04 Prerna Aggarwal Added concept information SPRF_3.0_6a
        OPEN p_qual_search_res FOR
            SELECT   qualifier_name
                    ,description
                    ,comments
                    ,con.preferred_name vm_concept_code
                    ,con.long_name vm_concept_name
                    ,con.evs_source vm_evs_cui_source
                    ,con.definition_source evs_definition_source
                    ,con.origin
                FROM qualifier_lov_view_ext qual
                    ,CONCEPTS_EXT con
               WHERE UPPER( qualifier_name ) LIKE UPPER( NVL( v_search_string, qualifier_name ))
                     AND qual.con_idseq = con.con_idseq(+)
            ORDER BY UPPER( qualifier_name );
    END;
    PROCEDURE search_rep(
        p_search_string    IN       VARCHAR2
       ,p_asl_name         IN       VARCHAR2
       ,p_context          IN       VARCHAR2 DEFAULT NULL
       ,p_rep_id           IN       VARCHAR2   -- 01-JUL-2003, W. Ver Hoef
       ,p_rep_search_res   OUT      type_rep_search
       ,p_con_name         IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq        IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                         ) IS
        -- Date:  01-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted procedure from straight query to dynamic sql; added
        --          parameter p_rep_id to allow query by the public id; substituted
        --          a block of code for the simple where clause addition for p_asl_name
        --          to handle possibility of multiple comma-separated values; added
        --          rep_id to query result (origin was already there)  (per SPRF_2.0_12)
        -- 01-Jul-2003, W. Ver Hoef replaced variable definition for v_search_string and
        --                            added other variables to support new code
        -- v_search_string varchar2(255) := replace(p_search_string,'*','%');
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 4000 );
        v_where           VARCHAR2( 2000 ) := ' ';
        v_from            VARCHAR2( 2000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
    BEGIN
        IF p_rep_search_res%ISOPEN THEN
            CLOSE p_rep_search_res;
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added code to build dynamic sql
        --11/18/04 PRerna Aggarwal Added concept information SPRF_3.0_6a
        v_sql :=
            'SELECT
 rep.preferred_name
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
 ,c.name CONTEXT
 ,des.LAE_NAME LANGUAGE
 ,des.DESIG_IDSEQ  lae_des_idseq
 ,rep.rep_id
 ,rep.condr_idseq';
        v_from :=
            '
 FROM
  representations_view_ext   rep
 ,contexts_view              c
 ,sbrext.de_cn_language_view des';
        v_where :=
               '
 rep.conte_idseq = c.conte_idseq
 AND rep.rep_idseq = des.ac_idseq(+)
 AND (UPPER(rep.preferred_name) LIKE UPPER(NVL('''
            || v_search_string
            || ''',rep.preferred_name))
        OR UPPER(NVL(rep.long_name,'
            || ''''
            || ' '
            || ''''
            || ' )) LIKE '
            || ''''
            || v_search_string
            || ''''
            || '
        OR UPPER(rep.preferred_definition) LIKE UPPER(NVL('''
            || v_search_string
            || ''',rep.preferred_definition)))';
        IF p_context IS NOT NULL THEN
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        -- handle multiple values in p_asl_name, parsing value to make a list for "in" comparison
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(rep.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- 01-Jul-2003, W. Ver Hoef added comparison
        IF ( p_rep_id IS NOT NULL ) THEN
            v_where := v_where || ' AND rep.rep_id = ' || '''' || p_rep_id || '''';
        END IF;
        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 rep.rep_idseq IN (
 SELECT rv.rep_idseq
 FROM sbrext.representations_view_ext      rv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = rv.CONDR_IDSEQ
 ) AND '
                || v_where;
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '  ORDER BY   upper(rep.long_name)';
        /*
          dbms_output.put_line(SUBSTR(v_sql,1,200));
          dbms_output.put_line(SUBSTR(v_sql,201,200));
          dbms_output.put_line(SUBSTR(v_sql,401,200));
          dbms_output.put_line(SUBSTR(v_sql,601,200));
          dbms_output.put_line(SUBSTR(v_sql,801,200));
          dbms_output.put_line(SUBSTR(v_sql,1001,200));
          dbms_output.put_line(SUBSTR(v_sql,1201,200));
        */
        OPEN p_rep_search_res FOR v_sql;
    /*
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
          ,sbrext.de_cn_language_view des
       WHERE       rep.conte_idseq = c.conte_idseq
       and         rep.rep_idseq = des.ac_idseq(+)
       and         (upper(rep.preferred_name) like upper(nvl(v_search_string,rep.preferred_name))
                    or upper(nvl(rep.long_name,'1')) like upper(nvl(v_search_string,nvl(rep.long_name,'1')))
                    or upper(rep.preferred_definition) like upper(nvl(v_search_string,rep.preferred_definition)))
       and         upper(c.name) = upper(nvl(p_context,c.name))
       and         upper(rep.asl_name)= upper(nvl(p_asl_name,rep.asl_name))
       order by    upper(rep.long_name);
    */
    END;
    FUNCTION get_de_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_elements_view de
              ,contexts_view cv
         WHERE de.conte_idseq = cv.conte_idseq
           AND de.long_name = p_long_name
           AND de.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_de_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_elements_view de
              ,contexts_view cv
         WHERE de.conte_idseq = cv.conte_idseq
           AND de.preferred_name = p_preferred_name
           AND de.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_de_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_elements_view de
              ,contexts_view cv
         WHERE de.conte_idseq = cv.conte_idseq
           AND de.preferred_definition = p_preferred_definition
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_vd_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM value_domains_view vd
              ,contexts_view cv
         WHERE vd.conte_idseq = cv.conte_idseq
           AND vd.long_name = p_long_name
           AND vd.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_vd_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM value_domains_view vd
              ,contexts_view cv
         WHERE vd.conte_idseq = cv.conte_idseq
           AND vd.preferred_name = p_preferred_name
           AND vd.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_vd_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM value_domains_view vd
              ,contexts_view cv
         WHERE vd.conte_idseq = cv.conte_idseq
           AND vd.preferred_definition = p_preferred_definition
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_dec_long_name_count( p_long_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_element_concepts_view DEC
              ,contexts_view cv
         WHERE DEC.conte_idseq = cv.conte_idseq
           AND DEC.long_name = p_long_name
           AND DEC.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_dec_name_count( p_preferred_name IN VARCHAR2, p_version IN NUMBER, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_element_concepts_view DEC
              ,contexts_view cv
         WHERE DEC.conte_idseq = cv.conte_idseq
           AND DEC.preferred_name = p_preferred_name
           AND DEC.VERSION = p_version
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    FUNCTION get_dec_definition_count( p_preferred_definition IN VARCHAR2, p_context IN VARCHAR2 )
        RETURN NUMBER IS
        v_cnt   NUMBER := 0;
    BEGIN
        SELECT COUNT( * )
          INTO v_cnt
          FROM data_element_concepts_view DEC
              ,contexts_view cv
         WHERE DEC.conte_idseq = cv.conte_idseq
           AND DEC.preferred_definition = p_preferred_definition
           AND cv.NAME = p_context;
        RETURN v_cnt;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    --create de_version
    PROCEDURE de_version( p_ac_idseq IN admin_components_view.ac_idseq%TYPE, p_return_code OUT VARCHAR2 ) IS
    BEGIN
        p_return_code := NULL;
        meta_config_mgmt.de_version( p_ac_idseq, p_return_code );
        IF p_return_code IS NOT NULL THEN
            RETURN;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_return_code := SQLCODE || '--' || SQLERRM;
            RETURN;
    END;
    --create vd_version
    PROCEDURE vd_version( p_ac_idseq IN admin_components_view.ac_idseq%TYPE, p_return_code OUT VARCHAR2 ) IS
    BEGIN
        p_return_code := NULL;
        meta_config_mgmt.vd_version( p_ac_idseq, p_return_code );
        IF p_return_code IS NOT NULL THEN
            RETURN;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_return_code := SQLCODE || '--' || SQLERRM;
            RETURN;
    END;
    PROCEDURE search_pvvm(
        p_search_string     IN       VARCHAR2
       ,p_cd_idseq          IN       VARCHAR2
       ,p_pvvm_search_res   OUT      type_pvname_search
       ,p_con_name          IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq         IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
                                                          ) IS
        v_search_string   VARCHAR2( 255 )  := REPLACE( p_search_string, '*', '%' );
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 4000 );
        v_from            VARCHAR2( 2000 ) := ' ';
        v_where           VARCHAR2( 2000 ) := ' ';
        v_order           VARCHAR2( 2000 );
    BEGIN
        IF p_pvvm_search_res%ISOPEN THEN
            CLOSE p_pvvm_search_res;
        END IF;

        /*
        ** TT#1667: return one CD name for the associated VM
        **          S. Alred; 12/13/2005 [SPRF_3.1_7a]
        */
        v_sql :=
            'SELECT
             p.pv_idseq
             ,p.value
             ,vm.LONG_NAME short_meaning
             ,p.begin_date
             ,p.end_date
             ,p.meaning_description
             ,vm.description         vm_description
             ,vm.condr_idseq
             ,sbrext_cde_curator_pkg.get_one_cd_name(vm.long_name) cd_name
              ,vm.VM_IDSEQ
             ,vm.LONG_NAME
             ,vm.PREFERRED_DEFINITION
             ,vm.VERSION
             ,vm.vm_id
             ,vm.conte_idseq
             ,vm.asl_name
             ,vm.change_note
             ,vm.comments
             ,vm.latest_version_ind
              ';
        v_from := '
   FROM    permissible_values        p
   ,       value_meanings_view  vm';   -- 16-Feb-2004, W. Ver Hoef added
   v_where := 'p.vm_idseq = vm.vm_idseq';   -- 16-Feb-2004, W. Ver Hoef added

        --add keyword filter  (Sumana)
        IF p_search_string IS NOT NULL THEN
            v_where :=
                   v_where
                || '
        AND (UPPER(vm.long_name) LIKE UPPER(NVL('''
                || v_search_string
                || ''',vm.long_name))
          OR UPPER(value)           LIKE UPPER(NVL('''
                || v_search_string
                || ''',value)))';
        END IF;

        --add cd filter (sumana)
        IF p_cd_idseq IS NOT NULL THEN
            v_from := v_from || '
          ,cd_vms                   d
          ,conceptual_domains       c ';
            v_where :=
                   v_where
                || '
       AND   d.cd_idseq             = c.cd_idseq (+)
       AND      d.vm_idseq         = vm.vm_idseq (+)
        AND   NVL(c.cd_idseq,''1'')    = NVL('''
                || p_cd_idseq
                || ''',NVL(c.cd_idseq,''1''))';   -- criteria added on 8/8/03 Prerna Aggarwal
        END IF;

        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;

            v_where :=
                   ' p.pv_idseq IN (
                     SELECT pv.pv_idseq
                     FROM sbr.permissible_values_view          pv
                         ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
                         ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
                         ,sbrext.CONCEPTS_VIEW_EXT             CON
                         ,value_meanings_view              vmv
                     WHERE '
                                    || v_con_name
                                    || '
                     AND CON.CON_IDSEQ = CC.CON_IDSEQ
                     AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
                     AND CDR.CONDR_IDSEQ = vmv.CONDR_IDSEQ
                     AND vmv.vm_idseq = pv.vm_idseq
                     ) AND '
                || v_where;
        END IF;

        v_sql := v_sql || v_from || ' WHERE ' || v_where || ' ORDER BY UPPER(value)';   -- criteria added on 8/8/03 Prerna Aggarwal

        OPEN p_pvvm_search_res FOR v_sql;
    END;   --search pvvm
    PROCEDURE search_vm( p_search_string IN VARCHAR2
                           ,p_cd_idseq IN VARCHAR2
                           ,p_description IN VARCHAR2
                           ,p_condr_idseq IN VARCHAR2
                         ,p_vm_search_res OUT type_vm_search
                            ,p_con_name          IN       VARCHAR2 DEFAULT NULL
                            ,p_con_idseq         IN       VARCHAR2 DEFAULT NULL
                                         ,p_id         IN       VARCHAR2 DEFAULT NULL
                    ,p_version_ind IN     VARCHAR2 DEFAULT NULL
                                        ,p_version IN NUMBER DEFAULT NULL)
    IS
        v_search_string   VARCHAR2( 255 ) := REPLACE( p_search_string, '*', '%' );
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 4000 );
        v_from            VARCHAR2( 2000 );
        v_where           VARCHAR2( 2000 );
        v_order           VARCHAR2( 2000 );
    BEGIN
        IF p_vm_search_res%ISOPEN THEN
            CLOSE p_vm_search_res;
        END IF;

        v_sql :=
            'SELECT
              vm.VM_IDSEQ
             ,vm.LONG_NAME
             ,vm.PREFERRED_DEFINITION
             ,sbrext_cde_curator_pkg.get_one_cd_name(vm.long_name) cd_name
             ,vm.preferred_definition         vm_description
             ,vm.begin_date
             ,vm.end_date
             ,vm.condr_idseq
             ,vm.long_name
             ,vm.VERSION
             ,vm.vm_id
             ,vm.conte_idseq
             ,vm.asl_name
             ,vm.change_note
             ,vm.comments
             ,vm.latest_version_ind';
        v_from := ' FROM value_meanings_view vm INNER JOIN sbr.ac_status_lov_view asl ON asl.asl_name = vm.asl_name ';

        --add keyword filter  (Sumana)
        IF p_search_string IS NOT NULL THEN
            v_where :=
                   v_where
                || '
                UPPER(vm.long_name) LIKE UPPER(NVL('''
                || v_search_string
                || ''',vm.long_name))';
        END IF;
        --add id filter (Anu)

        IF p_id IS NOT NULL THEN
                 IF 'vm.vm_id' is NOT NULL THEN
                      IF v_where IS NOT NULL THEN

                          v_where := v_where || ' AND ';

                      END IF;
                         v_where :=   v_where ||  'vm.vm_id = ''' || p_id || ''' ';
                  END IF;
      END IF;
       -- filter by description

      IF p_description IS NOT NULL THEN
            IF v_where IS NOT NULL THEN
                     v_where := v_where || ' AND ';
            END IF;
            v_where :=
                   v_where
                || '
                UPPER(vm.preferred_definition) LIKE UPPER(NVL('''
                || p_description
                || ''',vm.description))';
       END IF;
        --filter by condr idseq
       IF p_condr_idseq IS NOT NULL THEN
            IF v_where IS NOT NULL THEN
                     v_where := v_where || ' AND ';
            END IF;
            v_where :=
                   v_where ||
                'NVL( vm.CONDR_IDSEQ, ''1'' ) = NVL('''
                || p_condr_idseq
                || ''', NVL( vm.CONDR_IDSEQ, ''1''))';
        END IF;

        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF v_where IS NOT NULL THEN
                     v_where := v_where || ' AND ';
            END IF;
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;

            v_where := v_where ||
                   'vm.condr_idseq IN (
                     SELECT vmv.condr_idseq
                     FROM sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
                         ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
                         ,sbrext.CONCEPTS_VIEW_EXT             CON
                         ,value_meanings_view              vmv
                     WHERE '
                                    || v_con_name
                                    || '
                     AND CON.CON_IDSEQ = CC.CON_IDSEQ
                     AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
                     AND CDR.CONDR_IDSEQ = vmv.CONDR_IDSEQ
                      )';
        END IF;

        --add cd filter (sumana)
        IF p_cd_idseq IS NOT NULL THEN
            v_from := v_from || '
                     left outer join cd_vms d on d.vm_idseq = vm.vm_idseq
                     left outer join conceptual_domains c on c.cd_idseq = d.cd_idseq
                   ';
            IF v_where IS NOT NULL THEN
                     v_where := v_where || ' AND ';
            END IF;
            v_where :=
                   v_where || '
                NVL(c.cd_idseq,''1'')    = NVL('''
                || p_cd_idseq
                || ''',NVL(c.cd_idseq,''1''))';   -- criteria added on 8/8/03 Prerna Aggarwal
        END IF;
      --added by Anu to check for the latest version indicator and the version
      IF p_version_ind IS NOT NULL THEN
          IF v_where IS NOT NULL THEN
                 v_where := v_where || ' AND ';
                      END IF;
                  v_where :=   v_where ||  'vm.latest_version_ind = ''' || p_version_ind || ''' ';
        END IF;
          IF p_version IS NOT NULL THEN
           IF p_version > 0 THEN
              IF v_where IS NOT NULL THEN
                 v_where := v_where || ' AND ';
               END IF;
                  v_where :=   v_where ||  'vm.VERSION = ''' || p_version || ''' ';
            END IF;
          END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || ' ORDER BY asl.display_order, UPPER(vm.long_name)';   -- criteria added on 8/8/03 Prerna Aggarwal

        OPEN p_vm_search_res FOR v_sql;
    END;   --search vm


    PROCEDURE search_crfvalue(
        p_quest_idseq     IN       VARCHAR2
       ,p_qc_id           IN       VARCHAR2   -- 03-Jul-2003, W. Ver Hoef
       ,p_asl_name        IN       VARCHAR2
       ,p_vv_search_res   OUT      type_quest_vv_search ) IS
        -- Date:  03-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted procedure from straight query to dynamic sql; added
        --          parameters p_qc_id and p_asl_name to allow query by the public id
        --          and asl_name; added a block of code to handle possibility of multiple
        --          comma-separated values in p_asl_name; added  qv.asl_name,  qv.qc_id
        --          and qv.origin to query result; also wrapped the qc_idseq parameter
        --          with a nvl function in the comparison in the sql in case it is null
        --          since during testing it was not returning any values
        --          (per SPRF_2.0_12)
        v_sql        VARCHAR2( 4000 );
        v_where      VARCHAR2( 2000 ) := ' ';
        v_asl_name   VARCHAR2( 2000 );
        v_asl_list   VARCHAR2( 2000 );
        i            NUMBER           := 1;
    BEGIN
        IF p_vv_search_res%ISOPEN THEN
            CLOSE p_vv_search_res;
        END IF;
        v_sql :=
               'SELECT    qv.qc_idseq,
                      qv.long_name value,
                      qv.vp_idseq,
                      pv.value permissible_Value,
                      vm.long_name value_meaning,
       qv.asl_name,
       qv.qc_id,
       qv.origin
            FROM      quest_contents_view_ext qv,
                      quest_contents_view_ext qq,
                      vd_pvs_view vp,
                      permissible_values pv,
                      value_meanings vm
            WHERE     qv.p_qst_idseq = qq.qc_idseq
            AND       qv.vp_idseq    = vp.vp_idseq(+)
            AND       vp.pv_idseq    = pv.pv_idseq(+)
            AND       pv.vm_idseq    = vm.vm_idseq
            AND       qv.qtl_name    = ''VALID_VALUE''
            AND       qq.qc_idseq    = NVL('''
            || p_quest_idseq
            || ''',qq.qc_idseq)';
        -- 03-Jul-2003, W. Ver Hoef
        -- added the following section to handle comparison against a comma-separated list
        -- of asl names
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(qv.asl_name) in (' || v_asl_list || ')';
        END IF;
        -- 03-Jul-2003, W. Ver Hoef added comparison
        IF ( p_qc_id IS NOT NULL ) THEN
            v_where := v_where || ' AND nvl(qv.qc_id,' || '''' || '-1' || '''' || ') = ' || '''' || p_qc_id || '''';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '  ORDER BY   upper(value)';
        -- dbms_output.put_line(substr(v_where,least(-200,(-1*length(v_where)))));
        -- dbms_output.put_line(substr(v_where,1,200));
        -- dbms_output.put_line(substr(v_where,201,400));
        OPEN p_vv_search_res FOR v_sql;
    /*
          SELECT    qv.qc_idseq,
                  qv.long_name value,
                  qv.vp_idseq,
                  pv.value permissible_Value,
                  pv.short_meaning value_meaning
     FROM       quest_contents_view_ext qv,
                       quest_contents_view_ext qq,
                       vd_pvs_view vp,
                       permissible_values pv
       WHERE       qv.p_qst_idseq = qq.qc_idseq
       AND         qv.vp_idseq  = vp.vp_idseq(+)
       AND         vp.pv_idseq  = pv.pv_idseq(+)
       AND         qv.qtl_name = 'VALID_VALUE'
       AND         qq.qc_idseq = p_quest_idseq
       order by upper(value);
    */
    END;
    PROCEDURE delete_vd_pvs( p_vd_idseq IN VARCHAR2, p_return_code OUT VARCHAR2 ) IS
        v_count   NUMBER;
        CURSOR vd IS
            SELECT vp_idseq
              FROM vd_pvs_view
             WHERE vd_idseq = p_vd_idseq;
    BEGIN
        SELECT COUNT( * )
          INTO v_count
          FROM quest_contents_view_ext q
              ,vd_pvs_view v
         WHERE v.vp_idseq = q.vp_idseq AND v.vd_idseq = p_vd_idseq;
        IF v_count = 0 THEN
            FOR v_rec IN vd LOOP
                DELETE FROM VD_PVS_SOURCES_EXT
                      WHERE vp_idseq = v_rec.vp_idseq;
                DELETE FROM vd_pvs_view
                      WHERE vp_idseq = v_rec.vp_idseq;
            END LOOP;
            p_return_code := 'Rows Successfully deleted';
        ELSE
            p_return_code := 'Children Rows exist for values';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            p_return_code := 'Error Deleteing Records';
    END;
    -- 19-Mar-2004, W. Ver Hoef substituted DRAFT NEW with function call below
    PROCEDURE search_question(
        p_user               IN       VARCHAR2
       ,p_asl_name           IN       VARCHAR2 DEFAULT Sbrext_Common_Routines.get_default_asl( 'INS' )
       ,   -- 'DRAFT NEW',
        p_qc_id              IN       VARCHAR2
       ,p_valid_crf          OUT      VARCHAR2
       ,p_quest_search_res   OUT      type_quest_search ) IS
        -- Date:  03-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  converted code from open cursor with explicit sql to reference v_sql instead;
        --          added parameter p_qc_id and associated comparison code to query by public
        --          id; substituted original asl_name comparison for code that handles multiple
        --          comma-separated values; added qc_id and origin to query result
        --          (per SPRF_2.0_12)
        --
        -- Date:  07-Jul-2003
        -- Modified By:  W. Ver Hoef
        -- Reason:  commented out references to de_cde_id_view.min_cde_id and replaced with
        --          data_elements_view.cde_id
        --          (per SPRF_2.0_12)
        --
        -- Date:  19-Mar-2004
        -- Modified By:  W. Ver Hoef
        -- Reason:  substituted default value of p_asl_name DRAFT NEW with function call
        v_crf_idseq              quest_contents_view_ext.qc_idseq%TYPE;
        v_has_update_privilege   VARCHAR2( 3 );
        v_sql                    VARCHAR2( 4000 );   --03-Jul-2003, W. Ver Hoef
        v_where                  VARCHAR2( 2000 )                        := ' ';
        v_asl_name               VARCHAR2( 2000 );
        v_asl_list               VARCHAR2( 2000 );
        i                        NUMBER                                  := 1;
    BEGIN
        SELECT qc_idseq
          INTO v_crf_idseq
          FROM CRF_TOOL_PARAMETER_EXT
         WHERE UPPER( ua_name ) = UPPER( p_user );
        v_has_update_privilege := admin_security_util.has_update_privilege( p_user, v_crf_idseq );
        IF ( v_has_update_privilege = 'Yes' ) THEN
            p_valid_crf := 'ASSIGNED';
            IF p_quest_search_res%ISOPEN THEN
                CLOSE p_quest_search_res;
            END IF;
            -- 03-Jul-2003, W. Ver Hoef converted from explicit cursor query to v_sql
            v_sql :=
                   'SELECT  p.proto_idseq
          ,p.protocol_id
    ,crf.qc_idseq crf_idseq
    ,NVL(crf.long_name,crf.preferred_name) crf_name
    ,q.qc_idseq question_idseq
          ,NVL(q.long_name,q.long_name) question
    ,q.conte_idseq
    ,c.name CONTEXT
    ,q.asl_name
    ,q.de_idseq
    ,NVL(d.long_name,d.preferred_name) de_long_name
    ,d.vd_idseq de_vd_idseq
    ,q.dn_vd_idseq ques_vd_idseq
    ,NVL(v.long_name,v.preferred_name) value_domain_name
    ,v.preferred_name vd_preferred_name
    ,v.preferred_definition vd_preferred_definition
    ,d.cde_id  -- ,r.min_cde_id cde_id replaced 07-Jul-2003, W. Ver Hoef
    ,q.highlight_ind
    ,q.qc_id  -- added 03-Jul-2003, W. Ver Hoef
    ,q.origin
   FROM       quest_contents_view_ext q
        ,protocols_view_ext p
       ,data_elements_view d
       ,contexts_view c
       ,QUEST_CONTENTS_EXT crf
       -- ,de_cde_id_view  r   eliminiated 07-Jul-2003, W. Ver Hoef
       ,value_domains v
    ,PROTOCOL_QC_EXT pq
      WHERE      crf.qc_idseq = pq.qc_idseq(+)
   AND        pq.PROTO_IDSEQ = p.proto_idseq(+)
      AND        q.dn_crf_idseq = crf.qc_idseq(+)
      AND        q.conte_idseq = c.conte_idseq
      AND        q.de_idseq = d.de_idseq(+)
--      AND        d.de_idseq = r.ac_idseq(+)   eliminiated 07-Jul-2003, W. Ver Hoef
      AND        q.dn_vd_idseq = v.vd_idseq(+)
      AND        q.qtl_name = ''QUESTION''
      AND        q.dn_crf_idseq = '''
                || v_crf_idseq
                || '''';
            -- 03-Jul-2003, W. Ver Hoef
            -- substituted the following section for the commented out sql condition below
            IF ( p_asl_name IS NOT NULL ) THEN
                v_asl_name := UPPER( p_asl_name );
                WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                    i := INSTR( v_asl_name, ',' );
                    IF i = 0 THEN
                        v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                    ELSE
                        v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                    END IF;
                    v_asl_name := SUBSTR( v_asl_name, i + 1 );
                END LOOP;
                v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
                v_where := v_where || ' AND upper(q.asl_name) in (' || v_asl_list || ')';
            END IF;
            -- AND        upper(q.asl_name) = upper(p_asl_name)
            -- 03-Jul-2003, W. Ver Hoef added comparison
            IF ( p_qc_id IS NOT NULL ) THEN
                v_where := v_where || ' AND nvl(q.qc_id,' || '''' || '-1' || '''' || ') = ' || '''' || p_qc_id || '''';
            END IF;
            -- dbms_output.put_line(substr(v_sql,-200));
            -- dbms_output.put_line(substr(v_where,1,200));
            -- dbms_output.put_line(substr(v_where,201,400));
            v_sql := v_sql || v_where;
            v_sql := v_sql || '  ORDER BY q.display_order';
            OPEN p_quest_search_res FOR v_sql;
        ELSE
            p_valid_crf := 'No write permission';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_valid_crf := 'Not Assigned';
    END;
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
       ,p_origin                   IN       VARCHAR2 DEFAULT NULL   -- 20-Feb-2004, W. Ver Hoef added param per SPRF_2.1_17
       ,p_created_by               IN       VARCHAR2
                DEFAULT NULL   -- 02-Mar-2004, W. Ver Hoef added create/mod by per SPRF_2.1_10a
       ,p_modified_by              IN       VARCHAR2 DEFAULT NULL
       ,p_latest_version_ind       IN       VARCHAR2 DEFAULT NULL   -- 05-Mar-2004, W. Ver Hoef added per SPRF_2.1_08
       ,p_version                  IN       NUMBER   -- 15-Nov-2004, PAGGARWA- added per SPRF_3.0_1a
       ,p_con_name                 IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_con_idseq                IN       VARCHAR2 DEFAULT NULL   -- 6-DEC-2005, S. Hegde (TT1780)
       ,p_value_meaning            IN       value_meanings_view.long_name%TYPE
                DEFAULT NULL   -- 13-Dec-2005; S. Alred; TT#1667
                            ) IS
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_con_name        VARCHAR2( 1000 ) := UPPER( REPLACE( p_con_name, '*', '%' ));
        v_sql             VARCHAR2( 5000 );
        v_from            VARCHAR2( 2000 ) := ' ';
        v_where           VARCHAR2( 3000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_origin          VARCHAR2( 255 )  := UPPER( REPLACE( p_origin, '*', '%' ));
        v_created_by      VARCHAR2( 255 )  := p_created_by;   -- 02-Mar-2004, W. Ver Hoef
        v_modified_by     VARCHAR2( 255 )  := p_modified_by;   -- added "by" vars
        v_lat_vers_ind    VARCHAR2( 2000 ) := p_latest_version_ind;   -- 05-Mar-2004, W. Ver Hoef added
        v_value_meaning   VARCHAR2( 255 )  := REPLACE( p_value_meaning, '*', '%' );
    BEGIN
        IF p_cd_search_res%ISOPEN THEN
            CLOSE p_cd_search_res;
        END IF;
        v_sql :=
            'SELECT
 cd.preferred_name
 ,cd.long_name
 ,cd.preferred_definition
 ,cd.asl_name
 ,cd.conte_idseq
 ,cd.begin_date
 ,cd.end_date
 ,cd.version
 ,cd.cd_idseq
 ,cd.change_note
 ,c.name CONTEXT
 ,cd.cd_id
 ,cd.ORIGIN
 ,cd.dimensionality
 ,cd.latest_version_ind
 ,cd.deleted_ind
 ,cd.date_created
 ,cd.date_modified
 ,asl.display_order
 ,asl.asl_name
 ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(cd.created_by)  created_by
 ,SBREXT_CDE_CURATOR_PKG.get_ua_full_name(cd.modified_by) modified_by';   -- 10-Mar-2004, W. Ver Hoef added get func.
        v_from := '
 FROM
    conceptual_domains_view  cd
   ,sbr.ac_status_lov_view asl
   ,contexts_view            c';
        v_where := '
        asl.asl_name = cd.asl_name
        AND cd.conte_idseq = c.conte_idseq ';
        IF v_search_string IS NOT NULL THEN
            v_where :=
                   v_where
                || ' AND ( upper(cd.preferred_name) like '
                || ''''
                || v_search_string
                || ''''
                || '
                    OR UPPER(NVL(cd.long_name,'
                || ''''
                || ' '
                || ''''
                || ' )) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
   OR UPPER(cd.preferred_definition) LIKE '
                || ''''
                || v_search_string
                || ''''
                || ') ';
        END IF;
        IF ( p_conte_idseq IS NOT NULL ) THEN
            v_where := v_where || ' AND cd.conte_idseq = ' || '''' || p_conte_idseq || '''';
        END IF;
        IF ( p_context IS NOT NULL ) THEN
            --v_where := v_where||' AND c.name= '||''''||p_context||''''||'  ';
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(cd.asl_name) in (' || v_asl_list || ')';
        END IF;
        IF ( p_cd_idseq IS NOT NULL ) THEN
            v_where := v_where || ' AND cd.cd_idseq = ' || '''' || p_cd_idseq || '''';
        END IF;
        IF ( p_cd_id IS NOT NULL ) THEN
            v_where := v_where || ' AND cd.cd_id = ''' || p_cd_id || '''';
        END IF;
        -- 19-Feb-2004, W. Ver Hoef added if-then stmts for dates
        IF p_created_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(cd.date_created) >= TO_DATE('''
                || p_created_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_created_ending_date IS NOT NULL THEN
            v_where :=
                v_where || '
 AND TRUNC(cd.date_created) <= TO_DATE(''' || p_created_ending_date || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_starting_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(cd.date_modified) >= TO_DATE('''
                || p_modified_starting_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        IF p_modified_ending_date IS NOT NULL THEN
            v_where :=
                   v_where
                || '
 AND TRUNC(cd.date_modified) <= TO_DATE('''
                || p_modified_ending_date
                || ''',''MM/DD/YYYY'')';
        END IF;
        -- 20-Feb-2004, W. Ver Hoef added if-then stmt
        IF ( p_origin IS NOT NULL ) THEN
            v_where := v_where || '
 AND UPPER(cd.origin) LIKE ''' || v_origin || '''';
        END IF;
        -- 02-Mar-2004, W. Ver Hoef added if-then stmts for by's
        IF p_created_by IS NOT NULL THEN
            v_where := v_where || '
 AND cd.created_by = ''' || v_created_by || '''';
        END IF;
        IF p_modified_by IS NOT NULL THEN
            v_where := v_where || '
 AND cd.modified_by = ''' || v_modified_by || '''';
        END IF;
        -- 10-Mar-2004, W. Ver Hoef added per mod to SPRF_2.1_08
        IF p_latest_version_ind IS NOT NULL THEN
            v_where := v_where || '
    AND cd.latest_version_ind = ''' || v_lat_vers_ind || ''' ';
        END IF;
        -- 15-Nov2004, Prerna Aggarwal added to apply only when param is not null
        IF p_version <> 0 THEN
            v_where := v_where || '
 AND         cd.version = ' || p_version || ' ';
        END IF;
        --filter by concept name or con idseq sumana (7-dec-05)
        IF ( p_con_name IS NOT NULL OR p_con_idseq IS NOT NULL ) THEN
            IF ( p_con_name IS NOT NULL ) THEN
                v_con_name :=
                       '(UPPER(CON.LONG_NAME) LIKE '''
                    || v_con_name
                    || ''' OR UPPER(CON.PREFERRED_NAME) LIKE '''
                    || v_con_name
                    || ''') ';
            ELSE
                v_con_name := 'CON.CON_idseq = ''' || p_con_idseq || ''' ';
            END IF;
            v_where :=
                   '
 cd.cd_idseq IN (
 SELECT cdv.cd_idseq
 FROM sbr.conceptual_domains_view          cdv
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.CONCEPTS_VIEW_EXT             CON
 WHERE '
                || v_con_name
                || '
 AND CON.CON_IDSEQ = CC.CON_IDSEQ
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND CDR.CONDR_IDSEQ = CDV.CONDR_IDSEQ
 ) AND '
                || v_where;
        END IF;
        -- check for conditional use of p_value_meaning: TT#1667
        IF p_value_meaning IS NOT NULL THEN
            v_from := v_from || '
    ,value_meanings_view   vm
    ,cd_vms_view               vms';
            v_where :=
                   v_where
                || '
    AND cd.cd_idseq = vms.cd_idseq
    AND vm.vm_idseq = vms.vm_idseq
    AND vm.long_name = '''
                || v_value_meaning
                || ''' ';
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '  ORDER BY  asl.display_order, upper(long_name )';
        -- dbms_output.put_line(substr(v_where,1,200));
        -- dbms_output.put_line(substr(v_where,201,400));
        OPEN p_cd_search_res FOR v_sql;
    END;
    -- 10-Mar-2004. W. Ver Hoef added function per mod to SPRF_2.1_10a
    -- which requested that created_by and modified_by output be the user's full
    -- name rather than login id
    FUNCTION get_ua_full_name( p_ua_name IN VARCHAR2 )
        RETURN VARCHAR2 IS
        v_ua_full_name   VARCHAR2( 255 );
    BEGIN
        SELECT NAME
          INTO v_ua_full_name
          FROM user_accounts_view
         WHERE ua_name = p_ua_name;
        RETURN v_ua_full_name;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;
    -- 10-Mar-2004, W. Ver Hoef added procedure per SPRF_2.1_10b
    PROCEDURE get_user_list( p_user_list_cur OUT type_user_list ) IS
    BEGIN
        IF p_user_list_cur%ISOPEN THEN
            CLOSE p_user_list_cur;
        END IF;
        OPEN p_user_list_cur FOR
            SELECT   ua_name
                    ,NAME
                FROM user_accounts_view
            ORDER BY UPPER( NAME );
    END;
    -- 16-Mar-2004, W. Ver Hoef added procedure per SPRF_2.1_16a
    PROCEDURE get_doc_types_list( p_doc_types_list_cur OUT type_doc_types_list ) IS
    BEGIN
        IF p_doc_types_list_cur%ISOPEN THEN
            CLOSE p_doc_types_list_cur;
        END IF;
        OPEN p_doc_types_list_cur FOR
            SELECT   dctl_name
                    ,actl_name
                    ,description
                FROM document_types_lov_view
            ORDER BY UPPER( dctl_name )
                    ,UPPER( actl_name );
    END;
    -- 17-Mar-2004, W. Ver Hoef added procedure per SPRF_2.1_24
    PROCEDURE get_complex_rep_type( p_complex_rep_types_cur OUT type_complex_rep_types ) IS
    BEGIN
        IF p_complex_rep_types_cur%ISOPEN THEN
            CLOSE p_complex_rep_types_cur;
        END IF;
        OPEN p_complex_rep_types_cur FOR
            SELECT   crtl_name
                FROM complex_rep_type_lov_view
            ORDER BY UPPER( crtl_name );
    END;
    -- 17-Mar-2004, W. Ver Hoef added procedure per SPRF_2.1_24
    PROCEDURE get_complex_de(
        p_de_idseq             IN       VARCHAR2
       ,p_methods              OUT      VARCHAR2
       ,p_rule                 OUT      VARCHAR2
       ,p_concat_char          OUT      VARCHAR2
       ,p_crtl_name            OUT      VARCHAR2
       ,p_cdt_components_cur   OUT      type_cdt_components_types
       ,p_de_name               OUT      VARCHAR2
       ,p_de_id                   OUT      VARCHAR2
       ,p_de_version           OUT      VARCHAR2 ) IS
        v_de_idseq      CHAR( 36 )       := p_de_idseq;
        v_methods       VARCHAR2( 4000 );
        v_rule          VARCHAR2( 4000 );
        v_concat_char   VARCHAR2( 1 );
        v_crtl_name     VARCHAR2( 30 );
        v_de_name         VARCHAR2( 255 );
        v_de_id         VARCHAR2( 30 );
        v_de_version    VARCHAR2( 30 );
    BEGIN
        IF p_cdt_components_cur%ISOPEN THEN
            CLOSE p_cdt_components_cur;
        END IF;
        -- get the Complex DE header info
        SELECT methods
              ,rule
              ,concat_char
              ,crtl_name
              ,long_name
              ,cde_id
              ,version
          INTO v_methods
              ,v_rule
              ,v_concat_char
              ,v_crtl_name
              ,v_de_name
              ,v_de_id
              ,v_de_version
          FROM complex_data_elements_view
                 ,data_elements_view
         WHERE p_de_idseq = v_de_idseq
         AND   de_idseq = p_de_idseq;
        p_methods := v_methods;
        p_rule := v_rule;
        p_concat_char := v_concat_char;
        p_crtl_name := v_crtl_name;
        p_de_name := v_de_name;
        p_de_id := v_de_id;
        p_de_version := v_de_version;
        -- get the Complex DE component info
        OPEN p_cdt_components_cur FOR
            SELECT   cdr.cdr_idseq
                    ,   -- 23-Mar-2004, W. Ver Hoef added cdr_idseq to cursor
                     de.long_name
                    ,cdr.c_de_idseq
                    ,cdr.display_order
                    ,de.cde_id
                    ,de.VERSION
                FROM data_elements_view de
                    ,complex_de_rel_view cdr
               WHERE cdr.c_de_idseq = de.de_idseq AND cdr.p_de_idseq = v_de_idseq
            ORDER BY cdr.display_order
                    ,UPPER( de.long_name );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN;
    END;
    -- 30-Mar-2004, W. Ver Hoef added procedure per SPRF_2.1_16b
    -- 01-Apr-2004, W. Ver Hoef added nvl on logn name to show pref name if long is null
    -- 07-Apr-2004, W. Ver Hoef added AND/OR combinations to handle returning OTHER TYPES not
    --                            in the set of 15 common types
    -- 11-Nov-2005, S. Alred; TT1588
    PROCEDURE get_reference_documents( p_ac_idseq IN VARCHAR2, p_dctl_name IN VARCHAR2, p_ref_docs_cur OUT type_ref_docs ) IS
    BEGIN
        IF p_ref_docs_cur%ISOPEN THEN
            CLOSE p_ref_docs_cur;
        END IF;
        OPEN p_ref_docs_cur FOR
            SELECT   ac.ac_idseq
                    ,NVL( ac.long_name, ac.preferred_name ) ac_long_name
                    ,rd.rd_idseq
                    ,rd.NAME rd_name
                    ,rd.dctl_name rd_dctl_name
                    ,rd.doc_text rd_doc_text
                    ,rd.lae_name rd_lae_name
                    ,rd.url
                    ,rd.conte_idseq
                    ,c.NAME context_name
                FROM reference_documents_view rd
                    ,admin_components_view ac
                    ,contexts c
               WHERE rd.ac_idseq = ac.ac_idseq
                 AND rd.ac_idseq = NVL( p_ac_idseq, rd.ac_idseq )
                 AND rd.conte_idseq = c.conte_idseq(+)
                 AND (    ( NVL( p_dctl_name, 'xxx' ) != 'OTHER TYPES'
                            AND rd.dctl_name = NVL( p_dctl_name, rd.dctl_name ))
                       OR (     p_dctl_name = 'OTHER TYPES'
                            AND rd.dctl_name NOT IN
                                    ( 'REFERENCE'
                                     ,'EXAMPLE'
                                     ,'COMMENT'
                                     ,'NOTE'
                                     ,'DESCRIPTION'
                                     ,'Preferred Question Text'
                                     ,'IMAGE_FILE'
                                     ,'VALID_VALUE_SOURCE'
                                     ,'DATA_ELEMENT_SOURCE'
                                     ,'HISTORIC SHORT CDE NAME'
                                     ,'UML Class'
                                     ,'DETAIL_DESCRIPTION'
                                     ,'TECHNICAL GUIDE'
                                     ,'UML Attribute'
                                     ,'LABEL' )))
            ORDER BY rd.dctl_name
                    ,UPPER( rd.NAME );
    END;
    -- This procedure was originally in sbrext_ss_api and was moved here on 31-Mar-2004
    /******************************************************************************
       NAME:       get_alternate_names
       PURPOSE:    Get alternate names and type for a given ac_idseq.
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       2.1       02/11/2004   W. Ver Hoef      1. Created this procedure per SPRF_2.1_21
       2.1       03/25/2004   W. Ver Hoef      1. added context_name and lae_name, swapped
                                                  order by components, added detl_name not in
                 clause  per Denise's loose instructions to
                 not include any public IDs
       2.1       03/31/2004   W. Ver Hoef      1. added p_detl_name parameter and associated
                                                  where clause per SPRF_2.1_21 mod
       2.1       04/05/2004   W. Ver Hoef      1. added d.ac_idseq and ac.long_name per
                                                  another mod to SPRF_2.1_21
       2.1       04/08/2004   W. Ver Hoef      1. added nvl function for ac.long_name per
                                                  another mod to SPRF_2.1_21
    ******************************************************************************/
    PROCEDURE get_alternate_names( p_ac_idseq IN CHAR, p_detl_name IN VARCHAR2, p_alt_name_cur OUT type_alt_name ) IS
    BEGIN
        IF p_alt_name_cur%ISOPEN THEN
            CLOSE p_alt_name_cur;
        END IF;
        OPEN p_alt_name_cur FOR
            SELECT   d.desig_idseq
                    ,d.conte_idseq
                    ,c.NAME context_name
                    ,d.NAME
                    ,d.detl_name
                    ,d.lae_name
                    ,d.ac_idseq
                    ,NVL( ac.long_name, ac.preferred_name ) ac_long_name
                FROM designations_view d
                    ,contexts_view c
                    ,admin_components_view ac
               WHERE d.conte_idseq = c.conte_idseq
                 AND d.ac_idseq = ac.ac_idseq
                 AND d.ac_idseq = p_ac_idseq
                 AND d.detl_name = NVL( p_detl_name, d.detl_name )
            /*AND    d.detl_name not in ('CDE_ID', 'CD_ID', 'CS_ID', 'DEC_ID', 'OC_ID',
                                       'PROP_ID', 'PROTO_ID', 'QC_ID', 'REP_ID', 'VD_ID') */
            ORDER BY d.detl_name
                    ,UPPER( d.NAME );
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.put_line( SQLERRM );
    END;
    PROCEDURE get_protocol_crf( p_de_idseq IN CHAR, p_protocol_crf_cur OUT type_protocol_crf ) IS
    BEGIN
        IF p_protocol_crf_cur%ISOPEN THEN
            CLOSE p_protocol_crf_cur;
        END IF;
        OPEN p_protocol_crf_cur FOR
            SELECT   b.protocol_id protocol_id
                    ,NVL( b.long_name, b.preferred_name ) protocol_name
                    ,b.proto_id proto_id
                    ,NVL( c.long_name, c.preferred_name ) crf
                    ,a.NAME crf_context
                    ,c.asl_name crf_asl_name
                    ,c.qc_id qc_id
                FROM sbrext.protocols_view_ext b
                    ,sbr.contexts_view a
                    ,quest_contents_view_ext q
                    ,quest_contents_view_ext c
                    ,PROTOCOL_QC_EXT pq
               WHERE ( c.qc_idseq = q.dn_crf_idseq )
                 AND ( q.qtl_name = 'QUESTION' )
                 AND ( a.conte_idseq = b.conte_idseq )
                 AND ( c.qc_idseq = pq.qc_idseq )
                 AND ( pq.proto_idseq = b.proto_idseq )
                 AND ( q.de_idseq = p_de_idseq )
            ORDER BY crf;
    /*   SELECT
          B.PROTOCOL_ID PROTOCOL_ID
        , NVL(B.LONG_NAME, B.PREFERRED_NAME) PROTOCOL_NAME
        , B.PROTO_ID PROTO_ID
        , NVL(C.LONG_NAME, C.PREFERRED_NAME) CRF_NAME
        , A.NAME CRF_CONTEXT
        , C.ASL_NAME CRF_ASL_NAME
        , C.QC_ID QC_ID
       FROM
          SBREXT.PROTOCOLS_VIEW_EXT B
        , SBR.CONTEXTS_VIEW A
        , SBREXT.QUEST_CONTENTS_VIEW_EXT C
       WHERE
            (A.CONTE_IDSEQ = B.CONTE_IDSEQ)
        AND (C.PROTO_IDSEQ = B.PROTO_IDSEQ)
        AND (C.DE_IDSEQ = p_de_idseq); */
    END get_protocol_crf;
    PROCEDURE get_ac_concepts( p_condr_idseq IN VARCHAR2, p_con_res OUT type_con_res ) IS
    BEGIN
        IF p_con_res%ISOPEN THEN
            CLOSE p_con_res;
        END IF;
        OPEN p_con_res FOR
            SELECT   com.con_idseq
                    ,display_order
                    ,primary_flag_ind
                    ,preferred_name
                    ,long_name
                    ,preferred_definition
                    ,origin
                    ,definition_source
                    ,evs_source
                    ,com.CONCEPT_VALUE
                FROM COMPONENT_CONCEPTS_EXT com
                    ,CONCEPTS_EXT con
               WHERE com.con_idseq = con.con_idseq AND com.condr_idseq = p_condr_idseq
            ORDER BY display_order DESC;
    END;
       PROCEDURE search_con(
        p_search_string    IN       VARCHAR2
       ,p_asl_name         IN       VARCHAR2
       ,p_context          IN       VARCHAR2
       ,p_con_id           IN       VARCHAR2
       ,p_con_idseq        IN       VARCHAR2
       ,p_con_search_res   OUT      type_con_search
       ,p_dec_idseq        IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_vd_idseq         IN       VARCHAR2 DEFAULT NULL   -- 7-DEC-2005, S. Hegde (TT1780)
       ,p_definition       IN        VARCHAR2 DEFAULT NULL    -- GF 634)
                                                         ) IS
        v_search_string   VARCHAR2( 255 )  := UPPER( REPLACE( p_search_string, '*', '%' ));
        v_definition      VARCHAR2( 2000 )  := UPPER(p_definition);
        v_sql             VARCHAR2( 6000 );
        v_where           VARCHAR2( 4000 ) := ' ';
        v_from            VARCHAR2( 2000 ) := ' ';
        v_sub             VARCHAR2( 4000 ) := ' ';
        v_asl_name        VARCHAR2( 2000 );
        v_asl_list        VARCHAR2( 2000 );
        i                 NUMBER           := 1;
        v_context         VARCHAR2( 2000 );
        v_context_list    VARCHAR2( 2000 );
    BEGIN
        IF p_con_search_res%ISOPEN THEN
            CLOSE p_con_search_res;
        END IF;
        v_sql :=
            'SELECT
 con.preferred_name
 ,con.long_name
 ,con.preferred_definition
 ,con.conte_idseq
 ,con.asl_name
 ,con.con_idseq
 ,con.version
 ,con.begin_date
 ,con.end_date
 ,con.change_note
 ,con.origin
 ,con.definition_source
 ,c.name CONTEXT
 ,con.evs_source
 ,asl.display_order
 ,asl.asl_name
 ,con.con_ID';
        v_from := '
 FROM
  concepts_view_ext con
 ,sbr.ac_status_lov_view asl
 ,contexts_view c';
        v_where := '
        asl.asl_name = con.asl_name
        AND con.conte_idseq = c.conte_idseq';
        IF p_search_string IS NOT NULL THEN
            v_where :=
                   v_where
                || '
      AND  (UPPER(con.preferred_name) LIKE UPPER(NVL('''
                || v_search_string
                || ''',con.preferred_name))
             OR UPPER(NVL(con.long_name,'
                || ''''
                || ' '
                || ''''
                || ' )) LIKE '
                || ''''
                || v_search_string
                || ''''
                || '
            /* OR UPPER(con.preferred_definition) LIKE UPPER(NVL('''
                || v_search_string
               || ''',con.preferred_definition)) */  --GF348
            )';
        END IF;
        IF p_context IS NOT NULL THEN
            v_context := UPPER( p_context );
            WHILE( i != 0 AND v_context IS NOT NULL ) LOOP
                i := INSTR( v_context, ',' );
                IF i = 0 THEN
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( v_context )) || '''';
                ELSE
                    v_context_list := v_context_list || ',''' || LTRIM( RTRIM( SUBSTR( v_context, 1, i - 1 ))) || '''';
                END IF;
                v_context := SUBSTR( v_context, i + 1 );
            END LOOP;
            v_context_list := SUBSTR( v_context_list, 2, LENGTH( v_context_list ));
            v_where := v_where || ' AND upper(c.name) in (' || v_context_list || ')';
        END IF;
        i := 1;
        IF ( p_asl_name IS NOT NULL ) THEN
            v_asl_name := UPPER( p_asl_name );
            WHILE( i != 0 AND v_asl_name IS NOT NULL ) LOOP
                i := INSTR( v_asl_name, ',' );
                IF i = 0 THEN
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( v_asl_name )) || '''';
                ELSE
                    v_asl_list := v_asl_list || ',''' || LTRIM( RTRIM( SUBSTR( v_asl_name, 1, i - 1 ))) || '''';
                END IF;
                v_asl_name := SUBSTR( v_asl_name, i + 1 );
            END LOOP;
            v_asl_list := SUBSTR( v_asl_list, 2, LENGTH( v_asl_list ));
            v_where := v_where || ' AND upper(con.asl_name) in (' || v_asl_list || ')';
        END IF;
        IF ( p_con_id IS NOT NULL ) THEN
            v_where := v_where || ' AND con.con_id = ' || '''' || p_con_id || '''';
        END IF;
        IF ( p_con_idseq IS NOT NULL ) THEN
            v_where := v_where || ' AND con.con_idseq = ' || '''' || p_con_idseq || '''';
        END IF;
        IF ( p_definition IS NOT NULL ) THEN
            v_where := v_where || ' AND upper(con.preferred_definition) = ' || '''' || v_definition || '''';
        END IF;
        IF p_dec_idseq IS NOT NULL OR p_vd_idseq IS NOT NULL THEN
            v_sub := '
 con.con_idseq IN (';
            IF p_vd_idseq IS NOT NULL THEN
                v_sub :=
                       v_sub
                    || '
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbr.VALUE_DOMAINS_VIEW               VD
 WHERE vd.vd_idseq = '''
                    || p_vd_idseq
                    || '''
 AND CDR.CONDR_IDSEQ = vd.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 UNION
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.REPRESENTATIONS_VIEW_EXT      rep
     ,sbr.VALUE_DOMAINS_VIEW               VD
 WHERE vd.vd_idseq = '''
                    || p_vd_idseq
                    || '''
 AND rep.rep_idseq = vd.rep_idseq
 AND CDR.CONDR_IDSEQ = rep.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 UNION
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbr.VD_PVS_VIEW                      cvp
     ,sbr.permissible_values_view          cpv
     ,sbr.value_meanings_view          cvm
     ,sbr.VALUE_DOMAINS_VIEW               VD
 WHERE vd.vd_idseq = '''
                    || p_vd_idseq
                    || '''
 AND cvp.vd_IDSEQ = vd.vd_IDSEQ
 AND cpv.pv_idseq = cvp.pv_idseq
 AND cvm.vm_idseq = cpv.vm_idseq
 AND CDR.condr_idseq = cvm.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 UNION
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbr.conceptual_domains_view          CD
     ,sbr.VALUE_DOMAINS_VIEW               VD
 WHERE vd.vd_idseq = '''
                    || p_vd_idseq
                    || '''
 AND CD.CD_IDSEQ = vd.CD_IDSEQ
 AND CDR.CONDR_IDSEQ = cd.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 ';
            END IF;
            IF p_dec_idseq IS NOT NULL THEN
                IF p_vd_idseq IS NOT NULL THEN
                    v_sub := v_sub || '
 UNION';
                END IF;
                v_sub :=
                       v_sub
                    || '
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbr.conceptual_domains_view          CD
     ,sbr.DATA_ELEMENT_CONCEPTS_VIEW       DEC
 WHERE DEC.dec_idseq = '''
                    || p_dec_idseq
                    || '''
 AND CD.CD_IDSEQ = DEC.cd_idseq
 AND CDR.CONDR_IDSEQ = cd.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 UNION
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.object_classes_view_ext       OC
     ,sbr.DATA_ELEMENT_CONCEPTS_VIEW       DEC
 WHERE DEC.dec_idseq = '''
                    || p_dec_idseq
                    || '''
 AND OC.OC_IDSEQ = DEC.oc_idseq
 AND CDR.CONDR_IDSEQ = oc.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 UNION
 SELECT cn.con_idseq
 FROM sbrext.concepts_view_ext             cn
     ,sbrext.CON_DERIVATION_RULES_VIEW_EXT CDR
     ,sbrext.COMPONENT_CONCEPTS_VIEW_EXT   CC
     ,sbrext.properties_view_ext           PROP
     ,sbr.DATA_ELEMENT_CONCEPTS_VIEW       DEC
 WHERE DEC.dec_idseq = '''
                    || p_dec_idseq
                    || '''
 AND PROP.PROP_IDSEQ = DEC.prop_idseq
 AND CDR.CONDR_IDSEQ = prop.condr_idseq
 AND CC.CONDR_IDSEQ = CDR.CONDR_IDSEQ
 AND cn.CON_IDSEQ = CC.CON_IDSEQ
 ';
            END IF;
            v_where := v_sub || ') AND ' || v_where;
        END IF;
        v_sql := v_sql || v_from || ' WHERE ' || v_where || '
 ORDER BY asl.display_order, UPPER(con.long_name)';
        -- dbms_output.put_line(SUBSTR(v_sql,1,200));
        -- dbms_output.put_line(SUBSTR(v_sql,201,200));
        -- dbms_output.put_line(SUBSTR(v_sql,401,200));
        -- dbms_output.put_line(SUBSTR(v_sql,601,200));
        -- dbms_output.put_line(SUBSTR(v_sql,801,200));
        -- dbms_output.put_line(SUBSTR(v_sql,1001,200));
        -- dbms_output.put_line(SUBSTR(v_sql,1201,200));
        -- dbms_output.put_line(SUBSTR(v_sql,1401,200));
        -- dbms_output.put_line(SUBSTR(v_sql,1601,200));
        -- dbms_output.put_line(SUBSTR(v_sql,1801,200));
        OPEN p_con_search_res FOR v_sql;
    END;
    -- TT1824
    PROCEDURE add_to_sentinel_cs( p_id_seq IN VARCHAR2, p_ua_name IN VARCHAR2, p_csi_idseq OUT VARCHAR2 ) IS
        /*
        ** Description: Create associations between a user CSI and
        **    various Administered Components [TT#1824]
        ** Parameters:
        **  p_id_seq  ID of administered component
        **  p_ua_name ???
        **  p_csi_idseq idseq of the CSI created or found
        ** Changes
        **  11/07/2005  S. Alred  No prior version
        **  11/21/2005  S. Alred  Added check to prevent attempts to load duplicate
        **    cs_csi items
        **  11/22/2005  S. Alred  Added ins procedure for ac_csi
        ** Notes
        */
        -- variables
        v_rvsd_cs_cs_idseq   classification_schemes_view.cs_idseq%TYPE;
        v_rvsd_csi_format    sbrext.tool_options_view_ext.VALUE%TYPE;
        v_token              sbr.class_scheme_items.csi_name%TYPE;
        v_csi_idseq          sbr.class_scheme_items.csi_idseq%TYPE;
        v_cs_csi_idseq       cs_csi_view.cs_csi_idseq%TYPE;
        v_dummy              VARCHAR2( 1 );
        -- Cursors
        -- get Sentinel values; use one cursor to get both values
        CURSOR get_value IS
            SELECT VALUE
                  ,property
              FROM sbrext.tool_options_view_ext
             WHERE tool_name = 'SENTINEL' AND( property = 'RSVD.CS.CS_IDSEQ' OR property = 'RSVD.CSI.FORMAT' );
        -- get/check CSI
        CURSOR get_csi( p_csi_name class_scheme_items_view.csi_name%TYPE ) IS
            SELECT csi_idseq
              FROM class_scheme_items_view
             WHERE csi_name = p_csi_name;
        --  get/check cs_csi
        CURSOR check_cs_csi(
            p_cs_idseq    classification_schemes_view.cs_idseq%TYPE
           ,p_csi_idseq   class_scheme_items_view.csi_idseq%TYPE ) IS
            SELECT cs_csi_idseq
              FROM cs_csi_view ccv
             WHERE ccv.cs_idseq = p_cs_idseq AND ccv.csi_idseq = p_csi_idseq AND ccv.p_cs_csi_idseq IS NULL;
        -- check for ac_csi
        CURSOR check_ac_csi( p_ac_idseq ac_csi_view.ac_idseq%TYPE, p_cs_csi_idseq ac_csi_view.cs_csi_idseq%TYPE ) IS
            SELECT 'x'
              FROM ac_csi_view
             WHERE ac_idseq = p_ac_idseq AND cs_csi_idseq = p_cs_csi_idseq;
        ----
        PROCEDURE ins_csi(
            p_csi_name        IN       class_scheme_items_view.csi_name%TYPE
           ,p_csi_idseq_out   OUT      class_scheme_items_view.csi_idseq%TYPE ) IS
            v_idseq   CHAR( 36 );
        BEGIN
            v_idseq := admincomponent_crud.cmr_guid;
            INSERT INTO class_scheme_items_view
                        ( csi_idseq
                         ,csi_name
                         ,csitl_name
                         ,description
                         ,comments
                         ,date_created
                         ,created_by )
                 VALUES ( v_idseq
                         ,p_csi_name
                         ,'CATEGORY_TYPE'
                         ,'Created by system process'
                         ,'Created by system process'
                         ,SYSDATE
                         ,p_ua_name );
            p_csi_idseq_out := v_idseq;
        -- dbms_output.put_line('**Created class scheme item #: '||v_idseq);
        END ins_csi;
        PROCEDURE ins_cs_csi(
            p_cs_idseq           IN       classification_schemes_view.cs_idseq%TYPE
           ,p_csi_idseq_in       IN       class_scheme_items_view.csi_idseq%TYPE
           ,p_cs_csi_idseq_out   OUT      cs_csi_view.cs_csi_idseq%TYPE ) IS
            v_cs_csi_idseq   cs_csi_view.cs_csi_idseq%TYPE;
        BEGIN
            v_cs_csi_idseq := admincomponent_crud.cmr_guid;
            INSERT INTO cs_csi_view
                        ( cs_csi_idseq
                         ,cs_idseq
                         ,csi_idseq
                         ,label
                         ,date_created
                         ,created_by )
                 VALUES ( v_cs_csi_idseq
                         ,p_cs_idseq
                         ,p_csi_idseq_in
                         ,'Sentinel User Monitors'
                         ,SYSDATE
                         ,p_ua_name );
            -- dbms_output.put_line('**Created cs csi item #: '||v_cs_csi_idseq);
            p_cs_csi_idseq_out := v_cs_csi_idseq;
        END ins_cs_csi;
        PROCEDURE ins_ac_csi(
            p_ac_idseq       IN   admin_components_view.ac_idseq%TYPE
           ,p_cs_csi_idseq   IN   cs_csi_view.cs_csi_idseq%TYPE ) IS
            /*
            ** Create a row in the Admin Component <-> CS-CSI association table
            ** Parameters:
            **  p_ac_idseq: ID for an administered component
            **  p_cs_csi_idseq: ID for CS_CSI association
            ** S. Alred; 11/22/2005
            */
            v_idseq   CHAR( 36 ) := NULL;   -- hold new PK value
        BEGIN
            v_idseq := admincomponent_crud.cmr_guid;
            INSERT INTO ac_csi_view
                        ( ac_csi_idseq
                         ,cs_csi_idseq
                         ,ac_idseq
                         ,date_created
                         ,created_by )
                 VALUES ( v_idseq
                         ,p_cs_csi_idseq
                         ,p_ac_idseq
                         ,SYSDATE
                         ,p_ua_name );
        END ins_ac_csi;
    -- end private declarations
    BEGIN
        -- pick up Sentinel values [specification steps 1,3]
        IF p_ua_name IS NOT NULL THEN
            admin_security_util.seteffectiveuser(p_ua_name);
        END IF;

        FOR r_rec IN get_value LOOP
            IF r_rec.property = 'RSVD.CS.CS_IDSEQ' THEN
                v_rvsd_cs_cs_idseq := r_rec.VALUE;
            ELSIF r_rec.property = 'RSVD.CSI.FORMAT' THEN
                v_rvsd_csi_format := r_rec.VALUE;
            END IF;
        END LOOP;
        -- test results; return NULL if either variable were not found [2,4]
        IF ( v_rvsd_cs_cs_idseq IS NULL OR v_rvsd_csi_format IS NULL ) THEN
            p_csi_idseq := NULL;
            RETURN;
        END IF;
        -- perform substitution [5,6]
        v_token := REPLACE( v_rvsd_csi_format, '$ua_name$', p_ua_name );
        v_token := TRIM( BOTH ' ' FROM v_token );
        -- Attempt to retrieve CSI; if not found create one [7,8]
        OPEN get_csi( p_csi_name => v_token );
        FETCH get_csi
         INTO p_csi_idseq;
        IF get_csi%NOTFOUND THEN
            v_csi_idseq := NULL;
            ins_csi( p_csi_name => v_token, p_csi_idseq_out => v_csi_idseq );
            p_csi_idseq := v_csi_idseq;
        END IF;
        CLOSE get_csi;
        -- associate the new/found csi with the cs [7,8]
        -- [11/21/2005] if it doesn't exist
        OPEN check_cs_csi( p_cs_idseq => v_rvsd_cs_cs_idseq, p_csi_idseq => p_csi_idseq );
        FETCH check_cs_csi
         INTO v_cs_csi_idseq;
        IF check_cs_csi%NOTFOUND THEN
            ins_cs_csi( p_cs_idseq               => v_rvsd_cs_cs_idseq
                       ,p_csi_idseq_in           => p_csi_idseq
                       ,p_cs_csi_idseq_out       => v_cs_csi_idseq );
        END IF;
        CLOSE check_cs_csi;
        -- link to AC [9]
        -- check for existance first
        OPEN check_ac_csi( p_ac_idseq => p_id_seq, p_cs_csi_idseq => v_cs_csi_idseq );
        FETCH check_ac_csi
         INTO v_dummy;
        IF check_ac_csi%NOTFOUND THEN
            ins_ac_csi( p_ac_idseq => p_id_seq, p_cs_csi_idseq => v_cs_csi_idseq );
        END IF;
        CLOSE check_ac_csi;
    END add_to_sentinel_cs;
    -- TT1824
    PROCEDURE remove_from_sentinel_cs( p_id_seq IN VARCHAR2, p_ua_name IN VARCHAR2 ) IS
        /*
        ** Description: Remove associations between a user CSI and
        **    various Administered Components [TT#1824]
        ** Parameters:
        **  p_id_seq  ID of administered component
        **  p_ua_name user account id
        ** Changes
        **  12/08/2005  Larry Hebel (ScenPro)  No prior version
        ** Notes
        */
        v_rvsd_cs_cs_idseq   classification_schemes_view.cs_idseq%TYPE;
        v_rvsd_csi_format    sbrext.tool_options_view_ext.VALUE%TYPE;
        v_name               class_scheme_items_view.csi_name%TYPE;
        v_cs_csi_idseq       cs_csi_view.cs_csi_idseq%TYPE;
        -- Cursors
        -- get Sentinel values; use one cursor to get both values
        CURSOR get_value IS
            SELECT VALUE
                  ,property
              FROM sbrext.tool_options_view_ext
             WHERE tool_name = 'SENTINEL' AND( property = 'RSVD.CS.CS_IDSEQ' OR property = 'RSVD.CSI.FORMAT' );
        -- get/check CSI
        CURSOR get_cscsi(
            p_csi_name   class_scheme_items_view.csi_name%TYPE
           ,p_cs_idseq   classification_schemes_view.cs_idseq%TYPE ) IS
            SELECT csc.cs_csi_idseq
              FROM cs_csi_view csc
                  ,class_scheme_items_view csi
                  ,classification_schemes_view cs
             WHERE cs.cs_idseq = p_cs_idseq
               AND cs.cs_idseq = csc.cs_idseq
               AND csc.csi_idseq = csi.csi_idseq
               AND csi.csi_name = p_csi_name;
    -- end private declarations
    BEGIN
        -- pick up Sentinel values
        FOR r_rec IN get_value LOOP
            IF r_rec.property = 'RSVD.CS.CS_IDSEQ' THEN
                v_rvsd_cs_cs_idseq := r_rec.VALUE;
            ELSIF r_rec.property = 'RSVD.CSI.FORMAT' THEN
                v_rvsd_csi_format := r_rec.VALUE;
            END IF;
        END LOOP;
        -- test results; return NULL if either variable were not found
        IF ( v_rvsd_cs_cs_idseq IS NULL OR v_rvsd_csi_format IS NULL ) THEN
            RETURN;
        END IF;
        -- perform substitution
        v_name := REPLACE( v_rvsd_csi_format, '$ua_name$', p_ua_name );
        v_name := TRIM( BOTH ' ' FROM v_name );
        -- Attempt to retrieve CSI; if not found that's ok just return.
        OPEN get_cscsi( p_csi_name => v_name, p_cs_idseq => v_rvsd_cs_cs_idseq );
        FETCH get_cscsi
         INTO v_cs_csi_idseq;
        IF get_cscsi%NOTFOUND THEN
            RETURN;
        END IF;
        CLOSE get_cscsi;
        -- Delete the ac_csi that maintains the association between the AC and CSI
        DELETE FROM ac_csi_view
              WHERE cs_csi_idseq = v_cs_csi_idseq AND ac_idseq = p_id_seq;
    END remove_from_sentinel_cs;
    PROCEDURE search_tool_options(
        p_tool_name            IN       VARCHAR2
       ,p_property             IN       VARCHAR2
       ,p_value                IN       VARCHAR2
       ,p_toolopt_search_res   OUT      type_toolopt_search
       ,p_return_code          OUT      VARCHAR2 ) IS
        -- Date:  11-Nov-2005
        -- Modified By:  S. Alred
        -- Reason: No prior version; created to support TT1627
        v_sql        VARCHAR2( 4000 );
        v_where      VARCHAR2( 2000 ) := '
WHERE 1=1 ';
        v_order_by   VARCHAR2(1000)   := '
ORDER BY TOOL_NAME, PROPERTY';
        v_property   VARCHAR2( 255 );
    BEGIN
        -- standard wildcard substitution
        v_property := REPLACE( p_property, '*', '%' );
        p_return_code := NULL;
        IF p_toolopt_search_res%ISOPEN THEN
            CLOSE p_toolopt_search_res;
        END IF;
        v_sql :=
            'SELECT TOOL_IDSEQ
                  ,TOOL_NAME
                  ,PROPERTY
                  ,VALUE
                  ,DATE_CREATED
                  ,CREATED_BY
                  ,DATE_MODIFIED
                  ,MODIFIED_BY
                  ,UA_NAME
 FROM       tool_options_view_ext tov';
        -- business rule test(s)
        IF ( p_property IS NULL AND p_value IS NULL AND p_tool_name IS NULL ) THEN   -- error: one parm must be not null
            p_return_code := 'API-001: All parameters NULL';
            RETURN;
        END IF;
        -- test for not null parameters and construct WHERE clause accordingly
        IF ( p_tool_name IS NOT NULL ) THEN
            v_where := v_where || ' AND tov.tool_name = ' || '''' || p_tool_name || '''';
        END IF;
        IF ( p_property IS NOT NULL ) THEN
            v_where := v_where || ' AND tov.property LIKE ' || '''' || UPPER( v_property ) || '''';
        END IF;
        IF ( p_value IS NOT NULL ) THEN
            v_where := v_where || ' AND tov.value = ' || '''' || p_value || '''';
        END IF;
        v_sql := v_sql || v_where || v_order_by;
        OPEN p_toolopt_search_res FOR v_sql;
    END search_tool_options;
    -- SPRF_3.1_16a (TT#1001)
    PROCEDURE Search_Ac_Contact(
        p_ac_idseq            IN       ac_contacts_view.ac_idseq%TYPE
       ,p_acc_idseq           IN       ac_contacts_view.acc_idseq%TYPE
       ,p_ac_con_search_res   OUT      type_ac_contact ) IS
        /*
        ** Return ac_contact attributes filtered by ac_idseq or by acc_idseq
        if either is NOT NULL
        ** Business rule -- at least one should be not null
        */
        v_sql     VARCHAR2( 4000 );
        v_where   VARCHAR2( 2000 );
        v_order   VARCHAR2( 2000 );
    BEGIN
        v_sql :=
            'SELECT acc_idseq
              ,ac.org_idseq
              ,ac.per_idseq
              ,ac.ac_idseq
              ,ac.rank_order
              ,ac.date_created
              ,ac.created_by
              ,ac.date_modified
              ,ac.modified_by
              ,ac.cs_csi_idseq
              ,ac.ar_idseq
              ,ac.contact_role
              FROM ac_contacts_view ac
              ,    contacts_view_ext cve';
        v_where := '
              WHERE (ac.per_idseq = cve.con_idseq
                OR   ac.org_idseq = cve.con_idseq)';
        IF p_ac_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND ac_idseq = ''' || p_ac_idseq || ''' ';
        END IF;
        IF p_acc_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND acc_idseq = ''' || p_acc_idseq || ''' ';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '
             ORDER BY ac.rank_order, ac.contact_role, upper(cve.name)';
        IF p_ac_con_search_res%ISOPEN THEN
            CLOSE p_ac_con_search_res;
        END IF;
        OPEN p_ac_con_search_res FOR v_sql;
    END Search_Ac_Contact;
    -- SPRF_3.1_16b (TT#1001)
    PROCEDURE search_contact_comm(
        p_org_idseq            IN       contact_comms_view.org_idseq%TYPE
       ,p_per_idseq            IN       contact_comms_view.per_idseq%TYPE
       ,p_ccomm_idseq          IN       contact_comms_view.ccomm_idseq%TYPE
       ,p_con_com_search_res   OUT      type_con_comm ) IS
        /*
        ** Return contact_comm attributes filtered by org_idseq, per_idseq, or ccom_idseq
        **  if any is NOT NULL
        ** Business rule -- at least one should be not null
        */
        v_sql     VARCHAR2( 4000 );
        v_where   VARCHAR2( 2000 );
        v_order   VARCHAR2( 2000 );
    BEGIN
        v_sql :=
            'SELECT ccomm_idseq
              ,org_idseq
              ,per_idseq
              ,ctl_name
              ,rank_order
              ,cyber_address
              ,date_created
              ,created_by
              ,date_modified
              ,modified_by
              FROM contact_comms_view';
        v_where := '
              WHERE 1=1';
        IF p_org_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND org_idseq = ''' || p_org_idseq || ''' ';
        END IF;
        IF p_per_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND per_idseq = ''' || p_per_idseq || ''' ';
        END IF;
        IF p_ccomm_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND ccom_idseq = ''' || p_ccomm_idseq || ''' ';
        END IF;
        v_sql := v_sql || v_where;
        v_SQL := v_SQL||'
          ORDER BY rank_order, ctl_name, cyber_address';
        IF p_con_com_search_res%ISOPEN THEN
            CLOSE p_con_com_search_res;
        END IF;
        OPEN p_con_com_search_res FOR v_sql;
    END search_contact_comm;
    -- SPRF_3.1_16c (TT#1001)
    PROCEDURE search_contact_addr(
        p_org_idseq             IN       contact_addresses_view.org_idseq%TYPE
       ,p_per_idseq             IN       contact_addresses_view.per_idseq%TYPE
       ,p_caddr_idseq           IN       contact_addresses_view.caddr_idseq%TYPE
       ,p_con_addr_search_res   OUT      type_con_addr ) IS
        /*
        ** Return contact_addresses attributes filtered by org_idseq, per_idseq, or caddr_idseq
        **  if any is NOT NULL
        ** Business rule -- at least one should be not null
        */
        v_sql     VARCHAR2( 4000 );
        v_where   VARCHAR2( 2000 );
        v_order   VARCHAR2( 2000 );
    BEGIN
        v_sql :=
            'SELECT caddr_idseq
             ,org_idseq
             ,per_idseq
             ,atl_name
             ,rank_order
             ,addr_line1
             ,addr_line2
             ,city
             ,state_prov
             ,postal_code
             ,country
             ,date_created
             ,created_by
             ,date_modified
             ,modified_by
             FROM contact_addresses_view';
        v_where := '
              WHERE 1=1';
        IF p_org_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND org_idseq = ''' || p_org_idseq || ''' ';
        END IF;
        IF p_per_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND per_idseq = ''' || p_per_idseq || ''' ';
        END IF;
        IF p_caddr_idseq IS NOT NULL THEN
            v_where := v_where || '
              AND caddr_idseq = ''' || p_caddr_idseq || ''' ';
        END IF;
        v_sql := v_sql || v_where;
        v_sql := v_sql || '
           ORDER BY rank_order,atl_name,addr_line1';
        IF p_con_addr_search_res%ISOPEN THEN
            CLOSE p_con_addr_search_res;
        END IF;
        OPEN p_con_addr_search_res FOR v_sql;
    END search_contact_addr;
    -- SPRF_3.1_16d (TT#1001)
    PROCEDURE get_contact_roles_list( p_con_role_res OUT type_con_role ) IS
        v_sql   VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_con_role_res%ISOPEN THEN
            CLOSE p_con_role_res;
        END IF;
        -- define the basic query
        v_sql :=
            'SELECT contact_role
              ,      description
              FROM CONTACT_ROLES_EXT
              ORDER BY contact_role';
        OPEN p_con_role_res FOR v_sql;
    END get_contact_roles_list;
    -- SPRF_3.1_16e (TT#1001)
    PROCEDURE get_organization_list( p_org_name_res OUT type_org_name ) IS
        v_sql   VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_org_name_res%ISOPEN THEN
            CLOSE p_org_name_res;
        END IF;
        -- define the basic query
        v_sql :=
            'SELECT ov.org_idseq
              ,      ov.name
              FROM organizations_view ov
              ORDER BY  UPPER(ov.name)';
        OPEN p_org_name_res FOR v_sql;
    END get_organization_list;
    -- SPRF_3.1_16f (TT#1001)
    PROCEDURE get_persons_list( p_per_name_res OUT type_per_name ) IS
        v_sql   VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_per_name_res%ISOPEN THEN
            CLOSE p_per_name_res;
        END IF;
        -- define the basic query
        v_sql :=
            'SELECT  per.lname
              ,      per.fname
              ,      per.per_idseq
              ,      per.org_idseq
              FROM persons_view per
              ORDER BY UPPER(per.lname)
              ,        UPPER(per.fname)';
        OPEN p_per_name_res FOR v_sql;
    END get_persons_list;
    -- SPRF_3.1_16g (TT#1001)
    PROCEDURE get_comm_type_list( p_comm_type_res OUT type_comm_type ) IS
        v_sql   VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_comm_type_res%ISOPEN THEN
            CLOSE p_comm_type_res;
        END IF;
        -- define the basic query
        v_sql :=
            'SELECT ctlv.ctl_name
              ,      ctlv.comments
              FROM comm_types_lov_view ctlv
              ORDER BY UPPER(ctlv.ctl_name)';
        OPEN p_comm_type_res FOR v_sql;
    END get_comm_type_list;
    -- SPRF_3.1_16h (TT#1001)
    PROCEDURE get_addr_type_list( p_addr_type_res OUT type_addr_type ) IS
        v_sql   VARCHAR2( 4000 ) := NULL;
    BEGIN
        IF p_addr_type_res%ISOPEN THEN
            CLOSE p_addr_type_res;
        END IF;
        -- define the basic query
        v_sql :=
            'SELECT atlv.atl_name
              ,      atlv.description
              FROM addr_types_lov_view atlv
              ORDER BY UPPER(atlv.atl_name)';
        OPEN p_addr_type_res FOR v_sql;
    END get_addr_type_list;

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
