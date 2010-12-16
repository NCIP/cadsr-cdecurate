<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="org.codehaus.jettison.json.JSONArray"%>
  <%
  
  
  	ArrayList<String> headers = (ArrayList<String>) session.getAttribute("headers");
  	ArrayList<String> names = (ArrayList<String>) session.getAttribute("names");
  
  	JSONArray jArray = new JSONArray();
	    
		
  		for (int colLoop = 0; colLoop < headers.size(); colLoop++) {
  			JSONObject columnTitle=new JSONObject();
  			//Take Column Name from headers and take correct column from current row
		    columnTitle.put("field",headers.get(colLoop));
		    columnTitle.put("name","N_"+headers.get(colLoop));
		    columnTitle.put("width","30");
		    jArray.put(columnTitle);
    	}
    
    //Done constructing array, printing it:
    out.print(jArray.toString());
    out.flush();
  %>
