//
//
//
//
function editCell (cell) {
  if (document.all) {
    cell.innerHTML =
      '<INPUT ' +
      ' ID="editCell"' +
      ' ONCLICK="event.cancelBubble = true;"' + 
      ' ONCHANGE="setCell(this.parentElement, this.value)" ' +
      ' ONBLUR="setCell(this.parentElement, this.value)" ' +
      ' VALUE="' + cell.innerText + '"' +
      ' SIZE="' + cell.innerText.length + '"' +
      '>';
    document.all.editCell.focus();
    document.all.editCell.select();
  }
  else if (document.getElementById) {
    cell.normalize();
    var input = document.createElement('INPUT');
    input.setAttribute('value', cell.firstChild.nodeValue);
    input.setAttribute('size', cell.firstChild.nodeValue.length);
    input.onchange = function (evt) { setCell(this.parentNode, 
this.value); };
    input.onclick = function (evt) { 
      evt.cancelBubble = true;
      if (evt.stopPropagation)
        evt.stopPropagation();
    };
    cell.replaceChild(input, cell.firstChild);
    input.focus();
    input.select();
  }

}
function setCell (cell, value) {
  if (document.all)
    cell.innerText = value;
  else if (document.getElementById)
    cell.replaceChild(document.createTextNode(value), cell.firstChild);
}


