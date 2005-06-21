
<%@ page import= "java.util.*" %>
<%@ page buffer= "12kb" %>
<%@ page session="true" %>
<html>
<head>
<title>Search Parameters</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/SearchParameters.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
   Vector vSelectedAttr = new Vector();
   String sMenuAction = (String)session.getAttribute("MenuAction");
   String ac = (String)session.getAttribute("parentAC");
   String sMetaCode = "No";
   Vector vStatus = new Vector();
   String strHTML = (String)session.getAttribute("strHTML");

   //get the session attributes
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
          || sSearchAC.equals("PV_ValueMeaning"))
     sLongAC = "Value Meaning";
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
   String sLastKeyword = (String)request.getAttribute("creKeyword");
   if (sLastKeyword == null) sLastKeyword = "";
   sLastKeyword = sLastKeyword.trim();
   String sContext = (String)session.getAttribute("creContextBlocks");
   if (sContext == null) sContext = "All Contexts";
   //Vector vStatus = (Vector)session.getAttribute("creStatusBlocks");
   String sRetired = (String)session.getAttribute("creRetired");
   if (sRetired == null) sRetired = "Exclude";
   String sSearchIn = (String)session.getAttribute("creSearchInBlocks");
   if (sSearchIn == null) sSearchIn = "longName";
   String sSearchInEVS = (String)session.getAttribute("SearchInEVS");
   if (sSearchInEVS == null) sSearchInEVS = "Synonym";
   if(sSearchInEVS.equals("Code")) sMetaCode = "Yes";
   String sMetaSource = (String)session.getAttribute("MetaSource");
   if (sMetaSource == null) sMetaSource = "All Sources";
   String dtsVocab = (String)session.getAttribute("dtsVocab");
//System.out.println("spb dtsVocab: " + dtsVocab);
   if (dtsVocab == null || dtsVocab.equals("NCI_Thesaurus")) 
    dtsVocab = "Thesaurus/Metathesaurus";
   if (dtsVocab.equals("MGED")) dtsVocab = "MGED_Ontology";
//System.out.println("spb dtsVocab: " + dtsVocab);
  //session.setAttribute("dtsVocab", null);
   Vector vSource = (Vector)session.getAttribute("MetaSources");
   if(vSource == null) vSource = new Vector();
   String sMetaLimit = "100";
   String sVersion = (String)session.getAttribute("sVersion");
   if (sVersion == null) sVersion = "";
   String sUISearchType = (String)request.getAttribute("UISearchType");
