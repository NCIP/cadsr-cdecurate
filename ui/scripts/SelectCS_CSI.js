// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/SelectCS_CSI.js,v 1.9 2007-05-25 05:03:27 hegdes Exp $
// $Name: not supported by cvs2svn $


//var selCSIArray = new Array();
var prevCSCSI = "";
var obj_selCS;
var obj_selCSI;
var obj_selectedCS; 
var obj_selectedCSI; 
var obj_selACCSI; 
var obj_hidCSName; 
var obj_hidCSCSI; 
var obj_hidACCSI; 
var obj_hidAC;
var obj_ACid, obj_ACname, obj_ACaction;
var altNameCount = 0;
var refDocCount = 0;

//creates these objects
function createObject(formName)
{
  obj_selCS = eval(formName + ".selCS"); 
  obj_selCSI = eval(formName + ".selCSI"); 
  obj_selectedCS = eval(formName + ".selectedCS"); 
  obj_selectedCSI = eval(formName + ".selectedCSI"); 
  obj_selCSIACList = eval(formName + ".selCSIACList"); 
  obj_selCSNAMEHidden = eval(formName + ".selCSNAMEHidden"); 
  obj_selCSCSIHidden = eval(formName + ".selCSCSIHidden"); 
  obj_selACCSIHidden = eval(formName + ".selACCSIHidden"); 
  obj_selACHidden = eval(formName + ".selACHidden");
  obj_ACname = eval(formName + ".txtLongName");
  if (formName == "document.newCDEForm" || formName == "document.designateDEForm")
  {
    obj_ACid = eval(formName + ".deIDSEQ");
    obj_ACaction = eval(formName + ".DEAction");
  }
  else if (formName == "document.newDECForm")
  {
    obj_ACid = eval(formName + ".decIDSEQ");
    obj_ACaction = eval(formName + ".DECAction");
  }
  else if (formName == "document.createVDForm")
  {
    obj_ACid = eval(formName + ".vdIDSEQ");
    obj_ACaction = eval(formName + ".VDAction");
  }
  return;
}
//-------------cs-csi hierarchy begin---------------
/*
* first loads all cs in selCS select box and loads all selected cs-csi if  exists any
* calls changeCS function when cs is selected to display its csis : loops through 
csiArray and looking at parent id and level adds tabs to make hierachy, adds options selCSI 
* when CSI is selected calls selectCSI function which checks if with in the write contexts, 
if its CS was existed and/or selected in the selectedCS options, and calls addSelectedCSI to add csi
* addSelectedCSI function calls selectHierCSI to gets all parents which will be in reverse order.
In the opposite order loop from this heierachy array, calls the addSelectCSI array to 
fill selectedCSI options.


*/
   //gets the tab spaces according to the display order.
   function getTabSpace(csiLevel, csiName)
   {
      //add display order * 4 tabs to the string variable             
      var spaceCount = (eval(csiLevel) - 1) * 4;
      var tabspace = "String.fromCharCode(160"  //add one tab code
      //loop through number of counts to add more tab codes
      for (var counter=2; counter<=spaceCount; counter++)
      {
          tabspace += ", 160";          
      }
      tabspace += ")";  //end with closing bracket.
      //add the tab to the csi
      csiName = eval(tabspace) + csiName;
      //return tabspace;  //return the string.
      return csiName;
   }

   //check the context of the selected CS.  Add only if it is in the write context list
   function checkContextCS_AC(selCS)
   {
      if (selCS != null && selCS != "")
      {
        if (writeContArray != null && writeContArray.length > 0)
        {
           for (var idx=0; idx<writeContArray.length; idx++)
           { 
              var sContext = writeContArray[idx][0];
              if (sContext != "")
              {
                var subIndex = selCS.lastIndexOf(" - " + sContext); //do not start comparison at beginning
                if (subIndex >= 0)
                  return true;
              }
           }
        }
        else
        {
           alert("Unable to get the list of writable context");
           return false;
        }
      }
      else
      {
         alert("Please select classification scheme from the drop down list");
         return false;
      }    
      return false;
   }
   
   //selects parent csi and displays it in the same order of the tree
   function selectHierCSI(thisCSid, thisCSCSIid, arrPCHier)
   {
      if (arrPCHier == null) arrPCHier = new Array();
      //get the csi name from the original array list to remove the tabs.
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //for the selected csi and cs
        if (csiArray[idx][2] == thisCSCSIid  && csiArray[idx][0] == thisCSid)
        {
          //add this array to parent child array
          arrPCHier[arrPCHier.length] = csiArray[idx];
          //check if this csi has parent id and go back to loop to add the parent to the Heir array.
          if (csiArray[idx][3] != null && csiArray[idx][3] != "")
          {
            thisCSCSIid = csiArray[idx][3];
            idx=0; //reset the loop
          }
          else
            break;
        }
      } 
      return arrPCHier;
   }

  //called before submitting the form to make hidden fields selcted.
  function selectMultiSelectList()
  {     
     //cs-csi lists
     obj_selCSNAMEHidden.length = 0;  //load the clean list
     obj_selCSCSIHidden.length = 0;
     obj_selACCSIHidden.length = 0;
     for (var i=0; i<obj_selectedCS.length; i++)  //selected cs ids
     {
        obj_selectedCS[i].selected = true;
        var csName = obj_selectedCS[i].text;
        obj_selCSNAMEHidden[i] = new Option(csName, csName);
        obj_selCSNAMEHidden[i].selected = true;
     }
     for (var idx=0; idx<selACCSIArray.length; idx++)     
     { 
        //selected cs-csi ids
        obj_selCSCSIHidden[idx] = new Option(selACCSIArray[idx][4], selACCSIArray[idx][4]);
        obj_selCSCSIHidden[idx].selected = true;
        //selected ac-csi ids
        obj_selACCSIHidden[idx] = new Option(selACCSIArray[idx][5], selACCSIArray[idx][5]);
        obj_selACCSIHidden[idx].selected = true;
        //selected ac ids stored in here for  edit
        obj_selACHidden[idx] = new Option(selACCSIArray[idx][6], selACCSIArray[idx][6]);
        obj_selACHidden[idx].selected = true;
     }
    // alert(obj_selectedCS.length + " cscsi " + selACCSIArray.length);
  }
 
  //called to load selCSI list when cs drowdown changes.
   function ChangeCS()
   {
      var CS_ID = obj_selCS[obj_selCS.selectedIndex].value;
      var CS_Name = obj_selCS[obj_selCS.selectedIndex].text;
      obj_selCSI.length = 0;  //empty the select list
      var csiIdx = 0;
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //if the csId in the array is same as the selected from dropdown, add the csi in select field.
        if (csiArray[idx][0] == CS_ID)
        {
          //var csi_id = csiArray[idx][1];  //get the csi id   
          var cs_csi_id = csiArray[idx][2];  //get the cs-csi id for uniqueness
          var csi_name = csiArray[idx][6];       //add csi name for the name
          //add tabs if the parent exists
          if (csiArray[idx][3] != null || csiArray[idx][3] == "")
             csi_name = getTabSpace(csiArray[idx][8], csi_name);  //csi level and csi name
          //add new option to csi
          obj_selCSI[csiIdx] = new Option(csi_name, cs_csi_id);
          csiIdx++;
        }          
      } 
   }
   //called from onChange event of selCSI to store the selected csi in selected cs, csi lists
   function selectCSI()
   {
      //return if no csi is selected
      if (obj_selCSI.selectedIndex < 0)
        return;
      else 
      {
        //checked the selected one if it already picked once.
        var thisCSCSI = obj_selCSI[obj_selCSI.selectedIndex].value;
        if (prevCSCSI != null && prevCSCSI != "" && prevCSCSI == thisCSCSI)
           return;
        else
           prevCSCSI = thisCSCSI; 
      }

      var isExists = false;
      //get the current length of the selected CS
      var selCSLength = obj_selectedCS.length;
      //selected CS value and text
      var selCS_id = obj_selCS[obj_selCS.selectedIndex].value;
      var selCS_name = obj_selCS[obj_selCS.selectedIndex].text;
      //check context of cs with ac context
      var isContextValid = checkContextCS_AC(selCS_name);
      if (isContextValid == false)
      {
          alert("Please make sure that the selected classification scheme's context is within the user's context");
          return;
      }
          
      //check its existance in selectedCS list
      if (selCSLength >0)
      {
         //check if selected already
         if (obj_selectedCS.selectedIndex >= 0 && 
                obj_selectedCS[obj_selectedCS.selectedIndex].value == selCS_id)
         {
            addSelectedCSI(true);  //already selected CS in the selectedCS box.
            return;
         }
         else
         {
            //unselect the earlier selected cs
            if (obj_selectedCS.selectedIndex >= 0)
              obj_selectedCS[obj_selectedCS.selectedIndex].selected = false;

            //loop through to check if the selected CS already exists in the selected CS list.
            for (var i=0; i<selCSLength; i++)
            {
              if (obj_selectedCS[i].value == selCS_id)
              {
                 isExists = true;
                 obj_selectedCS[i].selected = true;      //keep it selected if found.
                 break;
              }
            }
         }
       }
       //create a new one if not found and keep it selected.
       if (isExists == false)
       {
          obj_selectedCS[selCSLength] = new Option(selCS_name, selCS_id);
          obj_selectedCS[selCSLength].selected = true;
       }
       addSelectedCSI(false);  //newly added or selected CS in the selectedCS box.
       return;
   }

   //called from selectedCSI function
   function addSelectedCSI(wasCSSelected)
   {
      //get cs id and name from selectedCS list
      if (obj_selectedCS.selectedIndex >= 0)
      {
        var selCS_id = obj_selectedCS[obj_selectedCS.selectedIndex].value;
        var selCS_name = obj_selectedCS[obj_selectedCS.selectedIndex].text;
      }
      //get csi id and name from the selCSI list
      if (obj_selCSI.selectedIndex >= 0)
      {
        var selCSCSI_id = obj_selCSI[obj_selCSI.selectedIndex].value;
        var selCSI_name = obj_selCSI[obj_selCSI.selectedIndex].text;
      }
      //sumana - check if this is necessary
      //if (isFromEvent == true)
       // obj_selectedCSI.length = 0;   //empty selectedCSI to reload

      //if called when csi was selected, check for parent key and select all the parents 
      //and display from parent to child hierarchical order.
      var arrParentChild = new Array();  
      arrParentChild = selectHierCSI(selCS_id, selCSCSI_id, arrParentChild);
      //get the csi name from the original array list to remove the tabs.
      if (arrParentChild != null)
      {
        //display them from last to first
        for (var idx=arrParentChild.length-1; idx >= 0; idx--)
        {             
          //for the selected csi and cs
          selCSCSI_id = arrParentChild[idx][2];
          selCSI_id = arrParentChild[idx][0];
          addSelectCSI(wasCSSelected, false, selCSCSI_id);
        } 
      }
   }
   
   //matches the selected csis to the csis of the cs to rearrange in an hierarchical manner.
   function sortSelectedCSI()
   {
      //sort them properly
      var arrSelCSI = new Array();
      //store the selected csis in an array
      if (obj_selectedCSI != null && obj_selectedCSI.length >0)
      {
        for (var m=0; m<obj_selectedCSI.length; m++)
        {
          arrSelCSI[arrSelCSI.length] = new Array(obj_selectedCSI[m].value, obj_selectedCSI[m].text);
        }
      }
      if (arrSelCSI.length > 0)
      {
        obj_selectedCSI.length = 0;  //empty the select list
        //loop through selCSI select list get the csis
        for (var k=0; k<csiArray.length; k++)
        {
          var selCSIid = csiArray[k][2];
          if (obj_selectedCS.selectedIndex >= 0)
          {
            var selCS_id = obj_selectedCS[obj_selectedCS.selectedIndex].value;
            var arrCSid = csiArray[k][0];
            //loop through above array to get the matching csis
            if (selCS_id == arrCSid)
            {
              for (var m=0; m<arrSelCSI.length; m++)
              {
                var arrCSIid = arrSelCSI[m][0];
                if (arrCSIid == selCSIid)
                {
                  var idx = obj_selectedCSI.length;
                  obj_selectedCSI[idx] = new Option(arrSelCSI[m][1], arrCSIid);
                  //keep it selected
                  if (obj_selCSI.selectedIndex >= 0)
                  {
                    if (obj_selCSI[obj_selCSI.selectedIndex].value == arrCSIid)
                      obj_selectedCSI[idx].selected = true;
                  }
                  break;
                }
              }
            }
          }
        }
      }
   }
   //called from onchange event of selectedCSI function as well as addSelectedCSI function box
   function addSelectCSI(wasCSSelected, isFromEvent, selCSCSI_id)
   {
      if (obj_selectedCS.selectedIndex >= 0)
      {
        var selCS_id = obj_selectedCS[obj_selectedCS.selectedIndex].value;
        var selCS_name = obj_selectedCS[obj_selectedCS.selectedIndex].text;
      }
      var isExists = false;
      //get all the CSIs from the array since CS was not selected before 
      if (wasCSSelected == false)
      {
        //loop through the array to load all the csi for the selected CS
        obj_selectedCSI.length = 0;
        csiIdx = 0;
        for (var idx=0; idx<selCSIArray.length; idx++)
        { 
          //populate the selectedCSI list with csi for the matching cs from the array
          if (selCSIArray[idx][0] == selCS_id)
          {
             obj_selectedCSI[csiIdx] = new Option(selCSIArray[idx][3], selCSIArray[idx][4]);
             //check if csi already exists in the array
             if (isFromEvent == false && selCSIArray[idx][4] == selCSCSI_id)
             {
                //unselect the earlier selected csi
                if (obj_selectedCSI.selectedIndex >= 0)
                  obj_selectedCSI[obj_selectedCSI.selectedIndex].selected = false;

                obj_selectedCSI[csiIdx].selected = true;  //keep it selected
                isExists = true;
             }
             csiIdx++;
          }
        }
      }
      else
      {
        //check if the selected CSI already exists in the selected CSI list.
        for (var i=0; i<obj_selectedCSI.length; i++)
        {
          if (obj_selectedCSI[i].value == selCSCSI_id)
          {
             isExists = true;
             //unselect the earlier selected csi
             if (obj_selectedCSI.selectedIndex >= 0)
               obj_selectedCSI[obj_selectedCSI.selectedIndex].selected = false;

             obj_selectedCSI[i].selected = true;  //keep it selected
             break;
          }
        }
      } 
      
      //add the CSI to the selectedCSI list and selCSIArray only if not from the selectedCS change event.
      if (isFromEvent == false)
      {
        //display alert if already exists and not a block edit
        if (isExists == true && obj_ACaction.value == "BlockEdit")
            addNewCSI(isExists, selCSCSI_id, selCS_id);            
            //addSelectedAC();      //alert("Selected " + selCSI_name + " already exists in the list");
        else if (isExists == false)
            addNewCSI(isExists, selCSCSI_id, selCS_id);
      }
      sortSelectedCSI();   //call the function to rearrange selected csi
   }

  //add the CSI to the selectedCSI list and selCSIArray only if not from the selectedCS change event.
   function addNewCSI(isExistInList, selCSCSI_id, selCS_id)
   {
      var selCSCSI_id, selCSI_name, selCS_name, selACCSI_id, selAC_id, selAC_name, selCSILevel;
      var arrParentChild = new Array();
      //get the csi name from the original array list to remove the tabs.
      for (var idx=0; idx<csiArray.length; idx++)
      { 
        //for the selected csi and cs
        if (csiArray[idx][2] == selCSCSI_id  && csiArray[idx][0] == selCS_id)
        {
          selCSI_name = csiArray[idx][6];
          selCSI_id = csiArray[idx][1];
          selCS_name = csiArray[idx][7];
          selCSILevel = csiArray[idx][8];
          selP_CSI_id = csiArray[idx][3];
          //adding tabs to the csi name
          selCSI_name = getTabSpace(selCSILevel, selCSI_name); 
          break;
        }
      }
      //add the CSI to the selectedCSI list as it does not exist.
      var selCSILength = obj_selectedCSI.length;
      //alert("selectedcsi size before new one " + selCSILength + isExistInList);
      if (isExistInList == false)
      {
         //unselect the earlier selected csi
         if (obj_selectedCSI.selectedIndex >= 0)
           obj_selectedCSI[obj_selectedCSI.selectedIndex].selected = false;

         //add it to the selected csi list on the page
         obj_selectedCSI[selCSILength] = new Option(selCSI_name, selCSCSI_id);
         obj_selectedCSI[selCSILength].selected = true;
      }
         
      //get Long name, id and add csi attributes to the array 
      if (obj_ACaction.value != "BlockEdit")
      {
         selAC_id = obj_ACid.value;  
         selAC_name = obj_ACname.value;
         //get it from the select list
         if ((selAC_id == null || selAC_id == "") && obj_selACHidden[0] != null)
         {
            selAC_id = obj_selACHidden[0].value;
            selAC_name = obj_selACHidden[0].text;
         }
         //fill the array with cs, csi and ac attributes.
         selACCSIArray[selACCSIArray.length] = new Array(selCS_id, selCS_name, selCSI_id, 
                selCSI_name, selCSCSI_id, selACCSI_id, selAC_id, selAC_name, selP_CSI_id);
      }
      else
      {  //loop through the array to add csi id for each ac id
        for (var j=0; j<obj_selACHidden.length; j++)
        {
          selAC_id = obj_selACHidden[j].value;
          selAC_name = obj_selACHidden[j].text;
          //fill the array with cs, csi and ac attributes.
          var foundAC = false;
          //loop through the existing array to check if it exists already for each de only if this csi exists in the selection list before
          if (isExistInList == true)
          {
            for (var idx=0; idx<selACCSIArray.length; idx++)
            {           
              if (selACCSIArray[idx][4] == selCSCSI_id && selACCSIArray[idx][6] == selAC_id)       //match the selected csi & AC 
                foundAC = true;
            }
          }
          if (foundAC == false)
          {
              selACCSIArray[selACCSIArray.length] = new Array(selCS_id, selCS_name, selCSI_id, 
                    selCSI_name, selCSCSI_id, selACCSI_id, selAC_id, selAC_name, selP_CSI_id);
          }
        }
        //refresh the selected ac list for newly added list
        addSelectedAC();
      }
      //call the method to fill selCSIArray
      makeSelCSIList();
   }

   //removes the classification scheme from cslist and its associated csi.
   function removeCSList()
   {
      if (obj_selectedCS.length > 0 && obj_selectedCS.selectedIndex >= 0)
      {
        //check context of cs with ac context
        var selCS_name = obj_selectedCS[obj_selectedCS.selectedIndex].text;
        var isContextValid = checkContextCS_AC(selCS_name);
        if (isContextValid == false)
        {
            alert("Please make sure that the selected classification scheme's context is within the user's context");
            return;
        }
        var removeOK = confirm("Click OK to continue with removing selected Classification Scheme and its Class Scheme Items.");
        if (removeOK == false) return;
        //continue removing
        var cs_id = obj_selectedCS[obj_selectedCS.selectedIndex].value;
        //first remove the associated cs from the selectedCSI array and the selection list.
        var isCSDeleted = false;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the csi for the matching cs 
          if (selACCSIArray[idx][0] == cs_id)
          {
             selACCSIArray.splice(idx, 1);  //(parameters : start and number of elements to remove)
             isCSDeleted = true;
             idx--;  //do not increase the index number
          }
        }
        if (isCSDeleted == true)
        {
          obj_selectedCSI.length = 0;
          //remove associated DE from the list
          if (obj_selCSIACList != null)
            obj_selCSIACList.length = 0;

          //call the method to fill selCSIArray
          makeSelCSIList();          
        }
        //removing the cs from the list.
        var tempCSArray = new Array();
        var csIdx = 0;
        //store the all other cs from the selectionList in to the array 
        for (var i=0; i<obj_selectedCS.length; i++)
        {
          if (obj_selectedCS[i].value != cs_id)
          {
            tempCSArray[csIdx] = new Array(obj_selectedCS[i].value, obj_selectedCS[i].text)
            csIdx++;
          }
        }
        obj_selectedCS.length =0;
        //re-populate the cs selection list from the array.
        if (tempCSArray.length > 0)
        {
          for (var j=0; j<tempCSArray.length; j++)
          {
            obj_selectedCS[j] = new Option(tempCSArray[j][1], tempCSArray[j][0]);
          }
        }
      }   
      else
        alert("Please select a Classification Scheme from the list");
   }

   //removes the csi from the selectionlist.
   function removeCSIList()
   {
      if (obj_selectedCSI.length > 0 && obj_selectedCSI.selectedIndex >= 0)
      {
        //check context of cs with ac context
        var selCS_name = obj_selectedCS[obj_selectedCS.selectedIndex].text;
        var isContextValid = checkContextCS_AC(selCS_name);
        if (isContextValid == false)
        {
            alert("Please make sure that the selected classification scheme's context is within the user's context");
            return;
        }
        var removeOK = confirm("Click OK to continue with removing selected Class Scheme Items.");
        if (removeOK == false) return;
        //continue removing
        var cscsi_id = obj_selectedCSI[obj_selectedCSI.selectedIndex].value;
        var cs_id;
        if (obj_selectedCS.selectedIndex >= 0)
           cs_id = obj_selectedCS[obj_selectedCS.selectedIndex].value;
        csiIdx = 0;
        var isDeleted = false;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the matching csi from the array list
          if (selACCSIArray[idx][4] == cscsi_id && selACCSIArray[idx][0] == cs_id)
          {
          //alert("removed " + selACCSIArray[idx][3]);
             selACCSIArray.splice(idx,1);   //(start and number of elements)
             isDeleted = true;
             idx--;  //do not increase the index number
          }
        }
        if (isDeleted == true)
        {
          //call the method to fill selCSIArray
          makeSelCSIList();
          addSelectCSI(false, true, '');  //re populate csi list after removing.
          //remove associated DE from the list
          if (obj_selCSIACList != null)
            obj_selCSIACList.length = 0;

          //remove selected CS from the list if selectedCSI is null (nothing left)
          if (obj_selectedCSI.length == 0)
          {
            for (var i=0; i<obj_selectedCS.length; i++)
            {
              if (obj_selectedCS.options[i].value == cs_id)
              {
                 obj_selectedCS.options[i] = null;
                 break;
              }
            }
          }
        }
      }
      else
        alert("Please select a Class Scheme Item from the list");
   }
   
   //to display related AC when CSI changed and show selected csi in the csi list.
   function addSelectedAC()
   {
      var cscsi_id = obj_selectedCSI[obj_selectedCSI.selectedIndex].value;
      //display ac names
      if (obj_selCSIACList != null)
      {
        csiIdx = 0;
        obj_selCSIACList.length = 0;
        for (var idx=0; idx<selACCSIArray.length; idx++)
        { 
          //remove the matching csi from the array list
          if (selACCSIArray[idx][4] == cscsi_id)
          {
            obj_selCSIACList[obj_selCSIACList.length] 
                  = new Option(selACCSIArray[idx][7], selACCSIArray[idx][7]);
          }
        } 
      }
      //show selected csi in csi list
      for (var i=0; i<csiArray.length; i++)
      {
          //get csi attributes
         if (csiArray[i][2] == cscsi_id)
         {
            var cs_id = csiArray[i][0];
            var isSelected = false;
            if (obj_selCS.selectedIndex > 0 && 
                      obj_selCS[obj_selCS.selectedIndex].value == cs_id)
               isSelected = true;

            //select the cs from the drow down list
            if (isSelected == false)
            {
              for (var j=0; j<obj_selCS.length; j++)
              {
                if (obj_selCS[j].value == cs_id)
                {
                    obj_selCS[j].selected = true;
                    ChangeCS();  //call method to select all the 
                    break;
                }
              }
            }
            //select the csi in selCSI list
            isSelected = false;            
            if (obj_selCSI.selectedIndex > 0 && 
                      obj_selCSI[obj_selCSI.selectedIndex].value == cscsi_id)
               isSelected = true;
               
            //select the cs from the drow down list
            if (isSelected == false)
            {
              for (var j=0; j<obj_selCSI.length; j++)
              {
                if (obj_selCSI[j].value == cscsi_id)
                {
                    obj_selCSI[j].selected = true;
                    break;
                }
              }
            }            
         }
      }      
   }

  //make the selected csi array from ac csi array at load.
   function makeSelCSIList()
   {
      selCSIArray.length = 0;
      for (var i=0; i<selACCSIArray.length; i++)
      {
        //add the cs-csi to the selected csi array only if it does not exist already
        var relFound = false;
        //alert("make sel " + selACCSIArray[i][3]);
        for (var idx=0; idx<selCSIArray.length; idx++)
        { 
          if (selCSIArray[idx][4] == selACCSIArray[i][4]) //match to the cscsi id
          {
            relFound = true;
            break;
          }
        }
        //add selCS_id, selCS_name, selCSI_id, selCSI_name, selCSCSI_id in this order
        if (relFound == false)
        {
          selCSIArray[selCSIArray.length] = new Array(selACCSIArray[i][0], selACCSIArray[i][1], 
            selACCSIArray[i][2], selACCSIArray[i][3], selACCSIArray[i][4], selACCSIArray[i][8]);  //, selACCSI_id, selAC_id, selAC_longName);
        }
      }
   }
