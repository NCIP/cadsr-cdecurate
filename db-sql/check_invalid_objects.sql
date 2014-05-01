COLUMN object_name FORMAT A30
SELECT owner,
       object_type,
       object_name,
       status
FROM   dba_objects
WHERE  status = 'INVALID'
and OWNER in ('SBR','SBREXT')
and OBJECT_NAME like 'SBREXT%'
ORDER BY owner, object_type, object_name;
