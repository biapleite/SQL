# SQL - Portfolio

## Projects

### -   SQL

#### 1. SCD Type 2

**Goal:**  The purpose of this script is to apply a Slowly Changing Dimension Type 2 in a ~300 million row using SQL in a Azure Synapse Analytics Table.

**Code:** [SCD_Type_2.sql](https://github.com/biapleite/SQL/blob/main/SCD_Type_2%20without%20MERGE.sql)

**Description:** A type 2 slowly changing dimension enables you to track the history of updates to your dimension records. When a changed record enters the warehouse, it creates a new record to store the changed data and leaves the old record intact. Type 2 is the most common type of slowly changing dimension because it enables you to track historically significant attributes. The old records point to all history prior to the latest change, and the new record maintains the most current information. 
This script is part of a project which consists in migrating the data warehouse from SQL Server to Azure Synapse Analytics. The main tool used for ETL purposes is Talend, however since this is a huge table the SCD Talend component was not able to process due to the volume of data. There is an option to use MERGE as a SQL command to perform slow changing dimension, however as of July 2021 this is a feature still in preview in Azure Synapse Analytics.

**Technologies:** SQL Server, Azure Synapse Analytics, Talend Enterprise Data Integration 

**Skills:** DDL (Create, Drop), Join (Inner, Left), Update, CTE (Common Table Expression), Insert, Funtion (checksum, getdate).

**Results:** Achieved the objective of keeping track of changes on this table by using  
<br/>

#### 2. Code Header Template

**Goal:**  The purpose of this script is to serve as a template to keep track of SQL scripts changes overtime.

**Code:** [Code_Header_Template.sql](https://github.com/biapleite/SQL/blob/main/Code_Header_Template.sql)

**Description:** A Code Header Template includes the title of file, author, purpose, summary of changes. When applicable, it can also includes: steps, parameters, warnings. This is recommended while maintaining a very large and complex .sql file.

**Technologies:** SQL Server.

**Skills:** Documentation

<br/>


