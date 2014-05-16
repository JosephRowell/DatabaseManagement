--Let's do this--

--ENUM TYPES--
DROP TYPE IF EXISTS payMode CASCADE;
DROP TYPE IF EXISTS payMethod CASCADE;
DROP TYPE IF EXISTS shiftType CASCADE;
DROP TYPE IF EXISTS roleName CASCADE;
DROP TYPE IF EXISTS turfCode CASCADE;

--Create enum types—
CREATE TYPE payMethod AS ENUM('Cash', 'Check', 'Credit', 'Debit', 'Bitcoin');
CREATE TYPE payMode AS ENUM ('Door', 'Phone', 'Web', 'Event');
CREATE TYPE shiftType AS ENUM ('Full', 'Training', 'Event');
CREATE TYPE roleName AS ENUM ('Canvasser', 'Field Manager', 'Project Director', 'Trainee', 'Administrative');
CREATE TYPE turfCode AS ENUM ('NH', 'CB', 'YESR', 'YESC', 'YESNM', 'MV', 'DC', 'X');



DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS donor CASCADE; 
DROP TABLE IF EXISTS staff CASCADE;
DROP TABLE IF EXISTS crew CASCADE;

DROP TABLE IF EXISTS donation CASCADE;

DROP TABLE IF EXISTS door CASCADE;
DROP TABLE IF EXISTS turf CASCADE;

DROP TABLE IF EXISTS zipPerson CASCADE; 
DROP TABLE IF EXISTS zipLocation CASCADE;
DROP TABLE IF EXISTS shift CASCADE; 

--Create TABLES--

CREATE TABLE IF NOT EXISTS zipPerson (
	zipP VARCHAR (15) NOT NULL UNIQUE, 
	city VARCHAR (40) NOT NULL,
	state CHAR(3) NOT NULL,           
	PRIMARY KEY (zipP)
	
);

ALTER TABLE zipPerson ADD CONSTRAINT zipPersonchk CHECK (char_length(zipP) >= 5);  

CREATE TABLE IF NOT EXISTS person ( 
	pid SERIAL NOT NULL UNIQUE, 
	firstName VARCHAR(50) NOT NULL, 
	lastName VARCHAR(50) NOT NULL, 
	address VARCHAR(80) NOT NULL,
	phonePrimary  CHAR(15) NOT NULL,
	zipP VARCHAR(15) NOT NULL REFERENCES zipPerson (zipP),  
	campaignName VARCHAR (50) NOT NULL,
	PRIMARY KEY (pid)
);


CREATE TABLE IF NOT EXISTS shift (
	shiftid INT NOT NULL UNIQUE,
	timeIn TIME NOT NULL,
	timeOut TIME NOT NULL,
	shiftType shiftType,
	PRIMARY KEY (shiftid)
	
);

CREATE TABLE IF NOT EXISTS staff (
	sid INTEGER NOT NULL REFERENCES person (pid),
	hireDate DATE NOT NULL DEFAULT CURRENT_DATE,
	payRate MONEY,
	roleName roleName, 
	shiftid INT NOT NULL REFERENCES shift (shiftid),  
	PRIMARY KEY (sid)                            
);

CREATE TABLE IF NOT EXISTS zipLocation (
	zipL VARCHAR(15) NOT NULL UNIQUE,
	city CHAR(40) NOT NULL,
	state CHAR(3) NOT NULL,
	PRIMARY KEY (zipL)
);

CREATE TABLE IF NOT EXISTS crew (
	crewid INT NOT NULL,
	driver VARCHAR(50),
	zipL VARCHAR(15) REFERENCES zipLocation (zipL),
	PRIMARY KEY (crewid)
	
);

--ALTER TABLE crew ADD CONSTRAINT driverchk CHECK (driver in (staff.roleName)); --didn't work

CREATE TABLE IF NOT EXISTS turf (
	turfid SERIAL NOT NULL UNIQUE,
	turfDate DATE DEFAULT CURRENT_DATE NOT NULL,
	crewid int NOT NULL REFERENCES crew (crewid),
	PRIMARY KEY (turfid)  
);

CREATE TABLE IF NOT EXISTS donation (
	donationid SERIAL NOT NULL UNIQUE,
	donDate DATE NOT NULL DEFAULT CURRENT_DATE,
	amount MONEY NOT NULL,
	payMethod payMethod,
	payMode payMode,
	sustainer BOOLEAN NOT NULL,
	PRIMARY KEY (donationid)	
);


CREATE TABLE IF NOT EXISTS door (
	doorid SERIAL NOT NULL UNIQUE,
	turfCode turfCode,
	sdid INT NOT NULL REFERENCES staff(sid),
	turfid INT NOT NULL REFERENCES turf (turfid),
	donationid INT REFERENCES donation (donationid),
	PRIMARY KEY (doorid)
);


