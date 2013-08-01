<%--L
  Copyright ScenPro Inc, SAIC-F

  Distributed under the OSI-approved BSD 3-Clause License.
  See http://ncip.github.com/cadsr-cdecurate/LICENSE.txt for details.
L--%>

<!-- Copyright (c) 2006 ScenPro, Inc.
    $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/jsp/DesignateComponent.jsp,v 1.4 2009-04-21 03:47:35 hegdes Exp $
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
		
		<SCRIPT LANGUAGE="JavaScript" SRC="js/HelpFunctions.js">
		 var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
				
		</SCRIPT>
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
      if ((opener.document != null) && (opener.document.searchResultsForm.hiddenDesIDName.length < 2))
          designateForm.txtDesignationName.value = opener.document.searchResultsForm.hiddenDesIDName[0].value;
      if (opener.document.searchResultsForm.actSelected.value == "blockDesignate")
          document.designateForm.btnDesignate.value  = "Block Designate";
      else
          document.designateForm.btnDesignate.value  = "Create Designation";

      //disable the undesignate button if more than one is selected.
      if (opener.document.searchResultsForm.hiddenDesIDName.length > 1)
          document.designateForm.btnUnDesignate.disabled = true;
          
      //disable the undesignate button if no used by context for the selected DE
      var vUsedBy = opener.document.searchResultsForm.hiddenDesIDName[0].text;
      if (vUsedBy == null || vUsedBy == "")
          document.designateForm.btnUnDesignate.disabled = true;
      
      designateForm.selContext.focus();
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
				<col width="29%">
				<col width="25%">
				<col width="44%">
				<tr valign="top">
					<td colspan=4>
						<b>
							<font size=4>
								Designate Data Element(s)/Alternate Name(s)/Reference Document(s)
							</font>
						</b>
					</td>
				</tr>
				<tr height="50">
					<td align="center">
						<font color="#FF0000">
							*
						</font>
					</td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Used By Context
					</td>
					<td colspan=2>
						<select name="selContext" size="1" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
							<%        boolean bDataFound = false;
          for (int i = 0; vContext.size()>i; i++)
          {
             String sContextName = (String)vContext.elementAt(i);
             String sContextID = (String)vContextID.elementAt(i);
             //if(sContext.equals("")) sContext = sContextName;
             if(sContextName.equals(sContext)) bDataFound = true;
%>
							<option value="<%=StringEscapeUtils.escapeHtml(sContextID)%>" <%if(sContextName.equals(sContext)){%> selected <%}%>>
								<%=StringEscapeUtils.escapeHtml(sContextName)%>
							</option>
							<%
          }
          if (bDataFound == false) { %>
							<option value="" selected></option>
							<%        } %>
						</select>
					</td>
				</tr>
				<tr>
					<td align="center"></td>
					<td>
						Data Element Long Name
					</td>
					<td colspan=2>
						<input name="txtDesignationName" type="text" value="" style="width:85%" readonly onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
					</td>
				</tr>
				<tr height="40" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Type
					</td>
					<td align="left">
						<input name="rType" type="radio" value="altName" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						Alternate Name
					</td>
					<td align="left">
						<input name="rType" type="radio" value="refDoc" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						Reference Documents
					</td>
				</tr>
				<tr height="35" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Alternate Name Type
					</td>
					<td colspan=2>
						<select name="selAltType" size="1" style="width:65%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
							<option value=""></option>
							<option value="C3DName">
								C3DName
							</option>
						</select>
					</td>
				</tr>
				<tr valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Enter
						</font>
						Alternate Name
					</td>
					<td colspan=2>
						<textarea name="txtAltName" style="width:85%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr height="40" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Select
						</font>
						Reference Document Type
					</td>
					<td colspan=2>
						<select name="selRefType" size="1" style="width:65%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
							<option value=""></option>
							<option value="Long_Name">
								LONG NAME
							</option>
						</select>
					</td>
				</tr>
				<tr height="40" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Enter
						</font>
						Reference Document Name
					</td>
					<td colspan=2>
						<textarea name="txtRefName" style="width:85%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr height="40" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Enter
						</font>
						Reference Document Text
					</td>
					<td colspan=2>
						<textarea name="txtRefText" style="width:85%" rows=2 onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false"></textarea>
					</td>
				</tr>
				<tr height="40" valign="middle">
					<td align="center"></td>
					<td>
						<font color="#FF0000">
							Enter
						</font>
						Reference Document URL
					</td>
					<td colspan=2 width="100%">
						<input name="txtRefURL" type="text" value="" style="width:85%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						&nbsp;&nbsp;
						<a href="">
							Search
						</a>
					</td>
				</tr>
				<!-- <tr><td height="7" valign="top"></tr>    -->
				<tr height="30" valign="middle">
					<td align="left" colspan=2>
						&nbsp;
					</td>
					<td align="left" colspan=2>
						<input type="button" name="btnAddAltName" value="Add Selection" onClick="addAltName();">
					</td>
				</tr>
				<tr>
					<td height="12" valign="top">
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td align="left">
						Selected Type
					</td>
					<td align="left">
						&nbsp;Name
					</td>
					<td align="center">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="button" name="btnRemAltName" value="Remove Item" onClick="removeAltName();">
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td align="left">
						<select name="selNameType" size="4" multiple="multiple" style="width:100%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						</select>
					</td>
					<td align="left" colspan="2">
						<select name="selName" size="4" multiple="multiple" style="width:90%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						</select>
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td align="left">
						Selected Doc Text
					</td>
					<td align="left">
						&nbsp;URL
					</td>
				</tr>
				<tr>
					<td align="left">
						&nbsp;
					</td>
					<td align="left">
						<select name="selDocText" size="4" multiple="multiple" style="width:100%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						</select>
					</td>
					<td align="left" colspan="2">
						<select name="selURL" size="4" multiple="multiple" style="width:90%" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						</select>
					</td>
				</tr>
				<tr>
					<td height="12" valign="top">
				</tr>
				<tr>
					<td colspan=4 align="center">
						<input type="button" name="btnDesignate" value="Create Designation" onClick="CreateDesignation();" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnUnDesignate" value="Remove Designation" onClick="RemoveDesignation();" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
						&nbsp;&nbsp;
						<input type="button" name="btnClose" value="Close Window" onClick="window.close();" onHelp="showHelp('html/Help_DesignateAC.html#designateForm_DesignateComponentPage',helpUrl); return false">
					</td>
				</tr>
				<!-- stores selected component ID and workflow status  -->
				<select size="1" name="hiddenUsedBy" style="visibility:hidden;"></select>
			</table>
		</form>
	</body>
</html>
