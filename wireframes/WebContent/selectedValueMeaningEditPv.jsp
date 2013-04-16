<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div>
	<s:form id="selectedVmForm" action="ValueMeaningAction" target="_blank">
		<s:textfield name="longName" label="VM Long Name" value="Bone Marrow"
			disabled="true" />
		<s:textfield name="publicIdVersion" label="Public Id & Version"
			value="2581613v1.0" disabled="true" />
		<s:textarea name="description" label="Description/Definition"
			value="The tissue occupying the spaces of bone. It consists of blood vessel sinuses and a network of hematopoietic cells which give rise to the red cells, white cells, and megakaryocytes. "
			disabled="true" rows="2" cols="50">
		</s:textarea>
		<tr>
			<td>Concepts:</td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td><s:url var="conceptTableUrl" action="conceptJson" /> <sjg:grid
					id="searchVmConceptTableEditPv" dataType="json"
					href="%{conceptTableUrl}" gridModel="editPvConceptModel"
					scroll="true" pager="true" shrinkToFit="true">
					<sjg:gridColumn name="name" title="Concept Name" sortable="true"
						align="center" />
					<sjg:gridColumn name="evsId" title="Concept ID" sortable="true"
						align="center" />
					<sjg:gridColumn name="vocabulary" title="Vocabulary"
						sortable="true" align="center" />
					<sjg:gridColumn name="type" title="Type" sortable="true"
						align="center" />
				</sjg:grid>
			</td>
		</tr>
	</s:form>
</sj:div>

