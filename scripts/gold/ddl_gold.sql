/*
===============================================================================
Create Gold Layer Views
===============================================================================

Script Purpose:
    This script creates the analytical views required for the Gold layer of the Data Warehouse.

Description:
    The Gold layer contains business-ready dimensional models that are optimized
    for reporting and analytics.

    The script performs the following tasks:

        - Drops existing Gold views if they already exist.
        - Creates the Customer Dimension (dim_customers).
        - Creates the Product Dimension (dim_products).
        - Creates the Sales Fact table as a view (fact_sales).
        - Joins cleaned Silver layer tables to produce a star schema suitable for BI tools such as 
		    Power BI and Tableau.

Gold Objects Created:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

Source Layer:
    Silver

Target Layer:
    Gold
===============================================================================
*/

-- Create Dimension: gold.dim_customers
IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
	  DROP VIEW gold.dim_customers;
CREATE VIEW gold.dim_customers AS
SELECT 
  	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
  	ci.cst_id AS customer_id,
  	ci.cst_key AS customer_number,
  	ci.cst_firstname AS first_name,
  	ci.cst_lastname AS last_name,
  	cl.cntry AS country,
  	ci.cst_marital_status AS marital_status,
  	CASE	
    		WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
    		ELSE COALESCE(ca.gen, 'Unknown')
  	END AS gender,
  	ca.bdate AS birthdate,
  	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_LOC_A101 AS cl
ON ci.cst_key = cl.cid;

-- Create Dimension: gold.dim_products
IF OBJECT_ID ('gold.dim_products', 'V') IS NOT NULL
	  DROP VIEW gold.dim_products;
CREATE VIEW gold.dim_products AS
SELECT 
  	ROW_NUMBER() over(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
  	pn.prd_id AS product_id,
  	pn.prd_key AS product_number,
  	pn.prd_nm AS product_name,
  	pn.cat_id AS category_id,
  	pc.cat AS category,
  	pc.subcat AS subcategory,
  	pc.maintenance ,
  	pn.prd_cost AS cost,
  	pn.prd_line AS product_line,
  	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_PX_CAT_G1V2 AS pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;

-- Create Fact: gold.fact_sales
IF OBJECT_ID ('gold.fact_sales', 'V') IS NOT NULL
	  DROP VIEW gold.fact_sales;
CREATE VIEW gold.fact_sales AS
SELECT 
    sd.sls_ord_num AS order_number,
    dp.product_key,
    dc.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS dp
ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
ON sd.sls_cust_id = dc.customer_id;
