<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/SearchParametersBlocks.jsp,v 1.19 2007-01-24 06:12:18 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import= "java.util.*" %>
<%@ page buffer= "12kb" %>
<%@ page session="true" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>
<html>
<head>
<title>Search Parameters</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/SearchParameters.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
   Session_Data sessionData = (Session_Data) session.getAttribute(Session_Data.CURATION_SESSION_ATTR);
   String sMenuAction = (String)session.getAttribute("MenuAction");
  // String ac = (String)session.getAttribute("parentAC");
  // String sMetaCode = "No";
  // Vector vStatus = new Vector();
 // System.out.println(" variable " + (String)request.getParameter("listSearchFor"));
   String strHTML = (String)session.getAttribute("strHTML");
  if (strHTML == null) strHTML = "";
   //session attributes of the dropdown lists and filter defaults
   Vector vContext = (Vector)session.getAttribute("vContext");
   if (vContext == null) vContext = new Vector();
   Vector vStatusAll = (Vector)session.getAttribute("vStatusALL");
   if (vStatusAll == null) vStatusAll = new Vector();
   Vector vBlockAttr = (Vector)session.getAttribute("creAttributeList");
   if (vBlockAttr == null) vBlockAttr = new Vector();
 //  Vector vDsrSearchIn = (Vector)session.getAttribute("dsrSearchIn");
 //  if(vDsrSearchIn == null) vDsrSearchIn = new Vector();
   EVS_UserBean usrBean = (EVS_UserBean)sessionData.EvsUsrBean; //(EVS_UserBean)session.getAttribute("EvsUserBean");
   if (usrBean == null) usrBean = new EVS_UserBean();
   Vector vVocab = usrBean.getVocabNameList();   //(Vector)session.getAttribute("dtsVocabNames");  //list of vocabulary names
   if (vVocab == null) vVocab = new Vector();
   Vector vVocabDisplay = usrBean.getVocabDisplayList();  // (Vector)session.getAttribute("dtsVocabDisplay");  //list of vocabulary display names
   if (vVocabDisplay == null) vVocabDisplay = new Vector();
  
   String dtsVocab = (String)session.getAttribute("dtsVocab");  //selected vocab
   if (dtsVocab == null && vVocab != null && vVocab.size() > 0)  //take first one in the list if not selected
      dtsVocab = (String)vVocab.elementAt(0);
   else if (dtsVocab == null) dtsVocab = "";  //"Thesaurus/Metathesaurus";  //hard code it only if doesn't exist.
   //get the vocab specific attributes
   Hashtable hVoc = (Hashtable)usrBean.getVocab_Attr();
   if (hVoc == null) hVoc = new Hashtable();
   EVS_UserBean vocBean = null;
   if (hVoc.containsKey(dtsVocab))
     vocBean = (EVS_UserBean)hVoc.get(dtsVocab);
   if (vocBean == null) 
     vocBean = (EVS_UserBean)sessionData.EvsUsrBean; //(EVS_UserBean)session.getAttribute("EvsUserBean");
   String optName = vocBean.getSearchInName();
   if (optName == null) optName = "";
   String optConCode = vocBean.getSearchInConCode();
   if (optConCode == null) optConCode = "";
   String optMetaCode = vocBean.getSearchInMetaCode();
   if (optMetaCode == null) optMetaCode = "";
