-- Recursive Queries

-- Exercise 1: Find the upward recommendation chain for member ID 27
WITH RECURSIVE recommenders(recommender) AS (
	SELECT recommendedby FROM cd.members WHERE memid = 27
	UNION ALL
	SELECT mems.recommendedby
		FROM recommenders recs
		INNER JOIN cd.members mems
			ON mems.memid = recs.recommender
)
SELECT 
	recs.recommender,
	mems.firstname,
	mems.surname
FROM 
	recommenders recs
INNER JOIN cd.members mems
	ON recs.recommender = mems.memid
ORDER BY memid DESC;

-- Exercise 2: Find the downward recommendation chain for member ID 1
WITH RECURSIVE recommendeds(recommended) AS (
	SELECT memid FROM cd.members WHERE recommendedby = 1
	UNION ALL
	SELECT members.memid 
		FROM recommendeds recs
		INNER JOIN cd.members members
			ON members.recommendedby = recs.recommended
)

SELECT 
	recs.recommended AS memid,
	members.firstname,
	members.surname
FROM 
	recommendeds recs
INNER JOIN cd.members members	
	ON recs.recommended = members.memid
ORDER BY recommended;

-- Exercise 3: Produce a CTE that can return the upward recommendation chain for any member
WITH RECURSIVE recommenders(recommender, member) AS (
	SELECT recommendedby, memid FROM cd.members
	UNION ALL
	SELECT mems.recommendedby, recs.member
		FROM recommenders recs
		INNER JOIN cd.members mems
			ON mems.memid = recs.recommender
)
SELECT 
	recs.member,
	recs.recommender,
	mems.firstname,
	mems.surname
FROM 
	recommenders recs
INNER JOIN cd.members mems
	ON recs.recommender = mems.memid
	WHERE recs.member = 22 OR recs.member = 12
ORDER BY recs.member ASC, recs.recommender DESC;