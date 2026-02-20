CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE analytics._stg_listings(
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
    license TEXT
    );

COPY analytics._stg_listings
FROM '/data/listings.csv'
CSV HEADER;

CREATE TABLE analytics.hosts(
    host_id INT PRIMARY KEY,
    host_name TEXT
);

INSERT INTO analytics.hosts(host_id, host_name)
SELECT DISTINCT
    host_id,
    host_name
FROM analytics._stg_listings;
CREATE TABLE analytics.neighbourhoods(
    neighbourhood_group VARCHAR(50),
    neighbourhood VARCHAR(50) PRIMARY KEY
);

COPY analytics.neighbourhoods
FROM '/data/neighbourhoods.csv'
CSV HEADER;


CREATE TABLE analytics.listings(
    "id" BIGINT PRIMARY KEY,
    "name" TEXT,
    room_type TEXT,
    neighbourhood TEXT REFERENCES analytics.neighbourhoods(neighbourhood),
    latitude DECIMAL(10,2),
    longitude DECIMAL (10,2),
    price NUMERIC (10,2),
    minimum_nights INT,
    availability_365 INT,
    host_id INT REFERENCES analytics.hosts(host_id)
);
INSERT INTO analytics.listings(
    "id",
    "name",
    room_type,
    neighbourhood, 
    latitude,
    longitude,
    price,
    minimum_nights,
    availability_365,
    host_id
)
SELECT
    s."id",
    s."name",
    s.room_type,
    n.neighbourhood,
    s.latitude,
    s.longitude,
    s.price,
    s.minimum_nights,
    s.availability_365,
    h.host_id
FROM analytics._stg_listings AS s
JOIN analytics.hosts AS h
ON s.host_id=h.host_id
LEFT JOIN analytics.neighbourhoods AS n
ON s.neighbourhood=n.neighbourhood;

CREATE TABLE analytics._stg_neighbourhoods(
    neighbourhood VARCHAR(50) REFERENCES analytics.neighbourhoods(neighbourhood),
    neighbourhood_group VARCHAR(50),
    geom geometry(MULTIPOLYGON, 4326) NOT NULL
);

INSERT INTO analytics._stg_neighbourhoods (
    neighbourhood,
    neighbourhood_group,
    geom
    )
SELECT
    feature->'properties'->>'neighbourhood' AS neighbourhood_neighbourhood_name,
	 feature->'properties'->>'neighbourhood_group' AS neighbourhood_group_name,
    ST_SetSRID(
        ST_Multi(
            ST_CollectionExtract(
                ST_Force2D(
                    ST_MakeValid(
                        ST_GeomFromGeoJSON(feature->>'geometry')
                    )
                ),
            3)
        ),
        4326
    ) AS geom
FROM (
    SELECT jsonb_array_elements(data->'features') AS feature
    FROM (
        SELECT pg_read_file('/data/neighbourhoods.geojson')::jsonb AS data
    ) f
) sub;
SELECT * FROM analytics._stg_neighbourhoods
CREATE  TABLE analytics.reviews(
    review_id SERIAL PRIMARY KEY,
    number_of_reviews INT,
    last_review DATE,
    reviews_per_month DOUBLE PRECISION,
    number_of_reviews_ltm INT,
    "id" BIGINT REFERENCES analytics.listings("id")
);
INSERT INTO analytics.reviews(
    number_of_reviews,
    last_review,
    reviews_per_month,
    number_of_reviews_ltm,
    "id"
);
SELECT
    s.number_of_reviews,
    s.last_review,
    s.reviews_per_month,
    s.number_of_reviews_ltm,
    l."id"
FROM  analytics._stg_listings AS s
JOIN analytics.listings AS l
ON s."id"=l."id";
CREATE TABLE analytics.analysis AS
SELECT
    l."id",
    l."name",
    h.host_id,
    h.host_name,
    s.neighbourhood,
    l.latitude,
    l.longitude,
    l.room_type,
    l.price,
    l.minimum_nights,
    r.number_of_reviews,
    r.last_review,
    r.reviews_per_month,
    l.availability_365,
    r.number_of_reviews_ltm
FROM analytics.listings AS l
JOIN analytics.hosts AS h 
ON l.host_id=h.host_id
LEFT JOIN _stg_neighbourhoods AS s 
ON l.neighbourhood=s.neighbourhood
JOIN analytics.reviews AS r
ON.l."id"=r."id";

SELECT
    room_type,
    SUM(price * (365 - availability_365)) AS revenue_per_room_type,
    ROUND(SUM(price * (365 - availability_365))/ SUM(SUM(price * (365 - availability_365))) OVER () * 100,2) 
        AS percentage_of_total
FROM analytics.analysis
GROUP BY room_type
ORDER BY revenue_per_room_type DESC;

SELECT 
	neighbourhood,
	ROUND(AVG(price),2)AS avg_price,
	SUM(price * (365 - availability_365)) AS total_revenue
FROM analytics.analysis
WHERE price !=0
GROUP BY neighbourhood
ORDER BY total_revenue DESC
LIMIT 10;
SELECT
	neighbourhood,
	COUNT(host_id)
	FROM analytics.analysis
WHERE price IS NULL OR 
availability_365=365
GROUP BY neighbourhood
ORDER BY COUNT(host_id) DESC
LIMIT 3;
SELECT
	host_name,
	COUNT(host_id),
	SUM(price * (365 - availability_365)) AS total_revenue
FROM analytics.analysis
GROUP BY host_name
HAVING COUNT(host_id)>200
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    room_type,
    SUM(price * (365 - availability_365)) AS revenue_per_room_type,
    ROUND(SUM(price * (365 - availability_365))/ SUM(SUM(price * (365 - availability_365))) OVER () * 100,2) 
        AS percentage_of_total
FROM analytics.analysis
GROUP BY room_type
ORDER BY revenue_per_room_type DESC;

SELECT 
	neighbourhood,
	ROUND(AVG(price),2)AS avg_price,
	SUM(price *(365-availability_365)) AS total_revenue
FROM analytics.analysis
WHERE price !=0
GROUP BY neighbourhood
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
	neighbourhood,
	COUNT("id")
	FROM analytics.analysis
WHERE price IS NULL OR 
availability_365=365
GROUP BY neighbourhood
ORDER BY COUNT("id") DESC
LIMIT 3;


SELECT
	host_name,
	COUNT(host_id),
	SUM(price * (365 - availability_365)) AS total_revenue
FROM analytics.analysis
GROUP BY host_name
HAVING COUNT(host_id)>200
ORDER BY total_revenue DESC
LIMIT 10;

