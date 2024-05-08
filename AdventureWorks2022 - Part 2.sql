/*
26. From the following table write a query in SQL to find the sum, average, and number of order quantity for those orders 
whose ids are 43659 and 43664 and product id starting with '71'. 
Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, and number of order quantity.

Sample table: Sales.SalesOrderDetail
*/

SELECT 
	SalesOrderID
	,ProductID
	,OrderQty
	,SUM(OrderQty) OVER (ORDER BY SalesOrderID, ProductID) as SumOrderQty
	,AVG(OrderQty) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID) as AvgOrderQty
	,COUNT(OrderQty) OVER(ORDER BY SalesOrderID, ProductID) as CountOrderQty
FROM AdventureWorks2022.Sales.SalesOrderDetail
WHERE SalesOrderID IN ('43659','43664')
	AND ProductID LIKE '71%' 
GROUP BY SalesOrderID, ProductID, OrderQty


/*
27. From the following table write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000. 
Return SalesOrderID, total cost.

Sample table: Sales.SalesOrderDetail
*/


SELECT
	SalesOrderID,
	SUM(OrderQty*UnitPrice) OrderIDCost
FROM AdventureWorks2022.Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(OrderQty*UnitPrice) > 100000
ORDER BY SalesOrderID;


/*
28. From the following table write a query in SQL to retrieve products whose names start with 'Lock Washer'. 
Return product ID, and name and order the result set in ascending order on product ID column.

Sample table: Production.Product
*/


SELECT
	ProductID
	,Name
FROM AdventureWorks2022.Production.Product
WHERE name LIKE 'Lock Washer%'
ORDER BY ProductID ASC


/*
29. Write a query in SQL to fetch rows from product table and order the result set on an unspecified column listprice. 
Return product ID, name, and color of the product.

Sample table: Production.Product
*/


SELECT 
	ProductID
	,Name
	,Color
FROM AdventureWorks2022.Production.Product
ORDER BY ListPrice


/*
30. From the following table write a query in SQL to retrieve records of employees. 
Order the output on year (default ascending order) of hiredate. 
Return BusinessEntityID, JobTitle, and HireDate.

Sample table: HumanResources.Employee
*/


SELECT 
	BusinessEntityID
	,JobTitle
	,HireDate
FROM AdventureWorks2022.HumanResources.Employee
ORDER BY YEAR(HireDate) ASC


/*
31. From the following table write a query in SQL to retrieve those persons whose last name begins with letter 'R'. 
Return lastname, and firstname and display the result in ascending order on firstname and descending order on lastname columns.

Sample table: Person.Person
*/


SELECT
	LastName
	,FirstName
FROM AdventureWorks2022.Person.Person
WHERE LastName LIKE 'R%'
ORDER BY FirstName ASC, LastName DESC


/*
32. From the following table write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag set to 'true' 
and BusinessEntityID in ascending order when SalariedFlag set to 'false'. 
Return BusinessEntityID, SalariedFlag columns.

Sample table: HumanResources.Employee
*/


SELECT
	BusinessEntityID
	,SalariedFlag
FROM AdventureWorks2022.HumanResources.Employee
ORDER BY 
	CASE WHEN SalariedFlag = 1 THEN BusinessEntityID END DESC,
	CASE WHEN SalariedFlag = 0 THEN BusinessEntityID END 


/*
33. From the following table write a query in SQL to set the result in order by the column TerritoryName 
when the column CountryRegionName is equal to 'United States' and by CountryRegionName for all other rows.

Sample table: Sales.vSalesPerson
*/

SELECT
	BusinessEntityID
	,LastName
	,TerritoryName
	,CountryRegionName
FROM AdventureWorks2022.Sales.vSalesPerson
WHERE TerritoryName IS NOT NULL
ORDER BY 
	CASE WHEN CountryRegionName = 'United States' THEN TerritoryName 
	ELSE CountryRegionName END


/*
34. From the following table write a query in SQL to find those persons who lives in a territory 
and the value of salesytd except 0. Return first name, last name,row number as 'Row Number', 'Rank', 'Dense Rank' 
and NTILE as 'Quartile', salesytd and postalcode. Order the output on postalcode column.

Sample table: Sales.SalesPerson
Sample table: Person.Person
Sample table: Person.Address
*/

