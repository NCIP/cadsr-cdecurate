<!-- SearchResultsBlocks.jsp -->

<%@ page import= "java.util.*" %>
<%@ page import="com.scenpro.NCICuration.*" %>
<html>
<head>
<title>Search Results</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<link href="../../cdecurate/Assets/popupMenus.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/SearchResultsBlocks.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/popupMenus.js"></SCRIPT>
<%
   //displayable result vector
   Vector results = (Vector)session.getAttribute("results");
   if (results == null) results = new Vector();
   
   Vector vSearchID = (Vector)session.getAttribute("SearchID");
   if (vSearchID == null) vSearchID = new Vector();
   Vector vSearchName = (Vector)session.getAttribute("SearchName");
   if (vSearchName == null)  vSearchName = new Vector();
   Vector vSearchDefinition = (Vector)session.getAttribute("SearchDefinition");
   if (vSearchDefinition == null)  vSearchDefinition = new Vector();
   Vector vSearchDefSource = (Vector)session.getAttribute("SearchDefSource");
   if (vSearchDefSource == null) vSearchDefSource = new Vector();
   Vector vSearchDatabase = (Vector)session.getAttribute("SearchDatabase");
   if (vSearchDatabase == null) vSearchDatabase = new Vector();
   Vector vCCode = (Vector)session.getAttribute("vCCode");
   if (vCCode == null) vCCode = new Vector();
   Vector vCCodeDB = (Vector)session.getAttribute("vCCodeDB");
   if (vCCodeDB == null) vCCodeDB = new Vector();
   String sKeyword = "", nRecs = "", sSelAC = "";
   String sSelAC_VM = "";
   String sSelectedParentName = "", sSelectedParentCC = "", sSelectedParentDB = "";
 
   Vector vSelAttr = new Vector();
   String sMAction = (String)session.getAttribute("MenuAction");
   if (sMAction != null && sMAction.equals("searchForCreate"))  // || sMAction.equals("BEDisplay"))
   {
       sKeyword = (String)session.getAttribute("creKeyword");
       nRecs = (String)request.getAttribute("creRecsFound");
       sSelAC = (String)session.getAttribute("creSearchAC");
       if (sSelAC == null) sSelAC = "";
       sSelectedParentName = (String)session.getAttribute("SelectedParentName");
       sSelectedParentCC = (String)session.getAttribute("SelectedParentCC");
       sSelectedParentDB = (String)session.getAttribute("SelectedParentDB");
       vSelAttr = (Vector)session.getAttribute("creSelectedAttr");
   }

   String sLabelKeyword =  (String)request.getAttribute("labelKeyword");
   if (sLabelKeyword == null)
      sLabelKeyword = "";
   if (sKeyword == null)
      sKeyword = "";
   if (nRecs == null)
      nRecs = "No ";
   if (sMAction == null)
      sMAction = "";
  if (sSelAC == null)
      sSelAC = "";

  boolean isSelAll = false;
  boolean isEVSvm = true;
  //allow multiple select only for select values from vd page
  if (sSelAC.equals("EVSValueMeaning") || sSelAC.equals("ParentConceptVM"))  
    isSelAll = true;
  //create display names for the selected ac
  if (sSelAC.equals("ObjectClass") || sSelAC.equals("VDObjectClass"))
     sSelAC = "Object Class";
  else if (sSelAC.equals("PropertyClass") || sSelAC.equals("VDPropertyClass"))
     sSelAC = "Property";
  else if (sSelAC.equals("RepTerm") || sSelAC.equals("VDRepTerm"))
     sSelAC = "Rep Term";
  else if (sSelAC.equals("Qualifier"))
     sSelAC = "Qualifier";
  else if (sSelAC.equals("ObjectQualifier") || sSelAC.equals("VDObjectQualifier"))
     sSelAC = "Object Qualifier";
  else if (sSelAC.equals("PropertyQualifier") || sSelAC.equals("VDPropertyQualifier"))
     sSelAC = "Property Qualifier";
  else if (sSelAC.equals("RepQualifier") || sSelAC.equals("VDRepQualifier"))
     sSelAC = "Rep Qualifier";
   else if (sSelAC.equals("ReferenceList"))
     sSelAC = "Reference List";
  else if (sSelAC.equals("EVSValueMeaning") || sSelAC.equals("CreateVM_EVSValueMeaning")
            || sSelAC.equals("PV_ValueMeaning"))
     sSelAC = "Value Meaning";
  else if (sSelAC.equals("ParentConcept"))
     sSelAC = "Parent Concept";
  else if (sSelAC.equals("ParentConceptVM"))
  {
     sSelAC = "Value Meaning";

     isEVSvm = false;
  }

  String strIsQualifier = "false";
        
  String sUISearchType2 = (String)request.getAttribute("UISearchType");
  if (sUISearchType2 == null || sUISearchType2.equals("nothing") 
  || sUISearchType2.equals("")) 
    sUISearchType2 = "term";
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
 var evsWindow2 = null;
 var selDefinition = null;
 var numRowsSelected = 0;
 var checkBoxArray = new Array();

   function setup()
   {
 // alert("start setUp");
 <%
    String statusMessage = (String)session.getAttribute("statusMessage");
    if (statusMessage == null) statusMessage = "";
    String sSubmitAction = (String)session.getAttribute("MenuAction");
    if (sSubmitAction == null) sSubmitAction = "nothing";
 %>
    displayStatus("<%=statusMessage%>", "<%=sSubmitAction%>");
 <%
    session.setAttribute("statusMessage", "");
 %>
    window.status = "Enter the keyword to search a component"
   }

   function getSearchComponent()
   {
     var type = "";
      sComp = opener.document.SearchActionForm.searchComp.value;
      if (sComp == "ParentConceptVM")
      {
        var sComp2 = opener.document.createVDForm.selectedParentConceptMetaSource.value;
        if (sComp2 == null) sComp2 = "";
        document.searchResultsForm.selectedParentConceptMetaSource.value = sComp2;
      }
    <%  if (sMAction.equals("searchForCreate") || sMAction.equals("BEDisplay")){%>
       
        if (sComp == "ObjectClass" || sComp == "VDObjectClass") type = "Object Class";
        else if (sComp == "PropertyClass" || sComp == "VDPropertyClass" || sComp == "Property") type = "Property";
        else if (sComp == "ObjectQualifier" || sComp == "VDObjectQualifier") type = "Object Qualifier";
        else if (sComp == "PropertyQualifier" || sComp == "VDPropertyQualifier") type = "Property Qualifier";
        else if (sComp == "RepTerm") type = "Rep Term";
        else if (sComp == "RepQualifier") type = "Rep Qualifier";
        else if (sComp == "EVSValueMeaning" || 
                  sComp == "CreateVM_EVSValueMeaning" || 
                  sComp == "ParentConceptVM") type = "Value Meaning";
        else if (sComp == "ParentConcept") type = "Parent Concept";
        
    <% } else { %>
        sComp = "<%=sSelAC%>";
    <% } %>
   }
     
  function ShowSelection()
  {
     if (opener.document == null)
        window.close();
      ShowUseSelection("<%=sMAction%>");
  }

   function reSetAttribute()
   {
<%    
       Vector vDECResult = new Vector();
       session.setAttribute("results", vDECResult);
       session.setAttribute("creRecsFound", "No ");
%>
   }

   function EnableButtons(checked, currentField)
   {
      if (opener.document == null)
        window.close();
      EnableCheckButtons(checked, currentField, "<%=sMAction%>")
   }

