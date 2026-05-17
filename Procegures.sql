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


CREATE PROCEDURE sp_CheckStockBeforeOrder
    @ProdID int , @RequiredQty int
AS
BEGIN
    IF @RequiredQty <= (SELECT UnitsInStock
                        FROM Products
                        WHERE ProductID = @ProdID)
        BEGIN
            SELECT 'Order Approved' AS Status;     
        END;
    ELSE
        BEGIN
            SELECT 'Inadequate Stock' AS Status;
        END;
END;
GO

CREATE PROCEDURE sp_GetCustomerStats
    @CustID nchar(5) , @TotalOrders int OUTPUT
AS
BEGIN
    SELECT @TotalOrders = COUNT(OrderID)
                          FROM Orders
                          WHERE CustomerID = @CustID
END;
GO

CREATE PROCEDURE sp_SearchProducts
    @CatID int = NULL,       
    @SuppID int = NULL       
AS
BEGIN
    SELECT P.ProductName, P.CategoryID, P.SupplierID
    FROM Products AS P
    WHERE 
        (P.CategoryID = @CatID OR @CatID IS NULL)
        AND 
        (P.SupplierID = @SuppID OR @SuppID IS NULL);
END;
GO

CREATE PROCEDURE sp_SafeDeleteProduct
    @ProdID int
AS
BEGIN
    IF EXISTS (SELECT 1 FROM [Order Details] WHERE ProductID = @ProdID)
    BEGIN
        SELECT 'Cannot delete. Product has active orders'
    END
    ELSE
        BEGIN 
            DELETE FROM Products WHERE ProductID = @ProdID
            SELECT 'Product deleted successfully'
        END;

END;

GO
CREATE PROCEDURE sp_AddEmployeeWithManagerCheck
    @FirstName nvarchar(10), @LastName nvarchar(20), @ManagerID int
AS
BEGIN
    IF EXISTS(SELECT 1 FROM Employees WHERE EmployeeID = @ManagerID)
    BEGIN
        INSERT INTO Employees (FirstName,LastName,ReportsTo)
                    VALUES (@FirstName,@LastName,@ManagerID);
        SELECT 'Employee added successfully' AS Mesage
    END
    ELSE
    BEGIN
        SELECT 'Error: Manager ID does not exist' AS ErrorMessage 
    END
END

GO

CREATE PROCEDURE sp_ApplyCategoryDiscount
    @CatID int, 
    @DiscountPercentage decimal(4,2)
AS
BEGIN    
    UPDATE Products
    SET UnitPrice = UnitPrice * (1 - @DiscountPercentage)
    WHERE CategoryID = @CatID AND UnitsInStock > 50;

END;
GO



CREATE PROCEDURE sp_GetOrderShippingTime
    @OrdID int , @DaysToShip int OUTPUT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Orders WHERE ShippedDate IS NOT NULL AND OrderID = @OrdID)
        BEGIN
            SELECT @DaysToShip = DATEDIFF(day, OrderDate, ShippedDate)
            FROM Orders
            WHERE OrderID = @OrdID;
        END
    ELSE
        BEGIN
            SET @DaysToShip = -1;
        END
  END

GO
CREATE PROCEDURE sp_InsertUniqueSupplier
    @CompanysName nvarchar(40), @CompCountry nvarchar(20)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Suppliers WHERE CompanyName = @CompanysName AND Country = @CompCountry)
        BEGIN
            SELECT 'The Company Already exists' AS Message
        END
        ELSE
        BEGIN
            INSERT INTO Suppliers (CompanyName,Country) 
            VALUES (@CompanysName,@CompCountry)
            SELECT 'The company has been addded to the Data Base' AS message
        END
END

GO
-- 5. Αξιολόγηση Πελάτη βάσει του συνολικού του τζίρου
CREATE PROCEDURE sp_EvaluateCustomerStatus
    @CustID nchar(5)
AS
BEGIN
    DECLARE @TotalRevenue money;
    SELECT @TotalRevenue = SUM(OD.UnitPrice * OD.Quantity)
    FROM Orders AS O
    JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
    WHERE O.CustomerID = @CustID;
    SET @TotalRevenue = ISNULL(@TotalRevenue, 0);
    IF @TotalRevenue > 50000
    BEGIN
        SELECT 'VIP Customer' AS CustomerStatus, @TotalRevenue AS TotalSpent;
    END
    ELSE IF @TotalRevenue >= 10000 AND @TotalRevenue <= 50000
    BEGIN
        SELECT 'Regular Customer' AS CustomerStatus, @TotalRevenue AS TotalSpent;
    END
    ELSE
    BEGIN
        SELECT 'Low Volume Customer' AS CustomerStatus, @TotalRevenue AS TotalSpent;
    END
END;
GO     
            
            







