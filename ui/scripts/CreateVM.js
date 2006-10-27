var evsWindow = null;

   //  checks the status message everytime page opens and alerts the  message
   function displayStatus(vStatusMessage)
   {
        if (vStatusMessage == null || vStatusMessage == "no message")
            vStatusMessage = "";
        if (vStatusMessage != "") 
        {
            alert(vStatusMessage);
        }
   }

  function hourglass()
  {
    document.body.style.cursor = "wait";
  }

  function down_hourglass()
  {
    document.body.style.cursor = "default";
  }

  //clears all boxes and sets back to default
  function clearBoxes()
  {    
      ClearMeaning();   //call function to clear meaning and description
      document.createVMForm.taComments.value="";
	    document.createVMForm.EndDate.value="";    
      document.createVMForm.BeginDate.value="";  
      currentDate();  
  }
  //clears meaning and description boxex
  function ClearMeaning()
  {
      document.createVMForm.selShortMeanings.text = "";
      document.createVMForm.selShortMeanings.value = "";
      document.createVMForm.CreateDescription.text = "";
      document.createVMForm.CreateDescription.value = "";
      document.createVMForm.CreateDescription.disabled=false;
      document.createVMForm.selShortMeanings.disabled=false;
      document.createVMForm.hiddenEVSSearch.value = "";  
      document.createVMForm.EVSConceptID.value="";  
  }  

  function SubmitValidate(origin)
  {
		//check if the date is valid
	   var isValid = "valid";  // isDateValid();
	   if (isValid == "valid")
	   {
	   hourglass();
	   if (origin == "validate")
       {
          document.createVMForm.pageAction.value = "validate";
          window.status = "Validating data, it may take a minute, please wait.....";
       }
       else if (origin == "submit")
       {
          document.createVMForm.pageAction.value = "submit";
          window.status = "Submitting data, it may take a minute, please wait.....";
	   } 

       document.createVMForm.CreateDescription.disabled = false;
       document.createVMForm.CreateDescription.selected = true;
       document.createVMForm.selShortMeanings.disabled = false;
       document.createVMForm.selShortMeanings.selected = true;
       document.createVMForm.Message.style.visibility="visible";
	   //disable the buttons
	   document.createVMForm.btnValidate.disabled = true;
	   document.createVMForm.btnClear.disabled = true;
	   document.createVMForm.btnBack.disabled = true;
	   //submit the form
       document.createVMForm.submit();
    }
  }

 function currentDate()
  {
    if (document.createVMForm.BeginDate.value == "")
    {
    	var today_date= new Date();
    	var month=today_date.getMonth()+1;
    	var today=today_date.getDate();
    	var year=today_date.getYear();
    	document.createVMForm.BeginDate.value = (month+"/"+today+"/"+year);
    }
  }
 
 function isDateValid()
 {
    var beginDate = document.createVMForm.BeginDate.value;
    var endDate = document.createVMForm.EndDate.value;
    return areDatesValid(beginDate, endDate, "EditVM");
    
   /* if(document.createVMForm.BeginDate.value != "")
    {
      var beginDate = document.createVMForm.BeginDate.value;
      var endDate = document.createVMForm.EndDate.value;
      var status = validateDate(beginDate, endDate); //validateDate is in date-picker.js
      if (!status) return "invalid";
    }
    return "valid";	*/
}
 
   function fillCDName()
  {
  //  document.createVMForm.selConceptualDomainText.value = document.createVMForm.selConceptualDomain.options[document.createVMForm.selConceptualDomain.selectedIndex].text;
 }


   function SubmitVM()
  {
     hourglass();
     document.createVMForm.pageAction.value = "submit";
     document.createVMForm.Message.style.visibility="visible";
     window.status = "Submitting data, it may take a minute, please wait.....";
     document.createVMForm.submit();
  }

  function Back()
  {
    hourglass();
    document.createVMForm.pageAction.value  = "backToPV";
    document.createVMForm.submit();
  }

