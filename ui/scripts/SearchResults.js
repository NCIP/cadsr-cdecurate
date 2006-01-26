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
      var windowW = screen.width - 710;
      detailWindow = window.open("jsp/PermissibleValueWindow.jsp", "PermissibleValue", "width=700,height=300,top=0,left=" + windowW + ",resizable=yes,scrollbars=yes");
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
      else if (sComp == "PermissibleValue" && opener.document.createVDForm != null)
          PVShowUseSelection();	
      
      //use the selected VM in create pv form
      else if (sComp == "ValueMeaning" && opener.document.createPVForm != null)  //search for value meaning
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
    submitOpener();   //calls the function submit hte opener form.
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
    submitOpener();   //calls the function submit hte opener form.
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
    if (opener.document.createPVForm != null)
    {
      opener.document.createPVForm.selShortMeanings.value = editLongName;
      opener.document.createPVForm.CreateDescription.value = editDescription;
      opener.document.createPVForm.newCDEPageAction.value = "appendSearchVM";
      opener.document.createPVForm.submit();
    }
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
  function submitOpener()
  {
    //store the selrow in an array 
    var selRowArray = new Array();        
    var rowNo = document.searchResultsForm.hiddenSelectedRow[0].value;
    selRowArray[0] = rowNo;
    opener.AllocSelRowOptions(selRowArray);  //allocate option for hidden row and select it.
    opener.SubmitValidate("updateNames");  //submit the form
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
	   getRowAttributes();   //get the values of each row.
	   var bOkOpen = true;
	   var selSearchAC = document.searchParmsForm.listSearchFor.options[document.searchParmsForm.listSearchFor.selectedIndex].value;
	   if (selSearchAC == "Questions")
	   {
		   if (editID != null && editID == "Edit")
           bOkOpen = confirm("You are about to edit a Data Element for which all attributes are complete.  \n" + 
           "Do you wish to proceed?")
			 else if (editID != null && editID == "Template")
           bOkOpen = confirm("The Value Domain selected for this question is different from the Value Domain associated with the selected Data Element. " + 
           "You must confirm and validate the attributes for this Data Element and submit the DE to the database.")
	   }
	   if (bOkOpen == true && document.searchResultsForm.editSelectedBtn.value != "Block Edit")
	   {
         window.status = "Opening the page, it may take a minute, please wait....."
			   document.searchResultsForm.Message.style.visibility="visible";
         document.searchResultsForm.actSelected.value = "Edit";
         document.searchResultsForm.numSelected.value = numRowsSelected;
         document.searchResultsForm.submit();
	   }
	   else if (document.searchResultsForm.editSelectedBtn.value=="Block Edit")
	   { 
  		   window.status = "Opening the page, it may take a minute, please wait....."
			   document.searchResultsForm.Message.style.visibility="visible";
         document.searchResultsForm.actSelected.value = "BlockEdit";
         document.searchResultsForm.numSelected.value = numRowsSelected;
         document.searchResultsForm.submit();
	   }
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

  /* This function enables/disables the "Edit Selection" and
  "Show Selected Rows Only" buttons based on checked items in the list.
  Edit Selection:  enabled when one checked and disabled otherwise, except 
  when the component is permissible value for searchforCreate
  Show Selected Rows Only:  enabled when one or more items are checked 
  designate record : enabled when not search for create and only one item checked.
  details: enabled when one DE or DEC or VD is checked
  */

  function EnableCheckButtons(checked, currentField, editAction, sButtonPressed, sSelAC)
  {
	   if (checked)
		   ++numRowsSelected;
	   else
		   --numRowsSelected;
	   
	   //if called directly from the checkbox click takes the name value, otherwise it is a string value
	   if (currentField.name == null)
		   var rowNo = currentField;
	   else
		   var rowNo = currentField.name;
	   
	   if (numRowsSelected > 0)
	   {
		   //enable the append button
		   if (document.searchResultsForm.AppendBtn != null)
			   document.searchResultsForm.AppendBtn.disabled=false;
               
           if (document.searchResultsForm.monitorBtn != null)
               document.searchResultsForm.monitorBtn.disabled = false;
                      
           if (document.searchResultsForm.unmonitorBtn != null)
               document.searchResultsForm.unmonitorBtn.disabled = false;
           
		   if (document.searchResultsForm.uploadBtn != null)
           	   document.searchResultsForm.uploadBtn.disabled = false;
            
		   if (numRowsSelected == 1)
		   {
			   if (editAction == "searchForCreate")
			   {
				   if (document.searchResultsForm.editSelectedBtn != null)
					   document.searchResultsForm.editSelectedBtn.disabled=false;
               }
			   else
			   {
				   if (document.searchResultsForm.showSelectedBtn != null)
					   document.searchResultsForm.showSelectedBtn.disabled=false;
               			
				   if (editAction != "nothing" || sButtonPressed == "Search")
				   {
					   if (document.searchResultsForm.editSelectedBtn != null  && 
						   editAction != "Complete Selected DE" && editAction != "Create New Version" && editAction != "Create New from Existing")
					   {
						   document.searchResultsForm.editSelectedBtn.disabled=false;
						   document.searchResultsForm.editSelectedBtn.value="Edit Selection";
					   }
					   if (document.searchResultsForm.editSelectedBtn != null  && 
						   editAction == "Complete Selected DE" || editAction == "Create New Version" || editAction == "Create New from Existing")
					   {
						   document.searchResultsForm.editSelectedBtn.disabled=false;
					   }
				   }
				   else if (editAction == "nothing" && sSelAC == "Data Element" || sSelAC == "Data Element Concept" || sSelAC == "Value Domain")
				   {
					   document.searchResultsForm.editSelectedBtn.disabled=false;
				   }
				   if (editAction == "nothing" && sSelAC == "Data Element" || sSelAC == "Data Element Concept" || sSelAC == "Value Domain" || sSelAC == "Conceptual Domain")
				   {
					   document.searchResultsForm.associateACBtn.value="Get Associated";
					   document.searchResultsForm.associateACBtn.disabled=false;
				   }
			   }
			   //both seachforcreate and regular the searches
			   if (checked)
				   StoreSelectedRow("true", rowNo, editAction);
			   else
				   StoreSelectedRow("false", rowNo, editAction);
			   
			   //disable the details button if not data element   
			   if (document.searchResultsForm.detailsBtn != null)
			   {
				   if (document.searchParmsForm.listSearchFor.value == "DataElement")
					   document.searchResultsForm.detailsBtn.disabled=false;
				   else
					   document.searchResultsForm.detailsBtn.disabled=true;
			   }
			   
			   //enable designate button and change the label to undesignate if already designated
			   if (document.searchParmsForm.listSearchFor.value != "PermissibleValue")
			   {
				   if (document.searchResultsForm.designateBtn != null)
					   document.searchResultsForm.designateBtn.disabled=false;
			   }
			   
			   //enable associate button if not questions
			   if (document.searchParmsForm.listSearchFor.value != "Questions")
			   {
				   if (document.searchResultsForm.associateACBtn != null)
					   document.searchResultsForm.associateACBtn.disabled=false;
			   }
		   }
		   else    // numRowsSelected > 1
		   {
			   if (document.searchResultsForm.associateACBtn != null)
			   {
				   document.searchResultsForm.associateACBtn.disabled=true;
			   }
			   if (document.searchResultsForm.detailsBtn != null)
				   document.searchResultsForm.detailsBtn.disabled=true;

		   		if (document.searchResultsForm.uploadBtn != null)
           			document.searchResultsForm.uploadBtn.disabled = true;
               
			   if (editAction != "searchForCreate")
			   {
				   document.searchResultsForm.showSelectedBtn.disabled=false;
				   if (checked)
					   StoreSelectedRow("true", rowNo, editAction);
				   else
					   StoreSelectedRow("false", rowNo, editAction);
				   
				   if (editAction != "nothing" || sButtonPressed == "Search" || sButtonPressed == "Edit")
				   {
					   if (document.searchResultsForm.editSelectedBtn != null)
					   {
						   //enable the edit button if action is regular search or edit otherwise disable
						   if (editAction != "Complete Selected DE" && editAction != "Create New Version" && editAction != "Create New from Existing")
						   {
							   document.searchResultsForm.editSelectedBtn.value="Block Edit";
							   document.searchResultsForm.editSelectedBtn.disabled=false;
						   }
						   else
							   document.searchResultsForm.editSelectedBtn.disabled=true;
					   }
				   }
			   }
			   else   // editAction == "searchForCreate"
			   {
				   if (document.searchParmsForm.listSearchFor.value == "PermissibleValue")
				   {
					   //search from create/edit pages
					   if (opener.document.createVDForm != null)
					   {
						   var vOrigin = opener.document.createVDForm.MenuAction.value;
						   //searching pv for questions
						   if (vOrigin == "Questions")
						   {
							   formObj= eval("document.searchResultsForm."+currentField.name);
							   formObj.checked=false;
							   --numRowsSelected;
							   alert("Please select only one value at a time");
						   }
						   else    // vOrigin != "Questions"
						   {
							   if (checked)
								   StoreSelectedRow("true", rowNo, editAction);
							   else
								   StoreSelectedRow("false", rowNo, editAction);
						   }
					   }
					   //search from the regular search pages
					   else
					   {
						   if (checked)
							   StoreSelectedRow("true", rowNo, editAction);
						   else
							   StoreSelectedRow("false", rowNo, editAction);
					   }
				   }
				   else if ( sSelAC == "Data Element")  // from CreateDE for DDE
				   {
							   if (checked)
								   StoreSelectedRow("true", rowNo, editAction);
							   else
								   StoreSelectedRow("false", rowNo, editAction);
				   }
				   else  // editAction == "searchForCreate", document.searchParmsForm.listSearchFor.value != "PermissibleValue"
				   {
				   /* formObj= eval("document.searchResultsForm."+currentField.name);
                   formObj.checked=false;
                   --numRowsSelected;
					   alert("Please check only one box at a time");*/
					   //allow to check more than one but disable the button if more selected
					   if (document.searchResultsForm.editSelectedBtn != null)
						   document.searchResultsForm.editSelectedBtn.disabled=true;
					   if (checked)
						   StoreSelectedRow("true", rowNo, editAction);
					   else
						   StoreSelectedRow("false", rowNo, editAction);
				   }
			   }
			   if (document.searchResultsForm.designateBtn != null)
				   document.searchResultsForm.designateBtn.disabled=false;
		   }
      }
      else  // numRowsSelected == 0
      {
          if (document.searchResultsForm.monitorBtn != null)
              document.searchResultsForm.monitorBtn.disabled = true;
              
          if (document.searchResultsForm.unmonitorBtn != null)
              document.searchResultsForm.unmonitorBtn.disabled = true;  
              
         if (document.searchResultsForm.uploadBtn != null)
               document.searchResultsForm.uploadBtn.disabled = true;            
           
		  if (document.searchResultsForm.associateACBtn != null)
			  document.searchResultsForm.associateACBtn.disabled=true;
		  
		  // disable the Details button if no row is selected
		  if (document.searchResultsForm.detailsBtn != null)
			  document.searchResultsForm.detailsBtn.disabled=true;
		  
		  //keep the show selection button disabled if no row is checked
          if (editAction != "searchForCreate")
			  if (document.searchResultsForm.showSelectedBtn != null)
				  document.searchResultsForm.showSelectedBtn.disabled=true;
			  
			  //disable edit button (use selection/edit/template/version)
			  if (document.searchResultsForm.editSelectedBtn != null)
				  document.searchResultsForm.editSelectedBtn.disabled=true;
			  
			  if (!checked)
				  StoreSelectedRow("false", rowNo, editAction);
			  
			  //disable designate button
			  if (document.searchResultsForm.designateBtn != null)
				  document.searchResultsForm.designateBtn.disabled=true;
			  
			  //disable the append button
			  if (document.searchResultsForm.AppendBtn != null)
				  document.searchResultsForm.AppendBtn.disabled=true;
	  }
  }  // end of EnableCheckButtons
   
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
	   var SearchAC = document.searchParmsForm.listSearchFor.value;   //get the search for from dropdown list
	   if (SearchAC == "ConceptualDomain" || SearchAC == "PermissibleValue" 
	   		|| SearchAC == "DataElement" || SearchAC == "ClassSchemeItems" || SearchAC == "ConceptClass" ) 
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
	   if (serverName != null && serverName != "")
	   {
		   getRowAttributes();   //get the values of each row.
		   
		   if (detailWindow && !detailWindow.closed)
			   detailWindow.close();
		   
		   //open browser in dev server if localhost or protocol, use the server from the host name
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
			 detailWindow = window.open(cdeServer + "/CDEBrowser/search?dataElementDetails=9&p_de_idseq=" + editID + "&PageId=DataElementsGroup&queryDE=yes&FirstTimer=0", "detailComponent", "width=850,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
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
      opener.document.createPVForm.newCDEPageAction.value  = "createNewVM";
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
  