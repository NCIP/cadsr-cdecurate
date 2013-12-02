<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateDEC.jsp,v 1.11 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->
<!-- 5/6/2013 2.16pm ET build -->

<%@ page session="true"%>
<%@ page import="gov.nih.nci.cadsr.common.Constants" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>
			Check EVS Lookup Status
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="java.text.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.*"%>
		<%
			//GF32723 final user selected defs
			String evsDone = "false";	//(String)session.getAttribute(Constants.FINAL_ALT_DEF_STRING);
			System.out.print("CheckEVSStatus invoked ...");
		%>
	</head>
	<body>
        <%= evsDone %>
        <%
            System.out.print("1 CheckEVSStatus done.");
        %>
	</body>
</html>