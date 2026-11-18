-- =========================================================================
-- ========= 1. DimDate (Role-Playing Date Dimension) ======================
-- =========================================================================
CREATE TABLE Gold.DimDate (
    DateKey INT NOT NULL PRIMARY KEY, 
    Full_Date DATE NOT NULL,
    [Year] INT NOT NULL,
    [Quarter] INT NOT NULL,
    [Month] INT NOT NULL,
    [Month_Name] VARCHAR(20) NOT NULL,
    [Day] INT NOT NULL,
    [Day_Name] VARCHAR(20) NOT NULL,
    Is_Weekend BIT NOT NULL
);

DECLARE @Start_Date DATE, @End_Date DATE, @Current_Date DATE;

SELECT
    @Start_Date = MIN(CAST(order_date_DateOrders AS DATE)),
    @End_Date   = MAX(CAST(shipping_date_DateOrders AS DATE))
FROM Silver.Orders;

SET @Current_Date = @Start_Date;

WHILE @Current_Date <= @End_Date
BEGIN 
    INSERT INTO Gold.DimDate (
        DateKey, Full_Date, [Year], [Quarter], [Month], [Month_Name], [Day], [Day_Name], Is_Weekend
    )
    VALUES (
        CAST(FORMAT(@Current_Date, 'yyyyMMdd') AS INT),
        @Current_Date,
        YEAR(@Current_Date),
        DATEPART(QUARTER, @Current_Date),
        MONTH(@Current_Date),
        DATENAME(MONTH, @Current_Date),
        DAY(@Current_Date),
        DATENAME(WEEKDAY, @Current_Date),
        CASE WHEN DATEPART(WEEKDAY, @Current_Date) IN (1, 7) THEN 1 ELSE 0 END
    );

    SET @Current_Date = DATEADD(DAY, 1, @Current_Date);
END;

SELECT * FROM Gold.DimDate;


-- =========================================================================
-- ========= 2. Dimension Tables ===========================================
-- =========================================================================

-- 2.1 DimCustomers
SELECT * 
INTO Gold.DimCustomers 
FROM [Silver].[Customers];

ALTER TABLE Gold.DimCustomers ALTER COLUMN [Customer_Id] INT NOT NULL;
ALTER TABLE Gold.DimCustomers ADD CONSTRAINT PK_DimCustomers PRIMARY KEY ([Customer_Id]);

-- 2.2 DimProducts
SELECT * 
INTO Gold.DimProducts 
FROM [Silver].[Products];

ALTER TABLE Gold.DimProducts ALTER COLUMN [Product_Card_Id] INT NOT NULL;
ALTER TABLE Gold.DimProducts ADD CONSTRAINT PK_DimProducts PRIMARY KEY ([Product_Card_Id]);

-- 2.3 DimSalesman
SELECT * 
INTO Gold.DimSalesman 
FROM [Silver].[Salesman];

ALTER TABLE Gold.DimSalesman ALTER COLUMN [Salesman_Id] INT NOT NULL;
ALTER TABLE Gold.DimSalesman ADD CONSTRAINT PK_DimSalesman PRIMARY KEY ([Salesman_Id]);


-- =========================================================================
-- ========= 3. FactOrders (With Dual Date Keys) ===========================
-- =========================================================================
SELECT * 
INTO Gold.FactOrders 
FROM [Silver].[Orders];

ALTER TABLE Gold.FactOrders ALTER COLUMN [Order_Item_Id] INT NOT NULL;
ALTER TABLE Gold.FactOrders ADD CONSTRAINT PK_FactOrders PRIMARY KEY ([Order_Item_Id]);


ALTER TABLE Gold.FactOrders 
ADD OrderDateKey INT,
    ShippingDateKey INT;


UPDATE Gold.FactOrders 
SET OrderDateKey    = CAST(FORMAT(order_date_DateOrders, 'yyyyMMdd') AS INT),
    ShippingDateKey = CAST(FORMAT(shipping_date_DateOrders, 'yyyyMMdd') AS INT);


ALTER TABLE Gold.FactOrders ALTER COLUMN OrderDateKey INT NOT NULL;
ALTER TABLE Gold.FactOrders ALTER COLUMN ShippingDateKey INT NOT NULL;


-- =========================================================================
-- ========= 4. Foreign Keys (Relating FactOrders to DimDate Twice) ========
-- =========================================================================

-- DimDate: OrderDate  
ALTER TABLE Gold.FactOrders
    ADD CONSTRAINT FK_FactOrders_OrderDate FOREIGN KEY (OrderDateKey)
    REFERENCES [Gold].[DimDate] ([DateKey]);

--  DimDate: ShippingDate
ALTER TABLE Gold.FactOrders
    ADD CONSTRAINT FK_FactOrders_ShippingDate FOREIGN KEY (ShippingDateKey)
    REFERENCES [Gold].[DimDate] ([DateKey]);


ALTER TABLE Gold.FactOrders
    ADD CONSTRAINT FK_FactOrders_Customers FOREIGN KEY ([Customer_Id])
    REFERENCES [Gold].[DimCustomers] ([Customer_Id]);

ALTER TABLE Gold.FactOrders
    ADD CONSTRAINT FK_FactOrders_Products FOREIGN KEY ([Product_Card_Id])
    REFERENCES [Gold].[DimProducts] ([Product_Card_Id]);

ALTER TABLE Gold.FactOrders
    ADD CONSTRAINT FK_FactOrders_Salesman FOREIGN KEY ([salesman_id])
    REFERENCES [Gold].[DimSalesman] ([Salesman_Id]);


-- =========================================================================
-- ========= 5. Indexes (Performance Optimization) =========================
-- =========================================================================
CREATE INDEX IX_FactOrders_OrderDateKey    ON Gold.FactOrders ([OrderDateKey]);
CREATE INDEX IX_FactOrders_ShippingDateKey ON Gold.FactOrders ([ShippingDateKey]);
CREATE INDEX IX_FactOrders_Customer_Id     ON Gold.FactOrders ([Customer_Id]);
CREATE INDEX IX_FactOrders_Product_Card_Id ON Gold.FactOrders ([Product_Card_Id]);
CREATE INDEX IX_FactOrders_Salesman_Id     ON Gold.FactOrders ([salesman_id]);


-- ========= Gold Validation =========

-- 1) Row counts across layers (Bronze -> Silver -> Gold)
SELECT 'Customers' AS entity,
       (SELECT COUNT(*) FROM Bronze.Customers) AS bronze,
       (SELECT COUNT(*) FROM Silver.Customers) AS silver,
       (SELECT COUNT(*) FROM Gold.DimCustomers) AS gold
UNION ALL
SELECT 'Products',
       (SELECT COUNT(*) FROM Bronze.Products),
       (SELECT COUNT(*) FROM Silver.Products),
       (SELECT COUNT(*) FROM Gold.DimProducts)
UNION ALL
SELECT 'Salesman',
       (SELECT COUNT(*) FROM Bronze.Salesman),
       (SELECT COUNT(*) FROM Silver.Salesman),
       (SELECT COUNT(*) FROM Gold.DimSalesman)
UNION ALL
SELECT 'Orders',
       (SELECT COUNT(*) FROM Bronze.Orders),
       (SELECT COUNT(*) FROM Silver.Orders),
       (SELECT COUNT(*) FROM Gold.FactOrders)


