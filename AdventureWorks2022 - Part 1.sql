--https://www.w3resource.com/sql-exercises/adventureworks/adventureworks-exercises.php



/*
1. From the following table write a query in SQL to retrieve 
all rows and columns from the employee table in the Adventureworks database. 
Sort the result set in ascending order on jobtitle.

Sample table: HumanResources.Employee
*/
SELECT 
		BusinessEntityID
		,NationalIDNumber
		,LoginID
		,OrganizationNode
		,OrganizationLevel
		,JobTitle
		,BirthDate
		,MaritalStatus
		,Gender
		,HireDate
		,SalariedFlag
		,VacationHours
		,SickLeaveHours
		,CurrentFlag
		,rowguid
		,ModifiedDate
FROM AdventureWorks2022.HumanResources.Employee
ORDER BY JobTitle ASC;


/*
2. From the following table write a query in SQL to retrieve 
all rows and columns from the employee table using table aliasing in the Adventureworks database. 
Sort the output in ascending order on lastname.

Sample table: Person.Person
*/

SELECT 
		p.BusinessEntityID
		,p.PersonType
		,p.NameStyle
		,p.Title
		,p.FirstName
		,p.MiddleName
		,p.LastName
		,p.Suffix
		,p.EmailPromotion
		,p.AdditionalContactInfo
		,p.Demographics
		,p.rowguid
		,p.ModifiedDate
FROM AdventureWorks2022.Person.Person p
ORDER BY LastName ASC;


/*
3. From the following table write a query in SQL to return all rows and a subset of the columns 
(FirstName, LastName, businessentityid) from the person table in the AdventureWorks database. 
The third column heading is renamed to Employee_id. Arranged the output in ascending order by lastname.

Sample table: Person.Person
*/

SELECT 
	FirstName
	,LastName
	,BusinessEntityID as Employee_id
FROM AdventureWorks2022.Person.Person 
ORDER BY LastName ASC;


/*
4. From the following table write a query in SQL to return only the rows for product that 
have a sellstartdate that is not NULL and a productline of 'T'. 
Return productid, productnumber, and name. 
Arranged the output in ascending order on name.

Sample table: production.Product
*/


SELECT 
		ProductID
		,Name
		,ProductNumber
FROM AdventureWorks2022.Production.Product
WHERE SellStartDate IS NOT NULL
	AND ProductLine = 'T'
ORDER BY NAME ASC;


/*
5. From the following table write a query in SQL to return all rows from the salesorderheader table in Adventureworks database 
and calculate the percentage of tax on the subtotal have decided. 
Return salesorderid, customerid, orderdate, subtotal, percentage of tax column. 
Arranged the result set in descending order on subtotal.

Sample table: sales.salesorderheader
*/

SELECT
		SalesOrderID
		,CustomerID
		,OrderDate
		,SubTotal
		,(TaxAmt/SubTotal)*100 AS TaxPercentage
FROM AdventureWorks2022.Sales.SalesOrderHeader
ORDER BY SubTotal DESC


/*
6. From the following table write a query in SQL to create a list of unique 
jobtitles in the employee table in Adventureworks database. 
Return jobtitle column and arranged the resultset in ascending order.

Sample table: HumanResources.Employee
*/

SELECT DISTINCT JobTitle
FROM AdventureWorks2022.HumanResources.Employee
ORDER BY JobTitle ASC


/*
7. From the following table write a query in SQL to calculate the total freight paid by each customer. 
Return customerid and total freight. Sort the output in ascending order on customerid.

Sample table: sales.salesorderheader
*/

SELECT 
	CustomerID
	,SUM(Freight) AS TotalFreight
FROM AdventureWorks2022.Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID ASC


/*
8. From the following table write a query in SQL to find the average and the sum of the subtotal for every customer. 
Return customerid, average and sum of the subtotal. Grouped the result on customerid and salespersonid. 
Sort the result on customerid column in descending order.

Sample table: sales.salesorderheader
*/

SELECT 
	CustomerID
	,SalesPersonID
	,AVG(SubTotal) AS Avg_SubTotal
	,SUM(SubTotal) AS Sum_SubTotal
FROM AdventureWorks2022.Sales.SalesOrderHeader
GROUP BY CustomerID, SalesPersonID
ORDER BY CustomerID DESC


/*
9. From the following table write a query in SQL to retrieve total quantity of each productid 
which are in shelf of 'A' or 'C' or 'H'. Filter the results for sum quantity is more than 500. 
Return productid and sum of the quantity. Sort the results according to the productid in ascending order.

Sample table: production.productinventory
*/

SELECT 
		ProductID
		,SUM(Quantity) AS Sum_Quantity
FROM AdventureWorks2022.Production.ProductInventory
WHERE Shelf IN ('A','C','H')
GROUP BY ProductID
HAVING SUM(Quantity) > 500
ORDER BY ProductID ASC


/*
10. From the following table write a query in SQL to find the total quentity for a group of locationid multiplied by 10.

Sample table: production.productinventory
*/

