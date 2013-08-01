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
		<td><s:url id="addPvFromParentUrl" action="addPvFromParent" />
			<sj:a id="linkPv" href="%{addPvFromParentUrl}"
				targets="pvModelFromParentDiv" button="true"
				buttonIcon="ui-icon-gear">Link Concept</sj:a></td>
	</tr>
</table>
<table width="100%" valign="top">
	<tr>
		<td><font size="4"> <b> Subconcept Search Results for
					Anatomic Site </b> </font></td>
	</tr>

	<tr>
		<td><font size="2"> &nbsp; 30 Immediate Subconcepts Found
		</font>
		</td>
	</tr>
</table>
<table width="100%" border="1" valign="top">
	<tr valign="middle">

		<th height="30px" width="30px"><a
			href="javascript:SelectAll('30')"> <img id="CheckGif"
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

		<td width="150px" valign="top">Microchip Site <br>
		</td>


		<td valign="top">C77682</td>

		<td valign="top">The anatomic site at which a microchip is
			implanted.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK1"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Microchip Site <br>
		</td>


		<td valign="top">C77682</td>

		<td valign="top">The anatomic site at which a microchip is
			implanted. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK2"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Infusion Site <br>
		</td>


		<td valign="top">C77679</td>

		<td valign="top">The anatomic site through which fluid is
			introduced into the body.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK3"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Infusion Site <br>
		</td>


		<td valign="top">C77679</td>

		<td valign="top">The anatomic site through which fluid is
			introduced into the body. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK4"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Arterial Access Site <br>
		</td>


		<td valign="top">C100056</td>

		<td valign="top">Anatomical location where an artery was accessed
			for a diagnostic or therapeutic procedure.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK5"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Arterial Access Site <br>
		</td>


		<td valign="top">C100056</td>

		<td valign="top">Anatomical location where an artery was accessed
			for a diagnostic or therapeutic procedure.</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK6"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Implantation Site <br>
		</td>


		<td valign="top">C77678</td>

		<td valign="top">The anatomic site at which a material such as a
			tissue, graft, device or radioactive material is inserted with some
			intended degree of permanence. This term may also refer to the site
			of the uterus at which the early embryo is attached.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK7"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Implantation Site <br>
		</td>


		<td valign="top">C77678</td>

		<td valign="top">The anatomic site at which a tissue, graft, or
			radioactive material is inserted. This term may also refer to the
			site of the uterus at which the early embryo is attached.</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK8"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Incision Site <br>
		</td>


		<td valign="top">C77683</td>

		<td valign="top">The anatomic site of a cut made during surgery.
			The term may also refer to the resultant scar from the surgical
			procedure.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK9"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Incision Site <br>
		</td>


		<td valign="top">C77683</td>

		<td valign="top">The anatomic site of a cut made during surgery.
			The term may also refer to the resultant scar from the surgical
			procedure. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK10"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Targeted Anatomic Site <br>
		</td>


		<td valign="top">C70729</td>

		<td valign="top">An anatomic site targeted for a particular
			medical intervention.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK11"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Tattoo Site <br>
		</td>


		<td valign="top">C77684</td>

		<td valign="top">The anatomic site at which a tattoo is present.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK12"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Tattoo Site <br>
		</td>


		<td valign="top">C77684</td>

		<td valign="top">The anatomic site at which a tattoo is present.
			(NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK13"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Biopsy Site <br>
		</td>


		<td valign="top">C77677</td>

		<td valign="top">The anatomic site targeted for a biopsy
			procedure.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK14"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Biopsy Site <br>
		</td>


		<td valign="top">C77677</td>

		<td valign="top">The anatomic site targeted for a biopsy
			procedure. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK15"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Acupuncture Point <br>
		</td>


		<td valign="top">C93246</td>

		<td valign="top">A specific spot on the body where an acupuncture
			needle may be inserted to control pain and other symptoms.</td>

		<td valign="top">NCI-GLOSS</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK16"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Anatomic Sites, Other <br>
		</td>


		<td valign="top">C13400</td>

		<td valign="top">No Value Exists</td>

		<td valign="top"></td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK17"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Injection Site <br>
		</td>


		<td valign="top">C77680</td>

		<td valign="top">The anatomic site at which a medication or a
			vaccine is injected.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK18"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Injection Site <br>
		</td>


		<td valign="top">C77680</td>

		<td valign="top">The anatomic site at which a medication or a
			vaccine is injected. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK19"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Catheter Site <br>
		</td>


		<td valign="top">C92596</td>

		<td valign="top">The anatomic site through which fluid is
			transferred into or out of the body using a catheter.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK20"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Catheter Site <br>
		</td>


		<td valign="top">C92596</td>

		<td valign="top">The anatomic site through which fluid is
			transferred into or out of the body using a catheter. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK21"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Unspecified Anatomic Sites <br>

		</td>


		<td valign="top">C13411</td>

		<td valign="top">Research that isn't focused on a specific site.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK22"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Application Site <br>
		</td>


		<td valign="top">C77676</td>

		<td valign="top">The anatomic site at which medical intervention
			is administered.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK23"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Application Site <br>
		</td>


		<td valign="top">C77676</td>

		<td valign="top">The anatomic site at which medical intervention
			is administered. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK24"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Exteriorization Site <br>
		</td>


		<td valign="top">C77685</td>

		<td valign="top">The site of the surgical exposure of an internal
			organ or tissue.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK25"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Exteriorization Site <br>
		</td>


		<td valign="top">C77685</td>

		<td valign="top">The site of the surgical exposure of an internal
			organ or tissue. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK26"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Multiple Anatomic Sites <br>

		</td>


		<td valign="top">C13420</td>

		<td valign="top">Present at many sites of the body.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK27"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">All Sites <br>
		</td>


		<td valign="top">C13399</td>

		<td valign="top">Anything relevant to all anatomic sites -
			non-specific.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK28"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Injury Site <br>
		</td>


		<td valign="top">C77681</td>

		<td valign="top">The anatomic site at which damage or harm was
			suffered.</td>

		<td valign="top">NCI</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>

	<tr>
		<td width="5px" valign="top"><input type="checkbox" name="CK29"
			onClick="javascript:EnableButtons(checked,this);">
		</td>

		<td width="150px" valign="top">Injury Site <br>
		</td>


		<td valign="top">C77681</td>

		<td valign="top">The anatomic site at which damage or harm was
			suffered. (NCI)</td>

		<td valign="top">CDISC</td>

		<td valign="top">Active</td>

		<td valign="top">Body Location or Region</td>

		<td valign="top">NCI Thesaurus</td>

		<td valign="top">1</td>

	</tr>


</table>
