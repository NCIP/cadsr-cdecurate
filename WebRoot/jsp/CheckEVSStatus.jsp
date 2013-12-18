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
    String evsMatchedCount =
    (String)session.getAttribute(Constants.DEC_EVS_MATCHED_COUNT);
    System.out.print("CheckEVSStatus invoked ...");
%>
{
    'status': <%= evsDone %>,
    'matchedCount': <%= evsMatchedCount %>
}
<%
    System.out.print("2 CheckEVSStatus evsDone = [" + evsDone + "] evsMatchedCount [" + evsMatchedCount + "] done.");
%>