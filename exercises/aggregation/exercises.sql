-- Aggregation

-- Exercise 1: Count the number of facilities
SELECT COUNT(*) FROM cd.facilities;

-- Exercise 2: Count the number of expensive facilities
SELECT COUNT(*) 
FROM 
	cd.facilities
WHERE
	guestcost >= 10;

-- Exercise 3: Count the number of recommendations each member makes.
SELECT 
	m1.recommendedby,
	COUNT(*)
FROM 
	cd.members AS m1
INNER JOIN
	cd.members AS m2 ON m1.recommendedby = m2.memid
GROUP BY
	m1.recommendedby
ORDER BY
	m1.recommendedby;

-- Exercise 4: List the total slots booked per facility
SELECT
	facid,
	SUM(slots) AS "Total Slots"
FROM 
	cd.bookings
	GROUP BY facid
ORDER BY facid;


-- Exercise 5: List the total slots booked per facility in a given month
SELECT
	facid,
	SUM(slots) AS "Total Slots"
FROM 
	cd.bookings
WHERE
	starttime >= '2012-09-01' AND
	starttime < '2012-10-01'
GROUP BY facid
ORDER BY "Total Slots";

-- Exercise 6: List the total slots booked per facility per month
SELECT
	facid,
	EXTRACT (MONTH FROM starttime) AS month,
	SUM(slots) AS "Total Slots"
FROM
	cd.bookings
WHERE
	EXTRACT (YEAR FROM starttime) = '2012'
GROUP BY facid, month
ORDER BY facid, month

-- Exercise 7: Find the count of members who have made at least one booking
SELECT COUNT(DISTINCT memid) FROM cd.bookings;

-- Exercise 8: List facilities with more than 1000 slots booked
SELECT 
	facid,
	SUM(slots) AS "Total Slots"
FROM 
	cd.bookings
GROUP BY 
	facid
HAVING 
  SUM(slots) > 1000
ORDER BY 
	facid;

-- Exercise 9: Find the total revenue of each facility
SELECT 
	facilities.name,
	SUM(slots * CASE
		WHEN memid = 0 THEN facilities.guestcost
		ELSE facilities.membercost
	END) AS revenue
FROM 
  cd.bookings AS bookings
INNER JOIN 
  cd.facilities AS facilities 
  ON bookings.facid = facilities.facid
GROUP BY 
  facilities.name
ORDER BY 
  revenue

-- Exercise 10: Find facilities with a total revenue less than 1000
SELECT 
	facilities.name,
	SUM(slots * CASE
		WHEN memid = 0 THEN facilities.guestcost
		ELSE facilities.membercost
	END) AS revenue
FROM 
  cd.bookings AS bookings
INNER JOIN 
  cd.facilities AS facilities 
  ON bookings.facid = facilities.facid
GROUP BY 
  facilities.name
HAVING SUM(slots * CASE
		WHEN memid = 0 THEN facilities.guestcost
		ELSE facilities.membercost
	END) < 1000
ORDER BY 
  revenue

-- Exercise 11: Output the facility id that has the highest number of slots booked
SELECT 
	facid,
	SUM(slots) AS "Total Slots"
FROM 
	cd.bookings
GROUP BY 
	facid
ORDER BY 
	SUM(slots) DESC
LIMIT 1

-- Exercise 12: List the total slots booked per facility per month, part 2
SELECT
	facid,
	EXTRACT (MONTH FROM starttime) AS month,
	SUM(slots) AS "Total Slots"
FROM
	cd.bookings
WHERE
	EXTRACT (YEAR FROM starttime) = '2012'
GROUP BY 
  ROLLUP(facid, month)
ORDER BY 
  facid, month;

-- Exercise 13: List the total hours booked per named facility
-- Review this query 
SELECT 
	FACILITIES.FACID,
	FACILITIES.NAME,
	TRIM(TO_CHAR(SUM(BOOKINGS.SLOTS)/2.0, '9999999999999999D99')) AS "Total Hours"
FROM
	CD.BOOKINGS BOOKINGS
INNER JOIN
	CD.FACILITIES FACILITIES ON FACILITIES.FACID = BOOKINGS.FACID
GROUP BY
	FACILITIES.FACID
ORDER BY 
	FACILITIES.FACID;

-- Exercise 14: List each member's first booking after September 1st 2012
SELECT
	MEMBERS.SURNAME,
	MEMBERS.FIRSTNAME,
	MEMBERS.MEMID,
	MIN(BOOKINGS.STARTTIME) AS STARTTIME
FROM 
	CD.MEMBERS MEMBERS
INNER JOIN CD.BOOKINGS BOOKINGS ON BOOKINGS.MEMID = MEMBERS.MEMID
WHERE
	BOOKINGS.STARTTIME >= '2012-09-01'
GROUP BY 
	MEMBERS.SURNAME, 
	MEMBERS.FIRSTNAME, 
	MEMBERS.MEMID
ORDER BY 
	MEMID;
