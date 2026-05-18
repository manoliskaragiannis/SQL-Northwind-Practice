
CREATE TABLE CustomerPhoneLog (
    LogID int IDENTITY(1,1) PRIMARY KEY,
    CustomerID nchar(5),
    OldPhone nvarchar(24),
    NewPhone nvarchar(24),
    ChangeDate datetime DEFAULT GETDATE()
);
CREATE TABLE DeletedShippersLog (
    ShipperID int,
    CompanyName nvarchar(40),
    DeletionDate datetime DEFAULT GETDATE()
);
CREATE TABLE ReorderAlerts (
    AlertID int IDENTITY(1,1) PRIMARY KEY,
    ProductID int,
    CurrentStock int,
    ReorderLevel int,
    AlertDate datetime DEFAULT GETDATE()
);
CREATE TABLE ProductNameLog (
    LogID int IDENTITY(1,1) PRIMARY KEY,
    ProductID int,
    OldName nvarchar(40),
    NewName nvarchar(40),
    ChangeDate datetime DEFAULT GETDATE()
);
GO-- 1. Αυτόματη επιστροφή αποθέματος όταν διαγράφεται μια γραμμή παραγγελίας
CREATE TRIGGER tr_RestoreStockOnDelete
ON [Order Details]
AFTER DELETE
AS
BEGIN

    UPDATE P
    SET P.UnitsInStock = P.UnitsInStock + D.Quantity
    FROM Products AS P
    JOIN deleted AS D ON P.ProductID = D.ProductID;
END;
GO

CREATE TRIGGER tr_LogPriceChanges
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    INSERT INTO ProductPriceLog (ProductID, OldPrice, NewPrice)
    SELECT 
        I.ProductID, 
        D.UnitPrice, 
        I.UnitPrice          
    FROM inserted AS I
    JOIN deleted AS D ON D.ProductID = I.ProductID ; 

END;
GO



GO
CREATE TRIGGER tr_StockDecrease
ON [Order Details] 
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET P.UnitsInStock = P.UnitsInStock - I.Quantity
    FROM Products AS P
    JOIN inserted AS I on I.ProductID = P.ProductID;
END;
GO


CREATE TRIGGER tr_NewPhone
ON Customers
AFTER UPDATE
AS 
BEGIN
    SET NOCOUNT ON;
    INSERT INTO CustomerPhoneLog (CustomerID,OldPhone, NewPhone) 
    SELECT I.CustomerID,d.Phone,I.Phone
    FROM deleted AS d
    JOIN Inserted AS I ON I.CustomerID = d.CustomerID;
END;

GO    

CREATE TRIGGER tr_BlockDateOfAquired
ON Orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE RequiredDate < OrderDate
    )
    BEGIN
      
        RAISERROR ('Λάθος Ημερομηνία! Η απαιτούμενη ημερομηνία δεν μπορεί να είναι πριν την ημερομηνία παραγγελίας.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER tr_StoredDeletes
ON Shippers
AFTER DELETE
AS 
BEGIN 
    INSERT INTO DeletedShippersLog (ShipperID,CompanyName)
    SELECT
        d.ShipperID,
        d.CompanyName
        FROM deleted AS d
      
END;

GO

CREATE TRIGGER tr_AllertLowStock
ON Products
AFTER UPDATE
AS
BEGIN
    IF EXISTS(SELECT 1 FROM inserted AS i WHERE i.UnitsInStock < i.ReorderLevel  )
    BEGIN
        INSERT INTO ReorderAlerts(ProductID,CurrentStock,ReorderLevel)
        SELECT
            
            i.ProductID,
            i.UnitsInStock,
            i.ReorderLevel
            FROM inserted AS i
    END;
END;
GO

CREATE TRIGGER tr_CheckForDiscount
ON [Order Details]
AFTER INSERT
AS
BEGIN 
    IF EXISTS(SELECT 1 FROM inserted WHERE Discount > 0.3)
    BEGIN
        RAISERROR('Η έκπτωση είναι μεγαλύτερη από την επιτρεπτή',16,1)
        ROLLBACK TRANSACTION
    END;
END;
GO

CREATE TRIGGER  tr_NameChangeHistory
ON Products
AFTER UPDATE
AS 
BEGIN
    INSERT INTO ProductNameLog (ProductID,OldName,NewName)
    SELECT
        i.ProductID,
        d.ProductName,
        i.ProductName
        FROM inserted AS i
        JOIN deleted as d ON i.ProductID = d.ProductID
END;









