// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/VDPVS.js,v 1.6 2009-01-06 21:04:06 veerlah Exp $
// $Name: not supported by cvs2svn $


 var altWindow = "";

 function SearchCDValue()
 {
 	var contObj = document.getElementById('selContext');
 	var contText = "";
 	if (contObj != null)
    	contText = contObj[contObj.selectedIndex].text;
 //   var vAction = document.getElementById('VDAction').value;
 //   if (contObj[selIdx].text == "" && vAction != "BlockEdit")
 //     alert("Please select a context first");
 //   else
 //   {
      document.SearchActionForm.searchComp.value = "ConceptualDomain";
      document.SearchActionForm.SelContext.value = "";  //contText contObj.options[contObj.selectedIndex].text;   //get the context 
      document.SearchActionForm.isValidSearch.value = "false";

      if (searchWindow && !searchWindow.closed)
        searchWindow.close()
      searchWindow = window.open("jsp/OpenSearchWindow.jsp", "searchWindow", "width=775,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
 //   }
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

 	var refObj = document.getElementById('btnRefDoc');
 	if (refObj != null)
    	refObj.disabled = true;
 }
 
  function openBEDisplayWindow()
  {
    var evsWindow = "";
    if (evsWindow && !evsWindow.closed)
      evsWindow.focus();
    else
    {
      evsWindow = window.open("jsp/OpenBlockEditWindow.jsp", "BEWindow", "width=750,height=350,top=0,left=0,resizable=yes,scrollbars=yes");
    }
  }

  //open alternate names reference document window
  function openDesignateWindowVM(sType, vmID)
  {
    if (altWindow && !altWindow.closed)
      altWindow.close();
    document.SearchActionForm.isValidSearch.value = "false";  
    document.SearchActionForm.itemType.value = sType
 // alert(" depage " + sType);
    //var windowW = screen.width - 410;
    if (sType == "Alternate Names")
        altWindow = window.open("../../cdecurate/NCICurationServlet?reqType=AltNamesDefs&searchEVS=ValueMeaning" + "&vmID=" + vmID, "designate", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
    else
        altWindow = window.open("jsp/EditDesignateDE.jsp", "designate", "width=700,height=650,top=0,left=0,resizable=yes,scrollbars=yes");
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
 
 //change the tabs
 function changeTab(tab)
 {
   if(tab == "PV"){
      document.createVDForm.action = "../../cdecurate/NCICurationServlet?reqType=viewVDPVSTab&vdpvstab=" +tab;
      document.createVDForm.submit();	
   }else if (tab == "VD"){
      document.PVForm.action = "../../cdecurate/NCICurationServlet?reqType=viewVDPVSTab&vdpvstab=" +tab;
      document.PVForm.submit();	
   } 
 
 }