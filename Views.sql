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
