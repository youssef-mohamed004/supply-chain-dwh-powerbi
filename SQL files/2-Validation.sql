/* =========================================================================
   PROJECT: DataCo Supply Chain Data Warehouse
   LAYER  : Bronze Layer — Data Profiling & Validation Script
   PURPOSE: Inspect raw data quality (row counts, nulls, whitespace/case 
            hygiene, type casting readiness, duplicates, orphans, & logic)
            before transforming and loading into the Silver Layer.
   ========================================================================= */

-- =========================================================================
-- ========= Step 0: Raw Data Preview (Initial Inspection) =================
-- =========================================================================

-- 0.1 Customers
SELECT *
FROM Bronze.Customers;

-- 0.2 Orders
SELECT * 
FROM bronze.Orders;

-- 0.3 Products
SELECT * 
FROM bronze.products;

-- 0.4 Salesman
SELECT * 
FROM bronze.Salesman;


-- =========================================================================
-- ========= Step 1: Row Counts Check ======================================
-- =========================================================================

-- 1.1 Customers
SELECT COUNT(*)
FROM Bronze.Customers;

-- 1.2 Orders
SELECT COUNT(*) 
FROM bronze.Orders;

-- 1.3 Products
SELECT COUNT(*) 
FROM bronze.products;

-- 1.4 Salesman
SELECT COUNT(*) 
FROM bronze.Salesman;


-- =========================================================================
-- ========= Step 2: NULLs, Blanks & Placeholder Strings Check =============
-- =========================================================================