//System.out.println("jsp " + dtsVocab + optName + optConCode + optMetaCode);
   String sRetSearch = vocBean.getRetSearch();  // (String)session.getAttribute("RetSearch");
   if (sRetSearch == null) sRetSearch = "false";
   String sTreeSearch = vocBean.getTreeSearch();  //do not allow when the search is only meta
   if (sTreeSearch == null) sTreeSearch = "true";
   String metaInclude = vocBean.getIncludeMeta();
   if (metaInclude == null) metaInclude = "";
   Vector vSource = (Vector)session.getAttribute("MetaSources");
   if(vSource == null) vSource = new Vector();

   //get the selected search for session attributes
   String sSearchAC = (String)session.getAttribute("creSearchAC");
   if (sSearchAC == null) sSearchAC = "ObjectClass";
 
   //display names for the components
   if (sSearchAC.equals("PropertyClass") || sSearchAC.equals("VDPropertyClass")) 
      sSearchAC = "Property";
   String sLongAC = "";
   if (sSearchAC.equals("ObjectClass") || sSearchAC.equals("VDObjectClass"))
     sLongAC = "Object Class";
   else if (sSearchAC.equals("Property") || sSearchAC.equals("VDProperty"))
     sLongAC = "Property";
   else if (sSearchAC.equals("ObjectQualifier"))
     sLongAC = "Object Qualifier";
   else if (sSearchAC.equals("PropertyQualifier"))
     sLongAC = "Property Qualifier";
   else if (sSearchAC.equals("RepQualifier"))
     sLongAC = "Rep Qualifier";
   else if (sSearchAC.equals("RepTerm"))
     sLongAC = "Rep Term";
   else if (sSearchAC.equals("EVSValueMeaning") 
          || sSearchAC.equals("CreateVM_EVSValueMeaning")
         // || sSearchAC.equals("VMConcept")
          || sSearchAC.equals("PV_ValueMeaning"))
     sLongAC = "Value Meaning";
   else if (sSearchAC.equals("VMConcept"))
     sLongAC = "Concept";
   else if (sSearchAC.equals("ParentConcept"))
     sLongAC = "Parent Concept";
   else if (sSearchAC.equals("ParentConceptVM"))
   {
     sLongAC = "Value Meaning";
     String vdType = (String)session.getAttribute("pageVDType");
     if (vdType != null && vdType.equals("N"))
       sLongAC = "Parent Concept";
   }

   //get the session attributes
   //cadsr search selected attributes
   String sLastKeyword = (String)request.getAttribute("creKeyword");
   if (sLastKeyword == null) sLastKeyword = "";
   sLastKeyword = sLastKeyword.trim();
   String sContext = (String)session.getAttribute("creContextBlocks");
   if (sContext == null) sContext = "All Contexts";
   String sSearchIn = (String)session.getAttribute("creSearchInBlocks");
   if (sSearchIn == null) sSearchIn = "longName";
   String sStatus = (String)session.getAttribute("creStatusBlocks");
   if (sStatus == null || sStatus.equals("")) sStatus = "RELEASED";
   //evs search selected attributes
   String sRetired = (String)session.getAttribute("creRetired");
   if (sRetired == null) sRetired = "Exclude";
   String sSearchInEVS = (String)session.getAttribute("SearchInEVS");
   if (sSearchInEVS == null) sSearchInEVS = "Synonym";
 //  if(sSearchInEVS.equals("MetaCode")) sMetaCode = "Yes";
   String sMetaSource = (String)session.getAttribute("MetaSource");
   if (sMetaSource == null) sMetaSource = "All Sources";
   String sMetaLimit = "100";
 //  String sVersion = (String)session.getAttribute("sVersion");
 //  if (sVersion == null) sVersion = "";
   String sUISearchType = (String)request.getAttribute("UISearchType");
   if (sUISearchType == null || sUISearchType.equals("nothing") || sUISearchType.equals(""))  //? || dtsVocab.equals("NCI Metathesaurus")) 
    sUISearchType = "term";
   String sOpenTreeToConcept = (String)request.getAttribute("OpenTreeToConcept");
   if (sOpenTreeToConcept == null || sOpenTreeToConcept.equals("")) sOpenTreeToConcept = "false";
   Vector vSelectedAttr = (Vector)session.getAttribute("creSelectedAttr");
   if ( vSelectedAttr == null) vSelectedAttr = new Vector();

  //get the seleected displayable attributes
//  Vector vSelDispAttr = (Vector)session.getAttribute("creSelectedAttr");
//  if (vSelDispAttr == null) vSelDispAttr = new Vector();
  //get the search result records
  Vector vSerResult = (Vector)session.getAttribute("results");
  boolean hasRecords = false;
  if (vSerResult != null && vSerResult.size() >0) hasRecords = true;
  String updFunction = "displayAttributes('" + hasRecords + "');";
