<%@ page isErrorPage="true" %>
<html>
<head>
<title>CDE Curation: Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<% System.err.println("in ErrorPageWindow.jsp!!"); %>
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

 function callMessageGifLogin()
   {
  //   document.LoginForm.Message.style.visibility="visible";
  //   window.status = "Loading data, it may take a minute, please wait....."
  //   document.LoginForm.submit();   
  //   dotcycle(); 
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
   	winFirstGov = window.open("http://www.firstgov.gov", "FirstGov", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}

//-->
</script>
</head>

<body>
<%
 String errMessage = "";  //exception.getMessage();
if (errMessage == null) errMessage = "";
%>
 <table width="100%" border="4" bgcolor = "#CCCCCC">

<tr>
<table width="100%" border=0>
  <tr>
      <td width="33%" align="center"> <img src="../Assets/curation_banner2.gif" name="TopMap" border="0" usemap="#TopMapMap" id="TopMap">
      </td>
  </tr>
  <tr height="200"></tr>
  <tr width="100%" align="center">
<tr height="240"></tr>
<tr width="100%" align="center">
 <!--beginning of login table -->
  <table>
  <tr height="60"></tr>
    <td width="40%"></td> 
    <td width=""  align="center">
    <table width="394" border="4" bgcolor = "#CCCCCC">  
	  <tr>
      <td width="387" height="45" valign="center" align="center">
          <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">This session is no longer active..</font></h3>
      </td>
    </tr>
  </table>
  <table width="394" border="4" bgcolor = "#CCCCCC">
  </tr>
    <tr>
      <td width="100%" align="center" valign="center">
        <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">User session has expired.</font></h3>
      </td>
    </tr>  
    <tr>
      <td width="100%" align="center" valign="center">
        <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">Close session and log in again.</font></h3>
      </td>
    </tr>  
    <tr height="40">
       <td width="100%" colspan="1" align="center" valign="center"> 
         <input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();" style="width: 95","height: 26">
      </td>
	   </tr>
    </tr>
  </table>
    </td>
 <tr height="100"></tr>
</table>
  </tr>
<tr height="100"></tr>
  <tr>
    <td align="center">
<table width="100%" border=0>
  <tr  height="150">
    <td width="20%" align="center" valign="bottom"> <img src="../Assets/Shorten_Bottom_Logo.gif" border="0" usemap="#BottomMap"> 
    </td>
  </tr>
</table>
    </td>
  </tr>
</table>
</table>
<!-- end of login table -->
<map name="BottomMap">
  <area shape="rect" coords="63,0,225,55" onClick = "linkCancerGov();" >
  <area shape="rect" coords="227,1,517,55" onClick = "linkNIH();" >
  <area shape="rect" coords="519,2,706,53" onClick = "linkDHHS();" >
  <area shape="rect" coords="710,4,993,57" onClick = "linkFirstGov();" >
</map>
<map name="TopMapMap">
  <area shape="rect" coords="21,1,167,54" onClick = "linkcaDSR();" >
  <area shape="rect" coords="189,1,367,54" onClick = "linkNCI();" >
  <area shape="rect" coords="471,1,1005,56" onClick = "linkNCICB();">
</map>
</body>
</html>