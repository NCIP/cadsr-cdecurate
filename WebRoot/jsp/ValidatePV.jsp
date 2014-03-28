<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidatePV.jsp,v 1.3 2009-04-21 03:47:36 hegdes Exp $
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
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.Session_Data"%>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
    boolean isValid = true;
    Vector vValidate = new Vector();
    vValidate = (Vector)request.getAttribute("vValidate");
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sStat = (String)vValidate.elementAt(i+2);
      if(sStat.equals("Valid")==false)
        isValid = false;
    }
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");  //remove the status messge if any
%>
		<script language="JavaScript">
   var evsWindow = null;

   function hourglass(){
      document.body.style.cursor = "wait";
   }
   function down_hourglass(){
      document.body.style.cursor = "default";
   }

   defaultStatus = "Validate Value Item status, go back to modify it or submit to create it"
   function submit()
   {
      hourglass();
      document.validatePVForm.Message.style.visibility="visible";
      defaultStatus = "Submitting data, it may take a minute, please wait....."
      document.validatePVForm.btnSubmit.disabled = true;
      document.validatePVForm.btnBack.disabled = true;
      document.validatePVForm.submit();
   }

   function EditPV()
   {
       document.validatePVForm.ValidatePVPageAction.value = "reEditPV";
       submit();
   }

   function SubmitValidate()
   {
      document.validatePVForm.ValidatePVPageAction.value = "submitPV";
      submit();
   }

   function DefSuggestion()
   {
      if (evsWindow && !evsWindow.closed)
        	evsWindow.focus();
      else
       	evsWindow = window.open("jsp/EVSSearch.jsp", "EVSWindow", "width=600,height=400,resizable=yes,scrollbars=yes");
   }
</script>
	</head>

	<body bgcolor="#666666">
		<form name="validatePVForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=validatePVFromForm">
			<font color="#CCCCCC"></font>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="764" height="29" valign="top">
						<% if (isValid == true) { %>
						<input type="button" name="btnSubmit" value="Submit" onClick="SubmitValidate()">
						<% } else { %>
						<input type="button" name="btnSubmit" value="Submit" onClick="SubmitValidate()" disabled>
						<% } %>
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" onClick="EditPV();">
						&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="400px" height="25px" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
				<!--  <tr  height="40">
    <td valign="middle"><label><font size="3"><strong><font size="4">Create/Edit
      <font color="#FF0000">Permissible Value</font> - Validate Mandatory & Optional
      Attributes</font></strong></font></label> <font size="4"></font>
  </tr> -->
			</table>
			<br>
			<table width="100%" border="2" cellspacing="0" cellpadding="0" bordercolor="#000000">
				<caption>
					<h3 align="left">
						Validate
						<font color="#FF0000">
							Permissible Value
						</font>
						Attributes
					</h3>
				</caption>
				<tr>
					<td width="282" height="20" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Name
								</font>
							</strong>
						</div>
					</td>
					<td valign="top" width="437" bgcolor="#FFFFFF" bordercolor="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Contents
								</font>
							</strong>
						</div>
					</td>
					<td width="101" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
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
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sItem = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i));
      String sContent = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i+1));
      if (sContent == null) sContent = "";
      String sStat = StringUtil.cleanJavascriptAndHtml((String)vValidate.elementAt(i+2));
      String sFont = "#000000";
      if (sStat.equals("Valid"))
        sFont = "#238E23";

      
%>
				<tr>
					<td height="20" valign="top" bgcolor="#FFFFFF" width="182" bordercolor="#000000">
						<strong>
							<%=sItem%>
						</strong>
					</td>
					<td valign="top" bgcolor="#FFFFFF" width="487" bordercolor="#000000">
						<%=sContent%>
						&nbsp;
					</td>
					<td valign="top" bgcolor="#FFFFFF" width="151" bordercolor="#000000">
						<font color="<%=sFont%>">
							<%=sStat%>
						</font>
						&nbsp;
					</td>
				</tr>
				<%
     
    }
%>
			</table>
			<input type="hidden" name="ValidatePVPageAction" value="nothing">
	</body>
</html>
