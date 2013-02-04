SET DEFINE OFF;

update SBREXT.TOOL_OPTIONS_EXT t set VALUE =    ('CDE_IDSEQ,DEC_IDSEQ,VD_IDSEQ,Conceptual Domain Public ID,Conceptual Domain Short Name,Conceptual Domain Version,Conceptual Domain Context Name,Classification Scheme Public ID,DDE Methods,Representation Concept Origin,Value Domain Concept Origin,Property Concept Origin,Object Class Concept Origin,Derivation Type Description,DDE Preferred Name,DDE Preferred Definition,Document Organization')
where t.tool_name = 'CURATION' and T.PROPERTY = 'CUSTOM.COLUMN.EXCLUDED';

DROP TABLE SBREXT.CUSTOM_DOWNLOAD_TYPES CASCADE CONSTRAINTS;

CREATE TABLE SBREXT.CUSTOM_DOWNLOAD_TYPES
(
  TYPE_NAME         VARCHAR2(255 BYTE),
  COLUMN_INDEX      NUMBER,
  DISPLAY_NAME      VARCHAR2(255 BYTE),
  DISPLAY_TYPE      VARCHAR2(255 BYTE),
  DISPLAY_COLUMN_INDEX  NUMBER
);

GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CUSTOM_DOWNLOAD_TYPES TO DER_USER;

--
--SQL Statement which produced this data:
--  SELECT 
--     ROWID, C.TYPE_NAME, C.COLUMN_INDEX, C.DISPLAY_NAME, 
--     C.DISPLAY_TYPE, C.DISPLAY_COLUMN_INDEX
--  FROM SBREXT.CUSTOM_DOWNLOAD_TYPES C
--
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 1, 'Code', 'String', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 2, 'Name', 'String', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 3, 'Public ID', 'Number', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 4, 'Definition Source', 'String', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 5, 'Origin', 'String', 5);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 6, 'EVS Source', 'String', 6);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_rd_list_t', 2, 'Document Organization', 'String', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 5, 'Classification Scheme Version', 'Number', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 2, 'Derivation Type Description', 'Struct', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 8, 'DDE Preferred Name', 'Struct', 8);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 9, 'DDE Preferred Definition', 'Struct', 9);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('designations_list_t', 1, 'Alternate Name Context Name', 'String', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('designations_list_t', 2, 'Alternate Name Context Version', 'Number', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('designations_list_t', 3, 'Alternate Name', 'String', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('designations_list_t', 4, 'Alternate Name Type', 'String', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_rd_list_t', 1, 'Document Name', 'String', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_rd_list_t', 3, 'Document Type', 'String', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_rd_list_t', 4, 'Document', 'String', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 5, 'Concatenation Character', 'Struct', 5);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 2, 'Classification Scheme Context Name', 'String', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 4, 'Classification Scheme Short Name', 'Number', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 1, 'Classification Scheme Public ID', 'String', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 3, 'Classification Scheme Context Version', 'Number', 5);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 6, 'Classification Scheme Item Name', 'String', 6);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 7, 'Classification Scheme Item Type Name', 'String', 7);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 8, 'Classification Scheme Item Public Id', 'Number', 8);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('cdebrowser_csi_list_t', 9, 'Classification Scheme Item Version', 'Number', 9);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 1, 'Derivation Type', 'Struct', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 3, 'Derivation Method', 'Struct', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 4, 'Derivation Rule', 'Struct', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 6, 'DDE Public ID', 'Struct', 6);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 7, 'DDE Long Name', 'Struct', 7);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 10, 'DDE Version', 'Struct', 10);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 11, 'DDE Workflow Status', 'Struct', 11);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('derived_data_element_t', 12, 'DDE Context', 'Struct', 12);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE)
 Values
   ('derived_data_element_t', 13, 'DDE Display Order', 'Struct');
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 2, 'Value Meaning Name', 'String', 2);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 3, 'Value Meaning Description', 'String', 3);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 4, 'Value Meaning Concepts', 'String', 4);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 5, 'PV Begin Date', 'Date', 5);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 6, 'PV End Date', 'Date', 6);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 7, 'Value Meaning PublicID', 'Number', 7);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 8, 'Value Meaning Version', 'Number', 8);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('valid_value_list_t', 1, 'Valid Values', 'String', 1);
Insert into SBREXT.CUSTOM_DOWNLOAD_TYPES
   (TYPE_NAME, COLUMN_INDEX, DISPLAY_NAME, DISPLAY_TYPE, DISPLAY_COLUMN_INDEX)
 Values
   ('concepts_list_t', 7, 'Primary Flag', 'String', 7);

