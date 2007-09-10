<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/NonEVSSearchPage.jsp,v 1.1 2007-09-10 16:16:48 hebell Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to secondary window error page if error occurs -->
<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<curate:checkLogon name="Userbean" page="/ErrorPageWindow.jsp" />
<!-- NonEVSSearchResultPage.jsp -->
<html>
	<head>
		<title>
			Referenced VD Non EVS Parent
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="java.util.*"%>
		<%@ page import="java.text.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%
  EVS_Bean eBean = (EVS_Bean)request.getAttribute("SelectedVDParent");
  if (eBean == null) eBean = new EVS_Bean();
  String sName = eBean.getLONG_NAME();
  if (sName == null) sName = "";
  String sDoc = eBean.getPREFERRED_DEFINITION();
  if (sDoc == null) sDoc = "";
  String sURL = eBean.getEVS_DEF_SOURCE();
  if (sURL == null) sURL = "";
  request.setAttribute("SelectedVDParent", new EVS_Bean());
%>
		<script>
  var browseWindow = null;
  function hourglass()
  {
    document.body.style.cursor = "wait";
  }
  //display message to upload document
  function uploadDocument()
  {
    alert("The Upload Document function will be available in a future release.");
  }
  
  //paste the text back to vd page
  function useSelection()
  {
    var sURL = document.nonEVSSearchPage.txtRefURL.value;
    if (sURL != null && sURL != "" && (sURL.length < 8 || (sURL.substring(0,7) != "http://" && sURL.substring(0,8) != "https://")))
    {
      alert("Reference Document URL Text must begin with 'http:// or https://'");
      return;
    }
    if (opener.document != null)
    {
      opener.document.getElementById("hiddenParentName").value = document.nonEVSSearchPage.txtRefName.value;
      opener.document.getElementById("hiddenParentCode").value = document.nonEVSSearchPage.txtRefText.value;
      opener.document.getElementById("hiddenParentDB").value = document.nonEVSSearchPage.txtRefURL.value;
      opener.document.getElementById("pageAction").value = "CreateNonEVSRef";
      opener.document.getElementById("Message").style.visibility="visible";
      opener.document.body.style.cursor = "wait";
      opener.SubmitValidate("CreateNonEVSRef");

      window.close();
    }
  }
  
  //enable use selection button if name is not null
  function enableButton()
  {
    var sName = document.nonEVSSearchPage.txtRefName.value;
    if (sName != null && sName != "")
        document.nonEVSSearchPage.useSelectedBtn.disabled = false;
  }
  
  //submit form to refresh for type change action
  function changeType(sType)
  {
     hourglass();
     window.status = "Refereshing the page, it may take a minute, please wait....."
     document.nonEVSSearchPage.actSelect.value = sType;
     document.nonEVSSearchPage.submit();
  }
  
  //when first opened check if it is to select or view
  function setup()
  {
    if (opener.document != null && opener.document.SearchActionForm != null)
    {
      //resubmit to get the data if search action is false and parent is selected
      var sInd = opener.document.getElementById("listParentConcept").selectedIndex;
      var isFirst = opener.document.SearchActionForm.isValidSearch.value;
      if (isFirst == "false" && sInd > -1)
      {
        opener.document.SearchActionForm.isValidSearch.value = "true";
        //fill the refname to get matching parent from the list of parents.
        document.nonEVSSearchPage.txtRefName.value = opener.document.getElementById("selectedParentConceptName").value;
        hourglass();
        window.status = "Refereshing the page, it may take a minute, please wait....."
        document.nonEVSSearchPage.actSelect.value = "viewParent";
        document.nonEVSSearchPage.submit();        
      }
    }
  }
  
  
  //restrict the input of the text if exceeds the max length
  function textCounter(field, maxlimit) 
  {
    var objField = eval("document.nonEVSSearchPage." + field);
    if (objField.value.length > maxlimit) // if too long...trim it!
      objField.value = objField.value.substring(0, maxlimit);
  }

  //open window to browse
  function openBrowse()
  {
    if (browseWindow && !browseWindow.closed)
        browseWindow.close();
    browseWindow = window.open("", "browseWindow")
    if (browseWindow.document != null)
    {
      browseWindow.document.writeln('<font size=4><b>');
      browseWindow.document.writeln("Navigate to desired URL and then use copy and paste method to select document URL");
      browseWindow.document.writeln('</b></font>');
    }
  } 
