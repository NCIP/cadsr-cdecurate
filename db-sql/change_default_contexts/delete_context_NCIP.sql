--Run with SBREXT user

--Confirming what we have first
select 1 from dual;
select count(*) from SBR.SC_CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'NCIP');

select 2 from dual;
select CONTE_IDSEQ, DESCRIPTION, pal_name, ll_name from SBR.CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'NCIP');

--Now delete the context (assumed user groups and sc_groups have been executed correctly previously)
delete from SBR.SC_CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'NCIP');

delete from SBR.CONTEXTS where CONTE_IDSEQ = (select CONTE_IDSEQ from SBR.CONTEXTS where name = 'NCIP');

--Prove that it is gone :)
select CONTE_IDSEQ, DESCRIPTION, pal_name, ll_name from SBR.CONTEXTS where NAME = 'NCIP';

commit;
