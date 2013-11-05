/*L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L*/

--run with user SBR
--https://system-requests-test.nci.nih.gov:7443/jira/browse/TASKMGT-4655

DROP VIEW DE_EXCEL_GENERATOR_VIEW;

drop view DE_XML_GENERATOR_VIEW;

DROP TYPE CDEBROWSER_VD_T;

DROP TYPE VALID_VALUE_LIST_T2;

DROP TYPE VALID_VALUE_T2;

CREATE OR REPLACE
TYPE          "VM_DEF_T"                                          AS OBJECT
("Definition"	    VARCHAR2 (4000)
);
/

CREATE OR REPLACE
TYPE          "VM_DEF_LIST_T" AS TABLE OF VM_DEF_T;
/

CREATE OR REPLACE
TYPE          "VALID_VALUE_T2"                                          AS OBJECT(
    ValidValue VARCHAR2(255),
    ValueMeaning VARCHAR2(255),
    MeaningDescription VARCHAR2(2000),
    MeaningConcepts VARCHAR2(2000),
    PvBeginDate DATE,
    PvEndDate DATE,
    VmPublicId NUMBER,
    VmVersion NUMBER(4,2),
	vm_alt_defs VM_DEF_LIST_T );
/

CREATE OR REPLACE
TYPE          "VALID_VALUE_LIST_T2"                                          AS TABLE OF VALID_VALUE_T2;
/

CREATE OR REPLACE
TYPE          "CDEBROWSER_VD_T"                                          AS OBJECT
( "PublicId"         NUMBER,
  "PreferredName"          VARCHAR2 (30),
  "PreferredDefinition"    VARCHAR2 (2000),
  "LongName"      VARCHAR2(255),
  "Version"                NUMBER (4,2),
  "WorkflowStatus"         VARCHAR2 (20),
  "ContextName"         VARCHAR2 (30),
  "ContextVersion"     NUMBER (4,2),
  "ConceptualDomain"    admin_component_with_id_ln_t,
  "Datatype"               VARCHAR2 (20),
  "ValueDomainType"        VARCHAR2 (50),
  "UnitOfMeasure"          VARCHAR2 (20),
  "DisplayFormat"          VARCHAR2 (20),
  "MaximumLength"          NUMBER (8),
  "MinimumLength"          NUMBER (8),
  "DecimalPlace"           NUMBER (2),
  "CharacterSetName"       VARCHAR2 (20),
  "MaximumValue"           VARCHAR2 (255),
  "MinimumValue"           VARCHAR2 (255),
  "Origin"    VARCHAR2(240),
  "Representation"    admin_component_with_con_t,
  "PermissibleValues"    valid_value_list_t2,
  "ValueDomainConcepts"    Concepts_list_t
);
/


CREATE OR REPLACE VIEW DE_EXCEL_GENERATOR_VIEW
(DE_IDSEQ, CDE_ID, LONG_NAME, PREFERRED_NAME, DOC_TEXT, 
 PREFERRED_DEFINITION, VERSION, ORIGIN, BEGIN_DATE, DE_CONTE_NAME, 
 DE_CONTE_VERSION, DEC_ID, DEC_PREFERRED_NAME, DEC_VERSION, DEC_CONTE_NAME, 
 DEC_CONTE_VERSION, VD_ID, VD_PREFERRED_NAME, VD_VERSION, VD_CONTE_NAME, 
 VD_CONTE_VERSION, VD_TYPE, DTL_NAME, MAX_LENGTH_NUM, MIN_LENGTH_NUM, 
 HIGH_VALUE_NUM, LOW_VALUE_NUM, DECIMAL_PLACE, FORML_NAME, VD_LONG_NAME, 
 CD_ID, CD_PREFERRED_NAME, CD_VERSION, CD_CONTE_NAME, OC_ID, 
 OC_PREFERRED_NAME, OC_LONG_NAME, OC_VERSION, OC_CONTE_NAME, PROP_ID, 
 PROP_PREFERRED_NAME, PROP_LONG_NAME, PROP_VERSION, PROP_CONTE_NAME, DEC_LONG_NAME, 
 DE_WK_FLOW_STATUS, REGISTRATION_STATUS, VALID_VALUES, REFERENCE_DOCS, CLASSIFICATIONS, 
 DESIGNATIONS, DE_DERIVATION, VD_CONCEPTS, OC_CONCEPTS, PROP_CONCEPTS, 
 REP_ID, REP_PREFERRED_NAME, REP_LONG_NAME, REP_VERSION, REP_CONTE_NAME, 
 REP_CONCEPTS)
