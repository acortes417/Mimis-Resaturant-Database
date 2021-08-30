

/***********************BEFORE INSERT***********************/

/* Before inserting row into Check, 
calculates the total due after 
finding all orders associated with CheckID through guest 
and adding the prices together */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_INSERT`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_INSERT` BEFORE INSERT ON `Check` FOR EACH ROW
BEGIN
	SET new.total = (
		SELECT SUM(OrderDetail.quantity * Menu.price)
		FROM Guest INNER JOIN OrderDetail 
			ON Guest.guestID = OrderDetail.guestID
		INNER JOIN Menu 
			ON OrderDetail.menuType = Menu.menuType
			AND OrderDetail.item = Menu.item
			AND OrderDetail.spice = Menu.spice
		WHERE Guest.checkID = new.checkID);
END$$
DELIMITER ;



/* Before inserting a row into the check, checks if a Customer is not a PaidCustomer. 
Then check if the person who is paying is paying cash if they are not part of the PaidCustomers.
If both checks are found to be false, an error is output.*/
DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_INSERT_1`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_INSERT_1` BEFORE INSERT ON `Check` FOR EACH ROW FOLLOWS `Check_BEFORE_INSERT`
BEGIN
	IF ((new.custID NOT IN (SELECT custID FROM `PaidCustomer`)) AND new.paymentType <> 'Cash' )  THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Customer must pay in cash';		
	END IF;
END
$$
DELIMITER ;


/* When inserting a Check entry, this trigger checks if the customer is known and sees how much Mimings Money
they currently have. It takes the recently calculated total in Check_BEFORE_INSERT trigger and subtracts the customer's
Mimings Money balance from the Check's total. 
Then, we calculate the Mimings Money the customer earns on the new total owed and set that to their account. */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_INSERT_2`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_INSERT_2` BEFORE INSERT ON `Check` FOR EACH ROW FOLLOWS `Check_BEFORE_INSERT_1`
BEGIN
	  DECLARE paidCustomerCount INT;
    DECLARE customerMimingsMoney FLOAT;
    SELECT COUNT(custID) INTO paidCustomerCount
    FROM PaidCustomer
    WHERE custID = new.custID;
    SELECT mimingsMoney into customerMimingsMoney
    FROM PaidCustomer
    WHERE custID = new.custID;
    IF paidCustomerCount > 0 THEN
		SET new.total = new.total - customerMimingsMoney;
        UPDATE PaidCustomer
        SET mimingsMoney = floor(new.total/10)
        WHERE custID = new.custID;
	END IF;
END
$$
DELIMITER ;


/* When inserting a Item entry, this trigger checks if the Head Chef can be associated with the item. If that Head Chef is already associated with 9 Menu Items, then an error is thrown. */


DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Item_BEFORE_INSERT`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Item_BEFORE_INSERT` BEFORE INSERT ON `Item` FOR EACH ROW
BEGIN
	DECLARE headChefCount INT;
	SELECT COUNT(headChef) INTO headChefCount
    FROM Item
    GROUP BY headChef
    HAVING headChef = new.headChef;
    IF headChefCount >= 9 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The Head Chef is too good at creating items. Only 9 is allowed.';
	END IF;

END$$
DELIMITER ;



/*Before a TableShift is inserted, count tables tat are in the TableShift.
If there are too many tables in table shift, an error is thrown.*/

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`TableShift_BEFORE_INSERT`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`TableShift_BEFORE_INSERT` BEFORE INSERT ON `TableShift` FOR EACH ROW
BEGIN
	DECLARE TableCount int;
	SELECT COUNT(employeeID) INTO TableCount
	FROM TableShift
	WHERE shiftID = new.shiftID AND employeeID = new.employeeID;
	IF (TableCount >= 5) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Too Many Tables on shift';	
	END IF;

END$$
DELIMITER ;



/*Before a Mentorship is inserted, we first ensure that the specified mentor has no more than 3 active mentorships at any moment.
If it is found that the given mentor 3 mentors already, an error is thrown. They must wait until the mentor can accept more mentees.*/

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Mentorship_BEFORE_INSERT`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Mentorship_BEFORE_INSERT` BEFORE INSERT ON `Mentorship` FOR EACH ROW
BEGIN
	DECLARE MentorCount int;
	
    SELECT COUNT(sousChefMentor) INTO MentorCount
    FROM Mentorship
    WHERE sousChefMentor = new.sousChefMentor and endDate IS NULL;

	IF (MentorCount >= 3) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'Unable to assign mentee to mentor because the mentor already has a max of 3';
	END IF;

END$$
DELIMITER ;




/* Before inserting row into PaidCustomer, counts how many null values are being entered to make sure that all  
corporate values are either completed or left null */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`PaidCustomer_BEFORE_INSERT`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`PaidCustomer_BEFORE_INSERT` BEFORE INSERT ON `PaidCustomer` FOR EACH ROW
BEGIN
	DECLARE nulls int;
	SELECT ISNULL(new.corpName) + ISNULL(new.corpAddress) + ISNULL(new.corpOrganization) + ISNULL(new.contactInfo) INTO nulls;
	IF nulls BETWEEN 1 AND 3 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'All corporate values must be either filled in or left null';
	END IF;

END$$
DELIMITER ;



/***********************BEFORE UPDATE***********************/

