<%@ page errorPage="ErrorPage.jsp" %>
<!-- CreatePVPage.jsp -->
<html>
<head>
<title>CDE Curation: Create Permissible Value</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
history.forward();
</script>
</head>

<body
  onHelp = "showHelp('Help_CreateVD.html#createVMPage'); return false">
<table width="100%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" valign="top"><%@ include file="CreateVM.jsp" %></td>
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
        <script language="JavaScript"> defaultStatus = "Create new Permissible Value"; </script>
<%
    }
%>
</body>
</html>
