<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/CreateCDAltName.jsp,v 1.4 2009-04-21 03:47:36 hegdes Exp $
    $Name: not supported by cvs2svn $
-->

<%@ page import="java.util.*"%>
<%@ page session="true"%>
<html>
	<head>
		<title>
			Designate Administered Component / Specify Alternate Name
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="css/FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.Session_Data"%>
		<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
		
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js"></SCRIPT>
		<%
  String sSearchAC = "";
  String sMenuAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
  if (sMenuAction.equals("searchForCreate"))
     sSearchAC = (String)session.getAttribute("creSearchAC");
  else
     sSearchAC = (String)session.getAttribute("searchAC");

  Vector vContext = new Vector();
  Vector vContextID = new Vector();
  if (sSearchAC.equals("DataElement"))
  {
     vContext = (Vector)session.getAttribute("vWriteContextDE");
     vContextID = (Vector)session.getAttribute("vWriteContextDE_ID");
  }
  else if (sSearchAC.equals("DataElementConcept"))
  {
     vContext = (Vector)session.getAttribute("vWriteContextDEC");
     vContextID = (Vector)session.getAttribute("vWriteContextDEC_ID");
  }
  else if (sSearchAC.equals("ValueDomain"))
  {
     vContext = (Vector)session.getAttribute("vWriteContextVD");
     vContextID = (Vector)session.getAttribute("vWriteContextVD_ID");
  }

   String sContext = (String)session.getAttribute("sDefaultContext");
   if (sContext == null) sContext = "";
%>

		<Script Language="JavaScript">
   function Setup()
   {
     
   }

   function CreateDesignation()
   {
      var desContext = document.designateForm.selContext.options[document.designateForm.selContext.selectedIndex].text;
      var desContextID = document.designateForm.selContext.options[document.designateForm.selContext.selectedIndex].value;
      var desName = document.designateForm.txtDesignationName.value;

      if (desContext == "")
         alert("Please select a context from the dropdown list");
      else
      {
          //store the values in opener document
         //opener.document.searchResultsForm.desName.value = desName;
         opener.document.searchResultsForm.desContext.value = desContext;
         opener.document.searchResultsForm.desContextID.value = desContextID;

         //display wait message while submitting.
         opener.document.body.style.cursor = "wait";
         window.status = "Submitting the page, it may take a minute, please wait....."
         opener.document.searchResultsForm.Message.style.visibility="visible";

         //submit the opener document
         //opener.document.searchResultsForm.actSelected.value = "createDesignate";
         opener.document.searchResultsForm.submit();

         //close this window
         window.close();
      }
   }
   function RemoveDesignation()
   {
      var vUsedBy = opener.document.searchResultsForm.hiddenDesIDName[0].text;
      var desContext = document.designateForm.selContext.options[document.designateForm.selContext.selectedIndex].text;
      var desContextID = document.designateForm.selContext.options[document.designateForm.selContext.selectedIndex].value;
      if (desContext == "")
         alert("Please select a context from the dropdown list");
      else
      {
        if (vUsedBy != "")
        {
           var isValid = false;
           var ArrayUsedby = vUsedBy.split(",");
           for (var idx = 0; idx<ArrayUsedby.length; idx++)
           {
              var thisContext = Trim(ArrayUsedby[idx]);
              //thisContext = thisContext.trim();
              if (thisContext == desContext)
              {
                 isValid = true;
                 break;
              }
           }

           if (isValid == false)
              alert("The selected item is not currently designated to the context of " +
                  desContext + ".\n Please select a different context from the dropdown list.");
           else
           {
                 opener.document.searchResultsForm.desContext.value = desContext;
                 opener.document.searchResultsForm.desContextID.value = desContextID;

                 //display wait message while submitting.
                 opener.document.body.style.cursor = "wait";
                 window.status = "Submitting the page, it may take a minute, please wait....."
                 opener.document.searchResultsForm.Message.style.visibility="visible";

                 //submit the opener document
                 opener.document.searchResultsForm.actSelected.value = "deleteDesignate";
                 opener.document.searchResultsForm.submit();

                 //close this window
                 window.close();
            }
         }
      }
   }

   /**********************************************************************
   //  adds newly selected alternate type and text to the selected type and name box
   //********************************************************************/
   function addAltName()
   {
      alert("adding type and text");
   }

   /**********************************************************************
   //  removes selected alternate type and text from the selected type and name box
   //********************************************************************/
   function removeAltName()
   {
      alert("removing type and text");
   }

   /**********************************************************************
   //  LTrim(str)
   //     Returns the string with whitespace trimmed from the beginning.
   //********************************************************************/
   function LTrim(str)
   {
   	if (str == null)
         {return null;}
   	for (var i = 0; str.charAt(i) == " "; i++);
      	return str.substring(i,str.length);
   }

   /**********************************************************************
   //  RTrim(str)
   //     Returns the string with whitespace trimmed from the end.
   //********************************************************************/
   function RTrim(str)
   {
   	if (str==null)
         {return null;}
   	for(var i = str.length-1; str.charAt(i) == " "; i--);
      	return str.substring(0,i+1);
   }

   /**********************************************************************
   //  Trim(str)
   //     Returns the string with whitespace trimmed from the beginning
   //     and end.
   //********************************************************************/
   function Trim(str)
      {return LTrim(RTrim(str));}

