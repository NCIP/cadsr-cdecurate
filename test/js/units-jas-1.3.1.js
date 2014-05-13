'use strict';

//var jasmine = require("jasmine-node");
//var jasmine_jquery = require("jasmine-jquery");

function callMock(mockName, callback) {
    if (typeof module === 'undefined') {
//        console.log("units-jas-1.3.1.js callMock 1");
        try {
//            console.log("units-jas-1.3.1.js callMock 2");
            requirejs(['./helpers/' + mockName], function (mock) {
//                console.log("units-jas-1.3.1.js callMock 3");
                callback(mock);
            });
        } catch(e) {
            console.log("units-jas-1.3.1.js callMock error: " + e);
        }
    } else {
//        console.log("units-jas-1.3.1.js callMock 4");
        var mock = require('./helpers/' + mockName);
//        console.log("units-jas-1.3.1.js callMock 5");
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

var stats = [];
describe('GF32723', function() {
    var ret;
    var spec = ['Alternate Name Specs'];
    var specm = [];

    beforeEach(function () {
        specm.push('Vocabulary picked should be NCIt');
        specm.push('Altername name should not be created');
    });

    /** define a test specs */
    it(spec[0], function () {
        var ret;
        //TODO: for PhantomJS to avoid timeout
//        requirejs(['phantom'], function(phantom) {
//            phantom.create(function (ph) {
//                ph.createPage(function (page) {
//                    page.settings.resourceTimeout = 3000; // 3 seconds
//                });
//            });
//        });
        //TODO: for PhantomJS to avoid timeout

        runs(function () {
            try {
                callMock('mock-gf32723', function (mock) {
                    //jasmine.log(mock);
                    if (typeof document !== 'undefined') {
                        mock.pickVocab(1, "NCI Thesaurus");
                        ret = mock.doVocabChange();
                        stats.push(ret);
                        expect(function () {
                            mock.SubmitValidate()
                        }).not.toThrow(); //"No raised error during submission"
                        ret = mock.SubmitValidate('validate');  //"Alternate name successfully submitted"
                        stats.push(ret);
                    } else {
                        jasmine.log('Skipped!');
                        expect(true).toBe(true);
                    }
                });
            } catch (e) {
                console.log('units-jas-1.3.1.js GF32723 error: ' + e);
            }
            //expect(false).toBe(true);
        });

        waitsFor(function() {
            var flag;
            if(stats.length === 2) {
                expect(stats).toEqual(['NCI Thesaurus', 'valid_submitted']);

                console.log("Async spec done!");
                flag = true;
            }
            return flag;
        }, spec[0], 1500);
    });

})