//System.out.println("jsp " + updFunction);  
  int iItem = 1;
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
  //submits the page if Vocab changed.
  function doVocabChange()
  {
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = "doVocabChange";
    document.searchParmsForm.listSearchFor[0].selected = true;     
    if (document.searchResultsForm != null)
      document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.submit();
  }

  function populateCaDSRSearchIn()
  {  
     var selIdx = document.searchParmsForm.listSearchInEVS.selectedIndex;
     if (document.searchParmsForm.listSearchIn != null)
     {
       if (selIdx > 0) selIdx = selIdx + 1;
       if (document.searchParmsForm.listSearchIn[selIdx] != null)
         document.searchParmsForm.listSearchIn[selIdx].selected = true;
     }
  }

  function populateEVSSearchIn()
  {
     var selIdx = document.searchParmsForm.listSearchIn.selectedIndex;
     if (selIdx > 1) selIdx = selIdx - 1;
     if (document.searchParmsForm.listSearchInEVS[selIdx] != null)
        document.searchParmsForm.listSearchInEVS[selIdx].selected = true;
  }

  function Setup()
  {
    //check if newly opened
 // alert("parameter setup ");
    getCompCreate();
    var actSelect = "";
    var isSearched = "false";
    var isSubmit = false;
    if (opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch != null)
      isSearched = opener.document.SearchActionForm.isValidSearch.value;
    if(isSearched != null && isSearched == "false")
    {
       hourglass();
       window.status = "Displaying selected attributes, it may take a minute, please wait....."
       document.searchParmsForm.actSelect.value = "FirstSearch";
       var thisblock = opener.document.SearchActionForm.searchComp.value;
       document.searchParmsForm.listSearchFor[0].value = thisblock;
       document.searchParmsForm.listSearchFor[0].text = thisblock;
       opener.document.SearchActionForm.isValidSearch.value = "true";
       //document.searchParmsForm.submit();
       //isSubmit = true;
    } 
    isSubmit = doOpenTreeSubmitAction();    //call the function to open the tree
 //   alert(isSubmit + " : " + document.searchParmsForm.actSelect.value + " : " + document.searchParmsForm.openToTree.value);
    if (isSearched == "false" || isSubmit == true)
    {
      window.status = "Submitting the page, please wait.....";
      if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
// alert("here before submit");
      document.searchParmsForm.submit();
    }
    //focus to the keyword if not null
    if(document.searchParmsForm.keyword != null)
      document.searchParmsForm.keyword.focus();
  }
  
  function doOpenTreeSubmitAction()
  {
    var actSelect = "";
    <% if(sSearchAC.equals("ParentConceptVM")) {%>
      if(opener.document != null)
      {      	
        if(opener.document.getElementById("selectedParentConceptCode") != null && 
        			opener.document.getElementById("selectedParentConceptCode").value != "")
        {
          var code = opener.document.getElementById("selectedParentConceptCode").value;
          var name = opener.document.getElementById("selectedParentConceptName").value
          var db = opener.document.getElementById("selectedParentConceptDB").value
          actSelect = opener.document.getElementById("actSelect").value
          document.searchParmsForm.sCCodeDB.value = db;
          document.searchParmsForm.sCCode.value = code;
          document.searchParmsForm.sCCodeName.value = name;
          document.searchParmsForm.actSelect.value = actSelect;
        }
        if(document.searchParmsForm.actSelect.value == "OpenTreeToParentConcept")  
        {
            window.status = "Submitting the page, please wait.....";
            if (document.searchResultsForm != null)
              document.searchResultsForm.Message.style.visibility="visible";
            document.searchParmsForm.openToTree.value = "true";
            if(opener.document != null)
            {
              opener.document.getElementById("selectedParentConceptCode").value = "";
              opener.document.getElementById("selectedParentConceptName").value = ""; 
              opener.document.getElementById("selectedParentConceptDB").value = "";
            }
           // document.searchParmsForm.submit();
           return true;
        }
      }
    <% }%>
    if(document.searchParmsForm.openToTree != null && document.searchParmsForm.openToTree.value == "true" && actSelect != "OpenTreeToParentConcept")
    {
      window.status = "Submitting the page, please wait.....";
      if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
      document.searchParmsForm.actSelect.value = "OpenTreeToConcept";
      var idx = document.searchParmsForm.listContextFilterVocab.selectedIndex;
      document.searchParmsForm.listContextFilterVocab[idx].text = document.searchParmsForm.sCCodeDB.value;
     // document.searchParmsForm.submit();
      return true;
    }    
    return false;
  }
  
  
