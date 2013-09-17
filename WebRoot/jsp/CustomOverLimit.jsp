<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
String downloadLimit = (String) request.getSession().getAttribute("downloadLimit");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Customizable Download</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<link rel="stylesheet" type="text/css" href="js/dojo/dijit/themes/claro/claro.css"
        />
        <style type="text/css">
            body, html { font-family:helvetica,arial,sans-serif; font-size:90%; }
        </style>
	    <style type="text/css">
	        @import "js/dojo/dojox/grid/enhanced/resources/claroEnhancedGrid.css";
	        @import "js/dojo/dojox/grid/enhanced/resources/EnhancedGrid_rtl.css";
	        .dojoxGrid table { margin: 0; } html, body { width: 100%; height: 100%;
	        margin: 0; }
	    </style>
  </head>
  
  <body class=" claro ">
        <!-- Main Area -->

       
      <br></br>
      <br></br>
      <div style="height:90%; width:70%">
      <% ArrayList<String> rows = (ArrayList<String>) session.getAttribute("downloadIDs"); %>
      <font size="4"><%=rows.size()%> elements selected for download.</font> <br/> 
      <% if (rows.size() > Integer.valueOf(downloadLimit).intValue()){ %>
      	<br><font size="4" color="red">Alert: The current limit for Custom Download is <%=downloadLimit%>. 
      	<br>Your download cannot be completed. <u>Please select a smaller set of items</u>.</font><br>
      <%} %></div>
          
        <curate:footer/>
  </body>
</html>