function getSubConceptsAll()
{
   if (opener.document == null)
        window.close();
   getSubConceptsAll2("<%=sUISearchType2%>")  
}
   
function getSubConceptsImmediate()
{
   if (opener.document == null)
        window.close();
  getSubConceptsImmediate2("<%=sUISearchType2%>")
}
   
function getSuperConcepts()
{
   if (opener.document == null)
        window.close();
   getSuperConcepts2("<%=sUISearchType2%>")  
}

</SCRIPT>

</head>

<body onLoad="setup();">
<form name="searchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=doSortBlocks">
<br>
<table border="0">
  <tr align="left">
    <td>
        <input type="button" name="editSelectedBtn" value="Use Selection" onClick="ShowSelection();" disabled style="width: 100", "height: 30">
        &nbsp;&nbsp;
    <!--   <input type="button" name="btnUseParent" value="Set Reference" onclick="javascript:getSubConcepts();" style="width: 95">
      &nbsp;&nbsp; -->
       <input type="button" name="btnSubConcepts" value="Get Subconcepts"  onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)" onmouseout="closeall()" style="width: 115" disabled>
      &nbsp;&nbsp;
       <input type="button" name="btnSuperConcepts" value="Get Superconcepts" disabled onclick="javascript:getSuperConcepts();" style="width: 130">
      &nbsp;&nbsp;
        <input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();" style="width: 93", "height: 30">
       &nbsp;&nbsp;
      <input type="button" name="btnSubmitToEVS" value="Suggest to EVS" onclick="javascript:NewTermSuggested();" style="width:108">
       &nbsp;&nbsp;
      <img name="Message" src="../../cdecurate/Assets/SearchMessage.gif" width="180" height="25" alt="WaitMessage" style="visibility:hidden;" align="top">
    </td>
  </tr>
