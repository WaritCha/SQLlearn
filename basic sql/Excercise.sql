-- Here are some of the exercises for which you can write SQL queries to self evaluate using all the concepts we have learnt to write SQL Queries.
-- * All the exercises are based on retail tables.
-- * We have already setup the tables and also populated the data.
-- * We will use all the 6 tables in retail database as part of these exercises.

-- Here are the commands to validate the tables
SELECT count(*) FROM departments;
SELECT count(*) FROM categories;
SELECT count(*) FROM products;
SELECT count(*) FROM orders;
SELECT count(*) FROM order_items;
SELECT count(*) FROM customers;

-- ### Exercise 1 - Customer order count

-- Get order count per customer for the month of 2014 January.

-- * Tables - `orders` and `customers`
-- * Data should be sorted in descending order by count and ascending order by customer id.
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname` and `customer_order_count`.

select customer_id, customer_fname , customer_lname,
	count(*) as customer_order_count
from customers as c
	join orders as o on c.customer_id = o.order_customer_id
where (to_char(o.order_date, 'yyyy-MM') = '2014-01') 
group by 1,2,3
order by 4 desc


-- ### Exercise 2 - Dormant Customers

-- Get the customer details who have not placed any order for the month of 2014 January.
-- * Tables - `orders` and `customers`
-- * Output Columns - **All columns from customers as is**
-- * Data should be sorted in ascending order by `customer_id`
-- * Output should contain all the fields from `customers`
-- * Make sure to run below provided validation queries and validate the output.

select count(*) from customers --to get number of all customers as X

SELECT count(DISTINCT order_customer_id)
FROM orders
WHERE to_char(order_date, 'yyyy-MM') = '2014-01'; --to get number of customer who ordered on 2014-01 as Y

-- Our result should be X - Y
--There are 2 ways to do this

-- 1. filter after full outer join
SELECT count(*)
FROM customers;

-- Get the difference
-- Get the count using solution query, both the difference and this count should match

-- * Hint: You can use `NOT IN` or `NOT EXISTS` or `OUTER JOIN` to solve this problem.

select c.*
from customers as c
	full OUTER join orders as o on c.customer_id = o.order_customer_id	
			AND (to_char(o.order_date, 'yyyy-MM') = '2014-01') 

WHERE o.order_customer_id is null
order by 1

--2. Or using not exists command
select c.*
from customers as c
where not exists(
	select o.order_customer_id
	from orders as o 
	where c.customer_id = o.order_customer_id	
			AND (to_char(o.order_date, 'yyyy-MM') = '2014-01') )
order by 1

-- ### Exercise 3 - Revenue Per Customer

-- Get the revenue generated by each customer for the month of 2014 January
-- * Tables - `orders`, `order_items` and `customers`
-- * Data should be sorted in descending order by revenue and then ascending order by `customer_id`
-- * Output should contain `customer_id`, `customer_fname`, `customer_lname`, `customer_revenue`.
-- * If there are no orders placed by customer, then the corresponding revenue for a given customer should be 0.
-- * Consider only `COMPLETE` and `CLOSED` orders

select c.customer_id,c.customer_fname,c.customer_lname, 
   COALESCE(round(sum(order_item_subtotal::numeric),2), 0)as customer_revenue
    from orders as o    
    FULL OUTER JOIN customers as c on o.order_customer_id = c.customer_id
        full outer join order_items as oi on o.order_id = oi.order_item_order_id
        FULL OUTER JOIN products as p on oi.order_item_product_id = p.product_id
        FULL OUTER JOIN categories as cat p.product_category_id = cat.category_id
        and to_char(o.order_date,'yyyy-MM') = '2014-01' 
        and o.order_status in ('COMPLETE','CLOSED')
GROUP BY 1,2,3
order by 4 desc,1;

-- ### Exercise 4 - Revenue Per Category

-- Get the revenue generated for each category for the month of 2014 January
-- * Tables - `orders`, `order_items`, `products` and `categories`
-- * Data should be sorted in ascending order by `category_id`.
-- * Output should contain all the fields from `categories` along with the revenue as `category_revenue`.
-- * Consider only `COMPLETE` and `CLOSED` orders

-- ### Exercise 5 - Product Count Per Department

-- Get the count of products for each department.
-- * Tables - `departments`, `categories`, `products`
-- * Data should be sorted in ascending order by `department_id`
-- * Output should contain all the fields from `departments` and the product count as `product_count`
