<!--
Copyright ScenPro Inc, SAIC-F

Distributed under the OSI-approved BSD 3-Clause License.
See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
-->

<!-- Copyright (c) 2006 ScenPro, Inc.
$Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/SearchResultsBlocks.jsp,v 1.19 2009-05-05 19:39:27 veerlah Exp $
$Name: not supported by cvs2svn $
-->

<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<html debug="true">
        <head>
        <title>
        Search Results
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
        <link href="css/popupMenus.css" rel="stylesheet" type="text/css">
        <!-- GF33087 load Dojo -->
        <link href="js/dojo/dijit/themes/claro/claro.css" rel="stylesheet" type="text/css">
        <style type="text/css">
        .dijitDialog {
        width: 300px;
        }
        .dialogConfirmButtons {
        border-top: 1px solid #ccc;
        padding-top: 3px;

        }
        </style>
        <%--<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.5/dojo/dojo.js" data-dojo-config="async: true"></script>--%>
        <script src="js/dojo/dojo/dojo.js" data-dojo-config="async: true"></script>
        <script>
        <%--require(["dojo"], function(dojo){--%>
        <%--dojo.ready(function(){--%>
        window.console && console.log("CreateDEC.jsp DOJO version used = [" + dojo.version.toString() + "]");
        <%--});--%>
        <%--});--%>
        </script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/SearchResultsBlocks.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/popupMenus.js"></SCRIPT>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/app.js"></SCRIPT>
        <%--<script type="text/javascript" src="https://getfirebug.com/firebug-lite-debug.js"></script>--%>
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
   String sMAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
   if (sMAction != null && sMAction.equals("searchForCreate"))  // || sMAction.equals("BEDisplay"))
   {
       sKeyword = (String)session.getAttribute("creKeyword");
       nRecs = (String)session.getAttribute("creRecsFound");
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
   String sLabelKeyword =  (String)session.getAttribute("labelKeyword");
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
    
  if (sSelAC.contains("Qualifier") || sSelAC.equals("VMConcept") || sSelAC.equals("EditVMConcept"))
  	allowNVP = true;
 // System.out.println(sSelAC + " allow nvp " + allowNVP);	
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
  else if (sSelAC.equals("VMConcept") || sSelAC.equals("EditVMConcept") )
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
  EVS_Bean selBean = (EVS_Bean)request.getAttribute(VMForm.REQUEST_SEL_CONCEPT);
  if (selBean == null) selBean = new EVS_Bean();
%>

        <SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
        var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";

        var evsWindow2 = null;
        var selDefinition = null;
        var numRowsSelected = 0;
        var checkBoxArray = new Array();
        var conArray = new Array();
        var metaName = "";
        var dsrName = "";
        var arrDefSrc = new Array();
        var isSel = false;
        var evsNewUrl = "<%=ToolURL.getEVSNewTermURL(pageContext)%>";
        var nonEVSRepTermSearch = "false";
        function setup()
        {
            <%
	    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
	    if (statusMessage == null) statusMessage = "";
	    String sSubmitAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
	    if (sSubmitAction == null) sSubmitAction = "nothing";
	 %>
        displayStatus("<%=statusMessage%>", "<%=StringEscapeUtils.escapeJavaScript(sSubmitAction)%>");
            <%
	    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
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
        var sComp2 = opener.document.PVForm.selectedParentConceptMetaSource.value;
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
        else if (sComp == "VMConcept" || sComp == "EditVMConcept") type = "Concept";
        else if (sComp == "ParentConcept") type = "Parent Concept";

            <% } else { %>
        sComp = "<%=StringEscapeUtils.escapeHtml(sSelAC)%>";
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

        function ShowSelection() {
            document.searchResultsForm.Message.style.visibility='visible';

            if (opener.document == null)
                window.close();

            ShowUseSelection("<%=StringEscapeUtils.escapeJavaScript(sMAction)%>");
        }

        function reSetAttribute()
        {
            <%
       Vector vDECResult = new Vector();
       session.setAttribute("results", vDECResult);
       session.setAttribute("creRecsFound", "No ");
%>
        }

        function EnableButtons(checked, currentField, isAConcept, conceptName, conceptID)
        {
        if (opener.document == null)
        window.close();

        EnableCheckButtons(checked, currentField, "<%=StringEscapeUtils.escapeJavaScript(sMAction)%>")
        opener.document.newDECForm.isAConcept.value = isAConcept;		//GF30798
        //alert("SearchResultsBlocks EnableButtons called!");
        //begin GF33087
        opener.document.newDECForm.conceptName.value = conceptName? conceptName: '';
        opener.document.newDECForm.conceptID.value = conceptID? conceptID: '';
        var tempStr = 'SearchResultsBlocks.jsp EnableButtons conceptName [' + opener.document.newDECForm.conceptName.value + '] conceptID [' + opener.document.newDECForm.conceptID.value + ']';
        window.console && console.log(tempStr);
        //alert(tempStr);
        //end GF33087

        //begin GF32723
        var userVocab = document.searchParmsForm.listContextFilterVocab[document.searchParmsForm.listContextFilterVocab.selectedIndex].text;  //window.userSelectedVocab
        opener.document.newDECForm.value = userVocab;
        window.console && console.log('SearchResultsBlocks.jsp EnableButtons opener.document.newDECForm.value = [' + opener.document.newDECForm.value + ']');
        //end GF32723
        }

        function EnableButtonWithTxt(currentField)
        {
        document.searchParmsForm.keyword.value="";
            <%
          String temp1 = (String)session.getAttribute("creSearchAC");
          Boolean temp2 =(Boolean)session.getAttribute("ApprovedRepTerm");
          if(temp1.equals("RepTerm")&& temp2.booleanValue())
        {
        %>
        var rowindex = currentField.substring(2, currentField.length);
        document.searchParmsForm.keyword.value="* "+ conArray[rowindex].conName;
            <%}
        %>

        }
        function EnableButtonWithTxt1(currentField,id)
        {
        document.searchParmsForm.keyword.value="";
            <%
          String temp3 = (String)session.getAttribute("creSearchAC");
          Boolean temp4 =(Boolean)session.getAttribute("ApprovedRepTerm");
          if(temp3.equals("RepTerm")&& temp4.booleanValue())
        {  	        	
        %>
        var rowindex = currentField.substring(2, currentField.length);
        document.searchParmsForm.keyword.value=conArray[rowindex].conName;
        nonEVSRepTermSearch ="true";
        document.searchParmsForm.nonEVSRepTermSearch.value = nonEVSRepTermSearch;
        document.searchParmsForm.conid.value = conArray[rowindex].conID;
            <%}
        %>
        doSearchBuildingBlocks();
        }

        function getSubConceptsAll()
        {
        if (opener.document == null)
        window.close();
        getSubConceptsAll2("<%=StringEscapeUtils.escapeJavaScript(sUISearchType2)%>")
        }

        function getSubConceptsImmediate()
        {
        if (opener.document == null)
        window.close();
        getSubConceptsImmediate2("<%=StringEscapeUtils.escapeJavaScript(sUISearchType2)%>")
        }

        function getSuperConcepts()
        {
        if (opener.document == null)
        window.close();
        getSuperConcepts2("<%=StringEscapeUtils.escapeJavaScript(sUISearchType2)%>")
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
	  //System.out.println("Exception in search results blocks " + e.toString());
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

        <body>
        <form name="searchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=doSortBlocks">
        <br>
        <table border="0">
        <tr align="left">
        <td>
        <input type="button" name="editSelectedBtn" value="Link Concept" onClick="this.disabled=true;ShowSelection();" disabled>
        &nbsp;&nbsp;
        <input type="button" name="btnSubConcepts" value="Get Subconcepts" onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)" onmouseout="closeall()" disabled>
        &nbsp;&nbsp;
        <input type="button" name="btnSuperConcepts" value="Get Superconcepts" disabled onclick="javascript:getSuperConcepts();">
        &nbsp;&nbsp;
        <input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();">
        &nbsp;&nbsp;
        <input type="button" name="btnSubmitToEVS" value="Suggest to EVS" onclick="javascript:NewTermSuggested();">
        &nbsp;&nbsp;
        <img name="Message" src="images/SearchMessage.gif" width="180px" height="25" alt="WaitMessage" style="visibility:hidden;" align="top">
        </td>
        </tr>
        </table>
        <br>
        <table width="100%" valign="top">
            <%
				Boolean temp =(Boolean)session.getAttribute("ApprovedRepTerm");
				if(sSelAC.equals("Parent Concept")){%>
        <tr>
        <td>
        <font size="4">
        <b>
        Search Results for Parent Concept -
            <%=sLabelKeyword%>
        </b>
        </font>
        </td>
        </tr>
            <% }else if(sSelAC.equals("Rep Term") && temp.booleanValue()){%>
        <tr>
        <td>
        <font size="4">
        <b>
        Preferred List of Rep Term Primary Concepts
        </b>
        </font>
        </td>
        </tr>
            <% } else {
				if(!(sSelAC.equals("Rep Term") && temp.booleanValue()))
				%>
        <tr>
        <td>
        <font size="4">
        <b>
        Search Results for
            <%=sLabelKeyword%>
        </b>
        </font>
        </td>
        </tr>
            <%}%>
        <tr>
        <td>
        <font size="2">
        &nbsp;
            <%=nRecs%>
        Records Found
        </font>
        </td>
        </tr>
        </table>
        <table width="100%" border="1" valign="top">
        <tr valign="middle">
            <%    if (isSelAll) { %>
        <th height="30px" width="30px">
        <a href="javascript:SelectAll('<%=nRecs%>')">
        <img id="CheckGif" src="images/CheckBox.gif" border="0" alt="Select All">
        </a>
        </th>
            <%    } else   { %>
        <th height="30px" width="30px">
        <img src="images/CheckBox.gif" border="0">
        </th>
            <%    } %>
            <% if(sSelAC.equals("Rep Term") && temp.booleanValue()){ %>
        <th height="30px" width="30px">
        <img src="images/CheckBox.gif" border="0">
        </th>
        <th height="30px" width="30px">
        <img src="images/CheckBox.gif" border="0">
        </th>
        <!-- add other headings -->
            <% }
      int k = 0;
      if (vSelAttr != null)
      {
        k = vSelAttr.size();
        for (int i =0; i < vSelAttr.size(); i++)
        {
          String sAttr = (String)vSelAttr.elementAt(i);
          if (sAttr == null || sAttr.equals("Concept Name")) { %>
        <th method="get">
        <a href="javascript:SetSortType('name')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Concept Name
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("EVS Identifier")) { %>
        <th method="get">
        <a href="javascript:SetSortType('umls')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        EVS Identifier
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("Public ID")) { %>
        <th method="get">
        <a href="javascript:SetSortType('publicID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Public_ID
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("Version")) { %>
        <th method="get">
        <a href="javascript:SetSortType('version')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Version
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("Definition")) { %>
        <th method="get">
        <a href="javascript:SetSortType('def')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Definition
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("Definition Source")) { %>
        <th method="get">
        <a href="javascript:SetSortType('source')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Definition Source
        </a>
        </th>
            <%        } else if (sAttr == null || sAttr.equals("Workflow Status")) { %>
        <th method="get">
        <a href="javascript:SetSortType('asl')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Workflow Status
        </a>
        </th>
            <%        } else if (sAttr == null || sAttr.equals("Context")) { %>
        <th method="get">
        <a href="javascript:SetSortType('context')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Context
        </a>
        </th>
            <%        } else if (sAttr == null || sAttr.equals("Semantic Type")) { %>
        <th method="get">
        <a href="javascript:SetSortType('semantic')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Semantic Type
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("Vocabulary")) { %>
        <th method="get">
        <a href="javascript:SetSortType('db')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Vocabulary
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("caDSR Component")) { %>
        <th method="get">
        <a href="javascript:SetSortType('cadsrComp')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        caDSR Component
        </a>
        </th>
            <%        }   else if (sAttr == null || sAttr.equals("DEC's Using")) { %>
        <th method="get">
        <a href="javascript:SetSortType('decUse')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        DEC's Using
        </a>
        </th>
            <%        } else if (sAttr.equals("Level")) { %>
        <th method="get">
        <a href="javascript:SetSortType('Level')" onHelp="showHelp('Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
        Level
        </a>
        </th>
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
      EVS_Bean eBean = null;
      int j = 0;
      for (int i = 0; i < results.size(); i+=k)
      {
      	int nvp = 0;
        if (vSearchRes.size() > j)
        {
          eBean = (EVS_Bean)vSearchRes.get(j);
          if (eBean == null) eBean = new EVS_Bean();
          String strVocab = eBean.getEVS_DATABASE();  
          vName = eBean.getVocabAttr(uBean, strVocab, EVSSearch.VOCAB_DBORIGIN, EVSSearch.VOCAB_NAME);  // "vocabDBOrigin", "vocabName");
          nvp = eBean.getNAME_VALUE_PAIR_IND();
          // System.out.println(eBean.getCONCEPT_NAME() + " nvp " + nvp);
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
        <td width="5px" valign="top">
        <input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this, false);">
        </td>
            <% if(sSelAC.equals("Rep Term") && temp.booleanValue()){ %>
        <td width="5px" valign="top">
        <img src="images/search_light.gif" border="0" alt="Perform a Rep Term search using the primary concept." onClick="javascript:EnableButtonWithTxt1('<%=ckName%>');">
        </td>
        <td width="5px" valign="top">
        <img src="images/copy.gif" border="0" alt="Paste the concept name into Search Term field." onClick="javascript:EnableButtonWithTxt('<%=ckName%>');">
        </td>
            <%} %>
        <td width="150px" valign="top">
            <%=strResult%>
        <br>
            <% //add the text box for NVP under concept name
            		if (allowNVP && nvp > 0 && vSelAttr.contains("Concept Name"))
            		{
            	%>
        <br>
        &nbsp;&nbsp;Enter Concept Value
        <br>
        &nbsp;&nbsp;
        <input type="text" name="nvp_<%=ckName%>" id="nvp_<%=ckName%>" maxlength="10" width="80%" onkeyup="" value="">
            <% }	%>
        </td>
            <%    }else{%>
        <tr>
        <td width="5px" valign="top">
        <input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this, true);">
        </td>
        <td width="150px" valign="top">
        <a href="<%=showConceptInTree%>">
            <%=strResult%>
        </a>
        <br>
            <% //add the text box for NVP under concept name
            		if (allowNVP && nvp > 0 && vSelAttr.contains("Concept Name"))
            		{
            	%>
        <br>
        &nbsp;&nbsp;Enter Concept Value
        <br>
        &nbsp;&nbsp;
        <input type="text" name="nvp_<%=ckName%>" id="nvp_<%=ckName%>" maxlength="10" size="30" onkeyup="" value="">
            <% }	%>
        </td>
            <%    } %>
            <%
		   for (int m = 1; m < k; m++)
		   {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>
        <td valign="top">
            <%=strResult%>
        </td>
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

        <select size="1" name="hiddenResults" style="visibility:hidden;width:145px">
            <%  for (int m = 0; results.size()>m; m++)
    {
       String sName = (String)results.elementAt(m);
%>
        <option value="<%=sName%>">
            <%=sName%>
        </option>
            <%
    }
%>
        </select>
        <select size="1" name="hiddenSelectedRow" style="visibility:hidden;">
        </select>
        </div>
        <div id="divAssACMenu" style="position:absolute;z-index:1;visibility:hidden;width:185px;">
        <table id="tblAssACMenu" border="3" cellspacing="0" cellpadding="0">
        <tr>
        <td class="menu" id="assDE">
        <a href="javascript:getSubConceptsAll();" onmouseover="changecolor('assDE',oncolor)" onmouseout="changecolor('assDE',offcolor);closeall()">
        All Subconcepts
        </a>
        </td>
        </tr>
        <tr>
        <td class="menu" id="assDEC">
        <a href="javascript:getSubConceptsImmediate();" onmouseover="changecolor('assDEC',oncolor)" onmouseout="changecolor('assDEC',offcolor);closeall()">
        Immediate Subconcepts
        </a>
        </td>
        </tr>
        </table>
        </div>
        <script language="javascript">
        setup();
        getSearchComponent();
        initPopupMenu2();
        storeResultInArray();
        </script>
        </form>
        </body>
        </html>
