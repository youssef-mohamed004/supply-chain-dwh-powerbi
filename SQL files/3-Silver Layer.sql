
/* =========================================================================
   PROJECT: DataCo Supply Chain Data Warehouse
   LAYER  : Silver Layer — Data Cleaning & Transformation
   PURPOSE: Transform raw Bronze data into clean, standardized, and
            structured Silver tables.

            This layer focuses on:
            - Data Type Conversion using TRY_CAST.
            - Removing leading/trailing spaces and repeated spaces.
            - Standardizing text values and categorical attributes.
            - Combining customer and salesman names.
            - Normalizing business categories and shipping modes.
            - Filtering records with invalid primary identifiers.
            - Defining Primary Keys to ensure entity uniqueness.

            The final Silver tables provide reliable and consistent data
            ready for the Gold Layer.
   ========================================================================= */


-- =========================================================================
-- ========= Step 1: Customers Transformation ==============================
-- =========================================================================

-- 1.1 Data Cleaning & Transformation
--     - Convert Customer_Id into BIGINT.
--     - Combine Customer_Fname and Customer_Lname into Full_Name.
--     - Clean customer names and descriptive attributes.
--     - Remove leading/trailing spaces and normalize repeated spaces.
--     - Convert Latitude and Longitude into DECIMAL(9,6).
--     - Convert Customer_Birth_Date into DATE.
--     - Exclude records with invalid Customer_Id.

SELECT 
    TRY_CAST([Customer_Id] AS BIGINT) AS Customer_Id,
    CONCAT_WS(' ', NULLIF(N.C_FNAME, ''), NULLIF(N.C_LNAME, '')) AS Full_Name,
    N.C_SEGMENT AS customer_segment,
    N.C_CITY AS city,
    N.C_STATE AS state,
    LTRIM(RTRIM(Customer_Street)) AS street,
    LTRIM(RTRIM(Customer_Zipcode)) AS zipcode,
    N.C_COUNTRY AS country,
    TRY_CAST([Latitude] AS DECIMAL(9,6)) AS Latitude,
    TRY_CAST([Longitude] AS DECIMAL(9,6)) AS Longitude,
    TRY_CAST([Customer_Birth_Date] AS DATE) AS Customer_Birth_Date
INTO Silver.Customers
FROM Bronze.Customers
CROSS APPLY(
    SELECT
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_Fname])), '  ' , ' ' ),'  ' , ' ')AS C_FNAME,
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_Lname])) , '  ' ,' '), '  ', ' ') AS C_LNAME,
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_Segment])) , '  ' ,' '), '  ', ' ')AS C_SEGMENT,
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_City])) , '  ' ,' '), '  ', ' ')AS C_CITY,
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_State])) , '  ' ,' '), '  ', ' ')AS C_STATE,
        REPLACE(REPLACE(LTRIM(RTRIM([Customer_Country])) , '  ' ,' '), '  ', ' ')AS C_COUNTRY
        ) N
WHERE TRY_CAST([Customer_Id] AS BIGINT) IS NOT NULL;


-- 1.2 Primary Key Definition
--     - Enforce NOT NULL constraint on Customer_Id.
--     - Define Customer_Id as the Primary Key.

ALTER TABLE Silver.Customers
ALTER COLUMN Customer_Id BIGINT NOT NULL;
GO

ALTER TABLE Silver.Customers
ADD CONSTRAINT PK_Sliver_Customer PRIMARY KEY (Customer_Id);


-- =========================================================================
-- ========= Step 2: Orders Transformation =================================
-- =========================================================================

-- 2.1 Data Cleaning & Transformation
--     - Convert identifiers and numerical attributes into appropriate
--       data types using TRY_CAST.
--     - Standardize text casing across categorical columns.
--     - Normalize repeated spaces in descriptive attributes.
--     - Standardize Market values into consistent business categories.
--     - Normalize Order_Status values by replacing underscores.
--     - Standardize Shipping_Mode values into consistent categories.
--     - Convert order and shipping dates into DATETIME2(0).
--     - Exclude records with invalid Order_Item_Id.

