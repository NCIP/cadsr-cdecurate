echo Setting up p6spy ...

del /q C:\apps\jboss-5.1.0.GA\server\default\deploy\*-ds.xml

copy dist\jboss\cdecurate-oracle-ds.xml C:\apps\jboss-5.1.0.GA\server\default\deploy
copy dist\jboss\ojdbc6.jar C:\Apps\jboss-5.1.0.GA\server\default\lib
copy %USERPROFILE%\Desktop\p6spy\cdecurate\lib\p6spy.jar C:\Apps\jboss-5.1.0.GA\server\default\lib
copy %USERPROFILE%\Desktop\p6spy\cdecurate\conf\spy.properties C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\WEB-INF\classes

echo p6spy setup done!

pause