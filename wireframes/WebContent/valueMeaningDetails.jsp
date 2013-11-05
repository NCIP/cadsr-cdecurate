<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>
<sj:div id="readVmDiv">
	<s:url var="editVmUrl" action="editVm" />
	<sj:a id="editVmAnchor" href="%{editVmUrl}" targets="readVmDiv"
		button="true" buttonIcon="ui-icon-gear">
    	Edit this VM
    </sj:a>
	<sj:a id="altNameDefVmAnchor" href="#" targets="readVmDiv"
		button="true" buttonIcon="ui-icon-gear">
    	Alt Names/Defs
    </sj:a>
	<sj:div cssClass="result ui-widget-content ui-corner-all">
		<sj:accordion id="vmExtraDiv" autoHeight="false" collapsible="true">
			<sj:accordionItem title="Attributes and Concepts">
				<s:form id="readVmForm" action="ValueMeaningAction" target="_blank">
					<s:textfield name="longName" label="VM Long Name" value="Bone"
						disabled="true" />
					<s:textfield name="publicIdVersion" label="Public Id & Version"
						value="2567236v1.0" disabled="true" />
					<s:textarea name="description" label="Description/Definition"
						value="Connective tissue that forms the skeletal components of the body"
						disabled="true" rows="2" cols="50">
					</s:textarea>
					<s:include value="conceptsGrid.jsp">
						<s:param name="withParent">no</s:param>
						<s:param name="gridModel">conceptModel</s:param>
						<s:param name="gridId">readVmConceptTable</s:param>
						<s:param name="gridCaption">VM Concepts</s:param>
						<s:param name="readOnly">yes</s:param>
					</s:include>
				</s:form>
				<br>
			</sj:accordionItem>
			<s:url id="conceptualDomainVmUrl" action="conceptualDomainsVm" />
			<sj:accordionItem title="Conceptual Domains (22 Found)">
				<sj:div href="%{conceptualDomainVmUrl}">
				</sj:div>
			</sj:accordionItem>
			<sj:accordionItem title="Alt Names/Definitions">
				<sj:div>
				</sj:div>
			</sj:accordionItem>
			<sj:accordionItem title="Where Used">
				<sj:tabbedpanel id="whereUsedTabs" cssClass="list">
					<sj:tab id="formTab" href="formsTemplatesForValueMeaning.jsp"
						label="Forms/Templates" />
					<sj:tab id="vmTab" href="valueDomainsForValueMeaning.jsp"
						label="Value Domains" />
					<sj:tab id="deTab" href="dataElementsForValueMeaning.jsp"
						label="Data Elements" />
				</sj:tabbedpanel>
			</sj:accordionItem>
		</sj:accordion>
	</sj:div>
	<br>
</sj:div>