var weekend = [0,6];
var weekendColor = "#e0e0e0";
var fontface = "Verdana";   //"Arial, Helvetica, sans-serif";
var fontsize = 2;

var gNow = new Date();
var ggWinCal;
var vWinCal = null;
isNav = (navigator.appName.indexOf("Netscape") != -1) ? true : false;
isIE = (navigator.appName.indexOf("Microsoft") != -1) ? true : false;

Calendar.Months = ["January", "February", "March", "April", "May", "June",
"July", "August", "September", "October", "November", "December"];

// Non-Leap year Month days..
Calendar.DOMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
// Leap year Month days..
Calendar.lDOMonth = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

function Calendar(p_item, p_WinCal, p_month, p_year, p_format) {
	if ((p_month == null) && (p_year == null))	return;

	if (p_WinCal == null)
		this.gWinCal = ggWinCal;
	else
		this.gWinCal = p_WinCal;
	
	if (p_month == null) {
		this.gMonthName = null;
		this.gMonth = null;
		this.gYearly = true;
	} else {
		this.gMonthName = Calendar.get_month(p_month);
		this.gMonth = new Number(p_month);
		this.gYearly = false;
	}

	this.gYear = p_year;
	this.gFormat = p_format;
	this.gBGColor = "white";
	this.gFGColor = "black";
	this.gTextColor = "black";
	this.gHeaderColor = "black";
	this.gReturnItem = p_item;
}

Calendar.get_month = Calendar_get_month;
Calendar.get_daysofmonth = Calendar_get_daysofmonth;
Calendar.calc_month_year = Calendar_calc_month_year;
Calendar.print = Calendar_print;

function Calendar_get_month(monthNo) {
	return Calendar.Months[monthNo];
}

