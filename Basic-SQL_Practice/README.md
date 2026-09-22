# 📊 SQL Practice & Analytics Project – Fundamental to Intermediate SQL

## 🔍 Project Overview
This project consolidates foundational to intermediate SQL queries spanning three key learning levels: **Level 1 (Basic SELECT)**, **Level 2 (Filtering & Sorting)**, and **Level 4 (GROUP BY & Aggregations)**[]. It demonstrates essential data querying, conditional slicing, pattern searching, sorting, multi-table joining, and dimensional metric aggregation commonly required in Data Analyst workflows[, 5, 6].

---

## 📁 Dataset Description
The queries operate on an e-commerce retail database comprising four primary tables[]:

### Table: `customers`
| Column Name | Description |
| :--- | :--- |
| `customer_id` | Unique identifier for each customer[] |
| `customer_name` | Full name of the customer[] |
| `city` | City location of the customer[] |
| `gender` | Gender of the customer[] |

### Table: `orders`
| Column Name | Description |
| :--- | :--- |
| `order_id` | Unique identifier for each order[] |
| `order_date` | Date the order was placed[] |
| `status` | Status of the order (`Completed`, `Cancelled`, etc.)[] |
| `sales_channel` | Channel used to place order (e.g., `Online`)[] |

### Table: `products`
| Column Name | Description |
| :--- | :--- |
| `product_id` | Unique identifier for each product[cite: 7] |
| `product_name` | Name of the product[cite: 7] |
| `category` | Classification category (e.g., `Electronics`)[] |
| `unit_price` | Price per product unit[] |
| `stock_qty` | Quantity of product currently in stock[] |

### Table: `order_items`
| Column Name | Description |
| :--- | :--- |
| `order_id` | Reference to the associated order[cite: 7] |
| `product_id` | Reference to the associated product[cite: 7] |
| `quantity` | Number of units purchased in line item[cite: 7] |
| `unit_price` | Unit price at the time of purchase[cite: 7] |

---

## 🎯 Business Problems Solved

### 🟢 Level 1: Basic Retrieval & Direct Filtering
* Retrieve entire or specific dimensional columns from tables[cite: 5].
* Filter records by categorical values (city, gender, order status, category)[cite: 5].
* Filter numerical values based on single thresholds[cite: 5].
* Find text records matching exact prefixes and suffixes using wildcards[cite: 5].

### 🟡 Level 2: Range Filtering, In-Lists & Sorting
* Filter values within defined numerical bounds using `BETWEEN`[].
* Match categorical values across list options using `IN`[].
* Filter chronological data placed after specific calendar dates[].
* Sort records in descending/ascending orders and restrict row output with `LIMIT`[].
* Identify records containing specific substrings with `%pattern%`[].

### 🔵 Level 4: Grouping & Aggregate KPI Calculation
* Calculate volume metrics per dimension using `COUNT(*)` (customer count by city/gender, order count by status/channel)[cite: 7].
* Compute summary price statistics (`AVG`, `MAX`) grouped by category[cite: 7].
* Calculate total inventory volume per category[cite: 7].
* Join transactional data (`order_items`) with dimensional data (`products`) to evaluate revenue per product[cite: 7].

---

## 🛠️ SQL Concepts Used
* **Data Projection & Filtering:** `SELECT`, `WHERE`, `=`, `>`, `<`, `BETWEEN`, `IN`[]
* **Pattern Matching:** Wildcard evaluation with `LIKE` (`A%`, `%a`, `%sh%`)[]
* **Sorting & Pagination:** `ORDER BY`, `DESC`, `LIMIT`[]
* **Aggregation Functions:** `COUNT()`, `SUM()`, `AVG()`, `MAX()`, `ROUND()`[cite: 7]
* **Grouping:** Multi-column and single-column `GROUP BY`[cite: 7]
* **Relational Joins:** `INNER JOIN` across transaction tables[cite: 7]

---

## 📌 Complete SQL Queries Script (All In One)

