-- 1. Εύρεση παραγγελιών με βάση το ID του πελάτη
CREATE PROCEDURE sp_GetCustomerOrders
    @CustID nchar(5) 
AS
BEGIN
    SELECT OrderID, OrderDate, ShipCity
    FROM Orders
    WHERE CustomerID = @CustID;
END;
GO

-- 2. Εμφάνιση προϊόντων συγκεκριμένης κατηγορίας
CREATE PROCEDURE sp_ProductsByCategory
    @CatID int
AS
BEGIN
    SELECT P.ProductName, P.UnitPrice
    FROM Products AS P
    WHERE P.CategoryID = @CatID;
END;
GO

-- 3. Λίστα υπαλλήλων που μένουν σε μια συγκεκριμένη χώρα
CREATE PROCEDURE sp_EmployeesByCountry
    @Country nvarchar(15)
AS
BEGIN
    SELECT E.FirstName, E.LastName, E.City
    FROM Employees AS E
    WHERE E.Country = @Country;
END;
GO

-- 4. Παραγγελίες με μεταφορικά ίσα ή μεγαλύτερα από ένα ποσό
CREATE PROCEDURE sp_HighFreightOrders
    @MinFreight money
AS
BEGIN
    SELECT OrderID, CustomerID, Freight
    FROM Orders
    WHERE Freight >= @MinFreight;
END;
GO

-- 5. Αναζήτηση προϊόντων ανάμεσα σε ελάχιστη και μέγιστη τιμή
CREATE PROCEDURE sp_ProductsInPriceRange
    @MinPrice money, 
    @MaxPrice money
AS
BEGIN
    SELECT P.ProductName 
    FROM Products AS P 
    WHERE P.UnitPrice BETWEEN @MinPrice AND @MaxPrice;
END;
GO

-- 6. Υπολογισμός συνολικού τζίρου για μία παραγγελία
CREATE PROCEDURE sp_GetOrderTotal
    @OrdID int
AS
BEGIN
    SELECT SUM(UnitPrice * Quantity) AS MaxMoney
    FROM [Order Details]
    WHERE OrderID = @OrdID;
END;
GO

-- 7. Ενημέρωση της τιμής ενός προϊόντος (UPDATE)
CREATE PROCEDURE sp_UpdateProductPrice
    @ProdID int, 
    @NewPrice money
AS
BEGIN
    UPDATE Products 
    SET UnitPrice = @NewPrice 
    WHERE ProductID = @ProdID;
END;
GO
