<%@ page errorPage="ErrorPage.jsp" %>
<!-- EditDECPage.jsp -->
<html>
<head>
<title>CDE Curation: Edit Data Element Concept</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td height="81" valign="top" colspan="2">

    <table width="100%" border="1" cellpadding="0" cellspacing="0">
      <tr>
        <td height="95" valign="top"><%@ include file="TitleBar.jsp" %></td>
      </tr>
    </table width="100%" border="1" cellpadding="0" cellspacing="0"></td>

  </tr>
  <tr>
    <td width="100%" valign="top"><%@ include file="EditDEC.jsp" %></td>
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
        <script language="JavaScript"> defaultStatus = "Create new Data Element Concept"; </script>
<%
    }
%>
</body>
</html>
