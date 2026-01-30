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