# 📊 SQL Analytics Project – Business Analysis

## 🔍 Project Overview
This project analyzes retail transaction data using SQL to extract actionable business intelligence, including high-value customer behavior, product and category revenues, geographical sales distributions, and order fulfillment health[]. It simulates real-world analytical scenarios commonly handled by Data Analysts and Business Intelligence professionals[].

---

## 📁 Dataset Description
The database schema consists of four interconnected tables modeling retail transactions[]:

### Table: `customers`
| Column Name | Description |
| :--- | :--- |
| `customer_id` | Unique identifier for each customer[] |
| `customer_name` | Full name of the customer[] |
| `city` | City location of the customer[] |

### Table: `orders`
| Column Name | Description |
| :--- | :--- |
| `order_id` | Unique identifier for each order[] |
| `customer_id` | Foreign key referencing the `customers` table[] |
| `status` | Current status of the order (`Completed`, `Cancelled`, `Pending`)[] |

### Table: `order_items`
| Column Name | Description |
| :--- | :--- |
| `order_id` | Foreign key referencing the `orders` table[] |
| `product_id` | Foreign key referencing the `products` table[] |
| `quantity` | Number of units purchased[] |
| `line_total` | Total monetary value for the specific line item[] |

### Table: `products`
| Column Name | Description |
| :--- | :--- |
| `product_id` | Unique identifier for each product[] |
| `product_name` | Name/description of the product[] |
| `category` | Product classification category[] |

---

## 🎯 Business Problems Solved

### 1️⃣ Revenue & Outlier Analysis
* Identify the highest-spending customer across total historical purchases[].
* Pinpoint the product and category generating the highest cumulative revenue[].
* Determine the top sales-generating city to evaluate geographical performance[].

### 2️⃣ Product & Customer Benchmarking
* Identify the top 3 customers by cumulative expenditure[].
* Identify the top 5 products ranked by total revenue[].
* Determine the best-selling product based on total unit volume sold[].
* Calculate Average Order Value (AOV) per transaction[].

### 3️⃣ Operations & Fulfillment Metrics
* Count the total distribution of orders across `Completed`, `Cancelled`, and `Pending` statuses[].
* Calculate net revenue generated exclusively from completed orders[].

---

## 🛠️ SQL Concepts Used
* Multi-Table Relational Joins (`INNER JOIN` linking 3 to 4 tables)[]
* Aggregate Functions (`SUM`, `AVG`, `COUNT`, `ROUND`)[]
* Grouping & Categorization (`GROUP BY`)[]
* Sorting & Rank-Limiting (`ORDER BY DESC`, `LIMIT`)[]
* Conditional Record Filtering (`WHERE`)[]

---

## 📌 Complete SQL Queries Script (All In One)

```sql
-- Q1: Who is the highest-spending customer?
select cu.customer_name, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 1;

-- Q2: Which product generated the highest revenue?
select pr.product_id, pr.product_name, sum(oi.line_total) high_revenue
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2
order by 3 desc
limit 1;

-- Q3: Which category generated the highest revenue?
select pr.category,sum(oi.line_total) Total_Revenue
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1
order by 2 desc
limit 1;

-- Q4: Which city generated the highest sales?
select cu.city, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 1;

-- Q5: What is the average order value?
select order_id,round(avg(line_total),2) Average_revenue
from order_items
group by 1
order by 2 desc;

-- Q6: Find the top 3 customers by total spending.
select cu.customer_name, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 3;

-- Q7: Find the top 5 products by revenue.
select pr.product_id, pr.product_name,sum(oi.line_total)total_rev
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2
order by 2 desc
limit 5;

-- Q8: Find the top-selling product based on quantity.
select pr.product_name,sum(oi.quantity) Total_Quantity
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1
order by 2 desc
limit 1;

-- Q9: Find the number of completed, cancelled, and pending orders.
select status,count(*) Status_Count from orders
group by 1
order by 1;

-- Q10: Calculate total revenue from completed orders only.
select od.order_id,sum(oi.line_total) from orders od join order_items oi
on od.order_id=oi.order_id
where od.status='Completed'
group by 1
order by 2 desc;
```

---

## 📈 Key Insights
* **Spend Concentration:** High-value customers generate a disproportionate percentage of total sales, establishing clear targets for VIP loyalty programs[].
* **Flagship Drivers:** Top product and category metrics highlight core inventory drivers responsible for primary revenue streams[].
* **Regional Hubs:** City-level breakdowns spotlight high-performing metropolitan markets for prioritized advertising and supply-chain logistics[].
* **Fulfillment Pipeline:** Monitoring order statuses provides visibility into fulfillment throughput and highlights revenue leakage from cancellations[].

---

## 🚀 Tools Used
* PostgreSQL / MySQL[]
* SQL (Core Analytics, Aggregations, Multi-Table Joins)[, 4]

---

## 💼 Why This Project Matters
This project demonstrates:
* Ability to write multi-table relational joins across transactional schemas[].
* Practical application of grouping, ordering, and aggregate calculations to extract core business KPIs[].
* Translation of business questions into optimized SQL queries for executive reporting[].
* Core data manipulation and analytics competencies essential for Data Analyst and BI Analyst roles[].

---

## 📬 Author
**Aditya Sharma**[]  
Aspiring Data Analyst | SQL | Python | Power BI[]
