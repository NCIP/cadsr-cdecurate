<!-- SearchResultsBEDisplay.jsp -->
<%@ page import= "java.util.*" %>
<html>
<head>
<title>Search Results</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/SearchResults.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="../../cdecurate/Assets/HelpFunctions.js"></SCRIPT>
<%
   String sSelAC = "";
   String sKeyword, nRecs;
   String strBEDisplaySubmitted = (String)session.getAttribute("BEDisplaySubmitted");
   if(strBEDisplaySubmitted == null || strBEDisplaySubmitted.equals("")) strBEDisplaySubmitted = "false";
   session.setAttribute("BEDisplaySubmitted", "");
// System.out.println("SR BE.jsp strBEDisplaySubmitted: " + strBEDisplaySubmitted);  
   Vector results = new Vector();
   Vector vSelAttr = new Vector();
   results = (Vector)session.getAttribute("resultsBEDisplay");
   if (results == null)
    results = (Vector)session.getAttribute("results");
  // Do this so page will not bomb before it re-submits
  if(strBEDisplaySubmitted == "false")
    results = null;
  
  // String sMAction = (String)session.getAttribute("MenuAction");
 //  session.setAttribute("MenuAction", "searchForCreate");
   sKeyword = (String)session.getAttribute("creKeyword");
   nRecs = (String)request.getAttribute("recsFound");
   sSelAC = (String)session.getAttribute("searchAC");  //done now in CDEHomePage
   vSelAttr = (Vector)session.getAttribute("selectedAttr");

   if (sKeyword == null)
      sKeyword = "";
   if (nRecs == null)
      nRecs = "No ";
   if (sSelAC == null) sSelAC = "";
   if(sSelAC.equals("DataElement"))
      sSelAC = "Data Element"; 
   else if(sSelAC.equals("DataElementConcept"))
      sSelAC = "Data Element Concept";
   else if(sSelAC.equals("ValueDomain"))
      sSelAC = "Value Domain";
   else if(sSelAC.equals("ConceptualDomain"))
      sSelAC = "Conceptual Domain"; 
      
   String sLabelKeyword = "Selected Search Results";
   if (sSelAC.equals("Data Element"))
      sLabelKeyword = "Selected Data Element(s)";
   else if (!sSelAC.equals(""))
      sLabelKeyword = "Selected " + sSelAC + "s";
 
/*System.out.println("SR BEDisplay.jsp sMAction: " + sMAction);
System.out.println("SR BEDisplay.jsp sSelAC: " + sSelAC);
if(results != null) System.out.println("SR BE.jsp resultsBEDisplay.size2: " + results.size());
System.out.println("SR BE.jsp vSelAttr.size: " + vSelAttr.size());
System.out.println("SR BEDisplay.jsp sLabelKeyword: " + sLabelKeyword); */
%>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
var numRows2;
var SelectAllOn = "false";

function setup()
{
<%
    if(strBEDisplaySubmitted.equals("false"))
    {
    %>
            document.searchBEDisplayForm.submit(); 
  <%} %>
}

/*   function getSearchComponent()
   {
    //get the selected component from the opener document or from session attribute
    <% // if (sMAction.equals("searchForCreate")) {%>
        sComp = opener.document.SearchActionForm.searchComp.value;
    <%// } else {%>
        sComp = "<%=sSelAC%>";
    <%// }%>

   } */
   
  function closeWindow()
  {
      window.close();
  }

</SCRIPT>
</head>
<body onLoad="setup();">
<form name="searchBEDisplayForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showBEDisplayResult">
<br>
<table width="100%">
  <tr>
   <td width="80%" align="center"></td>
    <td>
      <input type="button" name="closeBtn" value="Close Window" onClick="javascript:closeWindow();" style="width: 97", "height: 30">
        &nbsp;
      </td>
  </tr>
  <tr></tr>
  <tr>
      <td><font size="4"><b><%=sLabelKeyword%></b></font></td>
  </tr>
  <tr></tr>
      <td><div align="left"><font size="2"><%=nRecs%> Records</font></div></td>
  </tr>
  </tr>
 </table>
 <table width="100%" border="1" style="border-collapse: collapse" valign="top">
  <br>
    <tr valign="middle">
     
      <!-- adds Review status only if questions -->