</table>
<br>
<table width="100%" valign="top">
<% if(sSelAC.equals("Parent Concept")){%>
  <tr>
      <td><font size="4"><b>Search Results for Parent Concept -  <%=sLabelKeyword%></b></font></td>
  </tr>
<% } else { %>
  <tr>
      <td><font size="4"><b>Search Results for <%=sLabelKeyword%></b></font></td>
  </tr>
<%}%>
  <tr>
     <td><font size="2">&nbsp;<%=nRecs%> Records Found</font></td>
  </tr>  
<!--  <tr>
    <td><a href=""><b>Use Concept to limit the Values</b></a></td>
  </tr>  -->
</table>
<table width="100%" border="1" valign="top">
  <tr valign="middle">
<%    if (isSelAll) { %>
      <th height="30" width="30"><a href="javascript:SelectAll('<%=nRecs%>')">
        <img id="CheckGif" src="../../cdecurate/Assets/CheckBox.gif" border="0" alt="Select All"></a></th>
<%    } else   { %>                 
      <th height="30" width="30"><img src="../../cdecurate/Assets/CheckBox.gif" border="0"></th>
<%    } %>                 
      <!-- add other headings -->
<%
      int k = 0;
      if (vSelAttr != null)
      {
        k = vSelAttr.size();
        for (int i =0; i < vSelAttr.size(); i++)
        {
          String sAttr = (String)vSelAttr.elementAt(i);
          if (sAttr == null || sAttr.equals("Concept Name")) { %>
            <th method="get"><a href="javascript:SetSortType('name')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Concept Name</a></th>
<%        }   else if (sAttr == null || sAttr.equals("EVS Identifier")) { %>
            <th method="get"><a href="javascript:SetSortType('umls')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              EVS Identifier</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Public ID")) { %>
            <th method="get"><a href="javascript:SetSortType('publicID')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Public_ID</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Definition")) { %>
            <th method="get"><a href="javascript:SetSortType('def')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Definition</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Definition Source")) { %>
            <th method="get"><a href="javascript:SetSortType('source')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Definition Source</a></th>
<%        } else if (sAttr == null || sAttr.equals("Context")) { %>
            <th method="get"><a href="javascript:SetSortType('context')"
             onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
             Context</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Vocabulary")) { %>
            <th method="get"><a href="javascript:SetSortType('db')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Vocabulary</a></th>
<%        }   else if (sAttr == null || sAttr.equals("caDSR Component")) { %>
            <th method="get"><a href="javascript:SetSortType('cadsrComp')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              caDSR Component</a></th>
<%        }   else if (sAttr == null || sAttr.equals("DEC's Using")) { %>
            <th method="get"><a href="javascript:SetSortType('decUse')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              DEC's Using</a></th>
<%        } else if (sAttr.equals("Level")) { %>
            <th method="get"><a href="javascript:SetSortType('Level')"
                 onHelp = "showHelp('Help_SearchAC.html#searchResultsForm_sort'); return false">
              Level</a></th>
<%
	        }  }  }
