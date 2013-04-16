<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="readVmDiv">
	<sj:div cssClass="result ui-widget-content ui-corner-all">
		<s:form id="formValidate" action="ValueMeaningAction" target="_blank">
			<br>
			<s:textfield name="longName" label="VM Long Name" value="Bone" />
			<s:textfield name="publicId" label="Public Id" value="2567236"
				disabled="true" />
			<s:textfield name="version" label="Version" value="1.0" />
			<s:textarea name="description" label="Description/Definition"
				value="Connective tissue that forms the skeletal components of the body"
				rows="2" cols="50">
			</s:textarea>
			<br>
			<table>
				<tr>
					<td>Concepts:</td>
					<td></td>
				</tr>
				<tr>
					<td></td>
					<td>
						<%--			
				<table>
						<tr>
							<th>Concept Name</th>
							<th>Concept ID</th>
							<th>Vocabulary</th>
							<th>Workflow Status</th>
						</tr>
						<tr>
							<td>Bone</td>
							<td>C12366</td>
							<td>NCI Thesaurus</td>
							<td>RELEASED</td>
						</tr>
					</table>
					--%> <s:url var="conceptTableUrl" action="conceptJson" /> <sjg:grid
							id="vmConceptTable" dataType="json" href="%{conceptTableUrl}"
							gridModel="conceptModel" scroll="true" pager="true"
							shrinkToFit="true" pager="true" navigator="true"
							navigatorAddOptions="{
    		height:280,
    		reloadAfterSubmit:true,
			afterSubmit:function(response, postdata) {
							return isError(response.responseText);
                         }
		}"
							navigatorDelete="true"
							navigatorDeleteOptions="{
    		height:280,
    		reloadAfterSubmit:true,
			afterSubmit:function(response, postdata) {
							return isError(response.responseText);
                         }
		}"
							rowList="10,15,20" rowNum="15" editinline="false"
							viewsortcols="[true, 'horizontal', true]">
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
			</table>
		</s:form>
	</sj:div>
	<br>
	<sj:submit targets="result" button="true" validate="true" value="Save"
		indicator="indicator" align="right" parentTheme="simple" />
	<s:url id="editVmUrl" action="editVm" />
	<s:url id="readVmUrl" action="vmDetails" />
	<sj:a id="editVmAnchor" indicator="indicator2" href="%{readVmUrl}"
		targets="editVmDiv" listenTopics="editVmDiv" effect="highlight"
		effectDuration="1000" button="true" buttonIcon="ui-icon-gear">
    	Cancel
    </sj:a>
</sj:div>