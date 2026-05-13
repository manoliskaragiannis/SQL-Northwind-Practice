CREATE TABLE ProductReviews (
    ReviewID int IDENTITY(1,1) PRIMARY KEY, 
    ProductID int NOT NULL,                 
    CustomerName varchar(100) NOT NULL,      
    Rating int NOT NULL,                     
    Comments text,                           
    ReviewDate datetime DEFAULT GETDATE(),   

    CONSTRAINT FK_ProductExists FOREIGN KEY (ProductID) 
        REFERENCES Products(ProductID),

    CONSTRAINT CHK_RatingRange CHECK (Rating >= 1 AND Rating <= 5)
);