SELECT 
    TRY_CAST(LTRIM(RTRIM([Order_Id])) AS INT) AS [Order_Id],
    TRY_CAST(LTRIM(RTRIM([Order_Item_Id])) AS INT) AS [Order_Item_Id],
    TRY_CAST(LTRIM(RTRIM([Customer_Id])) AS INT) AS [Customer_Id],
    TRY_CAST(LTRIM(RTRIM([Product_Card_Id])) AS INT) AS [Product_Card_Id],
    UPPER(LEFT(c.ty, 1)) + LOWER(SUBSTRING(c.ty, 2, LEN(c.ty))) AS [Type],
    TRY_CAST(LTRIM(RTRIM([Days_for_shipping_real])) AS INT) AS [Days_for_shipping_real],
    TRY_CAST(LTRIM(RTRIM([Days_for_shipment_scheduled])) AS INT) AS [Days_for_shipment_scheduled],
    TRY_CAST(LTRIM(RTRIM([Benefit_per_order])) AS DECIMAL(18,2)) AS [Benefit_per_order],
    UPPER(LEFT(c.ds, 1)) + LOWER(SUBSTRING(c.ds, 2, LEN(c.ds))) AS [Delivery_Status],
    TRY_CAST(LTRIM(RTRIM([Late_delivery_risk])) AS BIT) AS [Late_delivery_risk],
    CASE WHEN UPPER(c.mk) IN ('LATAM', 'LATIN AMERICA') THEN 'LATAM'
         WHEN UPPER(c.mk) IN ('EU', 'EUROPE') THEN 'Europe'
         WHEN UPPER(c.mk) IN ('APAC', 'PACIFIC ASIA' ,'ASIA-PACIFIC' ) THEN 'Pacific Asia'
         WHEN UPPER(c.mk) IN ('USCA', 'U.S.-CANADA' ,'US & CANADA' ,'US AND CANADA') THEN 'USCA'
         WHEN UPPER(c.mk) IN ('AFR', 'AFRICA') THEN 'Africa'
         ELSE UPPER(LEFT(c.mk, 1)) + LOWER(SUBSTRING(c.mk, 2, LEN(c.mk))) END AS [Market],
    UPPER(LEFT(c.rg, 1)) + LOWER(SUBSTRING(c.rg, 2, LEN(c.rg))) AS [Order_Region],
    UPPER(LEFT(c.st, 1)) + LOWER(SUBSTRING(c.st, 2, LEN(c.st))) AS [Order_State],
    UPPER(LEFT(c.os, 1)) + LOWER(SUBSTRING(c.os, 2, LEN(c.os))) AS [Order_Status],
    [Order_Zipcode],
    TRY_CAST(LTRIM(RTRIM([order_date_DateOrders])) AS DATETIME2(0)) AS [order_date_DateOrders],
    TRY_CAST(LTRIM(RTRIM([shipping_date_DateOrders])) AS DATETIME2(0)) AS [shipping_date_DateOrders],
    CASE
        WHEN UPPER(LEFT(c.sm, 1)) + LOWER(SUBSTRING(c.sm, 2, LEN(c.sm))) IN('Standard class' ,'Std class' , 'Standard') THEN 'Standard class'
        WHEN UPPER(LEFT(c.sm, 1)) + LOWER(SUBSTRING(c.sm, 2, LEN(c.sm))) IN('1st class' ,'First class') THEN 'First class'            
        WHEN UPPER(LEFT(c.sm, 1)) + LOWER(SUBSTRING(c.sm, 2, LEN(c.sm))) IN('2nd class' ,'Second class') THEN 'Second class'
        WHEN UPPER(LEFT(c.sm, 1)) + LOWER(SUBSTRING(c.sm, 2, LEN(c.sm))) IN('Same-day' ,'Same day') THEN 'Same day'
        ELSE UPPER(LEFT(c.sm, 1)) + LOWER(SUBSTRING(c.sm, 2, LEN(c.sm))) END AS [Shipping_Mode],
    TRY_CAST(LTRIM(RTRIM([Order_Item_Discount])) AS DECIMAL(18,2)) AS [Order_Item_Discount],
    TRY_CAST(LTRIM(RTRIM([Order_Item_Profit_Ratio])) AS DECIMAL(9,4)) AS [Order_Item_Profit_Ratio],
    TRY_CAST(LTRIM(RTRIM([Order_Item_Quantity])) AS INT) AS [Order_Item_Quantity],
    TRY_CAST(LTRIM(RTRIM([Order_Item_Total])) AS DECIMAL(18,2)) AS [Order_Item_Total],
    TRY_CAST(LTRIM(RTRIM([salesman_id])) AS INT) AS [salesman_id]
