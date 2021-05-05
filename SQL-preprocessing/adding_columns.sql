-- Adding columns

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN duration DOUBLE PRECISION;

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN day_of_week INTEGER;

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN day INTEGER;

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN month INTEGER;

ALTER TABLE public."202004-202103-divvy-tripdata"
ADD COLUMN year INTEGER;