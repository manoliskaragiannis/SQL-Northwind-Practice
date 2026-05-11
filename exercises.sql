/* NORTHWIND DATABASE - SQL PRACTICE EXERCISES
   Συλλογή ερωτημάτων για την εξάσκηση σε T-SQL
*/

-- 1. Σύνδεση Προϊόντων με Κατηγορίες (Χρήση LEFT JOIN)
-- Εμφανίζει το όνομα του προϊόντος και την κατηγορία στην οποία ανήκει.
SELECT P.ProductID, P.ProductName, C.CategoryID
FROM Products AS P
LEFT JOIN Categories AS C ON P.CategoryID = C.CategoryID;

-- 2. Φιλτράρισμα Υπαλλήλων (WHERE Clause)
-- Αναζήτηση υπαλλήλων με συγκεκριμένο τίτλο εργασίας.
SELECT E.LastName, E.FirstName, E.City
FROM Employees AS E
WHERE E.Title = 'Sales Representative';

-- 3. Εύρεση των 5 Πιο Ακριβών Προϊόντων (TOP & ORDER BY)
-- Χρήση ταξινόμησης σε φθίνουσα σειρά για τον εντοπισμό των "Premium" ειδών.
SELECT TOP 5 P.ProductName, P.UnitPrice 
FROM Products AS P 
ORDER BY P.UnitPrice DESC;

-- 4. Σύνδεση Παραγγελιών με Μεταφορικές Εταιρείες
-- Σημαντικό: Σύνδεση μέσω του κλειδιού ShipVia (Orders) -> ShipperID (Shippers).
SELECT O.OrderID, S.CompanyName
FROM Orders AS O
LEFT JOIN Shippers AS S ON O.ShipVia = S.ShipperID;

-- 5. Καταμέτρηση Πελατών ανά Χώρα (Aggregates)
-- Ομαδοποίηση δεδομένων για στατιστική ανάλυση της γεωγραφικής κατανομής.
SELECT Country, COUNT(CustomerID) AS TotalCustomers
FROM Customers
GROUP BY Country
ORDER BY TotalCustomers DESC;

-- 6. Πλήθος Προϊόντων ανά Όνομα Κατηγορίας
-- Συνδυασμός JOIN και GROUP BY για πιο αναγνώσιμα αποτελέσματα.
SELECT C.CategoryName, COUNT(P.ProductID) AS TotalProducts
FROM Products AS P
LEFT JOIN Categories AS C ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryName;

-- 7. Συνολικά Έξοδα Μεταφορικών ανά Πελάτη
-- Χρήση της SUM για τον υπολογισμό του συνολικού κόστους (Business Intelligence).
SELECT C.CompanyName, SUM(O.Freight) AS TotalSpent
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
GROUP BY C.CompanyName
ORDER BY TotalSpent DESC;

-- 8. Υπολογισμός Συνολικής Αξίας ανά Παραγγελία (Fixed)
-- Πολλαπλασιασμός Τιμής x Ποσότητα και ομαδοποίηση ανά κωδικό παραγγελίας.
SELECT O.OrderID, SUM(O.UnitPrice * O.Quantity) AS TotalOrderValue
FROM [Order Details] AS O
GROUP BY O.OrderID;

-- 9. Χρήση Subquery (Εμφωλευμένο Ερώτημα)
-- Εύρεση παραγγελιών για συγκεκριμένο πελάτη χωρίς τη χρήση JOIN.
SELECT O.OrderID 
FROM Orders AS O
WHERE O.CustomerID = (
    SELECT C.CustomerID
    FROM Customers AS C
    WHERE C.CompanyName = 'Vins et alcools Chevalier'
);

-- 10. Κατηγοριοποίηση Αποθέματος (CASE Statement)
-- Μετατροπή αριθμητικών δεδομένων σε λεκτικές καταστάσεις (Logic in SQL).
SELECT P.ProductName, P.UnitPrice,
CASE 
    WHEN P.UnitsInStock = 0 THEN 'Out Of Stock'
    WHEN P.UnitsInStock > 0 AND P.UnitsInStock < 11 THEN 'Low Stock'
    ELSE 'Available'
END AS StockStatus
FROM Products AS P;