AS 
SELECT    de.de_idseq 
	 	 ,de.cde_id 
         ,de.long_name 
         ,de.preferred_name 
		 ,rd.doc_text 
		 ,de.preferred_definition 
		 ,de.VERSION 
		 ,de.origin 
		 ,de.begin_date 
		 ,de_conte.NAME de_conte_name 
		 ,de_conte.VERSION de_conte_version 
		 ,DEC.dec_id 
		 ,DEC.preferred_name dec_preferred_name 
		 ,DEC.VERSION dec_version 
		 ,dec_conte.NAME dec_conte_name 
		 ,dec_conte.VERSION dec_conte_version 
		 ,vd.vd_id 
		 ,vd.preferred_name vd_preferred_name 
		 ,vd.VERSION vd_version 
		 ,vd_conte.NAME vd_conte_name 
		 ,vd_conte.VERSION vd_conte_version 
		 ,DECODE (vd.vd_type_flag,'E','Enumerated','N','Non Enumerated','Unknown') vd_type 
		 ,vd.dtl_name 
		 ,vd.max_length_num 
		 ,vd.min_length_num 
		 ,vd.high_value_num 
		 ,vd.low_value_num 
		 ,vd.DECIMAL_PLACE 
		 ,vd.FORML_NAME 
		 ,vd.LONG_NAME vd_long_name 
		 ,cd.cd_id 
		 ,cd.preferred_name cd_preferred_name 
		 ,cd.VERSION cd_version 
		 ,cd_conte.NAME cd_conte_name 
		 ,oc.oc_id 
		 ,oc.preferred_name oc_preferred_name 
		 ,oc.long_name oc_long_name 
		 ,oc.VERSION oc_version 
		 ,oc_conte.NAME oc_conte_name 
		 ,prop.prop_id 
		 ,prop.preferred_name prop_preferred_name 
		 ,prop.long_name prop_long_name 
		 ,prop.VERSION prop_version 
		 ,prop_conte.NAME prop_conte_name 
		 ,DEC.LONG_NAME dec_long_name 
		 ,de.ASL_NAME de_wk_flow_status 
		 ,acr.registration_status 
		 ,CAST(MULTISET( 
	     	               SELECT pv.VALUE 
			      ,vm.long_name short_meaning 
			      ,vm.preferred_definition 
			      ,Sbrext_Common_Routines.get_concepts(vm.condr_idseq) MeaningConcepts 
			      ,pv.begin_date 
			      ,pv.end_date 
			      ,vm.vm_id 
			      ,vm.VERSION, 
			 CAST(MULTISET (SELECT def.DEFINITION AS "Definition" 
			 				  		  FROM definitions def 
									  WHERE def.AC_IDSEQ = vm.VM_IDSEQ 
			 )AS vm_def_list_t) vv_definitions 
			FROM  sbr.permissible_values pv, sbr.vd_pvs vp, value_meanings vm 
			WHERE vp.vd_idseq = vd.vd_idseq 
			AND   vp.pv_idseq = pv.pv_idseq 
			AND   pv.vm_idseq = vm.vm_idseq 
	   		) AS valid_value_list_t2) valid_values 
               ,CAST(MULTISET( 
                               SELECT rd.NAME 
				      ,org.NAME 
				      ,rd.DCTL_NAME 
				      ,rd.doc_text 
				      ,rd.URL 
				      ,rd.lae_name 
				      ,rd.display_order 
				FROM  sbr.reference_documents rd, sbr.organizations org 
				WHERE de.de_idseq = rd.ac_idseq (+) 
				AND   rd.ORG_IDSEQ = org.ORG_IDSEQ (+) 
				) AS cdebrowser_rd_list_t) reference_docs 
		,CAST(MULTISET( 
                 		SELECT admin_component_with_id_t(csv.cs_id 
							   	,csv.cs_context_name 
						         	,csv.cs_context_version 
							 	,csv.preferred_name 
							 	,csv.VERSION) 
							 	,csv.csi_name 
							 	,csv.csitl_name 
							 	,csv.csi_id 
							 	,csv.csi_version 
				FROM  sbrext.cdebrowser_cs_view csv 
				WHERE de.de_idseq = csv.ac_idseq 
				) AS cdebrowser_csi_list_t) classifications 
                ,CAST(MULTISET( 
                                     SELECT des_conte.NAME 
				      ,des_conte.VERSION 
					  ,des.NAME 
					  ,des.DETL_NAME 
					  ,des.LAE_NAME 
				FROM  sbr.designations des,sbr.contexts des_conte 
				WHERE de.de_idseq = des.AC_IDSEQ (+) 
				AND   des.conte_idseq = des_conte.conte_idseq (+) 
				) AS DESIGNATIONS_LIST_T) designations 
		,derived_data_element_t (ccd.crtl_name 
				                 ,ccd.description 
					             ,ccd.methods 
					             ,ccd.RULE 
					             ,ccd.concat_char 
					             ,"DataElementsList") DE_DERIVATION 
                ,CAST(MULTISET( 
                      SELECT con.preferred_name 
		       ,con.long_name 
		       ,con.con_id 
		       ,con.definition_source 
		       ,con. origin 
                       ,con.evs_Source 
                       ,com.primary_flag_ind 
                       ,com.display_order 
		      FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
				WHERE vd.condr_idseq = com.condr_IDSEQ (+) 
				AND   com.con_idseq = con.con_idseq (+) 
				ORDER BY display_order DESC) AS Concepts_list_t) vd_concepts 
        ,CAST(MULTISET( 
                SELECT con.preferred_name 
		       ,con.long_name 
		       ,con.con_id 
		       ,con.definition_source 
		       ,con. origin 
                       ,con.evs_Source 
                       ,com.primary_flag_ind 
                       ,com.display_order 
		      FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
				WHERE oc.condr_idseq = com.condr_IDSEQ (+) 
				AND   com.con_idseq = con.con_idseq (+) 
				ORDER BY display_order DESC) AS Concepts_list_t) oc_concepts 
        ,CAST(MULTISET( 
                SELECT con.preferred_name 
		       ,con.long_name 
		       ,con.con_id 
		       ,con.definition_source 
		       ,con. origin 
                       ,con.evs_Source 
                       ,com.primary_flag_ind 
                       ,com.display_order 
		      FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
				WHERE prop.condr_idseq = com.condr_IDSEQ (+) 
				AND   com.con_idseq = con.con_idseq (+) 
				ORDER BY display_order DESC) AS Concepts_list_t) prop_concepts 
		 ,rep.rep_id 
		 ,rep.preferred_name rep_preferred_name 
		 ,rep.long_name rep_long_name 
		 ,rep.VERSION rep_version 
		 ,rep_conte.NAME rep_conte_name 
        ,CAST(MULTISET( 
                SELECT con.preferred_name 
		       ,con.long_name 
		       ,con.con_id 
		       ,con.definition_source 
		       ,con. origin 
                       ,con.evs_Source 
                       ,com.primary_flag_ind 
                       ,com.display_order 
		      FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
				WHERE rep.condr_idseq = com.condr_IDSEQ (+) 
				AND   com.con_idseq = con.con_idseq (+) 
				ORDER BY display_order DESC) AS Concepts_list_t) rep_concepts 
