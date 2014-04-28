--Run this with SBR account

--alter table DESIGNATION_TYPES_LOV MODIFY DETL_NAME varchar2(100);

Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('NCI Thesaurus','NCI Thesaurus',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Gene Ontology','GO',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Common Terminology Criteria for Adverse Events','CTCAE',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('HUGO Gene Nomenclature Committee Ontology','HUGO',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Intrntnl Classifn of Diseases, 9th Revision, Clinical Modifn','ICD9CM',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('ICD-10','ICD10',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Logical Observation Identifier Names and Codes','LNC',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('MedDRA (Medical Dict for Regulatory Activities Terminology)','MDR',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('The MGED Ontology','MGED',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('NCI Metathesaurus','NCI Metathesaurus',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Nanoparticle Ontology','NPO',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Ontology for Biomedical Investigations','OBI',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Radiology Lexicon','RADLEX',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('SNOMED Clinical Terms','SNOMEDCT',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('UMLS Semantic Network','UMLS SemNet',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('National Drug File - Reference Terminology','VANDF',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');
Insert into DESIGNATION_TYPES_LOV (DESCRIPTION,DETL_NAME,COMMENTS,CREATED_BY,DATE_CREATED,DATE_MODIFIED,MODIFIED_BY) values ('Zebrafish','ZFIN',null,'SBR',to_date('08-MAY-03','DD-MON-RR'),to_date('23-OCT-06','DD-MON-RR'),'DWARZEL');

commit;

select detl_name, description from SBR.DESIGNATION_TYPES_LOV detl_name
where description in
('Prior Preferred Name',
'NCI Thesaurus',
'Gene Ontology',
'Common Terminology Criteria for Adverse Events',
'HUGO Gene Nomenclature Committee Ontology',
'Intrntnl Classifn of Diseases, 9th Revision, Clinical Modifn',
'ICD-10',
'Logical Observation Identifier Names and Codes',
'MedDRA (Medical Dict for Regulatory Activities Terminology)',
'The MGED Ontology',
'NCI Metathesaurus',
'Nanoparticle Ontology',
'Ontology for Biomedical Investigations',
'Radiology Lexicon',
'SNOMED Clinical Terms',
'UMLS Semantic Network',
'National Drug File - Reference Terminology',
'Zebrafish');
