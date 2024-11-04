CREATE DATABASE CDMA
USE CDMA

CREATE TABLE customers (
    customer_id INT PRIMARY KEY NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    gender VARCHAR(10) NOT NULL
);
CREATE TABLE products (
    product_id INT PRIMARY KEY ,
    product_category VARCHAR(255) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE payment_methods (
    payment_method_id INT PRIMARY KEY ,
    payment_method VARCHAR(50) NOT NULL
);
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY ,
    customer_id INT NOT NULL,
	product_id INT NOT NULL,
    product_category VARCHAR(255) NOT NULL,        
    purchase_date DATE NOT NULL,
    quantity INT NOT NULL,
    total_purchase_amount DECIMAL(10, 2) NOT NULL,
    payment_method_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
);
CREATE TABLE customer_churn (
    customer_id INT PRIMARY KEY NOT NULL,
	churn_status INT DEFAULT 0  -- 0 for false, 1 for true,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

BULK INSERT customers
FROM 'D:\Data Engineering\Project\customers.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- if you have headers
);
BULK INSERT products
FROM 'D:\Data Engineering\Project\products.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- if you have headers
);
BULK INSERT payment_methods
FROM 'D:\Data Engineering\Project\payment_methods.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- if you have headers
);
BULK INSERT customer_churn
FROM 'D:\Data Engineering\Project\customer_churn.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- if you have headers
);
BULK INSERT purchases
FROM 'D:\Data Engineering\Project\purchases.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',
    FIRSTROW = 2  -- if you have headers
);

--extract
SELECT * FROM customers

SELECT customer_name, age FROM customers

SELECT p.purchase_id, p.purchase_date, p.total_purchase_amount
FROM purchases p
JOIN customers c ON p.customer_id = c.customer_id
WHERE c.customer_name = 'Dominic Cline'

--purchase and quantity for each customer
SELECT c.customer_name, SUM(p.total_purchase_amount) AS total_spent, SUM(p.quantity) AS total_items
FROM customers c
JOIN purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_name;

--update the product price
UPDATE products
SET product_price = product_price * 1.1  
WHERE product_category = 'Clothing';

-- analyse Count of Customers by Gender
SELECT gender, COUNT(*) AS total_customers
FROM customers
GROUP BY gender;

--Average Purchase Amount by Customer
SELECT c.customer_name, AVG(p.total_purchase_amount) AS average_purchase
FROM customers c
JOIN purchases p ON c.customer_id = p.customer_id
GROUP BY c.customer_name;

--############################################################################--
--############################################################################--

CREATE DATABASE CDMAWarehouse
USE CDMAWarehouse

CREATE TABLE dim_Customer (
    customer_id INT PRIMARY KEY NOT NULL,
    customer_name VARCHAR(255) ,
    age INT ,
    gender VARCHAR(10)
);
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY NOT NULL,
    product_category VARCHAR(255) NOT NULL,
    product_price DECIMAL(10, 2) NOT NULL
);
CREATE TABLE dim_payment_method (
    payment_method_id INT PRIMARY KEY NOT NULL,
    payment_method VARCHAR(50) NOT NULL
);
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day INT NOT NULL,
    month INT NOT NULL,
    year INT NOT NULL,
    quarter INT NOT NULL
);
CREATE TABLE FactPurchases (
    purchase_id INT PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
	product_category INT NOT NULL,
    payment_method_id INT NOT NULL,
    total_purchase_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (payment_method_id) REFERENCES dim_payment_method(payment_method_id)
);

