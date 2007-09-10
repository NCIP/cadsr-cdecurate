// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/biztech_button.js,v 1.1 2007-09-10 16:16:48 hebell Exp $
// $Name: not supported by cvs2svn $

if(typeof(loc)=="undefined"||loc==""){var loc="";if(document.body&&document.body.innerHTML){var tt=document.body.innerHTML.toLowerCase();var last=tt.indexOf("biztech_button.js\"");if(last>0){var first=tt.lastIndexOf("\"",last);if(first>0&&first<last)loc=document.body.innerHTML.substr(first+1,last-first-1);}}}

var bd=0
document.write("<style type=\"text/css\">");
document.write("\n<!--\n");
document.write(".biztech_button_menu {border-color:black;border-style:solid;border-width:"+bd+"px 0px "+bd+"px 0px;background-color:#7f7fad;position:absolute;left:0px;top:0px;visibility:hidden;}");
document.write("a.biztech_button_plain:link, a.biztech_button_plain:visited{text-align:left;background-color:#7f7fad;color:#ffff99;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:12pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.biztech_button_plain:hover, a.biztech_button_plain:active{background-color:#ffff99;color:#3c0323;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:12pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.biztech_button_l:link, a.biztech_button_l:visited{text-align:left;background:#7f7fad url("+loc+"../images/biztech_button_l.gif) no-repeat right;color:#ffff99;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:12pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("a.biztech_button_l:hover, a.biztech_button_l:active{background:#ffff99 url("+loc+"../images/biztech_button_l2.gif) no-repeat right;color: #3c0323;text-decoration:none;border-color:black;border-style:solid;border-width:0px "+bd+"px 0px "+bd+"px;padding:0px 0px 0px 0px;cursor:hand;display:block;font-size:12pt;font-family:Arial, Helvetica, sans-serif;font-weight:bold;}");
document.write("\n-->\n");
document.write("</style>");

var fc=0x3c0323;
var bc=0xffff99;
if(typeof(frames)=="undefined"){var frames=0;}

startMainMenu("",0,0,2,0,2)
mainMenuItem("../images/biztech_button_b1",".gif",30,78,loc+"../NCICurationServlet?reqType=getSearchFilter","","Search",2,2,"biztech_button_plain");
mainMenuItem("../images/biztech_button_b2",".gif",30,78,"javascript:;","","Create",2,2,"biztech_button_plain");
mainMenuItem("../images/biztech_button_b3",".gif",30,78,"javascript:;","","Edit",2,2,"biztech_button_plain");
mainMenuItem("../images/biztech_button_b5",".gif",30,78,"javascript:;","","Options",2,2,"biztech_button_plain");
mainMenuItem("../images/biztech_button_b6",".gif",30,78,"javascript:callHelp();","","Help",2,2,"biztech_button_plain");
mainMenuItem("../images/biztech_button_b7",".gif",30,78,"javascript:callLogout();","","Logout",2,2,"biztech_button_plain");
endMainMenu("",0,0);

startSubmenu("../images/biztech_button_b5","biztech_button_menu",175);
submenuItem("About","javascript:callAboutAlert();","","biztech_button_plain");
submenuItem("Sentinel Tool","javascript:callSentinel();","","biztech_button_plain");
submenuItem("UML Model Browser","javascript:callUMLBrowser();","","biztech_button_plain");
endSubmenu("../images/biztech_button_b5");

startSubmenu("../images/biztech_button_b3","biztech_button_menu",204);
submenuItem("Data Element","javascript:callMessageGifDEedit();","","biztech_button_plain");
submenuItem("Data Element Concept","javascript:callMessageGifDECedit();","","biztech_button_plain");
submenuItem("Value Domain","javascript:callMessageGifVDedit();","","biztech_button_plain");
endSubmenu("../images/biztech_button_b3");

startSubmenu("biztech_button_b2_3","biztech_button_menu",280);
submenuItem("New","javascript:callMessageGifVDNew();","","biztech_button_plain");
submenuItem("New Using Existing Value Domain","javascript:callMessageGifVDTemplate();","","biztech_button_plain");
submenuItem("New Version","javascript:callMessageGifVDVersion();","","biztech_button_plain");
endSubmenu("biztech_button_b2_3");

startSubmenu("biztech_button_b2_2","biztech_button_menu",340);
submenuItem("New","javascript:callMessageGifDECNew();","","biztech_button_plain");
submenuItem("New Using Existing Data Element Concept", "javascript:callMessageGifDECTemplate();","","biztech_button_plain");
submenuItem("New Version","javascript:callMessageGifDECVersion();","","biztech_button_plain");
endSubmenu("biztech_button_b2_2");

startSubmenu("biztech_button_b2_1","biztech_button_menu",270);
submenuItem("New","javascript:callMessageGifDENew();","","biztech_button_plain");
submenuItem("New Using Existing Data Element", "javascript:callMessageGifDETemplate();","","biztech_button_plain");
submenuItem("New Version","javascript:callMessageGifDEVersion();","","biztech_button_plain");
endSubmenu("biztech_button_b2_1");

startSubmenu("../images/biztech_button_b2","biztech_button_menu",204);
mainMenuItem("biztech_button_b2_1","Data Element",0,0,"javascript:;","","",1,1,"biztech_button_l");
mainMenuItem("biztech_button_b2_2","Data Element Concept",0,0,"javascript:;","","",1,1,"biztech_button_l");
mainMenuItem("biztech_button_b2_3","Value Domain",0,0,"javascript:;","","",1,1,"biztech_button_l");
endSubmenu("../images/biztech_button_b2");

loc="";