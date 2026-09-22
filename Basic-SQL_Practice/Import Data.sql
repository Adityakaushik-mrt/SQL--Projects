drop table if exists customers ;

CREATE table if not exists customers (
customer_id	INTEGER PRIMARY KEY,
customer_name	VARCHAR(15),
gender	VARCHAR(10),
city	VARCHAR(15),
registration_date	DATE,
customer_type VARCHAR(15));

copy customers(customer_id,customer_name,gender,city,registration_date,customer_type)
from 'F:\Adi Complete Project\ProjectS\SQL Project\Adi sql\sql_practice_dataset\customers.csv'
delimiter','
header csv;
-----------

drop table if exists products ;
CREATE table if not exists products (
product_id	INTEGER PRIMARY KEY,
product_name	VARCHAR(20),
category	VARCHAR(15),
subcategory	VARCHAR(15),
unit_price	NUMERIC(10,2),
stock_qty INTEGER);

copy products(product_id,product_name,category,subcategory,unit_price,stock_qty)
from 'F:\Adi Complete Project\ProjectS\SQL Project\Adi sql\sql_practice_dataset\products.csv'
delimiter','
header csv;
-------------------
drop table if exists orders ;
CREATE table if not exists orders (
order_id	NTEGER PRIMARY KEY,
customer_id	INTEGER REFERENCES "customers"(customer_id) on DELETE CASCADE,
order_date	DATE,
ship_city	VARCHAR(15),
status	VARCHAR(15),
sales_channel VARCHAR(15));

copy orders(order_id,customer_id,order_date,ship_city,status,sales_channel)
from 'F:\Adi Complete Project\ProjectS\SQL Project\Adi sql\sql_practice_dataset\orders.csv'
delimiter','
header csv;

----------------------------
drop table if exists order_items ;

CREATE table if not exists order_items (
order_item_id	INTEGER PRIMARY KEY,
order_id	INTEGER REFERENCES "orders"(order_id) on DELETE CASCADE,
product_id	INTEGER,
quantity	INTEGER,
unit_price	NUMERIC(10,2),
line_total	NUMERIC(10,2));

copy order_items(order_item_id,order_id,product_id,quantity,unit_price,line_total)
from 'F:\Adi Complete Project\ProjectS\SQL Project\Adi sql\sql_practice_dataset\order_items.csv'
delimiter','
header csv;

----------showing CREATE tables.
select * from customers;
select * from products;
select * from orders;
select * from order_items;