SELECT
	p.FirstName
	,p.LastName
	,ROW_NUMBER() OVER(ORDER BY ad.PostalCode ) AS RowNumber
	,RANK() OVER(ORDER BY ad.PostalCode) as Rank
	,DENSE_RANK() OVER(ORDER BY ad.PostalCode) as DenseRank
	,sp.SalesYTD
	,ad.PostalCode
FROM AdventureWorks2022.Sales.SalesPerson sp
INNER JOIN AdventureWorks2022.Person.Person p
	ON sp.BusinessEntityID = p.BusinessEntityID	
INNER JOIN AdventureWorks2022.Person.Address ad
	ON ad.AddressID = p.BusinessEntityID
WHERE sp.TerritoryID IS NOT NULL
	AND sp.SalesYTD <> 0


/*
35. From the following table write a query in SQL to skip the first 10 rows from the sorted result set 
and return all remaining rows.

Sample table: HumanResources.Department
*/


SELECT
	DepartmentID
	,Name
	,GroupName
FROM AdventureWorks2022.HumanResources.Department
ORDER BY DepartmentID OFFSET 10 ROWS


/*
36. From the following table write a query in SQL to skip the first 5 rows and 
return the next 5 rows from the sorted result set.

Sample table: HumanResources.Department
*/


SELECT
	DepartmentID
	,Name
	,GroupName
FROM AdventureWorks2022.HumanResources.Department
ORDER BY DepartmentID 
	OFFSET 5 ROWS 
	FETCH NEXT 5 ROWS ONLY


/*
37. From the following table write a query in SQL to list all the products that are Red or Blue in color. 
Return name, color and listprice.Sorts this result by the column listprice.

Sample table: Production.Product
*/


SELECT
	Name
	,Color
	,ListPrice
FROM AdventureWorks2022.Production.Product
WHERE Color IN ('Red', 'Blue')
ORDER BY ListPrice 


/*
38. Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders. 
Additionally, it returns any sales orders that don't have any items mentioned in the Product table 
as well as any products that have sales orders other than those that are listed there. 
Return product name, salesorderid. Sort the result set on product name column.

Sample table: Production.Product
Sample table: Sales.SalesOrderDetail
*/


SELECT
	pr.Name
	,sod.SalesOrderID
FROM AdventureWorks2022.Sales.SalesOrderDetail sod
FULL OUTER JOIN AdventureWorks2022.Production.Product pr
	ON pr.ProductID = sod.ProductID
ORDER BY pr.Name


/*
39. From the following table write a SQL query to retrieve the product name and salesorderid. 
Both ordered and unordered products are included in the result set.

Sample table: Production.Product
Sample table: Sales.SalesOrderDetail
*/

SELECT 
	pr.Name
	,sod.SalesOrderID
FROM AdventureWorks2022.Production.Product pr
LEFT JOIN AdventureWorks2022.Sales.SalesOrderDetail sod
	ON pr.ProductID = sod.ProductID
ORDER BY pr.Name


/*
40. From the following tables write a SQL query to get all product names and sales order IDs. 
Order the result set on product name column.

Sample table: Production.Product
Sample table: Sales.SalesOrderDetail
*/

SELECT
	pr.Name
	,sod.SalesOrderID
FROM AdventureWorks2022.Production.Product pr
INNER JOIN AdventureWorks2022.Sales.SalesOrderDetail sod
	ON pr.ProductID = sod.ProductID
ORDER BY pr.Name


/*
41. From the following tables write a SQL query to retrieve the territory name and BusinessEntityID. 
The result set includes all salespeople, regardless of whether or not they are assigned a territory.

Sample table: Sales.SalesTerritory
Sample table: Sales.SalesPerson
*/


SELECT
	st.Name
	,sp.BusinessEntityID
FROM AdventureWorks2022.Sales.SalesTerritory st
RIGHT OUTER JOIN AdventureWorks2022.Sales.SalesPerson sp
	ON st.TerritoryID = sp.TerritoryID


/*
42. Write a query in SQL to find the employee's full name (firstname and lastname) and city from the following tables. 
Order the result set on lastname then by firstname.

Sample table: Person.Person
Sample table: HumanResources.Employee
Sample table: Person.Address
Sample table: Person.BusinessEntityAddress
*/

