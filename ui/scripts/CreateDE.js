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
		document.newCDEForm.newCDEPageAction.value = "createNewDEC";
		document.newCDEForm.submit();
	}
	else if (list.name == "selVD" && selectedValue == "createNew")
	{
		document.newCDEForm.Message.style.visibility="visible";
		document.newCDEForm.newCDEPageAction.value = "createNewVD";
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
	document.newCDEForm.newCDEPageAction.value = "createNewDEC";
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
	document.newCDEForm.newCDEPageAction.value = "createNewVD";
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
	
	document.newCDEForm.newCDEPageAction.value = "EditDECfromDE";
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
	
	document.newCDEForm.newCDEPageAction.value = "EditVDfromDE";
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
	   //check if the date is valid
     if (origin == "validate")
       isValid = isDateValid();
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
       
       SaveDDEInfor();
       		   
		   if (origin == "validate")
		   {
         document.newCDEForm.newCDEPageAction.value = "validate";
         window.status = "Validating data, it may take a minute, please wait.....";
		   }
		   else if (origin == "submit")
		   {
			   document.newCDEForm.newCDEPageAction.value = "submit";
         window.status = "Submitting data, it may take a minute, please wait.....";
		   }
       else if (origin == "updateNames")
		   {
			   document.newCDEForm.newCDEPageAction.value = "updateNames";
         window.status = "Refreshing the page, it may take a minute, please wait.....";
		   }     
       else if (origin == "changeNameType")
		   {
			   document.newCDEForm.newCDEPageAction.value = "changeNameType";
         window.status = "Refreshing the page, it may take a minute, please wait.....";
		   }     

		   document.newCDEForm.Message.style.visibility="visible";
		   document.newCDEForm.submit();
	   }
}

  //alerts if preferred name type was not selected
  function isNameTypeValid()
  {
      var isValid = "valid";
      if (document.newCDEForm.DEAction.value != "BlockEdit")
      {
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
          isValid = "invalid";
          alert("Please select the desired Preferred Name Type.");
        }
      }
      return isValid;
  }
  

function SubmitCDE()
{
	hourglass();
	document.newCDEForm.selDEC[0].selected = true;
	document.newCDEForm.selVD[0].selected = true;
	document.newCDEForm.newCDEPageAction.value = "submit";
	document.newCDEForm.Message.style.visibility="visible";
	window.status = "Submitting data, it may take a minute, please wait.....";
	document.newCDEForm.submit();
}

/* function getTermIdx(sTerm)
{
for(i=0; i<document.newCDEForm.hiddenTerm.length; i++)
{
if(sTerm == document.newCDEForm.hiddenTerm[i].value)
return i;
}
return -1;
  }  */

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
	//	var selIdx = document.newCDEForm.selContext.selectedIndex;
	//if (document.newCDEForm.selContext[selIdx].text == "")
	//	alert("Please select a context first");
	//else
	//{
//  if (document.newCDEForm.rNameConv != null)
 //   document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  

	document.SearchActionForm.searchComp.value = "DataElementConcept";
	document.SearchActionForm.isValidSearch.value = "false";
	
	if (searchWindow && !searchWindow.closed)
		searchWindow.close()
		searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=975,height=570,top=0,left=0,resizable=yes,scrollbars=yes")
		//}
}

