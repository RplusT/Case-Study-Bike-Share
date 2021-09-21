## Preprocessing Walkthrough
### Dataset Details
1. Data Location
- Originally came from this database: https://divvy-tripdata.s3.amazonaws.com/index.html
2. Data Organization
- Each month’s trip data from April 2020 to March 2021 is stored in a separate spreadsheet with the file name following this pattern: `yyyymm-companyname-tripdata`
- The data in these spreadsheets are identified by their unique `ride_id` in the first column with the following details in the other columns
  -  `rideable_type` - type of bike used
  -  `started_at` - bike trip’s starting time, with the date and time given in this format `yyyy-mm-dd hh:mm:ss` 
  -  `ended_at` - bike trip’s ending time, with the date and time given in this format `yyyy-mm-dd hh:mm:ss` 
  -  `start_station_name` - station where the trip started
  -  `start_station_id` - ID of start station
  -  `end_station_name` - station where the trip ended
  -  `end_station_id` - ID of end station
  -  `start_lat` - latitude of starting station
  -  `start_lng` - longitude of starting station
  -  `end_lat` - latitude of starting station
  -  `end_lng` - longitude of starting station
  -  `member_casual` - identifies whether customer or rider is an annual member or casual rider (non-annual member)
3. Data Credibility
- There are no issues with bias or credibility as the data came from the company itself, in collaboration with the city government of Chicago.
- It follows that the data then is reliable, original, comprehensive (enough to answer the business task), current (all 12 months needed are included, with the latest month being March 2021), and cited/vetted.

### Preprocessing
- Tool used for processing
  - PostgreSQL - pgAdmin4 GUI
- Observations
  - There were 3,489,748 bike trips from April 2020 to March 2021.
  - There were 122,175 bike trips where the `start_station_name` and `start_station_id` are NULL
  - However, all the trips have a `start_lat` and `start_lng` meaning all trips had a starting location, just not all station names were specified.
  - There were 143,242 trips where the `end_station_name` and `end_station_id` are NULL
  - There were 4,738 bike trips that did not have an ending location (given that `end_lat` and `end_lng` were NULL). However, all these trips had recorded ending times (no NULL `ended_at` values). Initial theory is that these bikes were never returned. Given that these trips comprise less than 1% of the dataset, these can be safely ignored.
  - All other columns have no NULL values.
  - Longitude and Latitude values are written inconsistently, with decimals degrees ranging from 1 to 15. For the purposes of this analysis, it is not necessary to make these decimal degrees uniform across longitude and latitude values.
  - There were 10,552 trips with negative trip durations; trips that ended earlier than when they started (`ended_at` timestamp values were earlier than `started_at`). Given that these trips comprise less than 1% of the dataset, these can be safely ignored.
- Data Cleaning and Manipulation
  - Combined all the monthly datasets into a single CSV file.
  - Renamed it as `202004-202103-divvy-tripdata`; stores all the ride data for the past year
  - Added `duration` column
    - Difference between `ended_at` and `started_at`
    - Measured in seconds
  - Added `day_of_week` column
    - Indicates day of week when trip started
  - Added `month` column
    - Indicates month of when trip started
  - Added `year` column
    - Indicated year of when trip started
  - Added `day` column
    - Indicates day of the month of when trip started (e.g. March 15, 2020)
  - Added `start_coord` and `end_coord` columns
    - `start_coord` - combines `start_lat` and `start_lng`
    - `end_coord` - combines `end_lat` and `end_lng`
  - Filled in 11,386 trips with missing `start_station_name` where available using the given coordinates
  - Filled in 9,883 trips with missing `start_station_id` where available using the given coordinates
  - Filled in 11,210 trips with missing `end_station_name` where available using the given coordinates
  - Filled in 11,317 trips with missing `end_station_id` where available using the given coordinates
  - Saved table with new columns as CSV file with file name `202004-202103-divvy-tripdata_v20210428`
