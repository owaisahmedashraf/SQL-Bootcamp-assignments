-- [Question 1] find out top 5 customers with the most orders



-- [Question 2] find out the top 3 most sold items



-- [Question 3] show customers and total order only for customers with more than 4 orders



-- [Question 4] only show records for customers that live on oak st, pine st or cedar st and belong to either anyville or anycity


-- [Question 5] In a simple select query, create a column called price_label in which label each item's price as:
-- low price if its price is below 10
-- moderate price if its price is between 10 and 50
-- high price if its price is above 50
-- "unavailable" in all other cases

-- order this query by price in descending order



-- [Question 6] Using DDL commands, add a column called stock_level to the items table.



-- [Question 7] Update this column in the following way:
-- low stock if the amount is below 20
-- moderate stock if the amount is between 20 and 50
-- high stock if the amount is over 50



-- [Question 8] from the customers table, delete the column country



-- [Question 9] find out the total no of customers in anytown without using group by and having



-- [Question 10] use DDL commands to add a column to the customers table called street. add this column directly after the address column
-- hint: google how to add a column before/after another column in MySQL 



-- [Question 11] update this column by extracting the street name from address
-- (hint: MySQL also has mid/left/right functions the same as excel. You can first test these with SELECT before using UPDATE)



-- [Question 12] Find out the number of customers per city per street. 
-- order the results in ascending order by city and then descending order by street



-- [Question 13] in the orders table, update shipping date and order date to the correct format. also change the data types of these columns to date. 
-- (try to change both columns in one update statement and one alter statement)



-- [Question 14] write a query to get order id, order date, shipping date and difference in days between order date and shipping date for each order
-- (google which function in MySQL can help you do this)
-- what do you observe in the results?



-- [Question 15] find out items priced higher than the avg price of all items (hint: you will need to use a subquery here)



-- [Question 16] using inner joins, get customer_id, first_name, last_name, order_id, order_date, item_id, item_name and item_price
-- (hint: you will need to join all three tables)




-- 