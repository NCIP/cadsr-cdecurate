<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib prefix="sj" uri="/struts-jquery-tags"%>
<%@ taglib prefix="sjg" uri="/struts-jquery-grid-tags"%>

<s:set name="withParent">${param.withParent}</s:set>
<s:set name="gridModel">${param.gridModel}</s:set>
<s:set name="gridId">${param.gridId}</s:set>
<s:set name="gridCaption">${param.gridCaption}</s:set>
<s:set name="readOnly">${param.readOnly}</s:set>
<s:set name="showOrder">${param.showOrder}</s:set>
<s:if test="%{#readOnly == 'yes'}">
	<s:set name="showNagivator">false</s:set>
</s:if>
<s:else>
	<s:set name="showNagivator">true</s:set>
</s:else>
<s:if test="%{#showOrder == 'yes'}">
	<s:set name="cellEdit">true</s:set>
</s:if>
<s:else>
	<s:set name="cellEdit">false</s:set>
</s:else>
<s:url var="conceptTableUrl" action="conceptJson" />
<sjg:grid id="%{#gridId}" dataType="json" href="%{conceptTableUrl}"
	gridModel="%{#gridModel}" scroll="true" pager="true" shrinkToFit="true"
	pager="true" caption="%{#gridCaption}" navigator="%{#showNagivator}"
	navigatorEdit="false" navigatorAdd="false" navigatorSearch="false"
	multiselect="%{#showNagivator}"
	navigatorDeleteOptions="{height:280, reloadAfterSubmit:true}"
	cellEdit="%{#cellEdit}" cellurl="#">
	<sjg:gridColumn name="name" title="Concept Name" sortable="true"
		align="center" />
	<sjg:gridColumn name="evsId" title="Concept ID" sortable="true"
		align="center" />
	<sjg:gridColumn name="vocabulary" title="Vocabulary" sortable="true"
		align="center" />
	<s:if test="%{#withParent != 'yes'}">
		<sjg:gridColumn name="type" title="Type" sortable="true"
			align="center" />
	</s:if>
	<%--doesn't work <s:if test="%{#parameters.withParent[0]=='yes'}"> --%>
	<s:if test="%{#withParent == 'yes'}">
		<sjg:gridColumn name="" title="" sortable="false" align="center"
			formatter="getConceptValuesLink" cssClass="link" />
	</s:if>
	<s:if test="%{#showOrder == 'yes'}">
		<sjg:gridColumn name="order" title="Order" sortable="false"
			align="center" editable="true" />
	</s:if>

</sjg:grid>