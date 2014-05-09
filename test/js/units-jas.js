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
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'true', 'RELEASED');
            expect(ret).toContain('PVAction remove disabled');
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', 'RELEASED');
            expect(ret).toContain('PVAction remove disabled');
        });
    });

    it('PV delete should be enabled', function () {
        callMock('mock-gf7680', function(mock) {
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', '');
            expect(ret).not.toContain('PVAction remove disabled');
        });
    });

    it('PV/VM input should be disabled', function () {
        callMock('mock-gf7680', function(mock) {
            var expectedStat = 'PV/VM input disabled';
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'true', 'WHATEVER');
            expect(ret).toContain(expectedStat);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'false', 'WHATEVER');
            expect(ret).toContain(expectedStat);
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', 'RELEASED');
            expect(ret).toContain(expectedStat);
        });
    });

    it('PV/VM input should be enabled', function () {
        callMock('mock-gf7680', function(mock) {
            var expectedStat = 'PV/VM input disabled';
            ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'false', 'true', 'WHATEVER');
            expect(ret).not.toContain(expectedStat);
        });
    });
})

describe('GF32723', function() {
    var stats = [];
    var ret;
    var spec = 'Alternate Name Specs';
    var specm = [];
    var mock;
    var originalTimeout;

    beforeEach(function(done) {
        originalTimeout = jasmine.DEFAULT_TIMEOUT_INTERVAL;
        jasmine.DEFAULT_TIMEOUT_INTERVAL = 5000;
        callMock('mock-gf32723', function (mock1) {
            mock = mock1;
            specm.push('Vocabulary picked should be NCIt');
            specm.push('Altername name should not be created');
            specm.push('Altername name should be created');
            done();
        });
    });

    afterEach(function(){
        expect(stats).toEqual(['NCI Thesaurus', 'valid_submitted']);
        jasmine.DEFAULT_TIMEOUT_INTERVAL = originalTimeout;
    });

    /** define a test specs */
    it(spec, function(done) {
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

        try {
            if (typeof document !== 'undefined') {
                mock.pickVocab(1, "NCI Thesaurus");
                ret = mock.doVocabChange();
                stats.push(ret);
                expect(function () {
                    mock.SubmitValidate()
                }).not.toThrow(); //"No raised error during submission"
                ret = mock.SubmitValidate('validate');  //"Alternate name successfully submitted"
                stats.push(ret);
                done();
            } else {
                jasmine.log('Skipped!');
                expect(true).toBe(true);
            }
        } catch (e) {
            console.log('units-jas.js GF32723 error: ' + e);
        }
    });
})