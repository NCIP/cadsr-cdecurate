<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/PermissibleValue.jsp,v 1.37 2009-04-21 19:08:14 veerlah Exp $
    $Name: not supported by cvs2svn $
-->


<html>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sb" uri="/struts-bootstrap-tags"%>
<sj:head jqueryui="true" jquerytheme="custom" customBasepath="themes"
	loadAtOnce="true" />
<%--<sj:head jqueryui="true" jquerytheme="smoothness" />
<sj:head jqueryui="true" jquerytheme="cupertino" /> 
<sj:head jqueryui="true" jquerytheme="redmond" loadAtOnce="true" />--%>
<title>Value Domain Wireframes</title>

<link href="styles/layout.css" rel="stylesheet" type="text/css" />
<link href="styles/custom.css" rel="stylesheet" type="text/css" />
<!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
<!--[if lt IE 9]>    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>    
<![endif]-->
<script type="text/javascript" src="js/showcase.js"></script>

	<body bgcolor="#FFFFFF" text="#000000">
		<form name="Form1" method="post" action="../../cdecurate/NCICurationServlet?reqType=newDEFromMenu"></form>
		<form name="Form2" method="post" action="../../cdecurate/NCICurationServlet?reqType=newDECFromMenu"></form>
		<form name="Form3" method="post" action="../../cdecurate/NCICurationServlet?reqType=newVDFromMenu"></form>
		<form name="LogoutForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=logout"></form>
		<form name="Form4" method="post" action="../../cdecurate/NCICurationServlet?reqType=actionFromMenu">
		<input type="hidden" name="hidMenuAction" value="nothing"/>
		</form>
		
		<table width="100%" border="0">
			<col style="width: 1px" />
			<col />
			<tr bgcolor="#A90101">
				<td align="left">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="images/brandtype.gif" border="0">
					</a>
				</td>
				<td align="right">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="images/tagline_nologo.gif" border="0">
					</a>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="padding:0 0 0 0">
					<a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr">
						<img src="images/curation_banner2.gif" border="0" alt="caDSR Logo">
					</a>
				</td>
			</tr>
		</table>
		<table style="border-collapse: collapse; width: 100%;">
			<col style="width: 2.3in" />
			<col />
			<tr>
				<td style="padding:0.05in 0 0 0">
					
					User&nbsp;Name&nbsp;:&nbsp;
					PANS
					
				</td>
				<td style="padding:0.05in 0 0 0">
					<script webstyle3>document.write('<scr'+'ipt src="js/xaramenu.js">'+'</scr'+'ipt>');document.write('<scr'+'ipt src="js/biztech_button.js">'+'</scr'+'ipt>');/*img src="images/biztech_button.gif" moduleid="myzara                     (project)\biztech_button_off.xws"*/</script>
				</td>
			</tr>
		</table>
	</body>
</html>

			</td>
		</tr>
		
		<tr>
			<td width="100%" valign="top">
				<form name="PVForm" method="POST"
					action="../../cdecurate/NCICurationServlet?reqType=pvEdits">
					
					<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/VDPVSTab.jsp,v 1.15 2009-04-21 19:08:14 veerlah Exp $
    $Name: not supported by cvs2svn $
-->




<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">


		

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
			
			<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate')">
			&nbsp;&nbsp;
			<!--no need for clear button in the block edit-->
			<input type="button" name="btnClear" value="Clear" onClick="ClearBoxes();">
			&nbsp;&nbsp;
			
			<input type="button" name="btnBack" value="Back" onClick="SubmitValidate('goBack');">
			&nbsp;&nbsp;
			
			
			<input type="button" name="btnAltName" value="Alt Names/Defs" 
				
					onClick="openDesignateWindow('Alternate Names');" 
				
			>
			&nbsp;&nbsp;
			<input type="button" name="btnRefDoc" value="Reference Documents" 
				
					onClick="openDesignateWindow('Reference Documents');" 
				
			>
			&nbsp;&nbsp;
			
			<img name="Message" src="images/WaitMessage1.gif" width="250px" height="25px" alt="WaitMessage" style="visibility:hidden;">
		</td>
	</tr>
	<tr valign="middle">
		<th colspan=2 height="40">
			<div align="left">
				
				
				<label>
					<font size=4>
						
						   Edit Existing
						<font color="#FF0000">
							Value Domain
						</font>
						
					</font>
				</label>
				
					<font size=3>
						 - Anatomic Site Location Text Name  [2188327v1.0]
					</font>	
						
			</div>
		</th>
	</tr>
	
	<tr height="25" valign="bottom">
		<td align="left" colspan=2 height="11">
			<font color="#FF0000">
				&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;
			</font>
			Indicates Required Field
		</td>
		<br>
	</tr>
	