//System.out.println("spb sUISearchType: " + sUISearchType);
   if (sUISearchType == null || sUISearchType.equals("nothing") 
        || sUISearchType.equals("") || dtsVocab.equals("NCI Metathesaurus")) 
    sUISearchType = "term";

  String sOpenTreeToConcept = (String)request.getAttribute("OpenTreeToConcept");
  if (sOpenTreeToConcept == null || sOpenTreeToConcept.equals("")) sOpenTreeToConcept = "false";

  //make the default displayable attributes with cadsr fields
  Vector vOCAttr = new Vector();
  vOCAttr.addElement("Concept Name");
  vOCAttr.addElement("Public ID");
  vOCAttr.addElement("EVS Identifier");
  vOCAttr.addElement("Definition");
  vOCAttr.addElement("Definition Source");
  vOCAttr.addElement("Context");
  vOCAttr.addElement("Vocabulary");
  vOCAttr.addElement("caDSR Component");
  if (sLongAC.equals("Object Class") || sLongAC.equals("Property"))
    vOCAttr.addElement("DEC's Using");
  //all displayable attributes without cadsr properties
  Vector vQualAttr = new Vector();
  vQualAttr.addElement("Concept Name");
  vQualAttr.addElement("EVS Identifier");
  vQualAttr.addElement("Definition");
  vQualAttr.addElement("Definition Source");
  vQualAttr.addElement("Vocabulary");

  //get the seleected displayable attributes
  Vector vSelDispAttr = (Vector)session.getAttribute("creSelectedAttr");
  if (vSelDispAttr == null) vSelDispAttr = new Vector();
  //get the search result records
  Vector vSerResult = (Vector)session.getAttribute("results");
  boolean hasRecords = false;
  if (vSerResult != null && vSerResult.size() >0) hasRecords = true;
  String updFunction = "displayAttributes('" + hasRecords + "');";
  
   Vector vVocab = new Vector();
   if (!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM"))
   {
    vVocab.addElement("Thesaurus/Metathesaurus");
    if(dtsVocab.equals("NCI Metathesaurus"))
      vVocab.addElement("NCI Metathesaurus");
    vVocab.addElement("GO");
    vVocab.addElement("VA_NDFRT");
    vVocab.addElement("LOINC");
    vVocab.addElement("MGED_Ontology");
    vVocab.addElement("MedDRA");
    }
    else // For parent concepts
    {
      vVocab.addElement("Thesaurus/Metathesaurus");
      if(dtsVocab.equals("NCI Metathesaurus"))
        vVocab.addElement("NCI Metathesaurus");
      vVocab.addElement("VA_NDFRT");
      vVocab.addElement("MGED_Ontology");
      vVocab.addElement("MedDRA");
    }
  int iItem = 1;
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
  function populateAttr()
  {
    getCompCreate();

    var vSearchAC = document.searchParmsForm.listSearchFor.options[document.searchParmsForm.listSearchFor.selectedIndex].value;
    var idx = -1;
    if(document.searchParmsForm.listAttrFilter != null)
      document.searchParmsForm.listAttrFilter.length = 0;
    //if (vSearchAC == "ObjectClass" || vSearchAC == "Property" || vSearchAC == "RepTerm")
    if (vSearchAC != "ParentConcept" && vSearchAC != "ParentConceptVM")
    {
      <% if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("NCI_Thesaurus")
            || dtsVocab.equals("NCI Metathesaurus")) { %> 
          if(document.searchParmsForm.listSearchIn != null)
            document.searchParmsForm.listSearchIn.length = 4;
     <%} else { %>
          if(document.searchParmsForm.listSearchIn != null)
           document.searchParmsForm.listSearchIn.length = 3;
     <%} %>

     <% //if(!sSearchAC.equals("ParentConceptVM"))  //add the attribute list
      //{
        for (int i = 0; i < vOCAttr.size(); i++)
        {
          String sAttr = (String)vOCAttr.elementAt(i); %>
          idx++;
          var vAttr = "<%=sAttr%>";
          selectAttr(idx, vAttr);     //call the function
      <% }%>  //} 
    }
 /*   qual and vm searches have cadsr only parent should be here without cadsr change.
      else if (vSearchAC == "ObjectQualifier" || vSearchAC == "PropertyQualifier" 
      || vSearchAC == "RepQualifier" || vSearchAC == "EVSValueMeaning" 
      || vSearchAC == "CreateVM_EVSValueMeaning" || vSearchAC == "PV_ValueMeaning"
      || vSearchAC == "ParentConcept" || vSearchAC == "ParentConceptVM") */
      else
      {
       <%if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("NCI_Thesaurus")
              || dtsVocab.equals("NCI Metathesaurus")) { %>   
         // if(document.searchParmsForm.listSearchIn != null)
         //   document.searchParmsForm.listSearchIn.length = 3;
          if(document.searchParmsForm.listSearchInEVS != null)
            document.searchParmsForm.listSearchInEVS.length = 3;
      <%}else{ %>
         // if(document.searchParmsForm.listSearchIn != null)
          //  document.searchParmsForm.listSearchIn.length = 2;
          if(document.searchParmsForm.listSearchInEVS != null)
            document.searchParmsForm.listSearchInEVS.length = 2;
      <%} %>
        
      <% if(!sSearchAC.equals("ParentConceptVM")) //add the attribute list only for parent search not parent vm search
      {
        for (int i = 0; i < vQualAttr.size(); i++)
        {
          String sAttr = (String)vQualAttr.elementAt(i);  %>
          idx++;
          var vAttr = "<%=sAttr%>";
          selectAttr(idx, vAttr);     //call the function
      <% }} %>
     }

      //check if newly opened
      var isSearched = "false";
      if (opener.document.SearchActionForm != null && opener.document.SearchActionForm.isValidSearch != null)
        isSearched = opener.document.SearchActionForm.isValidSearch.value;
      if(isSearched != null && isSearched == "false")
      {
         hourglass();
         window.status = "Displaying selected attributes, it may take a minute, please wait....."
         document.searchParmsForm.actSelect.value = "FirstSearch";
         opener.document.SearchActionForm.isValidSearch.value = "true";
         document.searchParmsForm.submit();
      }          

      //keyword empty if dropdown is not same as searched component
  /*    if (vSearchAC != "<%=sSearchAC%>" && document.searchParmsForm.keyword != null)
      {
          if(document.searchParmsForm.keyword != null)
            document.searchParmsForm.keyword.value = "";
          if (vSearchAC == "EVSValueMeaning" && document.searchParmsForm.listSearchInEVS != null)  //submit the form to refresh the page
          {
              //make synonym selected
              document.searchParmsForm.listSearchInEVS[0].value = "Synonym";
              document.searchParmsForm.listSearchInEVS[0].text = "Synonym";
              document.searchParmsForm.listSearchInEVS[0].selected = true;
              document.searchParmsForm.submit();  //submit the form
          }
      } */
  }

  //submits the page if Vocab changed.
  function doVocabChange()
  {
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = "doVocabChange";
    if(opener)
    {
      document.searchParmsForm.listSearchFor[0].selected = true;     
    }
    else
    {
       var selIdx = document.searchParmsForm.listSearchFor.selectedIndex;
       document.searchParmsForm.listSearchFor[selIdx].selected = true;
    }
    var selIdx2 = document.searchParmsForm.listContextFilterVocab.selectedIndex;
    document.searchParmsForm.listContextFilterVocab[selIdx2].selected = true;
<%if (sUISearchType.equals("term")) {%>
    var selIdx4 = document.searchParmsForm.listSearchInEVS.selectedIndex;
    document.searchParmsForm.listSearchInEVS[selIdx4].selected = true;
    if (document.searchParmsForm.listSearchIn != null)
    {
      var selIdx3 = document.searchParmsForm.listSearchIn.selectedIndex;
      document.searchParmsForm.listSearchIn[selIdx3].selected = true;
    }
<%}%>
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
    var actSelect = "";
<%if (sUISearchType.equals("term")) {%>
     populateAttr();
     if(document.searchParmsForm.keyword != null)
      document.searchParmsForm.keyword.focus();
<%}%>
<%
    if(sSearchAC.equals("DataElement") || sSearchAC.equals("ValueDomain") 
    || sSearchAC.equals("DataElementConcept") || sSearchAC.equals("PermissibleValue")
    || sSearchAC.equals("ConceptualDomain")) 
  {%>
        document.searchParmsForm.actSelect.value = "FirstSearch";
        document.searchParmsForm.submit();
<% }
 if(sSearchAC.equals("ParentConceptVM")) {%>
  if(opener.document.createVDForm != null)
  {
    if(opener.document.createVDForm.selectedParentConceptCode.value != "")
    {
      var code = opener.document.createVDForm.selectedParentConceptCode.value;
      var name = opener.document.createVDForm.selectedParentConceptName.value
      var db = opener.document.createVDForm.selectedParentConceptDB.value
      actSelect = opener.document.createVDForm.actSelect.value
      document.searchParmsForm.sCCodeDB.value = db;
      document.searchParmsForm.sCCode.value = code;
      document.searchParmsForm.sCCodeName.value = name;
      document.searchParmsForm.actSelect.value = actSelect;
    }
    if(document.searchParmsForm.actSelect.value == "OpenTreeToParentConcept")  
    {
        window.status = "Submitting the page, please wait.....";
        document.searchResultsForm.Message.style.visibility="visible";
        document.searchParmsForm.openToTree.value = "true";
        if(opener.document.createVDForm != null)
        {
          opener.document.createVDForm.selectedParentConceptCode.value = "";
          opener.document.createVDForm.selectedParentConceptName.value = ""; 
          opener.document.createVDForm.selectedParentConceptDB.value = "";
        }
        document.searchParmsForm.submit();
    }
  }
<% }%>
    if(document.searchParmsForm.openToTree != null && document.searchParmsForm.openToTree.value == "true" && actSelect != "OpenTreeToParentConcept")
    {
      window.status = "Submitting the page, please wait.....";
      document.searchResultsForm.Message.style.visibility="visible";
      document.searchParmsForm.actSelect.value = "OpenTreeToConcept";
      document.searchParmsForm.submit();
    }
 // alert("done setup");
  }

