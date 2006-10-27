   var numRowsSelected = 0;
   var attributesSelected = 0;
   var editID = "";
   var editName = "";
   var editNameLong = "";
  // var editLongName = "";
  // var editNameType = "";
   var editDefinition = "";
   var editDefSource = "";
   var editLevel = "";
   var editStatus = "";
   var sComp = "";
   var selRow = "";
   var noMessage = "";
   var desWindow = "";
   var sOCCCodeDB = "";
   var sOCCCode = "";
   var sPCCCodeDB = "";
   var sPCCCode = "";
   var sSelectedParent = "";
   var detailWindow = null;
  
  
   //  checks the status message everytime page opens and alerts the  message
   function displayStatus(vStatusMessage, vSubmitAction)
   {
        if (vStatusMessage == "" || (vStatusMessage == "no message") || (vStatusMessage == "nothing") || (vStatusMessage == "no Message"))
            return;
        else if (vStatusMessage == "no write permission")
        {
          alert("User does not have authorization to Create/Edit for the selected context");
        }
        else 
        {
          alert(vStatusMessage);
        }
   }

   function SetSortType(sortBy)
   {
      var isSubmitOk = true;
      if (document.searchResultsForm.hiddenResults != null)
      {
        var dCount = document.searchResultsForm.hiddenResults.length;
        if (dCount == null || dCount == 0 || dCount < 0)
        {
          isSubmitOk = false;
          alert("Search results must be present before sorting the column"); 
          //alert("Please make sure that initial search has been done before sorting the column"); 
        }
      }
      if (isSubmitOk == true)
      {
        window.status = "Submitting the page, it may take a minute, please wait....."
        document.searchResultsForm.Message.style.visibility="visible";
        document.searchResultsForm.blockSortType.value = sortBy;
        document.searchResultsForm.submit();
      }
   }
   
   //opens the details for using decs
   function openDECDetail(selRowID)
   {
  //alert("link " + selRowID);
      document.searchResultsForm.selRowID.value = selRowID;
      if (detailWindow && !detailWindow.closed)
          detailWindow.close();
      detailWindow = window.open("jsp/DECDetailWindow.jsp", "DECDetails", "width=750,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
   }
   
   function showConceptInTree(sCKName)
   {
      StoreSelectedRow("true", sCKName);
      document.searchResultsForm.OCCCodeDB.value = sCCodeDB;
      if (sCCodeDB != dsrName)  //"caDSR" && sCCodeDB != "NCI Metathesaurus")
      {
        window.status = "Submitting the page, it may take a minute, please wait....."
        document.searchResultsForm.Message.style.visibility="visible";
        sComp = opener.document.SearchActionForm.searchComp.value;
        document.searchResultsForm.actSelected.value = "showConceptInTree"; 
        document.searchResultsForm.openToTree.value = "true";
        document.searchResultsForm.searchComp.value = sComp;
        document.searchResultsForm.OCCCode.value = sCCode;
        document.searchResultsForm.OCCCodeName.value = editNameLong;
        document.searchResultsForm.submit();
      }
      else
        alert("This database cannot be shown in a tree.");
   }
   
  function useSelectionBuildBlocks()
  {
    var useStatus = checkValidStatus(editStatus);
    if (useStatus != "valid") 
      return;
    //store the nvp value to capture
    var nvpRow = document.getElementById("nvp_"+selRow);
    var nvpVal = opener.document.getElementById("nvpConcept");
  	if (nvpRow != null && nvpVal != null)
  	 	nvpVal.value = nvpRow.value;
  	 	
    //continue with the submission
    if(opener.document.newDECForm != null)
    {
      var source = opener.document.newDECForm.DECAction.value;
      opener.document.newDECForm.sCompBlocks.value = sComp;
      opener.document.newDECForm.selCompBlockRow.value = selRow;
      opener.SubmitValidate("UseSelection");
      window.close();
    }
    else if(opener.document.createVDForm != null)
    {
      opener.document.createVDForm.sCompBlocks.value = sComp;
      opener.document.createVDForm.selRepRow.value = selRow;
      opener.SubmitValidate("UseSelection");
      window.close();
    }
  }
  //stores the selected row in the hidden array and submits the form to refresh
  function submitOpener()
  {
    //first check the concept status and return if not valid
    var useStatus = checkValidStatus(editStatus);
    if (useStatus != "valid") 
      return;
    //store the selrow in an array 
    var selRowArray = new Array();        
    var rowNo = document.searchResultsForm.hiddenSelectedRow[0].value;
    selRowArray[0] = rowNo;
    opener.AllocSelRowOptions(selRowArray);  //allocate option for hidden row and select it.
    opener.SubmitValidate("UseSelection");  //submit the form
  }
      
 function ShowUseSelection(vCompAction)
 {
    if(vCompAction == "BEDisplay") vCompAction = "searchForCreate";
    var LongName = "";
    var PrefName  = "";
    if (vCompAction == "searchForCreate")
    { 
      var blName = editName + "\n &nbsp;&nbsp;" + sCCodeDB + "\n &nbsp;&nbsp;" + sCCode;
      //building blocks from DEC page
      if (opener.document.newDECForm != null && 
          (sComp == "ObjectClass" || sComp == "PropertyClass" || sComp == "Property" || 
           sComp == "ObjectQualifier" || sComp == "PropertyQualifier"))
        useSelectionBuildBlocks();
      //rep term components from VD page
      else if (opener.document.createVDForm != null && (sComp == "RepTerm" || sComp == "RepQualifier"))
       useSelectionBuildBlocks();
      //other attributes oc and prop from vd page
      else if (opener.document.createVDForm != null && (sComp == "VDObjectClass" || sComp == "VDPropertyClass"))
      {
        //call the function to submit the form
        opener.document.createVDForm.sCompBlocks.value = sComp;
        submitOpener();
        window.close();
      }
      //parent concept from vd page
      else if (sComp == "ParentConcept")  // && opener.document.createVDForm != null)
        useSelectionParentConcept();
      //opened from create or edit VD form.
      else if (sComp == "EVSValueMeaning" || sComp == "ParentConceptVM"  || sComp == "VMConcept")  // && opener.document.createVDForm != null)
        useSelectionSelectVM();
      //opened from create vm page
   //   else if (sComp == "CreateVM_EVSValueMeaning")
   //     useSelectionCreateVM();          
    } 
  }

  //allow only if released or active or none
  function checkValidStatus(cStatus)
  {
    var sStatus = "valid";
   // alert("checkvalid status ");
    //check the status of multiple selection
    if (cStatus != null && cStatus == "multiple")
    {
      var dCount = document.searchResultsForm.hiddenSelectedRow.length;
      for (i=0; i<dCount; i++)
      {        
        var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value; //get the row number
        cStatus = conArray[rowNo].conStatus;
        if (cStatus != null && cStatus != "" && cStatus != "RELEASED" && cStatus != "Active")
        {
          sStatus = "invalid"; 
          break;
        }
      }
    }
    //check the statu for single selection
    else if (cStatus != null && cStatus != "" && cStatus != "RELEASED" && cStatus != "Active")      
      sStatus = "invalid";
    //put the alert message if not valid
    if (sStatus != "valid")
      alert("Concept must be Released or Active to use it in an Administered Component");
    //return the staus  
    return sStatus;
  }

  function useSelectionParentConcept()
  {     
 // alert("use parent concept"); 
    if (opener.document != null)
    {
      //first check the concept status and return if not valid
      var useStatus = checkValidStatus(editStatus);
      if (useStatus != "valid") 
        return;
      //do not allow to use the meta term if enum parent
      var vdtype = opener.document.getElementById("listVDType").value;   //createVDForm.listVDType[opener.document.createVDForm.listVDType.selectedIndex].value;
      if (vdtype == "E" && (sCCodeDB == null || sCCodeDB == "" || sCCodeDB == metaName))  // "NCI Metathesaurus"))
      {
        alert("Concepts from the " + metaName + " may not be used to reference an Enumerated Value Domain.\n" + 
              "Please select a Concept from another EVS Vocabulary.");
        return;
      }
      else
      {          
        //submit vd form for parent selection
        if (opener.document.getElementById("hiddenParentName") != null)
        {
          opener.document.getElementById("hiddenParentName").value = editNameLong;
          opener.document.getElementById("hiddenParentCode").value = sCCode;
          opener.document.getElementById("hiddenParentDB").value = sCCodeDB;
          //store the selrow in an array 
          var selRowArray = new Array();
          var rowNo = document.searchResultsForm.hiddenSelectedRow[0].value;
          selRowArray[0] = rowNo;
          opener.AllocSelRowOptions(selRowArray);  //allocate option for hidden row and select it.
          opener.SubmitValidate("selectParent");
          window.close();
        }
      }
    }
  }
  
  function useSelectionSelectVM()
  {
//  alert("vm use selection");
      //first check the concept status and return if not valid
      var useStatus = checkValidStatus("multiple");
      if (useStatus != "valid") 
        return;
      var sConfirm = false;
      var selRowArray2 = new Array();
      var selRowArray3 = new Array();
      var multiNames = checkDuplicateConcept();
      if (multiNames != null && multiNames != "")
      {
        sConfirm = confirm("Duplicate Concept Names are selected either because they have " 
              + "multiple definitions \nor they are contained in multiple hierachical " 
              + "locations within their source vocabulary.\n\n" 
              + "Click OK: Default definition - NCI source will be selected. \n"
              + "If no NCI definition is present, the first definition associated with the Concept will be used. \n\n"
              + "Click CANCEL to go back and manually de-select the unwanted duplicates.\n\n" 
              + "Duplicate Concepts : \n\t" + multiNames);
  
        if (sConfirm == true)
        {
          selRowArray2 = getRowNumbersOfUniqueConcepts();
          for (var y=0; y<selRowArray2.length; y++)
          {
            var thisRow = selRowArray2[y];
            if(thisRow == 0 && thisRow != "")
            {  
              selRowArray3[selRowArray3.length] = thisRow;
            }
            else if(thisRow != "")
            {     
              selRowArray3[selRowArray3.length] = thisRow;
            }
          }
        }
        else
          return;
      }         
      //store the selrow in an array 
      var selRowArray = new Array();        
      var dCount = document.searchResultsForm.hiddenSelectedRow.length;
      for (i=0; i<dCount; i++)
      {
        //get the row number
        var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
        selRowArray[selRowArray.length] = rowNo;  //fill the array with the checked row number
        //remove the check boxes
        var ckField = "CK"+rowNo;
        formObj= eval("document.searchResultsForm."+ckField);
        formObj.checked=false;
      }
      //make sure it is valid; get the editing pv; call function to create new row of concept for each concept; submit this page to add the bean to pv - vd - session; close window or come back to allow more selection
      if (sComp == "VMConcept")
      {
      	var pvInd = opener.document.getElementById("currentPVInd").value;
      	if (pvInd != null)
      	{
		    document.getElementById("editPVInd").value = pvInd;
	  		//add teh concept info on the page
	//  alert(editName + sCCode + sCCodeDB + " con " + conArray[0].conName + conArray[0].conID + conArray[0].conDBOrg);
	      	document.searchResultsForm.actSelected.value = "appendConcept";
	        document.searchResultsForm.submit(); 
        }
        else
        	alert("Unable to find the edited Permissible Value from the page");
      }
      else
      {
	      if(sConfirm == true)
	          opener.AllocSelRowOptions(selRowArray3);  //allocate option for hidden row and select it.      
	      else
	          opener.AllocSelRowOptions(selRowArray); 
	      //submit the vd form to store these in pv bean and refresh the page
	      opener.SubmitValidate("addSelectedCon");
      }
      //disable button and de-count the checked numbers
      numRowsSelected = 0;
      document.searchResultsForm.hiddenSelectedRow.length = 0;
      document.searchResultsForm.editSelectedBtn.disabled=true;
      document.searchResultsForm.btnSubConcepts.disabled=true;
    //  opener.document.createVDForm.searchComp.value = sComp;
   // }
  //alert("done showUseSelection");
  }
  
/*  function useSelectionCreateVM()
  {
    var dCount = document.searchResultsForm.hiddenSelectedRow.length;
    if (dCount > 0)
    {
      for (i=0; i<dCount; i++)
      {
        var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
        //first check the concept status and return if not valid
        editStatus = conArray[rowNo].conStatus;
        var useStatus = checkValidStatus(editStatus);
        if (useStatus != "valid") 
          return;
        //get the evs values from the row number
        editNameLong = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //evs concept name
        editDefinition = conArray[rowNo].conDef;  // document.searchResultsForm.hiddenDefSource[rowNo].text;   //evs definition 
        editDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value;   //evs definition source
        sCCodeDB = conArray[rowNo].conVocab;  // document.searchResultsForm.hiddenCCodeDB[rowNo].value;  //evs vocabulary
        sCCode = conArray[rowNo].conID;  // document.searchResultsForm.hiddenCCode[rowNo].value;   //evs code
        var sCode = sCCode + " : " + sCCodeDB;
        if (opener.document != null && opener.document.createVMForm != null && opener.document.createVMForm.selShortMeanings != null)
        {
	        opener.document.createVMForm.CreateDescription.value = editDefinition;
	        opener.document.createVMForm.selShortMeanings.value = editNameLong;
	       // opener.document.createVMForm.taComments.value = sCode;
	        opener.document.createVMForm.EVSConceptID.value = sCode;
	        opener.document.createVMForm.selShortMeanings.disabled = true;
	        if(selDefinition != null && selDefinition != "")
	          opener.document.createVMForm.CreateDescription.disabled = true;
	        else
	          opener.document.createVMForm.CreateDescription.disabled = false;
	        opener.document.createVMForm.hiddenEVSSearch.value = "Searched"; 
	        opener.document.createVMForm.hiddenSelRow.value = rowNo; 
	        //submit vm page to store data in the bean
	        opener.document.createVMForm.pageAction.value = "appendSearchVM";
	        opener.SubmitValidate("appendSearchVM");
	        //close the window
	        window.close();
        }
      }
    }
  } */
  //alerts if more than one concept with same name is selected
  function checkDuplicateConcept()
  {   
      var selNameArray = new Array();  //store the unique checked names in an array        
      var dupNameArray = new Array();   //store duplicate names in an array     
      var dCount = document.searchResultsForm.hiddenSelectedRow.length;
      var dupNames = "";
      for (var i=0; i<dCount; i++)
      {
        //get the row number
        var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
        var rowName = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //concept name 
        var rowDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value; 
        //loop through the selected names array to find if match occurs
        var isMatch = false;
        if (rowName != null && rowName != "" && selNameArray.length > 0)
        {
          //loop through the stored non duplicate checked names
          for (var j=0; j<selNameArray.length; j++)
          {
            var thisName = selNameArray[j];
           if (thisName == rowName)  //already exists as
            {
               var dupExists = false;
              //loop through the duplicate names array to store only once
              for (var k=0; k<dupNameArray.length; k++)
              {
                var dName = dupNameArray[k];
                if (dName == rowName)
                  dupExists = true;
              }
              //add it only if not exists as duplicates
              if (dupExists == false)
              {
                dupNameArray[dupNameArray.length] = rowName;
                //cut off the list of names to be displayed if more than 30 numbers to fit it within the window
                if (dupNameArray.length < 31)
                  dupNames = dupNames + rowName + "\n\t";  //add to name list
              }
              isMatch = true;
              break;
            } 
          }
        }
        //add only if no duplicate names selected
        if (isMatch == false)
          selNameArray[selNameArray.length] = rowName;
      }
      //let the users know if more than 30 duplicates exist
      if (dupNameArray != null && dupNameArray.length > 30)
        dupNames = dupNames + "\n" + (dupNameArray.length - 30) + " more duplicates exist .......\n";
      //return the list of duplicate names
      return dupNames;
  }
  
  
  //alerts if more than one concept with same name is selected
  function getDuplicateNameArray()
  { 
      var selNameArray = new Array();  //store the unique checked names in an array        
      var dupNameArray = new Array();   //store duplicate names in an array     
      var dCount = document.searchResultsForm.hiddenSelectedRow.length;
      for (var i=0; i<dCount; i++)
      {
        //get the row number
        var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
        var rowName = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //concept name 
        var rowDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value; 
        var isMatch = false;
        if (rowName != null && rowName != "" && selNameArray.length > 0)
        {
          //loop through the stored non duplicate checked names
          for (var j=0; j<selNameArray.length; j++)
          {
            var thisName = selNameArray[j];
           if (thisName == rowName)  //already exists as
            {
               var dupExists = false;
              //loop through the duplicate names array to store only once
              for (var k=0; k<dupNameArray.length; k++)
              {
                var dName = dupNameArray[k];
                if (dName == rowName)
                  dupExists = true;
              }
              //add it only if not exists as duplicates
              if (dupExists == false)
              {
                dupNameArray[dupNameArray.length] = rowName;
              }
              isMatch = true;
              break;
            } 
          }
        }
          //add only if no duplicate names selected
        if (isMatch == false)
          selNameArray[selNameArray.length] = rowName;
      }
      return dupNameArray;
  }
  
  function getRowNumbersOfUniqueConcepts()
  {
      var multiNamesArray = getDuplicateNameArray();
      var selNameArray = new Array();  //store the unique checked names in an array        
      var dupNameArray = new Array();   //store duplicate names in an array 
      var uniqueRowArray = new Array();
      var firstOneRow = "";
      var foundRightOne = "false";
      var foundRightOneNCI = "false";
      var foundRightOneNCIGLOSS = "false";
      var foundRightOneNCI04 = "false";
      var foundRightOneNCICB = "false";
      var foundRightRowNoNCI = "";
      var foundRightRowNoNCIGLOSS = "";
      var foundRightRowNoNCI04 = "";
      var foundRightRowNoNCICB = "";
      var firstOneRow = "";
      var dCount = document.searchResultsForm.hiddenSelectedRow.length;
      var dupNames = "";
      var rowNo;
      var rowName;
      var foundRightRowNo = "";
      var lastDup = multiNamesArray.length - 1;
      
      // Case of No Duplicates
      if(multiNamesArray.length == 0)
      {
        for (var i=0; i<dCount; i++)
        {
          rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
          uniqueRowArray[uniqueRowArray.length] = rowNo;
        }
      }
      else if(multiNamesArray.length == 1)  // Case of One Duplicate
      {
        var dName = multiNamesArray[0];
        var firstDuplicateIndexTracker = -1;
        // Cycle through all checked rows, check for duplicates
        for (var i=0; i<dCount; i++)
        {
          var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
          var rowName = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //concept name 
          if (dName == rowName)
          {
            firstOneRow = rowNo;
            firstDuplicateIndexTracker++;
            var sDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value; 
            if(sDefSource == arrDefSrc[0]) // "NCI")
            {
              foundRightRowNoNCI = rowNo;
              foundRightOneNCI = "true";
            }
            else if(sDefSource == arrDefSrc[1]) // "NCI-GLOSS")
            {
              foundRightRowNoNCIGLOSS = rowNo;
              foundRightOneNCIGLOSS = "true";
            }
            else if(sDefSource == arrDefSrc[2]) // "NCI04")
            {
              foundRightRowNoNCI04 = rowNo;
              foundRightOneNCI04 = "true";
            }
            else if(sDefSource == arrDefSrc[3]) // "NCICB")
            {
              foundRightRowNoNCICB = rowNo;
              foundRightOneNCICB = "true";
            }
          }
          else // if not a duplicate, add it
            uniqueRowArray[uniqueRowArray.length] = rowNo;
        }
        if(foundRightOneNCI == "true")       
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI;
        else if(foundRightOneNCIGLOSS == "true")    
          uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCIGLOSS;
        else if(foundRightOneNCI04 == "true")    
          uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI04;
        else if(foundRightOneNCICB == "true")    
          uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCICB;
        else // Case of No NCI type Duplicates
        {
          lastDuplicateFirstRowNo = firstOneRow - firstDuplicateIndexTracker;   
          uniqueRowArray[uniqueRowArray.length] = lastDuplicateFirstRowNo;
        } 
      }
      else if(multiNamesArray.length > 1) // Case of more than 1 Duplicate
      {
      for (var k=0; k<multiNamesArray.length; k++)
      {
        var index = k;
        var lastDuplicate = "false";
        if(k == (multiNamesArray.length-1))
          lastDuplicate = "true";
        var lastDuplicateFirstRowNo = 0;
        if(k > 0)// Made it all the way through the first duplicate, so now add the right one to array
        {
          if(foundRightOneNCI == "true")
          {
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI;         
          }
          else if(foundRightOneNCIGLOSS == "true")    
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCIGLOSS;
          else if(foundRightOneNCI04 == "true")    
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI04;
          else if(foundRightOneNCICB == "true")    
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCICB;
          else
          {
            lastDuplicateFirstRowNo = firstOneRow - firstDuplicateIndexTracker;
            uniqueRowArray[uniqueRowArray.length] = lastDuplicateFirstRowNo;
          }
          foundRightOneNCI = "false";
          foundRightOneNCIGLOSS = "false";
          foundRightOneNCI04 = "false";
          foundRightOneNCICB = "false";
          foundRightRowNoNCI = "";
          foundRightRowNoNCIGLOSS = "";
          foundRightRowNoNCI04 = "";
          foundRightRowNoNCICB = "";
        }
        var dName = multiNamesArray[k];
        var firstDuplicateIndexTracker = -1;
        foundRightOneNCI = "false";
        foundRightOneNCIGLOSS = "false";
        foundRightOneNCI04 = "false";
        foundRightOneNCICB = "false";
        foundRightRowNo = "";
        foundRightRowNoNCI = "";
        foundRightRowNoNCIGLOSS = "";
        foundRightRowNoNCI04 = "";
        foundRightRowNoNCICB = "";
        for (var i=0; i<dCount; i++) // for each duplicate, cycle through all checked rows
        {
          var rowNo = document.searchResultsForm.hiddenSelectedRow[i].value;
          var rowName = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //concept name 
  //alert("dName: " + dName + " rowName: " + rowName + " rowNo: " + rowNo + " foundRightRowNoNCI: " + foundRightRowNoNCI);
          if (dName == rowName)
          {
            firstOneRow = rowNo;
            firstDuplicateIndexTracker++;
            var sDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value;        
            if(sDefSource == arrDefSrc[0]) // "NCI")
            {
              foundRightRowNoNCI = rowNo;
              foundRightOneNCI = "true";
            }
            else if(sDefSource == arrDefSrc[1])  // "NCI-GLOSS")
            {
              foundRightRowNoNCIGLOSS = rowNo;
              foundRightOneNCIGLOSS = "true";
            }
            else if(sDefSource == arrDefSrc[2])  // "NCI04")
            {
              foundRightRowNoNCI04 = rowNo;
              foundRightOneNCI04 = "true";
            }
            else if(sDefSource == arrDefSrc[3])  // "NCICB")
            {
              foundRightRowNoNCICB = rowNo;
              foundRightOneNCICB = "true";
            }
          }
        }
      
        if(lastDuplicate == "true")// Made it all the way through the first duplicate, so now add the right one to array
        {
          if(foundRightOneNCI == "true")
          {
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI;   
          }
          else if(foundRightOneNCIGLOSS == "true")
          {
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCIGLOSS;       
          }
          else if(foundRightOneNCI04 == "true")    
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCI04;
          else if(foundRightOneNCICB == "true")    
            uniqueRowArray[uniqueRowArray.length] =  foundRightRowNoNCICB;
          else
          {
            lastDuplicateFirstRowNo = firstOneRow - firstDuplicateIndexTracker;
            uniqueRowArray[uniqueRowArray.length] = lastDuplicateFirstRowNo;
          }
          foundRightRowNoNCI = "";
          foundRightRowNoNCIGLOSS = "";
          foundRightRowNoNCI04 = "";
          foundRightRowNoNCICB = "";
        }
        }
      }  
      // Now add the non-duplicates to array
      for (var p=0; p<dCount; p++)
      {
        var isDup = "false";
        var rowNo2 = document.searchResultsForm.hiddenSelectedRow[p].value;
        var rowName2 = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo2].value;  //concept name
        for (var q=0; q<multiNamesArray.length; q++)
        {
          var dName2 = multiNamesArray[q];
          if (dName2 == rowName2)
            isDup = "true"
        }
        if(isDup == "false")
        {
          uniqueRowArray[uniqueRowArray.length] = rowNo2;
        }
      }
    return uniqueRowArray;
  }
  
  function getSubConceptsAll2(sUISearchType)
  {
      var sSearch = false;
      var url = "";
      var nodeCode = sCCode;
      var nodeName = editNameLong;
      var vocab = sCCodeDB;
      var conLevel = editLevel;
      sSearch = confirm("Searching for all Subconcepts may take a long time. Continue?");
      if (sSearch == true)
      {
      
        hourglass();
        window.status = "Refereshing the page, it may take a minute, please wait.....";
        document.searchResultsForm.Message.style.visibility="visible";
        url = "../../cdecurate/NCICurationServlet?reqType=getSubConcepts&&searchType=All&&nodeCode=" + nodeCode + "&&vocab=" + vocab + "&&nodeName=" + nodeName + "&&UISearchType=" + sUISearchType + "&&conLevel=" + conLevel;
        document.searchResultsForm.action = url;
        document.searchResultsForm.submit(); 
      }
   }
   
  function getSubConceptsImmediate2(sUISearchType)
  {
      var url = "";
      var nodeCode = sCCode;
      var nodeName = editNameLong;
      var vocab = sCCodeDB;
      var defSource = editDefSource;
      var conLevel = editLevel;
//alert("nodeCode: " + nodeCode + " nodeName: " + nodeName + " vocab: " + vocab +  " defSource: " + defSource);
      hourglass();
      url = "../../cdecurate/NCICurationServlet?reqType=getSubConcepts&&searchType=Immediate&&nodeCode=" + nodeCode + "&&vocab=" + vocab + "&&nodeName=" + nodeName + "&&defSource=" + defSource + "&&UISearchType=" + sUISearchType + "&&conLevel=" + conLevel;   
      document.searchResultsForm.action = url;
      document.searchResultsForm.submit(); 
      window.status = "Refereshing the page, it may take a minute, please wait.....";
      document.searchResultsForm.Message.style.visibility="visible";
   }
   
  function getSuperConcepts2(sUISearchType)
  {
      var url = "";
      var nodeCode = sCCode;
      var nodeName = editNameLong;
      var vocab = sCCodeDB;
      var defSource = editDefSource;
      hourglass();
      url = "../../cdecurate/NCICurationServlet?reqType=getSuperConcepts&&searchType=All&&nodeCode=" + nodeCode + "&&vocab=" + vocab + "&&nodeName=" + nodeName + "&&defSource=" + defSource + "&&UISearchType=" + sUISearchType;
      document.searchResultsForm.action = url;
      document.searchResultsForm.submit(); 
      window.status = "Refereshing the page, it may take a minute, please wait.....";
      document.searchResultsForm.Message.style.visibility="visible";
  }

   //trims off spaces and "_"
   function TrimEnds(editDefinition)
   {
      if (editDefinition.length > 0)
      {
        if (editDefinition.charAt(0) == "_" || editDefinition.charAt(0) == " " )
           editDefinition = editDefinition.slice(1, editDefinition.length);
        if (editDefinition.charAt(0) == "_" || editDefinition.charAt(0) == " " ) //do it again for second "_"
           editDefinition = editDefinition.slice(1, editDefinition.length);
        if (editDefinition.charAt(editDefinition.length -1) == "_" || editDefinition.charAt(editDefinition.length -1) == " ")
           editDefinition = editDefinition.slice(0, editDefinition.length - 1);
      }
      return editDefinition;
   }

   function TrimToFourChar(name)
   {
    if (name.length > 4)
    {
	   name = name.slice(0, 4);
    }
    return name;
   }

   //creates the names of the opener document