```sql
-- ====================================================================
-- 🟢 Level 1 — Basic SELECT
-- ====================================================================

-- 1. Display all customers.
select * from customers;

-- 2. Display only customer name and city.
select customer_name,city from customers;

-- 3. Find all customers from Delhi.
select * from customers where city='Delhi';

-- 4. Find all female customers.
select * from customers where gender='Female';

-- 5. Display all products belonging to the Electronics category.
select * from products where category='Electronics';

-- 6. Find products with a unit price greater than ₹20,000.
select * from products where unit_price>'20000';

-- 7. Display products whose stock quantity is less than 20.
select * from products where stock_qty<'20';

-- 8. Find customers whose names start with A.
select * from customers where customer_name like 'A%';

-- 9. Find customers whose names end with a.
select * from customers where customer_name like '%a';

-- 10. Display orders having Completed status.
select * from orders where status='Completed';


-- ====================================================================
-- 🟡 Level 2 — Filtering & Sorting
-- ====================================================================

-- 11. Find products priced between ₹5,000 and ₹20,000.
select * from products where unit_price between 5000 and 20000;

-- 12. Find customers from Delhi, Mumbai, or Jaipur.
select * from customers where city in ('Delhi','Mumbai','Jaipur');

-- 13. Find orders placed after 2024-09-01.
select * from orders where order_date>'2024-09-01';

-- 14. Display products from highest price to lowest price.
select * from products 
order by unit_price desc;

-- 15. Display the 5 most expensive products.
select * from products 
order by unit_price desc
limit 5;

-- 16. Find all orders placed through the Online sales channel.
select * from orders where sales_channel='Online';

-- 17. Find cancelled orders.
select * from orders where status='Cancelled';

-- 18. Find customers whose names contain sh.
select * from customers where customer_name like '%sh%';

-- 19. Find products whose stock is between 10 and 30.
select * from products where stock_qty between 10 and 30;

-- 20. Display completed orders sorted by order date.
select * from orders 
order by order_date;


-- ====================================================================
-- 🔵 Level 4 — GROUP BY & Aggregations
-- ====================================================================

-- 21. Find the number of customers in each city.
select city,count(*) Customer_NumberS from customers
group by city;

-- 22. Find the number of customers by gender.
select gender,count(*) Customer_NumberS from customers
group by gender;

-- 23. Find the number of products in each category.
select category,count(*) from products
group by category;

-- 24. Find the average price of products by category.
select category,round(avg(unit_price),2) Avg_Price from products
group by category;

-- 25. Find the maximum product price in each category.
select category,max(unit_price) Max_Price from products
group by category;

-- 26. Find total stock quantity by category.
select category,sum(stock_qty) Total_Stock from products
group by category;

-- 27. Find the number of orders by status.
select status,count(*) Status_Count from orders
group by status;

-- 28. Find the number of orders by sales channel.
select sales_channel,count(*) Sales_Status_Count from orders
group by sales_channel;

-- 29. Find total sales by product.
select pr.product_id,pr.product_name,sum(oi.quantity*oi.unit_price) Total_sale
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1,2;

-- 30. Find total quantity sold for each product.
select product_name,sum(stock_qty) Total_Stock from products
group by product_name;
```

---

## 📈 Key Insights
* **Customer Demographics:** Segmenting customers by city and gender enables targeted geographic and demographic promotions[cite: 7].
* **Inventory & Pricing:** Categorical summaries expose price spreads and low-stock categories needing restocking[].
* **Sales Channels:** Channel breakdown provides visibility into online vs. offline transaction share[].
* **Product Revenue Drivers:** Joining catalog items with order items highlights the highest revenue-producing inventory[cite: 7].

---

## 🚀 Tools Used
* PostgreSQL / MySQL[]
* SQL (SELECT, Filtering, Sorting, Aggregations, Relational Joins)[]

---

## 💼 Why This Project Matters
This project demonstrates:
* Strong command over core and intermediate SQL querying[].
* Ability to filter, slice, and order transactional datasets effectively[].
* Practical understanding of grouped aggregate reporting for key performance indicators[cite: 7].
* Foundational data manipulation skills essential for any Data Analyst or BI professional[].

---

## 📬 Author
**Aditya Sharma**[]  
Aspiring Data Analyst | SQL | Python | Power BI[]
