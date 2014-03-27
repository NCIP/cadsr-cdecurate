<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/SearchResults.jsp,v 1.14 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			Search Results
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/popupMenus.css" rel="stylesheet" type="text/css">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SearchResults.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/popupMenus.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		<%@ page import="java.util.*"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>
		
		<%
		
   UtilService serUtil = new UtilService();
   //capture the duration
   Date sDate = new Date();
 //  logger.info(serUtil.makeLogMessage(session, "SearchResults", "begin page", sDate, sDate));
   String strInitiatedFrom = (String)session.getAttribute("initiatedFrom");
   Vector results = new Vector();
   results = (Vector)session.getAttribute("results");
   if (results == null) results = new Vector();
   String sSelAC = "";
   //store these to get data for the checked row.
   Vector vSearchID = (Vector)session.getAttribute("SearchID");
   if (vSearchID == null)  vSearchID = new Vector();
   int numRows = 0;
   if(vSearchID.size()>0) numRows = vSearchID.size(); 
   Vector vSearchName = (Vector)session.getAttribute("SearchName");
   if (vSearchName == null)  vSearchName = new Vector();
   Vector vSearchLongName = (Vector)session.getAttribute("SearchLongName");
   if (vSearchLongName == null)  vSearchLongName = new Vector();
//System.out.println("sr jsp vSearchLongName.size: " + vSearchLongName.size()); 
   Vector vSearchASL = (Vector)session.getAttribute("SearchASL");
   if (vSearchASL == null)  vSearchASL = new Vector();
   Vector vSearchDefinitionAC = (Vector)session.getAttribute("SearchDefinitionAC");
   if (vSearchDefinitionAC == null)  vSearchDefinitionAC = new Vector();
   Vector vSearchDefSource = (Vector)session.getAttribute("SearchDefSource");
   if (vSearchDefSource == null) vSearchDefSource = new Vector();
   Vector vSearchUsedContext = (Vector)session.getAttribute("SearchUsedContext");
   if (vSearchUsedContext == null) vSearchUsedContext = new Vector();
   Vector vSearchMeanDescription = (Vector)session.getAttribute("SearchMeanDescription");
   if (vSearchMeanDescription == null)  vSearchMeanDescription = new Vector();

   //get the list of contexts to write for all three components
   Vector vWriteContextDE = (Vector)session.getAttribute("vWriteContextDE");
   if (vWriteContextDE == null)  vWriteContextDE = new Vector();
   Vector vWriteContextDEC = (Vector)session.getAttribute("vWriteContextDEC");
   if (vWriteContextDEC == null)  vWriteContextDEC = new Vector();
   Vector vWriteContextVD = (Vector)session.getAttribute("vWriteContextVD");
   if (vWriteContextVD == null)  vWriteContextVD = new Vector();

   //empty the alternate name and ref doc results from the session
   session.setAttribute("AllAltNameList", new Vector()); 
   session.setAttribute("AllRefDocList", new Vector()); 

   String sKeyword, nRecs;
   Vector vSelAttr = new Vector();
   Vector vCheckList = new Vector();
   String sMAction = StringUtil.cleanJavascriptAndHtml( (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION) );
   String sButtonPressed = (String)session.getAttribute("LastMenuButtonPressed");
   if (sButtonPressed == null) sButtonPressed = "undefined";
   //get the session attributes according searching from Menu or create page
   if (sMAction.equals("searchForCreate"))
   {
       sKeyword = (String)session.getAttribute("creKeyword");
       nRecs = (String)session.getAttribute("creRecsFound");
       sSelAC = (String)session.getAttribute("creSearchAC"); //done now in CDEHomePage
       vSelAttr = (Vector)session.getAttribute("creSelectedAttr");
       vCheckList = (Vector)session.getAttribute("creCheckList");
       session.setAttribute("creCheckList", new Vector());  //to avoid keep it selected make it empty only for searh window right now.
   }
   else
   {
       sKeyword = (String)session.getAttribute("serKeyword");
       sSelAC = (String)session.getAttribute("searchAC");  //done now in CDEHomePage
       	nRecs = (String)request.getAttribute("recsFound");
         vSelAttr = (Vector)session.getAttribute("selectedAttr");
       vCheckList = (Vector)session.getAttribute("CheckList");
   }
   // if sLabelKeyword has word "associated" then a getAssociated search was just done
   String sLabelKeyword =  (String)session.getAttribute("labelKeyword");
   if (sLabelKeyword == null)
   {
      sLabelKeyword = "";
    }
   if (sKeyword == null)
      sKeyword = "";
   if (nRecs == null)
      nRecs = "No ";
// logger.warn(sLabelKeyword + "jsp ac " + sSelAC);   
          
   //drop downlist visible text
  if ((sSelAC == null) || (sSelAC.equals("DataElement")))
    sSelAC = "Data Element";
  else if (sSelAC.equals("DataElementConcept"))
    sSelAC = "Data Element Concept";
  else if (sSelAC.equals("ValueDomain"))
    sSelAC = "Value Domain";
  else if (sSelAC.equals("ConceptualDomain"))
    sSelAC = "Conceptual Domain";
  else if (sSelAC.equals("PermissibleValue"))
    sSelAC = "Values/Meanings";
  else if (sSelAC.equals("ClassSchemeItems"))
    sSelAC = "Class Scheme Items";
  else if (sSelAC.equals("ValueMeaning"))
    sSelAC = "Value Meaning";

    //for button label text
  if ((sMAction == null) || (sMAction.equals("nothing")))
    sMAction = "nothing";
  else if ((sMAction.equals("NewDETemplate")) || (sMAction.equals("NewDECTemplate")) || (sMAction.equals("NewVDTemplate")))
    sMAction = "Create New from Existing";
  else if ((sMAction.equals("NewDEVersion")) || (sMAction.equals("NewDECVersion")) || (sMAction.equals("NewVDVersion")))
    sMAction = "Create New Version";
  else if ((sMAction.equals("editDE")) || (sMAction.equals("editDEC")) || (sMAction.equals("editVD")))
    sMAction = "Edit Selection";
  else if (sSelAC.equals("Questions") && !sMAction.equals("searchForCreate"))
    sMAction = "Complete Selected DE";
    
  if (sSelAC.equals("ObjectClass") || sSelAC.equals("Property"))
    sMAction = "nothing";
    
