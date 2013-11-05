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
		<ul>
			<li><s:url var="urltabslocal" action="tabs-local" />
				<sj:a id="tabslocallink" href="%{urltabslocal}" targets="main">Local Tabs</sj:a>
			</li>
			<li><s:url var="urltabs" action="tabs" />
				<sj:a id="tabslocalremote" href="%{urltabs}" targets="main">Remote Tabs with Topics</sj:a>
			</li>
			<li><s:url var="urltabspreselect" action="tabs-preselect" />
				<sj:a id="tabspreselectedlink" href="%{urltabspreselect}"
					targets="main">Preselectet Tabs with Animation</sj:a>
			</li>
		</ul>
	</div>
</div>
<div id="col3">
	<div id="col3_content" class="clearfix"></div>
</div>