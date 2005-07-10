
<html>
<head>
<title>CDE Curation: Login</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<%@ page import="java.util.*" %>
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
     wincaDSR = window.open("http://ncicb.nci.nih.gov/core/caDSR", "caDSR", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
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

</script>
</head>

<body>
<%
  String errMessage = (String)session.getAttribute("ErrorMessage");
  if (errMessage == null) errMessage = "";
//System.out.println("LoginE errMessage: " + errMessage);
 // if (errMessage == "") errMessage = "Problem with login. User name/password may be incorrect, or database connection can not be established.";
  if (errMessage == "java.lang.NullPointerException") errMessage = "NullPointer : Session terminated. Please login again.";
  session.setAttribute("ErrorMessage", "");
  String reqType = (String)request.getAttribute("LatestReqType"); 
  if(reqType == null) reqType = "";

  //these are requests used for second window open
  Vector lstWinOpenReqs = new Vector();
  lstWinOpenReqs.addElement("searchEVS");
  lstWinOpenReqs.addElement("searchBlocks");
  lstWinOpenReqs.addElement("searchQualifiers");
  lstWinOpenReqs.addElement("getRefDocument");
  lstWinOpenReqs.addElement("treeExpand");
  lstWinOpenReqs.addElement("treeCollapse");
  lstWinOpenReqs.addElement("doSortBlocks");
  lstWinOpenReqs.addElement("doSortQualifiers");
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
  <table width="100%" border="0" bgcolor = "#FFFFFF" valign="middle" align="center">
    <col width="30%"><col width="40%"><col width="30%">
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td colspan="3" width="33%" align="center"> <img src="Assets/curation_banner2.gif" name="TopMap" border="0" usemap="#TopMapMap" id="TopMap">
      </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <%
    //for windows that are open
    if (lstWinOpenReqs.contains(reqType))  //for second windows open, display different message
    { %> 
    <tr>
      <td>&nbsp;</td>
      <td align="center" valign="middle">
        <table width="394" border="4" bgcolor="#CCCCCC">  
          <tr>
            <td width="387" valign="bottom" align="center">
              <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">This session is no longer active.</font></h3>
            </td>
          </tr>     
          <tr>
            <td width="100%" align="center" valign="bottom">
              <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">User session has expired.</font></h3>
            </td>
          </tr>  
          <tr>
            <td width="100%" align="center" valign="bottom">
              <h3 align="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">Close session and log in again.</font></h3>
            </td>
          </tr>  
          <tr height="40">
            <td width="100%" colspan="1" align="center" valign="middle"> 
              <input type="button" name="closeBtn" value="Close Window" onClick="javascript:CloseWindow();" style="width: 95, height: 26">
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
        <form name="LoginForm" method="POST" action="/cdecurate/NCICurationServlet?reqType=login">
          <table border="4" bgcolor = "#CCCCCC">
            <tr>
              <td colspan="3" height="50" valign="middle" align="center">
                <% if (errMessage.equals("")) { %>
                   <h3 align="center" valign="center"><font face="Arial, Helvetica, sans-serif" style="font-size:18px">Please enter User Name and Password.</font></h3>
                <%} else { %>
                    <h4 align="center"><font color="#FF0000" style="font-size:18px"><%=errMessage%></font></h4>
                <% } %>
              </td>
            </tr>
            <tr>
              <td width="120" valign="top" align="right" height="50">
                <h4><font face="Arial, Helvetica, sans-serif" style="font-size:15px">User Name</font>&nbsp;</h4>
              </td>
              <td width="205" valign="top">
                <input type="text" name="Username">
              </td>
            </tr>
            <tr>
              <td valign="top" align="right" height="50">
                <h4><font face="Arial, Helvetica, sans-serif" style="font-size:15px">Password</font>&nbsp;</h4>
              </td>
              <td valign="top" width="205">
                <input type="password" name="Password">
              </td>
            </tr>
            <tr>
              <td valign="middle" align="right"  height="50">
                <input name="Submit"  height="25" type="button" value="Login" onClick="callMessageGifLogin();">&nbsp;
              </td>                    
              <td valign="top" width="205"> <img name="Message" src="Assets/WaitMessage1.gif" width="250" height="25" alt="WaitMessage" style="visibility:hidden;">
              </td>
              <td width="55">&nbsp;</td>
            </tr>
          </table>
        </form>
      </td>
      <td>&nbsp;</td>
    </tr>
    <%}%>
    <tr>
      <td>&nbsp;</td>
      <td valign="top" align="center" >
        <h5><font face="Arial, Helvetica, sans-serif" style="font-size:15px">Do not use your browser's "Back" button to navigate once you have logged in. Doing so may cause the tool to function incorrectly.</font></h5>
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td></tr>
    <tr>
      <td colspan="3" width="20%" align="center"> <img src="Assets/Shorten_Bottom_Logo.gif" border="0" usemap="#BottomMap"> 		  
      </td>   
    </tr>
  </table>
  <!-- end of login table -->
  <map name="BottomMap">
    <area shape="rect" coords="63,0,225,55" onClick = "linkCancerGov();" >
    <area shape="rect" coords="227,1,517,55" onClick = "linkNIH();" >
    <area shape="rect" coords="519,2,706,53" onClick = "linkDHHS();" >
    <area shape="rect" coords="710,4,993,57" onClick = "linkFirstGov();" >
  </map>
  <map name="TopMapMap">
    <area shape="rect" coords="5,1,110,54" onClick = "linkNCI();" >
    <area shape="rect" coords="120,1,267,54" onClick = "linkcaDSR();" >
  </map>
  <%
    if (!lstWinOpenReqs.contains(reqType))  //for windows that are open
    { %> 
      <script language = "javascript">
      onFirstLoad();
      </script>
  <% } %>
</body>
</html>


