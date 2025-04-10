
create database TechShop3;
use TechShop3;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2)
);


CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE,
    OrderStatus VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)

);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    QuantityInStock INT,
    LastStockUpdate DATE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);


INSERT INTO Customer (CustomerName, Email, Phone, Address) VALUES
('giraha', 'giraha@example.com', '1234567890', 'cuddalore'),
('roki', 'roki@example.com', '9876543210', 'Puducherry'),
('maha', 'maha@example.com', '1112233445', 'Mahe'),
('David Kim', 'david@example.com', '2223334444', 'Karaikal'),
('harni', 'harini@example.com', '3334445555', 'Puducherry'),
('pope', 'pope@example.com', '4445556666', 'cuddalore'),
('arthi', 'arthi@example.com', '5556667777', 'Puducherry'),
('Henry Adams', 'henry@example.com', '6667778888', 'Mahe'),
('Ivy Clark', 'ivy@example.com', '7778889999', 'Mahe'),
('Jack White', 'jack@example.com', '8889990000', 'Puducherry');

INSERT INTO Product (ProductName, Category, Price) VALUES
('Smartphone', 'Electronics', 699.99),
('Laptop', 'Electronics', 999.99),
('Smartwatch', 'Electronics', 199.99),
('Tablet', 'Electronics', 399.99),
('Bluetooth Speaker', 'Electronics', 49.99),
('Headphones', 'Electronics', 89.99),
('Monitor', 'Electronics', 159.99),
('Keyboard', 'Electronics', 39.99),
('Mouse', 'Electronics', 29.99),
('Webcam', 'Electronics', 59.99);


INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) VALUES
(1, '2024-03-01', 'Pending'),
(2, '2024-03-02', 'Shipped'),
(3, '2024-03-03', 'Delivered'),
(4, '2024-03-04', 'Pending'),
(5, '2024-03-05', 'Shipped'),
(6, '2024-03-06', 'Delivered'),
(7, '2024-03-07', 'Pending'),
(8, '2024-03-08', 'Shipped'),
(9, '2024-03-09', 'Delivered'),
(10, '2024-03-10', 'Pending');


INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(2, 1, 1),
(2, 2, 2),
(3, 3, 1),
(4, 4, 3),
(5, 5, 2),
(6, 6, 1),
(7, 7, 2),
(8, 8, 1),
(9, 9, 3),
(10, 10, 1);

INSERT INTO Inventory (ProductID, QuantityInStock, LastStockUpdate) VALUES
(1, 50, '2024-04-01'),
(2, 30, '2024-04-01'),
(3, 40, '2024-04-01'),
(4, 25, '2024-04-01'),
(5, 60, '2024-04-01'),
(6, 35, '2024-04-01'),
(7, 45, '2024-04-01'),
(8, 55, '2024-04-01'),
(9, 20, '2024-04-01'),
(10, 70, '2024-04-01');

-- 1. Retrieve the names and emails of all customers

SELECT CustomerName, Email FROM Customer;

-- 2. List all orders with their order dates and corresponding customer names

SELECT o.OrderID, o.OrderDate, c.CustomerName
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID;

-- 3. Insert a new customer record

INSERT INTO Customer (CustomerName, Email, Phone, Address)
VALUES ('Rahul Kumar', 'rahul.kumar@example.com', '9998887777', 'Chennai');

-- 4. Update prices by 10%

UPDATE Product
SET Price = Price * 1.10;

-- 5. Delete a specific order and its order details

DECLARE @OrderID INT = 1;

DELETE FROM OrderDetails WHERE OrderID = @OrderID;
DELETE FROM Orders WHERE OrderID = @OrderID;


-- 6. Insert a new order

INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
VALUES (1, GETDATE(), 'Pending');

-- 7. Update customer contact info 

DECLARE @CustomerID INT = 1;
DECLARE @NewEmail VARCHAR(100) = 'giraha13@gmail.com';
DECLARE @NewAddress varchar(max) = 'Bangalore';

UPDATE Customer
SET Email = @NewEmail, Address = @NewAddress
WHERE CustomerID = @CustomerID;

select * from customer;

-- 8. Recalculate and update total cost of each order

ALTER TABLE Orders ADD TotalAmount DECIMAL(10,2) DEFAULT 0;

UPDATE Orders
SET TotalAmount = (
    SELECT SUM(p.Price * od.Quantity)
    FROM OrderDetails od
    JOIN Product p ON od.ProductID = p.ProductID
    WHERE od.OrderID = Orders.OrderID
);

select * from orders;

-- 9. Delete all orders and order details for a specific customer

BEGIN TRANSACTION;

DECLARE @CustID INT = 1;

DELETE FROM OrderDetails 
WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = @CustID);

DELETE FROM Orders 
WHERE CustomerID = @CustID;

SELECT * FROM Orders WHERE CustomerID = @CustID;
SELECT * FROM OrderDetails WHERE OrderID IN (SELECT OrderID FROM Orders WHERE CustomerID = @CustID);


ROLLBACK;

-- 10. Insert a new electronic gadget product

INSERT INTO Product (ProductName, Category, Price)
VALUES ('Wireless Earbuds', 'Electronics', 129.99);

-- 11. Update order status

BEGIN TRANSACTION;

DECLARE @UpdateOrderID INT = 2;
DECLARE @NewStatus VARCHAR(50) = 'Delivered';

UPDATE Orders
SET OrderStatus = @NewStatus
WHERE OrderID = @UpdateOrderID;

SELECT * FROM Orders WHERE OrderID = @UpdateOrderID;

ROLLBACK;

-- 12. Calculate and update number of orders placed by each customer

