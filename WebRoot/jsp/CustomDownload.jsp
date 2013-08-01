<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>Customizable Download</title>
	<!-- GF30779 -->
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<link rel="stylesheet" type="text/css" href="js/dojo/dijit/themes/claro/claro.css"/>
        <style type="text/css">
            body, html { font-family:helvetica,arial,sans-serif; font-size:90%; }
        </style>
	    <style type="text/css">
	        @import "js/dojo/dojox/grid/enhanced/resources/claroEnhancedGrid.css";
	        @import "js/dojo/dojox/grid/enhanced/resources/EnhancedGrid_rtl.css";
	        .dojoxGrid table { margin: 0; } html, body { width: 100%; height: 100%;
	        margin: 0; }
	    </style>
	<!-- begin of ng init -->
  	<!--
  	<script src="jsp/app.js"></script>
  	-->
	<!-- end of ng init -->
  </head>
  
  <body class=" claro "> <!-- GF30779 PERF remove onLoad toggleView -->
          <!-- Header -->
            <curate:header displayUser = "false"/>
        <!-- Main Area -->
 	<%ArrayList<String> headers = (ArrayList<String>) session.getAttribute("headers");
 	  ArrayList<String> allExpandedHeaders = (ArrayList<String>) session.getAttribute("allExpandedHeaders");
      ArrayList<String> types = (ArrayList<String>) session.getAttribute("types");
      ArrayList<String> defaultExcluded = (ArrayList<String>) session.getAttribute("excludedHeaders");
      
      HashMap<String,ArrayList<String[]>> typeMap = (HashMap<String,ArrayList<String[]>>) session.getAttribute("typeMap");%>
        
      <form name="columnSubmission" method="post" action="../../cdecurate/NCICurationServlet?reqType=dlExcelColumns">
            <input type="hidden" name="cdlColumns" value=""/>
       
	      <button type="button" onClick="submitSelectedColumnNames('Excel');">Download Excel</button>
<!-- GF31701
		  <button type="button" onClick="submitSelectedColumnNames('XML');">Download XML</button>
