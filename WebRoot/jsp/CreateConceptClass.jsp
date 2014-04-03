<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateConceptClass.jsp,v 1.4 2009-04-21 03:47:34 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to lgoin page if error occurs -->
<%@page errorPage="ErrorPage.jsp"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<!-- GF32649 -->
<%@ page import="gov.nih.nci.ncicb.cadsr.common.CaDSRUtil"%>
<html>
<head>
		<!-- includes change for NCIP -->
		<title>
			Create Concept Class
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/style.css" rel="stylesheet" type="text/css">
        <script language="JavaScript" src="js/menu.js"></script>
        <script language="JavaScript" src="js/date.js"></script>
        <script language="JavaScript" src="js/header.js"></script>
	<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
        <script language="javascript" type="text/javascript">
           history.forward();
           
         function Back()
           {
           alert("Here");
             window.open("../../cdecurate/NCICurationServlet?reqType=homePage");
           }
        </script>
        <style>
	<!--
	td.menuItemBlank {
		color: #f0f0f0;
		padding: 2px 8px 2px 8px;
		background-color: #336699;
		cursor: default
	}
	
	td.menuItemNormal {
		color: #f0f0f0;
		font-size: 10pt;
		padding: 2px 12px 2px 12px;
		background-color: #336699;
		cursor: default;
		border-left: 1px dotted #f0f0f0
	}
	
	td.footerItem {
		color: #f0f0f0;
		font-size: 8pt;
		background-color: #336699;
		text-align: center;
		font-weight: normal;
		padding: 2px 0px 2px 0px;
		cursor: default
	}
	
	td.rsCell {
		border: 1px solid #e0e0e0;
		padding: 4px 4px 4px 4px
	}
	
	th.rsCell {
		border: 1px solid #e0e0e0;
		padding: 4px 4px 4px 4px
	}
	
	tr.stripe {
		background-color: #e0e0e0
	}
	
	span.footerItemVer {
		color: #a9a9a9;
		font-size: 8pt;
		background-color: #336699;
		text-align: center;
		font-weight: normal;
		padding: 2px 0px 2px 0px;
		cursor: default
	}
	
	span.footerItemSep {
		color: #f0f0f0;
		font-size: 8pt;
		background-color: #336699;
		text-align: center;
		font-weight: normal;
		padding: 2px 0px 2px 0px;
		cursor: default
	}
	
	span.footerItemNormal {
		color: #f0f0f0;
		font-size: 8pt;
		background-color: #336699;
		text-align: center;
		font-weight: normal;
		padding: 2px 8px 2px 8px;
		cursor: default
	}
	
	span.footerItemFocus {
		color: #f0f0f0;
		font-size: 8pt;
		background-color: #475B82;
		text-align: center;
		font-weight: normal;
		padding: 2px 8px 2px 8px;
		cursor: pointer
	}
	
	div.footerBanner1 {
		width: 100%;
		background-color: #336699;
		padding: 2px 0px 2px 0px;
		text-align: center
	}
	
	div.footerBanner2 {
		width: 100%;
		text-align: center;
		padding-top: 5px
	}
	
	div.menu {
		display: none;
		position: absolute;
		border: 2px outset #eeeeee;
		background-color: #d8d8df;
		padding: 5px 5px 5px 5px;
		margin: 0px 0px 0px 0px
	}
	
	div.xyz {
		padding: 0px 0px 0px 0px;
		margin: 0px 0px 0px 0px;
		width: 100%
	}
	
	div.scItem {
		padding-top: 7px
	}
	
	div.scSubItem {
		padding-top: 7px;
		padding-left: 20px
	}
	
	div.popMenu {
		padding: 8px 5px 3px 5px;
		margin: 0px 0px 0px 0px;
		cursor: default
	}
	
	div.hrWrap {
		padding: 4px 0px 4px 0px
	}
	
	dl.menu {
		padding: 0px 0px 4px 7px;
		margin: 0px 0px 0px 0px
	}
	
	dt.menu {
		padding: 0px 0px 4px 7px;
		margin: 0px 0px 0px 0px
	}
	
	hr.xyz {
		padding: 0px 0px 0px 0px;
		margin: 0px 0px 0px 0px;
		width: 1in;
		height: 1px
	}
	
	table.tight {
		width: 100%;
		border-collapse: collapse;
		border: 0px solid black;
		padding: 0in 0in 0in 0in
	}
	
	table.footerBanner1 {
		width: 100%;
		background-color: #5c5c5c
	}
	
	table.menu {
		width: 100%;
		background-color: #5c5c5c;
		border: 0px solid #336699
	}
	
	body {
		font-family: Arial, Helvetica, Verdana, sans-serif;
		font-size: 10pt
	}
	
	table {
		font-family: Arial, Helvetica, Verdana, sans-serif;
		font-size: 10pt
	}
	
	p {
		font-family: Arial, Helvetica, Verdana, sans-serif;
		font-size: 10pt
	}
	
	td.tabx {
	
		border: 1px solid black;
		border-bottom: 1px solid black;
		padding: 0.05in 0.05in 0.05in 0.05in;
		font-family:  Arial, Helvetica, Geneva, sans-serif;
		text-align: left;
		background-color: #CCCCCC;
		cursor: default
	}
	
	td.taby {
	
		border-top: 1px solid black;
		border-left: 1px solid black;
		border-right: 1px solid black;
		padding: 0.05in 0.05in 0.05in 0.05in;
		font-family:  Arial, Helvetica, Geneva, sans-serif;
		text-align: left;
		cursor: default
	}
	
	div.divbody {
	
		border-left: 1px solid black;
		border-right: 1px solid black;
		border-bottom: 1px solid black;
		cursor: default
	}
	-->
	</style>