SELECT SUM(Quantity) AS Total_Quantity
FROM AdventureWorks2022.Production.ProductInventory
GROUP BY (LocationID*10)


/*
11. From the following tables write a query in SQL to find the persons whose last name starts with letter 'L'. 
Return BusinessEntityID, FirstName, LastName, and PhoneNumber. Sort the result on lastname and firstname.

Sample table: Person.PersonPhone
Sample table: Person.Person
*/


SELECT 
		p.BusinessEntityID
		,p.FirstName
		,p.LastName
		,pe.PhoneNumber
FROM AdventureWorks2022.Person.Person p
	INNER JOIN AdventureWorks2022.Person.PersonPhone pe
		ON  p.BusinessEntityID = pe.BusinessEntityID
WHERE p.LastName LIKE 'L%'
ORDER BY p.LastName, p.FirstName


/*
12. From the following table write a query in SQL to find the sum of subtotal column. 
Group the sum on distinct salespersonid and customerid. Rolls up the results into subtotal and running total. 
Return salespersonid, customerid and sum of subtotal column i.e. sum_subtotal.

Sample table: sales.salesorderheader
*/


SELECT 
	SalesPersonID
	,CustomerID
	,SUM(SubTotal) AS Sum_SubTotal
FROM AdventureWorks2022.Sales.SalesOrderHeader
GROUP BY ROLLUP (SalesPersonID, CustomerID)


/*
13. From the following table write a query in SQL to find the sum of the quantity of all combination of group of distinct locationid 
and shelf column. Return locationid, shelf and sum of quantity as TotalQuantity.

Sample table: production.productinventory
*/


SELECT
	LocationID
	,Shelf 
	,SUM(Quantity) as TotalQuantity
FROM AdventureWorks2022.Production.ProductInventory
GROUP BY CUBE (LocationID,Shelf)


/*
14. From the following table write a query in SQL to find the sum of the quantity with subtotal for each locationid. 
Group the results for all combination of distinct locationid and shelf column. Rolls up the results into subtotal and running total. 
Return locationid, shelf and sum of quantity as TotalQuantity.

Sample table: production.productinventory
*/


SELECT 
	LocationID
	,Shelf
	,SUM(Quantity) AS Sum_Quantity
FROM AdventureWorks2022.Production.ProductInventory
GROUP BY GROUPING SETS (ROLLUP(LocationID, Shelf), CUBE (LocationID, Shelf))


/*
15. From the following table write a query in SQL to find the total quantity for each locationid and 
calculate the grand-total for all locations. Return locationid and total quantity. 
Group the results on locationid.

Sample table: production.productinventory
*/


SELECT 
	ISNULL(CAST(LocationID AS VARCHAR(20)), 'Total_All_Locations') AS Location
	,SUM(Quantity) AS TotalQuantity
FROM AdventureWorks2022.Production.ProductInventory
GROUP BY ROLLUP (LocationID)


/*
16. From the following table write a query in SQL to retrieve the number of employees for each City. 
Return city and number of employees. Sort the result in ascending order on city.

Sample table: Person.BusinessEntityAddress
Sample table: Person.Address
*/


SELECT
	a.City
	,COUNT(ea.BusinessEntityID) AS EmployeeNBR
FROM AdventureWorks2022.Person.BusinessEntityAddress ea
	INNER JOIN AdventureWorks2022.Person.Address a
		ON ea.AddressID = a.AddressID
GROUP BY a.City
ORDER BY a.City ASC


/*
17. From the following table write a query in SQL to retrieve the total sales for each year. 
Return the year part of order date and total due amount. 
Sort the result in ascending order on year part of order date.

Sample table: Sales.SalesOrderHeader
*/


SELECT
	YEAR(OrderDate) AS Year
	,SUM(TotalDue) AS TotalAmount
FROM AdventureWorks2022.Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) ASC


/*
18. From the following table write a query in SQL to retrieve the total sales for each year. 
Filter the result set for those orders where order year is on or before 2016. 
Return the year part of orderdate and total due amount. Sort the result in ascending order on year part of order date.

Sample table: Sales.SalesOrderHeader
*/


SELECT
	YEAR(OrderDate) AS Year
	,SUM(TotalDue) AS TotalAmount
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE YEAR(OrderDate) <= 2016
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate) ASC;


/*
19. From the following table write a query in SQL to find the contacts who are designated as a manager in various departments. 
Returns ContactTypeID, name. Sort the result set in descending order.

Sample table: Person.ContactType
*/


SELECT
	ContactTypeID,
	Name
FROM AdventureWorks2022.Person.ContactType
WHERE NAME LIKE '%Manager%'
ORDER BY ContactTypeID DESC


/*
20. From the following tables write a query in SQL to make a list of contacts who are designated as 'Purchasing Manager'. 
Return BusinessEntityID, LastName, and FirstName columns. Sort the result set in ascending order of LastName, and FirstName.

Sample table: Person.BusinessEntityContact
Sample table: Person.ContactType
Sample table: Person.Person
*/


