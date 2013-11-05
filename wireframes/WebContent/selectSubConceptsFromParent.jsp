<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>


<table border="0">
	<tr align="left">
		<td>
		<s:url id="subconceptTableUrl"
				value="subConceptsFromParent.jsp" /> <sj:a id="getSubconcept"
				href="%{subconceptTableUrl}" targets="subconceptTable" button="true"
				buttonIcon="ui-icon-gear">Get Subconcepts</sj:a>
				
		<input
			type="button" name="btnSuperConcepts" value="Get Superconcepts">
			&nbsp;&nbsp;</td>
	</tr>
</table>
<br>
<table width="100%" valign="top">

	<tr>
		<td><font size="4"> <b> Search Results for Anatomic
					Site </b> </font>
		</td>
	</tr>

	<tr>
		<td><font size="2"> &nbsp; 1 Records Found </font>
		</td>
	</tr>
</table>
<table width="100%" border="1" valign="top">
	<tr valign="middle">

		<th height="30px" width="30px"><a
			href="javascript:SelectAll('1')"> <img id="CheckGif"
				src="images/CheckBox.gif" border="0" alt="Select All"> </a>
		</th>


		<th method="get"><a href="javascript:SetSortType('name')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Concept Name </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('umls')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				EVS Identifier </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('def')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Definition </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('source')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Definition Source </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('asl')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Workflow Status </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('semantic')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Semantic Type </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('db')"
			onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Vocabulary </a>
		</th>

		<th method="get"><a href="javascript:SetSortType('Level')"
			onHelp="showHelp('Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
				Level </a>
		</th>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK0"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Anatomic Site <br>
		</td>


		<td valign="top">C13717</td>

		<td valign="top">No Value Exists</td>

		<td valign="top"></td>

		<td valign="top">Active</td>

		<td valign="top"></td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">0</td>

	</tr>


</table>
<br>
<br>
<br>
<div id="subconceptTable"></div>
</div>