//-------------cs-csi hierarchy  end ---------------
  function openBEDisplayWindow()
  {
    var evsWindow = "";
    if (evsWindow && !evsWindow.closed)
      evsWindow.focus();
    else
    {
      evsWindow = window.open("jsp/OpenBlockEditWindow.jsp", "BEWindow", "width=750,height=350,top=0,left=0,resizable=yes,scrollbars=yes");
    }
  }

  //display message to upload document
  function uploadDocument()
  {
    var docWindow = "";
    if (docWindow && !docWindow.closed)
      docWindow.focus();
    else
    {
      docWindow = window.open("jsp/UploadDocument.jsp", "UpdDocWindow", "width=550,height=350,top=0,left=0,resizable=yes,scrollbars=yes");
    }
  }
  
  //open window to browse
  function openBrowse()
  {
    if (browseWindow && !browseWindow.closed)
        browseWindow.close();
    browseWindow = window.open("", "browseWindow")
    if (browseWindow.document != null)
    {
      browseWindow.document.writeln('<font size=4><b>');
      browseWindow.document.writeln("Navigate to desired URL and then use copy and paste method to select document URL");
      browseWindow.document.writeln('</b></font>');
    }
  } 
  
  function submitDesignate(sAction)
  {
    var dispType = document.designateDEForm.pageDisplayType.value;
    if (dispType == null) dispType = "";
 // alert(dispType + " submit " + sAction);
    if (dispType == "Designation")
    {
      //check for context if removr or create designation
      var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
      if (sAction == "remove" || sAction == "create")
      {
        if (sContext == null || sContext == "")
        {
          alert("Select a designate context from the drop down list.");
          return;
        }
        else if (sAction == "remove")
        {
          var isOK = confirm("Click OK to continue with removing selected used by context and other attributes");
          if (isOK == false)
            return;
        }
      }
      var sContName = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].text;
      document.designateDEForm.contextName.value = sContName;
      selectMultiSelectList();  //select cscsi attributes
    }
    if (dispType != "") //submit the page only if not empty
    {
      document.designateDEForm.Message.style.visibility="visible";
      document.designateDEForm.pageAction.value = sAction;
      document.designateDEForm.submit();
    }
  }

  //to udpate alternate names and reference documents for owning context
  function updateAttributes(sDisp, sAC, ARStatus)
  {
  	if (ARStatus == "changed")
  	{
  	  var longAC = sAC;
  	  if (sAC == "DataElement") longAC = "Data Element";
  	  else if (sAC == "DataElementConcept") longAC = "Data Element Concept";
  	  else if (sAC == "ValueDomain") longAC = "Value Domain";
  	  //display alert message
  	  alert("Updates to " + sDisp + " will not be associated to the " + longAC + 
  			" or written to the database until the " + longAC + " has been successfully submitted.");
	  
	  //make the action string
	  var subAct = "Store " + sDisp;
	  opener.SubmitValidate(subAct);
	}
  	window.close();
  }
  
  //restrict the input of the text if exceeds the max length
  function textCounter(field, maxlimit) 
  {
    var objField = eval("document.designateDEForm." + field);
    if (objField.value.length > maxlimit) // if too long...trim it!
      objField.value = objField.value.substring(0, maxlimit);
  }

