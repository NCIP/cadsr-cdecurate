@echo off

echo You should launch this manually and it will open in your default browser
echo start /wait units-qun.html
echo ......

echo You should launch this manually and it will open in your default browser
echo start /wait units-jas.html
echo ......


echo Running unit tests in Jasmine against headless browser ...
:call phantomjs runner-jas.js units-jas.html
call phantomjs runner-jas-1.3.1.js units-jas-1.3.1.html
pause

echo "Running unit tests in Jasmine without a browser ..."
:call jasmine-node --matchall --captureExceptions units-jas.js
call jasmine-node --matchall --captureExceptions units-jas-1.3.1.js
pause

echo Running unit tests in QUnits against headless browser ...
call phantomjs runner-qun.js units-qun.html
pause

echo Running unit tests in QUnit without a browser ...
call qunit --cov -c ./helpers/mock-gf7680.js:./helpers/mock-gf32723.js -d vendors/curl.min-0.7.3.js -t units-qun.js

echo Done!
pause
