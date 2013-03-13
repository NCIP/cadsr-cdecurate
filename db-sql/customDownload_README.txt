/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=11372.
 */

*** APPLYING CHANGES ***

Run with user SBREXT:

SQL> desc "SBREXT"."CDE_EXCEL_GENERATOR_VIEW";
ERROR:
ORA-24372: invalid object for describe


SQL> @customDownload.sql
insert into sbrext.tool_options_view_ext (tool_name, property, value)
*
ERROR at line 1:
ORA-00001: unique constraint (SBREXT.TOOL_OPTIONS_UNIQ) violated


insert into sbrext.tool_options_view_ext (tool_name, property, Value)
*
ERROR at line 1:
ORA-00001: unique constraint (SBREXT.TOOL_OPTIONS_UNIQ) violated



Type dropped.


Type dropped.


Type created.


Type created.


Table dropped.


Table created.


Grant succeeded.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


View created.


Grant succeeded.


Grant succeeded.


Grant succeeded.


Commit complete.

SQL> desc "SBREXT"."CDE_EXCEL_GENERATOR_VIEW";
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 CDE_IDSEQ				   NOT NULL CHAR(36)
 DE Short Name				   NOT NULL VARCHAR2(30)
 DE Long Name					    VARCHAR2(255)
 DE Preferred Question Text			    VARCHAR2(4000)
 DE Preferred Definition		   NOT NULL VARCHAR2(2000)
 DE Version				   NOT NULL NUMBER(4,2)
 DE Context Name			   NOT NULL VARCHAR2(30)
 DE Context Version			   NOT NULL NUMBER(4,2)
 DE Public ID				   NOT NULL NUMBER
 DE Workflow Status			   NOT NULL VARCHAR2(20)
 DE Registration Status 			    VARCHAR2(50)
 DE Begin Date					    DATE
 DE Source					    VARCHAR2(240)
 DEC Public ID				   NOT NULL NUMBER
 DEC Short Name 			   NOT NULL VARCHAR2(30)
 DEC Long Name					    VARCHAR2(255)
 DEC Version				   NOT NULL NUMBER(4,2)
 DEC Context Name			   NOT NULL VARCHAR2(30)
 DEC Context Version			   NOT NULL NUMBER(4,2)
 OC Public ID					    NUMBER
 OC Long Name					    VARCHAR2(255)
 OC Short Name					    VARCHAR2(30)
 OC Context Name				    VARCHAR2(30)
 OC Version					    NUMBER(4,2)
 OC_CONCEPTS					    CONCEPTS_LIST_T
 Property Public ID				    NUMBER
 Property Long Name				    VARCHAR2(255)
 Property Short Name				    VARCHAR2(30)
 Property Context Name				    VARCHAR2(30)
 Property Version				    NUMBER(4,2)
 PROP_CONCEPTS					    CONCEPTS_LIST_T
 VD Public ID				   NOT NULL NUMBER
 VD Short Name				   NOT NULL VARCHAR2(30)
 VD Long Name					    VARCHAR2(255)
 VD Version				   NOT NULL NUMBER(4,2)
 VD Context Name			   NOT NULL VARCHAR2(30)
 VD Context Version			   NOT NULL NUMBER(4,2)
 VD Type					    VARCHAR2(14)
 VD Datatype				   NOT NULL VARCHAR2(20)
 VD Min Length					    NUMBER(8)
 VD Max Length					    NUMBER(8)
 VD Min value					    VARCHAR2(255)
 VD Max Value					    VARCHAR2(255)
 VD Decimal Place				    NUMBER(2)
 VD Format					    VARCHAR2(20)
 VD_CONCEPTS					    CONCEPTS_LIST_T
 Representation Public ID			    NUMBER
 Representation Long Name			    VARCHAR2(255)
 Representation Short Name			    VARCHAR2(30)
 Representation Context Name			    VARCHAR2(30)
 Representation Version 			    NUMBER(4,2)
 REP_CONCEPTS					    CONCEPTS_LIST_T
 VALID_VALUES					    VALID_VALUE_LIST_T
 CLASSIFICATIONS				    CDEBROWSER_CSI_LIST_T
 DESIGNATIONS					    DESIGNATIONS_LIST_T
 REFERENCE_DOCS 				    CDEBROWSER_RD_LIST_T
 DE_DERIVATION					    DERIVED_DATA_ELEMENT_T
 CD Public ID				   NOT NULL NUMBER
 CD Short Name				   NOT NULL VARCHAR2(30)
 CD Version				   NOT NULL NUMBER(4,2)
 CD Context Name			   NOT NULL VARCHAR2(30)

SQL> desc "SBREXT"."VALID_VALUE_LIST_T";
 "SBREXT"."VALID_VALUE_LIST_T" TABLE OF VALID_VALUE_T
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 VALIDVALUE					    VARCHAR2(255)
 VALUEMEANING					    VARCHAR2(255)
 MEANINGDESCRIPTION				    VARCHAR2(2000)
 MEANINGCONCEPTS				    VARCHAR2(2000)
 PVBEGINDATE					    DATE
 PVENDDATE					    DATE
 VMPUBLICID					    NUMBER
 VMVERSION					    NUMBER(4,2)
 VMALTERNATEDEFINITIONS 			    VARCHAR2(2000)

SQL> desc "SBREXT"."VALID_VALUE_T";
 Name					   Null?    Type
 ----------------------------------------- -------- ----------------------------
 VALIDVALUE					    VARCHAR2(255)
 VALUEMEANING					    VARCHAR2(255)
 MEANINGDESCRIPTION				    VARCHAR2(2000)
 MEANINGCONCEPTS				    VARCHAR2(2000)
 PVBEGINDATE					    DATE
 PVENDDATE					    DATE
 VMPUBLICID					    NUMBER
 VMVERSION					    NUMBER(4,2)
 VMALTERNATEDEFINITIONS 			    VARCHAR2(2000)

SQL> 


*** UNDOING CHANGES ***

Please use the previous version in the SVN.