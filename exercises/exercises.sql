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
FROM cd.facilities