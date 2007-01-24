<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/OpenStatusWindow.jsp,v 1.3 2007-01-24 06:12:18 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp" %>
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate" %>
<html>
<head>
<title>CDE Curation: Block Edit Status</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ page import="java.util.*" %>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
</head>
<curate:checkLogon name="Userbean" page="/jsp/ErrorPageWindow.jsp" />
<%
Vector  vStatMsg = (Vector)session.getAttribute("vStatMsg");
session.setAttribute("vStatMsg", null);
%>
<body>
<table>
  <col width="45%"><col width="50%">
  <tr>
    <td>&nbsp;</td>
    <td align="center"><input type="button" name="btnClose" value="Close Window" style="width: 100,height:30" onClick="window.close();"></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
 <%
    String strResult = "";
    if (vStatMsg != null)
	  {
		  for (int i = 0; i < vStatMsg.size(); i++)
		  {
           strResult = (String)vStatMsg.get(i);
           if (strResult == null) strResult = "";
           if (strResult.equals("\n") || strResult.equals("\\n")) {
%>
            <tr><td>&nbsp;</td></tr>
<%        } else {
%>
            <tr><td><%=strResult%></td></tr>
<%
          }
       }
    }
%>
</table>
<table>
  <col width="45%"><col width="50%">
  <tr>
    <td>&nbsp;</td>
    <td align="center"><input type="button" name="btnClose" value="Close Window" style="width: 100,height:30" onClick="window.close();"></td>
  </tr>
</table>
</body>
</html>
