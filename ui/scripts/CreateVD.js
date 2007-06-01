// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/CreateVD.js,v 1.23 2007-06-01 22:20:48 hegdes Exp $
// $Name: not supported by cvs2svn $

var evsWindow = null;
var altWindow = null;
var statusWindow = null;

var objQTerm = "";
var objCTerm = "";
var propQTerm = "";
var propCTerm = "";
var objQTerm2 = "";
var objCTerm2 = "";
var propQTerm2 = "";
var propCTerm2 = "";
var repQTerm = "";
var repTerm = "";
var repQTerm2 = "";
var repTerm2 = "";
var selectedItem = null;
var selectedMeaning = null;
var pvIndex = 0;
var pmIndex = 0;
var selectedIdx;
var list2IndexOld = 0;
var F='';
var checkedValueCount = 0;


function removeAllText(thisBlock)
 {
   var formObj= eval("document.createVDForm."+thisBlock);
   formObj.onkeydown =
   function (evt)
   {
      evt = (evt) ? evt : event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));

      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //empty data
		 formObj.value = "";
      }
      //don't do anything
      return false;
   };
   formObj.onkeyup =
   function (evt)
   {
      evt = (evt) ? evt : event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));
      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //empty data
		 formObj.value = "";
      }
      //don't do anything
      return false;
   };
   formObj.onkeypress =
   function (evt)
   {
      evt = (evt) ? evt : event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));

      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //to reset the value of valid search.
		   formObj.value = "";
      }
	  return false;
   };

 }

  function hourglass(){
    document.body.style.cursor = "wait";
  }
  function down_hourglass(){
    document.body.style.cursor = "default";
  }

  //  opens a window for large status messages
  function displayStatusWindow()
  {
      if (statusWindow && !statusWindow.closed)
          statusWindow.close()
      var windowW = (screen.width/2) - 230;
      statusWindow = window.open("jsp/OpenStatusWindow.jsp", "statusWindow", "width=475,height=545,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes")      
  }

  function OpenEVSWindow()
  {
    if (evsWindow && !evsWindow.closed)
       evsWindow.focus()
    else
    {
       evsWindow = window.open("jsp/OpenSearchWindowDef.jsp", "EVSWindow", "width=970,height=500,top=0,left=0,resizable=yes,scrollbars=yes")
       document.SearchActionForm.searchEVS.value = "ValueDomain";
    }
  }

 function SearchBuildingBlocks(thisBlock, openToTree)
 {
    var vAction = document.createVDForm.VDAction.value;
    var selIdx = document.createVDForm.selContext.selectedIndex;
     if(openToTree == "true")
    {
      if(thisBlock == "RepTerm" && (RepTerm.innerText == null || RepTerm.innerText == ""
        || RepTerm.innerText == "caDSR"))  //|| RepTerm.innerText == "NCI Metathesaurus" 
      {
        alert("Cannot open to tree for this database.");
        return;
      }
      else if(thisBlock == "RepQualifier" && (RepQual.innerText == null || RepQual.innerText == ""
        || RepQual.innerText == "caDSR"))  //|| RepQual.innerText == "NCI Metathesaurus" 
      {
        alert("Cannot open to tree for this database.");
        return;
      }
    }
	document.SearchActionForm.searchComp.value = thisBlock;
  	document.createVDForm.openToTree.value = openToTree; //true
    document.SearchActionForm.isValidSearch.value = "false";
	if (searchWindow && !searchWindow.closed)
   		searchWindow.close()
    if(openToTree == "true")
    	searchWindow = window.open("jsp/OpenSearchWindowBlocks.jsp", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
    else
    {
    	document.SearchActionForm.isValidSearch.value = "true";
    	searchWindow = window.open("NCICurationServlet?reqType=searchBlocks&actSelect=FirstSearch" + "&listSearchFor=" + thisBlock + "&listContextFilterVocab=NCI_Thesaurus", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes");
    }	
 }

  //adds new option for the hidden vm select fields from new window
  function AllocVMOptions(iCount)
  {
    for (var i = 0; iCount > i; i++)
    {
      createVDForm.selVMConCode[i] = new Option("","");
      createVDForm.selVMConName[i] = new Option("","");
      createVDForm.selVMConDef[i] = new Option("","");
      createVDForm.selVMConDefSource[i] = new Option("","");
      createVDForm.selVMConOrigin[i] = new Option("","");
      createVDForm.selVMParentCC[i] = new Option("","");
      createVDForm.selVMParentName[i] = new Option("","");  
    }
  } 
  //adds new option for the hidden vm select fields from new window
  function AllocSelRowOptions(rowArray)
  {
    for (var i = 0; rowArray.length > i; i++)
    {
      createVDForm.hiddenSelRow[i] = new Option(rowArray[i],rowArray[i]);
      createVDForm.hiddenSelRow[i].selected = true;
//alert("createvd AllocSel");
    }
  } 

 //add remove contacts
function editContact(sAction)
{
    var selInd = document.createVDForm.selContact.selectedIndex;
    var sCont = "";
    if (selInd >= 0)
    {
    	sCont = document.createVDForm.selContact[selInd].value; 
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
    var selInd = document.createVDForm.selContact.selectedIndex;
    if (selInd >= 0)
    {
    	var sCont = document.createVDForm.selContact[selInd].value;
    	if (sCont != null && sCont != "")
    	{
    		document.createVDForm.btnViewCt.disabled = false;
    		document.createVDForm.btnRmvCt.disabled = false;
    	}
    }
}


    function showValueMessage()
   {
     document.createVDForm.Message.style.visibility="visible";
   }

   function callMessageGif1()
   {
 //    document.Form5.Message.style.visibility="visible";
     document.Form1.submit();
     dotcycle();
   }

  function LinkToValidateVD()
  {
    window.location = "ValidateVD.jsp";
  }

  function Skip()
  {
     this.blur();
  }

  function ClearBoxes()
  {
     document.createVDForm.pageAction.value = "clearBoxes"
     document.createVDForm.Message.style.visibility="visible";
     window.status = "clearing data, it may take a minute, please wait....."
     document.createVDForm.submit();
  }

  function AddOptionToList(form, list)
  {
     AddToList(form, list);
     fillNames();
  }
 
  function changeCountLN()
  {
    document.createVDForm.txtLongNameCount.value = document.createVDForm.txtLongName.value.length;
  }

  function changeCountPN()
  {
    document.createVDForm.txtPrefNameCount.value = document.createVDForm.txtPreferredName.value.length;
  }

  
  function SubmitValidate(origin)
  {
 // alert("submitValidate origin: " + origin);
 	if (origin == "goBack")
 		Back();
    //check if the date is valid
    var isValid = "valid";
    if (isValid == "valid" && origin == "validate") 
      isValid = isNameTypeValid(); 
    //do the action
    if (isValid == "valid")
    {
      hourglass();
     // document.createVDForm.listVDType.selected = true;
      document.createVDForm.selObjectClass.selected = true;
      document.createVDForm.selPropertyClass.selected = true;
   //   document.createVDForm.selObjectQualifier.selected = true;
   //   document.createVDForm.selPropertyQualifier.selected = true;
      document.createVDForm.selRepQualifier.selected = true;
      document.createVDForm.selRepTerm.selected = true;
      document.createVDForm.selConceptualDomain.selected = true;
      document.createVDForm.selConceptualDomain.options[0].selected = true;
      document.createVDForm.tfLowValue.disabled=false; // needs to be enabled for validation code
      document.createVDForm.tfHighValue.disabled=false;  // needs to be enabled for validation code
    	//select cs-csi multi select lists
      selectMultiSelectList();
     
      //submit the form
      if (origin == "refresh") origin = "refreshCreateVD";
      document.createVDForm.pageAction.value = origin;
      window.status = "Validating the page, it may take a minute, please wait.....";          
      document.createVDForm.Message.style.visibility="visible";
	   //submit the form
	  DisableButtons();
      document.createVDForm.submit();
    }
  }

  function isDateValid()
  {
      var beginDate = document.createVDForm.BeginDate.value;
      var endDate = document.createVDForm.EndDate.value;
      var acAction = document.createVDForm.VDAction.value;
      if (acAction == "EditVD" || acAction == "BlockEdit") acAction = "Edit";
      return areDatesValid(beginDate, endDate, acAction);
  }
  
  //alerts if preferred name type was not selected
  function isNameTypeValid()
  {
      var isValid = "valid";
      if (document.createVDForm.VDAction.value != "BlockEdit")
      {
        //check if sys was selected
        var nameType = document.createVDForm.rNameConv[0].checked;
        //check if abbr was selected if not sys
        if (nameType == null || nameType == false)
          nameType = document.createVDForm.rNameConv[1].checked;
        //cehck if user was selcted if neither of abve
        if (nameType == null || nameType == false)
          nameType = document.createVDForm.rNameConv[2].checked;
        if (nameType == null || nameType == false)
        {
          //stop it only if dec vd was changed
          if (document.createVDForm.nameTypeChange.value == "true")
          {
            isValid = "invalid";
            alert("Please select the desired Short Name Type.");
          }
          else
            document.createVDForm.rNameConv[2].checked = true;
        }
      }
      return isValid;
  }
  
 function ToggleDisableList2()
 {
    //enumerated selected
    if (document.createVDForm.listVDType[0].selected == true)
    { 
      //confirm to remove the meta parents before chagning it.
      var isChangeOK = true;        
      var vdType = document.createVDForm.listVDType[document.createVDForm.listVDType.selectedIndex].value;
      if (document.createVDForm.ParentDB != null && document.createVDForm.ParentDB.length >0 && vdType == "E")
      {          
        for (var i=0; i<document.createVDForm.ParentDB.length; i++)
        {
          var parDB = document.createVDForm.ParentDB[i].value;
          if (parDB == "NCI Metathesaurus")
          {
            var okChange = confirm("Parent Concepts from the NCI Metathesaurus may not be used to reference an Enumerated Value Domain.\n" + 
              "Changing the Value Domain type to Enumerated will remove the Parent Concept(s) from the NCI Metathesaurus.\n\n");
            if (okChange == false)
            {
              document.createVDForm.listVDType.value = "N";
              return;
            }
            else
              break;
          }
        }
      }
      document.createVDForm.pageAction.value = "Enum";
      document.createVDForm.listVDType[0].selected = "1";
      SubmitValidate("Enum");
    }
    //non enumerated selected
    else if (document.createVDForm.listVDType[1].selected == true)
    {
      document.createVDForm.pageAction.value = "NonEnum";
      document.createVDForm.listVDType[1].selected = "1";
      SubmitValidate("NonEnum");
    }
  }
  
  function MM_callJS(jsStr)
  { //v2.0
    return eval(jsStr)
  }
  
  function Back()
  {
    hourglass();
    document.createVDForm.pageAction.value  = "goBack";
    document.createVDForm.submit();
  }

function enableValueNum()
{
   var sDataType = document.createVDForm.selDataType.options[document.createVDForm.selDataType.selectedIndex].text;   
   sDataType = sDataType.toUpperCase();
   if ((sDataType == "NUMBER") || (sDataType == "NUMERIC"))	
   {
		document.createVDForm.tfLowValue.disabled=false;
		document.createVDForm.tfHighValue.disabled=false;
   }
   else
   {
		document.createVDForm.tfLowValue.value = "";
		document.createVDForm.tfHighValue.value = "";
		document.createVDForm.tfLowValue.text = "";
		document.createVDForm.tfHighValue.text = "";
		document.createVDForm.tfLowValue.disabled=true;
		document.createVDForm.tfHighValue.disabled=true;
   }

}
 function changeDataType()
 {
    var dtInd = document.createVDForm.selDataType.selectedIndex;
    var sDataType = document.createVDForm.selDataType.options[document.createVDForm.selDataType.selectedIndex].text; 
    if (sDataType == null)
    {
      sDataType = "";
      dtInd = 0;
    }
    if (dtInd > -1 && document.createVDForm.datatypeDesc != null)
    {
      var sDTDesc = document.createVDForm.datatypeDesc[dtInd].value;
      var sDTComm = document.createVDForm.datatypeDesc[dtInd].text;
      lblDTDesc.innerText = sDTDesc;
      lblDTComment.innerText = sDTComm;
    }
    //call function to handle enabling
    enableValueNum();
 }
 
 function EnableChecks(checked, currentField)
 {
    var field = currentField.name;
	if(field == "VersionCheck" && checked)
	{
		document.createVDForm.PointCheck.disabled=false;
		document.createVDForm.PointCheck.checked=false;
		document.createVDForm.WholeCheck.disabled=false;
		document.createVDForm.WholeCheck.checked=false;
	}
	else if(field == "VersionCheck" && checked == false)
	{
		document.createVDForm.PointCheck.disabled=true;
		document.createVDForm.PointCheck.checked=false;
		document.createVDForm.WholeCheck.disabled=true;
		document.createVDForm.WholeCheck.checked=false;
	}
	else if(field == "PointCheck" && checked)
	{
		document.createVDForm.PointCheck.disabled=false;
		document.createVDForm.PointCheck.checked=true;
		document.createVDForm.WholeCheck.disabled=true;
	}
      else if(field == "PointCheck" && checked == false)
	{
		document.createVDForm.WholeCheck.disabled=false;
		document.createVDForm.WholeCheck.checked=false;
		document.createVDForm.PointCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked)
	{
		document.createVDForm.PointCheck.disabled=true;
		document.createVDForm.WholeCheck.checked=true;
		document.createVDForm.WholeCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked == false)
	{
		document.createVDForm.PointCheck.disabled=false;
		document.createVDForm.PointCheck.checked=false;
	}
  //display business rule message if version is checked but no workflow status is selected
  if ((field == "PointCheck" || field == "WholeCheck") && checked)
  {
    var wfStatus = document.createVDForm.selStatus.value;
    if (wfStatus == null || wfStatus == "")
    {
      alert("Please consider selecting an appropriate Workflow Status when Block Versioning. \n " +
              "Click the Business Rules hyperlink to get more information.");              
    }
  }
}

function RemoveBuildingBlocks(thisBlock)
{
      var selIdx = 0;
      document.createVDForm.sCompBlocks.value = thisBlock;
      if (thisBlock == "RepTerm")
      {
        document.createVDForm.selRepRow.value = selIdx;
      //  TrimDefinition('Object')
        if(document.createVDForm.selRepTerm[0].value != null 
          && (document.createVDForm.selRepTerm[0].value != "" || document.createVDForm.selRepTerm[0].text != ""))
        {
          document.createVDForm.selRepTerm[0].value = "";
          SubmitValidate("RemoveSelection");
        }
      }
      else if (thisBlock == "RepQualifier")
      {
        selIdx = document.createVDForm.selRepQualifier.selectedIndex;
        if (selIdx == -1)
          alert("Please select a Qualifier to remove.");
        else
        {
          document.createVDForm.selRepQRow.value = selIdx;
          SubmitValidate("RemoveSelection");
        }
      }
      else if (thisBlock == "VDObjectClass")
      {
        document.createVDForm.selObjectClass.value = selIdx;
      //  TrimDefinition('Object')
        document.createVDForm.selObjectClass[0].value = "";
        SubmitValidate("RemoveSelection");
      }
      else if (thisBlock == "VDPropertyClass")
      {
        document.createVDForm.selPropertyClass.value = selIdx;
      //  TrimDefinition('Object')
        document.createVDForm.selPropertyClass[0].value = "";
        SubmitValidate("RemoveSelection");
      }
} 

function ShowEVSInfo(thisBlock)
{
      var selIdx = 0;
      document.createVDForm.sCompBlocks.value = thisBlock;
      if (thisBlock == "RepQualifier")
      {
        selIdx = document.createVDForm.selRepQualifier.selectedIndex;
        if(selIdx != null && selIdx != -1 && document.createVDForm.vRepQualifierCodes.options[selIdx] != null)
        {
          var RepQCode = document.createVDForm.vRepQualifierCodes.options[selIdx].text
          if (RepQCode == null || RepQCode == "null") RepQCode = "";
          var RepQCodeDB = document.createVDForm.vRepQualifierDB.options[selIdx].text
          if (RepQCodeDB == null || RepQCodeDB == "null") RepQCodeDB = "";
          RepQual.innerText = RepQCodeDB;
          RepQualID.innerText = RepQCode;
          document.createVDForm.RepQualCCodeDB.value = RepQCodeDB;
          document.createVDForm.RepQualCCode.value = RepQCode;
        }
      }
} 

