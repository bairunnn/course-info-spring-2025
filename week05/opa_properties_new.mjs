// npm install big-json

import fs from 'node:fs';
import BigJSON from 'big-json';

// Load the data from the GeoJSON file
const data = await BigJSON.parse({
  body: fs.readFileSync('opa_properties_public.geojson')
});

// Write the data to a JSONL file
const f = fs.createWriteStream('opa_properties.jsonl');
for (const feature of data.features) {
  const row = feature.properties;
  const geog = JSON.stringify(feature.geometry);

  // Only write the row if geog is not empty
  if (geog && geog !== '{}' && geog !== '[]') {
    row.geog = geog;
    f.write(JSON.stringify(row) + '\n');
  }
}