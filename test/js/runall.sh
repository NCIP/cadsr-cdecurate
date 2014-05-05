#!/bin/bash

echo You should launch this manually and it will open in your default browser
echo start /wait units-qun.html
echo ......

echo You should launch this manually and it will open in your default browser
echo start /wait units-jas.html
echo ......

echo Running unit tests in QUnits against headless browser ...
phantomjs runner-qun.js units-qun.html
echo "Press any key to continue..." ; read anykey 

echo Running unit tests in Jasmine against headless browser ...
phantomjs runner-jas.js units-jas.html
echo "Press any key to continue..." ; read anykey 

echo "Running unit tests in Jasmine without a browser ..."
jasmine-node --matchall units-jas.js
echo "Press any key to continue..." ; read anykey 

echo Running unit tests in QUnit without a browser ...
qunit --cov -c ./helpers/mock-gf7680.js:./helpers/mock-gf32723.js -d vendors/curl.min-0.7.3.js -t units-qun.js

echo Done!
