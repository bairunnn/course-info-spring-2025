# PostgreSQL information
# Server: localhost
# Port: 5432
# Username: postgres
# Database: musa509week03byron

# Connect to PostgreSQL
psql -U postgres

# Create new database
CREATE DATABASE musa509week03byron;

CREATE EXTENSION postgis

# Verify database creation
\l

# To exit the PostgreSQL interactive shell (psql) 
# and return to Mac terminal
\q

# Install csvkit
brew install csvkit

# Download data into the current directory
curl https://www.rideindego.com/wp-content/uploads/2025/01/indego-stations-2025-01-01.csv | csvcut --not-columns 4-8 > indego_stations.csv

# Install sqlfluff and set up PATH
# export PATH="/opt/homebrew/Cellar/sqlfluff/3.3.0_1:$PATH"

# Loading station status data
ogr2ogr \
    -f "PostgreSQL" \
    -nln stations_geo \
    -lco SCHEMA=indego \
    -lco GEOMETRY_NAME=geog \
    -lco GEOMETRY_TYPE=geography \
    -lco OVERWRITE=YES \
PG:"host=localhost user=postgres dbname=musa509week03byron password=7777" \
"phl.geojson"



