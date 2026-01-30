CREATE TABLE analytics.sales_analysis AS
SELECT
cu.customer_id,
cu.first_name,
cu.last_name,
cu.age,
cu.email,
co.country_name,
r.region_name,
ci.city_name,
o.order_date,
p.product_name,
p.category,
p.price,
oi.quantity,
o.status
FROM analytics.customers AS cu
JOIN analytics.cities AS ci
ON cu.city_id=ci.city_id
JOIN analytics.regions AS r
ON ci.region_id=r.region_id
JOIN analytics.countries AS co
ON r.country_id=co.country_id
JOIN analytics.orders AS o
ON cu.customer_id=o.customer_id
JOIN analytics.order_items AS oi
ON o.order_id=oi.order_id
JOIN products AS p
ON oi.product_id=p.product_id 
Task 1 
SELECT 
CONCAT(first_name, ' ', last_name) AS full_name,
age,
country_name
FROM analytics.sales_analysis
GROUP BY  full_name,
age,
country_name

TASK 2
SELECT 
CONCAT(first_name, ' ', last_name) AS full_name,
SUM(price * quantity) AS total_revenue
FROM analytics.sales_analysis
WHERE status = 'cancelled'
GROUP BY full_name
--THE answer is yes
TASK 3
--Because order_item is distinct and order can be not unique.
TASK 4

TASK 5
SELECT 
country_name,
SUM(price * quantity) AS total_revenue
FROM analytics.sales_analysis
GROUP BY country_name

TASK 6
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  ci.city_name
FROM analytics.customers c
JOIN analytics.customer_locations cl
  ON c.customer_id = cl.customer_id
JOIN analytics.cities ci
  ON c.city_id = ci.city_id
JOIN analytics.city_boundaries cb
  ON ci.city_id = cb.city_id
  WHERE NOT ST_Within(cl.geom, cb.geom);