//-------------alternate names begin ---------------
  //enable or disable the remove button of the alternate names
  function enableAltNames(checked)
  {
     if (checked)
       ++altNameCount;
     else
       --altNameCount;
     if (altNameCount == 1)
     {
        //document.designateDEForm.altCheckGif.alt = "Unselect All";
        document.designateDEForm.btnRemAltName.disabled = false;
     }
     else
     {
        //document.designateDEForm.altCheckGif.alt = "Select All";
        document.designateDEForm.btnRemAltName.disabled = true;
     }
  }
  //sort the alternate name columns
  function sortAlt(sfield)
  {
    document.designateDEForm.sortColumn.value = sfield;
    submitDesignate("sortAlt");
  }
   
  //adds newly created alternate name into selected alt name list.
  function addAltName()
  {
    var sType = document.designateDEForm.selAltType[document.designateDEForm.selAltType.selectedIndex].value;
    var sName = document.designateDEForm.txtAltName.value;
    var isCon = true;
    if (document.designateDEForm.selContext != null)
    {
      var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
      if (sContext == null || sContext == "") isCon = false;
    }
    if (isCon == false) 
      alert("Select a designate context from the drop down list.");    
    else if (sType == null || sType == "")
      alert("Select a type of alternate name from the drop down list.");
    else if (sName == null || sName == "")
      alert("Please enter a text for the alternate name");
    else  //ok to submit
      submitDesignate("addAlt");
  }
  
  //remove the alternate name from the list
  function removeAltName()
  {
    var isOK = confirm("Please click OK to continue removing the selected alternate type and name.");
    if (isOK == true)  //ok to submit
      submitDesignate("removeAlt");
  }
    
