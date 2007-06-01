// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/EditContact.js,v 1.6 2007-06-01 22:20:48 hegdes Exp $
// $Name: not supported by cvs2svn $


var commCount = 0;
var addrCount = 0;

//submits the form
function submitForm(pgAct)
{
	if (pgAct != "openPage" && pgAct != "changeContact" && pgAct != "changeType")
	{
		var validTxt = "";
		var ctOrd = document.ACContactForm.rank.value;
		var ctPerName = "";   //person name
		if (document.ACContactForm.selPer != null && document.ACContactForm.selPer.selectedIndex != null)
		{
			var selPerInd = document.ACContactForm.selPer.selectedIndex;
			if (selPerInd >= 0)
				ctPerName = document.ACContactForm.selPer[selPerInd].value;
		}
		var ctOrgName = "";  //organization name
		if (document.ACContactForm.selOrg != null && document.ACContactForm.selOrg.selectedIndex != null)
		{
			var selOrgInd = document.ACContactForm.selOrg.selectedIndex;
			if (selOrgInd >= 0)
				ctOrgName = document.ACContactForm.selOrg[selOrgInd].value;
		}
		//check if all mandatory attributes are entered
		if (ctOrd == null || ctOrd == "")
			validTxt = "Please enter Contact Rank Order.";
		else if (isNumeric(ctOrd) == false)
			validTxt = "Rank Order must be whole number.";
		else if ((ctPerName == null || ctPerName == "") && (ctOrgName == null || ctOrgName == ""))
		{
			if (document.ACContactForm.rType[0].checked == true)
				validTxt = "Please select Person Name.";
			else if (document.ACContactForm.rType[1].checked == true)
				validTxt = "Please select Organization Name.";
			else
				validTxt = "Please select Contact Person or Organization.";
		}
		//return if not valid display message and exit
		if (validTxt != "")
		{
			alert(validTxt);
			return;
		} 		
	}
	document.ACContactForm.pageAction.value = pgAct;  
	document.ACContactForm.Message.style.visibility = "visible";
	document.ACContactForm.submit();
}

//called from onload event
//submits the page to refresh with the data when opened first
function setup()
{
	var isValid = true;
	//first check if opened first time to refresh the page with the right bean
	if (opener.document != null && opener.document.SearchActionForm != null)
	  isValid = opener.document.SearchActionForm.isValidSearch.value;
	if (isValid == "false")
	{
	  //get selected contact and other info
	  opener.document.SearchActionForm.isValidSearch.value = "true";
	  var selContact = opener.document.SearchActionForm.acID.value;
	  var contAction = opener.document.SearchActionForm.itemType.value;		
	  document.ACContactForm.contAction.value = contAction;  
	  document.ACContactForm.selContact.value = selContact;  
	  submitForm("openPage");      
	}	
}

//submits the page if action is to update
function submitOpener()
{
	var contAct = document.ACContactForm.contAction.value;
	if (contAct != null && contAct == "doContactUpd")
	{
		if (opener.document != null)
			opener.SubmitValidate(contAct);
		window.close();
	}
}


function contactNameChange(contType)
{
	var contID = "";
	if (contType == "person")
	{
		//check person data
		var selPerInd = document.ACContactForm.selPer.selectedIndex;
		if (selPerInd >= 0)
			contID = document.ACContactForm.selPer[selPerInd].value;
	}
	else if (contType == "organization")
	{
		//check org data
		var selOrgInd = document.ACContactForm.selOrg.selectedIndex;
		if (selOrgInd >= 0)
			contID = document.ACContactForm.selOrg[selOrgInd].value;
	}
	//submit the form if either person or org selected is valid
	if (contID != "")
		submitForm("changeContact");
	return;	
}

//check if comm or addr was selected for edit, keep it checked
function selCommAddrForEdit(cmCheck, adCheck)
{
	if (cmCheck != null && cmCheck != "")
	{
        formObj= eval("document.ACContactForm."+cmCheck);
        formObj.checked = true;
		enableCommButtons(true);
	}
	if (adCheck != null && adCheck != "")
	{
        formObj= eval("document.ACContactForm."+adCheck);
        formObj.checked = true;
		enableAddrButtons(true);
	}
	return;
}