function Calendar_get_daysofmonth(monthNo, p_year) {
	/* 
	Check for leap year ..
	1.Years evenly divisible by four are normally leap years, except for... 
	2.Years also evenly divisible by 100 are not leap years, except for... 
	3.Years also evenly divisible by 400 are leap years. 
	*/
	if ((p_year % 4) == 0) {
		if ((p_year % 100) == 0 && (p_year % 400) != 0)
			return Calendar.DOMonth[monthNo];
	
		return Calendar.lDOMonth[monthNo];
	} else
		return Calendar.DOMonth[monthNo];
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

function Calendar_print() {
	ggWinCal.print();
}

function Calendar_calc_month_year(p_Month, p_Year, incr) {
	/* 
	Will return an 1-D array with 1st element being the calculated month 
	and second being the calculated year 
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();
	
	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}
	
	return ret_arr;
}

// This is for compatibility with Navigator 3, we have to create and discard one object before the prototype object exists.
new Calendar();

Calendar.prototype.getMonthlyCalendarCode = function() {
	var vCode = "";
	var vHeader_Code = "";
	var vData_Code = "";
	
	// Begin Table Drawing code here..
	vCode = vCode + "<TABLE WIDTH='100%' BORDER=1 BGCOLOR=\"" + this.gBGColor + "\">";
	
	vHeader_Code = this.cal_header();
	vData_Code = this.cal_data();
	vCode = vCode + vHeader_Code + vData_Code;
	
	vCode = vCode + "</TABLE>";
	
	return vCode;
}

Calendar.prototype.show = function() {
	var vCode = "";
	
	this.gWinCal.document.open();

	// Setup the page...
	this.wwrite("<html>");
	this.wwrite("<head><title>Calendar</title>");
	this.wwrite("</head>");

	this.wwrite("<body " + 
		"link=\"" + this.gLinkColor + "\" " + 
		"vlink=\"" + this.gLinkColor + "\" " +
		"alink=\"" + this.gLinkColor + "\" " +
		"text=\"" + this.gTextColor + "\">");
	this.wwriteA("<FONT FACE='" + fontface + "' SIZE='" + fontsize + "'><B>");
	this.wwriteA(this.gMonthName + " " + this.gYear);
	this.wwriteA("</B><BR>");

	// Show navigation buttons
	var prevMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];

	var nextMMYYYY = Calendar.calc_month_year(this.gMonth, this.gYear, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];
	
	this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'><TR><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)-1) + "', '" + this.gFormat + "'" +
		");" +
		"\"><<<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + prevMM + "', '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\"><<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"javascript:window.print();\">Print</A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + nextMM + "', '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">><\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', '" + this.gMonth + "', '" + (parseInt(this.gYear)+1) + "', '" + this.gFormat + "'" +
		");" +
		"\">>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for the month..
	vCode = this.getMonthlyCalendarCode();
	this.wwrite(vCode);

	this.wwrite("</font></body></html>");
	this.gWinCal.document.close();
}

Calendar.prototype.showY = function() {
	var vCode = "";
	var i;
	var vr, vc, vx, vy;		// Row, Column, X-coord, Y-coord
	var vxf = 285;			// X-Factor
	var vyf = 200;			// Y-Factor
	var vxm = 10;			// X-margin
	var vym;				// Y-margin
	if (isIE)	vym = 75;
	else if (isNav)	vym = 25;
	
	this.gWinCal.document.open();

	this.wwrite("<html>");
	this.wwrite("<head><title>Calendar</title>");
	this.wwrite("<style type='text/css'>\n<!--");
	for (i=0; i<12; i++) {
		vc = i % 3;
		if (i>=0 && i<= 2)	vr = 0;
		if (i>=3 && i<= 5)	vr = 1;
		if (i>=6 && i<= 8)	vr = 2;
		if (i>=9 && i<= 11)	vr = 3;
		
		vx = parseInt(vxf * vc) + vxm;
		vy = parseInt(vyf * vr) + vym;

		this.wwrite(".lclass" + i + " {position:absolute;top:" + vy + ";left:" + vx + ";}");
	}
	this.wwrite("-->\n</style>");
	this.wwrite("</head>");

	this.wwrite("<body " + 
		"link=\"" + this.gLinkColor + "\" " + 
		"vlink=\"" + this.gLinkColor + "\" " +
		"alink=\"" + this.gLinkColor + "\" " +
		"text=\"" + this.gTextColor + "\">");
	this.wwrite("<FONT FACE='" + fontface + "' SIZE='" + fontsize + "'><B>");
	this.wwrite("Year : " + this.gYear);
	this.wwrite("</B><BR>");

	// Show navigation buttons
	var prevYYYY = parseInt(this.gYear) - 1;
	var nextYYYY = parseInt(this.gYear) + 1;
	
	this.wwrite("<TABLE WIDTH='100%' BORDER=1 CELLSPACING=0 CELLPADDING=0 BGCOLOR='#e0e0e0'><TR><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', null, '" + prevYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\" alt='Prev Year'><<<\/A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"javascript:window.print();\">Print</A>]</TD><TD ALIGN=center>");
	this.wwrite("[<A HREF=\"" +
		"javascript:window.opener.Build(" + 
		"'" + this.gReturnItem + "', null, '" + nextYYYY + "', '" + this.gFormat + "'" +
		");" +
		"\">>><\/A>]</TD></TR></TABLE><BR>");

	// Get the complete calendar code for each month..
	var j;
	for (i=11; i>=0; i--) {
		if (isIE)
			this.wwrite("<DIV ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");
		else if (isNav)
			this.wwrite("<LAYER ID=\"layer" + i + "\" CLASS=\"lclass" + i + "\">");

		this.gMonth = i;
		this.gMonthName = Calendar.get_month(this.gMonth);
		vCode = this.getMonthlyCalendarCode();
		this.wwrite(this.gMonthName + "/" + this.gYear + "<BR>");
		this.wwrite(vCode);

		if (isIE)
			this.wwrite("</DIV>");
		else if (isNav)
			this.wwrite("</LAYER>");
	}

	this.wwrite("</font><BR></body></html>");
	this.gWinCal.document.close();
}

Calendar.prototype.wwrite = function(wtext) {
	this.gWinCal.document.writeln(wtext);
}

Calendar.prototype.wwriteA = function(wtext) {
	this.gWinCal.document.write(wtext);
}

Calendar.prototype.cal_header = function() {
	var vCode = "";
	
	vCode = vCode + "<TR>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Sun</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Mon</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Tue</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Wed</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Thu</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='14%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Fri</B></FONT></TD>";
	vCode = vCode + "<TD WIDTH='16%'><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='" + this.gHeaderColor + "'><B>Sat</B></FONT></TD>";
	vCode = vCode + "</TR>";
	
	return vCode;
}

Calendar.prototype.cal_data = function() {
	var vDate = new Date();
	vDate.setDate(1);
	vDate.setMonth(this.gMonth);
	vDate.setFullYear(this.gYear);

	var vFirstDay=vDate.getDay();
	var vDay=1;
	var vLastDay=Calendar.get_daysofmonth(this.gMonth, this.gYear);
	var vOnLastDay=0;
	var vCode = "";

	/*
	Get day for the 1st of the requested month/year..
	Place as many blank cells before the 1st day of the month as necessary. 
	*/

	vCode = vCode + "<TR>";
	for (i=0; i<vFirstDay; i++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(i) + "><FONT SIZE='" + fontsize + "' FACE='" + fontface + "'> </FONT></TD>";
	}

	// Write rest of the 1st week
	for (j=vFirstDay; j<7; j++) {
		vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='" + fontsize + "' FACE='" + fontface + "'>" + 
			this.getDayHREF(vDay) + 
			"</FONT></TD>";
		vDay=vDay + 1;
	}
	vCode = vCode + "</TR>";

	// Write the rest of the weeks
	for (k=2; k<7; k++) {
		vCode = vCode + "<TR>";

		for (j=0; j<7; j++) {
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j) + "><FONT SIZE='" + fontsize + "' FACE='" + fontface + "'>" + 
				this.getDayHREF(vDay) + 
				"</FONT></TD>";
			vDay=vDay + 1;

			if (vDay > vLastDay) {
				vOnLastDay = 1;
				break;
			}
		}

		if (j == 6)
			vCode = vCode + "</TR>";
		if (vOnLastDay == 1)
			break;
	}
	
	// Fill up the rest of last week with proper blanks, so that we get proper square blocks
	for (m=1; m<(7-j); m++) {
		if (this.gYearly)
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='gray'> </FONT></TD>";
		else
			vCode = vCode + "<TD WIDTH='14%'" + this.write_weekend_string(j+m) + 
			"><FONT SIZE='" + fontsize + "' FACE='" + fontface + "' COLOR='gray'>" + m + "</FONT></TD>";
	}
	
	return vCode;
}

