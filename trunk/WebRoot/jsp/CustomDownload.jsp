<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>Customizable download</title>
    
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
          <!-- Header -->
            <curate:header displayUser = "false"/>
        <!-- Main Area -->
    
        
      <form name="columnSubmission" method="post" action="../../cdecurate/NCICurationServlet?reqType=cdlColumns">
            <input type="hidden" name="cdlColumns" value=""/>
        </form>
      <button type="button" onClick="submitSelectedColumnNames();">Submit Selected Columns</button>
      <br></br>
      <br></br>
      <div id="customDownloadContainer" style="width: 80%; height: 50%;"></div> 
        <script type="text/javascript">
            var djConfig = {
            parseOnLoad: true,
            isDebug: true,
            locale: 'en-us'
            };
        </script>
        <script src="js/dojo/dojo/dojo.js"></script>
        
        <script type="text/javascript">
            
            function submitSelectedColumnNames() {
            var allSelectedSpans = dojo.query(".dojoxGridHeaderSelected div > span[id^='caption'] ");
            
            var cols = "";
            var i=0;
            for (i=0; i < allSelectedSpans.length; i++){
            var mySpan = allSelectedSpans[i];
            var spanText;
            
            if (mySpan.innerText == undefined)
            	spanText = mySpan.textContent;
            else
            	spanText = mySpan.innerText;
            	
            cols = cols + spanText;
            if (i < allSelectedSpans.length-1) {
            cols = cols+",";    
            }
            }
            document.columnSubmission.cdlColumns.value = cols;
            document.columnSubmission.submit();
            }
            
          
            dojo.require("dojox.grid.EnhancedGrid");
            dojo.require("dojo.data.ItemFileReadStore");
            dojo.require("dojox.data.KeyValueStore");
            dojo.require("dojox.grid.enhanced.plugins.DnD");
            dojo.require("dojox.grid.enhanced.plugins.NestedSorting");//This is a must as DnD depends on NestedSorting feature
            
            // our data store:
            var completeData = new dojo.data.ItemFileReadStore({
            url:"NCICurationServlet?reqType=jsonRequest"
            });
            
            var cdlLayout = [
            <%   
            ArrayList<String> headers = (ArrayList<String>) session.getAttribute("headers");
            ArrayList<String> names = (ArrayList<String>) session.getAttribute("names");
            
            for (int colLoop = 0; colLoop < headers.size(); colLoop++) {
            
            out.println("{");
            //Take Column Name from headers and take correct column from current row
            out.println("field:\""+headers.get(colLoop)+"\",");
            out.println("name:\""+""+headers.get(colLoop)+"\",");
            out.println("width:"+"10");
            out.println("}");
            if (colLoop != headers.size())
            out.println(",");
            }
            %>	    ];
            
            
            // create a new grid:
            var cdGrid = new dojox.grid.EnhancedGrid({
            query: {},
            store: completeData,
            clientSort: true,
            rowSelector: '20px',
            structure: cdlLayout,
            plugins:{dnd: true}
            },
            document.createElement('gridDiv'));
            // append the new grid to the div "customDownloadContainer":
            dojo.byId("customDownloadContainer").appendChild(cdGrid.domNode);
            
            // Call startup, in order to render the grid:
            cdGrid.startup();
            
           
        </script>	
        
           <!-- Footer -->
        <curate:footer/>
  </body>
</html>
