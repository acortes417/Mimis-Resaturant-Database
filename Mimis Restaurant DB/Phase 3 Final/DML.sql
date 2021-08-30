USE cecs323sec01bg01;

-- DML

-- insert 6 customers into customers using custID to identify
INSERT INTO Customer (custID) VALUES 
	(1),
  	(2),
  	(3),
  	(4),
  	(5), 
	(6);
    
-- insert 4 paid customers with or without the corporate values
INSERT INTO PaidCustomer (custID, customerName, email, custAddress, mimingsMoney, corpName, corpAddress, corpOrganization, contactInfo) VALUES 
    (1, 'Mayra Sanchez', 'msan@gmail.com', '583 Earth Way', 0, 'Sanchez Inc.' , '292 Sanchez Road', 'Coding Stuff', '523-424-1164'),
    (2, 'Andre Cortes', 'andre@gmail.com', '696 Code Ave', 0, 'Andre Inc' , '123 Euclid st' , 'Coding with friends', '123-456-7890' ),
    (3, 'Bob Builder', 'builder@gmail.com', '0219 Building', 0, null, null, null, null), 
    (4, 'Mayra Sanchez', 'msan@gmail.com', '583 Earth Way', 0, 'Sanchez Inc', '292 Sanchez Road', null, null);

--Creating eight checks with different payment types belonging to different customers
INSERT INTO `Check` (checkID, paymentType, mimingsMoney, total, custID, `date`) VALUES
    (1, 'Credit', 0, 0.0, 1, '2019-11-16'),
    (2, 'Debit', 0, 0.0, 1, '2018-03-11'),
    (3, 'Credit', 0, 0.0, 2, '2019-10-26'),
    (4, 'Debit', 0, 0.0, 2, '2018-10-18'),
    (5, 'Cash', 0, 0.0, 3, '2020-01-03'),
    (6, 'Debit', 0, 0.0, 3, '2017-09-12'),
    (7, 'Cash', 0, 0.0, 4, '2019-12-06'),
    (8, 'Cash', 0, 0.0, 4, '2020-12-06');
	
--Creating 10 tables in the restaurant 
INSERT INTO RestaurantTable (tableID) VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10);

