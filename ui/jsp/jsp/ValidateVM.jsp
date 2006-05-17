<!-- ValidateVD.jsp -->
<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<title>ValidateVD</title>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
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
    String isVMExist = (String)request.getAttribute("VMExist");
    session.setAttribute("statusMessage", "");  //remove the status messge if any    
%>
<script language="JavaScript">
   var evsWindow = null;

   function displayMessage()
   {
     <% if (isVMExist != null && isVMExist.equals("true"))  { %>
        var useThis = confirm("The Value Meaning already exists in the database.  Please click 'OK' to use the existing one.");
        if (useThis == true)
        {
          hourglass();
          document.validateVMForm.Message.style.visibility="visible";
          document.validateVMForm.ValidateVMPageAction.value = "useExistVM";
          defaultStatus = "Submitting data, it may take a minute, please wait....."
          document.validateVMForm.submit();
        }  
      <% } %>
   }
   
   function hourglass(){
      document.body.style.cursor = "wait";
   }
   function down_hourglass(){
      document.body.style.cursor = "default";
   }

   //defaultStatus = "Validate Data Element status, go back to modify it or submit to create it"
   function submit()
   {
      hourglass();
      document.validateVMForm.Message.style.visibility="visible";
      defaultStatus = "Submitting data, it may take a minute, please wait....."
      document.validateVMForm.btnSubmit.disabled = true;
      document.validateVMForm.btnBack.disabled = true;
      document.validateVMForm.submit();
   }

   function EditPV()
   {
      document.validateVMForm.ValidateVMPageAction.value = "reEditPV";
      submit();
   }

   function SubmitValidate()
   {
      document.validateVMForm.ValidateVMPageAction.value = "submitVM";
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

<body bgcolor = "#666666" onload="displayMessage();">
<form name="validateVMForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=validateVMFromForm" >
<font color="#CCCCCC"></font>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top">
      <% if (isValid == true) { %>
          <input type="button" name="btnSubmit" value="Submit" style="width:125" onClick="SubmitValidate()">
      <% } else { %>
          <input type="button" name="btnSubmit" value="Submit" style="width:125" onClick="SubmitValidate()" disabled>
      <% } %>
        &nbsp;&nbsp;
      <input type="button" name="btnBack" value="Back" style="width:125" onClick="EditPV();">
        &nbsp;&nbsp;
    	<img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" 						style="visibility:hidden;">
    </td>
  </tr>
</table>
<br>
<table width="100%" border="2" cellspacing="0" cellpadding="0" bordercolor="#000000">
  <caption>
  <h3 align="left">Validate <font color="#FF0000">Value Meaning </font> Attributes</h3>
  </caption>
  <tr>
    <td width="282" height="20" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
      <div align="center"><strong><font size="3">Attribute Name</font></strong></div>
    </td>
    <td valign="top" width="437" bgcolor="#FFFFFF" bordercolor="#000000">
      <div align="center"><strong><font size="3">Attribute Contents</font></strong></div>
    </td>
    <td width="101" valign="top" bgcolor="#FFFFFF" bordercolor="#000000">
      <div align="center"><strong><font size="3">Validation Status</font></strong></div>
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
          <td height="20" valign="top" bgcolor="#FFFFFF" width="182" bordercolor="#000000"><strong><%=sItem%></strong></td>
          <td valign="top" bgcolor="#FFFFFF" width="487" bordercolor="#000000"><%=sContent%>&nbsp;</td>
          <td valign="top" bgcolor="#FFFFFF" width="151" bordercolor="#000000"><font color="<%=sFont%>"> <%=sStat%> </font>&nbsp;</td>
        </tr>
<%
      
    }
%>
</table>
<input type="hidden" name="ValidateVMPageAction" value="nothing">

</body>
</html>