function createNames(acType)
{
	var openerLN = "";
	var openerPN = "";
  var repQual = "";
  var repQualLN = "";
  var rep = "";
  var repLN = "";
	//get the values of the building blocks
	if (acType == "DataElementConcept" && opener.document.newDECForm != null)
	{
    var objQual = ""; //opener.document.newDECForm.selObjectQualifierPN.value;
    if(objQual == null) objQual = "";
    var propQual = ""; //opener.document.newDECForm.selPropertyQualifierPN.value; 
    if(propQual == null) propQual = "";
   	var obj = TrimToFourChar(opener.document.newDECForm.txtObjClass.value);
    if(obj == null) obj = "";
   	var prop = TrimToFourChar(opener.document.newDECForm.txtPropClass.value);
    if(prop == null) prop = "";
  
    var objQualLN = ""; //opener.document.newDECForm.selObjectQualifierLN.value;
    if(objQualLN == null) objQualLN = "";
   	var objLN = opener.document.newDECForm.txtObjClass.value;
    if(objLN == null) objLN = "";
   	var propQualLN = "";  //opener.document.newDECForm.selPropertyQualifierLN.value;
    if(propQualLN == null) propQualLN = "";
   	var propLN = opener.document.newDECForm.txtPropClass.value;
    if(propLN == null) propLN = "";
    
	  var vStatus = opener.document.newDECForm.selStatus.value;
	}
	else if (acType == "ValueDomain" && opener.document.createVDForm != null)
	{
  	  var objQual = TrimToFourChar(opener.document.createVDForm.selObjectQualifierText.value);
   	  var obj = TrimToFourChar(opener.document.createVDForm.selObjectClassText.value);
   	  var propQual = TrimToFourChar(opener.document.createVDForm.selPropertyQualifierText.value);
   	  var prop = TrimToFourChar(opener.document.createVDForm.selPropertyClassText.value);
      var repQual = TrimToFourChar(opener.document.createVDForm.selRepQualifierText.value);
   	  var rep = TrimToFourChar(opener.document.createVDForm.txtRepTerm.value);
      var objQualLN = opener.document.createVDForm.selObjectQualifierLN.value;
   	  var objLN = opener.document.createVDForm.selObjectClassLN.value;
   	  var propQualLN = opener.document.createVDForm.selPropertyQualifierLN.value;
   	  var propLN = opener.document.createVDForm.selPropertyClassLN.value;
	    var repQualLN = opener.document.createVDForm.selRepQualifierLN.value;
   	  var repLN = opener.document.createVDForm.selRepTerm.value;
	    var vStatus = opener.document.createVDForm.selStatus.value;
	}
//alert("repLN: " + repLN + "rep: " + rep);	
	   // create long name and preferred names
	   var LongName = "";
     var OCLongName = "";
     var PropLongName = "";
     var PrefName = "";
	   if (objQualLN != "") 
     {
      LongName = objQualLN + " ";
      OCLongName = objQualLN + " "; 
     }
	   if (objLN != "") 
     {
      LongName = LongName + objLN + " ";
      OCLongName = OCLongName + objLN + " ";
     }
	   if (propQualLN != "") 
     {
      LongName = LongName + propQualLN + " ";
      PropLongName = propQualLN + " ";
     }
	   if (propLN != "") 
     {
      LongName = LongName + propLN + " ";
      PropLongName = PropLongName + propLN + " ";
     }
//	alert("LongName00: " + LongName + "PrefName0: " + PrefName);   
	   if (objQual != "") PrefName = objQual + "_";
	   if (obj != "") PrefName = PrefName + obj + "_";
	   if (propQual != "") PrefName = PrefName + propQual + "_";
	   if (prop != "") PrefName = PrefName + prop + "_";
     
     if (repQualLN != "") LongName = LongName + repQualLN + " ";
	   if (repLN != "") LongName = LongName + repLN + " ";
	   if (repQual != "") PrefName = PrefName + repQual + "_";
	   if (rep != "") PrefName = PrefName + rep + "_";
	  // }
//alert("LongName01: " + LongName + "PrefName0: " + PrefName);
	   // remove the first and last character if empty or underscore
	   if (LongName.length > 0)
	   {
	   	if (LongName.charAt(0) == " ")
		   LongName = LongName.slice(1, LongName.length);
      if (LongName.charAt(LongName.length -1) == " ")
		   LongName = LongName.slice(0, LongName.length - 1);
	   }
	   if (PrefName.length > 0)
         {
		if (PrefName.charAt(0) == "_" || PrefName.charAt(0) == " " )
		   PrefName = PrefName.slice(1, PrefName.length);
	      if (PrefName.charAt(PrefName.length -1) == "_" || PrefName.charAt(PrefName.length -1) == " ")
		   PrefName = PrefName.slice(0, PrefName.length - 1);
         }
	//fill the long name and preferred name fields of the opener document
	if (acType == "DataElementConcept" && opener.document.newDECForm != null)
	{
         var source = opener.document.newDECForm.DECAction.value;
	   if (source == "NewDEC")
	   {
        //  opener.document.newDECForm.txtObjClass.value = OCLongName;
       //   opener.document.newDECForm.txtPropClass.value = PropLongName; 
         	opener.document.newDECForm.txtLongName.value = LongName; 
         	opener.document.newDECForm.txtLongNameCount.value = LongName.length;
	   	if (PrefName.length > 0)
	   	{
	   		opener.document.newDECForm.txtPreferredName.value = PrefName;
        opener.document.newDECForm.txtPrefNameCount.value = PrefName.length;
	   	}
	    }
	    else if (source == "EditDEC")
	    {
        opener.document.newDECForm.txtObjClass.value = opener.document.newDECForm.txtObjClass.value + " " + LongName;
        opener.document.newDECForm.txtLongName.value = opener.document.newDECForm.txtLongName.value + " " + LongName;
        openerLN = opener.document.newDECForm.txtLongName.value;
	      openerPN = opener.document.newDECForm.txtPreferredName.value;
        opener.document.newDECForm.txtLongNameCount.value = (openerLN.length + LongName.length);
	   	if (PrefName.length > 0)
	   	{
	   		opener.document.newDECForm.txtPreferredName.value = opener.document.newDECForm.txtPreferredName.value + "_" + PrefName;
         		opener.document.newDECForm.txtPrefNameCount.value = (openerPN.length + PrefName.length);
	   	}
	    }

    }
	else if (acType == "ValueDomain" && opener.document.createVDForm != null)
	{
//alert("LongName1: " + LongName + "PrefName1: " + PrefName);
         var source = opener.document.createVDForm.VDAction.value;
	   if (source == "NewVD")
	   {
         //	opener.document.createVDForm.txtLongName.value = LongName;
         //	opener.document.createVDForm.txtLongNameCount.value = LongName.length;
	   	if (PrefName.length > 0)
	   	{
         // opener.document.createVDForm.txtPreferredName.value = PrefName;
         // opener.document.createVDForm.txtPrefNameCount.value = PrefName.length;
	   	}
	    }
	    else if (source == "EditVD")
	   {
       // opener.document.createVDForm.txtLongName.value = opener.document.createVDForm.txtLongName.value + " " + LongName;
        openerLN = opener.document.createVDForm.txtLongName.value;
        openerPN = opener.document.createVDForm.txtPreferredName.value;
      //  opener.document.createVDForm.txtLongNameCount.value = (openerLN.length + LongName.length);
	   	if (PrefName.length > 0)
	   	{
       // opener.document.createVDForm.txtPreferredName.value = opener.document.createVDForm.txtPreferredName.value + "_" + PrefName;
       // opener.document.createVDForm.txtPrefNameCount.value = (openerPN.length + PrefName.length);
      }
	   }

      }
	//close the window
	window.close();
   }

   //creates the names of the opener document
   function createNamesEdit(acType, sComp)
   {
      var openerLN = "";
      var openerPN = "";
      var LongName = "";
      var PrefName = "";
  
	//get the values of the building blocks
	if (acType == "DataElementConcept" && opener.document.newDECForm != null)
	{
	  LongName = opener.document.newDECForm.txtLongName.value ;
    PrefName = opener.document.newDECForm.txtPreferredName.value;
    var source = opener.document.newDECForm.DECAction.value;
    var MenuAction = opener.document.newDECForm.MenuAction.value;
    if (sComp == "ObjectClass")
    {
      var objLN = editNameLong;  //opener.document.newDECForm.selObjectClass.value;
      if(objLN == null) objLN = "";
      LongName = LongName + " " + objLN;
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var objPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selObjectClass.value);
        if(objPN == null) objPN = "";
        PrefName = PrefName + "_" + objPN;
      }
    }
    else if (sComp == "PropertyClass")
    {
      var propLN = editNameLong; //opener.document.newDECForm.selPropertyClass.value;
      if(propLN == null) propLN = "";
      LongName = LongName + " " + propLN;
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var propPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selPropertyClass.value);
        if(propPN == null) propPN = "";
        PrefName = PrefName + "_" + propPN;
      }
    }
    else if (sComp == "PropertyQualifier")
    {
      var propLN = editNameLong;  //opener.document.newDECForm.selPropertyQualifier[0].value;
      if(propLN == null) propLN = "";
      LongName = LongName + " " + propLN;
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var propPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selPropertyQualifier[0].value);
        if(propPN == null) propPN = "";
        PrefName = PrefName + "_" + propPN;
      }
    }
    else if (sComp == "ObjectQualifier")
    {
      var objLN = editNameLong;  //opener.document.newDECForm.selObjectQualifier.value;
      if(objLN == null) objLN = "";
      LongName = LongName + " " + objLN;
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var objPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selObjectQualifier.value);
        if(objPN == null) objPN = "";
        PrefName = PrefName + "_" + objPN;