FROM	 sbr.data_elements de 
  		,sbr.data_element_concepts DEC 
		,sbr.contexts de_conte 
		,sbr.value_domains vd 
		,sbr.contexts vd_conte 
		,sbr.contexts dec_conte 
		,sbr.ac_registrations acr 
		,cdebrowser_complex_de_view ccd 
                ,conceptual_domains cd 
                ,contexts cd_conte 
                ,OBJECT_CLASSES_EXT oc 
                ,contexts oc_conte 
                ,PROPERTIES_EXT prop 
                ,REPRESENTATIONS_EXT rep 
                ,contexts prop_conte 
                ,contexts rep_conte 
               ,(SELECT ac_idseq,doc_text 
                  FROM reference_documents 
                  WHERE dctl_name = 'Preferred Question Text') rd 
  WHERE  de.dec_idseq = DEC.dec_idseq 
  AND	 de.conte_idseq = de_conte.conte_idseq 
  AND	 de.vd_idseq = vd.vd_idseq 
  AND    vd.conte_idseq = vd_conte.conte_idseq 
  AND	 DEC.conte_idseq = dec_conte.conte_idseq 
  AND	 de.de_idseq = rd.ac_idseq (+) 
  AND    de.de_idseq = acr.ac_idseq (+) 
  AND    de.de_idseq = ccd.p_de_idseq (+) 
  AND    vd.cd_idseq = cd.cd_idseq 
  AND    cd.conte_idseq = cd_conte.conte_idseq 
  AND    DEC.oc_idseq = oc.oc_idseq(+) 
  AND    oc.conte_idseq = oc_conte.conte_idseq(+) 
  AND    DEC.prop_idseq = prop.prop_idseq(+) 
  AND    prop.conte_idseq = prop_conte.conte_idseq(+) 
  AND    vd.rep_idseq = rep.rep_idseq(+) 
  AND    rep.conte_idseq = rep_conte.conte_idseq(+)