--insert seats into the tables
--tables 1 and 2 have 6 seats each, while the rest have 2 seats each.     
INSERT INTO Seat (tableID, seatNum) VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (2, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (3, 1),
    (3, 2),
    (4, 1),
    (4, 2),
    (5, 1),
    (5, 2),
    (6, 1),
    (6, 2),
    (7, 1),
    (7, 2),
    (8, 1),
    (8, 2),
    (9, 1),
    (9, 2),
    (10, 1),
    (10, 2);



--created 10 guests 
INSERT INTO Guest (checkID, guestID) VALUES
    (1, 100), 
    (1, 101),
    (1, 102), 
    (1, 103),
    (2, 104), 
    (2, 105),
    (3, 106),
    (4, 107), 
    (5, 108),
     (4, 109),
    (5, 110);
    
--Inserting the values of where our dine-in guests and where they 
-- are seated at and at what seat number.

INSERT INTO DineInGuest (guestID, tableID, seatNum) VALUES 
    (100, 1, 1), 
    (101, 1, 2), 
    (102, 1, 3), 
    (103, 1, 4), 
    (104, 2, 1), 
    (105, 2, 2), 
    (106, 3, 2), 
    (107, 4, 1), 
    (108, 5, 2);

--created 2 to go guests with their orderready and pickup times
INSERT INTO ToGoGuest(guestID, orderReadyTime, pickupTime) VALUES
(109, '12:01', '12:15'), 
(110, '1:25', '1:45');

-- insert one phone order guest
INSERT INTO PhoneOrderGuest(guestID) VALUES
	(109);

--insert one web order guest
INSERT INTO WebOrderGuest (guestID) VALUES
(110);

--insert a web guest check for the web guest
INSERT INTO WebGuestCheck(checkID, guestID, webConfirmationNum) VALUES
	(2, 110, 42);

--Creating twelve employees with their employeeID auto incremented
-- Employee (12) 
INSERT INTO Employee (eLastName, eFirstName, ePhone) VALUES
    ('John', 'Robert' , '234-123-5123'),
    ('Lu', 'David', '523-123-1234'),
    ('Sanchez', 'Mayra', '234-123-8564'),
    ('Thomas', 'Kate', '796-378-8456'),
    ('Bender', 'Aang', '008-456-3846'),
    ('Cao', 'Jon', '967-345-3457'),
    ('NewAvatar', 'Korra', '947-285-8385'),
    ('Wu', 'Wendy', '333-333-2748'),
    ('Frost', 'Robert', '899-999-9999'),
    ('Work', 'Team', '377-373-3735'),
    ('Cortes’, 'Andrew’, '123-456-7890’)
    ('Sane’, 'Leroy’, '123-351-7890’);


-- insert 4 part time employee
-- 8 and 10 are waitstaff
-- 7 is a host 11 is a dishwasher
INSERT INTO PartTimeEmployee (employeeID, hourlyRate, hoursWorked) VALUES
    (8, 14, 22),
    (7, 15, 28), 
    (10, 13, 25),
    (11, 11, 21); 

-- 1,2,3,4 are sous chef, 5,9 head chef, 6 manager, 12 is a linecook
-- inserts 8 full time employees
INSERT INTO FullTimeEmployee (employeeID, salary) VALUES
    (1, 69000),
    (2, 65000),
    (3, 62000),
    (4, 76000),
    (5, 88500),
    (6, 27000),
    (9, 72000),
    (12,71000);
	

-- insert 2 waitstaff with tips 
INSERT INTO WaitStaff (employeeID, tips) VALUES
    (8, 250), 
    (10, 300);

-- insert 1 host 
INSERT INTO Host (employeeID) VALUES
	(7);

-- insert 1 dishwasher
INSERT INTO Dishwasher (employeeID) VALUES
	(11);
    
-- insert 1 manager 
INSERT INTO Manager (employeeID) VALUES
	(6);
  
-- insert 1 headchef
INSERT INTO HeadChef (employeeID) VALUES
    (5),
    (9);
  
-- insert 1 souschef
INSERT INTO SousChef (employeeID) VALUES
    (1),
    (2),
    (3),
    (4);

-- insert 1 linecook
INSERT INTO LineCook(employeeID) VALUES
	(12);
 
-- Spice (enum 5): Mild, Tangy, Piquant, Hot, Oh My God
INSERT INTO Spice (spice) VALUES
    ('Mild'),
    ('Tangy'),
    ('Piquant'),
    ('Hot'),
    ('Oh My God'), 
    ('N/A');




-- Category (enum 11): Appetizer, Soup, 
-- Meat Entree Pork, Meat Entree Chef Special, Meat Entree Chicken, Meat Entree Beef, Meat Entree Seafood, Meat Entree Vegetables, 
-- Chow Mein, Egg Foo Young , Chop Suey
INSERT INTO Category (category) VALUES
    ('Appetizer'),
    ('Soup'),
    ('Meat Entree Chef Special'),
    ('Meat Entree Pork'),
    ('Meat Entree Chicken'),
    ('Meat Entree Beef'),
    ('Meat Entree Seafood'),
    ('Meat Entree Vegetables'),
    ('Chow Mein'),
    ('Egg Foo Young'),
    ('Chop Suey'), 
    ('N/A');
    
	

-- Item created 12 items with which head chef made what dish and a buffet
INSERT INTO Item (`name`, spice, category, headChef) VALUES
    ('Steamed Chicken Buns', 'Mild', 'Appetizer', 5),
    ('Spicy Pork EggRoll', 'Piquant', 'Appetizer', 9),
    ('Fish Soup, Pint', 'Oh My God', 'Soup', 5),
    ('Egg Drop Soup, Quart', 'Tangy', 'Soup', 5),
    ('Chinese Beef and Broccoli', 'Mild', 'Meat Entree Beef', 5),
    ('Orange Chicken', 'Mild', 'Meat Entree Chicken', 5),
    ('Fish Stir Fry', 'Mild', 'Meat Entree Seafood', 5),
    ('Chef Special Chow Mein', 'Hot', 'Meat Entree Chef Special', 5),
    ('Egg Foo Young', 'Piquant', 'Meat Entree Chef Special', 5),
    ('Beef Chop Suey', 'Tangy', 'Meat Entree Beef', 5),
    ('Vegetable Chop Suey', 'Oh My God', 'Meat Entree Vegetables', 9),
    ('Buffet', 'N/A', 'N/A', 9);

-- MenuType (enum 4): Evening, Lunch, Sunday Brunch Buffet, Childrens
INSERT INTO MenuType (menuType) VALUES
    ('Evening'),
    ('Lunch'),
    ('Sunday Brunch Buffet'),
    ('Childrens');

-- inserted 14 items into different menus and their prices
INSERT INTO Menu (menuType, item, spice, price) VALUES 
     ('Lunch', 'Steamed Chicken Buns', 'Mild', 3.75),
    ('Evening', 'Spicy Pork EggRoll', 'Piquant', 4.00),
    ('Childrens', 'Fish Soup, Pint', 'Oh My God', 2.00),
    ('Lunch', 'Egg Drop Soup, Quart', 'Tangy', 3.00),
    ('Evening', 'Chinese Beef and Broccoli', 'Mild', 7.45),
    ('Evening', 'Orange Chicken', 'Mild', 8.00),
    ('Lunch', 'Fish Stir Fry', 'Mild', 9.00),
    ('Evening', 'Chef Special Chow Mein', 'Hot', 10.00),
    ('Lunch', 'Egg Foo Young', 'Piquant', 8.75),
    ('Evening', 'Beef Chop Suey', 'Tangy', 7.50),
    ('Lunch', 'Vegetable Chop Suey', 'Oh My God', 8.00),
    ('Sunday Brunch Buffet', 'Buffet', 'N/A', 14.99),
    ('Childrens', 'Orange Chicken', 'Mild', 2.50),
    ('Childrens', 'Chinese Beef and Broccoli', 'Mild', 2.75);
    

-- inserted 16 order details
INSERT INTO OrderDetail (guestID, menuType, item, spice, quantity) VALUES
	(101, 'Lunch', 'Steamed Chicken Buns', 'Mild', 2),
    (102, 'Evening','Spicy Pork EggRoll', 'Piquant', 2),
    (102, 'Childrens', 'Fish Soup, Pint', 'Oh My God', 1),
    (103, 'Lunch', 'Egg Drop Soup, Quart', 'Tangy', 5),
    (104, 'Evening', 'Chinese Beef and Broccoli', 'Mild', 2),
    (104, 'Evening', 'Orange Chicken', 'Mild', 1),
    (105, 'Lunch', 'Fish Stir Fry', 'Mild', 1),
    (104, 'Evening', 'Chef Special Chow Mein', 'Hot', 1),
    (105, 'Lunch', 'Egg Foo Young', 'Piquant', 1),
    (102, 'Evening', 'Beef Chop Suey', 'Tangy', 1),
    (105, 'Lunch', 'Vegetable Chop Suey', 'Oh My God', 1),
    (106, 'Sunday Brunch Buffet', 'Buffet', 'N/A', 1), 
    (107, 'Childrens',  'Fish Soup, Pint', 'Oh My God', 2),
    (108, 'Childrens', 'Fish Soup, Pint', 'Oh My God', 1), 
    (109, 'Childrens', 'Orange Chicken', 'Mild', 1),
    (110, 'Childrens', 'Orange Chicken', 'Mild', 2);

    
-- inserted 9 sous chefs who became expert at a dish enough to be called Level 99
INSERT INTO Level99Chef (item, spice, sousChef) VALUES
	( 'Steamed Chicken Buns', 'Mild', 1), 
    ('Spicy Pork EggRoll', 'Piquant', 1),
    ('Fish Soup, Pint', 'Oh My God', 1),
    ('Egg Foo Young', 'Piquant', 1), 
    ('Orange Chicken', 'Mild', 1),
    ('Steamed Chicken Buns', 'Mild', 2), 
    ('Spicy Pork EggRoll', 'Piquant', 2), 
    ('Chef Special Chow Mein', 'Hot', 2),
    ('Fish Soup, Pint','Oh My God',2),
('Orange Chicken','Mild',2);
	
    
-- inserted 3 mentorship into between two sous chefs 
INSERT INTO Mentorship (item, spice, sousChefMentor, sousChefMentee, startDate, endDate) VALUES
	('Steamed Chicken Buns', 'Mild', 1, 2, '2018-12-04', null),
    ('Spicy Pork EggRoll', 'Piquant', 1, 3, '2018-12-05', null),
    ('Fish Soup, Pint', 'Oh My God', 1, 4, '2018-12-06', null);

-- Station (enum 8): butcher, fry cook, grill chef, pantry chef, pastry chef, roast chef, sauté chef, vegetable chef 
INSERT INTO Station (station) VALUES
    ('butcher'),
    ('fry cook'), 
    ('grill chef'), 
    ('pantry chef'), 
    ('pastry chef'), 
    ('roast chef'), 
    ('sauté chef'), 
    ('vegetable chef');


-- Remove EmployeeShift Table FK from Shift to populate initial data
ALTER TABLE Shift 
	DROP FOREIGN KEY `shift_fk03`;

ALTER TABLE Shift 
	DROP FOREIGN KEY `shift_fk04`;

-- inserted 2 shifts with given variables
INSERT INTO Shift (startTime, endTime, manager, headChef,weekNum) VALUES
	('2019-12-09 8:00:00', '2019-12-09 22:00:00', 6, 5,50),
('2019-11-30 12:00:00', '2019-11-30 18:00:00',6,5,49);

-- created 10 employeeshifts with which employees were on each shift
INSERT INTO EmployeeShift (employeeID, shiftID) VALUES
	(1, 4),
    (2, 4),
    (3, 4),
    (4, 4),
    (5, 4),
    (6, 4), 
    (5, 2), 
    (6, 2),
    (7, 2),
    (8, 2), 
    (9, 2), 
    (10, 2),
    (11, 2),
    (12, 2);

-- Add FK constraints back to Shift after populating the EmployeeShift table
ALTER TABLE Shift ADD CONSTRAINT shift_fk03 FOREIGN KEY (shiftID, manager) references Staffing (shiftID, employeeID);
ALTER TABLE Shift ADD CONSTRAINT shift_fk04 FOREIGN KEY (shiftID, headChef) references Staffing (shiftID, employeeID);

-- created a station on a shift
INSERT INTO ShiftStation (shiftID, station) VALUES
(2,'fry cook');


-- inserted a line cook into a shiftstation
INSERT INTO LineCookShiftStation(lineCook, shiftID, station) VALUES
	(12, 2, 'fry cook');


-- inserted 5 tables shifts. 5 shift on one employee. Use the same employee to test trigger
INSERT INTO TableShift (tableID, employeeID, shiftID) VALUES
    (1, 8, 2),
    (2, 8, 2),
    (3, 8, 2),
    (4, 8, 2),
    (5, 8, 2);









