/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
	DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH cte_base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT 
	fs.order_number,
	fs.product_key,
	fs.order_date,
	fs.sales_amount,
	fs.quantity,
	dc.customer_key,
	dc.customer_number,
	CONCAT(dc.first_name, ' ', dc.last_name) AS customer_name,
	DATEDIFF(year, dc.birthdate, GETDATE()) AS age,
	dc.country
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
ON fs.customer_key = dc.customer_key
WHERE fs.order_date IS NOT NULL
), 

cte_customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
	SELECT 
		customer_key,
		customer_number,
		customer_name,
		age,
		country,
        MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity_purchased,
		SUM(product_key) AS total_products
	FROM cte_base_query
	GROUP BY customer_key, customer_number, customer_name, age, country
)

SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
    country,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    lifespan,
	total_orders,
	total_sales,
    total_quantity_purchased,
	total_products,
	--Compute average order value
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
	END AS average_order_value,
    --Compute average monthly spend
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END AS average_monthly_spend,
	CASE 
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment
FROM cte_customer_aggregation 