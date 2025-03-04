// // This is for Week 7!
// import dotenv from 'dotenv';
// dotenv.config();

// import BigJSON from 'big-json'; // For handling large JSON files 
// import fs from 'fs/promises';
// import path from 'path';
// import { fileURLToPath } from 'url';
// import { Storage } from '@google-cloud/storage';

// const __dirname = path.dirname(fileURLToPath(import.meta.url));
// const RAW_DATA_DIR = path.join(__dirname, 'raw_data/');
// const PREPARED_DATA_DIR = path.join(__dirname, 'prepared_data/');

// const rawFilename = path.join(RAW_DATA_DIR, 'phl_pwd_parcels.geojson');
// const preparedFilename = path.join(PREPARED_DATA_DIR, 'phl_pwd_parcels.jsonl');
// const bucketName = process.env.DATA_LAKE_BUCKET;

// // Download the raw data from the bucket
// const storageClient = new Storage();
// const bucket = storageClient.bucket(bucketName);
// const rawBlobName = 'week7exercises/raw/phl_pwd_parcels.geojson';
// await bucket.file(rawBlobName).download({ destination: rawFilename });
// console.log(`Downloaded ${rawFilename}`);

// // Load the data from the GeoJSON file
// const data = await BigJSON.parse({
//   body: await fs.readFile(rawFilename)
// });

// // Write the data to a JSONL file
// const f = await fs.open(preparedFilename, 'w');
// for (const feature of data.features) {
//   const row = feature.properties;
//   row.geog = (
//     feature.geometry && feature.geometry.coordinates
//     ? JSON.stringify(feature.geometry)
//     : null
//   );
//   await f.write(JSON.stringify(row) + '\n');
// }

// console.log(`Processed data into ${preparedFilename}`);

// // Upload the prepared data to the bucket
// const preparedBlobName = 'week7exercises/prepared/phl_pwd_parcels.jsonl';
// await bucket.upload(preparedFilename, {
//   destination: preparedBlobName,
// });
// console.log(`Uploaded ${preparedFilename} to gs://${bucketName}/${preparedBlobName}`);

import dotenv from 'dotenv';
dotenv.config();

import BigJSON from 'big-json'; // For handling large JSON files 
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { Storage } from '@google-cloud/storage';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const RAW_DATA_DIR = path.join(__dirname, 'raw_data/');
const PREPARED_DATA_DIR = path.join(__dirname, 'prepared_data/');
const rawFilename = path.join(RAW_DATA_DIR, 'phl_pwd_parcels.geojson');
const preparedFilename = path.join(PREPARED_DATA_DIR, 'phl_pwd_parcels.jsonl');
const bucketName = process.env.DATA_LAKE_BUCKET;
const storageClient = new Storage();
const bucket = storageClient.bucket(bucketName);
const rawBlobName = 'week7exercises/raw/phl_pwd_parcels.geojson';
const preparedBlobName = 'week7exercises/prepared/phl_pwd_parcels.jsonl';

async function downloadRawData() {
  try {
    await fs.mkdir(RAW_DATA_DIR, { recursive: true });
    console.log(`Downloading ${rawBlobName} from bucket...`);
    await bucket.file(rawBlobName).download({ destination: rawFilename });
    console.log(`Downloaded ${rawFilename}`);
  } catch (error) {
    console.error('Error downloading raw data:', error);
  }
}

async function processGeoJSON() {
  try {
    console.log('Processing GeoJSON data...');
    const data = await BigJSON.parse({ body: await fs.readFile(rawFilename) });
    await fs.mkdir(PREPARED_DATA_DIR, { recursive: true });
    const f = await fs.open(preparedFilename, 'w');
    for (const feature of data.features) {
      const row = feature.properties;
      row.geog = feature.geometry?.coordinates ? JSON.stringify(feature.geometry) : null;
      await f.write(JSON.stringify(row) + '\n');
    }
    await f.close();
    console.log(`Processed data into ${preparedFilename}`);
  } catch (error) {
    console.error('Error processing GeoJSON:', error);
  }
}

async function uploadPreparedData() {
  try {
    console.log('Uploading prepared data to bucket...');
    await bucket.upload(preparedFilename, { destination: preparedBlobName });
    console.log(`Uploaded ${preparedFilename} to gs://${bucketName}/${preparedBlobName}`);
  } catch (error) {
    console.error('Error uploading prepared data:', error);
  }
}

async function main() {
  await downloadRawData();
  await processGeoJSON();
  await uploadPreparedData();
}

main();