//System.out.println("XXX sr jsp sSelAC: " + sSelAC + " sMAction: " + sMAction);
  Vector vNewPV = (Vector)request.getAttribute("newPVData");
  if (vNewPV == null) vNewPV = new Vector();

  //get the server name to open cdeBrowser
  //String thisServer = request.getServerName();
  String browserURL = (String)session.getAttribute("BrowserURL");
  String sAppendAct = (String)request.getParameter("AppendAction");
   // this session attribute says the Back button on a getAssociated search result was hit,
   // so search results will be popped off of stack (in setup method)
  String sBackFromGetAssociated =  (String)session.getAttribute("backFromGetAssociated");
  if (sBackFromGetAssociated == null) sBackFromGetAssociated = "";
  session.setAttribute("backFromGetAssociated", ""); 

   // so search results will be popped off of stack (in setup method)
  String sSecondBackFromGetAssociated =  (String)session.getAttribute("SecondBackFromGetAssociated");
  if (sSecondBackFromGetAssociated == null) sSecondBackFromGetAssociated = "";
  session.setAttribute("SecondBackFromGetAssociated", ""); 
// System.out.println("sr sBackFromGetAssociated: " + sBackFromGetAssociated); 
// Use this in setup below
 Stack sSearchACStack = (Stack)session.getAttribute("sSearchACStack");
 Stack vResultStack = (Stack)session.getAttribute("vResultStack");
 if(vResultStack == null) vResultStack = new Stack();

 String pushBoolean = "false";
 String sSelectAll = "false";
// System.out.println(sSelectAll + " checksize " + vCheckList.size());
if(!sSelAC.equals("ValueMeaning"))
{
 if(vCheckList != null && vCheckList.size()>0)
  sSelectAll = "true";
 else
  sSelectAll = "false";
 } 
