<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/VDPVSTab.jsp,v 1.15 2009-04-21 19:08:14 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="gov.nih.nci.cadsr.common.Constants"%>
<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
<%
		String sTabFocus = (String) session.getAttribute("TabFocus");
		//for view only page
		String bodyPage = (String) request.getAttribute("IncludeViewPage");
		boolean isView = false;
		if (bodyPage != null && !bodyPage.equals(""))
		{
			isView = true;
			if (bodyPage.equals("PermissibleValue.jsp"))
				sTabFocus = "PV";
		}
      UtilService serUtil = new UtilService();
      String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
      String sOriginAction = (String) session.getAttribute("originAction");
      if (sOriginAction == null)
          sOriginAction = "";
      String vdTabFocus = "TABX";
      String pvTabFocus = "TABX";
      if (sTabFocus == null || sTabFocus.equals(""))
      	sTabFocus = "VD";
      if (sTabFocus.equals("VD"))
      	vdTabFocus = "TABY";
      else
      	pvTabFocus = "TABY";
      	
  //  System.out.println(pvTabFocus + " tab " + vdTabFocus);
      //get the name for the tab display
      VD_Bean mVD = new VD_Bean();
      String id = "";
      if (isView){
		   id = (String)request.getAttribute("viewVDId");
		   String viewVD = "viewVD" + id;
		   mVD = (VD_Bean) session.getAttribute(viewVD);
	  }else{
		   mVD = (VD_Bean) session.getAttribute("m_VD");
     }   
      if (mVD == null) mVD = new VD_Bean();
      String sVDIDseq = mVD.getVD_VD_IDSEQ();
      boolean inForm = mVD.getVD_IN_FORM();
      if(inForm) {
          session.setAttribute(Constants.VD_USED_IN_FORM, inForm);    //GF7680
      }
      String sLongName = mVD.getVD_LONG_NAME();
      if (sLongName == null) sLongName = "";
      if (!sLongName.equals(""))
      	sLongName = serUtil.parsedStringDoubleQuoteJSP(sLongName); //call the function to handle doubleQuote
      String sVersion = mVD.getVD_VERSION();
      if (sVersion == null) sVersion = "1.0";
	    String sVDID = mVD.getVD_VD_ID();
	    if (sVDID == null) sVDID = "";

      String vdNameDisplay = "";
      if (!sLongName.equals(""))
      	vdNameDisplay = " - " + sLongName + "  [" + sVDID + "v" + sVersion + "]";

	    //these are for value/meaning search.
	    if (!isView) {
	    session.setAttribute(Session_Data.SESSION_MENU_ACTION, "searchForCreate");
	    Vector vResult = new Vector();
	    session.setAttribute("results", vResult);
	    session.setAttribute("creRecsFound", "No ");
	    //for altnames and ref docs
	    session.setAttribute("dispACType", "ValueDomain");
	    }
        String displayErrorMessagee = (String)session.getAttribute("displayErrorMessage");
        String from = "view";
        if ((displayErrorMessagee != null)&&(displayErrorMessagee).equals("Yes")){
          from = "edit";
        }
        
   // System.out.println(sOriginAction + " action " + sMenuAction);

		%>
		

<script>

 var newwindow;
