// Copyright (c) 2006 ScenPro, Inc.

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/alternates.js,v 1.8 2009-04-13 17:04:34 veerlah Exp $
// $Name: not supported by cvs2svn $

// Perform a general action and remember the previous action. The previous action
// is used in processing to return to a previous state.

function doAction(aobj)
{
    var prevAltAction = document.getElementsByName("prevAlternatesAction");
    var altAction = document.getElementsByName("alternatesAction");
    prevAltAction[0].value = altAction[0].value;
    altAction[0].value = aobj;
    doSubmit();
}

// Directly perform a general action. The previous action is not remembered.

function doActionDirect(aobj)
{
    var altAction = document.getElementsByName("alternatesAction");
    altAction[0].value = aobj;
    doSubmit();
}

// Perform a Cancel during an Add/Edit

function doActionCancel()
{
    var prevAltAction = document.getElementsByName("prevAlternatesAction");
    var altAction = document.getElementsByName("alternatesAction");
    altAction[0].value = prevAltAction[0].value;
    doSubmit();
}

// Submit the form for processing

function doSubmit()
{
    eobj = document.getElementById("process");
    eobj.innerText = "working...";
    eobj.textContent = "working...";
    document.alternatesForm.submit();
}
// Manage the selection of the CSI on the Add/Edit page

function selCSI(aobj)
{
    var pn = aobj.parentNode.parentNode;
    var sel = getAlreadySelCSI(pn);
    if(sel != null) {
    	sel.setAttribute("selected","none");
    	sel.style.backgroundColor="";
    }
    aobj.style.backgroundColor = "#ffff00"
    aobj.setAttribute("selected","selected");
}

// Post process the Add/Edit page load

function loaded()
{
    // Set focus to the Name/Definition field
    eobj = document.getElementsByName(parmNameDef);
    eobj[0].focus();
    
    // Filter the CSI tree using the previous text
    eobj = document.getElementsByName(parmFilterText);
    filterCSI(eobj[0]);
}

// Utility function to find the root of the tree displayed as an HTML Table

function findRoot(eobj)
{
    if (eobj.getAttribute(nodeLevel) != null)
        return eobj.parentNode;

    for (var i = 0; i < eobj.children.length; ++i)
    {
        var xobj = findRoot(eobj.children[i]);
        if (xobj != null)
            return xobj;
    }
    
    return null;
}

// Filter the CSI tree dynamically as the user types in the Filter Text

function filterCSI(tobj)
{
    var tlow = tobj.value.toLowerCase();
    var eobj = findTable();
      // Go through all the rows in the table (nodes in the tree)
    for (var i = 0; i < eobj.rows.length; ++i)
    {
        // If the text entered by the user appears in the row.
        var tt = eobj.rows[i]; 
        var text = (tt.innerText) ? tt.innerText: tt.textContent;          
        if ((text.toLowerCase().indexOf(tlow) > -1))
        {
            // Make the row visible as well as its ancetors and
            // offspring
            var b;
            tt.style.display = "block";
            var level = parseInt(tt.getAttribute(nodeLevel));
            var compLevel = level;
            for (b = i - 1; b >= 0; --b)
            {
                var prev = eobj.rows[b];
                var prevLevel = parseInt(prev.getAttribute(nodeLevel));
                if (prevLevel < compLevel)
                {
                    prev.style.display = "block";
                    compLevel = prevLevel;
                }
                if (prevLevel == 1)
                    break;
            }
            for (b = i + 1; b < eobj.rows.length; ++b)
            {
                var prev = eobj.rows[b];
                var prevLevel = parseInt(prev.getAttribute(nodeLevel));
                if (prevLevel <= level)
                    break;
                prev.style.display = "block";
            }
            i = b - 1;
        }
        
        // If the text doesn't appear, hide the row.
        else
        {
            tt.style.display = "none";
        }
    }
}

// Save the Add/Edit data.

