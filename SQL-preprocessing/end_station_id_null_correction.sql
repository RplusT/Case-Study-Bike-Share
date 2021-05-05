-- Filling up NULL end_station_id with correct values where available

UPDATE public."202004-202103-divvy-tripdata"
SET end_station_id = t.end_station_id
FROM (
	SELECT DISTINCT ON (end_coord) end_coord, end_station_id
	FROM public."202004-202103-divvy-tripdata"
	WHERE end_station_id IS NOT NULL
	ORDER BY end_coord, end_station_id
) AS t
WHERE
	t.end_coord = public."202004-202103-divvy-tripdata".end_coord AND
	public."202004-202103-divvy-tripdata".end_station_id IS NULL