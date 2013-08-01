<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- CreatePVPage.jsp -->
<!-- goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
<head>
<title>CDE Curation: Create Value</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body>
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td height="95" valign="top" colspan="2">

    <table width="100%" border="1" cellpadding="0" cellspacing="0">
      <tr>
        <td height="95" valign="top"><%@ include file="TitleBar.jsp" %></td>
      </tr>
    </table width="100%" border="1" cellpadding="0" cellspacing="0"></td>

  </tr>
  <tr>
    <td width="100%" valign="top"><%@ include file="CreatePV.jsp" %></td>
  </tr>
</table>
<%
    String statMsg = (String)request.getAttribute("statusMessage");
    if(statMsg != null)
    {
%>
        <script language="JavaScript"> defaultStatus = "<%=statMsg%>"; </script>
<%
    }
    else
    {
%>
        <script language="JavaScript"> defaultStatus = "Create a new Value"; </script>
<%
    }
%>
</body>
</html>
