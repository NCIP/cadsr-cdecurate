"use strict";

var opener;

(function() {
    if(typeof document !== 'undefined') {
        document.searchParmsForm = {};
        document.searchParmsForm.listContextFilterVocab = {};
        //document.searchParmsForm.listContextFilterVocab[17] = [{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{}];
        document.searchParmsForm.listContextFilterVocab[1] = {};
        document.searchParmsForm.listContextFilterVocab[1].text = {};
        opener = {};
        opener.document = document;
        document.newDECForm = {};
        document.newDECForm.userSelectedVocab = {};
        document.newDECForm.userSelectedVocab.value = {};
    }
})();

/**
 * Define a CommonJS-style module to isolate the mocking codes in a module
 */
if (typeof window === 'undefined') {
    /** server side */
    exports.pickVocab = pickVocab;
    //===in place of SearchParametersBlocks.jsp#doVocabChange()
    exports.doVocabChange = function () {
        return doVocabChange();
    };
    //===in place of CreateDEC.js#SubmitValidate('validate')
    exports.SubmitValidate = function (ACRequestTypes) {
        SubmitValidate(ACRequestTypes);
    };
} else
if (typeof define === 'function') {
    /** client side */
    define(
        ['require', 'exports', 'module'],
        function (require, exports, module) {
            exports.pickVocab = pickVocab;
            //===in place of SearchParametersBlocks.jsp#doVocabChange()
            exports.doVocabChange = function () {
                return doVocabChange();
            };
            //===in place of CreateDEC.js#SubmitValidate('validate')
            exports.SubmitValidate = function (ACRequestTypes) {
                SubmitValidate(ACRequestTypes);
            };
        }
    )
}

function pickVocab(idx, vocabName) {
    if(typeof window !== 'undefined' && typeof document !== 'undefined') {
        document.searchParmsForm.listContextFilterVocab[idx].text = vocabName;
        document.searchParmsForm.listContextFilterVocab.selectedIndex = idx;
    }
}

function doVocabChange() {
    var stat = "";

    if(typeof window !== 'undefined' && typeof document !== 'undefined') {
        try {
            var idx = document.searchParmsForm.listContextFilterVocab.selectedIndex;
            opener.document.newDECForm.userSelectedVocab.value = document.searchParmsForm.listContextFilterVocab[idx].text;
            window.userSelectedVocab = opener.document.newDECForm.userSelectedVocab.value; //TODO global is bad we know!
            stat = window.userSelectedVocab;
        }catch(e) {
            console.log("mock-gf32723.js doVocabChange() error: " + e);
        }
    }

    return stat;
}

function SubmitValidate() {

}
