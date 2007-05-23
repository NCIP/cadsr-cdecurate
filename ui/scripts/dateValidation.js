// Copyright ScenPro, Inc 2007

// $Header: /cvsshare/content/cvsroot/cdecurate/ui/scripts/dateValidation.js,v 1.3 2007-05-23 23:20:06 hegdes Exp $
// $Name: not supported by cvs2svn $

function checkDash(str)
{
   var dashCount=0;
   var st = str;
   for(var i = 0; i < st.length; i++)
   {
      var ch = st.substring(i, i + 1);
      if (ch == '-')
      {
         dashCount += 1;
      }
   }
   //checking dashes between month, day, and year-----
   if (dashCount < 2)
   {
      alert("Please use '-' to seperate DD, MMM and YY");
      return false;
   }
   return true;
}


function checkNum(str)
{
   var chCount = 0;
   var st = str;
   for(var i = 0; i < st.length; i++)
   {
      var ch = st.substring(i,i+1);
      if (ch < '0' || '9' < ch)
      {
         chCount += 1;
      }
   }
   if (chCount > 0)
   {
      return false;
   }
   return true;
}


function checkCase(str)
{
   var chCount = 0;
   var st = str;
   for(var i = 0; i < st.length; i++)
   {
      var ch = st.substring(i, i + 1);
      if (ch < 'A' || 'Z' < ch)
      {
         chCount += 1;
      }
   }
   if (chCount > 0)
   {
       return false;
   }
   return true;
}


function monthString(str)
{
   var st = str;
   var ch1 = "";
   var ch2 = "";
   var ch3 = "";
   if (st.length == 3)
   {
      ch1 = st.substring(0, 1);
      ch2 = st.substring(1, 2);
      ch3 = st.substring(2, 3);
      var totalch = ch1 + ch2 + ch3;
   }
   return totalch;
}


function validMonth(str)
{
   var chCount = 0;
   var st = str;
   var strDate = new Array(1,2,3,4,5,6,7,8,9,10,11,12);
   for (var j = 0; j < 12; j++)
   {
      if (st == strDate[j])
      {
         chCount += 1;
      }
   }
   if (chCount > 0)
   {
      return true;
   }
   return false;
}


function monthConversion(str)
{
   var convertedMonth = null;
   switch (str)
   {
      case "JAN" :
         convertedMonth = 1;
         break;
      case "FEB" :
         convertedMonth = 2;
         break;
      case "MAR" :
         convertedMonth = 3;
         break;
      case "APR" :
         convertedMonth = 4;
         break;
      case "MAY" :
         convertedMonth = 5;
         break;
      case "JUN" :
         convertedMonth = 6;
         break;
      case "JUL" :
         convertedMonth = 7;
         break;
      case "AUG" :
         convertedMonth = 8;
         break;
      case "SEP" :
         convertedMonth = 9;
         break;
      case "OCT" :
         convertedMonth = 10;
         break;
      case "NOV" :
         convertedMonth = 11;
         break;
      case "DEC" :
         convertedMonth = 12;
         break;
   }   
    return convertedMonth;
}


