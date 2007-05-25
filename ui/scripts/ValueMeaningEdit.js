// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/ValueMeaningEdit.js,v 1.3 2007-05-25 05:03:27 hegdes Exp $
// $Name: not supported by cvs2svn $

	var secondWindow;
	
	//submit the page
	function SubmitValidate(sAction)
	{
		var actObject = document.getElementById(elmPageAction);
		if ( actObject == null || sAction == "")
		{
			alert("what is the action");
			return;
		}
		//validate the data before submitting
		actObject.value = sAction;
		//disable the button and display wait message
		DisableButtons();
		//submit the form
		if (document.VMDetail != null)
			document.VMDetail.submit();
		else if (document.VMUse != null)
			document.VMUse.submit();		
	}
	
	function searchConcepts()
	{
		var searchComp = "EditVMConcept";
	    document.SearchActionForm.searchComp.value = searchComp;
	    document.SearchActionForm.isValidSearch.value = "false";
	    if (secondWindow && !secondWindow.closed)
	       secondWindow.close();
	  	secondWindow = window.open("NCICurationServlet?reqType=searchBlocks&actSelect=FirstSearch" + "&listSearchFor=" + searchComp + "&listContextFilterVocab=NCI_Thesaurus", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes");
	}
	
	function deleteConcept(iRow, conName)
	{
		var conMsg = "the concept : " + conName;
		if (iRow == "-99")
			conMsg = "all concepts";
	  	var confirmOK = confirm("Click OK to continue with removing " + conMsg + ".");
	    if (confirmOK == false) 
	    	return;
	    	
    	var selRowObj = document.getElementById(elmSelectRow);
    	if (selRowObj != null)
    	{
    		selRowObj.value = iRow;
	  		SubmitValidate(actionDelete);
	    }
	}
	
	function moveConcept(iRow, mAct)
	{
    	var selRowObj = document.getElementById(elmSelectRow);
    	if (selRowObj != null)
    	{
    		selRowObj.value = iRow;
	  		SubmitValidate(mAct);
	    }
	}
	
	function appendConcept(iRow, nvpValue)
	{
    	var selRowObj = document.getElementById(elmSelectRow);
    	if (selRowObj != null)
    	{
    		selRowObj.value = iRow;
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
		var focusObj = document.getElementById(focusElm);
		if (focusObj != null)
			focusObj.scrollIntoView();
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
        secondWindow = window.open("NCICurationServlet?reqType=AltNamesDefs&searchEVS=" + document.SearchActionForm.searchEVS.value, "designate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
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
    	var selACObj = document.getElementById(elmACType);
    	if (selACObj != null)
    		selACObj.value = acType;
    	//field type
    	var selFiedlObj = document.getElementById(elmFieldType);
    	if (selFiedlObj != null)
    		selFiedlObj.value = fieldType;

    	//submit form
	  	SubmitValidate(actionSort);
  	
  	}
  	
  	//sort the column
  	function showReleased(acType, filterType)
  	{
  		//ac type
    	var selACObj = document.getElementById(elmACType);
    	if (selACObj != null)
    		selACObj.value = acType;
    	//field type
    	var selFiedlObj = document.getElementById(elmFieldType);
    	if (selFiedlObj != null)
    		selFiedlObj.value = filterType;

    	//submit form
	  	SubmitValidate(actionFilter);
  	
  	}
	