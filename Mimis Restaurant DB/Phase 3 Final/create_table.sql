USE cecs323sec01bg01;
 
-- creates a parent table, Customer, that can uniquely identify a customer by their customer ID. A customer has a one-to-one relationship with their check.
CREATE TABLE Customer (
   custID INT(10) auto_increment NOT NULL,
   CONSTRAINT customer_pk PRIMARY KEY (custID)
);
 
-- creates a child table for paid customers of the restaurant that is inherited from the Customer table. This table is denormalized so that we can keep track of customers that are both miming account holders and are part of a corporation.The table takes in the customer ID as a foreign key and associates that ID with a name, email, address,rewards money, and corporation info if they have it. That way the restaurant has their information for the next time that they visit. It has a one-to-one relationship with the customer's check.
CREATE TABLE PaidCustomer (
   custID INT(10) NOT NULL,
   customerName varchar(20) NOT NULL,
   email varchar(30) NOT NULL,
   custAddress varchar(30) NOT NULL,
   mimingsMoney float(10) NOT NULL,
   corpName varchar(30),
   corpAddress varchar (30),
   corpOrganization varchar (30),
   contactInfo varchar (12),
   CONSTRAINT  paidCustomer_pk PRIMARY KEY (custID),
   KEY custID (custID),
   CONSTRAINT paidCustomer_fk1 FOREIGN KEY (custID) REFERENCES  Customer (custID)
  
);
 
-- creates a child table called check, that will once again take the customer ID as a foreign key, and associate that customer with their payment type, total,miming money, and date of their order. The check table serves the purpose of creating a bill for the customer, as well as providing them their rewards balance. It is uniquely identified by the check ID and it has a one-to-one relationship with web guest check and guests.
CREATE TABLE `Check` (
   checkID INT(10) NOT NULL,
   paymentType varchar(10) NOT NULL,
   mimingsMoney float(10) NOT NULL,
   total  float(10) NOT NULL,
   custID INT(10) NOT NULL,
   date DATE NOT NULL,
   CONSTRAINT check_pk PRIMARY KEY  (checkID),
   CONSTRAINT check_fk1 FOREIGN KEY (custID) REFERENCES Customer (custID)
);
 
-- creates a parent table for Tables in the restaurant. Each table is identified by its own table ID and represents a single table in the restaurant. A table has zero-to-six seats and has a many-to-many relationship with table shifts.
CREATE TABLE RestaurantTable (
   tableID INT(2) auto_increment NOT NULL,
   CONSTRAINT restauranttable_pk PRIMARY KEY (tableID)
);
 
-- creates a table for the seats in a restaurant. It will take in the table ID as a foreign key and associate that table with the seatNum attribute. Each seat in the restaurant is assigned to a specific table. 
CREATE TABLE Seat (
   tableID INT(2) NOT NULL,
   seatNum INT(2) NOT NULL,
   CONSTRAINT seat_pk PRIMARY KEY (tableID, seatNum),
   CONSTRAINT seat_fk FOREIGN KEY (tableID) REFERENCES RestaurantTable (tableID)
);
 
-- creates a parent table for the guests in the restaurant.It uniquely identifies a guest by their guestID and it takes in their checkID as a foreign key.  
CREATE TABLE Guest(
   checkID INT(7) NOT NULL,
   guestID INT(7) NOT NULL,
   CONSTRAINT guest_ibpk PRIMARY KEY (guestID),
   CONSTRAINT guest_ibfk_1 FOREIGN KEY (checkID)
   REFERENCES `Check` (checkID)
);
 
