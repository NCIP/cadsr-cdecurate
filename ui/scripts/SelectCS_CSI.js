
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
    alert("The Upload Document function will be available in a future release.");
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
    var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
    if (sContext == null || sContext == "")
      alert("Select a designate context from the drop down list.");
    else
    {
      if (sAction == "remove")
      {
        var isOK = confirm("Click OK to continue with removing selected used by context and other attributes");
        if (isOK == false)
          return;
        else
          removeUsedByAttr(sContext);
      }
      document.designateDEForm.Message.style.visibility="visible";
      storeAltHiddenFields();  //store/select alternate name properties
      storeRefHiddenFields();  //select ref doc attributes
      selectMultiSelectList();  //select cscsi attributes
      //alert("submiting " + sAction);
      document.designateDEForm.newCDEPageAction.value = sAction;
      document.designateDEForm.submit();
    }
  }

  //marks as deleted when removing used by context
  function removeUsedByAttr(sContext)
  {
    //mark as removed for each ac
    for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
    {
      var selAC = document.designateDEForm.selACHidden[j].value;
      //mark as removed for alternate names
      for (var k=0; k<selAltNameArray.length; k++)
      {
        if (selAC == selAltNameArray[k].ac_idseq && sContext == selAltNameArray[k].conte_id)
        {
          //update the submit action to be removed
          selAltNameArray[k].submit_action = "DEL";
        }
      }  
      //mark as removed for reference documents
      for (var k=0; k<selRefDocArray.length; k++)
      {
        if (selAC == selRefDocArray[k].ac_idseq && sContext == selRefDocArray[k].conte_id)
        {
          //update the submit action to be removed
          selRefDocArray[k].submit_action = "DEL";
        }
      }  
    }  
  }
  
  //restrict the input of the text if exceeds the max length
  function textCounter(field, maxlimit) 
  {
    var objField = eval("document.designateDEForm." + field);
    if (objField.value.length > maxlimit) // if too long...trim it!
      objField.value = objField.value.substring(0, maxlimit);
  }

