-- Why do some orders have negative profit?
USE Practice;
GO

-- 1. How many loss-making rows, and how much do they cost?
SELECT COUNT(*) AS loss_rows, SUM(Profit) AS total_loss
FROM dbo.superstore
WHERE Profit < 0;

-- 2. Do all loss-making rows have a discount?
SELECT AVG(CASE WHEN Discount > 0 THEN 1.0 ELSE 0 END) AS pct_with_discount
FROM dbo.superstore
WHERE Profit < 0;

-- 3. Profitability by discount band
SELECT discount_band,
       COUNT(*) AS rows_cnt,
       AVG(CASE WHEN Profit < 0 THEN 1.0 ELSE 0 END) AS pct_negative,
       SUM(Profit) AS total_profit
FROM (
    SELECT Profit,
           CASE
             WHEN Discount = 0    THEN '1) 0%'
             WHEN Discount <= 0.1 THEN '2) 0-10%'
             WHEN Discount <= 0.2 THEN '3) 10-20%'
             WHEN Discount <= 0.3 THEN '4) 20-30%'
             WHEN Discount <= 0.5 THEN '5) 30-50%'
             ELSE                      '6) 50-80%'
           END AS discount_band
    FROM dbo.superstore
) t
GROUP BY discount_band
ORDER BY discount_band;

-- 4. Which sub-categories lose the most?
SELECT Sub_Category, COUNT(*) AS loss_rows, SUM(Profit) AS total_loss
FROM dbo.superstore
WHERE Profit < 0
GROUP BY Sub_Category
ORDER BY total_loss;

-- 5. Top 10 worst individual rows
SELECT TOP 10 Product_Name, Sales, Discount, Profit
FROM dbo.superstore
ORDER BY Profit;