-- creates a child table for the dine in guests of the restaurant, which is inherited from the Guest table. r. Dine in guests are customers who eat their meal inside the restaurant so we assign the unique guestID to a table and seat number to them.
CREATE TABLE DineInGuest(
   guestID INT(7) NOT NULL,
   tableID INT(2) NOT NULL,
   seatNum INT(2) NOT NULL,
   CONSTRAINT DineInGuest_ibpk PRIMARY KEY (guestID),
   CONSTRAINT DineInGuest_ibfk_1 FOREIGN KEY (guestID) REFERENCES Guest (guestID),
   CONSTRAINT DineInGuest_ibfk_2 FOREIGN KEY (tableID, seatNum) REFERENCES Seat (tableID, seatNum)
);
 
 
-- creates a child table for the to go guests of the restaurant, which is inherited from the Guests table. These guests are also uniquely assigned a guest ID, and associates it with an order ready time and their pickup time. A togo guest is defined as a customer who is not dining in the restaurant.
CREATE TABLE ToGoGuest(
   guestID INT(7) NOT NULL,
   orderReadyTime TIME(0) NOT NULL,
   pickupTime TIME(0) NOT NULL,
   CONSTRAINT ToGoGuest_ibpk PRIMARY KEY (guestID),
   CONSTRAINT ToGoGuest_ibfk_1 FOREIGN KEY (guestID) REFERENCES Guest (guestID)
);
 
-- creates a child table for the PhoneOrderGuest, which is inherited from ToGoGuest. It is uniquely identified by the guest’s guestID. A phone order guest is a type of to go guest. 
CREATE TABLE PhoneOrderGuest(
   guestID INT(7) NOT NULL,
   CONSTRAINT PhoneOrderGuest_ibpk PRIMARY KEY (guestID),
   CONSTRAINT PhoneOrderGuest_ibfk_1 FOREIGN KEY (guestID) REFERENCES ToGoGuest (guestID)
);
 
-- creates a child table for the WebOrderGuest, which is inherited from ToGoGuest. It is uniquely identified by the guest’s ID and a web order guest is a type of to go guest.
CREATE TABLE WebOrderGuest(
   guestID INT(7) NOT NULL,
   CONSTRAINT WebOrderGuest_ibpk PRIMARY KEY (guestID),
   CONSTRAINT WebOrderGuest_ibfk_1 FOREIGN KEY (guestID) REFERENCES ToGoGuest (guestID)
  
);
 
 
-- creates a child table for the WebGuestCheck, which is inherited from WebOrderGuest.It is uniquely identified by the guest’s checkID. A WebGuestCheck is a type of check that our online customers can still access info in a regular Check.
CREATE TABLE WebGuestCheck (
   checkID int(10) NOT NULL,
   guestID int(7) NOT NULL,
   webConfirmationNum
   int(20) NOT NULL,
   CONSTRAINT WebGuestCheck_pk PRIMARY KEY (checkID),
   CONSTRAINT WebGuestCheck_fk1 FOREIGN KEY (guestID) REFERENCES WebOrderGuest (guestID)
);
-- Creates the parent table, Employee, which is uniquely identified by emplopyeeID and has a one-to-many relationship with Shift. An employee also has their first name, last name, and their phone number. 
CREATE TABLE Employee (
   employeeID int NOT NULL AUTO_INCREMENT,
   eLastName VARCHAR(20) NOT NULL,
   eFirstName VARCHAR(20) NOT NULL,
   ePhone CHAR(12) NOT NULL,
   CONSTRAINT Employee_pk PRIMARY KEY (employeeID)
);
 
-- Creates the child table, PartTimeEmployee, which is inherited from Employee. It is uniquely identified by employeeID and has a one-to-many relationship with Employee. A part time employee is an employee that has an hourly rate along with an hours worked. 
CREATE TABLE PartTimeEmployee (
   employeeID int NOT NULL,
   hourlyRate decimal(9,2) NOT NULL,
   hoursWorked int,
   CONSTRAINT PartTimeEmployee_pk PRIMARY KEY (employeeID),
   CONSTRAINT PartTimeEmployee_Employee_fk FOREIGN KEY(employeeID)
   REFERENCES Employee (employeeID)
);
 
