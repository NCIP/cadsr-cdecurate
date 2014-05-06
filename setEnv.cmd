cd %~dp0
cd ..\..
set PROJECT_HOME=%CD%

set JAVA_HOME=C:\jdk1.7.0_51
set GAE_JAVA_SDK_HOME=C:\appengine-java-sdk-1.9.1
set ANT_HOME=C:\apache-ant-1.9.3
set MAVEN_HOME=C:\apache-maven-2.2.1
set ROO_HOME=C:\spring-roo-1.1.0.M3

set PATH=%JAVA_HOME%\bin;%GAE_JAVA_SDK_HOME%\bin;%ANT_HOME%\bin;%MAVEN_HOME%\bin;%ROO_HOME%\bin;%PATH%
