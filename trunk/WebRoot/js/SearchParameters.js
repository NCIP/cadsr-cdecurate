// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/SearchParameters.js,v 1.11 2009-04-09 21:37:54 hebell Exp $
// $Name: not supported by cvs2svn $

    function hourglass()
    {
      document.body.style.cursor = "wait";
    }
    
    // submits the page when clicked on updatedisplaybutton to get the data for selected attributes.
    function displayAttributes(isSubmitOk)
    {
     if (isSubmitOk == "true")
      { 
         hourglass();
         window.status = "Displaying selected attributes, it may take a minute, please wait....."
         document.searchParmsForm.actSelect.value = "Attribute";
	      if (document.searchResultsForm != null)
	        document.searchResultsForm.Message.style.visibility="visible";
         document.searchParmsForm.submit();
      }
      else
        alert("Search results must be present before updating the attributes"); 
     }

   //fuction to refresh the page for simple/advanced filter
   function refreshFilter(filterAction)
   {
     hourglass();
     window.status = "Refereshing the page, it may take a minute, please wait....."
     document.searchParmsForm.actSelect.value = filterAction;
     if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
     document.searchParmsForm.submit();
   }

   //fuction to change the search type
   function changeType(sType)
   {
     if (opener.document != null && opener.document.SearchActionForm != null)
        opener.document.SearchActionForm.isValidSearch.value = "true";
     hourglass();
     window.status = "Refereshing the page, it may take a minute, please wait....."
     document.searchParmsForm.actSelect.value = sType;
      if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
     document.searchParmsForm.submit();
   }

  

   function selectAll()
   {
      for (i=0; i<document.searchParmsForm.selectContext.length; i++)
      {
      	document.searchParmsForm.selectContext.options[i].selected=true;
      }
   }

   function deselectAll()
   {
      for (i=0; i<document.searchParmsForm.selectContext.length; i++)
      {
      	document.searchParmsForm.selectContext.options[i].selected=false;
      }
   }
   
  //keeps the component selected on searchForCreate action by getting the selected comp from opener page
  function getCompCreate()
  {

    if (opener && opener.document != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.searchComp != null)
    {
      var sSelComp = opener.document.SearchActionForm.searchComp.value;
      if (sSelComp != null)
      {
         if (sSelComp == "CreateVM_EVSValueMeaning")
         {
           document.searchParmsForm.listSearchFor[0].value = "CreateVM_EVSValueMeaning";
           document.searchParmsForm.listSearchFor[0].text = "Value Meaning";
         }
         if (sSelComp == "PV_ValueMeaning") 
         {
           document.searchParmsForm.sConteIdseq.value = ""; // no context for PV's
           document.searchParmsForm.listSearchFor[0].value = "PV_ValueMeaning";
           document.searchParmsForm.listSearchFor[0].text = "Value Meaning";
           document.searchParmsForm.sCCode.value = opener.document.SearchActionForm.sCCode.value
           document.searchParmsForm.sCCodeDB.value = opener.document.SearchActionForm.sCCodeDB.value
           document.searchParmsForm.sCCodeName.value = opener.document.SearchActionForm.sCCodeName.value
           document.searchParmsForm.openToTree.value = opener.document.SearchActionForm.openToTree.value;
         }
         if (sSelComp == "ObjectClass")
         {
           var oc = opener.document.newDECForm.selObjectClass[0].value;
           if(oc == null) oc = "";
           var selIdx = opener.document.newDECForm.selContext.selectedIndex;
           var conte_idseq = opener.document.newDECForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           if (document.searchParmsForm.sCCodeName != null)
           {
           document.searchParmsForm.sCCodeName.value = oc;
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "ObjectClass";
           document.searchParmsForm.listSearchFor[0].text = "Object Class";
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("ObjClassID").innerText) ? opener.document.getElementById("ObjClassID").innerText : opener.document.getElementById("ObjClassID").textContent;
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("ObjClass").innerText) ? opener.document.getElementById("ObjClass").innerText : opener.document.getElementById("ObjClass").textContent;
           document.searchParmsForm.openToTree.value = opener.document.newDECForm.openToTree.value;
           opener.document.newDECForm.openToTree.value = ""; // reset this
           }
         }
         else if (sSelComp == "VDObjectClass")
         {
           document.searchParmsForm.listSearchFor[0].value = "ObjectClass";
           document.searchParmsForm.listSearchFor[0].text = "Object Class";
         }
         else if (sSelComp == "PropertyClass")
         {
           var Prop = opener.document.newDECForm.selPropertyClass[0].value;
           if(Prop == null) Prop = "";
           var selIdx = opener.document.newDECForm.selContext.selectedIndex;
           var conte_idseq = opener.document.newDECForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "Property";
           document.searchParmsForm.listSearchFor[0].text = "Property";
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("PropClass").innerText) ? opener.document.getElementById("PropClass").innerText : opener.document.getElementById("PropClass").textContent;
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("PropClassID").innerText) ? opener.document.getElementById("PropClassID").innerText : opener.document.getElementById("PropClassID").textContent;
           document.searchParmsForm.sCCodeName.value = Prop;
           document.searchParmsForm.openToTree.value = opener.document.newDECForm.openToTree.value;
           opener.document.newDECForm.openToTree.value = "";
         }
         else if (sSelComp == "VDPropertyClass")
         {
           document.searchParmsForm.listSearchFor[0].value = "Property";
           document.searchParmsForm.listSearchFor[0].text = "Property";
         }
	       else if (sSelComp == "RepTerm")
         {
           var selIdx = opener.document.createVDForm.selContext.selectedIndex;
           var conte_idseq = opener.document.createVDForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "RepTerm";
           document.searchParmsForm.listSearchFor[0].text = "Rep Term";
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("RepTerm").innerText) ? opener.document.getElementById("RepTerm").innerText : opener.document.getElementById("RepTerm").textContent;
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("RepTermID").innerText) ? opener.document.getElementById("RepTermID").innerText : opener.document.getElementById("RepTermID").textContent;
           document.searchParmsForm.sCCodeName.value = opener.document.createVDForm.selRepTerm.value;
           document.searchParmsForm.openToTree.value = opener.document.createVDForm.openToTree.value;
           opener.document.createVDForm.openToTree.value = "";
         }
         else if (sSelComp == "ParentConcept")
         {
           document.searchParmsForm.listSearchFor[0].value = "ParentConcept";
           document.searchParmsForm.listSearchFor[0].text = "Parent Concept";
         }
         else if (sSelComp == "ParentConceptVM")
         {
           document.searchParmsForm.listSearchFor[0].value = "ParentConceptVM";
           document.searchParmsForm.listSearchFor[0].text = "Value Meaning";
           //make the search as parent concept when viewing the parent for non enum vd
         }
         else if (sSelComp == "ObjectQualifier")
         {
           var qual = "";
           if(opener.document.newDECForm.selObjectQualifier[0].value != null)
            qual = opener.document.newDECForm.selObjectQualifier[0].value;
           if(qual == null) qual = "";
           var selIdx = opener.document.newDECForm.selContext.selectedIndex;
           var conte_idseq = opener.document.newDECForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "ObjectQualifier";
           document.searchParmsForm.listSearchFor[0].text = "Object Qualifier";
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("ObjQual").innerText) ? opener.document.getElementById("ObjQual").innerText : opener.document.getElementById("ObjQual").textContent;
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("ObjQualID").innerText) ? opener.document.getElementById("ObjQualID").innerText : opener.document.getElementById("ObjQualID").textContent;
           document.searchParmsForm.sCCodeName.value = qual;
           document.searchParmsForm.openToTree.value = opener.document.newDECForm.openToTree.value;
           opener.document.newDECForm.openToTree.value = "";
         }
         else if (sSelComp == "VDObjectQualifier")
         {
           document.searchParmsForm.listSearchFor[0].value = "ObjectQualifier";
           document.searchParmsForm.listSearchFor[0].text = "Object Qualifier";
         }
         else if (sSelComp == "PropertyQualifier")
         {
           var qualProp = opener.document.newDECForm.selPropertyQualifier[0].value;
           if(qualProp == null) qualProp = "";
           var selIdx = opener.document.newDECForm.selContext.selectedIndex;
           var conte_idseq = opener.document.newDECForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "PropertyQualifier";
           document.searchParmsForm.listSearchFor[0].text = "Property Qualifier";
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("PropQual").innerText) ? opener.document.getElementById("PropQual").innerText : opener.document.getElementById("PropQual").textContent;
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("PropQualID").innerText) ? opener.document.getElementById("PropQualID").innerText : opener.document.getElementById("PropQualID").textContent;
           document.searchParmsForm.sCCodeName.value = qualProp;
           document.searchParmsForm.openToTree.value = opener.document.newDECForm.openToTree.value;
           opener.document.newDECForm.openToTree.value = "";
        }
         else if (sSelComp == "VDPropertyQualifier")
         {
           document.searchParmsForm.listSearchFor[0].value = "PropertyQualifier";
           document.searchParmsForm.listSearchFor[0].text = "Property Qualifier";
         }
	       else if (sSelComp == "RepQualifier")
         {
           var qualRep = opener.document.createVDForm.selRepQualifier.value;
           if(qualRep == null) qualRep = "";
           var selIdx = opener.document.createVDForm.selContext.selectedIndex;
           var conte_idseq = opener.document.createVDForm.selContext[selIdx].value;
           if(conte_idseq == null) conte_idseq = "";
           document.searchParmsForm.sConteIdseq.value = conte_idseq;
           document.searchParmsForm.listSearchFor[0].value = "RepQualifier";
           document.searchParmsForm.listSearchFor[0].text = "Rep Qualifier";
           document.searchParmsForm.sCCodeDB.value = (opener.document.getElementById("RepQual").innerText) ? opener.document.getElementById("RepQual").innerText : opener.document.getElementById("RepQual").textContent;
           document.searchParmsForm.sCCode.value = (opener.document.getElementById("RepQualID").innerText) ? opener.document.getElementById("RepQualID").innerText : opener.document.getElementById("RepQualID").textContent; 
           document.searchParmsForm.sCCodeName.value = qualRep;
           document.searchParmsForm.openToTree.value = opener.document.createVDForm.openToTree.value;
           opener.document.createVDForm.openToTree.value = "";
         }
         else if (sSelComp == "ValueMeaning")
         {
           document.searchParmsForm.listSearchFor[0].value = "ValueMeaning";
           document.searchParmsForm.listSearchFor[0].text = "Value Meaning";
          }
          else if (sSelComp == "EVSValueMeaning")
         {
           document.searchParmsForm.listSearchFor[0].value = "EVSValueMeaning";
           document.searchParmsForm.listSearchFor[0].text = "Value Meaning";
          }
          else if (sSelComp == "VMConcept")
         {
           document.searchParmsForm.listSearchFor[0].value = "VMConcept";
           document.searchParmsForm.listSearchFor[0].text = "Concept";  //"Value Meaning";
         }
          else if (sSelComp == "EditVMConcept")
         {
           document.searchParmsForm.listSearchFor[0].value = "EditVMConcept";
           document.searchParmsForm.listSearchFor[0].text = "Concept";  //"Value Meaning";
         }
      }
    }
  }

  //submits the page if selected searchIn CRFName to create two input fields.
  function doSearchInChange()
  {
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = "searchInSelect";
    if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.submit();
  }
  
    //submits the page if changed searchFor refresh the page for Question, otherwise calls the function to change attributes.
  function doSearchForChange()
  {
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = "searchForSelectOther";
    var selIdx = document.searchParmsForm.listSearchFor.selectedIndex;
    document.searchParmsForm.listSearchFor[selIdx].selected = true;
    if (document.searchResultsForm != null)
    	document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.submit();
  }
 
	//submits the page if crfvalue search
  function doSearchForCRF()
  {
    //refresh the page first time it opened
    if (opener.document != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
    {
      opener.document.SearchActionForm.isValidSearch.value = "true";
      if(opener && opener.document.SearchParmsForm != null)
        document.searchParmsForm.listSearchFor[0].selected = true;
      else
      {
         var selIdx = document.searchParmsForm.listSearchFor.selectedIndex;
         document.searchParmsForm.listSearchFor[selIdx].selected = true;
      }
      hourglass();
      window.status = "Refreshing the page, it may take a minute, please wait....."
      document.searchParmsForm.actSelect.value = "searchForSelectCRF";
      if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
      document.searchParmsForm.submit();
    }
  }
  
  //submits the form if needs refresh in searchForCreate and for filters cd list for pv search according to the context of cd with vd.
  function openSearchForCreateAct(thisComp)
  {
    if (opener && opener.document != null && opener.document.SearchActionForm != null)
    {
        var sSelComp = opener.document.SearchActionForm.searchComp.value;
        document.searchParmsForm.listSearchFor[0].value = sSelComp;
        //refresh the page if opened by window.open
        if ((sSelComp != null)  && (sSelComp != thisComp))
        {
            if (sSelComp == "PermissibleValue")
            {
              //seperate between crf search and other searches
              if (opener.document.getElementById("MenuAction") != null && opener.document.getElementById("MenuAction").value == "Questions")
                doSearchForCRF();
              else
                openSearchPVForCreate();  //doSearchForChange(); //keep the cd selected and submit form to get initial search
            }
            //preselect the context of the dec/VD and get all cds in this context
            else if (sSelComp == "ConceptualDomain")
              openSearchCDForCreate();
            //preselect the cd of the pv and get all vms in this cd
            else if (sSelComp == "ValueMeaning")
              openSearchVMForCreate();
            else
              doSearchForChange();
        }
        else
        {
          if ((sSelComp != null) && (sSelComp == "PermissibleValue")) //&& (opener.document.SearchActionForm.isValidSearch.value == "false"))
          {
            //seperate between crf search and other searches
            if (opener.document.getElementById("MenuAction") != null && opener.document.getElementById("MenuAction").value == "Questions")
              doSearchForCRF();
            else 
              openSearchPVForCreate();   //keep the cd selected and do initial search 
              
            //var sIndex = opener.document.createVDForm.selConceptualDomain.selectedIndex;
            var CDID = opener.document.getElementById("selConceptualDomain")[0].value;
            var cdName =  opener.document.getElementById("selConceptualDomain")[0].text;
            var cdContext =  opener.document.SearchActionForm.CDVDcontext.value;
            //only reset cd filter if different after the search 
            if ((opener.document.SearchActionForm.isValidSearch.value == "false") || (cdContext == "different"))
            {
              if (document.searchParmsForm.listCDName != null)
              {
                document.searchParmsForm.listCDName.value = CDID;

                //remove all other cds from the drop down if cd and vd contexts are different
                if (cdContext == "different")
                {
                  document.searchParmsForm.listCDName[0].value = CDID;
                  document.searchParmsForm.listCDName[0].text = cdName;
                  document.searchParmsForm.listCDName.length = 1;
                  document.searchParmsForm.CDVDContext.value = "different";
                }
              }  
            } 
          }
          //preselect the context of the dec/VD and get all cds in this context
          else if ((sSelComp != null) && sSelComp == "ConceptualDomain")
          {
            //document.searchParmsForm.listSearchFor[0].value = sSelComp;
            openSearchCDForCreate();
          }          
          //preselect the cd of the pv and get all vms in this cd
          else if ((sSelComp != null) && sSelComp == "ValueMeaning")
              openSearchVMForCreate();
              
          else if ((sSelComp != null) && sSelComp == "DataElement")  //for DDE
              openSearchDEForCreate();

          //remove the keyword if reopened the window again
          else
          {
            if (opener.document != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
            {
                opener.document.SearchActionForm.isValidSearch.value = "true";
                if (document.searchParmsForm.keyword != null)
                    document.searchParmsForm.keyword.value = "";
            }
          }
       }
    }
  }
  
  //Handle search PV for create/edit VD
  function openSearchPVForCreate()
  {
      //refresh the page first time it opened
      if (opener.document != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
      {
        //get the selected conceptual domain from the vd page
        var SelCD = opener.document.getElementById("selConceptualDomain").options[0].value;
        if (SelCD != null)
          document.searchParmsForm.selCDID.value = SelCD;

        opener.document.SearchActionForm.isValidSearch.value = "true";
        doSearchForChange();  //submit the form
      }
  }

  //Handle search CD for create/edit
  function openSearchCDForCreate()
  {
      //refresh the page first time it opened
      if (opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
      {
        //get the selected context from the dec/vd page
        var SelContext = opener.document.SearchActionForm.SelContext.value;
        //make that context selected for the search
        if (document.searchParmsForm.listMultiContextFilter != null)
        {
          //select all contexts if no context is selected on dec/vd pages
          if (SelContext == null || SelContext == "")
            document.searchParmsForm.listMultiContextFilter.options[0].selected = true;
          else
          {
            //loop to get the matching context and select it
            for (i=0; i < document.searchParmsForm.listMultiContextFilter.length; i++)
            {
              if (document.searchParmsForm.listMultiContextFilter.options[i].text == SelContext)
              {
                 document.searchParmsForm.listMultiContextFilter.options[0].selected = false;
                 document.searchParmsForm.listMultiContextFilter.options[i].selected = true;
                // break;
              }
              else
                 document.searchParmsForm.listMultiContextFilter.options[i].selected = false;
            }
          }
          opener.document.SearchActionForm.isValidSearch.value = "true";
        }
        else
          opener.document.SearchActionForm.isValidSearch.value = "false";  //resubmit to get the context
        
        doSearchForChange();  //submit the form
      }
  }
 
  //Handle search VM for create/edit
  function openSearchVMForCreate()
  {
      //refresh the page first time it opened
      if (opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
      {
        //get the selected context from the dec/vd page
        var SelCDid = opener.document.SearchActionForm.SelCDid.value;
        //make that context selected for the search
        if (document.searchParmsForm.listCDName != null)
        {
          //select all cds if no cd is selected on create pv pages
          if (SelCDid == null || SelCDid == "")
            document.searchParmsForm.listCDName.options[0].selected = true;
          else
          {
            //loop to get the matching context and select it
            for (i=0; i < document.searchParmsForm.listCDName.length; i++)
            {
              if (document.searchParmsForm.listCDName.options[i].value == SelCDid)
              {
                 document.searchParmsForm.listCDName.options[i].selected = true;
                 break;
              }
            }
          }
          opener.document.SearchActionForm.isValidSearch.value = "true";
        }
        else
        {
          //get the selected conceptual domain from the pv page
          if (SelCDid != null)
            document.searchParmsForm.selCDID.value = SelCDid;
          opener.document.SearchActionForm.isValidSearch.value = "false";  //resubmit to get the context
        }  
        doSearchForChange();  //submit the form
      }
  }
 
  //Handle search DDE for create/edit
  function openSearchDEForCreate()
  {
      if (opener.document.newCDEForm != null && opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch.value == "false")
      {
          opener.document.SearchActionForm.isValidSearch.value = "true";
          doSearchForChange();  //submit the form
      }
  }

  //clear the text box of the date fields
  function clearDate(dateType)
  { 
    if (dateType == 'createdFrom')
      document.searchParmsForm.createdFrom.value = "";
    else if (dateType == 'createdTo')
      document.searchParmsForm.createdTo.value = "";
    else if (dateType == 'modifiedFrom')
      document.searchParmsForm.modifiedFrom.value = "";
    else if (dateType == 'modifiedTo')
      document.searchParmsForm.modifiedTo.value = "";
  }

  //enable other radio button when version text box is entered.
  function enableOtherVersion()
  {
    var txVer = document.searchParmsForm.tVersion.value;
    if (txVer != null && txVer != "")
    {
      //alert("finite " + isFinite(txVer) + "parse " + parseFloat(txVer) + "nan " + isNaN(txVer));
      if (isNaN(txVer))
      {
        if (txVer == ".")
          document.searchParmsForm.tVersion.value = "0.";
        else
        {
          alert("Version filter must be a positive number");
          txVer = txVer.substring(0, txVer.length -1);
          document.searchParmsForm.tVersion.value = txVer;
        }
      }
    }
    document.searchParmsForm.rVersion[2].checked = true;
  }
  
  //remove the other text when all or latest was selected
  function removeOtherText()
  {
    if (document.searchParmsForm.tVersion != null)
      document.searchParmsForm.tVersion.value = "";
  }
    //do conceptual domain searh for dec or vd search
  function doCDSearch()
  {
    document.SearchActionForm.searchComp.value = "ConceptualDomain";
    document.SearchActionForm.isValidSearch.value = "false";
    var anotherSearchWindow = null;
    if (anotherSearchWindow && !anotherSearchWindow.closed)
      anotherSearchWindow.close()
    anotherSearchWindow = window.open("jsp/OpenSearchWindow2.jsp", "AnothersearchWindow", "width=975,height=570,top=0,left=0,resizable=yes,scrollbars=yes")
    anotherSearchWindow.alert("inside search window");
   
  }
  
  // check to see if input is whitespace only or empty
function isEmpty(val)
{
if (val.match(/^\s+$/) || val == "")
{
return true;
}
else
{
return false;
} 
}

function testIsValidObject(objToTest) {
		if (null == objToTest) {
			return false;
		}
		if ("undefined" == typeof(objToTest) ) {
			return false;
		}
		return true;

	}

//check if the user is performing a default search or he/she has selected any search criteria
function checkIfDefaultSearch(numOfDefaultContexts){

 var validObj = testIsValidObject(document.searchParmsForm.keyword)  
 if(validObj)
     var cond1 = (document.searchParmsForm.keyword.value==null || isEmpty(document.searchParmsForm.keyword.value));
  
 validObj = testIsValidObject(document.searchParmsForm.listMultiContextFilter)
 if(validObj) {
  		//cond1 = cond1 &&  document.searchParmsForm.listMultiContextFilter.value == "AllContext";
  		var selectedlistMultiContext = getSelections(document.searchParmsForm.elements["listMultiContextFilter"]);	
		cond1 = cond1 &&  selectedlistMultiContext.length == numOfDefaultContexts;
  	}

 validObj = testIsValidObject(document.searchParmsForm.enumBox)
 if(validObj) 
  	cond1 = cond1 &&  document.searchParmsForm.enumBox.checked == false; 
 
 validObj = testIsValidObject(document.searchParmsForm.nonEnumBox)
 if(validObj) 
  	cond1 = cond1 &&  document.searchParmsForm.nonEnumBox.checked == false;  	
    
 validObj = testIsValidObject(document.searchParmsForm.listCDName)
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.listCDName.value == "All Domains"; 	
  
 validObj = testIsValidObject(document.searchParmsForm.listStatusFilter)
 if(validObj) { 
    if(document.searchParmsForm.listSearchFor.value=="ConceptClass")
   	cond1 = cond1 && document.searchParmsForm.listStatusFilter.value == "RELEASED";
   	else
   	cond1 = cond1 && document.searchParmsForm.listStatusFilter.value == "AllStatus";
   }	

 validObj = testIsValidObject(document.searchParmsForm.listRegStatus)
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.listRegStatus.value == "allReg";				      
  	
 validObj = testIsValidObject(document.searchParmsForm.listDeriveType)
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.listDeriveType.value=="allDer";
  	
 validObj = testIsValidObject(document.searchParmsForm.createdFrom)	
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.createdFrom.value == " "; 		        
  	
 validObj = testIsValidObject(document.searchParmsForm.createdTo)	
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.createdTo.value == " "; 
  	
 validObj = testIsValidObject( document.searchParmsForm.creator)	
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.creator.value == "allUsers"; 
  	
 validObj = testIsValidObject( document.searchParmsForm.modifiedFrom)	
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.modifiedFrom.value == " " ;
  	
 validObj = testIsValidObject( document.searchParmsForm.modifiedTo)	
 if(validObj) 
     cond1 = cond1 && document.searchParmsForm.modifiedTo.value == " " ;
  	
 validObj = testIsValidObject(document.searchParmsForm.modifier)	
 if(validObj) 
    cond1 = cond1 && document.searchParmsForm.modifier.value == "allUsers"; 
 		
 validObj = testIsValidObject(document.searchParmsForm.listCSName)	
 if(validObj) 
    cond1 = cond1 && document.searchParmsForm.listCSName.value == "AllSchemes";
    	
 if(cond1){
     return true;
  }
  else{
    return false;
   }
}


function selectedContextsfunction(elm)
{
var listMultiContext = elm.searchParmsForm.elements["listMultiContextFilter"];
var selectedlistMultiContext = getSelections(listMultiContext);
var allValues=new Array(); 
// test run through of returned array
for(var k=0;k<selectedlistMultiContext.length;k++){
allValues[k] = selectedlistMultiContext[k].value;
}
//alert(allValues);
return allValues;
}

// returns references to the
// actual option elements (not values)
function getSelections(select)
{
var options = select.options,
sOptions = [],
opt, k=0;
while(opt = options[k++])
if(opt.selected)
sOptions[sOptions.length] = opt
return sOptions
} 
