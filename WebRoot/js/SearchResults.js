// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/SearchResults.js,v 1.14 2008-12-09 20:16:23 veerlah Exp $
// $Name: not supported by cvs2svn $

  var numRowsSelected = 0;
  var attributesSelected = 0;
  var editID = "";
  var editName = "";
  var editLongName = "";
  var editDefinition = "";
  var editASL = "";
  var editUsedby = "";
  var sComp = "";
  var selRow = "";
  var noMessage = "";
  var desWindow = "";
  var detailWindow = "";
  var statusWindow = "";
  var db = "";
  var db2 = "";
  var temp = "";
  var ccode = "";
  var umls = "";
  var count = 0;
  var checkCnt = 0;
  var menuTextColor = "#000000";
  var menuDisabledColor = "#777777";
 
  //  checks the status message everytime page opens and alerts the  message
  function displayStatus(vStatusMessage, vSubmitAction)
  {
       if (vStatusMessage == "" || (vStatusMessage == "no message") || (vStatusMessage == "nothing") || (vStatusMessage == "no Message"))
         return;
       else if (vStatusMessage == "no write permission")
          alert("User does not have authorization to Create/Edit for the selected context");
       else 
          alert(vStatusMessage);
  }
  
  //opens window for more alternate names
  function openAltNameWindow(docType, acID)
  {
      document.SearchActionForm.acID.value = acID;
      document.SearchActionForm.itemType.value = docType;
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/AlternateNameWindow.jsp", "AlternateNames", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  //opens window for more refrence documents
  function openRefDocWindow(docType, acID)
  {
      document.SearchActionForm.acID.value = acID;
      document.SearchActionForm.itemType.value = docType;
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/ReferenceDocumentWindow.jsp", "ReferenceDocuments", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  //opens window for more permissible values
  function openPermValueWindow(acName, acID)
  {
      document.SearchActionForm.acID.value = acID;
      document.SearchActionForm.itemType.value = acName;  //ac name for pv
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 910;
      detailWindow = window.open("jsp/PermissibleValueWindow.jsp", "PermissibleValue", "width=900,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  //opens window for more permissible values
  function openProtoCRFWindow(acName, acID)
  {
      document.SearchActionForm.acID.value = acID;
      document.SearchActionForm.itemType.value = acName;  //ac name for protocol and crf
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/ProtoCRFWindow.jsp", "ProtocolCRF", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  //  opens a window for large status messages
  function displayStatusWindow()
  {
      if (statusWindow && !statusWindow.closed)
          statusWindow.close()
      var windowW = (screen.width/2) - 230;
      statusWindow = window.open("jsp/OpenStatusWindow.jsp", "statusWindow", "width=475,height=545,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes")      
  }

  //opens the details for using decs
  function openDECDetail(selRowID)
  {
      document.searchResultsForm.selRowID.value = selRowID;
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      detailWindow = window.open("jsp/DECDetailWindow.jsp", "DECDetails", "width=750,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
  }
   
  //opens window for more concept names
  function openConceptWindow(acName, acID, ac2ID, acType)
  {
      document.SearchActionForm.acID.value = acID;
      document.SearchActionForm.ac2ID.value = ac2ID;
      document.SearchActionForm.itemType.value = acType;  //ac type for concept search
      document.SearchActionForm.searchComp.value = acName;  //ac name for pv
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/ConceptClassDetailWindow.jsp", "ConceptClass", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  //opens window for more conceptual Domains
  function openConDomainWindow(acName)
  {
      document.SearchActionForm.searchComp.value = acName;  //value meaning
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/ConDomainDetailWindow.jsp", "ConceptualDomain", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  function SetSortTypeJS(sortBy, menuAction)
  {
    var isSubmitOk = true;
    if (document.searchResultsForm.serRecCount != null)
    {
      var dCount = document.searchResultsForm.serRecCount.value;
      if (dCount == null || dCount == "No " || dCount == "0")
      {
        isSubmitOk = false;
        alert("Search results must be present before sorting the column"); 
      }
    }
 /*   var vSearchAC = document.searchParmsForm.listSearchFor.options[document.searchParmsForm.listSearchFor.selectedIndex].value;
    //make sure it is searched before the sorting action in search for create page.
    if (menuAction != null && menuAction == "searchForCreate")
    {
      if (opener && opener.document != null && opener.document.SearchActionForm != null)
      {
        if (opener.document.SearchActionForm.isValidSearch.value == "false")
        {
          isSubmitOk = false;
          alert("Please make sure that initial search has been done before sorting the column"); 
        }
      }
    } */
    if (isSubmitOk == true)
    {
      window.status = "Submitting the page, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.sortType.value = sortBy;
      document.searchResultsForm.actSelected.value = "sort";
      document.searchResultsForm.numSelected.value = numRowsSelected;
      document.searchResultsForm.submit();
    }
  }

  function ShowSelectedRows(SelectAll)
  {
      window.status = "Submitting the page, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      if(SelectAll == false)
        document.searchResultsForm.actSelected.value = "NoRowsSelected";
      else
      document.searchResultsForm.actSelected.value = "Rows";
      document.searchResultsForm.numSelected.value = numRowsSelected;
      document.searchResultsForm.submit();
  }

  // Add the selected items to the user's reserved CSI and create an Alert to
  // monitor activity on the CSI.
  function monitorCmd()
  {
      window.status = "Submitting list to the Sentinel Tool, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.actSelected.value = "Monitor";
      document.searchResultsForm.numSelected.value = numRowsSelected;
      document.searchResultsForm.submit();
  }

  // adds the selected row to the opener document and closes the window if the action is searchforcreate
  // for permissible value handles the multiple row selection
  function ShowUseSelection()
  {
      getRowAttributes();   //get the values of each row.
      //use the selected VD in create/edit DE form
      if (sComp == "DataElementConcept" && opener.document.newCDEForm != null)
          DECShowUseSelection();
      
      //use the selected VD in create/edit DE form
      else if (sComp == "ValueDomain" && opener.document.newCDEForm != null)
          VDShowUseSelection();
      
      //use the selected cd in either DEC or VD forms
      else if (sComp == "ConceptualDomain")
          CDShowUseSelection();
      
      //use the selected pv in create/edit vd form
      else if (sComp == "PermissibleValue" && opener.document != null)
          PVShowUseSelection();	
      
      //use the selected VM in create pv form
      else if (sComp == "ValueMeaning" && opener.document.PVForm != null)  //search for value meaning
          VMShowUseSelection();	

      //use the selected DE in create/edit DE form for DDE
      else if (sComp == "DataElement" && opener.document.newCDEForm != null)  //search for DDE
          DEShowUseSelection();
  } // end of ShowUseSelection

  //do the use selection for DEC search
  function DECShowUseSelection()
  {
	//	} // end != BlockEdit
    if(opener.document.SearchActionForm != null) opener.document.SearchActionForm.isValidSearch.value = "false";
    reSetAttribute();  //calls function to reset the attribute values
    if (opener.document.newCDEForm.acSearch != null)
      opener.document.newCDEForm.acSearch.value = "DataElementConcept";
    submitOpener("updateNames");   //calls the function submit hte opener form.
    window.close();
  }

  //do the use selection for VD search
  function VDShowUseSelection()
  {
	//	} // end != BlockEdit
		opener.document.SearchActionForm.isValidSearch.value = "false";
		reSetAttribute();  //calls the reset the attribute values
    if (opener.document.newCDEForm.acSearch != null)
      opener.document.newCDEForm.acSearch.value = "ValueDomain";
    submitOpener("updateNames");   //calls the function submit hte opener form.
		window.close();
  }

  //do the use selection for CD search
  function CDShowUseSelection()
  {
		if (opener.document.createVDForm != null)
		{
      //handle selected pv for cd change 
      editLongName = editLongName + " - " + editUsedby;
    //  var isCDVDValid = opener.doCDNameChangeAction(editLongName);
      var isCDVDValid = true;
      if (isCDVDValid == true)
      {
        opener.document.createVDForm.selConceptualDomain[0].value = editID;
        opener.document.createVDForm.selConceptualDomain[0].text = editLongName;
        opener.document.createVDForm.selConceptualDomainText.value = editLongName;    
      }
		}
		else if (opener.document.newDECForm != null)
		{
			opener.document.newDECForm.selConceptualDomain[0].value = editID;
      editLongName = editLongName + " - " + editUsedby;
			opener.document.newDECForm.selConceptualDomain[0].text = editLongName;
			opener.document.newDECForm.selConceptualDomainText.value = editLongName;            
		}
		if (opener.document.SearchActionForm.isValidSearch != null)
			opener.document.SearchActionForm.isValidSearch.value = "false";
		
		reSetAttribute();  //calls the reset the attribute values
		window.close();
  }


  //do the use selection for VM search
  function VMShowUseSelection()
  {
    submitOpener("appendSearchVM");
    window.close();
  }

  //do the use selection for DE search
  function DEShowUseSelection()
  {
		var selCount = document.searchResultsForm.hiddenSelectedRow.length;
		opener.AllocOptions(selCount);  //function in CreateVD.jsp
    
		for(k=0; k<selCount; k++)
		{
  		  var rowNo = document.searchResultsForm.hiddenSelectedRow[k].value;
  		  var selRow = document.searchResultsForm.hiddenSelectedRow[k].text;
			  editID = document.searchResultsForm.hiddenSearch[rowNo].value;
			  editName = document.searchResultsForm.hiddenSearch[rowNo].text;
			  editLongName = document.searchResultsForm.hiddenName2[rowNo].text;
        opener.InsertDEComp(editID, editLongName);
        formObj= eval("document.searchResultsForm."+selRow);
        formObj.checked=false;
        --numRowsSelected;
		}
		document.searchResultsForm.hiddenSelectedRow.length = 0;   //remove all the selected rows from the list.
		document.searchResultsForm.editSelectedBtn.disabled=true;  //disable btn
  }

  //stores the selected row in the hidden array and submits the form to refresh
  function submitOpener(sAction)
  {
    //store the selrow in an array 
    var selRowArray = new Array();        
    var rowNo = document.searchResultsForm.hiddenSelectedRow[0].value;
    selRowArray[0] = rowNo;
    opener.AllocSelRowOptions(selRowArray);  //allocate option for hidden row and select it.
    opener.SubmitValidate(sAction);  //submit the form
  }
  
  //trims off spaces and "_"
  function TrimEnds(editDefinition)
  {
       if (editDefinition.length > 0)
       {
         if (editDefinition.charAt(0) == "_" || editDefinition.charAt(0) == " " )
           editDefinition = editDefinition.slice(1, editDefinition.length);
         if (editDefinition.charAt(editDefinition.length -1) == "_" || editDefinition.charAt(editDefinition.length -1) == " ")
           editDefinition = editDefinition.slice(0, editDefinition.length - 1);
       }
       return editDefinition;
  }

  function RTrim(str)
  {
      if (str==null)
        {return null;}
      else
        return str.substring(2,str.length);
  } 
  
  // for edit/template/version/Question submits the page with action selected as Edit
  function ShowEditSelection()
  { 
     window.status = "Opening the page, it may take a minute, please wait....."
	 document.searchResultsForm.Message.style.visibility="visible";
     document.searchResultsForm.actSelected.value = "Edit";
     document.searchResultsForm.submit();
  }

  // Block edit multiple rows of DE's, DEC's, or VD's
  function BlockEdit()
  {
       getRowAttributes();   //get the values of each row.
       window.status = "Opening the page, it may take a minute, please wait....."
       document.searchResultsForm.Message.style.visibility="visible";
       document.searchResultsForm.actSelected.value = "BlockEdit";
       document.searchResultsForm.numSelected.value = numRowsSelected;
       document.searchResultsForm.submit();
  }
  function UnCheckAllCheckBoxes() 
  {
  	var dCount =0;
  	alert("in function UnCheckAllCheckBoxes");
  	alert("length----->" + document.searchResultsForm.hiddenSelectedRow.length);
  	if(document.searchResultsForm.hiddenSelectedRow != null)
        dCount = document.searchResultsForm.hiddenSelectedRow.length;  	
		for (k=0; k<dCount; k++)
		   {
		   	   var selRow = document.searchResultsForm.hiddenSelectedRow[k].text;	
			   formObj= eval("document.searchResultsForm."+selRow);
        		  formObj.checked=false;
		   }  
  }
  // stored the selected row values for permissible values on SearchForCreate action
  function StoreSelectedRow(addRow, rowNo, editAction)
  {
	   selRow = rowNo;
	   rowNo = rowNo.substring(2, rowNo.length);
     var dCount = 0;
     if(document.searchResultsForm.hiddenSelectedRow != null)
        dCount = document.searchResultsForm.hiddenSelectedRow.length;
//alert("StoreSelectedRow dCount1: " + dCount);
	   if (addRow == "true")
		   searchResultsForm.hiddenSelectedRow.options[dCount] = new Option(selRow,rowNo); //store the row number in the hidden vector
	   //remove the row if not selected anymore
	   else
	   {
		   for (k=0; k<dCount; k++)
		   {
			   if (document.searchResultsForm.hiddenSelectedRow[k].value == rowNo)
			   {
				   searchResultsForm.hiddenSelectedRow.options[k] = null;
				   break;
			   }
		   }
	   }
//alert("StoreSelectedRow dCount2: " + document.searchResultsForm.hiddenSelectedRow.length);
  }

  //gets the other attributes for the checked row from the hidden select boxes
  function getRowAttributes()
  {
  
	   document.searchResultsForm.hiddenACIDStatus.length = 0;
	   document.searchResultsForm.hiddenDesIDName.length = 0;
	   var rowCount = document.searchResultsForm.hiddenSelectedRow.length;
	   for (i=0; i<rowCount; i++)
	   {
		   var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
		   
		   if (document.searchResultsForm.hiddenSearch != null && document.searchResultsForm.hiddenSearch.length > rowNo)
		   {
			   editID = document.searchResultsForm.hiddenSearch[rowNo].value;
		       editName = document.searchResultsForm.hiddenSearch[rowNo].text;
		   }
		   if (document.searchResultsForm.hiddenName != null && document.searchResultsForm.hiddenName.length > rowNo)
		   {
			   editASL = document.searchResultsForm.hiddenName[rowNo].text;
		   }
		   if (document.searchResultsForm.hiddenName2 != null && document.searchResultsForm.hiddenName2.length > rowNo)
		   {
			   editLongName = document.searchResultsForm.hiddenName2[rowNo].text;
		   }
		   if (document.searchResultsForm.hiddenDefSource != null && document.searchResultsForm.hiddenDefSource.length > rowNo)
		   {
			   editDefinition = document.searchResultsForm.hiddenDefSource[rowNo].text;
			   editUsedby = document.searchResultsForm.hiddenDefSource[rowNo].value;
		   }
		   if (document.searchResultsForm.hiddenMeanDescription != null && document.searchResultsForm.hiddenMeanDescription.length > rowNo)
		   {
			   editDescription = document.searchResultsForm.hiddenMeanDescription[rowNo].text;  //text handles double quotes better than value
		   }
		   //for selected component's ID, Name, workflow status for designations.
		   var selComp = document.searchParmsForm.listSearchFor.value;
		   if ((editLongName != null || editLongName != "") && (selComp == "DataElement" || selComp == "DataElementConcept" || selComp == "ValueDomain"))
		   {
			   var dCount = document.searchResultsForm.hiddenDesIDName.length;
			   searchResultsForm.hiddenDesIDName.options[i] = new Option(editUsedby,editLongName); //name must be stored both in text and value to handle special characters
			   searchResultsForm.hiddenACIDStatus.options[i] = new Option(editASL, editID);
			   searchResultsForm.hiddenACIDStatus.options[i].selected = true;
			   searchResultsForm.hiddenDesIDName.options[i].selected = true;
		   } 
		   //for permissible value store in hidden selectbox, multiple name, id, longname, if checked, remove for unchecked.
		   if (document.searchParmsForm.listSearchFor.value == "PermissibleValue" || document.searchParmsForm.listSearchFor.value == "ReferenceValue")
		   {
			   if (document.searchResultsForm.hiddenPVValue != null)
			   {
				   var selCount = document.searchResultsForm.hiddenPVValue.length;
				   var selRow = document.searchResultsForm.hiddenSelectedRow[i].text;
				   searchResultsForm.hiddenPVValue.options[selCount]= new Option(editID,selRow);
				   searchResultsForm.hiddenPVMean.options[selCount]= new Option(editLongName,editName);
				   searchResultsForm.hiddenPVMeanDesc.options[selCount]= new Option(editDescription,editDescription);
			   }
		   }
	   }
  }

  //This function enables/disables the "Show Attributes" and
  //"Show Selected Rows Only" buttons based on checked items in the list.
  //Edit Selection:  enabled when one or more items are checked
  //Show Selected Rows Only:  enabled when one or more items are checked

  function EnableAttributesButton(checked)
  {
	   var attChecked = document.searchResultsForm.AttChecked.value;
	   if (attChecked > 0)
	   {
		   document.searchResultsForm.numAttSelected.value = attChecked;
		   document.searchResultsForm.AttChecked.value = 0;
	   }
	   
	   if (checked)
	   {
		   attributesSelected = document.searchResultsForm.numAttSelected.value;
		   ++attributesSelected;
		   document.searchResultsForm.numAttSelected.value = attributesSelected;
	   }
	   else
	   {
		   attributesSelected = document.searchResultsForm.numAttSelected.value;
		   --attributesSelected;
		   document.searchResultsForm.numAttSelected.value = attributesSelected;
	   }
	   
	   if (attributesSelected > 0)
	   {
		   document.searchResultsForm.actSelected.value = "attChecked";
	   }
  }

  //submit the page when clicked on showSelectedRow only button
  function showAttributes()
  {
      window.status = "Submitting the page, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.actSelected.value="Attribute";
      document.searchResultsForm.submit();
  }

  // submit the page when clicked on clear records.
  function clearRecords()
  {
      window.status = "clearing the records, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.actSelected.value = "clearRecords";
      document.searchResultsForm.submit();
  }

  // submit the page when create new button is clicked for pv searches in searchForCreate.
  function createNewValue()
  {
      window.status = "Opening page to create new Value Meanings, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.actSelected.value = "createNewValue";
      document.searchResultsForm.submit();
  }

  // opens the designate window to get the context and alias, comes back to this page to submit
  function designateRecord()
  {
	   getRowAttributes();   //get the values of each row.
	   
	   var dCount = document.searchResultsForm.hiddenSelectedRow.length;    //document.searchResultsForm.hiddenACIDStatus.length;
	   var isStatusValid = true;
	   var ACNames = "";
	   for (k=0; k<dCount; k++)
	   {
		   var ACStatus = document.searchResultsForm.hiddenACIDStatus[k].text;
		   if (!(ACStatus == "RELEASED" || ACStatus == "APPRVD FOR TRIAL USE" || ACStatus == "CMTE SUBMTD USED" || 
			   ACStatus == "DRAFT MOD" || ACStatus == "CMTE APPROVED" || ACStatus == "RELEASED-NON-CMPLNT"))
		   {
			   ACNames = ACNames + document.searchResultsForm.hiddenDesIDName[k].value + "\n\t"
				   isStatusValid = false;
		   }
	   }
	   if (isStatusValid == true)
	   {
		   if (desWindow && !desWindow.closed)
			   desWindow.close();
		   //open the window.
		   if (dCount > 1)
			   document.searchResultsForm.actSelected.value = "blockDesignate";
		   else
			   document.searchResultsForm.actSelected.value = "createDesignate";		   
		//   desWindow = window.open("jsp/DesignateComponent.jsp", "designateComponent", "width=700,height=610,top=0,left=0,resizable=yes,scrollbars=yes")
//		   desWindow = window.open("jsp/EditDesignateDEPage.jsp", "designateComponent", "width=700,height=610,top=0,left=0,resizable=yes,scrollbars=yes")
       window.status = "Opening page to designate, it may take a minute, please wait....."
       document.searchResultsForm.Message.style.visibility="visible";
			 document.searchResultsForm.actSelected.value = "EditDesignateDE";
       document.searchResultsForm.submit();
	   }
	   else
	   {
		   alert ("You can only designate a component with a Workflow Status of Released, Approved for Trial Use,\n" + 
			   "Committee Submitted Used, Draft Mod, Committee Approved, or Released-non-compliant.\n\n"+ 
			   "Please check the workflow status(es) of :\n" + ACNames);
		   document.searchResultsForm.hiddenACIDStatus.length = 0;
		   document.searchResultsForm.hiddenDesIDName.length = 0;
	   }
  } 

  //make the opener documents isValidsearch to false before closing to accomodate new search 
  function closeWindow()
  {
	   var vSearchAC = document.searchParmsForm.listSearchFor.options[document.searchParmsForm.listSearchFor.selectedIndex].value;
	   if (opener && opener.document != null && opener.document.SearchActionForm != null)
		   opener.document.SearchActionForm.isValidSearch.value = "false";
	   window.close();
	   
  } 
  
  // submit the page to get the associated DEs.
  function getAssocDEs()
  {
	   document.searchResultsForm.unCheckedRowId.value = document.searchResultsForm.selectedRowId.value;
	   var SearchAC = document.searchParmsForm.listSearchFor.value;   //get the search for from dropdown list
	   if (SearchAC != "DataElement")
	   { 
		   getRowAttributes();   //get the values of each row.
		   //display message if row is from EVS
		   if (editID == "EVS")
			   alert("Selected row is either from NCI Thesaurus or NCI MetaThesaurus. Please check only caDSR result to get associated Data Element.");
		   else
		   {
			   window.status = "Opening page to get associated Data Elements, it may take a minute, please wait....."
				   document.searchResultsForm.Message.style.visibility="visible";
			   document.searchResultsForm.actSelected.value = "AssocDEs";
			   document.searchResultsForm.submit();
		   }
	   }
  }
  
  // submit the page to get the associated DECs.
  function getAssocDECs()
  {
	   document.searchResultsForm.unCheckedRowId.value = document.searchResultsForm.selectedRowId.value;
	   var SearchAC = document.searchParmsForm.listSearchFor.value;   //get the search for from dropdown list
	   if (SearchAC == "ConceptualDomain" || SearchAC == "DataElement" || SearchAC == "ObjectClass" 
	   		|| SearchAC == "Property" || SearchAC == "ClassSchemeItems" || SearchAC == "ConceptClass")
	   { 
		   window.status = "Opening page to get associated Data Element Concepts, it may take a minute, please wait....."
			   document.searchResultsForm.Message.style.visibility="visible";
		   document.searchResultsForm.actSelected.value = "AssocDECs";
		   document.searchResultsForm.submit();
	   }
  }

  // submit the page to get the associated VDs.
  function getAssocVDs()
  {
	   document.searchResultsForm.unCheckedRowId.value = document.searchResultsForm.selectedRowId.value;
	   var SearchAC = document.searchParmsForm.listSearchFor.value;   //get the search for from dropdown list
	   if (SearchAC == "ConceptualDomain" || SearchAC == "PermissibleValue" 
	   		|| SearchAC == "DataElement" || SearchAC == "ClassSchemeItems" || SearchAC == "ConceptClass" || SearchAC == "ValueMeaning" ) 
	   { 
		   getRowAttributes();   //get the values of each row.
		   //display message if row is from EVS
		   if (editID == "EVS")
			   alert("Selected row is either from NCI Thesaurus or NCI MetaThesaurus. Please check only caDSR result to get associated Value Domain.");
		   else
		   {
			   window.status = "Opening page to get associated Value Domains, it may take a minute, please wait....."
				   document.searchResultsForm.Message.style.visibility="visible";
			   document.searchResultsForm.actSelected.value = "AssocVDs";
			   document.searchResultsForm.submit();
		   }
	   }
  }

  //using the id of the checked row and with the host name open the browser window.
  function GetDetailsJS(serverName)
  {
	   editID = document.searchResultsForm.hiddenSearch[document.searchResultsForm.selectedRowId.value].value;
	   if (serverName != null && serverName != "")
	   {
		  	   
		   if (detailWindow && !detailWindow.closed)
			   detailWindow.close();
		   
		   //open browser in dev server if localhost or protocol, use the server from the hgeost name
//		   serverName = serverName.toLowerCase();
       var cdeServer = serverName;   //defaults to curation tool server
/*       if (serverName == "localhost")
          cdeServer = "cdebrowser-qa.nci.nih.gov";
       else if (serverName == "protocol.scenpro.net")
          cdeServer = "cdebrowser-dev.nci.nih.gov";
		   else if (serverName == "ncicb-dev.nci.nih.gov" || serverName == "cdecurate-dev.nci.nih.gov")
          cdeServer = "cdebrowser-dev.nci.nih.gov";
       else if (serverName == "ncicb-qa.nci.nih.gov" || serverName == "cdecurate-qa.nci.nih.gov")
          cdeServer = "cdebrowser-qa.nci.nih.gov";
       else if (serverName == "ncicb-stage.nci.nih.gov" || serverName == "cdecurate-stage.nci.nih.gov")
          cdeServer = "cdebrowser-stage.nci.nih.gov";
       else if (serverName == "ncicb.nci.nih.gov" || serverName == "cdecurate.nci.nih.gov")
          cdeServer = "cdebrowser.nci.nih.gov";*/
          
		   //open cde browser	
			 detailWindow = window.open(cdeServer + "search?dataElementDetails=9&p_de_idseq=" + editID + "&PageId=DataElementsGroup&queryDE=yes&FirstTimer=0", "detailComponent", "width=850,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
	   }
	   else
		   alert("Unable to determine the server name of the browser.");	
  }

  //sets the append attributes and submits form to refresh
  function setAppendAction()
  {
	   document.searchResultsForm.AppendAction.value = "Appended";
	   window.status = "Submitting the page, it may take a minute, please wait....."
		 document.searchResultsForm.Message.style.visibility="visible";
	   document.searchResultsForm.actSelected.value = "Rows";
	   document.searchResultsForm.numSelected.value = numRowsSelected;
	   document.searchResultsForm.submit();
  }

  //submits the form to create new vm from pv page
  function createNewVM()
  {
    if (opener.document != null && opener.document.createPVForm != null)
    {
      opener.document.createPVForm.pageAction.value  = "createNewVM";
 	    opener.document.createPVForm.submit();
      //close window
      window.close();
    }
  }
  
  //DE derivation relationship details
  function openDerRelationDetail(deName, deID, derType)
  {
      document.SearchActionForm.acID.value = deID;
      document.SearchActionForm.searchComp.value = deName;  //de Name for DDE
      document.SearchActionForm.itemType.value = derType;  //de Name for DDE
      document.SearchActionForm.isValidSearch.value = "false";
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      var windowW = screen.width - 760;
      detailWindow = window.open("jsp/DerivedDEWindow.jsp", "DerivedDE", "width=750,height=620,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
  }

  // Remove selected items from the user's reserved CSI and remove the Alert to
  // monitor activity on the CSI.
  function unmonitorCmd()
  {
      window.status = "Submitting list to the Sentinel Tool, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchResultsForm.actSelected.value = "UnMonitor";
      document.searchResultsForm.numSelected.value = numRowsSelected;
      document.searchResultsForm.submit();
  }  
function uploadCmd()
  {
  	  getRowAttributes();   //get the values of each row.
	   
	  var isStatusValid = true;
	  
	   
	   //Conditions... 
	   /*
	   var SearchAC = document.searchParmsForm.listSearchFor.value;   //get the search for from dropdown list
	   
	   if (SearchAC = "DataElement")
	   {
	    	//TODO: Add code to set a AC type attribute.
	   }
		*/
	   
	   if (isStatusValid == true)
	   {
			window.status = "Opening page to Reference Document Attachments, it may take a minute, please wait....."
	       	document.searchResultsForm.Message.style.visibility="visible";
			document.searchResultsForm.actSelected.value = "RefDocumentUpload";
	        document.searchResultsForm.submit();
	   }
	   else
	   {
		   alert ("Message...");
		   document.searchResultsForm.hiddenACIDStatus.length = 0;
		   document.searchResultsForm.hiddenDesIDName.length = 0;
	   }
	   
	   
  }  
   function openEditVMWindow(curPV)
    {
    	document.getElementById("editPVInd").value = curPV;
    	document.searchResultsForm.actSelected.value = "pvEdits";
    	document.getElementById("pageAction").value = "openEditVM";
    	StoreSelectedRow("true",curPV,"ValueMeaning");
    	document.searchResultsForm.submit();
    }
    
    function count(checked)
    {
    if (checked)
		   ++count;
	   else
		   --count;
	document.searchResultsForm.menuDefs.objMenu.selCnt.value = count;
		   
   }
  // This function will display the alert message to the user if he/she is not logged in 
  // or will call the appropriate function if he/she is already logged in
   function  performActionJS(user, type){
    if (user == "null"){
       alert("Please Login to use this feature.");
    }else{
        if (type == "uploadDoc"){
          uploadCmd();
        }
        if (type == "monitor"){
          monitorCmd();
        }
        if (type == "unmonitor"){
           unmonitorCmd();
        }
        if (type == "designate"){
           designateRecord();
        }
        if (type == "append"){
           setAppendAction();
        }
        if (type == "edit"){
           ShowEditSelection();
        }
        if (type == "blockEdit"){
           BlockEdit();
        }
     }    
  
  }
// This function will display the alert message to the user if he/she is not logged in 
// or will call the appropriate function if he/she is already logged in
function createNewJS(user, selAC, type){
    if (user == "null"){
       alert("Please Login to use this feature.");
    }else{
        createNewAC(selAC,type);
    }    
}
   
//submits the page to display 'Create New Using Existing' window or 'Creat New Version' window
function createNewAC(selAC, type){
         
         window.status = "Opening the page, it may take a minute, please wait....."
		 document.searchResultsForm.Message.style.visibility="visible";
         document.searchResultsForm.actSelected.value = "Edit";
         document.searchResultsForm.numSelected.value = numRowsSelected;
         if (type == "newUsingExisting"){
             document.searchResultsForm.hidaction.value = "newUsingExisting";
             if (selAC == "Data Element"){
               document.searchResultsForm.hidMenuAction.value = "NewDETemplate";
             }
             if (selAC == "Data Element Concept"){
               document.searchResultsForm.hidMenuAction.value = "NewDECTemplate";
             }
             if (selAC ==  "Value Domain"){
               document.searchResultsForm.hidMenuAction.value = "NewVDTemplate";
             }
         }else if (type == "newVersion"){
             document.searchResultsForm.hidaction.value = "newVersion";
             if (selAC == "Data Element"){
               document.searchResultsForm.hidMenuAction.value = "NewDEVersion";
             }
             if (selAC == "Data Element Concept"){
               document.searchResultsForm.hidMenuAction.value = "NewDECVersion";
             }
             if (selAC ==  "Value Domain"){
               document.searchResultsForm.hidMenuAction.value = "NewVDVersion";
             }
         }
        document.searchResultsForm.submit();
  }
  // stored the selected row values for permissible values on SearchForCreate action
  function StoreRow(addRow, rowNo){
	   selRow = rowNo;
	   rowNo = rowNo.substring(2, rowNo.length);
     var dCount = 0;
     if(document.searchResultsForm.hiddenSelectedRow != null)
        dCount = document.searchResultsForm.hiddenSelectedRow.length;
     if (addRow == "true")
		   searchResultsForm.hiddenSelectedRow.options[dCount] = new Option(selRow,rowNo); //store the row number in the hidden vector
	   //remove the row if not selected anymore
	   else
	   {
		   for (k=0; k<dCount; k++)
		   {
			   if (document.searchResultsForm.hiddenSelectedRow[k].value == rowNo)
			   {
				   searchResultsForm.hiddenSelectedRow.options[k] = null;
				   break;
			   }
		   }
	   }
   } 
  
 //This function calculates the number of checkboxes checked
function checkClickJS(cb,selAC,rowsChecked)  {
                if (rowsChecked > 0){
                   checkCnt = rowsChecked;
                }
                if (cb.checked == true) {
                    ++checkCnt;
                }  else   {
                    --checkCnt;
                }
                var msg = document.getElementById("selCnt");
                msg.innerText = checkCnt;
                msg.textContent = checkCnt;
                //if called directly from the checkbox click takes the name value, otherwise it is a string value
	            if (cb.name == null)
		            var rowNo = cb;
	            else
		            var rowNo = cb.name;
		         if (cb.checked == true){
					StoreRow("true", rowNo);
			     }else{
			        StoreRow("false", rowNo);
			     } 
			     //enableDisableMenuItemsJS(selAC, checkCnt);
   
}
  //This function enables or disables the menu items depending on the num of items checked          
function enableDisableMenuItemsJS(sSelAC, checkCount){
           
           if (checkCount > 1)  {
                
                   //document.searchResultsForm.numOfRowsSelected.value = ">1";
                   if ( (sSelAC == "Data Element")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Domain") ){
                      var doc = document.getElementById("uploadDoc");
                      var newUE = document.getElementById("newUE");
                      var newVersion = document.getElementById("newVersion");
                      disable(doc);
                      disable(newUE); 
                      disable(newVersion); 
                   }
                   if ( (sSelAC == "Value Domain")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Meaning")||(sSelAC == "Values/Meanings")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass") ){
                      var aDe = document.getElementById("associatedDE");
                      var menuADe = document.getElementById("menuAssociatedDE");
                      disable(aDe);
                      disable(menuADe); 
                   }
                  if ( (sSelAC == "Data Element")||(sSelAC == "ObjectClass")||(sSelAC == "Property")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass")){
                      var aDec = document.getElementById("associatedDEC");
                      var menuADec = document.getElementById("menuAssociatedDEC");
                      disable(aDec);
                      disable(menuADec);
                   }
                   if( (sSelAC == "Data Element") || (sSelAC == "ObjectClass")||(sSelAC == "Property")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass")){
                       var aVd = document.getElementById("associatedVD"); 
                       var menuAVd = document.getElementById("menuAssociatedVD");
                       disable(aVd);
                       disable(menuAVd);
                   }
                   if (sSelAC == "Data Element"){
                       var details = document.getElementById("details");
                       var sMenudetails = document.getElementById("searchMenuDetails");
                       disable(details);
                       disable(sMenudetails);
                   }
                    if ((sSelAC == "Data Element")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Domain")||(sSelAC == "Value Meaning")){
                       var view = document.getElementById("view");
                       disable(view);
                   }
                 }else{
                  //document.searchResultsForm.numOfRowsSelected.value = "1";
                 if ( (sSelAC == "Data Element")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Domain") ){
                      var doc = document.getElementById("uploadDoc");
                      var newUE = document.getElementById("newUE");
                      var newVersion = document.getElementById("newVersion");
                      enableUploadDoc(doc);
                      enableNewUsingExisting(newUE);
                      enableNewVersion(newVersion);
                   }
                  if ( (sSelAC == "Value Domain")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Meaning")||(sSelAC == "Values/Meanings")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass") ){
                      var aDe = document.getElementById("associatedDE");
                      var menuADe = document.getElementById("menuAssociatedDE");
                      enableGetAssDE(aDe);
                      enableGetAssDE(menuADe);
                    }
                   if ( (sSelAC == "Data Element")||(sSelAC == "ObjectClass")||(sSelAC == "Property")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass")){
                      var aDec = document.getElementById("associatedDEC");
                      var menuADec = document.getElementById("menuAssociatedDEC");
                      enableGetAssDEC(aDec);
                      enableGetAssDEC(menuADec);
                   }
                   if( (sSelAC == "Data Element") || (sSelAC == "ObjectClass")||(sSelAC == "Property")
                         ||(sSelAC == "Class Scheme Items")||(sSelAC == "Conceptual Domain")||(sSelAC == "ConceptClass")){
                       var aVd = document.getElementById("associatedVD");
                       var menuAVd = document.getElementById("menuAssociatedVD"); 
                       enableGetAssVD(aVd);
                       enableGetAssVD(menuAVd);
                   }
                   if (sSelAC == "Data Element"){
                       var details = document.getElementById("details");
                       var sMenudetails = document.getElementById("searchMenuDetails");
                       enableViewDetails(details);
                       enableViewDetails(sMenudetails);
                   }
                   if ((sSelAC == "Data Element")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Domain")||(sSelAC == "Value Meaning")){
                       var view = document.getElementById("view");
                       enableView(view);
                   }
                 }
                 if( (checkCount == 1) || (checkCount == 0)){
                   if ( (sSelAC == "Data Element")||(sSelAC == "Data Element Concept")||(sSelAC == "Value Domain") ){
                       var blockEdit = document.getElementById("blockEdit");
                       var sMenublockEdit = document.getElementById("searchMenuBlockEdit");
                       var eMenublockEdit = document.getElementById("editMenuBlockEdit");
                       enableBlockEdit(blockEdit);
                       enableBlockEdit(sMenublockEdit);
                       enableBlockEdit(eMenublockEdit);
                    } 
                }
                
         
}      
 //This function disables the menu item
 function disable(element){
   element.style.color = menuDisabledColor;
   element.onclick = "";
 }
 //This function enables the menu item 'Block Edit'
 function enableBlockEdit(element){
   element.style.color = menuTextColor;
   element.onclick = function () {performAction('blockEdit')};
  }
  //This function enables the menu item 'View'
 function enableView(element){
   element.style.color = menuTextColor;
   element.onclick = function () {};
  }
 //This function enables the menu item 'View Details'
 function enableViewDetails(element){
   element.style.color = menuTextColor;
   element.onclick = function () {GetDetails()};
  }
  //This function enables the menu item 'Get Associated DE'
  function enableGetAssDE(element){
   element.style.color = menuTextColor;
   element.onclick = function () {getAssocDEs()};
  }
  //This function enables the menu item 'Get Associated DEC'
  function enableGetAssDEC(element){
   element.style.color = menuTextColor;
   element.onclick = function () {getAssocDECs()};
  }
  //This function enables the menu item 'Get Associated VD'
  function enableGetAssVD(element){
   element.style.color = menuTextColor;
   element.onclick = function () {getAssocVDs()};
  }
  //This function enables the menu item 'Upload Document'
  function enableUploadDoc(element){
   element.style.color = menuTextColor;
   element.onclick = function () {performAction('uploadDoc')};
  }
  //This function enables the menu item 'New Using Existing'
  function enableNewUsingExisting(element){
   element.style.color = menuTextColor;
   element.onclick = function () {createNew('newUsingExisting')};
  }
  //This function enables the menu item 'New Version'
  function enableNewVersion(element){
   element.style.color = menuTextColor;
   element.onclick = function () {createNew('newVersion')};
  }
   
		  
			
     
      
           
   
 
   
  