/* Formatted on 5/11/2011 4:39:16 PM (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW SBREXT.cde_excel_generator_view (
   cde_idseq,
   "DE Short Name",
   "DE Long Name",
   "DE Preferred Question Text",
   "DE Preferred Definition",
   "DE Version",
   "DE Context Name",
   "DE Context Version",
   "DE Public ID",
   "DE Workflow Status",
   "DE Registration Status",
   "DE Begin Date",
   "DE Source",
   "DEC Public ID",
   "DEC Short Name",
   "DEC Long Name",
   "DEC Version",
   "DEC Context Name",
   "DEC Context Version",
   "OC Public ID",
   "OC Long Name",
   "OC Short Name",
   "OC Context Name",
   "OC Version",
   oc_concepts,
   "Property Public ID",
   "Property Long Name",
   "Property Short Name",
   "Property Context Name",
   "Property Version",
   prop_concepts,
   "VD Public ID",
   "VD Short Name",
   "VD Long Name",
   "VD Version",
   "VD Context Name",
   "VD Context Version",
   "VD Type",
   "VD Datatype",
   "VD Min Length",
   "VD Max Length",
   "VD Min value",
   "VD Max Value",
   "VD Decimal Place",
   "VD Format",
   vd_concepts,
   "Representation Public ID",
   "Representation Long Name",
   "Representation Short Name",
   "Representation Context Name",
   "Representation Version",
   rep_concepts,
   valid_values,
   classifications,
   designations,
   reference_docs,
   de_derivation,
   "CD Public ID",
   "CD Short Name",
   "CD Version",
   "CD Context Name"
   )
AS
   SELECT de.de_idseq cde_idseq,
          de.preferred_name,
          de.long_name,
          rd.doc_text,
          de.preferred_definition,
          de.version,
          de_conte.name de_conte_name,
          de_conte.version de_conte_version,
          de.cde_id,
          de.asl_name de_wk_flow_status,
          acr.registration_status,
          de.begin_date,
          de.origin,
          dec.dec_id,
          dec.preferred_name dec_preferred_name,
          dec.long_name dec_long_name,
          dec.version dec_version,
          dec_conte.name dec_conte_name,
          dec_conte.version dec_conte_version,
          oc.oc_id,
          oc.long_name oc_long_name,
          oc.preferred_name oc_preferred_name,
          oc_conte.name oc_conte_name,
          oc.version oc_version,
          CAST (MULTISET (SELECT con.preferred_name,
                                 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE oc.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             oc_concepts,
          prop.prop_id,
          prop.long_name prop_long_name,
          prop.preferred_name prop_preferred_name,
          prop_conte.name prop_conte_name,
          prop.version prop_version,
          CAST (MULTISET (SELECT con.preferred_name,
                                 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE prop.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             prop_concepts,
          vd.vd_id,
          vd.preferred_name vd_preferred_name,
          vd.long_name vd_long_name,
          vd.version vd_version,
          vd_conte.name vd_conte_name,
          vd_conte.version vd_conte_version,
          DECODE (vd.vd_type_flag,
             'E', 'Enumerated',
             'N', 'Non Enumerated',
             'Unknown')
             vd_type,
          vd.dtl_name,
          vd.min_length_num,
          vd.max_length_num,
          vd.low_value_num,
          vd.high_value_num,
          vd.decimal_place,
          vd.forml_name,
          CAST (MULTISET (SELECT con.preferred_name,
                                 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE vd.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             vd_concepts,
          rep.rep_id,
          rep.long_name rep_long_name,
          rep.preferred_name rep_preferred_name,
          rep_conte.name rep_conte_name,
          rep.version rep_version,
          CAST (MULTISET (SELECT con.preferred_name,
                                 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE rep.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             rep_concepts,
          CAST (MULTISET (SELECT pv.VALUE,
                                 vm.long_name short_meaning,
                                 vm.preferred_definition,
                                 sbrext_common_routines.get_concepts(vm.condr_idseq)
                                    meaningconcepts,
                                 pv.begin_date,
                                 pv.end_date,
                                 vm.vm_id,
                                 vm.version
                          FROM sbr.permissible_values pv,
                               sbr.vd_pvs vp,
                               value_meanings vm
                          WHERE     vp.vd_idseq = vd.vd_idseq
                                AND vp.pv_idseq = pv.pv_idseq
                                AND pv.vm_idseq = vm.vm_idseq
                ) AS valid_value_list_t
          )
             valid_values,
          CAST (MULTISET (SELECT admin_component_with_id_t (csv.cs_id,
                                                            csv.cs_context_name,
                                                            csv.cs_context_version,
                                                            csv.preferred_name,
                                                            csv.version
                                 ),
                                 csv.csi_name,
                                 csv.csitl_name,
                                 csv.csi_id,
                                 csv.csi_version
                          FROM sbrext.cdebrowser_cs_view csv
                          WHERE de.de_idseq = csv.ac_idseq
                ) AS cdebrowser_csi_list_t
          )
             classifications,
          CAST (MULTISET (SELECT des_conte.name,
                                 des_conte.version,
                                 des.name,
                                 des.detl_name,
                                 des.lae_name
                          FROM sbr.designations des, sbr.contexts des_conte
                          WHERE de.de_idseq = des.ac_idseq(+)
                                AND des.conte_idseq = des_conte.conte_idseq(+)
                ) AS designations_list_t
          )
             designations,
          CAST (MULTISET (SELECT rd.name,
                                 org.name,
                                 rd.dctl_name,
                                 rd.doc_text,
                                 rd.url,
                                 rd.lae_name,
                                 rd.display_order
                          FROM sbr.reference_documents rd,
                               sbr.organizations org
                          WHERE de.de_idseq = rd.ac_idseq(+)
                                AND rd.org_idseq = org.org_idseq(+)
                ) AS cdebrowser_rd_list_t
          )
             reference_docs,
          derived_data_element_t (ccd.crtl_name,
                                  ccd.description,
                                  ccd.methods,
                                  ccd.rule,
                                  ccd.concat_char,
                                  "DataElementsList"
          )
             de_derivation,
          cd.cd_id,
          cd.preferred_name cd_preferred_name,
          cd.version cd_version,
          cd_conte.name cd_conte_name
   FROM sbr.data_elements de,
        sbr.data_element_concepts dec,
        sbr.contexts de_conte,
        sbr.value_domains vd,
        sbr.contexts vd_conte,
        sbr.contexts dec_conte,
        sbr.ac_registrations acr,
        cdebrowser_complex_de_view ccd,
        conceptual_domains cd,
        contexts cd_conte,
        object_classes_ext oc,
        contexts oc_conte,
        properties_ext prop,
        representations_ext rep,
        contexts prop_conte,
        contexts rep_conte,
        (SELECT ac_idseq, doc_text
         FROM reference_documents
         WHERE dctl_name = 'Preferred Question Text') rd
   WHERE     de.dec_idseq = dec.dec_idseq
         AND de.conte_idseq = de_conte.conte_idseq
         AND de.vd_idseq = vd.vd_idseq
         AND vd.conte_idseq = vd_conte.conte_idseq
         AND dec.conte_idseq = dec_conte.conte_idseq
         AND de.de_idseq = rd.ac_idseq(+)
         AND de.de_idseq = acr.ac_idseq(+)
         AND de.de_idseq = ccd.p_de_idseq(+)
         AND vd.cd_idseq = cd.cd_idseq
         AND cd.conte_idseq = cd_conte.conte_idseq
         AND dec.oc_idseq = oc.oc_idseq(+)
         AND oc.conte_idseq = oc_conte.conte_idseq(+)
         AND dec.prop_idseq = prop.prop_idseq(+)
         AND prop.conte_idseq = prop_conte.conte_idseq(+)
         AND vd.rep_idseq = rep.rep_idseq(+)
         AND rep.conte_idseq = rep_conte.conte_idseq(+);

GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CDE_EXCEL_GENERATOR_VIEW TO CDECURATE;

GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CDE_EXCEL_GENERATOR_VIEW TO DER_USER;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CDE_EXCEL_GENERATOR_VIEW TO SBR WITH GRANT OPTION;

/* Formatted on 5/11/2011 4:40:12 PM (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW SBREXT.dec_excel_generator_view (
   dec_idseq,
   "DEC Public ID",
   "DEC Short Name",
   "DEC Long Name",
   "DEC Version",
   "DEC Context Name",
   "DEC Context Version",  
   "OC Public ID",
   "OC Long Name",
   "OC Short Name",
   "OC Context Name",
   "OC Version",
   oc_concepts,
   "Property Public ID",
   "Property Long Name",
   "Property Short Name",
   "Property Context Name",
   "Property Version",
   prop_concepts,
   classifications,
   designations
   )
AS
   SELECT dec.dec_idseq dec_idseq,
          dec.dec_id,
          dec.preferred_name dec_preferred_name,
          dec.long_name dec_long_name,
          dec.version dec_version,
          dec_conte.name dec_conte_name,
          dec_conte.version dec_conte_version,
          oc.oc_id,
          oc.long_name oc_long_name,
          oc.preferred_name oc_preferred_name,
          oc_conte.name oc_conte_name,
          oc.version oc_version,
          CAST (MULTISET (SELECT con.preferred_name, 
								 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE oc.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             oc_concepts,
          prop.prop_id,
          prop.long_name prop_long_name,
          prop.preferred_name prop_preferred_name,
          prop_conte.name prop_conte_name,
          prop.version prop_version,
          CAST (MULTISET (SELECT con.preferred_name, 
								 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE prop.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             prop_concepts,
          CAST (MULTISET (SELECT admin_component_with_id_t (csv.cs_id,
                                                            csv.cs_context_name,
                                                            csv.cs_context_version,
                                                            csv.preferred_name,
                                                            csv.version
                                 ),
                                 csv.csi_name,
                                 csv.csitl_name,
                                 csv.csi_id,
                                 csv.csi_version
                          FROM sbrext.cdebrowser_cs_view csv
                          WHERE dec.dec_idseq = csv.ac_idseq
                ) AS cdebrowser_csi_list_t
          )
             classifications,
          CAST (MULTISET (SELECT des_conte.name,
                                 des_conte.version,
                                 des.name,
                                 des.detl_name,
                                 des.lae_name
                          FROM sbr.designations des, sbr.contexts des_conte
                          WHERE dec.dec_idseq = des.ac_idseq(+)
                                AND des.conte_idseq = des_conte.conte_idseq(+)
                ) AS designations_list_t
          )
             designations
   FROM sbr.data_element_concepts dec,
        sbr.contexts dec_conte,
        sbr.ac_registrations acr,
        object_classes_ext oc,
        contexts oc_conte,
        properties_ext prop,
        contexts prop_conte
   WHERE     dec.conte_idseq = dec_conte.conte_idseq
         AND dec.dec_idseq = acr.ac_idseq(+)
         AND dec.oc_idseq = oc.oc_idseq(+)
         AND oc.conte_idseq = oc_conte.conte_idseq(+)
         AND dec.prop_idseq = prop.prop_idseq(+)
         AND prop.conte_idseq = prop_conte.conte_idseq(+);


GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.DEC_EXCEL_GENERATOR_VIEW TO CDECURATE;

GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.DEC_EXCEL_GENERATOR_VIEW TO DER_USER;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.DEC_EXCEL_GENERATOR_VIEW TO SBR WITH GRANT OPTION;

/* Formatted on 5/11/2011 4:40:49 PM (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW SBREXT.vd_excel_generator_view (
   vd_idseq,
   "VD Public ID",
   "VD Short Name",
   "VD Long Name",
   "VD Version",
   "VD Context Name",
   "VD Context Version",
   "VD Type",
   "VD Datatype",
   "VD Min Length",
   "VD Max Length",
   "VD Min value",
   "VD Max Value",
   "VD Decimal Place",
   "VD Format",
   vd_concepts,
   "Representation Public ID",
   "Representation Long Name",
   "Representation Short Name",
   "Representation Context Name",
   "Representation Version",
   rep_concepts,
   valid_values,
   classifications,
   designations,
   "CD Public ID",
   "CD Short Name",
   "CD Version",
   "CD Context Name"
   )
AS
   SELECT vd.vd_idseq vd_idseq,
          vd.vd_id,
          vd.preferred_name vd_preferred_name,
          vd.long_name vd_long_name,
          vd.version vd_version,
          vd_conte.name vd_conte_name,
          vd_conte.version vd_conte_version,
          DECODE (vd.vd_type_flag,
             'E', 'Enumerated',
             'N', 'Non Enumerated',
             'Unknown')
             vd_type,
          vd.dtl_name,
          vd.min_length_num,
          vd.max_length_num,
          vd.low_value_num,
          vd.high_value_num,
          vd.decimal_place,
          vd.forml_name,
          CAST (MULTISET (SELECT con.preferred_name,
				 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE vd.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             vd_concepts,
          rep.rep_id,
          rep.long_name rep_long_name,
          rep.preferred_name rep_preferred_name,
          rep_conte.name rep_conte_name,
          rep.version rep_version,
          CAST (MULTISET (SELECT con.preferred_name,
				 con.long_name,
                                 con.con_id,
                                 con.definition_source,
                                 con.origin,
                                 con.evs_source,
                                 com.primary_flag_ind,
                                 com.display_order
                          FROM component_concepts_ext com, concepts_ext con
                          WHERE rep.condr_idseq = com.condr_idseq(+)
                                AND com.con_idseq = con.con_idseq(+)
                          ORDER BY display_order DESC
                ) AS concepts_list_t
          )
             rep_concepts,
          CAST (MULTISET (SELECT pv.VALUE,
                                 vm.long_name short_meaning,
                                 vm.preferred_definition,
                                 sbrext_common_routines.get_concepts(vm.condr_idseq)
                                    meaningconcepts,
                                 pv.begin_date,
                                 pv.end_date,
                                 vm.vm_id,
                                 vm.version
                          FROM sbr.permissible_values pv,
                               sbr.vd_pvs vp,
                               value_meanings vm
                          WHERE     vp.vd_idseq = vd.vd_idseq
                                AND vp.pv_idseq = pv.pv_idseq
                                AND pv.vm_idseq = vm.vm_idseq
                ) AS valid_value_list_t
          )
             valid_values,
          CAST (MULTISET (SELECT admin_component_with_id_t (csv.cs_id,
                                                            csv.cs_context_name,
                                                            csv.cs_context_version,
                                                            csv.preferred_name,
                                                            csv.version
                                 ),
                                 csv.csi_name,
                                 csv.csitl_name,
                                 csv.csi_id,
                                 csv.csi_version
                          FROM sbrext.cdebrowser_cs_view csv
                          WHERE vd.vd_idseq = csv.ac_idseq
                ) AS cdebrowser_csi_list_t
          )
             classifications,
          CAST (MULTISET (SELECT des_conte.name,
                                 des_conte.version,
                                 des.name,
                                 des.detl_name,
                                 des.lae_name
                          FROM sbr.designations des, sbr.contexts des_conte
                          WHERE vd.vd_idseq = des.ac_idseq(+)
                                AND des.conte_idseq = des_conte.conte_idseq(+)
                ) AS designations_list_t
          )
             designations,
          cd.cd_id,
          cd.preferred_name cd_preferred_name,
          cd.version cd_version,
          cd_conte.name cd_conte_name
   FROM sbr.value_domains vd,
        sbr.contexts vd_conte,
        sbr.ac_registrations acr,
        conceptual_domains cd,
        contexts cd_conte,
        representations_ext rep,
        contexts rep_conte
   WHERE     vd.conte_idseq = vd_conte.conte_idseq
         AND vd.vd_idseq = acr.ac_idseq(+)
         AND vd.cd_idseq = cd.cd_idseq
         AND cd.conte_idseq = cd_conte.conte_idseq
         AND vd.rep_idseq = rep.rep_idseq(+)
         AND rep.conte_idseq = rep_conte.conte_idseq(+);



GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.VD_EXCEL_GENERATOR_VIEW TO CDECURATE;

GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.VD_EXCEL_GENERATOR_VIEW TO DER_USER;

GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.VD_EXCEL_GENERATOR_VIEW TO SBR WITH GRANT OPTION;



COMMIT;
