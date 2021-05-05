-- Filling up NULL start_station_id with correct values where available

UPDATE public."202004-202103-divvy-tripdata"
SET start_station_id = t.start_station_id
FROM (
	SELECT DISTINCT ON (start_coord) start_coord, start_station_id
	FROM public."202004-202103-divvy-tripdata"
	WHERE start_station_id IS NOT NULL
	ORDER BY start_coord, start_station_id
) AS t
WHERE
	t.start_coord = public."202004-202103-divvy-tripdata".start_coord AND
	public."202004-202103-divvy-tripdata".start_station_id IS NULL