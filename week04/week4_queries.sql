-- Active: 1739389935809@@localhost@5432@musa509week04byron
-- Load Philadelphia 2020 Census Block Groups from the Census FTP 
-- Bash
/* GPT
ogr2ogr \
    -f "PostgreSQL" \
    PG:"host=localhost user=postgres dbname=musa509week04byron password=7777" \
    "tl_2020_42_bg/tl_2020_42_bg.shp" \
    -nln census.blockgroups_2020 \
    -nlt PROMOTE_TO_MULTI \
    -t_srs EPSG:4326 \
    -lco GEOMETRY_NAME=geog \
    -overwrite \
    -progress
*/

/* Lecture
ogr2ogr \
  -f "PostgreSQL" \
  -nln "census.blockgroups_2020" \
  -nlt MULTIPOLYGON \
  -t_srs EPSG:4326 \
  -lco "GEOM_TYPE=geography" \
  -lco "GEOMETRY_NAME=geog" \
  -overwrite \
  PG:"host=localhost port=5432 dbname=musa_509 user=postgres password=postgres" \
  ~/Downloads/tl_2020_42_bg/tl_2020_42_bg.shp
*/

-- SQL
CREATE SCHEMA census;
CREATE SCHEMA septa;
CREATE EXTENSION postgis;

CREATE TABLE septa.bus_stops (
    stop_id SERIAL PRIMARY KEY,
    stop_code INTEGER,
    stop_name TEXT,
    stop_desc TEXT,
    stop_lat DOUBLE PRECISION,
    stop_lon DOUBLE PRECISION,
    zone_id INTEGER,
    stop_url TEXT,
    location_type INTEGER,
    parent_station INTEGER,
    stop_timezone TEXT,
    wheelchair_boarding INTEGER
);

-- Run in psql shell
\copy septa.bus_stops
FROM '/Users/bairun/Documents/GitHub/course-info-spring-cloud/week04/gtfs_public/google_bus/stops.txt'
DELIMITER ','
CSV HEADER;

/* FROM LECTURE
csvsql \
  --db "postgresql://postgres:postgres@localhost:5432/musa_509" \
  --insert \
  --overwrite \
  --create-if-not-exists \
  --db-schema "septa" \
  --tables "bus_stops" \
  ~/Downloads/gtfs_public/google_bus/stops.txt
*/

-- Select the geoid, geography, and the number of bus stops per sq km.
with
septa_bus_stops as (
    select
        *,
        st_makepoint(stop_lon, stop_lat)::geography as geog
    from septa.bus_stops
)
select
    blockgroups.geoid,
    blockgroups.geog,
    count(bus_stops.*) / st_area(blockgroups.geog) * 1000000 as bus_stops_per_sqkm
from census.blockgroups_2020 as blockgroups
left join septa_bus_stops as bus_stops
    on st_covers(blockgroups.geog, bus_stops.geog)
group by
    blockgroups.geoid, blockgroups.geog
order by
    bus_stops_per_sqkm desc
