-- Filling up NULL end_station_name with correct values where available

UPDATE public."202004-202103-divvy-tripdata"
SET end_station_name = t.end_station_name
FROM (
	SELECT DISTINCT ON (end_coord) end_coord, end_station_name
	FROM public."202004-202103-divvy-tripdata"
	WHERE end_station_name IS NOT NULL
	ORDER BY end_coord, end_station_name
) AS t
WHERE
	t.end_coord = public."202004-202103-divvy-tripdata".end_coord AND
	public."202004-202103-divvy-tripdata".end_station_name IS NULL