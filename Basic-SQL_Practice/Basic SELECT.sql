🧩 SQL Practice Questions
🟢 Level 1 — Basic SELECT
--Display all customers.
select * from customers;

--Display only customer name and city.
select customer_name,city from customers;

--Find all customers from Delhi.
select * from customers where city='Delhi';

--Find all female customers.
select * from customers where gender='Female';

--Display all products belonging to the Electronics category.
select * from products where category='Electronics';

--Find products with a unit price greater than ₹20,000.
select * from products where unit_price>'20000';

--Display products whose stock quantity is less than 20.
select * from products where stock_qty<'20';

--Find customers whose names start with A.
select * from customers where customer_name like 'A%';

-Find customers whose names end with a.
select * from customers where customer_name like '%a';

--Display orders having Completed status.
select * from orders where status='Completed';
