-- Adding coordinate values to coord columns

UPDATE public."202004-202103-divvy-tripdata"
SET start_coord = CONCAT(start_lat, ', ', start_lng);

UPDATE public."202004-202103-divvy-tripdata"
SET end_coord = CONCAT(end_lat, ', ', end_lng);