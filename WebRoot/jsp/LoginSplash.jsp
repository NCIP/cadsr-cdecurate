<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/LoginSplash.jsp,v 1.3 2008-03-13 20:35:06 chickerura Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
		<title>
			CDE Curation: Login
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script language="JavaScript" type="text/JavaScript">
<!--
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
var userid = "nciuser";
 var password = "1121demo7";
 var ok = false;

function isOk(){
  if (LoginForm.UserID.value == "nciuser")
     ok = true;
  else
	 alert("Incorrect User ID");
   if (LoginForm.Password.value == "1121demo7")
     ok = true;
  else
	 alert("Incorrect Password");
  document.LoginForm.Message.style.visibility="visible";
  if (ok== true)
      LoginForm.submit();
//     window.open("CDEHomePage.jsp");

  dotcycle();
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
		document.LoginForm.Message.src ="images/WaitMessage4.gif";
	}

	setTimeout("dotcycle()", 700)
}
var winCancerGov = null;
var winNIH = null;
var winDHHS = null;
var winFirstGov = null;
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

function onLoad()
{
  document.LoginForm.Username.focus();
}


function autoLogIn()
{
    // document.SplashLoginForm.Username.value = "pfowler";
    // document.SplashLoginForm.Password.value = "pfowler";
     document.body.style.cursor = "wait";
     document.LoginForm.Message.style.visibility="visible";
     window.status = "Loading data, it may take a minute, please wait....."
     document.SplashLoginForm.submit();
     dotcycle();
}

//-->
</script>
	</head>

	<body onLoad="autoLogin();">
		<form method="post" name="LoginForm" action="">
			<%
String errMessage = (String)session.getAttribute("ErrorMessage");
if (errMessage == null) errMessage = "";
session.setAttribute("ErrorMessage", "");
%>
			<table width="100%" border="4" bgcolor="#CCCCCC">

				<tr>
					<table width="100%" height="140" border=0>
						<tr>
							<td width="33%" align="center">
								<a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr">
									<img src="../images/curation_banner2.gif" border="0" alt="caDSR Logo">
								</a>
							</td>
						</tr>
						<tr height="200"></tr>

						<!--beginning of login table -->
						<table>
							<tr height="60"></tr>
							<td width="40%"></td>
							<td width="" align="center">
								<table width="394" border="4" bgcolor="#CCCCCC">

									<% if (errMessage.equals("")) { %>
									<tr>
										<td width="387" height="67" valign="center" align="center">
											<h3 align="center" valign="center">
												<font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">
													Please enter User Name and Password.
												</font>
											</h3>
										</td>
									</tr>
									<%} else { %>
									<tr>
										<td width="387" height="67" valign="center" align="center">
											<h3 align="center">
												<font color="#FF0000" style="font-size: 14pt">
													<%=errMessage%>
												</font>
											</h3>
										</td>
									</tr>
									<% } %>
								</table>
								<table width="394" border="4" bgcolor="#CCCCCC">

									<tr>
										<td width="115" height="30" valign="top" align="center">
											<h4>
												<font face="Arial, Helvetica, sans-serif" style="font-size: 12pt">
													User Name
												</font>
											</h4>
										</td>
										<td width="231" valign="top">
											<input type="text" name="Username" value="">
										</td>
										<td width="20"></td>
									</tr>
									<tr>
										<td height="30" valign="top" width="115" align="center">
											<h4>
												<font face="Arial, Helvetica, sans-serif" style="font-size: 12pt">
													Password
												</font>
											</h4>
										</td>
										<td valign="top" width="231">
											<input type="password" name="Password" value="">
										</td>
										<td width="20"></td>
									</tr>
									<tr>
									<td height="55" colspan="1" valign="top" width="115">
										<input name="Submit" type="submit" value="Login" onClick="callMessageGifLogin()">
									</td>

									<td valign="top" width="231">
										<img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
									</td>
									<td width="20">
										<select name="Context" style="visibility:hidden;">
											<option></option>
										</select>
									</td>
								 </tr>
								</table>
								</form>
							</td>
							<tr height="60"></tr>
							<tr height="60">
								<td width="100"></td>
								<td width="400" height="30" valign="top" align="center">
									<h5>
										<font face="Arial, Helvetica, sans-serif" style="font-size: 10pt">
											Do not use your browser's "Back" button to navigate once you have logged in. Doing so may cause the tool to function incorrectly.
										</font>
									</h5>
								</td>
							</tr>
						</table>
					<tr height="100"></tr>

						<tr>
							<td align="center">
								<table width="100%" border=0>
									<tr>
										<td width="20%" align="center">
											<img src="../images/Shorten_Bottom_Logo.gif" border="0" usemap="#BottomMap">

										</td>

									</tr>
								</table>
							</td>
						</tr>
					</table>
			</table>
			<!-- end of login table -->
			<map name="BottomMap">
				<area shape="rect" coords="63,0,225,55" onClick="linkCancerGov();">
				<area shape="rect" coords="227,1,517,55" onClick="linkNIH();">
				<area shape="rect" coords="519,2,706,53" onClick="linkDHHS();">
				<area shape="rect" coords="710,4,993,57" onClick="linkFirstGov();">
			</map>
			<script language="javascript">
onLoad();
</script>
	</body>
</html>
