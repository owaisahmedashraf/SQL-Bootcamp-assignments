-- NOTE: FOR ALL DATE RELATED QUESTIONS, PLEASE MAKE SURE YOU HAVE UPDATED YOUR DATES TO THE RIGHT FORMAT

-- [Question 1]
-- Using window functions and CTE, find out which items are priced higher than their item_type's average price
-- For all such items, your results should show item_id, item_name, item_type, item_price and item_type_avg
-- Round item_type_avg to 2 decimal places
with averages as (
select item_id, round(avg(item_price) over(partition by item_type),2) as item_type_avg
from items)
select i.item_id, i.item_name, i.item_type, i.item_price, a.item_type_avg
from items i
join averages a 
on i.item_id = a.item_id
where i.item_price > a.item_type_avg;


-- [Question 2a]
-- Find out customer_ids that have a total purchase amount > 100 (a simple group by query should do)
-- Your results should show customer_id and total_amount
select customer_id, sum(item_price) as total_amount
from items i
join orders o 
on i.item_id = o.item_id
group by customer_id
having sum(item_price) > 100
order by customer_id;


-- [Question 2b]
-- Add a column called "customer_value" to the customers table. 15 characters should be enough.
ALTER TABLE customers
ADD COLUMN customer_value VARCHAR(15);

select *
from customers;


-- [Question 2c]
-- Write a correlated subquery to update each customer's value as follows:
-- if the total amount of their orders is greater than 150, assign them "high value" status
-- if the total amount of their orders is between 100 and 150, assign them "median value" status. Otherwise, assign them "low value" status.
-- hint: make a CTE for customers and their total amounts and use this in a correlated subquery to update. If you can't figure this out, google how to update with a correlated subquery.
       
set sql_safe_updates = 0;       
						
with cus_status as(
select customer_id, sum(item_price) as total_amount
from items i
join orders o 
on i.item_id = o.item_id
group by customer_id
order by customer_id)

update customers c 
set customer_value = (select case when total_amount >150 then "high Value"
					              when total_amount between 100 and 150 then "median value"
                                  else "low value"
                                  end 
					 from cus_status cs
                     where cs.customer_id = c.customer_id);

select *
from customers;
                       

-- rough work, please ignore just for my understanding
select *, case when total_amount >150 then "high Value"
					   when total_amount between 100 and 150 then "median value"
                       else "low value"
                       end as category
from customers c
join cus_status cs
on c.customer_id = cs.customer_id   ;
            


-- [Question 2d]
-- Finally, show customers table ordered by customer_value in descending order and then customer_id in ascending order
select *
from customers
order by customer_value desc, customer_id asc;


-- [Question 3] 
-- Show customer_id, last_name, address, street, city and count of customers in each street in each city for all 100 records in customers

select customer_id, last_name, address, street, city, count(customer_id) over(partition by street, city) as customers_in_street_city
from customers;



-- [Question 4] 
-- Rank each item according to price WITHIN EACH ITEM TYPE. Assign the highest rank to the highest priced item and so on...
-- Use dense rank for this
-- your results should show item_id, item_name, item_type, item_price and ranks
select item_id, item_name, item_type, item_price, 
dense_rank()over(partition by item_type order by item_price desc) as price_rank
from items;


-- [Question 5] 
-- Rank each item TYPE based on its average price. Assign highest rank to the highest avg price and so on
-- Your results should show item_type, item_type_avg and ranks
-- round off average price to 3 decimal places

select item_type, round(avg(item_price),3) as item_type_avg, dense_rank() over(order by avg(item_price) desc) as ranks
from items
group by item_type;

-- Tried something different but I am not sure if it is correct, 

with itemAverage as (select item_type, avg(item_price)  over(partition by item_type) as item_type_avg
from items)
select item_type, item_type_avg, dense_rank() over(order by item_type_avg desc)
from itemAverage;

