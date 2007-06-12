// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/popupMenus.js,v 1.8 2007-06-12 20:27:24 hegdes Exp $
// $Name: not supported by cvs2svn $

/* define variables for "if n4 (Netscape 4), if IE (IE 4.x), 
and if n6 (if Netscape 6/W3C-DOM compliant)" */

var n4, ie, n6;

/* detecting browser support for certain key objects/methods and 
assembling a custom document object */


var doc,doc2,doc3,sty;

if (document.layers) {
  doc = "document.";
  doc2 = ".document.";
  doc3 = "";
  sty = "";
  n4 = true;
  }
else if (document.all) {
  doc = "document.all.";
  doc2 = "";
  doc3 = "";
  sty = ".style";
  ie = true;
}

else if (document.getElementById) {
  doc = "document.getElementById('";
  doc2 ="')";
  doc3 ="')";
  sty = "').style";
  n6 = "true";
 } 
 
//position the element on the page.
function placeIt(elem,leftPos,topPos) 
{
    leftPos = leftPos - window.screenLeft - 8;
    topPos = topPos - window.screenTop;
    docObj = eval(doc + elem + sty);
    if(docObj != null)
    {
      docObj.pixelLeft = leftPos;
      docObj.pixelTop = topPos;
    }
// window.status = "elem:" + elem + ", leftPos:" + leftPos + ", topPos:" + topPos + ", x:" + window.screenLeft + ", y:" + window.screenTop
// window.status = "docObj:" +item + "top:" + topPos;
// item = ttt;
}

// img src swap function
function onoff (elemparent,elem,state) 
{
    newstate = eval(elem+"_"+state);
    menuObj = eval (doc + elem + doc2);
    if(menuObj != null)
    menuObj.src = newstate.src;
}


// mouse over (on) and mouseoff(off) color values
//var oncolor = "#99ccff";
//var offcolor = "#6699cc";
var oncolor = "#eeeeee";
var offcolor = "#cccccc";

function changecolor(divname,colorname) 
{
    stopall();
    menuObj = eval(doc + divname + sty);
    if(menuObj != null)
     menuObj.backgroundColor = colorname;
}

// show or hide DIV element
function showhide(divname,state) 
{
    divObj = eval (doc + divname + sty);
    if(divObj != null)
    {
     divObj.visibility = state;
    }
}

// disable menu item depends on search AC (DE, DEC...)
function disableMenu(sSearchAC) 
{
  var disMenu;
  //disable DE (enable when search is DEC, VD, CD, CSI, VM)
  if (sSearchAC == "DataElement" || sSearchAC == "ObjectClass" || sSearchAC == "Property")
  {
    disMenu = "assDE";
    divObj = eval (doc + disMenu);
    if(divObj != null)
      divObj.disabled = 'true';
  }
  //disable VD (enable when search is CD, VM)
  if (sSearchAC == "DataElementConcept" || sSearchAC == "ValueDomain" 
	  || sSearchAC == "ObjectClass" || sSearchAC == "Property")
  {
    disMenu = "assVD";
    divObj = eval (doc + disMenu);
    if(divObj != null)
      divObj.disabled = 'true';
  }
  //disable DEC (enable when search is CD)
  if (sSearchAC == "DataElementConcept" || sSearchAC == "ValueDomain" 
	  || sSearchAC == "PermissibleValue")
  {
    disMenu = "assDEC";
    divObj = eval (doc + disMenu);
    if(divObj != null)
    {
      divObj.disabled = 'true';
    }
  }
  // do nothing (enable all) if Question, Conceptual Domain  
  //else
    return;   
}

// variables that hold the value of the currently active (open) menu
var active_submenu1 = null;
var active_submenu2 = null;
var active_menuelem = null;
var active_topelem = null;

// function closes all active menus and turns back to 'off' state
function closeallmenus() 
{
    if(active_submenu1 != null) {
      showhide(active_submenu1,'hidden');
      }
    if(active_submenu2 != null) {
      showhide(active_submenu2,'hidden');
      }
    if(active_menuelem != null) {
      changecolor(active_menuelem,offcolor);
      }
}

// the menu close timeout variable
var menu_close_timeout = 0;
// delay in miliseconds until the open menus are closed
var delay = 500;
// function calls the closeallmenus() function after a delay
function closeall() {
    menu_close_timeout = setTimeout('closeallmenus()',delay);
}

// stop all timeout functions (stops menus from closing)
function stopall() {
    clearTimeout(menu_close_timeout);
}

// function controls submenus 
function controlsubmenu(event, submenu1,submenu2,menuelem,topelem)
{
  if (document.searchResultsForm.associateACBtn.value != "Create Complex DE")
  {
    stopall();
    closeallmenus();
    if (submenu1 != null) 
    {
      placeIt(submenu1,event.screenX,event.screenY);
      showhide(submenu1,'visible');
      active_submenu1 = submenu1;
    }
    if (submenu2 != null) 
    {
     showhide(submenu2,'visible');
     active_submenu2 = submenu2;
    }
    if (menuelem != null) {
     changecolor(menuelem,oncolor);
     active_menuelem = menuelem;
     }
  }
}

function controlsubmenu2(event, submenu1,submenu2,menuelem,topelem)
{
  if (document.searchResultsForm.btnSubConcepts.value != null)
  {
    stopall();
    closeallmenus();
    if (submenu1 != null) 
    {
      placeIt(submenu1,event.screenX,event.screenY);
      showhide(submenu1,'visible');
      active_submenu1 = submenu1;
    }
    if (submenu2 != null) 
    {
     showhide(submenu2,'visible');
     active_submenu2 = submenu2;
    }
    if (menuelem != null) 
    {
     changecolor(menuelem,oncolor);
     active_menuelem = menuelem;
    }
  }
}

// to init loading on/off images, no need here
function initPopupMenu(sSelAC) 
{  
    //when page init, 2 line of divAssACMenu appear, to remove it, show then hide it
    placeIt('divAssACMenu',200,200)
    showhide('divAssACMenu','visible');
    showhide('divAssACMenu','hidden');
    closeallmenus();
    stopall();
    disableMenu(sSelAC);  // disable menu depends on searched AC
}

// to init loading on/off images, no need here
function initPopupMenu2() 
{  
    //when page init, 2 line of divAssACMenu appear, to remove it, show then hide it
    placeIt('divAssACMenu',0,0)
    showhide('divAssACMenu','visible');
    showhide('divAssACMenu','hidden');
    closeallmenus();
    stopall();
  //  disableMenu('DataElementConcept');  // disable menu depends on searched AC
}
