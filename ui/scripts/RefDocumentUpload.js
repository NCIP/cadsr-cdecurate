    var checkCount = 0;

    function adjustCheckCount(cbobj)
    {
        if (cbobj.checked == true)
            ++checkCount;
        else
            --checkCount;
            
        if (checkCount == 1)
            document.RefDocumentUploadForm.Uploadbtn.disabled = false;
        else
            document.RefDocumentUploadForm.Uploadbtn.disabled = true;
    }

  function Back()
  {
    document.RefDocumentUploadForm.newRefDocPageAction.value = "backToSearch";
    document.RefDocumentUploadForm.encoding = "application/x-www-form-urlencoded";
    document.RefDocumentUploadForm.submit();
  }
  
  function selectAll()
   {
    var checked;
    var isDisabled = true;
    
     if (!document.getElementById("ck0").checked) {
        for (i=0; i < (document.RefDocumentUploadForm.length - 4); i++)
      		{
      			isDisabled = document.getElementById("ck"+ i).disabled;
      			if (isDisabled = false)
      			{
      				document.getElementById("ck"+ i).checked=true; 
      			}
      		}
      	checked = "yes";
     }
     else if (document.getElementById("ck0").checked) {
        for (i=0; i < (document.RefDocumentUploadForm.length - 4); i++)
      		{
      			isDisabled = document.getElementById("ck"+ i).disabled;
      			if (isDisabled = false)
      			{
      				document.getElementById("ck"+ i).checked=false; 
      			}
     		}
      	checked = "no";
     }
   }
   
   function doUpload2()
  {   
	 window.status = "Uploading Reference Document Attachments, it may take a minute, please wait.....";
	 document.RefDocumentUploadForm.newRefDocPageAction.value = "UploadFile";
	 document.RefDocumentUploadForm.encoding = "multipart/form-data";
	 document.RefDocumentUploadForm.submit();
  }
   
  function doUpload()
  {   
	var checkbox_choices = 0;
	var str = document.RefDocumentUploadForm.uploadfile.value;
	var isChecked = true;
	var checkboxName = "ck";
	var NotChecked = true;
	
	if (str.length == 0)
		{
    		alert("Please Select a file to attach to a referrence document. \n");
			return;
		} 

	for (i=0; i <= (document.RefDocumentUploadForm.length - 6); ++i)
  		{
   			checkboxName = "ck";
   			checkboxName = checkboxName + i;
   			isChecked = document.getElementById(checkboxName).checked;

   			if (isChecked)
   			{
   				checkbox_choices = checkbox_choices + 1;
   			} 
      	}

	if (checkbox_choices > 1 )
		{
			msg="You're limited to only one selection.\n";
			msg=msg + "You have made " + checkbox_choices + " selections.\n";
			alert(msg);
			return;
		}

	if (checkbox_choices < 1 )
		{
			alert("Please Select a referrence document. \n");
			return;
		}

	if (checkbox_choices == 1 )
		{
			window.status = "Uploading Reference Document Attachments, it may take a minute, please wait.....";
			document.RefDocumentUploadForm.newRefDocPageAction.value = "UploadFile";
			document.RefDocumentUploadForm.encoding = "multipart/form-data";
			document.RefDocumentUploadForm.submit();
		}
  }
  
  function onDocDelete(fileName, fileDisplayName)
  {
   	conf = confirm("Are you sure you want to permanetly delete " + fileDisplayName + "?");
   	if (conf == true)
   	{
	   	document.RefDocumentUploadForm.RefDocTargetFile.value = fileName;
	   	window.status = "Deleting Reference Document Attachment, it may take a minute, please wait....";
	    document.RefDocumentUploadForm.newRefDocPageAction.value = "DeleteAttachment";
	    document.RefDocumentUploadForm.encoding = "application/x-www-form-urlencoded";
	    document.RefDocumentUploadForm.submit();
   	}
   	else
   	{
   		return
   	}
  }
   

