<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateNewPermValues.jsp,v 1.2 2008-03-13 18:05:14 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*"%>
<html>
	<head>
		<title>
			Untitled Document
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
	</head>

	<body>
		<table width="30%" border="1">
			<tr>
				<td>

					<table width="30%" border="0" cellspacing="0" cellpadding="0">
						<!--DWLayoutTable-->
						<tr>
							<td height="20" colspan="3" valign="top">
								<p>
									<font size="4" face="Arial, Helvetica, sans-serif">
										<strong>
											Create New
										</strong>
									</font>
								</p>
							</td>
						</tr>
						<tr>
							<td height="21" colspan="3" valign="top">
								<font color="#FF0000" face="Arial, Helvetica, sans-serif">
									<strong>
										Permissible Values
									</strong>
								</font>
							</td>
						</tr>
						<tr>
							<td height="18" colspan="3" valign="top">
								a)
								<font color="#FF0000">
									Enter
								</font>
								CS Item:
							</td>
						</tr>
						<tr>
							<td height="24" colspan="3" valign="top">
								<input name="NewPerValues" type="text" id="NewPerValues" value="Enter new PV to add" size="35">
							</td>
						</tr>
						<tr>
							<td height="21" colspan="3" valign="top">
								b)
								<font color="#FF0000">
									Enter
								</font>
								CS Item Meaning:
							</td>
						</tr>
						<tr>
							<td height="72" colspan="3" valign="top">
								<textarea name="CSItemMeaning" cols="30" id="CSItemMeaning"></textarea>
							</td>
						</tr>
						<tr>
							<td height="21" colspan="3" valign="top">
								c)
								<font color="#FF0000">
									Enter
								</font>
								Effective Begin Date:
							</td>
						</tr>
						<tr>
							<td height="37" colspan="2" valign="top">
								<p>
									<input name="BeginDate" type="text" id="BeginDate" size="15">
									<img name="Calendar" src="" width="38" height="33" alt="Calendar" style="background-color: #FF0000">
								</p>
							</td>
							<td width="41">
								&nbsp;
							</td>
						</tr>
						<tr>
							<td width="104" height="18" valign="top">
								<div align="center">
									<font color="#6699FF">
										<em>
											MM/DD/YYYY
										</em>
									</font>
								</div>
							</td>
							<td width="105"></td>
							<td></td>
						</tr>
						<tr>
							<td height="33" colspan="3" valign="top">
								<input name="AddNewPV" type="button" id="AddNewPV" value="Add New Permissible Value">
							</td>
						</tr>
						<tr>
							<td height="26" colspan="3" valign="top">
								Summary of PV's:
							</td>
						</tr>
						<tr>
							<td height="187" colspan="3" valign="top">
								<textarea name="SummaryPV" cols="30" rows="10" id="SummaryPV"></textarea>
							</td>
						</tr>
					</table>
					</td>
				</tr>
		</table>
	</body>
</html>
