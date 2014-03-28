<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ValidateDEC.jsp,v 1.5 2009-04-21 03:47:34 hegdes Exp $
    $Name: not supported by cvs2svn $
-->
<%@ page contentType="text/html;charset=WINDOWS-1252"%>
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.common.Constants" %>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>

<HTML>
	<HEAD>
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<TITLE>
			CreateOrDisplayDEC
		</TITLE>
		<%
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    boolean isValid = false;
    boolean isValidFlag = true;
    String sStat2 = "";
    Vector vValidate = new Vector();
    vValidate = (Vector)request.getAttribute("vValidate");
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sStat = (String)vValidate.elementAt(i+2);
      if(sStat == null) sStat = "";
      if(sStat.length()>24)
        sStat2 = sStat.substring(0,24);
      if(sStat2 == null) sStat2 = "";
      if(sStat.startsWith("Valid") || sStat.equals("No Change") || sStat2.equals("Warning: This DEC should")
      || sStat2.equals("Warning: a Data Element ") || sStat2.equals("Warning: DEC's with comb")) {
          isValid = true; // this just keeps the status quo
      }
      else
      {
        isValidFlag = false; //GF32649 mandatory field should not be allowed to submit    
      }
    }
    isValid = isValidFlag;	//GF32649 mandatory field should not be allowed to submit
	//System.out.println("isValid: " + isValid);
    String sDECAction = (String)session.getAttribute("DECAction");
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

    defaultStatus = "Validate Data Element status, go back to modify it or submit to create it"
    function submit()
    {
       hourglass();
       document.validateDECForm.Message.style.visibility="visible";
       defaultStatus = "Submitting data, it may take a minute, please wait....."
       document.validateDECForm.btnSubmit.disabled = true;
       document.validateDECForm.btnBack.disabled = true;
       document.validateDECForm.submit();
    }

    function EditDEC()
    {
       document.validateDECForm.ValidateDECPageAction.value = "reEditDEC";
       submit();
    }

    function SubmitValidate()
    {
       document.validateDECForm.ValidateDECPageAction.value = "submitDEC";
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
	</HEAD>
	<body bgcolor="#666666">

		<form name="validateDECForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=validateDECFromForm">

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
						<input type="button" name="btnBack" value="Back" onClick="EditDEC();">
						&nbsp;&nbsp;
						<img name="Message" src="images/SubmitMessageFinal.gif" width="300px" height="25px" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
			</table>
			<br>

			<table width="100%" border="2" cellspacing="0" cellpadding="0" bordercolor="#000000">
				<%if(sOriginAction.equals("BlockEditDEC")){ %>
				<caption>
					<h3 align="left">
						Validate the
						<font color="#FF0000">
							Data Element Concepts
						</font>
						Block Edit Attributes
					</h3>
				</caption>
				<% } else { %>
				<caption>
					<h3 align="left">
						Validate
						<font color="#FF0000">
							Data Element Concept
						</font>
						Attributes
					</h3>
				</caption>
				<% } %>
				<tr>
					<td width="182" height="20" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Name
								</font>
							</strong>
						</div>
					</td>
					<td valign="top" width="487" bgcolor="#FFFFFF" bordercolor="#000000">
						<div align="center">
							<strong>
								<font size="3">
									Attribute Contents
								</font>
							</strong>
						</div>
					</td>
					<td width="151" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
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
      if(sItem != null && sItem.equals("Alternate Definition")) {
	String temp = (String)session.getAttribute(Constants.FINAL_ALT_DEF_STRING);
	System.out.println("temp [" + temp + "] temp.trim().indexOf(null) = " + temp.trim().indexOf("null"));
      	if (!temp.trim().equals("null")) {
      		sContent = temp;	//GF30798
	}
      }
      String sFont = "#000000";
      if (sStat.startsWith("Valid") || sStat.equals("No Change"))
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
			<input type="hidden" name="ValidateDECPageAction" value="nothing">

		</form>
	</body>
</html>