//    alert("OCQ PrefName: " + PrefName);
      }
    }
//  alert("prefName00: " + PrefName);
    if (LongName.length > 0)
	  {
	   	if (LongName.charAt(0) == " ")
		   LongName = LongName.slice(1, LongName.length);
      if (LongName.charAt(LongName.length -1) == " ")
		   LongName = LongName.slice(0, LongName.length - 1);
	   }
    if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
    {
	   if (PrefName.length > 0)
     {
        if (PrefName.charAt(0) == "_" || PrefName.charAt(0) == " " )
          PrefName = PrefName.slice(1, PrefName.length);
	      if (PrefName.charAt(PrefName.length -1) == "_" || PrefName.charAt(PrefName.length -1) == " ")
          PrefName = PrefName.slice(0, PrefName.length - 1);
      }
    }
    opener.document.newDECForm.txtLongName.value = LongName;
    opener.document.newDECForm.txtLongNameCount.value = LongName.length;
    if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
    {
      if (PrefName.length > 0)
      {
//alert("prefName final: " + PrefName);
        opener.document.newDECForm.txtPreferredName.value = PrefName;
        opener.document.newDECForm.txtPrefNameCount.value = PrefName.length;
      }
    }
  }
	else if (acType == "ValueDomain" && opener.document.createVDForm != null)
	{
	  var LongName = opener.document.createVDForm.txtLongName.value ;
    var PrefName = opener.document.createVDForm.txtPreferredName.value;
    var source = opener.document.createVDForm.VDAction.value;
    var MenuAction = opener.document.createVDForm.MenuAction.value;
    
    var objQualLN = opener.document.createVDForm.selObjectQualifierLN.value;
   	var objLN = opener.document.createVDForm.selObjectClassLN.value;
   	var propQualLN = opener.document.createVDForm.selPropertyQualifierLN.value;
   	var propLN = opener.document.createVDForm.selPropertyClassLN.value;
	  var repQualLN = opener.document.createVDForm.selRepQualifierLN.value;
   	var repLN = opener.document.createVDForm.selRepTerm.value;
    var repLN = opener.document.createVDForm.selRepTermLN.value;
    var repLN3 = opener.document.createVDForm.txtRepTerm.value;
	  var vStatus = opener.document.createVDForm.selStatus.value;
	   if (objLN != "" && (sComp == "ObjectClass" || sComp == "VDObjectClass")) 
      LongName = LongName + " " + objLN;
	   if (propLN != "" && (sComp == "PropertyClass" || sComp == "VDPropertyClass")) 
      LongName = LongName + " " + propLN;
	   if (repQualLN != "" && sComp == "RepQualifier") 
      LongName = LongName + " " + repQualLN;
	   if (repLN != "" && sComp == "RepTerm") 
      LongName = LongName + " " + repLN;
	   // remove the first and last character if empty or underscore
	   if (LongName.length > 0)
	   {
	   	if (LongName.charAt(0) == " ")
		   LongName = LongName.slice(1, LongName.length);
      if (LongName.charAt(LongName.length -1) == " ")
		   LongName = LongName.slice(0, LongName.length - 1);
	   } 
    if (LongName.length > 0)
	  {
	   //opener.document.createVDForm.txtLongName.value = LongName;
	   //opener.document.createVDForm.txtLongNameCount.value = LongName.length;
    }
    
    if (sComp == "RepQualifier")
    {
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var objPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selObjectQualifier.value);
        if(objPN == null) objPN = "";
        PrefName = PrefName + "_" + objPN;
      }
    }
     if (sComp == "RepTerm")
    {
      if(MenuAction == "NewDECVersion" || MenuAction == "NewDECTemplate")
      {
        var repPN = TrimToFourChar(editNameLong);  //(opener.document.newDECForm.selObjectQualifier.value);
        if(repPN == null) repPN = "";
        PrefName = PrefName + "_" + repPN;
      }
    }
    if(MenuAction == "NewVDVersion" || MenuAction == "NewVDTemplate")
    {
      if (PrefName.length > 0)
      {
        //opener.document.createVDForm.txtPreferredName.value = PrefName;
        //opener.document.createVDForm.txtPrefNameCount.value = PrefName.length;
      }
    }
  }