--WRITE SOME TRIGGERS/STORE PROCS FOR CB/NH etc.

CREATE TABLE IF NOT EXISTS donor (
	donorid INTEGER NOT NULL UNIQUE REFERENCES person (pid), 
	dateLastGiven DATE NOT NULL, --SEE IF A TRIGGER CAN GO HERE 
	amountLastGiven MONEY NOT NULL,--AND HERE
	email VARCHAR(256),
	donationid INT NOT NULL REFERENCES donation (donationid),
	PRIMARY KEY (donorid)
);

--INSERTS-

INSERT into zipPerson(zipP, city, state) VALUES
('12603', 'Poughkeepsie', 'NY'),
('07712', 'Asbury Park', 'NJ'),
('12561', 'New Paltz', 'NY'),
('12538', 'Hyde Park', 'NY'),
('41949', 'Punksville', 'PA'),
('89421', 'Los Angeles', 'CA'),
('97255', 'Mortalville', 'NY'),
('89429', 'Freedom', 'NH'),
('56412', 'Ourganac', 'VT');

INSERT into shift(shiftid, timeIn, timeOut, shiftType) VALUES
(1, time '2:00', time '9:30', 'Training'),
(2, time '12:00', time '9:30', 'Full'),
(3, time '1:00', time '9:30', 'Full'),
(4, time '1:00', time '9:30', 'Full'),
(5, time '12:00', time '9:30', 'Full');

INSERT into person(pid, firstName, lastName, address, phonePrimary, zipP, campaignName) VALUES
(1, 'Bob', 'Dole', '5 dole lane', '123-444-4444', '12603', 'hydrofracking'),--staff trainee
(2, 'Bruce', 'Springsteen', '20 Asbury Lane', '222-867-5309', '07712', 'hydrofracking'), --staff (the boss)
(3, 'Weinberg', 'Bottomtooth', '1 Private Drive', '666-888-9999', '12603', 'hydrofracking'),--generous donor
(4, 'Joe', 'Smoe', '1 Main Street', '123-456-7890','12603', 'hydrofracking'),--contrib
(5, 'Vladamir', 'Lenin', '20 Red Square Drive','555-777-9494','12538', 'hydrofracking'),-- staff Field Manager
(6, 'Sid', 'Vicious', '77 Anarchy Plaza', '111-222-1234','12603', 'hydrofracking'),--New member
(7, 'Nancy', 'Spungen', '76 Anarchy Plaza', '333-707-7070','12603', 'hydrofracking'), --New member
(8, 'D', 'Boon', '48 DoubleNikels Drive', '933-555-8888', '89421', 'hydrofracking'),--staff not effective
(9, 'Exene', 'Cerveka', '80 LosAngeles Blvd', '333-111-3435', '89421', 'hydrofracking'),--previous giver, CB
(10, 'Laura', 'Croft', '98 Tombraided Place', '394-345-5968','89421', 'hydrofracking'),--previous giver, not this year
(11, 'Sonia', 'Blade', '94 Finishhim Way', '924-345-5335','97255', 'Clean Elections'),--New Member
(12, 'Johnny', 'Cage', '92 Finishhim Way', '335-434-5677','97255', 'Clean Elections'),--FM for CE campaign
(13, 'Joe', 'King', '88 Webelo Way', '343-564-4322', '89429', 'Clean Elections'), --New member
(14, 'Joey', 'Ramone', '53rd and 3rd', '350-435-5364', '89429', 'hydrofracking'), --contrib
(15, 'Lee', 'Ving', '44 Fear Place', '335-333-1122','89429', 'Clean Elections'), --Returning member
(16, 'Darby', 'Crash', '99 Forming Street', '222-435-9643', '89429', 'Free College'), --New member  --
(17, 'Joan', 'Jett', '86 Blackheart Drive', '454-356-3569', '56412','Free College'), --contrib
(18, 'Mikey', 'Erg', '33 Dorkage Drive', '902-943-8944', '56412', 'Free College'), --Returning
(19, 'Iggy', 'Pop', '76 Punkrock Place', '436-655-4356', '56412','Free College'),--contrib
(20, 'Flava', 'Flav', '91 Powerfightin Way', '353-775-4364', '56412', 'Free College'), --awesome donor
(21, 'Doctor', 'Freedom', '2014 Nofracking Way', '951-753-4682', '12603', 'hydrofracking'); --Can't forget Doctor Freedom, he hates fracking.

