"use strict";

require('../../../WebRoot/js/SearchResultsBlocks');

/**
 * Define a CommonJS-style module to isolate the mocking codes in a module
 */
if (typeof define === 'function') {
    /** client side */
    define(function (require, exports, module) {
        exports.createNamesMock = function (acType) {
            createNames(acType);
        };
    });
} else {
    /** server side */
    exports.createNamesMock = function(acType) {
        //createNames(acType);
        console.log('mock-gf32723 TODO');
    };
}