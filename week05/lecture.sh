ogr2ogr \
  "opa_properties_public-4326.csv" \
  "opa_properties_public.geojson" \
  -lco GEOMETRY=AS_WKT \
  -lco GEOMETRY_NAME=geog \
  -skipfailures

# Can also use Javascript to convert from GeoJSON to CSV or to JSON-L. 
# This can be rather convenient as we will eventually want this to be 
# run on a process on a cloud server.
# See node.js script

# Note the JSON / GEOJSON files compress well

# Preview JSON-L file

head -n 100 opa_properties.jsonl > slice_opa_properties_100.jsonl

