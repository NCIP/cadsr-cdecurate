<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div>
	<s:form id="selectedVmForm" action="ValueMeaningAction" target="_blank">
		<s:textfield name="longName" label="VM Long Name" value="Lung"
			disabled="true" />
		<s:textfield name="publicIdVersion" label="Public Id & Version"
			value="2873883v1.0" disabled="true" />
		<s:textarea name="description" label="Description/Definition"
			value="One of a pair of viscera occupying the pulmonary cavities of the thorax, the organs of respiration in which aeration of the blood takes place. As a rule, the right lung is slightly larger than the left and is divided into three lobes (an upper, a middle, and a lower or basal), while the left has but two lobes (an upper and a lower or basal). Each lung is irregularly conical in shape, presenting a blunt upper extremity (the apex), a concave base following the curve of the diaphragm, an outer convex surface (costal surface), an inner or mediastinal surface (mediastinal surface), a thin and sharp anterior border, and a thick and rounded posterior border. SYN pulmo. "
			disabled="true" rows="4" cols="90">
		</s:textarea>
		<tr>
			<td>Concepts:</td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td><s:url var="conceptTableUrl" action="conceptJson" /> <sjg:grid
					id="searchVmConceptTable" dataType="json"
					href="%{conceptTableUrl}" gridModel="addedPvConceptModel" scroll="true"
					pager="true" shrinkToFit="true">
					<sjg:gridColumn name="name" title="Concept Name" sortable="true"
						align="center" />
					<sjg:gridColumn name="evsId" title="Concept ID" sortable="true"
						align="center" />
					<sjg:gridColumn name="vocabulary" title="Vocabulary"
						sortable="true" align="center" />
					<sjg:gridColumn name="type" title="Type" sortable="true"
						align="center" />
				</sjg:grid></td>
		</tr>
	</s:form>
</sj:div>

