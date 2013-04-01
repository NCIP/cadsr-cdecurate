--Run with SBREXT user
select * from SBR.PROGRAM_AREAS_LOV
/
select * from SBR.LIFECYCLES_LOV
/
delete from SBR.PROGRAM_AREAS_LOV where PAL_NAME = 'UNASSIGNED'
/
delete from SBR.LIFECYCLES_LOV where LL_NAME = 'UNASSIGNED'
/
select * from SBR.PROGRAM_AREAS_LOV
/
select * from SBR.LIFECYCLES_LOV
/
select name, PAL_NAME, LL_NAME from SBR.CONTEXTS where NAME = 'HITSP'
/
delete from SBR.CONTEXTS where NAME = 'HITSP'
/
select name, PAL_NAME, LL_NAME from SBR.CONTEXTS where NAME = 'HITSP'
/
