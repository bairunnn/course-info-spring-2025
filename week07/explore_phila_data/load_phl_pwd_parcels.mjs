// import dotenv from 'dotenv';
// dotenv.config();

// import { BigQuery } from '@google-cloud/bigquery';

// const bucketName = process.env.DATA_LAKE_BUCKET;
// const datasetName = process.env.DATA_LAKE_DATASET;

// // Load the data into BigQuery as an external table
// const preparedBlobName = 'week7exercises/prepared/phl_pwd_parcels.jsonl';
// const tableName = 'phl_pwd_parcels';
// const tableUri = `gs://${bucketName}/${preparedBlobName}`;

// const createTableQuery = `
// CREATE OR REPLACE EXTERNAL TABLE \`${tableName}\`
// OPTIONS (
//   format = 'JSON',
//   uris = ['${tableUri}']
//   )
// `;

// const bigqueryClient = new BigQuery();
// await bigqueryClient.query(createTableQuery);
// console.log(`Loaded ${tableUri} into ${datasetName}.${tableName}`);

import dotenv from 'dotenv';
dotenv.config();

import { BigQuery } from '@google-cloud/bigquery';

const bucketName = process.env.DATA_LAKE_BUCKET;
const datasetName = process.env.DATA_LAKE_DATASET;
const preparedBlobName = 'week7exercises/prepared/phl_pwd_parcels.jsonl';
const tableName = 'phl_pwd_parcels';
const tableUri = `gs://${bucketName}/${preparedBlobName}`;

async function loadExternalTable() {
  try {
    console.log('Creating external table in BigQuery...');
    const bigqueryClient = new BigQuery();
    const createTableQuery = `
      CREATE OR REPLACE EXTERNAL TABLE \`${datasetName}.${tableName}\`
      OPTIONS (
        format = 'JSON',
        uris = ['${tableUri}']
      )`;
    
    await bigqueryClient.query(createTableQuery);
    console.log(`Loaded ${tableUri} into ${datasetName}.${tableName}`);
  } catch (error) {
    console.error('Error creating external table:', error);
  }
}

loadExternalTable();