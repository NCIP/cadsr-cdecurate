<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateConceptClass.jsp,v 1.1 2008-12-04 19:37:25 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<!-- goes to lgoin page if error occurs -->
<%@page errorPage="ErrorPage.jsp"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<html>
<head>
		<title>
			Create Concept Class
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/style.css" rel="stylesheet" type="text/css">
        <script language="JavaScript" src="js/menu.js"></script>
        <script language="JavaScript" src="js/header.js"></script>
        <script language="javascript" type="text/javascript">
           history.forward();
           
           	//to add concepts to the vm, store the editing element and pv number in the hidden field
	     function selectConcept()
	     {
	     	window.open("jsp/OpenSearchWindowBlocks.jsp", "BlockSearch", "width=975,height=700,top=0,left=0,resizable=yes,scrollbars=yes")
  }
        </script>
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
						<input type="button" name="btnValidate" value="Validate" style="width: 125" onClick="SubmitValidate('validate');" onHelp="showHelp('html/Help_CreateVD.html#createVMForm_Validation',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClear" value="Clear" style="width: 125" onClick="clearBoxes();">
						&nbsp;&nbsp;
						<input type="button" name="btnBack" value="Back" style="width: 125" onClick="Back();">
						&nbsp;&nbsp;
						<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
					</td>
				</tr>
				<tr>
				<td>
				<div style="border: 1px black dotted;" align="center">
				<table width="90%" border="0">
				<col width="4%">
				<col width="95%">
				<tr valign="middle">
					<th colspan=2 height="40">
						<div align="left">
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
							<option value="AllContext"
								
								selected >
								All Contexts
							</option>
							
							<option value="caBIG"
								>
								caBIG
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
						      <a href="javascript:show_calendar('createConceptClassForm.beginDate', null, null, 'MM/DD/YYYY');">
							<img name="Calendar" src="images/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top", "background-color: #FF0000">
						</a>
						&nbsp;&nbsp;MM/DD/YYYY<br/><br/>
							<div class="ind2">
								
									<font color="#FF0000">* Enter/Select </font>Effective End Date
								
							</div>
								<input type="text" name="endDate" value="" size="12" maxlength=10>
							  <a href="javascript:show_calendar('createConceptClassForm.endDate', null, null, 'MM/DD/YYYY');">
							<img name="Calendar" src="images/calendarbutton.gif" width="22" height="22" alt="Calendar" style="vertical-align: top", "background-color: #FF0000">
						</a>
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
