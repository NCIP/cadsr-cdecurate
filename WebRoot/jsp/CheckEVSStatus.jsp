<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.*"%>
<%@ page import="gov.nih.nci.cadsr.common.*"%>
<%
    //GF32723 final user selected defs
    String evsDone =
    //"true";
    (String)session.getAttribute(Constants.DEC_EVS_LOOKUP_FLAG);
    System.out.print("CheckEVSStatus invoked ...");
%>
    <%= evsDone %>
<%
    System.out.print("1 CheckEVSStatus evsDone = [" + evsDone + "] done.");
%>