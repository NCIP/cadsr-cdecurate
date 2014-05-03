"use strict";

//require('../../../WebRoot/js/SearchResultsBlocks');

/**
 * Define a CommonJS-style module to isolate the mocking codes in a module
 */
if (typeof define === 'function') {
    /** client side */
    define(['require', 'exports', 'module'], function (require, exports, module) {
        exports.createNamesMock = function (acType) {
            createNames(acType);
        };
    });
} else
if (typeof define === undefined) {
    /** server side */
    exports.createNamesMock = function(acType) {
        //createNames(acType);
        console.log('mock-gf32723 TODO');
    };
}