-- Initialise the database

CREATE SCHEMA phl;
CREATE EXTENSION postgis;

-- Load those datasets into the said database

-- ogr2ogr for the neighbourhoods geojson and bike stations geojson

-- 1.  Write a query that lists which neighborhoods have the highest density of bikeshare stations.
-- Let's say "density" means number of stations per square km.

SELECT * FROM phl.neighs;

SELECT DISTINCT public.ST_SRID(geog) AS srid
FROM phl.neighs;

/*
WITH neighs_w_area AS (
SELECT
    name,
    public.ST_Area(public.ST_Transform(geog::geometry, 32129)) / 1000000 AS area_sqkm,
    geog
FROM phl.neighs
)
SELECT
    nh.name,
    nh.geog,
    COUNT(sta.id) / nh.area_sqkm AS denn_sqkm
FROM neighs_w_area AS nh
LEFT JOIN phl.stations AS sta
    ON public.st_covers(nh.geog, sta.geog)
GROUP BY nh.name, nh.geog, nh.area_sqkm
ORDER BY denn_sqkm DESC;
*/

WITH neighs_w_area AS (
    SELECT
        name,
        geog,
        public.ST_Area(public.ST_Transform(geog, 32129)) / 1000000 AS area_sqkm
    FROM phl.neighs
)

SELECT
    nh.name,
    nh.geog,
    -- Fixed "denn_sqkm" to "dens_sqkm" for clarity
    COUNT(sta.id) / nh.area_sqkm AS dens_sqkm
FROM neighs_w_area AS nh
LEFT JOIN phl.stations AS sta
    ON public.ST_Covers(nh.geog, sta.geog)  -- Ensure correct schema reference
GROUP BY nh.name, nh.geog, nh.area_sqkm
ORDER BY dens_sqkm DESC;

/*
SET search_path TO public;
*/

/*
2. Write a query to get the average bikeshare station density across
all the neighborhoods that have a non-zero bike share station density.
*/

WITH neighs_w_area AS (
    SELECT
        name,
        geog,
        public.ST_Area(public.ST_Transform(geog, 32129)) / 1000000 AS area_sqkm
    FROM phl.neighs
),

neighs_with_density AS (
    SELECT
        nh.name,
        COUNT(sta.id) / nh.area_sqkm AS dens_sqkm
    FROM neighs_w_area AS nh
    LEFT JOIN phl.stations AS sta
        ON public.ST_Covers(nh.geog, sta.geog)
    GROUP BY nh.name, nh.area_sqkm
    HAVING COUNT(sta.id) > 0  -- Exclude neighborhoods with zero stations
)

SELECT AVG(dens_sqkm) AS avg_bikeshare_density
FROM neighs_with_density;

-- Asnwer: 3.656

/*
3.  Write a query that lists which neighborhoods have a density above the average, and which have a density below average.
*/

WITH neighs_w_area AS (
    SELECT
        name,
        geog,
        public.ST_Area(public.ST_Transform(geog, 32129)) / 1000000 AS area_sqkm
    FROM phl.neighs
),

neighs_with_density AS (
    SELECT
        nh.name,
        COUNT(sta.id) / nh.area_sqkm AS dens_sqkm
    FROM neighs_w_area AS nh
    LEFT JOIN phl.stations AS sta
        ON public.ST_Covers(nh.geog, sta.geog)
    GROUP BY nh.name, nh.area_sqkm
    HAVING COUNT(sta.id) > 0  -- Exclude neighborhoods with zero stations
),

avg_density AS (
    SELECT AVG(dens_sqkm) AS avg_bikeshare_density
    FROM neighs_with_density
)

SELECT
    nwd.name,
    nwd.dens_sqkm,
    CASE
        WHEN nwd.dens_sqkm > ad.avg_bikeshare_density THEN 'Above Average'
        ELSE 'Below Average'
    END AS density_category
FROM neighs_with_density AS nwd
CROSS JOIN avg_density AS ad
ORDER BY nwd.dens_sqkm DESC;




-- With geog

WITH neighs_w_area AS (
    SELECT
        name,
        geog,
        public.ST_Area(public.ST_Transform(geog, 32129)) / 1000000 AS area_sqkm
    FROM phl.neighs
),

neighs_with_density AS (
    SELECT
        nh.name,
        nh.geog,
        COUNT(sta.id) / nh.area_sqkm AS dens_sqkm
    FROM neighs_w_area AS nh
    LEFT JOIN phl.stations AS sta
        ON public.ST_Covers(nh.geog, sta.geog)
    GROUP BY nh.name, nh.geog, nh.area_sqkm
    HAVING COUNT(sta.id) > 0  -- Exclude neighborhoods with zero stations
),

avg_density AS (
    SELECT AVG(dens_sqkm) AS avg_bikeshare_density
    FROM neighs_with_density
)

SELECT
    nwd.name,
    nwd.geog,
    nwd.dens_sqkm,
    CASE
        WHEN nwd.dens_sqkm > ad.avg_bikeshare_density THEN 'Above Average'
        ELSE 'Below Average'
    END AS density_category
FROM neighs_with_density AS nwd
CROSS JOIN avg_density AS ad
ORDER BY nwd.dens_sqkm DESC;
