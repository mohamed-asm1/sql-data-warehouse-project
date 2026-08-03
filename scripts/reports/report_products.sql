/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH cte_base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
	SELECT 
		fs.order_number,
		fs.order_date,
		fs.sales_amount,
		fs.quantity,
		dp.product_key,
		dp.product_name,
		dp.category,
		dp.subcategory,
		dp.cost
	FROM gold.fact_sales AS fs
	LEFT JOIN gold.dim_products AS dp
	ON fs.product_key = dp.product_key
	WHERE fs.order_date IS NOT NULL
),

cte_product_aggregation AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
	SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity_sold
	FROM cte_base_query
	GROUP BY product_key, product_name, category, subcategory, cost
)

SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
	lifespan,
	total_orders,
	total_sales,
	total_quantity_sold,
	--Compute average order revenue
	CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
	END AS average_order_value,
	--Compute average monthly revenue
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales / lifespan
	END AS average_monthly_spend,
	CASE 
		WHEN total_sales > 500000 THEN 'High Performer'
		WHEN total_sales >= 100000 THEN 'Mid-Range'
		ELSE 'Low Performer'
	END AS product_segment
FROM cte_product_aggregation