/






CREATE OR REPLACE VIEW DE_XML_GENERATOR_VIEW
(DE_IDSEQ, PUBLICID, LONGNAME, PREFERREDNAME, PREFERREDDEFINITION, 
 VERSION, WORKFLOWSTATUS, CONTEXTNAME, CONTEXTVERSION, ORIGIN, 
 REGISTRATIONSTATUS, DATAELEMENTCONCEPT, VALUEDOMAIN, REFERENCEDOCUMENTSLIST, CLASSIFICATIONSLIST, 
 ALTERNATENAMELIST, DATAELEMENTDERIVATION)
AS 
SELECT 
         de.de_idseq 
	 	 ,de.CDE_ID "PublicId" 
         ,de.long_name "LongName" 
         ,de.preferred_name "PreferredName" 
		 ,de.preferred_definition "PreferredDefinition" 
		 ,de.VERSION "Version" 
		 ,de.ASL_NAME "WorkflowStatus" 
		 ,de_conte.NAME "ContextName" 
		 ,de_conte.VERSION "ContextVersion" 
		 ,de.origin "Origin" 
		 ,ar.registration_status "RegistrationStatus" 
		 ,cdebrowser_dec_t( DEC.dec_id 
		 		    ,DEC.dec_preferred_name 
		 		    ,DEC.PREFERRED_DEFINITION 
				    ,DEC.dec_long_name 
		 		    ,DEC.dec_version 
				    ,DEC.ASL_NAME 
				    ,DEC.dec_context_name 
				    ,DEC.dec_context_version 
				    ,admin_component_with_id_ln_t(DEC.cd_id 
						   		               ,DEC.cd_context_name 
						                       ,DEC.cd_context_version 
								               ,DEC.cd_preferred_name 
								               ,DEC.cd_version 
                                               ,DEC.cd_long_name) 
				    ,admin_component_with_con_t(DEC.oc_id 
						   	                   ,DEC.oc_context_name 
						                       ,DEC.oc_context_version 
							                   ,DEC.oc_preferred_name 
							                   ,DEC.oc_version 
                                               ,DEC.oc_long_name 
                                               ,CAST(MULTISET( 
                                                              SELECT con.preferred_name 
                                                              ,con.long_name 
                                                              ,con.con_id 
                                                              ,con.definition_source 
                                                              ,con. origin 
                                                              ,con.evs_Source 
                                                              ,com.primary_flag_ind 
                                                              ,com.display_order 
                                                              FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
                                                              WHERE  DEC.oc_condr_idseq = com.condr_IDSEQ (+) 
                                                              AND   com.con_idseq = con.con_idseq (+) 
                                                              ORDER BY display_order DESC) AS Concepts_list_t)) 
				       ,admin_component_with_con_t( DEC.prop_id 
						   	                   ,DEC.pt_context_name 
						                       ,DEC.pt_context_version 
							                   ,DEC.pt_preferred_name 
							                   ,DEC.pt_version 
                                               ,DEC.pt_long_name 
                                               ,CAST(MULTISET( 
                                                              SELECT con.preferred_name 
                                                              ,con.long_name 
                                                              ,con.con_id 
                                                              ,con.definition_source 
                                                              ,con. origin 
                                                              ,con.evs_Source 
                                                              ,com.primary_flag_ind 
                                                              ,com.display_order 
                                                              FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
                                                              WHERE  DEC.prop_condr_idseq = com.condr_IDSEQ (+) 
                                                              AND   com.con_idseq = con.con_idseq (+) 
                                                              ORDER BY display_order DESC) AS Concepts_list_t)) 
				                                 ,DEC.obj_class_qualifier 
	  			                                 ,DEC.property_qualifier 
						                         ,DEC.dec_origin) "DataElementConcept" 
		 ,cdebrowser_vd_t(vd.vd_id 
		 				,vd.preferred_name 
		 				,vd.preferred_definition 
						,vd.long_name 
						,vd.VERSION 
						,vd.asl_name 
						,vd_conte.NAME 
						,vd_conte.VERSION 
						,admin_component_with_id_ln_T(cd.cd_id 
									,cd_conte.NAME 
						            ,cd_conte.VERSION 
								  	,cd.preferred_name 
								  	,cd.VERSION 
                                    ,cd.long_name) 
						,vd.dtl_name 
						,DECODE(vd.vd_type_flag,'E','Enumerated','N','NonEnumerated') 
						,vd.uoml_name 
						,vd.forml_name 
						,vd.max_length_num 
						,vd.min_length_num 
						,vd.decimal_place 
						,vd.char_set_name 
						,vd.high_value_num 
						,vd.low_value_num 
						,vd.origin 
                                                ,admin_component_with_con_t(rep.rep_id 
						   	                   ,rep_conte.NAME 
						                       ,rep_conte.VERSION 
							                   ,rep.preferred_name 
							                   ,rep.VERSION 
                                               ,rep.long_name 
                                               ,CAST(MULTISET( 
                                                              SELECT con.preferred_name 
                                                              ,con.long_name 
                                                              ,con.con_id 
                                                              ,con.definition_source 
                                                              ,con. origin 
                                                              ,con.evs_Source 
                                                              ,com.primary_flag_ind 
                                                              ,com.display_order 
                                                              FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
                                                              WHERE  rep.condr_idseq = com.condr_IDSEQ (+) 
                                                              AND   com.con_idseq = con.con_idseq (+) 
                                                              ORDER BY display_order DESC) AS Concepts_list_t)) 
						,CAST(MULTISET( 
	                 			SELECT pv.VALUE 
						      ,pv.short_meaning 
			                  ,vm.preferred_definition 
			                  ,Sbrext_Common_Routines.get_concepts(vm.condr_idseq) MeaningConcepts 
			                  ,pv.begin_date 
			                  ,pv.end_date 
			                  ,vm.vm_id 
			                  ,vm.VERSION, 
							  			 CAST(MULTISET (SELECT def.DEFINITION AS "Definition" 
			 				  		  FROM definitions def 
									  WHERE def.AC_IDSEQ = vm.VM_IDSEQ 
			 )AS vm_def_list_t) vv_definitions 
						FROM  sbr.permissible_values pv, sbr.vd_pvs vp, value_meanings vm 
					 	WHERE vp.vd_idseq = vd.vd_idseq 
						AND   vp.pv_idseq = pv.pv_idseq 
						AND pv.vm_idseq = vm.vm_idseq 
	   					) AS valid_value_list_t2) 
                                             ,CAST(MULTISET( 
                                        SELECT con.preferred_name 
		                               ,con.long_name 
		                               ,con.con_id 
		                               ,con.definition_source 
		                               ,con. origin 
                                        ,con.evs_Source 
                                                         ,com.primary_flag_ind 
                                                         ,com.display_order 
		                                         FROM  COMPONENT_CONCEPTS_EXT com,CONCEPTS_EXT con 
				                         WHERE vd.condr_idseq = com.condr_IDSEQ (+) 
				                         AND   com.con_idseq = con.con_idseq (+) 
				                         ORDER BY display_order DESC) AS Concepts_list_t) 
				  ) "ValueDomain" 
		,CAST(MULTISET( 
                 		SELECT rd.NAME 
				      ,org.NAME 
				      ,rd.DCTL_NAME 
				      ,rd.doc_text 
				      ,rd.URL 
				      ,rd.lae_name 
				      ,rd.display_order 
				FROM  sbr.reference_documents rd, sbr.organizations org 
				WHERE de.de_idseq = rd.ac_idseq 
				AND   rd.ORG_IDSEQ = org.ORG_IDSEQ (+) 
				) AS cdebrowser_rd_list_t) "ReferenceDocumentsList" 
		,CAST(MULTISET( 
                 		SELECT admin_component_with_id_t(csv.cs_id 
							   							,csv.cs_context_name 
						         						,csv.cs_context_version 
							 							,csv.preferred_name 
							 							,csv.VERSION) 
							 							,csv.csi_name 
							 							,csv.csitl_name 
							 							,csv.csi_id 
							 							,csv.csi_version 
				FROM  sbrext.cdebrowser_cs_view csv 
				WHERE de.de_idseq = csv.ac_idseq 
				) AS cdebrowser_csi_list_t) "ClassificationsList" 
		,CAST(MULTISET( 
                SELECT des_conte.NAME 
				      ,des_conte.VERSION 
					  ,des.NAME 
					  ,des.detl_name 
					  ,des.lae_name 
				FROM  sbr.designations des,sbr.contexts des_conte 
				WHERE de.de_idseq = des.AC_IDSEQ (+) 
				AND   des.conte_idseq = des_conte.conte_idseq (+) 
				) AS cdebrowser_altname_list_t) "AlternateNameList" 
		 ,derived_data_element_t (ccd.crtl_name 
				                 ,ccd.description 
					             ,ccd.methods 
					             ,ccd.RULE 
					             ,ccd.concat_char 
					             ,"DataElementsList") "DataElementDerivation" 
