CREATE TABLE ProductReviews (
    ReviewID int IDENTITY(1,1) PRIMARY KEY, 
    ProductID int NOT NULL,                 
    CustomerName varchar(100) NOT NULL,      
    Rating int NOT NULL,                     
    Comments text,                           
    ReviewDate datetime DEFAULT GETDATE(),   

    CONSTRAINT FK_ProductExists FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID),

    CONSTRAINT CHK_RatingRange CHECK (Rating >= 1 AND Rating <= 5),
    CONSTRAINT CHK_NameCheck CHECK (CustomerName IS NOT NULL AND 
                                      LEN(CustomerName) >2
                                   )
);

ALTER TABLE Products
ADD CONSTRAINT CHK_NoUnitPriceUnderZero CHECK (UnitPrice > -1);

--ΠΕΛΑΤΕΣ ΣΤΗΝ ΓΕΡΜΑΝΙΑ

SELECT CustomerID
FROM Customers
WHERE Country = 'Germany';

-- ΤΟΠ 10 ΦΘΗΝΑ ΠΡΟΙΟΝΤΑ

SELECT TOP 10 ProductName
FROM Products
ORDER BY UnitPrice ASC;

--ΟΝΟΜΑ ΠΡΟΙΟΝΤΟΣ ΚΑΙ ΕΤΑΙΡΕΙΑΣ ΤΟΥ ΠΡΟΜΗΘΕΥΤΗ ΓΙΑ ΚΑΘΕ ΠΡΟΙΟΝ
SELECT P.ProductName, S.CompanyName 
FROM Suppliers AS S
LEFT JOIN Products AS P
    ON S.SupplierID = P.SupplierID;


-- ΠΟΣΑ ΠΡΟΙΟΝΤΑ ΕΧΕΙ ΚΑΘΕ ΕΤΑΙΡΕΙΑ
SELECT COUNT(P.ProductID) AS NumberOfProducts, C.CategoryID
FROM Products AS P 
LEFT JOIN Categories AS C 
    ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryID;


--ΟΝΟΜΑ ΠΡΟΙΟΝΤΩΝ ΚΑΙ ΚΑΤΗΓΟΡΙΑ
SELECT C.CategoryName,COUNT(P.ProductID) AS NumberOfProducts
FROM Categories AS C
LEFT JOIN Products AS P
    ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName;


--ΠΡΟΙΟΝΤΑ ΜΕ ΤΙΜΗ ΜΕΓΑΛΥΤΕΡΡΗ ΤΟΥ ΜΕΣΟΥ ΟΡΟΥ
SELECT ProductName
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice)
                   FROM Products);


--ΟΝΟΜΑ ΠΡΟΙΟΝΤΟΣ ΚΑΙ ΤΙΜΗ ΚΑΘΕ ΤΟΥ ΜΕ ΕΜΦΑΝΙΣΗ ΜΥΝΗΜΑΤΟΣ
SELECT P.ProductName,
CASE
    WHEN P.UnitPrice < 20 THEN 'CHEAP'
    WHEN P.UnitPrice >20 AND P.UnitPrice <51 THEN 'Normal'
    ELSE 'Expensive'
END AS PriceCategory
FROM Products AS P

--ΟΨΗ ΜΕ ΥΠΑΛΛΗΛΟΥΣ ΠΟΥ ΜΕΝΟΥΝ USA
GO
CREATE VIEW vw_US_Employees AS
SELECT 
    E.FirstName,
    E.LastName,
    E.Title
FROM Employees AS E
WHERE E.Country = 'USA';
GO

SELECT O.OrderID, C.CompanyName, E.FirstName
FROM Customers AS C
LEFT JOIN Orders AS O 
    ON C.CustomerID = O.CustomerID
    LEFT JOIN Employees AS E
        ON O.EmployeeID = E.EmployeeID;

        
    






