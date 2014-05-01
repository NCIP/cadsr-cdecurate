test( "GF7680 Test", function() {
    QUnit.config.autostart = false;
    ok( 1 == "1", "Passed!" );  //just a sanity check to make sure that QUnit works! ;)
    arrValidate[0] = arrValidate[2] = 'qunitTest';   //remove "view" and avoid "Please save the Permissible Value before continuing." alert!
//    view('pv0View', 'pv0ImgClose', 'pv0ImgOpen', 'view', 'pv0', 'RELEASED','true','true','RETIRED WITHDRAWN');
    //QUnit.load();
    //QUnit.start();
});