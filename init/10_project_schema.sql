CREATE TABLE project.neighbourhoods(
neighbourhood_group TEXT,
neighbourhood TEXT NOT NULL 
);
CREATE TABLE project.listings (
"id" BIGINT NOT NULL PRIMARY KEY,
"name" TEXT NOT NULL,
host_id INT NOT NULL,
host_name TEXT ,
neighbourhood_group TEXT,
neighbourhood TEXT ,
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
number_of_reviews_ltm INT,
license TEXT);
CREATE TABLE project.reviews(
"id" BIGINT NOT NULL REFERENCES project.listings("id"),
"date" DATE);
CREATE TABLE project.neighbourhoods_boundaries (
    neighbourhood TEXT  ,
    geom       GEOMETRY(MultiPolygon, 4326)
);
CREATE TABLE project._stg_neighbourhoods_boundaries (
    neighbourhood TEXT,
	neighbourhood_group TEXT,
    wkt TEXT);
COPY  project.neighbourhoods
FROM '/data/neighbourhoods.csv'
CSV HEADER;
COPY  project.listings
FROM '/data/listings.csv'
CSV HEADER;

COPY  project._stg_neighbourhoods_boundaries
FROM '/data/neighbourhoods_wkt.csv'
CSV HEADER;
COPY  project.reviews
FROM '/data/reviews.csv'
CSV HEADER;