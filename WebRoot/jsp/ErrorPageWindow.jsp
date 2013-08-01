<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/ErrorPageWindow.jsp,v 1.4 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			CDE Curation: Error Page
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<%@ page import="java.util.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		<script language="JavaScript" type="text/JavaScript">
<!--
 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);

var winNCI = null;
var wincaDSR = null;
var winNCICB = null;

function linkNCI()
{
  if (winNCI && !winNCI.closed)
     winNCI.focus();
  else
     winNCI = window.open("http://www.nci.nih.gov", "NCI", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkcaDSR()
{
  if (wincaDSR && !wincaDSR.closed)
     wincaDSR.focus();
  else
     wincaDSR = window.open("http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr", "caDSR", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkNCICB()
{
  if (winNCICB && !winNCICB.closed)
     winNCICB.focus();
  else
   	winNCICB = window.open("http://ncicb.nci.nih.gov", "NCICB", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
 function callMessageGifLogin()
 {
     document.LoginForm.Message.style.visibility="visible";
     window.status = "Loading data, it may take a minute, please wait....."
     document.LoginForm.submit();   
     dotcycle(); 
 }

var dotCntr = -1;
function dotcycle()
{
	dotCntr = dotCntr + 1
	if (dotCntr == 3) 
	{
	  dotCntr = 0
	}
	if (dotCntr == 0)
	{
		document.LoginForm.Message.src ="images/WaitMessage1.gif";
		
	}
	else if (dotCntr == 1)
	{
		document.LoginForm.Message.src ="images/WaitMessage2.gif";
	}
	else if (dotCntr == 2)
	{
		document.LoginForm.Message.src ="images/WaitMessage3.gif";
	}
	else if (dotCntr == 3)
	{
		document.LoginForm.Message.src ="../images/WaitMessage4.gif";
	}

	setTimeout("dotcycle()", 700)
}
var winCancerGov = null;
var winNIH = null;
var winDHHS = null;
var winFirstGov = null;
var helpWindow = null;

function linkCancerGov()
{
  if (winCancerGov && !winCancerGov.closed)
     winCancerGov.focus();
  else
   	winCancerGov = window.open("http://www.cancer.gov", "CancerGov", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkNIH()
{
  if (winNIH && !winNIH.closed)
     winNIH.focus();
  else
   	winNIH = window.open("http://www.nih.gov", "NIH", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkDHHS()
{
  if (winDHHS && !winDHHS.closed)
     winDHHS.focus();
  else
   	winDHHS = window.open("http://www.dhhs.gov", "DHHS", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkFirstGov()
{
  if (winFirstGov && !winFirstGov.closed)
     winFirstGov.focus();
  else
   	winFirstGov = window.open("http://www.usa.gov", "USA", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}

function CloseWindow()
{
  window.close();
}

function callHelp()
   {
      if (helpWindow && !helpWindow.closed)
       	helpWindow.focus();
      else
        	helpWindow = window.open(helpUrl, "Help");
   }
</script>
		<style>
    .WDEMAIL {
        font-family: wingdings;
        font-size: 24pt;
        font-weight: bold;
        text-decoration: none;
        margin-right: 0.2in;
        color: #888888
        }
</style>
	</head>

	<body>
		<table width="100%" border="0" bgcolor="#FFFFFF" valign="middle" align="center" cellspacing="0">
			<col width="30%">
			<col width="40%">
			<col width="30%">
			<tr bgcolor="#A90101">
				<td align="left">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="../images/brandtype.gif" border="0" alt="NCI Logo">
					</a>
				</td>
				<td>
					&nbsp;
				</td>
				<td align="right">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="../images/tagline_nologo.gif" border="0" alt="NCI Logo">
					</a>
				</td>
			</tr>
			<tr>
				<td colspan="3" width="100%" align="left">
					<a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr">
						<img src="../images/curation_banner2.gif" border="0" alt="caDSR Logo">
					</a>
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
				<td align="center" valign="middle">
					<table width="394" border="4" bgcolor="#CCCCCC">
						<tr>
							<td width="387" valign="bottom" align="center">
								<h3 align="center" valign="center">
									<font face="Arial, Helvetica, sans-serif" style="font-size:18px">
										This session is no longer active.
									</font>
								</h3>
							</td>
						</tr>
						<tr>
							<td width="100%" align="center" valign="bottom">
								<h3 align="center">
									<font face="Arial, Helvetica, sans-serif" style="font-size:18px">
										User session has expired.
									</font>
								</h3>
							</td>
						</tr>
						<tr>
							<td width="100%" align="center" valign="bottom">
								<h3 align="center">
									<font face="Arial, Helvetica, sans-serif" style="font-size:18px">
										Close session and log in again.
									</font>
								</h3>
							</td>
						</tr>
						<tr height="40">
							<td width="100%" colspan="1" align="center" valign="middle">
								<input type="button" name="closeBtn" value="Close Window" onClick="window.close();">
							</td>
						</tr>
					</table>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td colspan="3" align="center">
					<a href="mailto:ncicb@pop.nci.nih.gov?subject=CDE%20Curation%20Tool">
						<span class="wdemail" title="Email NCICB Help Desk">
							&#42;
						</span>
					</a>
					<a target="_blank" href="http://www.cancer.gov/">
						<img border="0" src="../images/footer_nci.gif" alt="National Cancer Institute Logo" title="National Cancer Institute">
					</a>
					<a target="_blank" href="http://www.dhhs.gov/">
						<img border="0" src="../images/footer_hhs.gif" alt="Department of Health and Human Services Logo" title="Department of Health and Human Services">
					</a>
					<a target="_blank" href="http://www.nih.gov/">
						<img border="0" src="../images/footer_nih.gif" alt="National Institutes of Health Logo" title="National Institutes of Health">
					</a>
					<a target="_blank" href="http://www.usa.gov/">
						<img border="0" src="../images/footer_usagov.gif" alt="USA.gov" title="USA.gov">
					</a>
				</td>
			</tr>
		</table>
	</body>
</html>


