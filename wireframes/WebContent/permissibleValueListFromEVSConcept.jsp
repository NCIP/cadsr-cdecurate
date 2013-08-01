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
						size="22" style="width: 160" value="Lung"
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
					<td><s:url id="pvTableUrl" action="addPv" /> <sj:a
							id="addPvButton" href="%{pvTableUrl}" targets="existingPVs"
							listenTopics="existingPVs" button="true"
							buttonIcon="ui-icon-gear" onCompleteTopics="closeDialog">Link Concept</sj:a>
						<%--<input type="button" name="editSelectedBtn"
						value="Use Selection" onClick="ShowSelection();" disabled>
						&nbsp;&nbsp;--%> <input type="button" name="btnSubConcepts"
						value="Get Subconcepts"
						onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)"
						onmouseout="closeall()" disabled> &nbsp;&nbsp; <input
						type="button" name="btnSuperConcepts" value="Get Superconcepts"
						disabled onclick="javascript:getSuperConcepts();">
						&nbsp;&nbsp; <input type="button" name="btnSubmitToEVS"
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
								Meaning - lung </b> </font></td>
				</tr>

				<tr>
					<td><font size="2"> &nbsp; 7 Records Found </font></td>
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

					<td width="150px" valign="top">Lung <br></td>


					<td valign="top">2202738</td>

					<td valign="top">C12468</td>

					<td valign="top">One of a pair of viscera occupying the
						pulmonary cavities of the thorax, the organs of respiration in
						which aeration of the blood takes place. As a rule, the right lung
						is slightly larger than the left and is divided into three lobes
						(an upper, a middle, and a lower or basal), while the left has but
						two lobes (an upper and a lower or basal). Each lung is
						irregularly conical in shape, presenting a blunt upper extremity
						(the apex), a concave base following the curve of the diaphragm,
						an outer convex surface (costal surface), an inner or mediastinal
						surface (mediastinal surface), a thin and sharp anterior border,
						and a thick and rounded posterior border.</td>

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
						href="javascript:showConceptInTree('CK1');"> Lung </a> <br></td>


					<td valign="top"></td>

					<td valign="top">C12468</td>

					<td valign="top">One of a pair of viscera occupying the
						pulmonary cavities of the thorax, the organs of respiration in
						which aeration of the blood takes place. As a rule, the right lung
						is slightly larger than the left and is divided into three lobes
						(an upper, a middle, and a lower or basal), while the left has two
						lobes (an upper and a lower or basal). Each lung is irregularly
						conical in shape, presenting a blunt upper extremity (the apex), a
						concave base following the curve of the diaphragm, an outer convex
						surface (costal surface), an inner or mediastinal surface
						(mediastinal surface), a thin and sharp anterior border, and a
						thick and rounded posterior border.</td>

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
						href="javascript:showConceptInTree('CK2');"> Lung </a> <br></td>


					<td valign="top"></td>

					<td valign="top">C12468</td>

					<td valign="top">One of a pair of organs in the chest that
						supplies the body with oxygen, and removes carbon dioxide from the
						body.</td>

					<td valign="top">NCI-GLOSS</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK3"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK3');"> Lung </a> <br></td>


					<td valign="top"></td>

					<td valign="top">C12468</td>

					<td valign="top">One of a pair of viscera occupying the
						pulmonary cavities of the thorax, the organs of respiration in
						which aeration of the blood takes place. As a rule, the right lung
						is slightly larger than the left and is divided into three lobes
						(an upper, a middle, and a lower or basal), while the left has two
						lobes (an upper and a lower or basal). Each lung is irregularly
						conical in shape, presenting a blunt upper extremity (the apex), a
						concave base following the curve of the diaphragm, an outer convex
						surface (costal surface), an inner or mediastinal surface
						(mediastinal surface), a thin and sharp anterior border, and a
						thick and rounded posterior border. (NCI)</td>

					<td valign="top">CDISC</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK4"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK4');"> Mouse Lung </a> <br>

					</td>


					<td valign="top"></td>

					<td valign="top">C22600</td>

					<td valign="top">No Value Exists</td>

					<td valign="top"></td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK5"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK5');"> Lung Tissue </a> <br>

					</td>


					<td valign="top"></td>

					<td valign="top">C33024</td>

					<td valign="top">Tissue consisting of an external serous coat,
						subserous areolar tissue and lung parenchyma. The parenchyma is
						made up of lobules wound together by connective tissue. A primary
						lobule consists of a terminal bronchiole, respiratory bronchioles,
						and alveolar ducts, which communicate with many alveoli, each
						alveolus being surrounded by a network of capillary blood vessels.
					</td>

					<td valign="top">NCI</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>

				<tr>
					<td width="5px" valign="top"><input type="checkbox" name="CK6"
						onClick="javascript:EnableButtons(checked,this);"></td>
					<td width="150px" valign="top"><a
						href="javascript:showConceptInTree('CK6');"> Lung Tissue </a> <br>

					</td>


					<td valign="top"></td>

					<td valign="top">C33024</td>

					<td valign="top">Tissue consisting of an external serous coat,
						subserous areolar tissue and lung parenchyma. The parenchyma is
						made up of lobules wound together by connective tissue. A primary
						lobule consists of a terminal bronchiole, respiratory bronchioles,
						and alveolar ducts, which communicate with many alveoli, each
						alveolus being surrounded by a network of capillary blood vessels.
						(NCI)</td>

					<td valign="top">CDISC</td>

					<td valign="top">Active</td>

					<td valign="top"></td>

					<td valign="top"></td>

					<td valign="top">NCI Thesaurus</td>

					<td valign="top"></td>

				</tr>


			</table>
			<div style="display:none">
				<input type="hidden" name="AttChecked" value="5"> <input
					type="hidden" name="searchComp" value=""> <input
					type="hidden" name="openToTree" value=""> <input
					type="hidden" name="selectedParentConceptCode" value=""> <input
					type="hidden" name="selectedParentConceptName" value=""> <input
					type="hidden" name="selectedParentConceptDB" value=""> <input
					type="hidden" name="selectedParentConceptMetaSource" value="">
				<input type="hidden" name="OCCCode" value=""> <input
					type="hidden" name="OCCCodeDB" value=""> <input
					type="hidden" name="OCCCodeName" value=""> <input
					type="hidden" name="numSelected" value=""> <input
					type="hidden" name="actSelected" value="Search"> <input
					type="hidden" name="numAttSelected" value=""> <input
					type="hidden" name="blockSortType" value="nothing"> <input
					type="hidden" name="UISearchType" value="term"> <input
					type="hidden" name="selRowID" value=""> <input
					type="hidden" name="editPVInd" value=""> <select size="1"
					name="hiddenPVValue" style="visibility:hidden;"></select> <select
					size="1" name="hiddenPVMean" style="visibility:hidden;"></select> <select
					size="1" name="hiddenResults" style="visibility:hidden;width:145px">

					<option value="Lung">Lung</option>

					<option value="2202738">2202738</option>

					<option value="C12468">C12468</option>

					<option
						value="One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border.">
						One of a pair of viscera occupying the pulmonary cavities of the
						thorax, the organs of respiration in which aeration of the blood
						takes place. As a rule, the right lung is slightly larger than the
						left and is divided into three lobes (an upper, a middle, and a
						lower or basal), while the left has but two lobes (an upper and a
						lower or basal). Each lung is irregularly conical in shape,
						presenting a blunt upper extremity (the apex), a concave base
						following the curve of the diaphragm, an outer convex surface
						(costal surface), an inner or mediastinal surface (mediastinal
						surface), a thin and sharp anterior border, and a thick and
						rounded posterior border.</option>

					<option value="NCI">NCI</option>

					<option value="RELEASED">RELEASED</option>

					<option value="null">null</option>

					<option value="NCIP">NCIP</option>

					<option value="caDSR">caDSR</option>

					<option value="Concept Class">Concept Class</option>

					<option value="Lung">Lung</option>

					<option value="null">null</option>

					<option value="C12468">C12468</option>

					<option
						value="One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border.">
						One of a pair of viscera occupying the pulmonary cavities of the
						thorax, the organs of respiration in which aeration of the blood
						takes place. As a rule, the right lung is slightly larger than the
						left and is divided into three lobes (an upper, a middle, and a
						lower or basal), while the left has two lobes (an upper and a
						lower or basal). Each lung is irregularly conical in shape,
						presenting a blunt upper extremity (the apex), a concave base
						following the curve of the diaphragm, an outer convex surface
						(costal surface), an inner or mediastinal surface (mediastinal
						surface), a thin and sharp anterior border, and a thick and
						rounded posterior border.</option>

					<option value="NCI">NCI</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Lung">Lung</option>

					<option value="null">null</option>

					<option value="C12468">C12468</option>

					<option
						value="One of a pair of organs in the chest that supplies the body with oxygen, and removes carbon dioxide from the body.">
						One of a pair of organs in the chest that supplies the body with
						oxygen, and removes carbon dioxide from the body.</option>

					<option value="NCI-GLOSS">NCI-GLOSS</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Lung">Lung</option>

					<option value="null">null</option>

					<option value="C12468">C12468</option>

					<option
						value="One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. (NCI)">
						One of a pair of viscera occupying the pulmonary cavities of the
						thorax, the organs of respiration in which aeration of the blood
						takes place. As a rule, the right lung is slightly larger than the
						left and is divided into three lobes (an upper, a middle, and a
						lower or basal), while the left has two lobes (an upper and a
						lower or basal). Each lung is irregularly conical in shape,
						presenting a blunt upper extremity (the apex), a concave base
						following the curve of the diaphragm, an outer convex surface
						(costal surface), an inner or mediastinal surface (mediastinal
						surface), a thin and sharp anterior border, and a thick and
						rounded posterior border. (NCI)</option>

					<option value="CDISC">CDISC</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Mouse Lung">Mouse Lung</option>

					<option value="null">null</option>

					<option value="C22600">C22600</option>

					<option value="No Value Exists">No Value Exists</option>

					<option value=""></option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Lung Tissue">Lung Tissue</option>

					<option value="null">null</option>

					<option value="C33024">C33024</option>

					<option
						value="Tissue consisting of an external serous coat, subserous areolar tissue and lung parenchyma. The parenchyma is made up of lobules wound together by connective tissue. A primary lobule consists of a terminal bronchiole, respiratory bronchioles, and alveolar ducts, which communicate with many alveoli, each alveolus being surrounded by a network of capillary blood vessels.">
						Tissue consisting of an external serous coat, subserous areolar
						tissue and lung parenchyma. The parenchyma is made up of lobules
						wound together by connective tissue. A primary lobule consists of
						a terminal bronchiole, respiratory bronchioles, and alveolar
						ducts, which communicate with many alveoli, each alveolus being
						surrounded by a network of capillary blood vessels.</option>

					<option value="NCI">NCI</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Lung Tissue">Lung Tissue</option>

					<option value="null">null</option>

					<option value="C33024">C33024</option>

					<option
						value="Tissue consisting of an external serous coat, subserous areolar tissue and lung parenchyma. The parenchyma is made up of lobules wound together by connective tissue. A primary lobule consists of a terminal bronchiole, respiratory bronchioles, and alveolar ducts, which communicate with many alveoli, each alveolus being surrounded by a network of capillary blood vessels. (NCI)">
						Tissue consisting of an external serous coat, subserous areolar
						tissue and lung parenchyma. The parenchyma is made up of lobules
						wound together by connective tissue. A primary lobule consists of
						a terminal bronchiole, respiratory bronchioles, and alveolar
						ducts, which communicate with many alveoli, each alveolus being
						surrounded by a network of capillary blood vessels. (NCI)</option>

					<option value="CDISC">CDISC</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

				</select> <select size="1" name="hiddenSelectedRow"
					style="visibility:hidden;">
				</select>
			</div>
			<div id="divAssACMenu"
				style="position:absolute;z-index:1;visibility:hidden;width:185px;">
				<table id="tblAssACMenu" border="3" cellspacing="0" cellpadding="0">
					<tr>
						<td class="menu" id="assDE"><a
							href="javascript:getSubConceptsAll();"
							onmouseover="changecolor('assDE',oncolor)"
							onmouseout="changecolor('assDE',offcolor);closeall()"> All
								Subconcepts </a></td>
					</tr>
					<tr>
						<td class="menu" id="assDEC"><a
							href="javascript:getSubConceptsImmediate();"
							onmouseover="changecolor('assDEC',oncolor)"
							onmouseout="changecolor('assDEC',offcolor);closeall()">
								Immediate Subconcepts </a></td>
					</tr>
				</table>
			</div>
			<div id="divAssACMenu"
				style="position:absolute;z-index:1;visibility:hidden;width:185px;">
				<table id="tblAssACMenu" border="3" cellspacing="0" cellpadding="0">
					<tr>
						<td class="menu" id="assDE"><a
							href="javascript:getSubConceptsAll();"
							onmouseover="changecolor('assDE',oncolor)"
							onmouseout="changecolor('assDE',offcolor);closeall()"> All
								Subconcepts </a>
						</td>
					</tr>
					<tr>
						<td class="menu" id="assDEC"><a
							href="javascript:getSubConceptsImmediate();"
							onmouseover="changecolor('assDEC',oncolor)"
							onmouseout="changecolor('assDEC',offcolor);closeall()">
								Immediate Subconcepts </a>
						</td>
					</tr>
				</table>
			</div>

		</form>
	</div>
</div>