<%    int k = 0;
      if (vSelAttr != null)
      {
         //for review status increase the k size to 1
           k = vSelAttr.size();

        for (int i =0; i < vSelAttr.size(); i++) 
        {
          String sAttr = (String)vSelAttr.elementAt(i);
          if (sAttr.equals("Name")) { %>
            <th method="get"><font size="2">Preferred Name</font></th>
<%        } else if (sAttr.equals("Alias Name")) { %>
            <th method="get"><font size="2"> Name/Alias Name</font></th>
<%        } else if (sAttr.equals("Long Name")) { %>
            <th method="get"><font size="2">
<%                if(sSelAC.equals("Data Element"))   { %>                 
              Data Element Long Name
<%                } else if(sSelAC.equals("Data Element Concept"))   { %>                 
              Data Element Concept Long Name
<%                } else if(sSelAC.equals("Value Domain"))   { %>                 
              Value Domain Long Name
<%                } else if(sSelAC.equals("Conceptual Domain"))   { %>                 
              Conceptual Domain Long Name
<%                } else   { %>                 
              Long Name
<%                } %>                 
              </font></th>
<%        } else if (sAttr.equals("Public ID")) { %>
            <th method="get"><font size="2">Public ID</font></th>
<%        } else if (sAttr.equals("Version")) { %>
            <th method="get"><font size="2">Version</font></th>
<%        } else if (sAttr.equals("Workflow Status")) { %>
            <th method="get"><font size="2">Workflow Status</font></th>
<%        } else if (sAttr.equals("Owned By Context")) { %>
            <th method="get"><font size="2">Owned By Context</font></th>
<%        } else if (sAttr.equals("Used By Context")) { %> 
            <th method="get"><font size="2">Used By Context</font></th>
<%        } else if (sAttr.equals("Definition")) { %>
            <th method="get"><font size="2">Definition</font></th>
<%        } else if (sAttr.equals("Value Domain")) { %>
            <th method="get"><font size="2">Value Domain Long Name</font></th>
<%        } else if (sAttr.equals("Data Element Concept")) { %>
            <th method="get"><font size="2">Data Element Concept Long Name</font></th>
<%        } else if (sAttr.equals("Document Text")) { %>
            <th method="get"><font size="2">Document Text</font></th>     
<%        } else if (sAttr.equals("Question Text")) { %>
            <th method="get"><font size="2">Question Text</font></th>
<%        } else if (sAttr.equals("DE Long Name")) { %>
            <th method="get"><font size="2">Data Element Long Name</font></th>
<%        } else if (sAttr.equals("DE Public ID")) { %>
            <th method="get"><font size="2">DE Public ID</font></th>
<%        } else if (sAttr.equals("Highlight Indicator")) { %>
            <th method="get"><font size="2">Highlight Indicator</font></th>
<%        } else if (sAttr.equals("Owned By")) { %>
            <th method="get"><font size="2">Owned By</font></th>
<%        } else if (sAttr.equals("Used By")) { %>
            <th method="get"><font size="2">Used By</font></th>
<%        } else if (sAttr.equals("Protocol ID")) { %>
            <th method="get"><font size="2">Protocol ID</font></th>
<%        } else if (sAttr.equals("CRF Name")) { %>
            <th method="get"><font size="2">CRF Name</font></th>
<%        } else if (sAttr.equals("Type of Name")) { %>
            <th method="get"><font size="2">Type of Name</font></th>
<%        } else if (sAttr.equals("Effective Begin Date")) { %>
            <th method="get"><font size="2">Effective Begin Date</font></th>
<%        } else if (sAttr.equals("Effective End Date")) { %>
            <th method="get"><font size="2">Effective End Date</font></th>
<%        } else if (sAttr.equals("Language")) { %>
            <th method="get"><font size="2">Language</font></th>
<%        } else if (sAttr.equals("Comments/Change Note")) { %>
            <th method="get"><font size="2">Comments/Change Note</font></th>
<%        } else if (sAttr.equals("Origin")) { %>
            <th method="get"><font size="2">Origin</font></th>
<%        } else if (sAttr.equals("Historic Short CDE Name")) { %>
            <th method="get"><font size="2">Historic Short CDE Name</font></th>
<%        } else if (sAttr.equals("Conceptual Domain")) { %>
            <th method="get"><font size="2">Conceptual Domain</font></th>
<%        } else if (sAttr.equals("Valid Values")) { %>
            <th method="get"><font size="2">Valid Value</font></th>
<%        } else if (sAttr.equals("Classification Schemes")) { %>
            <th method="get"><font size="2">Classification Schemes</font></th>
<%        } else if (sAttr.equals("Class Scheme Items")) { %>
            <th method="get"><font size="2">Class Scheme Items</font></th>
<%        } else if (sAttr.equals("Unit of Measures")) { %>
            <th method="get"><font size="2">Unit of Measures</font></th>
<%        } else if (sAttr.equals("Data Type")) { %>
            <th method="get"><font size="2">Data Type</font></th>
<%        } else if (sAttr.equals("Display Format")) { %>
            <th method="get"><font size="2">Display Format</font></th>
<%        } else if (sAttr.equals("Maximum Length")) { %>
            <th method="get"><font size="2">Maximum Length</font></th>
<%        } else if (sAttr.equals("Minimum Length")) { %>
            <th method="get"><font size="2">Minimum Length</font></th>
<%        } else if (sAttr.equals("High Value Number")) { %>
            <th method="get"><font size="2">High Value Number</font></th>
<%        } else if (sAttr.equals("Low Value Number")) { %>
            <th method="get"><font size="2">Low Value Number</font></th>
<%        } else if (sAttr.equals("Decimal Place")) { %>
            <th method="get"><font size="2">Decimal Place</font></th>
<%        } else if (sAttr.equals("Type Flag")) { %>
            <th method="get"><font size="2">Type Flag</font></th>
<%        } else if (sAttr.equals("Value")) { %>
            <th method="get"><font size="2">Value</font></th>
<%        } else if (sAttr.equals("Value Meaning")) { %>
            <th method="get"><font size="2">Value Meaning</font></th>
<%        } else if (sAttr.equals("PV Meaning Description")) { %>
            <th method="get"><font size="2">Permissible Value Meaning Description</font></th>
<%        } else if (sAttr.equals("Identifier")) { %>
            <th method="get"><font size="2">Identifier</font></th>
<%        } else if (sAttr.equals("CSITL Name")) { %>
            <th method="get"><font size="2">CSITL Name</font></th>
<%        } else if (sAttr.equals("Dimensionality")) { %>
            <th method="get"><font size="2">Dimensionality</font></th>
<%        } else if (sAttr.equals("CSI Name")) { %>
            <th method="get"><font size="2">CSI Name</font></th>
<%        } else if (sAttr.equals("CSI Type")) { %>
            <th method="get"><font size="2">CSI Type</font></th>
<%        } else if (sAttr.equals("CSI Definition")) { %>
            <th method="get"><font size="2">CSI Definition</font></th>
<%        } else if (sAttr.equals("Permissible Value")) { %>
            <th method="get"><font size="2">Permissible Value</font></th>
<%        } else if (sAttr.equals("CS Long Name")) { %>
            <th method="get"><font size="2">CS Long Name</font></th>
<%        } else if (sAttr.equals("Historical CDE ID")) { %>
            <th method="get"><font size="2">Historical CDE ID</font></th>
<%        } else if (sAttr.equals("Registration Status")) { %>
            <th method="get"><font size="2">Registration Status</font></th>
<%        } else if (sAttr.equals("Date Created")) { %>
            <th method="get"><font size="2">Date Created</font></th>
<%        } else if (sAttr.equals("Creator")) { %>
            <th method="get"><font size="2">Creator</font></th>
<%        } else if (sAttr.equals("Date Modified")) { %>
            <th method="get"><font size="2">Date Modified</font></th>
<%        } else if (sAttr.equals("Modifier")) { %>
            <th method="get"><font size="2">Modifier</font></th>
<%        } else if (sAttr.equals("Registration Status")) { %>
            <th method="get"><font size="2">Registration Status</font></th>
<%        }   else if (sAttr.equals("Concept Name")) { %>
            <th method="get"><font size="2">Concept Name</font></th>
<%        }   else if (sAttr.equals("Identifier")) { %>
            <th method="get"><font size="2">Identifier</font></th>
<%        }   else if (sAttr.equals("Definition Source")) { %>
            <th method="get"><font size="2">Definition Source</font></th>
<%        } else if (sAttr.equals("Context")) { %>
            <th method="get"><font size="2">Owned By Context</font></th>
<%        }   else if (sAttr.equals("Database")) { %>
            <th method="get"><font size="2">Database</font></th>
<%        }   else if (sAttr.equals("Comment Document Text")) { %>
            <th method="get"><font size="2">Comment Document Text</a></th>
<%        }   else if (sAttr.equals("Data Element Source Document Text")) { %>
            <th method="get"><font size="2">Data Element Source Document Text</a></th>
<%        }   else if (sAttr.equals("Description Document Text")) { %>
            <th method="get"><font size="2">Description Document Text</a></th>
<%        }   else if (sAttr.equals("Detail Description Document Text")) { %>
            <th method="get"><font size="2">Detail Description Document Text</a></th>
<%        }   else if (sAttr.equals("Example Document Text")) { %>
            <th method="get"><font size="2">Example Document Text</a></th>
<%        }   else if (sAttr.equals("Image File Document Text")) { %>
            <th method="get"><font size="2">Image File Document Text</a></th>
<%        }   else if (sAttr.equals("Label Document Text")) { %>
            <th method="get"><font size="2">Label Document Text</a></th>
<%        }   else if (sAttr.equals("Note Document Text")) { %>
            <th method="get"><font size="2">Note Document Text</a></th>
<%        }   else if (sAttr.equals("Reference Document Text")) { %>
            <th method="get"><font size="2">Reference Document Text</a></th>
<%        }   else if (sAttr.equals("Reference Documents")) { %>
            <th method="get"><font size="2">Reference Documents</a></th>
<%        }   else if (sAttr.equals("Technical Guide Document Text")) { %>
            <th method="get"><font size="2">Technical Guide Document Text</a></th>
<%        }   else if (sAttr.equals("UML Attribute Document Text")) { %>
            <th method="get"><font size="2">UML Attribute Document Text</a></th>
<%        }   else if (sAttr.equals("UML Class Document Text")) { %>
            <th method="get"><font size="2">UML Class Document Text</a></th>
<%        }   else if (sAttr.equals("Valid Value Source Document Text")) { %>
            <th method="get"><font size="2">Valid Value Source Document Text</a></th>
<%        }   else if (sAttr.equals("Other Types Document Text")) { %>
            <th method="get"><font size="2">Other Types Document Text</a></th>
<%        }   else if (sAttr.equals("Long Name Document Text")) { %>
            <th method="get"><font size="2">Long Name Document Text</a></th>
<%        }   else if (sAttr.equals("Historic Short CDE Name Document Text")) { %>
            <th method="get"><font size="2">"Historic Short CDE Name Document Text</a></th>
<%
	        }  }  }