SELECT
	CONCAT(p.FirstName, ', ', p.LastName) as FullName
	,ad.City
FROM AdventureWorks2022.Person.Person p
INNER JOIN AdventureWorks2022.HumanResources.Employee e
	ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN AdventureWorks2022.Person.Address ad
	ON ad.AddressID = e.BusinessEntityID
INNER JOIN AdventureWorks2022.Person.BusinessEntityAddress bea
	ON bea.BusinessEntityID = e.BusinessEntityID
ORDER BY p.LastName, p.FirstName


/*
43. Write a SQL query to return the businessentityid,firstname and lastname columns of all persons 
in the person table (derived table) with persontype is 'IN' and the last name is 'Adams'. 
Sort the result set in ascending order on firstname. 
A SELECT statement after the FROM clause is a derived table.

Sample table: Person.Person
*/

SELECT
	BusinessEntityID
	,FirstName
	,LastName
FROM (SELECT * FROM AdventureWorks2022.Person.Person
		WHERE PersonType = 'IN') personDT
WHERE LastName = 'Adams'
ORDER BY FirstName 


/*
44. Create a SQL query to retrieve individuals from the following table with a businessentityid inside 1500, 
a lastname starting with 'Al', and a firstname starting with 'M'.

Sample table: Person.Person
*/


SELECT 
	BusinessEntityID
	,LastName
	,FirstName
FROM AdventureWorks2022.Person.Person
WHERE BusinessEntityID <= 1500
	AND LastName LIKE 'Al%'
	AND FirstName LIKE 'M%'


/*
45. Write a SQL query to find the productid, name, and colour of the items 'Blade', 
'Crown Race' and 'AWC Logo Cap' using a derived table with multiple values.

Sample table: Production.Product
*/

SELECT
	p.ProductID
	,p.Name
	,p.Color
FROM AdventureWorks2022.Production.Product p
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS c(name) 
	ON p.name = c.name


/*
46. Create a SQL query to display the total number of sales orders each sales representative receives annually. 
Sort the result set by SalesPersonID and then by the date component of the orderdate in ascending order. 
Return the year component of the OrderDate, SalesPersonID, and SalesOrderID.

Sample table: Sales.SalesOrderHeader
*/

SELECT
	SalesPersonID
	,COUNT(SalesOrderID) SalesQty
	,YEAR(OrderDate) SalesYear
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY 
	SalesPersonID
	,YEAR(OrderDate)
ORDER BY 
	SalesPersonID
	,YEAR(OrderDate)


/*
47. From the following table write a query in SQL to find the average number of sales orders for 
all the years of the sales representatives.

Sample table: Sales.SalesOrderHeader
*/

WITH Sales
AS
(SELECT
	SalesPersonID
	,COUNT(*) AS Orders
FROM AdventureWorks2022.Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID
)
SELECT
AVG(Orders)
FROM Sales


/*
48. Write a SQL query on the following table to retrieve records with the characters green_ in the LargePhotoFileName field. 
The following table's columns must all be returned.

Sample table: Production.ProductPhoto
*/


SELECT
	*
FROM AdventureWorks2022.Production.ProductPhoto
WHERE LargePhotoFileName LIKE '%green_%'


/*
49. Write a SQL query to retrieve the mailing address for any company that is outside the United States (US) 
and in a city whose name starts with Pa. 
Return Addressline1, Addressline2, city, postalcode, countryregioncode columns.

Sample table: Person.Address
Sample table: Person.StateProvince
*/

SELECT
	ad.AddressLine1
	,ad.AddressLine2
	,ad.City
	,ad.PostalCode
	,sp.StateProvinceCode
	,sp.CountryRegionCode
FROM AdventureWorks2022.Person.Address ad
INNER JOIN AdventureWorks2022.Person.StateProvince sp
	ON ad.StateProvinceID = sp.StateProvinceID
WHERE sp.CountryRegionCode <> 'US'
	AND ad.City LIKE 'Pa%'


/*
50. From the following table write a query in SQL to fetch first twenty rows. Return jobtitle, hiredate. 
Order the result set on hiredate column in descending order.

Sample table: HumanResources.Employee
*/

SELECT TOP 20
	JobTitle
	,HireDate
FROM AdventureWorks2022.HumanResources.Employee
ORDER BY HireDate DESC