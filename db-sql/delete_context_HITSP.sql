--Run with SBREXT user

--Prove that it exist first :<
select CONTE_IDSEQ, DESCRIPTION, pal_name, ll_name from SBR.CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP');

--DELETE AC's child first
delete from SBR.AC_CSI where AC_IDSEQ in (select AC_IDSEQ from ADMINISTERED_COMPONENTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP'));

--DELETE AC
delete from SBR.ADMINISTERED_COMPONENTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP');

delete from SBR.CS_CSI where CS_IDSEQ = (select CS_IDSEQ from SBR.CLASSIFICATION_SCHEMES where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP'));

delete from SBR.CLASSIFICATION_SCHEMES where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP');

delete from CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'HITSP');

--Prove that it is gone :)
select CONTE_IDSEQ, DESCRIPTION, pal_name, ll_name from SBR.CONTEXTS where NAME = 'HITSP';

commit;