INSERT into staff(sid, hireDate, payRate, roleName, shiftid ) VALUES
(1, date '05-08-2013', '10', 'Trainee', 1),
(2, date '05-08-2010', '15', 'Project Director', 2),
(5, date '05-08-2011', '12', 'Field Manager', 3),
(8, date '05-08-2012', '11', 'Canvasser', 4),
(12, date '05-07-2010', '12', 'Field Manager', 5);

INSERT into zipLocation(zipL, city, state) VALUES
('12603', 'Poughkeepsie', 'NY'),
('12561', 'New Paltz', 'NY'),
('07712', 'Asbury Park', 'NJ');

INSERT into crew(crewid, driver, zipL) VALUES --crewid will always reference a FM or PD like 2, 5 or 12
(2, 'Bruce Springsteen', '12603'), --A night in Poughkeepsie
(5, 'D Boon', '12561'), --A night in New Paltz.
(12, 'Johnny Cage', '12561'); --Another campaign, another field manager doing New Paltz.

INSERT into turf(turfid, turfDate, crewid) VALUES
(1, date '05-10-2013', 2),
(2, date '05-10-2013', 12),
(3, date '05-10-2011', 5),
(4, date '05-10-2013', 5),
(5, date '05-25-2011', 12);

INSERT into donation(donationid, donDate, amount, payMethod, payMode, sustainer) VALUES --MAKE DATE LASTGIVEN BELOW DIFFERENT AND CONFIGURE TRIGGER ACCORDINGLY
(1, '05-10-2013', '365', 'Check', 'Door', FALSE),
(2, '05-10-2013', '36', 'Cash', 'Door', FALSE),
(3, '05-10-2013', '1', 'Check', 'Door', FALSE),
(4, '05-10-2013', '67', 'Check', 'Door', FALSE),
(5, '05-10-2013', '68', 'Credit', 'Door', FALSE),
(6, '05-10-2013', '600', 'Check', 'Door', TRUE),
(7, '05-10-2012', '365', 'Check', 'Door', FALSE),
(8, '05-25-2011', '120', 'Bitcoin', 'Door', FALSE),
(9, '05-25-2011', '12', 'Cash', 'Door', FALSE),
(10, '05-25-2011', '84', 'Credit', 'Door', FALSE);

INSERT into donor(donorid, dateLastGiven, amountLastGiven, email, donationid) VALUES --all except 1, 2, 5, 8 12, 9, 10
(3, date '05-15-2012', '300', 'toorichformyowngood@privilegedmail.com', 1),
(4, date '08-14-2011', '3', 'eatatsmoes@gmail.com', 2),
(6, date '05-17-2010', '66', 'vicious4life@anonmail.com', 3),
(7, date '05-15-2012', '67', 'nancyh8sfracking@earthlink.com', 4),
(9, date '05-1-2011', '66', 'xcervenkax@xmail.com', 5), --We did not get to her this year
(21, date '05-1-2011', '365', 'frackfracking@frackfreeNY.org', 6),
(14, date '05-10-2011', '6', 'heyholetsgo@aol.com', 7),
(11, date '05-05-2010', '100', 'bladelady44@mkombat.edu', 8),
(13, date '05-25-2011', '12', NULL, 9),
(15, date '05-25-2011', '62', NULL, 10);

INSERT into door(doorid, turfCode, sdid, turfid, donationid) VALUES --This one requires prodigious amounts of sample data
(1, 'NH', 1, 1, NULL),
(2, 'CB', 1, 1, NULL),
(3, 'YESR', 1, 1, 1), -- Bob Dole gets a crazy donation during his Training phase. Virtually unheard of.
(4, 'X', 1, 1, NULL),
(5, 'MV', 1, 1, NULL), --Realistically, each canvasser has over 40 doors.
(6, 'X', 2, 2, NULL),
(7, 'X', 2, 2, NULL),    
(8, 'YESC', 2, 2, 2),  --Bruce Springsteen has a surprisingly rough night
(9, 'X', 2, 2, NULL),  
(10, 'NH', 2, 2, NULL),  
(11, 'CB', 2, 2, NULL),  
(12, 'MV', 2, 2, NULL),  
(13, 'X', 8, 3, NULL),  
(14, 'YESC', 8, 3, 3),  
(15, 'CB', 8, 3, NULL),  
(16, 'X', 8, 3, NULL),  --  D Boon got one donation of $1 that night. Canvassing is not for him.
(17, 'X', 5, 4, 4),  
(18, 'X', 5, 4, 7),     -- Lenin is a wonderful canvasser. He really knows how to connect with people. 
(19, 'CB', 5, 4, NULL),  
(20, 'NH', 5, 4, NULL),  
(21, 'NH', 5, 4, NULL),  
(22, 'MV', 5, 4, NULL),  
(23, 'X', 12, 5, NULL), --Johnny Cage battiling big money in politics like if big money in politics was Goro.   
(24, 'YESNM', 12, 5, 8),   --Also, he gets Sonia Blade to give $120. Together they will perform a fatality on wealthy interests.
(25, 'YESNM', 12, 5, 9),  
(26, 'YESR', 12, 5, 10),  -- He also got Lee Ving and Joe King to contribute, but forgot to get their email addresses.
(27, 'X', 12, 5, NULL),  
(28, 'X', 12, 5, NULL);  

