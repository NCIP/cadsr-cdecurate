--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package Body MAINTAIN_CONCEPTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "SBREXT"."MAINTAIN_CONCEPTS" is


procedure load_concept(p_preferred_name in varchar2
,p_long_name in varchar2
,p_preferred_Definition in varchar2
,p_Definition_source in varchar2
,p_origin in varchar2
,p_evs_source in varchar2) is

v_conte_idseq  char(36);

v_count number;

begin

select conte_idseq into v_Conte_idseq
from contexts
where name = 'NCIP';    --GF32649 changed CABIG to NCI

select count(*) into v_count
from concepts_Ext
where preferred_name = p_preferred_name;

if v_count = 0 then

insert into concepts_ext(CON_IDSEQ
,PREFERRED_NAME
,LONG_NAME
,PREFERRED_DEFINITION
,CONTE_IDSEQ
,VERSION
,ASL_NAME
,LATEST_VERSION_IND
,BEGIN_DATE
,DEFINITION_SOURCE
,ORIGIN
,DELETED_IND
,EVS_SOURCE ) values
(admincomponent_crud.cmr_guid
,p_preferred_name
,p_long_name
,p_preferred_definition
,v_conte_idseq
,1
,'RELEASED'
,'Yes'
,Sysdate
,p_definition_source
,p_origin
,'No'
,p_evs_source);

 dbms_output.put_line(' Concept '||p_preferred_name||' loaded.');
else
 dbms_output.put_line('Error: Concept '||p_preferred_name||' already exists.');

end if;

end;

end;

/

  GRANT EXECUTE ON "SBREXT"."MAINTAIN_CONCEPTS" TO "CDEBROWSER";
 
  GRANT DEBUG ON "SBREXT"."MAINTAIN_CONCEPTS" TO "CDEBROWSER";
 
  GRANT EXECUTE ON "SBREXT"."MAINTAIN_CONCEPTS" TO "DATA_LOADER";
 
  GRANT DEBUG ON "SBREXT"."MAINTAIN_CONCEPTS" TO "DATA_LOADER";
 
  GRANT EXECUTE ON "SBREXT"."MAINTAIN_CONCEPTS" TO "SBR" WITH GRANT OPTION;
 
  GRANT DEBUG ON "SBREXT"."MAINTAIN_CONCEPTS" TO "SBR" WITH GRANT OPTION;
 
  GRANT EXECUTE ON "SBREXT"."MAINTAIN_CONCEPTS" TO "APPLICATION_USER";
 
  GRANT DEBUG ON "SBREXT"."MAINTAIN_CONCEPTS" TO "APPLICATION_USER";
 
  GRANT EXECUTE ON "SBREXT"."MAINTAIN_CONCEPTS" TO "DER_USER";