%>
    </tr>
<%
    String strResult = "";
    String strVocab = "";
    if (results != null)
    {
      int j = 0;
      for (int i = 0; i < results.size(); i+=k)
      {
       String ckName = ("CK" + j);
       strResult = (String)results.get(i);
       if (j < vSearchDatabase.size())
         strVocab = (String)vSearchDatabase.elementAt(j);
       if (strResult == null) strResult = "";
       if (strVocab == null) strVocab = "";
       boolean hasLink = false;
       String showConceptInTree = "javascript:showConceptInTree('" + ckName + "');";

       //no hyperlink for meta, cadsr, parentvm searches
       if(strVocab.equals("NCI Metathesaurus") || strVocab.equals("caDSR") 
          || (sSelAC.equals("Value Meaning") && isEVSvm == false))
          hasLink = false;
       else
       {
          //hyperlink only if first column is concept name or eve id
          if (vSelAttr.contains("Concept Name") || (vSelAttr.contains("EVS Identifier") && !vSelAttr.contains("Public ID")))
            hasLink = true;
          else
            hasLink = false;
       }
        
       //do not put hyperlink, concept name or evsid not selected 
       if (hasLink == false) {
%>
         <tr>
          <td width="5"><input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);"></td>
          <td width="150"><%=strResult%></td>
<%    }else{%>
        <tr>
          <td width="5"><input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);"></td>
          <td width="150"><a href="<%=showConceptInTree%>"><%=strResult%></a></td>
<%    } %>
<%
		   for (int m = 1; m < k; m++)
		   {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>        <td><%=strResult%></td>
<%
        }
%>
        </tr>
    <%
         j++;
    }
	 }
%>

</table>
<table>
<input type="hidden" name="AttChecked" value="<%=(k-5)%>">
<input type="hidden" name="searchComp" value="">
<input type="hidden" name="openToTree" value=""> 
<input type="hidden" name="selectedParentConceptCode" value="<%=sSelectedParentCC%>">
<input type="hidden" name="selectedParentConceptName" value="<%=sSelectedParentName%>">
<input type="hidden" name="selectedParentConceptDB" value="<%=sSelectedParentDB%>">
<input type="hidden" name="selectedParentConceptMetaSource" value="">
<input type="hidden" name="OCCCode" value="">
<input type="hidden" name="OCCCodeDB" value="">
<input type="hidden" name="OCCCodeName" value="">
<input type="hidden" name="numSelected" value="">
<input type="hidden" name="actSelected" value="Search">
<input type="hidden" name="numAttSelected" value="">
<input type="hidden" name="blockSortType" value="nothing"> 
<input type="hidden" name="UISearchType" value="<%=sUISearchType2%>">
<input type="hidden" name="selRowID" value="">
<select size="1" name="hiddenSearch" style="visibility:hidden;width:50">
<%                    for (int i = 0; vSearchID.size()>i; i++)
                      {
                        String sID = (String)vSearchID.elementAt(i);
                         String sName = "";
                        if (vSearchName.size() > i)
                          sName = (String)vSearchName.elementAt(i);
                        else
                          sName = "";
%>
                      <option value="<%=sID%>"><%=sName%></option>
<%
                      }
%>
  </select>
<select size="1" name="hiddenSearch2" style="visibility:hidden;width:50">
<%                    for (int i = 0; vSearchName.size()>i; i++)
                      {
                         String sName = "";
                        if (vSearchName.size() > i)
                          sName = (String)vSearchName.elementAt(i);
                        else
                          sName = "";
%>
                      <option value="<%=sName%>"><%=sName%></option>
<%
                      }
