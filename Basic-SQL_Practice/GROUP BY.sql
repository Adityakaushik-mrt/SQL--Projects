🔵 Level 4 — GROUP BY
--Find the number of customers in each city.
select city,count(*) Customer_NumberS from customers
group by city;

--Find the number of customers by gender.
select gender,count(*) Customer_NumberS from customers
group by gender;

--Find the number of products in each category.
select category,count(*) from products
group by category;

--Find the average price of products by category.
select category,round(avg(unit_price),2) Avg_Price from products
group by category;

--Find the maximum product price in each category.
select category,max(unit_price) Max_Price from products
group by category;

--Find total stock quantity by category.
select category,sum(stock_qty) Total_Stock from products
group by category;

--Find the number of orders by status.
select status,count(*) Status_Count from orders
group by status

--Find the number of orders by sales channel.
select sales_channel,count(*) Sales_Status_Count from orders
group by sales_channel;

--Find total sales by product.
select pr.product_id,pr.product_name,sum(oi.quantity*oi.unit_price) Total_sale
from products pr join order_items oi
on pr.product_id=oi.product_id
group by  1,2

--Find total quantity sold for each product.
select product_name,sum(stock_qty) Total_Stock from products
group by product_name;