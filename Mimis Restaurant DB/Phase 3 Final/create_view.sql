use cecs323sec01bg01;

/*	1
Item_v – For each Menu item, give it’s spiciness, AND all of the different costs for
that item. If a given item is not on a particular Menu, then report “N/A” for that particular
item for that particular Menu. Also, if an item only appears as a single serving portion,
put in “N/A” into the report for the gallon, … prices.
*/

DROP VIEW IF EXISTS MenuItem_v; 
 CREATE VIEW MenuItem_v AS
	SELECT Menu.menuType, Menu.item,  Menu.spice, Menu.price, 'N/A' as `Size`
    FROM Menu
    WHERE Menu.Item NOT LIKE '%cup%' AND  Menu.Item NOT LIKE '%bowl%' AND  Menu.Item NOT LIKE '%pint%' AND  Menu.Item NOT LIKE '%quart%' AND  Menu.Item NOT LIKE '%gallon%'
    UNION
    SELECT Menu.menuType, Menu.item, Menu.spice, Menu.price, 'Cup' as `Size`
    FROM Menu
    WHERE Menu.Item LIKE '%Cup%'
    UNION
    SELECT Menu.menuType, Menu.item, Menu.spice, Menu.price, 'Bowl' as `Size`
    FROM Menu
    WHERE Menu.Item LIKE '%bowl%'
	UNION
    SELECT Menu.menuType, Menu.item, Menu.spice, Menu.price, 'Pint' as `Size`
    FROM Menu
    WHERE Menu.Item LIKE '%pint%'
	UNION
    SELECT Menu.menuType, Menu.item, Menu.spice, Menu.price, 'Quart' as `Size`
    FROM Menu
    WHERE Menu.Item LIKE '%quart%'
	UNION
    SELECT Menu.menuType, Menu.item, Menu.spice, Menu.price, 'Gallon' as `Size`
    FROM Menu
    WHERE Menu.Item LIKE '%gallon%'
    UNION
    SELECT DISTINCT 'Childrens' AS menuType, Menu.item, Menu.spice, 'N/a' as price, 'N/a' as `Size`
    FROM Menu
    WHERE (Menu.item, Menu.spice) NOT IN (
		SELECT Menu.item, Menu.spice
        FROM Menu
        WHERE Menu.menuType = 'Childrens')
	UNION
    SELECT DISTINCT 'Evening' AS menuType, Menu.item, Menu.spice, 'N/a' as price, 'N/a' as `Size`
    FROM Menu
    WHERE (Menu.item, Menu.spice) NOT IN (
		SELECT Menu.item, Menu.spice
        FROM Menu
        WHERE Menu.menuType = 'Evening')
	UNION
    SELECT DISTINCT 'Lunch' AS menuType, Menu.item, Menu.spice, 'N/a' as price, 'N/a' as `Size`
    FROM Menu
    WHERE (Menu.item, Menu.spice) NOT IN (
		SELECT Menu.item, Menu.spice
        FROM Menu
        WHERE Menu.menuType = 'Lunch')
        UNION
    SELECT DISTINCT 'Sunday Brunch Buffet' AS menuType, Menu.item, Menu.spice, 'N/a' as price, 'N/a' as `Size`
    FROM Menu
    WHERE (Menu.item, Menu.spice) NOT IN (
		SELECT Menu.item, Menu.spice
        FROM Menu
        WHERE Menu.menuType = 'Sunday Brunch Buffet')
	ORDER BY menuType, item;

SELECT * FROM MenuItem_v;

    
/*		2
Customer_addresses_v – for each customer, indicate whether they are an individual or a
corporate account, and display all of the information that we are managing for that
customer.
*/

DROP VIEW IF EXISTS Customer_addresses_v; 
CREATE VIEW Customer_addresses_v AS
	SELECT 'CORPORATE' AS `ACCOUNT TYPE`, custID, corpName as `NAME`, corpAddress as `ADDRESS`, mimingsMoney, corpOrganization, contactInfo
	FROM PaidCustomer
    WHERE corpName IS NOT NULL
    UNION
    SELECT 'CUSTOMER' as `ACCOUNT TYPE`, 	custID, customerName as `NAME`, custAddress, mimingsMoney, 'N/A' as corpOrganization, 'N/A' as contactInfo
    FROM PaidCustomer
    WHERE corpName IS NULL;

SELECT * FROM Customer_addresses_v;    


/*		3

Sous_mentor_v – reports all the mentor/mentee relationships at Miming’s, sorted by the
name of the mentor, then the name of the mentee. Show the skill that the mentorship
passes, as well as the start date.

*/

DROP VIEW IF EXISTS Sous_mentor_v;
CREATE VIEW Sous_mentor_v AS
	SELECT `MENTOR`.eLastName AS `MENTOR LAST NAME`, `MENTOR`.eFirstName AS `MENTOR FIRST NAME`,  `MENTEE`.eLastName AS `MENTEE LAST NAME`, `MENTEE`.eFirstName AS `MENTEE FIRST NAME`, item, startDate
    FROM Mentorship
    INNER JOIN Employee AS `MENTOR` ON 	`MENTOR`.employeeID = Mentorship.sousChefMentor
    INNER JOIN Employee AS `MENTEE` ON `MENTEE`.employeeID = Mentorship.sousChefMentee
    ORDER BY
    	`MENTOR`.eLastName ASC,
        `MENTOR`.eFirstName ASC,
        `MENTEE`.eLastName ASC,
        `MENTEE`.eFirstName ASC
        ;
   
SELECT * FROM  Sous_mentor_v;


/*		4
Customer_Sales_v – On a year by year basis, show how much each customer has spent at
Miming’s.
*/

DROP VIEW IF EXISTS Customer_Sales_v;
CREATE VIEW Customer_Sales_v  AS 
	SELECT PaidCustomer.customerName, SUM(total) AS 'AMOUNT SPENT', YEAR(`date`) as 'YEAR'
    FROM `Check`
    INNER JOIN PaidCustomer ON PaidCustomer.custID = `Check`.custID
    GROUP BY `Check`.custID, YEAR(`date`);

SELECT * FROM  Customer_Sales_v;


/*		5


Customer_Value_v – List each customer and the total $ amount of their orders for the
past year, in order of the value of customer orders, from highest to the lowest.
*/
DROP VIEW IF EXISTS Customer_Value_v;
CREATE VIEW Customer_Value_v  AS
    SELECT PaidCustomer.customerName, SUM(total) AS 'AMOUNT SPENT', YEAR(`date`) AS 'YEAR'
    FROM `Check`
    INNER JOIN PaidCustomer ON PaidCustomer.custID = `Check`.custID
    WHERE `Check`.date BETWEEN (CURDATE() - INTERVAL 1 YEAR) AND CURDATE()
    GROUP BY `Check`.custID, 'YEAR'
    ORDER BY
        'AMOUNT SPENT' DESC;
        
SELECT * FROM  Customer_Value_v;

