'use strict';

//var jasmine = require("jasmine-node");
//var jasmine_jquery = require("jasmine-jquery");

function callMock(name, callback) {
    if (typeof module === 'undefined') {
//        console.log("units-jas.js callMock 1");
        var tName = './helpers/' + name;
        try {
//            console.log("units-jas.js callMock 2");
            requirejs([tName], function (mock) {    //TODO: for PhantomJS, this seems to be invoked more than once!
//                console.log("units-jas.js callMock 3");
                callback(mock);
            });
        } catch(e) {
            console.log("units-jas.js callMock error: " + e);
        }
    } else {
//        console.log("units-jas.js callMock 4");
        var mock = require('./helpers/' + name);
//        console.log("units-jas.js callMock 5");
        callback(mock);
    }
}

/** define a test suite */
describe('GF7680', function() {
    var ret;

    beforeEach(function () {
    })

    /** define a test specs */
    it('PV delete should be disabled', function () {
        callMock('mock-gf7680', function(mock) {
            //jasmine.log(mock);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'true', 'RELEASED');
            //jasmine.log(ret);
            expect(ret).toContain('PVAction remove disabled');
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', 'RELEASED');
            //jasmine.log(ret);
            expect(ret).toContain('PVAction remove disabled');
        });
    });

    it('PV delete should be enabled', function () {
        callMock('mock-gf7680', function(mock) {
            //jasmine.log(mock);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', '');
            //jasmine.log(ret);
            expect(ret).not.toContain('PVAction remove disabled');
        });
    });

    it('PV/VM input should be disabled', function () {
        callMock('mock-gf7680', function(mock) {
            //jasmine.log(mock);
            var expectedStat = 'PV/VM input disabled';
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'true', 'WHATEVER');
            //jasmine.log(ret);
            expect(ret).toContain(expectedStat);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'false', 'WHATEVER');
            //jasmine.log(ret);
            expect(ret).toContain(expectedStat);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', 'RELEASED');
            jasmine.log(ret);
            expect(ret).toContain(expectedStat);
        });
    });

    it('PV/VM input should be enabled', function () {
        callMock('mock-gf7680', function(mock) {
            //jasmine.log(mock);
            var expectedStat = 'PV/VM input disabled';
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'false', 'true', 'WHATEVER');
            //jasmine.log(ret);
            expect(ret).not.toContain(expectedStat);
        });
    });
})

describe('GF32723', function() {
    var ret;

    beforeEach(function () {
    });

    /** define a test specs */
    it('Altername name should be created', function () {
        callMock('mock-gf32723', function (mock) {
            //jasmine.log(mock);
            if(typeof document !== 'undefined') {
                mock.pickVocab(1, "NCI Thesaurus");
                var ret = mock.doVocabChange();
                expect(ret).toBe(ret === "NCI Thesaurus");
                try {
                    mock.SubmitValidate('validate');
                    expect(mock.SubmitValidate()).toThrow(); //"No raised error during submission"   //TODO caused "Error: Actual is not a function"
                } catch (e) {
                    expect(false).toBeTruthy(); throw e;
                }
                try {
                    ret = mock.SubmitValidate('validate');  //"Alternate name submitted successfully"
                    expect(ret).toEqual("1valid_submitted");
                } catch (e) {
                    expect(false).toBeTruthy(); throw e;
                }
            } else {
                jasmine.log('Skipped!');
                expect(true).toBe(true);
            }
        });
    });
})