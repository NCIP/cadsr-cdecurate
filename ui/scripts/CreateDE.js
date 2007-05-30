// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/CreateDE.js,v 1.20 2007-05-30 20:06:36 hegdes Exp $
// $Name: not supported by cvs2svn $

var searchWindow = null;
var evsWindow = null;
var altWindow = null;
var statusWindow = null;

var longDecTerm = "";
var longVdTerm = "";
var qualTerm = "";
var qualTerm2 = "";
var shortDecTerm = "";
var shortVdTerm = "";
var VdIndex = 0;
var DecIndex = 0;
var sDECLongID = "";
var selectedIdx;
var list2IndexOld = 0;
var selectedValueCsT = "";
//var selCSIArray = new Array();
//var prevCSCSI = "";

function hourglass(){
	document.body.style.cursor = "wait";
}
function down_hourglass(){
	document.body.style.cursor = "default";
}

function MM_callJS(jsStr) { //v2.0
	return eval(jsStr)
}

//  opens a window for large status messages
function displayStatusWindow()
{
    if (statusWindow && !statusWindow.closed)
        statusWindow.close()
    var windowW = (screen.width/2) - 230;
    statusWindow = window.open("jsp/OpenStatusWindow.jsp", "statusWindow", "width=475,height=545,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes")      
}

function resetBoxes(newDE, sDECID, sDEC, sVDID, sVD)
{
	if (arguments.length != 5)
	{
        alert("function ClearBoxes was called with " + arguments.length + 
			" arguments, but it expects 5 arguments.");
        return null;
	}
	if (sDECID != null && sDEC != null)
	{
        document.newCDEForm.selDEC[0].value = sDECID;
        document.newCDEForm.selDEC[0].text  = sDEC;
	}
	if (sVDID != null && sVD != null)
	{
        document.newCDEForm.selVD[0].value = sVDID;
        document.newCDEForm.selVD[0].text =  sVD;
	}
	//ClearAllCSLists();
}

function AddOption(form, list)
{
	var selectedValue = list[list.selectedIndex].value;
	if (list.name == "selDEC" && selectedValue == "createNew")
	{
		document.newCDEForm.Message.style.visibility="visible";
		document.newCDEForm.pageAction.value = "createNewDEC";
		document.newCDEForm.submit();
	}
	else if (list.name == "selVD" && selectedValue == "createNew")
	{
		document.newCDEForm.Message.style.visibility="visible";
		document.newCDEForm.pageAction.value = "createNewVD";
		document.newCDEForm.submit();
	}
	else
	{
        fillNames();
	}     
}

function CreateNewDECValue()
{
	var selIdx = document.newCDEForm.selContext.selectedIndex;
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
 // if (document.newCDEForm.rNameConv != null)
 //   document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  
  //select multiselection lists
  selectMultiSelectList();      
	//select dde info
  SaveDDEInfor();
	
	document.newCDEForm.Message.style.visibility="visible";
	document.newCDEForm.pageAction.value = "createNewDEC";
	document.newCDEForm.submit();
}

function CreateNewVDValue()
{
	var selIdx = document.newCDEForm.selContext.selectedIndex;
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
 // if (document.newCDEForm.rNameConv != null)
 //   document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  
  //select multiselection lists  
  selectMultiSelectList();      
	//select dde info
  SaveDDEInfor();  
	//submit the form
	document.newCDEForm.Message.style.visibility="visible";
	document.newCDEForm.pageAction.value = "createNewVD";
	document.newCDEForm.submit();
}

function EditDECValue()
{
	hourglass();
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
//  if (document.newCDEForm.rNameConv != null)
//    document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  
  //select multiselection lists
  selectMultiSelectList();      
	//seelct dde info
  SaveDDEInfor();
	
	document.newCDEForm.pageAction.value = "EditDECfromDE";
	document.newCDEForm.Message.style.visibility="visible";
	window.status = "Validating data, it may take a minute, please wait.....";
	document.newCDEForm.submit();
}

function EditVDValue()
{
	hourglass();
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
//  if (document.newCDEForm.rNameConv != null)
//    document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  
  //select multiselection lists  
  selectMultiSelectList();      
  //select dde info     		   
  SaveDDEInfor();
	
	document.newCDEForm.pageAction.value = "EditVDfromDE";
	document.newCDEForm.Message.style.visibility="visible";
	window.status = "Validating data, it may take a minute, please wait.....";
	document.newCDEForm.submit();
}