function dateValidation(ctl)
{
   var effDateChar = "";
   effDateChar = ctl.value;
   if (effDateChar.length!=0)
   {
      if (effDateChar.substring(0,1) == " ")
      {
         alert("SPACE is not allowed in the date field, please remove it or enter a valid date");
         ctl.focus();
         return false;
      }
     else if (effDateChar.length>10)
      {
         alert("Date must be of the format dd/mm/yyyy. Please enter a valid date.");
         ctl.focus();
         return false;
      }
     else if (!checkDash(effDateChar))
     {
        ctl.focus();
        return false;
     }
     // separate DD, MMM, YYYY and put them in an array
     var bufDateArray = effDateChar.split("-");
     var bufMonth = bufDateArray[1].toUpperCase();
     //Checking DD-----------
     if (!checkNum(bufDateArray[0]))
     {
        alert("Please Enter Number Only for DAY!");
        ctl.focus();
        return false;
     }
     //Checking MMM-----------
     else if (!checkCase(bufMonth))
     {
        alert("Please Enter Characters Only for Month!");
        ctl.focus();
        return false;
     }
     //checking YYYY---------
     if (!checkNum(bufDateArray[2]))
     {
        alert("Please Enter Number Only for YEAR!");
        ctl.focus();
        return false;
     }

     var vDay  = eval(bufDateArray[0]);
     var vMonth = monthString(bufMonth);
     var vYear = eval(bufDateArray[2]);
     var compMonth = eval(monthConversion(vMonth));

     var sysDT = new Date();
     var entryDate = new Date(bufDateArray[0] + " "+ bufDateArray[1] + ", "+ bufDateArray[2]);
     if ( entryDate > sysDT )
     {
        alert("The Date can not be a FUTURE date!");
        ctl.focus();
        return false;
     }
     if (!validMonth(compMonth))
     {
        alert('Month must one of the following: JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC!');
        ctl.focus();
        return false;
     }
     else if ((bufDateArray[0]).length != 2)
     {
        alert("Please enter DAY with 2 digits, eg. 11");
        ctl.focus();
        return false;
     }
     else if ((bufDateArray[1]).length != 3)
     {
        alert("Please enter the first three letters of the MONTH, eg. JAN");
        ctl.focus();
        return false;
     }
     else if ((bufDateArray[2]).length != 4)
     {
        alert("Please enter YEAR with 4 digits, eg. 2000");
        ctl.focus();
        return false;
     }
     //checking year range----
     else if (vYear < 1)
     {
        alert("Please enter a valid year.");
        ctl.focus();
        return false;
     }
     //checking day range
     else if (compMonth == 1 || compMonth == 3 ||compMonth == 5 ||compMonth == 7)
     {
        if ( vDay > 31 ||  vDay < 1)
        {
           alert("Day must be within 1 and 31 for this month!");
           ctl.focus();
           return false;
        }
     }
     else if (compMonth == 8 || compMonth == 10 ||compMonth == 12 )
     {
        if ( vDay > 31 ||  vDay < 1)
        {
           alert("Day Must be within 1 and 31 for this month!");
           ctl.focus();
           return false;
        }
     }
     else if (compMonth == 4 || compMonth == 6 ||compMonth == 9 ||compMonth == 11  )
     {
        if ( vDay > 30 ||  vDay < 1)
        {
           alert("Day Must be within 1 and 30 for this month!");
           ctl.focus();
           return false;
        }
     }
     else if ((compMonth==2)&&((vYear%4==0)&&((vYear%100!=0)||(vYear%400==0))))
     {
        if ( vDay >29 ||  vDay <1)
        {
           alert("Day Must be within 1 and 29 for this month!");
           ctl.focus();
           return false;
        }
     }
     else
     {
        if ( vDay > 28 || vDay < 1)
        {
           alert("Day Must be within 1 and 28 for this month!");
           ctl.focus();
           return false;
         }
      }
   }
   else
   {
      alert("Please enter a valid date");
      ctl.focus();
      return false;
   }
   return true;
}


function endDateValidation(begCtl, endCtl)
{
   var startDate = "";
   startDate = begCtl.value;
   var endDate = "";
   endDate = endCtl.value;

   // separate DD, MMM, YYYY and put them in an array
   var startDateArray = startDate.split("-");
   var endDateArray   = endDate.split("-");
   var ucBegMonth = startDateArray[1].toUpperCase();
   var ucEndMonth = endDateArray[1].toUpperCase();

   // convert day and year to numbers
   var begDay  = eval(startDateArray[0]);
   var begMonth= monthString(ucBegMonth);
   var begYear = eval(startDateArray[2]);
   // convert day and year to numbers
   var endDay  = eval(endDateArray[0]);
   var endMonth= monthString(ucEndMonth);
   var endYear = eval(endDateArray[2]);
   var compBegMonth = eval(monthConversion(begMonth));
   var compEndMonth = eval(monthConversion(endMonth));
   if (endDate.length > 0 && (compBegMonth != null && compEndMonth != null)) 
   {
      if (endYear < begYear)
      {
         alert ("Activaton End Date can not be earlier than the beginning date!");
         endCtl.focus();
         return false;
      }
      else if (endYear == begYear  &&  compEndMonth < compBegMonth)
      {
         alert ("Activaton End Date can not be earlier than the beginning date!");
         endCtl.focus();
         return false;
      }
      else if (endYear == begYear && compEndMonth == compBegMonth) 
      {
         if (begDay > endDay ) 
         {
            alert ("Activaton End Date can not be earlier than the beginning date!");
            endCtl.focus();
            return false;
         }
      }
   }
   return true;
}


function validateForm(form)
{
  if (!dateValidation(form.tfBegActDate))
   {
      return false;
   }
   else if (!dateValidation(form.tfEndActDate))
   {
      return false;
   }
   else if (!endDateValidation(form.tfBegActDate, form.tfEndActDate))
   {
      return false;
   }
 return true;
}
