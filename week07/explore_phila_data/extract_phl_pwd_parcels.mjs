// This is for Week 7!
import fetch from 'node-fetch';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { Storage } from '@google-cloud/storage';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DATA_DIR = path.join(__dirname, 'raw_data/');

const url = 'https://opendata.arcgis.com/datasets/84baed491de44f539889f2af178ad85c_0.geojson';
const filename = path.join(DATA_DIR, 'phl_pwd_parcels.geojson');

const response = await fetch(url);
if (!response.ok) {
  throw new Error(`HTTP error! status: ${response.status}`);
}

await fs.writeFile(filename, await response.text());

console.log(`Downloaded ${filename}`);

// Upload to GCS
const storageClient = new Storage();
const bucketName = 'bairun_data_lake';
const blobName = 'week7exercises/raw/phl_pwd_parcels.geojson';

const bucket = storageClient.bucket(bucketName);
await bucket.upload(filename, {
  destination: blobName,
});

console.log(`Uploaded ${filename} to gs://${bucketName}/${blobName}`);