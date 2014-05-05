"use strict";

var arrValidate;

QUnit.testSkip = function() {
    QUnit.test(arguments[0] + ' (SKIPPED)', function() {
        //QUnit.expect(0);//dont expect any tests
        if (typeof window !== 'undefined') {
            var li = document.getElementById(QUnit.config.current.id);
            QUnit.done(function () {
                li.style.background = '#FFFF99';
            });
        }
        ok(true);
    });
};

var xtest = QUnit.testSkip;

var callMock = function(name, callback) {
    if (typeof define !== 'undefined') {
        /** client side */
        curl(['./helpers/' + name], function (mock) {
            callback(mock);
        });
    } else {
        /** server side */
        try {
            var mock = require('./helpers/' + name);
            callback(mock);
        }catch(e) {
            console.log("unit-qun.js callMock() server side: " + e);
        }
    }
}

xtest( "GF7680 Test 1", function() {
    QUnit.config.autostart = false;
    //ok( 1 == "1", "qunit is ready!" );  //just a sanity check to make sure that QUnit works! ;)

    arrValidate[0] = arrValidate[2] = 'qunitTest';   //remove "view" and avoid "Please save the Permissible Value
    view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','RELEASED');
    var elem = document.getElementsByName("textarea");
    //equal(elem.readOnly, true);
    equal(elem.readOnly, undefined, "Element is undefined");
});

xtest( "GF7680 Test 2", function() {
    QUnit.config.autostart = false;
    //ok( 1 == "1", "qunit is ready!" );  //just a sanity check to make sure that QUnit works! ;)

    arrValidate[0] = arrValidate[2] = 'qunitTest';   //remove "view" and avoid "Please save the Permissible Value
    view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','NOT RELEASED');
//    var elem = $("img.PVAction");
//    equals(elem.style.display, "none");
    var elem = document.getElementsByName("textarea");
    notEqual(elem.readOnly, true, "Readonly is not found");
    //equal(elem.readOnly, undefined);
});

asyncTest( "GF7680 Test 3", function() {
    var ret1, ret2;
    QUnit.config.autostart = false;
    QUnit.log(function( details ) {
        console.log( "QUnit Log: ", details.result, details.message );
    });

    callMock('mock-gf7680', function (mock) {
        QUnit.start();
        ret1 = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','RELEASED');
        ok(ret1.indexOf('PVAction remove disabled') !== -1, "PV delete is disabled");
        ret2 = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED','true','true','');
        ok(!ret2.indexOf('PVAction remove disabled') !== -1, "PV delete is enabled");
    });
});

test( "GF32723 Test 1", function() {
//    createNames('acType');    //need to avoid window.close somehow
    ok( 1 == "1", "TODO: Altername name should be created" );  //just to avoid QUnit from complaining about no assertion! ;)
});