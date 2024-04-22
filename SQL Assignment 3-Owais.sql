-- [Question 1A]
-- Make sure you have extracted street names from the previous assignment
-- USING A JOIN, select order ids and the street name and city name for each order id. 
select o.order_id, c.street, c.city
from customers c 
join orders o 
on c.customer_id = o.customer_id
order by o.order_id;


-- [Question 1B]
-- Find out the total number of orders per street per city. Your results should show street, city and total_orders
-- results should be ordered by street in ascending order and cities in descending order
select  c.street, c.city, count(o.order_id) as Total_orders
from customers c
join orders o
on c.customer_id = o.customer_id
group by c.street, c.city
order by c.street ASC, c.city DESC;


-- [Question 2A]
-- USING A JOIN, select first names, last names and addresses of customers who have never placed an order.
-- Only these three columns should show in your results
SELECT first_name, last_name, address
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id is null;



-- [Question 2B]
-- USING A SUBQUERY IN WHERE (NOT correlated), select first_names, last_names and addresses of customers who have never placed an order.
SELECT distinct(customer_id) AS customers_who_placed_orders
FROM orders
ORDER BY customer_id;

SELECT first_name, last_name, address
FROM customers
WHERE customer_id NOT IN (SELECT distinct(customer_id) AS customers_who_placed_orders
							FROM orders
							ORDER BY customer_id);
                            
-- [Question 2C]
-- What do you observe in the results?
-- I observed that all the customers have placed atleast one order. Hence, there are no customers with zero orders. 


-- [Question 3A]
-- Write a simple group by query to find out item types and their average price
-- Pin this result in your workbench so you have it for comparison for the next question
SELECT item_type, ROUND(avg(item_price),2) AS Average_item_price
FROM items
GROUP BY item_type;

-- [Question 3B]
-- USING A CORRELATED SUBQUERY IN WHERE:
-- select item id, item name, item type and item price for all those items that have a price higher than the average price 
-- FOR THAT ITEM TYPE (NOT average of the whole column)
-- order your result by item type;
SELECT item_id, item_name, item_type, item_price
FROM items i
WHERE item_price >  (select avg(item_price)
					 from items it 
                     where i.item_type = it.item_type
                     group by it.item_type)
ORDER BY item_type;                     


-- [Question 3C]
-- Compare your results in part B to the averages you found in part A for each item type. 
-- Is your query in B returning all the items priced higher than the average of that item category?

-- Yes, it is returning all the items priced higher than the average of that item category. I used a correlated subquery. First from the outer query 
-- it selects the item-type from the first entry which is shoes then in the inner query it set up the item-type to shoes which then groups the items
-- according to that item-type which is shoes and then gives the average price of that item-type in this case shoes. Now if the price of the first item
-- from the items table is greater than the average it returns all the select variables which we want and if its not greater than it doesnt. The same thing
-- happens for all the entries in the table


-- [Question 4] 
-- USING A SUBQUERY IN WHERE (NOT correlated), find out customer ids and the order date and item id of their most recent order
-- order your result by customer_id

SELECT customer_id, max(order_date) as recent_order
FROM orders
GROUP BY customer_id
ORDER BY customer_id;

SELECT customer_id, order_date, item_id
FROM orders
WHERE order_date IN (SELECT max(order_date)
					FROM orders
					GROUP BY customer_id)
ORDER BY customer_id;                    

-- [Question 5A]
-- USE A JOIN to select the following:
-- last name, address, phone number, order id, order date, item name, item type, and item price. 

SELECT c.last_name, c.phone_number, o.order_id, o.order_date, i.item_name, i.item_price
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN items i
ON o.item_id = i.item_id;

-- [Question 5B]
-- Now return the same table as above but also return the total number of orders by that customer next to each row (call this total_orders)
-- USE A CORRELATED SUBQUERY IN THE SELECT CLAUSE FOR THIS
SELECT c.first_name, c.last_name, c.phone_number, o.order_id, o.order_date, i.item_name, i.item_price, (select count(order_id) 
																							from orders o
                                                                                            where o.customer_id = c.customer_id
                                                                                            group by o.customer_id) as total_orders_by_customers
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN items i
ON o.item_id = i.item_id;


-- NOTE FOR QUESTION 6: 
-- Please remember that when you group by a certain column for e.g. id, you can only add id and aggregate columns like sum(), count() avg() etc to the select clause
-- You cannot add non-aggregated columns like name, type etc to the select clause UNLESS they are also in the group by clause
-- However, you CAN add non-aggregated columns like name, type etc to the select clause without them being in the group by clause IF you group by a primary key column.
-- To solve the question, you can either set a primary key or add all the requested columns to the group by clause along with the column you need to group by. 

-- [Questions 6] 
-- USING A JOIN, find out the item name, item type, amount in stock and total_orders for the 5 top most sold items.
-- Since there are more than 5 top most sold items, show your top 5 based on item name ascending alphabetical order (your results should not show more than 5 rows)
-- DON'T use any subqueries here


SELECT i.item_name, i.item_type, i.amount_in_stock, count(o.order_id) as total_orders
FROM items i 
JOIN orders o 
ON i.item_id = o.item_id
GROUP BY i.item_name, i.item_type, i.amount_in_stock
ORDER BY total_orders DESC, i.item_name ASC
LIMIT 5;



