--What are the top 5 brands by receipts scanned for most recent month?

WITH recent_month AS (
    SELECT 
    STRFTIME('%Y-%m', max(purchaseDate)) AS latest_month
    FROM receipts r join Brands b on r.barcode=b.barcode
    WHERE purchaseDate IS NOT NULL
),

filtered_receipts AS (
    SELECT 
        r.barcode,
        r.purchaseDate
    FROM receipts r
    JOIN recent_month rm
      ON STRFTIME('%Y-%m', r.purchaseDate) = rm.latest_month
),

receipt_counts AS (
    SELECT 
        b.name AS brand_name,
        COUNT(*) AS receipt_count
    FROM filtered_receipts fr
    JOIN brands b ON fr.barcode = b.barcode
    GROUP BY b.name
)

SELECT 
    brand_name,
    receipt_count
FROM receipt_counts
ORDER BY receipt_count DESC
LIMIT 5;
----------------------------------------------------------------------------------------------------------------------------
--How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month?

WITH month_summary AS (
  SELECT 
    b.name AS brand_name,
    STRFTIME('%Y-%m', r.purchaseDate) AS purchase_month,
    COUNT(*) AS receipt_count
  FROM receipts r
  JOIN brands b ON r.barcode = b.barcode
  WHERE r.purchaseDate IS NOT NULL
  GROUP BY brand_name, purchase_month
),

-- Get the 2 most recent months
latest_months AS (
  SELECT DISTINCT purchase_month
  FROM month_summary
  ORDER BY purchase_month DESC
  LIMIT 2
),

-- Assign flags to identify this month and last month
labeled_data AS (
  SELECT 
    ms.brand_name,
    ms.receipt_count,
    CASE 
      WHEN ms.purchase_month = (SELECT MAX(purchase_month) FROM latest_months) THEN 'this_month'
      WHEN ms.purchase_month = (SELECT MIN(purchase_month) FROM latest_months) THEN 'last_month'
    END AS period
  FROM month_summary ms
  WHERE ms.purchase_month IN (SELECT purchase_month FROM latest_months)
),

-- This and last month data
This_Last_Month AS (
  SELECT 
    brand_name,
    MAX(CASE WHEN period = 'this_month' THEN receipt_count END) AS this_month,
    MAX(CASE WHEN period = 'last_month' THEN receipt_count END) AS last_month
  FROM labeled_data
  GROUP BY brand_name
)
-- Final: Top 5 brands by this month's receipts
SELECT *
FROM This_Last_Month
ORDER BY this_month DESC
LIMIT 5;
---------------------------------------------------------------------------------------------------------------------------------------
--When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?

SELECT (case when r.rewardsReceiptStatus ='FINISHED' THEN 'ACCEPTED'
             when r.rewardsReceiptStatus ='REJECTED' THEN 'REJECTED'
        ELSE 'OTHER'
       END) AS RewardStatus ,
       ROUND(AVG(r.totalSpent),2) AS TotalSpent
       FROM Receipts r
       where (case when r.rewardsReceiptStatus ='FINISHED' THEN 'ACCEPTED'
             when r.rewardsReceiptStatus ='REJECTED' THEN 'REJECTED'
        ELSE 'OTHER'
       END) in ('ACCEPTED','REJECTED')
group by 1
ORDER BY 2 DESC;


-------------------------------------------------------------------------------------------------------------------------------------------
--When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?


SELECT (case when r.rewardsReceiptStatus ='FINISHED' THEN 'ACCEPTED'
             when r.rewardsReceiptStatus ='REJECTED' THEN 'REJECTED'
        ELSE 'OTHER'
       END) AS RewardStatus ,
       SUM(r.purchasedItemCount) AS TotalItemsPurchased
       FROM Receipts r
       where (case when r.rewardsReceiptStatus ='FINISHED' THEN 'ACCEPTED'
             when r.rewardsReceiptStatus ='REJECTED' THEN 'REJECTED'
        ELSE 'OTHER'
       END) in ('ACCEPTED','REJECTED')
group by 1
ORDER BY 2 DESC;

-----------------------------------------------------------------------------------------------------------------------------------------------

--Which brand has the most spend among users who were created within the past 6 months?
WITH max_cdate AS (
  SELECT DATE(MAX(createdDate)) AS max_date
  FROM UsersData
),
recent_users AS (
  SELECT *
  FROM UsersData, max_cdate
  WHERE DATE(createdDate) >= DATE(max_date, '-5 months')
    AND DATE(createdDate) <= max_date
),
user_receipts AS (
    SELECT r.userId, r.barcode, r.totalSpent
    FROM receipts r
    JOIN recent_users u ON r.userId = u.userid
    WHERE r.totalSpent IS NOT NULL
),
brand_spending AS (
    SELECT b.name AS brand_name, SUM(r.totalSpent) AS total_spent
    FROM user_receipts r
    JOIN brands b ON r.barcode = b.barcode
    GROUP BY b.name )
    
SELECT brand_name, total_spent
FROM brand_spending
ORDER BY total_spent DESC
LIMIT 1;

---------------------------------------------------------------------------------------------
--Which brand has the most transactions among users who were created within the past 6 months?

WITH max_cdate AS (
  SELECT DATE(MAX(createdDate)) AS max_date
  FROM UsersData
),
recent_users AS (
  SELECT *
  FROM UsersData, max_cdate
  WHERE DATE(createdDate) >= DATE(max_date, '-5 months')
    AND DATE(createdDate) <= max_date
),
user_receipts AS (
  SELECT r.barcode
  FROM receipts r
  JOIN recent_users u ON r.userId = u.userid
  WHERE r.barcode IS NOT NULL
),

brand_transactions AS (
  SELECT b.name AS brand_name, COUNT(*) AS transaction_count
  FROM user_receipts ur
  JOIN brands b ON ur.barcode = b.barcode
  GROUP BY b.name
)

SELECT brand_name, transaction_count
FROM brand_transactions
ORDER BY transaction_count DESC
LIMIT 1;

