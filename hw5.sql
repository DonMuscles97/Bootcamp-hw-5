IF OBJECT_ID ('dbo.pricing') IS NOT NULL
DROP FUNCTION dbo.pricing;
GO
CREATE FUNCTION dbo.pricing (@price DECIMAL(18,2), @quantity DECIMAL(18,2))
RETURNS DECIMAL(18,2)
AS
BEGIN
DECLARE @ret DECIMAL(18,2);  
    SELECT @ret = @price * @quantity ;
     IF (@ret IS NULL)   
        SET @ret = 0;  
    RETURN @ret;  
END

GO

SELECT *, dbo.pricing(supPrice, amountSup) AS total FROM supSales;

-- 1. Write a query to return a “report” of all users and their roles
SELECT owners.ownerName, roles.roleName, roles.roleDescription FROM owners JOIN roles ON owners.ownerID = roles.roleID

-- 2. Write a query to return all classes and the count of guests that hold those classes

SELECT class.className, COUNT(*) classCount FROM classLevel
 LEFT JOIN class ON class.classID = classLevel.classID
 LEFT JOIN  guests ON guests.guestID = classLevel.guestID
 GROUP BY className

-- 3 - 4 Write a query that returns all guests ordered by name (ascending) and their classes and corresponding levels. Add a column that labels them beginner (lvl 1-5), intermediate (5-10) and expert (10+) for their classes (Don’t alter the table for this)
-- Write a function that takes a level and returns a “grouping” from question 3 (e.g. 1-5, 5-10, 10+, etc)

IF OBJECT_ID ('dbo.lvlrank') IS NOT NULL
DROP FUNCTION dbo.lvlrank;
GO

CREATE FUNCTION dbo.lvlrank (@lvl INT)
RETURNS VARCHAR(50)
AS 
BEGIN
DECLARE @ret INT;
DECLARE @rank VARCHAR(50)
SELECT @ret = (@lvl)
IF @ret <= 40 SET @rank = 'Beginner'
IF  @ret BETWEEN 41 AND 70 SET @rank = 'Intermediate'
IF @ret >= 71 SET @rank = 'Advanced';
RETURN @rank
END
GO

SELECT names, className, levelNumber, dbo.lvlrank(levelNumber) rankings FROM classLevel 
JOIN class ON class.classID = classLevel.classID
JOIN guests ON classLevel.classID = guests.guestID
ORDER BY  names

-- 5. Write a function that returns a report of all open rooms (not used) on a particular day (input) and which tavern they belong to.

-- Yeah I got pretty confused on the rest of the hw.

IF OBJECT_ID ('dbo.openRooms') IS NOT NULL
DROP FUNCTION dbo.openRooms;
GO

CREATE FUNCTION dbo.openRooms (@date DATE)
RETURNS TABLE
AS 
RETURN
(	
	SELECT rooms.roomID, taverns.tavernID
	FROM roomSales
	JOIN rooms ON rooms.roomID = roomSales.roomID
	JOIN taverns ON rooms.tavernID = taverns.tavernID