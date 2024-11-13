CREATE DATABASE OLX_Clone_db
USE OLX_Clone_db

-- USER INFORMATION
CREATE TABLE tbl_user(
id_user INT PRIMARY KEY,
user_username VARCHAR(30),
user_password VARCHAR(20),
user_age INT,
);

alter table tbl_user
drop column user_age;

ALTER TABLE tbl_user
ADD user_age INT CHECK (user_age > 18);

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
WHERE TABLE_NAME = 'tbl_user' AND COLUMN_NAME = 'user_age';

alter table tbl_user
drop constraint CK__tbl_user__user_a__72C60C4A;

alter table tbl_user
drop column user_age;

ALTER TABLE tbl_user
ADD user_age INT  NOT NULL CHECK (user_age > 18);


CREATE TABLE tbl_buyer(
buyer_id INT PRIMARY KEY,
buyer_name VARCHAR(20),
buyer_phone_no BIGINT,
buyer_email VARCHAR(100),
buyer_address VARCHAR(300),
id_user int foreign key references tbl_user(id_user)
);

CREATE TABLE tbl_seller(
seller_id INT PRIMARY KEY,
seller_name VARCHAR(20),
seller_phone_no BIGINT,
seller_email VARCHAR(100),
seller_address VARCHAR(300),
id_user int foreign key references tbl_user(id_user)
);

-- CATEGORY INFROMATION

CREATE TABLE tbl_category(
category_id INT PRIMARY KEY,
category_name VARCHAR(50)
);

CREATE TABLE tbl_car(
car_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
car_name_model VARCHAR(100),
car_price decimal(10,2),
car_description TEXT
);

CREATE TABLE tbl_electronics(
electronics_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
electronics_name_company VARCHAR(100),
electronics_price decimal(10,2),
electronics_description TEXT
);

CREATE TABLE tbl_mobile(
mobile_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
mobile_name_model VARCHAR(100),
mobile_price decimal(10,2),
mobile_description TEXT
);

CREATE TABLE tbl_property(
property_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
property_sqft INT,
property_price decimal(10,2),
property_description TEXT
);

CREATE TABLE tbl_others(
others_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
others_name VARCHAR(100),
others_price decimal(10,2),
others_description TEXT
);

-- DATA STORAGE

CREATE TABLE tbl_data(
data_id INT PRIMARY KEY,
seller_id INT FOREIGN KEY REFERENCES tbl_seller(seller_id),
category_id INT FOREIGN KEY REFERENCES tbl_category(category_id),
buyer_id INT FOREIGN KEY REFERENCES tbl_buyer(buyer_id)
)

alter table tbl_data
add item_id int not null;


-- SELECT STATEMENTS TO SEE THE TABLES

SELECT * FROM tbl_user
SELECT * FROM tbl_buyer
SELECT * FROM tbl_seller
SELECT * FROM tbl_category
SELECT * FROM tbl_others
SELECT * FROM tbl_mobile
SELECT * FROM tbl_electronics
SELECT * FROM tbl_car
SELECT * FROM tbl_property
SELECT * FROM tbl_data


-- Join Query to find the details for buyer and seller
SELECT 
    b.buyer_name AS Buyer_Name,
    b.buyer_phone_no AS Buyer_Phone,
    b.buyer_email AS Buyer_Email,
    b.buyer_address AS Buyer_Address,
    s.seller_name AS Seller_Name,
    s.seller_phone_no AS Seller_Phone,
    s.seller_email AS Seller_Email,
    s.seller_address AS Seller_Address,
    c.category_name AS Category_Purchased,
    d.item_id AS Item_ID
FROM 
    tbl_data d
JOIN 
    tbl_buyer b ON d.buyer_id = b.buyer_id
JOIN 
    tbl_seller s ON d.seller_id = s.seller_id
JOIN 
    tbl_category c ON d.category_id = c.category_id;

-- Selecting the buyer name and email who purchased electrnoics only with subquery

SELECT 
    b.buyer_name,
    b.buyer_email
FROM 
    tbl_buyer b
WHERE 
    b.buyer_id IN (SELECT d.buyer_id 
                   FROM tbl_data d
                   JOIN tbl_category c ON d.category_id = c.category_id
                   WHERE c.category_name = 'Electronics');

-- Selecting the total purchases per buyer
SELECT 
    b.buyer_name,
    COUNT(d.item_id) AS Total_Purchases
FROM 
    tbl_data d
JOIN 
    tbl_buyer b ON d.buyer_id = b.buyer_id
GROUP BY
    b.buyer_name
--ORDER BY 
--	Total_Purchases desc ;

-- Seller who sold the most items 
SELECT 
    s.seller_name,
    COUNT(d.item_id) AS total_items_sold
FROM 
    tbl_data d
JOIN 
    tbl_seller s ON d.seller_id = s.seller_id
GROUP BY 
    s.seller_name
ORDER BY 
    total_items_sold DESC;


-- Items Sold in Each Category
SELECT 
    c.category_name,
    COUNT(d.item_id) AS items_sold
FROM 
    tbl_data d
JOIN 
    tbl_category c ON d.category_id = c.category_id
GROUP BY 
    c.category_name;
