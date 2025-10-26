/*
	------------------------------------------------------
	DDL Script: Create bronze Tables
	------------------------------------------------------
	Script Purpose:
		This script creates table in 'bronze' schema, dropping existing tables
		if they already exist.
		Run this script to re-define DDL structure of 'bronze' tables
*/

		IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
			DROP TABLE bronze.crm_cust_info;
GO
  
		CREATE TABLE bronze.crm_cust_info
		(
			cst_id INT,
			cst_key NVARCHAR(50),
			cst_firstname NVARCHAR(50),
			cst_lastname NVARCHAR(50),
			cst_material_status NVARCHAR(50),
			cst_gender NVARCHAR(50),
			cst_create_date DATE
		);
GO

		IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
			DROP TABLE bronze.crm_prd_info;
		CREATE TABLE bronze.crm_prd_info
		(
			prd_id INT,
			prd_key NVARCHAR(50),
			prd_nm NVARCHAR(50),
			prd_cost INT,
			prd_line NVARCHAR(50),
			prd_start_dt NVARCHAR(50),
			prd_end_dt NVARCHAR(50)
		);
GO

		IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
			DROP TABLE  bronze.crm_sales_details;
GO
  
		CREATE TABLE bronze.crm_sales_details
		(
			sls_ord_num NVARCHAR(50),
			sls_prd_key NVARCHAR(50),
			sls_cust_id INT,
			sls_order_dt INT,
			sls_ship_dt INT,
			sls_due_dt INT,
			sls_sales INT,
			sls_quantity INT,
			sls_price INT
		);
GO

		IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
			DROP TABLE  bronze.erp_cust_az12;
GO
  
		CREATE TABLE bronze.erp_cust_az12
		(
			cid NVARCHAR(50),
			bdate NVARCHAR(50),
			gen NVARCHAR(50)
		);
GO


		IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
			DROP TABLE  bronze.erp_loc_a101;
GO
  
		CREATE TABLE bronze.erp_loc_a101
		(
			cid NVARCHAR(50),
			cntry NVARCHAR(50)
		);
GO


    IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
			DROP TABLE  bronze.erp_px_cat_g1v2;
GO
  
		CREATE TABLE bronze.erp_px_cat_g1v2
		(
			id NVARCHAR(50),
			cat NVARCHAR(50),
			subcat NVARCHAR(50),
			maintenance NVARCHAR(50)
		);
GO
	

		PRINT'--------------------------';
		PRINT'BRONZE CRM LAYERS';
		PRINT'--------------------------';

GO
		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.crm_cust_info <<<';
		TRUNCATE TABLE bronze.crm_cust_info
		--truncate help the table to not store data again & again when we are executing the query multiple times
		PRINT'>>> INSERTING DATA INTO: bronze.crm_cust_info';
GO  
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>> Load Duration : ' + CAST(DATEDIFF(second, @start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '-------------';
GO
  
		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info
		PRINT'>>> INSERTING DATA INTO: bronze.crm_prd_info';
GO
		BULK INSERT  bronze.crm_prd_info
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF (second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------';
GO
		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details
		PRINT'>>> INSERTING DATA INTO: bronze.crm_sales_details';
GO
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST( DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
		PRINT '-----------';
GO
  
		PRINT'--------------------------';
		PRINT'BRONZE ERP LAYERS';
		PRINT'--------------------------';

GO
		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12
		PRINT'>>> INSERTING DATA INTO: bronze.erp_cust_az12';
GO
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF (second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------';

GO
		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101
    PRINT'>>> INSERTING DATA INTO: bronze.erp_loc_a101';
GO
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
    SET @end_time = GETDATE();
		PRINT 'Load Duration: ' + CAST(DATEDIFF (second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT '-----------';
GO

		SET @start_time = GETDATE();
		PRINT'>>> TRUNCATING THE TABLE: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
    PRINT'>>> INSERTING DATA INTO: bronze.erp_px_cat_g1v2';
GO
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\DELL\OneDrive\Documents\SQL SERVER WITH PROJECTS\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);