INTO Silver.Orders
FROM Bronze.Orders
CROSS APPLY (
    SELECT
        REPLACE(REPLACE(LTRIM(RTRIM([Type])),            '  ', ' '), '  ', ' ') AS ty,
        REPLACE(REPLACE(LTRIM(RTRIM([Delivery_Status])), '  ', ' '), '  ', ' ') AS ds,
        REPLACE(REPLACE(LTRIM(RTRIM([Market])),          '  ', ' '), '  ', ' ') AS mk,
        REPLACE(REPLACE(LTRIM(RTRIM([Order_Region])),    '  ', ' '), '  ', ' ') AS rg,
        REPLACE(REPLACE(LTRIM(RTRIM([Order_State])),     '  ', ' '), '  ', ' ') AS st,
        REPLACE(REPLACE(REPLACE(LTRIM(RTRIM([Order_Status])), '_', ' '), '  ', ' '), '  ', ' ') AS os,
        REPLACE(REPLACE(LTRIM(RTRIM([Shipping_Mode])),   '  ', ' '), '  ', ' ') AS sm
) c
WHERE TRY_CAST(LTRIM(RTRIM([Order_Item_Id])) AS INT) IS NOT NULL;


-- 2.2 Primary Key Definition
--     - Enforce NOT NULL constraint on Order_Item_Id.
--     - Define Order_Item_Id as the Primary Key.

ALTER TABLE Silver.Orders
ALTER COLUMN [Order_Item_Id] INT NOT NULL;

ALTER TABLE Silver.Orders
ADD CONSTRAINT Pk_Silver_Orders PRIMARY KEY ([Order_Item_Id]);

-- 2.3 Drop Coulmn
ALTER TABLE Silver.Orders
DROP COLUMN [Order_Zipcode]
-- =========================================================================
-- ========= Step 3: Products Transformation ===============================
-- =========================================================================

-- 3.1 Data Cleaning & Transformation
--     - Convert Product_Card_Id, Category_Id, and Department_Id into INT.
--     - Convert Product_Price into DECIMAL(18,2).
--     - Convert Product_Status into BIT.
--     - Clean Product_Name, Category_Name, and Department_Name.
--     - Remove leading/trailing spaces and normalize repeated spaces.
--     - Exclude records with invalid Product_Card_Id.

SELECT
    TRY_CAST(LTRIM(RTRIM([Product_Card_Id])) AS INT) AS [Product_Card_Id],
    k.PN AS [Product_Name],
    TRY_CAST(LTRIM(RTRIM([Product_Price])) AS decimal(18 , 2)) AS [Product_Price],
    TRY_CAST(LTRIM(RTRIM([Product_Status]))AS BIT) AS [Product_Status],
    [Product_Description],
    TRY_CAST(LTRIM(RTRIM([Category_Id])) AS INT) AS [Category_Id],
    k.CN AS [Category_Name],
    TRY_CAST(LTRIM(RTRIM([Department_Id])) AS INT) AS [Department_Id],
    k.DN AS [Department_Name]
INTO Silver.Products
FROM Bronze.Products
CROSS APPLY(
    SELECT
        REPLACE(REPLACE(LTRIM(RTRIM([Product_Name])) , '  ' ,' '), '  ', ' ') AS PN,
        REPLACE(REPLACE(LTRIM(RTRIM([Category_Name])) , '  ' ,' '), '  ', ' ') AS CN,
        REPLACE(REPLACE(LTRIM(RTRIM([Department_Name])) , '  ' ,' '), '  ', ' ') AS DN
) k
WHERE TRY_CAST(LTRIM(RTRIM([Product_Card_Id])) AS INT) IS NOT NULL;


