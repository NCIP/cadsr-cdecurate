// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/WebRoot/js/RefDocumentUpload.js,v 1.2 2009-04-15 17:14:25 hebell Exp $
// $Name: not supported by cvs2svn $

    var checkCount = 0;

    function adjustCheckCount(cbobj)
    {
        if (cbobj.checked === true)
        {
            ++checkCount;
        }
        else
        {
            --checkCount;
        }
            
        if (checkCount == 1)
        {
            document.RefDocumentUploadForm.Uploadbtn.disabled = false;
        }
        else
        {
            document.RefDocumentUploadForm.Uploadbtn.disabled = true;
        }
    }

  function Back()
  {
    document.RefDocumentUploadForm.newRefDocPageAction.value = "backToSearch";
    document.RefDocumentUploadForm.encoding = "application/x-www-form-urlencoded";
    document.RefDocumentUploadForm.submit();
  }
  
function selectAll()
{
    var table = document.getElementById("RefDocList");
    var cbs = table.getElementsByTagName("INPUT");
    var i;
    
    if (document.RefDocumentUploadForm.ck0.checked)
    {
        for (i=0; i < cbs.length; ++i)
        {
        	if (cbs[i].disabled === false)
        	{
        		cbs[i].checked = true;
        	}
        }
    }
    else
    {
        for (i=0; i < cbs.length; ++i)
    	{
            if (cbs[i].disabled === false)
            {
                cbs[i].checked = false;
            }
    	}
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
    var i;
    var msg;
	
	if (str.length === 0)
		{
    		alert("Please Select a file to attach to a referrence document. \n");
			return;
		} 

    var table = document.getElementById("RefDocList");
    var cbs = table.getElementsByTagName("INPUT");
	for (i=0; i < cbs.length; ++i)
  		{
            var cb = cbs[i];
            if (cb.type == "checkbox")
            {
       			if (cb.checked)
       			{
       				checkbox_choices = checkbox_choices + 1;
       			}
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
   	var conf = confirm("Are you sure you want to permanently delete " + fileDisplayName + "?");
   	if (conf === true)
   	{
	   	document.RefDocumentUploadForm.RefDocTargetFile.value = fileName;
	   	window.status = "Deleting Reference Document Attachment, it may take a minute, please wait....";
	    document.RefDocumentUploadForm.newRefDocPageAction.value = "DeleteAttachment";
	    document.RefDocumentUploadForm.encoding = "application/x-www-form-urlencoded";
	    document.RefDocumentUploadForm.submit();
   	}
  }
  
  //do not allow typing on browse input
  function doValidateInput()
  {
   var formObj= eval("document.RefDocumentUploadForm.uploadfile");
   formObj.onkeydown =
   function (evt)
   {
      evt = (evt) ? evt : window.event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));

      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //empty data
		 formObj.value = "";
      }
      //make sure that tab works as it is 
      else if (c == 9 || c == 11)
      {
      	return true;
      }
      //don't do anything
      return false;
   };
   formObj.onkeyup =
   function (evt)
   {
      evt = (evt) ? evt : window.event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));
      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //empty data
		 formObj.value = "";
      }
      //make sure that tab works as it is 
      else if (c == 9 || c == 11)
      {
      	return true;
      }
      //don't do anything
      return false;
   };
   formObj.onkeypress =
   function (evt)
   {
      evt = (evt) ? evt : window.event;
      var c = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
         ((evt.which) ? evt.which : 0));

      //space bar, backspace, del keys pressed : empty all the data
      if (c == 32 || c == 8 || c == 46)
      {
         //to reset the value of valid search.
		   formObj.value = "";
      }
      //make sure that tab works as it is 
      else if (c == 9 || c == 11)
      {
      	return true;
      }
	  return false;
   };
  }
  