-- [Question 6a] 
-- Rank each customer_id based on the most expensive item they purchased
-- In another column, also rank each customer_id based on their average purchase amount
-- Highest ranking goes to the highest amount for both columns
-- Your results should show customer_id, max_purchase, avg_purchase, max_purchase_rank, avg_purchase_rank
with itemprice as( select customer_id, (select item_price
			from items i 
            where i.item_id = o.item_id
            ) as item_price
from orders o)
select c.customer_id, max(item_price) as max_purchase, dense_rank() over(order by max(item_price) desc) as max_purchase_rank,
round(avg(item_price),2) as avg_purchase, dense_rank() over(order by avg(item_price) desc) as avg_purchase_rank
from customers c 
join itemprice ip
on c.customer_id = ip.customer_id
group by customer_id;         


-- [Question 6b]
-- Now, only show those customer_ids that have the same max_purchase_rank and avg_purhase_rank
-- The columns in the result should remain the same as in part(a) 

with my_table as (with itemprice as( select customer_id, (select item_price
			from items i 
            where i.item_id = o.item_id
            ) as item_price
from orders o)
select c.customer_id, max(item_price) as max_purchase, dense_rank() over(order by max(item_price) desc) as max_purchase_rank,
round(avg(item_price),2) as avg_purchase, dense_rank() over(order by avg(item_price) desc) as avg_purchase_rank
from customers c 
join itemprice ip
on c.customer_id = ip.customer_id
group by customer_id
)
select *
from my_table
where max_purchase_rank = avg_purchase_rank;

-- [Question 7]
-- Sequentially from the earliest order to the latest, find out the difference (in days) between each order for each customer
-- Your results should show customer_id, order_id, current_row_date, next_row_date, and difference
select *
from orders;

with date_order as (select customer_id, order_id, order_date as current_row_date, Lead(order_date) over(partition by customer_id order by order_date) as next_row_date
from orders
order by customer_id, order_date asc)
select *, datediff(next_row_date, current_row_date) as difference
from date_order;


-- [Question 8]
-- Find out which customers haven't placed an order for over 50 days
-- Since all the dates in the dataset are from 2022, use 2022-07-01 as date_today and calculate the differences from this date
-- Your query should show customer_id, first_name, last_name, phone_number, last_order_date, date_today and difference
-- Remember that date_today will be 2022-07-01 for every record. To add a static column, simply write its value and alias in the select clause.
 
with recent_order as (select customer_id, max(order_date) as last_order_date, '2022-07-01' as date_today
from orders
group by customer_id)
select r.customer_id, first_name, last_name, phone_number, last_order_date, datediff(date_today,last_order_date) as difference
from customers c
join recent_order r
on c.customer_id = r.customer_id
where  datediff(date_today,last_order_date) > 50
order by difference desc;

-- BONUS QUESTIONS

-- [Question 9]
-- Find out the order_id, order_date, customer_id, first_name, last_name and phone_number of the smallest order amount that took the
-- company's earnings over 5000
-- Assume that the company earns the money on the day the order is placed
-- Do this in a single query

with new_table as (select customer_id, order_id, order_date, item_price, sum(item_price)over(order by order_date) as r_tot
from items i 
join orders o 
on i.item_id = o.item_id
)
select order_id, order_date, c.customer_id, first_name, last_name, phone_number, item_price, r_tot
from customers c 
join new_table nt
on c.customer_id = nt.customer_id
where r_tot > 5000
limit 1;

-- [Question 10a]
-- Find out if any customers placed an order in their birth month
-- Your results should show customer_id, date_of_birth, order_date

UPDATE customers
SET date_of_birth = str_to_date(date_of_birth, "%d/%m/%Y");

ALTER TABLE customers
MODIFY date_of_birth DATE;

select c.customer_id, date_of_birth, order_date
from customers c 
join orders o 
on c.customer_id = o.customer_id
where month(date_of_birth) = month(order_date);


-- [Question 10b]
-- Find out if any customers placed an order on their birthday
-- Show the same columns as part (a)


select c.customer_id, date_of_birth, order_date
from customers c 
join orders o 
on c.customer_id = o.customer_id
where date_of_birth = order_date;



