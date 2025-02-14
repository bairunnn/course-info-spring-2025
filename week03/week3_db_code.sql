CREATE SCHEMA indego;

CREATE EXTENSION postgis;

-- You can think of schemas as a way to organize your database
-- into different sections / "topics".
DROP TABLE IF EXISTS indego.stations;

CREATE TABLE indego.stations (
    id INT,
    name TEXT,
    go_live_date TEXT,
    status TEXT
);

-- This chunk below may need to be run in the psql terminal (left pane!)
\copy indego.stations 
FROM '/Users/bairun/Documents/GitHub/course-info-spring-cloud/week03/stations.csv' 
WITH (FORMAT CSV, HEADER TRUE);

SELECT * FROM indego.stations;

ALTER TABLE indego.stations
ALTER COLUMN go_live_date TYPE DATE 
USING to_date(go_live_date, 'MM/DD/YYYY');

SELECT * FROM indego.stations;

-- Here, note that SHOW is a Postgres command
-- This command shows the current search path (default schema)
SHOW search_path;

SELECT 
    id,
    id + 1 AS next_id
FROM indego.stations;

SELECT go_live_date
FROM indego.stations
WHERE id = 3355;

SELECT *
FROM indego.stations
WHERE go_live_date >= '2023-10-12';

-- EXTRACT function
SELECT
    id,
    name,
    EXTRACT(MONTH FROM go_live_date) AS go_live_month
FROM indego.stations
WHERE EXTRACT(QUARTER FROM go_live_date) = 4;

-- String concatenation with ||
SELECT
    id,
    'Name: ' || name || ', ID: ' || id AS station_info,
    go_live_date
FROM indego.stations;

-- LIKE operator when filtering
SELECT 
    id,
    name,
    go_live_date
FROM indego.stations
WHERE name LIKE '%Park%';








-- SPATIAL DATA OPERATIONS
-- Note that these chunks may need to be typed in the psql terminal (left pane!)

-- Verify the SRID of the geometry column
SELECT ST_SRID(geog) FROM indego.stations_geo LIMIT 5;

UPDATE indego.stations_geo
SET geog = ST_Transform(ST_SetSRID(geog, 4326), 4326)
WHERE ST_SRID(geog) <> 4326;

SELECT
    id,
    name,
    ST_Distance(
        geog,
        ST_SetSRID(ST_MakePoint(-75.1634, 39.9529), 4326)::geography
    ) AS dist_geog
FROM indego.stations_geo
ORDER BY dist_geog;

-- Comparison with Web Mercator
ALTER TABLE indego.stations_geo  
    ADD COLUMN geom_3857 GEOMETRY;  

UPDATE indego.stations_geo SET  
    geom_3857 = ST_Transform(geog::GEOMETRY, 3857);

SELECT  
    id,  
    name,

    ST_Distance(  
        geog,  
        ST_MakePoint(-75.1634, 39.9529)::geography  
    ) AS dist_geog,

    ST_Distance(  
        geom_3857,  
        ST_Transform(  
            ST_SetSRID(  
                ST_MakePoint(-75.1634, 39.9529),  
                4326  
            ),
            3857
        )
    ) AS dist_3857

FROM indego.stations_geo
ORDER BY dist_geog;

-- And 32129

ALTER TABLE indego.stations_geo  
    ADD COLUMN geom_32129 GEOMETRY;  
UPDATE indego.stations_geo SET  
    geom_32129 = ST_Transform(geog::GEOMETRY, 32129);

-- Indeed the deviations vary significantly

-- CTE

WITH CITY_HALL AS (  
    SELECT  
        ST_SetSRID(  
            ST_MakePoint(-75.1634, 39.9529),  
            4326  
        )::GEOMETRY AS GEOM  
)
SELECT  
    ID,  
    NAME,  

    ST_Distance(  
        GEOG,  
        CITY_HALL.GEOM  
    ) AS DIST_GEO,  

    ST_Distance(
        GEOM_32129,  
        ST_Transform(CITY_HALL.GEOM, 32129)  
    ) AS DIST_32129  

FROM INDEGO.STATIONS_GEO  
CROSS JOIN CITY_HALL  
ORDER BY DIST_GEO;