%>

		<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
    var numRows2;
    var SelectAllOn = <%=sSelectAll%>;
     var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
    
    function setup()
    {
        <!-- enables/disables associated sub menus -->
        initPopupMenu(document.searchParmsForm.listSearchFor.value);
        if (document.searchResultsForm.CheckGif != null)
        {
            if(SelectAllOn == true)
                document.searchResultsForm.CheckGif.alt = "Unselect All";
            else
                document.searchResultsForm.CheckGif.alt = "Select All";
        }
        //display status message if any 
 <%
        String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
        if (statusMessage == null) statusMessage = "";
        //statusMessage = "Value Domain Name : Malignant Neoplasm Neoplastic Cell\\nPublic ID : 2296135\\n\\t Successfully created New Value Domain";
        String sSubmitAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
        if (sSubmitAction == null) sSubmitAction = "nothing";
        Vector vStat = (Vector)session.getAttribute("vStatMsg");
        if (vStat != null && vStat.size() > 30)
        { %>
            displayStatusWindow();
     <% }
        else if (statusMessage != null && !statusMessage.equals(""))
        { 
            session.setAttribute("vStatMsg", new Vector());
        %>
            displayStatus("<%=statusMessage%>", "<%=StringEscapeUtils.escapeJavaScript(sSubmitAction)%>");
     <% }
        //reset the message attributes   
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
        if (vCheckList != null && vCheckList.size() >0)
        {
            // System.out.println("vchecklist " + vCheckList.size());
            for (int i=0; i<vCheckList.size(); i++)
            {
            %>
                EnableButtons("checked", "<%=vCheckList.elementAt(i)%>");
            <%
            }
        }
%>
        window.status = "Enter the keyword to search a component";
    
<%
        if (sBackFromGetAssociated.equals("backFromGetAssociated"))
        {
            Stack vSearchIDStack = (Stack)session.getAttribute("vSearchIDStack");
            Vector vIDs = (Vector)session.getAttribute("SearchID");
            if (vSearchIDStack != null && vSearchIDStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
//System.out.println("sr jsp before 1pop vSearchIDStack.size: " + vSearchIDStack.size());
                vIDs = (Vector)vSearchIDStack.pop();
            } 
            if (vSearchIDStack != null && vSearchIDStack.size()>0)
            {
                vIDs = (Vector)vSearchIDStack.pop();
//System.out.println("sr jsp after 2pop vSearchIDStack.size: " + vSearchIDStack.size());
          // do not lose the very first search result
      //    if(vSearchIDStack.size()==0) 
      //    {
                vSearchIDStack.push(vIDs);
//System.out.println("sr jsp after push vSearchIDStack.size: " + vSearchIDStack.size());
       //   }
                session.setAttribute("vSearchIDStack", vSearchIDStack);
                session.setAttribute("SearchID", vIDs);
                // Set the nRecs when Back button hit
                Integer nRecsInt;
                if (vIDs != null)
                    nRecsInt = new Integer(vIDs.size());
                else
                    nRecsInt = new Integer(0);
                nRecs = nRecsInt.toString();
            }
            Stack vSearchNameStack = (Stack)session.getAttribute("vSearchNameStack");
            Vector vNames = (Vector)session.getAttribute("SearchName");
            if (vSearchNameStack != null && vSearchNameStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vNames = (Vector)vSearchNameStack.pop();
            }
            if (vSearchNameStack != null && vSearchNameStack.size()>0)
            {
                vNames = (Vector)vSearchNameStack.pop();
          // do not lose the very first search result
       //   if(vSearchNameStack.size()==0) 
        //  {
                vSearchNameStack.push(vNames);
       //   }
                session.setAttribute("vSearchNameStack", vSearchNameStack);
                session.setAttribute("SearchName", vNames);
            }
      
            Stack vSearchLongNameStack = (Stack)session.getAttribute("vSearchLongNameStack");
            Vector vLongNames = (Vector)session.getAttribute("SearchLongName");
            if (vSearchLongNameStack != null && vSearchLongNameStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vLongNames = (Vector)vSearchLongNameStack.pop();
            } 
            if (vSearchLongNameStack != null && vSearchLongNameStack.size()>0)
            {
                vLongNames = (Vector)vSearchLongNameStack.pop();
          // do not lose the very first search result
       //   if(vSearchNameStack.size()==0) 
        //  {
                vSearchLongNameStack.push(vLongNames);
       //   }
                session.setAttribute("vSearchLongNameStack", vSearchLongNameStack);
                session.setAttribute("SearchLongName", vLongNames);
            }
        
            Stack vACSearchStack = (Stack)session.getAttribute("vACSearchStack");
            Vector vACSearch = (Vector)session.getAttribute("vACSearch");
            if (vACSearchStack != null && vACSearchStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vACSearch = (Vector)vACSearchStack.pop();
            } 
            if (vACSearchStack != null && vACSearchStack.size()>0)
            {
                vACSearch = (Vector)vACSearchStack.pop();
        // do not lose the very first search result
     //   if(vACSearchStack.size()==0) 
     //   {
                vACSearchStack.push(vACSearch);
      //  }
                session.setAttribute("vACSearchStack", vACSearchStack);
                session.setAttribute("vACSearch", vACSearch);
            }
      
            Stack vSearchASLStack = (Stack)session.getAttribute("vSearchASLStack");
            vSearchASL = (Vector)session.getAttribute("SearchASL");
            if (vSearchASL == null)  vSearchASL = new Vector();
            if (vSearchASLStack != null && vSearchASLStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vSearchASL = (Vector)vSearchASLStack.pop();
            } 
            if (vSearchASLStack != null && vSearchASLStack.size()>0)
            {
                vSearchASL = (Vector)vSearchASLStack.pop();
//System.out.println("sr jsp 2pop vSearchASL2.size: " + vSearchASL.size());
        // do not lose the very first search result
    //    if(vSearchASLStack.size()==0) 
     //   {
                vSearchASLStack.push(vSearchASL);
     //   }
                session.setAttribute("vSearchASLStack", vSearchASLStack);
                session.setAttribute("SearchASL", vSearchASL);
            } 

            Stack vSelRowsStack = (Stack)session.getAttribute("vSelRowsStack");
            Vector vRSel = (Vector)session.getAttribute("vSelRows");
            if (vSelRowsStack != null && vSelRowsStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vRSel = (Vector)vSelRowsStack.pop();
            } 
            if (vSelRowsStack != null && vSelRowsStack.size()>0)
            {
                vRSel = (Vector)vSelRowsStack.pop();

        // do not lose the very first search result
     //   if(vSelRowsStack.size()==0) 
     //   {
                vSelRowsStack.push(vRSel);
     //   }
                session.setAttribute("vSelRowsStack", vSelRowsStack);
                session.setAttribute("vSelRows", vRSel);
            }

      // set number of records variable
            if (vRSel != null) numRows = vRSel.size();

            if (vResultStack != null && vResultStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                results = (Vector)vResultStack.pop();
            } 
            if (vResultStack != null && vResultStack.size()>0)
            {
                results = (Vector)vResultStack.pop();
     //   if(vResultStack.size()==0) 
      //  {
                vResultStack.push(results);
                pushBoolean = "true";
     //   }
                session.setAttribute("vResultStack", vResultStack);
                session.setAttribute("results", results);
            }
        } %>
    }

  function Back()
  {
    hourglass();
    document.searchResultsForm.pageAction.value = "backFromGetAssociated";
    <% if (sBackFromGetAssociated.equals("backFromGetAssociated"))
       {
          session.setAttribute("SecondBackFromGetAssociated", "True");
        }
          %>
    document.searchResultsForm.submit();
  }

   function getSearchComponent()
   {
    //get the selected component from the opener document or from session attribute
    <%  if (sMAction.equals("searchForCreate")) {%>
          if (opener && opener.document != null && opener.document.SearchActionForm != null)
            sComp = opener.document.SearchActionForm.searchComp.value;
    <% } else { %>
          sComp = "<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>";
    <% }%>

       //call the function to fill the newly created pv in opener document
       //UpdateOpenerForNew();
   }

   //opens edit/create page if not the regular search, or uses the selection for search From create.
   function ShowSelection()
   {
       ShowUseSelection("<%=StringEscapeUtils.escapeJavaScript(sMAction)%>");
   }

   //no use!!!!!
   function reSetAttribute()
   {
<%     Vector vDECResult = new Vector();
       session.setAttribute("results", vDECResult);
       session.setAttribute("creRecsFound", "No ");
%>
   }

   //gets some attribute for the selelcted row and enables/disables the button
   function EnableButtons(checked, currentField)
   {
      EnableCheckButtons(checked, currentField, "<%=StringEscapeUtils.escapeJavaScript(sMAction)%>", "<%=StringEscapeUtils.escapeJavaScript(sButtonPressed)%>", "<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>")
   }

   //check if the user has permission to delete in the context called from designate record
   function hasWritePermission(vWrContext)
   {
      var doesExist = "false";
      if (document.searchParmsForm.listSearchFor.value == "DataElement")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextDE.size(); i++)
		  {
          String sWCont = (String)vWriteContextDE.elementAt(i);
%>
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }
      else if (document.searchParmsForm.listSearchFor.value == "DataElementConcept")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextDEC.size(); i++)
		  {
          String sWCont = (String)vWriteContextDEC.elementAt(i);
%>
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }
      else if (document.searchParmsForm.listSearchFor.value == "ValueDomain")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextVD.size(); i++)
		  {
          String sWCont = (String)vWriteContextVD.elementAt(i);
%>        
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }

      if (doesExist == "false")
      {
         alert("User does not have a permission to delete a component in " + vWrContext + " context.")
         return "No";
      }
      else
          return "Yes";
   }

  //if the created, update the opener document
  function UpdateOpenerForNew()
  {
 <% if (vNewPV.size() > 0)
    {
         String sPVid = (String)vNewPV.elementAt(0);
         String sPValue = (String)vNewPV.elementAt(1);
         String sPVmean = (String)vNewPV.elementAt(2);
 %>
         if (opener.document != null && opener.document.createVDForm != null)
         {
            var idx = parseInt(opener.document.createVDForm.valueCount.value);
            opener.document.createVDForm.selValuesList[idx].value = "<%=sPVid%>";
            opener.document.createVDForm.selValuesList[idx].text = "<%=sPValue%>";
            opener.document.createVDForm.selMeaningsList[idx].value = "<%=sPValue%>";
            opener.document.createVDForm.selMeaningsList[idx].text = "<%=sPVmean%>";
            opener.document.createVDForm.hiddenMeanText.value = "<%=sPVmean%>";
            idx++;

            opener.document.createVDForm.valueCount.value = idx;
         }
<%
    }
%>
  }
  
  //get detail button and calls the function in the js passing server name from the request.
  function GetDetails()
  {
      GetDetailsJS("<%=browserURL%>");
  }
  //sorts by heading.  called from column heading Hyperlink click event
  function SetSortType(sortBy)
  {
      SetSortTypeJS(sortBy, "<%=StringEscapeUtils.escapeJavaScript(sMAction)%>");
  }
  
  function SelectAll()
  {
    var numRows2 = "<%=numRows%>"; 
    var CK = "";
    if(SelectAllOn == false)
    {
      for(k=0; k<numRows2; k++)
      {
        CK = "CK" + k;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked == false)
        {
          formObj.checked=true;
          EnableButtons(true,formObj);
        }
      }
      SelectAllOn = "true";
      if (document.searchResultsForm.CheckGif != null)
          document.searchResultsForm.CheckGif.alt = "Unselect All";
      ShowSelectedRows(true);
    }
    else
    {
      for(m=0; m<numRows2; m++)
      {
        CK = "CK" + m;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked==true)
        {
          formObj.checked=false;
          EnableButtons(false,formObj);
        }
      }
      SelectAllOn = "false";
       if (document.searchResultsForm.CheckGif != null)
          document.searchResultsForm.CheckGif.alt = "Select All";
      ShowSelectedRows(false);
    }
  }


