## Slides

- Main slides: https://Weitzman-MUSA-GeoCloud/presentation_slides/week06/SLIDES.html

- Additional slides about spatial data formats: https://docs.google.com/presentation/d/18R1x1_Pscpc_TyYi5NH1RBJA7OO8wsjlG1BhYTVrvfA/edit?usp=sharing

## Code Samples

In the [explore_phila_data/](explore_phila_data/) directory you'll find extract and prepare scripts for a few datasets. I recommend reviewing them in this order:

- Extract & prepare scripts for PWD Parcels (the parcels are downloaded as a GeoJSON file).
- Extract & prepare scripts for L&I Permits (the permits are downloaded as a GeoPackage).
- Extract & prepare scripts for OPA Properties (the properties are downloaded as a CSV file with EPSG:2272 coords).
- Extract & prepare scripts for SEPTA Bus and Rail data (the GTFS file requires some ... interesting code).
  
| Script files | What they demonstrate... |
| --- | --- |
| [extract_phl_pwd_parcels.py](explore_phila_data/extract_phl_pwd_parcels.py)<br>[extract_phl_pwd_parcels.mjs](explore_phila_data/extract_phl_pwd_parcels.mjs)<br><br>[extract_phl_li_permits.py](explore_phila_data/extract_phl_li_permits.py)<br>[extract_phl_li_permits.mjs](explore_phila_data/extract_phl_li_permits.mjs)<br><br>[extract_phl_opa_properties.py](explore_phila_data/extract_phl_opa_properties.py)<br>[extract_phl_opa_properties.mjs](explore_phila_data/extract_phl_opa_properties.mjs) | - Simple downloading of data from a URL (whether it's an API or static file) |
| [extract_gtfs.py](explore_phila_data/extract_gtfs.py)<br>[extract_gtfs.mjs](explore_phila_data/extract_gtfs.mjs) | - Downloading and unzipping a GTFS feed |
| [prepare_phl_pwd_parcels.py](explore_phila_data/prepare_phl_pwd_parcels.py)<br>[prepare_phl_pwd_parcels.mjs](explore_phila_data/prepare_phl_pwd_parcels.mjs) | - Reading a GeoJSON file and converting to JSON-L |
| [prepare_phl_li_permits.py](explore_phila_data/prepare_phl_li_permits.py)<br>[prepare_phl_li_permits.mjs](explore_phila_data/prepare_phl_li_permits.mjs) | - Reading a GeoPackage file and converting to JSON-L |
| [prepare_phl_opa_properties.py](explore_phila_data/prepare_phl_opa_properties.py)<br>[prepare_phl_opa_properties.mjs](explore_phila_data/prepare_phl_opa_properties.mjs) | - Reading a CSV file and converting to JSON-L<br>- Parsing WKT data<br>- Reprojecting coordinates to 4326 |
| [prepare_gtfs.py](explore_phila_data/prepare_gtfs.py)<br>[prepare_gtfs.mjs](explore_phila_data/prepare_gtfs.mjs) | - Looping through CSV-formatted text files in a GTFS feed and converting each to JSON-L |

## In-class Exercise

Continue working on the [BigQuery & Carto](../week05/exercises/ex_load_data_into_bigquery.md) exercise. Refer to the tips in the previous week's README for help.

## Assignments

- [Assignment 02](https://github.com/Weitzman-MUSA-GeoCloud/assignment02)
- Read the following chapters(access books through [O'Reilly for Higher Education](http://hdl.library.upenn.edu.proxy.library.upenn.edu/1017/7026/1)):
    * **Data Pipelines Pocket Reference**  
      *Chapter 3: Common Data Pipeline Patterns*

    * **Designing Data-Intensive Applications**  
      *Chapter 3: Storage and Retrieval* **Only the second section (_Transaction Processing or Analytics?_) is necessary.**

      About the other _optional_ sections:  
      The first section (*Data Structures That Power Your Database*) goes in to a lot more detail about the types of indexing we were discussing this week, and the last section (*Column-Oriented Storage*) covers things we'll see in the next few weeks, but in more detail than we'll go into in class. They are optional, but feel free to read them if you enjoy technical details.
## Resources

- [_ES Modules: All You Need To Know_](https://konstantin.digital/blog/es-modules-all-you-need-to-know)