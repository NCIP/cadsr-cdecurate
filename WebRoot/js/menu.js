var rX;
var rY;
var menuVertPx = 20;
var menuHorizPx = 20;
var menuVisibleElement = null;
var menuHoldElement = null;
var menuSrcElement = null;
var menuSrcElementHold = null;

var menuBackgroundColor = "#d8d8df";
var menuRootBackgroundColor = "#5c5c5c";
var menuTextColor = "#000000";
var menuFocusColor = "#ffffff";
var menuDisabledColor = "#777777";
var menuRootFocusColor = "#6B78B4";

var prevRowObj = null;
var prevRowBGColor;

function loaded(menus){
    var menu = document.getElementById(menus);
    menuCheckEnabled(menu);
}
function menuHide() {
	if (menuVisibleElement !== null) {
		menuVisibleElement.style.display = "none";
	}
	menuVisibleElement = menuHoldElement;
	menuSrcElement = menuSrcElementHold;
	menuHoldElement = null;
	menuSrcElementHold = null;
}
function setColor(obj, j){
	var exit = false;
	rowColor = obj.parentNode.style.backgroundColor;
	if (rowColor == "rgb(255, 232, 124)") {
		exit = true;
	}
	else if (rowColor == "#ffe87c") {
		exit = true;
	}
	
	if(!exit) {
	     if ((j%2) === 0){
	       obj.style.backgroundColor = "#dfdfdf";
	     }else{
	       obj.style.backgroundColor = "#FFFFFF";
	     } 
     } 
}
function setHighlightRow(obj){
    var child;
    if (obj.nodeName == "TR"){
        if (prevRowObj != null){
            prevRowObj.style.backgroundColor = prevRowBGColor;
            child = prevRowObj.childNodes[1];
	        child.style.backgroundColor = prevRowBGColor;
         }
        prevRowBGColor = obj.style.backgroundColor;
        prevRowObj = obj;
        prevRowObj.style.backgroundColor = "#FFE87C";
        return;
    }
    setHighlightRow(obj.parentNode);
}
function menuShow(obj, evnt) {
	setHighlightRow(obj);
	var menuID = obj.getAttribute("menuID");
	var rowId = obj.getAttribute("rowId");
	document.searchResultsForm.selectedRowId.value = rowId;
	if (menuID == null) {
		return;
	}
	var srcElementHold = null;
	if (evnt.srcElement == undefined) {
		if (menuSrcElement == evnt.currentTarget) {
			menuHide();
			return;
		}
		srcElementHold = evnt.currentTarget;
		
	} else {
		if (menuSrcElement == evnt.srcElement) {
			menuHide();
			return;
		}
		srcElementHold = evnt.srcElement;
	}
	var menu = document.getElementById(menuID);
	menuHide();
	menuHoldElement = menu;
	menuSrcElementHold = srcElementHold;
	menu.style.display = "block";
	var offsetX;
	var offsetY;
	var menuType = menu.getAttribute("menuType");
	if (menuType !== null && menuType == "float") {
		if (srcElementHold.width > 0) {
			offsetX = srcElementHold.width;
			offsetY = srcElementHold.height;
		} else {
			offsetX = menuHorizPx;
			offsetY = menuVertPx;
		}
	} else {
		offsetX = 0;
		offsetY = menuVertPx;
	}
	var top = 0;
	var left = 0;
	if (evnt.offsetX == undefined || evnt.offsetY == undefined) {
		menuObjPos(srcElementHold);
	    top = rY;
		left = rX;
		menuObjPos(menu.parentNode);
		top = top - rY + offsetY;
		left = left - rX + offsetX;
	} else {
		var scrollTop = document.documentElement.scrollTop > document.body.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop; 
		top = scrollTop + evnt.clientY - evnt.offsetY + offsetY;
		left = document.body.parentElement.scrollLeft + evnt.clientX - evnt.offsetX + offsetX;
	}
	menu.style.top = top + "px";
	menu.style.left = left + "px";
}
function menuItemFocus(mitem) {
	var miEnable = mitem.getAttribute("menuEnable");
	if (miEnable == null || miEnable != "false") {
		mitem.style.backgroundColor = menuFocusColor;
		//mitem.style.color = menuTextColor;
	} else {
		//mitem.style.color = menuDisabledColor;
	}
	mitem.style.cursor = "default";
}
function menuItemNormal(mitem) {
	mitem.style.backgroundColor = menuBackgroundColor;
	var miEnable = mitem.getAttribute("menuEnable");
	if (miEnable == null || miEnable != "false") {
		//mitem.style.color = menuTextColor;
	}
}
function menuRootOver(obj, evnt) {
	obj.style.backgroundColor = menuRootFocusColor;
	if (menuVisibleElement !== null) {
		var menuID = obj.getAttribute("menuID");
	    if (menuID !== null) {
			if (evnt.srcElement === undefined) {
				menuSrcElement = evnt.currentTarget;
			} else {
				menuSrcElement = evnt.srcElement;
			}
			var menu = document.getElementById(menuID);
			menuVisibleElement.style.display = "none";
			menuVisibleElement = menu;
			menuVisibleElement.style.display = "block";
			var offsetX;
			var offsetY;
			var menuType = menu.getAttribute("menuType");
			if (menuType !== null && menuType == "float") {
				if (menuSrcElement.width > 0) {
					offsetX = menuSrcElement.width;
					offsetY = menuSrcElement.height;
				} else {
					offsetX = menuHorizPx;
					offsetY = menuVertPx;
				}
			} else {
				offsetX = 0;
				offsetY = menuVertPx;
			}
			var top = 0;
			var left = 0;
			if (evnt.offsetX == undefined || evnt.offsetY == undefined) {
				menuObjPos(menuSrcElement);
				top = rY;
				left = rX;
				menuObjPos(menu.parentNode);
				top = top - rY + offsetY;
				left = left - rX + offsetX;
			} else {
				top = document.body.parentElement.scrollTop + evnt.clientY - evnt.offsetY + offsetY;
				left = document.body.parentElement.scrollLeft + evnt.clientX - evnt.offsetX + offsetX;
			}
			menu.style.top = top + "px";
			menu.style.left = left + "px";
		}
	}
}
function menuRootOut(obj, evnt) {
	obj.style.backgroundColor = menuRootBackgroundColor;
}
function menuOver(obj, evnt) {
	obj.style.backgroundColor = menuRootFocusColor;
}	
function menuCheckEnabled(menu) {
	var len;
	if (menu.children == undefined) {
		len = menu.childNodes.length;
	} else {
		len = menu.children.length;
	}
	var cnt;
	for (cnt = 0; cnt < len; ++cnt) {
		var child;
		if (menu.children == undefined) {
			child = menu.childNodes[cnt];
		} else {
			child = menu.children[cnt];
		}
		menuCheckEnabled(child);
	}
	if (menu.getAttribute !== undefined) {
		var menuFlag = menu.getAttribute("menuEnable");
		if (menuFlag !== null) {
			if (menuFlag == "false" || menuFlag == false) {
				menu.style.color = menuDisabledColor;
			} else {
				if (menuFlag != "true" && menuFlag !== true) {
					alert("The 'menuFlag' attribute is invalid on '" + menu.innerHTML + "', valid values are 'true' and 'false', case sensitive.");
				}
			}
		}
	}
}
function menuObjPos(obj) {
	var tagBody = document.getElementsByTagName("body")[0];
	var oX = obj.offsetLeft;
	var oY = obj.offsetTop;
	
	// finds the absolute position of the object
	while (obj.parentNode) {
		if (obj.parentNode.tagName != "TR") { 
            // Table Cells are relative to the Table not the Row. Adding the
            // Row offset causes a position miscalculation.
			var nX = obj.parentNode.offsetLeft;
			var nY = obj.parentNode.offsetTop;
			oX = oX + nX;
			oY = oY + nY;
		}
		if (obj == tagBody) {
			break;
		} else {
			obj = obj.parentNode;
		}
	}
	rX = oX;
	rY = oY;
}
 //submits the form to display 'Create New DE' window
 function callDENew(user){
  if (user == "null"){
       alert("Please Login to use this feature.");
  }else{     
     document.newDEForm.submit();
  }   
 }
 //submits the form to display 'Create New DEC' window
 function callDECNew(user){
  if (user == "null"){
       alert("Please Login to use this feature.");
  }else{  
     document.newDECForm.submit();
  }
 }
//submits the form to display 'create New VD window'
 function callVDNew(user){
  if (user == "null"){
       alert("Please Login to use this feature.");
  }else{  
     document.newVDForm.submit();
  }
 }  
 
 //submits the form to display 'create New Concept Class window'
 function callCCNew(user){
  if (user == "null"){
       alert("Please Login to use this feature.");
  }else{  
     document.newCCForm.submit();
  }
 } 
//submits the form to display 'Home Page'
 function showHomePage(){
    document.homePageForm.submit();
 } 
 function displayStepsToFollow(){
     alert("Please follow the steps below.\n 1. Do the Search.\n 2. Click on the action icon on the selected row.\n 3. Select 'New Using Existing' on the pop up action menu.");
 }
 function displayStepsToFollow2(){
     alert("Please follow the steps below.\n 1. Do the Search. \n 2. Click on the action icon on the selected row. \n 3. Select 'New Version' on the pop up action menu.");
 }  