function openUsedWindowVM(idseq, type)
{
var newUrl = "../../cdecurate/NCICurationServlet?reqType=showUsedBy";
newUrl = newUrl + "&idseq=" +idseq+"&type="+type;

	newwindow=window.open(newUrl,"UsedByForms","height=400,width=600,toolbar=no,scrollbars=yes,menubar=no");
	if (window.focus) {newwindow.focus()}


}
</script>
<table width="100%" border="0">
	<tr height="25">
		<td height="26" align="left" valign="top">
			<% if (!isView) { %>
			<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate')">
			&nbsp;&nbsp;
			<!--no need for clear button in the block edit-->
			<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
			&nbsp;&nbsp;
			<% if (!sOriginAction.equals("NewVDFromMenu")){%>
			<input type="button" name="btnBack" value="Back" onClick="SubmitValidate('goBack');">
			&nbsp;&nbsp;
			<% } %>
			<%if(sOriginAction.equals("BlockEditVD")){%>
			<input type="button" name="btnDetails" value="Details" onClick="openBEDisplayWindow();">
			&nbsp;&nbsp;
			<%} } %>
			<input type="button" name="btnAltName" value="Alt Names/Defs" 
				<% if (isView) { %>
					onClick="openAltNameViewWindow();"
				<% } else { %>
					onClick="openDesignateWindow('Alternate Names');" 
				<% } %>
			>
			&nbsp;&nbsp;
			<input type="button" name="btnRefDoc" value="Reference Documents" 
				<% if (isView) { %>
					onClick="openRefDocViewWindow();"
				<% } else { %>
					onClick="openDesignateWindow('Reference Documents');" 
				<% } %>
			>
			&nbsp;&nbsp;
			<% if((displayErrorMessagee != null)&&(displayErrorMessagee).equals("Yes")){	%>
							<input type="button" value="Back" onClick="Back();">
							&nbsp;&nbsp;
			<% }else if (isView) {	%>
				<input type="button" id="btnClose" value="Close" onClick="window.close();">
				&nbsp;&nbsp;
			<% }session.setAttribute("displayErrorMessage", "No"); %>
			<img name="Message" src="images/WaitMessage1.gif" width="250px" height="25px" alt="WaitMessage" style="visibility:hidden;">
		</td>
	</tr>
	<tr valign="middle">
		<th colspan=2 height="40">
			<div align="left">
				<%if (!isView){ %>
				<%if (sOriginAction.contains("NewVD") || sMenuAction.contains("NewVD")) {%>
				<label>
					<font size=4>
						Create New
						<font color="#FF0000">
							Value Domain
						</font>
						<%if (sMenuAction.equals("NewVDVersion")){%>
						Version
						<%} else if (sMenuAction.equals("NewVDTemplate")){%>
						Using Existing
						<%}%>
					</font>
				</label>
				<%} else if(sOriginAction.equals("BlockEditVD")){%>
				<label>
					<font size=4>
						Block Edit Existing
						<font color="#FF0000">
							Value Domains
						</font>
					</font>
				</label>
				<% } else {%>
				<label>
					<font size=4>
						<%if (isView) { %>
						   View Value Domain
						<% } else { %>
						   Edit Existing
						<font color="#FF0000">
							Value Domain
						</font>
						<%} %>
					</font>
				</label>
				<% }}else{%>
				   <label>
					<font size=4>
						View Value Domain
					</font>
				</label>
				
				<%}%>
					<font size=3>
						<%=vdNameDisplay%>
					</font>	
					<%if (inForm){%>
					<br>
					<font size=4 color="#FF0000">Note:</font>
					<font size=4> Value Domain is used in a form. <a href="javascript:openUsedWindowVM('<%=sVDIDseq%>','VD');">View Usage</a></font>
					<%}%>	
			</div>
		</th>
	</tr>
	<%if(!sOriginAction.equals("BlockEditVD") && (!isView)){%>
	<tr height="25" valign="bottom">
		<td align="left" colspan=2 height="11">
			<font color="#FF0000">
				&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;
			</font>
			Indicates Required Field
		</td>
		<br>
	</tr>
	<%}%>
</table>
<table style="width: 100%; border-collapse: collapse;">
	<colgroup>
		<col style="width: 15%" />
		<col style="width: 15%" />
		<col />
	</colgroup>
	<tr>
		<td id="vddetailstab" class="<%=vdTabFocus%>" <% if (isView) { %>onclick="changeTab('VD','<%=StringEscapeUtils.escapeJavaScript(from)%>', '<%=id%>');"<% } else { %>onclick="SubmitValidate('vddetailstab');"<%} %>>
			<b>
				Value Domain Details
			</b>
		</td>
		<% if(!sOriginAction.equals("BlockEditVD")){%>
		<td id="vdpvstab" class="<%=pvTabFocus%>" <% if (isView) { %>onclick="changeTab('PV','<%=StringEscapeUtils.escapeJavaScript(from)%>', '<%=id%>');"<% } else { %>onclick="SubmitValidate('vdpvstab');"<%} %>>
			<b>
				Permissible Values
			</b>
		</td>
		<% } else {%>
		<td style="border-bottom: 2px solid black">
			&nbsp;
		</td>
		<% } %>
		<td style="border-bottom: 2px solid black" align="left" valign="middle">
			&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>
