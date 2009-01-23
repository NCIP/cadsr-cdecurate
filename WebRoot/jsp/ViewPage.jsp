<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link href="css/style.css" rel="stylesheet" type="text/css">
    <script language="JavaScript" src="js/menu.js"></script>
    <script language="JavaScript" src="js/header.js"></script>
<title>View AC</title>
</head>
<body>
	<%String displayErrorMessagee = (String)session.getAttribute("displayErrorMessage");
	   if((displayErrorMessagee != null)&&(displayErrorMessagee).equals("Yes")){%>
	       <curate:header displayUser = "true"/>
	   <%}else{ %>
	       <curate:header displayUser = "false"/>
	<%}%>
	<table width=100%><tr><td class="menuItemBlank">&nbsp;</td></tr></table>
	<% String bodyPage = (String)request.getAttribute("IncludeViewPage") ;
		  String errorMsg =  (String)request.getAttribute("errMsg") ;
		  String show =  (String)request.getAttribute("showCloseBtn") ;
		  if (errorMsg == null || errorMsg.equals(""))
				  errorMsg = " Error Occurred. ";
		  if (bodyPage != null && !bodyPage.equals("")) {
	%>
			<jsp:include  page = "<%=bodyPage%>" />
	<%	  } else { %>
	        <%if ((show != null) && (show.equals("yes"))){%>
	          </br>
	          <input type="button" name="closeBtn" value="Close" style="width: 125" onClick="window.close();">
	        <%}%>
			<p> <font size=4>
			<%=errorMsg %>
			</font></p>
	<% } %>
	<curate:footer/>
</body>
</html>