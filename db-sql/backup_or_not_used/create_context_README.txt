Requirements/request -

Warzel, Denise (NIH/NCI) [E]Actions
To:
 Tan, James (NIH/NCI) [C] 
 Monday, May 13, 2013 1:58 PM
You forwarded this message on 5/13/2013 2:29 PM.
Hi James, 

When do you think you will be able to run the script to add the new contexts to Production?  They don’t have to go through all the tiers since we have tested it already.


------ Forwarded Message
From: Dianne Reeves <reevesd@mail.nih.gov>
Date: Mon, 13 May 2013 13:45:36 -0400
To: Tommie Curtis <curtist@mail.nih.gov>, "Warzel, Denise (NIH/NCI) [E]" <warzeld@mail.nih.gov>
Subject: Update on contexts

Sorry – I forgot to tell you this on the new contexts:
SWOG is first – we have all we need except extending the privileges to the CTEP preceptors.  We have their content, their curators, their administrator.  
COG is next – awaiting their reply
ACRIN/ECOG is next once they decide about a few items
Alliance will be moving forward as soon as I reconnect with their point of contact.  
 
Denise – can you please create the SWOG context.  Short name is SWOG, long name is the same – they don’t want to use the name ‘Southwest Oncology Group’ any longer because it is no longer a geographically-defined group.  I don’t have the final naming convention for the other contexts, but they will be coming shortly.
 
Dianne 


From: Gaheen, Sharon (NIH/NCI) [C]
Sent: Friday, March 15, 2013 10:04 AM
To: Tan, James (NIH/NCI) [C]
Subject: FW: New Contexts in caDSR

Hi James,

Please move forward with running this on DEV, and yes, make sure we have a backup.

Thanks!
Sharon

-----Original Message-----
From: Warzel, Denise (NIH/NCI) [E] 
Sent: Thursday, March 14, 2013 12:20 PM
To: Gaheen, Sharon M.
Subject: New Contexts in caDSR

Hi Sharon,

The content team wants to add a bunch of new Contexts to caDSR.  This is a multi-step process if done manually.

There was a script written to do this, could someone test this script on one of the non-production tiers to see if it still works?  I don't have privileges or know how to connect to the database so I can't  do the test.  If it works, it will save me a lot of time...there are 3 that need to be created now, and more coming...

Here is the wiki page describing what to do - see the "Semi-Automated" section - you have to be signed into the wiki to see the page.

https://wiki.nci.nih.gov/display/caDSRproj/Create+caDSR+Context

*** APPLYING CHANGES ***

Run with user SBREXT:

SQL*Plus: Release 10.2.0.4.0 - Production on Tue Mar 26 09:58:16 2013

Copyright (c) 1982, 2007, Oracle.  All Rights Reserved.


Connected to:
Oracle Database 10g Enterprise Edition Release 10.2.0.5.0 - 64bit Production
With the Partitioning, Data Mining and Real Application Testing options

SQL> @create_context.sql
1

PL/SQL procedure successfully completed.


Commit complete.

1

PL/SQL procedure successfully completed.


Commit complete.

1

PL/SQL procedure successfully completed.


Commit complete.


SCL_NAME
------------------------------
DESCRIPTION
--------------------------------------------------------------------------------
AECC_SC
Security Context for AECC

LCC_SC
Security Context for LCC

USC/NCCC_SC
Security Context for USC/NCCC


SQL> 

 