%>
  </select>
<select size="1" name="hiddenName" style="visibility:hidden;width:50">
<%                    for (int i = 0; vSearchName.size()>i; i++)
                      {
                        String sName = (String)vSearchName.elementAt(i);
%>
                      <option value="<%=sName%>"><%=sName%></option>
<%
                      }
%>
  </select>
<select size="1" name="hiddenDatabase" style="visibility:hidden;">
<%                    for (int i = 0; vSearchDatabase.size()>i; i++)
                      {
                        String sName = (String)vSearchDatabase.elementAt(i);
%>
                      <option value="<%=sName%>"><%=sName%></option>
<%
                      }
%>
  </select>
<select size="1" name="hiddenDefSource" style="visibility:hidden;width:145">
<%                    String sSource = "";
                      String sDef = "";
                      for (int i = 0; vSearchDefinition.size()>i; i++)
                      {
                          sDef = (String)vSearchDefinition.elementAt(i);
                          sSource = (String)vSearchDefSource.elementAt(i);
%>
                      <option value="<%=sSource%>"><%=sDef%></option>
<%
                      }
%>
 </select>
<select size="1" name="hiddenCCode" style="visibility:hidden;width:145">
<%                
                      String sCode = "";
                      for (int i = 0; vCCode.size()>i; i++)
                      {
                          sCode = (String)vCCode.elementAt(i);
%>
                      <option value="<%=sCode%>"><%=sCode%></option>
<%
                      }
%>
 </select>
<select size="1" name="hiddenCCodeDB" style="visibility:hidden;width:145">
<%                
                      String sCuiDB = "";
                      for (int i = 0; vCCodeDB.size()>i; i++)
                      {
                          sCuiDB = (String)vCCodeDB.elementAt(i);
%>
                      <option value="<%=sCuiDB%>"><%=sCuiDB%></option>
<%
                      }
%>
</select>
<select size="1" name="hiddenPVValue" style="visibility:hidden;">
  </select>
<select size="1" name="hiddenPVMean" style="visibility:hidden;">
  </select>
  
<select size="1" name="hiddenResults" style="visibility:hidden;width:145">
<%        for (int m = 0; results.size()>m; m++)
          {
             String sName = (String)results.elementAt(m);
%>
             <option value="<%=sName%>"><%=sName%></option>
<%
          }
%>
        </select>
        <select size="1" name="hiddenName2" style="visibility:hidden;width:145">
<%        for (int i = 0; i<results.size(); i+=k)
          {
             String sName = (String)results.elementAt(i);
%>
             <option value="<%=sName%>"><%=sName%></option>
<%
          }
%>
        </select>
        <select size="1" name="hiddenIdentifier" style="visibility:hidden;width:145">
<%        for (int i = 1; i<results.size(); i+=k)
          {
             String sName = (String)results.elementAt(i);
%>
             <option value="<%=sName%>"><%=sName%></option>
<%
          }
%>
        </select>
<select size="1" name="hiddenSelectedRow" style="visibility:hidden;"> </select>
</table>
<div id="divAssACMenu" style="position:absolute;z-index:1;visibility:hidden;width:185px;">
<table id="tblAssACMenu" border="3" cellspacing="0" cellpadding="0">
<tr><td class="menu" id="assDE"><a href="javascript:getSubConceptsAll();" onmouseover="changecolor('assDE',oncolor)" onmouseout="changecolor('assDE',offcolor);closeall()">All Subconcepts</a></td></tr>
<tr><td class="menu" id="assDEC"><a href="javascript:getSubConceptsImmediate();" onmouseover="changecolor('assDEC',oncolor)" onmouseout="changecolor('assDEC',offcolor);closeall()">Immediate Subconcepts</a></td></tr>
</table>
</div>
<script language = "javascript">
getSearchComponent();
initPopupMenu2();
</script>
</form>
</body>
</html>
