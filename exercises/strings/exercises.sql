-- Strings

-- Exercise 1: Format the names of members
SELECT 
	surname || ', ' || firstname AS name
FROM 
	CD.MEMBERS;

-- Exercise 2: Find facilities by a name prefix
SELECT 	
	*
FROM 
	CD.FACILITIES
WHERE
	NAME LIKE 'Tennis%'

-- Exercise 3: Perform a case-insensitive search
SELECT 	
	*
FROM 
	CD.FACILITIES
WHERE
	NAME ILIKE 'tennis%'

-- Exercise 4: Find telephone numbers with parentheses
SELECT
	MEMID,
	TELEPHONE
FROM
	CD.MEMBERS
WHERE
	TELEPHONE LIKE '(%)%';

-- Exercise 5: Pad zip codes with leading zeroes
-- It turns zipcode into text type and then returns the values
SELECT 
	LPAD(ZIPCODE::TEXT, 5, '0') AS ZIP
FROM CD.MEMBERS

-- Exercise 6: Count the number of members whose surname starts with each letter of the alphabet
SELECT 
	SUBSTR (SURNAME, 1, 1) AS LETTER,
	COUNT(*) AS COUNT
FROM
	CD.MEMBERS
GROUP BY 
  LETTER
ORDER BY 
  LETTER;

-- Exercise 7: Clean up telephone numbers
SELECT
	MEMID,
	TRANSLATE(TELEPHONE, '-() ', '') AS TELEPHONE
FROM 
	CD.MEMBERS;