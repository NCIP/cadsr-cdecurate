<%@ page import="gov.nih.nci.cadsr.cdecurate.tool.*"%>
<%@ page import="gov.nih.nci.cadsr.cdecurate.util.ToolURL"%>
<%@ page import="java.util.*"%>
<%@ page session="true"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@taglib uri="/WEB-INF/tld/curate.tld" prefix="curate"%>
<%
	UtilService util = new UtilService();
	Vector vSelectedAttr = new Vector();
	Vector vStatus = new Vector();
	Vector vContext = new Vector();
	Vector vDocs = new Vector();
	Vector vACAttr = new Vector();
	String sMenuAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
	String sInitiatedFrom = (String) session.getAttribute("initiatedFrom");
	String sLastKeyword, sSearchIn, sContextUse = "", sContext = "";
	String sCreatedFrom = "", sCreatedTo = "", sModifiedFrom = "", sModifiedTo = "";
	String sCreator = "", sModifier = "", sRegStatus = "", sDerType = "", sDataType = "";
	String selCD = "", sProtoKeyword = "", sUIFilter = "simple", sVersion = "", txVersion = "";
	String sSearchAC = "";
	String typeEnum = "", typeNonEnum = "", typeRef = "";
	Vector vMultiContext = (Vector) session.getAttribute("multiContextAC");
	//gets the session attributes for action searchForCreate
	if (sMenuAction.equals("searchForCreate")) {
		sSearchAC = (String) session.getAttribute("creSearchAC"); //done now in CDEHomePage
		//System.out.println("search parameters jsp sfc sSearchAC: "+ sSearchAC);
		sLastKeyword = (String) session.getAttribute("creKeyword");
		sContext = (String) session.getAttribute("creContext");
		vContext = (Vector) session.getAttribute("creMultiContext");
		sContextUse = (String) session.getAttribute("creContextUse");
		vStatus = (Vector) session.getAttribute("creStatus");
		vSelectedAttr = (Vector) session.getAttribute("creSelectedAttr");
		vACAttr = (Vector) session.getAttribute("creAttributeList");
		selCD = (String) session.getAttribute("creSelectedCD");
		sSearchIn = (String) request.getAttribute("creSearchIn");
		sRegStatus = (String) session.getAttribute("creRegStatus");
		sDerType = (String) session.getAttribute("creDerType");
		sDataType = (String) session.getAttribute("creDataType");
		sVersion = (String) session.getAttribute("creVersion");
		txVersion = (String) session.getAttribute("creVersionNum");
		vDocs = (Vector) session.getAttribute("creDocTyes");
		typeEnum = (String) session.getAttribute("creVDTypeEnum");
		typeNonEnum = (String) session.getAttribute("creVDTypeNonEnum");
		typeRef = (String) session.getAttribute("creVDTypeRef");
		sUIFilter = (String) session.getAttribute("creUIFilter");
		if (sUIFilter == null)
			sUIFilter = "simple";
		if (sUIFilter.equals("advanced")) {
			sCreatedFrom = (String) session.getAttribute("creCreatedFrom");
			sCreatedTo = (String) session.getAttribute("creCreatedTo");
			sModifiedFrom = (String) session.getAttribute("creModifiedFrom");
			sModifiedTo = (String) session.getAttribute("creModifiedTo");
			sCreator = (String) session.getAttribute("creCreator");
			sModifier = (String) session.getAttribute("creModifier");
		}
	} else //gets the session attributes for all other searches
	{
		sSearchAC = (String) session.getAttribute("searchAC"); //done now in CDEHomePage
		//System.out.println("search parameters else jsp sSearchAC: "	+ sSearchAC);
		sLastKeyword = (String) session.getAttribute("serKeyword");
		sProtoKeyword = (String) session.getAttribute("serProtoID");
		sContext = (String) session.getAttribute("serContext");
		vContext = (Vector) session.getAttribute("serMultiContext");
		sContextUse = (String) session.getAttribute("serContextUse");
		vStatus = (Vector) session.getAttribute("serStatus");
		vSelectedAttr = (Vector) session.getAttribute("selectedAttr");
		//System.out.println("Selected Attributes size: "	+ vSelectedAttr.size());
		vACAttr = (Vector) session.getAttribute("serAttributeList");
		//System.out.println("vACAttr: " + vACAttr.size());
		selCD = (String) session.getAttribute("serSelectedCD");
		sSearchIn = (String) session.getAttribute("serSearchIn");
		sRegStatus = (String) session.getAttribute("serRegStatus");
		sDerType = (String) session.getAttribute("serDerType");
		sDataType = (String) session.getAttribute("serDataType");
		sVersion = (String) session.getAttribute("serVersion");
		txVersion = (String) session.getAttribute("serVersionNum");
		vDocs = (Vector) session.getAttribute("serDocTyes");
		typeEnum = (String) session.getAttribute("serVDTypeEnum");
		typeNonEnum = (String) session.getAttribute("serVDTypeNonEnum");
		typeRef = (String) session.getAttribute("serVDTypeRef");
		sUIFilter = (String) session.getAttribute("serUIFilter");
		//get these attributes only if advanced filter
		if (sUIFilter == null)
			sUIFilter = "simple";
		if (sUIFilter.equals("advanced")) {
			sCreatedFrom = (String) session.getAttribute("serCreatedFrom");
			sCreatedTo = (String) session.getAttribute("serCreatedTo");
			sModifiedFrom = (String) session.getAttribute("serModifiedFrom");
			sModifiedTo = (String) session.getAttribute("serModifiedTo");
			sCreator = (String) session.getAttribute("serCreator");
			sModifier = (String) session.getAttribute("serModifier");
		}
	}
	if (selCD == null)
		selCD = "All Domains";
	//searches data element if searchAC is not set
	if (sSearchAC == null)
		sSearchAC = "DataElement";
	//gets the searchin attribute, defaults to longName if none
	if (sSearchIn == null)
		sSearchIn = "longName";
	
	//expands the searchAC for displaying in the dropdown list.
	String sLongAC = "";
	if (sSearchAC.equals("DataElement"))
		sLongAC = "Data Element";
	else if (sSearchAC.equals("DataElementConcept"))
		sLongAC = "Data Element Concept";
	else if (sSearchAC.equals("ValueDomain"))
		sLongAC = "Value Domain";
	else if (sSearchAC.equals("ConceptualDomain"))
		sLongAC = "Conceptual Domain";
	else if (sSearchAC.equals("PermissibleValue"))
		sLongAC = "Permissible Value";
	else if (sSearchAC.equals("Questions"))
		sLongAC = "CRF Questions";
	else if (sSearchAC.equals("ValueMeaning"))
		sLongAC = "Value Meaning";
	else
		sLongAC = sSearchAC;

	if (sLastKeyword == null)
		sLastKeyword = "";
	sLastKeyword = util.parsedStringDoubleQuoteJSP(sLastKeyword);
	sLastKeyword = sLastKeyword.trim();
	if (sProtoKeyword == null)
		sProtoKeyword = "";
	sProtoKeyword = util.parsedStringDoubleQuoteJSP(sProtoKeyword);
	sProtoKeyword = sProtoKeyword.trim();
	//get the search result records
	String sBack = (String) session.getAttribute("backFromGetAssociated");
	if (sBack == null)
		sBack = "";
	Vector vSerResult = (Vector) session.getAttribute("results");
	boolean hasRecords = false;
	if ((vSerResult != null && vSerResult.size() > 0) || sBack.equals("backFromGetAssociated"))
		hasRecords = true;
	String updFunction = "displayAttributes('" + hasRecords + "');";

	if (vContext == null)
		vContext = new Vector();
	if (sContext == null)
		sContext = "AllContext";
	if (sContextUse == null || sContextUse == "")
		sContextUse = "BOTH";
	// if (sSearchIn.equals("CRFName")) sContextUse = "OWNED_BY";
	if (sVersion == null || sVersion == "")
		sVersion = "Yes"; //"All";
	if (!sVersion.equals("Other"))
		txVersion = "";

	if (sCreatedFrom == null)
		sCreatedFrom = "";
	if (sCreatedTo == null)
		sCreatedTo = "";
	if (sCreator == null)
		sCreator = "allUsers";
	if (sModifiedFrom == null)
		sModifiedFrom = "";
	if (sModifiedTo == null)
		sModifiedTo = "";
	if (sModifier == null)
		sModifier = "allUsers";
	Vector vContextAC = (Vector) session.getAttribute("vContext");
	Vector vStatusDE = (Vector) session.getAttribute("vStatusDE");
	Vector vStatusDEC = (Vector) session.getAttribute("vStatusDEC");
	Vector vStatusVD = (Vector) session.getAttribute("vStatusVD");
	Vector vStatusVM = (Vector) session.getAttribute("vStatusVM");
	Vector vStatusCD = (Vector) session.getAttribute("vStatusCD");
	Vector vRegStatus = (Vector) session.getAttribute("vRegStatus");
	Vector vDerType = (Vector) session.getAttribute("vRepType");
	Vector vDataType = (Vector) session.getAttribute("vDataType");
	Vector vUsers = (Vector) session.getAttribute("vUsers");
	Vector vUsersName = (Vector) session.getAttribute("vUsersName");
	Vector vDocType = (Vector) session.getAttribute("vRDocType");
	//filter by cs for csi search
	Vector vCS = (Vector) session.getAttribute("vCS");
	Vector vCS_ID = (Vector) session.getAttribute("vCS_ID");
	String selCS = (String) session.getAttribute("selCS");
	//filter by cd for value meaning search
	Vector vCD = (Vector) session.getAttribute("vCD");
	Vector vCD_ID = (Vector) session.getAttribute("vCD_ID");
	String sAppendAction = (String) session.getAttribute("AppendAction");
	String sAssocSearch = (String) request.getAttribute("GetAssocSearchAC");
	if (sAssocSearch == null)
		sAssocSearch = "";
	if (sAssocSearch.equals("true")) {
		sUIFilter = "simple";
		sSearchIn = "";
		sContext = "AllContext";
		sContextUse = "BOTH";
		sVersion = "All";
		selCD = "All Domains";
	}
	String temp = (String) session.getAttribute("UnqualifiedsearchDE");
	String temp1 = (String) session.getAttribute("UnqualifiedsearchDEC");
	String temp2 = (String) session.getAttribute("UnqualifiedsearchCSI");
	String temp3 = (String) session.getAttribute("UnqualifiedsearchCD");
	String temp4 = (String) session.getAttribute("UnqualifiedsearchVD");
	String temp5 = (String) session.getAttribute("UnqualifiedsearchPV");
	String temp6 = (String) session.getAttribute("UnqualifiedsearchVM");
	String temp7 = (String) session.getAttribute("UnqualifiedsearchOC");
	String temp8 = (String) session.getAttribute("UnqualifiedsearchCC");
	String temp9 = (String) session	.getAttribute("UnqualifiedsearchProp");
	//System.out.println(temp + " " + temp1 + " " + temp2 + " " + temp3 + " ");
   //mm
	UtilService serUtil = new UtilService();
	//capture the duration
	Date sDate = new Date();
	//  logger.info(serUtil.makeLogMessage(session, "SearchResults", "begin page", sDate, sDate));
    String strInitiatedFrom = (String) session.getAttribute("initiatedFrom");
	Vector results = new Vector();
	results = (Vector) session.getAttribute("results");
	if (results == null)
		results = new Vector();
	String sSelAC = "";
	//store these to get data for the checked row.
	Vector vSearchID = (Vector) session.getAttribute("SearchID");
	if (vSearchID == null)
		vSearchID = new Vector();
	int numRows = 0;
	if (vSearchID.size() > 0)
		numRows = vSearchID.size();
	Vector vSearchName = (Vector) session.getAttribute("SearchName");
	if (vSearchName == null)
		vSearchName = new Vector();
	Vector vSearchLongName = (Vector) session.getAttribute("SearchLongName");
	if (vSearchLongName == null)
		vSearchLongName = new Vector();
	Vector vSearchASL = (Vector) session.getAttribute("SearchASL");
	if (vSearchASL == null)
		vSearchASL = new Vector();
	Vector vSearchDefinitionAC = (Vector) session.getAttribute("SearchDefinitionAC");
	if (vSearchDefinitionAC == null)
		vSearchDefinitionAC = new Vector();
	Vector vSearchDefSource = (Vector) session.getAttribute("SearchDefSource");
	if (vSearchDefSource == null)
		vSearchDefSource = new Vector();
	Vector vSearchUsedContext = (Vector) session.getAttribute("SearchUsedContext");
	if (vSearchUsedContext == null)
		vSearchUsedContext = new Vector();
	Vector vSearchMeanDescription = (Vector) session.getAttribute("SearchMeanDescription");
	if (vSearchMeanDescription == null)
		vSearchMeanDescription = new Vector();

	//get the list of contexts to write for all three components
	Vector vWriteContextDE = (Vector) session
			.getAttribute("vWriteContextDE");
	if (vWriteContextDE == null)
		vWriteContextDE = new Vector();
	Vector vWriteContextDEC = (Vector) session.getAttribute("vWriteContextDEC");
	if (vWriteContextDEC == null)
		vWriteContextDEC = new Vector();
	Vector vWriteContextVD = (Vector) session.getAttribute("vWriteContextVD");
	if (vWriteContextVD == null)
		vWriteContextVD = new Vector();

	//empty the alternate name and ref doc results from the session
	session.setAttribute("AllAltNameList", new Vector());
	session.setAttribute("AllRefDocList", new Vector());
	
	String sKeyword, nRecs;
	Vector vSelAttr = new Vector();
	Vector vCheckList = new Vector();
	String sMAction = (String) session.getAttribute(Session_Data.SESSION_MENU_ACTION);
	String sButtonPressed = (String) session.getAttribute("LastMenuButtonPressed");
	if (sButtonPressed == null)
		sButtonPressed = "undefined";
	//get the session attributes according searching from Menu or create page
	if (sMAction.equals("searchForCreate")) {
		sKeyword = (String) session.getAttribute("creKeyword");
		nRecs = (String) session.getAttribute("creRecsFound");
		sSelAC = (String) session.getAttribute("creSearchAC"); //done now in CDEHomePage
		vSelAttr = (Vector) session.getAttribute("creSelectedAttr");
		vCheckList = (Vector) session.getAttribute("creCheckList");
		session.setAttribute("creCheckList", new Vector()); //to avoid keep it selected make it empty only for searh window right now.
	} else {
		sKeyword = (String) session.getAttribute("serKeyword");
		sSelAC = (String) session.getAttribute("searchAC"); //done now in CDEHomePage
		nRecs = (String) session.getAttribute("recsFound");
		vSelAttr = (Vector) session.getAttribute("selectedAttr");
		vCheckList = (Vector) session.getAttribute("CheckList");
	}
	int rowsChecked = 0;
	if (vCheckList!=null){
	    rowsChecked = vCheckList.size();
	}
	// if sLabelKeyword has word "associated" then a getAssociated search was just done
	String sLabelKeyword = (String) session.getAttribute("labelKeyword");
	if (sLabelKeyword == null) {
		sLabelKeyword = "";
	}
	if (sKeyword == null)
		sKeyword = "";
	if (nRecs == null)
		nRecs = "No ";

	//drop downlist visible text
	if ((sSelAC == null) || (sSelAC.equals("DataElement")))
		sSelAC = "Data Element";
	else if (sSelAC.equals("DataElementConcept"))
		sSelAC = "Data Element Concept";
	else if (sSelAC.equals("ValueDomain"))
		sSelAC = "Value Domain";
	else if (sSelAC.equals("ConceptualDomain"))
		sSelAC = "Conceptual Domain";
	else if (sSelAC.equals("PermissibleValue"))
		sSelAC = "Values/Meanings";
	else if (sSelAC.equals("ClassSchemeItems"))
		sSelAC = "Class Scheme Items";
	else if (sSelAC.equals("ValueMeaning"))
		sSelAC = "Value Meaning";

	//for button label text
	if ((sMAction == null) || (sMAction.equals("nothing")))
		sMAction = "nothing";
	else if ((sMAction.equals("NewDETemplate"))
			|| (sMAction.equals("NewDECTemplate"))
			|| (sMAction.equals("NewVDTemplate")))
		sMAction = "Create New from Existing";
	else if ((sMAction.equals("NewDEVersion"))
			|| (sMAction.equals("NewDECVersion"))
			|| (sMAction.equals("NewVDVersion")))
		sMAction = "Create New Version";
	else if ((sMAction.equals("editDE"))
			|| (sMAction.equals("editDEC"))
			|| (sMAction.equals("editVD")))
		sMAction = "Edit Selection";
	else if (sSelAC.equals("Questions")
			&& !sMAction.equals("searchForCreate"))
		sMAction = "Complete Selected DE";

	if (sSelAC.equals("ObjectClass") || sSelAC.equals("Property"))
		sMAction = "nothing";

	Vector vNewPV = (Vector) request.getAttribute("newPVData");
	if (vNewPV == null)
		vNewPV = new Vector();

	//get the server name to open cdeBrowser
	//String thisServer = request.getServerName();
	String browserURL = (String) session.getAttribute("BrowserURL");
	String sAppendAct = (String) request.getParameter("AppendAction");
	// this session attribute says the Back button on a getAssociated search result was hit,
	// so search results will be popped off of stack (in setup method)
	String sBackFromGetAssociated = (String) session
			.getAttribute("backFromGetAssociated");
	if (sBackFromGetAssociated == null)
		sBackFromGetAssociated = "";
	session.setAttribute("backFromGetAssociated", "");

	// so search results will be popped off of stack (in setup method)
	String sSecondBackFromGetAssociated = (String) session
			.getAttribute("SecondBackFromGetAssociated");
	if (sSecondBackFromGetAssociated == null)
		sSecondBackFromGetAssociated = "";
	session.setAttribute("SecondBackFromGetAssociated", "");
	// Use this in setup below
	Stack sSearchACStack = (Stack) session
			.getAttribute("sSearchACStack");
	Stack vResultStack = (Stack) session.getAttribute("vResultStack");
	if (vResultStack == null)
		vResultStack = new Stack();

	String pushBoolean = "false";
	String sSelectAll = "false";
	if (!sSelAC.equals("ValueMeaning")) {
		if (vCheckList != null && vCheckList.size() > 0)
			sSelectAll = "true";
		else
			sSelectAll = "false";
	}
   String labelKeyword1 = (String)request.getAttribute("labelKeyword1");	
   String labelKeyword2 = (String)request.getAttribute("labelKeyword2");
   String show = (String)session.getAttribute("showDefaultSortBtn");
 %>

