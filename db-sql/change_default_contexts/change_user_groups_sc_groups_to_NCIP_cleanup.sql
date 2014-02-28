--Run with SBR user
DROP TABLE SBR.SECURITY_CONTEXTS_LOV_BACKUP;

DROP TABLE sbr.groups_backup;

DROP TABLE sbr.user_groups_backup;

DROP TABLE sbr.sc_groups_backup;

desc sbr.groups_backup;

desc sbr.user_groups_backup;

desc sbr.sc_groups_backup;

commit;
