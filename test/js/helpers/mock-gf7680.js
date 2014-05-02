"use strict";

/**
 * Define a CommonJS-style module to isolate the mocking codes in a module
 */
if (typeof define === 'function') {
    /** client side */
    define(function (require, exports, module) {
        //var dep1 = require('app/foo');
        exports.view = function (pvd, imgdhide, imgddisp, action, pvNo, vdwfstatus, vdusedinform, pvusedinform, fmwfstatus) {
            /**
             * These piece of codes should have been wrapped in function but it didn't. Thus this mock is created to make it testable.
             */
            var status = '';

            if (fmwfstatus !== 'null') { //only for existing VD
                if ((vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true') /* cond 2 and 3 */ ||
                    (vdwfstatus !== 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true' && fmwfstatus === 'RELEASED' /* cond 5 */)
                    ) {
                    //#1 disablement
                    dojo.query("img.PVAction").forEach(function (node, index) {
                        try {
                            var altText = node.getAttribute('alt');
                            //window.console && console.log('PVAction altText [' + altText + ']');
                            if (altText === 'Remove') {
                                dojo.style(node, 'display', 'none');
                                window.console && console.log('PVAction remove disabled');
                                status = 'PVAction remove disabled';
                            }
                        } catch (e) {
                            window.console && console.log('Error: Not able to disable PVAction remove, ' + e);
                        }
                    });
                }
                if ((vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true') /* cond 2 and 3 */ ||
                    (vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'false') /* cond 4 */ ||
                    (vdwfstatus !== 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true' && fmwfstatus === 'RELEASED' /* cond 5 */)
                    ) {
                    //#2 disablement
                    dojo.query('[id^="txtpv"]').forEach(function (node, index, arr) { //GF7680 "txtpvonly" has to be the same as gov.nih.nci.cadsr.common.PV_NAME
                        try {
                            dojo.attr(node, "readonly", true);
                            window.console && console.log('PV/VM input disabled');
                            status = 'PV/VM input disabled';
                        } catch (e) {
                            window.console && console.log('Error: Not able to disable PV/VM input, ' + e);
                        }
                    });
                }
                //#4 please keep the following for future requirements changes, if any
                /*
                 dojo.query("img.ConceptAction").forEach(function(node, index){
                 var altText = node.getAttribute('alt');
                 //window.console && console.log('ConceptAction altText [' + altText + ']');
                 if(altText === 'Remove') {
                 dojo.style(node, 'display', 'none');
                 window.console && console.log('ConceptAction remove disabled');
                 }
                 });
                 */

                return status;
            }
        };
    });
} else {
    /** server side */
    exports.view = function(pvd, imgdhide, imgddisp, action, pvNo, vdwfstatus, vdusedinform, pvusedinform, fmwfstatus) {
        /**
         * These piece of codes should have been wrapped in function but it didn't. Thus this mock is created to make it testable. Also dojo codes and window.console are commented out, as those are client side component.
         */
        var status = '';

        if (fmwfstatus !== 'null') { //only for existing VD
            if ((vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true') /* cond 2 and 3 */ ||
                (vdwfstatus !== 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true' && fmwfstatus === 'RELEASED' /* cond 5 */)
                ) {
                //#1 disablement
//                dojo.query("img.PVAction").forEach(function (node, index) {
                    try {
//                        var altText = node.getAttribute('alt');
//                        //window.console && console.log('PVAction altText [' + altText + ']');
//                        if (altText === 'Remove') {
//                            dojo.style(node, 'display', 'none');
                            console.log('PVAction remove disabled');
                            status += 'PVAction remove disabled';
//                        }
                    } catch (e) {
                        console.log('Error: Not able to disable PVAction remove, ' + e);
                    }
//                });
            }
            if ((vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true') /* cond 2 and 3 */ ||
                (vdwfstatus === 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'false') /* cond 4 */ ||
                (vdwfstatus !== 'RELEASED' && vdusedinform === 'true' && pvusedinform === 'true' && fmwfstatus === 'RELEASED' /* cond 5 */)
                ) {
                //#2 disablement
//                dojo.query('[id^="txtpv"]').forEach(function (node, index, arr) { //GF7680 "txtpvonly" has to be the same as gov.nih.nci.cadsr.common.PV_NAME
                    try {
//                        dojo.attr(node, "readonly", true);
                        console.log('PV/VM input disabled');
                        status += 'PV/VM input disabled';
                    } catch (e) {
                        console.log('Error: Not able to disable PV/VM input, ' + e);
                    }
//                });
            }
            //#4 please keep the following for future requirements changes, if any
            /*
             dojo.query("img.ConceptAction").forEach(function(node, index){
             var altText = node.getAttribute('alt');
             //window.console && console.log('ConceptAction altText [' + altText + ']');
             if(altText === 'Remove') {
             dojo.style(node, 'display', 'none');
             window.console && console.log('ConceptAction remove disabled');
             }
             });
             */

            return status;
        }
    };
}