//-------------alternate names  end ---------------


//-------------reference documents begin ---------------

  //enable or disable the remove button of the alternate names
  function enableRefDocs(checked)
  {
     if (checked)
       ++refDocCount;
     else
       --refDocCount;
     if (refDocCount == 1)
     {
        //document.designateDEForm.refCheckGif.alt = "Unselect All";
        document.designateDEForm.btnRemRefDoc.disabled = false;
     }
     else
     {
        //document.designateDEForm.refCheckGif.alt = "Select All";
        document.designateDEForm.btnRemRefDoc.disabled = true;
     }
  }

  //sort the alternate name columns
  function sortRef(sfield)
  {
    alert("sorting ref " + sfield);
    document.designateDEForm.sortColumn.value = sfield;
    submitDesignate("sortRef");
  }
    
  //adds newly created reference into selected reference documents list.
  function addRefDoc()
  {
    var sType = document.designateDEForm.selRefType[document.designateDEForm.selRefType.selectedIndex].value;
    var sName = document.designateDEForm.txtRefName.value;
    var sURL = document.designateDEForm.txtRefURL.value;
    var isCon = true;
    if (document.designateDEForm.selContext != null)
    {
      var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
      if (sContext == null || sContext == "") isCon = false;
    }
    //check the validity
    if (isCon == false) 
      alert("Select a designate context from the drop down list.");
    else if (sType == null || sType == "")
      alert("Select a type of Reference Document from the drop down list.");
    else if (sName == null || sName == "")
      alert("Please enter a text for the Reference Document Name");
      //if less than 7 or does not have http:// at the begging
    else if (sURL != null && sURL != "" && (sURL.length < 8 || (sURL.substring(0,7) != "http://" && sURL.substring(0,8) != "https://")))
      alert("Reference Document URL Text must begin with 'http:// or https://'");
    else  //ok to submit
      submitDesignate("addRefDoc");
  }

  //remove the reference documents from the list
  function removeRefDoc()
  {  
    var isOK = confirm("Please click OK to continue removing the selected Reference Document.");
    if (isOK == true)  //ok to submit
      submitDesignate("removeRefDoc");
  }
  
//-------------reference documents  end ---------------