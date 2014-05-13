//        var logger = log4javascript.getLogger("JasmineClientUnitTests");
//        logger.setLevel(log4javascript.Level.ALL);
//        logger.addAppender(new log4javascript.BrowserConsoleAppender());
//        window.logger = logger;
//        logger.debug("debug: activate-tests-runner.html::log4javascript ready to rock the mic.");

require.config({
//    baseUrl: "./js",
    optimize: "none",
    paths: {
        jasmine: "./vendors/jasmine-2.0.0/jasmine",
        jasmineHtml: "./vendors/jasmine-2.0.0/jasmine-html",
//                        jasmineBoot: "./vendors//jasmine-2.0.0/boot",
        createDEC: '../../WebRoot/js/CreateDEC',
        SelectCS_CSI: '../../WebRoot/js/SelectCS_CSI',
        gf7680: './helpers/mock-gf7680',
        gf32723: './helpers/mock-gf32723',
        test: './units-jas'
    },
    shim: {
        gf7680: {
            exports: 'gf7680'
        },
        gf32723: {
            exports: 'gf32723'
        },
        jasmine: {
            exports: 'jasmine'
        },
        jasmineHtml: {
            deps: [
                'jasmine'
            ]
        },
//                        jasmineBoot: {
//                            deps: [
//                                'jasmine'
//                            ]
//                        },
        test: {
            deps: [
                'jasmine',
//                                'jasmineBoot',
                'jasmineHtml',
                'createDEC', 'SelectCS_CSI', 'gf7680', 'gf32723'],
            exports: 'test'
        }
    }
    ,
    waitSeconds: 120     //timeout in seconds if not able to load any of the external URL above
});
