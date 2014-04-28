Sample output on DEV (should return 18 rows):

SQL*Plus: Release 12.1.0.1.0 Production on Mon Apr 28 13:00:04 2014

Copyright (c) 1982, 2013, Oracle.  All rights reserved.


Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.5.0 - 64bit Production
With the Partitioning, Data Mining and Real Application Testing options

SQL> @GF32723_insert_alt_name_lov.sql
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DAT
E_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('NCI Thesaurus','NCI Thesaurus',nul
l,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZ
EL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.

Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DAT
E_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('NCI Metathesaurus','NCI Metathesau
rus',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'
),'DWARZEL')
*
ERROR at line 1:
ORA-00001: unique constraint (SBR.DT_PK) violated



1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


1 row created.


Commit complete.


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
NCI Thesaurus
NCI Thesaurus

NCI Metathesaurus
NCI Metathesaurus

Zebrafish
Zebrafish


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
GO
Gene Ontology

CTCAE
Common Terminology Criteria for Adverse Events

HUGO
HUGO Gene Nomenclature Committee Ontology


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
ICD9CM
Intrntnl Classifn of Diseases, 9th Revision, Clinical Modifn

ICD10
ICD-10

LNC
Logical Observation Identifier Names and Codes


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
MDR
MedDRA (Medical Dict for Regulatory Activities Terminology)

MGED
The MGED Ontology

NPO
Nanoparticle Ontology


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
OBI
Ontology for Biomedical Investigations

RADLEX
Radiology Lexicon

SNOMEDCT
SNOMED Clinical Terms


DETL_NAME
--------------------
DESCRIPTION
------------------------------------------------------------
UMLS SemNet
UMLS Semantic Network

VANDF
National Drug File - Reference Terminology

ZFIN
Zebrafish


18 rows selected.

SQL>
