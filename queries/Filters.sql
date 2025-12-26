Task 1 
SELECT
category,
AVG(total_sales) AS average_sales_amount,
AVG (discount) AS average_discount_amount
FROM sales_analysis
GROUP BY category;

SELECT
transaction_id,
city,
category,
total_sales,
CASE 
WHEN total_sales >= 257.1 AND discount <= 0.25 THEN 'High value transaction with low discounting'
WHEN total_sales >= 257.1 AND discount > 0.25 THEN 'High value transaction with high discounting'
WHEN total_sales <= 257.1 AND discount <= 0.25 THEN 'Low value transaction with low discounting'
ELSE 'Low value transaction with high discounting'
END AS sales_segment
FROM sales_analysis
WHERE year = 2023
AND category = 'Electronics'

Task 2
SELECT 
category,
COUNT (transaction_id) AS transaction_count,
SUM (total_sales) AS total_revenue,
AVG (discount) AS average_discount,
CASE 
WHEN SUM(total_sales) >= 80000 THEN 'Strong performer'
When SUM(total_sales)>= 60000 THEN 'Average performer'
ELSE 'Low performer'
END AS category_segment
FROM sales_analysis
WHERE year = 2023
GROUP BY category
HAVING SUM(total_sales) >60000 

Task 3
SELECT 
city,
COUNT (*) AS transaction_volume,
SUM (total_sales) AS total_revenue,
CASE 
WHEN SUM(total_sales)>900  THEN 'High activity'
WHEN SUM(total_sales) > 500  THEN 'Medium activity'
ELSE 'Low activity'
END AS city_segment
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING SUM (total_sales)< 900

Task 4
SELECT
category,
SUM(total_sales) AS total_revenue,
AVG(discount) AS discount_amount,
CASE
WHEN AVG(discount)>0.25 THEN 'Discount-heavy'
WHEN AVG (discount)>0.15 THEN 'Moderate discount'
ELSE 'Low or no discount'
END AS discount_category
FROM sales_analysis
WHERE year = 2023
GROUP BY category
HAVING AVG (discount)>0.15
ORDER BY SUM(total_sales) DESC
