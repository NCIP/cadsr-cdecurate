<html>
<head>
<title>TitleBar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<% String thisServer2 = request.getServerName(); %>
<script language="JavaScript">
<!--
var dotCntr = -1;
var helpWindow = null;
var aboutWindow = null;
var sentinelWindow = null;

   function callLogout()
   {
      if(confirm("Are you sure you want to logout?"))
        document.LogoutForm.submit();
   }

   function callHelp()
   {
      if (helpWindow && !helpWindow.closed)
       	helpWindow.focus();
      else
       	helpWindow = window.open("Help.htm", "Help", "width=750,height=620,top=0,left=0,resizable=yes,scrollbars=yes,titlebar=false");
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
       aboutWindow = window.open("jsp/SplashScreenAbout.jsp", "CurationTool", "width=900,height=600,top=0,left=0,resizable=yes,scrollbars=yes");
  }
  
  function callSentinel()
  {
      callSentinelJS("<%=thisServer2%>");
  }
  
  
  function callSentinelJS(serverName)
  {
	   if (serverName != null && serverName != "")  

	   {
		   serverName = serverName.toLowerCase();
       var cdeServer = serverName;   //defaults to curation tool server
       if (serverName == "localhost")
          cdeServer = "biotite.scenpro.net:8080";
       else if (serverName == "protocol.scenpro.net")
          cdeServer = "protocol.scenpro.net:8080/DSRAlert/do/logon";
       else if (serverName == "ncicb-dev.nci.nih.gov" || serverName == "cdecurate-dev.nci.nih.gov")
          cdeServer = "ncicb-dev.nci.nih.gov/cadsrsentinel"; 
       else if (serverName == "ncicb-qa.nci.nih.gov" || serverName == "cdecurate-qa.nci.nih.gov")
          cdeServer = "ncicb-qa.nci.nih.gov/cadsrsentinel";
       else if (serverName == "ncicb-stage.nci.nih.gov" || serverName == "cdecurate-stage.nci.nih.gov")
          cdeServer =  "cadsrsentinel-stage.nci.nih.gov/";   //"ncicb-stage.nci.nih.gov/cadsrsentinel";
       else if (serverName == "ncicb.nci.nih.gov" || serverName == "cdecurate.nci.nih.gov")
          cdeServer = "cadsrsentinel.nci.nih.gov/"; //"ncicb-nci.nih.gov/cadsrsentinel";
		    //open the window
        if (sentinelWindow && !sentinelWindow.closed)
          sentinelWindow.focus();
        else
          sentinelWindow = window.open("http://" + cdeServer);
        //  sentinelWindow = window.open("http://" + cdeServer + "/DSRAlert/DSRAlert/cdecuration", "_blank");
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
     document.Form4.hidMenuAction.value = "NewDECTemplate";
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
   	winNCI = window.open("http://www.nci.nih.gov", "NCI", "width=680,height=680,resizable=yes,scrollbars=yes,titlebar=false");
}
function link_caDSR()
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

</script>
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="Form1" method="post" action="/cdecurate/NCICurationServlet?reqType=newDEFromMenu"></form>
<form name="Form2" method="post" action="/cdecurate/NCICurationServlet?reqType=newDECFromMenu"></form>
<form name="Form3" method="post" action="/cdecurate/NCICurationServlet?reqType=newVDFromMenu"></form>
<form name="LogoutForm" method="post" action="/cdecurate/NCICurationServlet?reqType=logout"></form>
<form name="Form4" method="post" action="/cdecurate/NCICurationServlet?reqType=actionFromMenu">
<input type="hidden" name="hidMenuAction" value="nothing">
</form>
<%
    String Username = (String)session.getAttribute("Username");
    String Context = (String)session.getAttribute("sDefaultContext");
%>
<div id="Layer3" style="position:absolute; width:575px; height:44px; z-index:1; left: 222px; top: 75px"> 
  <script webstyle3>document.write('<scr'+'ipt src="Assets/xaramenu.js">'+'</scr'+'ipt>');document.write('<scr'+'ipt 				src="Assets/biztech_button.js">'+'</scr'+'ipt>');/*img src="Assets/biztech_button.gif" moduleid="myzara 					(project)\biztech_button_off.xws"*/</script>
	</div>

<div id="Layer5" style="position:absolute; width:153px; height:17px; z-index:4; left: 42px; top: 75px; font-size:12px">
  <!-- Context: <%=Context%>--> <br>
  User Name : <%=Username%> </div> 

<div id="Layer4" style="position:absolute; z-index:5; left: 19px; top: 22px;; width: 600px; height: 21px">
  <img width="850"; height="50" src="Assets/curation_banner2.gif" name="InternalMap" border="0" usemap="#InternalMap" id="InternalMap">
  <map name="InternalMap" >
    <area shape="rect" coords="1,1,80,50" onClick = "linkNCI();" >
    <area shape="rect" coords="80,1,180,50" onClick = "link_caDSR();" >
  </map>
</div>
</body>
</html>
