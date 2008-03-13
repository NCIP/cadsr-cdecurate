<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateVM.jsp,v 1.3 2008-03-13 18:07:44 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<html>
	<head>
		<title>
			ValidateVD
		</title>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
		VMForm thisForm = (VMForm)request.getAttribute(VMForm.REQUEST_FORM_DATA); 
    String vmNameDisplay = thisForm.vmDisplayName;

    boolean isValid = true;
    Vector vValidate = new Vector();
    vValidate = (Vector)request.getAttribute(Session_Data.REQUEST_VALIDATE);
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sStat = (String)vValidate.elementAt(i+2);
      if(sStat.startsWith("Valid")==false)
        isValid = false;
    }
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");  //remove the status messge if any    
%>
		<script language="JavaScript">
	 var elmPageAction = "<%=VMForm.ELM_PAGE_ACTION%>";

   function hourglass(){
      document.body.style.cursor = "wait";
   }

   //defaultStatus = "Validate Data Element status, go back to modify it or submit to create it"
   function submitPage(sAction)
   {
			var actObject = document.getElementById(elmPageAction);
			if ( actObject != null && sAction != "")
			{
      	actObject.value = sAction;  // "reEditVM""submitVM";
	      hourglass();
	      document.validateVMForm.Message.style.visibility="visible";
	      defaultStatus = "Submitting data, it may take a minute, please wait....."
	      document.validateVMForm.btnSubmit.disabled = true;
	      document.validateVMForm.btnBack.disabled = true;
	      document.validateVMForm.submit();
      }
   }

</script>
	</head>

	<body>
		<form name="validateVMForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=<%=VMForm.ELM_FORM_REQ_VAL%>">
			<table width="100%" border="0">
				<tr>
					<td valign="top">
						<input type="button" name="btnSubmit" value="Submit" style="width:125" onClick="submitPage('<%=VMForm.ACT_SUBMIT_VM%>');" <% if (!isValid) { %> disabled <% } %>>
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" style="width:125" onClick="submitPage('<%=VMForm.ACT_REEDIT_VM%>');">
						&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<br>
			<table width="100%" border="2" cellspacing="0" cellpadding="0" bordercolor="#000000">
				<caption>
					<h3 align="left">
						Validate
						<font color="#FF0000">
							Value Meaning
						</font>
						<%=vmNameDisplay%>
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
      String sItem = (String)vValidate.elementAt(i);
      String sContent = (String)vValidate.elementAt(i+1);
      if (sContent == null) sContent = "";
      String sStat = (String)vValidate.elementAt(i+2);
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
			<input type="hidden" name="<%=VMForm.ELM_PAGE_ACTION%>" value="<%=VMForm.ACT_PAGE_DEFAULT%>">
	</body>
</html>
