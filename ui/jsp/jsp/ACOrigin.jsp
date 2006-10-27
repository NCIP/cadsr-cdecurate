
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>
			List of Origins
		</title>

		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="FullDesignArial.css" rel="stylesheet" type="text/css">
		<%@ page import="java.text.*"%>
		<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
		<%
			Vector vSource = (Vector) session.getAttribute("vSource");
      if (vSource == null) vSource = new Vector();
    %>
    
		<Script Language="JavaScript">
			function appendOrigin(src)
			{
				var success = false;
				var curelm;
				if (opener != null && opener.document != null)
				{
					var curelmInd = opener.document.getElementById("currentElmID");
					if (curelmInd != null)
					{
						curelm = curelmInd.value;
						if (curelm != null && curelm != "")
						{
							if (curelm == "allOrigin")
							{
								opener.changeAll(curelm, src);
								success = true;
							}
							else
							{
									var curPV = opener.document.getElementById("currentPVInd");
									opener.changeElementText(curPV, curelm, false, src, "replace");
									success = true;
									if (curPV != null && curPV.value != null)
										opener.document.getElementById("editPVInd").value = curPV.value;
										
									opener.document.getElementById("currentOrg").value = src;
							 }
						}
					}
				}
				if (success == false)
					alert(curelm + " Unable to append the Origin for the selected Permissible Value " + src);
				
				//close the window
				window.close();
			}
		</SCRIPT>    
	</head>

	<body>
		<p>
			<font size=4>Select<font color="#FF0000">	Origin</font>
			</font>
		</p>
		<table border="1">
			<tr>
				<th>Action</th>
				<th>Origin Name</th>
			</tr>
			<%
				for (int i=0; i<vSource.size(); i++)
				{
					String src = (String)vSource.elementAt(i);
					if (src == null) src = "";
			%>
			<tr>
				<td>
					<a href="javascript:appendOrigin('<%=src%>');">
						<img src="../../cdecurate/Assets/select.gif" border="0" alt="Select to use">
					</a>
				</td>
				<td>
					<%=src%>
				</td>
			</tr>
			<% } %>
		</table>
	</body>
</html>