function doSave()
{
    // Have to enter a Name/Definition
    eobj = document.getElementsByName(parmNameDef);
    if (eobj[0].value == null || eobj[0].value.length == 0)
    {
        if (nameFlag)
        {
            alert("Please enter a Name.");
        }
        else
        {
            alert("Please enter a Definition.");
        }
        eobj[0].focus();
        return;
    }

    // Have to enter a Type
    eobj = document.getElementsByName(parmType);
    if (eobj[0].selectedIndex < 1)
    {
        alert("Please select a Type.");
        eobj[0].focus();
        return;
    }

    // Have to enter a Language
    eobj = document.getElementsByName(parmLang);
    if (eobj[0].selectedIndex < 1)
    {
        alert("Please enter a Language.");
        eobj[0].focus();
        return;
    }

    // All good do the Save
    doActionDirect(actionSaveName);
}

// Perform a Classify on a Name/Definition from the Add/Edit page.

function doClassify()
{
    //verify the user selected a CSI and not a CS
    var tobj = findTable();
    var eobj = getAlreadySelCSI(tobj);
    if (eobj == null)
    {
        alert("Please select a Class Scheme Item from the hierarchy at the bottom of the page.");
        return;
    }
    else
    {
        var level = parseInt(eobj.getAttribute(nodeLevel));
        if (level == 1)
        {
            alert("You have selected a Classification Scheme, please select a Class Scheme Item.");
            return;
        }
    }
    
    var rsrvd = eobj.getAttribute(nodeCsiType);
    if (rsrvd != null && rsrvd == parmReserved)
    {
        alert("Class Scheme Item type " + parmReserved + " is reserved by the caDSR Tools and can not be chosen for Classify. Please make a different selection.");
        return;
    }

    // Do the Classify
    var aobj = document.getElementsByName(parmIdseq);
    aobj[0].value = eobj.getAttribute(nodeValue);
    doActionDirect(actionClassify);
}

// Get the special application node value for the row.

function getNodeValue(aobj)
{
    var last = aobj;
    var idseq = last.getAttribute(nodeValue);
    while (last != null && idseq == null)
    {
        last = last.parentNode;
        idseq = last.getAttribute(nodeValue);
    }
    
    return idseq;
}

// Get the special application node name for the row.

function getNodeName(aobj)
{
    var last = aobj;
    var name = last.getAttribute(nodeName);
    while (last != null && name == null)
    {
        last = last.parentNode;
        name = last.getAttribute(nodeName);
    }
    
    return name;
}

// Perform a remove association on the Add/Edit page

function removeAssoc(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doActionDirect(actionRemoveAssoc);
}

// Perform a restore association to undo a previous remove

function restoreAssoc(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doActionDirect(actionRestoreAssoc);
}

// Perform an Edit on a Name/Definition from one of the "View ..." pages

function doEdit(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doAction(actionEditNameDef);
}

// Perform a Delete on a Name/Definition from one of the "View ..." pages

function doDelete(aobj)
{
    // Always confirm a delete even if you can undo it.
    var idseq = getNodeName(aobj);
    if (confirm("Are you sure you want to delete " + idseq + "?"))
    {
	    idseq = getNodeValue(aobj);
	    
	    var eobj = document.getElementsByName(parmIdseq);
	    eobj[0].value = idseq;
	    doAction(actionDelNameDef);
    }
}

// Perform a Restore on a Name/Definition that was previously deleted

function doRestore(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doAction(actionRestoreNameDef);
}

function findTable(){
   var tobj;
   if (navigator.userAgent.indexOf('Firefox') != -1){
        var div = document.getElementById("csiList");
        if (div.childNodes[1]!= null)
           tobj = div.childNodes[1];
         
    }else{
       eobj = findRoot(document.getElementById("csiList"));
       tobj = eobj.parentNode;
    }        
  return tobj;    
}

function getAlreadySelCSI(tobj){
 for (var i=0; i<tobj.rows.length; i++){	
	       var robj = tobj.rows[i];
	       if (robj.getAttribute("selected") == "selected")
	         return robj;
	    }
}
