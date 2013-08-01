<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CRFValueResults.jsp,v 1.4 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			CRF Value Results
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%@ page import="java.util.*"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		
		<link href="css/FullDesignVer.css" rel="stylesheet" type="text/css">
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
      Vector vQuestValue = (Vector)session.getAttribute("vQuestValue");
      if (vQuestValue == null) vQuestValue = new Vector();

      Integer recs = new Integer(vQuestValue.size());
      String nRecs = recs.toString();

      //make keyWordLabel label request session
      Quest_Bean QuestBean = (Quest_Bean)session.getAttribute("m_Quest");
      String sQuestion = "";
      if (QuestBean != null)
         sQuestion = QuestBean.getQUEST_NAME();
      String sLabelKeyword = "CRF Values in Question - " + sQuestion;   //make the label

      Quest_Value_Bean QuestValueBean = new Quest_Value_Bean();

      Vector vNewPV = (Vector)request.getAttribute("newPVData");
      if (vNewPV == null) vNewPV = new Vector();
%>

		<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
   var numRowsSelected = 0;
    var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
   
   function setup()
   {
 <%
    String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
    if (statusMessage == null) statusMessage = "";
    if (!statusMessage.equals(""))
    {
 %>
	    alert("<%=statusMessage%>");
 <%
    }
    session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
 %>
    window.status = "Enter the keyword to search a component"

    UpdateOpenerForNew();

      <!-- alert("setup"); -->
   }
  //if the created, update the opener document
  function UpdateOpenerForNew()
  {
 <% if (vNewPV.size() > 0)
    {
         String sPVid = (String)vNewPV.elementAt(0);
         String sPValue = (String)vNewPV.elementAt(1);
         String sPVmean = (String)vNewPV.elementAt(2);
 %>
         var idx = parseInt(opener.document.createVDForm.valueCount.value);
         opener.document.createVDForm.selValuesList[idx].value = "<%=sPVid%>";
         opener.document.createVDForm.selValuesList[idx].text = "<%=sPValue%>";
         opener.document.createVDForm.selMeaningsList[idx].value = "<%=sPValue%>";
         opener.document.createVDForm.selMeaningsList[idx].text = "<%=sPVmean%>";
         opener.document.createVDForm.hiddenMeanText.value = "<%=sPVmean%>";
         idx++;

         opener.document.createVDForm.valueCount.value = idx;
<%
    }
%>
  }

  function EnableButtons(checked, currentField)
  {
      if (checked)
         ++numRowsSelected;
      else
         --numRowsSelected;
      var rowNo = currentField.name;
      rowNo = rowNo.substring(2, rowNo.length);

      if (document.searchParmsForm.listSearchFor.value == "PermissibleValue" && numRowsSelected > 1)
      {
     	 	var vOrigin = opener.document.createVDForm.MenuAction.value;
		    if (vOrigin == "Questions" && numRowsSelected > 1)
		    {
			    formObj= eval("document.searchResultsForm."+currentField.name);
			    formObj.checked=false;
			    --numRowsSelected;
			    alert("Please select only one value at a time.");
		    }
	    }
      else if (numRowsSelected == 1)
      {

<%
         for (int i=0; i<(vQuestValue.size()); i++)
         {
%>
            var qNo = <%=i%>;
            if (qNo == rowNo)
            {
<%
               QuestValueBean = new Quest_Value_Bean();
               QuestValueBean = (Quest_Value_Bean)vQuestValue.elementAt(i);
               String QuestValue = QuestValueBean.getQUESTION_VALUE();
               String QuestIDseq = QuestValueBean.getQUESTION_VALUE_IDSEQ();
%>
               //store the name and id in the search parameter form.
               document.searchParmsForm.QCValueIDseq.value = "<%=QuestIDseq%>";
               document.searchParmsForm.QCValueName.value = "<%=QuestValue%>";
               document.searchParmsForm.keyword.value = "<%=QuestValue%>";
            }
<%
	      }
%>
      }
  }


</SCRIPT>

	</head>

	<body bgcolor="#FFFFFF" onLoad="setup();">
		<form name="searchResultsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=showResult">
			<br>
			<table width="100%" border="0">
				<tr height="20" valign="top">
					<!-- makes Create New  button to create new    -->
					<td align="left">
						<input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();">
						&nbsp;&nbsp;
						<img name="Message" src="images/SearchMessage.gif" width="180" height="25" alt="WaitMessage" style="visibility:hidden;" valign="bottom">
					</td>
				</tr>
			</table>
			<br>
			<table width="100%">
				<tr>
					<td>
						<font size="4">
							<b>
								Search Results of
								<%=sLabelKeyword%>
							</b>
						</font>
					</td>
					<td>
						<div align="right">
							<font size="2">
								<%=nRecs%>
								Records Found
							</font>
						</div>
					</td>
				</tr>
			</table>
			<table width="100%" border="1">
				<tr valign="middle">
					<th height="30">
						<img src="images/CheckBox.gif">
					</th>
					<th method="get">
						<a href="../../cdecurate/NCICurationServlet?reqType=doSortCDE&sortType=CRFValue" onClick=SetSortType( "CRFValue");
              onHelp="showHelp('html/Help.htm#searchResultsForm_sort',helpUrl); return false">
							Values from CRF Question
						</a>
					</th>
					<th method="get">
						<a href="../../cdecurate/NCICurationServlet?reqType=doSortCDE&sortType=value" onClick=javascript:SetSortType( "value")
              onHelp="showHelp('html/Help.htm#searchResultsForm_sort',helpUrl); return false">
							Value Items
						</a>
					</th>
					<th method="get">
						<a href="../../cdecurate/NCICurationServlet?reqType=doSortCDE&sortType=meaning" onClick=javascript:SetSortType( "meaning")
              onHelp="showHelp('html/Help.htm#searchResultsForm_sort',helpUrl); return false">
							Value Meanings
						</a>
					</th>
				</tr>
				<%
      for(int i=0; i<(vQuestValue.size()); i++)
      {
        QuestValueBean = new Quest_Value_Bean();
        QuestValueBean = (Quest_Value_Bean)vQuestValue.elementAt(i);
        String ckName = ("CK" + i);
        String crfValue =  QuestValueBean.getQUESTION_VALUE();
        if (crfValue == null) crfValue = "";
        String PValue =  QuestValueBean.getPERMISSIBLE_VALUE();
        if (PValue == null) PValue = "";
        String PVMean =  QuestValueBean.getVALUE_MEANING();
        if (PVMean == null) PVMean = "";
%>
				<tr>
					<td width="5">
						<input type="checkbox" name="<%=ckName%>" onClick="javascript:EnableButtons(checked,this);">
					</td>
					<td width="100">
						<%=crfValue%>
					</td>
					<td width="100">
						<%=PValue%>
					</td>
					<td width="100">
						<%=PVMean%>
					</td>
				</tr>
				<%
	   }
%>
			</table>
		</form>
	</body>
</html>
