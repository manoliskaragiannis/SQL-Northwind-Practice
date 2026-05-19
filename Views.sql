CREATE VIEW vw_OrderDetailsExtended AS
SELECT 
    OD.OrderID, 
    P.ProductName, 
    OD.UnitPrice, 
    OD.Quantity,
    (OD.UnitPrice * OD.Quantity) AS ExtendedPrice
FROM [Order Details] AS OD
JOIN Products AS P ON OD.ProductID = P.ProductID;


CREATE VIEW vw_EmployeeAges AS 
SELECT 
    E.FirstName,
    E.LastName,
    YEAR(E.BirthDate) AS BirthYear
FROM Employees AS E;


SELECT * FROM vw_EmployeeAges
ORDER BY BirthYear ASC;

CREATE VIEW vw_LowStockAlert AS
SELECT 
    P.ProductName, 
    S.CompanyName AS Supplier, 
    P.UnitsInStock, 
    P.ReorderLevel
FROM Products AS P
JOIN Suppliers AS S ON P.SupplierID = S.SupplierID
WHERE P.UnitsInStock <= P.ReorderLevel;
CREATE VIEW vw_ProductDetails AS
SELECT 
    P.ProductID, 
    P.ProductName, 
    C.CategoryName,
    S.CompanyName AS SupplierName
FROM Products AS P
JOIN Categories AS C ON P.CategoryID = C.CategoryID
JOIN Suppliers AS S ON P.SupplierID = S.SupplierID;
GO

CREATE VIEW cw_CustomerOrders AS
SELECT
    C.CustomerID,
    C.CompanyName,
    O.OrderID
    FROM Customers AS C
    JOIN Orders AS O ON C.CustomerID = O.CustomerID
GO

CREATE VIEW vw_UrgentOrders AS
SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    RequiredDate,
    ShippedDate
FROM Orders
WHERE  ShippedDate IS NULL AND RequiredDate < '1997-09-30'
GO