//-------------alternate names begin ---------------
  //define altNames object
  function altNames()
  {
    this.idseq = "";
    this.conte_name = "";
    this.conte_id = "";
    this.alt_name = "";
    this.type_name = "";
    this.ac_name = "";
    this.ac_idseq = "";
    this.ac_language = "";
    this.submit_action = "";
    return this;
  } 

  //referesh alt name select object
  function refreshAltNameSelect()
  {
    //remove all the existing ones
    document.designateDEForm.selAltNameText.length = 0;
    document.designateDEForm.selAltNameType.length = 0;
    if (selAltNameArray != null)
    {
      for (var i=0; i<selAltNameArray.length; i++)
      {
        //check if it already in the select list.
        var thisType = selAltNameArray[i].type_name;
        var thisName = selAltNameArray[i].alt_name;
        var isExist = false;
        for (var j=0; j<document.designateDEForm.selAltNameText.length; j++)
        {
          var selType = document.designateDEForm.selAltNameText[j].value;
          var selName = document.designateDEForm.selAltNameText[j].text;
          //loop till same type and name found in the list
          if (thisType == selType && thisName == selName)
          {
            isExist = true;
            break;
          }
        }
        if (isExist == false && selAltNameArray[i].submit_action != "DEL")
        {
          var dCount = document.designateDEForm.selAltNameText.length;
          document.designateDEForm.selAltNameText[dCount] = new Option(thisName, thisType);
          document.designateDEForm.selAltNameType[dCount] = new Option(thisType, thisType);
        }
      }  
    }
  }
  
  //adds newly created alternate name into selected alt name list.
  function addAltName()
  {
    var sType = document.designateDEForm.selAltType[document.designateDEForm.selAltType.selectedIndex].value;
    var sName = document.designateDEForm.txtAltName.value;
    var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
    if (sContext == null || sContext == "")
      alert("Select a designate context from the drop down list.");
    else if (sType == null || sType == "")
      alert("Select a type of alternate name from the drop down list.");
    else if (sName == null || sName == "")
      alert("Please enter a text for the alternate name");
    else
    {
      if (selAltNameArray != null)
      {
        var isAltExist = false; 
        for (var i=0; i<selAltNameArray.length; i++)
        {
          //check if it already in the select list.
          var thisType = selAltNameArray[i].type_name;
          var thisName = selAltNameArray[i].alt_name;
          //check if the type and name exists already in the list
          if (thisType == sType && thisName == sName)
          {
            isAltExist = true;
            break;
          }
        } 
        //display the added item if not displayed (new one or removed and added back)
        var dCount = document.designateDEForm.selAltNameText.length;
        var isDisp = false;
        //check if already selected in the list
        for (var k=0; k<dCount; k++)
        {
          var dispName = document.designateDEForm.selAltNameText[k].text;
          var dispType = document.designateDEForm.selAltNameText[k].value;
          if (dispName == sName && dispType == sType)
          {
            isDisp = true;
            break;
          }
        }
        //add them if not existed
        if (isDisp == false)
        {
          document.designateDEForm.selAltNameText[dCount] = new Option(sName, sType);
          document.designateDEForm.selAltNameType[dCount] = new Option(sType, sType);
        }
        
        //create alt in the array if not exists
        if (isAltExist == false)
        {
          //create altname array 
          fillAltAttrArray("ALL_AC");
        }
        else
        {
            //check if type, name, ac and context exist in the list
          for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
          {
            var isAltACExist = false;
            var selAC = document.designateDEForm.selACHidden[j].value;
            for (var k=0; k<selAltNameArray.length; k++)
            {
              //check if all four exists
              if (selAC == selAltNameArray[k].ac_idseq && sContext == selAltNameArray[k].conte_id
                   && sType == selAltNameArray[k].type_name && sName == selAltNameArray[k].alt_name)
              {
                if (selAltNameArray[k].submit_action == "DEL")
                  selAltNameArray[k].submit_action = "UPD";
                isAltACExist = true;
                //alert("Selected " + sType + " and " + sName + "already exists in the list.");
                break;
              }
            }  
            //create alt in the array if not exists for this ac and context
            if (isAltACExist == false)
            {
     // alert("adding to array");
              fillAltAttrArray(selAC);
            }
          } 
        }
      }
      //clear the fields
      document.designateDEForm.selAltType[0].selected = true;
      document.designateDEForm.txtAltName.value = "";      
    }
  }
  //remove the alternate name from the list
  function removeAltName()
  {
    var sContext = "";
    if (document.designateDEForm.selContext.selectedIndex > -1)
      sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
    var altName = "";
    var altType = "";
    if (document.designateDEForm.selAltNameText.selectedIndex > -1)
    {
      altName = document.designateDEForm.selAltNameText[document.designateDEForm.selAltNameText.selectedIndex].text;
      altType = document.designateDEForm.selAltNameText[document.designateDEForm.selAltNameText.selectedIndex].value;
    }
    var isOK = true;
    if (sContext == null || sContext == "")
      alert("Select a designate context from the drop down list.");
    else if (altType == null || altType == "" || altName == null || altName == "")
      alert("Select an item to be removed from the list of selected alternate names.");
    else
    {
      isOK = confirm("Please click OK to continue removing the selected alternate type and name");
      if (isOK == true)
      {
        var isAltRemoved = false;
          //check if type, name, ac and context exist in the list
        for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
        {
          var selAC = document.designateDEForm.selACHidden[j].value;
          for (var k=0; k<selAltNameArray.length; k++)
          {
            //check if all four exists
            if (selAC == selAltNameArray[k].ac_idseq && sContext == selAltNameArray[k].conte_id
                 && altType == selAltNameArray[k].type_name && altName == selAltNameArray[k].alt_name)
            {
              isAltRemoved = true;
              //update the submit action to be removed
              selAltNameArray[k].submit_action = "DEL";
            }
          }  
        }
        if (isAltRemoved == true)
          refreshAltNameSelect();       //refresh the select list
        else
          alert("Unable to remove the selected Alternate Name, because it does not exist in the selected Context.");
      }
    }
  }
  
  //make the other attribute list selected
  function selectedAltList(sList)
  {
    var sIndex;
    if (sList == 'altType')
      sIndex = document.designateDEForm.selAltNameType.selectedIndex;
    else if (sList = 'altName')
      sIndex = document.designateDEForm.selAltNameText.selectedIndex;
    if (sIndex > -1)
    {
      document.designateDEForm.selAltNameType[sIndex].selected = true;
      document.designateDEForm.selAltNameText[sIndex].selected = true;      
    }
  }
  
  //store the alt name attributes in the array
  function fillAltAttrArray(acid)
  {
    //check if type, name, ac and context exist in the list
    for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
    {
      var thisAC = document.designateDEForm.selACHidden[j].value;
      var thisACName = document.designateDEForm.selACHidden[j].text;
      //create object and add to array if new one or matching ac id
      if (acid == "ALL_AC" || acid == thisAC)
      {
        var objAltName = new altNames();
        objAltName.idseq = "new";
        var iType = document.designateDEForm.selContext.selectedIndex;
        objAltName.conte_name = document.designateDEForm.selContext[iType].text;
        objAltName.conte_id = document.designateDEForm.selContext[iType].value;
        iType = document.designateDEForm.selAltType.selectedIndex;
        objAltName.type_name = document.designateDEForm.selAltType[iType].value;
        objAltName.alt_name = document.designateDEForm.txtAltName.value;
        objAltName.ac_name = thisACName;
        objAltName.ac_idseq = thisAC;
        objAltName.ac_language = "ENGLISH";
        objAltName.submit_action = "INS";
        selAltNameArray[selAltNameArray.length] = objAltName;  
      }
    } 
  }
  
  //store the array in hidden field for the requests
  function storeAltHiddenFields()
  {
      //store them in the hidden fields and keep it selected
    for (var k=0; k<selAltNameArray.length; k++)
    {
      document.designateDEForm.selAltIDHidden.options[k] = new Option(selAltNameArray[k].idseq, selAltNameArray[k].idseq);
      document.designateDEForm.selAltIDHidden.options[k].selected = true;

      document.designateDEForm.selAltNameHidden.options[k] = new Option(selAltNameArray[k].alt_name, selAltNameArray[k].alt_name);
      document.designateDEForm.selAltNameHidden.options[k].selected = true;

      document.designateDEForm.selAltTypeHidden.options[k] = new Option(selAltNameArray[k].type_name, selAltNameArray[k].type_name);
      document.designateDEForm.selAltTypeHidden.options[k].selected = true;

      document.designateDEForm.selAltACHidden.options[k] = new Option(selAltNameArray[k].ac_idseq, selAltNameArray[k].ac_idseq);
      document.designateDEForm.selAltACHidden.options[k].selected = true;

      document.designateDEForm.selAltContHidden.options[k] = new Option(selAltNameArray[k].conte_name, selAltNameArray[k].conte_name);
      document.designateDEForm.selAltContHidden.options[k].selected = true;

      document.designateDEForm.selAltContIDHidden.options[k] = new Option(selAltNameArray[k].conte_id, selAltNameArray[k].conte_id);
      document.designateDEForm.selAltContIDHidden.options[k].selected = true;

      document.designateDEForm.selAltActHidden.options[k] = new Option(selAltNameArray[k].submit_action, selAltNameArray[k].submit_action);
      document.designateDEForm.selAltActHidden.options[k].selected = true;
    }  
  }
  
