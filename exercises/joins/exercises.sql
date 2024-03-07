-- Joins

-- Exercise 1: Retrieve the start times of members' bookings
SELECT starttime FROM cd.bookings WHERE memid = (SELECT memid FROM cd.members WHERE firstname LIKE 'David' AND surname LIKE 'Farrell');

-- Exercise 2: Work out the start times of bookings for tennis courts
SELECT 
    b.starttime AS start, 
    f.name AS name
FROM 
    cd.bookings AS b
JOIN 
    cd.facilities AS f ON b.FACID = f.facid
WHERE 
    b.facid IN (0, 1)
    AND b.starttime >= '2012-09-21'
    AND b.starttime < '2012-09-22'
ORDER BY 
    starttime;

-- Exercise 3: Produce a list of all members who have recommended another member
SELECT DISTINCT
	firstname,
	surname
FROM 
	cd.members
WHERE
	memid IN (
		SELECT recommendedby 
		FROM cd.members 
		WHERE recommendedby IS NOT NULL
	)
ORDER BY 
	surname;

-- Exercise 4: Produce a list of all members, along with their recommender
SELECT
	m1.firstname AS memfname,
	m1.surname AS memsname,
	m2.firstname AS recfname,
	m2.surname AS recsname
FROM 
	cd.members AS m1
LEFT JOIN 
	cd.members AS m2
ON 
	m1.recommendedby = m2.memid
ORDER BY 
	m1.surname, m1.firstname;

-- Exercise 5: Produce a list of all members who have used a tennis court
SELECT DISTINCT
    members.firstname || ' ' || members.surname AS member,
    facilities.name AS facility
FROM 
    cd.facilities
INNER JOIN
    cd.bookings AS bookings ON facilities.facid = bookings.facid
INNER JOIN
    cd.members AS members ON bookings.memid = members.memid
WHERE 
    facilities.name LIKE 'Tennis Court%'
ORDER BY 
	member, facility;

-- Exercise 6: Produce a list of costly bookings
SELECT 
	members.firstname || ' ' || members.surname AS member,
	facilities.name as facility,
	CASE
		WHEN members.memid = 0 THEN facilities.guestcost * bookings.slots
		ELSE facilities.membercost * bookings.slots
	END AS cost
FROM 
	cd.members AS members
INNER JOIN
	cd.bookings as bookings ON bookings.memid = members.memid
INNER JOIN
	cd.facilities as facilities ON facilities.facid = bookings.facid
WHERE 
	bookings.starttime >= '2012-09-14' AND 
	bookings.starttime < '2012-09-15' AND 
	((members.memid = 0 AND facilities.guestcost * bookings.slots > 30) OR (members.memid != 0 AND facilities.membercost * bookings.slots > 30 ))
ORDER BY cost DESC

-- Exercise 7: Produce a list of all members, along with their recommender, using no joins.
SELECT DISTINCT
	m1.firstname || ' ' || m1.surname AS member,
	(
		SELECT 
			m2.firstname || ' ' || m2.surname
		FROM
			cd.members AS m2
		WHERE
			m2.memid = m1.recommendedby
	) AS recommender
FROM 
	cd.members AS m1
ORDER BY
	member;

-- Exercise 8: Produce a list of costly bookings, using a subquery
SELECT 
    (SELECT firstname || ' ' || surname FROM cd.members WHERE memid = bookings.memid) AS member,
    (SELECT name FROM cd.facilities WHERE facid = bookings.facid) AS facility,
    CASE
        WHEN (
            SELECT memid FROM cd.members WHERE memid = bookings.memid
        ) = 0 THEN (
            SELECT guestcost FROM cd.facilities WHERE facid = bookings.facid
        ) * bookings.slots
        ELSE (
            SELECT membercost FROM cd.facilities WHERE facid = bookings.facid
        ) * bookings.slots
    END AS cost
FROM 
    cd.bookings
WHERE 
    starttime >= '2012-09-14' 
    AND starttime < '2012-09-15' 
    AND (
        (
            (SELECT memid FROM cd.members WHERE memid = bookings.memid) = 0 
            AND (
                SELECT guestcost FROM cd.facilities WHERE facid = bookings.facid
            ) * bookings.slots > 30
        ) 
        OR (
            (SELECT memid FROM cd.members WHERE memid = bookings.memid) != 0 
            AND (
                SELECT membercost FROM cd.facilities WHERE facid = bookings.facid
            ) * bookings.slots > 30
        )
    )
ORDER BY 
    cost DESC;