// This is for Week 7!
/*
import dotenv from 'dotenv';
dotenv.config();

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
*/

import dotenv from 'dotenv';
dotenv.config();

import fetch from 'node-fetch';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { Storage } from '@google-cloud/storage';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const DATA_DIR = path.join(__dirname, 'raw_data/');
const url = 'https://opendata.arcgis.com/datasets/84baed491de44f539889f2af178ad85c_0.geojson';
const filename = path.join(DATA_DIR, 'phl_pwd_parcels.geojson');

async function downloadFile() {
  try {
    console.log('Fetching data...');
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(`HTTP error! Status: ${response.status}`);
    }
    const data = await response.text();
    await fs.mkdir(DATA_DIR, { recursive: true }); // Ensure directory exists
    await fs.writeFile(filename, data);
    console.log(`Downloaded ${filename}`);
  } catch (error) {
    console.error('Error downloading file:', error);
  }
}

async function uploadToGCS() {
  try {
    console.log('Uploading to Google Cloud Storage...');
    const storageClient = new Storage();
    const bucketName = process.env.DATA_LAKE_BUCKET;
    const blobName = 'week7exercises/raw/phl_pwd_parcels.geojson';

    const bucket = storageClient.bucket(bucketName);
    await bucket.upload(filename, { destination: blobName });
    console.log(`Uploaded ${filename} to gs://${bucketName}/${blobName}`);
  } catch (error) {
    console.error('Error uploading file:', error);
  }
}

async function main() {
  await downloadFile();
  await uploadToGCS();
}

main();