-- Creates the child table, FullTimeEmployee, which is inherited from Employee. It is uniquely identified by employeeID and has a one-to-many relationship with Employee. A full time employee is an employee with an annual salary. 
CREATE TABLE FullTimeEmployee (
   employeeID int NOT NULL,
   salary decimal(9,2) NOT NULL,
   CONSTRAINT FullTimeEmployee_pk PRIMARY KEY (employeeID),
   CONSTRAINT FullTimeEmployee_Employee_fk FOREIGN KEY(employeeID)
   REFERENCES Employee (employeeID)
);
 
-- Creates the table, WaitStaff, which is inherited from PartTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with PartTimeEmployee. The wait staff are part time employees that also receive tips, alongside their hourly pay. 
CREATE TABLE WaitStaff (
   employeeID int NOT NULL,
   tips decimal(9,2) NOT NULL,
   CONSTRAINT WaitStaff_pk PRIMARY KEY (employeeID),
   CONSTRAINT WaitStaff_PartTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES PartTimeEmployee (employeeID)
);
 
 
 
-- Creates the table, Host, which is inherited from PartTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with PartTimeEmployee. 
CREATE TABLE Host (
   employeeID int NOT NULL,
   CONSTRAINT Host_pk PRIMARY KEY (employeeID),
   CONSTRAINT Host_PartTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES PartTimeEmployee (employeeID)
);
 
-- Creates the table, Dishwasher, which is inherited from PartTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with PartTimeEmployee.
CREATE TABLE Dishwasher (
   employeeID int NOT NULL,
   CONSTRAINT Dishwasher_pk PRIMARY KEY (employeeID),
   CONSTRAINT Dishwasher_PartTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES PartTimeEmployee (employeeID)
);
 
-- Creates the table, Manager which is inherited from FullTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with FullTimeEmployee.
CREATE TABLE Manager (
   employeeID int NOT NULL,
   CONSTRAINT Manager_pk PRIMARY KEY (employeeID),
   CONSTRAINT Manager_FullTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES FullTimeEmployee (employeeID)
);
 
-- Creates the table, HeadChef which is inherited from FullTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with FullTimeEmployee.
CREATE TABLE HeadChef (
   employeeID int NOT NULL,
   CONSTRAINT HeadChef_pk PRIMARY KEY (employeeID),
   CONSTRAINT HeadChef_FullTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES FullTimeEmployee (employeeID)
);
 
-- Creates the table, SousChef which is inherited from FullTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with FullTimeEmployee.
CREATE TABLE SousChef (
   employeeID int NOT NULL,
   CONSTRAINT SousChef_pk PRIMARY KEY (employeeID),
   CONSTRAINT SousChef_FullTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES FullTimeEmployee (employeeID)
);
 
-- Creates the table, LineCook which is inherited from FullTimeEmployee. It is uniquely identified by employeeID and has a zero-to-one relationship with FullTimeEmployee.
CREATE TABLE LineCook (
   employeeID int NOT NULL,
   CONSTRAINT LineCook_pk PRIMARY KEY (employeeID),
   CONSTRAINT LineCook_FullTimeEmployee_fk FOREIGN KEY(employeeID)
   REFERENCES FullTimeEmployee (employeeID)
);
 
 
-- Creates the table, Spice which just specifies the spice level. It is uniquely identified by spice. 
CREATE TABLE Spice (
   spice VARCHAR(20) NOT NULL,
   CONSTRAINT Spice_pk PRIMARY KEY (spice)
);
 
-- Creates a table, Category which just specifies the category of a menu item. It is uniquely identified by category.
CREATE TABLE Category (
   category VARCHAR(30) NOT NULL,
   CONSTRAINT Category_pk PRIMARY KEY (category)
);
 
-- Creates a table, Item which contains information about a menu item. It is uniquely identified by name and spice and has a one-to-many relationship with Spice and Category and a zero-to-five relationship with HeadChef.
CREATE TABLE Item(
   name VARCHAR(30) NOT NULL,
   spice VARCHAR(20) NOT NULL,
   category VARCHAR(30) NOT NULL,
   headChef INT NOT NULL,
   CONSTRAINT Item_ibpk PRIMARY KEY (name, spice),
   CONSTRAINT Item_ibfk_1 FOREIGN KEY (spice) REFERENCES Spice (spice),
   CONSTRAINT Item_ibfk_2 FOREIGN KEY (category) REFERENCES Category (category),
   CONSTRAINT Item_ibfk_3 FOREIGN KEY (headChef) REFERENCES HeadChef(employeeID)
);
 