function fillNames()
{
	longDecTerm = document.newCDEForm.selDEC.options[document.newCDEForm.selDEC.selectedIndex].text;
	longVdTerm = document.newCDEForm.selVD.options[document.newCDEForm.selVD.selectedIndex].text;
	DecIndex = document.newCDEForm.selDEC.selectedIndex;
	VdIndex = document.newCDEForm.selVD.selectedIndex;
	shortDecTerm = getShortDecName(DecIndex);
	shortVdTerm = getShortVdName(VdIndex);
	document.newCDEForm.txtLongName.value = (longDecTerm + " " + longVdTerm);
	document.newCDEForm.txtPreferredName.value = (shortDecTerm + "_" + shortVdTerm);
	document.newCDEForm.txtLongNameCount.value = document.newCDEForm.txtLongName.value.length;
	document.newCDEForm.txtPrefNameCount.value = document.newCDEForm.txtPreferredName.value.length;
	
	document.newCDEForm.selDECText.value = longDecTerm;
	document.newCDEForm.selVDText.value = longVdTerm;
}


function getShortDecName(DecIndex)
{
	// return document.newCDEForm.hiddenPrefDEC[DecIndex].value;
}

function getShortVdName(VdIndex)
{
	//  return document.newCDEForm.hiddenPrefVD[VdIndex].value;
}

function changeCountPN()
{
    document.newCDEForm.txtPrefNameCount.value = document.newCDEForm.txtPreferredName.value.length;
}
function changeCountLN()
{
    document.newCDEForm.txtLongNameCount.value = document.newCDEForm.txtLongName.value.length;
}


function submit()
{
    newCDEForm.submit();
}

function SubmitValidate(origin)
{
     var isValid = "valid";
     if (isValid == "valid" && origin == "validate") 
       isValid = isNameTypeValid(); 
	   //check if the DEComp order is valid
	   if (isValid == "valid" && origin == "validate")
  	   isValid = isDECompOrderValid();
     //continue with submitting if valid
	   if (isValid == "valid")
	   {
		   hourglass();
		   document.newCDEForm.selDEC[0].selected = true;
		   document.newCDEForm.selVD[0].selected = true;

	       //select multiselection lists
	       selectMultiSelectList();
	       //DDE info saved
	       SaveDDEInfor();
			//
           document.newCDEForm.pageAction.value = origin;
           window.status = "Validating data, it may take a minute, please wait.....";
		   document.newCDEForm.Message.style.visibility="visible";
		   //disable the buttons
		   document.newCDEForm.btnValidate.disabled = true;
		   document.newCDEForm.btnClear.disabled = true;
		   if (document.newCDEForm.btnBack != null) 
		   		document.newCDEForm.btnBack.disabled = true;
		   document.newCDEForm.btnAltName.disabled = true;
		   document.newCDEForm.btnRefDoc.disabled = true;
		   //submit the form
		   document.newCDEForm.submit();
	   }
}

//alerts if preferred name type was not selected
function isNameTypeValid()
{
    var isValid = "valid";
    //check if sys was selected
    var nameType = document.newCDEForm.rNameConv[0].checked;
    //check if abbr was selected if not sys
    if (nameType == null || nameType == false)
      nameType = document.newCDEForm.rNameConv[1].checked;
    //cehck if user was selcted if neither of abve
    if (nameType == null || nameType == false)
      nameType = document.newCDEForm.rNameConv[2].checked;
    if (nameType == null || nameType == false)
    {
      //stop it only if dec or vd was changed
      if (document.newCDEForm.nameTypeChange.value == "true")
      {
        isValid = "invalid";
        alert("Please select the desired Short Name Type.");
      }
      else
        document.newCDEForm.rNameConv[2].checked = true;
    }
    return isValid;
}
  

function SubmitCDE()
{
	hourglass();
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
	document.newCDEForm.pageAction.value = "submit";
	document.newCDEForm.Message.style.visibility="visible";
	window.status = "Submitting data, it may take a minute, please wait.....";
	document.newCDEForm.submit();
}


