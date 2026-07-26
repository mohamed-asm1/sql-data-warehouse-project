/*
===============================================================================
Stored Procedure: silver.silver_load
===============================================================================
Purpose:
    This stored procedure loads data from the Bronze layer into the Silver layer of the Data Warehouse.

Description:
    The procedure performs the following tasks:
        - Truncates all Silver layer tables to remove existing data.
        - Extracts data from the Bronze layer tables.
        - Cleans and transforms the data by:
            * Removing duplicate customer records.
            * Trimming leading and trailing spaces.
            * Standardizing gender and marital status values.
            * Extracting product category and product keys.
            * Calculating product end dates.
            * Validating and correcting order, shipping, and due dates.
            * Recalculating invalid sales and price values.
            * Standardizing country names and gender values.
            * Handling missing or invalid data using business rules.
        - Loads the transformed data into the corresponding Silver tables.
        - Measures and prints the execution time for each table load and the total loading duration.
        - Implements TRY...CATCH error handling to report any errors that occur during execution.

Source Tables (Bronze Layer):
    - bronze.crm_cust_info
    - bronze.crm_prd_info
    - bronze.crm_sales_details
    - bronze.erp_CUST_AZ12
    - bronze.erp_LOC_A101
    - bronze.erp_PX_CAT_G1V2

Target Tables (Silver Layer):
    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_sales_details
    - silver.erp_CUST_AZ12
    - silver.erp_LOC_A101
    - silver.erp_PX_CAT_G1V2
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.silver_load AS
BEGIN
    DECLARE @start_time DATETIME , @end_time DATETIME, @load_start_time DATETIME, @load_end_time DATETIME;
    BEGIN TRY
        SET @load_start_time = GETDATE();
        PRINT '===================================================';
        PRINT 'Loading Silver Layer';
        PRINT '===================================================';
        
        PRINT '---------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '---------------------------------------------------';
        
        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.crm_cust_info'
        TRUNCATE TABLE silver.crm_cust_info;

        PRINT '>>Inserting Data Into: silver.crm_cust_info'
        INSERT INTO silver.crm_cust_info (
            cst_id,
                cst_key,
                cst_firstname,
                cst_lastname,
                cst_marital_status,
                cst_gndr,
                cst_create_date
        ) 
        SELECT
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_marital_status,
            cst_gndr,
            cst_create_date
        FROM (
            SELECT 
                cst_id,
                cst_key,
                TRIM(cst_firstname) AS cst_firstname,
                TRIM(cst_lastname) AS cst_lastname,
                CASE
                    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                    ELSE 'Unknown'
                END AS cst_marital_status,
                CASE
                    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                    ELSE 'Unknown'
                END AS cst_gndr,
                cst_create_date,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS cst_creation_rank
            FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL)t
        WHERE cst_creation_rank = 1;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.crm_prd_info'
        TRUNCATE TABLE silver.crm_prd_info;

        PRINT '>>Inserting Data Into: silver.crm_prd_info'
        INSERT INTO silver.crm_prd_info (
            prd_id ,
            cat_id	,
            prd_key	,
            prd_nm	,
            prd_cost ,
            prd_line ,
            prd_start_dt ,
            prd_end_dt
        )
        SELECT 
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, --Extract Category ID
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        --Extract Product Key
            prd_nm,
            COALESCE(prd_cost, 0) AS prd_cost,
            CASE
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'Unknown'
            END AS prd_line, --Map product line codes to descriptive values
            prd_start_dt,
            --Calculate end date as one day before next start date
            DATEADD(DAY, -1, LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt))  AS prd_end_dt 
        FROM bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.crm_sales_details'
        TRUNCATE TABLE silver.crm_sales_details;

        PRINT '>>Inserting Data Into: silver.crm_sales_details'
        INSERT INTO silver.crm_sales_details (
            sls_ord_num	,
            sls_prd_key	,
            sls_cust_id	,
            sls_order_dt ,
            sls_ship_dt	,
            sls_due_dt ,
            sls_sales ,
            sls_quantity ,
            sls_price 
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE
                WHEN LEN(sls_order_dt) !=8 THEN NULL
                WHEN sls_order_dt < 20100101 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE) 
            END AS sls_order_dt,
            CASE
                WHEN LEN(sls_ship_dt) !=8 THEN NULL
                WHEN sls_ship_dt < sls_order_dt THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE) 
            END AS sls_ship_dt,
            CASE
                WHEN LEN(sls_due_dt) !=8 THEN NULL
                WHEN sls_due_dt < sls_order_dt THEN NULL
                ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE) 
            END AS sls_due_dt,
            CASE
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales, --Recalculate sales if original value is missing or incorrect
            sls_quantity,
            CASE
                WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price --Derive price if original value is invalid
        FROM bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.erp_CUST_AZ12'
        TRUNCATE TABLE silver.erp_CUST_AZ12;

        PRINT '>>Inserting Data Into: silver.erp_CUST_AZ12'
        INSERT INTO silver.erp_CUST_AZ12 (
            cid,
            bdate,
            gen
        )
        SELECT 
            CASE 
                WHEN LEN(cid) > 10 THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,
            CASE --Remove invalid prefix if exists
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate, --Set future birthdates to NULL
            CASE 
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'Unknown'
            END AS gen --Normalize gender values and handl unknown cases
        FROM bronze.erp_CUST_AZ12;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.erp_LOC_A101'
        TRUNCATE TABLE silver.erp_LOC_A101;

        PRINT '>>Inserting Data Into: silver.erp_LOC_A101'
        INSERT INTO silver.erp_LOC_A101 (
            cid,
            cntry
        )
        SELECT 
            REPLACE(cid, '-', '') AS cid,
            CASE 
                WHEN UPPER(TRIM(cntry)) IN ('US','USA') THEN 'United States'
                WHEN UPPER(TRIM(cntry)) ='DE' THEN 'Germany'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
                ELSE TRIM(cntry)
            END AS cntry --Normalize and handle missing or blank country codes
        FROM bronze.erp_LOC_A101 ;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        PRINT '---------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>>Truncating Table: silver.erp_PX_CAT_G1V2 '
        TRUNCATE TABLE silver.erp_PX_CAT_G1V2;

        PRINT '>>Inserting Data Into: silver.erp_PX_CAT_G1V2 '
        INSERT INTO silver.erp_PX_CAT_G1V2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT 
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_PX_CAT_G1V2;
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
        SET @load_end_time = GETDATE();
        PRINT '---------------------------------------------------';
        PRINT '>>>Total Silver Load Duration: ' + CAST(DATEDIFF(SECOND, @load_start_time, @load_end_time) AS NVARCHAR) + ' Seconds';
    END TRY 
  	BEGIN CATCH
      	PRINT '===================================================';
      	PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
      	PRINT '===================================================';
      	PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
      	PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
      	PRINT 'ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR);
  
        THROW;
    END CATCH
END;
GO

EXEC silver.silver_load;
