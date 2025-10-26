-- CRM CUSTOME INFO OPERATION

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;
GO

SELECT 
*
FROM 
bronze.crm_cust_info
WHERE cst_id = 11407;
GO

SELECT 
cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);
GO

SELECT 
cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);
GO


--CRM PRD OPERATION

SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
GO

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL
GO

SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL
GO

SELECT DISTINCT prd_line
FROM bronze.crm_prd_info
GO

SELECT 
*
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt
GO

SELECT
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) AS prd_end_dt_test
FROM bronze.crm_prd_info

SELECT prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) = 1

SELECT * 
FROM silver.crm_prd_info

-- CRM SALES INFO OPERATION

SELECT 
NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0

SELECT 
NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 

SELECT 
	CASE
		WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales 
		END,
sls_quantity,
CASE
	WHEN sls_price IS NULL OR sls_price <=0 THEN
	sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_quantity <=0 OR sls_quantity IS NULL

-- ERP CUSTOMER BDATE AND GENDER INFO

SELECT 
CASE 
	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
	END AS cid,
CASE 
	WHEN bdate >= GETDATE() THEN NULL
	ELSE bdate
	END AS bdate,
CASE 
	WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE gen
	END AS gen
FROM bronze.erp_cust_az12
WHERE gen != TRIM(gen) OR gen IS NULL OR gen ='' OR gen ='M' OR gen ='F'

-- ERP LOC A101

SELECT DISTINCT CNTRY
FROM 
bronze.erp_loc_a101

SELECT
CASE 
	WHEN TRIM(CNTRY) = 'DE' THEN 'Denmark'
	WHEN TRIM(CNTRY) IN ('USA', 'US') THEN 'United States'
	WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'N/A'
	ELSE TRIM(CNTRY)
	END 
FROM bronze.erp_loc_a101
WHERE CNTRY IS NULL

SELECT CID
FROM bronze.erp_loc_a101
WHERE CID IS NULL

SELECT * FROM silver.erp_loc_a101
