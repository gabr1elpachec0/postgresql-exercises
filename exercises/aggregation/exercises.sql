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

-- Exercise 15: Produce a list of member names, with each row containing the total member count
SELECT 
	COUNT(*) OVER() AS count,
	firstname,
	surname
FROM 
	cd.members
ORDER BY joindate;

-- Exercise 16: Produce a numbered list of members
SELECT
	ROW_NUMBER() OVER() AS row_number,
	firstname,
	surname
FROM
	cd.members
ORDER BY
	joindate;

-- Exercise 17: Output the facility id that has the highest number of slots booked, again
SELECT
	facilities.facid,
	SUM(slots) AS total
FROM
	cd.facilities facilities
INNER JOIN 
	cd.bookings bookings ON bookings.facid = facilities.facid
GROUP BY 
	facilities.facid
HAVING
	SUM(slots) = (SELECT MAX(total) FROM (SELECT SUM(slots) AS total FROM cd.bookings GROUP BY facid) AS subquery);

-- Exercise 18: Rank members by (rounded) hours used
SELECT 
	firstname,
	surname,
	((SUM(bookings.slots) + 10) / 20) * 10 AS hours,
	RANK() OVER (ORDER BY ((SUM(bookings.slots) + 10) / 20) * 10 DESC) AS rank
FROM
	cd.bookings bookings
INNER JOIN cd.members members
	ON bookings.memid = members.memid
GROUP BY 
	members.memid
ORDER BY 
	rank, 
	surname, 
	firstname;

-- Exercise 19: Find the top three revenue generating facilities
SELECT 
	name,
	RANK() OVER (ORDER BY total DESC) AS rank
FROM 
	(
		SELECT
			facilities.name,
			SUM(slots * CASE
					WHEN memid = 0 THEN facilities.guestcost
					ELSE facilities.membercost
				END) AS total
		FROM
			cd.bookings bookings
		INNER JOIN 
			cd.facilities facilities
			ON bookings.facid = facilities.facid
		GROUP BY 
			facilities.name
	) AS subquery

LIMIT 3;

-- Exercise 20: Classify facilities by value
SELECT 
	name,
	CASE 
		WHEN class=1 THEN 'high'
		WHEN class=2 THEN 'average'
		ELSE 'low'
		END revenue
FROM	
	(
		SELECT 
			facilities.name, 
			NTILE(3) OVER (ORDER BY SUM(CASE 
						WHEN memid = 0 THEN slots * facilities.guestcost
						ELSE slots * membercost END) DESC) AS class
	
		FROM cd.bookings bookings
		INNER JOIN cd.facilities facilities
			ON bookings.facid = facilities.facid
		GROUP BY facilities.name
	) AS subquery
ORDER BY class, name;

-- Exercise 21: Calculate the payback time for each facility
SELECT 
	facilities.name,
	facilities.initialoutlay/((SUM(CASE WHEN memid = 0 THEN slots * guestcost
										ELSE slots * membercost
										END) / 3) - facilities.monthlymaintenance) AS months
	FROM cd.bookings bookings
	INNER JOIN cd.facilities facilities
		ON bookings.facid = facilities.facid
	GROUP BY facilities.facid
ORDER BY name;

-- Exercise 22: Calculate a rolling average of total revenue
select 	dategen.date,
	(
		select sum(case
			when memid = 0 then slots * facs.guestcost
			else slots * membercost
		end) as rev

		from cd.bookings bks
		inner join cd.facilities facs
			on bks.facid = facs.facid
		where bks.starttime > dategen.date - interval '14 days'
			and bks.starttime < dategen.date + interval '1 day'
	)/15 as revenue
	from
	(
		select 	cast(generate_series(timestamp '2012-08-01',
			'2012-08-31','1 day') as date) as date
	)  as dategen
order by dategen.date;   