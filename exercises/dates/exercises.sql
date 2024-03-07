-- Dates

-- Exercise 1: Produce a TIMESTAMP for 1 a.m. on the 31st of August 2012
SELECT TIMESTAMP '2012-08-31 01:00:00';

-- Exercise 2: Subtract TIMESTAMPs from each other
SELECT (TIMESTAMP '2012-08-31 01:00:00') - (TIMESTAMP '2012-07-30 01:00:00') AS interval;

-- Exercise 3: Generate a list of all the dates in October 2012
-- generate_series is a postgresql function
SELECT generate_series(TIMESTAMP '2012-10-01', TIMESTAMP '2012-10-31', interval '1 day') AS ts;

-- Exercise 4: Get the day of the month from a timestamp
SELECT EXTRACT(DAY FROM TIMESTAMP '2012-08-31') AS date_part;

-- Exercise 5: Work out the number of seconds between timestamps
SELECT ROUND(EXTRACT(EPOCH FROM (TIMESTAMP '2012-09-02 00:00:00' - TIMESTAMP '2012-08-31 01:00:00'))) AS date_part;

-- Exercise 6: Work out the number of days in each month of 2012
SELECT 
    EXTRACT(MONTH FROM generate_series) AS month,
    COUNT(*) || ' ' || 'days' AS length
FROM 
    generate_series(timestamp '2012-01-01', timestamp '2012-12-31', interval '1 day') AS generate_series
GROUP BY 
    EXTRACT(MONTH FROM generate_series)
ORDER BY month;

-- Exercise 7: Work out the number of days remaining in the month
SELECT (timestamp '2012-03-01') - (timestamp '2012-02-11') as remaining;

-- Exercise 8: Work out the end time of bookings
SELECT 
	starttime, 
	starttime + slots * (INTERVAL '30 minutes') as endtime
FROM 
	cd.bookings
ORDER BY
	endtime DESC,
	starttime DESC
LIMIT 10;

-- Exercise 9: Return a count of bookings for each month
SELECT
	DATE_TRUNC('MONTH', STARTTIME) AS MONTH,
	COUNT(*)
FROM 
	CD.BOOKINGS
GROUP BY
	MONTH
ORDER BY
	MONTH

-- Exercise 10: Work out the utilisation percentage for each facility by month
SELECT 
	NAME,
	MONTH,
	ROUND((100 * SLOTS)/CAST(25 * (CAST((MONTH + INTERVAL '1 MONTH') AS DATE) - CAST (MONTH AS DATE)) AS NUMERIC), 1) AS UTILISATION
FROM 
	(
	  SELECT FACILITIES.NAME AS NAME, DATE_TRUNC('MONTH', STARTTIME) AS MONTH, SUM(SLOTS) AS SLOTS
	  	FROM CD.BOOKINGS BOOKINGS
	  	INNER JOIN CD.FACILITIES FACILITIES ON BOOKINGS.FACID = FACILITIES.FACID
	  	GROUP BY FACILITIES.FACID, MONTH
	  ) AS INN
ORDER BY NAME, MONTH