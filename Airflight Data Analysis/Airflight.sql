--1. Find all flights above a given fare.
 select * from flights;

--2. Find Total bookings by seat class
select seat_class,count(booking_id) Total_Seats
from bookings
group by seat_class;

--  1. Find all flights above a given fare
select flight_no  Flight_number,sum(base_fare) Total_Fare
from flights
group by flight_no
order by 2 desc;

-- 2. Find Total bookings by seat class
select seat_class,count(booking_id) Total_Seats
from bookings
group by seat_class;

-- 3. Calculate revenue by flight.
select fl.flight_id,fl.flight_no,
sum(fl.base_fare) over (partition by fl.flight_no ) Total_flight_revemue
from flights fl left join bookings bk
on fl.flight_id=bk.flight_id
where bk.booking_status='Confirmed'
group by 1
order by 3 desc

-- 4. Find passengers with more than 3 bookings
with booking_cnt as(
select *,count(*) over(partition by passenger_id) as total_booking
from bookings
where booking_status<>'Confirmed')
select * from booking_cnt 
where total_booking>3

-- 5. Find the most popular destination airport
select count(fl.flight_id),fl.destination_airport,ai.airport_code,ai.city,ai.country
from flights fl join airports ai
on fl.destination_airport =ai.airport_id
group by 2,3,4,5
order by 1 desc
limit 1;
----------
select *,count(*)over (partition by destination_airport) total_flight
from flights order by total_flight desc
limit 1;

---6. Calculate cancellation rate by flight.
select count(*) total_booking,  
count(*) filter(where booking_status='Cancelled') cancel_booking,
round((count(*) filter(where booking_status=
'Cancelled')::numeric/count(*))*100,2) cancel_rate
from bookings ;

--7. Find the top 10 flights by booking revenue
with total_fare as(
select *,
sum(fl.base_fare) over (partition by fl.flight_no ) Total_flight_revemue
from flights fl 
),
flight_booking as(
select tf.flight_no,tf.Total_flight_revemue,bk.booking_id,
row_number() over (partition by tf.Total_flight_revemue order by tf.Total_flight_revemue desc) Rnk
from total_fare tf join bookings bk
on tf.flight_id=bk.flight_id
order by tf.Total_flight_revemue desc)
select flight_no,booking_id,Total_flight_revemue
from flight_booking 
where rnk=1
limit 10;

--8. Rank flights within each origin airport by revenue
select *,dense_rank()over (order by total_fare ) Rank
from (
with total_revenue as (
select origin_airport,sum(base_fare) total_fare
from flights group by origin_airport
),
airport_details as (select airport_id,airport_code,city 
				from airports )
				select * from total_revenue re join airport_details dt
				on re.origin_airport=dt.airport_id );
				
				
-- 9. Find passengers whose latest booking is cancelled
with passengers_data as(
select booking_id,passenger_id,flight_id,booking_date,booking_status from (
select booking_id,passenger_id,flight_id,booking_date,booking_status,
dense_rank() over(partition by flight_id order by booking_date desc) rnk
from bookings 
where booking_status='Cancelled'
order by booking_date desc) where rnk=1),
details as (select passenger_id,passenger_name,gender,city from passengers )
select * from passengers_data ps join details dt
on ps.passenger_id=dt.passenger_id
order by ps.flight_id;

--10. Calculate monthly booking revenue and month-over-month growth
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', bk.booking_date) AS booking_month,
        SUM(fl.base_fare) AS current_revenue
    FROM bookings bk
    JOIN flights fl 
        ON bk.flight_id = fl.flight_id
    WHERE bk.booking_status = 'Confirmed'
    GROUP BY DATE_TRUNC('month', bk.booking_date)
),
mom_calc AS (
    SELECT 
        TO_CHAR(booking_month, 'YYYY-MM') AS month_label,
        booking_month,
        current_revenue,
        LAG(current_revenue, 1) OVER (ORDER BY booking_month) AS prev_revenue
    FROM monthly_revenue
)
SELECT 
    month_label,
    current_revenue,
    COALESCE(prev_revenue, 0) AS previous_month_revenue,
    (current_revenue - prev_revenue) AS absolute_change,
    ROUND(
        (current_revenue - prev_revenue) * 100.0 / NULLIF(prev_revenue, 0),
        2
    ) AS mom_growth_percent
FROM mom_calc
ORDER BY booking_month;