-- 3.2 Primary Key Definition
--     - Enforce NOT NULL constraint on Product_Card_Id.
--     - Define Product_Card_Id as the Primary Key.

ALTER TABLE Silver.Products
ALTER COLUMN [Product_Card_Id] INT NOT NULL

ALTER TABLE Silver.Products
ADD CONSTRAINT Pk_Silver_Product PRIMARY KEY([Product_Card_Id]);

-- 3.3 Drop Coulmn
ALTER TABLE Silver.Products
DROP COLUMN [Product_Description]
-- =========================================================================
-- ========= Step 4: Salesman Transformation ===============================
-- =========================================================================

-- 4.1 Data Cleaning & Transformation
--     - Convert Salesman_Id into INT.
--     - Combine Salesman_Fname and Salesman_Lname into Full_Name.
--     - Clean and standardize Salesman_Email, Market, and Region.
--     - Remove leading/trailing spaces and normalize repeated spaces.
--     - Convert Hire_Date into DATE.
--     - Convert Commission_Rate into DECIMAL(5,4).
--     - Exclude records with invalid Salesman_Id.

SELECT
    TRY_CAST(LTRIM(RTRIM([Salesman_Id])) AS INT ) AS [Salesman_Id],
    CONCAT_WS(' ', NULLIF(m.S_FNAME, ''), NULLIF(m.S_LNAME, '')) AS Full_Name,
    m.S_EMAIL AS [Salesman_Email],
    m.S_MARKET AS [Salesman_Market],
    m.S_REGION AS [Salesman_Region],
    TRY_CAST(LTRIM(RTRIM([Hire_Date])) AS date) AS [Hire_Date],
    TRY_CAST(LTRIM(RTRIM([Commission_Rate]))AS decimal(5 , 4)) AS [Commission_Rate]
INTO Silver.Salesman
FROM Bronze.Salesman
CROSS APPLY(
    SELECT
        REPLACE(REPLACE(LTRIM(RTRIM([Salesman_Fname])) , '  ',' '),'  ',' ') AS S_FNAME,
        REPLACE(REPLACE(LTRIM(RTRIM([Salesman_Lname])) , '  ',' '),'  ',' ') AS S_LNAME,
        REPLACE(REPLACE(LTRIM(RTRIM([Salesman_Email])) , '  ',' '),'  ',' ') AS S_EMAIL,
        REPLACE(REPLACE(LTRIM(RTRIM([Market])) , '  ',' '),'  ',' ') AS S_MARKET,
        REPLACE(REPLACE(LTRIM(RTRIM([Region])) , '  ',' '),'  ',' ') AS S_REGION
) m
WHERE TRY_CAST(LTRIM(RTRIM([Salesman_Id])) AS INT ) IS NOT NULL;


-- 4.2 Primary Key Definition
--     - Enforce NOT NULL constraint on Salesman_Id.
--     - Define Salesman_Id as the Primary Key.

ALTER TABLE Silver.Salesman
ALTER COLUMN [Salesman_Id] INT NOT NULL

ALTER TABLE Silver.Salesman
ADD CONSTRAINT Pk_Silver_Salesman PRIMARY KEY([Salesman_Id]);


-- =========================================================================
-- ========= Step 5: Row Counts Check ======================================
-- =========================================================================
-- Compare the number of records between Bronze and Silver tables
-- to verify the results of the transformation process.
-- Any difference in row counts should be reviewed to identify
-- records excluded due to invalid identifiers.

-- 5.1 Customers
SELECT COUNT(*)
FROM Bronze.Customers;

SELECT COUNT(*)
FROM [Silver].[Customers]

-- 5.2 Orders
SELECT COUNT(*) 
FROM bronze.Orders;

SELECT COUNT(*)
FROM [Silver].[Orders]

-- 5.3 Products
SELECT COUNT(*) 
FROM bronze.products;

SELECT COUNT(*)
FROM [Silver].[Products]

-- 5.4 Salesman
SELECT COUNT(*) 
FROM bronze.Salesman;

SELECT COUNT(*)
FROM [Silver].[Salesman]