-- 2.1 Customers
SELECT
    SUM(CASE WHEN Customer_Id         IS NULL OR LTRIM(RTRIM(Customer_Id))         IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Id,
    SUM(CASE WHEN Customer_Fname      IS NULL OR LTRIM(RTRIM(Customer_Fname))      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Fname,
    SUM(CASE WHEN Customer_Lname      IS NULL OR LTRIM(RTRIM(Customer_Lname))      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Lname,
    SUM(CASE WHEN Customer_Segment    IS NULL OR LTRIM(RTRIM(Customer_Segment))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Segment,
    SUM(CASE WHEN Customer_City       IS NULL OR LTRIM(RTRIM(Customer_City))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_City,
    SUM(CASE WHEN Customer_State      IS NULL OR LTRIM(RTRIM(Customer_State))      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_State,
    SUM(CASE WHEN Customer_Street     IS NULL OR LTRIM(RTRIM(Customer_Street))     IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Street,
    SUM(CASE WHEN Customer_Zipcode    IS NULL OR LTRIM(RTRIM(Customer_Zipcode))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Zipcode,
    SUM(CASE WHEN Customer_Country    IS NULL OR LTRIM(RTRIM(Customer_Country))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Country,
    SUM(CASE WHEN Latitude            IS NULL OR LTRIM(RTRIM(Latitude))            IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Latitude,
    SUM(CASE WHEN Longitude           IS NULL OR LTRIM(RTRIM(Longitude))           IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Longitude,
    SUM(CASE WHEN Customer_Birth_Date IS NULL OR LTRIM(RTRIM(Customer_Birth_Date)) IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Birth_Date
FROM bronze.Customers;

-- 2.2 Products
SELECT
    SUM(CASE WHEN Product_Card_Id     IS NULL OR LTRIM(RTRIM(Product_Card_Id))     IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Card_Id,
    SUM(CASE WHEN Product_Name        IS NULL OR LTRIM(RTRIM(Product_Name))        IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Name,
    SUM(CASE WHEN Product_Price       IS NULL OR LTRIM(RTRIM(Product_Price))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Price,
    SUM(CASE WHEN Product_Status      IS NULL OR LTRIM(RTRIM(Product_Status))      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Status,
    SUM(CASE WHEN Product_Description IS NULL OR LTRIM(RTRIM(Product_Description)) IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Description,
    SUM(CASE WHEN Category_Id         IS NULL OR LTRIM(RTRIM(Category_Id))         IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Category_Id,
    SUM(CASE WHEN Category_Name       IS NULL OR LTRIM(RTRIM(Category_Name))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Category_Name,
    SUM(CASE WHEN Department_Id       IS NULL OR LTRIM(RTRIM(Department_Id))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Department_Id,
    SUM(CASE WHEN Department_Name     IS NULL OR LTRIM(RTRIM(Department_Name))     IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Department_Name
FROM bronze.Products;

-- 2.3 Salesman
SELECT
    SUM(CASE WHEN Salesman_Id       IS NULL OR LTRIM(RTRIM(Salesman_Id))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Salesman_Id,
    SUM(CASE WHEN Salesman_Fname    IS NULL OR LTRIM(RTRIM(Salesman_Fname))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Salesman_Fname,
    SUM(CASE WHEN Salesman_Lname    IS NULL OR LTRIM(RTRIM(Salesman_Lname))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Salesman_Lname,
    SUM(CASE WHEN Market            IS NULL OR LTRIM(RTRIM(Market))            IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Market,
    SUM(CASE WHEN Region            IS NULL OR LTRIM(RTRIM(Region))            IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Region,
    SUM(CASE WHEN Hire_Date         IS NULL OR LTRIM(RTRIM(Hire_Date))         IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Hire_Date,
    SUM(CASE WHEN Commission_Rate   IS NULL OR LTRIM(RTRIM(Commission_Rate))   IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Commission_Rate
FROM bronze.Salesman;

-- 2.4 Orders
SELECT
    SUM(CASE WHEN Order_Id                    IS NULL OR LTRIM(RTRIM(Order_Id))                    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_Id,
    SUM(CASE WHEN Order_Item_Id               IS NULL OR LTRIM(RTRIM(Order_Item_Id))               IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_Item_Id,
    SUM(CASE WHEN Customer_Id                 IS NULL OR LTRIM(RTRIM(Customer_Id))                 IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Customer_Id,
    SUM(CASE WHEN Product_Card_Id             IS NULL OR LTRIM(RTRIM(Product_Card_Id))             IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Product_Card_Id,
    SUM(CASE WHEN salesman_id                 IS NULL OR LTRIM(RTRIM(salesman_id))                 IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_salesman_id,
    SUM(CASE WHEN Type                        IS NULL OR LTRIM(RTRIM(Type))                        IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Type,
    SUM(CASE WHEN Days_for_shipping_real      IS NULL OR LTRIM(RTRIM(Days_for_shipping_real))      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Days_real,
    SUM(CASE WHEN Days_for_shipment_scheduled IS NULL OR LTRIM(RTRIM(Days_for_shipment_scheduled)) IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Days_scheduled,
    SUM(CASE WHEN Benefit_per_order           IS NULL OR LTRIM(RTRIM(Benefit_per_order))           IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Benefit_per_order,
    SUM(CASE WHEN Delivery_Status             IS NULL OR LTRIM(RTRIM(Delivery_Status))             IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Delivery_Status,
    SUM(CASE WHEN Late_delivery_risk          IS NULL OR LTRIM(RTRIM(Late_delivery_risk))          IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Late_delivery_risk,
    SUM(CASE WHEN Market                      IS NULL OR LTRIM(RTRIM(Market))                      IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Market,
    SUM(CASE WHEN Order_Region                IS NULL OR LTRIM(RTRIM(Order_Region))                IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_Region,
    SUM(CASE WHEN Order_State                 IS NULL OR LTRIM(RTRIM(Order_State))                 IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_State,
    SUM(CASE WHEN Order_Status                IS NULL OR LTRIM(RTRIM(Order_Status))                IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_Status,
    SUM(CASE WHEN Order_Zipcode               IS NULL OR LTRIM(RTRIM(Order_Zipcode))               IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Order_Zipcode,
    SUM(CASE WHEN order_date_DateOrders       IS NULL OR LTRIM(RTRIM(order_date_DateOrders))       IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN shipping_date_DateOrders    IS NULL OR LTRIM(RTRIM(shipping_date_DateOrders))    IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_shipping_date,
    SUM(CASE WHEN Shipping_Mode               IS NULL OR LTRIM(RTRIM(Shipping_Mode))               IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Shipping_Mode,
    SUM(CASE WHEN Order_Item_Discount         IS NULL OR LTRIM(RTRIM(Order_Item_Discount))         IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Discount,
    SUM(CASE WHEN Order_Item_Profit_Ratio     IS NULL OR LTRIM(RTRIM(Order_Item_Profit_Ratio))     IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Profit_Ratio,
    SUM(CASE WHEN Order_Item_Quantity         IS NULL OR LTRIM(RTRIM(Order_Item_Quantity))         IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Quantity,
    SUM(CASE WHEN Order_Item_Total            IS NULL OR LTRIM(RTRIM(Order_Item_Total))            IN ('','NULL','N/A') THEN 1 ELSE 0 END) AS null_Item_Total
FROM bronze.Orders;

-- 2.5 Deep-Dive Inspection: Customers with Missing Last Name
SELECT Customer_Id, Customer_Fname, Customer_Lname,
       CASE WHEN Customer_Lname IS NULL THEN 'NULL'
            WHEN LTRIM(RTRIM(Customer_Lname)) = '' THEN 'BLANK'
            ELSE 'TEXT: ' + Customer_Lname END AS lname_type
FROM bronze.Customers
WHERE Customer_Lname IS NULL
   OR LTRIM(RTRIM(Customer_Lname)) IN ('', 'NULL', 'N/A');


-- =========================================================================
-- ========= Step 3: Categorical Columns Hygiene (Spaces & Case Check) =====
-- =========================================================================

-- [3.1 Customers]
SELECT 'Customer_Segment' AS Column_Name, '[' + Customer_Segment + ']' AS Original_Value, LEN(Customer_Segment) AS Visible_Len, DATALENGTH(Customer_Segment) AS Actual_Bytes, COUNT(*) AS Row_Cnt
FROM Bronze.Customers
GROUP BY Customer_Segment
HAVING Customer_Segment <> LTRIM(RTRIM(Customer_Segment)) 
    OR DATALENGTH(Customer_Segment) <> DATALENGTH(LTRIM(RTRIM(Customer_Segment))) 
    OR Customer_Segment LIKE '%  %'

UNION ALL

SELECT 'Customer_City', '[' + Customer_City + ']', LEN(Customer_City), DATALENGTH(Customer_City), COUNT(*)
FROM Bronze.Customers
GROUP BY Customer_City
HAVING Customer_City <> LTRIM(RTRIM(Customer_City)) 
    OR DATALENGTH(Customer_City) <> DATALENGTH(LTRIM(RTRIM(Customer_City))) 
    OR Customer_City LIKE '%  %'

UNION ALL

SELECT 'Customer_State', '[' + Customer_State + ']', LEN(Customer_State), DATALENGTH(Customer_State), COUNT(*)
FROM Bronze.Customers
GROUP BY Customer_State
HAVING Customer_State <> LTRIM(RTRIM(Customer_State)) 
    OR DATALENGTH(Customer_State) <> DATALENGTH(LTRIM(RTRIM(Customer_State))) 
    OR Customer_State LIKE '%  %'

UNION ALL

SELECT 'Customer_Country', '[' + Customer_Country + ']', LEN(Customer_Country), DATALENGTH(Customer_Country), COUNT(*)
FROM Bronze.Customers
GROUP BY Customer_Country
HAVING Customer_Country <> LTRIM(RTRIM(Customer_Country)) 
    OR DATALENGTH(Customer_Country) <> DATALENGTH(LTRIM(RTRIM(Customer_Country))) 
    OR Customer_Country LIKE '%  %';

-- ===============

-- [3.2 Products]
SELECT 'Category_Name' AS Column_Name, '[' + Category_Name + ']' AS Original_Value, LEN(Category_Name) AS Visible_Len, DATALENGTH(Category_Name) AS Actual_Bytes, COUNT(*) AS Row_Cnt
FROM Bronze.Products
GROUP BY Category_Name
HAVING Category_Name <> LTRIM(RTRIM(Category_Name)) 
    OR DATALENGTH(Category_Name) <> DATALENGTH(LTRIM(RTRIM(Category_Name))) 
    OR Category_Name LIKE '%  %'

UNION ALL

SELECT 'Department_Name', '[' + Department_Name + ']', LEN(Department_Name), DATALENGTH(Department_Name), COUNT(*)
FROM Bronze.Products
GROUP BY Department_Name
HAVING Department_Name <> LTRIM(RTRIM(Department_Name)) 
    OR DATALENGTH(Department_Name) <> DATALENGTH(LTRIM(RTRIM(Department_Name))) 
    OR Department_Name LIKE '%  %';

-- ===============

-- [3.3 Salesman]
SELECT 'Market' AS Column_Name, '[' + Market + ']' AS Original_Value, LEN(Market) AS Visible_Len, DATALENGTH(Market) AS Actual_Bytes, COUNT(*) AS Row_Cnt
FROM Bronze.Salesman
GROUP BY Market
HAVING Market <> LTRIM(RTRIM(Market)) 
    OR DATALENGTH(Market) <> DATALENGTH(LTRIM(RTRIM(Market))) 
    OR Market LIKE '%  %'

UNION ALL

SELECT 'Region', '[' + Region + ']', LEN(Region), DATALENGTH(Region), COUNT(*)
FROM Bronze.Salesman
GROUP BY Region
HAVING Region <> LTRIM(RTRIM(Region)) 
    OR DATALENGTH(Region) <> DATALENGTH(LTRIM(RTRIM(Region))) 
    OR Region LIKE '%  %';

--==============

-- [3.4 Orders]
SELECT 'Type' AS Column_Name, '[' + [Type] + ']' AS Original_Value, LEN([Type]) AS Visible_Len, DATALENGTH([Type]) AS Actual_Bytes, COUNT(*) AS Row_Cnt
FROM Bronze.Orders
GROUP BY [Type]
HAVING [Type] <> LTRIM(RTRIM([Type])) 
    OR DATALENGTH([Type]) <> DATALENGTH(LTRIM(RTRIM([Type]))) 
    OR [Type] LIKE '%  %'

UNION ALL

SELECT 'Delivery_Status', '[' + Delivery_Status + ']', LEN(Delivery_Status), DATALENGTH(Delivery_Status), COUNT(*)
FROM Bronze.Orders
GROUP BY Delivery_Status
HAVING Delivery_Status <> LTRIM(RTRIM(Delivery_Status)) 
    OR DATALENGTH(Delivery_Status) <> DATALENGTH(LTRIM(RTRIM(Delivery_Status))) 
    OR Delivery_Status LIKE '%  %'

UNION ALL

SELECT 'Market', '[' + Market + ']', LEN(Market), DATALENGTH(Market), COUNT(*)
FROM Bronze.Orders
GROUP BY Market
HAVING Market <> LTRIM(RTRIM(Market)) 
    OR DATALENGTH(Market) <> DATALENGTH(LTRIM(RTRIM(Market))) 
    OR Market LIKE '%  %'

UNION ALL

SELECT 'Order_Region', '[' + Order_Region + ']', LEN(Order_Region), DATALENGTH(Order_Region), COUNT(*)
FROM Bronze.Orders
GROUP BY Order_Region
HAVING Order_Region <> LTRIM(RTRIM(Order_Region)) 
    OR DATALENGTH(Order_Region) <> DATALENGTH(LTRIM(RTRIM(Order_Region))) 
    OR Order_Region LIKE '%  %'

UNION ALL

SELECT 'Order_State', '[' + Order_State + ']', LEN(Order_State), DATALENGTH(Order_State), COUNT(*)
FROM Bronze.Orders
GROUP BY Order_State
HAVING Order_State <> LTRIM(RTRIM(Order_State)) 
    OR DATALENGTH(Order_State) <> DATALENGTH(LTRIM(RTRIM(Order_State))) 
    OR Order_State LIKE '%  %'

UNION ALL

SELECT 'Order_Status', '[' + Order_Status + ']', LEN(Order_Status), DATALENGTH(Order_Status), COUNT(*)
FROM Bronze.Orders
GROUP BY Order_Status
HAVING Order_Status <> LTRIM(RTRIM(Order_Status)) 
    OR DATALENGTH(Order_Status) <> DATALENGTH(LTRIM(RTRIM(Order_Status))) 
    OR Order_Status LIKE '%  %'

UNION ALL

SELECT 'Shipping_Mode', '[' + Shipping_Mode + ']', LEN(Shipping_Mode), DATALENGTH(Shipping_Mode), COUNT(*)
FROM Bronze.Orders
GROUP BY Shipping_Mode
HAVING Shipping_Mode <> LTRIM(RTRIM(Shipping_Mode)) 
    OR DATALENGTH(Shipping_Mode) <> DATALENGTH(LTRIM(RTRIM(Shipping_Mode))) 
    OR Shipping_Mode LIKE '%  %';


-- =========================================================================
-- ========= Step 4: Data Type Conversion & Transformation Preview =========
-- NOTE: These SELECT & DDL statements are tested here in Bronze to verify 
--       safe casting and standardization rules, and will be copied/moved 
--       directly into the Silver Layer ETL script.
-- =========================================================================

-- 4.1 Customers (Preview & Silver DDL Template)
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
WHERE TRY_CAST([Customer_Id] AS BIGINT) IS NOT NULL
/* -- Silver Layer DDL (Customers)
ALTER TABLE Sliver.Customers
DROP COLUMN [Customer_Email]

ALTER TABLE Sliver.Customers
DROP COLUMN [Customer_Password]

ALTER TABLE Sliver.Customers
ALTER COLUMN [Customer_Id] INT NOT NULL

ALTER TABLE Sliver.Customers
ADD CONSTRAINT PK_Sliver_Customer PRIMARY KEY (Customer_Id);
*/

-- 4.2 Orders (Preview & Silver DDL Template)
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

/* -- Silver Layer DDL (Orders)
ALTER TABLE Silver.Orders
ALTER COLUMN [Order_Item_Id] INT NOT NULL;

ALTER TABLE Silver.Orders
ADD CONSTRAINT Pk_Silver_Orders PRIMARY KEY ([Order_Item_Id]);
*/

-- 4.3 Products (Preview & Silver DDL Template)
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
FROM Bronze.Products
CROSS APPLY(
    SELECT
        REPLACE(REPLACE(LTRIM(RTRIM([Product_Name])) , '  ' ,' '), '  ', ' ') AS PN,
        REPLACE(REPLACE(LTRIM(RTRIM([Category_Name])) , '  ' ,' '), '  ', ' ') AS CN,
        REPLACE(REPLACE(LTRIM(RTRIM([Department_Name])) , '  ' ,' '), '  ', ' ') AS DN
) k
WHERE TRY_CAST(LTRIM(RTRIM([Product_Card_Id])) AS INT) IS NOT NULL;

/* -- Silver Layer DDL (Products)
ALTER TABLE Silver.Products
ALTER COLUMN [Product_Card_Id] INT NOT NULL

ALTER TABLE Silver.Products
ADD CONSTRAINT Pk_Silver_Product PRIMARY KEY([Product_Card_Id]);
*/

-- 4.4 Salesman (Preview & Silver DDL Template)
SELECT
    TRY_CAST(LTRIM(RTRIM([Salesman_Id])) AS INT ) AS [Salesman_Id],
    CONCAT_WS(' ', NULLIF(m.S_FNAME, ''), NULLIF(m.S_LNAME, '')) AS Full_Name,
    m.S_EMAIL AS [Salesman_Email],
    m.S_MARKET AS [Salesman_Market],
    m.S_REGION AS [Salesman_Region],
    TRY_CAST(LTRIM(RTRIM([Hire_Date])) AS date) AS [Hire_Date],
    TRY_CAST(LTRIM(RTRIM([Commission_Rate]))AS decimal(5 , 4)) AS [Commission_Rate]
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

/* -- Silver Layer DDL (Salesman)
ALTER TABLE Silver.Salesman
ALTER COLUMN [Salesman_Id] INT NOT NULL

ALTER TABLE Silver.Salesman
ADD CONSTRAINT Pk_Silver_Salesman PRIMARY KEY([Salesman_Id]);
*/


-- =========================================================================
-- ========= Step 5: Exact Primary Key Duplicates Check ====================
-- =========================================================================

-- 5.1 Customers
SELECT
    LTRIM(RTRIM([Customer_Id])) AS [Customer_Id],
    COUNT(*) AS cnt
FROM Bronze.Customers
GROUP BY LTRIM(RTRIM([Customer_Id]))
HAVING COUNT(*) > 1;

-- 5.2 Orders
SELECT
    LTRIM(RTRIM([Order_Item_Id])) AS [Order_Item_Id],
    COUNT(*) AS cnt
FROM Bronze.Orders
GROUP BY LTRIM(RTRIM([Order_Item_Id]))
HAVING COUNT(*) > 1;

-- 5.3 Products
SELECT
    LTRIM(RTRIM(Product_Card_Id)) AS Product_Card_Id,
    COUNT(*) AS cnt
FROM Bronze.Products
GROUP BY LTRIM(RTRIM(Product_Card_Id))
HAVING COUNT(*) > 1;

-- 5.4 Salesman
SELECT
    LTRIM(RTRIM([Salesman_Id])) AS [Salesman_Id],
    COUNT(*) AS cnt
FROM Bronze.Salesman
GROUP BY LTRIM(RTRIM([Salesman_Id]))
HAVING COUNT(*) > 1;


-- =========================================================================
-- ========= Step 6: Non-Identical Duplicates (Different IDs) ==============
-- =========================================================================

-- 6.1 Customers: Same person under different Customer_Id
SELECT
    COUNT(DISTINCT LTRIM(RTRIM([Customer_Id]))) AS distinct_customer_ids,
    UPPER(LTRIM(RTRIM([Customer_Fname]))) AS [Customer_Fname],
    UPPER(LTRIM(RTRIM([Customer_Lname]))) AS [Customer_Lname],
    LTRIM(RTRIM([Customer_Birth_Date])) AS [Customer_Birth_Date],
    UPPER(LTRIM(RTRIM([Customer_Street]))) AS [Customer_Street],
    LTRIM(RTRIM([Customer_Zipcode])) AS [Customer_Zipcode],
    COUNT(*) AS cnt
FROM Bronze.Customers
GROUP BY UPPER(LTRIM(RTRIM([Customer_Fname]))), UPPER(LTRIM(RTRIM([Customer_Lname])))
         , LTRIM(RTRIM([Customer_Birth_Date])), UPPER(LTRIM(RTRIM([Customer_Street])))
         , LTRIM(RTRIM([Customer_Zipcode]))
HAVING COUNT(*) > 1;

-- 6.2 Products: Same product under different Product_Card_Id
SELECT
    COUNT(DISTINCT LTRIM(RTRIM([Product_Card_Id]))) AS distinct_product_ids,
    UPPER(LTRIM(RTRIM([Product_Name]))) AS [Product_Name],
    LTRIM(RTRIM([Category_Id])) AS [Category_Id],
    LTRIM(RTRIM([Product_Price])) AS [Product_Price],
    COUNT(*) AS cnt
FROM Bronze.Products
GROUP BY UPPER(LTRIM(RTRIM([Product_Name]))), LTRIM(RTRIM([Category_Id])), LTRIM(RTRIM([Product_Price]))
HAVING COUNT(*) > 1;

-- 6.3 Salesman: Same person under different Salesman_Id
SELECT
    COUNT(DISTINCT LTRIM(RTRIM([Salesman_Id]))) AS distinct_salesman_ids,
    UPPER(LTRIM(RTRIM([Salesman_Fname]))) AS [Salesman_Fname],
    UPPER(LTRIM(RTRIM([Salesman_Lname]))) AS [Salesman_Lname],
    LOWER(LTRIM(RTRIM([Salesman_Email]))) AS [Salesman_Email],
    LTRIM(RTRIM([Hire_Date])) AS [Hire_Date],
    COUNT(*) AS cnt
FROM Bronze.Salesman
GROUP BY UPPER(LTRIM(RTRIM([Salesman_Fname]))), UPPER(LTRIM(RTRIM([Salesman_Lname])))
         , LOWER(LTRIM(RTRIM([Salesman_Email]))), LTRIM(RTRIM([Hire_Date]))
HAVING COUNT(*) > 1;

-- 6.4 Orders: Identical rows on ALL columns except Order_Item_Id
SELECT
    COUNT(DISTINCT [Order_Item_Id]) AS distinct_item_ids,
    COUNT(*) AS cnt
FROM Bronze.Orders
GROUP BY [Order_Id], [Customer_Id], [Product_Card_Id], [Type], [Days_for_shipping_real],
         [Days_for_shipment_scheduled], [Benefit_per_order], [Delivery_Status], [Late_delivery_risk],
         [Market], [Order_Region], [Order_State], [Order_Status], [Order_Zipcode],
         [order_date_DateOrders], [shipping_date_DateOrders], [Shipping_Mode],
         [Order_Item_Discount], [Order_Item_Profit_Ratio], [Order_Item_Quantity],
         [Order_Item_Total], [salesman_id]
HAVING COUNT(*) > 1;


-- =========================================================================
-- ========= Step 7: Referential Integrity (Orphan Records Check) ==========
-- =========================================================================

-- 7.1 Orders without matching Customer
SELECT
    TRY_CAST(LTRIM(RTRIM(bo.Customer_Id)) AS INT) AS Missing_Customer_Id,
    COUNT(*) AS cnt
FROM Bronze.Orders bo
LEFT JOIN Bronze.Customers bc
    ON TRY_CAST(LTRIM(RTRIM(bo.Customer_Id)) AS INT) = TRY_CAST(LTRIM(RTRIM(bc.Customer_Id)) AS INT)
WHERE bc.Customer_Id IS NULL
GROUP BY TRY_CAST(LTRIM(RTRIM(bo.Customer_Id)) AS INT);

-- 7.2 Orders without matching Product
SELECT
    TRY_CAST(LTRIM(RTRIM(bo.Product_Card_Id)) AS INT) AS Missing_Product_Card_Id,
    COUNT(*) AS cnt
FROM Bronze.Orders bo
LEFT JOIN Bronze.Products bp
    ON TRY_CAST(LTRIM(RTRIM(bo.Product_Card_Id)) AS INT) = TRY_CAST(LTRIM(RTRIM(bp.Product_Card_Id)) AS INT)
WHERE bp.Product_Card_Id IS NULL
GROUP BY TRY_CAST(LTRIM(RTRIM(bo.Product_Card_Id)) AS INT);

-- 7.3 Orders without matching Salesman
SELECT
    TRY_CAST(LTRIM(RTRIM(bo.salesman_id)) AS INT) AS Missing_Salesman_Id,
    COUNT(*) AS cnt
FROM Bronze.Orders bo
LEFT JOIN Bronze.Salesman bs
    ON TRY_CAST(LTRIM(RTRIM(bo.salesman_id)) AS INT) = TRY_CAST(LTRIM(RTRIM(bs.Salesman_Id)) AS INT)
WHERE bs.Salesman_Id IS NULL
GROUP BY TRY_CAST(LTRIM(RTRIM(bo.salesman_id)) AS INT);


-- =========================================================================
-- ========= Step 8: Business Logic Validation =============================
-- =========================================================================

-- 8.1 Shipping date earlier than Order date
SELECT
    Order_Item_Id,
    order_date_DateOrders,
    shipping_date_DateOrders
FROM Bronze.Orders
WHERE TRY_CAST(LTRIM(RTRIM(shipping_date_DateOrders)) AS DATETIME2(0))
    < TRY_CAST(LTRIM(RTRIM(order_date_DateOrders)) AS DATETIME2(0));