function keypress_handler()
{
    var keycode = window.event.keyCode;
    if(keycode != 13)
    {
        return true;  // only interest on return kay
    }
    //make sure tool does not submitthe search  by key press if use selection is enabled or keyword is empty.
    if (document.searchParmsForm.keyword == null || document.searchParmsForm.keyword.value == null 
    	|| document.searchParmsForm.keyword.value == "" || 
    	(document.searchResultsForm.editSelectedBtn != null && !document.searchResultsForm.editSelectedBtn.disabled))
    {
        alert("Please use the pointer to select the desired action.");
    		return false;
    }
    //check if it is valid for search
    if(document.searchParmsForm.listSearchInEVS != null && document.searchParmsForm.listSearchInEVS.value == "MetaCode")
    {
      var sTerm = document.searchParmsForm.keyword.value;
      if (sTerm == null) sTerm = "";
      if(document.searchParmsForm.listContextFilterSource.value == "All Sources" || sTerm == "")
      {
        alert("This type of search will search the Metathesaurus only. \n"
        + "The search term should be a code; for example, a LOINC code. \n"
        + "Please select a Meta Concept Source to filter by and enter a search term. ");
        return false;
      }
    }
    // all other case go to servlet to search
    <% if (sMenuAction.equals("searchForCreate")) { %>
        if (opener && opener.document != null && opener.document.SearchActionForm != null)
          opener.document.SearchActionForm.isValidSearch.value = "true";
    <% } %>
    hourglass();
    window.status = "Searching Keyword, it may take a minute, please wait....."
    document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.actSelect.value = "Search";
    markVMConceptOrder("Search");
    document.searchParmsForm.submit();
    return false;
}

function LoadKeyHandler()
{
    document.onkeypress = null;
    document.onkeypress = keypress_handler;
}

 //submits the page to start the search  
    function doSearchBuildingBlocks()
    {
      if(document.searchParmsForm.listSearchInEVS != null && document.searchParmsForm.listSearchInEVS.value == "MetaCode")
      {
      	var sTerm = document.searchParmsForm.keyword.value;
      	if (sTerm == null) sTerm = "";
        if(document.searchParmsForm.listContextFilterSource.value == "All Sources" || sTerm == "")
        {
           alert("This type of search will search the Metathesaurus only. \n"
        + "The search term should be a code; for example, a LOINC code. \n"
        + "Please select a Meta Concept Source to filter by and enter a search term. ");
          return false;
        }
      } 
      for (i=0; i<document.searchParmsForm.listAttrFilter.length; i++)
      {
        document.searchParmsForm.listAttrFilter.options[i].selected = true;
      }
      if (opener && opener.document != null && opener.document.SearchActionForm != null)
			opener.document.SearchActionForm.isValidSearch.value = "true";
	    hourglass(); 
      window.status = "Searching Keyword, it may take a minute, please wait....."
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchParmsForm.actSelect.value = "Search";
      markVMConceptOrder("Search");
      document.searchParmsForm.submit();
    }

	//mark if primary vm search
	function markVMConceptOrder(actionType)
	{
		if (actionType == "Search" && opener.document != null)
		{
			var pv = opener.document.getElementById("currentPVInd");
			if (pv != null)
			{
				var pvId = pv.value;
				var curTbl = opener.document.getElementById(pvId + "TBL");
				if (curTbl != null)
				{
			  	var totalCon = curTbl.rows.length;
			  	//make sure the first row has data
			  	if (totalCon == 1 && curTbl.rows(0).cells(1) == null)
			  		totalCon = 0;
			  	document.getElementById("vmConOrder").value = totalCon;	
			  }
			}
		}
	}
//fuction to refresh the page for simple/advanced filter
function searchType(type)
{
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = type;
    if (document.searchResultsForm != null)
        document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.submit();
}

//fuction to search or expand or collapse tree
function doTreeAction(type, nodeCode, vocab, nodeName, nodeID, nodeLvl)
{
    var url = "";
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait.....";
    document.searchResultsForm.Message.style.visibility="visible";
//alert(type + nodeCode + vocab);
//alert(nodeName + nodeID);
  //  opener.document.SearchActionForm.searchComp.value = "<%=sSearchAC%>";
    if(type == 'search')
      url = "../../cdecurate/NCICurationServlet?reqType=treeSearch&&keywordID=" + nodeCode + "&&vocab=" + vocab + "&&keywordName=" + nodeName + "&&nodeID=" + nodeID + "&&nodeLevel=" + nodeLvl;
    else if(type == 'expand')
      url = "../../cdecurate/NCICurationServlet?reqType=treeExpand&&nodeName=" + nodeName + "&&vocab=" + vocab + "&&nodeCode=" + nodeCode + "&&nodeID=" + nodeID + "&&nodeLevel=" + nodeLvl;
    else if(type == 'collapse')
      url = "../../cdecurate/NCICurationServlet?reqType=treeCollapse&&nodeName=" + nodeName + "&&vocab=" + vocab + "&&nodeCode=" + nodeCode + "&&nodeID=" + nodeID + "&&nodeLevel=" + nodeLvl;
    document.searchParmsForm.action = url;
    window.status = "Submitting the page, please wait.....";
    if (document.searchResultsForm != null)
      document.searchResultsForm.Message.style.visibility="visible";
    document.searchParmsForm.submit();
}