</SCRIPT>
	</head>
	<body onLoad="setup();">
		<form name="searchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showResult">
			<table width="100%" border="0" valign="top">
				<tr>
					<td height="7">
				</tr>
				<tr height="20" valign="top">

					<td align="left">
						<%
    String buttons[] = new String[17];
    if (sMAction.equals("searchForCreate")) {
        buttons[0] = "<!-- searchForCreate -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"Link Concept\" onClick=\"ShowUseSelection();\" disabled>\n&nbsp;\n";
    } else if (((sMAction.equals("Edit Selection")) || (sMAction.equals("nothing"))) && ((sSelAC.equals("Value Meaning"))||(sSelAC.equals("Data Element")) || (sSelAC.equals("Data Element Concept")) || (sSelAC.equals("Value Domain")))){
        buttons[1] = "<!-- nothing -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"Edit Selection\" onClick=\"ShowEditSelection();\" disabled "
			+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_Editing',helpUrl); return false\">\n&nbsp;\n";
    } else if (!sMAction.equals("Create New from Existing") && !sMAction.equals("Create New Version") &&(sSelAC.equals("Data Element") || sSelAC.equals("Data Element Concept") || sSelAC.equals("Value Domain"))) {
        buttons[2] = "<!-- Create New from Existing -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"Edit Selection\" onClick=\"ShowEditSelection();\" disabled "
			+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_Editing',helpUrl); return false\">\n&nbsp;\n";
    } else if (!sMAction.equals("nothing") && !sSelAC.equals("Questions") && !sSelAC.equals("Class Scheme Items") && !sSelAC.equals("Conceptual Domain") && !sSelAC.equals("ConceptClass")) {
        buttons[3] = "<!-- other -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"" + sMAction + "\" onClick=\"ShowEditSelection();\" disabled>\n&nbsp;\n";
    } else if (sMAction.equals("Complete Selected DE") && sSelAC.equals("Questions")) {
        buttons[4] = "<!-- Complete Selected DE -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"" + sMAction + "\" onClick=\"ShowEditSelection();\" disabled "
			+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_completeSelectedDE',helpUrl); return false\">\n&nbsp;\n";
    } else if (sButtonPressed.equals("Search") && (sSelAC.equals("Data Element") || sSelAC.equals("Data Element Concept") || sSelAC.equals("Value Domain")||sSelAC.equals("Value Meaning"))) {
        buttons[5] = "<!-- Search -->\n"
            + "<input type=\"button\" name=\"editSelectedBtn\" value=\"Edit Selection\" onClick=\"ShowEditSelection();\" disabled>\n&nbsp;\n";
    }
    if ((sSelAC.equals("Data Element") || sSelAC.equals("Data Element Concept") || sSelAC.equals("Value Domain")) && !sMAction.equals("searchForCreate")) {
        buttons[16] = "<!-- !searchForCreate -->\n"
            + "<br/><input type=\"button\" name=\"monitorBtn\" value=\"Monitor\" onClick=\"monitorCmd();\" disabled "
            + "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_monitor',helpUrl); return false\">\n&nbsp;\n"
            + "<input type=\"button\" name=\"unmonitorBtn\" value=\"Unmonitor\" onClick=\"unmonitorCmd();\" disabled "
            + "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_monitor',helpUrl); return false\">\n&nbsp;\n"
            + "<input type=\"button\" name=\"uploadBtn\" value=\"Upload Document(s)\" onClick=\"uploadCmd();\" disabled "
            + "onHelp = \"showHelp('html/Help_SearchAC.html#Upload_Attachments',helpUrl); return false\">\n&nbsp;\n";
    } 
    if (sSelAC.equals("Data Element") && !sMAction.equals("searchForCreate"))  // || sSelAC.equals("Data Element Concept") || sSelAC.equals("Value Domain") || (sSelAC.equals("Questions") && sMAction.equals("searchForCreate")))
    {
        buttons[7] = "<!-- designation button only for DE, DEC, VD in both the searches, exclude DDE  -->\n"
            + "<input type=\"button\" name=\"designateBtn\" value=\"Designations\" onClick=\"designateRecord();\" disabled "
			+ "onHelp = \"showHelp('html/Help_DesignateDE.html#searchResultsForm_designateDE',helpUrl); return false\" >\n&nbsp;\n";
    } 
    if (sSelAC.equals("Data Element") && !sMAction.equals("searchForCreate")) {
        buttons[8] = "<!-- details button only for DE, exclude DDE  -->\n"
            + "<input type=\"button\" name=\"detailsBtn\" value=\"Details\" onClick=\"GetDetails();\" disabled "
			+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_Details',helpUrl); return false\">\n&nbsp;\n";
    } 
    if ((sSelAC.equals("Data Element") || sSelAC.equals("Data Element Concept") || sSelAC.equals("Value Domain")) && !sMAction.equals("searchForCreate")) {
        buttons[9] = "<!-- Append button only for DE, DEC, VD in only the main search  -->\n"
            + "<input type=\"button\" name=\"AppendBtn\" value=\"Append\" onClick=\"setAppendAction();\" disabled "
			+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_append',helpUrl); return false\">\n&nbsp;\n";
    } 
    if (sMAction.equals("searchForCreate")) {
        buttons[11] = "<!-- makes close button only if page opened from createDE or VD pages   -->\n"
            + "<input type=\"button\" name=\"closeBtn\" value=\"Close Window\" onClick=\"javascript:closeWindow();\">\n&nbsp;\n";
    } else{
        buttons[12] = "<!-- makes showSelection, designate, clear buttons otherwise   -->\n"
            + "<input type=\"button\" name=\"showSelectedBtn\" value=\"Show Selected Rows\" onClick=\"ShowSelectedRows(true);\" disabled "
            + "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_showSelectedBtn',helpUrl); return false\">\n&nbsp;\n";
        if (!sSelAC.equals("Questions")) {
            buttons[13] = "<!-- button get Associated with popup menu   -->\n"
                + "<input id=\"assACBtn\" type=button name=\"associateACBtn\" value=\"Get Associated\"  onmouseover=\"controlsubmenu(event,'divAssACMenu',null,null,null)\" onmouseout=\"closeall()\" disabled "
				+ "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_getAssociated',helpUrl); return false\">\n&nbsp;\n";
        }
        buttons[14] = "<input type=\"button\" name=\"clearBtn\" value=\"Clear Records\" onClick=\"clearRecords();\" ";
        if(nRecs.equals("No ") || nRecs.equals("0"))
        {
            buttons[14] = buttons[14] + "disabled ";
        }
        buttons[14] = buttons[14]
            + "onHelp = \"showHelp('html/Help_SearchAC.html#searchResultsForm_clearBtn',helpUrl); return false\">\n&nbsp;\n";
    } 
    //System.out.println("SR.jsp!!! vResultStack.size: " + vResultStack.size()+""+sBackFromGetAssociated.equals("backFromGetAssociated")+""+sMAction); 
    if (((vResultStack.size()>0 && sBackFromGetAssociated.equals("backFromGetAssociated") && !pushBoolean.equals("true"))
          || vResultStack.size()>1) && !sMAction.equals("searchForCreate")) {
        buttons[15] = "<input type=\"button\" name=\"btnBack\" value=\"Back\" onClick=\"Back();\">\n&nbsp;&nbsp;\n";
    }
    for (int i = 0; i < buttons.length; ++i)
    {
        if (buttons[i] != null)
        {
            %>
						<%=buttons[i]%>
						<%
        }
    }
    %>
						<img name="Message" src="images/SearchMessage.gif" width="180px" height="25px" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<table width="100%" valign="top">
				<tr>
					<td height="7">
				</tr>
				<tr>
					<td>
						<font size="4">
							<b>
								Search Results for
								<%=StringEscapeUtils.escapeHtml(sLabelKeyword)%>
							</b>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						<font size="2">
							&nbsp;
							<%=nRecs%>
							Records Found
						</font>
					</td>
				</tr>
				<tr>
					<td height="7">
				</tr>
			</table>
			<table width="100%" border="1" valign="top">
				<tr valign="middle">
					<%    if (sSelAC.equals("Data Element") || !sMAction.equals("searchForCreate")) {     %>
					<th height="30">
						<a href="javascript:SelectAll()">
							<img id="CheckGif" src="images/CheckBox.gif" border="0" alt="Select All" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
						</a>
					</th>
					<%    } else   { %>
					<th height="30">
						<img src="images/CheckBox.gif" border="0" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</th>
					<%    } %>

					<!-- adds Review status only if questions -->
					<%  if (sSelAC.equals("Questions") && !sMAction.equals("searchForCreate")) {  %>
					<th height="30">
						<a>
							Curation Status
						</a>
					</th>
					<% } %>
					<!-- add other headings -->
					<%    int k = 0;
      if (vSelAttr != null)
      {
         //for review status increase the k size to 1
        if (sSelAC.equals("Questions"))
           k = vSelAttr.size() + 1;
        else
           k = vSelAttr.size();

        for (int i =0; i < vSelAttr.size(); i++) {
          String sAttr = (String)vSelAttr.elementAt(i);

          if (sAttr.equals("Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('name')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Short Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Alias Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('aliasName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Name/Alias Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Long Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('longName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							<%                if(sSelAC.equals("Data Element"))   { %>
							Data Element Long Name
							<%                } else if(sSelAC.equals("Data Element Concept"))   { %>
							Data Element Concept Long Name
							<%                } else if(sSelAC.equals("Value Domain"))   { %>
							Value Domain Long Name
							<%                } else if(sSelAC.equals("Conceptual Domain"))   { %>
							Conceptual Domain Long Name
							<%                } else   { %>
							Long Name
							<%                } %>
						</a>
					</th>
					<%        } else if (sAttr.equals("Question Text")) { %>
					<th method="get">
						<a href="javascript:SetSortType('QuestText')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Question Text
						</a>
					</th>
					<%        } else if (sAttr.equals("DE Long Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('DELongName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Element Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("DE Public ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('DEPublicID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							DE Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Highlight Indicator")) { %>
					<th method="get">
						<a href="javascript:SetSortType('HighLight')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Highlight Indicator
						</a>
					</th>
					<%        } else if (sAttr.equals("Definition")) { %>
					<th method="get">
						<a href="javascript:SetSortType('def')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition
						</a>
					</th>
					<%        } else if (sAttr.equals("Owned By Context")) { %>
					<th method="get">
						<a href="javascript:SetSortType('context')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Owned By Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Context")) { %>
					<th method="get">
						<a href="javascript:SetSortType('context')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Used By Context")) { %>
					<th method="get">
						<a href="javascript:SetSortType('UsedContext')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Used By Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Value Domain")) { %>
					<th method="get">
						<a href="javascript:SetSortType('vd')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Domain Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Data Element Concept")) { %>
					<th method="get">
						<a href="javascript:SetSortType('DEC')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Element Concept Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Version")) { %>
					<th method="get">
						<a href="javascript:SetSortType('version')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Version
						</a>
					</th>
					<%        } else if (sAttr.equals("Public ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('minID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Public_ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Question Public ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('minID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Question Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Workflow Status")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Status')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Workflow Status
						</a>
					</th>
					<%        } else if (sAttr.equals("Protocol ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('ProtoID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Protocol ID
						</a>
					</th>
					<%        } else if (sAttr.equals("CRF Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CRFName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CRF Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Type of Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('TypeName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Type of Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Effective Begin Date")) { %>
					<th method="get">
						<a href="javascript:SetSortType('BeginDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Effective Begin Date
						</a>
					</th>
					<%        } else if (sAttr.equals("Effective End Date")) { %>
					<th method="get">
						<a href="javascript:SetSortType('EndDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Effective End Date
						</a>
					</th>
					<%        } else if (sAttr.equals("Language")) { %>
					<th method="get">
						<a href="javascript:SetSortType('language')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Language
						</a>
					</th>
					<%        } else if (sAttr.equals("Change Note")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Comments')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Change Note
						</a>
					</th>
					<%        } else if (sAttr.equals("Origin")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Origin')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Origin
						</a>
					</th>
					<%        } else if (sAttr.equals("Conceptual Domain")) { %>
					<th method="get">
						<a href="javascript:SetSortType('ConDomain')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Conceptual Domain
						</a>
					</th>
					<%        } else if (sAttr.equals("Valid Values")) { %>
					<th method="get">
						<a href="javascript:SetSortType('validValue')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Valid Value
						</a>
					</th>
					<%        } else if (sAttr.equals("Classification Schemes")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Class')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Classification Schemes
						</a>
					</th>
					<%        } else if (sAttr.equals("Class Scheme Items")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSI')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Class Scheme Items
						</a>
					</th>
					<%        } else if (sAttr.equals("Unit of Measures")) { %>
					<th method="get">
						<a href="javascript:SetSortType('UOML')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Unit of Measures
						</a>
					</th>
					<%        } else if (sAttr.equals("Data Type")) { %>
					<th method="get">
						<a href="javascript:SetSortType('DataType')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Type
						</a>
					</th>
					<%        } else if (sAttr == null || sAttr.equals("Comments")) { %>
					<th method="get">
						<a href="javascript:SetSortType('comment')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Comments
						</a>
					</th>
					<%        } else if (sAttr.equals("Display Format")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Format')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Display Format
						</a>
					</th>
					<%        } else if (sAttr.equals("Maximum Length")) { %>
					<th method="get">
						<a href="javascript:SetSortType('MaxLength')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Maximum Length
						</a>
					</th>
					<%        } else if (sAttr.equals("Minimum Length")) { %>
					<th method="get">
						<a href="javascript:SetSortType('MinLength')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Minimum Length
						</a>
					</th>
					<%        } else if (sAttr.equals("High Value Number")) { %>
					<th method="get">
						<a href="javascript:SetSortType('HighNum')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							High Value Number
						</a>
					</th>
					<%        } else if (sAttr.equals("Low Value Number")) { %>
					<th method="get">
						<a href="javascript:SetSortType('LowNum')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Low Value Number
						</a>
					</th>
					<%        } else if (sAttr.equals("Decimal Place")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Decimal')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Decimal Place
						</a>
					</th>
					<%        } else if (sAttr.equals("Type Flag")) { %>
					<th method="get">
						<a href="javascript:SetSortType('TypeFlag')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Type Flag
						</a>
					</th>
					<%        } else if (sAttr.equals("Value")) { %>
					<th method="get">
						<a href="javascript:SetSortType('value')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value
						</a>
					</th>
					<%        } else if (sAttr.equals("Value Meaning Long Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Meaning Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Public ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							VM Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Version")) { %>
					<th method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							VM Version
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Description")) { %>
					<th method="get">
						<a href="javascript:SetSortType('MeanDesc')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Meaning Description
						</a>
					</th>
					<%        } else if (sAttr.equals("Meaning Description")) { %>
					<th method="get">
						<a href="javascript:SetSortType('MeanDesc')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Meaning Description
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("caDSR Component")) { %>
					<th method="get">
						<a href="javascript:SetSortType('cadsrComp')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							caDSR Component
						</a>
					</th>
					<%        } else if (sAttr.equals("Vocabulary")) { %>
					<th method="get">
						<a href="javascript:SetSortType('database')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Vocabulary
						</a>
					</th>
					<%        } else if (sAttr.equals("Description Source")) { %>
					<th method="get">
						<a href="javascript:SetSortType('descSource')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Description Source
						</a>
					</th>
					<%        } else if (sAttr.equals("Identifier")) { %>
					<th method="get">
						<a href="javascript:SetSortType('Ident')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("DEC's Using")) { %>
					<th method="get">
						<a href="javascript:SetSortType('decUse')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							DEC's Using
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSIName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CSI Name
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Type")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSITL')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CSI Type
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Definition")) { %>
					<th method="get">
						<a href="javascript:SetSortType('def')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CSI Definition
						</a>
					</th>
					<%        } else if (sAttr.equals("Permissible Value")) { %>
					<th method="get">
						<a href="javascript:SetSortType('permValue')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Permissible Value
						</a>
					</th>
					<%        } else if (sAttr.equals("CS Long Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Long Name
						</a>
					</th>
					<%       
				    } else if (sAttr.equals("CS Public ID")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Public ID
						</a>
					</th>
					<%       
				       } else if (sAttr.equals("CS Version")) { %>
					<th method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Version
						</a>
					</th>
					<%        } else if (sAttr.equals("Registration Status")) { %>
					<th method="get">
						<a href="javascript:SetSortType('regStatus')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Registration Status
						</a>
					</th>
					<%        } else if (sAttr.equals("Date Created")) { %>
					<th method="get">
						<a href="javascript:SetSortType('creDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Date Created
						</a>
					</th>
					<%        } else if (sAttr.equals("Creator")) { %>
					<th method="get">
						<a href="javascript:SetSortType('creator')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Creator
						</a>
					</th>
					<%        } else if (sAttr.equals("Date Modified")) { %>
					<th method="get">
						<a href="javascript:SetSortType('modDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Date Modified
						</a>
					</th>
					<%        } else if (sAttr.equals("Modifier")) { %>
					<th method="get">
						<a href="javascript:SetSortType('modifier')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Modifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Concept Name")) { %>
					<th method="get">
						<a href="javascript:SetSortType('conName')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Concept Name
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("EVS Identifier")) { %>
					<th method="get">
						<a href="javascript:SetSortType('umls')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							EVS Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Identifier")) { %>
					<th method="get">
						<a href="javascript:SetSortType('umls')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Definition Source")) { %>
					<th method="get">
						<a href="javascript:SetSortType('source')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition Source
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Database")) { %>
					<th method="get">
						<a href="javascript:SetSortType('db')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Database
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Alternate Names")) { %>
					<th method="get">
						<a href="javascript:SetSortType('altNames')">
							Alternate Names
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Reference Documents")) { %>
					<th method="get">
						<a href="javascript:SetSortType('refDocs')">
							Reference Documents
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Derivation Relationship")) { %>
					<th method="get">
						<a href="javascript:SetSortType('DerRelation')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Derivation Relationship
						</a>
					</th>
					<%        } else if (sAttr.equals("Dimensionality")) { %>
					<th method="get">
						<a href="javascript:SetSortType('dimension')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Dimensionality
						</a>
					</th>
					<%
	        }  }  }