<SCRIPT LANGUAGE="JavaScript" type="text/JavaScript">
  var bUnAppendWarning = false;
  var helpUrl = "<%=ToolURL.getCurationToolHelpURL(pageContext)%>";
function populateAttr(){
     if (document.searchParmsForm.keyword != null)
        document.searchParmsForm.keyword.focus();
    //call function to get component to search for if search from create page
  <%if (sMenuAction.equals("searchForCreate")) {%>       
      openSearchForCreateAct("<%=StringEscapeUtils.escapeJavaScript(sSearchAC)%>");   //call the function in JS
  <%}%>  
}
function unQualifiedSearch(ac){
 var flag = true;
 if(ac=="DataElement") {
  <% if(temp.equals("N")){%>
        flag =false;
      <%}%>
  }
  if(ac=="DataElementConcept"){
  <%if(temp1.equals("N")){%>
        flag =false;
      <%}%>
  }
  if(ac=="ClassSchemeItems"){
    <% if(temp2.equals("N")){%>
          flag =false;
        <%}%>
  }
  if(ac=="ConceptualDomain"){
    <% if(temp3.equals("N")){%>
          flag =false;
        <%}%>
   }
  if(ac=="ValueDomain"){
    <% if(temp4.equals("N")){%>
          flag =false;
        <%}%>
   }
  if(ac=="PermissibleValue"){
    <% if(temp5.equals("N")){%>
          flag =false;
        <%}%>
  }
  
  if(ac=="ValueMeaning"){
    <% if(temp6.equals("N")){%>
          flag =false;
        <%}%>
   }
  if(ac=="ObjectClass"){
      <% if(temp7.equals("N")){%>
            flag =false;
          <%}%>
   }
 if(ac=="ConceptClass"){
      <% if(temp8.equals("N")){%>
            flag =false;
          <%}%>
 }
    if(ac=="Property"){
      <% if(temp9.equals("N")){%>
            flag =false;
          <%}%>
 }
    return flag;
}
function searchAll(){
        
        var ac = document.searchParmsForm.listSearchFor.value;
        var unQualifiedSearchflag = unQualifiedSearch(ac);
        var checkDefaultSearch = checkIfDefaultSearch();
   	    if(checkDefaultSearch && !unQualifiedSearchflag)
    	{
    		confirmation =  confirm("The Search will cause all caDSR content for "+ ac +" to be retrieved.\n"
        				 +"This is a slow, lengthy search. Are you sure you wish to proceed?");
    		return confirmation;
    	}
    	else 
    	{
    	  return true;
    	}
         
 }
 //submits the page to start the search  
function doSearchDE(){
   	
     if(searchAll()){     
     <%  if (!sMenuAction.equals("searchForCreate") && sAppendAction.equals("Was Appended")) { %>
     var conf = confirm("You did not press the Append button so these results will not be appended.");
      if (conf == true)
      {
        if (opener && opener.document != null && opener.document.SearchActionForm != null)
          opener.document.SearchActionForm.isValidSearch.value = "true";
        hourglass();
        window.status = "Searching Keyword, it may take a minute, please wait....."
        document.searchResultsForm.Message.style.visibility="visible";
        document.searchParmsForm.actSelect.value = "Search";
        document.searchParmsForm.submit();
      }
       
     <% } else { %>
        <% if (sMenuAction.equals("searchForCreate")) { %>
          if (opener && opener.document != null && opener.document.SearchActionForm != null)
            opener.document.SearchActionForm.isValidSearch.value = "true";
        <% } %>
        hourglass();
        window.status = "Searching Keyword, it may take a minute, please wait....."
        document.searchResultsForm.Message.style.visibility="visible";
        document.searchParmsForm.actSelect.value = "Search";
        document.searchParmsForm.submit();
      <% }%>
     } 
  }
