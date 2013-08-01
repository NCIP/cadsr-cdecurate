<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/DefSearchParameters.jsp,v 1.5 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.util.*"%>
<%@ page buffer="12kb"%>
<%@ page session="true"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>

<html>
	<head>
		<title>
			CDE Curation Tool: Search Enterprise Vocabulary System
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
String sLastKeyword = "";
sLastKeyword = (String)request.getAttribute("evsKeyword");
if (sLastKeyword == null) sLastKeyword = "";

// leave these in for hidden field outPrint at bottom
Vector vOCAttr = new Vector();
vOCAttr.addElement("Concept Name");
vOCAttr.addElement("Definition");
%>
		<Script Language="JavaScript">
  var metaWindow = null;
  var srch = null;
   var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
  


  function Setup()
  {
     document.EVSForm.tfSearchTerm.focus();
  }

  function Search()
  {
      document.body.style.cursor = "wait";
      document.EVSForm.actSelect.value = "SearchDef";
      document.EVSForm.submit();
  }

  function accessMetaphraseViewer()
  {
    if (metaWindow && !metaWindow.closed)
       metaWindow.focus();
    else
    //   metaWindow = window.open("http://ncievs3.nci.nih.gov/indexMetaphrase.html", "metaWindow");
       metaWindow = window.open("http://ncievs-test2.nci.nih.gov/indexMetaphrase.html", "metaWindow");
  }

  function enableButtons()
  {
   srch = EVSForm.tfSearchTerm.value;
	if (srch.length > 0)
	   EVSForm.btnSearch.disabled=false;
	else
 	   EVSForm.btnSearch.disabled=true;
  }

//  displayed when the enter key is pressed.
function keypress_handler(evt)
{
    var keycode = (window.event)?event.keyCode:evt.which;
    if(keycode != 13)
    {
        return true;  // only interest on return kay
    }
    hourglass();
    document.body.style.cursor = "wait";
    document.EVSForm.actSelect.value = "SearchDef";
    document.EVSForm.submit();
    return false;
}

function LoadKeyHandler()
{
    document.onkeypress = null;
    document.onkeypress = keypress_handler;
}

function hourglass()
{
    document.body.style.cursor = "wait";
}

</script>
	</head>

	<body onLoad="Setup();" onHelp="showHelp('html/Help_SearchAC.html#EVSSearchParmsForm_SearchDefinition',helpUrl); return false">
		<form name="EVSForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=searchACs">
			<table width="100%" class="sidebarBGColor">
				<col width="10px">
				<tr valign="center" align="left" class="firstRow">
					<th>
						1)&nbsp;&nbsp;Enter Search Term:
					</th>
				</tr>
				<tr>
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="text" name="tfSearchTerm" value="<%=sLastKeyword%>" onKeyUp="JavaScript:enableButtons()">
					</td>
				</tr>

				<tr align="left">
					<td height="50">
						<div style="margin-right: 10px">
							<b>
								2)&nbsp;&nbsp;Click the Start Search
							</b>
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; button to start the search.
							<br>
							<!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; want to use. <br>-->
						</div>
					</td>
				<tr align="left">
					<td height="50">
						<div style="margin-right: 10px">
							<b>
								3)&nbsp;&nbsp;Check the row
							</b>
							which
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; contains the definition you
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; want to use.
							<br>
						</div>
					</td>
				<tr align="left">
					<td height="50">
						<div style="margin-right: 10px">
							<b>
								4)&nbsp;&nbsp;Click the Use Selection
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; button
							</b>
							to paste the selected
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; text in the Definition text
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; box.
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div align="center">
						</div>
					</td>
				</tr>
				<tr height="50">
					<td align="center">
						<input type="button" name="btnSearch" value="Start Search" onclick="JavaScript:Search()" disabled >
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
				</tr>
				<input type="hidden" name="actSelect" value="SearchDef">
				<input type="hidden" name="outPrint" value="Print" style="visibility:hidden;" <% out.println(""+vOCAttr.size());// leave this in, it slows jsp load down so no jasper error%>>
			</table>
			<script language="javascript">
LoadKeyHandler();
</script>
		</form>
	</body>
</html>