%>
				</tr>
				<%
    String strResult = "";
    if (results != null)
	  {
      int rsize = results.size();
      int j = 0;
		  for (int i = 0; i < results.size(); i+=k)
		  {
           String ckName = ("CK" + j);
           strResult = (String)results.get(i);
           if (strResult == null) strResult = "";
%>
				<tr>
					<td width="5">
						<input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);" <%if((vCheckList != null && vCheckList.contains(ckName))){%> checked <%}%> onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>
					<%     if (sSelAC.equals("Questions") && !sMAction.equals("searchForCreate"))
       {
          //if edit, display the status as complete, otherwise incomplete
          if (strResult.equals("Edit"))   {  %>
					<td>
						Attributes Completed
					</td>
					<%        } else {  %>
					<td>
						Incomplete
					</td>
					<%        }
       } else {  %>
					<td width="150">
						<%=strResult%>
					</td>
					<%     }
          // add other attributes
		 for (int m = 1; m < k; m++)
		 {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>
					<td>
						<%=strResult%>
					</td>
					<%
       }
%>
					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
				</tr>
				<%
         j++;
    }
	 }
%>
			</table>
			<table>
				<input type="hidden" name="pageAction" value="nothing">
				<input type="hidden" name="AttChecked" value="<%=(k-5)%>">
				<input type="hidden" name="searchComp" value="">
				<input type="hidden" name="numSelected" value="">
				<input type="hidden" name="sortType" value="nothing">
				<input type="hidden" name="actSelected" value="Search">
				<input type="hidden" name="numAttSelected" value="">
				<input type="hidden" name="orgCompID" value="">
				<input type="hidden" name="desID" value="">
				<input type="hidden" name="desName" value="">
				<input type="hidden" name="desContext" value="">
				<input type="hidden" name="desContextID" value="">
				<input type="hidden" name="AppendAction" value="NotAppended">
				<input type="hidden" name="SelectAll" value="">
				<input type="hidden" name="isValid" value="false">
				<input type="hidden" name="serMenuAct" value="<%=StringEscapeUtils.escapeHtml(sMAction)%>"/>
				<input type="hidden" name="serRecCount" value="<%=nRecs%>">
				<input type="hidden" name="selRowID" value="">
				<!-- stores Designation Name and ID -->
				<select size="1" name="hiddenDesIDName" style="visibility:hidden;" multiple>
				</select>
				<!-- stores selected component ID and workflow status -->
				<select size="1" name="hiddenACIDStatus" style="visibility:hidden;" multiple>
				</select>

				<!-- stores results ID and Short Names -->
				<select size="1" name="hiddenSearch" style="visibility:hidden;width:50">
					<%   
      vSearchID = (Vector)session.getAttribute("SearchID");
      if (vSearchID == null)  vSearchID = new Vector();
      vSearchName = (Vector)session.getAttribute("SearchName");
      if (vSearchName == null)  vSearchName = new Vector();
      for (int i = 0; vSearchID.size()>i; i++)
      {
        String sID = (String)vSearchID.elementAt(i);
        String sName = "";
        if (vSearchName.size() > i)
          sName = (String)vSearchName.elementAt(i);
        else
          sName = "";
  %>
					<option value="<%=sID%>">
						<%=sName%>
					</option>
					<%
      }
  %>
				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName" style="visibility:hidden;">
					<% 
    vSearchASL = (Vector)session.getAttribute("SearchASL");
    if (vSearchASL == null)  vSearchASL = new Vector();
    for (int i = 0; vSearchASL.size()>i; i++)
    {
      String sASL = (String)vSearchASL.elementAt(i);
        if(sASL == null) sASL = "";
%>
					<option value="<%=sASL%>">
						<%=sASL%>
					</option>
					<%
    }
