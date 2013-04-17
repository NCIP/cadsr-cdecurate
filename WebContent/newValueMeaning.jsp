<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<sj:div>
	<s:form id="newVmForm" action="ValueMeaningAction" target="_blank">
		<s:textfield name="longName" label="VM Long Name" />
		<s:textarea name="description" label="Description/Definition" rows="2"
			cols="50">
		</s:textarea>
		<%--
		<tr>
			<td>Concepts:</td>
			<td><sj:a id="add" button="true" buttonIcon="ui-icon-gear">
    	Search and Associate </sj:a>
			</td>
		</tr>
		
		<tr>
			<td></td>
			<td><br> <s:url var="conceptTableUrl" action="conceptJson" />
				<sjg:grid id="editVmConceptTable" dataType="json"
					href="%{conceptTableUrl}" gridModel="conceptModel" scroll="true"
					pager="true" shrinkToFit="true" pager="true">
					<sjg:gridColumn name="action" title=""
						formatter="formatRemoveConceptLink" cssClass="link"
						sortable="false" align="center" />
					<sjg:gridColumn name="name" title="Concept Name" sortable="true"
						align="center" />
					<sjg:gridColumn name="evsId" title="Concept ID" sortable="true"
						align="center" />
					<sjg:gridColumn name="vocabulary" title="Vocabulary"
						sortable="true" align="center" />
					<sjg:gridColumn name="type" title="Type" sortable="true"
						align="center" />
				</sjg:grid><br></td>
		</tr> --%>
		<tr>
			<td></td>
			<td align="right"><sj:submit targets="result" button="true"
					validate="true" value="Save the VM" indicator="indicator" align="right"
					parentTheme="simple" /></td>
		</tr>
	</s:form>
</sj:div>