%>
    </tr>
<%
    String strResult = "";
    if (results != null)
	  {
      int j = 0;
		  for (int i = 0; i < results.size(); i+=k)
		  {
         //  String ckName = ("CK" + j);
           strResult = (String)results.get(i);
           if (strResult == null) strResult = "";
%>
        <tr>
          <td width="100"><font size="2"><%=strResult%></font></td>
<%   
          // add other attributes
		 for (int m = 1; m < k; m++)
		 {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>
           <td><font size="2"><%=strResult%></font></td>
<%
       }
%>
       </tr>
<%
         j++;
    }
	 }
%>
 </table>
 <table>
<input type="hidden" name="newCDEPageAction" value="nothing">
<input type="hidden" name="AttChecked" value="<%=(k-5)%>">
<input type="hidden" name="searchComp" value="">
<input type="hidden" name="numSelected" value="">
<input type="hidden" name="sortType" value="nothing">
<input type="hidden" name="actSelected" value="Search">
<input type="hidden" name="numAttSelected" value="">
<input type="hidden" name="orgCompID" value="">
<input type="hidden" name="desID" value="">
<input type="hidden" name="desName" value="">
<input type="hidden" name="desContext" value="">
<input type="hidden" name="desContextID" value="">
<input type="hidden" name="AppendAction" value="NotAppended">
<input type="hidden" name="SelectAll" value="">
  <!-- stores Designation Name and ID -->
</table>
      <!-- div for associated AC popup menu -->
<script language = "javascript">
//getSearchComponent();
</script>
</form>
<form name="SearchActionForm" method="post" action="">
<input type="hidden" name="acID" value="">
<input type="hidden" name="itemType" value="">
<input type="hidden" name="isValidSearch" value="false">
</form>
</body>
</html>
