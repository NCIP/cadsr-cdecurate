<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ValidateVD.jsp,v 1.7 2007-01-26 20:17:45 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>ValidateVD</title>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
    String sOriginAction = (String)session.getAttribute("originAction");
    if (sOriginAction == null) sOriginAction = "";
    boolean isValid = true;
    boolean isValidFlag = true;
    Vector vValidate = new Vector();
    vValidate = (Vector)request.getAttribute("vValidate");
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sStat = (String)vValidate.elementAt(i+2);
      if(sStat.equals("Valid") || sStat.equals("No Change"))
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
    String statusMessage = (String)session.getAttribute("statusMessage");
    if (statusMessage != null && !statusMessage.equals(""))
    { %>
	       alert("<%=statusMessage%>");
 <% }
    //reset the status message to no message
    session.setAttribute("statusMessage", "");
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
       document.validateVDForm.ValidateVDPageAction.value = "reEditVD";
       submit();
   }

   function SubmitValidate()
   {
      document.validateVDForm.ValidateVDPageAction.value = "submitVD";
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

<body bgcolor = "#666666">
<form name="validateVDForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=validateVDFromForm" >
<font color="#CCCCCC"></font>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="1200" height="29" valign="top">
      <% if (isValid == true) { %>
          <input type="button" name="btnSubmit" value="Submit" style="width:125" onClick="SubmitValidate()">
      <% } else { %>
          <input type="button" name="btnSubmit" value="Submit" style="width:125" onClick="SubmitValidate()" disabled>
      <% } %>
        &nbsp;&nbsp;
      <input type="button" name="btnBack" value="Back" style="width:125" onClick="EditVD();">
        &nbsp;&nbsp;
      <img name="Message" src="Assets/SubmitMessageFinal.gif" width="300" height="25" alt="WaitMessage" style="visibility:hidden;">
    </td>
  </tr>
</table>
<br>

<table width="100%" border="2" cellspacing="0" cellpadding="0" BORDERCOLOR="#000000">
 <%if(sOriginAction.equals("BlockEditVD")){ %>
       <caption>
        <h3 align="left">Validate the <font color="#FF0000">Value Domains </font>Block Edit Attributes</h3>
        </caption>
     <% } else { %>
        <caption>
        <h3 align="left">Validate <font color="#FF0000">Value Domain </font>Attributes</h3>
        </caption>
     <% } %>
  <tr>
<!--    <th> <font size=2>Attribute Name</font> </th>
    <th> <font size=2>Attribute Contents</font> </th>
    <th> <font size=2>Validation Status</font> </th> -->
     <td width="182" height="20" valign="top" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
      <div align="center"><strong><font size="3">Attribute Name</font></strong></div>
    </td>
    <td valign="top" width="487" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
      <div align="center"><strong><font size="3">Attribute Contents</font></strong></div>
    </td>
    <td width="151" valign="top" bgcolor="#FFFFFF" BORDERCOLOR="#000000">
      <div align="center"><strong><font size="3">Validation Status</font></strong></div>
    </td> 
  </tr>
<%
    //Vector vValidate = new Vector();
    //vValidate = (Vector)request.getAttribute("vValidate");
 if (vValidate != null)
  {
    for (int i = 0; vValidate.size()>i; i = i+3)
    {
      String sItem = (String)vValidate.elementAt(i);
      String sContent = (String)vValidate.elementAt(i+1);
      if (sContent == null) sContent = "";
      //System.out.println("content " + sContent);
      String sStat = (String)vValidate.elementAt(i+2);
      String sFont = "#000000";
      if (sStat.equals("Valid") || sStat.equals("No Change"))
        sFont = "#238E23";
     
%>
        <tr>
          <td height="20" valign="top" bgcolor="#FFFFFF" width="182" BORDERCOLOR="#000000"><strong><%=sItem%></strong></td>
          <td valign="top" bgcolor="#FFFFFF" width="487" BORDERCOLOR="#000000"><%=sContent%></td>
          <td valign="top" bgcolor="#FFFFFF" width="151" BORDERCOLOR="#000000"><font color="<%=sFont%>"> <%=sStat%> </font></td>
        </tr>

<%  
    }
}
%>
</table>
<input type="hidden" name="ValidateVDPageAction" value="nothing">
<script language = "javascript">
displayStatusMessage();
</script>
</form>
</body>
</html>
