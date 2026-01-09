1. Revenue Overviewը
SELECT
  SUM (total_sales) AS total_revenue
  FROM sales_analysis

SELECT
category,
  SUM(total_sales) AS total_revenue
  FROM sales_analysis
  GROUP BY category
  
  SELECT
category,
  SUM(total_sales) AS total_revenue,
  ROUND((SUM(total_sales)/1271017.85)*100,2) AS percentage_of_total
  FROM sales_analysis
  GROUP BY category
  ORDER BY percentage_of_total DESC

  2.Typical Transaction value
  
  SELECT 
CEILING (PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY total_sales)) AS median_value,
CEILING (AVG(total_sales)) AS mean_value,
MIN(total_sales) AS min_value,
MAX(total_sales) AS max_value
FROM sales_analysis
--Մեղիանի և միջինի միջև տարբերությունը ընդամենը չորս է։
--Սա նշանակում է, որ սիմմետրիկ է բաշխված։
--Այս դեպքում օգտագործվում է AVG ֆունկցիան, քանզի outlier-ների ազդեցություն չկա։
3. Null Impact Assessment

SELECT
transaction_id,
price,
discount
FROM sales_analysis
WHERE discount is Null

3.1 default behavior
SELECT
 AVG(discount) AS avg_discount
 FROM Sales_analysis

 3.2 zero imputation
 SELECT
 AVG(COALESCE(discount,0)) AS avg_discount_zero_imputed
 FROM sales_analysis

3.3 mean imputation
SELECT
 AVG(discount) AS avg_discount
 FROM Sales_analysis

 SELECT 
 AVG(COALESCE(discount,0.24771800000000000000)) AS avg_discount_mean_imputed
 FROM sales_analysis
 3.4 median imputation
 SELECT
 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY discount) AS median_discount
 FROM sales_analysis

SELECT 
AVG(COALESCE(discount,0.25)) AS median_discount_imputed
FROM sales analysis
--Default behavior-օգտագործվում է հիմնականում, երբ տվյալների բազան մեծ չէ կամ report analysis-ի ժամանակ
--zero imputation- ՉԻ ազդում KPI-ների վրա և միջինը մնում է նույնը
--mean imputation-  outlier-ներն ազդեցություն ունեն
--median imputation- outlier-ներն ազդեցություն չունեն
4. Revenue Distribution Analysis
SELECT
CEILING(total_sales/50) * 50 AS revenue_range,
COUNT(*) AS transactions,
SUM(total_sales) AS total_revenue
FROM sales_analysis
GROUP BY revenue_range
ORDER BY total_revenue DESC
5.Data Quality Check
--Duplicates wasnt found. 
--As sales_analysis is a transaction level, measuring salary will result in overcalculation of salaries
-- To get a just result we should caluclate salary for example per period. 