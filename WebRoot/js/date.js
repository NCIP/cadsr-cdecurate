
var calDivID = "scenCalendar2009v1"; // ID assigned to the Calendar control
var calMonNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
var calStyleSpanDay = "cursor: default; padding: 4px 4px 4px 4px";
var calStyleSpanHdr = "padding: 0px 5px 0px 5px; cursor: default";
var calStyleBGColor1 = "#ffffff";
var calStyleBGColor2 = "#dfdf99";
var calStyleBGColor3 = "#d8d8d8";
var calStyleAncColor = "#aa0066";

// Main entry point, provide the "name" of the input control.
function calendar(input, evnt)
{
    // If this is the first time, create the calendar <div>
    var div = document.getElementById(calDivID);
    if (div === null) {
        div = document.createElement("DIV");
        div.id = calDivID;
        div.style.backgroundColor = calStyleBGColor1;
        div.style.border = "2px inset #0000c0";
        div.style.display = "none";
        div.style.position = "absolute";
        document.body.appendChild(div);
    }

    // If it's visible, hide it.
    if (div.style.display == "block") {
        div.style.display = "none";
        return;
    }
    
    // Set the position in the window.
    calSetPosition(div, evnt);

    // Check existing value in the input control and use that to default the calendar display.
    var today = new Date();
    var fld = document.getElementsByName(input);
    if (fld !== null && fld[0].value !== null) {
        var list = fld[0].value.split(/[^0-9]/);
        if (list.length == 3) {
            today.setFullYear(list[2], Math.floor(list[0]) - 1, list[1]);
        }
    }

    // Open the calendar
    calDisplay(today, input);
}

// Select the day and put it in the input control.
function calSelect(cal, day)
{
    while (cal.nodeName != "TABLE") {
        cal = cal.parentNode;
    }
    var input = document.getElementsByName(cal.getAttribute("calInput"));
    if (input.length > 0) {
        var mon = Math.floor(cal.getAttribute("calMon")) + 1;
        input[0].value = mon + "/" + day + "/" + cal.getAttribute("calYear");
        
        var fire = input[0].getAttribute("oncalendar");
        if (fire) {
            eval(fire.replace(/this[.]/, "input[0]."));
        }
    }
    var div = document.getElementById(calDivID);
    div.style.display = "none";
}

// Open the calendar
function calDisplay(today, input)
{
    // When showing the current month, display today's date differently for emphasis.
    var ancDay = 0;
    var present = new Date();
    if (today.getMonth() == present.getMonth() && today.getFullYear() == present.getFullYear()) {
        ancDay = present.getDate();
    }

    // The calendar will be N rows of 7 columns, figure out how many blank cells to start.
    var eom = calDays(today);
    var tmon = today.getMonth();
    var tyr = today.getFullYear();
    today.setFullYear(tyr, tmon, 1);
    var dow = today.getDay();
    var table = "";
    for (var cnt = 0; cnt < dow; ++cnt) {
        table = table + "<td>&nbsp;</td>";
    }
    if (dow > 0) {
        table = "<tr>" + table;
    }
    
    // Put numbers in the calendar.
    var day = 1;
    for (; cnt < 42; ++cnt) {
        if ((cnt % 7) === 0) {
            table = table + "</tr>";
            if (day > eom) {
                // Stop when starting a new row and the last day of the month has already been added to the calendar
                break;
            }
            table = table + "<tr>";
        }
        if (day > eom) {
            // After showing the last day of the month, pad the remaining cells with blanks.
            table = table + "<td>&nbsp;</td>";
        }
        else if (day == ancDay) {
            // This is today's date, the anchor day for user reference
            table = table + "<td align=\"center\" onmouseover=\"this.style.backgroundColor = '" + calStyleBGColor2 + "';\" " +
                "onmouseout=\"this.style.backgroundColor = '" + calStyleBGColor1 + "';\" " +
                "onclick=\"calSelect(this, " + day + ");\"><span style=\"color: " + calStyleAncColor + "; " + calStyleSpanDay + "\"><b><i><u>" + day + "</u></i></b></span></td>";
        }
        else {
            // Just another day in the month
            table = table + "<td align=\"center\" onmouseover=\"this.style.backgroundColor = '" + calStyleBGColor2 + "';\" " +
                "onmouseout=\"this.style.backgroundColor = '" + calStyleBGColor1 + "';\" " +
                "onclick=\"calSelect(this, " + day + ");\"><span style=\"" + calStyleSpanDay + "\">" + day + "</span></td>";
        }
        ++day;
    }

    // Put the <table> in the calendar <div>
    var div = document.getElementById(calDivID);
    div.innerHTML = "<table calInput=\"" + input + "\" calMon=\"" + tmon + "\" calYear=\"" + tyr +
        "\"><col style=\"border-collapse: collapse; text-align: center\"><col style=\"text-align: center\">" +
        "<col style=\"text-align: center\"><col style=\"text-align: center\"><col style=\"text-align: center\"><col style=\"text-align: center\">" +
        "<col style=\"text-align: center\">" +
        "<tr><td align=\"center\" colspan=\"7\">" +
        "<span onclick=\"calShowToday(this);\" title=\"Today\" style=\"" + calStyleSpanHdr + "\">&equiv;</span>" +
        "<span style=\"" + calStyleSpanHdr + "\"><img title=\"Prev Year\" src=\"https://cdecurate-stage.nci.nih.gov/cdecurate/images/arrow_16_down.gif\" onclick=\"calChgYear(this, -1);\"></span>" +
        "<span style=\"" + calStyleSpanHdr + "\"><img title=\"Prev Month\" src=\"https://cdecurate-stage.nci.nih.gov/cdecurate/images/arrow_16_left.gif\" onclick=\"calPrev(this);\"></span>" +
        "<span style=\"" + calStyleSpanHdr + "\"><b>" + calMonNames[tmon] + "&nbsp;" + tyr + "</b></span>" +
        "<span style=\"" + calStyleSpanHdr + "\"><img title=\"Next Month\" src=\"https://cdecurate-stage.nci.nih.gov/cdecurate/images/arrow_16_right.gif\" onclick=\"calNext(this);\"></span>" +
        "<span style=\"" + calStyleSpanHdr + "\"><img title=\"Next Year\" src=\"https://cdecurate-stage.nci.nih.gov/cdecurate/images/arrow_16_up.gif\" onclick=\"calChgYear(this, 1);\"></span>" +
        "<span onclick=\"calClose();\" title=\"Close\" style=\"color: white; background-color: #aa0000; " + calStyleSpanHdr + "\">&Chi;</span>" +
        "</td></tr>" +
        "<tr style=\"background-color: " + calStyleBGColor3 + "\"><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr>" + table + "</table>";
    div.style.display = "block";
    
    var dbg = document.getElementById("debug");
    if (dbg !== null) {
        if (dbg.innerText) {
            dbg.innerText = div.innerHTML;
        }
        else {
            dbg.textContent = div.innerHTML;
        }
    }
}

