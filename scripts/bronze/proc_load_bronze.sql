/*
================================================================
Load Data into Bronze Layer
================================================================
Script Purpose:
    This stored procedure loads raw data from CRM and ERP CSV files
    into the Bronze layer of the DataWarehouse.

Process:
    - Records the start time of the load process.
    - Truncates each Bronze table to remove existing data.
    - Loads fresh data from the source CSV files using BULK INSERT.
    - Measures and displays the load duration for each table.
    - Displays the total execution time for the entire Bronze load.
    - Implements TRY...CATCH error handling to capture and report
      any errors encountered during execution.

Notes:
    - This procedure performs a full refresh of the Bronze layer.
    - Source files must exist at the configured file paths.
    - SQL Server must have permission to access the source files.
================================================================
*/

CREATE OR ALTER PROCEDURE bronze.bronze_load AS
BEGIN
	  DECLARE @start_time DATETIME , @end_time DATETIME, @load_start_time DATETIME, @load_end_time DATETIME;
	  BEGIN TRY
    		SET @load_start_time = GETDATE();
    		PRINT '===================================================';
    		PRINT 'Loading Bronze Layer';
    		PRINT '===================================================';
    
    		PRINT '---------------------------------------------------';
    		PRINT 'Loading CRM Tables';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.crm_cust_info';
    		TRUNCATE TABLE bronze.crm_cust_info;
    
    		PRINT '>>Inserting Data Into: bronze.crm_cust_info';
    		BULK INSERT bronze.crm_cust_info
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.crm_prd_info';
    		TRUNCATE TABLE bronze.crm_prd_info;
    
    		PRINT '>>Inserting Data Into: bronze.crm_prd_info';
    		BULK INSERT bronze.crm_prd_info
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.crm_sales_details';
    		TRUNCATE TABLE bronze.crm_sales_details;
    
    		PRINT '>>Inserting Data Into: bronze.crm_sales_details';
    		BULK INSERT bronze.crm_sales_details
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT 'Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    
    		PRINT '---------------------------------------------------';
    		PRINT 'Loading CRM Tables';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.erp_CUST_AZ12';
    		TRUNCATE TABLE bronze.erp_CUST_AZ12;
    
    		PRINT '>>Inserting Data Into: bronze.erp_CUST_AZ12';
    		BULK INSERT bronze.erp_CUST_AZ12
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.erp_LOC_A101';
    		TRUNCATE TABLE bronze.erp_LOC_A101;
    
    		PRINT '>>Inserting Data Into: bronze.erp_LOC_A101';
    		BULK INSERT bronze.erp_LOC_A101
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    		PRINT '---------------------------------------------------';
    
    		SET @start_time = GETDATE();
    		PRINT '>>Truncating Table: bronze.erp_PX_CAT_G1V2';
    		TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;
    
    		PRINT '>>Inserting Data Into: bronze.erp_PX_CAT_G1V2';
    		BULK INSERT bronze.erp_PX_CAT_G1V2
    		FROM 'C:\Users\Mohamed\Desktop\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    		WITH (
    			FIRSTROW = 2,
    			FIELDTERMINATOR = ',',
    			TABLOCK
    		);
    		SET @end_time = GETDATE();
    		PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' Seconds';
    		SET @load_end_time = GETDATE();
    		PRINT '---------------------------------------------------';
    		PRINT '>>>Total Bronze Load Duration: ' + CAST(DATEDIFF(SECOND, @load_start_time, @load_end_time) AS NVARCHAR) + ' Seconds';
	  END TRY 
	  BEGIN CATCH
    		PRINT '===================================================';
    		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
    		PRINT '===================================================';
    		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
    		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    		PRINT 'ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR);
	  END CATCH
END;

EXEC bronze.bronze_load