//  From a search page:  a search can be initiated two ways:
//    By pressing the "Start Search" button or
//    Pressing the enter key
//  This piece of code ensures that the WaitMessage is
//  displayed when the enter key is pressed.
function keypress_handler(evt){
    var keycode = (window.event)?event.keyCode:evt.which;
    if(keycode != 13){
        return true;  // only interest on return key
    }
    if(searchAll()){
    	//check if it is valid for search
    	if(bUnAppendWarning){
     	 var conf = confirm("You did not press the Append button so these results will not be appended.");
     	 if (conf == false)
              return false;     //user canceled, may append again, do nothing
    	}
      		 // all other case go to servlet to search
    	<% if (sMenuAction.equals("searchForCreate")) { %>
       		 if (opener && opener.document != null && opener.document.SearchActionForm != null)
         	 opener.document.SearchActionForm.isValidSearch.value = "true";
  		  <% } %>
   		 hourglass();
    	window.status = "Searching Keyword, it may take a minute, please wait....."
    	document.searchResultsForm.Message.style.visibility="visible";
    	document.searchParmsForm.actSelect.value = "Search";
    	document.searchParmsForm.submit();
    	return false;
    }
    else{
      return true;
    }
}
function LoadKeyHandler(){
    <% if (sAppendAction.equals("Was Appended") && !sMenuAction.equals("searchForCreate")) {%>
    bUnAppendWarning = true;
    <%}%>
    document.onkeypress = null;
    document.onkeypress = keypress_handler;
}

    var numRows2;
    var SelectAllOn = <%=sSelectAll%>;
      
        //display status message if any 
 	<%
        String statusMessage = (String)session.getAttribute(Session_Data.SESSION_STATUS_MESSAGE);
        if (statusMessage == null) statusMessage = "";
        String sSubmitAction = (String)session.getAttribute(Session_Data.SESSION_MENU_ACTION);
        if (sSubmitAction == null) sSubmitAction = "nothing";
        Vector vStat = (Vector)session.getAttribute("vStatMsg");
        if (vStat != null && vStat.size() > 30)  { %>
            displayStatusWindow();
     <% }
        else if (statusMessage != null && !statusMessage.equals("")) { 
            session.setAttribute("vStatMsg", new Vector());
        %>
            displayStatus("<%=statusMessage%>", "<%=StringEscapeUtils.escapeJavaScript(sSubmitAction)%>");
     <% }
        //reset the message attributes   
        session.setAttribute(Session_Data.SESSION_STATUS_MESSAGE, "");
        if (vCheckList != null && vCheckList.size() >0) {
            for (int i=0; i<vCheckList.size(); i++) {
            %>
                
            <%
            }
        }
%>
        window.status = "Enter the keyword to search a component";
    
<%
        if (sBackFromGetAssociated.equals("backFromGetAssociated"))  {
            Stack vSearchIDStack = (Stack)session.getAttribute("vSearchIDStack");
            Vector vIDs = (Vector)session.getAttribute("SearchID");
            if (vSearchIDStack != null && vSearchIDStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vIDs = (Vector)vSearchIDStack.pop();
            } 
            if (vSearchIDStack != null && vSearchIDStack.size()>0)
            {
                vIDs = (Vector)vSearchIDStack.pop();
          // do not lose the very first search result
      //    if(vSearchIDStack.size()==0) 
      //    {
                vSearchIDStack.push(vIDs);
       //   }
                session.setAttribute("vSearchIDStack", vSearchIDStack);
                session.setAttribute("SearchID", vIDs);
                // Set the nRecs when Back button hit
                Integer nRecsInt;
                if (vIDs != null)
                    nRecsInt = new Integer(vIDs.size());
                else
                    nRecsInt = new Integer(0);
                nRecs = nRecsInt.toString();
            }
            Stack vSearchNameStack = (Stack)session.getAttribute("vSearchNameStack");
            Vector vNames = (Vector)session.getAttribute("SearchName");
            if (vSearchNameStack != null && vSearchNameStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vNames = (Vector)vSearchNameStack.pop();
            }
            if (vSearchNameStack != null && vSearchNameStack.size()>0)
            {
                vNames = (Vector)vSearchNameStack.pop();
          // do not lose the very first search result
       //   if(vSearchNameStack.size()==0) 
        //  {
                vSearchNameStack.push(vNames);
       //   }
                session.setAttribute("vSearchNameStack", vSearchNameStack);
                session.setAttribute("SearchName", vNames);
            }
      
            Stack vSearchLongNameStack = (Stack)session.getAttribute("vSearchLongNameStack");
            Vector vLongNames = (Vector)session.getAttribute("SearchLongName");
            if (vSearchLongNameStack != null && vSearchLongNameStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vLongNames = (Vector)vSearchLongNameStack.pop();
            } 
            if (vSearchLongNameStack != null && vSearchLongNameStack.size()>0)
            {
                vLongNames = (Vector)vSearchLongNameStack.pop();
          // do not lose the very first search result
       //   if(vSearchNameStack.size()==0) 
        //  {
                vSearchLongNameStack.push(vLongNames);
       //   }
                session.setAttribute("vSearchLongNameStack", vSearchLongNameStack);
                session.setAttribute("SearchLongName", vLongNames);
            }
        
            Stack vACSearchStack = (Stack)session.getAttribute("vACSearchStack");
            Vector vACSearch = (Vector)session.getAttribute("vACSearch");
            if (vACSearchStack != null && vACSearchStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vACSearch = (Vector)vACSearchStack.pop();
            } 
            if (vACSearchStack != null && vACSearchStack.size()>0)
            {
                vACSearch = (Vector)vACSearchStack.pop();
        // do not lose the very first search result
     //   if(vACSearchStack.size()==0) 
     //   {
                vACSearchStack.push(vACSearch);
      //  }
                session.setAttribute("vACSearchStack", vACSearchStack);
                session.setAttribute("vACSearch", vACSearch);
            }
      
            Stack vSearchASLStack = (Stack)session.getAttribute("vSearchASLStack");
            vSearchASL = (Vector)session.getAttribute("SearchASL");
            if (vSearchASL == null)  vSearchASL = new Vector();
            if (vSearchASLStack != null && vSearchASLStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vSearchASL = (Vector)vSearchASLStack.pop();
            } 
            if (vSearchASLStack != null && vSearchASLStack.size()>0)
            {
                vSearchASL = (Vector)vSearchASLStack.pop();
//System.out.println("sr jsp 2pop vSearchASL2.size: " + vSearchASL.size());
        // do not lose the very first search result
    //    if(vSearchASLStack.size()==0) 
     //   {
                vSearchASLStack.push(vSearchASL);
     //   }
                session.setAttribute("vSearchASLStack", vSearchASLStack);
                session.setAttribute("SearchASL", vSearchASL);
            } 

            Stack vSelRowsStack = (Stack)session.getAttribute("vSelRowsStack");
            Vector vRSel = (Vector)session.getAttribute("vSelRows");
            if (vSelRowsStack != null && vSelRowsStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                vRSel = (Vector)vSelRowsStack.pop();
            } 
            if (vSelRowsStack != null && vSelRowsStack.size()>0)
            {
                vRSel = (Vector)vSelRowsStack.pop();

        // do not lose the very first search result
     //   if(vSelRowsStack.size()==0) 
     //   {
                vSelRowsStack.push(vRSel);
     //   }
                session.setAttribute("vSelRowsStack", vSelRowsStack);
                session.setAttribute("vSelRows", vRSel);
            }

      // set number of records variable
            if (vRSel != null) numRows = vRSel.size();

            if (vResultStack != null && vResultStack.size()>0) // && sSecondBackFromGetAssociated.equals(""))
            {
                results = (Vector)vResultStack.pop();
            } 
            if (vResultStack != null && vResultStack.size()>0)
            {
                results = (Vector)vResultStack.pop();
     //   if(vResultStack.size()==0) 
      //  {
                vResultStack.push(results);
                pushBoolean = "true";
     //   }
                session.setAttribute("vResultStack", vResultStack);
                session.setAttribute("results", results);
            }
        } 
        %>
  
   function checkClick(cb){
   var numRowsChecked = <%=rowsChecked%>;
   if((numRowsChecked > 0) && (document.searchResultsForm.count.value == "1")){
       checkClickJS(cb,'<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>',numRowsChecked);
       document.searchResultsForm.count.value = ">1";
    }else{
        var num = 0;
        checkClickJS(cb,'<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>', num); 
    }   
 }  
 function SelectUnSelectCheckBox()
  {
    var numRows2 = "<%=numRows%>";
    var CK = "";
    if(SelectAllOn == false){
       for(k=0; k<numRows2; k++){
        CK = "CK" + k;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked == false)
        {
          formObj.checked=true;
        }
      }
      SelectAllOn = "true";
      if (document.searchResultsForm.CheckGif != null)
          document.searchResultsForm.CheckGif.alt = "Unselect All";
      ShowSelectedRows(true);
    }
    else{
       for(m=0; m<numRows2; m++){
        CK = "CK" + m;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked==true)
        {
          formObj.checked=false;
        }
      }
      SelectAllOn = "false";
       if (document.searchResultsForm.CheckGif != null)
          document.searchResultsForm.CheckGif.alt = "Select All";
       ShowSelectedRows(false);
    }
  } 
  function Back()
  {
    hourglass();
    document.searchResultsForm.pageAction.value = "backFromGetAssociated";
    <% if (sBackFromGetAssociated.equals("backFromGetAssociated"))
       {
          session.setAttribute("SecondBackFromGetAssociated", "True");
        }
          %>
    document.searchResultsForm.submit();
  }

   function getSearchComponent() {
    //get the selected component from the opener document or from session attribute
    <%  if (sMAction.equals("searchForCreate")) {%>
          if (opener && opener.document != null && opener.document.SearchActionForm != null)
            sComp = opener.document.SearchActionForm.searchComp.value;
    <% } else { %>
          sComp = "<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>";
    <% }%>

       //call the function to fill the newly created pv in opener document
       //UpdateOpenerForNew();
   }

   //opens edit/create page if not the regular search, or uses the selection for search From create.
   function ShowSelection()
   {
       ShowUseSelection("<%=StringEscapeUtils.escapeJavaScript(sMAction)%>");
   }

   //check if the user has permission to delete in the context called from designate record
   function hasWritePermission(vWrContext)
   {
      var doesExist = "false";
      if (document.searchParmsForm.listSearchFor.value == "DataElement")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextDE.size(); i++)
		  {
          String sWCont = (String)vWriteContextDE.elementAt(i);
%>
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }
      else if (document.searchParmsForm.listSearchFor.value == "DataElementConcept")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextDEC.size(); i++)
		  {
          String sWCont = (String)vWriteContextDEC.elementAt(i);
%>
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }
      else if (document.searchParmsForm.listSearchFor.value == "ValueDomain")
      {
<%      //loop through the vector to check if this context exists
        for (int i = 0; i < vWriteContextVD.size(); i++)
		  {
          String sWCont = (String)vWriteContextVD.elementAt(i);
%>        
          var vCont = "<%=sWCont%>";
          if (vCont == vWrContext)
             doesExist = "true";
<%      } %>
      }

      if (doesExist == "false")
      {
         alert("User does not have a permission to delete a component in " + vWrContext + " context.")
         return "No";
      }
      else
          return "Yes";
   }

  //if the created, update the opener document
  function UpdateOpenerForNew()
  {
 <% if (vNewPV.size() > 0)
    {
         String sPVid = (String)vNewPV.elementAt(0);
         String sPValue = (String)vNewPV.elementAt(1);
         String sPVmean = (String)vNewPV.elementAt(2);
 %>
         if (opener.document != null && opener.document.createVDForm != null)
         {
            var idx = parseInt(opener.document.createVDForm.valueCount.value);
            opener.document.createVDForm.selValuesList[idx].value = "<%=sPVid%>";
            opener.document.createVDForm.selValuesList[idx].text = "<%=sPValue%>";
            opener.document.createVDForm.selMeaningsList[idx].value = "<%=sPValue%>";
            opener.document.createVDForm.selMeaningsList[idx].text = "<%=sPVmean%>";
            opener.document.createVDForm.hiddenMeanText.value = "<%=sPVmean%>";
            idx++;

            opener.document.createVDForm.valueCount.value = idx;
         }
<%
    }
%>
  }
  
  //get detail button and calls the function in the js passing server name from the request.
  function GetDetails(){
     GetDetailsJS("<%=browserURL%>");
  }
  //sorts by heading.  called from column heading Hyperlink click event
  function SetSortType(sortBy)
  {
      SetSortTypeJS(sortBy, "<%=StringEscapeUtils.escapeJavaScript(sMAction)%>");
  }
  
  
  function SelectAllCheckBox(){
    document.searchResultsForm.show.value = "Yes";
    var numRows2 = "<%=numRows%>";
    var CK = "";
    for(k=0; k<numRows2; k++){
        CK = "CK" + k;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked == false)
        {
          formObj.checked=true;
        }
     }
     SelectAllOn = "true";
     if (document.searchResultsForm.CheckGif != null)
         document.searchResultsForm.CheckGif.alt = "Unselect All";
     ShowSelectedRows(true);
   }
   function UnSelectAllCheckBox(){
    document.searchResultsForm.show.value = "Yes";
    var numRows2 = "<%=numRows%>";
    var CK = "";
    for(m=0; m<numRows2; m++){
        CK = "CK" + m;
        formObj= eval("document.searchResultsForm."+CK);
        if(formObj && formObj.checked==true)
        {
          formObj.checked=false;
        }
     }
     SelectAllOn = "false";
     if (document.searchResultsForm.CheckGif != null)
         document.searchResultsForm.CheckGif.alt = "Select All";
     ShowSelectedRows(false);
   }
