echo "Please confirm that the Eclipse copy of your js files will be overwritten by the JBoss copies! (Ctrl + C to break)"
pause

copy /y C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\js C:\Users\ag\demo\cadsr-cdecurate\WebRoot\js

echo "Please confirm that the Eclipse copy of your jsp files will be overwritten by the JBoss copies! (Ctrl + C to break)"
pause

copy /y C:\Apps\jboss-5.1.0.GA\server\default\deploy\cdecurate.war\jsp C:\Users\ag\demo\cadsr-cdecurate\WebRoot\jsp
