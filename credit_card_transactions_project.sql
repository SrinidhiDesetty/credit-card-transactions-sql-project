/* 
---------------------------------------------------------------
Title: Credit Card Transactions SQL Analysis
Author: Srinidhi Desetty
Description: 
  SQL project exploring credit card transactions dataset 
  using aggregation, window functions, and analytical queries.
---------------------------------------------------------------
*/

USE sample_db;

SELECT * FROM credit_card_transactions;

-- ================================================================================================================================

-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
SELECT city, SUM(amount) as total_spends, 
       ROUND(SUM(amount) * 100 / (SELECT SUM(amount) FROM credit_card_transactions), 2) as per_contribution
FROM credit_card_transactions 
GROUP BY city
ORDER BY total_spends DESC
LIMIT 5;

-- 2- write a query to print highest spend month for each year and amount spent in that month for each card type
SELECT yr, month_name, card_type, total_spend
FROM (
SELECT EXTRACT(YEAR FROM transaction_date) as yr, 
-- 	   EXTRACT(MONTH FROM transaction_date) as mon, 
       MONTHNAME(transaction_date) as month_name,
       card_type, 
       SUM(amount) as total_spend,
       RANK() OVER(PARTITION BY EXTRACT(YEAR FROM transaction_date), card_type 
				   ORDER BY SUM(amount) DESC) as rnk
		FROM credit_card_transactions
		GROUP BY EXTRACT(YEAR FROM transaction_date), MONTHNAME(transaction_date), card_type) as ranked
WHERE rnk = 1;

-- 3- write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
WITH cs AS ( 
		SELECT *, 
        SUM(amount) OVER(PARTITION BY card_type ORDER BY transaction_date, transaction_id) as cumulative_spend
		FROM credit_card_transactions ),
	 rn AS (
		SELECT *, RANK() OVER(PARTITION BY card_type ORDER BY cumulative_spend) as rnk
		FROM cs
        WHERE cumulative_spend >= 1000000)
SELECT * 
FROM rn
WHERE rnk = 1;

-- 4- write a query to find city which had lowest percentage spend for gold card type
WITH cte AS (
			SELECT city, card_type, SUM(amount) as total_amount,
					SUM(CASE WHEN card_type = 'Gold' THEN amount END) as gold_amount
			FROM credit_card_transactions
			GROUP BY city, card_type)
SELECT city, SUM(gold_amount)*100 / SUM(total_amount) as gold_ratio
FROM cte
GROUP BY city
HAVING COUNT(gold_amount) > 0 AND SUM(gold_amount) > 0
ORDER BY gold_ratio
LIMIT 1;

-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
WITH cte AS (
			SELECT city, exp_type, 
                   RANK() OVER(PARTITION BY city ORDER BY SUM(amount) DESC) as rnk_desc,
                   RANK() OVER(PARTITION BY city ORDER BY SUM(amount) ASC) as rnk_asc
			FROM credit_card_transactions
            GROUP BY city, exp_type)
SELECT city,
       MAX(CASE WHEN rnk_desc = 1 THEN exp_type END) as highest_expense_type,
       MIN(CASE WHEN rnk_asc = 1 THEN exp_type END) as lowest_expense_type
FROM cte
GROUP BY city;
       
-- 6- write a query to find percentage contribution of spends by females for each expense type
SELECT exp_type,
       SUM(CASE WHEN gender = 'F' THEN amount ELSE 0 END)*100 / SUM(amount) as female_contribution_ratio
FROM credit_card_transactions
GROUP BY exp_type;
	   
-- 7- which card and expense type combination saw highest month over month growth in Jan-2014
WITH cte1 AS (
			SELECT card_type, exp_type,
				YEAR(transaction_date) as yt,
				MONTHNAME(transaction_date) as mt,
				SUM(amount) as total_spend
			FROM credit_card_transactions
			GROUP BY card_type, exp_type, YEAR(transaction_date), MONTHNAME(transaction_date)),
	 cte2 AS (
			SELECT *,
            LAG(total_spend, 1) OVER(PARTITION BY card_type, exp_type ORDER BY yt, mt) as prev_mon_spend
            FROM cte1)
SELECT (total_spend - prev_mon_spend) as mom_growth
FROM cte2
WHERE prev_mon_spend IS NOT NULL AND yt = 2014 AND mt = 'January'
ORDER BY mom_growth DESC
LIMIT 1;

-- 8- during weekends which city has highest total spend to total no of transactions ratio 
SELECT city,
       SUM(amount)*100 / COUNT(1) as trans_ratio
FROM credit_card_transactions
WHERE DAYNAME(transaction_date) IN ('Sunday', 'Saturday')
GROUP BY city
ORDER BY trans_ratio DESC
LIMIT 1;

-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city
WITH cte AS (
			SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY city ORDER BY transaction_date, transaction_id) as rn
			FROM credit_card_transactions)
SELECT city, TIMESTAMPDIFF(DAY, MIN(transaction_date), MAX(transaction_date)) as datediffs
FROM cte
WHERE rn = 1 or rn = 500
GROUP BY city
HAVING COUNT(*) = 2
ORDER BY datediffs
LIMIT 1;

-- 10. Find which card type generated the highest total spend in each city.
SELECT city, card_type
FROM (
SELECT city, card_type, SUM(amount) as total_spend,
       RANK() OVER(PARTITION BY city ORDER BY SUM(amount) DESC) as rnk
FROM credit_card_transactions
GROUP BY city, card_type) as ranked
WHERE rnk = 1;

-- 11. For each card type, calculate: Total number of transactions, Total spend, Average spend per transaction
SELECT card_type, 
       COUNT(transaction_id) as total_transactions,
       SUM(amount) as total_spend,
       ROUND(AVG(amount),2) as avg_spend_per_transaction
FROM credit_card_transactions
GROUP BY card_type;
