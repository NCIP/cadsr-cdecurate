<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/ui/jsp/jsp/ErrorPage.jsp,v 1.8 2007-01-24 06:12:18 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page isErrorPage="true" %>
<%//System.out.println("inn ErrorPage jsp");%>
<html>
<head>
<title>CDE Curation: Login</title>
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
		document.LoginForm.Message.src ="Assets/WaitMessage1.gif";
		
	}
	else if (dotCntr == 1)
	{
		document.LoginForm.Message.src ="Assets/WaitMessage2.gif";
	}
	else if (dotCntr == 2)
	{
		document.LoginForm.Message.src ="Assets/WaitMessage3.gif";
	}
	else if (dotCntr == 3)
	{
		document.LoginForm.Message.src ="Assets/WaitMessage4.gif";
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
   	winFirstGov = window.open("http://www.firstgov.gov", "FirstGov", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}

function onLoad()
{
  if(document.LoginForm.Username != null)
    document.LoginForm.Username.focus();
}

//-->
</script>
</head>

<body>
<%
String errMessage = (String)session.getAttribute("ErrorMessage");
//System.err.println("in ErrorPage!!Body!!! errMessage: " + errMessage); 
if (errMessage == null) errMessage = "";
session.setAttribute("ErrorMessage", "");

%>
<% String reqType = request.getParameter("reqType");
//System.out.println("ErrorPage reqType: " + reqType);
  if (reqType.equals("searchEVS") || reqType.equals("searchBlocks")
    || reqType.equals("searchQualifiers") || reqType.equals("getRefDocument")
    || reqType.equals("getAltNames") || reqType.equals("treeSearch") 
    || reqType.equals("treeExpand")  || reqType.equals("treeCollapse")
    || reqType.equals("doSortBlocks") || reqType.equals("doSortQualifiers")
    || reqType.equals("AltNamesDefs") || reqType.equals("ACcontact")
    || reqType.equals("showBEDisplayResult") || reqType.equals("getConClassForAC")
    || reqType.equals("getPermValue") || reqType.equals("doSortBlocks")) //for windows that are open
{

String exceptionMessage = exception.getMessage();
if (exceptionMessage == null) exceptionMessage = "";

%> 

<table width="100%" border="4" bgcolor = "#CCCCCC">
<tr>
  <table width="100%" height="140" border=0>
  <tr>
      <td width="33%" align="center"><a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr"><img src="Assets/curation_banner2.gif" border="0" alt="caDSR Logo"></a>
      </td>
  </tr>
  <tr height="200"></tr>
  <tr width="100%" align="center">
  <!--beginning of login table -->
  <table>
  <tr height="60"></tr>
    <td width="40%"></td> 
    <td width=""  align="center">
    <table width="394" border="4" bgcolor = "#CCCCCC">  
     <% if (exceptionMessage.equals("")) { %>
	      <tr>
          <td width="387" height="67" valign="center" align="center">
             <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">Please login again.</font></h3>
          </td>
        </tr>
      <%} else { %>
	      <tr>
          <td width="100%" align="center">
        <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">There is an error on page, User session has expired.</font></h3>
      </td>
       </tr>
    <% } %>
     </table>
  <table width="394" border="4" bgcolor = "#CCCCCC">
    <tr>
       <td width="387" height="67" valign="center" align="center">
              <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt"><%=exceptionMessage%></font></h3>
        </td>
    </tr>  
    <tr>
      <td width="100%" align="center">
        <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size: 14pt">Close session and log in again.</font></h3>
      </td>
    </tr>  
    <tr>
       <td width="100%" colspan="1" align="center"> 
         <input type="button" name="closeBtn" value="Close Window" onClick="javascript:window.close();" style="width: 93","height: 30">
      </td>
	   </tr>
    </tr>
  </table>
    </td>
 <tr height="200"></tr>
</table>
  </tr>
<tr height="100"></tr>
  <tr>
    <td align="center">
<table width="100%" border=0>
  <tr  height="200">
    <td width="20%" align="center" valign="bottom"> <img src="Assets/Shorten_Bottom_Logo.gif" border="0" usemap="#BottomMap"> 
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

    
<%}else{%>

<table width="100%" border="4" bgcolor = "#CCCCCC">
<tr>
  <table width="100%" height="140" border=0>
  <tr>
      <td width="33%" align="center"><a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr"><img src="Assets/curation_banner2.gif" border="0" alt="caDSR Logo"></a>
      </td>
  </tr>
  <tr height="200"></tr>
  <tr width="100%" align="center">
  <!--beginning of login table -->
  <table>
  <form method="post" name="LoginForm" action="/cdecurate/NCICurationServlet?reqType=login">
  <tr height="60"></tr>
    <td width="40%"></td> 
    <td width=""  align="center">
    <table width="394" border="4" bgcolor = "#CCCCCC">  
    <tr>
        <td width="100%" align="center">
          <h4 align="center"><font face="Arial, Helvetica, sans-serif">Error on page: <%=errMessage%></font></h4>
        </td>
    </tr>
    </table>
    <table width="394" border="4" bgcolor = "#CCCCCC">  
    <tr>
      <td width="115" height="30" valign="top" align="center" > 
        <h4><font face="Arial, Helvetica, sans-serif">User Name</font></h4>
      </td>
      <td width="231" valign="top"> 
        <input type="text" name="Username">
      </td>
      <td width="20"></td>
    </tr>
    <tr>
      <td height="30" valign="top" width="115" align="center"> 
        <h4><font face="Arial, Helvetica, sans-serif">Password</font></h4>
      </td>
      <td valign="top" width="231"> 
        <input type="password" name="Password">
      </td>
      <td width="20"></td>
    </tr>
   
      <td height="55" colspan="1" valign="top" width="115"> 
        <input name="Submit" type="submit" value="Login" onClick="callMessageGifLogin()">
      </td>
	   
      <td valign="top" width="231"> <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;"> 
      </td>
      <td width="20">
	<select name="Context" style="visibility:hidden;">
	</select>
      </td>
	
    </tr>
  </table>
</form>

    </td>
<tr height="60"></tr>

</table>
  </tr>
<tr height="100"></tr>

  <tr>
    <td align="center">
<table width="100%" border=0>
  <tr>
    <td width="20%" align="center"> <img src="Assets/Shorten_Bottom_Logo.gif" border="0" usemap="#BottomMap"> 
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
<script language = "javascript">
onLoad();
</script>
<%}%>
</body>
</html>