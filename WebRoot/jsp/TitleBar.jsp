<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/TitleBar.jsp,v 1.11 2009-04-16 17:22:44 veerlah Exp $
    $Name: not supported by cvs2svn $
-->

<html>
	<head>
	<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
	<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
	<% //String thisServer2 = request.getServerName(); 
   String sentinelURL = (String)session.getAttribute("SentinelURL");
   String UMLBrowserURL = (String)session.getAttribute("UMLBrowserURL");
   String strNothing ="nothing";
   
 %>
<script language="JavaScript">
<!--
var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
var dotCntr = -1;
var helpWindow = null;
var aboutWindow = null;
var sentinelWindow = null;

   function NoConfirm(){
       window.open('','_self','');
       window.close();
   }
   function logout()
   {
      if(confirm("Are you sure you want to logout?")) {
        document.LogoutForm.action = document.LogoutForm.action.replace(/logout/, "logoutfull");
        document.LogoutForm.submit();
      }
   }
   function callTimeout()
   {
      document.LogoutForm.submit();
   }

   function callHelp()
   {
      if (helpWindow && !helpWindow.closed)
           helpWindow.focus();
      else
           helpWindow = window.open(helpUrl, "Help");
   }

    function callManageAlert()
   {
    alert("Manage Page is under development");
   }
 

  
  function callAboutAlert()
  {
    //open the window
    if (aboutWindow && !aboutWindow.closed)
       aboutWindow.focus();
    else
       aboutWindow = window.open("jsp/SplashScreenAbout.jsp", "CurationTool", "width=900;height=600,top=0,left=0,resizable=yes,scrollbars=yes");
  }
  
  function callSentinel()
  {
      callSentinelJS("<%=sentinelURL%>");
  }
    
  function callUMLBrowser()
  {
      window.open("<%=UMLBrowserURL%>");
  }
  
  function callSentinelJS(serverName)
  {
         
       if (serverName != null && serverName != "")  
       {
//           serverName = serverName.toLowerCase();
           var cdeServer = serverName
            //open the window
	        if (sentinelWindow && !sentinelWindow.closed)
	          sentinelWindow.focus();
	        else
	          sentinelWindow = window.open(cdeServer);
       }
       else
           alert("Unable to determine the server name for the Sentinel Tool.");    
  } 
  
   function callMessageGifDENew()
   {
     document.Form1.submit();
   }

   function callMessageGifDETemplate()
   {
     document.Form4.hidMenuAction.value = "NewDETemplate";
     document.Form4.submit();
   }

   function callMessageGifDEVersion()
   {
     document.Form4.hidMenuAction.value = "NewDEVersion";
     document.Form4.submit();
   }

   function callMessageGifDECNew()
   {
     document.Form2.submit();
   }

   function callMessageGifDECTemplate()
   {
     document.Form4.hidMenuAction.value ="NewDECTemplate";
     document.Form4.submit();
   }

   function callMessageGifDECVersion()
   {
     document.Form4.hidMenuAction.value = "NewDECVersion";
     document.Form4.submit();
   }

   function callMessageGifVDNew()
   {
     document.Form3.submit();
   }

   function callMessageGifVDTemplate()
   {
     document.Form4.hidMenuAction.value = "NewVDTemplate";
     document.Form4.submit();
   }

   function callMessageGifVDVersion()
   {
     document.Form4.hidMenuAction.value = "NewVDVersion";
     document.Form4.submit();
   }

   function callMessageGifDEedit()
   {
     document.Form4.hidMenuAction.value = "editDE";
     document.Form4.submit();
   }

   function callMessageGifDECedit()
   {
  //   document.Form5.Message.style.visibility="visible";
     document.Form4.hidMenuAction.value = "editDEC";
     document.Form4.submit();
   }

   function callMessageGifVDedit()
   {
  //   document.Form5.Message.style.visibility="visible";
     document.Form4.hidMenuAction.value = "editVD";
     document.Form4.submit();
   }
   function BackToSearch(){
     <%String searchAC = (String) session.getAttribute("searchAC");
       if((searchAC).equals("ValueMeaning")){%>
         BackFromEditVM();
       <%}else{%>
         Back(); 
       <%}%>
   }

function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
// -->
//links to logos
var winNCI;
var winNCICB;
var wincaDSR;

function linkNCI()
{
  if (winNCI && !winNCI.closed)
     winNCI.focus();
  else
       winNCI = window.open("http://www.nci.nih.gov", "NCI", "width=680;height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function link_caDSR()
{
  if (wincaDSR && !wincaDSR.closed)
     wincaDSR.focus();
  else
       wincaDSR = window.open("http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr", "caDSR", "width=680;height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function linkNCICB()
{
  if (winNCICB && !winNCICB.closed)
     winNCICB.focus();
  else
       winNCICB = window.open("http://ncicb.nci.nih.gov", "NCICB", "width=680;height=680,resizable=yes,scrollbars=yes,titlebar=false");
}

</script>
	</head>

	<body bgcolor="#FFFFFF" text="#000000">
		<form name="Form1" method="post" action="../../cdecurate/NCICurationServlet?reqType=newDEFromMenu"></form>
		<form name="Form2" method="post" action="../../cdecurate/NCICurationServlet?reqType=newDECFromMenu"></form>
		<form name="Form3" method="post" action="../../cdecurate/NCICurationServlet?reqType=newVDFromMenu"></form>
		<form name="LogoutForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=logout"></form>
		<form name="Form4" method="post" action="../../cdecurate/NCICurationServlet?reqType=actionFromMenu">
		<input type="hidden" name="hidMenuAction" value="<%=StringEscapeUtils.escapeHtml(strNothing)%>"/>
		</form>
		<%
          String Username = (String)session.getAttribute("Username");
  		  //String Context = (String)session.getAttribute("sDefaultContext");
		%>
		<table width="100%" border="0">
			<col style="width: 1px" />
			<col />
			<tr bgcolor="#A90101">
				<td align="left">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="images/brandtype.gif" border="0" alt="NCI Logo">
					</a>
				</td>
				<td align="right">
					<a href="http://www.cancer.gov" target=_blank>
						<img src="images/tagline_nologo.gif" border="0" alt="no logo">
					</a>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="padding:0 0 0 0">
					<a target="_blank" href="http://ncicb.nci.nih.gov/NCICB/infrastructure/cacore_overview/cadsr">
						<img src="images/curation_banner2.gif" border="0" alt="caDSR Logo">
					</a>
				</td>
			</tr>
		</table>
		<table style="border-collapse: collapse; width: 100%;">
			<col style="width: 2.3in" />
			<col />
			<tr>
				<td style="padding:0.05in 0 0 0">
					<%if (Username != null) { %>
					User&nbsp;Name&nbsp;:&nbsp;
					<%=StringEscapeUtils.escapeHtml(Username)%>
					<%} else { %>
					<a href="<%=request.getContextPath() %>/jsp/LoginE.jsp">Login</a>
					<%} %>
				</td>
				<td style="padding:0.05in 0 0 0">
					<script webstyle3>document.write('<scr'+'ipt src="js/xaramenu.js">'+'</scr'+'ipt>');document.write('<scr'+'ipt src="js/biztech_button.js">'+'</scr'+'ipt>');/*img src="images/biztech_button.gif" moduleid="myzara                     (project)\biztech_button_off.xws"*/</script>
				</td>
			</tr>
		</table>
	</body>
</html>