//-------------alternate names  end ---------------


//-------------reference documents begin ---------------
  function refDocs()
  {
    this.idseq = "";
    this.conte_name = "";
    this.conte_id = "";
    this.ref_name = "";
    this.ref_text = "";
    this.ref_URL = "";
    this.type_name = "";
    this.ac_name = "";
    this.ac_idseq = "";
    this.ac_language = "";
    this.submit_action = "";
    return this; 
  }

  //referesh Ref Doc select object
  function refreshRefDocSelect()
  {
    //remove all the existing ones
    document.designateDEForm.selRefDocType.length = 0;
    document.designateDEForm.selRefDocName.length = 0;
    document.designateDEForm.selRefDocText.length = 0;
    document.designateDEForm.selRefDocURL.length = 0;
    if (selRefDocArray != null)
    {
      for (var i=0; i<selRefDocArray.length; i++)
      {
        //check if it already in the select list.
        var thisType = selRefDocArray[i].type_name;
        var thisName = selRefDocArray[i].ref_name;
        var isExist = false;
        for (var j=0; j<document.designateDEForm.selRefDocName.length; j++)
        {
          var selType = document.designateDEForm.selRefDocName[j].value;
          var selName = document.designateDEForm.selRefDocName[j].text;
          //loop till same type and name found in the list
          if (thisType == selType && thisName == selName)
          {
            isExist = true;
            break;
          }
        }
        if (isExist == false && selRefDocArray[i].submit_action != "DEL")
        {
          var dCount = document.designateDEForm.selRefDocText.length;
          document.designateDEForm.selRefDocType[dCount] = new Option(thisType, thisType);
          document.designateDEForm.selRefDocName[dCount] = new Option(selRefDocArray[i].ref_name, thisType);
          document.designateDEForm.selRefDocText[dCount] = new Option(selRefDocArray[i].ref_text, thisType);
          document.designateDEForm.selRefDocURL[dCount] = new Option(selRefDocArray[i].ref_URL, thisType);
        }
      } 
    }
  }

  //adds newly created reference into selected reference documents list.
  function addRefDoc()
  {
    var sType = document.designateDEForm.selRefType[document.designateDEForm.selRefType.selectedIndex].value;
    var sName = document.designateDEForm.txtRefName.value;
    var sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
    if (sContext == null || sContext == "")
      alert("Select a designate context from the drop down list.");
    else if (sType == null || sType == "")
      alert("Select a type of Reference Documents from the drop down list.");
    else if (sName == null || sName == "")
      alert("Please enter a text for the Reference Document Name");
    else
    {
      if (selRefDocArray != null)
      {
        var isRefExist = false; 
        for (var i=0; i<selRefDocArray.length; i++)
        {
          //check if it already in the select list.
          var thisType = selRefDocArray[i].type_name;
          var thisName = selRefDocArray[i].ref_name;
          //check if the type and name exists already in the list
          if (thisType == sType && thisName == sName)
          {
            isRefExist = true;
            break;
          }
        }  
        //display the added item if not displayed (new one or removed and added back)
        var dCount = document.designateDEForm.selRefDocName.length;
        var isDisp = false;
        //check if already selected in the list
        for (var k=0; k<dCount; k++)
        {
          var dispName = document.designateDEForm.selRefDocName[k].text;
          var dispType = document.designateDEForm.selRefDocType[k].text;
          if (dispName == sName && dispType == sType)
          {
            isDisp = true;
            break;
          }
        }
        //add them if not existed
        if (isDisp == false)
        {
          var sText = document.designateDEForm.txtRefText.value;
          var sURL = document.designateDEForm.txtRefURL.value;
          document.designateDEForm.selRefDocName[dCount] = new Option(sName, sType);
          document.designateDEForm.selRefDocType[dCount] = new Option(sType, sType);
          document.designateDEForm.selRefDocText[dCount] = new Option(sText, sType);
          document.designateDEForm.selRefDocURL[dCount] = new Option(sURL, sType);
        }
        //create ref in the array if not exists
        if (isRefExist == false)
        {
          //create refname array 
          fillRefAttrArray("ALL_AC");
        }
        else
        {
            //check if type, name, ac and context exist in the list
          for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
          {
            var isRefACExist = false;
            var selAC = document.designateDEForm.selACHidden[j].value;
            for (var k=0; k<selRefDocArray.length; k++)
            {
              //check if all four exists
              if (selAC == selRefDocArray[k].ac_idseq && sContext == selRefDocArray[k].conte_id
                   && sType == selRefDocArray[k].type_name && sName == selRefDocArray[k].ref_name)
              {
                if (selRefDocArray[k].submit_action == "DEL")
                  selRefDocArray[k].submit_action = "UPD";
                isRefACExist = true;
                //alert("Selected " + sType + " and " + sName + "already exists in the list.");
                break;
              }
            }  
            //create ref in the array if not exists for this ac and context
            if (isRefACExist == false)
            {
     // alert("adding to array");
              fillRefAttrArray(selAC);
            }
          } 
        }
      }
      //clear all the fields
      document.designateDEForm.selRefType[0].selected = true;
      document.designateDEForm.txtRefName.value = "";
      document.designateDEForm.txtRefText.value = "";
      document.designateDEForm.txtRefURL.value = "";
    }
  }

  //store the ref name attributes in the array
  function fillRefAttrArray(acid)
  {
    //check if type, name, ac and context exist in the list
    for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
    {
      var thisAC = document.designateDEForm.selACHidden[j].value;
      var thisACName = document.designateDEForm.selACHidden[j].text;
      //create object and add to array if new one or matching ac id
      if (acid == "ALL_AC" || acid == thisAC)
      {
        var objRefDoc = new refDocs();
        objRefDoc.idseq = "new";
        var iType = document.designateDEForm.selContext.selectedIndex;
        objRefDoc.conte_name = document.designateDEForm.selContext[iType].text;
        objRefDoc.conte_id = document.designateDEForm.selContext[iType].value;
        iType = document.designateDEForm.selRefType.selectedIndex;
        objRefDoc.type_name = document.designateDEForm.selRefType[iType].value;
        objRefDoc.ref_name = document.designateDEForm.txtRefName.value;
        objRefDoc.ref_text = document.designateDEForm.txtRefText.value;
        objRefDoc.ref_URL = document.designateDEForm.txtRefURL.value;
        objRefDoc.ac_name = thisACName;
        objRefDoc.ac_idseq = thisAC;
        objRefDoc.ac_language = "ENGLISH";
        objRefDoc.submit_action = "INS";
        selRefDocArray[selRefDocArray.length] = objRefDoc;  
      }
    } 
  }

  //remove the reference documents from the list
  function removeRefDoc()
  {  
    var sContext = "";
    if (document.designateDEForm.selContext.selectedIndex > -1)
      sContext = document.designateDEForm.selContext[document.designateDEForm.selContext.selectedIndex].value;
    var refName = "";
    var refType = "";
    if (document.designateDEForm.selRefDocName.selectedIndex > -1)
    {
      refName = document.designateDEForm.selRefDocName[document.designateDEForm.selRefDocName.selectedIndex].text;
      refType = document.designateDEForm.selRefDocName[document.designateDEForm.selRefDocName.selectedIndex].value;
    }
    var isOK = true;
    if (sContext == null || sContext == "")
      alert("Select a designate context from the drop down list.");
    else if (refType == null || refType == "" || refName == null || refName == "")
      alert("Select an item to be removed from the list of selected Reference Documents.");
    else
    {
      isOK = confirm("Please click OK to continue removing the selected Reference Document.");
      if (isOK == true)
      {
        var isAltRemoved = false;
          //check if type, name, ac and context exist in the list
        for (var j=0; j<document.designateDEForm.selACHidden.length; j++)
        {
          var selAC = document.designateDEForm.selACHidden[j].value;
          for (var k=0; k<selRefDocArray.length; k++)
          {
            //check if all four exists
            if (selAC == selRefDocArray[k].ac_idseq && sContext == selRefDocArray[k].conte_id
                 && refType == selRefDocArray[k].type_name && refName == selRefDocArray[k].ref_name)
            {
              isAltRemoved = true;
              //update the submit action to be removed
              selRefDocArray[k].submit_action = "DEL";
            }
          }  
        }
        if (isAltRemoved == true)
          refreshRefDocSelect();       //refresh the select list
        else
          alert("Unable to remove selected Reference Document, because it does not exist in the selected Context.");
      }
    }
  }
  
  //make the other Reference Doc attribute selected
  function selectedRefList(sList)
  {
    var sIndex;
    if (sList == 'refType')
      sIndex = document.designateDEForm.selRefDocType.selectedIndex;
    else if (sList == 'refName')
      sIndex = document.designateDEForm.selRefDocName.selectedIndex;
    else if (sList == 'refText')
      sIndex = document.designateDEForm.selRefDocText.selectedIndex;
    else if (sList == 'refURL')
      sIndex = document.designateDEForm.selRefDocURL.selectedIndex;
    if (sIndex > -1)
    {
      document.designateDEForm.selRefDocType[sIndex].selected = true;
      document.designateDEForm.selRefDocName[sIndex].selected = true;      
      document.designateDEForm.selRefDocText[sIndex].selected = true;
      document.designateDEForm.selRefDocURL[sIndex].selected = true;      
    }
  }
  
  //store the array in hidden field for the requests
  function storeRefHiddenFields()
  {
      //store them in the hidden fields and keep it selected
    for (var k=0; k<selRefDocArray.length; k++)
    {
      document.designateDEForm.selRefIDHidden.options[k] = new Option(selRefDocArray[k].idseq, selRefDocArray[k].idseq);
      document.designateDEForm.selRefIDHidden.options[k].selected = true;

      document.designateDEForm.selRefNameHidden.options[k] = new Option(selRefDocArray[k].ref_name, selRefDocArray[k].ref_name);
      document.designateDEForm.selRefNameHidden.options[k].selected = true;

      document.designateDEForm.selRefTypeHidden.options[k] = new Option(selRefDocArray[k].type_name, selRefDocArray[k].type_name);
      document.designateDEForm.selRefTypeHidden.options[k].selected = true;

      document.designateDEForm.selRefTextHidden.options[k] = new Option(selRefDocArray[k].ref_text, selRefDocArray[k].ref_text);
      document.designateDEForm.selRefTextHidden.options[k].selected = true;

      document.designateDEForm.selRefURLHidden.options[k] = new Option(selRefDocArray[k].ref_URL, selRefDocArray[k].ref_URL);
      document.designateDEForm.selRefURLHidden.options[k].selected = true;

      document.designateDEForm.selRefACHidden.options[k] = new Option(selRefDocArray[k].ac_idseq, selRefDocArray[k].ac_idseq);
      document.designateDEForm.selRefACHidden.options[k].selected = true;

      document.designateDEForm.selRefContIDHidden.options[k] = new Option(selRefDocArray[k].conte_id, selRefDocArray[k].conte_id);
      document.designateDEForm.selRefContIDHidden.options[k].selected = true;

      document.designateDEForm.selRefActHidden.options[k] = new Option(selRefDocArray[k].submit_action, selRefDocArray[k].submit_action);
      document.designateDEForm.selRefActHidden.options[k].selected = true;
    }  
  }
  

//-------------reference documents  end ---------------