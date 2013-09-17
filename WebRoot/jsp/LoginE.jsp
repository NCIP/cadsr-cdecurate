<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright ScenPro, Inc 2007
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/LoginE.jsp,v 1.7 2009-04-21 03:47:35 hegdes Exp $
    $Name: not supported by cvs2svn $
-->
<html>
<head>
<title>CDE Curation: Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">

<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolConstants"%>
<script language="JavaScript" type="text/JavaScript">
<!--
 var helpUrl = "<%=ToolConstants.ONLINE_HELP_URL%>";
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
/*var userid = "nciuser";
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
 } */

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
 // if (opener != null)
   // opener.callTimeout();
 // opener.callLogout();
 // opener.closeWindow();
  window.close();
}

//-->
function onFirstLoad()
{
  if (window.opener != null)
      window.opener = null;
  if(document.LoginForm.Username != null)
      document.LoginForm.Username.focus();
  document.onkeypress = keypress_handler;
}

function keypress_handler()
{
    var keycode = window.event.keyCode;
    if(keycode == 13)
    {      
      callMessageGifLogin();   //submit the form
    }
    return;  // only interest on return kay
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
<%
  String errMessage = (String)session.getAttribute("ErrorMessage");
  if (errMessage == null) errMessage = "";
//System.out.println("LoginE errMessage: " + errMessage);
 // if (errMessage == "") errMessage = "Problem with login. User name/password may be incorrect, or database connection can not be established.";
  if (errMessage == "java.lang.NullPointerException") errMessage = "Unexpected Exception. Session Terminated. Please login again.";
  session.setAttribute("ErrorMessage", "");
  String reqType = (String)request.getAttribute("LatestReqType"); 
  if(reqType == null) reqType = "";

  //these are requests used for second window open
  //Vector<String> lstWinOpenReqs = new Vector<String>();
  Vector lstWinOpenReqs = new Vector();
  lstWinOpenReqs.addElement("searchEVS");
  lstWinOpenReqs.addElement("searchBlocks");
   lstWinOpenReqs.addElement("getRefDocument");
  lstWinOpenReqs.addElement("treeExpand");
  lstWinOpenReqs.addElement("treeCollapse");
  lstWinOpenReqs.addElement("doSortBlocks");
  lstWinOpenReqs.addElement("doSortQualifiers");
  lstWinOpenReqs.addElement("getPermValue");
  lstWinOpenReqs.addElement("getDDEDetails");
  lstWinOpenReqs.addElement("nonEVSSearch");
  lstWinOpenReqs.addElement("showDECDetail");
  lstWinOpenReqs.addElement("showCDDetail");
  lstWinOpenReqs.addElement("getConClassForAC");
  lstWinOpenReqs.addElement("getAltNames");
  lstWinOpenReqs.addElement("showBEDisplayResult");
  lstWinOpenReqs.addElement("ACcontact");
  lstWinOpenReqs.addElement("AltNamesDefs");
 // lstWinOpenReqs.addElement("");
  //handle search for create items (de, dec, vd, pv, vm searches)
  String menuAct = (String)session.getAttribute("serMenuAct");
  if (menuAct == null) menuAct = "";
//System.out.println("LoginE reqType: " + reqType + " menuAct: " + menuAct);
  if (menuAct.equals("searchForCreate") && !errMessage.equals(""))
  {
    lstWinOpenReqs.addElement("searchForCreate");
    reqType = "searchForCreate";
    session.setAttribute("serMenuAct", "");
  }
  
%>
  <table width="100%" border="0" bgcolor = "#FFFFFF" valign="middle" align="center" cellspacing="0">
    <col width="30%"><col width="40%"><col width="30%">
		<tr bgcolor="#A90101">
				<td  align="left"><a href="http://www.cancer.gov" target=_blank><img src="images/brandtype.gif" border="0" alt="NCI Logo"></a></td>
				<td>&nbsp;</td>
				<td  align="right"><a href="http://www.cancer.gov" target=_blank><img src="images/tagline_nologo.gif" border="0" alt="NCI Logo"></a></td>
		</tr>
    <tr>
      <td colspan="3" width="100%" align="left"><a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr"><img src="images/curation_banner2.gif" border="0" alt="caDSR Logo"></a>
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <% 
    //System.out.println("LoginE_jsp " + reqType);
        //for windows that are open
    if (lstWinOpenReqs.contains(reqType))  //for second windows open, display different message
    {%> 
    <tr>
      <td>&nbsp;</td>
      <td align="center" valign="middle">
        <table width="394" border="4" bgcolor="#CCCCCC">  
          <tr>
            <td width="387" valign="bottom" align="center">
              <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">This session is no longer active.</font></h3>
            </td>
          </tr>     
          <tr>
            <td width="100%" align="center" valign="bottom">
              <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">User session has expired.</font></h3>
            </td>
          </tr>  
          <tr>
            <td width="100%" align="center" valign="bottom">
              <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">Close session and log in again.</font></h3>
            </td>
          </tr>  
          <tr height="40">
            <td width="100%" colspan="1" align="center" valign="middle"> 
              <input type="button" name="closeBtn" value="Close Window" onClick="javascript:CloseWindow();">
            </td>
          </tr>
        </table>
      </td>
      <td>&nbsp;</td>
    </tr>          
    <%} else {%>
    <!--beginning of login table -->
    <tr>
      <td>&nbsp;</td>
      <td align="center" valign="middle">
        <form name="LoginForm" method="POST" action="../../cdecurate/NCICurationServlet?reqType=login">
        	<input type="hidden" name="previousReqType" value="/SearchResultsPage.jsp">
          <table border="5" bgcolor = "#CCCCCC">
			<tr><td>
			<table border="0" bgcolor = "#CCCCCC">
            <tr>
              <td colspan="3" height="50" valign="middle" align="center">
                <% if (errMessage.equals("")) { %>
                   <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">Please enter User Name and Password.</font></h3>
                <%} else { %>
                    <h4 align="center"><font color="#FF0000" style="font-size: 14pt"><%=errMessage%></font></h4>
                <% } %>
              </td>
            </tr>
            <tr>
				<td colspan="2" align="right" >
				<font face="Arial, Helvetica, sans-serif" style="font-size: 12pt font-weight: bold;"><b>User Name</b></font>&nbsp;<input type="text" name="Username" style="width: 4cm">
				<br><br>
				<font face="Arial, Helvetica, sans-serif" style="font-size: 12pt font-weight: bold;"><b>Password</b></font>&nbsp;<input type="password" name="Password" style="width: 4cm">
				</td>
				<td>&nbsp;</td>
			</tr>
            <tr>
              <td valign="middle" align="right"  height="50">
                <input name="Submit"  height="25" type="button" value="Login" onClick="callMessageGifLogin();">&nbsp;
              </td>                    
              <td valign="middle" width="205"> <img name="Message" src="images/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
              </td>
              <td valign="middle" width="55">
              <input name="Help"  height="25" type="button" value="Help" onClick="callHelp();">&nbsp;
              </td>
            </tr>
          </table>
		</td></tr>
		</table>
        </form>
      </td>
      <td>&nbsp;</td>
    </tr>
    <%}%>
    <tr>
      <td>&nbsp;</td>
      <td valign="top" align="center" >
        <h5><font face="Arial, Helvetica, sans-serif" style="font-size: 10pt">Do not use your browser's "Back" button to navigate once you have logged in. Doing so may cause the tool to function incorrectly.</font></h5>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td colspan="3" align="center">
          <a href="mailto:ncicb@pop.nci.nih.gov?subject=CDE%20Curation%20Tool"><span class="wdemail" title="Email NCICB Help Desk">&#42;</span></a>
          <a target="_blank" href="http://www.cancer.gov/"><img border="0" src="images/footer_nci.gif" alt="National Cancer Institute Logo" title="National Cancer Institute"></a>
          <a target="_blank" href="http://www.dhhs.gov/"><img border="0" src="images/footer_hhs.gif" alt="Department of Health and Human Services Logo" title="Department of Health and Human Services"></a>
          <a target="_blank" href="http://www.nih.gov/"><img border="0" src="images/footer_nih.gif" alt="National Institutes of Health Logo" title="National Institutes of Health"></a>
          <a target="_blank" href="http://www.usa.gov/"><img border="0" src="images/footer_usagov.gif" alt="USA.gov" title="USA.gov"></a>
      </td>   
    </tr>
  </table>
  <!-- end of login table -->
  <%
    if (!lstWinOpenReqs.contains(reqType))  //for windows that are open
    { %> 
      <script language = "javascript">
      onFirstLoad();
      </script>
  <% } %>
</body>
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
</head>
</html>