SELECT
	pe.BusinessEntityID
	,pe.LastName
	,pe.FirstName
FROM AdventureWorks2022.Person.Person pe
	INNER JOIN AdventureWorks2022.Person.BusinessEntityContact ec
		ON pe.BusinessEntityID = ec.PersonID
	INNER JOIN AdventureWorks2022.Person.ContactType ct
		ON ec.ContactTypeID = ct.ContactTypeID
WHERE ct.ContactTypeID = 15 --Purchasing Manager
ORDER BY pe.LastName, pe.FirstName


/*
21. From the following tables write a query in SQL to retrieve the salesperson for each PostalCode 
who belongs to a territory and SalesYTD is not zero. Return row numbers of each group of 
PostalCode, last name, salesytd, postalcode column. Sort the salesytd of each postalcode group in descending order. 
Shorts the postalcode in ascending order.

Sample table: Sales.SalesPerson
Sample table: Person.Person
Sample table: Person.Address
*/

SELECT 
	ROW_NUMBER() OVER (PARTITION BY ad.PostalCode ORDER BY sp.SalesYTD DESC) AS RN
	,ad.PostalCode
	,pe.LastName
	,sp.SalesYTD
FROM AdventureWorks2022.Sales.SalesPerson sp
	INNER JOIN AdventureWorks2022.Person.Person pe
		ON sp.BusinessEntityID = pe.BusinessEntityID
	INNER JOIN AdventureWorks2022.Person.Address ad
		ON ad.AddressID = pe.BusinessEntityID
WHERE sp.TerritoryID IS NOT NULL
AND sp.SalesYTD <> 0
ORDER BY PostalCode


/*
22. From the following table write a query in SQL to count the number of contacts for combination of each type and name. 
Filter the output for those who have 100 or more contacts. Return ContactTypeID and ContactTypeName and BusinessEntityContact. 
Sort the result set in descending order on number of contacts.

Sample table: Person.BusinessEntityContact
Sample table: Person.ContactType
*/

SELECT 
	ec.ContactTypeID
	,ct.Name
	,COUNT(ec.ContactTypeID) AS ContactNBR
FROM AdventureWorks2022.Person.BusinessEntityContact ec
	INNER JOIN AdventureWorks2022.Person.ContactType ct
		ON ec.ContactTypeID = ct.ContactTypeID
GROUP BY ec.ContactTypeID, ct.Name
HAVING COUNT(ec.ContactTypeID) >= 100
ORDER BY COUNT(ec.ContactTypeID) DESC


/*
23. From the following table write a query in SQL to retrieve the RateChangeDate, 
full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees. 
In the output the RateChangeDate should appears in date format. Sort the output in ascending order on NameInFull.

Sample table: HumanResources.EmployeePayHistory
Sample table: Person.Person
*/


SELECT
	CAST(ph.RateChangeDate AS date) AS RateChangeDate
	,CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS Full_Name
	,(40 * ph.Rate) AS WeeklySalary
FROM AdventureWorks2022.HumanResources.EmployeePayHistory ph
	INNER JOIN AdventureWorks2022.Person.Person pe
		ON ph.BusinessEntityID = pe.BusinessEntityID
ORDER BY Full_Name ASC


/*
24. From the following tables write a query in SQL to calculate and display the latest weekly salary of each employee. 
Return RateChangeDate, full name (first name, middle name and last name) and weekly salary (40 hours in a week) of employees 
Sort the output in ascending order on NameInFull.

Sample table: Person.Person
Sample table: HumanResources.EmployeePayHistory
*/


SELECT 
	CAST(ph.RateChangeDate as date) AS Date
	,CONCAT(LastName, ', ', FirstName, ' ', MiddleName) AS Full_Name
	,(40 * ph.Rate) AS WeeklySalaryek
FROM AdventureWorks2022.HumanResources.EmployeePayHistory ph
	INNER JOIN AdventureWorks2022.Person.Person pe
		ON ph.BusinessEntityID = pe.BusinessEntityID
WHERE ph.RateChangeDate = (SELECT MAX(RateChangeDate)
                                FROM AdventureWorks2022.HumanResources.EmployeePayHistory 
                                WHERE BusinessEntityID = ph.BusinessEntityID)
ORDER BY Full_Name


/*
25. From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order 
quentity for those orders whose id are 43659 and 43664. Return SalesOrderID, ProductID, OrderQty, 
sum, average, count, max, and min order quantity.

Sample table: Sales.SalesOrderDetail
*/


SELECT
	SalesOrderID
	,ProductID
	,OrderQty
	,SUM(OrderQty) OVER (PARTITION BY SalesOrderID)AS Sum_OrderQty
	,AVG(OrderQty)OVER (PARTITION BY SalesOrderID) AS Avg_OrderQty
	,COUNT(OrderQty) OVER (PARTITION BY SalesOrderID) AS Count_OrderQty
	,MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS Min_OrderQty
	,MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS Max_OrderQTY
FROM AdventureWorks2022.Sales.SalesOrderDetail
WHERE SalesOrderID IN (43659, 43664)