// Close/hide the calendar
function calClose()
{
    var div = document.getElementById(calDivID);
    div.style.display = "none";
}

// Jump to the current month.
function calShowToday(cal)
{
    while (cal.nodeName != "TABLE")
    {
        cal = cal.parentNode;
    }
    calDisplay(new Date(), cal.getAttribute("calInput"));
}

// Jump to last month, don't forget to adjust the year when in Jan.
function calPrev(cal)
{
    while (cal.nodeName != "TABLE")
    {
        cal = cal.parentNode;
    }
    var nmon = cal.getAttribute("calMon") - 1;
    var nyr = cal.getAttribute("calYear");
    if (nmon < 0) {
        nmon = calMonNames.length - 1;
        nyr = nyr - 1;
    }
    var today = new Date();
    today.setFullYear(nyr, nmon, 1);
    calDisplay(today, cal.getAttribute("calInput"));
}

// Jump to last month, don't forget to adjust the year when in Jan.
function calChgYear(cal, inc)
{
    while (cal.nodeName != "TABLE")
    {
        cal = cal.parentNode;
    }
    var nmon = cal.getAttribute("calMon");
    var nyr = Math.floor(cal.getAttribute("calYear")) + inc;
    var today = new Date();
    today.setFullYear(nyr, nmon, 1);
    calDisplay(today, cal.getAttribute("calInput"));
}

// Jump to the next month, don't forget to adjust the year when in Dec.
function calNext(cal)
{
    while (cal.nodeName != "TABLE")
    {
        cal = cal.parentNode;
    }
    var nmon = Math.floor(cal.getAttribute("calMon")) + 1;
    var nyr = cal.getAttribute("calYear");
    if (nmon == calMonNames.length) {
        nmon = 0;
        nyr = Math.floor(nyr) + 1;
    }
    var today = new Date();
    today.setFullYear(nyr, nmon, 1);
    calDisplay(today, cal.getAttribute("calInput"));
}

// Calculate the number of days in a month by subtracting the first day of next month from the first day of
// the month/year specified.
function calDays(today)
{
   var next = new Date();
    var prev = new Date();

    var mon = today.getMonth();
    var nxm = mon + 1;
    var nyr = today.getFullYear() + Math.floor(nxm / 12);
    nxm = nxm % 12;
    prev.setFullYear(today.getFullYear(), mon, 1);
    next.setFullYear(nyr, nxm, 1);
    var minutes = 1000 * 60;
    var hours = minutes * 60;
    var days = hours * 24;
    return Math.round((next.getTime() - prev.getTime()) / days);

}

function calSetPosition(div, evnt)
{
    var targ;
    if (evnt.currentTarget) {
        targ = evnt.currentTarget;
    }
    else if (evnt.target) {
        targ = evnt.target;
    }
    else if (evnt.srcElement) {
        targ = evnt.srcElement;
    }
    
    var scrollTop = document.documentElement.scrollTop > document.body.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop; 
	var scrollLeft = document.documentElement.scrollLeft > document.body.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft; 
 
    var left = scrollLeft + (evnt.clientX + targ.width) + "px";
    var top = scrollTop + evnt.clientY + "px";
    div.style.top = top;
    div.style.left = left;
}