function createDEC()
{
	document.newCDEForm.Message2.style.visibility="visible";
	window.location=CreateDEC.jsp;
}

function createNew()
{
	AddToList(formName, list);
}

function SearchDECValue()
{
	document.SearchActionForm.searchComp.value = "DataElementConcept";
	document.SearchActionForm.isValidSearch.value = "false";
	
	if (searchWindow && !searchWindow.closed)
		searchWindow.close()
	searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=975,height=570,top=0,left=0,resizable=yes,scrollbars=yes")
}

function SearchVDValue()
{
	document.SearchActionForm.searchComp.value = "ValueDomain";
	document.SearchActionForm.isValidSearch.value = "false";
	if (searchWindow && !searchWindow.closed)
		searchWindow.close()
	searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=975,height=650,top=0,left=0,resizable=yes,scrollbars=yes")
}

 function closeDep() 
 {
    if (searchWindow && !searchWindow.closed)   //&& searchWindow.open 
      searchWindow.close();
    if (altWindow && !altWindow.closed)  // && altWindow.open
      altWindow.close();
    if (statusWindow && !statusWindow.closed)  // && statusWindow.open
      statusWindow.close();
 }

function RTrim(str)
{
   	if (str==null)
	{return null;}
   	for(var i = str.length-1; str.charAt(i) == " "; i--);
	return str.substring(0,i+1);
}

function RTrimDash(str)
{
   	if (str==null)
	{return null;}
   	for(var i=0; i<str.length; i++)
    {
        if(str.charAt(i) == "-")
			return str.substring(0,i);
    }
}

function CaptureContext(str)
{
	var length = str.length - 1;
   	if (str==null)
	{return null;}
   	for(var i=0; i<str.length; i++)
    {
        if(str.charAt(i) == "-")
			return str.substring(i-1,length+1);
    }
}

function isDash(char)
{
	if (char.length > 1)
	{return false;}
	var string = "-";
   	if (string.indexOf(char) != -1)
	{return true;}
   	return false;
}

