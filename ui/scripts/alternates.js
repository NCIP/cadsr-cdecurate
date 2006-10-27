
function doAction(aobj)
{
    alternatesForm.prevAlternatesAction.value = alternatesForm.alternatesAction.value;
    alternatesForm.alternatesAction.value = aobj;
    doSubmit();
}

function doActionDirect(aobj)
{
    alternatesForm.alternatesAction.value = aobj;
    doSubmit();
}

function doActionCancel()
{
    alternatesForm.alternatesAction.value = alternatesForm.prevAlternatesAction.value;
    doSubmit();
}

function doSubmit()
{
    eobj = document.getElementById("process");
    eobj.innerText = "working...";
    alternatesForm.submit();
}

function selCSI(aobj)
{
    var pn = aobj.parentNode;
    var eobj = pn.getAttribute("nodeSelection");
    if (eobj != null)
    {
        eobj.style.backgroundColor = pn.getAttribute("nodeColor");
    }
    pn.setAttribute("nodeSelection", aobj);
    pn.setAttribute("nodeColor", aobj.style.backgroundColor);
    aobj.style.backgroundColor = "#ffff00";
}

function loaded()
{
    eobj = document.getElementsByName(parmNameDef);
    eobj[0].focus();
    
    eobj = document.getElementsByName(parmFilterText);
    filterCSI(eobj[0]);
}

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

function filterCSI(tobj)
{
    var eobj = findRoot(document.getElementById("csiList"));
    var tlow = tobj.value.toLowerCase();
    for (var i = 0; i < eobj.children.length; ++i)
    {
        var tt = eobj.children[i];
        if (tt.innerText.toLowerCase().indexOf(tlow) > -1)
        {
            var b;
            tt.style.display = "block";
            var level = parseInt(tt.getAttribute(nodeLevel));
            var compLevel = level;
            for (b = i - 1; b >= 0; --b)
            {
                var prev = eobj.children[b];
                var prevLevel = parseInt(prev.getAttribute(nodeLevel));
                if (prevLevel < compLevel)
                {
                    prev.style.display = "block";
                    compLevel = prevLevel;
                }
                if (prevLevel == 1)
                    break;
            }
            for (b = i + 1; b < eobj.children.length; ++b)
            {
                var prev = eobj.children[b];
                var prevLevel = parseInt(prev.getAttribute(nodeLevel));
                if (prevLevel <= level)
                    break;
                prev.style.display = "block";
            }
            i = b - 1;
        }
        else
        {
            tt.style.display = "none";
        }
    }
}

function doSave()
{
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

    eobj = document.getElementsByName(parmType);
    if (eobj[0].selectedIndex < 1)
    {
        alert("Please select a Type.");
        eobj[0].focus();
        return;
    }

    eobj = document.getElementsByName(parmLang);
    if (eobj[0].selectedIndex < 1)
    {
        alert("Please enter a Language.");
        eobj[0].focus();
        return;
    }

    doActionDirect(actionSaveName);
}

function doClassify()
{
    var last = findRoot(document.getElementById("csiList"));
    var eobj = last.getAttribute("nodeSelection");
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
    
    var aobj = document.getElementsByName(parmIdseq);
    aobj[0].value = eobj.getAttribute(nodeValue);
    doActionDirect(actionClassify);
}

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

function removeAssoc(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doActionDirect(actionRemoveAssoc);
}

function restoreAssoc(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doActionDirect(actionRestoreAssoc);
}

function doEdit(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doAction(actionEditNameDef);
}

function doDelete(aobj)
{
    var idseq = getNodeName(aobj);
    if (confirm("Are you sure you want to delete " + idseq + "?"))
    {
	    idseq = getNodeValue(aobj);
	    
	    var eobj = document.getElementsByName(parmIdseq);
	    eobj[0].value = idseq;
	    doAction(actionDelNameDef);
    }
}

function doRestore(aobj)
{
    var idseq = getNodeValue(aobj);
    
    var eobj = document.getElementsByName(parmIdseq);
    eobj[0].value = idseq;
    doAction(actionRestoreNameDef);
}
