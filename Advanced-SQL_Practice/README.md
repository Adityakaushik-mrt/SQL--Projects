# 📊 Advanced SQL Analytics Project – Intelligence

## 🔍 Project Overview
This project analyzes data using Advanced SQL to extract meaningful business insights such as customer spending behavior, revenue performance, category rankings, and time-series trends[]. It simulates production-grade analytical scenarios commonly encountered in data analyst and business intelligence roles[, 3].

---

## 📁 Dataset Description
The schema models an e-commerce platform and consists of four relational tables[]:

### Table: customers
| Column Name | Description |
| :--- | :--- |
| customer_id | Unique identifier for each customer[] |
| customer_name | Full name of the customer[] |
| city | City location of the customer[] |

### Table: orders
| Column Name | Description |
| :--- | :--- |
| order_id | Unique identifier for each order[] |
| customer_id | Identifier linking to customers[] |
| order_date | Date when the order was placed[] |

### Table: order_items
| Column Name | Description |
| :--- | :--- |
| order_id | Identifier linking to orders[] |
| product_id | Identifier linking to products[] |
| quantity | Number of units ordered[] |
| line_total | Total monetary value for this item[] |

### Table: products
| Column Name | Description |
| :--- | :--- |
| product_id | Unique identifier for each product[] |
| product_name | Name of the product[] |
| category | Category/classification of product[] |
| unit_price | Unit price of the product[] |

---

## 🎯 Business Problems Solved

### 1️⃣ Benchmark & Outlier Identification
* Identify customers whose total spend exceeds the overall average customer spending[].
* Identify products whose revenue outperforms the average product revenue[].

### 2️⃣ Product & Pricing Tier Analysis
* Find the 2nd and 3rd highest-priced products handling price ties[].
* Identify the product with the maximum quantity sold[].
* Extract the top-performing product in each category by total revenue[].

### 3️⃣ Revenue Distribution & Customer Contribution
* Rank customers and products by total cumulative revenue[].
* Compute each customer's percentage contribution to overall store sales[].

### 4️⃣ Time-Series & Sequence Analytics
* Calculate daily sales running totals over time[].
* Track prior purchase dates for each customer[].
* Identify customers whose latest purchase value increased compared to their previous purchase[].

### 5️⃣ Regional Segmentation
* Determine the top 3 spending customers in each city[].

---

## 🛠️ SQL Concepts Used
* Common Table Expressions (CTEs)[]
* Window Ranking Functions (DENSE_RANK, ROW_NUMBER)[]
* Lead/Lag Sequential Analysis (LAG)[]
* Running Totals & Aggregation via Window Functions[]
* Multi-Table Relational Joins (INNER JOIN)[]
* Aggregate Functions & Grouping (SUM, AVG, COUNT, GROUP BY)[]

---

## 📌 Complete SQL Queries Script (All In One)

