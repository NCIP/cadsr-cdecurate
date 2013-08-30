Sample output on DEV:

SQL*Plus: Release 10.2.0.4.0 - Production on Fri Aug 30 16:18:59 2013

Copyright (c) 1982, 2007, Oracle.  All Rights Reserved.


Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.5.0 - 64bit Production
With the Partitioning, Data Mining and Real Application Testing options

SQL> @GF32723_update_alt_name_lov.sql

Table altered.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Gene Ontology','GO',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('ICD-10','ICD-10_',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('The MGED Ontology','MGED',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated


Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('NCI Metathesaurus','NCI Metathesaurus',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Radiology Lexicon','RadLex',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DETL_NAME,DESCRIPTION,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Zebrafish','Zebrafish',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



Commit complete.


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
Common Terminology Criteria for Adverse Events
CTCAE

Gene Ontology
GO

HUGO Gene Nomenclature Committee Ontology
HGNC


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
ICD-10
ICD-10_

International Classification of Diseases, Ninth Revision, Clinical Modification
ICD-9-CM

Logical Observation Identifier Names and Codes
LOINC


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
MedDRA (Medical Dictionary for Regulatory Activities Terminology)
MedDRA

NCI Metathesaurus
NCI Metathesaurus

NCI Thesaurus
NCI Thesaurus


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
Nanoparticle Ontology
NPO

National Drug File - Reference Terminology
VA_NDFRT

Ontology for Biomedical Investigations
OBI


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
Prior Preferred Name
A previous name in this registry

Radiology Lexicon
RadLex

SNOMED Clinical Terms
SNOMED


DETL_NAME
--------------------------------------------------------------------------------
DESCRIPTION
------------------------------------------------------------
The MGED Ontology
MGED

UMLS Semantic Network
UMLS SemNet

Zebrafish
Zebrafish


18 rows selected.

SQL> 
