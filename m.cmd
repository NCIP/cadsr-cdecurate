echo "Please confirm that the Eclipse copy of your js files will be overwritten by the JBoss copies! (Ctrl + C to break)"
pause

copy /y C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\js WebRoot\js

echo "Please confirm that the Eclipse copy of your jsp files will be overwritten by the JBoss copies! (Ctrl + C to break)"
pause

copy /y C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\jsp WebRoot\jsp

echo "Please confirm that the Eclipse copy of your test\js files will be overwritten by the JBoss copies! (Ctrl + C to break)"
pause

xcopy /e /y C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\test\js test\js\
