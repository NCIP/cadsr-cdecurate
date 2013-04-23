<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<div id="col1">
	<div id="col1_content" class="clearfix">

		<form name="searchParmsForm" method="post"
			action="../../cdecurate/NCICurationServlet?reqType=searchACs">
			<!-- need this style to keep the table aligned top which is different for crf questions   -->
			<table class="sidebarBGColor" border="0" width="100%"
				style="position: relative; top: -28px;">

				<col width="5%">
				<col width="100%">
				<tr>
					<td height="7" colspan=2 valign="top">
				</tr>
				<tr>
					<th align=right>1)</th>
					<th valign="top" align="left">Search For:</th>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align=left>
						<!-- include all components for regular search or question search-->

						<select name="listSearchFor" size="1" style="width: 172px"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="ValueMeaning" selected>Value Meaning</option>
					</select>
					</td>
				</tr>

				<!--not for crf questions    -->

				<tr>
					<td height="7" colspan=2 valign="top">
				</tr>
				<tr>
					<th valign="top" align=right>2)</th>
					<th valign="bottom">
						<div align="left">Search In:</div>
					</th>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><select name="listSearchIn" size="1" style="width: 172px"
						onChange="doSearchInChange();"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<!-- include names&definition only if not questions-->
							<option value="longName" selected>Names & Definition</option>
							<!-- include document text for Data Element -->

							<!-- include crf name if not searching from create & only DataElement-->

							<!-- include public ID all administered componenet -->

							<option value="minID">Public ID</option>

							<!-- include Historical cde_ID for Data Element -->

							<!-- include permissible value for Data Element and value domain-->

							<!-- include origin all administered componenet -->

							<!-- include concept filter for all acs-->

							<option value="concept">Concept Name/EVS Identifier</option>

					</select>
					</td>
				</tr>

				<!-- Names, definition, long name document text and historic short cde name search in -->


				<!-- Reference Document Types if the search in is  Refernce Document Text -->

				<!-- end not equal value meaning -->

				<!--  makes two input boxes if searhing crfname  otherwise only one  -->

				<tr>
					<td height="7" colspan=2 valign="top">
				</tr>
				<tr>
					<th><div valign="top" align=right>3)</div></th>
					<th valign="bottom">
						<div align="left">Enter Search Term:</div>
					</th>
				</tr>

				<!-- same input box for crf name and other keyword searches -->
				<tr>
					<td>&nbsp;</td>
					<td><input type="text" name="keyword" size="24" value="lung"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<div align="left"
							title="The wildcard character, *, expands the search to find a non-exact match.">
							use * as wildcard</div>
					</td>
				</tr>

				<!-- end not crf question -->
				<tr>
					<td height="7" colspan=2 valign="top">
				</tr>
				<tr>
					<th><div valign="top" align=right>4)</div></th>
					<th valign="bottom">
						<div align="left">
							Filter By:
							<!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->

						</div>
					</th>
				</tr>
				<br>
				<!--not for crf questions    -->

				<!--no context for permissible value search for    -->


				<br>
				<!-- designation exist only for data element -->

				<!-- radio button version only for DE, VD, DEC, CD searches-->

				<tr>
					<td>&nbsp;</td>
					<td style="height: 20" valign=bottom><b> Version </b>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align=left><input type="radio" name="rVersion" value="All"
						onclick="javascript:removeOtherText();"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						All&nbsp; <input type="radio" name="rVersion" value="Yes"
						onclick="javascript:removeOtherText();" checked
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Latest&nbsp; <input type="radio" name="rVersion" value="Other"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						<input type="text" name="tVersion" value="" maxlength="5" size="3"
						style="height: 20" onkeyup="javascript:enableOtherVersion();"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
					</td>
				</tr>

				<!-- filter value domain type -->


				<!-- classification schemes filter for csi search -->

				<!-- CD filter for pv, vm, dec or vd searches drop down list-->

				<tr>
					<td>&nbsp;</td>
					<td style="height: 20" valign=bottom><b> Conceptual Domain
					</b>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><select name="listCDName" size="1" style="width: 172px"
						valign="top"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="All Domains">All Domains</option>

							<option title="1A RH TEST CD - TEST"
								value="FC6E9AFD-4890-63AA-E034-0003BA3F9857">1A RH TEST
								CD - TEST</option>

							<option title="Abnormal Cell - caBIG"
								value="0741AABF-C6A3-2728-E044-0003BA3F9857">Abnormal
								Cell - caBIG</option>

							<option title="Activity - caBIG"
								value="1B8A8A1E-77BA-4685-E044-0003BA3F9857">Activity -
								caBIG</option>

							<option title="Address - caBIG"
								value="67F3112F-4C10-2255-E040-BB89AD43764C">Address -
								caBIG</option>

							<option title="Adverse Event - TEST"
								value="F404CD55-647E-276B-E034-0003BA3F9857">Adverse
								Event - TEST</option>

							<option title="Adverse Event Occurrences - CTEP"
								value="B3092D14-2B40-0CA5-E034-0003BA12F5E7">Adverse
								Event Occurrences - CTEP</option>

							<option title="Adverse Event Results - CTEP"
								value="BB869948-5E78-2537-E034-0003BA12F5E7">Adverse
								Event Results - CTEP</option>

							<option title="Adverse Events - CTEP"
								value="AB51E03C-635E-5672-E034-0003BA12F5E7">Adverse
								Events - CTEP</option>

							<option title="Affiliation Type - DCP"
								value="CF636D8C-E049-5012-E034-0003BA12F5E7">Affiliation
								Type - DCP</option>

							<option title="Anatomic Sites - TEST"
								value="D93ABE66-E2C1-40C5-E034-0003BA12F5E7">Anatomic
								Sites - TEST</option>

							<option title="Anatomic Sites - CTEP"
								value="B1ED0F8B-4D91-332D-E034-0003BA12F5E7">Anatomic
								Sites - CTEP</option>

							<option title="Anatomic Structure, System, or Substance - caBIG"
								value="0741AE5B-831D-25C7-E044-0003BA3F9857">Anatomic
								Structure, System, or Substance - caBIG</option>

							<option title="Assessment Occurrences - CTEP"
								value="B203ECED-CE3C-69BE-E034-0003BA12F5E7">Assessment
								Occurrences - CTEP</option>

							<option title="Assessment Results - CTEP"
								value="B2D08DE9-38BB-7208-E034-0003BA12F5E7">Assessment
								Results - CTEP</option>

							<option title="Assessments - EDRN"
								value="CC049DE1-E982-5FB4-E034-0003BA12F5E7">Assessments
								- EDRN</option>

							<option title="Assessments - CTEP"
								value="B22DA727-6718-5A2D-E034-0003BA12F5E7">Assessments
								- CTEP</option>

							<option title="Assessments - TEST"
								value="DC2065AE-57FE-47D7-E034-0003BA12F5E7">Assessments
								- TEST</option>

							<option title="Assessments - EDRN"
								value="CC049DE1-E976-5FB4-E034-0003BA12F5E7">Assessments
								- EDRN</option>

							<option title="Behavior - SPOREs"
								value="B78145CC-5DBF-209B-E034-0003BA12F5E7">Behavior -
								SPOREs</option>

							<option title="Biochemical Pathway - caBIG"
								value="0741B16D-87D7-26CD-E044-0003BA3F9857">Biochemical
								Pathway - caBIG</option>

							<option title="Bioinformatics - caCORE"
								value="CD81DD3C-8FFA-28BA-E034-0003BA12F5E7">
								Bioinformatics - caCORE</option>

							<option title="Biological Process - caBIG"
								value="0741AABF-C6A4-2728-E044-0003BA3F9857">Biological
								Process - caBIG</option>

							<option title="BIOLOGICAL PROCESSES - SPOREs"
								value="A8E871E4-EC81-7323-E034-0003BA12F5E7">BIOLOGICAL
								PROCESSES - SPOREs</option>

							<option title="Biology - caBIG"
								value="61B96FD6-A3CA-FAEE-E040-BB89AD43223E">Biology -
								caBIG</option>

							<option title="Business Rules - SPOREs"
								value="B799A5DB-F019-086C-E034-0003BA12F5E7">Business
								Rules - SPOREs</option>

							<option title="caBIG - caBIG"
								value="DACB2549-3BE3-73F7-E034-0003BA12F5E7">caBIG -
								caBIG</option>

							<option title="caDSR CD - TEST"
								value="6100B969-323A-D722-E040-BB89AD436CA9">caDSR CD -
								TEST</option>

							<option title="Cancer Imaging Program - CIP"
								value="99BA9DC8-2098-4E69-E034-080020C9C0E0">Cancer
								Imaging Program - CIP</option>

							<option title="Chemotherapy Regimen - caBIG"
								value="0741B9F7-9264-25C9-E044-0003BA3F9857">
								Chemotherapy Regimen - caBIG</option>

							<option title="CHRIS TEST CD$ti - TEST"
								value="0173730A-F3F7-6807-E044-0003BA3F9857">CHRIS TEST
								CD$ti - TEST</option>

							<option title="CHRIS TEST CD8vt1k8ti - TEST"
								value="01D90A75-6ECC-6473-E044-0003BA3F9857">CHRIS TEST
								CD8vt1k8ti - TEST</option>

							<option title="CHRIS TEST CDfb7m;2mh - TEST"
								value="01735129-EED8-6340-E044-0003BA3F9857">CHRIS TEST
								CDfb7m;2mh - TEST</option>

							<option title="CHRIS TEST CDj&#34ct2d - TEST"
								value="0174A3EB-8023-38CF-E044-0003BA3F9857">CHRIS TEST
								CDj&#34ct2d - TEST</option>

							<option title="CHRIS TEST CDue*83,g8* - TEST"
								value="01D9225D-E652-672E-E044-0003BA3F9857">CHRIS TEST
								CDue*83,g8* - TEST</option>

							<option title="CHRIS TEST CDzh-/-zn - TEST"
								value="01735CC3-75FC-64F7-E044-0003BA3F9857">CHRIS TEST
								CDzh-/-zn - TEST</option>

							<option
								title="Chronic or Associated Diseases and Exposures - CTEP"
								value="B9B9249B-AB81-2F8D-E034-0003BA12F5E7">Chronic or
								Associated Diseases and Exposures - CTEP</option>

							<option title="Clinical or Research Activity - caBIG"
								value="0741AE5B-831E-25C7-E044-0003BA3F9857">Clinical
								or Research Activity - caBIG</option>

							<option title="Clinical Trials Monitoring Service - CCR"
								value="A55B8DE7-D6F4-62E7-E034-080020C9C0E0">Clinical
								Trials Monitoring Service - CCR</option>

							<option title="CONCEPTUAL ENTITIES - SPOREs"
								value="AAF2C088-4DD1-0B8B-E034-0003BA12F5E7">CONCEPTUAL
								ENTITIES - SPOREs</option>

							<option title="Conceptual Entity - caBIG"
								value="0741B16D-87D8-26CD-E044-0003BA3F9857">Conceptual
								Entity - caBIG</option>

							<option title="Concomitant Medication - CDISC"
								value="AA1591D7-FC76-D679-E040-BB89AD43495D">Concomitant
								Medication - CDISC</option>

							<option title="COPPA Generic Conceptual Domain - caBIG"
								value="5561583F-EAC1-3305-E044-0003BA3F9857">COPPA
								Generic Conceptual Domain - caBIG</option>

							<option title="CTEP - CTEP"
								value="DD27475F-2920-019C-E034-0003BA12F5E7">CTEP -
								CTEP</option>

							<option title="CTEP - CTEP"
								value="DD27475F-1964-019C-E034-0003BA12F5E7">CTEP -
								CTEP</option>

							<option title="CTEP - CTEP"
								value="DD27475F-09A8-019C-E034-0003BA12F5E7">CTEP -
								CTEP</option>

							<option title="CTEP - CTEP"
								value="99BA9DC8-2099-4E69-E034-080020C9C0E0">CTEP -
								CTEP</option>

							<option title="Culture Procedure - caBIG"
								value="63D97C89-0391-3FA7-E040-BB89AD4330F8">Culture
								Procedure - caBIG</option>

							<option title="Data Source - CTEP"
								value="BB881FE7-E125-2545-E034-0003BA12F5E7">Data
								Source - CTEP</option>

							<option title="Data Source - TEST"
								value="D922AC1A-F784-30BB-E034-0003BA12F5E7">Data
								Source - TEST</option>

							<option title="DCP Conceptual Domain - DCP"
								value="A946859C-932E-4C16-E034-0003BA12F5E7">DCP
								Conceptual Domain - DCP</option>

							<option title="DEFAULT_BULKLOADER_CD - caCORE"
								value="8B4D345F-4473-AABC-E040-BB89AD432C77">
								DEFAULT_BULKLOADER_CD - caCORE</option>

							<option title="Diagnosis - CTEP"
								value="B205508C-8324-69B0-E034-0003BA12F5E7">Diagnosis
								- CTEP</option>

							<option title="Diagnosis - TEST"
								value="DBD12DB3-8C3C-49A1-E034-0003BA12F5E7">Diagnosis
								- TEST</option>

							<option title="Diagnostic or Prognostic Factor - caBIG"
								value="0741C99A-9B70-231B-E044-0003BA3F9857">Diagnostic
								or Prognostic Factor - caBIG</option>

							<option
								title="Diagnostic, Therapeutic, and Research Equipment - caBIG"
								value="0741AE5B-831F-25C7-E044-0003BA3F9857">Diagnostic,
								Therapeutic, and Research Equipment - caBIG</option>

							<option title="Disease Occurrences - CTEP"
								value="B205508C-8323-69B0-E034-0003BA12F5E7">Disease
								Occurrences - CTEP</option>

							<option title="Disease Response - CTEP"
								value="B22C0651-216B-5273-E034-0003BA12F5E7">Disease
								Response - CTEP</option>

							<option title="Disease Response/Progression Occurrences - CTEP"
								value="B1ECEA35-BE26-349F-E034-0003BA12F5E7">Disease
								Response/Progression Occurrences - CTEP</option>

							<option title="Disease, Disorder or Finding - caBIG"
								value="0741B16D-87D9-26CD-E044-0003BA3F9857">Disease,
								Disorder or Finding - caBIG</option>

							<option title="Disease-Disorder Classification - EDRN"
								value="CAAB9A16-A8FF-455E-E034-0003BA12F5E7">
								Disease-Disorder Classification - EDRN</option>

							<option title="Drug or Chemical - caBIG"
								value="07431EBC-FB04-25D9-E044-0003BA3F9857">Drug or
								Chemical - caBIG</option>

							<option title="Drug Route of Administration - CCR"
								value="D86E246E-BBB4-0438-E034-0003BA12F5E7">Drug Route
								of Administration - CCR</option>

							<option title="Eligibility - CTEP"
								value="B1EC3968-9F25-305A-E034-0003BA12F5E7">Eligibility
								- CTEP</option>

							<option title="Experimental Organism Anatomical Concept - caBIG"
								value="07432182-1610-25E9-E044-0003BA3F9857">
								Experimental Organism Anatomical Concept - caBIG</option>

							<option title="Experimental Organism Diagnosis - caBIG"
								value="0741C99A-9B71-231B-E044-0003BA3F9857">
								Experimental Organism Diagnosis - caBIG</option>

							<option title="Findings - caCORE"
								value="C44155F4-8B24-18FB-E034-0003BA12F5E7">Findings -
								caCORE</option>

							<option title="Findings - caCORE"
								value="CFCBA97B-C908-5D7B-E034-0003BA12F5E7">Findings -
								caCORE</option>

							<option title="Formulation - DCP"
								value="CF637BA8-4A0D-4E5D-E034-0003BA12F5E7">Formulation
								- DCP</option>

							<option title="Gender - DCP"
								value="CF636062-DE60-503D-E034-0003BA12F5E7">Gender -
								DCP</option>

							<option title="Gene - caBIG"
								value="07431EBC-FB05-25D9-E044-0003BA3F9857">Gene -
								caBIG</option>

							<option title="Gene Names - caCORE"
								value="AB53B487-91EF-58B0-E034-0003BA12F5E7">Gene Names
								- caCORE</option>

							<option title="Gene Product - caBIG"
								value="0741AE5B-8320-25C7-E044-0003BA3F9857">Gene
								Product - caBIG</option>

							<option title="Genealogy and Heraldry - EDRN"
								value="CC049DE1-E97E-5FB4-E034-0003BA12F5E7">Genealogy
								and Heraldry - EDRN</option>

							<option title="Genealogy and Heraldry - SPOREs"
								value="B79B153E-8FAB-0849-E034-0003BA12F5E7">Genealogy
								and Heraldry - SPOREs</option>

							<option title="Genealogy and Heraldry - CTEP"
								value="CC19DB0F-B49C-0747-E034-0003BA12F5E7">Genealogy
								and Heraldry - CTEP</option>

							<option title="Geographic Locations - CTEP"
								value="B227ED46-D8B2-4A76-E034-0003BA12F5E7">Geographic
								Locations - CTEP</option>

							<option title="Geographic Locations - TEST"
								value="B173B5C7-1E38-59F7-E034-0003BA12F5E7">Geographic
								Locations - TEST</option>

							<option title="ICD-O-3 - CTEP"
								value="B53C231B-97A2-3794-E034-0003BA12F5E7">ICD-O-3 -
								CTEP</option>

							<option title="ICD_O_3_MORPHOLOGY_CODES - SPOREs"
								value="B0597C7B-471D-5F08-E034-0003BA12F5E7">
								ICD_O_3_MORPHOLOGY_CODES - SPOREs</option>

							<option title="ICD_O_3_TOPOLOGY - SPOREs"
								value="B114A69B-4964-3611-E034-0003BA12F5E7">
								ICD_O_3_TOPOLOGY - SPOREs</option>

							<option title="Indication - DCP"
								value="CF6290AB-CBE7-5625-E034-0003BA12F5E7">Indication
								- DCP</option>

							<option title="Individuals - CDISC"
								value="E799B454-C9F3-7079-E034-0003BA3F9857">Individuals
								- CDISC</option>

							<option title="Individuals - CTEP"
								value="B1ECD4A9-32EE-348C-E034-0003BA12F5E7">Individuals
								- CTEP</option>

							<option title="Individuals - TEST"
								value="BFEF23DF-BC80-0DFE-E034-0003BA12F5E7">Individuals
								- TEST</option>

							<option title="Individuals - EDRN"
								value="CC049DE1-E97A-5FB4-E034-0003BA12F5E7">Individuals
								- EDRN</option>

							<option title="Involvement and Extent of Disease - CTEP"
								value="B22AA815-A017-5261-E034-0003BA12F5E7">Involvement
								and Extent of Disease - CTEP</option>

							<option title="ISO21090 Data Types - caBIG"
								value="64793C86-27A4-C8B7-E040-BB89AD4337FF">ISO21090
								Data Types - caBIG</option>

							<option title="JL CD Hardware Type - TEST"
								value="D90F2E4B-6C65-6ED5-E034-0003BA12F5E7">JL CD
								Hardware Type - TEST</option>

							<option title="JL CD Hardware Type - TEST"
								value="DC2058C3-944D-47DA-E034-0003BA12F5E7">JL CD
								Hardware Type - TEST</option>

							<option title="JL CD Hardware Type - TEST"
								value="DC20604A-7A85-47A5-E034-0003BA12F5E7">JL CD
								Hardware Type - TEST</option>

							<option title="JL CD Hardware Type - TEST"
								value="DC205B0E-A178-47DC-E034-0003BA12F5E7">JL CD
								Hardware Type - TEST</option>

							<option title="JL CD Hardware Type - TEST"
								value="DC2056F7-6CAB-479A-E034-0003BA12F5E7">JL CD
								Hardware Type - TEST</option>

							<option title="JL's Conceptual Domain 001 - TEST"
								value="D7FF5259-68A9-2851-E034-0003BA12F5E7">JL's
								Conceptual Domain 001 - TEST</option>

							<option title="JL's Conceptual Domain 001 - TEST"
								value="DBCEB918-0DED-3BA7-E034-0003BA12F5E7">JL's
								Conceptual Domain 001 - TEST</option>

							<option title="Jobs - CTEP"
								value="B227CE66-2831-4A7B-E034-0003BA12F5E7">Jobs -
								CTEP</option>

							<option title="Lab Results - CTEP"
								value="B2CFBA7D-D009-7227-E034-0003BA12F5E7">Lab
								Results - CTEP</option>

							<option title="Language Code - caBIG"
								value="A9A1BB97-D437-D8DE-E040-BB89AD436AFF">Language
								Code - caBIG</option>

							<option title="LOINC Laboratory Tests - TEST"
								value="DA572C92-755E-0DEB-E034-0003BA12F5E7">LOINC
								Laboratory Tests - TEST</option>

							<option title="media - SPOREs"
								value="B79B153E-8FA3-0849-E034-0003BA12F5E7">media -
								SPOREs</option>

							<option title="Medical Imaging - CIP"
								value="F96173D7-A9B4-3CBB-E034-0003BA3F9857">Medical
								Imaging - CIP</option>

							<option title="Medical Records - TEST"
								value="B1EFB530-370B-3B7D-E034-0003BA12F5E7">Medical
								Records - TEST</option>

							<option title="Medical Records and Forms - CTEP"
								value="B2CBFF50-BB95-6B3D-E034-0003BA12F5E7">Medical
								Records and Forms - CTEP</option>

							<option title="MethodDevice - TEST"
								value="CA177BDE-FA52-6B9B-E040-BB89AD434F38">
								MethodDevice - TEST</option>

							<option title="Molecular Abnormality - caBIG"
								value="07432BB3-787B-25DB-E044-0003BA3F9857">Molecular
								Abnormality - caBIG</option>

							<option title="NCI Administrative Concept - caBIG"
								value="07432182-1611-25E9-E044-0003BA3F9857">NCI
								Administrative Concept - caBIG</option>

							<option title="Numbers - CTEP"
								value="B227CE66-2830-4A7B-E034-0003BA12F5E7">Numbers -
								CTEP</option>

							<option title="Occurrences - EDRN"
								value="CC049DE1-E96E-5FB4-E034-0003BA12F5E7">Occurrences
								- EDRN</option>

							<option title="Occurrences - CTEP"
								value="B53BD1AB-090B-398B-E034-0003BA12F5E7">Occurrences
								- CTEP</option>

							<option title="Organ Measurements - CTEP"
								value="B2290399-D743-4A70-E034-0003BA12F5E7">Organ
								Measurements - CTEP</option>

							<option title="Organism - caBIG"
								value="07432BB3-787C-25DB-E044-0003BA3F9857">Organism -
								caBIG</option>

							<option title="Outcome of Therapy - caBIG"
								value="63D982FA-DFBF-58C7-E040-BB89AD433E84">Outcome of
								Therapy - caBIG</option>

							<option title="Patient Consent - TEST"
								value="DC72DD48-3CC0-5542-E034-0003BA12F5E7">Patient
								Consent - TEST</option>

							<option title="Patient Consent - EDRN"
								value="CC049DE1-E96A-5FB4-E034-0003BA12F5E7">Patient
								Consent - EDRN</option>

							<option title="Patient Consent - TEST"
								value="FC6F5B7F-3D12-5F52-E034-0003BA3F9857">Patient
								Consent - TEST</option>

							<option title="Patient Consent - CTEP"
								value="B1ECCB2D-44A9-3496-E034-0003BA12F5E7">Patient
								Consent - CTEP</option>

							<option title="Payment Methods - CTEP"
								value="B21965EF-9A7F-25C2-E034-0003BA12F5E7">Payment
								Methods - CTEP</option>

							<option title="Person Measure/Instrument Testing - CCR"
								value="1E838B40-6636-0A25-E044-0003BA3F9857">Person
								Measure/Instrument Testing - CCR</option>

							<option title="Personal attributes - SPOREs"
								value="B7FD1513-11B0-2714-E034-0003BA12F5E7">Personal
								attributes - SPOREs</option>

							<option title="Pharmacologic Substance - caCORE"
								value="D727D9B9-FB5E-1E8C-E034-0003BA12F5E7">
								Pharmacologic Substance - caCORE</option>

							<option title="Physical Description of Individuals - EDRN"
								value="CC049DE1-E972-5FB4-E034-0003BA12F5E7">Physical
								Description of Individuals - EDRN</option>

							<option title="Physical Description of Individuals - CTEP"
								value="B241CFD7-077D-1374-E034-0003BA12F5E7">Physical
								Description of Individuals - CTEP</option>

							<option title="Procedures - CCR"
								value="D7049CF8-1252-211C-E034-0003BA12F5E7">Procedures
								- CCR</option>

							<option title="Properties or Attributes - caCORE"
								value="C4F36F0A-BEBB-047F-E034-0003BA12F5E7">Properties
								or Attributes - caCORE</option>

							<option title="Property or Attribute - caBIG"
								value="0741AE5B-8321-25C7-E044-0003BA3F9857">Property
								or Attribute - caBIG</option>

							<option title="protocol - caBIG"
								value="B03417B5-806E-1DA8-E034-0003BA12F5E7">protocol -
								caBIG</option>

							<option title="Protocol Administration - CTEP"
								value="B1ECAD41-A932-34B1-E034-0003BA12F5E7">Protocol
								Administration - CTEP</option>

							<option title="Protocol Administration - TEST"
								value="02558939-3B40-6F23-E044-0003BA3F9857">Protocol
								Administration - TEST</option>

							<option title="Protocol Administration - EDRN"
								value="CC049DE1-E966-5FB4-E034-0003BA12F5E7">Protocol
								Administration - EDRN</option>

							<option
								title="Protocol and Form Administration Occurrences - CTEP"
								value="B1ECD4A9-32ED-348C-E034-0003BA12F5E7">Protocol
								and Form Administration Occurrences - CTEP</option>

							<option title="Quality of Life - CTEP"
								value="B2BB9365-9878-4484-E034-0003BA12F5E7">Quality of
								Life - CTEP</option>

							<option title="Reproduction - CTEP"
								value="B227DAE6-EC15-4A7D-E034-0003BA12F5E7">
								Reproduction - CTEP</option>

							<option title="Research Activity - DCP"
								value="CF645D69-F09F-5EFE-E034-0003BA12F5E7">Research
								Activity - DCP</option>

							<option title="Research Organizations - CTEP"
								value="B1EC94A4-3F0A-3494-E034-0003BA12F5E7">Research
								Organizations - CTEP</option>

							<option title="Research Protocols - CTEP"
								value="B1ECC2BE-2F27-348A-E034-0003BA12F5E7">Research
								Protocols - CTEP</option>

							<option title="Response - EDRN"
								value="CAAB9A16-A8FD-455E-E034-0003BA12F5E7">Response -
								EDRN</option>

							<option title="Role - caBIG"
								value="67F34359-7D35-ED41-E040-BB89AD437390">Role -
								caBIG</option>

							<option title="Route - DCP"
								value="CF636062-DE5C-503D-E034-0003BA12F5E7">Route -
								DCP</option>

							<option title="Society of Thoracic Surgeons Procedures - caCORE"
								value="C4B58161-5027-3FED-E034-0003BA12F5E7">Society of
								Thoracic Surgeons Procedures - caCORE</option>

							<option title="Specimen Characteristics - CTEP"
								value="B22908C4-638F-4A74-E034-0003BA12F5E7">Specimen
								Characteristics - CTEP</option>

							<option title="Specimen Characteristics - EDRN"
								value="CC049DE1-E986-5FB4-E034-0003BA12F5E7">Specimen
								Characteristics - EDRN</option>

							<option title="SPOREs - SPOREs"
								value="99BA9DC8-209A-4E69-E034-080020C9C0E0">SPOREs -
								SPOREs</option>

							<option title="Surgery - caCORE"
								value="C4544CEE-36AB-275C-E034-0003BA12F5E7">Surgery -
								caCORE</option>

							<option title="Surgical Margin Measurements - CTEP"
								value="BB880E47-7AFF-254C-E034-0003BA12F5E7">Surgical
								Margin Measurements - CTEP</option>

							<option title="Symptoms - CTEP"
								value="BB883C03-CF97-2540-E034-0003BA12F5E7">Symptoms -
								CTEP</option>

							<option title="Techniques - caCORE"
								value="C4F459FF-A125-0578-E034-0003BA12F5E7">Techniques
								- caCORE</option>

							<option title="Techniques - caBIG"
								value="0741B16D-87DA-26CD-E044-0003BA3F9857">Techniques
								- caBIG</option>

							<option title="Telecommunications - CTEP"
								value="B227F4EC-BFCD-4AE2-E034-0003BA12F5E7">
								Telecommunications - CTEP</option>

							<option title="Temporal concepts - SPOREs"
								value="B7822ECE-3F17-24F5-E034-0003BA12F5E7">Temporal
								concepts - SPOREs</option>

							<option title="TEST - TEST"
								value="29A8FB19-0AB1-11D6-A42F-0010A4C1E842">TEST -
								TEST</option>

							<option title="test - caCORE"
								value="AB51DE1C-DF1D-566C-E034-0003BA12F5E7">test -
								caCORE</option>

							<option title="test - CTEP"
								value="BB0B9356-4C1D-6337-E034-0003BA12F5E7">test -
								CTEP</option>

							<option title="Test Conceptual Domain - TEST"
								value="DC735D6B-6D77-4CCD-E034-0003BA12F5E7">Test
								Conceptual Domain - TEST</option>

							<option title="TEST1 - caCORE"
								value="AB53B4A9-36B9-58B2-E034-0003BA12F5E7">TEST1 -
								caCORE</option>

							<option title="test2 - caCORE"
								value="AB53F3C9-4899-58AD-E034-0003BA12F5E7">test2 -
								caCORE</option>

							<option title="test225 - TEST"
								value="B7804955-B4BD-1C75-E034-0003BA12F5E7">test225 -
								TEST</option>

							<option title="Therapies - CTEP"
								value="B214D04D-9F05-1CA5-E034-0003BA12F5E7">Therapies
								- CTEP</option>

							<option title="Therapy Doses - CTEP"
								value="B30C55B6-50B5-1219-E034-0003BA12F5E7">Therapy
								Doses - CTEP</option>

							<option title="Therapy Doses - EDRN"
								value="CFCBA97B-C904-5D7B-E034-0003BA12F5E7">Therapy
								Doses - EDRN</option>

							<option title="Therapy Occurrences - CTEP"
								value="B21505EE-5E2D-1A7C-E034-0003BA12F5E7">Therapy
								Occurrences - CTEP</option>

							<option title="Therapy Results - CTEP"
								value="B6690D31-4081-494A-E034-0003BA12F5E7">Therapy
								Results - CTEP</option>

							<option title="Thoracic Surgical Procedures - caCORE"
								value="C4A3895E-9F60-5895-E034-0003BA12F5E7">Thoracic
								Surgical Procedures - caCORE</option>

							<option title="Tissue Banking - SPOREs"
								value="F78BDEC8-6723-436F-E034-0003BA3F9857">Tissue
								Banking - SPOREs</option>

							<option title="Treatment/Off-treatment Reasons - CTEP"
								value="B2C9BE32-8BDB-649C-E034-0003BA12F5E7">
								Treatment/Off-treatment Reasons - CTEP</option>

							<option title="Tumor Measurements - CTEP"
								value="B228CD1A-3A0C-4C11-E034-0003BA12F5E7">Tumor
								Measurements - CTEP</option>

							<option title="UML DEFAULT CD - caCORE"
								value="F5E53F3B-47A4-52D1-E034-0003BA3F9857">UML
								DEFAULT CD - caCORE</option>

							<option title="Units of Measure - CTEP"
								value="B2DECB93-42CA-248A-E034-0003BA12F5E7">Units of
								Measure - CTEP</option>

							<option title="Units of Measure - EDRN"
								value="CC049DE1-E98A-5FB4-E034-0003BA12F5E7">Units of
								Measure - EDRN</option>

							<option title="Vaccine Therapy - caBIG"
								value="6206C3D8-38E9-7329-E040-BB89AD436A24">Vaccine
								Therapy - caBIG</option>

							<option title="Vertebrates - TEST"
								value="DC2056F7-6CB3-479A-E034-0003BA12F5E7">Vertebrates
								- TEST</option>

							<option title="Vertebrates - TEST"
								value="DC206E33-EFF8-47A7-E034-0003BA12F5E7">Vertebrates
								- TEST</option>

							<option title="Vertebrates - TEST"
								value="D1094F36-0D1B-0A9E-E034-0003BA12F5E7">Vertebrates
								- TEST</option>

							<option title="Veterinary Study - CCR"
								value="0D8A0123-4971-0869-E044-0003BA3F9857">Veterinary
								Study - CCR</option>

							<option title="Vital Signs - CDISC"
								value="F86BD37F-602C-11B6-E034-0003BA3F9857">Vital
								Signs - CDISC</option>

							<option title="W3C XML Datatypes - caBIG"
								value="68125F21-8612-FFD1-E040-BB89AD4331E7">W3C XML
								Datatypes - caBIG</option>

							<option title="Yes No Indicator Value Domains - CTEP"
								value="C377DE0C-8C3E-DCA8-E040-BB89AD431B6D">Yes No
								Indicator Value Domains - CTEP</option>

							<option title="YES_NO_RESPONSES - SPOREs"
								value="A8BCE4AE-035C-22EC-E034-0003BA12F5E7">
								YES_NO_RESPONSES - SPOREs</option>

					</select>
					</td>
				</tr>

				<!-- workflow status filter for all ACs except csi, pv, vm -->

				<tr>
					<td>&nbsp;</td>
					<td style="height: 20" valign=bottom><b> Workflow Status </b>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><select name="listStatusFilter" size="3"
						style="width: 172px" multiple
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<!--store the status list as per the CONCEPT SEARCH  -->

							<option value="RELEASED">RELEASED</option>

							<option value="AllStatus" selected>All Statuses</option>
							<!--store the status list as per the search component  -->

							<option value="APPRVD FOR TRIAL USE">APPRVD FOR TRIAL
								USE</option>

							<option value="CMTE APPROVED">CMTE APPROVED</option>

							<option value="CMTE SUBMTD">CMTE SUBMTD</option>

							<option value="CMTE SUBMTD USED">CMTE SUBMTD USED</option>

							<option value="DRAFT MOD">DRAFT MOD</option>

							<option value="DRAFT NEW">DRAFT NEW</option>

							<option value="RELEASED">RELEASED</option>

							<option value="RELEASED-NON-CMPLNT">RELEASED-NON-CMPLNT</option>

							<option value="RETIRED ARCHIVED">RETIRED ARCHIVED</option>

							<option value="RETIRED DELETED">RETIRED DELETED</option>

							<option value="RETIRED PHASED OUT">RETIRED PHASED OUT</option>

							<option value="RETIRED WITHDRAWN">RETIRED WITHDRAWN</option>

					</select>
					</td>
				</tr>

				<!-- Registration status filter-->

				<tr>
					<td>&nbsp;</td>
					<td style="height: 20" valign=bottom><b> Registration
							Status </b>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><select name="listRegStatus" size="1" style="width: 172px"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="allReg" selected>All Statuses</option>

							<option value="Application">Application</option>

							<option value="Candidate">Candidate</option>

							<option value="Proposed">Proposed</option>

							<option value="Qualified">Qualified</option>

							<option value="Retired">Retired</option>

							<option value="Standard">Standard</option>

							<option value="Standardized Elsewhere">Standardized
								Elsewhere</option>

							<option value="Superceded">Superceded</option>

							<option value="Suspended">Suspended</option>

					</select>
					</td>
				</tr>

				<!-- Registration status filter-->


				<!-- created date filter-->


				<!--display attributes -->
				<tr>
					<td height="7" colspan=2 valign="top">
				</tr>
				<tr>
					<td class="dashed-black" colspan=2>
						<div align="left">
							<b> 5 )&nbsp;&nbsp;Display Attributes: </b> &nbsp;<input
								type="button" name="updateDisplayBtn" value="Update"
								onClick="displayAttributes('true');"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">
						</div> <br>
						<div align="right" valign="bottom">
							<select name="listAttrFilter" size="4" style="width: 175px"
								multiple valign="bottom"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">

								<option value="Long Name" selected>Long Name</option>

								<option value="Public ID" selected>Public ID</option>

								<option value="Version" selected>Version</option>

								<option value="Workflow Status" selected>Workflow
									Status</option>

								<option value="EVS Identifier" selected>EVS Identifier</option>

								<option value="Conceptual Domain" selected>Conceptual
									Domain</option>

								<option value="Definition" selected>Definition</option>

								<option value="All Attributes">All Attributes</option>

							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td height="35" valign="bottom" colspan="2">
						<div align="left">
							Results Displayed: <select name="recordsDisplayed" size="1"
								style="width: 160">

								<option value="500">500</option>
								<option value="1000" selected>1000</option>
								<option value="0">All</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td height="35" valign="bottom" colspan=2>
						<div align="center">
							<input type="button" name="startSearchBtn" value="Start Search"
								onClick="doSearchDE();"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						</div>
					</td>
				</tr>
			</table>
			<select size="1" name="hidListAttr"
				style="visibility: hidden; width: 150px">

				<option value="Long Name">Long Name</option>

				<option value="Public ID">Public ID</option>

				<option value="Version">Version</option>

				<option value="Workflow Status">Workflow Status</option>

				<option value="EVS Identifier">EVS Identifier</option>

				<option value="Conceptual Domain">Conceptual Domain</option>

				<option value="Definition">Definition</option>

			</select> <input type="hidden" name="actSelect" value="Search"> <input
				type="hidden" name="QCValueIDseq" value=""> <input
				type="hidden" name="QCValueName" value=""> <input
				type="hidden" name="CDVDContext" value="same"> <input
				type="hidden" name="selCDID" value=""> <input type="hidden"
				name="serMenuAct" value="searchForCreate"> <input
				type="hidden" name="outPrint" value="Print"
				style="visibility: hidden;"8