function SearchVDValue()
{
 // if (document.newCDEForm.rNameConv != null)
//    document.newCDEForm.rNameConv[0].checked = true;  //make system generated selected  
	document.SearchActionForm.searchComp.value = "ValueDomain";
	document.SearchActionForm.isValidSearch.value = "false";
	if (searchWindow && !searchWindow.closed)
		searchWindow.close()
		searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=975,height=650,top=0,left=0,resizable=yes,scrollbars=yes")
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
//open alternate names window
function openAltNameWindow()
{
    if (altWindow && !altWindow.closed)
      altWindow.close();
      
    document.SearchActionForm.isValidSearch.value = "false";  
    var windowW = screen.width - 510;
    altWindow = window.open("jsp/AlternateNameWindow.jsp", "AltNameWindow", "width=500,height=350,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
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
            document.newCDEForm.newCDEPageAction.value  = "DECompBackToEditDE";
        else                                                     // to New DE (primary)       
            document.newCDEForm.newCDEPageAction.value  = "DECompBackToNewDE";
    }
    else if(document.newCDEForm.MenuAction.value == "Questions" ||
            document.newCDEForm.MenuAction.value == "NewDETemplate" ||
            document.newCDEForm.MenuAction.value == "NewDEVersion" ||
            document.newCDEForm.MenuAction.value == "EditDesDE" ||
            document.newCDEForm.MenuAction.value == "editDE")
    {
        document.newCDEForm.newCDEPageAction.value  = "backToSearch";
    }
    else   //safe sake
        document.newCDEForm.newCDEPageAction.value  = "backToSearch";
    
    document.newCDEForm.submit();
}

function isDateValid()
{
	if(document.newCDEForm.BeginDate.value != "")
	{
		var beginDate = document.newCDEForm.BeginDate.value
			var endDate = document.newCDEForm.EndDate.value
			var status = validateDate(beginDate, endDate); //validateDate is in date-picker.js
		if (status) status = "valid";
		return status;
	}
	else if (document.newCDEForm.DEAction.value == "EditDE")
	{	//end date must be empty if begin date empty
		if (document.newCDEForm.EndDate.value != "")
			alert("If you select an End Date, you must also select a Begin Date");
		else
			return "valid";
	}
	else if (document.newCDEForm.DEAction.value == "BlockEdit")    //do the date validation in java
  {
    if(document.newCDEForm.EndDate.value != "")
    {
      var endDate = document.newCDEForm.EndDate.value
      var status = validateEndDate(endDate);
      if (status) status = "valid";
      return status;
    }
    else
      return "valid";
  }
  else
		alert("Begin Date cannot be empty");
	
	return "invalid";	
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

function ClearBoxes()
{ 
	document.newCDEForm.newCDEPageAction.value = "clearBoxes";
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


//-------------cs-csi hierarchy begin---------------
/*
* first loads all cs in selCS select box and loads all selected cs-csi if  exists any
* calls changeCS function when cs is selected to display its csis : loops through 
csiArray and looking at parent id and level adds tabs to make hierachy, adds options selCSI 
* when CSI is selected calls selectCSI function which checks if with in the write contexts, 
if its CS was existed and/or selected in the selectedCS options, and calls addSelectedCSI to add csi
* addSelectedCSI function calls selectHierCSI to gets all parents which will be in reverse order.
In the opposite order loop from this heierachy array, calls the addSelectCSI array to 
fill selectedCSI options.


*/
/*  function selectMultiSelectList()
  {     
     //cs-csi lists
     document.newCDEForm.selCSNAMEHidden.length = 0;  //load the clean list
     document.newCDEForm.selCSCSIHidden.length = 0;
     document.newCDEForm.selACCSIHidden.length = 0;
     for (var i=0; i<document.newCDEForm.selectedCS.length; i++)  //selected cs ids
     {
        document.newCDEForm.selectedCS[i].selected = true;
        var csName = document.newCDEForm.selectedCS[i].text;
        document.newCDEForm.selCSNAMEHidden[i] = new Option(csName, csName);
        document.newCDEForm.selCSNAMEHidden[i].selected = true;
     }
     for (var idx=0; idx<selACCSIArray.length; idx++)     
     { 
        //selected cs-csi ids
        document.newCDEForm.selCSCSIHidden[idx] = new Option(selACCSIArray[idx][4], selACCSIArray[idx][4]);
        document.newCDEForm.selCSCSIHidden[idx].selected = true;
        //selected ac-csi ids
        document.newCDEForm.selACCSIHidden[idx] = new Option(selACCSIArray[idx][5], selACCSIArray[idx][5]);
        document.newCDEForm.selACCSIHidden[idx].selected = true;
        //selected ac ids stored in here for  edit
        document.newCDEForm.selACHidden[idx] = new Option(selACCSIArray[idx][6], selACCSIArray[idx][6]);
        document.newCDEForm.selACHidden[idx].selected = true;
     }
  }
 
  //called to load csi when cs drowdown changes.
   function ChangeCS()
   {
      var CS_ID = document.newCDEForm.selCS[document.newCDEForm.selCS.selectedIndex].value;
      var CS_Name = document.newCDEForm.selCS[document.newCDEForm.selCS.selectedIndex].text;
      document.newCDEForm.selCSI.length = 0;  //empty the select list
      var csiIdx = 0;
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //if the csId in the array is same as the selected from dropdown, add the csi in select field.
        if (csiArray[idx][0] == CS_ID)
        {
          //var csi_id = csiArray[idx][1];  //get the csi id   
          var cs_csi_id = csiArray[idx][2];  //get the cs-csi id for uniqueness
          var csi_name = csiArray[idx][6];       //add csi name for the name
          //add tabs if the parent exists
          if (csiArray[idx][3] != null || csiArray[idx][3] == "")
             csi_name = getTabSpace(csiArray[idx][8], csi_name);  //csi level and csi name
          //add new option to csi
          document.newCDEForm.selCSI[csiIdx] = new Option(csi_name, cs_csi_id);
          csiIdx++;
        }          
      } 
   }
   //gets the tab spaces according to the display order.
   function getTabSpace(csiLevel, csiName)
   {
      //add display order * 4 tabs to the string variable             
      var spaceCount = (eval(csiLevel) - 1) * 4;
      var tabspace = "String.fromCharCode(160"  //add one tab code
      //loop through number of counts to add more tab codes
      for (var counter=2; counter<=spaceCount; counter++)
      {
          tabspace += ", 160";          
      }
      tabspace += ")";  //end with closing bracket.
      //add the tab to the csi
      csiName = eval(tabspace) + csiName;
      //return tabspace;  //return the string.
      return csiName;
   }

   //check the context of the selected CS.  Add only if it is in the write context list
   function checkContextCS_AC(selCS)
   {
      if (selCS != null && selCS != "")
      {
        if (writeContArray != null && writeContArray.length > 0)
        {
           for (var idx=0; idx<writeContArray.length; idx++)
           { 
              var sContext = writeContArray[idx][0];
              if (sContext != "")
              {
                var subIndex = selCS.lastIndexOf(" - " + sContext); //do not start comparison at beginning
                //alert("compare " + subIndex + selCS + sContext);
                if (subIndex >= 0)
                  return true;
              }
           }
        }
        else
        {
           alert("Unable to get the list of writable context");
           return false;
        }
      }
      else
      {
         alert("Please select classification scheme from the drop down list");
         return false;
      }    
      return false;
   }
   
   //store the selected csi in selected cs-csi select boxes
   function selectCSI()
   {
      //return if no csi is selected
      if (document.newCDEForm.selCSI.selectedIndex < 0)
        return;
      else 
      {
        //checked the selected one if it already picked once.
        var thisCSCSI = document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].value;
        if (prevCSCSI != null && prevCSCSI != "" && prevCSCSI == thisCSCSI)
           return;
        else
           prevCSCSI = thisCSCSI; 
      }

      var isExists = false;
      //get the current length of the selected CS
      var selCSLength = document.newCDEForm.selectedCS.length;
      //selected CS value and text
      var selCS_id = document.newCDEForm.selCS[document.newCDEForm.selCS.selectedIndex].value;
      var selCS_name = document.newCDEForm.selCS[document.newCDEForm.selCS.selectedIndex].text;
      //check context of cs with ac context
      var isContextValid = checkContextCS_AC(selCS_name);
      if (isContextValid == false)
      {
          alert("Please make sure that the selected classification scheme's context is within the user's context");
          return;
      }
          
      //check its existance
      if (selCSLength >0)
      {
         //check if selected already
         if (document.newCDEForm.selectedCS.selectedIndex >= 0 && 
                document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].value == selCS_id)
         {
            addSelectedCSI(true, false);  //already selected CS in the selectedCS box.
            return;
         }
         else
         {
            //unselect the earlier selected cs
            if (document.newCDEForm.selectedCS.selectedIndex >= 0)
              document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].selected = false;

            //loop through to check if the selected CS already exists in the selected CS list.
            for (var i=0; i<selCSLength; i++)
            {
              if (document.newCDEForm.selectedCS[i].value == selCS_id)
              {
                 isExists = true;
                 document.newCDEForm.selectedCS[i].selected = true;      //keep it selected if found.
                 break;
              }
            }
         }
       }
       //create a new one if not found and keep it selected.
       if (isExists == false)
       {
          document.newCDEForm.selectedCS[selCSLength] = new Option(selCS_name, selCS_id);
          document.newCDEForm.selectedCS[selCSLength].selected = true;
       }
       addSelectedCSI(false, false);  //newly added or selected CS in the selectedCS box.
       return;
   }

   //selects parent csi and displays it in the same order of the tree
   function selectHierCSI(thisCSid, thisCSCSIid, arrPCHier)
   {
      if (arrPCHier == null) arrPCHier = new Array();
      //get the csi name from the original array list to remove the tabs.
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //for the selected csi and cs
        if (csiArray[idx][2] == thisCSCSIid  && csiArray[idx][0] == thisCSid)
        {
          //add this array to parent child array
          arrPCHier[arrPCHier.length] = csiArray[idx];
          //check if this csi has parent id and go back to loop to add the parent to the Heir array.
          if (csiArray[idx][3] != null && csiArray[idx][3] != "")
          {
            thisCSCSIid = csiArray[idx][3];
            idx=0; //reset the loop
          }
          else
            break;
        }
      } 
      return arrPCHier;
   }

   //called from selectedCSI function as well as change event of the selectedCS box
   function addSelectedCSI(wasCSSelected, isFromEvent)
   {
      if (document.newCDEForm.selectedCS.selectedIndex >= 0)
      {
        var selCS_id = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].value;
        var selCS_name = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].text;
      }
      if (document.newCDEForm.selCSI.selectedIndex >= 0)
      {
        var selCSCSI_id = document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].value;
        var selCSI_name = document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].text;
      }
      if (isFromEvent == true)
        document.newCDEForm.selectedCSI.length = 0;   //empty selectedCSI to reload

      //if called when csi was selected, check for parent key and select all the parents and display from parent to child hierarchical order.
      var arrParentChild = new Array();  
      arrParentChild = selectHierCSI(selCS_id, selCSCSI_id, arrParentChild);
      //get the csi name from the original array list to remove the tabs.
      if (arrParentChild != null)
      {
        //display them from last to first
        for (var idx=arrParentChild.length-1; idx >= 0; idx--)
        {             
          //for the selected csi and cs
          selCSCSI_id = arrParentChild[idx][2];
          selCSI_id = arrParentChild[idx][0];
          addSelectCSI(wasCSSelected, isFromEvent, selCS_id, selCSCSI_id);
        } 
      }
   }
   
   //called from selectedCSI function as well as change event of the selectedCS box
   function addSelectCSI(wasCSSelected, isFromEvent, selCS_id, selCSCSI_id)
   {
      if (document.newCDEForm.selectedCS.selectedIndex >= 0)
      {
        selCS_id = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].value;
        selCS_name = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].text;
      }
   /*   if (document.newCDEForm.selCSI.selectedIndex >= 0)
      {
        var selCSCSI_id = document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].value;
        var selCSI_name = document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].text;
      }
      if (isFromEvent == true)
        document.newCDEForm.selectedCSI.length = 0;   //empty selectedCSI to reload
      alert("adding csi " + selCS_id + " : " + selCSCSI_id);
      //get the csi name from the original array list to remove the tabs.
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //for the selected csi and cs
        if (csiArray[idx][2] == selCSCSI_id  && csiArray[idx][0] == selCS_id)
        {
          selCSI_name = csiArray[idx][6];
          selCSI_id = csiArray[idx][1];
          selCS_name = csiArray[idx][7];
          selCSILevel = csiArray[idx][8];
          selP_CSI_id = csiArray[idx][3];
          //adding tabs to the csi name
          selCSI_name = getTabSpace(selCSILevel, selCSI_name); 
          alert("found " + selCSI_name);
          break;
        }
      } */

 /*     var isExists = false;
      //get all the CSIs from the array since CS was not selected before 
      //alert("sel " + wasCSSelected + " fromevent " + isFromEvent + " csi size " + selCSIArray.length);
      if (wasCSSelected == false)
      {
        //loop through the array to load all the csi for the selected CS
        document.newCDEForm.selectedCSI.length = 0;
        csiIdx = 0;
        for (var idx=0; idx<selCSIArray.length; idx++)
        { 
          //populate the selectedCSI list with csi for the matching cs from the array
          //alert(selCSIArray[idx][0] + " : " + selCS_id + " ; " + selCSIArray[idx][1] + selCSIArray[idx][3]);
          if (selCSIArray[idx][0] == selCS_id)
          {
                   //adding tabs to the csi name
             //var tabNumber = (eval(csiArray[idx][8]) - 1) * 4;
             //selCSI_name = getTabSpace(tabNumber, selCSI_name);   
              //add csi to visible list
             // alert(selCSI_name);
             document.newCDEForm.selectedCSI[csiIdx] = new Option(selCSIArray[idx][3], selCSIArray[idx][4]);
             //check if csi already exists in the array
             if (isFromEvent == false && selCSIArray[idx][4] == selCSCSI_id)
             {
                //unselect the earlier selected csi
                if (document.newCDEForm.selectedCSI.selectedIndex >= 0)
                  document.newCDEForm.selectedCSI[document.newCDEForm.selectedCSI.selectedIndex].selected = false;

                document.newCDEForm.selectedCSI[csiIdx].selected = true;  //keep it selected
                isExists = true;
             }
             csiIdx++;
          }
        }
      }
      else
      {
        //check if the selected CSI already exists in the selected CSI list.
        for (var i=0; i<document.newCDEForm.selectedCSI.length; i++)
        {
          if (document.newCDEForm.selectedCSI[i].value == selCSCSI_id)
          {
             isExists = true;
             //unselect the earlier selected csi
             if (document.newCDEForm.selectedCSI.selectedIndex >= 0)
               document.newCDEForm.selectedCSI[document.newCDEForm.selectedCSI.selectedIndex].selected = false;

             document.newCDEForm.selectedCSI[i].selected = true;  //keep it selected
             break;
          }
        }
      } 
      
      //add the CSI to the selectedCSI list and selCSIArray only if not from the selectedCS change event.
      if (isFromEvent == false)
      {
        //display alert if already exists and not a block edit
        if (isExists == true && document.newCDEForm.DEAction.value == "BlockEdit")
            addNewCSI(isExists, selCSCSI_id, selCS_id);            
            //addSelectedAC();      //alert("Selected " + selCSI_name + " already exists in the list");
        else if (isExists == false)
            addNewCSI(isExists, selCSCSI_id, selCS_id);
      }
   }

  
  //add the CSI to the selectedCSI list and selCSIArray only if not from the selectedCS change event.
   function addNewCSI(isExistInList, selCSCSI_id, selCS_id)
   {
      var selCSCSI_id, selCSI_name, selCS_name, selACCSI_id, selAC_id, selAC_name, selCSILevel;
      var arrParentChild = new Array();
      //get the csi name from the original array list to remove the tabs.
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //for the selected csi and cs
        if (csiArray[idx][2] == selCSCSI_id  && csiArray[idx][0] == selCS_id)
        {
          selCSI_name = csiArray[idx][6];
          selCSI_id = csiArray[idx][1];
          selCS_name = csiArray[idx][7];
          selCSILevel = csiArray[idx][8];
          selP_CSI_id = csiArray[idx][3];
          //adding tabs to the csi name
          selCSI_name = getTabSpace(selCSILevel, selCSI_name); 
          break;
        }
      }
      //add the CSI to the selectedCSI list as it does not exist.
      var selCSILength = document.newCDEForm.selectedCSI.length;
      //alert("selectedcsi size before new one " + selCSILength + isExistInList);
      if (isExistInList == false)
      {
         //unselect the earlier selected csi
         if (document.newCDEForm.selectedCSI.selectedIndex >= 0)
           document.newCDEForm.selectedCSI[document.newCDEForm.selectedCSI.selectedIndex].selected = false;

         //add it to the selected csi list on the page
         document.newCDEForm.selectedCSI[selCSILength] = new Option(selCSI_name, selCSCSI_id);
         document.newCDEForm.selectedCSI[selCSILength].selected = true;
      }
         
      //get Long name, id and add csi attributes to the array 
      if (document.newCDEForm.DEAction.value != "BlockEdit")
      {
         selAC_id = document.newCDEForm.deIDSEQ.value;  
         selAC_name = document.newCDEForm.txtLongName.value;
         //fill the array with cs, csi and ac attributes.
         selACCSIArray[selACCSIArray.length] = new Array(selCS_id, selCS_name, selCSI_id, 
                selCSI_name, selCSCSI_id, selACCSI_id, selAC_id, selAC_name, selP_CSI_id);
      }
      else
      {  //loop through the array to add csi id for each ac id
        for (var j=0; j<document.newCDEForm.selACHidden.length; j++)
        {
          var selAC_id = document.newCDEForm.selACHidden[j].value;
          var selAC_name = document.newCDEForm.selACHidden[j].text;
          //fill the array with cs, csi and ac attributes.
          var foundAC = false;
          //loop through the existing array to check if it exists already for each de only if this csi exists in the selection list before
          if (isExistInList == true)
          {
            for (var idx=0; idx<selACCSIArray.length; idx++)
            {           
              if (selACCSIArray[idx][4] == selCSCSI_id && selACCSIArray[idx][6] == selAC_id)       //match the selected csi & AC 
                foundAC = true;
            }
          }
          if (foundAC == false)
          {
              selACCSIArray[selACCSIArray.length] = new Array(selCS_id, selCS_name, selCSI_id, 
                    selCSI_name, selCSCSI_id, selACCSI_id, selAC_id, selAC_name, selP_CSI_id);
          }
        }
        //refresh the selected ac list for newly added list
        addSelectedAC();
      }
      //call the method to fill selCSIArray
      makeSelCSIList();
   }

   //removes the classification scheme from cslist and its associated csi.
   function removeCSList()
   {
      if (document.newCDEForm.selectedCS.length > 0 && document.newCDEForm.selectedCS.selectedIndex >= 0)
      {
        //check context of cs with ac context
        var selCS_name = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].text;
        var isContextValid = checkContextCS_AC(selCS_name);
        if (isContextValid == false)
        {
            alert("Please make sure that the selected classification scheme's context is within the user's context");
            return;
        }
        
        var cs_id = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].value;
        //first remove the associated cs from the selectedCSI array and the selection list.
        var isCSDeleted = false;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the csi for the matching cs 
          if (selACCSIArray[idx][0] == cs_id)
          {
             selACCSIArray.splice(idx, 1);  //(parameters : start and number of elements to remove)
             isCSDeleted = true;
             idx--;  //do not increase the index number
          }
        }
        if (isCSDeleted == true)
        {
          document.newCDEForm.selectedCSI.length = 0;
          //remove associated DE from the list
          if (document.newCDEForm.selCSIACList != null)
            document.newCDEForm.selCSIACList.length = 0;

          //call the method to fill selCSIArray
          makeSelCSIList();          
        }
        //removing the cs from the list.
        var tempCSArray = new Array();
        var csIdx = 0;
        //store the all other cs from the selectionList in to the array 
        for (var i=0; i<document.newCDEForm.selectedCS.length; i++)
        {
          if (document.newCDEForm.selectedCS[i].value != cs_id)
          {
            tempCSArray[csIdx] = new Array(document.newCDEForm.selectedCS[i].value, document.newCDEForm.selectedCS[i].text)
            csIdx++;
          }
        }
        document.newCDEForm.selectedCS.length =0;
        //re-populate the cs selection list from the array.
        if (tempCSArray.length > 0)
        {
          for (var j=0; j<tempCSArray.length; j++)
          {
            document.newCDEForm.selectedCS[j] = new Option(tempCSArray[j][1], tempCSArray[j][0]);
          }
        }
      }   
      else
        alert("Please select a Classification Scheme from the list");
   }

   //removes the csi from the selectionlist.
   function removeCSIList()
   {
      if (document.newCDEForm.selectedCSI.length > 0 && document.newCDEForm.selectedCSI.selectedIndex >= 0)
      {
        //check context of cs with ac context
        var selCS_name = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].text;
        var isContextValid = checkContextCS_AC(selCS_name);
        if (isContextValid == false)
        {
            alert("Please make sure that the selected classification scheme's context is within the user's context");
            return;
        }

        var cscsi_id = document.newCDEForm.selectedCSI[document.newCDEForm.selectedCSI.selectedIndex].value;
        var cs_id;
        if (document.newCDEForm.selectedCS.selectedIndex >= 0)
           cs_id = document.newCDEForm.selectedCS[document.newCDEForm.selectedCS.selectedIndex].value;
        csiIdx = 0;
        var isDeleted = false;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the matching csi from the array list
          if (selACCSIArray[idx][4] == cscsi_id && selACCSIArray[idx][0] == cs_id)
          {
             selACCSIArray.splice(idx,1);   //(start and number of elements)
             isDeleted = true;
             idx--;  //do not increase the index number
          }
        }
        if (isDeleted == true)
        {
          //call the method to fill selCSIArray
          makeSelCSIList();
          addSelectedCSI(false, true);  //re populate csi list after removing.
          //remove associated DE from the list
          if (document.newCDEForm.selCSIACList != null)
            document.newCDEForm.selCSIACList.length = 0;

          //remove selected CS from the list if selectedCSI is null (nothing left)
          if (document.newCDEForm.selectedCSI.length == 0)
          {
            for (var i=0; i<document.newCDEForm.selectedCS.length; i++)
            {
              if (document.newCDEForm.selectedCS.options[i].value == cs_id)
              {
                 document.newCDEForm.selectedCS.options[i] = null;
                 break;
              }
            }
          }
        }
      }
      else
        alert("Please select a Class Scheme Item from the list");
   }
   
   //to display related AC when CSI changed and show selected csi in the csi list.
   function addSelectedAC()
   {
      var cscsi_id = document.newCDEForm.selectedCSI[document.newCDEForm.selectedCSI.selectedIndex].value;
      //display ac names
      if (document.newCDEForm.selCSIACList != null)
      {
        csiIdx = 0;
        document.newCDEForm.selCSIACList.length = 0;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the matching csi from the array list
          if (selACCSIArray[idx][4] == cscsi_id)
          {
            document.newCDEForm.selCSIACList[document.newCDEForm.selCSIACList.length] 
                  = new Option(selACCSIArray[idx][7], selACCSIArray[idx][7]);
          }
        } 
      }
      //show selected csi in csi list
      for (var i=0; i<csiArray.length; i++)
      {
          //get csi attributes
         if (csiArray[i][2] == cscsi_id)
         {
            var cs_id = csiArray[i][0];
            var isSelected = false;
            if (document.newCDEForm.selCS.selectedIndex > 0 && 
                      document.newCDEForm.selCS[document.newCDEForm.selCS.selectedIndex].value == cs_id)
               isSelected = true;

            //select the cs from the drow down list
            if (isSelected == false)
            {
              for (var j=0; j<document.newCDEForm.selCS.length; j++)
              {
                if (document.newCDEForm.selCS[j].value == cs_id)
                {
                    document.newCDEForm.selCS[j].selected = true;
                    ChangeCS();  //call method to select all the 
                    break;
                }
              }
            }
            //select the csi in selCSI list
            isSelected = false;            
            if (document.newCDEForm.selCSI.selectedIndex > 0 && 
                      document.newCDEForm.selCSI[document.newCDEForm.selCSI.selectedIndex].value == cscsi_id)
               isSelected = true;
               
            //select the cs from the drow down list
            if (isSelected == false)
            {
              for (var j=0; j<document.newCDEForm.selCSI.length; j++)
              {
                if (document.newCDEForm.selCSI[j].value == cscsi_id)
                {
                    document.newCDEForm.selCSI[j].selected = true;
                    break;
                }
              }
            }            
         }
      }      
   }

  //make the selected csi array from ac csi array at load.
   function makeSelCSIList()
   {
      selCSIArray.length = 0;
      for (var i=0; i<selACCSIArray.length; i++)
      {
        //add the cs-csi to the selected csi array only if it does not exist already
        var relFound = false;
        //alert("make sel " + selACCSIArray[i][3]);
        for (var idx=0; idx<selCSIArray.length; idx++)
        { 
          if (selCSIArray[idx][4] == selACCSIArray[i][4]) //match to the cscsi id
          {
            relFound = true;
            break;
          }
        }
        //add selCS_id, selCS_name, selCSI_id, selCSI_name, selCSCSI_id in this order
        if (relFound == false)
        {
          selCSIArray[selCSIArray.length] = new Array(selACCSIArray[i][0], selACCSIArray[i][1], 
            selACCSIArray[i][2], selACCSIArray[i][3], selACCSIArray[i][4], selACCSIArray[i][8]);  //, selACCSI_id, selAC_id, selAC_longName);
         // var pos = csiPosition(selACCSIArray[i][8]);
         // selCSIArray[pos] = new Array(selACCSIArray[i][0], selACCSIArray[i][1], 
         //   selACCSIArray[i][2], selACCSIArray[i][3], selACCSIArray[i][4], selACCSIArray[i][8]);  //, selACCSI_id, selAC_id, selAC_longName);
        }
      }
   }
   
   //loop through accsi array to get the parent 
   //check if any other children exist
   function csiPosition(p_cscsi_id)
   {
      for (var j=0; j<selCSIArray.length; j++)
      {
        //alert(selCSIArray[j][3]);
        if (selCSIArray[j][4] == p_cscsi_id)
          return j;
      } 
      return selCSIArray.length;
   }
   
   function sortSelCSI(selCS_id)
   {
      var thisCSArray = new Array();
      for (var j=0; j<selCSIArray.length; j++)
      {
        //alert(selCSIArray[j][3]);
        if (selCSIArray[j][0] == selCS_id)
          thisCSArray[thisCSArray.length] = selCSIArray[j];
      } 
      //sort the array
      var arrSelCSI = new Array();
      var iter = 0;
      for (var i=0; i<thisCSArray.length; i++)
      {
        //pcscsi
        if (iter == 0 && thisCSArray[i][5] == "")
          alert("dummy");
      }
   } */
//-------------cs-csi hierarchy  end ---------------


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
    document.newCDEForm.newCDEPageAction.value = "CreateNewDEFComp";
    document.newCDEForm.submit();
}

//Called from local funcs, for create derived DE, save DDE into to hidden sels for Servlet pick them up
function SaveDDEInfor()
{
    if(document.newCDEForm.MenuAction.value == "EditDesDE" || 
        document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" ||
        document.newCDEForm.originActionHidden.value == "BlockEditDE")  //no DDE part
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
            alert("Please enter integer only for thid field!");
            document.newCDEForm.txtDECompOrder.value = "";
            return;
        }
    }

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
    if (document.newCDEForm.MenuAction.value == "EditDesDE" || 
        document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" ||
        document.newCDEForm.originActionHidden.value == "BlockEditDE")  //no DDE part
      return;
    if(action == "change")
    {
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
        
    if(sRepType == "CALCULATED" || sRepType == "COMPLEX RECODE")
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
    else     //empty, delete all DDE info
    {
        document.newCDEForm.DDEMethod.disabled=true;
        document.newCDEForm.DDEConcatChar.disabled=true;
        document.newCDEForm.DDERule.disabled=true;
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
  if(document.newCDEForm.MenuAction.value == "EditDesDE" ||
      document.newCDEForm.originActionHidden.value == "CreateNewDEFComp" || 
      document.newCDEForm.originActionHidden.value == "BlockEditDE" )
    return "valid";
    
  if(document.newCDEForm.selDEComp.options.length < 1)
      return "valid";
  // Representation Type selected
  var thisIdx = document.newCDEForm.selRepType.selectedIndex;
  if(thisIdx < 1)
  {
      alert("Please select a Representation Type");
      return "invalid";
  }
  
	return "valid";	
}

//------------ for DDE end ----------------------------

//-->