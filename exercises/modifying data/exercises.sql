-- Updates

-- Exercise 1: Insert some data into a table
INSERT INTO CD.FACILITIES (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Exercise 2: Insert multiple rows of data into a table
INSERT 
	INTO CD.FACILITIES (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
VALUES 
	(9, 'Spa', 20, 30, 100000, 800),
	(10, 'Squash Court 2', 3.5, 17.5, 5000, 80);

-- Exercise 3: Insert calculated data into a table
-- The facid column needs to be autoincrement for generate automatically.
INSERT INTO CD.FACILITIES (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Exercise 4: Update some existing data
UPDATE 
  cd.facilities
SET 
  initialoutlay = 10000
WHERE 
  facid = 1

-- Exercise 5: Update multiple rows and columns at the same time
UPDATE
	cd.facilities
SET 
	membercost = 6,
	guestcost = 30
WHERE
	facid IN (0, 1);


-- Exercise 6: Update a row based on the contents of another row
UPDATE cd.facilities
SET 
    membercost = ROUND((membercost * 1.1), 1),
    guestcost = ROUND((guestcost * 1.1), 1)
WHERE
    facid = 1;
  
-- Exercise 7: Delete all bookings
DELETE FROM cd.bookings;

-- Exercise 8: Delete a member from the cd.members table
DELETE FROM cd.members
WHERE memid = 37;

-- Exercise 9: Delete based on a subquery
DELETE FROM cd.members
WHERE memid NOT IN (SELECT memid FROM cd.bookings);
