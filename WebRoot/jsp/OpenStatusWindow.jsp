<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/OpenStatusWindow.jsp,v 1.2 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page errorPage="ErrorPage.jsp"%>
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
	<head>
		<title>
			CDE Curation: Status Message
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<STYLE TYPE="text/css">
		<!--
		.indented
		   {
		   padding-left: 30pt;
		   padding-right: 1pt;
		   margin-top:1mm;
		   margin-bottom:1mm;
		   }
		.normal
		   {
		   margin-top:2mm;
		   margin-bottom:2mm;
		   }
		-->
		</STYLE>
		
	</head>
	<curate:checkLogon name="Userbean" page="/ErrorPageWindow.jsp" />
	<%
Vector  vStatMsg = (Vector)session.getAttribute("vStatMsg");
session.setAttribute("vStatMsg", null);
%>
	<body>
		<table>
			<col width="45%">
			<col width="50%">
			<tr>
				<td>
					&nbsp;
				</td>
				<td align="center">
					<input type="button" name="btnClose" value="Close Window" onClick="window.close();">
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
			<%
    String strResult = "";
    if (vStatMsg != null)
	  {
		  for (int i = 0; i < vStatMsg.size(); i++)
		  {
           strResult = (String)vStatMsg.get(i);
           if (strResult == null || strResult.equals("\\n") || strResult.equals("\n"))
           		strResult = "";
           if (strResult.indexOf("<ul>") > -1) {
						strResult = strResult.replaceFirst("<ul>", "");
%>
			<p class="indented">
					<%=strResult%>
			</p>

<%        } else {  %>
			<p class="normal">
					<%=strResult%>
			</p>
<%
          }
       }
    }
%>
		<table>
			<col width="45%">
			<col width="50%">
			<tr>
				<td>
					&nbsp;
				</td>
				<td align="center">
					<input type="button" name="btnClose" value="Close Window" onClick="window.close();">
				</td>
			</tr>
		</table>
	</body>
</html>