</script>
	</head>
	<body onLoad="setup();">
		<form name="nonEVSSearchPage" method="post" action="../../cdecurate/NCICurationServlet?reqType=nonEVSSearch">
			<table width="100%" border="2" cellpadding="0" cellspacing="0">
				<col width="21%">
				<col width="79%">
				<tr valign="top">
					<td class="sidebarBGColor">
						<table class="sidebarBGColor" border="0" width="100%">
							<col width="5%">
							<col width="100%">
							<tr>
								<td height="7" colspan=2 valign="top">
							</tr>
							<tr height="35">
								<th align=right>
									1)
								</th>
								<th align="left">
									Search For:
								</th>
							</tr>
							<tr height="20">
								<td>
									&nbsp;
								</td>
								<td align=left>
									<select name="listSearchFor" size="1" style="width:172" onHelp="showHelp('Help_SearchAC.html#searchParmsForm_SearchParameters'); return false">
										<option value="ParentConcept" selected>
											Parent Concept
										</option>
									</select>
								</td>
							</tr>
							<tr height="35">
								<th align=right>
									2)
								</th>
								<th align="left">
									Search Type:
								</th>
							</tr>
							<tr height="20">
								<td>
									&nbsp;
								</td>
								<td>
									&nbsp;&nbsp;&nbsp;&nbsp
									<input type="RADIO" value="EVS" name="rRefType" onclick="changeType('EVS');" <%if(!sName.equals("")){%> disabled <%}%>>
									EVS &nbsp;&nbsp;&nbsp;&nbsp
									<input type="RADIO" value="Non EVS" checked="checked" name="rRefType" onclick="changeType('nonEVS');" <%if(!sName.equals("")){%> disabled <%}%>>
									Non EVS
								</td>
							</tr>
							<tr height="350">
								<td colspan=2 valign="top">
							</tr>
						</table>
					</td>
					<td>
						<table width="90%" border=0 align="center">
							<tr>
								<td height="7" valign="top">
							</tr>
							<tr>
								<td align="left" valign="top">
									<input type="button" name="useSelectedBtn" value="Set Reference" onClick="useSelection();" disabled style="width:100;height:30">
									&nbsp;&nbsp;
									<input type="button" name="btnClose" value="Close" onclick="window.close();" style="width:50;height:30">
									&nbsp;&nbsp;
									<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
								</td>
							<tr>
								<td height="7" valign="top">
							</tr>
							<tr></tr>
						</table>
						<table width="90%" border="0" align="center">
							<col width="60%">
							<col width="25%">
							<col width="15%">
							<!--    <tr valign="middle" height="55">
                <td colspan="3"><font size="4"><b>Reference Document Type : Value Domain Reference</b></font></td>
            </tr>  -->
							<tr valign="bottom" height="25">
								<td colspan="3">
									<b>
										Reference Type
									</b>
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<input type="TEXT" name="txtRefType" style="width:100%" value="Value Domain Reference" readonly></input>
								</td>
								<td></td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="3">
									<b>
										Reference Name
									</b>
									(maximum 30 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<input type="TEXT" name="txtRefName" style="width:100%" onchange="enableButton();" onkeydown="javascript:textCounter('txtRefName', 30);" onkeyup="javascript:textCounter('txtRefName', 30);" value="<%=sName%>" <% if(!sName.equals("")) {%> readonly
										<%}%>></input>
								</td>
								<td></td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="3">
									<b>
										Reference Document Text
									</b>
									(maximum 4000 characters)
								</td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<textarea name="txtRefText" style="width:100%" rows=2 onchange="enableButton();" onkeydown="javascript:textCounter('txtRefText', 4000);" onkeyup="javascript:textCounter('txtRefText', 4000);" <% if(!sName.equals("")) {%> readonly <%}%>><%=sDoc%></textarea>
								</td>
								<td></td>
							</tr>
							<tr valign="bottom" height="25">
								<td colspan="2">
									<b>
										Reference URL
									</b>
									(maximum 240 characters)
								</td>
								<td></td>
							</tr>
							<tr valign="middle">
								<td colspan="2">
									<input name="txtRefURL" type="text" value="<%=sURL%>" style="width:100%" onchange="enableButton();" onkeydown="javascript:textCounter('txtRefURL', 240);" onkeyup="javascript:textCounter('txtRefURL', 240);" <% if(!sName.equals("")) {%> readonly
										<%}%>></input>
								</td>
								<td>
									<% if(sName.equals("")) {%>
									<a href="javascript:openBrowse();">
										Browse
									</a>
									<%}%>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<input type="hidden" name="actSelect" value="nonEVS" style="visibility:hidden;">
		</form>
	</body>
</html>
