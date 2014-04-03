<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateDECPage.jsp,v 1.1 2007-09-10 16:16:48 hebell Exp $
    $Name: not supported by cvs2svn $
-->
<!-- 5/6/2013 2.16pm ET build -->

<!--  goes to login page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<!-- GF32649 -->
<%--<%@ page import="gov.nih.nci.ncicb.cadsr.common.CaDSRUtil"%>--%>
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<title>
            CDE Curation: Create Data Element Concept
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script>
        history.forward();
        </script>
        <!-- GF32723 load Dojo -->
        <%--<script src="//ajax.googleapis.com/ajax/libs/dojo/1.8.5/dojo/dojo.js" data-dojo-config="async: true"></script>--%>
        <script src="js/dojo/dojo/dojo.js" data-dojo-config="async: true"></script>
        <script>
        <%--require(["dojo"], function(dojo){--%>
        <%--dojo.ready(function(){--%>
        window.console && console.log("CreateDEC.jsp DOJO version used = [" + dojo.version.toString() + "]");
        <%--});--%>
        <%--});--%>
        </script>
    </head>

	<body bgcolor="#FFFFFF" text="#000000">
		<table width="100%" border="1" cellpadding="0" cellspacing="0">
			<tr>
				<td height="95" valign="top">
					<%@ include file="TitleBar.jsp"%>
				</td>
			</tr>
			<tr>
				<td width="100%" valign="top">
					<%@ include file="CreateDEC.jsp"%>
				</td>
			</tr>
		</table>
		<%
    String statMsg = (String)request.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
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
