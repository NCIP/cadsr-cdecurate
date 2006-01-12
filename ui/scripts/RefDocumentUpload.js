
  function Back()
  {
    document.RefDocumentUploadForm.newRefDocPageAction.value = "backToSearch";
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
	   document.RefDocumentUploadForm.submit();
	   
  }
  
   
