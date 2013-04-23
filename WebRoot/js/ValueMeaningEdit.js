// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/ValueMeaningEdit.js,v 1.17 2009-04-21 19:06:49 veerlah Exp $
// $Name: not supported by cvs2svn $

	var secondWindow;
	
	//submit the page
	function SubmitValidate(sAction)
	{   
		var actObject = document.getElementsByName(elmPageAction);
		if ( actObject[0] == null || sAction == "")
		{
			alert("what is the action");
			return;
		}
		//validate the data before submitting
		actObject[0].value = sAction;
		//disable the button and display wait message
		DisableButtons();
		//submit the form
		if (document.VMDetail != null)
			document.VMDetail.submit();
		else if (document.VMUse != null)
			document.VMUse.submit();		
	}
	
   function formValidator(oldVer,oldLN,oldWS,oldCN)
  {
	//alert("I am in form validator");
  	var newVer = document.getElementById('version').value;
  	var newLN = document.getElementById('name').value;
 	var newWS = document.getElementById('ws').value;
 	var newCN = document.getElementById('cn').value;
 	//alert(newVer + newLN + newWS + newCN);
	if(newVer!= oldVer || newLN!=oldLN || newWS!==oldWS)
	{
 	 	if(newCN ==null || newCN =="" || newCN == oldCN)
  		{
  	 	 alert("Please enter the change note to indicate changes to the VM");
  	 	 document.getElementById('cn').value = oldCN; 
  	 	 return false;
  	 	}
  	 	else
  	 	 { 
  	 	   SubmitValidate('validate');
  	 	 }  
	}
	return true;
 }
 
	function searchConcepts(vocab)
	{
		var searchComp = "EditVMConcept";
	    document.SearchActionForm.searchComp.value = searchComp;
	    document.SearchActionForm.isValidSearch.value = "false";
	    if (secondWindow && !secondWindow.closed)
	       secondWindow.close();
	      var url = "../../cdecurate/NCICurationServlet?reqType=searchBlocks&actSelect=FirstSearch" + "&listSearchFor=" + searchComp + "&listContextFilterVocab=" +  vocab;
	      secondWindow = window.open(url, "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes");
	}
	
	function deleteConcept(iRow, conName)
	{
		var conMsg = "the concept : " + conName;
		if (iRow == "-99")
			conMsg = "all concepts";
	  	var confirmOK = confirm("Click OK to continue with removing " + conMsg + ".");
	    if (confirmOK == false) 
	    	return;
	    	
    	var selRowObj = document.getElementsByName(elmSelectRow);
    	if (selRowObj[0] != null)
    	{
    		selRowObj[0].value = iRow;
	  		SubmitValidate(actionDelete);
	    }
	}
	
	function moveConcept(iRow, mAct)
	{
    	var selRowObj = document.getElementsByName(elmSelectRow);
    	if (selRowObj[0] != null)
    	{
    		selRowObj[0].value = iRow;
	  		SubmitValidate(mAct);
	    }
	}
	
	function appendConcept(iRow, nvpValue)
	{
    	var selRowObj = document.getElementsByName(elmSelectRow);
       	if (selRowObj[0] != null)
    	{
    		selRowObj[0].value = iRow;
    		//get the nvp value
    		var nvpObj = document.getElementById(elmNVP);
    		if (nvpObj != null)
    			nvpObj.value = nvpValue;
    		//submit the form
	  		SubmitValidate(actionAppend);
	    }
	}
	
	function setFocusTo(focusElm)
	{
	  //focus to this element
	  if (focusElm != null && focusElm != "")
	  {
		location.hash = focusElm;
	  }
	}
	

	function DisableButtons()
	{
		//make the status message visible
        window.status = "Validating data, it may take a minute, please wait.....";
        var msgObj = document.getElementById("Message");
        if (msgObj != null)
		   msgObj.style.visibility="visible";

	    //disable the buttons
	 	var valObj = document.getElementById('btnValidate');
	 	if (valObj != null)
	    	valObj.disabled = true;
	
	 	var clrObj = document.getElementById('btnClear');
	 	if (clrObj != null)
	    	clrObj.disabled = true;
	
	 	var bkObj = document.getElementById('btnBack');
	 	if (bkObj != null)
	    	bkObj.disabled = true;
	
	 	var dtlObj = document.getElementById('btnDetails');
	 	if (dtlObj != null)
	    	dtlObj.disabled = true;
	
	 	var altObj = document.getElementById('btnAltName');
	 	if (altObj != null)
	    	altObj.disabled = true;
	    	
	    var delObj = document.getElementById('btnDeleteAll');
	 	if (delObj != null)
	    	delObj.disabled = true;
	    
	}

  	function ClearBoxes()
  	{
     	SubmitValidate(actionClear);
  	}

    //open alternate names window
    function openDesignateWindow(sType)
    {
    	if (secondWindow && !secondWindow.closed)
      		secondWindow.close();
    	document.SearchActionForm.isValidSearch.value = "false";  
    	document.SearchActionForm.itemType.value = sType;
        secondWindow = window.open("../../cdecurate/NCICurationServlet?reqType=AltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "designate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
  	}
  	
  	//open cde browser tool
  	function openBrowserWindow(url)
  	{
  		var detailWindow = window.open(url, "CDEBrowser", "width=850,height=600,top=0,left=0,resizable=yes,scrollbars=yes");  		
  	}
  	
  	//sort the column
  	function sort(acType, fieldType)
  	{
  		//ac type
    	var selACObj = document.getElementsByName(elmACType);
    	if (selACObj[0] != null)
    		selACObj[0].value = acType;
    	//field type
    	var selFiedlObj = document.getElementsByName(elmFieldType);
    	if (selFiedlObj[0] != null)
    		selFiedlObj[0].value = fieldType;

    	//submit form
	  	SubmitValidate(actionSort);
  	
  	}
  	
  	//sort the column
  	function showReleased(acType, filterType)
  	{
  		//ac type
    	
    	var selACObj = document.getElementsByName(elmACType);
    	if (selACObj[0] != null)
    		selACObj[0].value = acType;
    	//field type
    	var selFiedlObj = document.getElementsByName(elmFieldType);
    	if (selFiedlObj[0] != null)
    		selFiedlObj[0].value = filterType;

    	//submit form
	  	SubmitValidate(actionFilter);
  	
  	}
  //change the tabs
 function viewVMChangeTab(tab, id, from){
   if (tab == "whereUsedTab" && document.VMDetail != null){
      document.VMDetail.action = "../../cdecurate/NCICurationServlet?reqType=viewVMAction&action=" +tab+ "&id=" +id+ "&from=" +from;
      document.VMDetail.submit();
   }else if (tab == "detailsTab" && document.VMUse != null){
      document.VMUse.action = "../../cdecurate/NCICurationServlet?reqType=viewVMAction&action=" +tab+ "&id=" +id+ "&from=" +from;
      document.VMUse.submit();	
   }
  } 
  
  function viewVMSort(acType, fieldType, id, from){
     //ac type
     var selACObj = document.getElementsByName(elmACType);
     if (selACObj[0] != null)
    	selACObj[0].value = acType;
     //field type
     var selFiedlObj = document.getElementsByName(elmFieldType);
     if (selFiedlObj[0] != null)
    	selFiedlObj[0].value = fieldType;
      document.VMUse.action = "../../cdecurate/NCICurationServlet?reqType=viewVMAction&action=sort&id=" +id+ "&from=" +from;
      document.VMUse.submit();	
  }
  
  function viewVMShow(acType, filterType, id, from){
      //ac type
      var selACObj = document.getElementsByName(elmACType);
      if (selACObj[0] != null)
    	selACObj[0].value = acType;
      //field type
      var selFiedlObj = document.getElementsByName(elmFieldType);
      if (selFiedlObj[0] != null)
    	selFiedlObj[0].value = filterType;
      document.VMUse.action = "../../cdecurate/NCICurationServlet?reqType=viewVMAction&action=show&id=" +id+ "&from=" +from;
      document.VMUse.submit();	
 } 
 //open viewonly alt name with something to tell view 
function openAltNameViewWindow(){
	var refWindow = window.open("../../cdecurate/NCICurationServlet?reqType=getAltNames&acID="+document.SearchActionForm.acID.value, "AlternateNames", "width=700,height=300,top=0,left=0,resizable=yes,scrollbars=yes");
	//var refWindow = window.open("../../cdecurate/NCICurationServlet?reqType=viewAltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "viewDesignate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
}
function hideCloseButton(isView){
  if (isView && (window.opener == null)){
    var closeBtn = document.getElementById("btnClose");
    if (closeBtn != null)
     closeBtn.style.display="none"; 
  }
}