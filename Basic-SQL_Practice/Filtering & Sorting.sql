🟡 Level 2 — Filtering & Sorting
--Find products priced between ₹5,000 and ₹20,000.
select * from products where unit_price between 5000 and 20000;

--Find customers from Delhi, Mumbai, or Jaipur.
select * from customers where city in ('Delhi','Mumbai','Jaipur');

--Find orders placed after 2024-09-01.
select * from orders where order_date>'2024-09-01'

--Display products from highest price to lowest price.
select * from products 
order by unit_price desc;

--Display the 5 most expensive products.
select * from products 
order by unit_price desc
limit 5;

--Find all orders placed through the Online sales channel.
select * from orders where sales_channel='Online';

--Find cancelled orders.
select * from orders where status='Cancelled';

--Find customers whose names contain sh.
select * from customers where customer_name like'%sh%';

--Find products whose stock is between 10 and 30.
select * from products where stock_qty between 10 and 30;

--Display completed orders sorted by order date.
select * from orders 
order by order_date;