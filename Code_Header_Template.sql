/*********************************************************************************************************************
-- NAME --------------------------------------------------------------------------------------------------------------
 
 Code Header Example

-- AUTHOR ------------------------------------------------------------------------------------------------------------

Firstname Lastname - MM/DD/YYYY
 
-- PURPOSE -----------------------------------------------------------------------------------------------------------
 
 Placeholder to be used for all SQL scripts

-- USAGE/LINKED PROCESSES --------------------------------------------------------------------------------------------

-- STEPS -------------------------------------------------------------------------------------------------------------

 -- 010.  
 -- 020.  
 -- 030.  

-- PARAMETERS --------------------------------------------------------------------------------------------------------

-- Find/Replace:

-- Parameters provided to run:
  
  @Example  -->  requirement

-- WARNINGS ----------------------------------------------------------------------------------------------------------
 

 Ex 1: Code requires specific handling to be rerun in a cycle
 Ex 2: This script drops tables so perform any backups before running if required

-- SUMMARY OF CHANGES ------------------------------------------------------------------------------------------------

Version		    Date(yyyy-mm-dd)   Author          PBI# 	Description
----------------------------------------------------------------------------------------------------------------------
  1.0			2012-04-27      John Usdaworkhur    128 	Move Z <-> X was done in a single step. Warehouse does not
  														    allow this. Converted to two step process.
  														    Z <-> 7 <-> X
  															1) move class Z to class 7
  															2) move class 7 to class X
  
  2.0			2018-03-22       Maan Widaplan      256 	General formatting and added header information.
  3.0			2018-03-22       Maan Widaplan      871 	Added logic to automatically Move G <-> H after 12 months.						
  
**********************************************************************************************************************/
