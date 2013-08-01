<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<%@ page isErrorPage="true"%>
<%@page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
	String helpUrl = ToolURL.getCurationToolHelpURL(pageContext);
	String errMessage = (String) session.getAttribute("ErrorMessage");
	if (errMessage == null)
		errMessage = "";
	session.setAttribute("ErrorMessage", "");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>CDE Curation: Login</title>
        <script language="JavaScript" src="js/menu.js"></script>
		<script language="JavaScript" SRC="js/login.js"></script>
	    <link href="css/style.css" rel="stylesheet" type="text/css">
	</head>
    <body onload="loaded();">
        <!-- Header -->
          <curate:header displayUser = "false"/>
        <!-- Main Area -->
        <div class="xyz">
	    <table style="border-collapse: collapse; width: 100%" border="0" cellspacing="0" cellpadding="0">
                <col style="width: 2in"/>
                <col />
                <tr>
                    <td class="menuItemBlank" align="left">&nbsp;</td>
                    <td>
                        <table class="footerBanner1" cellspacing="0" cellpadding="0">
                            <col />
                            <col style="width: 1px"/>

                            <tr>
                                <td class="menuItemBlank">&nbsp;</td>
                                <td class="menuItemNormal"
                                    onmouseover="menuRootOver(this, event);"
                                    onmouseout="menuRootOut(this, event);"
                                    onclick="window.open('<%=helpUrl%>', '_blank');">
                                        Help
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
         		<tr>
					<td colspan="2" align="center"><br/>
						<%if (errMessage.equals("")) {%>

						<h3 align="center" valign="center">
							<font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">
								Please login again. </font>
						</h3>
						<%} else {%>

						<h3 align="center">
							<font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">
								 <%=errMessage%> </font>
						</h3>
						<%}
						%>
					</td>
				</tr>
				<tr>
                    <td colspan="2" align="center">
                       <form name="LoginForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=login">
        	            <input type="hidden" name="previousReqType" value="/SearchResultsPage.jsp">
        	            <input type="hidden" name="cancelLogin" value="No">
                        <table style="border-collapse: collapse"><col align="right"/><col />
                            <tr><td style="padding: 0.2in 0.1in 0.1in 0.1in"><b>User&nbsp;Name</b></td><td style="padding: 0.2in 0.1in 0.1in 0.1in"><input type="text" name="Username" value="" size="25"/></td></tr>
                            <tr><td style="padding: 0.1in 0.1in 0.1in 0.1in"><b>Password</b></td><td style="padding: 0.1in 0.1in 0.1in 0.1in"><input type="password" name="Password" value="" size="25"/></td></tr>
                            <tr><td style="padding: 0.1in 0.1in 0.2in 0.1in" align="left">&nbsp;</td><td style="padding: 0.1in 0.1in 0.2in 0.1in" align="right"><input type="Submit" value="Login" name="login" onclick="javascript:callMessageGifLogin();"/> <input type="button" value="Cancel" name="cancel" onclick="javascript:CloseWindow();"/></td></tr>
                        </table>
                      </form>
                    </td>
                </tr>
            </table>
        </div>
     
        <!-- Footer -->
        	<curate:footer/>
     </body>
 </html>