<% String strNothing ="nothing"; %>
<%String userName = (String) session.getAttribute("Username");%>
function update(){
 var select = "<%=sSelectAll%>";
 if (select == "true"){
  document.searchResultsForm.selectAll.value = "true";
  var numRowsChecked = <%=rowsChecked%>;
  updateHiddenSelectedRow(numRowsChecked);
 }
}
// This function will display the alert message to the user if he/she is not logged in 
// or will call the appropriate function if he/she is already logged in
function performAction(type){
  if(checkUser('<%=StringEscapeUtils.escapeJavaScript(userName)%>')){
      if (isCheckboxChecked()){
        document.searchResultsForm.unCheckedRowId.value = "";
        performActionJS('<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>', type);
      } 
   }    
}
// This function will display the alert message to the user if he/she is not logged in 
// or will call the appropriate function if he/she is already logged in
function performUncheckedCkBoxAction(type){
   if(checkUser('<%=StringEscapeUtils.escapeJavaScript(userName)%>')){
      document.searchResultsForm.unCheckedRowId.value = document.searchResultsForm.selectedRowId.value;
      performActionJS('<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>', type);
   }   
}
// This function will display the alert message to the user if he/she is not logged in 
// or will call the appropriate function if he/she is already logged in
function createNew(type){
  if(checkUser('<%=StringEscapeUtils.escapeJavaScript(userName)%>')){
    document.searchResultsForm.unCheckedRowId.value = document.searchResultsForm.selectedRowId.value;
    createNewJS('<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>', type);
  }
}
function enableDisableMenuItems(){
  var numRowsChecked = <%=rowsChecked%>;
  enableDisableMenuItemsJS('<%=StringEscapeUtils.escapeJavaScript(sSelAC)%>',numRowsChecked);
}

function viewAC(){
 	   var acIdseq = document.searchResultsForm.hiddenSearch[document.searchResultsForm.selectedRowId.value].value;
 	   var name = "ViewAC"+document.searchResultsForm.selectedRowId.value;
 	   var viewWindow = window.open("../../cdecurate/NCICurationServlet?reqType=view&idseq=" +acIdseq, name, "width=1000,height=1000,top=0,left=0,resizable=yes,scrollbars=yes");
 }
function openEditVMWindow(curPV){
  if (checkUser('<%=StringEscapeUtils.escapeJavaScript(userName)%>')) 
      openEditVMWindowJS(curPV);	
}
function ShowSelectedRowss(){
  if (isCheckboxChecked())
     ShowSelectedRows(true);
}    
 

</SCRIPT>

 <!-- Main Area -->
        <div class="xyz">
            <table style="border-collapse: collapse; width: 100%" border="0" cellspacing="0" cellpadding="0">
               <curate:menuBar/>
 <tr>
