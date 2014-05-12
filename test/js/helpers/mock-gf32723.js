"use strict";

var opener, origin, obj_selCSNAMEHidden, obj_selCSCSIHidden, obj_selectedCS, obj_selACCSIHidden, selACCSIArray;

(function() {
    if(typeof document !== 'undefined') {
        //===init for doVocabChange()
        document.searchParmsForm = {};
        document.searchParmsForm.listContextFilterVocab = {};
        document.searchParmsForm.listContextFilterVocab[1] = {};
        document.searchParmsForm.listContextFilterVocab[1].text = {};
        opener = {};
        opener.document = document;
        document.newDECForm = {};
        document.newDECForm.userSelectedVocab = {};
        document.newDECForm.userSelectedVocab.value = {};
        //===init for submitValidate()
        document.newDECForm.rNameConv = {};
        document.newDECForm.rNameConv[0] = {};
        document.newDECForm.rNameConv[1] = {};
        document.newDECForm.rNameConv[2] = {};
        document.newDECForm.rNameConv[2].checked = true;
        document.newDECForm.selObjectClass = {};
        document.newDECForm.selObjectClass[0] = {};
        document.newDECForm.selObjectClass[0].selected = true;
        document.newDECForm.selPropertyClass = {};
        document.newDECForm.selPropertyClass[0] = {};
        document.newDECForm.selPropertyClass[0].selected = true;
        document.newDECForm.selObjectQualifier = {};
        document.newDECForm.selObjectQualifier[1] = {};
        document.newDECForm.selObjectQualifier[1].selected = true;
        document.newDECForm.selPropertyQualifier = {};
        document.newDECForm.selPropertyQualifier[1] = {};
        document.newDECForm.selPropertyQualifier[1].selected = true;
        document.newDECForm.selConceptualDomain = {};
        document.newDECForm.selConceptualDomain.options = {};
        document.newDECForm.selConceptualDomain.options[0] = {};
        document.newDECForm.selConceptualDomain.options[0].selected = true;
        obj_selCSNAMEHidden = obj_selCSCSIHidden = {};
        obj_selCSNAMEHidden[1] = obj_selCSCSIHidden[1] = {};
        obj_selectedCS = obj_selACCSIHidden = selACCSIArray = {};
        document.newDECForm.pageAction = {};
        document.newDECForm.pageAction.value = origin = "validate";
//        document.newDECForm.pageAction.value = "UseSelection";
//        document.newDECForm.pageAction.value = "submit";
        document.newDECForm.btnValidate = document.newDECForm.btnClear = document.newDECForm.btnAltName = document.newDECForm.btnRefDoc = {};
    }
})();

if (typeof window === 'undefined') {
    /** server side */
    exports.pickVocab = pickVocab;
    //===in place of SearchParametersBlocks.jsp#doVocabChange()
    exports.doVocabChange = function () {
        return doVocabChange();
    };
    //===in place of CreateDEC.js#SubmitValidate('validate')
    exports.SubmitValidate = function (ACRequestTypes) {
        return mockSubmitValidate(ACRequestTypes);
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
                return mockSubmitValidate(ACRequestTypes);
            };
        }
    )
}

/** Mock when a vocabulary list is selected by a user */
function pickVocab(idx, vocabName) {
    if(typeof window !== 'undefined' && typeof document !== 'undefined') {
        document.searchParmsForm.listContextFilterVocab[idx].text = vocabName;
        document.searchParmsForm.listContextFilterVocab.selectedIndex = idx;
    }
}

/** Mock of SearchParametersBlocks.jsp#doVocabChange() */
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

/** Mock when a "Validate" button is clicked by a user */
function mockSubmitValidate() {
    var stat;
    try {
        //===avoid calling the real method CreateDEC.js#SubmitValidate
        //SubmitValidate('validate');
        //=== mock up the codes inside the method instead as the following:-
        //check if the date is valid
        //check if the date is valid
        var isValid = "valid";
        //if (origin == "validate")
        //  isValid = isDateValid();
        if (isValid == "valid" && origin == "validate")
            isValid = isNameTypeValid();
        if (isValid == "valid") {
            if(typeof window !== 'undefined' && typeof document !== 'undefined') {
                //hourglass();  //GF32723
                //keep the blocks selection list selected
                selectBlocksList();
                //keep the cscsi selection list selected
                selectMultiSelectList();

                if (origin == "refresh") origin = "refreshCreateDEC";
                document.newDECForm.pageAction.value = origin;
                window.status = "Submitting data, it may take a minute, please wait.....";
                window.console && console.log("GF32723 CreateDEC.js " + window.status);
                //document.newDECForm.Message.style.visibility="visible";  //GF32723
                //disable the buttons
                document.newDECForm.btnValidate.disabled = true;
                document.newDECForm.btnClear.disabled = true;
                if (document.newDECForm.btnBack != null)
                    document.newDECForm.btnBack.disabled = true;
                document.newDECForm.btnAltName.disabled = true;
                document.newDECForm.btnRefDoc.disabled = true;
            }
            stat = "valid_submitted";
        }
    } catch (e) {
        console.log('mock-gf32723.js#mockSubmitValidate error: ' + e);
    }

    return stat;
}