//handle communication actions add, edit or remove
function editCommune(sAct)
{
	//alert("communication " + sAct);
	//make sure all mandatory are ok before adding, all other just submit.
	if (sAct == "add")
	{
		var validText = "";
		var cType = "";
		var selInd = document.ACContactForm.selCommType.selectedIndex;
		if (selInd >= 0)
			cType = document.ACContactForm.selCommType[selInd].value;
		var cOrd = document.ACContactForm.comOrder.value;
		var cCyber = document.ACContactForm.comCyber.value;
		//check if all mandatory attributes are entered
		if (cType == null || cType == "")
			validText = "Please select Communication Type.";
		else if (cOrd == null || cOrd == "")
			validText = "Please enter the Call Order.";
		else if (isNumeric(cOrd) == false)
			validText = "Call Order must be whole number.";
		else if (cCyber == null || cCyber == "")
			validText = "Please enter Communication Information.";
		//return if not valid display message and exit
		if (validText != "")
		{
			alert(validText);
			return;
		} 		
	}
	else if (sAct == "remove")
	{
        var removeOK = confirm("Click OK to continue with removing selected Contact Communication attributes.");
        if (removeOK == false) return;
	}
	submitForm(sAct + "Comm");
}

//enable/disable the communication buttons
function enableCommButtons(checked)
{
     if (checked)
       ++commCount;
     else
       --commCount;
     if (commCount == 1)
     {
        document.ACContactForm.btnUpdComm.disabled = false;
        document.ACContactForm.btnRemComm.disabled = false;
     }
     else
     {
        document.ACContactForm.btnUpdComm.disabled = true;
        document.ACContactForm.btnRemComm.disabled = true;
     }
}

//handle address actions add, edit or remove
function editAddress(sAct)
{
	//alert("address " + sAct);
	//make sure all mandatory are ok before adding, all other just submit.
	if (sAct == "add")
	{
		var validText = "";
		var selInd = document.ACContactForm.selAddrType.selectedIndex;
		var aType = "";
		if (selInd >= 0)
			aType = document.ACContactForm.selAddrType[selInd].value;
		var aOrd = document.ACContactForm.txtPrimOrder.value;
		var aAddr = document.ACContactForm.txtAddr1.value;
		var aCity = document.ACContactForm.txtCity.value;
		var aState = document.ACContactForm.txtState.value;
		var aPost = document.ACContactForm.txtPost.value;

		//check if all mandatory attributes are entered
		if (aType == null || aType == "")
			validText = "Please select Address Type.";
		else if (aOrd == null || aOrd == "")
			validText = "Please enter the Primary Order.";
		else if (isNumeric(aOrd) == false)
			validText = "Primary Order must be whole number.";
		else if (aAddr == null || aAddr == "")
			validText = "Please enter Address Line 1.";
		else if (aCity == null || aCity == "")
			validText = "Please enter City.";
		else if (aState == null || aState == "")
			validText = "Please enter State.";
		else if (aPost == null || aPost == "")
			validText = "Please enter Postal Code.";

		//return if not valid display message and exit
		if (validText != "")
		{
			alert(validText);
			return;
		} 		
	}
	else if (sAct == "remove")
	{
        var removeOK = confirm("Click OK to continue with removing selected Contact Address attributes.");
        if (removeOK == false) return;
	}
	submitForm(sAct + "Addr");
}

//enable/disable the address buttons
function enableAddrButtons(checked)
{
     if (checked)
       ++addrCount;
     else
       --addrCount;
     if (addrCount == 1)
     {
        document.ACContactForm.btnUpdAddr.disabled = false;
        document.ACContactForm.btnRemAddr.disabled = false;
     }
     else
     {
        document.ACContactForm.btnUpdAddr.disabled = true;
        document.ACContactForm.btnRemAddr.disabled = true;
     }
}
//returns false if not a number
function isNumeric(sText)
{
   var ValidChars = "0123456789";
   var Char;
   //loop through input text to check if it is number
   for (i = 0; i < sText.length; i++) 
   { 
	  Char = sText.charAt(i); 
	  if (ValidChars.indexOf(Char) == -1) 
     	return false;
   }
   return true;   
}
