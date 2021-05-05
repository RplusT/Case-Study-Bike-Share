-- Adding derived values to columns

UPDATE public."202004-202103-divvy-tripdata"
SET duration = EXTRACT(EPOCH FROM (ended_at - started_at))
--- The query above adds duration of the ride, measured in seconds

UPDATE public."202004-202103-divvy-tripdata"
SET day_of_week = EXTRACT(ISODOW FROM started_at);

UPDATE public."202004-202103-divvy-tripdata"
SET day = EXTRACT(DAY FROM started_at);

UPDATE public."202004-202103-divvy-tripdata"
SET month = EXTRACT(MONTH FROM started_at);

UPDATE public."202004-202103-divvy-tripdata"
SET year = EXTRACT(YEAR FROM started_at);