/* Before updating row in Check, calculates total by finding all orders associated with CheckID through guest and adding prices together */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_UPDATE`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_UPDATE` BEFORE UPDATE ON `Check` FOR EACH ROW
BEGIN
	SET new.total = (
		SELECT SUM(OrderDetail.quantity * Menu.price)
		FROM Guest INNER JOIN OrderDetail 
			ON Guest.guestID = OrderDetail.guestID
		INNER JOIN Menu 
			ON OrderDetail.menuType = Menu.menuType
			AND OrderDetail.item = Menu.item
			AND OrderDetail.spice = Menu.spice
		WHERE Guest.checkID = new.checkID);
END$$
DELIMITER ;



/*Before Updating a check row, checks if a Customer is not a PaidCustomer. 
It then checks to ensure that the check payer is paying cash if they are not part of the paidcustomers. If both checks are found to be false, an error is output.*/

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_UPDATE_1`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_UPDATE_1` BEFORE UPDATE ON `Check` FOR EACH ROW FOLLOWS `Check_BEFORE_UPDATE`
BEGIN
	IF ((new.custID NOT IN (SELECT custID FROM `PaidCustomer`)) AND new.paymentType <> 'Cash' )  THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Customer must pay in cash';		
	END IF;
END$$
DELIMITER ;




/* When updating a Check entry, this trigger checks if the customer is not anonymous and sees how much Mimings Money
they currently have. 
It takes the recently calculated total Check_BEFORE_INSERT trigger and subtracts the customer's
Mimings Money balance from the Check's total. 
Then, we calculate the Mimings Money the customer earns based on the new amount that 
they owe and set that to their account. */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Check_BEFORE_UPDATE_2`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Check_BEFORE_UPDATE_2` BEFORE UPDATE ON `Check` FOR EACH ROW FOLLOWS `Check_BEFORE_UPDATE_1`
BEGIN
	DECLARE paidCustomerCount INT;
    DECLARE customerMimingsMoney FLOAT;
    SELECT COUNT(custID) INTO paidCustomerCount
    FROM PaidCustomer
    WHERE custID = new.custID;
    SELECT mimingsMoney into customerMimingsMoney
    FROM PaidCustomer
    WHERE custID = new.custID;
    IF paidCustomerCount > 0 THEN
		SET new.total = new.total - customerMimingsMoney;
        UPDATE PaidCustomer
        SET mimingsMoney = floor(new.total/10)
        WHERE custID = new.custID;
	END IF;
END
$$
DELIMITER ;


/* When updating a Item entry, this trigger checks if the Head Chef to be associated with the new Item can. If that Head Chef is already associated with 9 Items, then an error is thrown. */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Item_BEFORE_UPDATE`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Item_BEFORE_UPDATE` BEFORE UPDATE ON `Item` FOR EACH ROW
BEGIN
	DECLARE headChefCount INT;
	SELECT COUNT(headChef) INTO headChefCount
    FROM Item
    GROUP BY headChef
    HAVING headChef = new.headChef;
    IF headChefCount >= 9 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='The Head Chef is too good at creating items. Only 9 is allowed.';
	END IF;

END$$
DELIMITER ;



/*Before a TableShift is updated, we count how many tables are in the TableShift. If there are too many tables, an error is thrown.*/
DROP TRIGGER IF EXISTS `cecs323sec01bg06`.`TableShift_BEFORE_UPDATE`;

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`TableShift_BEFORE_UPDATE`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`TableShift_BEFORE_UPDATE` BEFORE UPDATE ON `TableShift` FOR EACH ROW
BEGIN
	DECLARE TableCount int;
	SELECT COUNT(employeeID) INTO TableCount
	FROM TableShift
	WHERE shiftID = new.shiftID AND employeeID = new.employeeID;
	IF (TableCount >= 5) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Too Many Tables on shift';	
	END IF;
END$$
DELIMITER ;


/*Before a Mentorship is updated, we first ensure that the specified mentor has no more than 3 active mentorships at any moment.
If it is found that the given mentor 3 mentors already, an error is thrown. */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`Mentorship_BEFORE_UPDATE`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`Mentorship_BEFORE_UPDATE` BEFORE UPDATE ON `Mentorship` FOR EACH ROW
BEGIN
	DECLARE MentorCount int;
	
    SELECT COUNT(sousChefMentor) INTO MentorCount
    FROM Mentorship
    WHERE sousChefMentor = new.sousChefMentor and endDate IS NULL;

	IF (MentorCount >= 3) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'UUnable to assign mentee to mentor because the mentor already has a max of 3';
	END IF;

END$$
DELIMITER ;



/* Before updating row in PaidCustomer, counts how many null values are being entered to ensure all corporate values are either completed or left null */

DROP TRIGGER IF EXISTS `cecs323sec01bg01`.`PaidCustomer_BEFORE_UPDATE`;

DELIMITER $$
USE `cecs323sec01bg01`$$
CREATE DEFINER = CURRENT_USER TRIGGER `cecs323sec01bg01`.`PaidCustomer_BEFORE_UPDATE` BEFORE UPDATE ON `PaidCustomer` FOR EACH ROW
BEGIN
	DECLARE nulls int;
	SELECT ISNULL(new.corpName) + ISNULL(new.corpAddress) + ISNULL(new.corpOrganization) + ISNULL(new.contactInfo) INTO nulls;
	IF nulls BETWEEN 1 AND 3 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT= 'All corporate values must be either filled in or left null';
	END IF;

END$$
DELIMITER ;


