/*
Implement and call a SQL procedure to apply Slowly Changing Dimension type 2 table within a data warehouse.
*/

--Drop table if not exists
IF OBJECT_ID (N'dbo.SourceProducts') IS NOT NULL DROP TABLE dbo.SourceProducts;
IF OBJECT_ID (N'dbo.TargetProducts') IS NOT NULL DROP TABLE dbo.TargetProducts;

--Create source table
CREATE TABLE SourceProducts(
    ProductID		INT,
    ProductName		VARCHAR(50),
    Price			DECIMAL(9,2)
)
GO

--Load Source table
INSERT INTO SourceProducts(ProductID,ProductName, Price) VALUES(1,'Table',100)
INSERT INTO SourceProducts(ProductID,ProductName, Price) VALUES(2,'Desk',80)
INSERT INTO SourceProducts(ProductID,ProductName, Price) VALUES(3,'Chair',50)
INSERT INTO SourceProducts(ProductID,ProductName, Price) VALUES(4,'Computer',300)
GO


--Create Target Table
CREATE TABLE TargetProducts(
    ProductID		INT,
    ProductName		VARCHAR(50),
    Price			DECIMAL(9,2),
	ActiveFLG		BIT,
	EndDate			DATE
)
GO


--Load Target Table
INSERT INTO TargetProducts(ProductID,ProductName, Price, ActiveFLG, EndDate) VALUES(1,'Table',100,1,NULL)
INSERT INTO TargetProducts(ProductID,ProductName, Price, ActiveFLG, EndDate) VALUES(2,'Desk',180,1,NULL)
INSERT INTO TargetProducts(ProductID,ProductName, Price, ActiveFLG, EndDate) VALUES(5,'Bed',50,1,NULL)
INSERT INTO TargetProducts(ProductID,ProductName, Price, ActiveFLG, EndDate) VALUES(6,'Cupboard',300,1,NULL)
GO


--Check difference between Source and Target tables
SELECT * FROM SourceProducts;
SELECT * FROM TargetProducts;


--Drop procedure if exists
IF EXISTS (
        SELECT type_desc, type
        FROM sys.procedures WITH(NOLOCK)
        WHERE NAME = 'SCDType2MERGE'
            AND type = 'P'
      )
     DROP PROCEDURE dbo.SCDType2MERGE
GO



--Create Procedure to implement SCD type 2 with MERGE statement
CREATE PROCEDURE SCDType2MERGE
AS 
BEGIN

INSERT INTO TargetProducts (ProductID,ProductName, Price, ActiveFLG, EndDate)
SELECT ProductID,ProductName, Price, 1, NULL
FROM (

MERGE TargetProducts AS Target
USING SourceProducts AS Source
ON Source.ProductID = Target.ProductID

--UPDATE
WHEN MATCHED 
AND (Source.ProductName <> Target.ProductName OR Source.Price <> Target.Price)
AND ActiveFLG = 1
THEN UPDATE SET
	Target.ActiveFLG	= 0,
	Target.EndDate		= GETDATE()-1

--INSERT
WHEN NOT MATCHED BY Target THEN
	INSERT (ProductID, ProductName, Price, ActiveFLG, EndDate)
	VALUES (Source.ProductID, Source.ProductName, Source.Price, 1, NULL)
--	OUTPUT $action, Source.ProductID, Source.ProductName, Source.Price,1, NULL


--DELETE
WHEN NOT MATCHED BY Source THEN
UPDATE SET
	Target.ActiveFLG = 0,
	Target.EndDate = GETDATE()-1


--INSERT UPDATED AS NEW RECORD
OUTPUT $Action, Source.*
)AS i([Action], [ProductID],[ProductName], [Price])

where [Action] = 'UPDATE'
AND ProductID IS NOT NULL


SELECT * FROM SourceProducts ORDER BY ProductID;
SELECT * FROM TargetProducts ORDER BY ProductID;

END



--Call Procedure
EXEC SCDType2MERGE;