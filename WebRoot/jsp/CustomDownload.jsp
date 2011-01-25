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
      <button type="button" onClick="toggleView();">Toggle View</button>
      <br></br>
      <br></br>
      <% ArrayList<String> rows = (ArrayList<String>) session.getAttribute("rows"); %>
      <font size="4"><%=rows.size()%> elements selected for download.</font>
      
      <div id="customDownloadContainer" style="width: 80%; height: 50%; display: block"></div> 
      <div id="simpleViewContainer" style="width: 80%; height: 50%; display: none">
          <form>
          <table border="0">
              <tr>
                  <td>
                      <select id="notSelectedCols"></select>
                  </td>
                  <td align="center" valign="middle">
                      <input type="button" value="--&gt;"
                          onclick="moveOptions(this.form.notSelectedCols, this.form.selectedCols);" /><br />
                      <input type="button" value="&lt;--"
                          onclick="moveOptions(this.form.selectedCols, this.form.notSelectedCols);" />
                  </td>
                  <td>
                      
                      <select id="selectedCols"></select>
                  </td>
                  <td><input type="button" value="up" /><input type="button" value="down"/></td>
              </tr>
              
          </table>
          </form>
      </div>
        <script type="text/javascript">
            var djConfig = {
            parseOnLoad: true,
            isDebug: true,
            locale: 'en-us'
            };
        </script>
        <script src="js/dojo/dojo/dojo.js"></script>
        
        <script type="text/javascript">
            
            function addOption(theSel, theText, theValue)
            {
		    var newOpt = new Option(theText, theValue);
		    var selLength = theSel.length;
		    theSel.options[selLength] = newOpt;
            }
            
            function deleteOption(theSel, theIndex)
            { 
		    var selLength = theSel.length;
		    if(selLength>0)
		    {
		   	 theSel.options[theIndex] = null;
		    }
            }
            
            function moveOptions(theSelFrom, theSelTo)
            {
            
		    var selLength = theSelFrom.length;
		    var selectedText = new Array();
		    var selectedValues = new Array();
		    var selectedCount = 0;

		    var i;

		    // Find the selected Options in reverse order
		    // and delete them from the 'from' Select.
		    for(i=selLength-1; i>=0; i--)
		    {
		    if(theSelFrom.options[i].selected)
		    {
		    selectedText[selectedCount] = theSelFrom.options[i].text;
		    selectedValues[selectedCount] = theSelFrom.options[i].value;
		    deleteOption(theSelFrom, i);
		    selectedCount++;
		    }
		    }

		    // Add the selected text/values in reverse order.
		    // This will add the Options to the 'to' Select
		    // in the same order as they were in the 'from' Select.
		    for(i=selectedCount-1; i>=0; i--)
		    {
		    addOption(theSelTo, selectedText[i], selectedValues[i]);
		    }
            
            }
            
            function moveOption(theSel, direction) 
            {
            	    var selLength = theSel.length;
		    var selectedCount = 0;

		    var i;
		    
		    for(i=selLength-1; i>=0; i--)
		    {
		    	if(theSel.options[i].selected)
		    	{
		    		break;
		    	}
		    }
		    
		    swap(theSel, i, direction);
		    
            }
            
            function swap(theSel,i, direction) 
            {
            	var current = theSel.options[i]
            	var selLength = theSel.length;
            	
            	if (direction == 'up' && i > 0)
            	{
            		var toSwap = theSel.options[i-1];
            		theSel.options[i-1] = current;
            		theSel.options[i] = toSwap;
            	}
            	if (direction == 'down' && i < selLength)
            	{
            		var toSwap = theSel.options[i+1];
			theSel.options[i+1] = current;
            		theSel.options[i] = toSwap;
            	}
            }
            
            
            function toggleView() {
                var cust = dojo.byId("customDownloadContainer"); 
                var simp = dojo.byId("simpleViewContainer");
                
                divstyle = cust.style.display;
                if(divstyle.toLowerCase()=="block" || divstyle == "")
                {
                    cust.style.display = "none";
                    simp.style.display = "block";
                }
                else
                {
                    cust.style.display = "block";
                    simp.style.display = "none";
                }
            }
            
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
            
            dojo.require("dijit.form.MultiSelect");
           
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
            if (colLoop != headers.size()-1)
            out.println(",");
            }
            %>	    ];
            
            dojo.addOnLoad(function() {
                var notSel = dojo.byId('notSelectedCols');
                
                <% for (int colLoop = 0; colLoop < headers.size(); colLoop++) { %>
                    var c = dojo.doc.createElement('option');
                    c.innerHTML = '<%=headers.get(colLoop)%>';
                    c.value = '<%=headers.get(colLoop)%>';
                    notSel.appendChild(c);
                <%  } %>
                
                var sel = dojo.byId('selectedCols');
                
                new dijit.form.MultiSelect({
                name: 'notSelectedCols'
                },
                notSel);
                
                new dijit.form.MultiSelect({
                name: 'selectedCols'
                },
                sel);
                });
            
            
            
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
