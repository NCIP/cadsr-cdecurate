
	var secondWindow;
	//submit the page
	function SubmitValidate(sAction)
	{
		var actObject = document.getElementById("pageAction");
		if ( actObject == null)
			alert("what is the object");
		else
		{
			actObject.value = sAction;
			beforeRefresh(sAction);
			if (secondWindow && !secondWindow.closed)
	            secondWindow.close()
			var isValid = storeVMConcept(sAction);
			if (isValid)  //submit only if valid
				document.PVForm.submit();
		}	
	}
	//confirm the remove item			
    function confirmRM(pvNo, itmAct, itmMsg)
    {
		var confirmOK = true;
		if (itmAct == "remove")
		{
	    	confirmOK = confirm("Click OK to continue with removing the " + itmMsg + ".");
	    	if (confirmOK == false) 
	    		return;
		}
		if (confirmOK)
		{
		   document.getElementById("editPVInd").value = pvNo;
		   SubmitValidate(itmAct);   
		} 		
    }
    
    //disable vm search if data exist
    function disableSearch(pvNo)
    {	
    	if (pvNo == "pvNew")
    	{
    		var vmEDiv = document.getElementById("pvNewVMLblEdit");
    		if (vmEDiv != null && vmEDiv.style.display == "inline")
    			vmEDiv.style.display = "none";
    	//	var vmVDiv = document.getElementById("pvNewVMLblView");
    	//	if (vmVDiv != null && vmVDiv.style.display == "none")
    	//		vmVDiv.style.display = "block";    		
    	}
    }
    function CancelNewPV()
    {
		var vmNewDiv = document.getElementById("divpvnew");
		if (vmNewDiv != null)
			vmNewDiv.style.display = "none";
		SubmitValidate("cancelNewPV");		
    }
    
    //when Add new pv button clicked; check if mandatory values exist  
    function AddNewPV()
    {
    	var alertMsg = "";
    	var txtVM = "";
    	//first if user entered
    	var vmDiv = document.getElementById("pvNewVMEdit");
    	if (vmDiv != null && vmDiv.style.display == "block")
    	{
	    	txtVM = document.getElementById("pvNewVM").value;
    	}
    	//may be using concepts
    	if (txtVM == null || txtVM == "")
    	{
    		vmDiv = document.getElementById("pvNewVMView");
    		if (vmDiv != null)
    			txtVM = vmDiv.innerText;
    	}
    	if (txtVM == null || txtVM == "")
	    	alertMsg += "Please enter the text for Value Meaning. \n";
	    	
    	//check user entered description
    	var vmdDiv = document.getElementById("pvNewVMDEdit");
    	if (vmdDiv != null && vmdDiv.style.display == "block")
    	{
	    	var txtVMD = document.getElementById("pvNewVMD").value;
	    	if (txtVMD == null || txtVMD == "")
	    		alertMsg += "Please enter the text for Value Meaning Description. \n";
    	}
    	//get vm pv if not exists
    	var txtPV = document.getElementById("pvNewValue").value;
    	if ((txtPV == null || txtPV == "") && alertMsg == "")
    	{
			if (txtVM != "")
			{
				document.getElementById("pvNewValue").value = txtVM;
				txtPV = txtVM;
			}
    	}
    	if (txtPV == null || txtPV == "")  //still empty
    		alertMsg += "Please enter the text for Permissible Value. \n";

    	if (alertMsg != "")
    		alert(alertMsg);
    	else
    	{
    		if (checkPVVMCombDuplicate(txtPV, txtVM, "newPV"))
    		{
    			var bSave = document.getElementById("btnCreateNew");
    			if (bSave != null && !bSave.disabled)
    				bSave.disabled = true;
    			SubmitValidate("addNewPV");
    		}
    	}
    }
    
    //viewall image clicked; collapse or expand each pv and its image according the expected action    
    function viewAll(changeTo)
    {
    	var vmCount = 0;
    	do
    	{
    		var vmObjID = "pv" + vmCount + "View";
    		var vmObj = document.getElementById(vmObjID);
    		if (vmObj == null)
    		  break;
    		else
    		{
    			var sType = vmObj.getAttribute("viewType");
    			if (sType == null) 
    				alert("unable to find the view type");
    			else if (!((changeTo == "collapseAll" && sType == "collapse") || (changeTo == "expandAll" && sType == "expand")))
    			{        			
        			switch (changeTo)
        			{
        				case "collapseAll":
        					vmObj.setAttribute("viewType", "collapse");
        					vmObj.style.display = "none";
		        			//make the edit icon change if needed
			        		var pvImgS = document.getElementById(vmCount + "ImgSave");
			        		if (pvImgS != null && pvImgS.style.display == "inline")
			        		{
			        			var pvImgE = document.getElementById(vmCount + "ImgEdit");
			        			var pvNo = "pv" + vmCount;
			        			view(vmObj, pvImgS, pvImgE, 'open', pvNo);
			        		}
        					//change the individual icons
		        			var pvImgC = document.getElementById(vmCount + "ImgClose");
		        			if (pvImgC != null) pvImgC.style.display = "inline";
		        			var pvImgO = document.getElementById(vmCount + "ImgOpen");
		        			if (pvImgO != null) pvImgO.style.display = "none";
        					break;
        				case "expandAll":
        					vmObj.setAttribute("viewType", "expand");
        					vmObj.style.display = "block";
		        			var pvImgC = document.getElementById(vmCount + "ImgClose");
		        			if (pvImgC != null) pvImgC.style.display = "none";
		        			var pvImgO = document.getElementById(vmCount + "ImgOpen");
		        			if (pvImgO != null) pvImgO.style.display = "inline";
        					break;
        				case "uneditAll":
        					if (sType == "edit")
        					{
			        			var pvImgHide = document.getElementById(vmCount + "ImgSave");
			        			var pvImgDisp = document.getElementById(vmCount + "ImgEdit");
			        			var pvNo = "pv" + vmCount;
			        			view(vmObj, pvImgHide, pvImgDisp, 'open', pvNo);
        					}
        					break;
        			}
    			}
    		}
    		vmCount += 1;        		        		
    	} while (vmCount > 0);
    	
    	//make the action image toggle
    	if (changeTo == "collapseAll" || changeTo == "expandAll")
    		toggleActionAll(changeTo);
    }
        
    //display close all or open all image for the action 
    function toggleActionAll(changeTo)
    {	
    	//check if all were collapsed to toggle all action image to collapse
    	if (changeTo == "collapse")
    	{
  			var vmCount = 0;
        	var isAllCollapse = true;
    		do
        	{
        		var vmObjID = "pv" + vmCount + "View";
        		var vmObj = document.getElementById(vmObjID);
        		if (vmObj == null)
        		  break;
        		else
        		{
        			var vT = vmObj.getAttribute("viewType");
        			if (vT != "collapse")  //found one that is open
        			{
        				isAllCollapse = false;
        				break;
        			}
        		}
        		vmCount += 1;   
        	} while (vmCount > 0); 
        	
  			if (isAllCollapse == false)
  				return;
    	}
    	displayViewAllImage(changeTo);		     		
    } 
    
    //change the image of the view all	      
    function displayViewAllImage(changeTo)
    {
    	//display proper image
    	switch (changeTo)
    	{
    		case "collapse":
    		case "collapseAll":
    			document.getElementById("imgOpenAll").style.display = "none";
    			document.getElementById("imgCloseAll").style.display = "inline";
    			break;
    		case "expand":
    		case "expandAll":
    			document.getElementById("imgCloseAll").style.display = "none";
    			document.getElementById("imgOpenAll").style.display = "inline"; 
    			break;
    	}        	
    }
    
    //set or get the editing pv indicator            
	function getORsetEdited(pvNo, field)
	{
		var pvIndHidden = document.getElementById("editPVInd");
		if (pvIndHidden != null)
		{
			if (pvNo == "none")
				return pvIndHidden.value;
			else
			{
				pvIndHidden.value = pvNo;
				if ((field == "vm" || field == "vmd") && document.getElementById("txt" + pvNo + "Mean") != null)
					document.getElementById("currentVM").value = document.getElementById("txt" + pvNo + "Mean").value;
			}
		}
	}

	function validatePVAction(action)
	{
		var editedPV = getORsetEdited("none");
		if (editedPV != null && editedPV != "")
		{
		  if (action == "save")
		  {
		  	//check current vm has the data
		  	var curVM = document.getElementById("currentVM");
		  	if (curVM == null || curVM.value == null || curVM.value == "")
		  		editedPV = getORsetEdited(editedPV, "vm");
		  	SubmitValidate("save");
		  }
		  else
		  	alert("Please save or restore the edited Permissible Value");
		  return false;
		}
		return true;
	}
	
    function view(pvdiv, imgdivhide, imgdivdisp, action, pvNo)
    {
    //	if (action == "save" || action == "edit")
	//	{
        	//refresh teh page if value, vm or vmd changed
        /*	var editedPV = getORsetEdited("none");
        	if (editedPV != null && editedPV != "")
        	{
        	  if (action == "save")
        	  {
        	  	//check current vm has the data
        	  	var curVM = document.getElementById("currentVM");
        	  	if (curVM == null || curVM.value == null || curVM.value == "")
        	  		editedPV = getORsetEdited(editedPV, "vm");
        	  	SubmitValidate("save");
        	  }
        	  else
        	  	alert("Please save or restore the edited Permissible Value");
        	  return;
        	}
        */
	//	} 
    	//unedit all first
    //	if (action == "edit") 
    //		viewAll("uneditAll");
  // alert(editedPV + " view " + action); 	
  		if (validatePVAction(action) == false)
  			return;
  			
    	if (action == "save") action = "open";	
    	viewVM = pvdiv;
    	var currDisp = viewVM.style.display;
    	if (currDisp == "block" && action != "open" && action != "edit")
    	{
    		viewVM.style.display = "none";
    		viewVM.setAttribute("viewType", "collapse");
    		toggleActionAll("collapse");
    	}
    	else if (currDisp == "none")
    	{
    		viewVM.style.display = "block";
    		if (action == "edit")
    			viewVM.setAttribute("viewType", "edit");
    		else
    			viewVM.setAttribute("viewType", "expand");
    		toggleActionAll("expand");
    	}
    	//view icons
    	if (imgdivhide != null)
    		imgdivhide.style.display = "none";
    	if (imgdivdisp != null)
    		imgdivdisp.style.display = "inline";
    	//collpase the view while edit more will changes back to edit icon
    	if (currDisp == "block" && action == "view")
    	{
    		imgdivhide = document.getElementById(pvNo + "ImgSave");
    		if (imgdivhide != null)
    			imgdivhide.style.display = "none";
    		imgdivdisp = document.getElementById(pvNo + "ImgEdit");
        	if (imgdivdisp != null)
        		imgdivdisp.style.display = "inline";
    	}
    	//do actions; mark to view if pv was opened already when done with editing
    	if ((action == "open" || action == "edit") && pvNo != null)
    	{
    		imgdivhide = document.getElementById(pvNo + "ImgClose");
    		if (imgdivhide != null)
    			imgdivhide.style.display = "none";
    		imgdivdisp = document.getElementById(pvNo + "ImgOpen");
        	if (imgdivdisp != null)
        		imgdivdisp.style.display = "inline";
        	if (action == "open")
    			action = "view";	        	
    	}
    	//display delete icon when not editing
    	if (action == "view" && pvNo != null)
    	{
    		imgdivhide = document.getElementById(pvNo + "ImgRestore");
    		if (imgdivhide != null)
    			imgdivhide.style.display = "none";
    		imgdivdisp = document.getElementById(pvNo + "ImgDelete");
        	if (imgdivdisp != null)
        		imgdivdisp.style.display = "inline";
    	}
    	//display restore icon for undo the action while editing
    	else if (action == "edit" && pvNo != null)
    	{
    		imgdivhide = document.getElementById(pvNo + "ImgDelete");
    		if (imgdivhide != null)
    			imgdivhide.style.display = "none";
    		imgdivdisp = document.getElementById(pvNo + "ImgRestore");
        	if (imgdivdisp != null)
        		imgdivdisp.style.display = "inline";
    	}
    	//set the display value according to the action
    	if (action == "view" || action == "edit")	
    		changeDepDivDisplay(pvNo, action);
    }

	function changeDepDivDisplay(pvNo, action)
	{
		var editDisp = "none";
		if (action == "edit") 
			editDisp = "block";
			
		//toggle value, vm and vmd displays
		vvmvmdDisplay(pvNo, action);
		
		//concept label toggle
		changeElementText(pvNo, pvNo + "ConLbl", true, "", action);
    	//draw a line around concepts when editing	
    	var divCon = document.getElementById(pvNo + "Con");
    	if (action == "edit")
    	{
    		divCon.style.border = "1px";
    		divCon.style.borderColor = "gray";
    		divCon.style.borderStyle = "solid";
    	}
    	else
    		divCon.style.border = "0px";
		    		
	    	//display or undisplay the delete icon for concepts	
    	count = 0;
    	while (document.getElementById(pvNo + "con" + count) != null) 
    	{
    		var divConEdit = document.getElementById(pvNo + "con" + count);
    		divConEdit.style.display = editDisp;
    		count++;
    	}
		//origin data toggle (add hyperlink if editing)
		changeElementText(pvNo, pvNo + "Org", false, "", action);
		//begin date data data toggle (add hyperlink if editing)
		changeElementText(pvNo, pvNo + "BD", false, "", action);
		//end date data toggle (add hyperlink if editing)
		changeElementText(pvNo, pvNo + "ED", false, "", action);
	}        
         
    function changeElementText(curPV, elmObjName, isBold, nodeText, action)
    {
		var elmObj = document.getElementById(elmObjName);
 		if (elmObj != null)
		{
    		//get the node text if empty -  toggling 
  			var thisObj = elmObj.firstChild;
  			if (thisObj != null)
  			{
	  			while (thisObj.nodeType != 3)
	  			{
  					if (thisObj.firstChild != null)
  						thisObj = thisObj.firstChild;
  					else
  						thisObj = thisObj.nextSibling;
	  			}
  			}
  			else
  				thisObj = elmObj;
  			//get the text from the object
  			if (nodeText == "" && thisObj.nodeValue != null)
  				nodeText = thisObj.nodeValue;
  						
			//get the default text for viewing or editing
			nodeText = getDefaultNodeText(elmObjName, action, nodeText);
			//create object for node text
			var textNode = document.createTextNode(nodeText);
  			//replace the text when changing the data
  			if (action == "replace")
  			{
  				thisObj.replaceNode(textNode);
  				return;
  			}		
			else  //remove all nodes first when toggling
			{
			    while (elmObj.childNodes.length > 0) 
			    {
			        elmObj.removeChild(elmObj.firstChild);
			    }
			}
			var parentNode;
			if (isBold)
				parentNode = document.createElement("b");
	 		//add the link if editing
	    	if (action == "edit")
	    	{
		    	var linkNode = document.createElement("a");
		    	var linkText = "";
		    	if (elmObjName.match("Org") != null)
		    		linkText = "javascript:selectOrigin('" + elmObjName + "','" + curPV + "');";		//"javascript:selectOrigin('pv1Org','pv1');"
		    	else if ((elmObjName.match("ED") != null) || (elmObjName.match("BD") != null))			//"javascript:selectDate('pv1ED','pv1');javascript:show_calendar('PVForm', null, null, 'MM/DD/YYYY');"
		    		linkText = "javascript:selectDate('" + elmObjName + "','" + curPV + "');";
		    	else if (elmObjName.match("Con") != null)
		    		linkText = "javascript:selectConcept('" + elmObjName + "','" + curPV + "');";		//"javascript:selectConcept('pv1Con','pv1');"
		    	
		    	linkNode.setAttribute("href", linkText);
		    	linkNode.appendChild(textNode);
		    	if (isBold)
		    		parentNode.appendChild(linkNode);
		    	else
		    		parentNode = linkNode;
		    	//append it to the main object
		    	elmObj.appendChild(parentNode);
	    	}
    		else if (action == "view")
    		{
		    	if (isBold)
		    		parentNode.appendChild(textNode);
		    	else
		    		parentNode = textNode;
		    	//append it to the main object
		    	elmObj.appendChild(parentNode);
    		}
		}
	}
    
	function vvmvmdDisplay(pvNo, action)
	{
		//value, vm and vmd display
		var divVVEdit = document.getElementById(pvNo + "ValidEdit");
		var divVVView = document.getElementById(pvNo + "ValidView");
		var divValEdit = document.getElementById(pvNo + "ValueEdit");
		var divValView = document.getElementById(pvNo + "ValueView");
		var divVMEdit = document.getElementById(pvNo + "VMEdit");
		var divVMView = document.getElementById(pvNo + "VMView");
		var divVMDEdit = document.getElementById(pvNo + "VMDEdit");
		var divVMDView = document.getElementById(pvNo + "VMDView");
		var divVMAltView = document.getElementById(pvNo + "VMAltView");		
		var divcon = document.getElementById(pvNo + "con0");
		if (action == "edit")
		{
			if (divValEdit != null)
				divValEdit.style.display = "block";
			if (divValView != null)
				divValView.style.display = "none";
			if (divVMAltView != null)
				divVMAltView.style.display = "none";
			//change the display only if it was existed (con does not exist)
			if (divVMEdit != null)
			{
				divVMEdit.style.display = "inline";
				if (divVMView != null)
					divVMView.style.display = "none";
				if (divVMDEdit != null)
					divVMDEdit.style.display = "block";
				if (divVMDView != null)
					divVMDView.style.display = "none";
			}
			//change valid value to edit only if exists
			if (divVVEdit != null)
			{
				divVVEdit.style.display = "block";
				if (divVVView != null)
					divVVView.style.display = "none";
			}			
		}
		else
		{
			if (divVVEdit != null)
				divVVEdit.style.display = "none";
			if (divVVView != null)
				divVVView.style.display = "block";
			if (divValEdit != null)
				divValEdit.style.display = "none";
			if (divValView != null)
				divValView.style.display = "block";
			if (divVMEdit != null)
				divVMEdit.style.display = "none";
			if (divVMView != null)
				divVMView.style.display = "inline";
			if (divVMDEdit != null)
				divVMDEdit.style.display = "none";
			if (divVMDView != null)
				divVMDView.style.display = "block";
			if (divVMAltView != null)
				divVMAltView.style.display = "inline";
		}
	}
    		
   function getDefaultNodeText(objName, action, nodeText)
   {
	  	 //add text to the hyperlink if empty while editing
	  	 if (action == "edit" && nodeText == "")
	  	 {
	  		 if (objName.match("Org") != null)
	  			 nodeText = "List";
	  		 else if (objName.match("BD") != null || objName.match("ED") != null)
	  			 nodeText = "MM/DD/YYYY";
  		 }
  		 else if (action == "view")
  		 {
  			 if (objName.match("Org") != null && nodeText == "List")
  				 nodeText = "";
  			 else if ((objName.match("BD") != null || objName.match("ED") != null) && nodeText == "MM/DD/YYYY")
  				 nodeText = "";
  		 }
  		 return nodeText;
    }
    		
	function onLoad(focusElm)
	{
		//set the attributes of mode type for VM div 
		var vmCount = 0;
		var expanded = false;
		do
		{
			var vmObjID = "pv" + vmCount + "View";
			var vmObj = document.getElementById(vmObjID);
			if (vmObj == null)
			  break;
			else
			{
				if (vmObj.style.display == "block")
				{
					vmObj.setAttribute("viewType", "expand");
					expanded = true;
				}
				else
					vmObj.setAttribute("viewType", "collapse");
			}
			vmCount += 1;   
		} while (vmCount > 0);  
		//make the allviews image as needed
		if (expanded)
	 		displayViewAllImage("expandAll");
 			         		
		//focus to this element
		var focusObj = document.getElementById(focusElm);
		if (focusObj != null)
			focusObj.scrollIntoView();
			
		selectParent();   //do the parent select action if the parent was selected.
		
	//	var pvObj = document.getElementById("editPVInd");
	//	if (pvObj != null && (pvObj.value != null && pvObj.value != ""))
	//		vvmvmdDisplay(pvObj.value, "edit");
	}
    		
	function beforeRefresh(submitAct)
	{
		var pvViewTypes = document.getElementById("PVViewTypes");    
		if (pvViewTypes != null)
		{  
			//make the first one expanded if adding new 
			if (submitAct == "addNewPV")
			{
				var firstRow = 0;
				pvViewTypes = createRow(pvViewTypes, firstRow, vType)        		
			} 	
			var vmCount = 0;
			do
			{
	    		var vmObjID = "pv" + vmCount + "View";
	    		var vmObj = document.getElementById(vmObjID);
	    		if (vmObj == null)
	    		  break;
	    		else
	    		{
	    			var vType = vmObj.getAttribute("viewType");
	    			var pvCount = vmCount;
	    			if (submitAct == "addNewPV")
	    				pvCount += 1;  //increase by one of adding new
					pvViewTypes = createRow(pvViewTypes, pvCount, vType);  
	    		}
	    		vmCount += 1;
			} while (vmCount > 0); 
		}
	}
    		
  function createRow(obj, rowNo, vType)
  {
  	if (obj.length > rowNo)
  	{
		obj[rowNo].value = vType;
		obj[rowNo].text = vType;
    }
    else
    {
		obj[rowNo] = new Option(vType,vType);
    }
	obj[rowNo].selected = true;
    return obj;
  }

  function ClearBoxes()
  {
     SubmitValidate("clearBoxes");
  }

  function selectParent()
  {
  	var parObj = document.getElementById("listParentConcept");
	if (parObj != null)
	{
	  var sInd = parObj.selectedIndex;
      if (sInd > -1)
      {
      	//enable unavailable label by default
      	var crepvObj = document.getElementById("divpvcreate_disable");
      	if (crepvObj != null)  
      		crepvObj.style.display = "block";
      	 //disable available label by default
      	var serpvObj = document.getElementById("divpvcreate_enable");
      	if (serpvObj != null) 
      		serpvObj.style.display = "none";
      		
        //handle non evs parent or non enumerated parent
        var parType = parObj[sInd].value;
        var vdObj = document.getElementById("listVDType");
        var vdType = vdObj.value;
        var selValObj = document.getElementById("btnSelectValues");
        selValObj.disabled = false;
        var rmParObj = document.getElementById("btnRemoveConcept");
        rmParObj.disabled = false;
        if ((parType != null && parType == "Non_EVS") || (vdType != null && vdType == "N"))
        {
          selValObj.value = "View Parent";
          //make create value enabled if non evs parent
          if (crepvObj != null)
            crepvObj.style.display = "none";        
      	  if (serpvObj != null) 
      		serpvObj.style.display = "block";
        }
        else
            selValObj.value = "Select Values";
      }
	}  	
  }

  function selectValues()
  {
  	  var parObj = document.getElementById("listParentConcept");
	  if (parObj != null)
	  {
	      var sInd = parObj.selectedIndex;
	      //store the concept information in hidden selected fields
	      storeConceptInfo(sInd);  //call the function	      
	      var parType = parObj[sInd].value;
	      document.SearchActionForm.isValidSearch.value = "false";   //reset it to false
	      //non evs parent is to only view
	      if (parType != null && parType == "Non_EVS")
	      {
	        if (secondWindow && !secondWindow.closed)
	            secondWindow.close()
	        secondWindow = window.open("jsp/NonEVSSearchPage.jsp", "NonEVSParentView", "width=750,height=500,top=0,left=0,resizable=yes,scrollbars=yes")
	      }
	      else
	      {
	        document.getElementById("actSelect").value = "OpenTreeToParentConcept";
			openConceptSearchWindow("ParentConceptVM", "true");
	      }
      }
      
  }

  //submits the form to mark as removed
  function removeParent()
  {
  	  var parObj = document.getElementById("listParentConcept");
	  if (parObj != null)
	  {
	    var sInd = parObj.selectedIndex;
	    if (sInd != -1)
	    {
	      //make a msg string according to evs or non evs parent 
	      var parString = parObj[sInd].text;
	      var parType = parObj[sInd].value;
          var vdObj = document.getElementById("listVDType");
	      var vdType = vdObj.value;
	      var sAct = "removeParent";  //default to remove parent
	      var strMsg = "Removing Referenced Parent \n  " + parString;
	      if ((parType != null && parType == "Non_EVS") || (vdType != null && vdType == "N"))
	        strMsg += ".\n\n";
	      else
	        strMsg += "\n and all its restricted values.\n\n";
	      strMsg = strMsg + "Click OK to remove.";
	      //check if ok continue removing       
	      var remPVs = false;
	      remPVs = confirm(strMsg);
	      if (remPVs == false)
	      	return;
	      else if (vdType != null && vdType != "N")
	        sAct = "removePVandParent";  //remove both parent and children
	        
	      //store the concept information in hidden selected fields
	      storeConceptInfo(sInd);  
	      //submit the form to refresh.
	      SubmitValidate(sAct);
	    }
	    else
	      alert("Please select a parent to remove");
      }
  }
  
  function storeConceptInfo(sInd)
  {
	  var sParentCode = document.getElementById("ParentCodes").options[sInd].value;
	  var sParentName = document.getElementById("ParentNames").options[sInd].text;
	  var sParentDB = document.getElementById("ParentDB").options[sInd].text; 
	  var sParentMetaSource = document.getElementById("listParentConcept").options[sInd].text;
	  document.getElementById("selectedParentConceptCode").value = sParentCode;
	  document.getElementById("selectedParentConceptName").value = sParentName;
	  document.getElementById("selectedParentConceptDB").value = sParentDB;
	  document.getElementById("selectedParentConceptMetaSource").value = sParentMetaSource;
  }

  function createParent()
  {
      //do not allow to create parent if pvs exist without parents
      var pvCount = document.getElementById("PVViewTypes").length;
      var parCount = document.getElementById("listParentConcept").length;
      if (pvCount >0 && parCount < 1)
      {
        alert("Please remove existing Permissible Values before selecting parents to constrain the values");
        return;
      }
      else
      {
      	openConceptSearchWindow("ParentConcept", "term");
      }
  }
  
  function createMultipleValues()
  {
  	  var vdtypeObj = document.getElementById("listVDType");
      if (vdtypeObj.value == "E")
      {
          openConceptSearchWindow("EVSValueMeaning", "term");
      }
      else
          alert("Type must be 'Enumerated' to create/edit/remove Permissible Values.");
  }
  
  function openConceptSearchWindow(serComp, treeOpen)
  {
	  document.SearchActionForm.searchComp.value = serComp;
	  document.getElementById("openToTree").value = treeOpen;
	  document.SearchActionForm.isValidSearch.value = "false";
	  if (secondWindow && !secondWindow.closed)
	    secondWindow.close()
      if(treeOpen == "true")
    	  searchWindow = window.open("jsp/OpenSearchWindowBlocks.jsp", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
      else
      {
    	  document.SearchActionForm.isValidSearch.value = "true";
    	  searchWindow = window.open("NCICurationServlet?reqType=searchBlocks&actSelect=FirstSearch" + "&listSearchFor=" + serComp + "&listContextFilterVocab=NCI_Thesaurus", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes");
      }	
  }
  
    //sort the pv attributes
  function sortPV(fieldName)
  {
    if (document.getElementById("PVViewTypes").length > 0)
    {
      document.getElementById("pvSortColumn").value = fieldName;
      SubmitValidate("sortPV");
    }
  }

  //disables the valid value selection
  function disableSelect()
  {
    var sInd = document.getElementById("selValidValue").selectedIndex;
    if (sInd >-1)
      document.getElementById("selValidValue").selectedIndex = -1;
  }

  //adds new option for the hidden vm select fields from new window
  function AllocSelRowOptions(rowArray)
  {
  	if (rowArray != null)
  	{
	    for (var i = 0; rowArray.length > i; i++)
	    {
	      document.getElementById("hiddenSelRow")[i] = new Option(rowArray[i],rowArray[i]);
	      document.getElementById("hiddenSelRow")[i].selected = true;
	    }
    }
  } 
  
	//to change the origin value, store the editing element and pv number in the hidden field
    function selectOrigin(curElm, curPV)
    {
	  	//check if any item was in edit mode
	  	if (curPV == "all")
	  	{
		  	var editElm = document.getElementById("editPVInd").value
		  	if (editElm != null && editElm != "")
		  	{
		  		alert("One of the Permissible Values is changed. Do save the changes before block editing.");
		  		return;
		  	}
	  	}
	  	var curInd = document.getElementById("currentElmID");
	  	if (curInd != null)
	  	{
	  		curInd.value = curElm;
	  		document.getElementById("currentPVInd").value = curPV;
		  	if (secondWindow && !secondWindow.closed)
		    	secondWindow.close()
		  	secondWindow = window.open("jsp/ACOrigin.jsp", "SelectOrigin", "width=750,height=700,top=0,left=0,resizable=yes,scrollbars=yes")	  		
	  	}
    }

	//to change the date value, store the editing element and pv number in the hidden field
    function selectDate(curElm, curPV)
    {
	  	//check if any item was in edit mode
	  	if (curPV == "all")
	  	{
		  	var editElm = document.getElementById("editPVInd").value
		  	if (editElm != null && editElm != "")
		  	{
		  		alert("One of the Permissible Values is changed. Do save the changes before block editing.");
		  		return;
		  	}
	  	}
	  	var curInd = document.getElementById("currentElmID");
	  	if (curInd != null)
	  	{
	  		curInd.value = curElm;  		
	  		document.getElementById("currentPVInd").value = curPV;
	  	}
	  	//call javascript to show calender
	  	show_calendar('PVForm', null, null, 'MM/DD/YYYY');
    }
  
  	//append the selected date to the respective table data and hidden fields
  	function appendDate(sDate)
	{
		var success = false;
		var curelm;
		var curelmInd = document.getElementById("currentElmID");
		if (curelmInd != null)
		{
			curelm = curelmInd.value;
			if (curelm != null && curelm != "")
			{
				if (curelm == "allBeginDate" || curelm == "allEndDate")
				{
					changeAll(curelm, sDate);
					success = true;
				}
				else
				{
					var curPV = document.getElementById("currentPVInd");
					changeElementText(curPV, curelm, false, sDate, "replace");
					success = true;
					//udate the hidden fields
					if (curPV != null && curPV.value != null)
						document.getElementById("editPVInd").value = curPV.value;
					if (curelm.match("ED") != null)
						document.getElementById("currentED").value = sDate;
					if (curelm.match("BD") != null)
						document.getElementById("currentBD").value = sDate;
				}
			}
		}
		if (success == false)
			alert(curelm + " Unable to append the Date for the selected Permissible Value " + sDate);		
	}
	
	//submit the page to change all the data
    function changeAll(fType, fData)
    {
   // alert(fType + fData);
    	if (fType == "allOrigin")
			document.getElementById("currentOrg").value = fData;
		else if (fType == "allBeginDate")
			document.getElementById("currentBD").value = fData;
		else if (fType == "allEndDate")
			document.getElementById("currentED").value = fData;
    	SubmitValidate('changeAll');
    }
    

	//to add concepts to the vm, store the editing element and pv number in the hidden field
  function selectConcept(curElm, curPV)
  {
  	var curInd = document.getElementById("currentElmID");
  	if (curInd != null)
  	{
  		curInd.value = curElm;
  		document.getElementById("currentPVInd").value = curPV;
        openConceptSearchWindow("VMConcept", "term");
  	}
  }
  
  	//add a row to append the selected concept to teh vm
  	function appendConcept(txName, txId, txVocab, vmName, vmDesc)
	{
		var curPV = document.getElementById("currentPVInd");
		if (curPV != null && curPV.value != null)
		{
			changeConceptText(curPV.value, txName, txId, txVocab, vmDesc);
			//update the hidden fields
			document.getElementById("editPVInd").value = curPV.value;
			//update vm name and description
			appendVMNameDesc(curPV.value, vmName, vmDesc)
		}
		else
			alert(curPV.value + " Unable to append the Date for the selected Permissible Value " + txName);		
	}

	function changeConceptText(pvInd, txName, txId, txVocab, txDesc)
	{
  		//get teh con count
  		var curTbl = document.getElementById(pvInd + "TBL");
  		var totalCon = curTbl.rows.length;
  		//create new row; add id; add tds and its contents
   		var trCur;
   		var curTrCount = totalCon;
  		var txType = "Qualifier";
  		if (totalCon < 1) 			//(isNewP)
  			trCur = curTbl.insertRow();
  		else
  		{
  			curTrCount = (totalCon-1);
  			//use the empty one if exists
  			var trP = curTbl.rows(curTrCount);
  			if (trP != null && (trP.getAttribute("id") == null || trP.getAttribute("id") == ""))
  			{
  				txType = "Primary";
  			 	trCur = curTbl.rows(curTrCount);
  			 	trCur.deleteCell(); 
  			}
  			else //if (trP != null)  //push forward the last one in the list 
  			{
  				trCur = curTbl.insertRow(curTrCount);
  				trP = curTbl.rows(totalCon);
  				trP.setAttribute("id", pvInd + "tr" + totalCon);
  				//change the id of the delete div 
  				replaceDelDiv(trP, curTrCount, totalCon, pvInd, trP.getAttribute("id"));
  			}
  		}
  		//add id to the row	
  		var trID = pvInd + "tr" + curTrCount;
  		trCur.setAttribute("id", trID);
  		//create first column
  		var delDivID = pvInd + "Con" + curTrCount;
  		var tdIm = createTD("delImg", "", delDivID, trID, pvInd);
  		//create conName column
  		var tdN = createTD("conName", txName, "", trID, pvInd);
  		//create conID column
  		var tdId = createTD("conId", txId, "", trID, pvInd);
  		//create conVocab column
  		var tdV = createTD("conVocab", txVocab, "", trID, pvInd);
  		//create conVocab column
  		var tdT = createTD("conType", txType, "", trID, pvInd);
  		//create conVocab column
  		var tdD = createTD("conDesc", txDesc, "", trID, pvInd);
  		
		//append the cells to the row
		trCur.appendChild(tdIm);																			
		trCur.appendChild(tdN);																			
		trCur.appendChild(tdId);																			
		trCur.appendChild(tdV);																			
		trCur.appendChild(tdT);																			
		trCur.appendChild(tdD);																			
 	}
  
  	function createTD(tdType, sText, divId, trID, pvInd)
  	{
  		var tdElm = document.createElement("td");
  		tdElm.setAttribute("valign", "top");
  		tdElm.setAttribute("nowrap", "nowrap");
  		if (tdType == "delImg")
  		{
  			var delDiv = document.createElement("div");
  			delDiv = appendDelDiv(delDiv, divId, trID, pvInd);
  			tdElm.appendChild(delDiv);
  		}
  		else
  		{
  			var nodeText = document.createTextNode(sText);
  			var spText = document.createTextNode("\u00a0");
  			if (tdType == "conId")
  				tdElm.appendChild(spText);
  			//make description invisible
  			if (tdType == "conDesc")
  			{
  				tdElm.style.visibility = "hidden";  //setAttribute("style", "visibility:hidden");
  				tdElm.setAttribute("width", "0.1px");
  				var aDiv = document.createElement("div");
  				aDiv.style.display = "none";		//.setAttribute("style", "display:none");
  				aDiv.appendChild(nodeText);
  				tdElm.appendChild(aDiv);
  			}
  			else
  			{
  				tdElm.appendChild(nodeText);
  			  	tdElm.appendChild(spText);  
  			}			
  		}
  		return tdElm;
  	}
  	
  	function appendDelDiv(delDiv, divId, trID, pvInd)
  	{
  		delDiv.setAttribute("id", divId);
  		delDiv.setAttribute("style", "display:inline");
  		var linkElm = "<a href=\"javascript:deleteConcept('" + trID + "', '" + pvInd + "');\" title=\"Remove Item\"></a>";
  		var divLink = document.createElement(linkElm);
  		var divImg = document.createElement("<img src=\"Assets/delete_small.gif\" border=\"0\" alt=\"Remove\">");
  		divLink.appendChild(divImg);
  		delDiv.appendChild(divLink);
  		//put extra space
  		var spText = document.createTextNode("\u00a0");
  		delDiv.appendChild(spText);
  		
  		return delDiv;
  	}
  	
  	function appendVMNameDesc(pvInd, vmName, vmDesc)
  	{
  		//append the current desc to the vm description
  		var curTbl = document.getElementById(pvInd + "TBL");
  		var tblLen = curTbl.rows.length;
  		var appName = "";
  		var appDesc = "";
  		for (var i =0; i<tblLen; i++)
  		{
  			var nameCell = curTbl.rows(i).cells(1);
  			if (appName != "") appName += " ";
  			if (nameCell != null && nameCell.innerText != null && nameCell.innerText != "")
  				appName += nameCell.innerText;
  			var descCell = curTbl.rows(i).cells(5);
  			if (appDesc != "") appDesc += ": ";
  			if (descCell != null && descCell.innerText != null && descCell.innerText != "")
  				appDesc += descCell.innerText;
  		}
  		
  		var vm = document.getElementById(pvInd + "VMView");
  		if (vm != null && vm.style.display == "none")
  		{
  			vm.style.display = "inline";
  			vmedit = document.getElementById(pvInd + "VMEdit");
  			if (vmedit != null)
  				vmedit.style.display = "none";
  		}
  		vm.innerText = appName;  // vmName;
  		document.getElementById("currentVM").value = appName;
  		
  		//get the vm description object
  		var vmd = document.getElementById(pvInd + "VMDView");
  		if (vmd != null && vmd.style.display == "none")
  		{
  			vmd.style.display = "block";
  			vmdedit = document.getElementById(pvInd + "VMDEdit");
  			if (vmdedit != null)
  				vmdedit.style.display = "none";
  		}
  		vmd.innerText = appDesc;  // vmDesc;
  		//make sure to disable the search link also when vm name exists
  		if (appName != "")
  			disableSearch('pvNew');  
  		return;
  	}
  	
  	function enableEditVM(pvInd)
  	{  		
  		//get value meaning object
  		var vm = document.getElementById(pvInd + "VMEdit");
  		if (vm != null && vm.style.display == "none")
  		{
  			vm.style.display = "block";
  			vmedit = document.getElementById(pvInd + "VMView");
  			if (vmedit != null)
  				vmedit.style.display = "none";
  		}
  		var vmTE = document.getElementById("txt" +pvInd + "Mean");  		
  		if (vmTE != null)
  			document.getElementById("currentVM").value = vmTE.value;
  	//	vm.innerText = "";  // vmName;
  		
  		//get the vm description object
  		var vmd = document.getElementById(pvInd + "VMDEdit");
  		if (vmd != null && vmd.style.display == "none")
  		{
  			vmd.style.display = "block";
  			vmdedit = document.getElementById(pvInd + "VMDView");
  			if (vmdedit != null)
  				vmdedit.style.display = "none";
  		}
  		var vmDE = document.getElementById("txt" +pvInd + "Def");  
  		
  	//	if (vmT != null)
  	//	vmd.innerText = "";  // vmDesc;  		
  	}
  	
  	function deleteConcept(trId, pvId)
  	{
  		//get teh con count
  		var curTbl = document.getElementById(pvId + "TBL");
  		var totalCon = curTbl.rows.length;
  		for (var i=0; i<totalCon; i++)
  		{
  			var curTr = curTbl.rows(i);
  			if (curTr != null && curTr.getAttribute("id") == trId)
  			{
  				var parPrim = "";
  				var par = document.getElementById(pvId + "Par");
  				if (par != null)
  					parPrim = par.innerText;
		  		//do not remove if the primary concept that is associated to a parent
		  		if (parPrim != null && parPrim != "" && i == totalCon -1)
		  		{
		  			alert("The primary concept cannot be removed when the Permissible Value is referenced by a parent concept." +
		  				"\nTo remove this concept, you must remove the Permissible Value.");
		  			break;  			
		  		}
		  		
  				//change the id of the other rows
  				for (var j = i+1; j<totalCon; j++)
  				{
  					var nextTr = curTbl.rows(j);
  					nextTr.setAttribute("id", pvId + "tr" + (j-1));
  					replaceDelDiv(nextTr, j, j-1, pvId, trId);
  				} 
  				curTbl.deleteRow(i);  				
  				document.getElementById("editPVInd").value = pvId;
  				appendVMNameDesc(pvId, "", "")
  				isDelete = true;
  				break;
  			}
  		}
  		//enable text box if no concepts exist
  		var totalCon = curTbl.rows.length;
  		if (totalCon == 0)
  		{
  			//create empty row
  			var trCur = curTbl.insertRow();
  			var tdN = createTD("emptyRow", "\u00a0", "", "", "");
  			trCur.appendChild(tdN);
  			//make vm edit mode do this later
  			//enableEditVM(pvId);
  		}  		
  	}
  	
  	function replaceDelDiv(selTr, cD, nD, pvId, trId)
  	{
  		var delDiv = document.getElementById(pvId + "Con" + cD);
  		if (delDiv != null)
  		{
			var newDiv = document.createElement("div");
			var divId = pvId + "Con" + nD;
			newDiv = appendDelDiv(newDiv, divId, trId, pvId);
			var delDiv = selTr.cells(0).replaceChild(newDiv, delDiv);
  		}
  	}
  	
  	//store the Edited concepts of the VM in hidden select box
  	function storeVMConcept(sAct)
  	{
  		var pvId = document.getElementById("editPVInd").value;
  		if (pvId != null && pvId != "")
  		{
  			//make sure vm text exists and no duplicate pvvm
	  		if (sAct == "save" || sAct == "edit")
	  		{
	  			if (checkVMText(pvId) == false)
	  				return false;
	  		}
  			//add the concepts to the hidden field	
	  		var hidElm = document.getElementById("hiddenConVM");
	  		if (hidElm != null)
	  		{
		  		var curTbl = document.getElementById(pvId + "TBL");
		  		var totalCon = curTbl.rows.length;
		  		for (var i=0; i<totalCon; i++)
		  		{
		  			var curTr = curTbl.rows(i);
		  			if (curTr != null && curTr.cells(2) != null)
		  			{
		  				var oText = curTr.cells(2).innerText;
			  			var elmLen = hidElm.length;
			  			hidElm[elmLen] = new Option(oText, oText);
			  			hidElm[elmLen].selected = true;
		  			}
		  		}		  		
	  		}
  		}
  		return true;
  	}
  	
  	function checkVMText(pvId)
  	{
  			//get the vm object
  		 	var vmT = document.getElementById(pvId + "VMEdit");
  		 	var vmText = "";
  		 	if (vmT == null)
  		 	{
  		 		vmT = document.getElementById(pvId + "VMView");
  		 		if (vmT != null)
  		 			vmText = vmT.innerText;
  		 	}
  		 	else
  		 	{
  		 		vmInput = document.getElementById("txt" + pvId + "Mean");
  		 		if (vmInput != null)
  		 			vmText = vmInput.value;
  		 	}
  		 	//now check if vm exists
  		 	if (vmText == null || vmText == "")
  		 	{
  		 		alert("Value Meaning is mandatory for a Permissible Value.  Please add a Value Meaning.");
  		 		return false;
  		 	}
	  		//check if pv vm comb is valid
	  		var vText = "";
	  		var pvT = document.getElementById("txt" + pvId + "Value");
	  		if (pvT != null)
	  			vText = pvT.value;
	  		
  			return checkPVVMCombDuplicate(vText, vmText, pvId);
  			
  		//finally	
  		return true;
  	}
  	
  	function checkPVVMCombDuplicate(sVal, sVM, pvId)
  	{
		//make it lower case no space for matching  		
		sVal = sVal.toLowerCase();
  		while (sVal.indexOf(' ') > 0)
		{
			sVal = sVal.replace(' ', '');
		}
  		sVM = sVM.toLowerCase();
  		while (sVM.indexOf(' ') > 0)
		{
			sVM = sVM.replace(' ', '');
		}

  		//get the value and meaning from each row and compare it to the text of the saving pv
  		var i = 0;
  		do
  		{
  			var pvCount = "pv" + i;
  			if (pvCount != pvId)
  			{
  				//loop through existing ones to check for duplicate pv vm
	  			var pvTr = document.getElementById(pvCount + "ValueView");
	  			if (pvTr != null && pvTr.innerText != "")
	  			{
	  				var val = pvTr.innerText;
			  		val = val.toLowerCase();  //make it lower case no space for matching
			  		while (val.indexOf(' ') > 0)
					{
						val = val.replace(' ', '');
					}
	  				
	  				var vm = "";
	  				var vmTr = document.getElementById(pvCount + "VMView");
		  			if (vmTr != null && vmTr.innerText != "")
	  					vm = vmTr.innerText;
			  		vm = vm.toLowerCase();   //make it lower case no space for matching
			  		while (vm.indexOf(' ') > 0)
					{
						vm = vm.replace(' ', '');
					}
	  				if (sVal == val && sVM == vm)
	  				{
	  					alert("The Value and the Value Meaning combination must be unique in the Value Domain." +
	  						"\n Modify either the Value or the Value Meaning to create new Permissible Value.");
	  					return false; 
	  				}
	  			}
	  			else  //may be no more rows
	  				return true;  
  			}
  			i += 1;
  		}
  		while (i > 0)
  		//none found
  		return true;
  	}
  	
  	function searchVM()
    {
	    if (document.SearchActionForm.searchComp != null)
	    {
	        document.SearchActionForm.searchComp.value = "ValueMeaning";
	        document.SearchActionForm.isValidSearch.value = "false";
	    }
	    if (secondWindow && !secondWindow.closed)
	      secondWindow.close()
	    secondWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=875,height=570,top=0,left=0,resizable=yes,scrollbars=yes")
    }
    
    function enableUSE()
    {
  		var usElm = document.getElementById("btnUseSelect");
  		if (usElm != null)
    		usElm.disabled = false;
    	document.getElementById("currentVM").value = "selected one";
    }
    