-- Creates a table, MenuType which just specifies what menu type it is. It is uniquely identified by menuType and has a one-to-one relationship with Menu. 
CREATE TABLE MenuType(
   menuType VARCHAR(20) NOT NULL,
   CONSTRAINT MenuType_ibpk PRIMARY KEY (menuType)
);
 
-- Creates a table, Menu which contains information about the items on a menu. It is uniquely identified by menuType, item, and spice and has a one-to-many relationship with MenuType and a zero-to-many relationship with Item.
CREATE TABLE Menu (
   menuType VARCHAR(20) NOT NULL,
   item VARCHAR(30) NOT NULL,
   spice VARCHAR(20) NOT NULL,
   price decimal(5, 2) NOT NULL,
   CONSTRAINT Menu_ibpk PRIMARY KEY (menuType, item, spice),
   CONSTRAINT Menu_ibfk_1 FOREIGN KEY (menuType) REFERENCES MenuType (menuType),
   CONSTRAINT Menu_ibfk_2 FOREIGN KEY (item, spice) REFERENCES Item (`name`, spice)
  
);
 
-- Creates a table, OrderDetail which contains information about the transaction. It is uniquely identified by the guestID, menuType, item, and spice and has a one-to-many relationship with Guest and a zero-to-many relationship with Menu.
CREATE TABLE OrderDetail (
   guestID INT(7) NOT NULL,
   menuType VARCHAR(20) NOT NULL,
   item VARCHAR(30) NOT NULL,
   spice varchar(20) NOT NULL,
   quantity INT(2) NOT NULL,
   CONSTRAINT OrderDetail_ibpk PRIMARY KEY (guestID, menuType, item, spice),
   CONSTRAINT OrderDetail_ibfk_1 FOREIGN KEY (guestID) REFERENCES Guest (guestID),
   CONSTRAINT OrderDetail_ibfk_2 FOREIGN KEY (menuType, item, spice) REFERENCES Menu (menuType, item, spice)
);
 
-- Creates a table, Level99Chef which contains information about a chef who mastered a menu item. It is uniquely identified by the item, spice and sousChef and has a zero-to-many relationship with Item and a one-to-many relationship with SousChef.
CREATE TABLE Level99Chef(
   item varchar(30) NOT NULL,
   spice varchar(20) NOT NULL,
   sousChef INT NOT NULL,
   CONSTRAINT level99Chef_pk PRIMARY KEY (item, spice, sousChef),
   CONSTRAINT level99Chef_fk01 FOREIGN KEY (item, spice) references Item (name, spice),
   CONSTRAINT level99Chef_fk02 FOREIGN KEY (sousChef) references SousChef (employeeID)
);
 
-- Creates a table, Mentorship which contains information about the people involved in the mentorship and the logistics of it. It is uniquely identified by the item, spice, and sousChefMentor and has a one-to-many relationship with Level99Chef and SousChef.
CREATE TABLE Mentorship(
   item varchar(30) NOT NULL,
   spice varchar(20) NOT NULL,
   sousChefMentor INT NOT NULL,
   sousChefMentee INT NOT NULL,
   startDate date NOT NULL,
   endDate date,
   CONSTRAINT mentorship_pk PRIMARY KEY (item, spice, sousChefMentor),
   CONSTRAINT mentorship_fk01 FOREIGN KEY (item, spice, sousChefMentor) references Level99Chef (item, spice, sousChef),
   CONSTRAINT mentorship_fk02 FOREIGN KEY (sousChefMentee) references SousChef (employeeID)
);
 
 
-- Creates a table, Station which contains information about a station. It is uniquely identified by station and has a one-to-one relationship with shiftStation.
CREATE TABLE Station (
   station varchar(20),
   CONSTRAINT station_pk PRIMARY KEY (station)
);
 
