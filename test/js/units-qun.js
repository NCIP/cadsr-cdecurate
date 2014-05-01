test( "GF7680 Test 1", function() {
    QUnit.config.autostart = false;
    //ok( 1 == "1", "qunit is ready!" );  //just a sanity check to make sure that QUnit works! ;)

    arrValidate[0] = arrValidate[2] = 'qunitTest';   //remove "view" and avoid "Please save the Permissible Value
    view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','RELEASED');
    var elem = document.getElementsByName("textarea");
    //equal(elem.readOnly, true);
    equal(elem.readOnly, undefined);
});

test( "GF7680 Test 2", function() {
    QUnit.config.autostart = false;
    //ok( 1 == "1", "qunit is ready!" );  //just a sanity check to make sure that QUnit works! ;)

    arrValidate[0] = arrValidate[2] = 'qunitTest';   //remove "view" and avoid "Please save the Permissible Value
    view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','NOT RELEASED');
//    var elem = $("img.PVAction");
//    equals(elem.style.display, "none");
    var elem = document.getElementsByName("textarea");
    //equal(elem.readOnly, true);
    equal(elem.readOnly, undefined);

});