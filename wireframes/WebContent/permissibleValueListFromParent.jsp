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

		<table width="100%" class="sidebarBGColor">
			<!-- style="position: relative; top: -22px;"> -->
			<tr valign="top" align="left" class="firstRow">
				<th>1 ) Search For:</th>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <select name="listSearchFor"
					size="1" style="width: 160"
					onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">
						<option value="ParentConcept">Parent Concept</option>
				</select></td>
			</tr>

			<tr valign="bottom" align="left" class="firstRow" height="22">
				<th>2 ) Search Type:</th>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="RADIO" value="EVS"
					checked="checked" name="rRefType"
					onclick="javascript:changeType('EVS');"> EVS
					&nbsp;&nbsp;&nbsp;&nbsp; <input type="RADIO" value="Non EVS"
					name="rRefType" onclick="javascript:changeType('nonEVS');">
					Non EVS</td>
			</tr>

			<tr valign="bottom" align="left" class="firstRow" height="22">
				<th>3 ) Select EVS Vocabulary:</th>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <select
					name="listContextFilterVocab" size="1" style="width: 160"
					onChange="doVocabChange();"
					onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchBlocks',helpUrl); return false">

						<option value="NCI Thesaurus" selected>NCI Thesaurus</option>

						<option value="Common Terminology Criteria for Adverse Events">
							CTCAE</option>

						<option
							value="MedDRA (Medical Dictionary for Regulatory Activities Terminology)">
							MedDRA</option>

						<option value="The MGED Ontology">MGED</option>

						<option value="NCI Metathesaurus">NCI Metathesaurus</option>

						<option value="SNOMED Clinical Terms">SNOMED</option>

						<option value="National Drug File - Reference Terminology">
							VA_NDFRT</option>

						<option value="Zebrafish">Zebrafish</option>

				</select></td>
			</tr>
			<tr>
				<th height="22" valign="bottom">
					<div align="left">
						4 ) Search In:
						<!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->
					</div></th>
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
					<div align="left">5 ) Enter Search Term:</div></th>
			</tr>
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="text" name="keyword"
					size="22" style="width: 160" value="anatomic site"
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
					<div align="left">6 ) Filter Search By:</div></th>
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
						<b> 7 ) Display Attributes: </b> &nbsp;&nbsp; <input type="button"
							name="updateDisplayBtn" value="Update"
							onClick="displayAttributes('true');"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">
					</div> <br>
					<div align="center">
						<select name="listAttrFilter" size="5" style="width: 160" multiple
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">

							<option value="Concept Name" selected>Concept Name</option>

							<option value="EVS Identifier" selected>EVS Identifier</option>

							<option value="Definition" selected>Definition</option>

							<option value="Definition Source" selected>Definition
								Source</option>

							<option value="Workflow Status" selected>Workflow Status</option>

							<option value="Semantic Type" selected>Semantic Type</option>

							<option value="Vocabulary" selected>Vocabulary</option>

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
		<table width="100%" valign="top">
			<table border="0">
				<tr align="left">
					<td><s:url id="parentGridUrl" action="parentConceptListGrid" /> <sj:a
							id="parentTableButton" href="%{parentGridUrl}" targets="parentTable"
							listenTopics="parentTable" button="true"
							buttonIcon="ui-icon-gear">Link Concept</sj:a>
						<input type="button" name="btnSubConcepts" value="Get Subconcepts"
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
			<tr>
				<td><font size="4"> <b> Search Results for Parent
							Concept - - anatomic site </b> </font></td>
			</tr>

			<tr>
				<td><font size="2"> &nbsp; 1 Records Found </font></td>
			</tr>
		</table>
		<table width="100%" border="1" valign="top">
			<tr valign="middle">

				<th height="30px" width="30px"><img src="images/CheckBox.gif"
					border="0"></th>


				<th method="get"><a href="javascript:SetSortType('name')"
					onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
						Concept Name </a></th>

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

				<th method="get"><a href="javascript:SetSortType('db')"
					onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
						Vocabulary </a></th>

			</tr>

			<tr>
				<td width="5px" valign="top"><input type="checkbox" name="CK0"
					onClick="javascript:EnableButtons(checked,this);"></td>
				<td width="150px" valign="top"><a
					href="javascript:showConceptInTree('CK0');"> Anatomic Site </a> <br>

				</td>


				<td valign="top">C13717</td>

				<td valign="top">Named locations of or within the body.</td>

				<td valign="top">NCI</td>

				<td valign="top">Active</td>

				<td valign="top"></td>

				<td valign="top">NCI Thesaurus</td>

			</tr>


		</table>
		<div style="display:none">
			<input type="hidden" name="AttChecked" value="2"> <input
				type="hidden" name="searchComp" value=""> <input
				type="hidden" name="openToTree" value=""> <input
				type="hidden" name="selectedParentConceptCode" value="C13717">
			<input type="hidden" name="selectedParentConceptName"
				value="Anatomic Site"> <input type="hidden"
				name="selectedParentConceptDB" value="NCI Thesaurus"> <input
				type="hidden" name="selectedParentConceptMetaSource" value="">
			<input type="hidden" name="OCCCode" value=""> <input
				type="hidden" name="OCCCodeDB" value=""> <input
				type="hidden" name="OCCCodeName" value=""> <input
				type="hidden" name="numSelected" value=""> <input
				type="hidden" name="actSelected" value="Search"> <input
				type="hidden" name="numAttSelected" value=""> <input
				type="hidden" name="blockSortType" value="nothing"> <input
				type="hidden" name="UISearchType" value="term"> <input
				type="hidden" name="selRowID" value=""> <input type="hidden"
				name="editPVInd" value=""> <select size="1"
				name="hiddenPVValue" style="visibility:hidden;"></select> <select
				size="1" name="hiddenPVMean" style="visibility:hidden;"></select> <select
				size="1" name="hiddenResults" style="visibility:hidden;width:145px">

				<option value="Anatomic Site">Anatomic Site</option>

				<option value="C13717">C13717</option>

				<option value="Named locations of or within the body.">
					Named locations of or within the body.</option>

				<option value="NCI">NCI</option>

				<option value="Active">Active</option>

				<option value=""></option>

				<option value="NCI Thesaurus">NCI Thesaurus</option>

			</select> <select size="1" name="hiddenSelectedRow" style="visibility:hidden;">
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
	</div>
</div>