//fuction to search or expand or collapse tree
function refreshTree(vocab)
{
    var url = "";
    window.status = "Refreshing the tree, it may take a minute, please wait.....";
    url = "../../cdecurate/NCICurationServlet?reqType=treeRefresh&&vocab=" + vocab;
    document.searchParmsForm.action = url;
    var conf = confirm("This link refreshes the tree. All expanded nodes are collapsed. Continue?");
    if(conf == true)
    {
      hourglass();
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchParmsForm.submit();
    }
}

//fuction to search or expand or collapse tree
function doMetaCodeSearch()
{
  hourglass();
  window.status = "Refreshing the page, it may take a minute, please wait....."
  document.searchParmsForm.actSelect.value = "MetaCodeSearch";
  window.status = "Submitting the page, please wait.....";
  if (document.searchResultsForm != null)
    document.searchResultsForm.Message.style.visibility="visible";
  document.searchParmsForm.submit();   
}

</SCRIPT>
</head>

<body onLoad="Setup();">
<form name="searchParmsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=searchBlocks">
  <table width="100%" class="sidebarBGColor"> <!-- style="position: relative; top: -22px;"> --> 
    <tr valign="top" align="left" class="firstRow">
      <th><%=iItem++%>) Search For:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;
        <select name="listSearchFor" size="1" style="width: 160"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="<%=sSearchAC%>"><%=sLongAC%></option>
        </select>
      </td>
  </tr>
  <%if(sSearchAC.equals("ParentConcept")){%>
    <tr valign="bottom" align="left" class="firstRow" height="22">
      <th><%=iItem++%>) Search Type:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;
      <input type="RADIO" value="EVS"  checked="checked" name="rRefType" onclick="javascript:changeType('EVS');">EVS
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="RADIO" value="Non EVS" name="rRefType" onclick="javascript:changeType('nonEVS');">Non EVS
      </td>
    </tr>
  <% } %>
    <tr valign="bottom" align="left" class="firstRow" height="22">
      <th><%=iItem++%>) Select EVS Vocabulary:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;
          <select name="listContextFilterVocab" size="1" style="width: 160" onChange="doVocabChange();"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
<%        if (vVocab != null)
          {
            for (int i = 0; vVocab.size()>i; i++)
            {
              String sVocab = (String)vVocab.elementAt(i);
              //do not add to the list if parent concept
              boolean isParSearch = usrBean.getVocabUseParent();
              EVS_UserBean vBean = (EVS_UserBean)hVoc.get(sVocab);
              if (vBean != null) isParSearch = vBean.getVocabUseParent();
       //   System.out.println(sVocab + isParSearch + " parent " + sSearchAC + (sSearchAC.equals("ParentConcept") && !isParSearch));
              if(sSearchAC.equals("ParentConcept") && !isParSearch)
                continue;
              //get its vocab display  
              String sVocabDisp = sVocab;
              if (vVocabDisplay != null && vVocabDisplay.size()>i)
                  sVocabDisp = (String)vVocabDisplay.elementAt(i);
           // System.out.println(sVocab + " jsp vocab " + sVocabDisp);
            //keep only the parent vocab in the drop down for select values from parent
              if (sSearchAC.equals("ParentConceptVM") && sVocab.equals(dtsVocab)) {
%>
                <option value="<%=sVocab%>" selected><%=sVocabDisp%></option>
<%            } else if (!sSearchAC.equals("ParentConceptVM")) {  %>
                <option value="<%=sVocab%>" <%if(sVocab.equals(dtsVocab)){%>selected<%}%>><%=sVocabDisp%></option>
<%            }
            }
         }