Calendar.prototype.format_day = function(vday) {
	var vNowDay = gNow.getDate();
	var vNowMonth = gNow.getMonth();
	var vNowYear = gNow.getFullYear();

	if (vday == vNowDay && this.gMonth == vNowMonth && this.gYear == vNowYear)
		return ("<FONT COLOR=\"RED\"><B>" + vday + "</B></FONT>");
	else
		return (vday);
}

Calendar.prototype.write_weekend_string = function(vday) {
	var i;

	// Return special formatting for the weekend day.
	for (i=0; i<weekend.length; i++) {
		if (vday == weekend[i])
			return (" BGCOLOR=\"" + weekendColor + "\"");
	}
	
	return "";
}

Calendar.prototype.format_data = function(p_day) {
	var vData;
	var vMonth = 1 + this.gMonth;
	vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
	var vMon = Calendar.get_month(this.gMonth).substr(0,3).toUpperCase();
	var vFMon = Calendar.get_month(this.gMonth).toUpperCase();
	var vY4 = new String(this.gYear);
	var vY2 = new String(this.gYear.substr(2,2));
	var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;

	switch (this.gFormat) {
		case "MM\/DD\/YYYY" :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
			break;
		case "MM\/DD\/YY" :
			vData = vMonth + "\/" + vDD + "\/" + vY2;
			break;
		case "MM-DD-YYYY" :
			vData = vMonth + "-" + vDD + "-" + vY4;
			break;
		case "MM-DD-YY" :
			vData = vMonth + "-" + vDD + "-" + vY2;
			break;

		case "DD\/MON\/YYYY" :
			vData = vDD + "\/" + vMon + "\/" + vY4;
			break;
		case "DD\/MON\/YY" :
			vData = vDD + "\/" + vMon + "\/" + vY2;
			break;
		case "DD-MON-YYYY" :
			vData = vDD + "-" + vMon + "-" + vY4;
			break;
		case "DD-MON-YY" :
			vData = vDD + "-" + vMon + "-" + vY2;
			break;

		case "DD\/MONTH\/YYYY" :
			vData = vDD + "\/" + vFMon + "\/" + vY4;
			break;
		case "DD\/MONTH\/YY" :
			vData = vDD + "\/" + vFMon + "\/" + vY2;
			break;
		case "DD-MONTH-YYYY" :
			vData = vDD + "-" + vFMon + "-" + vY4;
			break;
		case "DD-MONTH-YY" :
			vData = vDD + "-" + vFMon + "-" + vY2;
			break;

		case "DD\/MM\/YYYY" :
			vData = vDD + "\/" + vMonth + "\/" + vY4;
			break;
		case "DD\/MM\/YY" :
			vData = vDD + "\/" + vMonth + "\/" + vY2;
			break;
		case "DD-MM-YYYY" :
			vData = vDD + "-" + vMonth + "-" + vY4;
			break;
		case "DD-MM-YY" :
			vData = vDD + "-" + vMonth + "-" + vY2;
			break;

		default :
			vData = vMonth + "\/" + vDD + "\/" + vY4;
	}

	return vData;
}