-->
		<!-- GF30779 PERF comment out button -->
	      <!-- <button type="button" onClick="toggleView();">Refresh Preview</button> -->
	      	<input type="checkbox" name="fillIn" value="true"/> Check to fill in all values.
      </form>
      <% ArrayList<String> rows = (ArrayList<String>) session.getAttribute("downloadIDs"); %>
      <font size="4"><%=rows.size()%> elements selected for download.</font>  
	       
      <div id="simpleViewContainer" style="width: 100%; display: block">
      <form>  
          <table border="0">
          		<tr>
                  <td align="center">
                      Excluded
                  </td>
                  <td >
                      
                  </td>
                  <td align="center">
                     Included
                  </td>
                  <td>
              </tr>
              <tr>
                  <td>
                      <select id="notSelectedCols" style="width:300px" size=15></select>
                  </td>
                  <td align="center" valign="middle">
                      <input type="button" value="--&gt;"
                          onclick="moveOptions(this.form.notSelectedCols, this.form.selectedCols, 0);" /><br />
                      <input type="button" value="&lt;--"
                          onclick="moveOptions(this.form.selectedCols, this.form.notSelectedCols, 1);" />
                  </td>
                  <td >
                      
                      <select style="width:300px" id="selectedCols" size=15></select>
                  </td>
                  <td><input type="button" value="up" onclick="moveOption(this.form.selectedCols,'up');"/>
                  <input type="button" value="down" onclick="moveOption(this.form.selectedCols, 'down');"/></td>
              </tr>
              
          </table>
          </form>
      </div>
      
      <!-- GF30779 PERF -->
     <%--  <font size="4">Preview of data from selected columns.</font><% if (rows.size() > 10) {%>  <font size="4"> Limited to first 10 records</font><%} %>
      <div id="customDownloadContainer" style="width: 90%; height: 50%; display: block"></div> --%> 
      
        <script type="text/javascript">
            var djConfig = {
            parseOnLoad: true,
            isDebug: false,
            locale: 'en-us'
            };
        </script>
        <script src="js/dojo/dojo/dojo.js"></script>
        
        <script type="text/javascript">
        
        	var cdGrid;
            var dndPlugin;
            var gdHeaderMap;
            var gdHeaderArray;
            var completeData;
            
            //Fix for: indexOf not implemented in IE.
            if (!Array.prototype.indexOf) {
	            Array.prototype.indexOf = function(obj, start) {
				     for (var i = (start || 0), j = this.length; i < j; i++) {
				         if (this[i] == obj) { return i; }
				     }
				     return -1;
				}
	        }
            
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
            
            function moveOptions(theSelFrom, theSelTo, dir)
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
            
            function swap(element,i, direction) 
            {
            	
            	var selLength = element.length;
            	
            	if (direction == 'up' && i > 0)
            	{
            		var temp = new Option(element.options[i-1].text,element.options[i-1].value);
			        var temp2 = new Option(element.options[i].text,element.options[i].value);
			        element.options[i-1] = temp2;
			        element.options[i-1].selected = true;
			        element.options[i] = temp;
            	}
            	if (direction == 'down' && i < selLength- 1)
            	{
            		 var temp = new Option(element.options[i+1].text,element.options[i+1].value);
			        var temp2 = new Option(element.options[i].text,element.options[i].value);
			        element.options[i+1] = temp2;
			        element.options[i+1].selected = true;
			        element.options[i] = temp;
            	}
            }
            
          //GF30779 PERF
          /*   function toggleView() {
            
                    selectInGrid();
                
            } 

            function selectInGrid() {
            	dndPlugin.cleanCellSelection();
            	
            	//refresh the grid with new structure first
            	
            	restructure();
            	
            }

            function restructure() {
            	
            	var cdlLayout = getLayout('false');
            	cdGrid.setStructure(cdlLayout);
            	cdGrid.update();
	            
            } */
            
            function getCol(colName) {
				if (cdGrid != null && dndPlugin != null) {
					return getGdHeaderMap()[colName];
				}

				return null;
            }

            function getGdHeaderMap() {
				
					gdHeaderMap = {};
					for (var i=0;i<dndPlugin.getHeaderNodes().length;i++) {
						var nme = cdGrid.getCell(i).name;
						gdHeaderMap[nme] = cdGrid.getCell(i);
					}
				

				return gdHeaderMap;
            }

            function getGdHeaderArray() {
				
					gdHeaderArray = new Array();
					for (var i=0;i<dndPlugin.getHeaderNodes().length;i++) {
						var nme = cdGrid.getCell(i).name;
						gdHeaderArray[i] = nme;
					}
				

				return gdHeaderArray;
            }
            
            function syncFromGrid() {
            	var sel = document.forms[1].selectedCols;
            	var notSel = document.forms[1].notSelectedCols;
            	moveAllLeft();
            	var leftMap = getNotSelectedMap();
            	var selectedCols = getSelectedSpans();
            	var gdHeaderArray = getGdHeaderArray();
            	for (var i=0;i<dndPlugin.getHeaderNodes().length;i++) {
					if (selectedCols.indexOf(gdHeaderArray[i]) != -1) {
						var colName = cdGrid.getCell(i).name;
						var optn = leftMap[colName];
						if (optn != null) {
							addOption(sel, optn.text, optn.value);
							deleteOption(notSel, optn.index);
						}
					}
                }
            }

            function moveAllLeft() {
                var sel = document.forms[1].selectedCols;
                var notSel = document.forms[1].notSelectedCols;
            	var len = sel.length
            	while (sel.options.length > 0) {
					addOption(notSel, sel.options[0].text, sel.options[0].value);
					deleteOption(sel, 0);
                }
            }

            function getNotSelectedMap() {
				var notSelMap = {};
				var notSel = document.forms[1].notSelectedCols;
				var len = notSel.length;
				for (var i=0;i<len;i++) {
					nme = notSel.options[i].text;
					notSelMap[nme] = notSel.options[i];
				}

				return notSelMap;
            }

            function selectColumn(evt) {
        		var nme = evt.target.firstChild.nodeValue;
        		var headCell = getGdHeaderMap()[nme];
        		if (headCell != null) dndPlugin.selectColumn(headCell.index); 
        	}
            
            function getLayout(newLayout) {
            	
		            
            	if (newLayout == 'true') {
            var cdlLayout = [
		            <%   
		            
		            for (int colLoop = 0; colLoop < allExpandedHeaders.size(); colLoop++) {
		            
		            
		            
					    out.println("{");
					    //Take Column Name from headers and take correct column from current row
					    out.println("field:\""+allExpandedHeaders.get(colLoop)+"\",");
					    out.println("name:\""+""+allExpandedHeaders.get(colLoop)+"\",");
					    out.println("width:"+"10");
					    out.println("}");
					    if (colLoop != allExpandedHeaders.size()-1)
					    	out.println(",");
					    
		            }
		            %>	    ];
           	 	return cdlLayout;
            	} else {
            		//Create array out of selected columns in form (in order) 
            		//Create array out of the unselected columnns
            		//Append the unselected array to the selected array
            		//Go through the resulting array and find original column indices then
            		//Create layout from the resulting array.
            		var sel = document.forms[1].selectedCols;
                	var notSel = document.forms[1].notSelectedCols;
            		var cdlLayout = [];
           	 		var s = 0;
           	 		var n = 0;
            		for (var s=0; s < sel.length; s++) {
            			var tempPMap = {field:sel.options[s].text,
            							name:sel.options[s].text,
            							width:10}
            			cdlLayout[s] = tempPMap;
            		}

            		return cdlLayout;            		
            	}
            }
            
            function submitSelectedColumnNames(action) {
                
            	var cust = dojo.byId("customDownloadContainer"); 
                      	
                var cols = {};
                var returnCols = "";
                var i=0;
				
                var sel = document.forms[1].selectedCols;
                
                
                for (i=0; i < sel.length; i++) {
                 	returnCols = returnCols + sel.options[i].text;
	                  if (i < sel.length-1) {
	                  	returnCols = returnCols+",";    
             	     }
                }
                
                if (action == "XML")
                	document.columnSubmission.action = "../../cdecurate/NCICurationServlet?reqType=dlXMLColumns";
                
                if (action == "Excel")
                	document.columnSubmission.action = "../../cdecurate/NCICurationServlet?reqType=dlExcelColumns";
                
                document.columnSubmission.cdlColumns.value = returnCols;
                document.columnSubmission.submit();
            }
            
            
            function getSelectedSpans() {
	      	   var allSelectedSpans = dojo.query(".dojoxGridHeaderSelected div > span[id^='caption'] ");
	       	   var cols = new Array();
	       	   var i = 0;
	           for (i=0; i < allSelectedSpans.length; i++){
	                  var mySpan = allSelectedSpans[i];
	                  var spanText;
	                  
	                  if (mySpan.innerText == undefined)
	                  	spanText = mySpan.textContent;
	                  else
	                  	spanText = mySpan.innerText;
	                  
	                  cols[i] = spanText;
	                 
              	}
	           return cols;
            }
            
            dojo.require("dijit.form.MultiSelect");
           
            dojo.require("dojox.grid.EnhancedGrid");
            dojo.require("dojo.data.ItemFileReadStore");
            dojo.require("dojox.data.KeyValueStore");
            dojo.require("dojox.grid.enhanced.plugins.DnD");
            dojo.require("dojox.grid.enhanced.plugins.NestedSorting");//This is a must as DnD depends on NestedSorting feature
            
            // our data store:
           //GF30779 PERF
           /*  completeData = new dojo.data.ItemFileReadStore({
            url:"NCICurationServlet?reqType=jsonRequest"
            }); */
            
			var cdlLayout = getLayout('true');
            
            dojo.addOnLoad(function() {
                var notSel = dojo.byId('notSelectedCols');
                var sel = dojo.byId('selectedCols');
                
                <% for (int colLoop = 0; colLoop < allExpandedHeaders.size(); colLoop++) { 
                	if (!allExpandedHeaders.get(colLoop).endsWith("IDSEQ")){
                	
                %>
                    var c = dojo.doc.createElement('option');
                    
			
				c.innerHTML = '<%=allExpandedHeaders.get(colLoop)%>';
				c.value = '<%=allExpandedHeaders.get(colLoop)%>';
				<%if (defaultExcluded.contains(allExpandedHeaders.get(colLoop))){%>
					notSel.appendChild(c);
					<%} else {%>
					sel.appendChild(c);
					<%}%>
                    <%  } %>
                    
                <%  } %>
            	cdlLayout= getLayout();
            	
                var sel = dojo.byId('selectedCols');
                
                new dijit.form.MultiSelect({
                name: 'notSelectedCols',
                size: 15,
                style: 'width:300px'
                },
                notSel);
                
                new dijit.form.MultiSelect({
                name: 'selectedCols',
                size: 15,
                style: 'width:300px'
                },
                sel);
                });
            
            
            
            // create a new grid:
            //GF30779 PERF
           /*  cdGrid = new dojox.grid.EnhancedGrid({
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
            dndPlugin = new dojox.grid.enhanced.plugins.DnD(cdGrid);
            cdGrid.pluginMgr.preInit();
            cdGrid.pluginMgr.postInit();
            // Call startup, in order to render the grid:
            cdGrid.startup();
            
            dojo.connect(cdGrid, "onHeaderCellClick", selectColumn); */
           
            
        </script>	
        
<!--        
<iframe frameborder='0' scrolling='no' style="border: 0px; width: 870px; height:80%;" name="505849e578e27" src="jsp/crud.html"/>
-->
        
           <!-- Footer -->
        <curate:footer/>
  </body>
</html>