/*(29, 'X', 2, 2, NULL),  
(30, 'X', 2, 2, NULL),  
(31, 'X', 2, 2, NULL),  
(32, 'X', 2, 2, NULL),  */




--Views!--
--donors and how much they gave!
DROP VIEW IF EXISTS tonightsDonors;

CREATE VIEW tonightsDonors AS
SELECT distinct firstName, lastName, address, zipPerson.city, phonePrimary, amount from person
	INNER JOIN zipPerson
	on zipPerson.zipP = person.zipP
	INNER JOIN donor
	on person.pid = donor.donorid
	INNER JOIN donation
	on donor.donationid = donation.donationid  --made it this far!
	order by city asc;

DROP VIEW IF EXISTS payMethodTotals;

CREATE VIEW payMethodTotals AS

SELECT sum(amount), payMethod as nightlyTotals
FROM donation where payMethod = 'Check' 
GROUP BY payMethod union

SELECT sum(amount), payMethod as cashTotal
FROM donation where payMethod = 'Cash'
GROUP BY payMethod union

SELECT sum(amount), payMethod as bitcoinTotal
FROM donation where payMethod = 'Bitcoin'
GROUP BY payMethod union

SELECT sum(amount), payMethod as creditTotal
FROM donation where payMethod = 'Credit'
GROUP BY payMethod union

SELECT sum(amount), payMethod as debitTotal
FROM donation where payMethod = 'Debit'
GROUP BY payMethod;                                              


DROP VIEW IF EXISTS codeCounts;

CREATE VIEW codeCounts AS

SELECT count(*) tCount, turfCode from door as nhCount
where turfCode = 'NH'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as cbCount
where turfCode = 'CB' 
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as yrCount
where turfCode = 'YESR'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as ynCount
where turfCode = 'YESNM'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as ycCount
where turfCode = 'YESC'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as MVCount
where turfCode = 'MV'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as xCount
where turfCode = 'X'
GROUP BY turfCode UNION

SELECT count(*) tCount, turfCode from door as dcCount
where turfCode = 'DC'
GROUP BY turfCode;

/*SELECT distinct donorid, firstName, lastName, address, turfid, payMethod
 from donor, zipPerson, person, door, donation order by donorid desc;

SELECT distinct firstName, lastName, amount, address from person, zipPerson, donor, donation;
*/

/*SELECT distinct pid, firstName, lastName, person.zipP, campaignName --SAMPLE DATA PEOPLE
from person, zipPerson ORDER BY pid asc;   */

/*SELECT pid, firstName, lastName, address, phonePrimary, zipP, campaignName, hireDate, payRate, roleName  from staff s  --SAMPLE DATA STAFF
inner join person p on s.sid = p.pid;  */

/*SELECT * from crew; --	CREW SAMPLE DATA */

/*SELECT firstName, lastName, address, amountLastGiven, dateLastGiven, phonePrimary, email, zipP, campaignName from donor d  --DONOR DATA
inner join person p on d.donorid = p.pid ; */

/*

donor.dateLastGiven, donor.amountLastGiven,

SELECT distinct person.firstName, person.lastName, person.address, donation.donDate, donation.amount, donation.payMethod, donation.payMode, person.campaignName from person, donation
inner join donor d on donation.donationid = d.donationid ------SEE WHAT'S UP WITH THIS
inner join person p on d.donorid = p.pid
where d.donorid = p.pid
*/             

--Stored Procedures--                  
DROP FUNCTION getContactRate(pid int);

CREATE FUNCTION getContactRate(pid int) RETURNS decimal AS $$
DECLARE
contact integer := (SELECT count(*) FROM door

WHERE sdid = pid AND turfCode = 'YESR' OR 'YESC' OR 'YESNM');
numHomes integer := (SELECT count(*) FROM door
WHERE sdid = pid);
ratio decimal := 0;

BEGIN
ratio := (SELECT CAST (contacts AS decimal(2))/(SELECT CAST (numHomes AS decimal(2))));
return (trunc (ratio, 3));
END;
$$ LANGUAGE plpgsql;

--Triggers--
DROP TRIGGER IF EXISTS contactRate ON door;

CREATE TRIGGER contactRate
  After Insert 
  ON door
  FOR EACH ROW
  EXECUTE PROCEDURE getContactRate(pid int);
