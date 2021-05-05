--Creating the consolidated table

CREATE TABLE public."202004-202103-divvy-tripdata" AS (
	SELECT *
	FROM
		public."202004-divvy-tripdata"
	UNION ALL
	SELECT *
	FROM
		public."202005-divvy-tripdata"
	SELECT *
	FROM
		public."202006-divvy-tripdata"
	SELECT *
	FROM
		public."202007-divvy-tripdata"
	SELECT *
	FROM
		public."202008-divvy-tripdata"
	SELECT *
	FROM
		public."202009-divvy-tripdata"
	SELECT *
	FROM
		public."202010-divvy-tripdata"
	SELECT *
	FROM
		public."202011-divvy-tripdata"
	SELECT *
	FROM
		public."202012-divvy-tripdata"
	SELECT *
	FROM
		public."202101-divvy-tripdata"
	SELECT *
	FROM
		public."202102-divvy-tripdata"
	SELECT *
	FROM
		public."202103-divvy-tripdata"
)
