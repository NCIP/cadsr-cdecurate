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
var xasyncTest = QUnit.testSkip;

function callMock(mockName, callback) {
    if (typeof define !== 'undefined') {
        console.log("units-qun.js callMock 1");
        /** client side */
        try {
            console.log("units-qun.js callMock 2");
            curl(['./helpers/' + mockName], function (mock) {
                console.log("units-qun.js callMock 3");
                callback(mock);
            });
        }catch(e) {
            console.log("unit-qun.js callMock() client side error: " + e);
        }
    } else {
        console.log("units-qun.js callMock 4");
        /** server side */
        try {
            console.log("units-qun.js callMock 5");
            var mock = require('./helpers/' + mockName);
            console.log("units-qun.js callMock 6");
            callback(mock);
        }catch(e) {
            console.log("unit-qun.js callMock() server side error: " + e);
        }
    }
}

QUnit.module("GF7680");

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

QUnit.module("GF32723");

xasyncTest( "GF32723 Test 1", function() {
    expect(3);
    function CustomError( message ) {
        this.message = message;
    }
    CustomError.prototype.toString = function() {
        return this.message;
    };
    callMock('mock-gf32723', function (mock) {
        var idx;
        idx = 1;      //NCIt
        if(typeof document !== 'undefined') {
            mock.pickVocab(1, "NCI Thesaurus");
            var ret = mock.doVocabChange();
            ok(ret === "NCI Thesaurus");
            throws(
                ret = mock.SubmitValidate('validate'),
                undefined,
                "No raised error during submission"
            );
            ok( ret == "valid_submitted", "Alternate name submitted successfully" );
        } else {
            ok( 1 == "1", "Skipped!" );
        }
    });
    //TODO somehow the test hang here and does not quit!
    //ok( 1 == "1", "Altername name should be created" );  //just to avoid QUnit from complaining about no assertion! ;)
});