<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!--
    Copyright (c) 2006 ScenPro, Inc.

    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/alternates3.jsp,v 1.2 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%@ page import="java.util.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsServlet"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.ui.AltNamesDefsSession"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.TreeNode"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.database.DBAccess"%>
<%@ page import="gov.nih.nci.cadsr.common.StringUtil"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<curate:checkLogon name="Userbean" page="/LoginE.jsp" />
<html>
	<head>
		<base href="<%=basePath%>">

		<title>
			Administered Component Alternate Names and Definitions
		</title>

		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">

		<link rel="stylesheet" type="text/css" href="css/alternates.css">

        <%
        ServletRequest req = pageContext.getRequest();
        String length;
        String text;
        text = (String) req.getAttribute(AltNamesDefsServlet._modeFlag);
        boolean nameFlag = text.equals(AltNamesDefsServlet._modeName);
        %>
		<script type="text/javascript">
        var parmNameDef = "<%=AltNamesDefsServlet._parmNameDef%>";
        var nodeLevel = "<%=TreeNode._nodeLevel%>";
        var nodeValue = "<%=TreeNode._nodeValue%>";
        var nodeName = "<%=TreeNode._nodeName%>";
        var nodeCsiType = "<%=TreeNode._nodeCsiType%>";
        var nameFlag = <%=nameFlag%>;
        var parmType = "<%=AltNamesDefsServlet._parmType%>";
        var parmLang = "<%=AltNamesDefsServlet._parmLang%>";
        var actionSaveName = "<%=AltNamesDefsServlet._actionSaveAlt%>";
        var parmIdseq = "<%=AltNamesDefsServlet._parmIdseq%>";
        var actionClassify = "<%=AltNamesDefsServlet._actionClassify%>";
        var actionRemoveAssoc = "<%=AltNamesDefsServlet._actionRemoveAssoc%>";
        var actionRestoreAssoc = "<%=AltNamesDefsServlet._actionRestoreAssoc%>";
        var parmFilterText = "<%=AltNamesDefsServlet._parmFilterText%>";
        var parmReserved = "<%=DBAccess.getPackageAliasName()%>";

        history.forward();
    </script>
		<script type="text/javascript" src="js/alternates.js"></script>
	</head>

	<body onload="loaded();">
		<form name="alternatesForm" method="post" action="NCICurationServlet">
			<input type="hidden" name="reqType" value="<%=AltNamesDefsServlet._reqType%>" />
			<input type="hidden" name="<%=AltNamesDefsServlet._actionTag%>" value="<%=AltNamesDefsServlet._actionAddName%>" />
			<input type="hidden" name="<%=AltNamesDefsServlet._parmIdseq%>" value="" />
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._prevActionTag);
        %>
			<input type="hidden" name="<%=AltNamesDefsServlet._prevActionTag%>" value="<%=text%>" />
        <%
            text = (String) req.getAttribute(AltNamesDefsServlet._reqIdseq);
        %>
			<input type="hidden" name="<%=AltNamesDefsServlet._reqIdseq%>" value="<%=text%>" />
        <%
            text = (String) req.getAttribute(AltNamesDefsServlet._modeFlag);
        %>
			<input type="hidden" name="<%=AltNamesDefsServlet._modeFlag%>" value="<%=text%>" />
        <%
            text = (String) req.getAttribute(AltNamesDefsSession._searchEVS);
        %>
			<input type="hidden" name="<%=AltNamesDefsSession._searchEVS%>" value="<%=text%>" />
        <%
            text = (String) req.getAttribute(AltNamesDefsSession._beanVMID);
        %>
			<input type="hidden" name="<%=AltNamesDefsSession._beanVMID%>" value="<%=text%>" />

			<table>
				<tr>
					<td>
						<p class="title1">
							Alternate Names & Definitions
						</p>
						<p class="note1">
							Changes are not permanent until the Administered Component is Validated and Saved.
						</p>
                        <p class="note1">
                            The Edit and Delete icons only appear for entries owned by Contexts for which the user has update privileges.
                        </p>
					</td>
					<td>
						<p id="process" class="title2">
							&nbsp;
						</p>
					</td>
				</tr>
			</table>
			<p class="title1">
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._reqTitle);
        %>
				<%=text%>
			</p>
			<p>
		<%
            text = (String) req.getAttribute(AltNamesDefsSession._showClear);
            if (text.equals("Y"))
                text = "";
            else
                text = "disabled";
        %>
				<input type="button" value="Clear" onclick="doAction('<%=AltNamesDefsServlet._actionClear%>');" <%=text%> />
				&nbsp;
				<input type="button" value="Close" onclick="self.close();" />
			</p>
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._errors);
            if (text != null)
            {
        %>
			<p class="title1" style="color: red">
				<%=text%>
			</p>
		<%
            }
        %>
			<div class="tabs">
				<table>
					<colgroup>
						<col style="width: 1px" />
						<col style="width: 1px" />
						<col style="width: 1px" />
						<col />
					</colgroup>
					<tr>
						<td class="tabx" onclick="doAction('<%=AltNamesDefsServlet._actionViewName%>');">
							<%=AltNamesDefsServlet._tabViewName%>
						</td>
						<td class="tabx" onclick="doAction('<%=AltNamesDefsServlet._actionViewCSI%>');">
							<%=AltNamesDefsServlet._tabViewCSI%>
						</td>
						<td class="taby">
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._tabNameDef);
        %>
							<%=text%>
						</td>
						<td class="tabz">
							&nbsp;
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-left: 0in; margin-right: 0in; border-left: 2px solid black; border-bottom: 2px solid black; border-right: 2px solid black; width: 100%; padding: 0.1in 0.1in 0.1in 0.1in">
				<div>
					<input type="button" name="btnSave" value="Save" onclick="doSave();">
					<input type="button" name="btnCancel" value="Cancel" onclick="doActionCancel();">
				</div>
				<div>
					<table style="margin-top: 0.2in">
						<colgroup>
							<col />
							<col style="width: 1px" />
							<col style="width: 1px" />
						</colgroup>
						<tr>
		<%
            if (nameFlag)
            {
                length = (String) req.getAttribute(AltNamesDefsServlet._dbTextMax);
        %>
							<td style="vertical-align: top">
								<span class="mandatory">*</span><span class="prompt">Name:</span> (<%=length%> character max)<br />
		<%
                text = (String) req.getAttribute(AltNamesDefsServlet._parmNameDef);
        %>
								<input type="text" name="<%=AltNamesDefsServlet._parmNameDef%>" value="<%=text%>" maxlength="<%=length%>" style="width: 100%" />
							</td>
		<%
            }
            else
            {
                length = (String) req.getAttribute(AltNamesDefsServlet._dbTextMax);
        %>
							<td style="vertical-align: top">
								<span class="mandatory">*</span><span class="prompt">Definition:</span> (<%=length%> character max)<br />
		<%
                text = (String) req.getAttribute(AltNamesDefsServlet._parmNameDef);
        %>
								<textarea name="<%=AltNamesDefsServlet._parmNameDef%>" style="width: 100%; height: 1in"/><%=text%></textarea>
							</td>
		<%
            }
        %>
                            <td style="padding-left: 0.1in; vertical-align: top">
                                <span class="mandatory">*</span><span class="prompt">Context:</span><br />
                                <select name="<%=AltNamesDefsServlet._parmContext%>">
        <%
            text = (String) req.getAttribute(AltNamesDefsServlet._parmContext);
        %>
                                    <%=text%>
                                 </select>
                            </td>
							<td style="padding-left: 0.1in; vertical-align: top">
								<span class="mandatory">*</span><span class="prompt">Type:</span><br />
								<select name="<%=AltNamesDefsServlet._parmType%>">
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._parmType);
        %>
									<%=text%>
								</select>
							</td>
							<td style="padding-left: 0.1in; vertical-align: top">
								<span class="mandatory">*</span><span class="prompt">Language:</span><br />
								<select name="<%=AltNamesDefsServlet._parmLang%>">
		<%
            text = (String) req.getAttribute(AltNamesDefsServlet._parmLang);
        %>
									<%=text%>
								</select>
							</td>

						</tr>
					</table>
					<p style="margin-bottom: 0in">
						<span class="prompt">
							Classification Schemes and Class Scheme Items:
						</span>
					</p>
					<div class="list">
        <%
            text = (String) req.getAttribute(AltNamesDefsServlet._reqCSIList);
        %>
						<%=text%>
					</div>
				</div>

				<table style="margin-top: 0.2in">
					<tr>
						<td>
							<input type="button" name="btnClass" value="Classify" onclick="doClassify();">
						</td>
        <%
            text = (String) req.getAttribute(AltNamesDefsServlet._parmFilterText);
        %>
						<td style="padding-left: 0.2in">
							<span class="prompt">
								Filter Text:
							</span>
							<input type="text" name="<%=AltNamesDefsServlet._parmFilterText%>" value="<%=text%>" style="width: 3in" onkeyup="filterCSI(this);" />
						</td>
					</tr>
				</table>
				<div id="csiList" class="list" style="height: 3in">
        <%
            text = StringUtil.cleanJavascriptAndHtml((String) req.getAttribute(AltNamesDefsServlet._reqAttribute));
        %>
					<%=text%>
				</div>
			</div>
		</form>
	</body>
</html>
