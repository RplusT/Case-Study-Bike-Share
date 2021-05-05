-- Adding combined coordinates columns for start station and end station

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN start_coord TEXT,
ADD COLUMN end_coord TEXT;