<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Integer downloadLimit = (Integer) request.getSession().getAttribute("downloadLimit");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
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
      <% ArrayList<String> rows = (ArrayList<String>) session.getAttribute("rows"); %>
      <font size="6"><%=rows.size()%> elements selected for download.</font>  
      <% if (rows.size() > downloadLimit.intValue()){ %>
      	<font size="6" color="red">Warning: Current limit for item download is <%=downloadLimit.intValue()%>.  Please select a smaller set to download.</font>
      <%} %>
          
        <curate:footer/>
  </body>
</html>