%>
				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName2" style="visibility:hidden;width:100;">

					<%    for (int i = 0; vSearchLongName.size()>i; i++)
      {
        String sName = (String)vSearchLongName.elementAt(i);
%>
					<option value="<%=sName%>">
						<%=sName%>
					</option>
					<%
      }
%>
				</select>
				<!-- store definition and context here to use it later in javascript -->
				<select size="1" name="hiddenDefSource" style="visibility:hidden;width:100">
					<%
      String sDef = "";
      for (int i = 0; vSearchDefinitionAC.size()>i; i++)
      {
          sDef = (String)vSearchDefinitionAC.elementAt(i);
          String sUsed = "";
          if (vSearchUsedContext.size() > i)
             sUsed = (String)vSearchUsedContext.elementAt(i);
          if (sUsed == null) sUsed = "";
%>
					<option value="<%=sUsed%>">
						<%=sDef%>
					</option>
					<%
      }
%>
				</select>
				<select size="1" name="hiddenMeanDescription" style="visibility:hidden;width:100">
					<%
      String sDesc = "";
      for (int i = 0; vSearchMeanDescription.size()>i; i++)
      {
          sDesc = (String)vSearchMeanDescription.elementAt(i);
%>
					<option value="<%=sDesc%>">
						<%=sDesc%>
					</option>
					<%
      }
