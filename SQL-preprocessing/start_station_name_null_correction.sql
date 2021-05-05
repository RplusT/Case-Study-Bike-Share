-- Filling up NULL start_station_name with correct values where available

UPDATE public."202004-202103-divvy-tripdata"
SET start_station_name = t.start_station_name
FROM (
	SELECT DISTINCT ON (start_coord) start_coord, start_station_name
	FROM public."202004-202103-divvy-tripdata"
	WHERE start_station_name IS NOT NULL
	ORDER BY start_coord, start_station_name
) AS t
WHERE
	t.start_coord = public."202004-202103-divvy-tripdata".start_coord AND
	public."202004-202103-divvy-tripdata".start_station_name IS NULL