:set PATH=%PATH%;c:\bin\PhantomJS;c:\bin\casperjs\n1k0-casperjs-4f105a9\bin

:casperjs --ignore-ssl-errors=true --verbose --log-level=debug test js\first.js
casperjs --ignore-ssl-errors=true test js\first.js

:pause