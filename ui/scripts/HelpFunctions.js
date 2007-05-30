// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/HelpFunctions.js,v 1.6 2007-05-30 20:06:36 hegdes Exp $
// $Name: not supported by cvs2svn $

//Generic javascript file to link objects to context sensitive help document
//include <SCRIPT LANGUAGE="JavaScript" SRC="HelpFunctions.js"></SCRIPT>
//in the head of any page using help functions
//all objects must have the call for help doc function attached to 
//the onClick and the onContextMenu events.  onContextMenu responds to right mouse clicks.
//all objects use the this.name pointer except select boxes which use a name string:
//Inputbox:   oncontextmenu = "return showHelp(this.name); return false"  
//onHelp = "return showHelp(this.name)"
//Selectbox:  onhelp =" return showHelp('newCDE')" 
//oncontextmenu = "return showHelp('newCDE') ; return false" 

//this redirects IE help to this function.  This is left here if we use it in the future.
var helpWindow = null;
function showHelp(n){
   //can use the this pointer to pass names of objects except select boxes
   //select boxes must pass name string i.e. "SearchSelectbox"
  //n must be the name of the object and the name of the anchor in the help doc 
   var nameStr =  new String(n); 
   if (helpWindow && !helpWindow.closed)
   {
      helpWindow.close()
   }
   helpWindow = window.open(nameStr, "Help");   
//   var lW = (screen.availWidth - 660);
//   helpWindow = window.open(nameStr, "Help", "width=650,height=500,top=0,left=" + lW +",resizable=yes,scrollbars=yes")
   //location.href = nameStr;
   event.cancelBubble = true;
   return false;
}