-- Creates a table, Shift which contains information about a shift and the people associated with it. It is uniquely identified by the ShiftID and has a one-to-many relationship with Manager and HeadChef.
CREATE TABLE Shift (
   shiftID INT auto_increment NOT NULL,
   startTime datetime NOT NULL,
   endTime datetime NOT NULL,
   manager INT NOT NULL,
   headChef INT NOT NULL,
   weekNum INT NOT NULL,
   CONSTRAINT shift_pk PRIMARY KEY (shiftID),
   CONSTRAINT shift_fk01 FOREIGN KEY (Manager) references Manager (employeeID),
   CONSTRAINT shift_fk02 FOREIGN KEY (HeadChef) references HeadChef (employeeID)
);
 
-- Creates a table, EmployeeShift which contains information about the employee handling a specific shift. It is uniquely identified by employeeID and shiftID and has a one-to-many relationship with Employee and Shift. 
CREATE TABLE EmployeeShift(
   employeeID INT NOT NULL,
   shiftID INT NOT NULL,
   CONSTRAINT EmployeeShift_pk PRIMARY KEY (employeeID, shiftID),
   CONSTRAINT EmployeeShift_fk01 FOREIGN KEY (employeeID) references Employee (employeeID),
   CONSTRAINT EmployeeShift_fk02 FOREIGN KEY (shiftID) references Shift (shiftID)
);
 
-- Creates a table, ShiftStation which has information about a shift at a station. It is uniquely identified by the shiftID and station and has a one-to-many relationship with Shift and Station.
CREATE TABLE ShiftStation (
   shiftID INT NOT NULL,
   station varchar(20) NOT NULL,
   CONSTRAINT shiftstation_pk PRIMARY KEY (shiftID, station),
   CONSTRAINT shiftstation_fk01 FOREIGN KEY (shiftID) references Shift (shiftID),
   CONSTRAINT shiftstation_fk02 FOREIGN KEY (station) references Station (station)
);
 
-- Creates a table, LineCookShiftStation which has information regarding the line cook working at a station. It’s uniquely identified by lineCook, shiftID, and station and has a one-to-many relationship with EmployeeShift and LineCook, and a zero-to-many relationship with ShiftStation.
CREATE TABLE LineCookShiftStation(
   lineCook INT NOT NULL,
   shiftID INT NOT NULL,
   station varchar(20) NOT NULL,
   CONSTRAINT linecookshiftstation_pk PRIMARY KEY (lineCook, shiftID, station),
   CONSTRAINT linecookshiftstation_fk01 FOREIGN KEY (lineCook, shiftID) references EmployeeShift (employeeID, shiftID),
   CONSTRAINT linecookshiftstation_fk02 FOREIGN KEY (shiftID, station) references ShiftStation (shiftID, station),
   CONSTRAINT linecookshiftstation_fk03 FOREIGN KEY (lineCook) references LineCook (employeeID)
);
 
-- Creates a table, TableShift which has information regarding the shift being handled at a table. It’s uniquely identified by tableID and shiftID and has a one-to-many relationship with WaitStaff, Shift, and EmployeeShift.
CREATE TABLE TableShift (
   tableID int(2) NOT NULL,
   employeeID int NOT NULL,
   shiftID int NOT NULL,
   CONSTRAINT tableshift_pk PRIMARY KEY (tableID, shiftID),
   CONSTRAINT waitstaff_fk1 FOREIGN KEY (employeeID) REFERENCES WaitStaff (employeeID),
   CONSTRAINT waitstaff_fk2 FOREIGN KEY (shiftID) REFERENCES Shift (shiftID),
   CONSTRAINT waitstaff_fk3 FOREIGN KEY (employeeID, shiftID) REFERENCES EmployeeShift (employeeID, shiftID)
);
 
 
 
 
/*------------------------------------------------------------*/
 
 
 
 

