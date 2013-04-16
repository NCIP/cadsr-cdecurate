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
					</select></td>
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

					</select></td>
				</tr>
				<tr>
					<th height="22" valign="bottom">
						<div align="left">
							3 ) Search In:
							<!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->
						</div></th>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> caDSR </b></td>
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
						</p></td>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> EVS </b>

						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <a
						href="javascript:searchType('tree');"> Tree Search </a></td>
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
						</p></td>
				</tr>

				<tr>
					<th height="22" valign="bottom">
						<div align="left">4 ) Enter Search Term:</div></th>
				</tr>
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="text" name="keyword"
						size="22" style="width: 160" value="Bone Marrow"
						onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
					</td>
				</tr>
				<tr>
					<td>
						<div align="left"
							title="The wildcard character, *, expands the search to find a non-exact match.">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;use * as wildcard</div></td>
				</tr>
				<tr>
					<th height="22" valign="bottom">
						<div align="left">5 ) Filter Search By:</div></th>
				</tr>

				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> caDSR </b></td>
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

								<option value="caBIG">caBIG</option>

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
						</p></td>
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
						</p></td>
				</tr>


				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <b> EVS </b></td>
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
						</div></td>
				</tr>
				<tr>
					<td height="33" valign="bottom">
						<div align="center">
							<input type="button" name="startSearchBtn" value="Start Search"
								onClick="doSearchBuildingBlocks();"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
						</div></td>
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
						name="conid" value=""></td>
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
					<td><s:url id="selectedVmResultUrlEditPv"
							action="selectedVmResultEditPv" /> <sj:a
							id="selectedVmEVSAnchorEditPv"
							href="%{selectedVmResultUrlEditPv}"
							targets="vmDiv"
							listenTopics="vmDiv" button="true"
							buttonIcon="ui-icon-gear" onCompleteTopics="closeThisDialog">Use Selection</sj:a>
						<%--<input type="button" name="editSelectedBtn"
						value="Use Selection" onClick="ShowSelection();" disabled>
						&nbsp;&nbsp;--%> <input type="button" name="btnSubConcepts"
						value="Get Subconcepts"
						onmouseover="controlsubmenu2(event,'divAssACMenu',null,null,null)"
						onmouseout="closeall()" disabled> &nbsp;&nbsp; <input
						type="button" name="btnSuperConcepts" value="Get Superconcepts"
						disabled onclick="javascript:getSuperConcepts();">
						&nbsp;&nbsp; <input type="button" name="closeBtn"
						value="Close Window" onClick="javascript:window.close();">
						&nbsp;&nbsp; <input type="button" name="btnSubmitToEVS"
						value="Suggest to EVS" onclick="javascript:NewTermSuggested();">
						&nbsp;&nbsp; <img name="Message" src="images/SearchMessage.gif"
						width="180px" height="25" alt="WaitMessage"
						style="visibility:hidden;" align="top"></td>
				</tr>
			</table>
			<br>
			<table width="100%" valign="top">
				<tr>
					<td height="7">
				</tr>
				<tr>
					<td><font size="4"> <b> Search Results for Value
								Meaning : bone marrow </b> </font>
					</td>
				</tr>
				<tr>
					<td><font size="2"> &nbsp; 3 Records Found </font>
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

					<td width="150">Bone Marrow</td>

					<td>2570134</td>

					<td>1.0</td>

					<td>RELEASED</td>

					<td></td>

					<td>Adverse Events... <a
						href="javascript:openConDomainWindow('Bone Marrow')"><br>
							<b>More_>></b> </a>
					</td>

					<td>Bone Marrow</td>

					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
				</tr>

				<tr>
					<td width="5"><input type="checkbox" name="CK1"
						onClick="javascript:EnableButtons(checked,this);"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>

					<td width="150">Bone Marrow</td>

					<td>2581613</td>

					<td>1.0</td>

					<td>RELEASED</td>

					<td>C12431</td>

					<td>Adverse Events... <a
						href="javascript:openConDomainWindow('Bone Marrow')"><br>
							<b>More_>></b> </a>
					</td>

					<td>The tissue occupying the spaces of bone. It consists of
						blood vessel sinuses and a network of hematopoietic cells which
						give rise to the red cells, white cells, and megakaryocytes.</td>

					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
				</tr>

				<tr>
					<td width="5"><input type="checkbox" name="CK2"
						onClick="javascript:EnableButtons(checked,this);"
						onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>

					<td width="150">Bone Marrow</td>

					<td>3227901</td>

					<td>1.0</td>

					<td>DRAFT NEW</td>

					<td>C12431</td>

					<td>Adverse Events... <a
						href="javascript:openConDomainWindow('Bone Marrow')"><br>
							<b>More_>></b> </a>
					</td>

					<td>The soft, sponge-like tissue in the center of bones that
						produces white blood cells, red blood cells, and platelets.</td>

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
				<input type="hidden" name="serRecCount" value="3">
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

					<option value="2509CE87-DF03-5C23-E044-0003BA3F9857">Bone
						Marrow</option>

					<option value="2509CE88-0BDA-5C23-E044-0003BA3F9857">Bone
						Marrow</option>

					<option value="A0E811F0-F2BF-3136-E040-BB89AD430E1B">Bone
						Marrow</option>

				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName" style="visibility:hidden;">

				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName2"
					style="visibility:hidden;width:100;">


					<option value="Bone Marrow">Bone Marrow</option>

					<option value="Bone Marrow">Bone Marrow</option>

					<option value="Bone Marrow">Bone Marrow</option>

				</select>
				<!-- store definition and context here to use it later in javascript -->
				<select size="1" name="hiddenDefSource"
					style="visibility:hidden;width:100">

					<option value="(TBD context name)">Bone Marrow</option>

					<option value="(TBD context name)">The tissue occupying
						the spaces of bone. It consists of blood vessel sinuses and a
						network of hematopoietic cells which give rise to the red cells,
						white cells, and megakaryocytes.</option>

					<option value="(TBD context name)">The soft, sponge-like
						tissue in the center of bones that produces white blood cells, red
						blood cells, and platelets.</option>

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

					<option value="Bone">Bone</option>

					<option value="2202686">2202686</option>

					<option value="C12366">C12366</option>

					<option
						value="Connective tissue that forms the skeletal components of the body.">
						Connective tissue that forms the skeletal components of the body.</option>

					<option value="NCI">NCI</option>

					<option value="RELEASED">RELEASED</option>

					<option value="null">null</option>

					<option value="caBIG">caBIG</option>

					<option value="caDSR">caDSR</option>

					<option value="Concept Class">Concept Class</option>

					<option value="Bone">Bone</option>

					<option value="null">null</option>

					<option value="C12366">C12366</option>

					<option
						value="Connective tissue that forms the skeletal components of the body.">
						Connective tissue that forms the skeletal components of the body.</option>

					<option value="NCI">NCI</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Bone">Bone</option>

					<option value="null">null</option>

					<option value="C12366">C12366</option>

					<option
						value="Calcified connective tissue that forms the skeletal components of the body. (NCI)">
						Calcified connective tissue that forms the skeletal components of
						the body. (NCI)</option>

					<option value="CDISC">CDISC</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Bone Tissue">Bone Tissue</option>

					<option value="null">null</option>

					<option value="C13076">C13076</option>

					<option
						value="The mineralized osseous tissue that gives rigidity to the bones and forms its honeycomb-like three-dimensional internal structure.">
						The mineralized osseous tissue that gives rigidity to the bones
						and forms its honeycomb-like three-dimensional internal structure.</option>

					<option value="NCI">NCI</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Bone Tissue">Bone Tissue</option>

					<option value="null">null</option>

					<option value="C13076">C13076</option>

					<option
						value="The mineralized osseous tissue that gives rigidity to the bones and forms its honeycomb-like three-dimensional internal structure. (NCI)">
						The mineralized osseous tissue that gives rigidity to the bones
						and forms its honeycomb-like three-dimensional internal structure.
						(NCI)</option>

					<option value="CDISC">CDISC</option>

					<option value="Active">Active</option>

					<option value=""></option>

					<option value="null">null</option>

					<option value="NCI Thesaurus">NCI Thesaurus</option>

					<option value="null">null</option>

					<option value="Mouse Bone">Mouse Bone</option>

					<option value="null">null</option>

					<option value="C22682">C22682</option>

					<option value="No Value Exists">No Value Exists</option>

					<option value=""></option>

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

		</form>
	</div>
</div>