</script>

	</head>

	<body onLoad="Setup();">

		<form name="designateForm" method="post">
			<table width="100%" cellspacing=0 cellpadding=0 border="0">
				<col width="2%">
				<col width="36%">
				<col width="45%">
				<col width="10%">
				<tr valign="top" height="50" align="center">
					<td colspan=4>
						<b>
							<font size=4>
								Specify Conceptual Domain Alternate Name(s)
							</font>
						</b>
					</td>
				</tr>
				<tr height="75">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Alternate Name Type
					</td>
					<td colspan=2>
						<select name="entAltnameType" size="1" style="width:90%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
							<option value="EVS_NODE">
								EVS_NODE
							</option>
							<option value="EVS_VOCABULARY">
								EVS_VOCABULARY
							</option>
							<option value="caDSR_DOCUMENT">
								caDSR_DOCUMENT
							</option>
							<option value="EXTERNAL_LIST">
								EXTERNAL_LIST
							</option>
						</select>
					</td>
				</tr>
				<tr height="75">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Option 1
						</font>
						Select Node From An EVS Tree (Use Case 2a, 2b)
					</td>
					<td>
						&nbsp;&nbsp;&nbsp;
						<a href="javascript:searchType('tree');">
							Tree Search
						</a>
					</td>
				</tr>
				<tr height="75">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Option 2
						</font>
						Select Name Of EVS Vocabulary (Use Case 3a)
					</td>
					<td colspan=2>
						<select name="selEvsVocab" size="1" style="width:90%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
							<option value="C3DName">
								Thesaurus
							</option>
							<option value="C3DName">
								GO
							</option>
							<option value="C3DName">
								LOINC
							</option>
							<option value="C3DName">
								VA NDFRT
							</option>
							<option value="C3DName">
								UWD Visual Anatomist
							</option>
							<option value="C3DName">
								MGED
							</option>
						</select>
					</td>
				</tr>
				<tr height="75" valign="top">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Option 3
						</font>
						Select Name Of Non-Evs Vocabulary (Use Case 3b)
					</td>
					<td valign="top" colspan=2>
						<textarea name="txtNonEvsVocab" style="width:90%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr height="75" valign="top">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Option 4
						</font>
						Enter Name Of caDSR Document (Use Case 3c)
					</td>
					<td valign="top" colspan=2>
						<textarea name="txtExternalList" style="width:90%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr height="75" valign="top">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Option 5
						</font>
						Enter Name Of External List (Use Case 3d)
					</td>
					<td valign="top" colspan=2>
						<textarea name="txtExternalList" style="width:90%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr>
					<td height="12" valign="top">
				</tr>
				<tr>
					<td align="left" colspan=2>
						<input type="button" name="btnClose" value="Close Window" onClick="javascript:window.close();">
					</td>
					<td align="left" colspan=2>
						<input type="button" name="btnAddAltName" value="Create Alternate Name" onClick="addAltName();">
					</td>
				</tr>
				<!-- stores selected component ID and workflow status  -->
				<select size="1" name="hiddenUsedBy" style="visibility:hidden;"></select>
			</table>
		</form>
	</body>
</html>
