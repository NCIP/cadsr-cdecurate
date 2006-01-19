
  function Back()
  {
    document.RefDocumentUploadForm.newRefDocPageAction.value = "backToSearch";
    document.RefDocumentUploadForm.encoding = "application/x-www-form-urlencoded";
    document.RefDocumentUploadForm.submit();
  }
  
  function selectAll()
   {
    var checked;
     if (!document.getElementById("ck0").checked) {
        for (i=0; i < (document.RefDocumentUploadForm.length - 4); i++)
      		{
      			document.getElementById("ck"+ i).checked=true; 
      		}
      	checked = "yes";
     }
     else if (document.getElementById("ck0").checked) {
        for (i=0; i < (document.RefDocumentUploadForm.length - 4); i++)
      		{
      			document.getElementById("ck"+ i).checked=false; 
     		}
      	checked = "no";
     }
   }
   
   function doUpload()
  {   
     		
				   window.status = "Uploading Reference Document Attachments, it may take a minute, please wait.....";
				   document.RefDocumentUploadForm.newRefDocPageAction.value = "UploadFile";
				   document.RefDocumentUploadForm.encoding = "multipart/form-data";
				   document.RefDocumentUploadForm.submit();
  }
   
  function doUpload2()
  {   
     var checked;
     checked = "false";
		for (i=0; i < (document.RefDocumentUploadForm.length - 4); i++)
      		{
				if (document.getElementById("ck"+ i).checked)
				{
					checked = "true";
				}
	   		}
	   		if (checked = "true")
	   			{
      		
				   window.status = "Uploading Reference Document Attachments, it may take a minute, please wait.....";
				   document.RefDocumentUploadForm.newRefDocPageAction.value = "UploadFile";
				   document.RefDocumentUploadForm.encoding = "multipart/form-data";
				   document.RefDocumentUploadForm.submit();
				}
	   		else 
	   			{
	  			 alert ("Please select a Reference document first.");
 	   			}
  }
  
  function onDocDelete(fileName)
  {
   alert ('onclick pressed: ' + fileName);
  }
   