```sql
-- Q1: Customers Spending Greater Than Average Spending
with Cust_spend as(
select cu.customer_id, cu.customer_name, sum(line_total)total_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
)
select * from Cust_spend where total_spent>(
select avg(total_spent) from Cust_spend);

-- Q2: Products with Revenue Higher Than Average Revenue
with pro_spend as(
select pr.product_id, pr.product_name, sum(oi.line_total) high_revenue
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2
)
select * from pro_spend where high_revenue>(
select avg(high_revenue) from pro_spend);

-- Q3: Second-Highest Priced Product
with rnk_product as(
select product_id,product_name,unit_price,
dense_rank() over (order by unit_price desc) rnk
from products)
select product_id,product_name,unit_price
from rnk_product
where rnk=2;

-- Q4: Third-Highest Priced Product
with rnk_product as(
select product_id,product_name,unit_price,
dense_rank() over (order by unit_price desc) rnk
from products)
select product_id,product_name,unit_price
from rnk_product
where rnk=3;

-- Q5: Customer with Maximum Number of Orders
with cust_order_cnt as (
select cs.customer_id,cs.customer_name,count(*) total_count,
dense_rank()over (order by count(od.order_id)desc ) rnk
from customers cs join orders od
on cs.customer_id=od.customer_id
group by 1)
select * from cust_order_cnt
where rnk=1;

-- Q6: Product with the Highest Quantity Sold
with product_quantity_sold as (
select pr.product_name,sum(oi.quantity) Total_Quantity,
dense_rank() over(order by sum(oi.quantity) desc) rnk
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1)
select product_name,Total_Quantity from product_quantity_sold
where rnk=1;

-- Q7: Highest-Revenue Product Within Each Category
with product_revenue_by_category as(
select  pr.category, pr.product_name ,sum(oi.line_total)total_revenue,
dense_rank()over (partition by pr.category order by sum(oi.line_total) desc ) Rnk
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2)
select category, product_name ,total_revenue
from product_revenue_by_category
where rnk=1
order by 3 desc;

-- Q8: Rank Customers by Total Spending
select cu.customer_id, cu.customer_name, sum(line_total)total_spent ,
dense_rank() over (order by sum(oi.line_total) desc) ranking
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1;

-- Q9: Rank Products According to Revenue
select pr.product_name,sum(oi.line_total)total_revenue,
dense_rank() over (order by sum(oi.line_total) desc) ranking
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1;

-- Q10: Calculate Customer's Percentage Contribution to Total Sales
with customer_sales as (
select cu.customer_id, cu.customer_name, sum(line_total)total_spend
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1)
select customer_id, customer_name,total_spend,
round(100*total_spend/sum(total_spend) over(),2) percentage_Contribution
from customer_sales
group by 1,2,3;

-- Q11: Running Total of Sales by Order Date
with daily_sale as (
select od.order_date,sum(oi.line_total) daily_sales
from orders od join order_items oi
on od.order_id=oi.order_id
group by 1)
select order_date,daily_sales,
sum(daily_sales) over(order by order_date ) as runnig_total
from daily_sale
order by 1;

-- Q12: Previous Order Date for Each Customer (LAG)
select cs.customer_id,od.order_date,
lag(od.order_date) over (partition by cs.customer_id order by od.order_date )
from customers cs join orders od
on cs.customer_id=od.customer_id;

-- Q13: Customers with Latest Order Value Greater Than Previous Order
with cal_order as
(
select cs.customer_id,cs.customer_name,od.order_id,od.order_date,sum(oi.line_total) as total_sale
from customers cs join orders od
on cs.customer_id=od.customer_id
join order_items oi
on od.order_id=oi.order_id
group by 1,2,3,4
order by 4),
rank_order as (
select customer_id,customer_name,order_id,order_date,total_sale as latest_order_value,
lag(total_sale) over(partition by customer_id order by order_date,order_id) pre_order_vale,
row_number() over (partition by customer_id order by order_date desc,order_id desc) rnk
from cal_order)
select customer_id,customer_name,order_id,order_date,latest_order_value,pre_order_vale
from rank_order
where rnk=1
and latest_order_value>pre_order_vale;

-- Q14: Highest-Selling Product in Each Category (ROW_NUMBER)
select * from (
select  pr.category, pr.product_name ,sum(oi.line_total)total_revenue,
row_number()over (partition by pr.category order by sum(oi.line_total) desc ) row_num
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2)
where row_num=1;

-- Q15: Top 3 Customers in Each City
with customer_spending as (
select cu.city,cu.customer_name, sum(line_total)total_spent,
dense_rank()over (partition by cu.city order by sum(oi.line_total) desc) rnk
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1,2
order by 1)
select * from customer_spending where rnk<=3;
```

---

## 📈 Key Insights
* Top Spender Concentration: Pinpointed high-value customers outperforming the spending benchmark to support retention programs[].
* Category Drivers: Identified revenue-leading items across all categories for catalog optimization[].
* Spending Growth: Identified customers with positive basket-size growth between their consecutive orders[].
* Geographic Tiers: Segmented localized spenders to direct regional marketing spend effectively[].

---

## 🚀 Tools Used
* PostgreSQL / MySQL[]
* SQL (Core + Advanced Window Functions)[]

---

## 💼 Why This Project Matters
This project demonstrates:
* Deep competence with advanced window functions (DENSE_RANK, ROW_NUMBER, LAG, and running totals)[].
* Ability to structure clean, modular multi-step pipelines with Common Table Expressions (CTEs)[].
* Mastery of multi-table joins, subqueries, and analytical data aggregation[].
* Practical problem-solving skills required for Data Analyst and Business Intelligence roles[cite: 3].

---

## 📬 Author
Aditya Sharma(Adi)[]  
Aspiring Data Analyst | SQL | Python | Power BI[]
