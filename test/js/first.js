/*==============================================================================*/
/* Casper generated Fri Apr 25 2014 11:20:01 GMT-0400 (Eastern Daylight Time) */
/*==============================================================================*/

var x = require('casper').selectXPath;
casper.options.viewportSize = {width: 1517, height: 714};
casper.on('page.error', function(msg, trace) {
    this.echo('Error: ' + msg, 'ERROR');
    for(var i=0; i<trace.length; i++) {
        var step = trace[i];
        this.echo('   ' + step.file + ' (line ' + step.line + ')', 'ERROR');
    }
});
casper.test.begin('Resurrectio test', function(test) {
    casper.start('http://localhost:8080/cdecurate');
//    casper.start('https://cdecurate-dev.nci.nih.gov');
    casper.waitForSelector("#listSearchFor",
        function success() {
            test.assertExists("#listSearchFor");
            this.click("#listSearchFor");
            this.sendKeys("input[name='keyword']", "ana*\r");
        },
        function fail() {
            test.assertExists("#listSearchFor");
        });
    casper.waitForSelector("input[name='keyword']",
        function success() {
            test.assertTextExists('Anastrozole Administrered Medication Route of Administration Type', 'last results should has this DE long name');
        },
        function fail() {
            test.assertExists("input[name='keyword']");
        });
    casper.waitForSelector("#listMultiContextFilter option:nth-child(2)",
        function success() {
            test.assertExists("#listMultiContextFilter option:nth-child(2)");
            this.click("#listMultiContextFilter option:nth-child(2)");
        },
        function fail() {
            test.assertExists("#listMultiContextFilter option:nth-child(2)");
        });
    casper.waitForSelector("form[name=searchParmsForm] input[name='keyword']",
        function success() {
            test.assertExists("form[name=searchParmsForm] input[name='keyword']");
            this.click("form[name=searchParmsForm] input[name='keyword']");
        },
        function fail() {
            test.assertExists("form[name=searchParmsForm] input[name='keyword']");
        });
    casper.waitForSelector("input[name='keyword']",
        function success() {
            this.sendKeys("input[name='keyword']", "blood\r");
        },
        function fail() {
            test.assertExists("input[name='keyword']");
        });
    casper.waitForSelector("#listAttrFilter option:nth-child(1)",
        function success() {
            test.assertExists("#listAttrFilter option:nth-child(1)");
            this.click("#listAttrFilter option:nth-child(1)");
        },
        function fail() {
            test.assertExists("#listAttrFilter option:nth-child(1)");
        });
    casper.waitForSelector("form[name=searchParmsForm] input[type=button][value='Update']",
        function success() {
            test.assertExists("form[name=searchParmsForm] input[type=button][value='Update']");
            this.click("form[name=searchParmsForm] input[type=button][value='Update']");
        },
        function fail() {
            test.assertExists("form[name=searchParmsForm] input[type=button][value='Update']");
        });
    casper.then(function(){
        casper.evaluate(function() {
            //=== select the VD
            var sel1 = document.querySelector('select[name=listSearchFor]');
            sel1.value = 'ValueDomain';
            var evt = document.createEvent('HTMLEvents');
            evt.initEvent('change', true, false);
            sel1.dispatchEvent(evt);
    	});
    });
    casper.then(function() {
        this.captureSelector("result.png", "html");
    });
    casper.run(function() {test.done();});
});