FROM	 sbr.data_elements de 
  		,sbrext.cdebrowser_de_dec_view DEC 
		,sbr.contexts de_conte 
		,sbr.value_domains vd 
		,sbr.contexts vd_conte 
		,sbr.contexts cd_conte 
		,sbr.conceptual_domains cd 
		,sbr.ac_registrations ar 
		,cdebrowser_complex_de_view ccd 
                ,sbrext.REPRESENTATIONS_EXT rep 
		,sbr.contexts rep_conte 
  WHERE  de.de_idseq = DEC.de_idseq 
  AND	 de.conte_idseq = de_conte.conte_idseq 
  AND	 de.vd_idseq = vd.vd_idseq 
  AND    vd.conte_idseq = vd_conte.conte_idseq 
  AND	 vd.cd_idseq = cd.cd_idseq 
  AND    cd.conte_idseq = cd_conte.conte_idseq 
  AND    de.de_idseq = ar.ac_idseq (+) 
  AND    de.de_idseq = ccd.p_de_idseq (+) 
  AND    vd.rep_idseq = rep.rep_idseq(+) 
  AND    rep.conte_idseq = rep_conte.conte_idseq(+)
/

GRANT EXECUTE, DEBUG ON SBREXT.VALID_VALUE_T2 TO CDEBROWSER;
GRANT EXECUTE, DEBUG ON SBREXT.VM_DEF_T TO CDEBROWSER;
GRANT EXECUTE, DEBUG ON SBREXT.VALID_VALUE_LIST_T2 TO CDEBROWSER;
GRANT EXECUTE, DEBUG ON SBREXT.VM_DEF_LIST_T TO CDEBROWSER;
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_VD_T TO CDEBROWSER;
GRANT ALL ON SBREXT.DE_EXCEL_GENERATOR_VIEW TO CDEBROWSER;
GRANT ALL ON SBREXT.DE_XML_GENERATOR_VIEW TO CDEBROWSER;

delete from tool_options_ext where tool_name='CDEBrowser' and property='RELEASE_NOTES_WIKI';

insert into tool_options_ext (tool_name, property, value) values ('CDEBrowser', 'RELEASE_NOTES_WIKI', 'https://wiki.nci.nih.gov/x/DydhAg');

UPDATE TOOL_OPTIONS_EXT SET VALUE = 'https://wiki.nci.nih.gov/x/oiBhAg' WHERE tool_name='CDEBrowser' AND property = 'HELP.ROOT'

commit;