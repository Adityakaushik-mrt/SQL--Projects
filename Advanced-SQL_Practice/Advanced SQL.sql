🟤 Level 7 — Advanced SQL

--Find customers whose total spending is greater than the average customer spending.
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

--Find products whose price is higher than the average product price.
with pro_spend as(
select pr.product_id, pr.product_name, sum(oi.line_total) high_revenue
from customers cu join orders od
on cu.customer_id=od.customer_id
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2
)
select * from pro_spend where high_revenue>(
select avg(high_revenue) from pro_spend);

--Find the second-highest priced product.

with rnk_product as(
select product_id,product_name,unit_price,
dense_rank() over (order by unit_price desc) rnk
from products)
select product_id,product_name,unit_price
from rnk_product
where rnk=2

select * from pro_revenue where rnk=2;

--Find the third-highest priced product.
with rnk_product as(
select product_id,product_name,unit_price,
dense_rank() over (order by unit_price desc) rnk
from products)
select product_id,product_name,unit_price
from rnk_product
where rnk=3;

--Find the customer who placed the maximum number of orders.
with cust_order_cnt as (
select cs.customer_id,cs.customer_name,count(*) total_count,
dense_rank()over (order by count(od.order_id)desc ) rnk
from customers cs join orders od
on cs.customer_id=od.customer_id
group by 1)
select * from cust_order_cnt
where rnk=1;

--Find the product with the highest quantity sold.
with product_quantity_sold as (
select pr.product_name,sum(oi.quantity) Total_Quantity,
dense_rank() over(order by sum(oi.quantity) desc) rnk
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1)
select product_name,Total_Quantity from product_quantity_sold
where rnk=1;

--Find the highest-revenue product within each category.
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

--Rank customers according to their total spending.
select cu.customer_id, cu.customer_name, sum(line_total)total_spent ,
dense_rank() over (order by sum(oi.line_total) desc) ranking
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1

--Rank products according to their revenue.
select pr.product_name,sum(oi.line_total)total_revenue,
dense_rank() over (order by sum(oi.line_total) desc) ranking
from products pr join order_items oi
on pr.product_id=oi.product_id
group by 1;

--Calculate each customer's percentage contribution to total sales.
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
group by 1,2,3

--Find the running total of sales by order date.
with daily_sale as (
select od.order_date,sum(oi.line_total) daily_sales
from orders od join order_items oi
on od.order_id=oi.order_id
group by 1)
select order_date,daily_sales,
sum(daily_sales) over(order by order_date ) as runnig_total
from daily_sale
order by 1;

--Find the previous order date for each customer using LAG().
select cs.customer_id,od.order_date,
lag(od.order_date) over (partition by cs.customer_id order by od.order_date )
from customers cs join orders od
on cs.customer_id=od.customer_id;

--Find customers whose latest order value is greater than their previous order value
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

--Find the highest-selling product in each category using ROW_NUMBER().
select* from (
select  pr.category, pr.product_name ,sum(oi.line_total)total_revenue,
row_number()over (partition by pr.category order by sum(oi.line_total) desc ) row_num
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
join products pr
on pr.product_id=oi.product_id
group by 1,2)
where row_num=1

--Find the top 3 customers in each city using a window function.
with  customer_spending as (
select cu.city,cu.customer_name, sum(line_total)total_spent,
dense_rank()over (partition by cu.city order by sum(oi.line_total) desc) rnk
from customers cu join orders od
on cu.customer_id=od.customer_id
join order_items oi
on oi.order_id=od.order_id
group by 1,2
order by 1)
select * from customer_spending where rnk<=3