<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/VDPVSTab.jsp,v 1.10 2007-05-23 23:20:06 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">

<%  
      UtilService serUtil = new UtilService();
      String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
      String sOriginAction = (String) session.getAttribute("originAction");
      String vdTabFocus = "TABX";
      String pvTabFocus = "TABX";
      String sTabFocus = (String) session.getAttribute("TabFocus");
      if (sTabFocus == null || sTabFocus.equals(""))
      	sTabFocus = "VD";
      if (sTabFocus.equals("VD"))
      	vdTabFocus = "TABY";
      else
      	pvTabFocus = "TABY";
      	
  //  System.out.println(pvTabFocus + " tab " + vdTabFocus);
      //get the name for the tab display
      VD_Bean mVD = (VD_Bean) session.getAttribute("m_VD");
      if (mVD == null) mVD = new VD_Bean();
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
	    session.setAttribute(Session_Data.SESSION_MENU_ACTION, "searchForCreate");
	    Vector vResult = new Vector();
	    session.setAttribute("results", vResult);
	    session.setAttribute("creRecsFound", "No ");
	    //for altnames and ref docs
	    session.setAttribute("dispACType", "ValueDomain");


   // System.out.println(sOriginAction + " action " + sMenuAction);

		%>
<table width="100%" border="0">
	<tr height="25">
		<td height="26" align="left" valign="top">
			<input type="button" name="btnValidate" value="Validate" style="width:125" onClick="SubmitValidate('validate')">
			&nbsp;&nbsp;
			<!--no need for clear button in the block edit-->
			<input type="button" name="btnClear" value="Clear" style="width:125" onClick="ClearBoxes();">
			&nbsp;&nbsp;
			<% if (!sOriginAction.equals("NewVDFromMenu")){%>
			<input type="button" name="btnBack" value="Back" style="width:125" onClick="SubmitValidate('goBack');">
			&nbsp;&nbsp;
			<% } %>
			<%if(sOriginAction.equals("BlockEditVD")){%>
			<input type="button" name="btnDetails" value="Details" style="width: 125" onClick="openBEDisplayWindow();">
			&nbsp;&nbsp;
			<%}%>
			<input type="button" name="btnAltName" value="Alt Names/Defs" style="width:125" onClick="openDesignateWindow('Alternate Names');">
			&nbsp;&nbsp;
			<input type="button" name="btnRefDoc" value="Reference Documents" style="width:140" onClick="openDesignateWindow('Reference Documents');">
			&nbsp;&nbsp;
			<img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
		</td>
	</tr>
	<tr valign="middle">
		<th colspan=2 height="40">
			<div align="left">
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
						Edit Existing
						<font color="#FF0000">
							Value Domain
						</font>
					</font>
				</label>
				<% } %>
					<font size=3>
						<%=vdNameDisplay%>
					</font>	
			</div>
		</th>
	</tr>
	<%if(!sOriginAction.equals("BlockEditVD")){%>
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
		<td id="vddetailstab" class="<%=vdTabFocus%>" onclick="SubmitValidate('vddetailstab');">
			<b>
				Value Domain Details
			</b>
		</td>
		<% if(!sOriginAction.equals("BlockEditVD")){%>
		<td id="vdpvstab" class="<%=pvTabFocus%>" onclick="SubmitValidate('vdpvstab');">
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
