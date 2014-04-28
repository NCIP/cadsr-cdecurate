REM COPY p6spy version of cdecurate-oracle-ds.xml into C:\apps\jboss-5.1.0.GA\server\default\deploy
REM COPY p6spy.jar *** manually *** into C:\apps\jboss-5.1.0.GA\server\default\lib
REM COPY spy.properties *** manually *** into C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\WEB-INF\classes !!!

del /q C:\apps\jboss-5.1.0.GA\server\default\deploy\*-ds.xml

call cp6spy.cmd

REM overwrite with local DSRDEV
copy %USERPROFILE%\Desktop\cadsr-cdecurate\conf\cdecurate-oracle-ds.xml.p6spy.local C:\apps\jboss-5.1.0.GA\server\default\deploy\cdecurate-oracle-ds.xml

:pause