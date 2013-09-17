<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="org.codehaus.jettison.json.JSONArray"%>
  <%
  
  
  	ArrayList<String> headers = (ArrayList<String>) session.getAttribute("headers");
  	ArrayList<String> types = (ArrayList<String>) session.getAttribute("types");
  	ArrayList<String[]> rows = (ArrayList<String[]>) session.getAttribute("rows");
	JSONObject container = new JSONObject();
  	JSONArray jArray = new JSONArray();
	
  	int limit = 100;
  	if (rows.size() < 100)
  		limit = rows.size();
  	
	for (int rowLoop = 0; rowLoop < limit; rowLoop++) {	    
		JSONObject row=new JSONObject();
  		for (int colLoop = 0; colLoop < headers.size(); colLoop++) {
  			
  			//Take Column Name from headers and take correct column from current row
		    row.put(headers.get(colLoop),rows.get(rowLoop)[colLoop]);
		    
    	}
    	jArray.put(row);
	container.put("items",jArray);
}
    
    //Done constructing array, printing it:
    out.print(container.toString());
    out.flush();
  %>
