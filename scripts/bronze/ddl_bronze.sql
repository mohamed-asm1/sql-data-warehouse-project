/*
================================================================
Create Bronze Layer Tables
================================================================
Script Purpose:
    This script creates the tables required for the Bronze layer of the 'DataWarehouse' database.
    Before creating each table, it checks whether the table already exists and drops it if necessary. 
    This ensures that the Bronze schema is recreated with a clean structure, ready to receive raw
    data from the source systems.
    The tables created in this script store raw CRM and ERP data without any transformations or
    business rules applied.

Warning:
    Running this script will permanently delete and recreate all existing tables in the Bronze schema. 
    Any data currently stored in these tables will be lost. 
    Ensure that you have appropriate backups or that the data can be reloaded from the original source 
    systems before executing this script.
*/

-- Create 'crm_cust_info' table
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	  DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info(
  	cst_id INT,
  	cst_key	NVARCHAR(50),
  	cst_firstname NVARCHAR(50),
  	cst_lastname NVARCHAR(50),
  	cst_marital_status NVARCHAR(50),
  	cst_gndr NVARCHAR(50),
  	cst_create_date DATE
  );

-- Create 'crm_prd_info' table
IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	  DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
  	prd_id INT,
  	prd_key	NVARCHAR(50),
  	prd_nm	NVARCHAR(50),
  	prd_cost INT,
  	prd_line NVARCHAR(50),
  	prd_start_dt DATE,
  	prd_end_dt DATE
);

-- Create 'crm_sales_details' table
IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	  DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
  	sls_ord_num	NVARCHAR(50),
  	sls_prd_key	NVARCHAR(50),
  	sls_cust_id	INT,
  	sls_order_dt INT,
  	sls_ship_dt	INT,
  	sls_due_dt INT,
  	sls_sales INT,
  	sls_quantity INT,
  	sls_price INT
);

-- Create 'erp_CUST_AZ12' table
IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
	  DROP TABLE bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12(
  	cid	NVARCHAR(50),
  	bdate DATE,
  	gen NVARCHAR(50)
);

-- Create 'erp_LOC_A101' table
IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
	  DROP TABLE bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101(
  	cid	NVARCHAR(50),
  	cntry NVARCHAR(50)
);

-- Create 'erp_PX_CAT_G1V2' table    
IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	  DROP TABLE bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2(
  	id NVARCHAR(50),
  	cat NVARCHAR(50),
  	subcat NVARCHAR(50),
  	maintenance NVARCHAR(50)
);
