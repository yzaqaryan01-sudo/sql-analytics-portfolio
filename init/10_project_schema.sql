CREATE TABLE project.neighbourhoods(
neighbourhood_group TEXT,
neighbourhood TEXT NOT NULL PRIMARY KEY
);
CREATE TABLE project.listings (
"id" INT NOT NULL PRIMARY KEY,
"name" TEXT NOT NULL,
host_id INT NOT NULL,
host_name TEXT NOT NULL,
neighbourhood_group TEXT,
neighbourhood TEXT NOT NULL REFERENCES project.neighbourhoods (neighbourhood),
latitude DECIMAL(10,4) NOT NULL,
longitude DECIMAL(10,4) NOT NULL,
room_type TEXT,
price NUMERIC(10,2),
minimum_nights INT,
number_of_reviews INT,
last_review DATE,
reviews_per_month DOUBLE PRECISION,
calculated_host_listings_count INT,
availability_365 INT,
number_of_reviews_ltm INT);
CREATE TABLE project.reviews(
"id" INT NOT NULL REFERENCES project.listings("id"),
"date" DATE);
