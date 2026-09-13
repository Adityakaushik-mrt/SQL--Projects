DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2),
    stock_quantity INT
);

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10, 2),
    status VARCHAR(20)
);

DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    unit_price NUMERIC(10, 2)
);

Copy Customers (customer_id,first_name,last_name,email,city,created_at)
from 'file name WITH path'
DELIMITER','
csv HEADER;

Copy Products (product_id,name,category,price,stock_quantity)
from 'file name WITH path'
DELIMITER','
csv HEADER;

Copy orders (order_id,customer_id,order_date,total_amount,status)
from 'file name WITH path'
DELIMITER','
csv HEADER;

Copy order_items (item_id,order_id,product_id,quantity,unit_price)
from 'file name WITH path'
DELIMITER','
csv HEADER;


1.The finance and inventory departments require a consolidated breakdown of sales performance across product categories. 
The report must calculate total completed/shipped revenue, total units sold, and the distinct number of orders.

select pr.category,sum(oi.quantity*oi.unit_price) Total_Revnue
from products pr join order_items oi
on pr.product_id=oi.product_id
join orders os on os.order_id=oi.order_id
where os.status in ('Completed','Shipped')
group by pr.category
order by Total_Revnue;

2. Marketing seeks to understand geographic customer spending patterns to optimize local ad spend. 
They need customer count, total orders, average order value (AOV), and total spend per city.

select cs.city,round(avg(os.Total_amount),2) AOV,sum(os.total_amount) Total_Spend
from customers cs join orders os
on cs.customer_id=os.customer_id and os.status != 'Cancelled'
group by cs.city
order by Total_Spend desc;

3.
Identify high-engagement customers who have purchased across multiple distinct product categories for VIP cross-selling loyalty programs.

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    COUNT(DISTINCT p.category) AS Distinct_categories_bought,
    STRING_AGG(DISTINCT p.category, ', ' ORDER BY p.category) AS Category_list,
    SUM(oi.quantity * oi.unit_price) AS Total_Spend
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.status IN ('Completed', 'Shipped')
GROUP BY c.customer_id, customer_name, c.email
HAVING COUNT(DISTINCT p.category) >= 2
ORDER BY distinct_categories_bought DESC, Total_Spend DESC;

4. Generate a financial pacing report showing daily revenue alongside a running cumulative total across the operating calendar.

select order_date,count(distinct(order_id)) total_orders,sum(total_amount) Total_revenue,
sum(sum(total_amount))over(order by order_date) Running_cumulative_revenue,
lag(sum(total_amount))over(order by order_date) Previous_Day_Revenue,
lead(sum(total_amount))over(order by order_date) Next_revenue
from orders 
WHERE status != 'Cancelled'
group by order_date
order by order_date;

5. Identify dormant accounts who registered over 90 days ago 
but have never placed an order, or have not ordered in the past 90 days, to target with re-activation campaigns.

select cs.*,max(od.order_date) last_order_date 
from customers cs left join orders od
on cs.customer_id=od.customer_id
group by cs.customer_id
HAVING MAX(od.order_date) IS NULL 
    OR MAX(od.order_date) < (CURRENT_DATE - INTERVAL '90 days');
	
6 : Calculate month-over-month revenue growth rate and track historical performance trends across sequential billing cycles.

WITH monthly_sales AS (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS order_month,
        SUM(total_amount) AS current_month_revenue,
        COUNT(order_id) AS total_orders
    FROM orders
    WHERE status IN ('Completed', 'Shipped')
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT 
    order_month,
    total_orders,
    current_month_revenue,
    LAG(current_month_revenue) OVER (ORDER BY order_month) AS previous_month_revenue,
current_month_revenue - LAG(current_month_revenue) OVER (ORDER BY order_month) minus,  
round(
((current_month_revenue - LAG(current_month_revenue) OVER (ORDER BY order_month))/
LAG(current_month_revenue) OVER (ORDER BY order_month))*100,2) Mom_growth_percentage
FROM monthly_sales
ORDER BY order_month ASC;

8. Write a query to return the top 2 highest-priced products in each product category. 
If there is a tie in price, both products should receive the same rank without skipping subsequent ranks.

WITH ranked_products AS (
    SELECT 
        product_id,
        name,
        category,
        price,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) as price_rank
    FROM products
)
SELECT 
    product_id,
    name,
    category,
    price,
    price_rank
FROM ranked_products
WHERE price_rank <=2
ORDER BY category, price_rank;

9. : Find the customer with the 2nd highest total lifetime spend in each city. If a city has only 1 customer or no valid spenders

with customer_rank as (
select  cs.customer_id,
		cs.first_name || ' ' || cs.last_name AS customer_name,
		cs.city,sum(os.total_amount) total_amount,
		dense_rank() over (partition by cs.city order by sum(os.total_amount) desc) rank_in_city
        from customers cs join orders os
on cs.customer_id=os.customer_id
group by cs.customer_id)
select customer_id,customer_name,city,total_amount 
from customer_rank where rank_in_city=2 order by city;

10.
Calculate the percentage of customers who placed an order in their signup month and 
subsequently placed another order in the next calendar month

WITH user_first_order AS (
    SELECT 
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS first_order_month
    FROM orders
    WHERE status != 'Cancelled'
    GROUP BY customer_id
),
user_monthly_activity AS (
    SELECT DISTINCT 
        o.customer_id,
        u.first_order_month,
        DATE_TRUNC('month', o.order_date) AS active_month
    FROM orders o
    JOIN user_first_order u ON o.customer_id = u.customer_id
    WHERE o.status != 'Cancelled'
)
SELECT 
    TO_CHAR(first_order_month, 'YYYY-MM') AS cohort_month,
    COUNT(DISTINCT customer_id) AS total_cohort_users,
    COUNT(DISTINCT CASE 
        WHEN active_month = first_order_month + INTERVAL '1 month' 
        THEN customer_id 
    END) AS retained_month_1,
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN active_month = first_order_month + INTERVAL '1 month' 
            THEN customer_id 
        END) * 100.0 / COUNT(DISTINCT customer_id), 
        2
    ) AS month_1_retention_pct
FROM user_monthly_activity
GROUP BY first_order_month
ORDER BY first_order_month;