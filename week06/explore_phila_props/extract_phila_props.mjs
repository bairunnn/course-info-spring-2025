import fetch from 'node-fetch';
import fs from 'fs/promises';

const url = 'https://opendata-downloads.s3.amazonaws.com/opa_properties_public.csv';

const response = await fetch(url);
if (!response.ok) {
  throw new Error(`HTTP error! status: ${response.status}`); // Checks if the response is OK
}

await fs.writeFile( 'opa_properties.csv', await response.text());

console.log('Downloaded opa_properties.csv'); // Shows that the operation was successful
