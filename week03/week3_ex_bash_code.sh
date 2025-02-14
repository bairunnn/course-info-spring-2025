ogr2ogr \
    -f "PostgreSQL" \
    -nln neighs \
    -lco SCHEMA=phl \
    -lco GEOMETRY_NAME=geog \
    -lco GEOMETRY_TYPE=geography \
    -lco OVERWRITE=YES \
PG:"host=localhost user=postgres dbname=musa509week03byron password=7777" \
"philadelphia-neighborhoods.geojson"

ogr2ogr \
    -f "PostgreSQL" \
    -nln stations \
    -lco SCHEMA=phl \
    -lco GEOMETRY_NAME=geog \
    -lco GEOMETRY_TYPE=geography \
    -lco OVERWRITE=YES \
PG:"host=localhost user=postgres dbname=musa509week03byron password=7777" \
"phl.geojson"

ogr2ogr \
    -f "PostgreSQL" \
    -nln parks \
    -lco SCHEMA=phl \
    -lco GEOMETRY_NAME=geog \
    -lco GEOMETRY_TYPE=geography \
    -lco OVERWRITE=YES \
PG:"host=localhost user=postgres dbname=musa509week03byron password=7777" \
"PPR_Properties.geojson"