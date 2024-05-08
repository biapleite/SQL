/*********************************************************************************************************************
-- NAME --------------------------------------------------------------------------------------------------------------
 
 Slowly Changing Dimension Type 2 in SQL for Azure Synapse Analytics.


-- AUTHOR ------------------------------------------------------------------------------------------------------------

Beatriz Leite - 07/29/2021
 
 
-- PURPOSE -----------------------------------------------------------------------------------------------------------
 
 The purpose of this script is to apply a Slowly Changing Dimension Type 2 in a ~300 million row using SQL in a Azure Synapse Analytics Table.
 
 
-- CONTEXT ----------------------------------------------------------------------------------------------------------

 1: This script is part of a project which consists in migrating the data warehouse from SQL Server to Azure Synapse Analytics.
 2: The main tool used for ETL purposes is Talend, however since this is a huge table the SCD Talend component was not able to process due to the volume of data.
 3: There is an option to use MERGE as a SQL command to perform slow changing dimension, however as of July 2021 this is a feature still in preview in Azure Synapse Analytics.


-- STEPS -------------------------------------------------------------------------------------------------------------

 -- 1.  DELETION PART
 -- 2.  UPDATE PART
 -- 3.  INSERT PART
 -- 4. 	VALIDATION


-- SUMMARY OF CHANGES ------------------------------------------------------------------------------------------------

Version		    Date(yyyy-mm-dd)   Author          PBI# 	Description
----------------------------------------------------------------------------------------------------------------------
  1.0		    2021-07-29        Beatriz Leite    	001 	Created the script.
															
--Note this script has been created based on task executed but the overall script as well as table and column titles have been modified to preserve the privacy of the data.
				
  
**********************************************************************************************************************/


/*===============================================================================
STEP 1: DELETION PART 
===============================================================================*/


/*============================================================================================
STEP 1.1: IF EXISTS DROP TEMPORARY TABLE WHICH STORE IDS DELETED (FROM PREVIOUS EXECUTION) 
============================================================================================*/

IF OBJECT_ID('CDM.ID_DELETED') IS NOT NULL
	DROP TABLE CDM.ID_DELETED;


/*========================================================================================================
STEP 1.2: CREATE NEW TEMPORARY TABLE TO STORE IDS DELETED (IDS THAT EXIST ON TGT BUT NOT ON TMP TABLE)
========================================================================================================*/

CREATE TABLE CDM.ID_DELETED
WITH (DISTRIBUTION = HASH (ID), CLUSTERED COLUMNSTORE INDEX)
AS
SELECT TGT.*
FROM CDM.TARGET_TABLE TGT
LEFT JOIN CDM.TMP_TABLE TMP
ON TGT.ID = TMP.ID
WHERE TMP.ID IS NULL
AND TGT.HIST_END_DATETIME IS NULL
AND TGT.IS_DELETED = 0

/*=====================================================================================
STEP 1.3: UPDATE TARGET TABLE AND INCLUDE TODAY'S DATE AS END DATE FOR DELETED ID'S 
--===================================================================================*/

UPDATE CDM.TARGET_TABLE
SET
	HIST_END_DATETIME = GETDATE()
FROM CDM.TARGET_TABLE TGT
INNER JOIN CDM.ID_DELETED ID
ON ID.ID = TGT.ID
WHERE TGT.HIST_END_DATETIME IS NULL


/*==============================================================================
STEP 1.4: INSERT THE DELETED ROWS IN TARGET TABLE FLAGGED WITH IS_DELETED = 1
==============================================================================*/

; WITH LAST_EDITED AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY ID ORDER BY HIST_END_DATETIME DESC) AS RN
FROM CDM.TARGET_TABLE TGT
)
INSERT INTO CDM.TARGET_TABLE
(
COLUMN1,
COLUMN2,
COLUMN3,
COLUMN4,
COLUMN5,
COLUMN6,
COLUMN7,
COLUMN8,
COLUMN9,
COLUMN10,
IS_DELETED,
HIST_START_DATETIME,
HIST_END_DATETIME
)
SELECT 
LE.COLUMN1,
LE.COLUMN2,
LE.COLUMN3,
LE.COLUMN4,
LE.COLUMN5,
LE.COLUMN6,
LE.COLUMN7,
LE.COLUMN8,
LE.COLUMN9,
LE.COLUMN10,
1 AS IS_DELETED,
GETDATE () AS HIST_START_DATETIME,
NULL AS HIST_END_DATETIME
FROM LAST_EDITED LE
INNER JOIN CDM.ID_DELETED ID
ON ID.ID = LE.ID 
WHERE LE.RN = 1 --INSERT ON TARGET TABLE THE ID THAT WAS MARKED WITH HIST_END_DATETIME - ON STEP 1.3 (UPDATE TARGET TABLE AND INCLUDE TODAY'S DATE AS END DATE FOR DELETED ID'S )



/*===============================================================================
STEP 2: UPDATE PART 
===============================================================================*/

/*======================================================================================
STEP 2.1: UPDATE SCD FIELD WITH 'U' TO IDENTIFY THE ROWS THAT NEEDS TO BE UPDATED
======================================================================================*/

UPDATE CDM.TMP_TABLE
SET
	SCD = 'U'