<td valign="top" align="left" style="background-color: #c9c9c9; border-right: 2px solid #ffffff">
<form name="searchParmsForm" method="post" action="../../cdecurate/NCICurationServlet?reqType=searchACs">
			
			
			<!-- need this style to keep the table aligned top which is different for crf questions   -->
			<table>			
				   <tr>
				     
                       <td valign="top" align="left">
                       <div class = "scItem">
                         <b>Search For</b>
                        </div> 
                      </td>
                     </tr>
                     <tr>
                       <td> 
                        <div style="padding-left: 20px">        
                        <!-- include all components for regular search or question search-->
						<%
						if (!sMenuAction.equals("searchForCreate")) {
						%>
						
						<select name="listSearchFor" size="1" style="width: 185"
							onChange="doSearchForChange();"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="ClassSchemeItems"
								<%if(sSearchAC.equals("ClassSchemeItems")){%> selected <%}%>>
								Class Scheme Items
							</option>
							<option value="ConceptClass"
								<%if(sSearchAC.equals("ConceptClass")){%> selected <%}%>>
								Concept Class
							</option>
							<option value="ConceptualDomain"
								<%if(sSearchAC.equals("ConceptualDomain")){%> selected <%}%>>
								Conceptual Domain
							</option>
							
							<option value="DataElement"
								<%if(sSearchAC.equals("DataElement")){%> selected <%}%>>
								Data Element
							</option>
							<option value="DataElementConcept"
								<%if(sSearchAC.equals("DataElementConcept")){%> selected <%}%>>
								Data Element Concept
							</option>
							<option value="ObjectClass"
								<%if(sSearchAC.equals("ObjectClass")){%> selected <%}%>>
								Object Class
							</option>
							<option value="PermissibleValue"
								<%if(sSearchAC.equals("PermissibleValue")){%> selected <%}%>>
								Permissible Value
							</option>
							<option value="Property" <%if(sSearchAC.equals("Property")){%>
								selected <%}%>>
								Property
							</option>
							<option value="ValueDomain"
								<%if(sSearchAC.equals("ValueDomain")){%> selected <%}%>>
								Value Domain
							</option>
							<option value="ValueMeaning"
								<%if(sSearchAC.equals("ValueMeaning")){%> selected <%}%>>
								Value Meaning
							</option>
				</select>
						
						<%
						} else {
						%>
						
						<select name="listSearchFor" size="1" style="width: 185"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="<%=StringEscapeUtils.escapeHtml(sSearchAC)%>" selected>
								<%=StringEscapeUtils.escapeHtml(sLongAC)%>
							</option>
						</select>
					
						<%
						}
						%>
					</div>
					</td>
					</tr>
                
                
                
                     <!--not for crf questions    -->
				<%
				if (!sSearchAC.equals("Questions")) {
				%>
                     <tr>
                     
                        <td> <div class = "scItem">    
                              <b>Search In</b></div>
                        </td> 
                           
                     </tr>
                     <tr>
                        <td>       
                                <div style="padding-left: 20px">
                                    <select name="listSearchIn" size="1" style="width: 185"
							onChange="doSearchInChange();"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<!-- include names&definition only if not questions-->
							<option value="longName" <%if(sSearchIn.equals("longName")){%>
								selected <%}%>>
								<%
								if (sSearchAC.equals("ConceptClass")) {
								%>
								Concept Name
								<%
								} else {
								%>
								Names & Definition
								<%
								}
								%>
							</option>
							<!-- include document text for Data Element -->
							<%
							if (sSearchAC.equals("DataElement")) {
							%>
							<option value="NamesAndDocText"
								<%if(sSearchIn.equals("NamesAndDocText")){%> selected <%}%>>
								Names,Definition,Doc Text
							</option>
							<option value="docText" <%if(sSearchIn.equals("docText")){%>
								selected <%}%>>
								Reference Document Text
							</option>
							<%
							}
							%>
							<!-- include crf name if not searching from create & only DataElement-->
							<%
									if ((!sMenuAction.equals("searchForCreate"))
									&& (sSearchAC.equals("DataElement") || sSearchAC
											.equals("Questions"))) {
							%>
							<option value="CRFName" <%if(sSearchIn.equals("CRFName")){%>
								selected <%}%>>
								Protocol ID/CRF Name
							</option>
							<%
							}
							%>
							<!-- include public ID all administered componenet -->
							<%
									if (sSearchAC.equals("DataElement")
									|| sSearchAC.equals("DataElementConcept")
									|| sSearchAC.equals("ValueDomain")
									|| sSearchAC.equals("ConceptualDomain")
									|| sSearchAC.equals("ObjectClass")
									|| sSearchAC.equals("Property")
									|| sSearchAC.equals("ConceptClass")
									|| sSearchAC.equals("ValueMeaning")) {
							%>
							<option value="minID" <%if(sSearchIn.equals("minID")){%> selected
								<%}%>>
								Public ID
							</option>
							<%
							}
							%>
							<!-- include Historical cde_ID for Data Element -->
							<%
							if (sSearchAC.equals("DataElement")) {
							%>
							<option value="histID" <%if(sSearchIn.equals("histID")){%>
								selected <%}%>>
								Historical CDE_ID
							</option>
							<%
							}
							%>
							<!-- include permissible value for Data Element and value domain-->
							<%
									if (sSearchAC.equals("DataElement")
									|| sSearchAC.equals("ValueDomain")) {
							%>
							<option value="permValue" <%if(sSearchIn.equals("permValue")){%>
								selected <%}%>>
								Permissible Values
							</option>
							<%
							}
							%>
							<!-- include origin all administered componenet -->
							<%
									if (sSearchAC.equals("DataElement")
									|| sSearchAC.equals("DataElementConcept")
									|| sSearchAC.equals("ValueDomain")
									|| sSearchAC.equals("ConceptualDomain")) {
							%>
							<option value="origin" <%if(sSearchIn.equals("origin")){%>
								selected <%}%>>
								Origin
							</option>
							<%
							}
							%>
							<!-- include concept filter for all acs-->
							<%
									if (!sSearchAC.equals("Questions")
									&& !sSearchAC.equals("ConceptualDomain")
									&& !sSearchAC.equals("ClassSchemeItems")) {
							%>
							<option value="concept" <%if(sSearchIn.equals("concept")){%>
								selected <% } %>>
								<%
								if (sSearchAC.equals("ConceptClass")) {
								%>
								EVS Identifier
								<%
								} else {
								%>
								Concept Name/EVS Identifier
								<%
								}
								%>
							</option>
							<%
							}
							%>
						</select>
                        </div>
                    </td>
                    </tr>       
                           
                            
                      <!-- Names, definition, long name document text and historic short cde name search in -->
				      <%
						if (sSearchIn.equals("NamesAndDocText")
						&& sSearchAC.equals("DataElement")) {
				      %>     
                       <tr>
					        <td >
					        <div style="padding-left: 20px"> 
						    <font size=1> Doc Text searches in Document Text of type
							   Preferred Question Text and HISTORIC SHORT CDE NAME. </font></div>
					        </td>
				     </tr>
				    <%
				     }
				    %>
                           
                    
                     <!-- Reference Document Types if the search in is  Refernce Document Text -->
				     <%
						if (sSearchIn.equals("docText")
						&& sSearchAC.equals("DataElement")
						&& sUIFilter.equals("advanced")) {
				     %>      
                      <tr>
                        <td> <div class = "scItem">    
                              <b>Select Document Types</b></div> 
                        </td>
                      </tr>   
                      <tr>
                         <td>
                             <div style="padding-left: 20px">
                             <select name="listRDType" size="3" style="width: 185" valign="top"	multiple
                              onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<%
									if (vDocType != null) {
									//default Preferred Question Text and hist name if nothing is selected
									if (vDocs == null || vDocs.size() == 0) {
										vDocs = new Vector();
										vDocs.addElement("Preferred Question Text");
										vDocs.addElement("HISTORIC SHORT CDE NAME");
									}
									for (int i = 0; vDocType.size() > i; i++) {
										String sDoc = (String) vDocType.elementAt(i);
							%>
							<option value="<%=sDoc%>"
								<%if(vDocs != null && vDocs.contains(sDoc)){%> selected <%}%>>
								<%=sDoc%>
							</option>
							<%} }				
						    %>
						</select>
                         </div>
                         </td>
                      </tr>
				     <%
				        }
				     %>  
                     	<!-- end not equal value meaning -->
                     	
                  	<!--  makes two input boxes if searhing crfname  otherwise only one  -->     
                          
                     <%
						if (sSearchIn.equals("CRFName")
						&& sSearchAC.equals("DataElement")) {
				     %>     
                      <tr>
                        <td>  <div class = "scItem">      
                              <b>Enter Protocol ID</b></div>
                        </td> 
                     </tr>   
                     <tr>
                       <td>
                         <div style="padding-left: 20px">
						 <input type="text" name="protoKeyword" size="24"
							value="<%=sProtoKeyword%>"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
					   </div> 
					   </td>
					 </tr>
					 
					  <tr>
                        <td>  <div class = "scItem">      
                              <b>Enter CRF Name</b></div>
                        </td> 
                     </tr>        
                      <!--keep the seach term for all other cases-->
				     <%
				      } else {
				     %>     
                           <tr>
                        <td> <div class = "scItem">       
                              <b>Enter Search Term</b></div>
                              <div style="padding-left: 20px">
                                    <i>use * as wildcard</i><br/>
                              </div>
                        </td> 
                     </tr>   
                      
                      <%
				        }
				     %>    
                           
                     <!-- same input box for crf name and other keyword searches -->      
                     <tr>     
                      <td><div style="padding-left: 20px">
						<input type="text" name="keyword" size="24" style="width: 185"
							value="<%=sLastKeyword%>"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
					  </div>
					  </td>     
                     </tr>      
                          
                     <%
				}
				%>
				<!-- end not crf question -->
				      
                 
                 <tr>
                   <td>          
                       <span style="padding-right: 40px;  padding-top: 7px" ><b>Filter By</b></span>
                       <!-- Place the adv/simple filter hyperlink only if it is for AC of these only -->
							<%
										if (sSearchAC.equals("DataElement")
										|| sSearchAC.equals("DataElementConcept")
										|| sSearchAC.equals("ValueDomain")
										|| sSearchAC.equals("ConceptualDomain")) {
							%>
							<%
							if (sUIFilter.equals("simple")) {
							%>
							<a href="javascript:refreshFilter('advanceFilter');"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchFilters',helpUrl); return false">
								Advanced&nbsp;Filter </a>
							<%
							} else {
							%>
							<a href="javascript:refreshFilter('simpleFilter');"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchFilters',helpUrl); return false">
								Simple&nbsp;Filter </a>
							<%
							}
							%>
							<%
							}
							%>
                        
                   </td>
                 </tr>         
                           
                 
                 <!--not for crf questions    -->
				<%
				if (!sSearchAC.equals("Questions")) {
				%>
				<!--no context for permissible value search for    -->
				<%
						if (!sSearchAC.equals("PermissibleValue")
						&& !sSearchAC.equals("ValueMeaning")) {
				%>
                 
                 <tr>          
                   <td>
                       <div style="padding-left: 20px">    
                       <b>Context</b>
                       </div>
                   </td> 
                 </tr>                 
                 <tr>
                   <td>
                       <div style="padding-left: 20px">    
                        <select name="listMultiContextFilter" size="5" style="width: 185"
							multiple
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="AllContext"
								<%if (vContext.size() == 0 || vContext.contains("AllContext")){%>
								selected <%}%>>
								All Contexts
							</option>
							<%
									if (vContextAC != null) {
									for (int i = 0; vContextAC.size() > i; i++) {
										String sContextName = (String) vContextAC
										.elementAt(i);
							%>
							<option value="<%=sContextName%>"
								<% if (vContext != null && vContext.contains(sContextName)){%>
								selected <%}%>>
								<%=sContextName%>
							</option>
							<%
										}
										}
							%>
						</select>    
                        </div>
                     </td>
				  </tr>
				
				  <%
				     } //not pv
				    %>       
                            
                   
                   <!-- designation exist only for data element -->
				<%
				if (sSearchAC.equals("DataElement")) {
				%>         
                     <tr>          
                   <td>
                       <div class="scSubItem">
                        <b>Context Use</b> 
                       </div>
                   </td> 
                 </tr>    
                     
                 <tr>
                  <td><div style="padding-left: 20px">
                   <input type="radio" name="rContextUse" value="OWNED_BY"
							<%if(sContextUse.equals("OWNED_BY")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Owned By</div>
					</td>
				</tr> 
				
				<tr>
                  <td><div style="padding-left: 20px">
                   <input type="radio" name="rContextUse" value="USED_BY"
							<%if(sContextUse.equals("USED_BY")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Used By
					</td>
				</tr>    
				
				<tr>
                  <td><div style="padding-left: 20px">
                   <input type="radio" name="rContextUse" value="BOTH"
							<%if(sContextUse.equals("BOTH")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Owned By/Used By
					</td>
				</tr>       
                            
               <%
						//} 
						}
				%>             
                            
                
                <%
						if (sSearchAC.equals("DataElement")
						|| sSearchAC.equals("ValueMeaning")
						|| sSearchAC.equals("DataElementConcept")
						|| sSearchAC.equals("ValueDomain")
						|| sSearchAC.equals("ConceptualDomain")) {
				%>            
                            
                 <tr>
                   <td><div class="scSubItem">
                                    <b>Version</b></div>           
                   </td>         
                 </tr>           
                 <tr>
					<td align=left>
					<div style="padding-left: 20px">
						<input type="radio" name="rVersion" value="All"
							onclick="javascript:removeOtherText();"
							<%if(sVersion.equals("All")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						All&nbsp;
						<input type="radio" name="rVersion" value="Yes"
							onclick="javascript:removeOtherText();"
							<%if(sVersion.equals("Yes")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Latest&nbsp;
						<input type="radio" name="rVersion" value="Other"
							<% if (sVersion.equals("Other")) { %> checked <% } %>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false"><input type="text" name="tVersion" value="<%=txVersion%>"
							maxlength="5" size="3" style="height: 20"
							onkeyup="javascript:enableOtherVersion();"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						
					</div>
					</td>
				</tr>
				<%
				}
				%>  
				<!-- filter value domain type -->
				<%
				if (sSearchAC.equals("ValueDomain")) {
				%>
				 <tr>
                   <td><div class="scSubItem">
                        <b>Value Domain Type</b></div>           
                   </td>         
                 </tr>   
				<!-- check box value domain type -->
				<tr>
					<td ><div style="padding-left: 20px">
						<input type="checkbox" name="enumBox" value="E"
							<%if(typeEnum != null && typeEnum.equals("E")){%> checked <%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Enumerated
					</div>
					</td>
				</tr>
				<tr>
					<td><div style="padding-left: 20px">
						<input type="checkbox" name="nonEnumBox" value="N"
							<%if(typeNonEnum != null && typeNonEnum.equals("N")){%> checked
							<%}%>
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
						Non-Enumerated
					</div>
					</td>
				</tr> 
				
				         
                <%
				}
				%>
				<%
				} //not for crf question
				%>            
                            
                            
               
               <!-- classification schemes filter for csi search -->
				<%
				if (sSearchAC.equals("ClassSchemeItems")) {
				%>             
                            
                 <tr>
                   <td><div class="scSubItem">
                        <b>Classification Schemes</b></div>           
                   </td>         
                 </tr>                  
                 <tr>
                   <td><div style="padding-left: 20px">
						<select name="listCSName" size="1" style="width: 185" valign="top"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="AllSchemes" selected>
								All Schemes
							</option>
							<%
										for (int i = 0; vCS.size() > i; i++) {
										String sCSName = (String) vCS.elementAt(i);
										String sCS_ID = (String) vCS_ID.elementAt(i);
							%>
							<option title="<%=sCSName%>" value="<%=sCS_ID%>"
								<%if(sCS_ID.equals(selCS)){%> selected <%}%>>
								<%=sCSName%>
							</option>
							<%
							}
							%>
						</select>
                    </div>
                 </tr>            
                 	<%
				}
				%>              
                
                <!-- CD filter for pv, vm, dec or vd searches drop down list-->
				<%
							if (sSearchAC.equals("PermissibleValue")
							|| sSearchAC.equals("ValueMeaning")
							|| sSearchAC.equals("DataElementConcept")
							|| sSearchAC.equals("ValueDomain")) {
				%>               
                 <tr>
                   <td><div class="scSubItem">
                        <b> Conceptual Domain </b>         
                   </td>         
                 </tr>     
                 <tr>
                  <td><div style="padding-left: 20px">
						<select name="listCDName" size="1" style="width: 185" valign="top"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="All Domains" <%if(selCD.equals("All Domains")){%>
								selected <%}%>>
								All Domains
							</option>
							<%
										for (int i = 0; vCD.size() > i; i++) {
										String sCDName = (String) vCD.elementAt(i);
										String sCD_ID = (String) vCD_ID.elementAt(i);
							%>
							<option title="<%=sCDName%>" value="<%=sCD_ID%>"
								<%if(sCD_ID.equals(selCD)){%> selected <%}%>>
								<%=sCDName%>
							</option>
							<%
							}
							%>
						</select></div>
					</td>
				
                </tr>  
                <%
				}
				%>

              
              <!-- workflow status filter for all ACs except csi, pv, vm -->
				<%
							if (!sSearchAC.equals("ClassSchemeItems")
							&& !sSearchAC.equals("PermissibleValue")) {
				%>
                  <tr>
                   <td><div class="scSubItem">
                        <b>Workflow Status</b>         
                   </td>         
                 </tr>    
                 <tr>
					<td><div style="padding-left: 20px">
						<select name="listStatusFilter" size="5" style="width: 185"
							multiple
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<!--store the status list as per the CONCEPT SEARCH  -->
							<%
									if (sSearchAC.equals("ConceptClass")
									|| sSearchAC.equals("ValueMeaning")) {
							%>
							<option value="RELEASED"
								<%if (vStatus != null && vStatus.contains("RELEASED")){%>
								selected <%}%>>
								RELEASED
							</option>
							<%
									}
									if (!sSearchAC.equals("Questions")) {
							%>
							<option value="AllStatus"
								<%if (vStatus == null || vStatus.size()==0 || sAssocSearch.equals("true")){%>
								selected <%}%>>
								All Statuses
							</option>
							<!--store the status list as per the search component  -->
							<%
									}
									if (vStatusDE != null && sSearchAC.equals("DataElement")) {
										for (int i = 0; vStatusDE.size() > i; i++) {
									String sStatusName = (String) vStatusDE.elementAt(i);
							%>
							<option value="<%=sStatusName%>"
								<%if((vStatus != null) && (vStatus.contains(sStatusName))){%>
								selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
									}
									} else if (vStatusDEC != null
									&& sSearchAC.equals("DataElementConcept")) {
										for (int i = 0; vStatusDEC.size() > i; i++) {
									String sStatusName = (String) vStatusDEC.elementAt(i);
							%>
							<option value="<%=sStatusName%>"
								<%if((vStatus != null) && (vStatus.contains(sStatusName))){%>
								selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
									}
									}

									else if (vStatusVD != null && sSearchAC.equals("ValueDomain")) {
										for (int i = 0; vStatusVD.size() > i; i++) {
									String sStatusName = (String) vStatusVD.elementAt(i);
							%>
							<option value="<%=sStatusName%>"
								<%if((vStatus != null) && (vStatus.contains(sStatusName))){%>
								selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
									}
									} else if (vStatusVM != null
									&& sSearchAC.equals("ValueMeaning")) {
										for (int i = 0; vStatusVM.size() > i; i++) {
									String sStatusName = (String) vStatusVM.elementAt(i);
							%>
							<option value="<%=sStatusName%>"
								<%if((vStatus != null) && (vStatus.contains(sStatusName))){%>
								selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
									}
									} else if (vStatusCD != null
									&& sSearchAC.equals("ConceptualDomain")) {
										for (int i = 0; vStatusCD.size() > i; i++) {
									String sStatusName = (String) vStatusCD.elementAt(i);
							%>
							<option value="<%=sStatusName%>"
								<%if((vStatus != null) && (vStatus.contains(sStatusName))){%>
								selected <%}%>>
								<%=sStatusName%>
							</option>
							<%
									}
									} else if (sSearchAC.equals("Questions")
									&& !sMenuAction.equals("searchForCreate")) {
							%>
							<option value="DRAFT NEW" selected>
								DRAFT NEW
							</option>
							<%
							}
							%>
						</select></div>
					</td>
					
				</tr>
				<%
				}
				%>

                <!-- Registration status filter-->
				<%
							if (sSearchAC.equals("DataElement")
							|| sSearchAC.equals("ValueMeaning")) {
				%>          
                <tr>
                 <td>
                     <div class="scSubItem">
                         <b>Registration Status</b>      
                 </td>        
                </tr>
                <tr>
                   <td><div style="padding-left: 20px">
						<select name="listRegStatus" size="1" style="width: 185"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="allReg"
								<%if (vRegStatus == null || vRegStatus.size()==0 
              || sRegStatus == null || sRegStatus.equals("") || sRegStatus.equals("allReg")){%>
								selected <%}%>>
								All Statuses
							</option>
							<%
										if (vRegStatus != null) {
										for (int i = 0; vRegStatus.size() > i; i++) {
									String sReg = (String) vRegStatus.elementAt(i);
							%>
							<option value="<%=sReg%>" <%if(sReg.equals(sRegStatus)){%>
								selected <%}%>>
								<%=sReg%>
							</option>
							<%
									}
									}
							%>
						</select></div>
					</td>
				
				</tr>
				<%
				}
				%>          
                
                <!-- Registration status filter-->
				<%
				if (sSearchAC.equals("ValueDomain")) {
				%>             
                   <tr>
                 <td>
                     <div class="scSubItem">
                         <b> Value Domain Data Type</b>      
                 </td>        
                </tr>     
                <tr>
                  <td><div style="padding-left: 20px">
						<select name="listDataType" size="1" style="width: 185"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="allData"
								<%if (vDataType == null || vDataType.size()==0 
              || sDataType == null || sDataType.equals("") || sDataType.equals("allData")){%>
								selected <%}%>>
								All Data Types
							</option>
							<%
										if (vDataType != null) {
										for (int i = 0; vDataType.size() > i; i++) {
									String sData = (String) vDataType.elementAt(i);
									if (sData != null && !sData.equals("")) {
							%>
							<option value="<%=sData%>" <%if(sData.equals(sDataType)){%>
								selected <%}%>>
								<%=sData%>
							</option>
							<%
										}
										}
									}
							%>
						</select></div>
					</td>
				
				</tr>
				<%
				}
				%>
                         
                 <!-- created date filter-->
				<%
							if ((sUIFilter.equals("advanced"))
							&& (sSearchAC.equals("DataElement")
							|| sSearchAC.equals("DataElementConcept")
							|| sSearchAC.equals("ValueDomain") || sSearchAC
							.equals("ConceptualDomain"))) {
						if (sSearchAC.equals("DataElement")) {
				%>      
                 <tr>
                 <td>
                     <div class="scSubItem">
                         <b> Derivation Type </b>      
                 </td>        
                </tr>        
                <tr>
                    <td> <div style="padding-left: 20px">
						<select name="listDeriveType" size="1" style="width: 185"
							onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
							<option value="allDer"
								<%if (vDerType == null || vDerType.size()==0 
              || sDerType == null || sDerType.equals("") || sDerType.equals("allDer")){%>
								selected <%}%>>
								All Derivation Types
							</option>
							<%
									if (vDerType != null) {
									for (int i = 0; vDerType.size() > i; i++) {
										String sDer = (String) vDerType.elementAt(i);
										if (sDer != null && !sDer.equals("")) {
							%>
							<option value="<%=sDer%>" <%if(sDer.equals(sDerType)){%> selected
								<%}%>>
								<%=sDer%>
							</option>
							<%
									}
									}
										}
							%>
						</select></div>
					</td>
				
				</tr>
				<%
				} 
				%>
				 
				 
				 <tr >
					<td colspan=2><div class="scItem">
						<table style = "padding-right: 40px">
							<col width=5%>
							<col width=20%>
							<col width=32%>
							<col width=14%>
							<col width=20%>
							
							<tr>
								<td>
									&nbsp;
								</td>
								<td style="height: 20" colspan=4 valign=bottom>
									<b> Date Created </b> &nbsp;&nbsp;(MM/DD/YYYY)
								</td>
							</tr>
							
							<tr>
								<td>
									&nbsp;
								</td>
								<td align=right>
									From
								</td>
								<td>
									<input type="text" name="createdFrom" value="<%=sCreatedFrom%>"
										size="8" readonly
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
								</td>
								<td align=center>
									<a
										href="javascript:show_calendar('searchParmsForm.createdFrom', null, null, 'MM/DD/YYYY');">
										<img name="Calendar"
											src="../../cdecurate/images/calendarbutton.gif" border=1
											width="18" height="18" alt="Calendar"
											style="vertical-align: top;"> </a>
								</td>
								<td align=left>
									<a href="javascript:clearDate('createdFrom');"> Clear </a>
								</td>
							</tr>
							
							<tr>
								<td>
									&nbsp;
								</td>
								<td align=right>
									To
								</td>
								<td>
									<input type="text" name="createdTo" value="<%=sCreatedTo%>"
										size="8" readonly
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
								</td>
								<td align=center>
									<a
										href="javascript:show_calendar('searchParmsForm.createdTo', null, null, 'MM/DD/YYYY');">
										<img name="Calendar"
											src="../../cdecurate/images/calendarbutton.gif" border=1
											width="18" height="18" alt="Calendar"
											style="vertical-align: top"> </a>
								</td>
								<td align=left>
									<a href="javascript:clearDate('createdTo');"> Clear </a>
								</td>
							</tr>
							
							
							<!-- creator filter-->
							<tr>
								<td>
									&nbsp;
								</td>
								<td style="height: 20" colspan=4 valign=bottom>
									<b> Creator </b>
								</td>
							<tr>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								<td style="height: 20" colspan=4 valign=top><div style="padding-left: 20px">
									<select name="creator" size="1" style="width: 185" valign="top"
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
										<option value="allUsers"
											<%if (vUsers == null || vUsers.size()==0 
                  || sCreator == null || sCreator.equals("") || sCreator.equals("allUsers")){%>
											selected <%}%>>
											All Creators
										</option>
										<%
													if (vUsers != null) {
													for (int i = 0; vUsers.size() > i; i++) {
												String sUser = (String) vUsers.elementAt(i);
												String sUserName = sUser;
												if (vUsersName != null && vUsersName.size() > i)
													sUserName = (String) vUsersName.elementAt(i);
										%>
										<option value="<%=sUser%>" <%if(sUser.equals(sCreator)){%>
											selected <%}%>>
											<%=sUserName%>
										</option>
										<%
												}
												}
										%>
									</select></div>
								</td>
							</tr>
						
						
						<!-- modified date filter-->
						
						
							<tr>
								<td>
									&nbsp;
								</td>
								<td style="height: 20" colspan=4 valign=bottom>
									<b> Date Modified </b> &nbsp;&nbsp;(MM/DD/YYYY)
								</td>
							</tr>
							
							<tr>
								<td>
									&nbsp;
								</td>
								<td align=right>
									From
								</td>
								<td>
									<input type="text" name="modifiedFrom"
										value="<%=sModifiedFrom%>" size="8" readonly
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
								</td>
								<td align=center>
									<a
										href="javascript:show_calendar('searchParmsForm.modifiedFrom', null, null, 'MM/DD/YYYY');">
										<img name="Calendar"
											src="../../cdecurate/images/calendarbutton.gif" border="1"
											width="18" height="18" alt="Calendar"
											style="vertical-align: center"> </a>
								</td>
								<td align=left>
									<a href="javascript:clearDate('modifiedFrom');"> Clear </a>
								</td>
							</tr>
							
							<tr>
								<td>
									&nbsp;
								</td>
								<td align=right>
									To
								</td>
								<td>
									<input type="text" name="modifiedTo" value="<%=sModifiedTo%>"
										size="8" readonly
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
								</td>
								<td align=center>
									<a
										href="javascript:show_calendar('searchParmsForm.modifiedTo', null, null, 'MM/DD/YYYY');">
										<img name="Calendar"
											src="../../cdecurate/images/calendarbutton.gif" border=1
											width="18" height="18" alt="Calendar"
											style="vertical-align: center"> </a>
								</td>
								<td align=left>
									<a href="javascript:clearDate('modifiedTo');"> Clear </a>
								</td>
							</tr>
							
							
							<!-- modifier filter-->
							<tr>
								<td>
									&nbsp;
								</td>
								<td style="height: 20" colspan=4 valign=bottom>
									<b> Modifier </b>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
								
								<td style="height: 35" colspan=4 valign=top>
									<div style="padding-left: 20px">
									<select name="modifier" size="1" style="width: 185"
										valign="top"
										onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
										<option value="allUsers"
											<%if (vUsers == null || vUsers.size()==0 
                  || sModifier == null || sModifier.equals("") || sModifier.equals("allUsers")){%>
											selected <%}%>>
											All Modifiers
										</option>
										<%
													if (vUsers != null) {
													for (int i = 0; vUsers.size() > i; i++) {
												String sUser = (String) vUsers.elementAt(i);
												String sUserName = sUser;
												if (vUsersName != null && vUsersName.size() > i)
													sUserName = (String) vUsersName.elementAt(i);
										%>
										<option value="<%=sUser%>" <%if(sUser.equals(sModifier)){%>
											selected <%}%>>
											<%=sUserName%>
										</option>
										<%
												}
												}
										%>
									</select></div>
								
								</td>
							
							</tr>
				</table></div>
					</td>
				</tr>
				<%
				}
				%>     
                       
                <tr>
                  <td>
                      <div class="scItem">
                         <b>Display Attributes</b> &nbsp;
                         <input type="button" name="updateDisplayBtn" value="Update"
								onClick="<%=updFunction%>" 
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">                              
                       </div>  
                  </td>       
               </tr>          
               <tr>
                <td>
                   <div style="padding-left: 20px">
                      <select name="listAttrFilter" size="5" style="width: 185"
								multiple valign="bottom"
								onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_displayAttributes',helpUrl); return false">
								<%
										if (vACAttr != null) {
										for (int i = 0; vACAttr.size() > i; i++) {
											String sAttrName = (String) vACAttr.elementAt(i);
											String sDispName = sAttrName;
											//get the display name for some special attributes
											if (sAttrName.equals("Name"))
										sDispName = "Short Name";
								%>
								<option value="<%=StringEscapeUtils.escapeHtml(sAttrName)%>"
									<% if((vSelectedAttr != null) && (vSelectedAttr.contains(sAttrName))){ %>
									selected <% } %>>
									<%=StringEscapeUtils.escapeHtml(sDispName)%>
								</option>
								<%
										}
										//add all attributes if not existed
										if (!vACAttr.contains("All Attributes")) {
								%>
								<option value="All Attributes">
									All Attributes
								</option>
								<%
									}
									}
								%>
							</select>
						</div>          
                   </td>
                 </tr>               
                 <tr>
                  <td>
                       <div align="center" class="scItem">
                            <input type="button" name="startSearchBtn" value="Start Search"
								onClick="doSearchDE();" width= 150 height= 30
            onHelp="showHelp('html/Help_SearchAC.html#searchParmsForm_SearchParameters',helpUrl); return false">
                        </div>
                </td></tr>
            </table> 
               
           <select size="1" name="hidListAttr"
				style="visibility: hidden; width: 150">
				<%
						for (int i = 0; vSelectedAttr.size() > i; i++) {
						String sName = (String) vSelectedAttr.elementAt(i);
				%>
				<option value="<%=StringEscapeUtils.escapeHtml(sName)%>">
					<%=StringEscapeUtils.escapeHtml(sName)%>
				</option>
				<%
				}
				%>
			</select>
			
			<input type="hidden" name="actSelect" value="Search">
			<input type="hidden" name="QCValueIDseq" value="">
			<input type="hidden" name="QCValueName" value="">
			<input type="hidden" name="CDVDContext" value="same">
			<input type="hidden" name="selCDID" value="">
			<input type="hidden" name="serMenuAct" value="<%=StringEscapeUtils.escapeHtml(sMenuAction)%>">

			<input type="hidden" name="outPrint" value="Print" style="visibility: hidden;"
				<% out.println(""+vACAttr.size());// leave this in, it slows jsp load down so no jasper error%>>
 <script language="javascript">
      populateAttr();
      LoadKeyHandler();
</script>
</form>

</td>





<td valign="top">    <!---search results -->


<form name="searchResultsForm"  method="post" action=" ../../cdecurate/NCICurationServlet?reqType=showResult">
		   <input type="hidden" name="count" value="1">
		   <input type="hidden" name="hidaction" value="nothing">
           <input type="hidden" name="hidMenuAction" value="nothing">
           <input type="hidden" name="selectedRowId" value="">
           <input type="hidden" name="unCheckedRowId" value="">
           <input type="hidden" name="selectAll" value="false">
           <input type="hidden" name="flag" value="true">
           <input type="hidden" name="show" value="No">
         
           <table style="width: 100%; border-collapse: collapse">
			<%if (((vResultStack.size()>0 && sBackFromGetAssociated.equals("backFromGetAssociated") && !pushBoolean.equals("true"))
                   || vResultStack.size()>1) && !sMAction.equals("searchForCreate")){%>
				<tr>
					<td>
						<font size="4">
							<b>
								 Search Results for
								<%if (labelKeyword1 != null){%><%=StringEscapeUtils.escapeHtml(labelKeyword1)%><%}%>&nbsp;&nbsp;<input type="button" value="Back" style="width: 65" onClick="Back();"><img name="Message" src="images/SearchMessage.gif" width="180" height="25" alt="WaitMessage" style="visibility:hidden;">
							</b>
						</font>
					</td>
				</tr>
				<tr>
					<td>
						<font size="2">
							&nbsp;
							<%=nRecs%>
							Records Found <%if (labelKeyword2 != null){%><%=labelKeyword2%><%}%>
						</font>
						</td>				
				</tr>
				<%}else{%>
                 <tr>
					<td>
						<font size="4">
							<b>
								 Search Results for
								<%=StringEscapeUtils.escapeHtml(sLabelKeyword)%><img name="Message" src="images/SearchMessage.gif" width="180" height="25" alt="WaitMessage" style="visibility:hidden;">
							</b>
						</font>
					</td>
				</tr>
				<tr>
					<td><%if ((show != null) && (show.equals("Yes")) ){ %><input type="button" name="defaultSortBtn" value="Default Sort" onClick="doSearchDE();"><%}%>
						<font size="2">
							&nbsp;
							<%=nRecs%>
							Records Found
						</font>
					</td>				
				</tr>
				<%}%>
				<tr>
					<td height="7">
				</tr>
			</table>
			<table style="width: 100%; border-collapse: collapse" rules="all">
				 <tr valign="middle">
					<%    if (sSelAC.equals("Data Element") || !sMAction.equals("searchForCreate")) {     %>
					<th class="rsCell">
						<a href="javascript:SelectUnSelectCheckBox()">
							<img id="CheckGif" src="images/CheckBox.gif" border="0" alt="Select All" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
						</a>
					</th>
					
					<th class="rsCell">
					</th>
					<%    } else   { %>
					<th class="rsCell">
						<img src="images/CheckBox.gif" border="0" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</th>
					
					<%    } %>

					<!-- adds Review status only if questions -->
					<%  if (sSelAC.equals("Questions") && !sMAction.equals("searchForCreate")) {  %>
					<th class="rsCell">
						<a>
							Curation Status
						</a>
					</th>
					<% } %>
					<!-- add other headings -->
					<%    int k = 0;
					 boolean defExists = false;
                     int defIndex = 0;
      if (vSelAttr != null)
      {
         //for review status increase the k size to 1
        if (sSelAC.equals("Questions"))
           k = vSelAttr.size() + 1;
        else
           k = vSelAttr.size();

       
        
        for (int i =0; i < vSelAttr.size(); i++) {
          String sAttr = (String)vSelAttr.elementAt(i);

          if (sAttr.equals("Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('name')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Short Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Alias Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('aliasName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Name/Alias Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Long Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('longName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							<%                if(sSelAC.equals("Data Element"))   { %>
							Data Element 
							Long Name
							<%                } else if(sSelAC.equals("Data Element Concept"))   { %>
							Data Element Concept Long Name
							<%                } else if(sSelAC.equals("Value Domain"))   { %>
							Value Domain Long Name
							<%                } else if(sSelAC.equals("Conceptual Domain"))   { %>
							Conceptual Domain Long Name
							<%                } else if(sSelAC.equals("Value Meaning"))   { %>
							Value Meaning Long Name
							<%                } else   { %>
							Long Name
							<%                } %>
						</a>
					</th>
					<%        } else if (sAttr.equals("Question Text")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('QuestText')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Question Text
						</a>
					</th>
					<%        } else if (sAttr.equals("DE Long Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('DELongName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Element Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("DE Public ID")) { %>
					<th  class="rsCell" method="get">
						<a href="javascript:SetSortType('DEPublicID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							DE Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Highlight Indicator")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('HighLight')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Highlight Indicator
						</a>
					</th>
					<%        } else if (sAttr.equals("Definition")) { 
					         defExists = true;
					         defIndex = i;
					        
					        } else if (sAttr.equals("Owned By Context")) { %>
					<th  class="rsCell" method="get">
						<a href="javascript:SetSortType('context')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Owned By Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Context")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('context')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Used By Context")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('UsedContext')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Used By Context
						</a>
					</th>
					<%        } else if (sAttr.equals("Value Domain")) { %>
					<th  class="rsCell" method="get">
						<a href="javascript:SetSortType('vd')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Domain Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Data Element Concept")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('DEC')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Element Concept Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Version")) { %>
					<th  class="rsCell" method="get">
						<a href="javascript:SetSortType('version')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Version
						</a>
					</th>
					<%        } else if (sAttr.equals("Public ID")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('minID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Public_ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Question Public ID")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('minID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Question Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("Workflow Status")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Status')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Workflow Status
						</a>
					</th>
					<%        } else if (sAttr.equals("Protocol ID")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('ProtoID')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Protocol ID
						</a>
					</th>
					<%        } else if (sAttr.equals("CRF Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CRFName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CRF Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Type of Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('TypeName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Type of Name
						</a>
					</th>
					<%        } else if (sAttr.equals("Effective Begin Date")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('BeginDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Effective Begin Date
						</a>
					</th>
					<%        } else if (sAttr.equals("Effective End Date")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('EndDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Effective End Date
						</a>
					</th>
					<%        } else if (sAttr.equals("Language")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('language')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Language
						</a>
					</th>
					<%        } else if (sAttr.equals("Change Note")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Comments')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Change Note
						</a>
					</th>
					<%        } else if (sAttr.equals("Origin")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Origin')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Origin
						</a>
					</th>
					<%        } else if (sAttr.equals("Conceptual Domain")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('ConDomain')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Conceptual Domain
						</a>
					</th>
					<%        } else if (sAttr.equals("Valid Values")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('validValue')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Valid Value
						</a>
					</th>
					<%        } else if (sAttr.equals("Classification Schemes")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Class')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Classification Schemes
						</a>
					</th>
					<%        } else if (sAttr.equals("Class Scheme Items")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSI')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Class Scheme Items
						</a>
					</th>
					<%        } else if (sAttr.equals("Unit of Measures")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('UOML')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Unit of Measures
						</a>
					</th>
					<%        } else if (sAttr.equals("Data Type")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('DataType')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Data Type
						</a>
					</th>
					<%        } else if (sAttr == null || sAttr.equals("Comments")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('comment')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Comments
						</a>
					</th>
					<%        } else if (sAttr.equals("Display Format")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Format')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Display Format
						</a>
					</th>
					<%        } else if (sAttr.equals("Maximum Length")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('MaxLength')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Maximum Length
						</a>
					</th>
					<%        } else if (sAttr.equals("Minimum Length")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('MinLength')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Minimum Length
						</a>
					</th>
					<%        } else if (sAttr.equals("High Value Number")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('HighNum')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							High Value Number
						</a>
					</th>
					<%        } else if (sAttr.equals("Low Value Number")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('LowNum')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Low Value Number
						</a>
					</th>
					<%        } else if (sAttr.equals("Decimal Place")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Decimal')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Decimal Place
						</a>
					</th>
					<%        } else if (sAttr.equals("Type Flag")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('TypeFlag')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Type Flag
						</a>
					</th>
					<%        } else if (sAttr.equals("Value")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('value')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value
						</a>
					</th>
					<%        } else if (sAttr.equals("Value Meaning Long Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Value Meaning Long Name
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Public ID")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							VM Public ID
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Version")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('meaning')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							VM Version
						</a>
					</th>
					<%        } else if (sAttr.equals("VM Description")) { 
					
						     defExists = true;
					         defIndex = i;
					
				       } else if (sAttr.equals("Meaning Description")) { 
					
						     defExists = true;
					         defIndex = i;
					
					        }   else if (sAttr == null || sAttr.equals("caDSR Component")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('cadsrComp')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							caDSR Component
						</a>
					</th>
					<%        } else if (sAttr.equals("Vocabulary")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('database')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Vocabulary
						</a>
					</th>
					<%        } else if (sAttr.equals("Description Source")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('descSource')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Description Source
						</a>
					</th>
					<%        } else if (sAttr.equals("Identifier")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('Ident')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("DEC's Using")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('decUse')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							DEC's Using
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSIName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CSI Name
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Type")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSITL')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CSI Type
						</a>
					</th>
					<%        } else if (sAttr.equals("CSI Definition")) { 
						     defExists = true;
					         defIndex = i;
					         } else if (sAttr.equals("Permissible Value")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('permValue')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Permissible Value
						</a>
					</th>
					<%        } else if (sAttr.equals("CS Long Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Long Name
						</a>
					</th>
					<%       
				    } else if (sAttr.equals("CS Public ID")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Public ID
						</a>
					</th>
					<%       
				       } else if (sAttr.equals("CS Version")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('CSName')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							CS Version
						</a>
					</th>
					<%        } else if (sAttr.equals("Registration Status")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('regStatus')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Registration Status
						</a>
					</th>
					<%        } else if (sAttr.equals("Date Created")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('creDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Date Created
						</a>
					</th>
					<%        } else if (sAttr.equals("Creator")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('creator')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Creator
						</a>
					</th>
					<%        } else if (sAttr.equals("Date Modified")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('modDate')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Date Modified
						</a>
					</th>
					<%        } else if (sAttr.equals("Modifier")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('modifier')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Modifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Concept Name")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('conName')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							<% if(sSelAC.equals("ObjectClass"))   { %>
							      Object Class Long Name
							<% } else if(sSelAC.equals("Property"))   { %>
							     Property Long Name
							<%}else{ %>
							     Concept Name
							<%} %>
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("EVS Identifier")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('umls')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							EVS Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Identifier")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('umls')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Identifier
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Definition Source")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('source')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Definition Source
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Database")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('db')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Database
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Alternate Names")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('altNames')">
							Alternate Names
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Reference Documents")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('refDocs')">
							Reference Documents
						</a>
					</th>
					<%        }   else if (sAttr == null || sAttr.equals("Derivation Relationship")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('DerRelation')" onHelp="showHelp('html/../Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Derivation Relationship
						</a>
					</th>
					<%        } else if (sAttr.equals("Dimensionality")) { %>
					<th class="rsCell" method="get">
						<a href="javascript:SetSortType('dimension')" onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
							Dimensionality
						</a>
					</th>
					<%
	        }  }  }
%>
				</tr>
				<%
    String strResult = "";
    if (results != null)
	  {
      int rsize = results.size();
      int j = 0;
		  for (int i = 0; i < results.size(); i+=k)
		  {
           String ckName = ("CK" + j);
           strResult = (String)results.get(i);
           if (strResult == null) strResult = "";
           if ((j%2) == 0){%>	
           			<tr class="stripe" <%if (defExists){%>style="font-weight: bold"<%}%>>
	       <%}else { %>				
				<tr <%if (defExists){%>style="font-weight: bold"<%}%>>
		
			<%} %>	
				   <td class="rsCell" align="center">
						<input type="checkbox" onClick="javascript:checkClick(this);" name="<%=ckName%>" <%if((vCheckList != null && vCheckList.contains(ckName))){%> checked <%}%> onHelp="showHelp('html/Help_SearchAC.html#searchResultsForm_sort',helpUrl); return false">
					</td>
					<td  class="rsCell" align="center">
					<img <%if ((j%2) == 0){%>class="stripe"<%}else{%>class="white"<%}%> onclick="menuShow(this, event, 'yes');" onmouseover="style.border=('1px solid #4876FF');" onmouseout="setBorder(this, <%=j%>)" menuID="objMenu" rowId="<%=j%>" src="images/actionicon.gif"  border="1"/></td>
					<%     if (sSelAC.equals("Questions") && !sMAction.equals("searchForCreate"))
       {
          //if edit, display the status as complete, otherwise incomplete
          if (strResult.equals("Edit"))   {  %>
					<td class="rsCell">
						Attributes Completed
					</td>
					<%        } else {  %>
					<td class="rsCell">
						Incomplete
					</td>
					<%        }
       } else {  %>
					<td class="rsCell">
						<%=strResult%>
					</td>
					<%     }
		 String definition = "";
		 // add other attributes
		 for (int m = 1; m < k; m++)
		 {
           strResult = (String)results.get(i+m);
           if (strResult == null) strResult = "";
           if ((defExists)&&(m==defIndex)){
              definition = strResult;
            }else{%>
            	<td class="rsCell">
					<%=strResult%>
	    		</td>
     <% }} %>
					<!-- <td><a href="javascript:openAltNameWindow('DocTextLongName','abcd')">More >></a></td> -->
	</tr>
	<%if (defExists){ 
		 int colspan = k-1;
		 String id1 = "def" + j;
		 String id2 = "ellipsis" + j;
		 String id3 = "definition" + j;
		 String def = "";
		 int defSize = definition.length();
		 if (defSize >  100){
		      def = definition.substring(0,100);
	          definition = definition.substring(100,defSize);
	          %>
			   <%if ((j%2) == 0){%>	
      			   <tr class="stripe">
               <%}else { %>				
			        <tr>
		        <%} %>
                <td class="rsCell">&nbsp;</td><td class="rsCell">&nbsp;</td><td class="rsCell" colspan="<%=colspan%>">
                
                <p style="margin-left: 0.5in">
						<span onclick="hideShowDef('<%=id1%>', '<%=id2%>', '<%=id3%>');"
							style="padding: 2px 2px 2px 2px; font-weight: bold; cursor: default"><img
								id="<%=id1%>" src="images/plus_8.gif"
								style="margin: 0px 0px 0px 0px"></span> Definition: <%=def%><span id="<%=id2%>">&hellip;</span><span id="<%=id3%>" style="display: none"><%=definition%>
				</span></p></td></tr>			
	     <%}else{%>
		        <%if ((j%2) == 0){%>	
           	       <tr class="stripe">
	            <%}else { %>				
			        <tr>
			    <%} %>
			    <td class="rsCell">&nbsp;</td><td class="rsCell">&nbsp;</td><td class="rsCell" colspan="<%=colspan%>"><p style="margin-left: 0.5in">
			    <span onclick="changeImage('<%=id1%>','<%=id2%>');"
							style="padding: 2px 2px 2px 2px; font-weight: bold; cursor: default"><img
								id="<%=id1%>" src="images/plus_8.gif"
								style="margin: 0px 0px 0px 0px"></span>Definition: <%=definition%></td><span id="<%=id2%>" style="display: none"></span>
			    </tr>
		<%}%>
    <%}%>
			<%
         j++;
    }
	 }
%>
			</table>
			<table>
				<input type="hidden" name="pageAction" value="nothing">
				<input type="hidden" name="AttChecked" value="<%=(k-5)%>">
				<input type="hidden" name="searchComp" value="">
				<input type="hidden" name="numSelected" value="">
				<input type="hidden" name="sortType" value="nothing">
				<input type="hidden" name="actSelected" value="Search">
				<input type="hidden" name="numAttSelected" value="">
				<input type="hidden" name="orgCompID" value="">
				<input type="hidden" name="desID" value="">
				<input type="hidden" name="desName" value="">
				<input type="hidden" name="desContext" value="">
				<input type="hidden" name="desContextID" value="">
				<input type="hidden" name="AppendAction" value="NotAppended">
				<input type="hidden" name="SelectAll" value="">
				<input type="hidden" name="isValid" value="false">
				<input type="hidden" name="serMenuAct" value="<%=StringEscapeUtils.escapeHtml(sMAction)%>"/>
				<input type="hidden" name="serRecCount" value="<%=nRecs%>">
				<input type="hidden" name="selRowID" value="">
				<!-- stores Designation Name and ID -->
				<select size="1" name="hiddenDesIDName" style="visibility:hidden;" multiple>
				</select>
				<!-- stores selected component ID and workflow status -->
				<select size="1" name="hiddenACIDStatus" style="visibility:hidden;" multiple>
				</select>

				<!-- stores results ID and Short Names -->
				<select size="1" name="hiddenSearch" style="visibility:hidden;width:50">
					<%   
      vSearchID = (Vector)session.getAttribute("SearchID");
      if (vSearchID == null)  vSearchID = new Vector();
      vSearchName = (Vector)session.getAttribute("SearchName");
      if (vSearchName == null)  vSearchName = new Vector();
      for (int i = 0; vSearchID.size()>i; i++)
      {
        String sID = (String)vSearchID.elementAt(i);
        String sName = "";
        if (vSearchName.size() > i)
          sName = (String)vSearchName.elementAt(i);
        else
          sName = "";
  %>
					<option value="<%=sID%>">
						<%=sName%>
					</option>
					<%
      }
  %>
				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName" style="visibility:hidden;">
					<% 
    vSearchASL = (Vector)session.getAttribute("SearchASL");
    if (vSearchASL == null)  vSearchASL = new Vector();
    for (int i = 0; vSearchASL.size()>i; i++)
    {
      String sASL = (String)vSearchASL.elementAt(i);
        if(sASL == null) sASL = "";
%>
					<option value="<%=sASL%>">
						<%=sASL%>
					</option>
					<%
    }
%>
				</select>
				<!-- stores results longname and Designated IDs -->
				<select size="1" name="hiddenName2" style="visibility:hidden;width:100;">

					<%    for (int i = 0; vSearchLongName.size()>i; i++)
      {
        String sName = (String)vSearchLongName.elementAt(i);
%>
					<option value="<%=sName%>">
						<%=sName%>
					</option>
					<%
      }
%>
				</select>
				<!-- store definition and context here to use it later in javascript -->
				<select size="1" name="hiddenDefSource" style="visibility:hidden;width:100">
					<%
      String sDef = "";
      for (int i = 0; vSearchDefinitionAC.size()>i; i++)
      {
          sDef = (String)vSearchDefinitionAC.elementAt(i);
          String sUsed = "";
          if (vSearchUsedContext.size() > i)
             sUsed = (String)vSearchUsedContext.elementAt(i);
          if (sUsed == null) sUsed = "";
%>
					<option value="<%=sUsed%>">
						<%=sDef%>
					</option>
					<%
      }
%>
				</select>
				<select size="1" name="hiddenMeanDescription" style="visibility:hidden;width:100">
					<%
      String sDesc = "";
      for (int i = 0; vSearchMeanDescription.size()>i; i++)
      {
          sDesc = (String)vSearchMeanDescription.elementAt(i);
%>
					<option value="<%=sDesc%>">
						<%=sDesc%>
					</option>
					<%
      }
%>
				</select>
				<select size="1" name="hiddenPVValue" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMean" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenPVMeanDesc" style="visibility:hidden;">
				</select>
				<select size="1" name="hiddenSelectedRow" style="visibility:hidden;">
				</select>
			</table>
	    	<script language="javascript">
                  getSearchComponent();
           </script>
</form>
<form name="SearchActionForm" method="post" action="">
			<input type="hidden" name="acID" value="">
			<input type="hidden" name="ac2ID" value="">
			<input type="hidden" name="itemType" value="">
			<input type="hidden" name="isValidSearch" value="false">
			<input type="hidden" name="searchComp" value="">
			<input type="hidden" name="SelContext" value="">
			<input type="hidden" name="editPVInd" value="">
			<input type="hidden" name="pageAction" value="nothing">
</form>

</td>
</tr>
</table>
</div>