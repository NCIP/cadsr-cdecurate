<%@ page errorPage="ErrorPage.jsp" %>
<html>
<head>
<title>CDE Curation: Edit Value Domain</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="100%" border="2" cellpadding="0" cellspacing="0">
  <tr>
    <td height="95" valign="top" width="100%"><%@ include file="TitleBar.jsp" %></td>
  </tr>
  <tr>
    <td width="100%" valign="top"><%@ include file="EditVD.jsp" %></td>
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
        <script language="JavaScript"> defaultStatus = "Create new Value Domain"; </script>
<%
    }
%>
</body>
</html>
