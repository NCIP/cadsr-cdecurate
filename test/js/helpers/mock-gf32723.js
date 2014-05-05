"use strict";

//require('../../../WebRoot/js/SearchResultsBlocks');

/**
 * Define a CommonJS-style module to isolate the mocking codes in a module
 */
if (typeof window === 'undefined') {
    /** server side */
    exports.createNamesMock = function(acType) {
        //createNames(acType);
        console.log('mock-gf32723 TODO');
    };
} else
if (typeof define === 'function') {
    /** client side */
    if(typeof module !== 'undefined') {
        define(['require', 'exports', 'module'], function (require, exports, module) {
            exports.createNamesMock = function (acType) {
//            require('../../../WebRoot/js/SearchResultsBlocks', function(search) {
//                createNames(acType);
//            });
            };
        });
    }
}