<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateVD.jsp,v 1.8 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>
<html>
	<head>
		<title>
			ValidateVD
		</title>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.Session_Data"%>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    boolean isValid = true;
    boolean isValidFlag = true;
    Vector vValidate = new Vector();
    vValidate = (Vector)request.getAttribute("vValidate");
    String vdIDSEQ = (String) request.getAttribute("vdIDSEQ");
    boolean inForm = false;
    if (vdIDSEQ != null && vdIDSEQ.length() > 0)
    	inForm = true;
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sStat = (String)vValidate.elementAt(i+2);
      if(sStat.startsWith("Valid") || sStat.equals("No Change") || sStat.contains("Warning:"))
          isValid = true; // this just keeps the status quo
      else
          isValidFlag = false; // we have true failure here
    }
    isValid = isValidFlag;
    String sVDAction = (String)session.getAttribute("VDAction");
%>
		<script language="JavaScript">
   var evsWindow = null;

   //alert the message if any.
  function displayStatusMessage()
  {
 <%
    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    if (statusMessage != null && !statusMessage.equals(""))
    { %>
	       alert("<%=statusMessage%>");
 <% }
    //reset the status message to no message
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
%>
  }

   function hourglass(){
      document.body.style.cursor = "wait";
   }
   function down_hourglass(){
      document.body.style.cursor = "default";
   }

   defaultStatus = "Validate Data Element status, go back to modify it or submit to create it"
   function submit()
   {
      hourglass();
      document.validateVDForm.Message.style.visibility="visible";
      defaultStatus = "Submitting data, it may take a minute, please wait....."
      document.validateVDForm.btnSubmit.disabled = true;
      document.validateVDForm.btnBack.disabled = true;
      document.validateVDForm.submit();
   }

   function EditVD()
   {
       var valVDPageAction = document.getElementsByName("ValidateVDPageAction");
       valVDPageAction[0].value = "reEditVD";
       submit();
   }

   function SubmitValidate()
   {
      var valVDPageAction = document.validateVDForm.ValidateVDPageAction;
      valVDPageAction.value = "submitVD";
      submit();
   }

   function DefSuggestion()
   {
      if (evsWindow && !evsWindow.closed)
        evsWindow.focus();
      else
       	evsWindow = window.open("jsp/EVSSearch.jsp", "EVSWindow", "width=600,height=400,resizable=yes,scrollbars=yes");
   }
    var newwindow;
function openUsedWindowVM(idseq, type)
{
var newUrl = '../../cdecurate/NCICurationServlet?reqType=showUsedBy';
newUrl = newUrl + '&idseq=' +idseq+'&type='+type;

	newwindow=window.open(newUrl,'Used By Forms','height=400,width=600,toolbar=no,scrollbars=yes,menubar=no');
	if (window.focus) {newwindow.focus()}


}
</script>

	</head>

	<body bgcolor="#666666">
		<form name="validateVDForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=validateVDFromForm">
			<font color="#CCCCCC"></font>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="1200" height="29" valign="top">
						<% if (isValid == true) { %>
						<input type="button" name="btnSubmit" value="Submit" onClick="SubmitValidate()">
						<% } else { %>
						<input type="button" name="btnSubmit" value="Submit" onClick="SubmitValidate()" disabled>
						<% } %>
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" onClick="EditVD();">
						&nbsp;&nbsp;
						<img name="Message" src="images/SubmitMessageFinal.gif" width="300px" height="25px" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<br>

			<table width="100%" border="2" cellspacing="0" cellpadding="0" BORDERCOLOR="#000000">
				<%if(sOriginAction.equals("BlockEditVD")){ %>
				<caption>
					<h3 align="left">
						Validate the
						<font color="#FF0000">
							Value Domains
						</font>
						Block Edit Attributes
					</h3>
				</caption>
				<% } else { %>
				<caption>
					<h3 align="left">
						Validate
						<font color="#FF0000">
							Value Domain
						</font>
						Attributes
					</h3>
					<%if (inForm){%>
						<br>
						<font size=4 color="#FF0000">Note:</font>
						<font size=4> Value Domain is used in a form. <a href="javascript:openUsedWindowVM('<%=vdIDSEQ%>','VD');">View Usage</a></font>
					<%}%>
				</caption>
				<% } %>
				<tr>
					<!--    <th> <font size=2>Attribute Name</font> </th>
    <th> <font size=2>Attribute Contents</font> </th>
    <th> <font size=2>Validation Status</font> </th> -->
					<td width="182" height="20" valign="top" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Name
								</font>
							</strong>
						</div>
					</td>
					<td valign="top" width="487" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Contents
								</font>
							</strong>
						</div>
					</td>
					<td width="151" valign="top" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Validation Status
								</font>
							</strong>
						</div>
					</td>
				</tr>
				<%
    //Vector vValidate = new Vector();
    //vValidate = (Vector)request.getAttribute("vValidate");
 if (vValidate != null)
  {
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sItem = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i));
      String sContent = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i+1));
      if (sContent == null) sContent = "";
      //System.out.println("content " + sContent);
      String sStat = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i+2));
      String sFont = "#000000";
      if (sStat.startsWith("Valid") || sStat.equals("No Change"))
        sFont = "#238E23";
     
%>
				<tr>
					<td height="20" valign="top" bgcolor="#FFFFFF" width="182" BORDERCOLOR="#000000">
						<strong>
							<%=sItem%>
						</strong>
					</td>
					<td valign="top" bgcolor="#FFFFFF" width="487" BORDERCOLOR="#000000">
						<%=sContent%>
					</td>
					<td valign="top" bgcolor="#FFFFFF" width="151" BORDERCOLOR="#000000">
						<font color="<%=sFont%>">
							<%=sStat%>
						</font>
					</td>
				</tr>

				<%  
    }
}
%>
			</table>
			<input type="hidden" name="ValidateVDPageAction" value="nothing">
			<script language="javascript">
displayStatusMessage();
</script>
		</form>
	</body>
</html>
