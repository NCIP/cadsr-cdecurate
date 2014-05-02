//var jasmine = require("jasmine-node");
//var jasmine_jquery = require("jasmine-jquery");

/** define a test suite */
describe('GF7680', function() {
    var ret;
    var mock;

    beforeEach(function () {
        mock = require('../helpers/mock-gf7680');
    });

    /** define a test specs */
    it('PV delete should be disabled', function () {
        ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED', 'true', 'true', 'RELEASED');
        //jasmine.log(ret);
        expect(ret).toContain('PVAction remove disabled');
        ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', 'RELEASED');
        //jasmine.log(ret);
        expect(ret).toContain('PVAction remove disabled');
    });

    it('PV delete should be enabled', function () {
        ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'true', 'true', '');
        //jasmine.log(ret);
        expect(ret).not.toContain('PVAction remove disabled');
    });

    it('PV/VM input should be disabled', function () {
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

    it('PV/VM input should be enabled', function () {
        var expectedStat = 'PV/VM input disabled';
        ret = mock.view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'NOT RELEASED', 'false', 'true', 'WHATEVER');
        //jasmine.log(ret);
        expect(ret).not.toContain(expectedStat);
    });
})

describe('GF32723', function() {
    var ret;
    var mock;

    beforeEach(function () {
        mock = require('../helpers/mock-gf32723');
    });

    /** define a test specs */
    it('PV delete should be disabled', function () {
        mock.createNamesMock('DEC');
        //jasmine.log(ret);
        //expect(ret).toContain('PVAction remove disabled');
    });
})