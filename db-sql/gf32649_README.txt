/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=32649.
 */

*** APPLYING CHANGES ***

The scripts need to be executed in the correct order for them to work. They are showed as below -

Run with user SBREXT (note: there is no need to run gf32649_SBREXT_GET_ROW_SPEC.sql):

SQL> @gf32649_SBREXT_GET_ROW_BODY.sql
  ALTER TABLE "SBREXT"."AC_ATT_CSCSI_EXT" ADD CONSTRAINT "AAI_AAL_FK" FOREIGN KEY ("ATL_NAME")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."AC_ATT_CSCSI_EXT" ADD CONSTRAINT "AAI_CS_CSI_FK" FOREIGN KEY ("CS_CSI_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."AC_SOURCES_EXT" ADD CONSTRAINT "AST_ACT_FK" FOREIGN KEY ("AC_IDSEQ")
                                                                    *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."ASL_ACTL_EXT" ADD CONSTRAINT "AAT_ASL_FK" FOREIGN KEY ("ASL_NAME")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."ASL_ACTL_EXT" ADD CONSTRAINT "AAT_ATL_FK" FOREIGN KEY ("ACTL_NAME")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CDE_CART_ITEMS" ADD CONSTRAINT "CCM_ACTL_FK" FOREIGN KEY ("ACTL_NAME")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CDE_CART_ITEMS" ADD CONSTRAINT "CCM_AC_FK" FOREIGN KEY ("AC_IDSEQ")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CDE_CART_ITEMS" ADD CONSTRAINT "CCM_UA_FK" FOREIGN KEY ("UA_NAME")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CLASS_SCHEMES_STAGING" ADD CONSTRAINT "CSC_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."COMPONENT_CONCEPTS_EXT" ADD CONSTRAINT "CCT_CET_FK" FOREIGN KEY ("CON_IDSEQ")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."COMPONENT_CONCEPTS_EXT" ADD CONSTRAINT "CCT_CLT_FK" FOREIGN KEY ("CL_IDSEQ")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."COMPONENT_CONCEPTS_EXT" ADD CONSTRAINT "CCT_CONDR_FK" FOREIGN KEY ("CONDR_IDSEQ")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONCEPTS_EXT" ADD CONSTRAINT "CON_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONCEPTS_EXT" ADD CONSTRAINT "CON_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONCEPTUAL_DOMAINS_STAGING" ADD CONSTRAINT "CD_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                               *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_COMPONENTS_EXT" ADD CONSTRAINT "QCT_QCON_FK" FOREIGN KEY ("P_QCON_IDSEQ")
                                                                               *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_COMPONENTS_EXT" ADD CONSTRAINT "QCT_QCON_FK2" FOREIGN KEY ("C_QCON_IDSEQ")
                                                                                *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_COMPONENTS_EXT" ADD CONSTRAINT "QCT_RFT_FK" FOREIGN KEY ("RF_IDSEQ")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_COMPONENTS_EXT" ADD CONSTRAINT "QCT_VVT_FK" FOREIGN KEY ("VV_IDSEQ")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_MESSAGE_EXT" ADD CONSTRAINT "CMT_MTT_FK" FOREIGN KEY ("MT_NAME")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CONDITION_MESSAGE_EXT" ADD CONSTRAINT "CMT_QCON_FK" FOREIGN KEY ("QCON_IDSEQ")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CON_DERIVATION_RULES_EXT" ADD CONSTRAINT "CONDR_CRV_FK" FOREIGN KEY ("CRTL_NAME")
                                                                                *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CRF_TOOL_PARAMETER_EXT" ADD CONSTRAINT "CTP_UAT_FK" FOREIGN KEY ("UA_NAME")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CSIR_STAGING" ADD CONSTRAINT "CSR_CSC_FK" FOREIGN KEY ("CST_ID")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."CSI_STAGING" ADD CONSTRAINT "CST_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."DATA_ELEMENTS_STAGING" ADD CONSTRAINT "DE_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."DATA_ELEMENT_CONCEPTS_STAGING" ADD CONSTRAINT "DEC_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."DECR_STAGING" ADD CONSTRAINT "DCR_DCS_FK" FOREIGN KEY ("DCS_ID")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."DEC_RELATIONSHIPS" ADD CONSTRAINT "DER_DEC_FK" FOREIGN KEY ("DEC_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."DEC_STAGING" ADD CONSTRAINT "DCS_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EATTRIBUTES_STAGING" ADD CONSTRAINT "EAT_ECL_FK" FOREIGN KEY ("ECL_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."ECLASSES_STAGING" ADD CONSTRAINT "ECL_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EREFERENCES_STAGING" ADD CONSTRAINT "ERE_ECL_FK" FOREIGN KEY ("ECL_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."ESUPERTYPES_STAGING" ADD CONSTRAINT "ESU_ECL_FK" FOREIGN KEY ("ECL_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ACCESS_PRIVS" ADD CONSTRAINT "EUL4_AP_EU_FK" FOREIGN KEY ("AP_EU_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ACCESS_PRIVS" ADD CONSTRAINT "EUL4_GBA_BA_FK" FOREIGN KEY ("GBA_BA_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ACCESS_PRIVS" ADD CONSTRAINT "EUL4_GD_DOC_FK" FOREIGN KEY ("GD_DOC_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ACCESS_PRIVS" ADD CONSTRAINT "EUL4_GP_PRI_FK" FOREIGN KEY ("GP_APP_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_CONS" ADD CONSTRAINT "EUL4_AOC_OBJ_FK" FOREIGN KEY ("AOC_OBJ_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_CONS" ADD CONSTRAINT "EUL4_APC_ASMP_FK" FOREIGN KEY ("APC_ASMP_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_CONS" ADD CONSTRAINT "EUL4_ASOC_SUMO_FK" FOREIGN KEY ("ASOC_SUMO_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_CONS" ADD CONSTRAINT "EUL4_AUC_EU_FK" FOREIGN KEY ("AUC_EU_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_LOGS" ADD CONSTRAINT "EUL4_APL_ASMP_FK" FOREIGN KEY ("APL_ASMP_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_ASMP_LOGS" ADD CONSTRAINT "EUL4_APL_SUMO_FK" FOREIGN KEY ("APL_SUMO_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BATCH_PARAMS" ADD CONSTRAINT "EUL4_BP_BS_FK" FOREIGN KEY ("BP_BS_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BATCH_QUERIES" ADD CONSTRAINT "EUL4_BQ_BS_FK" FOREIGN KEY ("BQ_BS_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BATCH_REPORTS" ADD CONSTRAINT "EUL4_BR_EU_FK" FOREIGN KEY ("BR_EU_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BATCH_REPORTS" ADD CONSTRAINT "EUL4_BR_RFU_FK" FOREIGN KEY ("BR_RFU_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BATCH_SHEETS" ADD CONSTRAINT "EUL4_BS_BR_FK" FOREIGN KEY ("BS_BR_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BA_OBJ_LINKS" ADD CONSTRAINT "EUL4_BOL_BA_FK" FOREIGN KEY ("BOL_BA_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BA_OBJ_LINKS" ADD CONSTRAINT "EUL4_BOL_OBJ_FK" FOREIGN KEY ("BOL_OBJ_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_DEPS" ADD CONSTRAINT "EUL4_BFILD_FIL_FK" FOREIGN KEY ("BFILD_FIL_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_DEPS" ADD CONSTRAINT "EUL4_BFUND_FUN_FK" FOREIGN KEY ("BFUND_FUN_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_DEPS" ADD CONSTRAINT "EUL4_BID_IT_FK" FOREIGN KEY ("BID_IT_ID")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_DEPS" ADD CONSTRAINT "EUL4_BQD_BQ_FK" FOREIGN KEY ("BQD_BQ_ID")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_TABLES" ADD CONSTRAINT "EUL4_BQT_BQ_FK" FOREIGN KEY ("BQT_BQ_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BQ_TABLES" ADD CONSTRAINT "EUL4_BQT_BRR_FK" FOREIGN KEY ("BQT_BRR_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_BR_RUNS" ADD CONSTRAINT "EUL4_BRR_BR_FK" FOREIGN KEY ("BRR_BR_ID")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_DBH_NODES" ADD CONSTRAINT "EUL4_DHN_DBH_FK" FOREIGN KEY ("DHN_HI_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_DOCUMENTS" ADD CONSTRAINT "EUL4_DOC_EU_FK" FOREIGN KEY ("DOC_EU_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_DOMAINS" ADD CONSTRAINT "EUL4_DOM_IT_L_FK" FOREIGN KEY ("DOM_IT_ID_LOV")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_DOMAINS" ADD CONSTRAINT "EUL4_DOM_IT_R_FK" FOREIGN KEY ("DOM_IT_ID_RANK")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_CI_IT_FK" FOREIGN KEY ("CI_IT_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_FIL_DOC_FK" FOREIGN KEY ("FIL_DOC_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_FIL_OBJ_FK" FOREIGN KEY ("FIL_OBJ_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_IT_DOC_FK" FOREIGN KEY ("IT_DOC_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_IT_DOM_FK" FOREIGN KEY ("IT_DOM_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_IT_FUN_FK" FOREIGN KEY ("IT_FUN_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_IT_OBJ_FK" FOREIGN KEY ("IT_OBJ_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXPRESSIONS" ADD CONSTRAINT "EUL4_JP_FK_FK" FOREIGN KEY ("JP_KEY_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_CD_CI_FK" FOREIGN KEY ("CD_EXP_ID")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_CFD_FUN_FK" FOREIGN KEY ("CFD_FUN_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_CID_IT_FK" FOREIGN KEY ("CID_EXP_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_PD_P_FK" FOREIGN KEY ("PD_P_ID")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_PED_EXP_FK" FOREIGN KEY ("PED_EXP_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_PFD_FUN_FK" FOREIGN KEY ("PFD_FUN_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_EXP_DEPS" ADD CONSTRAINT "EUL4_PSD_SQ_FK" FOREIGN KEY ("PSD_SQ_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_FUN_ARGUMENTS" ADD CONSTRAINT "EUL4_FA_FUN_FK" FOREIGN KEY ("FA_FUN_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_FUN_FC_LINKS" ADD CONSTRAINT "EUL4_FFL_FC_FK" FOREIGN KEY ("FFL_FC_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_FUN_FC_LINKS" ADD CONSTRAINT "EUL4_FFL_FUN_FK" FOREIGN KEY ("FFL_FUN_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HIERARCHIES" ADD CONSTRAINT "EUL4_IBH_DBH_FK" FOREIGN KEY ("IBH_DBH_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_NODES" ADD CONSTRAINT "EUL4_HN_IBH_FK" FOREIGN KEY ("HN_HI_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_DHS_DBH_FK" FOREIGN KEY ("DHS_HI_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_DHS_DHN_C_FK" FOREIGN KEY ("DHS_DHN_ID_PARENT")
                                                                             *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_DHS_DHN_P_FK" FOREIGN KEY ("DHS_DHN_ID_CHILD")
                                                                             *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_IHS_HN_C_FK" FOREIGN KEY ("IHS_HN_ID_PARENT")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_IHS_HN_P_FK" FOREIGN KEY ("IHS_HN_ID_CHILD")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_HI_SEGMENTS" ADD CONSTRAINT "EUL4_IHS_IBH_FK" FOREIGN KEY ("IHS_HI_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IG_EXP_LINKS" ADD CONSTRAINT "EUL4_HIL_HN_FK" FOREIGN KEY ("HIL_HN_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IG_EXP_LINKS" ADD CONSTRAINT "EUL4_HIL_IT_FK" FOREIGN KEY ("HIL_EXP_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IG_EXP_LINKS" ADD CONSTRAINT "EUL4_KIL_IT_FK" FOREIGN KEY ("KIL_EXP_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IG_EXP_LINKS" ADD CONSTRAINT "EUL4_KIL_KEY_FK" FOREIGN KEY ("KIL_KEY_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IHS_FK_LINKS" ADD CONSTRAINT "EUL4_IFL_FK_FK" FOREIGN KEY ("IFL_KEY_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_IHS_FK_LINKS" ADD CONSTRAINT "EUL4_IFL_IHS_FK" FOREIGN KEY ("IFL_IHS_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_KEY_CONS" ADD CONSTRAINT "EUL4_FK_OBJ_FK" FOREIGN KEY ("FK_OBJ_ID_REMOTE")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_KEY_CONS" ADD CONSTRAINT "EUL4_FK_UK_FK" FOREIGN KEY ("FK_KEY_ID_REMOTE")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_KEY_CONS" ADD CONSTRAINT "EUL4_KEY_OBJ_FK" FOREIGN KEY ("KEY_OBJ_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJS" ADD CONSTRAINT "EUL4_OBJ_BA_FK" FOREIGN KEY ("OBJ_BA_ID")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJ_DEPS" ADD CONSTRAINT "EUL4_OD_COBJ_FK" FOREIGN KEY ("OD_OBJ_ID_FROM")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJ_DEPS" ADD CONSTRAINT "EUL4_OD_OBJ_FK" FOREIGN KEY ("OD_OBJ_ID_TO")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJ_JOIN_USGS" ADD CONSTRAINT "EUL4_OJU_COBJ_FK" FOREIGN KEY ("OJU_OBJ_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJ_JOIN_USGS" ADD CONSTRAINT "EUL4_OJU_FK_FK" FOREIGN KEY ("OJU_KEY_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_OBJ_JOIN_USGS" ADD CONSTRAINT "EUL4_OJU_SUMO_FK" FOREIGN KEY ("OJU_SUMO_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_BQ_FK" FOREIGN KEY ("SEG_BQ_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_CUO_FK" FOREIGN KEY ("SEG_CUO_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_EXP_FK" FOREIGN KEY ("SEG_EXP_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_OBJ_FK" FOREIGN KEY ("SEG_OBJ_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_SDO_FK" FOREIGN KEY ("SEG_SUMO_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SEGMENTS" ADD CONSTRAINT "EUL4_SEG_SMS_FK" FOREIGN KEY ("SEG_SMS_ID")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SQ_CRRLTNS" ADD CONSTRAINT "EUL4_SQC_IT_I_FK" FOREIGN KEY ("SQC_IT_INNER_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SQ_CRRLTNS" ADD CONSTRAINT "EUL4_SQC_IT_O_FK" FOREIGN KEY ("SQC_IT_OUTER_ID")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SQ_CRRLTNS" ADD CONSTRAINT "EUL4_SQC_SQ_FK" FOREIGN KEY ("SQC_SQ_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUB_QUERIES" ADD CONSTRAINT "EUL4_SQ_FIL_FK" FOREIGN KEY ("SQ_FIL_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUB_QUERIES" ADD CONSTRAINT "EUL4_SQ_IT_FK" FOREIGN KEY ("SQ_IT_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUB_QUERIES" ADD CONSTRAINT "EUL4_SQ_OBJ_FK" FOREIGN KEY ("SQ_OBJ_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMMARY_OBJS" ADD CONSTRAINT "EUL4_SBO_SRS_FK" FOREIGN KEY ("SBO_SRS_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMMARY_OBJS" ADD CONSTRAINT "EUL4_SDO_SBO_FK" FOREIGN KEY ("SDO_SBO_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMMARY_OBJS" ADD CONSTRAINT "EUL4_SUMO_ASMP_FK" FOREIGN KEY ("SUMO_ASMP_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMO_EXP_USGS" ADD CONSTRAINT "EUL4_SEU_SUMO_FK" FOREIGN KEY ("SEU_SUMO_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMO_EXP_USGS" ADD CONSTRAINT "EUL4_SFU_FUN_FK" FOREIGN KEY ("SFU_FUN_ID")
                                                                             *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMO_EXP_USGS" ADD CONSTRAINT "EUL4_SIU_IT_FK" FOREIGN KEY ("SIU_EXP_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUMO_EXP_USGS" ADD CONSTRAINT "EUL4_SMIU_FUN_FK" FOREIGN KEY ("SMIU_FUN_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUM_BITMAPS" ADD CONSTRAINT "EUL4_SB_FK_FK" FOREIGN KEY ("SB_KEY_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUM_BITMAPS" ADD CONSTRAINT "EUL4_SB_FUN_FK" FOREIGN KEY ("SB_FUN_ID")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUM_BITMAPS" ADD CONSTRAINT "EUL4_SB_IT_FK" FOREIGN KEY ("SB_EXP_ID")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUM_RFSH_SETS" ADD CONSTRAINT "EUL4_SRS_EU_FK" FOREIGN KEY ("SRS_EU_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."EUL4_SUM_RFSH_SETS" ADD CONSTRAINT "EUL4_SRS_RFU_FK" FOREIGN KEY ("SRS_RFU_ID")
                                                                             *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."GS_COMPOSITE" ADD CONSTRAINT "GCE_GTV_FK" FOREIGN KEY ("AC_TABLE")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."GS_TOKENS" ADD CONSTRAINT "GTN_GTV_FK" FOREIGN KEY ("AC_TABLE")
                                                               *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."LOADER_DEFAULTS" ADD CONSTRAINT "LDT_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."MATCH_RESULTS_EXT" ADD CONSTRAINT "MRT_ASV_FK" FOREIGN KEY ("ASL_NAME_OF_MATCH")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."MATCH_RESULTS_EXT" ADD CONSTRAINT "MRT_DET_FK" FOREIGN KEY ("DE_MATCH_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."MATCH_RESULTS_EXT" ADD CONSTRAINT "MRT_RDT_FK" FOREIGN KEY ("RD_MATCH_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."MATCH_RESULTS_EXT" ADD CONSTRAINT "MRT_VDN_FK" FOREIGN KEY ("VD_MATCH_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OBJECT_CLASSES_EXT" ADD CONSTRAINT "OCT_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OBJECT_CLASSES_EXT" ADD CONSTRAINT "OCT_CONDR_FK" FOREIGN KEY ("CONDR_IDSEQ")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OBJECT_CLASSES_EXT" ADD CONSTRAINT "OCT_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OBJECT_CLASSES_STAGING" ADD CONSTRAINT "OCS_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_AC_CSI_FK" FOREIGN KEY ("T_AC_CSI_IDSEQ")
                                                                    *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_AC_CSI_FK2" FOREIGN KEY ("S_AC_CSI_IDSEQ")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_ASL_FK" FOREIGN KEY ("ASL_NAME")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_CONDR_FK" FOREIGN KEY ("S_CONDR_IDSEQ")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_CONDR_FK1" FOREIGN KEY ("CONDR_IDSEQ")
                                                                    *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_CONDR_FK2" FOREIGN KEY ("T_CONDR_IDSEQ")
                                                                    *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_CONTE_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_OCT_FK" FOREIGN KEY ("T_OC_IDSEQ")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_OCT_FK2" FOREIGN KEY ("S_OC_IDSEQ")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."OC_RECS_EXT" ADD CONSTRAINT "ORT_RL_FK" FOREIGN KEY ("RL_NAME")
                                                                *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROPERTIES_EXT" ADD CONSTRAINT "PROP_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROPERTIES_EXT" ADD CONSTRAINT "PROP_CONDR_FK" FOREIGN KEY ("CONDR_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROPERTIES_EXT" ADD CONSTRAINT "PROP_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROPERTIES_STAGING" ADD CONSTRAINT "PT_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROTOCOLS_EXT" ADD CONSTRAINT "PROTO_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROTOCOLS_EXT" ADD CONSTRAINT "PROTO_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROTOCOL_QC_EXT" ADD CONSTRAINT "PQ_PROTO_FK" FOREIGN KEY ("PROTO_IDSEQ")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."PROTOCOL_QC_EXT" ADD CONSTRAINT "PQ_QC_FK" FOREIGN KEY ("QC_IDSEQ")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QC_RECS_EXT" ADD CONSTRAINT "QRS_RLV_FK" FOREIGN KEY ("RL_NAME")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUALIFIER_LOV_EXT" ADD CONSTRAINT "QLV_CONDR_FK" FOREIGN KEY ("CON_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_ATTRIBUTES_EXT" ADD CONSTRAINT "QAT_QCON_FK" FOREIGN KEY ("QCON_IDSEQ")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_ATTRIBUTES_EXT" ADD CONSTRAINT "QAT_QC_FK" FOREIGN KEY ("QC_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_ATTRIBUTES_EXT" ADD CONSTRAINT "QAT_QC_FK2" FOREIGN KEY ("VV_IDSEQ")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_CONTENTS_EXT" ADD CONSTRAINT "QC_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_CONTENTS_EXT" ADD CONSTRAINT "QC_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_CONTENTS_EXT" ADD CONSTRAINT "QC_DET_FK" FOREIGN KEY ("DE_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_CONTENTS_EXT" ADD CONSTRAINT "QC_VPV_FK" FOREIGN KEY ("VP_IDSEQ")
                                                                       *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_VV_EXT" ADD CONSTRAINT "QVT_QC_FK" FOREIGN KEY ("QUEST_IDSEQ")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."QUEST_VV_EXT" ADD CONSTRAINT "QVT_QVT_FK" FOREIGN KEY ("VV_IDSEQ")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."REPRESENTATIONS_EXT" ADD CONSTRAINT "REP_ASV_FK" FOREIGN KEY ("ASL_NAME")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."REPRESENTATIONS_EXT" ADD CONSTRAINT "REP_CONDR_FK" FOREIGN KEY ("CONDR_IDSEQ")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."REPRESENTATIONS_EXT" ADD CONSTRAINT "REP_COT_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."REPRESENTATIONS_STAGING" ADD CONSTRAINT "REPR_SDL_FK" FOREIGN KEY ("SDE_ID")
                                                                              *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."RULE_FUNCTIONS_EXT" ADD CONSTRAINT "RFT_CONDR_FK" FOREIGN KEY ("CONDR_IDSEQ")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_QUERY_EXT" ADD CONSTRAINT "SQT_SAT_FK" FOREIGN KEY ("AL_IDSEQ")
                                                                  *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_RECIPIENT_EXT" ADD CONSTRAINT "SPT_CONTE_FK" FOREIGN KEY ("CONTE_IDSEQ")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_RECIPIENT_EXT" ADD CONSTRAINT "SPT_SRT_FK" FOREIGN KEY ("REP_IDSEQ")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_RECIPIENT_EXT" ADD CONSTRAINT "SPT_UA_FK" FOREIGN KEY ("UA_NAME")
                                                                     *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_REPORT_EXT" ADD CONSTRAINT "SRT_SAT_FK" FOREIGN KEY ("AL_IDSEQ")
                                                                   *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."SN_REP_CONTENTS_EXT" ADD CONSTRAINT "SCT_SRT_FK" FOREIGN KEY ("REP_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TA_PROTO_CSI_EXT" ADD CONSTRAINT "TPI_AC_CSI_FK" FOREIGN KEY ("AC_CSI_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TA_PROTO_CSI_EXT" ADD CONSTRAINT "TPI_PROTO_FK" FOREIGN KEY ("PROTO_IDSEQ")
                                                                        *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TA_PROTO_CSI_EXT" ADD CONSTRAINT "TPI_TAT_FK" FOREIGN KEY ("TA_IDSEQ")
                                                                      *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TOOL_OPTIONS_EXT" ADD CONSTRAINT "TL_UA_FK" FOREIGN KEY ("UA_NAME")
                                                                    *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_DE_FK" FOREIGN KEY ("T_DE_IDSEQ")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QCON_FK" FOREIGN KEY ("QCON_IDSEQ")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QCON_FK2" FOREIGN KEY ("FORCED_QCON_IDSEQ")
                                                                             *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QC_FK" FOREIGN KEY ("S_QC_IDSEQ")
                                                                          *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QC_FK2" FOREIGN KEY ("T_QC_IDSEQ")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QVT_FK" FOREIGN KEY ("S_QR_IDSEQ")
                                                                           *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."TRIGGERED_ACTIONS_EXT" ADD CONSTRAINT "TAT_QVT_FK2" FOREIGN KEY ("T_QR_IDSEQ")
                                                                            *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."USERS_LOCKOUT" ADD CONSTRAINT "UL_UA_FK" FOREIGN KEY ("UA_NAME")
                                                                 *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."VALID_VALUES_ATT_EXT" ADD CONSTRAINT "VVT_QC_FK" FOREIGN KEY ("QC_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table


  ALTER TABLE "SBREXT"."VD_PVS_SOURCES_EXT" ADD CONSTRAINT "VPST_VPV_FK" FOREIGN KEY ("VP_IDSEQ")
                                                                         *
ERROR at line 1:
ORA-02275: such a referential constraint already exists in the table



Package body created.

SQL> 



*** UNDOING CHANGES ***

Please use the previous version in the SVN.