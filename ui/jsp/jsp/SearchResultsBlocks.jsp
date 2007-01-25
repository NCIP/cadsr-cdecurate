<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/SearchResultsBlocks.jsp,v 1.17 2007-01-25 22:39:31 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import= "java.util.*" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>
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
//System.out.println(" search results ");
   UtilService serUtil = new UtilService();
   Vector results = (Vector)session.getAttribute("results");
   Session_Data sessionData2 = (Session_Data) session.getAttribute(Session_Data.CURATION_SESSION_ATTR);
   if (results == null) results = new Vector();
   EVS_UserBean uBean = (EVS_UserBean)sessionData2.EvsUsrBean; //(EVS_UserBean)session.getAttribute("EvsUserBean");
   if (uBean == null) uBean = new EVS_UserBean();
   Vector vrVocab = uBean.getVocabNameList();   //(Vector)session.getAttribute("dtsVocabNames");  //list of vocabulary names
   if (vrVocab == null) vrVocab = new Vector();
   //get meta name
   String metaName = uBean.getMetaDispName();
   if (metaName == null) metaName = "";
   String dsrName = uBean.getDSRDispName();
   if (dsrName == null) dsrName = "";
   //list of def sources to filter duplicates
   Vector vDefSrc = uBean.getNCIDefSrcList();
   if (vDefSrc == null) vDefSrc = new Vector();
  // Vector vrDisplay = uBean.getVocabDisplayList();  // (Vector)session.getAttribute("dtsVocabDisplay");  //list of vocabulary display names
  // if (vrDisplay == null) vrDisplay = new Vector();
  // EVS_Bean eBean = new EVS_Bean();
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

   Vector vSearchRes = (Vector)session.getAttribute("vACSearch");
   if (vSearchRes == null) vSearchRes = new Vector();
   if (sSelAC == null || sSelAC.equals("ConceptualDomain")) vSearchRes = new Vector();
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
  boolean allowNVP = false;
  if (sSelAC.contains("Qualifier") || sSelAC.equals("VMConcept"))
  	allowNVP = true;
  	
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
            || sSelAC.equals("PV_ValueMeaning")) // || sSelAC.equals("VMConcept"))
     sSelAC = "Value Meaning";
  else if (sSelAC.equals("VMConcept"))
     sSelAC = "Concept";
  else if (sSelAC.equals("ParentConcept"))
     sSelAC = "Parent Concept";
  else if (sSelAC.equals("ParentConceptVM"))
  {
     sSelAC = "Value Meaning";
     isEVSvm = false;
  }

  String strIsQualifier = "false";
        
  String sUISearchType2 = (String)request.getAttribute("UISearchType");
  if (sUISearchType2 == null || sUISearchType2.equals("nothing") || sUISearchType2.equals("")) 
    sUISearchType2 = "term";
    
  //get the concept from the request after checking if exists in thesaurus or cadsr
  EVS_Bean selBean = (EVS_Bean)request.getAttribute("selConcept");
  if (selBean == null) selBean = new EVS_Bean();
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
 var evsWindow2 = null;
 var selDefinition = null;
 var numRowsSelected = 0;
 var checkBoxArray = new Array();
 var conArray = new Array();
 var metaName = "";
 var dsrName = "";
 var arrDefSrc = new Array();


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
	    //make the message visible.
	    var pageOpen = "";
	    if (document.searchParmsForm.actSelect != null)
	      pageOpen = document.searchParmsForm.actSelect.value;
	    if (pageOpen == "FirstSearch" || pageOpen == "OpenTreeToConcept" || pageOpen == "OpenTreeToParentConcept")
	      document.searchResultsForm.Message.style.visibility="visible";
    
   }

   function getSearchComponent()
   {
     var type = "";
      sComp = opener.document.SearchActionForm.searchComp.value;
      if (sComp == "ParentConceptVM")
      {
        var sComp2 = opener.document.getElementById("selectedParentConceptMetaSource").value;
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
                  sComp == "ParentConceptVM") type = "Value Meaning";  // || sComp == "VMConcept"
        else if (sComp == "VMConcept") type = "Concept";
        else if (sComp == "ParentConcept") type = "Parent Concept";
        
    <% } else { %>
        sComp = "<%=sSelAC%>";
    <% } %>
    
      //selected concept info
      <% if (selBean.getLONG_NAME() != null && !selBean.getLONG_NAME().equals(""))
      {
      	String sName = selBean.getLONG_NAME();
      	sName = serUtil.parsedStringSingleQuote(sName);
      	String sID = selBean.getCONCEPT_IDENTIFIER();
      	String sDB = selBean.getEVS_DATABASE();
      	String sDesc = selBean.getPREFERRED_DEFINITION();
      	sDesc = serUtil.parsedStringSingleQuote(sDesc);
    System.out.println(selBean.getLONG_NAME() + " sel Con " + selBean.getCONCEPT_IDENTIFIER() + " db " + selBean.getEVS_DATABASE() + " def " + selBean.getPREFERRED_DEFINITION());
      %>
	      	opener.appendConcept('<%=sName%>', '<%=sID%>', '<%=sDB%>', '<%=sName%>', '<%=sDesc%>');
	      	window.close();
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

  //stores the search resuls in the array
  function storeResultInArray()
  {
<%  
	try
	{
	  for(int i=0; i<vSearchRes.size(); i++)
	  {
	      EVS_Bean evsBean = (EVS_Bean)vSearchRes.elementAt(i);
	      if (evsBean == null) evsBean = new EVS_Bean();
	%>
	      //store con attributes in an array
	      var aIndex = <%=i%>;  //get the index
	      var conID = "<%=evsBean.getCONCEPT_IDENTIFIER()%>";  //get evs identifier
	      <% //parse the string for quotation character
	        String sData = evsBean.getLONG_NAME();
	        sData = serUtil.parsedStringDoubleQuote(sData);%>
	      var conName = "<%=sData%>";
	      <% //parse the string for quotation character
	        sData = evsBean.getPREFERRED_DEFINITION();
	        sData = serUtil.parsedStringDoubleQuote(sData);%>
	      var conDef = "<%=sData%>";
	      var conDefSrc = "<%=evsBean.getEVS_DEF_SOURCE()%>";
	      var conVocab = "<%=evsBean.getEVS_DATABASE()%>";
	      var conDBOrg = "<%=evsBean.getEVS_ORIGIN()%>";
	      var conLvl = "<%=evsBean.getLEVEL()%>";
	      var conStatus = "<%=evsBean.getASL_NAME()%>";
	      //create multi dimentional array with concept attributes 
	      conArray[aIndex] = fillConArray(conID, conName, conDef, conDefSrc, conVocab, conDBOrg, conLvl, conStatus);      
	<%        
	  }
	}
	catch (Exception e)
	{
	  System.out.println("Exception in search results blocks " + e.toString());
	}
%>
    //also store other variables
    metaName = "<%=metaName%>";
    dsrName = "<%=dsrName%>";
<%   //add teh defintion sources to filter duplicates
    for (int k=0; k<vDefSrc.size(); k++)
    {
      String sSrc = (String)vDefSrc.elementAt(k);
%>
      var kI = <%=k%>
      arrDefSrc[kI] = "<%=sSrc%>";
<%        
    }
%>
  }
  
</SCRIPT>

</head>

<body onLoad="setup();">
<form name="searchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=doSortBlocks">
<br>
<table border="0">
  <tr align="left">
    <td>
        <input type="button" name="editSelectedBtn" value="Use Selection" onClick="ShowSelection();" disabled style="width: 100,height: 30">
        &nbsp;&nbsp;
    <!--   <input type="button" name="btnUseParent" value="Set Reference" onclick="javascript:getSubConcepts();" style="width: 95">
      &nbsp;&nbsp; -->
       <input type="button" name="btnSubConcepts" value="Get Subconcepts"  onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)" onmouseout="closeall()" style="width: 115" disabled>
      &nbsp;&nbsp;
       <input type="button" name="btnSuperConcepts" value="Get Superconcepts" disabled onclick="javascript:getSuperConcepts();" style="width: 130">
      &nbsp;&nbsp;
        <input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();" style="width: 93,height: 30">
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
<%        }   else if (sAttr == null || sAttr.equals("Version")) { %>
            <th method="get"><a href="javascript:SetSortType('version')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Version</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Definition")) { %>
            <th method="get"><a href="javascript:SetSortType('def')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Definition</a></th>
<%        }   else if (sAttr == null || sAttr.equals("Definition Source")) { %>
            <th method="get"><a href="javascript:SetSortType('source')"
              onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
              Definition Source</a></th>
<%        } else if (sAttr == null || sAttr.equals("Workflow Status")) { %>
            <th method="get"><a href="javascript:SetSortType('asl')"
             onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
             Workflow Status</a></th>
<%        } else if (sAttr == null || sAttr.equals("Context")) { %>
            <th method="get"><a href="javascript:SetSortType('context')"
             onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
             Context</a></th>
<%        } else if (sAttr == null || sAttr.equals("Semantic Type")) { %>
            <th method="get"><a href="javascript:SetSortType('semantic')"
             onHelp = "showHelp('../Help_SearchAC.html#searchResultsForm_sort'); return false">
             Semantic Type</a></th>
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
    String vName = "";
   // String strVocab = "";
    if (results != null)
    {
      int j = 0;
      for (int i = 0; i < results.size(); i+=k)
      {
      	int nvp = 0;
        if (vSearchRes.size() > j)
        {
          EVS_Bean eBean = (EVS_Bean)vSearchRes.get(j);
          if (eBean == null) eBean = new EVS_Bean();
          String strVocab = eBean.getEVS_DATABASE();  
          vName = eBean.getVocabAttr(uBean, strVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
          nvp = eBean.getNAME_VALUE_PAIR_IND();
   // System.out.println(vName + " jsp vocab " + strVocab);
        }
         String ckName = ("CK" + j);
         strResult = (String)results.get(i);
         if (strResult == null) strResult = "";
         //if (strVocab == null) strVocab = "";
         //String vName = eBean.getVocabAttr(uBean, strVocab, "vocabDBOrigin", "vocabName");
         boolean hasLink = false;
         String showConceptInTree = "javascript:showConceptInTree('" + ckName + "');";
  
         //no hyperlink for meta, cadsr, parentvm searches
         if(vName.equals("") || !vrVocab.contains(vName) || (sSelAC.equals("Value Meaning") && isEVSvm == false)) //strVocab.equals("NCI Metathesaurus") || strVocab.equals("caDSR")           
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
            <td width="5" valign="top"><input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);"></td>
            <td width="150" valign="top"><%=strResult%> <br>
            	<% //add the text box for NVP under concept name
            		if (allowNVP && nvp > 0 && vSelAttr.contains("Concept Name"))
            		{
            	%>
            			<br>&nbsp;&nbsp;Enter Concept Value
            			<br>&nbsp;&nbsp;<input type="text" name="nvp_<%=ckName%>" maxlength="10" width="80%" onkeyup="" value="">            			
            	<% }	%>
            </td>
  <%    }else{%>
          <tr>
            <td width="5" valign="top"><input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);"></td>
            <td width="150" valign="top"><a href="<%=showConceptInTree%>"><%=strResult%></a> <br>
            	<% //add the text box for NVP under concept name
            		if (allowNVP && nvp > 0 && vSelAttr.contains("Concept Name"))
            		{
            	%>
            			<br>&nbsp;&nbsp;Enter Concept Value
            			<br>&nbsp;&nbsp;<input type="text" name="nvp_<%=ckName%>" maxlength="10" width="30" onkeyup="" value="">            			
            	<% }	%>
            </td>
  <%    } %>
  <%
		   for (int m = 1; m < k; m++)
		   {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>        <td valign="top"><%=strResult%></td>
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
<div style="display:none">
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
<input type="hidden" name="editPVInd" value="">
<select size="1" name="hiddenPVValue" style="visibility:hidden;"></select>
<select size="1" name="hiddenPVMean" style="visibility:hidden;"></select>
  
<select size="1" name="hiddenResults" style="visibility:hidden;width:145">
<%  for (int m = 0; results.size()>m; m++)
    {
       String sName = (String)results.elementAt(m);
%>
       <option value="<%=sName%>"><%=sName%></option>
<%
    }
%>
</select>
<select size="1" name="hiddenSelectedRow" style="visibility:hidden;"> </select>
</div>
<div id="divAssACMenu" style="position:absolute;z-index:1;visibility:hidden;width:185px;">
<table id="tblAssACMenu" border="3" cellspacing="0" cellpadding="0">
<tr><td class="menu" id="assDE"><a href="javascript:getSubConceptsAll();" onmouseover="changecolor('assDE',oncolor)" onmouseout="changecolor('assDE',offcolor);closeall()">All Subconcepts</a></td></tr>
<tr><td class="menu" id="assDEC"><a href="javascript:getSubConceptsImmediate();" onmouseover="changecolor('assDEC',oncolor)" onmouseout="changecolor('assDEC',offcolor);closeall()">Immediate Subconcepts</a></td></tr>
</table>
</div>
<script language = "javascript">
getSearchComponent();
initPopupMenu2();
storeResultInArray();

</script>
</form>
</body>
</html>