FROM CDM.TMP_TABLE TMP
INNER JOIN CDM.TARGET_TABLE TGT
ON TGT.ID = TMP.ID
AND CHECKSUM (TGT.COLUMN1, TGT.COLUMN2, TGT.COLUMN3, TGT.COLUMN4, TGT.COLUMN5, TGT.COLUMN6, TGT.COLUMN7, TGT.COLUMN8, TGT.COLUMN9, TGT.COLUMN10)
!= CHECKSUM (TMP.COLUMN1, TMP.COLUMN2, TMP.COLUMN3, TMP.COLUMN4, TMP.COLUMN5, TMP.COLUMN6, TMP.COLUMN7, TMP.COLUMN8, TMP.COLUMN9, TMP.COLUMN10)
AND TGT.HIST_END_DATETIME IS NULL


/*===========================================================================================
STEP 2.2: UPDATE TARGET TABLE AND INCLUDE TODAY'S DATE AS END DATE FOR IDS MARKED WITH 'U' 
===========================================================================================*/

UPDATE CDM.TARGET_TABLE
SET
	HIST_END_DATETIME = GETDATE()
FROM CDM.TARGET_TABLE TGT
INNER JOIN CDM.TMP_TABLE TMP
ON TGT.ID = TMP.ID
AND TMP.SCD = 'U'
WHERE TGT.HIST_END_DATETIME IS NULL


/*====================================================================================
STEP 2.3: INSERT THE ROWS MARKED WITH 'U' THE WITH THE NEW INFORMATION AS ACTIVE ROW
====================================================================================*/

INSERT INTO CDM.TARGET_TABLE
(
COLUMN1,
COLUMN2,
COLUMN3,
COLUMN4,
COLUMN5,
COLUMN6,
COLUMN7,
COLUMN8,
COLUMN9,
COLUMN10,
IS_DELETED,
HIST_START_DATETIME,
HIST_END_DATETIME
)
SELECT 
COLUMN1,
COLUMN2,
COLUMN3,
COLUMN4,
COLUMN5,
COLUMN6,
COLUMN7,
COLUMN8,
COLUMN9,
COLUMN10,
0 AS IS_DELETED,
GETDATE () AS HIST_START_DATETIME,
NULL AS HIST_END_DATETIME
FROM CDM.TMP_TABLE 
WHERE SCD = 'U'



/*===============================================================================
STEP 3: INSERT PART 
===============================================================================*/

/*================================================================================================
STEP 3.1: UPDATE SCD FIELD WITH 'I' TO IDENTIFY THE ROWS THAT NEEDS TO BE INSERTED - NEW IDS
================================================================================================*/

UPDATE CDM.TMP_TABLE
SET
	SCD = 'I'
FROM CDM.TMP_TABLE TMP
WHERE NOT EXISTS
(
SELECT 1
FROM CDM.TARGET_TABLE
WHERE ID = TMP.ID
)


/*==========================================
STEP 3.2: INSERT THE ROWS MARKED AS 'I'
--========================================*/

INSERT INTO CDM.TARGET_TABLE
(
COLUMN1,
COLUMN2,
COLUMN3,
COLUMN4,
COLUMN5,
COLUMN6,
COLUMN7,
COLUMN8,
COLUMN9,
COLUMN10,
IS_DELETED,
HIST_START_DATETIME,
HIST_END_DATETIME
)
SELECT 
COLUMN1,
COLUMN2,
COLUMN3,
COLUMN4,
COLUMN5,
COLUMN6,
COLUMN7,
COLUMN8,
COLUMN9,
COLUMN10,
0 AS IS_DELETED,
GETDATE () AS HIST_START_DATETIME,
NULL AS HIST_END_DATETIME
FROM CDM.TMP_TABLE 
WHERE SCD = 'I'
AND NOT EXISTS
(
SELECT 1
FROM CDM.TARGET_TABLE
WHERE ID = TMP.ID
)

--SCD IMPLEMENTATION FINISHED HERE, THE NEXT SESSION IS TO INVESTIGATE AND CONFIRM THAT IS WORKING AS EXPECTED


/*===============================================================================
STEP 4: VALIDATION PART 
===============================================================================*/


--INVESTIGATING ROWS TO BE INSERTED 

SELECT COUNT (*)
FROM CDM.TMP_TABLE 
WHERE SCD = 'I'

--INVESTIGATING ROWS TO BE UPDATED 

SELECT COUNT (*)
FROM CDM.TMP_TABLE 
WHERE SCD = 'U'

--INVESTIGATING ROWS TO BE DELETED

SELECT COUNT (*)
FROM CDM.ID_DELETED




--INVESTIGATING TOTAL ACTIVE ROWS ON TARGET TABLE (SUM OF INSERTED ROWS AFTER EACH EXECUTION)

SELECT COUNT (*)
FROM TARGET_TABLE
WHERE HIST_END_DATETIME IS NULL



--INVESTIGATING TOTAL DEACTIVATED ROWS ON TARGET TABLE (SUM OF DELETED ROWS AFTER EACH EXECUTION)

SELECT COUNT (*)
FROM TARGET_TABLE
WHERE IS_DELETED = 1


--INVESTIGATING TOTAL UPDATED AND DEACTIVATED ROWS ON TARGET TABLE (SUM OF UPDATED AND DELETED ROWS AFTER EACH EXECUTION)

SELECT COUNT (*)
FROM TARGET_TABLE
WHERE HIST_END_DATETIME IS NOT NULL


--INVESTIGATING TOTAL RECORD COUNTS (SUM OF INSERTED, UPDATED AND DELETED ROWS AFTER EACH EXECUTION)

SELECT COUNT (*)
FROM TARGET_TABLE
