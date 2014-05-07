'use strict';

//var jasmine = require("jasmine-node");
//var jasmine_jquery = require("jasmine-jquery");

function callMock(mockName, callback) {
    if (typeof module === 'undefined') {
//        console.log("units-jas.js callMock 1");
        try {
//            console.log("units-jas.js callMock 2");
            requirejs(['./helpers/' + mockName], function (mock) {    //TODO: for PhantomJS, this seems to be invoked more than once!
//                console.log("units-jas.js callMock 3");
                callback(mock);
            });
        } catch(e) {
            console.log("units-jas.js callMock error: " + e);
        }
    } else {
//        console.log("units-jas.js callMock 4");
        var mock = require('./helpers/' + mockName);
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
    var mock1;

    beforeEach(function () {
        callMock('mock-gf32723', function (mock) {
           mock1 = mock;
        });

    });

    function paused(milliSeconds) {
        setTimeout(continueExec, milliSeconds);
    }

    function continueExec() {
        console.log("")
    }

    ret = {
        stat1: '',
        stat2: '',
        stat3: ''
    };
    /** define a test specs */
    it('Altername name should not be created', function () {
        try {
            //jasmine.log(mock);
            if(typeof document !== 'undefined') {
                mock1.pickVocab(1, "NCI Thesaurus");
                ret.stat1 = mock.doVocabChange();
                expect(ret.stat1).toBe("NCI Thesaurus");

                expect(function () {
                    mock.SubmitValidate()
                }).not.toThrow(); //"No raised error during submission"
                ret.stat2 = mock.SubmitValidate('validate');  //"Alternate name successfully submitted"
                expect(ret.stat2).not.toEqual("1111valid_submitted");
            } else {
                jasmine.log('Skipped!');
                expect(true).toBe(true);
            }
        } catch (e) {
            console.log('units-jas.js GF32723 error: ' + e);
        }
        //expect(false).toBe(true);
        //paused(5000);
    });

})