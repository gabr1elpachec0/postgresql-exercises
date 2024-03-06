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
	firstname as memfname,
	surname as memsname,
	recommendedby
FROM 
	cd.members
order by surname, firstname;

