-- Active: 1739389935809@@localhost@5432@musa509week03byron@phl
-- Parks geojson loaded as 'parks'

SELECT * FROM phl.parks;

SELECT * FROM phl.stations;

/*
1.  Write a query that returns the number of bike share docks near
(within 500 meters of) each park in the city
(note that a station usually has multiple docks; see the `totalDocks` field in the station statuses dataset).
*/

-- First create a buffer around the parks
DROP TABLE IF EXISTS phl.parks500buffer;

CREATE TABLE phl.parks500buffer AS
SELECT
    public_name AS full_name,
    label AS park_name,
    public.ST_Buffer(public.ST_Transform(geog, 32129), 500) AS geog
FROM phl.parks;

-- There should be 507 parks in total
SELECT * FROM phl.parks500buffer;

SELECT public.ST_SRID(geog) AS srid
FROM phl.stations
LIMIT 1;

SELECT public.ST_SRID(geog) AS srid
FROM phl.parks500buffer
LIMIT 1;

SELECT
    park.full_name AS park_full_name,
    park.park_name,
    park.geog AS park_geog,
    sta.id AS station_id,
    sta.name AS station_name,
    sta.geog AS station_geog
FROM phl.parks500buffer AS park
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(public.ST_Transform(sta.geog, 32129), park.geog);


SELECT *
FROM phl.parks500buffer AS pk
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(pk.geog, public.ST_Transform(sta.geog, 32129));

-- With NULL values
SELECT
    pk.full_name AS park_full_name,
    pk.park_name,
    SUM(sta.totaldocks) AS total_docks
FROM phl.parks500buffer AS pk
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(pk.geog, public.ST_Transform(sta.geog, 32129))
GROUP BY pk.full_name, pk.park_name
ORDER BY total_docks DESC;

-- Without NULL values
SELECT
    pk.full_name AS park_full_name,
    pk.geog,
    COALESCE(SUM(sta.totaldocks), 0) AS total_docks
FROM phl.parks500buffer AS pk
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(pk.geog, public.ST_Transform(sta.geog, 32129))
GROUP BY pk.full_name, pk.geog
ORDER BY total_docks DESC;

-- Join the results back to the original parks table
DROP TABLE IF EXISTS phl.parksprocessed;

CREATE TABLE phl.parksprocessed AS
SELECT
    pk.full_name AS park_full_name,
    pk.geog,
    COALESCE(SUM(sta.totaldocks), 0) AS total_docks
FROM phl.parks500buffer AS pk
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(pk.geog, public.ST_Transform(sta.geog, 32129))
GROUP BY pk.full_name, pk.geog
ORDER BY total_docks DESC;

SELECT * FROM phl.parksprocessed;

-- Final output
SELECT
    pk.public_name,
    pk.geog,
    COALESCE(pp.total_docks, 0) AS total_docks
FROM phl.parks AS pk
LEFT JOIN phl.parksprocessed AS pp
    ON pk.public_name = pp.park_full_name;


/*
2. Write a query that returns the amount of park land
in Philadelphia that is within a kilometer of any bike share station.
*/
-- Step 1: Create 1km buffer for each station and union them into one feature
DROP TABLE IF EXISTS phl.stations1kbuffer;

CREATE TABLE phl.stations1kbuffer AS
SELECT
    public.ST_Union(
        public.ST_Buffer(public.ST_Transform(geog, 32129), 1000)
    ) AS geog
FROM phl.stations;

-- Step 2: Union all parks into one feature
DROP TABLE IF EXISTS phl.parksunion;

CREATE TABLE phl.parksunion AS
SELECT public.ST_Union(geog) AS geog
FROM phl.parks;

SELECT public.ST_SRID(geog) AS stations1kbuffer_srid
FROM phl.stations1kbuffer LIMIT 1;

SELECT public.ST_SRID(geog) AS parksunion_srid
FROM phl.parksunion LIMIT 1;

SELECT
    proname,
    proargtypes
FROM pg_proc
WHERE proname = 'round';

-- Step 3: Output the intersection area between parks and station buffers
SELECT
    ROUND(
        CAST(
            public.ST_Area(public.ST_Intersection(
                public.ST_Transform(sta.geog, 32129),
                public.ST_Transform(pk.geog, 32129)
            )) / 1000000 AS numeric
        ), 2
    ) AS intersection_area_sqkm
FROM phl.stations1kbuffer AS sta
INNER JOIN phl.parksunion AS pk
    ON public.ST_Intersects(
        public.ST_Transform(sta.geog, 32129),
        public.ST_Transform(pk.geog, 32129)
    );

-- Answer: 10.653 km2
