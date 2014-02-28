-- run this with SBR user
/*
 * Notes related to issue https://gforge.nci.nih.gov/tracker/index.php?func=detail&aid=30681.
 */
SET SERVEROUTPUT ON;

-- Backing up for rollback, in case of failed deployment/production release
CREATE TABLE SBR.DATA_ELEMENT_CONCEPTS_BACKUP AS SELECT * FROM SBR.DATA_ELEMENT_CONCEPTS
/
 
DECLARE
OC_CDR_NAME VARCHAR2(100);
PROP_CDR_NAME VARCHAR2(100);
NEW_CDR_NAME VARCHAR2(100);
 
CURSOR CDR IS
 Select DISTINCT DEC_IDSEQ, LONG_NAME, DEC_ID  from SBR.DATA_ELEMENT_CONCEPTS 
 where 
  CDR_NAME is NULL and
 DEC_IDSEQ is not null and 
 OC_IDSEQ is NOT NULL and PROP_IDSEQ is NOT NULL 
 ;

BEGIN
 
For DECID in CDR LOOP

begin
Select DISTINCT name into OC_CDR_NAME from SBREXT.con_derivation_rules_ext where CONDR_IDSEQ is not null and CONDR_IDSEQ IN(Select DISTINCT CONDR_IDSEQ from 
SBREXT.object_classes_ext where OC_IDSEQ IN(Select DISTINCT OC_IDSEQ from 
SBR.data_element_concepts where DEC_IDSEQ =DECID.DEC_IDSEQ)
and CONDR_IDSEQ is NOT NULL
);
 
Select DISTINCT name into PROP_CDR_NAME from SBREXT.con_derivation_rules_ext where CONDR_IDSEQ is not null and CONDR_IDSEQ IN(Select DISTINCT CONDR_IDSEQ from 
SBREXT.properties_ext where PROP_IDSEQ IN(Select DISTINCT PROP_IDSEQ from 
SBR.data_element_concepts where DEC_IDSEQ =DECID.DEC_IDSEQ)
and CONDR_IDSEQ is NOT NULL
);
  exception
-- handle ORA-01403: no data found here
    when no_data_found then
      dbms_output.put_line(CHR(10) || 'No data found for ' || DECID.LONG_NAME || ' (' || DECID.DEC_ID || ')');
    when too_many_rows then
      dbms_output.put_line(CHR(10) || 'Too many rows for ' || DECID.LONG_NAME || ' (' || DECID.DEC_ID || ')');
    when others then
      dbms_output.put_line(CHR(10) || 'Unknown error for ' || DECID.LONG_NAME || ' (' || DECID.DEC_ID || ')');
end;

-- DBMS_OUTPUT.put_line('.');
NEW_CDR_NAME:=':' || OC_CDR_NAME || ':' || PROP_CDR_NAME;

-- DBMS_OUTPUT.put_line('********* Updating DEC_IDSEQ [' || DECID.DEC_IDSEQ || '] CDR_NAME with [' || NEW_CDR_NAME || '] ...');

Update SBR.DATA_ELEMENT_CONCEPTS SET CDR_NAME=NEW_CDR_NAME where DEC_IDSEQ=DECID.DEC_IDSEQ;

-- DBMS_OUTPUT.put_line('DEC_IDSEQ = ' || DECID.DEC_IDSEQ || ' LONG NAME = ' || DECID.LONG_NAME || ' CDR_NAME set to [' || NEW_CDR_NAME || '] *********');

END LOOP;

END;
/
