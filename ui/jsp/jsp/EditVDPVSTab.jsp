<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/EditVDPVSTab.jsp,v 1.5 2007-01-26 19:30:38 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*" %>
<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
        

</script>

		<%  
      String sMenuAction = (String) session.getAttribute("MenuAction");
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
        <input type="button" name="btnAltName" value="Alternate Names" style="width:125" onClick="openDesignateWindow('Alternate Names');">
          &nbsp;&nbsp;
        <input type="button" name="btnRefDoc" value="Reference Documents" style="width:140" onClick="openDesignateWindow('Reference Documents');">
          &nbsp;&nbsp;
 	     <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
      </td>
    </tr>
    <tr valign="middle"> 
        <th colspan=2 height="40"> <div align="left">
		       <%if (sOriginAction.contains("NewVD") || sMenuAction.contains("NewVD")) {%> 
							<label><font size=4>Create New<font color="#FF0000"> Value Domain</font>
								<%if (sMenuAction.equals("NewVDVersion")){%>Version
								<%} else if (sMenuAction.equals("NewVDTemplate")){%>Using Existing
								<%}%></font>
							</label>
		       <%} else if(sOriginAction.equals("BlockEditVD")){%>
		          <label><font size=4>Block Edit Existing <font color="#FF0000">Value Domains</font></font></label>
		       <% } else {%>
		          <label><font size=4>Edit Existing <font color="#FF0000">Value Domain</font></font></label>
		       <% } %> </div>
		    </th>
    </tr>
  <%if(!sOriginAction.equals("BlockEditVD")){%>
	  <tr height="25" valign="bottom">
        <td align="left" colspan=2 height="11"><font color="#FF0000">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;</font>Indicates Required Field</td>
      </tr> 
    <%}%>
  </table>
	<table style="width: 100%; border-collapse: collapse">
    <colgroup><col style="width: 15%" /><col style="width: 15%" /><col /></colgroup>
		<tr>
			<td id="editvddetailstab" class="<%=vdTabFocus%>" onclick="SubmitValidate('editvddetailstab');">
				Value Domain Details
			</td>
			<td id="editvdpvstab" class="<%=pvTabFocus%>" onclick="SubmitValidate('editvdpvstab');">
				Permissible Values
			</td>
      <td style="border-bottom: 2px solid black" align="left" valign="middle">
         &nbsp;&nbsp;&nbsp;&nbsp;<font size="2"><b>NIH Training Types [1234567v1.0] </b></font>
      </td>
		</tr>
	</table>