function Build(p_item, p_month, p_year, p_format) {
	var p_WinCal = ggWinCal;
	gCal = new Calendar(p_item, p_WinCal, p_month, p_year, p_format);

	// Customize your Calendar here..
	gCal.gBGColor="white";
	gCal.gLinkColor="black";
	gCal.gTextColor="black";
	gCal.gHeaderColor="darkgreen";

	// Choose appropriate show function
	if (gCal.gYearly)	gCal.showY();
	else	gCal.show();
}

// This is called after a session expires in an open window
function closeWindow()
{
  window.close();
}

function show_calendar() {
	/* 
		p_month : 0-11 for Jan-Dec; 12 for All Months.
		p_year	: 4-digit year
		p_format: Date format (mm/dd/yyyy, dd/mm/yy, ...)
		p_item	: Return Item.
	*/

	p_item = arguments[0];
	if (arguments[1] == null)
		p_month = new String(gNow.getMonth());
	else
		p_month = arguments[1];
	if (arguments[2] == "" || arguments[2] == null)
		p_year = new String(gNow.getFullYear().toString());
	else
		p_year = arguments[2];
	if (arguments[3] == null)
		p_format = "MM/DD/YYYY";
	else
		p_format = arguments[3];

  if (vWinCal && !vWinCal.closed)
		vWinCal.close()
	vWinCal = window.open("", "Calendar", 
		"width=250,height=250,status=no,resizable=yes,top=200,left=200");
	vWinCal.opener = self;
	ggWinCal = vWinCal;

	Build(p_item, p_month, p_year, p_format);
}
/*
Yearly Calendar Code Starts here
*/
function show_yearly_calendar(p_item, p_year, p_format) {
	// Load the defaults..
	if (p_year == null || p_year == "")
		p_year = new String(gNow.getFullYear().toString());
	if (p_format == null || p_format == "")
		p_format = "MM/DD/YYYY";

	var vWinCal = window.open("", "Calendar", "scrollbars=yes");
	vWinCal.opener = self;
	ggWinCal = vWinCal;

	Build(p_item, null, p_year, p_format);
}


 function validateDate(beginDate, endDate)
 {
     var match = beginDate.search("/");
     var substrEnd = beginDate.slice(match + 1);
     var match2 = substrEnd.search("/");
     var begMonth = beginDate.substr(0,match);
     var begMonthInt = parseInt(begMonth);    
     var begDay = beginDate.substr((match + 1), match2);
     var begDayInt = parseInt(begDay);  
     var begYear = substrEnd.substr(match2 + 1);
     var begYearInt = parseInt(begYear);


     var matchE = endDate.search("/");
     var substrEndE = endDate.slice(matchE + 1);
     var match2E = substrEndE.search("/"); 
     var endMonth = endDate.substr(0,matchE);
     var endMonthInt = parseInt(endMonth);
     var endDay = endDate.substr((matchE + 1), match2E);
     var endDayInt = parseInt(endDay);  
     var endYear = substrEndE.substr(match2E + 1);
     var endYearInt = parseInt(endYear);

	   var beginDate2 = new Date();  
     beginDate2.setMonth(begMonth - 1);
     beginDate2.setDate(begDay);
     beginDate2.setFullYear(begYear);
     var endDate2 = new Date();
     endDate2.setMonth(endMonth - 1);
     endDate2.setDate(endDay);
     endDate2.setFullYear(endYear);

	     if (isNaN(begDayInt)) { alert("Begin day must be a number 01 to 31.");return false;};
           else if (beginDate.length>10) { alert("Begin Date must be of the format dd/mm/yyyy. Please enter a valid date.");return false;};
           else if (endDate.length>10) { alert("End Date must be of the format dd/mm/yyyy. Please enter a valid date.");return false;};
           else if (isNaN(begMonthInt)) { alert("Begin month must be a number 01 to 12.");return false;};
           else if (isNaN(begYearInt)) { alert("Begin year should be a number between 1000 and 9999.");return false;};
           else if (endDay != "" && isNaN(endDayInt)) { alert("End day must be a number 01 to 31.");return false;};
           else if (endMonth != "" && isNaN(endMonthInt)) { alert("End month must be a number 01 to 12.");return false;};
           else if (endYear != "" && isNaN(endYearInt)) { alert("End year should be a number between 1000 and 9999.");return false;};
	         else if (begDay < 1 || begDay > 31) { alert("Begin day must be a number 01 to 31.");return false;};
           else if (begMonth < 1 || begMonth > 12) { alert("Begin month must be a number 01 to 12.");return false;};
           else if (begYear < 1000 || begYear > 9999) { alert("Begin year should be between 1000 and 9999.");return false;}; 
           else if (endDate != "" && (endDay < 1 || endDay > 31)) { alert("End day must be a number 01 to 31.");return false;};
           else if (endMonth != "" && (endMonth < 1 || endMonth > 12)) { alert("End month must be a number 01 to 12.");return false;};
           else if (endYear != "" && (endYear < 1000 || endYear > 9999)) { alert("End year should be between 1000 and 9999.");return false;} 
  	     else if ((beginDate2.getTime() > endDate2.getTime()) && endDate != "") 
           { 
			alert("End Date is before Begin Date");
			return false;
	     }
		else if ((begMonthInt == 2 || begMonthInt == 02)&&((begYear%4==0)&&((begYear%100!=0)||(begYear%400==0))))
     		{
        		if ( begDay >29 ||  begDay <1)
        		{
           		alert("Begin Day Must be within 1 and 29 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	      else if ((endMonthInt == 2 || endMonthInt == 02)&&((endYear%4==0)&&((endYear%100!=0)||(endYear%400==0))))
     		{
        		if ( endDay >29 ||  endDay <1)
        		{
           		alert("End Day Must be within 1 and 29 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	      else if (begMonthInt == 2 || begMonthInt == 02)
     		{
        		if ( begDay >28 ||  begDay <1)
        		{
           		alert("Begin Day Must be within 1 and 28 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	      else if (endMonthInt == 2 || endMonthInt == 02)
     		{
        		if ( endDay >28 ||  endDay <1)
        		{
           		alert("End Day Must be within 1 and 28 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	     else if (begMonthInt == 1 || begMonthInt == 3 ||begMonthInt == 5 ||begMonthInt == 7 || begMonthInt == 01 || begMonthInt == 03 ||begMonthInt == 05 ||begMonthInt == 07)
     	     {
        		if ( begDay > 31 ||  begDay < 1)
        		{
           		alert("Begin Day must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     	     }
     		else if (begMonthInt == 8 || begMonthInt == 10 ||begMonthInt == 12 || begMonthInt == 08)
     		{
        		if ( begDay > 31 ||  begDay < 1)
        		{
           		alert("Begin Day Must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
     		else if (begMonthInt == 4 || begMonthInt == 6 ||begMonthInt == 9 ||begMonthInt == 11 || begMonthInt == 04 || begMonthInt == 06 ||begMonthInt == 09)
     		{
        		if ( begDay > 30 ||  begDay < 1)
        		{
          		 alert("Begin Day Must be within 1 and 30 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	      if (endMonthInt == 1 || endMonthInt == 3 ||endMonthInt == 5 ||endMonthInt == 7 || endMonthInt == 01 || endMonthInt == 03 ||endMonthInt == 05 ||endMonthInt == 07)
     	      {
        		if ( endDay > 31 ||  endDay < 1)
        		{
           		alert("End Day must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     	      }
     		else if (endMonthInt == 8 || endMonthInt == 10 ||endMonthInt == 12 || endMonthInt == 08)
     		{
        		if ( endDay > 31 ||  endDay < 1)
        		{
           		alert("End Day Must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
     		else if (endMonthInt == 4 || endMonthInt == 6 ||endMonthInt == 9 ||endMonthInt == 11 || endMonthInt == 04 || endMonthInt == 06 ||endMonthInt == 09)
     		{
        		if (endDay > 30 ||  endDay < 1)
        		{
          		 alert("End Day Must be within 1 and 30 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
		return true;  
}

 function validateEndDate(endDate)
 {
   /*  var match = beginDate.search("/");
     var substrEnd = beginDate.slice(match + 1);
     var match2 = substrEnd.search("/");
     var begMonth = beginDate.substr(0,match);
     var begMonthInt = parseInt(begMonth);    
     var begDay = beginDate.substr((match + 1), match2);
     var begDayInt = parseInt(begDay);  
     var begYear = substrEnd.substr(match2 + 1);
     var begYearInt = parseInt(begYear);  */


     var matchE = endDate.search("/");
     var substrEndE = endDate.slice(matchE + 1);
     var match2E = substrEndE.search("/"); 
     var endMonth = endDate.substr(0,matchE);
     var endMonthInt = parseInt(endMonth);
     var endDay = endDate.substr((matchE + 1), match2E);
     var endDayInt = parseInt(endDay);  
     var endYear = substrEndE.substr(match2E + 1);
     var endYearInt = parseInt(endYear);

	 /*  var beginDate2 = new Date();  
     beginDate2.setMonth(begMonth - 1);
     beginDate2.setDate(begDay);
     beginDate2.setFullYear(begYear);  */
     var endDate2 = new Date();
     endDate2.setMonth(endMonth - 1);
     endDate2.setDate(endDay);
     endDate2.setFullYear(endYear);

	   if (isNaN(endDayInt)) { alert("Begin day must be a number 01 to 31.");return false;};
  //   else if (beginDate.length>10) { alert("Begin Date must be of the format dd/mm/yyyy. Please enter a valid date.");return false;};
     else if (endDate.length>10) { alert("End Date must be of the format dd/mm/yyyy. Please enter a valid date.");return false;};
 //    else if (isNaN(begMonthInt)) { alert("Begin month must be a number 01 to 12.");return false;};
  //   else if (isNaN(begYearInt)) { alert("Begin year should be a number between 1000 and 9999.");return false;};
     else if (endDay != "" && isNaN(endDayInt)) { alert("End day must be a number 01 to 31.");return false;};
     else if (endMonth != "" && isNaN(endMonthInt)) { alert("End month must be a number 01 to 12.");return false;};
     else if (endYear != "" && isNaN(endYearInt)) { alert("End year should be a number between 1000 and 9999.");return false;};
//     else if (begDay < 1 || begDay > 31) { alert("Begin day must be a number 01 to 31.");return false;};
 //    else if (begMonth < 1 || begMonth > 12) { alert("Begin month must be a number 01 to 12.");return false;};
 //    else if (begYear < 1000 || begYear > 9999) { alert("Begin year should be between 1000 and 9999.");return false;}; 
     else if (endDate != "" && (endDay < 1 || endDay > 31)) { alert("End day must be a number 01 to 31.");return false;};
     else if (endMonth != "" && (endMonth < 1 || endMonth > 12)) { alert("End month must be a number 01 to 12.");return false;};
     else if (endYear != "" && (endYear < 1000 || endYear > 9999)) { alert("End year should be between 1000 and 9999.");return false;} 
  /*   else if ((beginDate2.getTime() > endDate2.getTime()) && endDate != "") 
           { 
			alert("End Date is before Begin Date");
			return false;
	     } 
      else if ((begMonthInt == 2 || begMonthInt == 02)&&((begYear%4==0)&&((begYear%100!=0)||(begYear%400==0))))
     	{
        		if ( begDay >29 ||  begDay <1)
        		{
           		alert("Begin Day Must be within 1 and 29 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}*/
	      else if ((endMonthInt == 2 || endMonthInt == 02)&&((endYear%4==0)&&((endYear%100!=0)||(endYear%400==0))))
     		{
        		if ( endDay >29 ||  endDay <1)
        		{
           		alert("End Day Must be within 1 and 29 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
	  /*    else if (begMonthInt == 2 || begMonthInt == 02)
     		{
        		if ( begDay >28 ||  begDay <1)
        		{
           		alert("Begin Day Must be within 1 and 28 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}  */
	      else if (endMonthInt == 2 || endMonthInt == 02)
     		{
        		if ( endDay >28 ||  endDay <1)
        		{
           		alert("End Day Must be within 1 and 28 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
   /*     else if (begMonthInt == 1 || begMonthInt == 3 ||begMonthInt == 5 ||begMonthInt == 7 || begMonthInt == 01 || begMonthInt == 03 ||begMonthInt == 05 ||begMonthInt == 07)
     	  {
        		if ( begDay > 31 ||  begDay < 1)
        		{
           		alert("Begin Day must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     	  }
     		else if (begMonthInt == 8 || begMonthInt == 10 ||begMonthInt == 12 || begMonthInt == 08)
     		{
        		if ( begDay > 31 ||  begDay < 1)
        		{
           		alert("Begin Day Must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
     		else if (begMonthInt == 4 || begMonthInt == 6 ||begMonthInt == 9 ||begMonthInt == 11 || begMonthInt == 04 || begMonthInt == 06 ||begMonthInt == 09)
     		{
        		if ( begDay > 30 ||  begDay < 1)
        		{
          		 alert("Begin Day Must be within 1 and 30 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}  */
	      else if (endMonthInt == 1 || endMonthInt == 3 ||endMonthInt == 5 ||endMonthInt == 7 || endMonthInt == 01 || endMonthInt == 03 ||endMonthInt == 05 ||endMonthInt == 07)
     	  {
        		if ( endDay > 31 ||  endDay < 1)
        		{
           		alert("End Day must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     	  }
     		else if (endMonthInt == 8 || endMonthInt == 10 ||endMonthInt == 12 || endMonthInt == 08)
     		{
        		if ( endDay > 31 ||  endDay < 1)
        		{
           		alert("End Day Must be within 1 and 31 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
     		else if (endMonthInt == 4 || endMonthInt == 6 ||endMonthInt == 9 ||endMonthInt == 11 || endMonthInt == 04 || endMonthInt == 06 ||endMonthInt == 09)
     		{
        		if (endDay > 30 ||  endDay < 1)
        		{
          		 alert("End Day Must be within 1 and 30 for this month!");
           		//ctl.focus();
           		return false;
        		}
     		}
		return true; 
}

  //allow emtpy  begin date and end dates but check validity if not empty 
  function areDatesValid(beginDate, endDate, acAct)
  {    
    var isValid = "valid";
    //first validate the begin date if not empty and do not allow if end date is greater than the begin date 
    if (beginDate != "")
    {
			var status = validateDate(beginDate, endDate); //validateDate is in date-picker.js
      if (!status) isValid = "invalid";
      return isValid;
    }
    //do not allow to use end date if no begin date for new acs
    else if (endDate != "" && acAct != "Edit")
    {
      alert("If you select an End Date, you must also select a Begin Date");
      return "invalid";
    }
    //if no begin date, validate end date if not empty for editing ac
    else if (endDate != "")
    {
      var status = validateEndDate(endDate);
      if (!status) isValid = "invalid";
      return isValid;
    }	
    return isValid;	
  }

Calendar.prototype.getDayHREF = function(vDay)
  {  	
  	var hrefText = "";
  	//href text for pv dates
  	if (this.gReturnItem.match("PVForm") != null)
  	{
  		hrefText = "<A HREF='#' " + 
				"onClick=\"self.opener.appendDate('" + 
				this.format_data(vDay) + 
				"');window.close();\">" + 
				this.format_day(vDay) + 
			"</A>";
  	}
  	//default text
  	if (hrefText == "")
  	{
  		hrefText = "<A HREF='#' " + 
				"onClick=\"self.opener.document." + this.gReturnItem + ".value='" + 
				this.format_data(vDay) + 
				"';self.opener.document." + this.gReturnItem + ".focus();window.close();\">" + 
				this.format_day(vDay) + 
			"</A>";
	}
	return hrefText;   	
  }

  