Source: https://wiki.nci.nih.gov/download/attachments/557631/create_context.sql

Requirements/request -

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

 