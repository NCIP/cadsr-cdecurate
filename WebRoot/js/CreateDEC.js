// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/CreateDEC.js,v 1.10 2009-04-21 19:06:49 veerlah Exp $
// $Name: not supported by cvs2svn $

var searchWindow = null;
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
//var selCSIArray = new Array();

//var prevCSCSI = "";

window.console && console.log("CreateDEC.js DOJO version used = [" + dojo.version.toString() + "]");

 function removeAllText(thisBlock)
 {
	//someodd reason it requires all three to function properly in disabling the character typing and removing them all if meant to delete
   var formObj= eval("document.newDECForm."+thisBlock);
   formObj.onkeydown =
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
  
   formObj.onkeyup =
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

 function LinkToValidateDEC()
  {
    window.location = "ValidateDEC.jsp";
  }

  function OpenEVSWindow()
  {
    if (evsWindow && !evsWindow.closed)
       evsWindow.focus();
    else
    {
       evsWindow = window.open("jsp/OpenSearchWindowDef.jsp", "EVSWindow", "width=970,height=500,top=0,left=0,resizable=yes,scrollbars=yes");
       document.SearchActionForm.searchEVS.value = "DataElementConcept";
    }
  }

//open alternate names reference document window
function openDesignateWindow(sType)
{
    if (altWindow && !altWindow.closed)
      altWindow.close();
    document.SearchActionForm.isValidSearch.value = "false";  
    document.SearchActionForm.itemType.value = sType
 // alert(" depage " + sType);
    //var windowW = screen.width - 410;
    if (sType == "Alternate Names")
        altWindow = window.open("../../cdecurate/NCICurationServlet?reqType=AltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "designate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
    else
        altWindow = window.open("jsp/EditDesignateDE.jsp", "designate", "width=700,height=650,top=0,left=0,resizable=yes,scrollbars=yes");
}

//open viewonly refe doc
function openRefDocViewWindow()
{
	var refWindow = window.open("../../cdecurate/NCICurationServlet?reqType=getRefDocument&acID="+document.SearchActionForm.acID.value, "ReferenceDocuments", "width=700,height=300,top=0,left=0,resizable=yes,scrollbars=yes");
}

//open viewonly alt name with something to tell view 
function openAltNameViewWindow()
{
	var refWindow = window.open("../../cdecurate/NCICurationServlet?reqType=getAltNames&acID="+document.SearchActionForm.acID.value, "AlternateNames", "width=700,height=300,top=0,left=0,resizable=yes,scrollbars=yes");
	//var refWindow = window.open("../../cdecurate/NCICurationServlet?reqType=viewAltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "viewDesignate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
}

 function SearchBuildingBlocks(thisBlock, openToTree)
 {
 //alert("thisBlock: " + thisBlock);
    var vAction = document.newDECForm.DECAction.value;
    var selIdx = document.newDECForm.selContext.selectedIndex;
    var vocab = "NCI_Thesaurus";  //default vocab
    var ocText = (document.getElementById("ObjClass").innerText) ? document.getElementById("ObjClass").innerText : document.getElementById("ObjClass").textContent;
    var propText = (document.getElementById("PropClass").innerText) ? document.getElementById("PropClass").innerText : document.getElementById("PropClass").textContent;
    var ocQText = (document.getElementById("ObjQual").innerText) ? document.getElementById("ObjQual").innerText : document.getElementById("ObjQual").textContent;
    var propQText = (document.getElementById("PropQual").innerText) ? document.getElementById("PropQual").innerText : document.getElementById("PropQual").textContent;
    if(openToTree == "true")
    { //remove this and add meta search display
      if(thisBlock == "ObjectClass" && (ocText == null || ocText == ""
        || ocText == "caDSR"))   //|| ObjClass.innerText == "NCI Metathesaurus" 
      {      
        alert("Cannot open to tree for this database.");
        return;
      }
      else if(thisBlock == "PropertyClass" && (propText == null || propText == ""
        || propText == "caDSR"))   //|| PropClass.innerText == "NCI Metathesaurus" 
      {
        alert("Cannot open to tree for this database.");
        return;
      }
      else if(thisBlock == "ObjectQualifier" && (ocQText == null || ocQText == ""
        || ocQText == "caDSR"))   //|| ObjQual.innerText == "NCI Metathesaurus" 
      {
        alert("Cannot open to tree for this database.");
        return;
      }
      else if(thisBlock == "PropertyQualifier" && (propQText == null || propQText == ""
        || propQText == "caDSR"))  //|| PropQual.innerText == "NCI Metathesaurus" 
      {
        alert("Cannot open to tree for this database.");
        return;
      }
    }
    //open the window
	if (isNameChangeOK(vAction, thisBlock) == true)
	{
	    document.SearchActionForm.searchComp.value = thisBlock;
	    document.newDECForm.openToTree.value = openToTree;
	    document.SearchActionForm.isValidSearch.value = "false";
	    if (searchWindow && !searchWindow.closed)
	       searchWindow.close();
	    if(openToTree == "true")
        	searchWindow = window.open("jsp/OpenSearchWindowBlocks.jsp", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
	    else
	    {
	    	document.SearchActionForm.isValidSearch.value = "true";
	    	searchWindow = window.open("../../cdecurate/NCICurationServlet?reqType=searchBlocks&actSelect=FirstSearch" + "&listSearchFor=" + thisBlock + "&listContextFilterVocab=NCI_Thesaurus", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes");
	    }	
	}
 }
 
function closeDep()
{
    window.console && console.log('CreateDEC.js closeDep()');

    if (searchWindow && !searchWindow.closed) {// && searchWindow.open
        window.console && console.log('CreateDEC.js closing searchWindow ...');
        searchWindow.close();
        //window.console && console.log('CreateDEC.js closing of searchWindow prevented (GF32723)');
    }
    if(altWindow && !altWindow.closed) {  // && altWindow.open
        window.console && console.log('CreateDEC.js closing altWindow ...');
        altWindow.close();
    }
    if(statusWindow && !statusWindow.closed) { // && statusWindow.open
        window.console && console.log('CreateDEC.js closing statusWindow ...');
        statusWindow.close();
    }
}

 //allow only one of the comp to change for block edit
 function isNameChangeOK(vAction, thisBlock)
 {
    var isOK = true;
    //do not change both object and property for block edit
    if (vAction == "BlockEdit")
    {
      if (thisBlock == "ObjectClass" || thisBlock == "ObjectQualifier")
      {
        var txProp = document.newDECForm.txtPropClass.value
        if (txProp != null && txProp != "")
          isOK = false;
      }
      else
      {
        var txOC = document.newDECForm.txtObjClass.value
        if (txOC != null && txOC != "")
          isOK = false;
      }
      if (isOK == false)
        alert("Both Object Class and Property cannot be changed in block edit of Data Element Concept");
    }
    return isOK;
 }
 
  function RemoveBuildingBlocks(thisBlock)
  {
      var selIdx = 0;
      document.newDECForm.sCompBlocks.value = thisBlock;
      if (thisBlock == "ObjectClass")
      {
		//document.getElementById('changedOCDefsWarning').style.display='none';	//GF30798
      
        document.newDECForm.selObjRow.value = selIdx;
        if(document.newDECForm.selObjectClass[0].value != null 
          && (document.newDECForm.selObjectClass[0].value != "" || document.newDECForm.selObjectClass[0].text != ""))
        {
          document.newDECForm.selObjectClass[0].value = "";
          SubmitValidate("RemoveSelection");
        }
      }
      else if (thisBlock == "Property")
      {
		//document.getElementById('changedPropDefsWarning').style.display='none';	//GF30798

        document.newDECForm.selPropRow.value = selIdx;
        if(document.newDECForm.selPropertyClass[0].value != null 
          && (document.newDECForm.selPropertyClass[0].value != "" || document.newDECForm.selPropertyClass[0].text != ""))
        {
          document.newDECForm.selPropertyClass[0].value = "";
          SubmitValidate("RemoveSelection");
        }
      }
      else if (thisBlock == "ObjectQualifier")
      {
        selIdx = document.newDECForm.selObjectQualifier.selectedIndex;
        if (selIdx == -1)
          alert("Please select a Qualifier to remove.");
        else
        {
          document.newDECForm.selObjQRow.value = selIdx;
          SubmitValidate("RemoveSelection");
        }
      }
      else if (thisBlock == "PropertyQualifier")
      {
        selIdx = document.newDECForm.selPropertyQualifier.selectedIndex;
         if (selIdx == -1)
          alert("Please select a Qualifier to remove.");
        else
        {
          document.newDECForm.selPropQRow.value = selIdx;
          SubmitValidate("RemoveSelection");
        }
      }     
  } 

function TrimDefinition(type)
{
  var def =  document.newDECForm.CreateDefinition.value;
  if(def != null && def != "")
  {
    var idx = def.search("_");
    if(idx != null && idx != -1)
    {
      if(type == "Object")
      {
        def = def.slice(idx + 1);
        document.newDECForm.ObjDefinition.value = "";
      }
      else if (type == "Property")
      {
        def = def.substr(0, idx);
        document.newDECForm.PropDefinition.value = "";
      }
    }
    else
    {
      def = "";
      document.newDECForm.ObjDefinition.value = def;
      document.newDECForm.PropDefinition.value = def;
    }
  document.newDECForm.CreateDefinition.value = def;
  }
}

	function ShowEVSInfo(thisBlock)
	{
      var selIdx = 0;
      document.newDECForm.sCompBlocks.value = thisBlock;
      if (thisBlock == "ObjectQualifier")
      {
        selIdx = document.newDECForm.selObjectQualifier.selectedIndex;
        if(selIdx != null && selIdx != -1 && document.newDECForm.vOCQualifierCodes.options[selIdx] != null)
        {
          var OCQCode = document.newDECForm.vOCQualifierCodes.options[selIdx].text
          if (OCQCode == null || OCQCode == "null") OCQCode = "";
          var OCQCodeDB = document.newDECForm.vOCQualifierDB.options[selIdx].text
          if (OCQCodeDB == null || OCQCodeDB == "null") OCQCodeDB = "";
          var obQual = document.getElementById("ObjQual");
          obQual.innerText = OCQCodeDB;
          obQual.textContent = OCQCodeDB;
          var obQualId = document.getElementById("ObjQualID");
          obQualId.innerText = OCQCode;
          obQualId.textContent = OCQCode;   
          document.newDECForm.OCQualCCodeDB.value = OCQCodeDB;
          document.newDECForm.OCQualCCode.value = OCQCode;
        }
      }
      else if (thisBlock == "PropertyQualifier")
      {
        selIdx = document.newDECForm.selPropertyQualifier.selectedIndex;
        if(selIdx != null && selIdx != -1 && document.newDECForm.vPropQualifierCodes.options[selIdx] != null)
        {
          var PQCode = document.newDECForm.vPropQualifierCodes.options[selIdx].text
          if (PQCode == null || PQCode == "null") PQCode = "";
          var PQCodeDB = document.newDECForm.vPropQualifierDB.options[selIdx].text
          if (PQCodeDB == null || PQCodeDB == "null") PQCodeDB = "";
          var propQual = document.getElementById("PropQual");
          propQual.innerText = PQCodeDB;
          propQual.textContent = PQCodeDB;  
          var propQualId = document.getElementById("PropQualID");
          propQualId.innerText = PQCode;
          propQualId.textContent = PQCode;  
          document.newDECForm.PCQualCCodeDB.value = PQCodeDB;
          document.newDECForm.PCQualCCode.value = PQCode;
        }
      }  
	} 


	function SearchCDValue()
 	{
		document.SearchActionForm.searchComp.value = "ConceptualDomain";
		document.SearchActionForm.SelContext.value =""; //document.newDECForm.selContext.options[document.newDECForm.selContext.selectedIndex].text;   //get the context 
		document.SearchActionForm.isValidSearch.value = "false";

		if (searchWindow && !searchWindow.closed)
			searchWindow.close()
		searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=775,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
 	}

  function SubmitDEC()
  {
     hourglass();
     document.newDECForm.pageAction.value = "submit"
     document.newDECForm.Message.style.visibility="visible";
     window.status = "submitting data, it may take a minute, please wait....."
     document.newDECForm.submit();
  }
  
  //contact edits
	function editContact(sAction)
	{
	    var selInd = document.newDECForm.selContact.selectedIndex;
	    var sCont = "";
	    if (selInd >= 0)
	    {
	    	sCont = document.newDECForm.selContact[selInd].value; 
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
	    var selInd = document.newDECForm.selContact.selectedIndex;
	    if (selInd >= 0)
	    {
	    	var sCont = document.newDECForm.selContact[selInd].value;
	    	if (sCont != null && sCont != "")
	    	{
	    		if (document.newDECForm.btnViewCt != null)
	    			document.newDECForm.btnViewCt.disabled = false;
	    		if (document.newDECForm.btnRmvCt != null)
	    			document.newDECForm.btnRmvCt.disabled = false;
	    	}
	    }
	}


  function ClearBoxes()
  { 
     hourglass();
     document.newDECForm.pageAction.value = "clearBoxes"
     document.newDECForm.Message.style.visibility="visible";
     window.status = "clearing data, it may take a minute, please wait....."
     document.newDECForm.submit();
  }

  function changeCountPN()
  {
    document.newDECForm.txtPrefNameCount.value = document.newDECForm.txtPreferredName.value.length;
  }
  function changeCountLN()
  {
    document.newDECForm.txtLongNameCount.value = document.newDECForm.txtLongName.value.length;
  }

  function fillCDName()
  {
    document.newDECForm.selConceptualDomainText.value = document.newDECForm.selConceptualDomain.options[0].text;
  }

  function SubmitValidate(origin)
  {
		//check if the date is valid
    //check if the date is valid
    var isValid = "valid";
    //if (origin == "validate")
    //  isValid = isDateValid();
    if (isValid == "valid" && origin == "validate") 
      isValid = isNameTypeValid(); 
	if (isValid == "valid")
	{
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

	   //begin GF32723
        function dojoCheckEVSStatus() {
            window.console && console.log('dojoCheckEVSStatus called');
            dojo.xhrGet({
                // The URL to request
                url: "jsp/CheckEVSStatus.jsp",
                // The method that handles the request's successful result
                // Handle the response any way you'd like!
                load: function(result) {
                    window.console && console.log("10 The flag is: " + result.trim());
                    if(result.indexOf("true") > -1) {
                        clearInterval(timer);
                        window.console && console.log("20 The flag is cleared!");
                    }
                }
            });
        }
        var timer;
        //alert(document.newDECForm && document.newDECForm.userSelectedVocab && document.newDECForm.userSelectedVocab.value);
        var userSelectedVocabName;
        if(document.newDECForm.userSelectedVocab === undefined)  {
            userSelectedVocabName = "nothing";
        } else {
            userSelectedVocabName = document.newDECForm.userSelectedVocab.value;    //document.searchParmsForm.listContextFilterVocab[document.searchParmsForm.listContextFilterVocab.selectedIndex].text;
        }
        window.console && console.log('CreateDEC.js SubmitValidate(origin) userSelectedVocabName is [' + userSelectedVocabName + ']');
        if(userSelectedVocabName !== 'nothing') {
            window.console && console.log('calling dojoCheckEVSStatus ...');
            timer = setInterval(dojoCheckEVSStatus, 5000);
//            dojoCheckEVSStatus();
        } else {
            window.console && console.log('CreateDEC.js SubmitValidate(origin) dojoCheckEVSStatus skipped as vocab is ['+ userSelectedVocabName + ']');
        }

	    //submit the form
        window.console && console.log('CreateDEC.js SubmitValidate(origin) submitting form to DataElementConceptServlet.java doDECUseSelection() ...');
        document.newDECForm.submit();
        window.console && console.log('CreateDEC.js SubmitValidate(origin) form submitted');
        //end GF32723
    }
  }

  function showWaitMessage() {
      hourglass();  //GF32723
      document.newDECForm.Message.style.visibility="visible";  //GF32723
  }

  //alerts if preferred name type was not selected
  function isNameTypeValid()
  {
      var isValid = "valid";
      //check if sys was selected
      var nameType = document.newDECForm.rNameConv[0].checked;
      //check if abbr was selected if not sys
      if (nameType == null || nameType == false)
        nameType = document.newDECForm.rNameConv[1].checked;
      //cehck if user was selcted if neither of abve
      if (nameType == null || nameType == false)
        nameType = document.newDECForm.rNameConv[2].checked;
      if (nameType == null || nameType == false)
      {
        //display the message only if name was changed
        if (document.newDECForm.nameTypeChange.value == "true")
        {
          isValid = "invalid";
          alert("Please select the desired Short Name Type.");
        }
        else
          document.newDECForm.rNameConv[2].checked = true;
      }      
      return isValid;
  }

  function selectBlocksList()
  {
      //building block selection
     document.newDECForm.selObjectClass[0].selected = true;
     document.newDECForm.selPropertyClass[0].selected = true;
     for (var i=0; i<document.newDECForm.selObjectQualifier.length; i++)
     {
        document.newDECForm.selObjectQualifier[i].selected = true;
     }
     for (var i=0; i<document.newDECForm.selPropertyQualifier.length; i++)
     {
        document.newDECForm.selPropertyQualifier[i].selected = true;
     }
     document.newDECForm.selConceptualDomain.options[0].selected = true;
  }
 
function Back()
{
    hourglass();
    document.newDECForm.pageAction.value  = "backToDE";
    document.newDECForm.submit();
}

  function isDateValid()
  {
      var beginDate = document.newDECForm.BeginDate.value;
      var endDate = document.newDECForm.EndDate.value;
      var acAction = document.newDECForm.DECAction.value;
      if (acAction == "EditDEC" || acAction == "BlockEdit") acAction = "Edit";
      return areDatesValid(beginDate, endDate, acAction);
  }

 function EnableChecks(checked, currentField)
  {
      var field = currentField.name;
	if(field == "VersionCheck" && checked)
	{
		document.newDECForm.PointCheck.disabled=false;
		document.newDECForm.PointCheck.checked=false;
		document.newDECForm.WholeCheck.disabled=false;
		document.newDECForm.WholeCheck.checked=false;
	}
	else if(field == "VersionCheck" && checked == false)
	{
		document.newDECForm.PointCheck.disabled=true;
		document.newDECForm.PointCheck.checked=false;
		document.newDECForm.WholeCheck.disabled=true;
		document.newDECForm.WholeCheck.checked=false;
	}
	else if(field == "PointCheck" && checked)
	{
		document.newDECForm.PointCheck.disabled=false;
		document.newDECForm.PointCheck.checked=true;
		document.newDECForm.WholeCheck.disabled=true;
	}
      else if(field == "PointCheck" && checked == false)
	{
		document.newDECForm.WholeCheck.disabled=false;
		document.newDECForm.WholeCheck.checked=false;
		document.newDECForm.PointCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked)
	{
		document.newDECForm.PointCheck.disabled=true;
		document.newDECForm.WholeCheck.checked=true;
		document.newDECForm.WholeCheck.disabled=false;
	}
	else if(field == "WholeCheck" && checked == false)
	{
		document.newDECForm.PointCheck.disabled=false;
		document.newDECForm.PointCheck.checked=false;
	}
  //display business rule message if version is checked but no workflow status is selected
  if ((field == "PointCheck" || field == "WholeCheck") && checked)
  {
    var wfStatus = document.newDECForm.selStatus.value;
    if (wfStatus == null || wfStatus == "")
    {
      alert("Please consider selecting an appropriate Workflow Status when Block Versioning. \n " +
              "Click the Business Rules hyperlink to get more information.");              
    }
  }
}

function disabled(){
		return;
 }
function hideCloseButton(isView){
  if (isView && (window.opener == null)){
    var closeBtn = document.getElementById("btnClose");
    if (closeBtn != null)
     closeBtn.style.display="none"; 
  }
}

