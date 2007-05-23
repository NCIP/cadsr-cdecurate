// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/AddNewListOption.js,v 1.2 2007-05-23 04:37:49 hegdes Exp $
// $Name: not supported by cvs2svn $

function AddToList(form, list)
{
   //alert("AddToList");
   var newOption = null;
   var selectedIdx = list.selectedIndex;
   if (selectedIdx >= 0)
   {
      var selectedValue = list[list.selectedIndex].value;
      if (selectedValue == "createNew")
      {
         newOption = trim(prompt("Enter another value", ""));
         if (newOption != null && newOption.length > 0)
            AddOption(list, newOption, newOption, form);
         else
         {
            if (list[0].value != "createNew")
               list[0].selected = true;
            else 
               list[1].selected = true;
         }
      }
   }
}


function AddOption(OptionList, OptionValue, OptionText, formName) 
{
   // Add option to the bottom of the list
   OptionList[OptionList.length] = new Option(OptionText, OptionValue, null, selected=true);
}


function trim(inputString) 
{
   // Removes leading and trailing spaces from the passed string. Also removes
   // consecutive spaces and replaces it with one space. If something besides
   // a string is passed in (null, custom object, etc.) then return the input.
   if (typeof inputString != "string") { return inputString; }
   var retValue = inputString;
   var ch = retValue.substring(0, 1);
   while (ch == " ") { // Check for spaces at the beginning of the string
      retValue = retValue.substring(1, retValue.length);
      ch = retValue.substring(0, 1);
   }
   ch = retValue.substring(retValue.length-1, retValue.length);
   while (ch == " ") { // Check for spaces at the end of the string
      retValue = retValue.substring(0, retValue.length-1);
      ch = retValue.substring(retValue.length-1, retValue.length);
   }
   while (retValue.indexOf("  ") != -1) { // Note that there are two spaces in the string - look for multiple spaces within the string
      retValue = retValue.substring(0, retValue.indexOf("  ")) + retValue.substring(retValue.indexOf("  ")+1, retValue.length); // Again, there are two spaces in each of the strings
   }
   return retValue; // Return the trimmed string back to the user
} // Ends the "trim" function
