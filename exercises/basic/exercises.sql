-- Basic

-- Exercise 1: Retrieve everything from a table
SELECT * FROM cd.facilities;

-- Exercise 2: Retrieve specific columns from a table
SELECT name, membercost FROM cd.facilities;

-- Exercise 3: Control which rows are retrieved
SELECT * FROM cd.facilities WHERE membercost > 0;

-- Exercise 4: Control which rows are retrieved - part 2
SELECT facid, name, membercost, monthlymaintenance FROM cd.facilities WHERE membercost > 0 and membercost < (monthlymaintenance * 1/50);

-- Exercise 5: Basic string searches
SELECT * FROM cd.facilities WHERE name LIKE '%Tennis%';

-- Exercise 6: Matching against multiple possible values
SELECT * FROM cd.facilities WHERE facid IN (1, 5);
SELECT * FROM cd.facilities WHERE facid = 1 OR facid = 5;

-- Exercise 7: Classify results into buckets
SELECT name,
	CASE 
		WHEN monthlymaintenance > 100 THEN 'expensive'
		ELSE 'cheap'
	END AS cost
FROM cd.facilities;

-- Exercise 8: Working with dates
SELECT memid, surname, firstname, joindate FROM cd.members WHERE joindate >= '2012-09-01';

-- Exercise 9: Removing duplicates, and ordering results
SELECT DISTINCT surname FROM cd.members ORDER BY surname LIMIT 10;

-- Exercise 10: Combining results from multiple queries
SELECT surname FROM cd.members UNION SELECT name FROM cd.facilities;

-- Exercise 11: Simple aggregation
SELECT MAX(joindate) as latest FROM cd.members;

-- Exercise 12: More aggregation
SELECT firstname, surname, joindate FROM cd.members WHERE joindate = (SELECT MAX(joindate) FROM cd.members);