function keypress_handler()
{
    var keycode = window.event.keyCode;
    if(keycode != 13)
    {
        return true;  // only interest on return kay
    }
    if(document.searchParmsForm.listSearchInEVS.value == "Code")
    {
      if(document.searchParmsForm.listContextFilterSource.value == "All Sources")
      {
        alert("This type of search will search the Metathesaurus only. \n"
        + "The search term should be a code; for example, a LOINC code. \n"
        + "Please select a Meta Concept Source to filter by. ");
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
      if(document.searchParmsForm.listSearchInEVS.value == "Code")
      {
        if(document.searchParmsForm.listContextFilterSource.value == "All Sources")
        {
           alert("This type of search will search the Metathesaurus only. \n"
        + "The search term should be a code; for example, a LOINC code. \n"
        + "Please select a Meta Concept Source to filter by. ");
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
      document.searchParmsForm.submit();
    }

//fuction to refresh the page for simple/advanced filter
function searchType(type)
{
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait....."
    document.searchParmsForm.actSelect.value = type;
    document.searchParmsForm.submit();
}

//fuction to search or expand or collapse tree
function doTreeAction(type, nodeCode, vocab, nodeName, nodeID)
{
    var url = "";
    hourglass();
    window.status = "Refreshing the page, it may take a minute, please wait.....";
    document.searchResultsForm.Message.style.visibility="visible";
  //  opener.document.SearchActionForm.searchComp.value = "<%=sSearchAC%>";
    if(type == 'search')
      url = "../../cdecurate/NCICurationServlet?reqType=treeSearch&&keywordID=" + nodeCode + "&&vocab=" + vocab + "&&keywordName=" + nodeName + "&&nodeID=" + nodeID;
    else if(type == 'expand')
      url = "../../cdecurate/NCICurationServlet?reqType=treeExpand&&nodeName=" + nodeName + "&&vocab=" + vocab + "&&nodeCode=" + nodeCode + "&&nodeID=" + nodeID;
    else if(type == 'collapse')
      url = "../../cdecurate/NCICurationServlet?reqType=treeCollapse&&nodeName=" + nodeName + "&&vocab=" + vocab + "&&nodeCode=" + nodeCode + "&&nodeID=" + nodeID;
    document.searchParmsForm.action = url;
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
  document.searchParmsForm.submit();   
}

</SCRIPT>
<%
    Vector vContext = (Vector)session.getAttribute("vContext");
    Vector vStatusAll = (Vector)session.getAttribute("vStatusALL");
%>

</head>

<body onLoad="Setup();">
<form name="searchParmsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=searchBlocks">
  <table width="100%" class="sidebarBGColor" style="position: relative; top: -22px;">
    <tr valign="top" align="left" class="firstRow">
      <th><%=iItem++%>) Search For:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp
    <%  if (sMenuAction.equals("nothing")) {%>
        <select name="listSearchFor" size="1" style="width: 160" onChange="populateDefaultAttr();"
             onHelp = "showHelp('../Help_CreateDEC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="ObjectClass" <%if(sSearchAC.equals("ObjectClass")){%>selected<%}%>>Object Class</option>
          <option value="PropertyClass" <%if(sSearchAC.equals("Property")){%>selected<%}%>>Property</option>
          <option value="Qualifier" <%if(sSearchAC.equals("ObjectQualifier")){%>selected<%}%>>Object Qualifier</option>
          <option value="Qualifier" <%if(sSearchAC.equals("PropertyQualifier")){%>selected<%}%>>Property Qualifier</option>
          <option value="EVSValueMeaning" <%if(sSearchAC.equals("EVSValueMeaning")|| sSearchAC.equals("ValueMeaning") || sSearchAC.equals("CreateVM_EVSValueMeaning") || sSearchAC.equals("PV_ValueMeaning")){%>selected<%}%>>Value Meaning</option>
          <option value="ParentConcept" <%if(sSearchAC.equals("ParentConcept")){%>selected<%}%>>Parent Concept</option>
	     </select>
    <% } else {%>
        <select name="listSearchFor" size="1" style="width: 160"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
          <option value="<%=sSearchAC%>"><%=sLongAC%></option>
        </select>
    <% } %>
      </td>
  </tr>
  <%if(sSearchAC.equals("ParentConcept")){%>
    <tr valign="bottom" align="left" class="firstRow" height="22">
      <th><%=iItem++%>) Search Type:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp
      <input type="RADIO" value="EVS"  checked="checked" name="rRefType" onclick="javascript:changeType('EVS');">EVS
      &nbsp;&nbsp;&nbsp;&nbsp
      <input type="RADIO" value="Non EVS" name="rRefType" onclick="javascript:changeType('nonEVS');">Non EVS
      </td>
    </tr>
  <% } %>
    <tr valign="bottom" align="left" class="firstRow" height="22">
      <th><%=iItem++%>) Select EVS Vocabulary:</th>
    </tr>
    <tr>
      <td>&nbsp;&nbsp;&nbsp;&nbsp
          <select name="listContextFilterVocab" size="1" style="width: 160" onChange="doVocabChange();"
          onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
<%
          if (vVocab != null)
          {
            for (int i = 0; vVocab.size()>i; i++)
            {
              String sVocab = (String)vVocab.elementAt(i);
              //keep only the parent vocab in the drop down for select values from parent
              if (sSearchAC.equals("ParentConceptVM") && sVocab.equals(dtsVocab)) {
%>
                <option value="<%=sVocab%>" selected><%=sVocab%></option>
<%            } else if (!sSearchAC.equals("ParentConceptVM")) {  %>
                <option value="<%=sVocab%>" <%if(sVocab.equals(dtsVocab)){%>selected<%}%>><%=sVocab%></option>
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
  <%//if(!sSearchAC.equals("EVSValueMeaning") && !sSearchAC.equals("CreateVM_EVSValueMeaning") 
    if(!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM")){%>
   <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;caDSR</td>
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
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EVS
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;
              <%if (sUISearchType.equals("term") && !sSearchAC.equals("ParentConceptVM")) {%>
                  <a href="javascript:searchType('tree');">Tree Search</a>
              <%} else if(!sSearchAC.equals("ParentConceptVM")){%> 
                  <a href="javascript:searchType('term');">Term Search</a><%}%>        
    </td>
  </tr>
  <tr>
      <td>
        <p>&nbsp;&nbsp;&nbsp;&nbsp;
          <select name="listSearchInEVS" size="1" style="width: 170" onChange="populateCaDSRSearchIn();"
            onHelp = "showHelp('../Help_SearchAC.html#searchParmsForm_SearchBlocks'); return false">
<% if(sSearchAC.equals("ParentConceptVM")) { %>
            <option value="Concept Code" selected>Identifier Code</option>
<%} else if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("NCI_Thesaurus")) { %>
            <option value="Synonym" <%if(sSearchInEVS.equals("Synonym")){%>selected<%}%>>Synonym</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Concept Code/CUI</option>
            <option value="Code" <%if(sSearchInEVS.equals("Code")){%>selected<%}%>>Code (Metathesaurus)</option>
<%} else if(dtsVocab.equals("GO")) { %>
            <option value="Preferred_Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Preferred Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("VA NDFRT") || dtsVocab.equals("VA_NDFRT")) { %>
            <option value="Search_Name" <%if(sSearchInEVS.equals("Search_Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("LOINC")) { %>
            <option value="Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("UWD VISUAL ANATOMIST") || dtsVocab.equals("UWD_Visual_Anatomist")) { %>
            <option value="SYNONYM" <%if(sSearchInEVS.equals("Synonym")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("MGED") || dtsVocab.equals("MGED_Ontology")) { %>
            <option value="Preferred_Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("MedDRA")) { %>
            <option value="Preferred_Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else if(dtsVocab.equals("HL7_V3")) { %>
            <option value="Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<%} else { %>
            <option value="Name" <%if(sSearchInEVS.equals("Name")){%>selected<%}%>>Name</option>
            <option value="Concept Code" <%if(sSearchInEVS.equals("Concept Code")){%>selected<%}%>>Identifier Code</option>
<% } %>
          </select>
        </p>
     </td>
  </tr>
<%if (sUISearchType.equals("term") && !dtsVocab.equals("NCI Metathesaurus")) {%>
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
<% //if(!sSearchAC.equals("EVSValueMeaning") && !sSearchAC.equals("ValueMeaning") && !sSearchAC.equals("CreateVM_EVSValueMeaning")
  if (!sSearchAC.equals("ParentConcept") && !sSearchAC.equals("ParentConceptVM")){%> 
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
              <option value"<%=sContextName%>"  <%if(sContextName.equals(sContext)){%>selected<%}%>><%=sContextName%></option>
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
          <option value="RELEASED"  selected>RELEASED</option>
        </select>
      </p>
    </td>
  </tr>
  <% } %>
<% if(dtsVocab.equals("Thesaurus/Metathesaurus") || dtsVocab.equals("NCI_Thesaurus")
|| dtsVocab.equals("NCI Metathesaurus") && !sSearchAC.equals("ParentConceptVM")) { %>
   <tr>
    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>EVS</b></td>
  </tr>
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
              <option value"<%=sSourceName%>"  <%if(sSourceName.equals(sMetaSource)){%>selected<%}%>><%=sSourceName%></option>
<%
            }
         }
%>
        </select>
      </p>
    </td>
 
    <tr>
      <th height="22" valign="bottom">
        <div align="left"><%=iItem++%>) Set Meta Returns Limit:</div>
      </th>
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
 <%}%>
  
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
        </select>
      </div>
    </td>
  </tr>
  <tr>
    <td height="33" valign="bottom">
      <div align="center">
        <input type="button" name="startSearchBtn" value="Start Search" onClick="doSearchBuildingBlocks();"  style="width: 150", "height: 30"
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
  <select size="1" name="hidListAttr" style="visibility:hidden;">
<%  for (int i = 0; vSelDispAttr.size()>i; i++)
    {
      String sName = (String)vSelDispAttr.elementAt(i);
      if (sName != null) {
%>
    <option value="<%=sName%>"><%=sName%></option>
<%
    } }
%>
  </select>
  <input type="hidden" name="actSelect" value="Search" style="visibility:hidden;">
  <input type="hidden" name="sCCodeDB" value="">
  <input type="hidden" name="sCCode" value="">
  <input type="hidden" name="sCCodeName" value="">
  <input type="hidden" name="openToTree" value=""> 
  <input type="hidden" name="sConteIdseq" value="">
  
  <input type="hidden" name="outPrint" value="Print" style="visibility:hidden;"
  <% out.println(""+vOCAttr.size());// leave this in, it slows jsp load down so no jasper error%> >
</table>
<script language = "javascript">
LoadKeyHandler();
</script>
</form>
</body>
</html>