>
	</div>
</div>
<div id="col3">
	<div id="col3_content" class="clearfix">
		<form name="searchResultsForm" method="post"
			action="../../cdecurate/NCICurationServlet?reqType=showResult">
			<table width="100%" border="0" valign="top">
				<tr>
					<td height="7">
				</tr>
				<tr height="20" valign="top">

					<td align="left"><s:url id="selectedVmResultUrl"
							action="selectedVmResult" /> <sj:a id="selectedVmAnchor"
							indicator="indicator2" href="%{selectedVmResultUrl}"
							targets="selectedVmResultDiv" listenTopics="selectedVmResultDiv"
							button="true" buttonIcon="ui-icon-gear"
							onCompleteTopics="closeThisDialog">Link Concept</sj:a> <!-- searchForCreate -->
						<%--<input type="button"
						name="editSelectedBtn" value="Use Selection"
						onClick="closeVmSearch();"> --%> &nbsp; <!-- makes close button only if page opened from createDE or VD pages   -->
					</td>
				</tr>
			</table>
			<table width="100%" valign="top">
				<tr>
					<td height="7">
				</tr>
				<tr>
					<td><font size="4"> <b> Search Results for Value
								Meaning : lung </b> </font>
					</td>
				</tr>
				<tr>
					<td><font size="2"> &nbsp; 2 Records Found </font>
					</td>
				</tr>
				<tr>
					<td height="7">
				</tr>
			</table>
			<table width="100%" border="1" valign="top">
				<tr valign="middle">

					<th height="30"><img src="images/CheckBox.gif" border="0"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</th>


					<!-- adds Review status only if questions -->

					<!-- add other headings -->

					<th method="get"><a href="javascript:SetSortType('longName')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">

							Long Name </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('minID')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Public_ID </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('version')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Version </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('Status')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Workflow Status </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('umls')"
						onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							EVS Identifier </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('ConDomain')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Conceptual Domain </a>
					</th>

					<th method="get"><a href="javascript:SetSortType('def')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition </a>
					</th>

				</tr>

				<tr>
					<td width="5"><input type="checkbox" name="CK0"
						onClick="javascript:EnableButtons(checked,this);"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>

					<td width="150">Lung</td>

					<td>2873883</td>

					<td>1.0</td>

					<td>RELEASED</td>

					<td>C12468</td>

					<td>Adverse Event Results... <a
						href="javascript:openConDomainWindow('Lung')"><br> <b>More_>></b>
					</a>
					</td>

					<td>One of a pair of viscera occupying the pulmonary cavities
						of the thorax, the organs of respiration in which aeration of the
						blood takes place. As a rule, the right lung is slightly larger
						than the left and is divided into three lobes (an upper, a middle,
						and a lower or basal), while the left has but two lobes (an upper
						and a lower or basal). Each lung is irregularly conical in shape,
						presenting a blunt upper extremity (the apex), a concave base
						following the curve of the diaphragm, an outer convex surface
						(costal surface), an inner or mediastinal surface (mediastinal
						surface), a thin and sharp anterior border, and a thick and
						rounded posterior border. SYN pulmo.</td>

					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
				</tr>

				<tr>
					<td width="5"><input type="checkbox" name="CK1"
						onClick="javascript:EnableButtons(checked,this);"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>

					<td width="150">Lung</td>

					<td>2567244</td>

					<td>1.0</td>

					<td>RELEASED</td>

					<td>C12468</td>

					<td>Adverse Event Results... <a
						href="javascript:openConDomainWindow('Lung')"><br> <b>More_>></b>
					</a>
					</td>

					<td>One of a pair of viscera occupying the pulmonary cavities
						of the thorax, the organs of respiration in which aeration of the
						blood takes place. As a rule, the right lung is slightly larger
						than the left and is divided into three lobes (an upper, a middle,
						and a lower or basal), while the left has but two lobes (an upper
						and a lower or basal). Each lung is irregularly conical in shape,
						presenting a blunt upper extremity (the apex), a concave base
						following the curve of the diaphragm, an outer convex surface
						(costal surface), an inner or mediastinal surface (mediastinal
						surface), a thin and sharp anterior border, and a thick and
						rounded posterior border.</td>

					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
				</tr>

			</table>
			<table>
				<input type="hidden" name="pageAction" value="nothing">
				<input type="hidden" name="AttChecked" value="2">
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
				<input type="hidden" name="isValid" value="false">
				<input type="hidden" name="serMenuAct" value="searchForCreate" />
				<input type="hidden" name="serRecCount" value="2">
				<input type="hidden" name="selRowID" value="">
				<!-- stores Designation Name and ID -->
				<select size="1" name="hiddenDesIDName" style="visibility:hidden;"
					multiple>
				</select>
				<!-- stores selected component ID and workflow status -->
				<select size="1" name="hiddenACIDStatus" style="visibility:hidden;"
					multiple>
				</select>

				<!-- stores results ID and Short Names -->
				<select size="1" name="hiddenSearch"
					style="visibility:hidden;width:50">

					<option value="696BC0F5-5D13-4222-E040-BB89AD4378C7">Lung
					</option>

					<option value="2509CE87-D3B9-5C23-E044-0003BA3F9857">Lung
					</option>

				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName" style="visibility:hidden;">

				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName2"
					style="visibility:hidden;width:100;">


					<option value="Lung">Lung</option>

					<option value="Lung">Lung</option>

				</select>
				<!-- store definition and context here to use it later in javascript -->
				<select size="1" name="hiddenDefSource"
					style="visibility:hidden;width:100">

					<option value="(TBD context name)">One of a pair of
						viscera occupying the pulmonary cavities of the thorax, the organs
						of respiration in which aeration of the blood takes place. As a
						rule, the right lung is slightly larger than the left and is
						divided into three lobes (an upper, a middle, and a lower or
						basal), while the left has but two lobes (an upper and a lower or
						basal). Each lung is irregularly conical in shape, presenting a
						blunt upper extremity (the apex), a concave base following the
						curve of the diaphragm, an outer convex surface (costal surface),
						an inner or mediastinal surface (mediastinal surface), a thin and
						sharp anterior border, and a thick and rounded posterior border.
						SYN pulmo.</option>

					<option value="(TBD context name)">One of a pair of
						viscera occupying the pulmonary cavities of the thorax, the organs
						of respiration in which aeration of the blood takes place. As a
						rule, the right lung is slightly larger than the left and is
						divided into three lobes (an upper, a middle, and a lower or
						basal), while the left has but two lobes (an upper and a lower or
						basal). Each lung is irregularly conical in shape, presenting a
						blunt upper extremity (the apex), a concave base following the
						curve of the diaphragm, an outer convex surface (costal surface),
						an inner or mediastinal surface (mediastinal surface), a thin and
						sharp anterior border, and a thick and rounded posterior border.</option>

				</select>
				<select size="1" name="hiddenMeanDescription"
					style="visibility:hidden;width:100">

				</select>
				<select size="1" name="hiddenPVValue" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMean" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMeanDesc" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenSelectedRow" style="visibility:hidden;">
				</select>
			</table>
			<!-- div for associated AC popup menu -->
			<div id="divAssACMenu"
				style="position:absolute;z-index:1;visibility:hidden;width:175px;">
				<table border="3" cellspacing="0" cellpadding="0">
					<tr>
						<td class="menu" id="assDE"><a
							href="javascript:getAssocDEs();"
							onmouseover="changecolor('assDE',oncolor)"
							onmouseout="changecolor('assDE',offcolor);closeall()"> Data
								Elements </a>
						</td>
					</tr>

					<tr>
						<td class="menu" id="assVD"><a
							href="javascript:getAssocVDs();"
							onmouseover="changecolor('assVD',oncolor)"
							onmouseout="changecolor('assVD',offcolor);closeall()"> Value
								Domains </a>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="acID" value=""> <input
				type="hidden" name="ac2ID" value=""> <input type="hidden"
				name="itemType" value=""> <input type="hidden"
				name="isValidSearch" value="false"> <input type="hidden"
				name="searchComp" value=""> <input type="hidden"
				name="SelContext" value=""> <input type="hidden"
				name="editPVInd" value=""> <input type="hidden"
				name="pageAction" value="nothing">
		</form>
	</div>
</div>