%>
        </select>
      </td>
  </tr>
   <tr>
      <th height="22" valign="bottom">
        <div align="left"><%=iItem++%>) Search In:   
          <!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->
        </div>
      </th>
  </tr>
  <% if(!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM")){%>
   <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>caDSR</b></td>
  </tr>
  <tr>
      <td>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;
          <select name="listSearchIn" size="1" style="width: 170" onChange="populateEVSSearchIn();"
            onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
            <option value="longName" <%if(sSearchIn.equals("longName")){%>selected<%}%>>Names and Definition</option>
            <option value="publicID" <%if(sSearchIn.equals("publicID")){%>selected<%}%>>Public ID</option>
            <option value="evsIdentifier" <%if(sSearchIn.equals("evsIdentifier")){%>selected<%}%>>EVS Identifier</option>
            <option value="Code" <%if(sSearchIn.equals("Code")){%>selected<%}%>>None</option>
          </select>
        </p>
     </td>
  </tr>
  <% } %>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>EVS</b>
    	<% if (sTreeSearch.equals("true")) { %>
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
              <%if (sUISearchType.equals("term") && !sSearchAC.equals("ParentConceptVM")) {%>
                  <a href="javascript:searchType('tree');">Tree Search</a>
              <%} else if(!sSearchAC.equals("ParentConceptVM")){%> 
                  <a href="javascript:searchType('term');">Term Search</a><%}%>   
      <% } %>     
    </td>
  </tr>
  <tr>
      <td>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;    
          <select name="listSearchInEVS" size="1" style="width: 170" onChange="populateCaDSRSearchIn();"
            onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
  <%        if (optName != null && !optName.equals("") && !sSearchAC.equals("ParentConceptVM")) { %>
                <option value="Name"  <%if (sSearchInEVS.equals("Name")){%>selected<%}%>><%=optName%></option>
  <%        } if (optConCode != null && !optConCode.equals("")) { %>
                <option value="ConCode"  <%if (sSearchInEVS.equals("ConCode")){%>selected<%}%>><%=optConCode%></option>
  <%        } if (optMetaCode != null && !optMetaCode.equals("") && !sSearchAC.equals("ParentConceptVM")) { %>
                <option value="MetaCode"  <%if (sSearchInEVS.equals("MetaCode")){%>selected<%}%>><%=optMetaCode%></option>
  <%        }   %>
          </select>        
        </p>
     </td>
  </tr>
<%if (sUISearchType.equals("term")) {%>
  <tr>
      <th height="22" valign="bottom">
        <div align="left"><%=iItem++%>) Enter Search Term:</div>
      </th>
  </tr>
  <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="text" name="keyword" size="22" style="width: 160" value=""
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
      </td>
  </tr>
  <tr>
    <td>
      <div align="left" title="The wildcard character, *, expands the search to find a non-exact match.">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;use * as wildcard
      </div>
    </td>
  </tr>
  <tr>
      <th height="22" valign="bottom">
        <div align="left"><%=iItem++%>) Filter Search By:</div>
      </th>
  </tr>
<% if (!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM")){%> 
   <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>caDSR</b></td>
  </tr>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Owned By/Used By</td>
  </tr>
  <tr>
    <td>
      <p>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <select name="listContextFilter" size="1" style="width: 160"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="AllContext"  <%if(sContext.equals("All Contexts")){%>selected<%}%>>All Contexts</option>
<%
          if (vContext != null)
          {
            for (int i = 0; vContext.size()>i; i++)
            {
              String sContextName = (String)vContext.elementAt(i);
%>
              <option value="<%=sContextName%>"  <%if(sContextName.equals(sContext)){%>selected<%}%>><%=sContextName%></option>
<%
            }
          }
%>
        </select>
      </p>
    </td>
  </tr>
  <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Workflow Status</td>
  </tr>
  <tr>
    <td>
      <p>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <select name="listStatusFilter" multiple size="2" style="width: 160"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="RELEASED" <% if(sStatus.equalsIgnoreCase("RELEASED")) {%>selected<%}%>>RELEASED</option>
          <option value="AllStatus" <% if(sStatus.equalsIgnoreCase("AllStatus")) {%>selected<%}%>>All Statuses</option>
        </select>
      </p>
    </td>
  </tr>
  <% } %>