</table>
<table style="width: 100%; border-collapse: collapse;">
	<colgroup>
		<col style="width: 15%" />
		<col style="width: 15%" />
		<col />
	</colgroup>
	<tr>
		<td id="vddetailstab" class="TABX" onclick="SubmitValidate('vddetailstab');">
			<b>
				Value Domain Details
			</b>
		</td>
		
		<td id="vdpvstab" class="TABY" onclick="SubmitValidate('vdpvstab');">
			<b>
				Permissible Values
			</b>
		</td>
		
		<td style="border-bottom: 2px solid black" align="left" valign="middle">
			&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
</table>

					<div
						style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0in 0.1in 0in">
						
								<s:url var="pvDetailsUrl" value="permissibleValueDetails.jsp" />
						<sj:div href="%{pvDetailsUrl}" />

					</div>
					<div style="display:none;">
						<input type="hidden" name="hideDatePick"
							oncalendar="appendDate(this.value);"> <input
							type="hidden" name="pageAction" value="nothing"> <input
							type="hidden" name="editPVInd" value="">
						<!-- keep this if there was error -->
						<input type="hidden" name="currentPVInd" value=""> <input
							type="hidden" name="currentElmID" value=""> <input
							type="hidden" name="currentPVViewType" value=""> <input
							type="hidden" name="currentOrg" value=""> <input
							type="hidden" name="currentBD" value=""> <input
							type="hidden" name="currentED" value=""> <input
							type="hidden" name="currentVM" value=""> <select
							name="PVViewTypes" size="1" style="visibility:hidden;width:100;"
							multiple>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
							<option value="expand" selected>
								expand
							</option>
							
						</select> <input type="hidden" name="hiddenParentName" value=""> <input
							type="hidden" name="hiddenParentCode" value=""> <input
							type="hidden" name="hiddenParentDB" value=""> <input
							type="hidden" name="hiddenParentListString" value=""> <select
							name="ParentNames" size="1" style="visibility:hidden;width:100;"
							multiple>
							
						</select> <select name="ParentCodes" size="1"
							style="visibility:hidden;width:100;" multiple>
							
						</select> <select name="ParentDB" size="1"
							style="visibility:hidden;width:100;" multiple>
							
						</select> <select name="ParentMetaSource" size="1"
							style="visibility:hidden;width:100;" multiple>
							
						</select> <input type="hidden" name="selectedParentConceptName" value="">
						<input type="hidden" name="selectedParentConceptCode" value="">
						<input type="hidden" name="selectedParentConceptDB" value="">
						<input type="hidden" name="selectedParentConceptMetaSource"
							value="">
						
						<input type="hidden" name="MenuAction" value="editVD">
						<input type="hidden" name="pvSortColumn" value=""> <input
							type="hidden" name="openToTree" value=""> <input
							type="hidden" name="actSelect" value=""> <input
							type="hidden" name="listVDType" value="E">
						<!-- stores the selected rows to get the bean from the search results -->
						<select name="hiddenSelRow" size="1"
							style="visibility:hidden;width:160" multiple></select>
						<!-- use both name and id -->
						<select id="hiddenConVM" name="hiddenConVM" size="1"
							style="visibility:hidden;width:160" multiple></select> <input
							type="hidden" name="acSearch" value="">
					</div>
				</form>
			</td>
		</tr>
	</table>
	<div style="display:none">
		<form name="SearchActionForm" method="post" action="">
			
			<input type="hidden" name="searchComp" value="DataElement">
			<input type="hidden" name="searchEVS" value="ValueDomain"> <input
				type="hidden" name="isValidSearch" value="true"> <input
				type="hidden" name="CDVDcontext" value=""> <input
				type="hidden" name="SelContext" value=""> <input
				type="hidden" name="acID" value="E3BF78C8-8EF1-6255-E034-0003BA12F5E7"> <input
				type="hidden" name="CD_ID" value="B1ED0F8B-4D91-332D-E034-0003BA12F5E7"> <input
				type="hidden" name="itemType" value=""> <input type="hidden"
				name="SelCDid" value="B1ED0F8B-4D91-332D-E034-0003BA12F5E7">
		</form>
	</div>
	<script language="javascript">
//put the pv in edit mode after cancel the duplicate to make sure that user completes the action

</script>
</body>
</html>