//alert("LongName1: " + LongName );
	//close the window
	window.close();
}


   /* This function enables/disables the "Edit Selection" and
     "Show Selected Rows Only" buttons based on checked items in the list.
    Edit Selection:  enabled when one checked and disabled otherwise, except 
		when the component is permissible value for searchforCreate
     Show Selected Rows Only:  enabled when one or more items are checked 
     designate record : enabled when not search for create and only one item checked.
 */

   function EnableCheckButtons(checked, currentField, editAction)
   {
  // alert("enableCheckButtons1");
      if(editAction == "BEDisplay") editAction = "searchForCreate";
      if (checked)
         ++numRowsSelected;
      else
         --numRowsSelected;
      var rowNo = currentField.name;
      var varSearchAC = document.searchParmsForm.listSearchFor.value;
      var nonEnumVD = false;
      //is this non enumerated
      if (opener != null)
      { 
      if (opener.document != null)
      { 
        if (opener.document.createVDForm != null)
        { 
          if (opener.document.createVDForm.listVDType != null)
          { 
          var eInd = opener.document.createVDForm.listVDType.selectedIndex;
          if (eInd > -1 && opener.document.createVDForm.listVDType[eInd].value == "N" && varSearchAC == "ParentConceptVM")
            nonEnumVD = true;
          }
        }
        }
      }
    
      //enable disable according to no of rows selected
      if (numRowsSelected > 0)
      {
         if (numRowsSelected == 1)
         {
              document.searchResultsForm.btnSuperConcepts.disabled=false;
              document.searchResultsForm.btnSubConcepts.disabled=false;
              //do not enble if non enumerated vd
              if (nonEnumVD == false)
                  document.searchResultsForm.editSelectedBtn.disabled=false;
              if (varSearchAC == "ParentConceptVM")
                document.searchResultsForm.btnSuperConcepts.disabled=true;
               if (checked)
                  StoreSelectedRow("true", rowNo);
               else
                  StoreSelectedRow("false", rowNo);
         }
         else
         {
               if (varSearchAC == "EVSValueMeaning" || varSearchAC == "ParentConceptVM")
               {
                  if (checked)
                     StoreSelectedRow("true", rowNo);
                  else
                     StoreSelectedRow("false", rowNo);
                  //document.searchResultsForm.editSelectedBtn.disabled=true;
                  document.searchResultsForm.btnSubConcepts.disabled=true;
                  document.searchResultsForm.btnSubConcepts.disabled=true;
               //   document.searchResultsForm.btnShowTree.disabled=true;
               }
               else
               {
                   formObj= eval("document.searchResultsForm."+currentField.name);
                   formObj.checked=false;
                   --numRowsSelected;
                   alert("Please check only one box at a time");
               }
         }
      }
      else
      {
          document.searchResultsForm.editSelectedBtn.disabled=true;
          document.searchResultsForm.btnSubConcepts.disabled=true;
          document.searchResultsForm.btnSuperConcepts.disabled=true;
         // if (varSearchAC == "EVSValueMeaning" || varSearchAC == "ParentConceptVM")
         //    StoreSelectedRow("false", rowNo);
          if (checked)
             StoreSelectedRow("true", rowNo);
          else
             StoreSelectedRow("false", rowNo);

      }
   }

	// stored the selected row values for permissible values on SearchForCreate action
   function StoreSelectedRow(addRow, rowNo)
   {
      selRow = rowNo;
      rowNo = rowNo.substring(2, rowNo.length);
      var dCount = 0;
      //add or remove the row number in the hidden field
      if (document.searchResultsForm.hiddenSelectedRow != null)
        dCount = document.searchResultsForm.hiddenSelectedRow.length;
      if (addRow == "true")
         searchResultsForm.hiddenSelectedRow.options[dCount] = new Option(selRow,rowNo); //store the row number in the hidden vector	    
      else  //remove the row if not selected anymore
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

      editID = conArray[rowNo].conID;  // document.searchResultsForm.hiddenSearch[rowNo].value;
      editNameLong = conArray[rowNo].conName;  // document.searchResultsForm.hiddenName[rowNo].value;  //evs concept name
      editName = conArray[rowNo].conName;  //  document.searchResultsForm.hiddenName[rowNo].value;   //truncated concept name used for parent concept 
	    if (editName.length > 30)
        editName = editName.substring(0,30);
      editLevel = conArray[rowNo].conLevel;  // document.searchResultsForm.hiddenName[rowNo].text;
    //  editLongName = document.searchResultsForm.hiddenName[rowNo].value;  //?
    //  editNameType = document.searchResultsForm.hiddenName[rowNo].text;   //?
      editDefinition = conArray[rowNo].conDef;  // document.searchResultsForm.hiddenDefSource[rowNo].text;   //evs definition
      editDefSource = conArray[rowNo].conDefSrc;  // document.searchResultsForm.hiddenDefSource[rowNo].value; 
      sCCodeDB = conArray[rowNo].conVocab;   //conArray[rowNo].conDBOrg;  // document.searchResultsForm.hiddenCCodeDB[rowNo].value;  //evs vocabulary
      sCCode = conArray[rowNo].conID;  // document.searchResultsForm.hiddenCCode[rowNo].value;   //evs code
      editStatus = conArray[rowNo].conStatus;
      if(sCCode == null || sCCode == "null") sCCode = "";
      if(sCCodeDB == null || sCCodeDB == "null") sCCodeDB = "";   
      
      //disable sub concept and super concept if meta or cadsr
      if (sCCodeDB == dsrName || sCCodeDB == metaName)    //sCCodeDB == "caDSR" || sCCodeDB == "NCI Metathesaurus")
      {
        document.searchResultsForm.btnSuperConcepts.disabled=true;
        document.searchResultsForm.btnSubConcepts.disabled=true;
      }       
   }

  function SelectAll(numRecs)
  {
    var CK = "";
    if(numRowsSelected < 1)
    {
      for(k=0; k<numRecs; k++)
      {
        CK = "CK" + k;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked == false)
        {
          formObj.checked=true;
          EnableButtons(true,formObj);
        }
      }
      if (document.searchResultsForm.CheckGif != null)
        document.searchResultsForm.CheckGif.alt = "Unselect All";
     // ShowSelectedRows(true);
    }
    else
    {
      for(m=0; m<numRecs; m++)
      {
        CK = "CK" + m;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked==true)
        {
          formObj.checked=false;
          EnableButtons(false,formObj);
        }
      }
      if (document.searchResultsForm.CheckGif != null)
        document.searchResultsForm.CheckGif.alt = "Select All";
     // ShowSelectedRows(false);
    }
  }
  //fill the array object
  function fillConArray(conID, conName, conDef, conDefSrc, conVocab, conDBOrg, conLvl, conStatus)
  {
    cArray = new Array();
    cArray.conID = conID;
    cArray.conName = conName;
    cArray.conDef = conDef;
    cArray.conDefSrc = conDefSrc;
    cArray.conVocab = conVocab;
    cArray.conDBOrg = conDBOrg;
    cArray.conLevel = conLvl;
    cArray.conStatus = conStatus;
    return cArray;
  }
  
   // submit the page when clicked on clear records.
   function clearRecords()
   {
      document.searchResultsForm.actSelected.value = "clearRecords";
      document.searchResultsForm.submit();
   }

  function NewTermSuggested()
  {      
     var sComp1 = "";
     if (opener != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.searchEVS != null)
        sCompl = opener.document.SearchActionForm.searchEVS.value;
     if (sComp1 == "DataElementConcept")
     {
        var decDef = opener.document.newDECForm.CreateDefinition.value;
        if (decDef != "")
          opener.document.newDECForm.CreateDefinition.value = decDef + " New EVS term suggested.";
        else
          opener.document.newDECForm.CreateDefinition.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open("http://ncimeta.nci.nih.gov/MetaServlet/servlet/FormalizationFailedServlet", "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
     else if (sComp1 == "ValueDomain")
     {
        var vdDef = opener.document.createVDForm.CreateDefinition.value;
        if(vdDef != "")
          opener.document.createVDForm.CreateDefinition.value = vdDef + " New EVS term suggested.";
         else
          opener.document.createVDForm.CreateDefinition.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open("http://ncimeta.nci.nih.gov/MetaServlet/servlet/FormalizationFailedServlet", "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
      else
      {
        if (evsWindow2 && !evsWindow2.closed)
          evsWindow2.close()
        evsWindow2 = window.open("http://ncimeta.nci.nih.gov/MetaServlet/servlet/FormalizationFailedServlet", "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
  }
  