%>
				</select>
				<select size="1" name="hiddenPVValue" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMean" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMeanDesc" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenSelectedRow" style="visibility:hidden;">
				</select>
			</table>
			<!-- div for associated AC popup menu -->
			<div id="divAssACMenu" style="position:absolute;z-index:1;visibility:hidden;width:175px;">
				<table border="3" cellspacing="0" cellpadding="0">
					<tr>
						<td class="menu" id="assDE">
							<a href="javascript:getAssocDEs();" onmouseover="changecolor('assDE',oncolor)" onmouseout="changecolor('assDE',offcolor);closeall()">
								Data Elements
							</a>
						</td>
					</tr>
					<%if (!sSelAC.equals("Value Meaning")){ %>
					<tr>
						<td class="menu" id="assDEC">
							<a href="javascript:getAssocDECs();" onmouseover="changecolor('assDEC',oncolor)" onmouseout="changecolor('assDEC',offcolor);closeall()">
								Data Element Concepts
							</a>
						</td>
					</tr>
					<%} %>
					<tr>
						<td class="menu" id="assVD">
							<a href="javascript:getAssocVDs();" onmouseover="changecolor('assVD',oncolor)" onmouseout="changecolor('assVD',offcolor);closeall()">
								Value Domains
							</a>
						</td>
					</tr>
				</table>
			</div>
			<script language="javascript">
getSearchComponent();
</script>
		</form>
		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="ac2ID" value="">
			<input type="hidden" name="itemType" value="">
			<input type="hidden" name="isValidSearch" value="false">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="SelContext" value="">
			<input type="hidden" name="editPVInd" value="">
			<input type="hidden" name="pageAction" value="nothing">
			</form>
	</body>
	<% 
    //capture duration
  //  logger.info(serUtil.makeLogMessage(session, "SearchResults", "end page", sDate, new Date())); 
%>
</html>
