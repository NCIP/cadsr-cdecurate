<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/EVSSearchResults.jsp,v 1.7 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<html>
	<head>
		<title>
			CDE Curation Tool: Search Enterprise Vocabulary System
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/SearchResults.js"></SCRIPT>
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
   Vector results = null;
   String sKeyword = "";
   String nRecs = "";
   
   results = (Vector)session.getAttribute("EVSresults");
   if (results == null)  results = new Vector();
   session.setAttribute("EVSresults", null);

    sKeyword = (String)session.getAttribute("creKeyword");
   if(sKeyword == null)
    sKeyword = "";
   session.setAttribute("creKeyword", null);

   nRecs = (String)session.getAttribute("creRecsFound");
    if (nRecs == null)
      nRecs = "No ";

   String sLabelKeyword =  (String)session.getAttribute("labelKeyword");
   if (sLabelKeyword == null)
      sLabelKeyword = "";
%>

		<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
   var selDefinition = null;
   var numRowsSelected = 0;
   var evsWindow2 = null;
   var checkBoxArray = new Array();
   var evsNewUrl = "<%=ToolURL.getEVSNewTermURL(pageContext)%>";

  function NoDefinitionFound()
  {
     sComp = opener.document.SearchActionForm.searchEVS.value;
      if (sComp == "DataElementConcept")
      {
         opener.document.newDECForm.CreateDefinition.value = "No definition found in EVS.";
      }
      else if (sComp == "ValueDomain")
      {
	       opener.document.createVDForm.CreateDefinition.value = "No definition found in EVS.";
      }
      else if (sComp == "DataElement")
      {
        opener.document.newCDEForm.CreateDefinition.value = "No definition found in EVS.";
      }
      else if (sComp == "PermissableValue")
      {
        opener.document.createPVForm.CreateDescription.value = "No definition found in EVS.";
      }
      else if (sComp == "ValueMeaning")
      {
        opener.document.createVMForm.CreateDescription.value = "No definition found in EVS.";
      }
  }

  function NoTermFound()
  {
     sComp = opener.document.SearchActionForm.searchEVS.value;
      if (sComp == "DataElementConcept")
      {
         opener.document.newDECForm.CreateDefinition.value = "No matching term found in EVS.";
      }
      else if (sComp == "ValueDomain")
      {
	       opener.document.createVDForm.CreateDefinition.value = "No matching term found in EVS.";
      }
      else if (sComp == "DataElement")
      {
        opener.document.newCDEForm.CreateDefinition.value = "No matching term found in EVS.";
      }
      else if (sComp == "PermissableValue")
      {
        opener.document.createPVForm.CreateDescription.value = "No matching term found in EVS.";
      }
      else if (sComp == "ValueMeaning")
      {
        opener.document.createVMForm.CreateDescription.value = "No matching term found in EVS.";
      }
  }

  function NewTermSuggested()
  {
     var sComp1 = opener.document.SearchActionForm.searchEVS.value;
     if (sComp1 == "DataElementConcept")
     {
        var decDef = opener.document.newDECForm.CreateDefinition.value;
        if (decDef != "")
          opener.document.newDECForm.CreateDefinition.value = decDef + " New EVS term suggested.";
        else
          opener.document.newDECForm.CreateDefinition.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open(evsNewUrl, "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
     else if (sComp1 == "ValueDomain")
     {
        var vdDef = opener.document.createVDForm.CreateDefinition.value;
        if(vdDef != "")
          opener.document.createVDForm.CreateDefinition.value = vdDef + " New EVS term suggested.";
         else
          opener.document.createVDForm.CreateDefinition.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open(evsNewUrl, "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
      else if (sComp1 == "DataElement")
      {
        opener.document.newCDEForm.CreateDefinition.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open(evsNewUrl, "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
       else if (sComp1 == "PermissableValue")
      {
        opener.document.createPVForm.CreateDescription.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open(evsNewUrl, "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
      else if (sComp1 == "ValueMeaning")
      {
        opener.document.createVMForm.CreateDescription.value = "New EVS term suggested.";
         if (evsWindow2 && !evsWindow2.closed)
            evsWindow2.close()
         evsWindow2 = window.open(evsNewUrl, "EVSWindow2", "width=750,height=550,resizable=yes,scrollbars=yes")
      }
  }

  function EnablePasteButton(checked, currentField)
  {
      
      if (checked)
      {
         ++numRowsSelected;
      }
      else
         --numRowsSelected;

      var rowNo = currentField.name;
      var rowNum = rowNo.substring(2, rowNo.length);
      if (numRowsSelected > 0)
      {
         if (numRowsSelected == 1)
         {
             document.EVSSearchResultsForm.useSelectedBtn.disabled=false;
             if (checked)
             {
                StoreSelectedRow(rowNo);
                checkBoxArray.push(rowNum);
             }
             else
             {
              checkBoxArrayRemove(rowNum);
              FindAndStoreSelectedRow();
             }
         }
         else
         {
            if (checked)
            {
              document.EVSSearchResultsForm.useSelectedBtn.disabled=true;
              checkBoxArray.push(rowNum);
            }
            else
            {
              checkBoxArrayRemove(rowNum);
            }
         }
        
      }
      else
      {
              document.EVSSearchResultsForm.useSelectedBtn.disabled=true;
      }
   }



   function StoreSelectedRow(rowNo)
   {
    rowNo = rowNo.substring(2, rowNo.length);
    var k = 2 + rowNo*5;
    var t = rowNo;
<%
if (results.size() > 0)
{
%>
    selDefinition = document.EVSSearchResultsForm.hiddenResults[k].text;
    if(document.EVSSearchResultsForm.hiddenName[t].value != null)
      selName = document.EVSSearchResultsForm.hiddenName[t].value;
<%
}
%>
   }

   function checkBoxArrayRemove(rowNum)
   {
      for(i=0;i< checkBoxArray.length;i++)
      {
        if(checkBoxArray[i] == rowNum)
         checkBoxArray[i] = 0;
      }
    }


   function FindAndStoreSelectedRow()
   {
      var lastRow = 0;
      for(i=0;i< checkBoxArray.length;i++)
      {
        if(checkBoxArray[i] != 0)
         lastRow = checkBoxArray[i];
      }    
      var k = 2 + lastRow*5;
      var t = lastRow;
<%
if (results.size() > 0)
{
%>
    selDefinition = document.EVSSearchResultsForm.hiddenResults[k].text;
    if(document.EVSSearchResultsForm.hiddenName[t].value != null)
      selName = document.EVSSearchResultsForm.hiddenName[t].value;
<%
}
%>
   }

   function PasteDefinition()
   {
      sComp = opener.document.SearchActionForm.searchEVS.value;
      if (sComp == "DataElementConcept")
      {
         opener.document.newDECForm.CreateDefinition.value = selDefinition;
      }
      else if (sComp == "ValueDomain")
      {
	       opener.document.createVDForm.CreateDefinition.value = selDefinition;
      }
      else if (sComp == "DataElement")
      {
        opener.document.newCDEForm.CreateDefinition.value = selDefinition;
      }
      else if (sComp == "PermissableValue")
      {
        opener.document.createPVForm.CreateDescription.value = selDefinition;
      }
      else if (sComp == "ValueMeaning")
      {
        opener.document.createVMForm.CreateDescription.value = selDefinition;
        opener.document.createVMForm.selShortMeanings.value = selName;
        opener.document.createVMForm.CreateDescription.disabled = true;
      }
      window.close();
   }

</SCRIPT>
	</head>

	<body>
		<form name="EVSSearchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showResult">
			<table width="100%" border="0">
				<tr height="40" valign="bottom">
					<td>
						<input type="button" name="useSelectedBtn" value="Link Concept" onClick="PasteDefinition()" disabled>
						&nbsp;&nbsp;
						<input type="button" name="btnSubmitToEVS" value="Submit Suggestion to EVS" onclick="javascript:NewTermSuggested();">
						&nbsp;&nbsp;
						<input type="button" name="btnClose" value="Close" onclick=window.close()>
						&nbsp;&nbsp;
						<b>
							<font size="2">
								Copy Text to Definition Field:
							</font>
						</b>
						&nbsp;&nbsp;
						<a href="javascript:NoTermFound();">
							No matching term found in EVS
						</a>
					</td>
				</tr>
				<tr valign="top">
					<td>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (click link to copy text)
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:NoDefinitionFound();">
							No definition found in EVS
						</a>
					</td>
				</tr>
				<tr valign="bottom" height="35">
					<td>
						<font size="3">
							<b>
								Search Results for:
								<%=sLabelKeyword%>
							</b>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						<font size="2">
							&nbsp;
							<%=nRecs%>
							Records Found
						</font>
					</td>
				</tr>
				<tr valign="top">
					<table width="100%" border="1">
						<th width="4%">
							<img src="images/CheckBox.gif">
						</th>
						<th width="10%">
							Concept Name
						</th>
						<th width="10%">
							Identifier
						</th>
						<th width="50%">
							Definition
						</th>
						<th width="8%">
							Definition Source
						</th>
						<th width="8%">
							Database
						</th>
						</tr>
						<%
    String strResult = "";
    int k = 5;

    if (results != null)
	  {
      int j = 0;
		  for (int i = 0; i < results.size(); i+=k)
		  {
           String ckName = ("CK" + j);
           strResult = (String)results.get(i);
           if (strResult == null) strResult = "";
%>
						<tr>
							<td width="5px">
								<input type="checkbox" name="<%=ckName%>" onClick="javascript:EnablePasteButton(checked,this);"/>
							</td>
							<td width="100px">
								<%=strResult%>
							</td>
							<%    
          // add other attributes
		    for (int m = 1; m < k; m++)
		    {
           if ((i + m)< results.size())
            strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
%>
							<td>
								<%=strResult%>
							</td>
							<%
          }
%>
						</tr>
						<%
         j++;
    }
	 }
%>
						<select size="1" name="hiddenResults" style="visibility:hidden;" style="width: 145px">
							<%        for (int m = 0; results.size()>m; m++)
          {
             String sName = (String)results.elementAt(m);
%>
							<option value="<%=sName%>">
								<%=sName%>
							</option>
							<%
          }
%>
						</select>
						<select size="1" name="hiddenName" style="visibility:hidden;" style="width: 145px">
							<%        for (int i = 0; i<results.size(); i+=k)
          {
             String sName = (String)results.elementAt(i);
%>
							<option value="<%=sName%>">
								<%=sName%>
							</option>
							<%
          }
%>
						</select>

					</table>
				</tr>
				<input type="hidden" name="outPrint" value="Print" style="visibility:hidden;" <% out.println(""+results.size());// leave this in, it slows jsp load down so no jasper error%>>
			</table>
		</form>
	</body>
</html>
