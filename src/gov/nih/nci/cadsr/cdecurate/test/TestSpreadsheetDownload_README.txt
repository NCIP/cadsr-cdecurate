Sample output (executed on 3/28/2013 against Oracle 10g DSRDEV with ojdbc6.jar):

************************************** start ROW 1 **************************************
************************************** start CONCEPT_DETAIL_T 1 **************************************
PREFERRED_NAME=C25407
LONG_NAME=Address
CON_ID=2202289
************************************** end CONCEPT_DETAIL_T 1 **************************************
************************************** start DERIVED_DATA_ELEMENT_T 1 **************************************
Current colum type = [oracle.sql.CHAR]
Current colum name = [oracle.sql.CHAR]
Current value[0] = [CONCATENATION]
Current colum type = [oracle.sql.CHAR]
Current colum name = [oracle.sql.CHAR]
Current value[1] = [Character string joined together with a colon separator.]
Current colum type = [oracle.sql.CHAR]
Current colum name = [oracle.sql.CHAR]
Current value[3] = [The concatentation of all necessary components of Street/Thoroughfare Address Line 1.]
Current colum type = [oracle.sql.CHAR]
Current colum name = [oracle.sql.CHAR]
Current value[4] = [+]
what are you my child=oracle.sql.ARRAY@1fbbd7b2
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341957
LongName=Address Secondary Unit Indicator/Designator Number
PreferredName=ADDR_SEC_U_DES_NUM
PreferredDefinition=A component of an address that specifies a location by identification of an additional subdivision of the primary address by number.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=8
************************************** child 1 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341954
LongName=Address Secondary Unit Indicator/Designator Type
PreferredName=ADDR_SEC_U_DES_TP
PreferredDefinition=A component of an address that specifies a location by identification of an additional subdivision of the primary address by type.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=7
************************************** child 2 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341948
LongName=Address Street/Thoroughfare Type
PreferredName=ADDR_STRT_TP
PreferredDefinition=A component of an address that specifies a location by identification of a street/thoroughfare by type.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=6
************************************** child 3 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341900
LongName=Address Street Post Directional Type
PreferredName=ADDR_ST_PST_DRCTN_TP
PreferredDefinition=A component of an address that specifies a location by identification of directional text occurring after the street/thoroughfare name.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=5
************************************** child 4 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341883
LongName=Address Street/Thoroughfare Name
PreferredName=ADDR_STRT_NM
PreferredDefinition=A component of an address that specifies a location by identification of a related road or public highway.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=4
************************************** child 5 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341893
LongName=Address Street Pre Directional Type
PreferredName=ADDR_ST_PRE_DRCTN_TP
PreferredDefinition=A component of an address that specifies a location by identification of directional text occurring before the street/thoroughfare name.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=3
************************************** child 6 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341863
LongName=Address Street/Thoroughfare Number
PreferredName=ADDR_STRT_NUM
PreferredDefinition=A component of an address that specifies a location by identification of an assigned numeral or string of numerals on a street/thoroughfare.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=2
************************************** child 7 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** start DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
PublicId=2341934
LongName=Address Post Office Box Number
PreferredName=ADDR_POST_OFF_BX_NUM
PreferredDefinition=A component of an address that specifies a location by identification of a delivery box at a postal facility.
Version=1
WorkflowStatus=RELEASED
ContextName=caBIG
DisplayOrder=1
************************************** child 8 of DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DATA_ELEMENT_DERIVATION_LIST_T 1 **************************************
************************************** end DERIVED_DATA_ELEMENT_T 1 **************************************
************************************** end ROW 1 **************************************

Sample SQL results (run with Oracle SQLDeveloper 3.2.10 and executed on 3/28/2013 against Oracle 10g DSRDEV with ojdbc6.jar):

SBREXT.DERIVED_DATA_ELEMENT_T('CONCATENATION','Character string joined together with a colon separator.',NULL,'The concatentation of all necessary components of Street/Thoroughfare Address Line 1.','+',SBREXT.DATA_ELEMENT_DERIVATION_LIST_T(SBREXT.DATA_ELEMENT_DERIVATION_T(2341957,'Address Secondary Unit Indicator/Designator Number','ADDR_SEC_U_DES_NUM','A component of an address that specifies a location by identification of an additional subdivision of the primary address by number.',1,'RELEASED','caBIG',8),SBREXT.DATA_ELEMENT_DERIVATION_T(2341954,'Address Secondary Unit Indicator/Designator Type','ADDR_SEC_U_DES_TP','A component of an address that specifies a location by identification of an additional subdivision of the primary address by type.',1,'RELEASED','caBIG',7),SBREXT.DATA_ELEMENT_DERIVATION_T(2341948,'Address Street/Thoroughfare Type','ADDR_STRT_TP','A component of an address that specifies a location by identification of a street/thoroughfare by type.',1,'RELEASED','caBIG',6),SBREXT.DATA_ELEMENT_DERIVATION_T(2341900,'Address Street Post Directional Type','ADDR_ST_PST_DRCTN_TP','A component of an address that specifies a location by identification of directional text occurring after the street/thoroughfare name.',1,'RELEASED','caBIG',5),SBREXT.DATA_ELEMENT_DERIVATION_T(2341883,'Address Street/Thoroughfare Name','ADDR_STRT_NM','A component of an address that specifies a location by identification of a related road or public highway.',1,'RELEASED','caBIG',4),SBREXT.DATA_ELEMENT_DERIVATION_T(2341893,'Address Street Pre Directional Type','ADDR_ST_PRE_DRCTN_TP','A component of an address that specifies a location by identification of directional text occurring before the street/thoroughfare name.',1,'RELEASED','caBIG',3),SBREXT.DATA_ELEMENT_DERIVATION_T(2341863,'Address Street/Thoroughfare Number','ADDR_STRT_NUM','A component of an address that specifies a location by identification of an assigned numeral or string of numerals on a street/thoroughfare.',1,'RELEASED','caBIG',2),SBREXT.DATA_ELEMENT_DERIVATION_T(2341934,'Address Post Office Box Number','ADDR_POST_OFF_BX_NUM','A component of an address that specifies a location by identification of a delivery box at a postal facility.',1,'RELEASED','caBIG',1)))
