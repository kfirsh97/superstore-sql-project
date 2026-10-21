IF DB_ID('Practice') IS NULL CREATE DATABASE Practice;
GO
USE Practice;
GO
DROP TABLE IF EXISTS dbo.superstore;
CREATE TABLE dbo.superstore (
    Row_ID          INT            PRIMARY KEY,
    Order_ID        VARCHAR(20),
    Order_Date      DATE,
    Ship_Date       DATE,
    Ship_Mode       VARCHAR(20),
    Customer_ID     VARCHAR(10),
    Customer_Name   NVARCHAR(50),
    Segment         VARCHAR(20),
    Country_Region  VARCHAR(30),
    City            NVARCHAR(50),
    State_Province  NVARCHAR(50),
    Postal_Code     VARCHAR(10),
    Region          VARCHAR(10),
    Product_ID      VARCHAR(20),
    Category        VARCHAR(20),
    Sub_Category    VARCHAR(20),
    Product_Name    NVARCHAR(200),
    Sales           DECIMAL(12,4),
    Quantity        INT,
    Discount        DECIMAL(5,2),
    Profit          DECIMAL(12,4)
);
GO
BULK INSERT dbo.superstore
FROM '/tmp/superstore.csv'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDQUOTE = '"',
      FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a');
GO
SELECT COUNT(*) AS rows_loaded, SUM(Profit) AS total_profit FROM dbo.superstore;
GO
