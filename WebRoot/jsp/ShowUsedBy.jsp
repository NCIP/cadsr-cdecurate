<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page language="java" import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<html>
	<head>
		<title>
			Show Forms Using Item
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%  Object temp = session.getAttribute("usedByResults");
			HashMap<String,ArrayList<String[]>> crfResults = new HashMap<String,ArrayList<String[]>>();
			if (temp != null){
				 crfResults = (HashMap<String,ArrayList<String[]>>) temp;
			}
			ArrayList<String[]> content = crfResults.get("Content");
		%>
		
       
	</head>
	<body>
	<table width="99%" border=1>
			
			<tr>
				<td>
						<div class="tabbody" style="width: 99%">
							
							<!--Forms/Templates-->
							<div class="ind2" style="display:inline; width: 4in">  <!--  width:49%;"> -->
								<b>
									Protocol Forms Using Selected Item
								</b>
								<%=content.size()%> Found 
							</div>	
							<% if (content.size() > 0) { %> 
								<div class="table">
									<table width="100%" border="0">
										<colgroup>
											<col width="20%">
											<col width="9%">
											<col width="7%">
											<col width="12%">
											<col width="8%">
											<col width="10%">
										</colgroup>
										<tbody>
											<tr>
												<%ArrayList<String[]> header = crfResults.get("Head"); 
												  String[] headerColumns = header.get(0);
												for(int i = 0; i < headerColumns.length - 2; i++){%>
												<th><%=headerColumns[i]%></th>
												<%} %>
												
											</tr>
											<%  
												for (int i =0; i<content.size(); i++) {
							              	                 
											%>
											<tr <% if(i%2 == 0) { %> class="rowColor" <% } %>>
												<%String[] columnContent = content.get(i); 
												for (int c = 0; c < columnContent.length - 2; c++) {	
												%>	
												<td><%=columnContent[c]%></td>
												<% } %>
											</tr>
											<% } %>
										</tbody>
									</table>
								</div>
							<% } %>
							<hr width="100%">
						</div>		
				</td>
			</tr>
		</table>
	</body>
</html>