</head>
<curate:sessionAttributes/>
	<body onload="loaded('menuDefs'); enableDisableMenuItems();" onclick="menuHide();" onkeyup="if (event.keyCode == 27) menuHide();">
		<curate:header displayUser = "true"/>
		<jsp:include  page = "menuDefs.jsp" />
		<form name="createConceptClassForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=newConceptClass">
			<input type="hidden" name="pageAction" value="nothing">
			<table width="100%" border="0">
				<col width="4%">
				<col width="95%">
				<tr>
					<td colspan="6" align="left" valign="top">
						<input type="button" name="btnValidate" value="Validate" onClick="SubmitValidate('validate');" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" onClick="clearBoxes();">
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" onClick="Back();">
						&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
				<tr>
				<td>
				<table style="width: 100%; border-collapse: collapse"  cellspacing=0 cellpadding=0>
				
							<colgroup>
								<col style="width: 3%" />
								<col style="width: 5%" />
								<col style="width: 4%" />
								<col />
							</colgroup>
				
							<tr>
								<td id="detailstd" class="taby" nowrap
									onclick="tabSetFocus(this, details);" bordercolor="black"> 
									<font color="#336699"><b>Concept Class Detail</b> </font>
								</td>
								<td id="refdoctd" class="tabx" onclick="tabSetFocus(this, refdoc);" nowrap> 
									<font color="#336699"><b>Reference Document(s)</b></font> 
								</td>
								<td id="desigtd" class="tabx" onclick="tabSetFocus(this, desig);" nowrap> 
									<font color="#336699"><b>Alternate Names/Definitions</b></font> 
								</td>
					                	<td style="border-bottom: 1px solid black;" align="left"
									valign="middle">
				
								</td>
							</tr>
				</table>
				  <div id="details" class="divbody" style="display:; " align="left">
				<table width="90%" border="0">
								<col width="4%">
								<col width="95%">
								<tr valign="middle">
									<th colspan=2 height="40">
										<div align="left">
										<br>
											<label>
												<font size=4>
													Create New
													<font color="#FF0000">
														Concept Class
													</font>
																				
											</font><br><br>
											<font size=1><font color="#FF0000">*</font> Indicates Required Field </font>
											</label><br><br></div></th></tr>
											<tr><td>		
											<form name="VMDetail" method="POST" action="../../cdecurate/NCICurationServlet?reqType=newConceptClass">
											<div class="tabbody" style="width: 100%">
											<div class="ind2">
												
												<font color="#FF0000">* Enter/Select</font> Concept Code
												
											</div>
											<input type="text" style="width:20%" id ="conceptCode" name="conceptCode" value=""/>&nbsp;<a href="javascript:selectConcept();">
																								Search EVS
																							</a>
																						<br/><br/>
											<div class="ind2">
												
												<font color="#FF0000">* Enter/Select</font>	Long Name
												
											</div>
											<input type="text" style="width:20%" id ="longName" name="longName" value=""/><br/><br/>
											<div class="ind2">
												
													Public Id
												
											</div>
											<input type="text" style="width:20%" id ="publicId" name="publicId" value="System Generated" readonly/><br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Enter</font> Version
												
											</div>
											<input type="text" style="width:20%" id ="version" name="version" value=""/><br/><br/>
											<div class="ind2">
												<font color="#FF0000">* Enter</font>	Definition
												
											</div>
											<input type="text" style="width:40%" id ="definition" name="definition" value=""/><br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Enter</font> Definition Source
												
											</div>
											<input type="text" style="width:40%" id ="definitionSrc" name="definitionSrc" value=""/><br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Select </font> Database
												
											</div>
											<select style='width: 150px;' id="database" name="database">
											<option value="NCI Thesaurus" 
												selected >
												NCI Thesaurus
											</option>
											
											<option value="Gene Ontology" >
												GO
											</option>
											
											<option value="National Drug File - Reference Terminology" >
												VA_NDFRT
											</option>
											
											<option value="Logical Observation Identifier Names and Codes" >
												LOINC
											</option>
											
											<option value="The MGED Ontology" >
												MGED
											</option>
											
											<option value="Medical Dictionary for Regulatory Activities Terminology (MedDRA)" >
												MedDRA
											</option>
											
											<option value="SNOMED Clinical Terms" >
												SNOMED
											</option>
											
											<option value="NCI Metathesaurus" >
												NCI Metathesaurus
											</option>
											
											<option value="Zebrafish" >
												Zebrafish
											</option>
											</select><br/><br/>
											<div class="ind2">
												
											<font color="#FF0000">* Select </font> Source Type
												
											</div>
											<select style='width: 150px;' id ="srcType" name="srcType">
											<option value="" >
												GO_CODE
											</option>
											
											<option value="" >
												LOINC_CODE
											</option>
											
											<option value="" >
												MEDDRA_CODE
											</option>
											
											<option value="" >
												NCI_CONCEPT_CODE
											</option>
											
											<option value="" >
												NCI_META_CUI
											</option>
											
											<option value="" >
												NCI_MO_CODE
											</option>
											
											<option value="" >
												SNOMED_CODE
											</option>
											
											<option value="" >
												UMLS_CUI
											</option>
											
											<option value="" >
												UWD_VA_CODE
											</option>
											
											<option value="" >
												VA_NDF_CODE
											</option>
												<option value="" >
												ZEBRAFISH_CODE
											</option>
											</select><br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Select </font>Context
												
											</div>
											<select style='width: 150px;' id ="context" name="context">
											
											<option value="All (No Test/Train)"
												
												selected >
												All (No Test/Train)
											</option>
											
											<option value="AllContext"
												
												 >
												All Contexts
											</option>
											
											<!-- GF32649 -->
											<option value="<%=CaDSRUtil.getDefaultContextName()%>"
												>
                                                <%=CaDSRUtil.getDefaultContextName()%>
											</option>
											
											<option value="caCORE"
												>
												caCORE
											</option>
											
											<option value="CCR"
												>
												CCR
											</option>
											
											<option value="CDISC"
												>
												CDISC
											</option>
											
											<option value="CIP"
												>
												CIP
											</option>
											
											<option value="CTEP"
												>
												CTEP
											</option>
											
											<option value="DCP"
												>
												DCP
											</option>
											
											<option value="EDRN"
												>
												EDRN
											</option>
											
											<option value="HITSP"
												>
												HITSP
											</option>
											
											<option value="NCRI"
												>
												NCRI
											</option>
											
											<option value="NHLBI"
												>
												NHLBI
											</option>
											
											<option value="NIDCR"
												>
												NIDCR
											</option>
											
											<option value="PS&CC"
												>
												PS&CC
											</option>
											
											<option value="SPOREs"
												>
												SPOREs
											</option>
											
											<option value="TEST"
												>
												TEST
											</option>
											
											<option value="Training"
												>
												Training
											</option>
										  </select><br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Enter/Select </font>Effective Begin Date
												
											</div>
											<input type="text" name="beginDate" value="" size="12" maxlength=10>
											<img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('beginDate', event);">
										&nbsp;&nbsp;MM/DD/YYYY<br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Enter/Select </font>Effective End Date
												
											</div>
												<input type="text" name="endDate" value="" size="12" maxlength=10>
											<img name="Calendar" src="images/calendarbutton.gif" alt="Calendar" onclick="calendar('endDate', event);">
										&nbsp;&nbsp;MM/DD/YYYY<br/><br/>
											<div class="ind2">
												
													<font color="#FF0000">* Select </font>Workflow Status
												
											</div>
											<select style='width: 150px;' id ="workflowStatus" name="workflowStatus">
											<option value="AllStatus"
												
												selected >
												All Statuses
											</option>
											<!--store the status list as per the search component  -->
											
											<option value="APPRVD FOR TRIAL USE"
												>
												APPRVD FOR TRIAL USE
											</option>
											
											<option value="CMTE APPROVED"
												>
												CMTE APPROVED
											</option>
											
											<option value="CMTE SUBMTD"
												>
												CMTE SUBMTD
											</option>
											
											<option value="CMTE SUBMTD USED"
												>
												CMTE SUBMTD USED
											</option>
											
											<option value="DRAFT MOD"
												>
												DRAFT MOD
											</option>
											
											<option value="DRAFT NEW"
												>
												DRAFT NEW
											</option>
											
											<option value="RELEASED"
												>
												RELEASED
											</option>
											
											<option value="RELEASED-NON-CMPLNT"
												>
												RELEASED-NON-CMPLNT
											</option>
											
											<option value="RETIRED ARCHIVED"
												>
												RETIRED ARCHIVED
											</option>
											
											<option value="RETIRED DELETED"
												>
												RETIRED DELETED
											</option>
											
											<option value="RETIRED PHASED OUT"
												>
												RETIRED PHASED OUT
											</option>
											
											<option value="RETIRED WITHDRAWN"
												>
												RETIRED WITHDRAWN
											</option>
											
										</select><br/><br/>
									</div>
									<div class="ind2">
									
										<font color="#FF0000">* Enter </font>Change Note
									
									</div>
									<input type="text" style="width:40%" id ="changeNote" name="changeNote" value=""/><br/>
									</form>
									</td>
									</tr>
					</table>
				</div>		
				</td>
			</tr>
		</table>
		<curate:footer/>
	</body>
</html>
