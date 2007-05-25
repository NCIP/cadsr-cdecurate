// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/navbar.js,v 1.4 2007-05-25 05:03:27 hegdes Exp $
// $Name: not supported by cvs2svn $

if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML.toLowerCase();var last=tt.indexOf("navbar.js\"");if(last>0){var first=tt.lastIndexOf("\"",last);if(first>0&&first<last)loc=document.body.innerHTML.substr(first+1,last-first-1);}}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".navbar_menu {border-color:black;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#3300cc;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write("a.navbar_plain:link, a.navbar_plain:visited{text-align:left;background-color:#3300cc;color:#ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:15pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.navbar_plain:hover, a.navbar_plain:active{background-color:#ff9900;color:#000000;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:15pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.navbar_l:link, a.navbar_l:visited{text-align:left;background:#3300cc url("+loc+"navbar_l.gif) no-repeat right;color:#ffffff;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:15pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("a.navbar_l:hover, a.navbar_l:active{background:#ff9900 url("+loc+"navbar_l2.gif) no-repeat right;color: #000000;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:2px 0px 2px 0px;cursor:hand;display:block;font-size:15pt;font-family:Arial, Helvetica, sans-serif;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0x000000;
var bc=0xff9900;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("",0,0,2,0,0)
mainMenuItem("navbar_b1",".gif",26,89,"javascript:;","","Search",2,2,"navbar_plain");
mainMenuItem("navbar_b2",".gif",26,89,"javascript:;","","Create",2,2,"navbar_plain");
mainMenuItem("navbar_b3",".gif",26,89,"javascript:;","","Edit",2,2,"navbar_plain");
mainMenuItem("navbar_b4",".gif",26,89,"javascript:;","","Manage",2,2,"navbar_plain");
mainMenuItem("navbar_b5",".gif",26,89,"javascript:;","","Options",2,2,"navbar_plain");
mainMenuItem("navbar_b6",".gif",26,89,"javascript:;","","Help",2,2,"navbar_plain");
endMainMenu("",0,0);

startSubmenu("navbar_b3_1","navbar_menu",224);
submenuItem("Single Data Element","javascript:;","","navbar_plain");
submenuItem("Block of Data Elements","javascript:;","","navbar_plain");
endSubmenu("navbar_b3_1");

startSubmenu("navbar_b3","navbar_menu",236);
mainMenuItem("navbar_b3_1","Data Element",0,0,"javascript:;","","",1,1,"navbar_l");
submenuItem("Data Element Concept","javascript:;","","navbar_plain");
endSubmenu("navbar_b3");

startSubmenu("navbar_b2_3","navbar_menu",267);
submenuItem("New - From Scratch","javascript:;","","navbar_plain");
submenuItem("New Using DEC as template","javascript:;","","navbar_plain");
submenuItem("New Version","javascript:;","","navbar_plain");
endSubmenu("navbar_b2_3");

startSubmenu("navbar_b2_2","navbar_menu",267);
submenuItem("New - From Scratch","javascript:;","","navbar_plain");
submenuItem("New Using DEC as template","javascript:;","","navbar_plain");
submenuItem("New Version","javascript:;","","navbar_plain");
endSubmenu("navbar_b2_2");

startSubmenu("navbar_b2_1","navbar_menu",253);
submenuItem(" New - From Scratch","javascript:;","","navbar_plain");
submenuItem("New Using DE as template","javascript:;","","navbar_plain");
submenuItem("New Version","javascript:;","","navbar_plain");
endSubmenu("navbar_b2_1");

startSubmenu("navbar_b2","navbar_menu",236);
mainMenuItem("navbar_b2_1","Data Element",0,0,"javascript:;","","",1,1,"navbar_l");
mainMenuItem("navbar_b2_2","Data Element Concept",0,0,"javascript:;","","",1,1,"navbar_l");
mainMenuItem("navbar_b2_3","Value Domain",0,0,"javascript:;","","",1,1,"navbar_l");
endSubmenu("navbar_b2");

loc="";