ALTER TABLE Customer ADD OrderCount INT DEFAULT 0;

UPDATE Customer
SET OrderCount = (
    SELECT COUNT(*) FROM Orders o WHERE o.CustomerID = Customer.CustomerID
);




------------------------TASK 3-------------


-------------1. Write an SQL query to retrieve a list of all orders along with customer information (e.g., customer name) for each order. 

SELECT o.OrderID, o.OrderDate, c.CustomerName, c.Email, c.Phone, c.Address
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID;

---------------2. Write an SQL query to find the total revenue generated by each electronic gadget product. Include the product name and the total revenue.


SELECT p.ProductName, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM OrderDetails od
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC;

----------------3.Write an SQL query to list all customers who have made at least one purchase. Include their names and contact information.

SELECT DISTINCT 
    c.CustomerID, 
    c.CustomerName, 
    c.Email, 
    c.Phone, 
    CAST(c.Address AS VARCHAR(MAX)) AS Address
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID;

----------------4. Write an SQL query to find the most popular electronic gadget, which is the one with the highest total quantity ordered. Include the product name and the total quantity ordered. 

SELECT TOP 1 p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalQuantityOrdered DESC;

---------------5. Write an SQL query to retrieve a list of electronic gadgets along with their corresponding categories. 

SELECT ProductName, Category
FROM Product;

---------------6. Write an SQL query to calculate the average order value for each customer. Include the customer's name and their average order value. 

SELECT c.CustomerID, c.CustomerName, AVG(od.Quantity * p.Price) AS AverageOrderValue
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY AverageOrderValue DESC;

--------------7. Write an SQL query to find the order with the highest total revenue. Include the order ID, customer information, and the total revenue. 

SELECT TOP 1 o.OrderID, c.CustomerName, c.Email, c.Phone, c.Address, SUM(od.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY o.OrderID, c.CustomerName, c.Email, c.Phone, c.Address
ORDER BY TotalRevenue DESC;

------------------8. Write an SQL query to list electronic gadgets and the number of times each product has been ordered. 

SELECT p.ProductName, COUNT(od.OrderID) AS TimesOrdered
FROM OrderDetails od
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TimesOrdered DESC;

-------------9.Write an SQL query to find customers who have purchased a specific electronic gadget product. 

DECLARE @ProductName VARCHAR(100) = 'Smartphone'; 

SELECT DISTINCT c.CustomerID, c.CustomerName, c.Email, c.Phone, c.Address
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
WHERE p.ProductName = @ProductName;

-----------10. Write an SQL query to calculate the total revenue generated by all orders placed within a specific time period.

DECLARE @StartDate DATE = '2024-01-01';
DECLARE @EndDate DATE = '2024-12-31';

SELECT SUM(od.Quantity * p.Price) AS TotalRevenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN @StartDate AND @EndDate;

-------------Task 4. Subquery and its type

----------------1. Write an SQL query to find out which customers have not placed any orders. 

SELECT CustomerID, CustomerName
FROM Customer
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID FROM Orders

);

-------------2.Write an SQL query to find the total number of products available for sale. 

SELECT p.ProductID, p.ProductName, i.QuantityInStock
FROM Product p
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE i.QuantityInStock > 0;


---------------3.Write an SQL query to calculate the total revenue generated by TechShop  

SELECT SUM(TotalAmount) AS TotalRevenue
FROM (
    SELECT od.Quantity * p.Price AS TotalAmount
    FROM OrderDetails od
    JOIN Product p ON od.ProductID = p.ProductID
) AS RevenueSub;

-------------------4. Write an SQL query to calculate the average quantity ordered for products in a specific category. Allow users to input the category name as a parameter.

SELECT AVG(od.Quantity) AS AverageQuantityOrdered
FROM OrderDetails od
JOIN Product p ON od.ProductID = p.ProductID
WHERE p.Category = 'Electronics'; 

-----------------5.. Write an SQL query to calculate the total revenue generated by a specific customer. Allow users to input the customer ID as a parameter. 

DECLARE @CustomerID INT = 4; 


SELECT 
    c.CustomerID,
    c.CustomerName,
    (
        SELECT SUM(od.Quantity * p.Price)
        FROM Orders o
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        JOIN Product p ON od.ProductID = p.ProductID
        WHERE o.CustomerID = c.CustomerID
    ) AS TotalRevenue
FROM Customer c
WHERE c.CustomerID = @CustomerID;

---------------6. Write an SQL query to find the customers who have placed the most orders. List their names and the number of orders they've placed

SELECT c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) = (
    SELECT MAX(OrderCount)
    FROM (
        SELECT COUNT(OrderID) AS OrderCount
        FROM Orders
        GROUP BY CustomerID
    ) AS Sub
);


---------------7. Write an SQL query to find the most popular product category, which is the one with the highest total quantity ordered across all orders. 

SELECT p.Category, SUM(od.Quantity) AS TotalQuantityOrdered
FROM OrderDetails od
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY TotalQuantityOrdered DESC;

--------------8. Write an SQL query to find the customer who has spent the most money (highest total revenue) on electronic gadgets. List their name and total spending. 

SELECT c.CustomerName, SUM(od.Quantity * p.Price) AS TotalSpending
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
WHERE p.Category = 'Electronics'
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpending DESC;

----------------9. Write an SQL query to calculate the average order value (total revenue divided by the number of orders) for all customers. 

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * p.Price) / COUNT(DISTINCT o.OrderID) AS AvgOrderValue
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;


----------------10. Write an SQL query to find the total number of orders placed by each customer and list their names along with the order count. 

SELECT c.CustomerName, COUNT(o.OrderID) AS TotalOrders
FROM Customer c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName;
