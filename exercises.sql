SELECT P.ProductID, P.ProductName, C.CategoryID
FROM PRODUCTS AS P
LEFT JOIN CATEGORIES AS C ON P.CategoryID = C.CategoryID;

SELECT E.LastName, E.FirstName, E.City
FROM Employees AS E
WHERE E.Title = 'Sales Representative' ;

SELECT TOP 5 P.ProductName, P.UnitPrice 
FROM Products As P 
ORDER BY P.UnitPrice DESC;

SELECT O.OrderID , S.CompanyName
FROM Orders AS O
LEFT JOIN Shippers AS S ON O.ShipVia = S.ShipperID;

SELECT Country, COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country
ORDER BY TotalCustomers DESC;

SELECT C.CategoryName , COUNT(P.ProductID) AS TotalProducts
FROM Products AS P
LEFT JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY CategoryName;

SELECT C.CompanyName, SUM(O.Freight) AS TotalSpent
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
ORDER BY TotalSpent DESC;

SELECT O.OrderID , SUM(O.UnitPrice * O.Quantity) AS PAOK
FROM [Order Details] AS O


SELECT P.ProductName , SUM(O.UnitPrice * O.Quantity) AS MONEY
FROM Products AS P 
LEFT JOIN [Order Details] AS O
	ON P.ProductID = O.ProductID
GROUP BY P.ProductName
ORDER BY MONEY DESC;

SELECT OrderID , OrderDate
FROM Orders
WHERE OrderDate > '1998-06-01'
ORDER BY OrderDate;












