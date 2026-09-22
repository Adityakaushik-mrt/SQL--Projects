🔴 Level 6 — Business Analysis
--Who is the highest-spending customer?
select cu.customer_name, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 1;

--Which product generated the highest revenue?
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

--Which category generated the highest revenue?
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

--Which city generated the highest sales?

select cu.city, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 1;

--What is the average order value?

select order_id,round(avg(line_total),2) Average_revenue
from order_items
group by 1
order by 2 desc;

--Find the top 3 customers by total spending.
select cu.customer_name, sum(line_total)total_amount_spent 
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1
order by 2 desc
limit 3;

--Find the top 5 products by revenue.
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

--Find the top-selling product based on quantity.
select pr.product_name,sum(oi.quantity) Total_Quantity
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1
order by 2 desc
limit 1;

--Find the number of completed, cancelled, and pending orders.
select status,count(*) Status_Count from orders
group by 1
order by 1;

--Calculate total revenue from completed orders only.
select od.order_id,sum(oi.line_total) from orders od join order_items oi
on od.order_id=oi.order_id
where od.status='Completed'
group by 1
order by 2 desc;