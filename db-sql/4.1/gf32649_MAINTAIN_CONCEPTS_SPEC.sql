--------------------------------------------------------
--  Please run with SBREXT account
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package MAINTAIN_CONCEPTS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "SBREXT"."MAINTAIN_CONCEPTS" is
procedure load_concept(p_preferred_name in varchar2
,p_long_name in varchar2
,p_preferred_Definition in varchar2
,p_Definition_source in varchar2
,p_origin in varchar2
,p_evs_source in varchar2);

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
