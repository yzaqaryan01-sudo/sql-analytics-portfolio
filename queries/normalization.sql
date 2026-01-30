CREATE TABLE normalization.customers(
sale_id INT PRIMARY KEY,
sale_date DATE NOT NULL,
customer_name TEXT NOT NULL,
customer_email TEXT UNIQUE,
customer_age INT NOT NULL
);

CREATE TABLE normalization.country(
country TEXT NOT NULL,
region TEXT NOT NULL,
city TEXT NOT NULL,
sale_id INT NOT NULL REFERENCES normalization.customers(sale_id)
);

CREATE TABLE normalization.city_boundaries(
city_lat DECIMAL(10,4) NOT NULL,
city_lon DECIMAL (10,4) NOT NULL,
sale_id INT NOT NULL REFERENCES normalization.customers(sale_id)
);

CREATE TABLE normalization.products (
product_name TEXT NOT NULL,
product_category TEXT NOT NULL,
unit_price NUMERIC(10,2) NOT NULL,
quantity INT NOT NULL,
sale_id INT NOT NULL REFERENCES normalization.customers(sale_id)
);

CREATE TABLE normalization.order_items(
payment_method TEXT NOT NULL,
order_status TEXT NOT NULL,
sale_id INT NOT NULL REFERENCES normalization.customers(sale_id)
);
CREATE TABLE normalization.sales_analysis AS
SELECT
cu.sale_id,
cu.sale_date,
cu.customer_name,
cu.customer_email,
cu.customer_age,

co.country,
co.region,
co.city,

cb.city_lat,
cb.city_lon,

p.product_name,
p.product_category,
p.unit_price,
p.quantity,

o.payment_method,
o.order_status
FROM normalization.customers AS cu
JOIN normalization.country AS co
ON cu.sale_id=co.sale_id
JOIN normalization.city_boundaries AS cb
ON cu.sale_id=cb.sale_id
JOIN normalization.products AS p
ON cu.sale_id=p.sale_id
JOIN normalization.order_items AS o
ON cu.sale_id=o.sale_id;

COPY normalization.sales_analysis
FROM '/data/Normalization Task - Sheet1.csv'
CSV HEADER;
SELECT 
*
FROM normalization.sales_analysis;