<%if((sRetSearch.equalsIgnoreCase("true") || !metaInclude.equals("")) && !sSearchAC.equals("ParentConceptVM")) { %>
   <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>EVS</b></td>
  </tr>
<%if(sRetSearch.equalsIgnoreCase("true")) { %>
   <tr>
      <td style="height:20"  valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Retired Concepts</td>
    </tr>
    <tr>
   <td align=left >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" name="rRetired" value="Exclude" <%if(sRetired.equals("Exclude")){%> checked <%}%>
              onHelp = "showHelp('Help_SearchAC.html#searchParmsForm_SearchParameters'); return false">
          Exclude&nbsp;
          <input type="radio" name="rRetired" value="Include" <%if(sRetired.equals("Include")){%> checked <%}%>
          onHelp = "showHelp('Help_SearchAC.html#searchParmsForm_SearchParameters'); return false">
          Include&nbsp;
        
      </td>
  </tr>
<% } %>
<%if(!metaInclude.equals("")) { %>
  <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Meta Concept Source</td>
  </tr>
  <tr>
    <td>
      <p>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <select name="listContextFilterSource" size="1" style="width: 160"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="All Sources"  <%if(sMetaSource.equals("All Sources")){%>selected<%}%>>All Sources</option>
<%
          if (vSource != null)
          {
            for (int i = 0; vSource.size()>i; i++)
            {
              String sSourceName = (String)vSource.elementAt(i);
%>
              <option value="<%=sSourceName%>"  <%if(sSourceName.equals(sMetaSource)){%>selected<%}%>><%=sSourceName%></option>
<%
            }
         }
%>
        </select>
      </p>
    </td>
 
    <tr>
    	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Set Meta Returns Limit</td>
  	</tr>
  	<tr>
      <td>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;
          <select name="listMetaLimit" size="1" style="width: 160"
            onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
            <option value="100" <%if(sMetaLimit.equals("100")){%>selected<%}%>>100</option>
            <option value="250" <%if(sMetaLimit.equals("250")){%>selected<%}%>>250</option>
            <option value="500" <%if(sMetaLimit.equals("500")){%>selected<%}%>>500</option>
            <option value="750" <%if(sMetaLimit.equals("750")){%>selected<%}%>>750</option>
          <!--  <option value="1000" <%if(sMetaLimit.equals("1000")){%>selected<%}%>>1000</option> -->
          </select>
        </p>
     </td>
  </tr>
 <%} }%>
  
<tr height="5"></tr>
  <tr>
    <td class="dashed-black">
      <div align="left"><b><%=iItem++%>) Display Attributes:</b>
        &nbsp;&nbsp;<input type="button" name="updateDisplayBtn" value="Update" onClick="<%=updFunction%>"  style="width:50"
        onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_displayAttributes'); return false">
      </div>
      <br>
      <div align="center">
        <select name="listAttrFilter" size="5" style="width: 160" multiple
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_displayAttributes'); return false">
        <% if (vBlockAttr != null)
          {
            for (int i = 0; i < vBlockAttr.size(); i++)
            {
              String sAttr = (String)vBlockAttr.elementAt(i);
        %>
              <option value="<%=sAttr%>" <% if (vSelectedAttr != null && vSelectedAttr.contains(sAttr)){ %>selected<% } %>><%=sAttr%></option>
        <%
            }
             //add all attributes if not existed
            if (!vBlockAttr.contains("All Attributes")) 
            {
%>
             <option value="All Attributes">All Attributes</option>
<%
            }
          }
%>      
        </select>
      </div>
    </td>
  </tr>
  <tr>
    <td height="33" valign="bottom">
      <div align="center">
        <input type="button" name="startSearchBtn" value="Start Search" onClick="doSearchBuildingBlocks();"  style="width: 150; height: 30"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
      </div>
	 </td>
  </tr>
 <%}%>
  <%if (sUISearchType.equals("tree")) { %> 
   <tr>
      <th height="22" valign="bottom">
        <div align="left"><%=iItem++%>) Click Concept To Search:</div>
      </th>
  </tr>
  <tr>
    <td> <%=strHTML%></td>
  </tr>
<% } %>
  <tr>   <td>
  <input type="hidden" name="actSelect" value="Search" style="visibility:hidden;">
  <input type="hidden" name="vmConOrder" value="0">
  <input type="hidden" name="sCCodeDB" value="">
  <input type="hidden" name="sCCode" value="">
  <input type="hidden" name="sCCodeName" value="">
  <input type="hidden" name="openToTree" value=""> 
  <input type="hidden" name="sConteIdseq" value="">
	 </td>  </tr>  
</table>

<script language = "javascript">
LoadKeyHandler();
</script>
</form>
</body>
</html>
