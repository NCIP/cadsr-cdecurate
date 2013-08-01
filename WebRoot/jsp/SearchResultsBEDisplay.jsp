<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/SearchResultsBEDisplay.jsp,v 1.4 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/ErrorPageWindow.jsp" />
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<html>
	<head>
		<title>
			Search Results
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SearchResults.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
   String sSelAC = "";
   String sKeyword, nRecs;
   String strBEDisplaySubmitted = (String)session.getAttribute("BEDisplaySubmitted");
   if(strBEDisplaySubmitted == null || strBEDisplaySubmitted.equals("")) strBEDisplaySubmitted = "false";
   session.setAttribute("BEDisplaySubmitted", "");
// System.out.println("SR BE.jsp strBEDisplaySubmitted: " + strBEDisplaySubmitted);  
   Vector results = new Vector();
   Vector vSelAttr = new Vector();
   results = (Vector)session.getAttribute("resultsBEDisplay");
   if (results == null)
    results = (Vector)session.getAttribute("results");
  // Do this so page will not bomb before it re-submits
   if(strBEDisplaySubmitted == "false")
      results = null;
  
  // String sMAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
 //  session.setAttribute("MenuAction", "searchForCreate");
   sKeyword = (String)session.getAttribute("creKeyword");
   nRecs = (String)session.getAttribute("recsFound");
   sSelAC = (String)session.getAttribute("searchAC");  //done now in CDEHomePage
   vSelAttr = (Vector)session.getAttribute("selectedAttr");

   if (sKeyword == null)
      sKeyword = "";
   if (nRecs == null)
      nRecs = "No ";
   if (sSelAC == null) sSelAC = "";
   if (sSelAC.equals("DataElement"))
      sSelAC = "Data Element"; 
   else if(sSelAC.equals("DataElementConcept"))
      sSelAC = "Data Element Concept";
   else if(sSelAC.equals("ValueDomain"))
      sSelAC = "Value Domain";
   else if(sSelAC.equals("ConceptualDomain"))
      sSelAC = "Conceptual Domain"; 
      
   String sLabelKeyword = "Selected Search Results";
   if (sSelAC.equals("Data Element"))
      sLabelKeyword = "Selected Data Element(s)";
   else if (!sSelAC.equals(""))
      sLabelKeyword = "Selected " + sSelAC + "s";
 
/*System.out.println("SR BEDisplay.jsp sMAction: " + sMAction);
System.out.println("SR BEDisplay.jsp sSelAC: " + sSelAC);
if(results != null) System.out.println("SR BE.jsp resultsBEDisplay.size2: " + results.size());
System.out.println("SR BE.jsp vSelAttr.size: " + vSelAttr.size());
System.out.println("SR BEDisplay.jsp sLabelKeyword: " + sLabelKeyword); */
%>

		<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
var numRows2;
var SelectAllOn = "false";

function setup()
{
<%
    if(strBEDisplaySubmitted.equals("false"))
    {
    %>
            document.searchBEDisplayForm.submit(); 
  <%} %>
}

/*   function getSearchComponent()
   {
    //get the selected component from the opener document or from session attribute
    <% // if (sMAction.equals("searchForCreate")) {%>
        sComp = opener.document.SearchActionForm.searchComp.value;
    <%// } else {%>
        sComp = "<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>";
    <%// }%>

   } */
   
  function closeWindow()
  {
      window.close();
  }

</SCRIPT>
	</head>
	<body onLoad="setup();">
		<form name="searchBEDisplayForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showBEDisplayResult">
			<br>
			<table width="100%">
				<tr>
					<td width="80%" align="center"></td>
					<td>
						<input type="button" name="closeBtn" value="Close Window" onClick="javascript:closeWindow();">
						&nbsp;
					</td>
				</tr>
				<tr></tr>
				<tr>
					<td>
						<font size="4">
							<b>
								<%=StringEscapeUtils.escapeHtml(sLabelKeyword)%>
							</b>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						<div align="left">
							<font size="2">
								<%=nRecs%>
								Records
							</font>
						</div>
					</td>
				</tr>
				<tr></tr>
			</table>
			<table width="100%" border="1" style="border-collapse: collapse" valign="top">
				<br>
				<tr valign="middle">

					<!-- adds Review status only if questions -->

					<%    int k = 0;
      if (vSelAttr != null)
      {
         //for review status increase the k size to 1
           k = vSelAttr.size();

        for (int i =0; i < vSelAttr.size(); i++) 
        {
          String sAttr = (String)vSelAttr.elementAt(i);
          //place heading if not null
          if (sAttr == null || sAttr.equals("")) continue;
          else
          {
            String sDisplay = sAttr;
            if (sAttr.equalsIgnoreCase("Name")) sDisplay = "Short Name";
            else if (sAttr.equals("Long Name")) 
            {
              if(sSelAC.equals("Data Element")) sDisplay = "Data Element Long Name";
              else if(sSelAC.equals("Data Element Concept")) sDisplay = "Data Element Concept Long Name";
              else if(sSelAC.equals("Value Domain")) sDisplay = "Value Domain Long Name";
              else if(sSelAC.equals("Conceptual Domain")) sDisplay = "Conceptual Domain Long Name";
            }
            else if (sAttr.equals("Value Domain")) sDisplay = "Value Domain Long Name";
            else if(sAttr.equals("Data Element Concept")) sDisplay = "Data Element Concept Long Name";
            else if (sAttr.equals("DE Long Name")) sDisplay = "Data Element Long Name";
%>
					<th method="get">
						<font size="2">
							<%=sDisplay%>
						</font>
					</th>
					<%            
	      }  
        }  
      }
%>
				</tr>
				<%
    String strResult = "";
    if (results != null)
	  {
      int j = 0;
		  for (int i = 0; i < results.size(); i+=k)
		  {
         //  String ckName = ("CK" + j);
           strResult = (String)results.get(i);
           if (strResult == null) strResult = "";
%>
				<tr>
					<td width="100">
						<font size="2">
							<%=strResult%>
						</font>
					</td>
					<%   
          // add other attributes
		 for (int m = 1; m < k; m++)
		 {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>
					<td>
						<font size="2">
							<%=strResult%>
						</font>
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
				<!-- stores Designation Name and ID -->
			</table>
			<!-- div for associated AC popup menu -->
			<script language="javascript">
//getSearchComponent();
</script>
		</form>
		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="itemType" value="">
			<input type="hidden" name="ac2ID" value="">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="isValidSearch" value="false">
		</form>
	</body>
</html>
