<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<div id="col1">
	<div id="col1_content" class="clearfix">

		<form name="searchParmsForm" method="post"
			action="../../cdecurate/NCICurationServlet?reqType=searchBlocks">
			<table width="100%" class="sidebarBGColor">
				<!-- style="position: relative; top: -22px;"> -->
				<tr valign="top" align="left" class="firstRow">
					<th>1 ) Search For:</th>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp; <select name="listSearchFor"
						size="1" style="width: 160"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
							<option value="VMConcept">Concept</option>
					</select>
					</td>
				</tr>

				<tr valign="bottom" align="left" class="firstRow" height="22">
					<th>2 ) Select EVS Vocabulary:</th>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp; <select
						name="listContextFilterVocab" size="1" style="width: 160"
						onChange="doVocabChange();"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">

							<option value="NCI Thesaurus" selected>NCI Thesaurus</option>

							<option value="Common Terminology Criteria for Adverse Events">
								CTCAE</option>

							<option value="Gene Ontology">GO</option>

							<option value="HL7 Reference Information Model">HL7</option>

							<option
								value="International Classification of Diseases, Ninth Revision, Clinical Modification">
								ICD-9-CM</option>

							<option value="ICD-10">ICD-10_</option>

							<option
								value="International Classification of Diseases, 10th Edition, Clinical Modification">
								ICD-10-CM</option>

							<option value="Logical Observation Identifier Names and Codes">
								LOINC</option>

							<option
								value="MedDRA (Medical Dictionary for Regulatory Activities Terminology)">
								MedDRA</option>

							<option value="The MGED Ontology">MGED</option>

							<option value="NCI Metathesaurus">NCI Metathesaurus</option>

							<option value="Nanoparticle Ontology">NPO</option>

							<option value="Ontology for Biomedical Investigations">
								OBI</option>

							<option value="Radiology Lexicon">RadLex</option>

							<option value="SNOMED Clinical Terms">SNOMED</option>

							<option value="UMLS Semantic Network">UMLS SemNet</option>

							<option value="National Drug File - Reference Terminology">
								VA_NDFRT</option>

							<option value="Zebrafish">Zebrafish</option>

					</select>
					</td>
				</tr>
				<tr>
					<th height="22" valign="bottom">
						<div align="left">
							3 ) Search In:
							<!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->
						</div>
					</th>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> caDSR </b>
					</td>
				</tr>
				<tr>
					<td>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp; <select name="listSearchIn" size="1"
								style="width: 170" onChange="populateEVSSearchIn();"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
								<option value="longName" selected>Names and Definition
								</option>
								<option value="publicID">Public ID</option>
								<option value="evsIdentifier">EVS Identifier</option>
								<option value="Code">None</option>
							</select>
						</p>
					</td>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> EVS </b>

						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <a
						href="javascript:searchType('tree');"> Tree Search </a>
					</td>
				</tr>
				<tr>
					<td>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp; <select name="listSearchInEVS" size="1"
								style="width: 170" onChange="populateCaDSRSearchIn();"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">

								<option value="Name" selected>Synonym</option>

								<option value="ConCode">Concept Code</option>

							</select>
						</p>
					</td>
				</tr>

				<tr>
					<th height="22" valign="bottom">
						<div align="left">4 ) Enter Search Term:</div>
					</th>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="text" name="keyword"
						size="22" style="width: 160" value="Leg"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
					</td>
				</tr>
				<tr>
					<td>
						<div align="left"
							title="The wildcard character, *, expands the search to find a non-exact match.">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;use * as wildcard</div>
					</td>
				</tr>
				<tr>
					<th height="22" valign="bottom">
						<div align="left">5 ) Filter Search By:</div>
					</th>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> caDSR </b>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Owned By/Used By</td>
				</tr>
				<tr>
					<td>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp; <select name="listContextFilter"
								size="1" style="width: 160"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">

								<option value="All (No Test/Train)" selected>All (No
									Test/Train)</option>
								<option value="AllContext">All Contexts</option>

								<option value="ACRIN">ACRIN</option>

								<option value="BRIDG">BRIDG</option>

								<option value="NCIP">NCIP</option>

								<option value="caBIG CDE Data Standards">caBIG CDE Data
									Standards</option>

								<option value="caCORE">caCORE</option>

								<option value="CCR">CCR</option>

								<option value="CDC/PHIN">CDC/PHIN</option>

								<option value="CDISC">CDISC</option>

								<option value="CIP">CIP</option>

								<option value="CTEP">CTEP</option>

								<option value="DCP">DCP</option>

								<option value="EDRN">EDRN</option>

								<option value="HITSP">HITSP</option>

								<option value="NCRI">NCRI</option>

								<option value="NHLBI">NHLBI</option>

								<option value="NHS England">NHS England</option>

								<option value="NICHD">NICHD</option>

								<option value="NIDA">NIDA</option>

								<option value="NIDCR">NIDCR</option>

								<option value="NINDS">NINDS</option>

								<option value="PS&CC">PS&CC</option>

								<option value="SPOREs">SPOREs</option>

								<option value="TEST">TEST</option>

								<option value="Training">Training</option>

							</select>
						</p>
					</td>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Workflow Status</td>
				</tr>
				<tr>
					<td>
						<p>
							&nbsp;&nbsp;&nbsp;&nbsp; <select name="listStatusFilter" multiple
								size="2" style="width: 160"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
								<option value="RELEASED" selected>RELEASED</option>
								<option value="AllStatus">All Statuses</option>
							</select>
						</p>
					</td>
				</tr>


				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> EVS </b>
					</td>
				</tr>

				<tr>
					<td style="height: 20" valign=bottom>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Retired Concepts</td>
				</tr>
				<tr>
					<td align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <input
						type="radio" name="rRetired" value="Exclude" checked
						onHelp="showHelp('Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Exclude&nbsp; <input type="radio" name="rRetired" value="Include"
						onHelp="showHelp('Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Include&nbsp;</td>
				</tr>



				<tr height="5"></tr>
				<tr>
					<td class="dashed-black">
						<div align="left">
							<b> 6 ) Display Attributes: </b> &nbsp;&nbsp; <input
								type="button" name="updateDisplayBtn" value="Update"
								onClick="displayAttributes('true');"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">
						</div> <br>
						<div align="center">
							<select name="listAttrFilter" size="5" style="width: 160"
								multiple
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">

								<option value="Concept Name" selected>Concept Name</option>

								<option value="Public ID" selected>Public ID</option>

								<option value="Version">Version</option>

								<option value="EVS Identifier" selected>EVS Identifier
								</option>

								<option value="Definition" selected>Definition</option>

								<option value="Definition Source" selected>Definition
									Source</option>

								<option value="Workflow Status" selected>Workflow
									Status</option>

								<option value="Semantic Type" selected>Semantic Type</option>

								<option value="Context" selected>Context</option>

								<option value="Vocabulary" selected>Vocabulary</option>

								<option value="caDSR Component" selected>caDSR
									Component</option>

								<option value="All Attributes">All Attributes</option>

							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td height="33" valign="bottom">
						<div align="center">
							<input type="button" name="startSearchBtn" value="Start Search"
								onClick="doSearchBuildingBlocks();"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
						</div>
					</td>
				</tr>


				<tr>
					<td><input type="hidden" name="actSelect" value="Search"
						style="visibility: hidden;"> <input type="hidden"
						name="vmConOrder" value="0"> <input type="hidden"
						name="sCCodeDB" value=""> <input type="hidden"
						name="sCCode" value=""> <input type="hidden"
						name="sCCodeName" value=""> <input type="hidden"
						name="openToTree" value=""> <input type="hidden"
						name="sConteIdseq" value=""> <input type="hidden"
						name="nonEVSRepTermSearch" value=""> <input type="hidden"
						name="conid" value="">
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<div id="col3">
	<div id="col3_content" class="clearfix">
		<form name="searchResultsForm" method="post"
			action="../../cdecurate/NCICurationServlet?reqType=doSortBlocks">
			<br>
			<table border="0">
				<tr align="left">
					<td><s:url id="editedVmUrl" action="editedVm" /> <sj:a
							id="selectedVmEVSAnchorEditVm" indicator="indicator2"
							href="%{editedVmUrl}" targets="vmInfoDiv" button="true"
							buttonIcon="ui-icon-gear">Link Concept</sj:a> <input
						type="button" name="btnSubConcepts" value="Get Subconcepts"
						onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)"
						onmouseout="closeall()" disabled> &nbsp;&nbsp; <input
						type="button" name="btnSuperConcepts" value="Get Superconcepts"
						disabled onclick="javascript:getSuperConcepts();">
						&nbsp;&nbsp;<input type="button" name="btnSubmitToEVS"
						value="Suggest to EVS" onclick="javascript:NewTermSuggested();">
						&nbsp;&nbsp; <img name="Message" src="images/SearchMessage.gif"
						width="180px" height="25" alt="WaitMessage"
						style="visibility:hidden;" align="top">
					</td>
				</tr>
			</table>
			<br>
			<table width="100%" valign="top">

				<tr>
					<td><font size="4"> <b> Search Results for Value
								Meaning - leg </b> </font></td>
				</tr>

				<tr>
					<td><font size="2"> &nbsp; 3 Records Found </font></td>
				</tr>
			</table>
			<table width="100%" border="1" valign="top">
				<tr valign="middle">

					<th height="30px" width="30px"><img src="images/CheckBox.gif"
						border="0"></th>


					<th method="get"><a href="javascript:SetSortType('name')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Concept Name </a></th>

					<th method="get"><a href="javascript:SetSortType('publicID')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Public_ID </a></th>

					<th method="get"><a href="javascript:SetSortType('umls')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							EVS Identifier </a></th>

					<th method="get"><a href="javascript:SetSortType('def')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition </a></th>

					<th method="get"><a href="javascript:SetSortType('source')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition Source </a></th>

					<th method="get"><a href="javascript:SetSortType('asl')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Workflow Status </a></th>

					<th method="get"><a href="javascript:SetSortType('semantic')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Semantic Type </a></th>

					<th method="get"><a href="javascript:SetSortType('context')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Context </a></th>

					<th method="get"><a href="javascript:SetSortType('db')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Vocabulary </a></th>

					<th method="get"><a href="javascript:SetSortType('cadsrComp')"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							caDSR Component </a></th>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK0"
						onClick="javascript:EnableButtons(checked,this);"></td>

					<td width="150px" valign="top">Leg <br></td>


					<td valign="top">2516717</td>

					<td valign="top">C32974</td>

					<td valign="top">Commonly used to refer to the whole lower
						limb but technically only the part between the knee and ankle.</td>

					<td valign="top">NCI</td>

					<td valign="top">RELEASED</td>

					<td valign="top"></td>

					<td valign="top">NCIP</td>

					<td valign="top">caDSR</td>

					<td valign="top">Concept Class</td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK1"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK1');"> Leg </a> <br></td>


					<td valign="top"></td>

					<td valign="top">C32974</td>

					<td valign="top">One of the two lower extremities in humans
						used for locomotion and support.</td>

					<td valign="top">NCI</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK2"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK2');"> Leg </a> <br></td>


					<td valign="top"></td>

					<td valign="top">C32974</td>

					<td valign="top">One of the two lower extremities in humans
						used for locomotion and support. (NCI)</td>

					<td valign="top">CDISC</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>


			</table>
		</form>
	</div>
</div>