var evsWindow = null;
function AccessEVS()
{
	if (evsWindow && !evsWindow.closed)
       	evsWindow.focus();
    else
    {
		evsWindow = window.open("jsp/OpenSearchWindowDef.jsp", "EVSWindow", "width=970,height=450,top=0,left=0,resizable=yes,scrollbars=yes");
		document.SearchActionForm.searchEVS.value = "DataElement";
    }
}
//open alternate names reference documents window
function openDesignateWindow(sType)
{
    if (altWindow && !altWindow.closed)
      altWindow.close();
   /* var acAction = document.newCDEForm.DEAction.value;
    if (acAction != "BlockEdit" && document.newCDEForm.selContext[selIdx].text == "")
    {
      alert("Please select a context first");
      return;
    } */
    document.SearchActionForm.isValidSearch.value = "false";  
    document.SearchActionForm.itemType.value = sType
 // alert(" depage " + sType);
    //var windowW = screen.width - 410;
    if (sType == "Alternate Names")
        altWindow = window.open("NCICurationServlet?reqType=AltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "designate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
    else
        altWindow = window.open("jsp/EditDesignateDE.jsp", "designate", "width=700,height=650,top=0,left=0,resizable=yes,scrollbars=yes");
}

function MM_callJS(jsStr) { //v2.0
	return eval(jsStr);
}

function Back()   
{
    hourglass();
    if(document.newCDEForm.originActionHidden.value == "CreateNewDEFComp")   // from DE Comp back
    {
        if(document.newCDEForm.MenuAction.value == "editDE")     // to Edit DE
            document.newCDEForm.pageAction.value  = "DECompBackToEditDE";
        else                                                     // to New DE (primary)       
            document.newCDEForm.pageAction.value  = "DECompBackToNewDE";
    }
    else if(document.newCDEForm.MenuAction.value == "Questions" ||
            document.newCDEForm.MenuAction.value == "NewDETemplate" ||
            document.newCDEForm.MenuAction.value == "NewDEVersion" ||
            document.newCDEForm.MenuAction.value == "EditDesDE" ||
            document.newCDEForm.MenuAction.value == "editDE")
    {
        document.newCDEForm.pageAction.value  = "backToSearch";
    }
    else   //safe sake
        document.newCDEForm.pageAction.value  = "backToSearch";
    
    document.newCDEForm.submit();
}

function isDateValid()
{
		var beginDate = document.newCDEForm.BeginDate.value;
		var endDate = document.newCDEForm.EndDate.value;
    var acAction = document.newCDEForm.DEAction.value;
    if (acAction == "EditDE" || acAction == "BlockEdit") acAction = "Edit";
    return areDatesValid(beginDate, endDate, acAction);
} 

function EnableChecks(checked, currentField)
{
	var field = currentField.name;
	if(field == "VersionCheck" && checked)
	{
		document.newCDEForm.PointCheck.disabled=false;
		document.newCDEForm.PointCheck.checked=false;
		document.newCDEForm.WholeCheck.disabled=false;
		document.newCDEForm.WholeCheck.checked=false;
	}
	else if(field == "VersionCheck" && checked == false)
	{
		document.newCDEForm.PointCheck.disabled=true;
		document.newCDEForm.PointCheck.checked=false;
		document.newCDEForm.WholeCheck.disabled=true;
		document.newCDEForm.WholeCheck.checked=false;
	}
	else if(field == "PointCheck" && checked)
	{
		document.newCDEForm.PointCheck.disabled=false;
		document.newCDEForm.PointCheck.checked=true;
		document.newCDEForm.WholeCheck.disabled=true;
	}
	else if(field == "PointCheck" && checked == false)
	{
		document.newCDEForm.WholeCheck.disabled=false;
		document.newCDEForm.WholeCheck.checked=false;
		document.newCDEForm.PointCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked)
	{
		document.newCDEForm.PointCheck.disabled=true;
		document.newCDEForm.WholeCheck.checked=true;
		document.newCDEForm.WholeCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked == false)
	{
		document.newCDEForm.PointCheck.disabled=false;
		document.newCDEForm.PointCheck.checked=false;
	}
  //display business rule message if version is checked but no workflow status is selected
  if ((field == "PointCheck" || field == "WholeCheck") && checked)
  {
    var wfStatus = document.newCDEForm.selStatus.value;
    if (wfStatus == null || wfStatus == "")
    {
      alert("Please consider selecting an appropriate Workflow Status when Block Versioning. \n " +
              "Click the Business Rules hyperlink to get more information.");              
    }
  }
}

function editContact(sAction)
{
    var selInd = document.newCDEForm.selContact.selectedIndex;
    var sCont = "";
    if (selInd >= 0)
    {
    	sCont = document.newCDEForm.selContact[selInd].value; 
    	if (sAction == "remove")
    	{
	        var removeOK = confirm("Click OK to continue with removing selected Contact.");
	        if (removeOK == true) SubmitValidate("removeContact");
    		return;
    	}
    }
    else if (sAction != "new")
    {
    	alert("Please select contact to do " + sAction + " action.");
    	return;
    }  
    //continue with opening contacts for edit or new 
    document.SearchActionForm.acID.value = sCont; 
    document.SearchActionForm.isValidSearch.value = "false";  
    document.SearchActionForm.itemType.value = sAction;
    if (altWindow && !altWindow.closed)
      altWindow.close();
    altWindow = window.open("jsp/EditACContact.jsp", "Contact", "width=800,height=650,top=0,left=0,resizable=yes,scrollbars=yes");
}
//enable view and remove buttons for contact
function enableContButtons()
{
    var selInd = document.newCDEForm.selContact.selectedIndex;
    if (selInd >= 0)
    {
    	var sCont = document.newCDEForm.selContact[selInd].value;
    	if (sCont != null && sCont != "")
    	{
    		document.newCDEForm.btnViewCt.disabled = false;
    		document.newCDEForm.btnRmvCt.disabled = false;
    	}
    }
}

function ClearBoxes()
{ 
	document.newCDEForm.pageAction.value = "clearBoxes";
	document.newCDEForm.Message.style.visibility="visible";
	window.status = "clearing data, it may take a minute, please wait.....";
	document.newCDEForm.submit();
}

//adds new option for the hidden vm select fields from new window
function AllocSelRowOptions(rowArray)
{
  for (var i = 0; rowArray.length > i; i++)
  {
    newCDEForm.hiddenSelRow[i] = new Option(rowArray[i],rowArray[i]);
    newCDEForm.hiddenSelRow[i].selected = true;
  }
} 

//------------ for DDE ----------------------------
function AllocOptions(iCount)
{
    var iStart = eval(document.newCDEForm.DECompCountHidden.value);
    var count = iCount;
    var idx = 0;
    for (var i = 0; count>i; i++)
    {
		idx = i+iStart;
		newCDEForm.selDEComp[idx] = new Option("","");
		newCDEForm.selOrderedDEComp[idx] = new Option("","");
		newCDEForm.selOrderList[idx] = new Option("","");
    }
}

//call from searchResult.jsp, insert name and ID to DEComp lists, if duplicate items, do nothing
function InsertDEComp(editID, editLongName)
{
	var count = parseInt(document.newCDEForm.DECompCountHidden.value);
	var sID;
	var sLongName;
	var i;

	for(i=0; i<count; i++)  // check duplicate
	{
		sID = document.newCDEForm.selDEComp[i].value;
		sLongName = document.newCDEForm.selDEComp[i].text;

		if(sID == editID && sLongName == editLongName)
    {
        document.newCDEForm.selDEComp.options[count+1] = null;    // remove empty entry by AllocOptions just before
        document.newCDEForm.selOrderedDEComp.options[count+1] = null;
        document.newCDEForm.selOrderList.options[count+1] = null;   
        return;       //do nothing if duplicate
    }
	}
	
	document.newCDEForm.selDEComp[count] = new Option(editLongName, editID);
	document.newCDEForm.selOrderedDEComp[count] = new Option(editLongName, editID);
  var iOrder = count+1;
	document.newCDEForm.selOrderList[count] = new Option(iOrder, "newDEComp");
	
	document.newCDEForm.DECompCountHidden.value = iOrder;
	//alert("===InsertDEComp, count:"+count);
	showDECompOrder();
}

//for create derived DE
function CreateNewDEValue()
{
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
  
    selectMultiSelectList();      //select multiselection lists
	
    SaveDDEInfor();
    
    document.newCDEForm.Message.style.visibility="visible";
    document.newCDEForm.pageAction.value = "CreateNewDEFComp";
    document.newCDEForm.submit();
}

//Called from local funcs, for create derived DE, save DDE into to hidden sels for Servlet pick them up
function SaveDDEInfor()
{
   /* if(document.newCDEForm.MenuAction.value == "EditDesDE" || 
        document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" ||
        document.newCDEForm.originActionHidden.value == "BlockEditDE")  //no DDE part */
    if (document.newCDEForm.DDEMethod == null)
      return;
//  if(document.newCDEForm.originActionHidden.value != "NewDEFromMenu")
//      return;
    document.newCDEForm.selDECompHidden.length = 0;
    document.newCDEForm.selDECompIDHidden.length = 0;
    document.newCDEForm.selDECompOrderHidden.length = 0;
    document.newCDEForm.selDECompRelIDHidden.length = 0;
    for(i=0; i < document.newCDEForm.selOrderedDEComp.length; i++)
    {
        if(newCDEForm.selOrderedDEComp[i].text != "")
        {
          var sT = document.newCDEForm.selOrderedDEComp[i].text;   //name
          var sV = document.newCDEForm.selOrderedDEComp[i].value;  //ID
          document.newCDEForm.selDECompHidden[i] = new Option(sV, sT);
          document.newCDEForm.selDECompHidden[i].selected=true;
          document.newCDEForm.selDECompIDHidden[i] = new Option(sT, sV);
          document.newCDEForm.selDECompIDHidden[i].selected=true;
          sV = document.newCDEForm.selOrderList[i].value;   //order
          sT = document.newCDEForm.selOrderList[i].text;   //order
          document.newCDEForm.selDECompOrderHidden[i] = new Option(sT, sT);
          document.newCDEForm.selDECompOrderHidden[i].selected=true;
          document.newCDEForm.selDECompRelIDHidden[i] = new Option(sV, sV);
          document.newCDEForm.selDECompRelIDHidden[i].selected=true;
        }
    }
}

//for create derived DE
function SearchDEValue()  
{
	document.SearchActionForm.searchComp.value = "DataElement";
	document.SearchActionForm.isValidSearch.value = "false";
	
	if (searchWindow && !searchWindow.closed)
		searchWindow.close()
	searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
}

//select the Ordered DEComp when Order list is selected.
function selectODEComp()
{
    for (var i=0; i<(document.newCDEForm.selOrderList.options.length); i++)
    {
  		document.newCDEForm.selOrderedDEComp[i].selected = false;
    }
    //using the selected index of the Order list, keep the same of Ordered DEComp.
    var thisIdx = document.newCDEForm.selOrderList.selectedIndex;
    if (thisIdx >= 0)
    {
    	document.newCDEForm.selOrderedDEComp[thisIdx].selected = true;
    }
}

//select the Order list when Ordered DEComp is selected.
function selectOList()
{
    for (var i=0; i<(document.newCDEForm.selOrderList.options.length); i++)
    {
		document.newCDEForm.selOrderList[i].selected = false;
    }
    //using the selected index of the Ordered DEComp, keep the same of Order list.
    var thisIdx = document.newCDEForm.selOrderedDEComp.selectedIndex;
    if (thisIdx >= 0)
    {
		document.newCDEForm.selOrderList[thisIdx].selected = true;
    }
}

//show DEComp order in text box when select a DEComp.
function showDECompOrder()
{
    //using the selected index of the DEComp, 
    var thisIdx = document.newCDEForm.selDEComp.selectedIndex;
    if(thisIdx >= 0)
    {
        var tx = document.newCDEForm.selOrderList[thisIdx].text;
       	document.newCDEForm.txtDECompOrder.value = tx;
    }
    else
       	document.newCDEForm.txtDECompOrder.value = "";
}

//change Ordered DEComp order when text box value changed.
function changeOrder()
{
    // check numeric
    var tx = document.newCDEForm.txtDECompOrder.value;
    for(var i=0; i<tx.length; i++)
    {
        var iChar = tx.charCodeAt(i);
        if(iChar < 48 || iChar > 57)
        {
            alert("Please enter integer only for this field!");
            document.newCDEForm.txtDECompOrder.value = "";
            return;
        }
    }
    
    if(tx.length < 1)   // have to be a integer, empty is not allowed
        return;

    //using the selected index of the DEComp, 
    var thisIdx = document.newCDEForm.selDEComp.selectedIndex;
    if(thisIdx >= 0)
    {
       document.newCDEForm.selOrderList[thisIdx].text = tx;
    }
}

//enable/disable method and concaChar control when rep type changed.
function changeRepType(action)
{
   /* if (document.newCDEForm.MenuAction.value == "EditDesDE" || 
        document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" ||
        document.newCDEForm.originActionHidden.value == "BlockEditDE")  //no DDE part */
    if (document.newCDEForm.DDEMethod == null)
      return;
    if(action == "change")
    {
      //do not empty boxes if it was data problem
      var oldDBType = document.newCDEForm.NotValidDBType.value;
      if (oldDBType != null && oldDBType != "") 
      	return;
      //empty the input boxes for changed type
      document.newCDEForm.DDEMethod.value="";
      document.newCDEForm.DDEConcatChar.value="";
      document.newCDEForm.DDEMethod.text="";
      document.newCDEForm.DDEConcatChar.text="";
      document.newCDEForm.DDERule.value="";
      document.newCDEForm.DDERule.text="";
    }
    //using the selected index of the DEComp, 
    var sRepType = "";
    if (document.newCDEForm.selRepType != null && document.newCDEForm.selRepType.value != "")
        sRepType = document.newCDEForm.selRepType.value;
    //clear all the data if it is empty type
    if (sRepType == null || sRepType == "")
    {
        if(action != "init")
        {
            //remove all Relationship IDs by moving them into delete array
            var idx = document.newCDEForm.selDECompDeleteHidden.length;     // save DE Relation ID before remove
            for(var i=0; i<document.newCDEForm.selOrderList.length; i++)
            {
              var RelID = document.newCDEForm.selOrderList.options[i].value;
              var relName = document.newCDEForm.selDEComp.options[i].text;
              document.newCDEForm.selDECompDeleteHidden.options[idx] = new Option(RelID, RelID);
              document.newCDEForm.selDECompDeleteHidden.options[idx].selected = true;
              document.newCDEForm.selDECompDelNameHidden.options[idx] = new Option(relName, relName);
              document.newCDEForm.selDECompDelNameHidden.options[idx].selected = true;
              idx++;
            }
            document.newCDEForm.selDEComp.length = 0;
            document.newCDEForm.selOrderedDEComp.length = 0;
            document.newCDEForm.selOrderList.length = 0;
            document.newCDEForm.txtDECompOrder.value = "";
        }
    }    
  /*  else if(sRepType == "CALCULATED" || sRepType == "COMPLEX RECODE")
    {
        document.newCDEForm.DDEMethod.disabled=false;
        document.newCDEForm.DDEConcatChar.disabled=false;
        document.newCDEForm.DDERule.disabled=false;
    }
    else if(sRepType == "OBJECT CLASS")
    {
        document.newCDEForm.DDEMethod.disabled=false;
        document.newCDEForm.DDEConcatChar.disabled=true;
        document.newCDEForm.DDERule.disabled=false;
    }
    else if(sRepType == "CONCATENATION" || sRepType == "SIMPLE RECODE")
    {
        document.newCDEForm.DDEMethod.disabled=true;
        document.newCDEForm.DDEConcatChar.disabled=false;
        document.newCDEForm.DDERule.disabled=false;
    }
    else if(sRepType == "COMPOUND")
    {
        document.newCDEForm.DDEMethod.disabled=true;
        document.newCDEForm.DDEConcatChar.disabled=true;
        document.newCDEForm.DDERule.disabled=false;
    }
    else     //enable all fields for all other types
    {
        document.newCDEForm.DDEMethod.disabled=false;
        document.newCDEForm.DDEConcatChar.disabled=false;
        document.newCDEForm.DDERule.disabled=false;
    } */
}

//remove DEComp from all DEComp list.
function removeDEComp()
{
    //using the selected index of the DEComp
    var thisIdx = document.newCDEForm.selOrderedDEComp.selectedIndex;
    if(thisIdx >= 0)
    {
      //get the name of the component
      var remComp = document.newCDEForm.selDEComp.options[thisIdx].text;
      document.newCDEForm.selDEComp.options[thisIdx] = null;
      document.newCDEForm.selOrderedDEComp.options[thisIdx] = null;
      var lenDel = document.newCDEForm.selDECompDeleteHidden.length;     // save DE Relation ID before remove
      var val = document.newCDEForm.selOrderList.options[thisIdx].value;
      document.newCDEForm.selDECompDeleteHidden.options[lenDel] = new Option(val, val);
      document.newCDEForm.selDECompDeleteHidden.options[lenDel].selected = true;
      document.newCDEForm.selDECompDelNameHidden.options[lenDel] = new Option(remComp, remComp);
      document.newCDEForm.selDECompDelNameHidden.options[lenDel].selected = true;
      document.newCDEForm.selOrderList.options[thisIdx] = null;   // removed ID
      var lenComp = document.newCDEForm.DECompCountHidden.value;  // update count also, which used in alloc
      lenComp--;
      document.newCDEForm.DECompCountHidden.value = lenComp;
      showDECompOrder();
    }
    else
    {
  		alert("Please select a DE Comp to remove.");
    }
}

function isDECompOrderValid()
{
 /* if(document.newCDEForm.MenuAction.value == "EditDesDE" ||
      document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" || 
      document.newCDEForm.originActionHidden.value == "BlockEditDE" ) */
  if (document.newCDEForm.DDEMethod == null)
    return "valid";
    
  if(document.newCDEForm.selDEComp.options.length < 1)
      return "valid";
  // Representation Type selected
  var thisIdx = document.newCDEForm.selRepType.selectedIndex;
  if(thisIdx < 1)
  {
      //do not empty boxes if it was data problem
      var oldDBType = document.newCDEForm.NotValidDBType.value;
      if (oldDBType != null && oldDBType != "")
      	alert("The existing Derivation Type " + oldDBType + " is no longer a valid type. \n Please select a new Derivation Type.");
  	  else
      	alert("Please select a Derivation Type");
      return "invalid";
  } 
  return "valid";	
}

//------------ for DDE end ----------------------------

//-->