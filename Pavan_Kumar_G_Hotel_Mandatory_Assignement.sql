/*                                               SQL 3 - Mandatory Project         
							                          PAVAN KUMAR G 
													   Batch-DS 16
/*




 /*  Create a database of the hotel named “Grosvenor”. Given are a few hints on how tables should be created and how the values should be inserted. 
 After the creation of the database, answer the questions given at the end about the hotel.

The Database
Hotel (Hotel_No, Name, Address) Room (Room_No, Hotel_No, Type, Price) Booking (Hotel_No,
Guest_No, Date_From, Date_To, Room_No) Guest (Guest_No, Name, Address)
Creating the Tables(Make sure to include primary and foreign keys also keeping in mind the normalization of tables).

CREATE TABLE hotel ( hotel_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address
VARCHAR(50) NOT NULL);
 
CREATE TABLE room ( room_no VARCHAR(4) NOT NULL, hotel_no CHAR(4) NOT NULL, type CHAR(1)
NOT NULL, price DECIMAL(5,2) NOT NULL);

CREATE TABLE booking (hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from
DATETIME NOT NULL, date_to DATETIME NULL, room_no CHAR(4) NOT NULL); Dates: YYYY-MM-DD;

CREATE TABLE guest ( guest_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address
VARCHAR(50) NOT NULL);
 */


create schema Grosvenor
use Grosvenor
CREATE TABLE hotel ( hotel_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address VARCHAR(50) NOT NULL);
CREATE TABLE room ( room_no VARCHAR(4) NOT NULL, hotel_no CHAR(4) NOT NULL, type CHAR(1) NOT NULL, price DECIMAL(5,2) NOT NULL);
CREATE TABLE booking (hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from DATETIME NOT NULL, date_to DATETIME NULL, room_no CHAR(4) NOT NULL); -- Dates: YYYY-MM-DD;
CREATE TABLE guest ( guest_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address VARCHAR(50) NOT NULL);


--  Populating the Tables --

INSERT INTO hotel VALUES ('H111', 'Grosvenor Hotel','London'); 
INSERT INTO hotel VALUES ('H112', 'Hotel Pushpak','Bangalore'); 
INSERT INTO hotel VALUES ('H113', 'InterContinental','Kabul'); 
INSERT INTO hotel VALUES ('H114', 'La Quinta','Moscow'); 
INSERT INTO hotel VALUES ('H115', 'Comfort Hotel Astana','Nur-Sultan'); 

select * from hotel

INSERT INTO room VALUES ('007', 'H111', 'S', 72.00); -- where S= Single
INSERT INTO room VALUES ('004', 'H112', 'D', 999.00); -- where D= Double
INSERT INTO room VALUES ('001', 'H115', 'F', 147.00); -- where F= Family
INSERT INTO room VALUES ('006', 'H111', 'S', 72.00); 
INSERT INTO room VALUES ('024', 'H111', 'S', 72.00); 
INSERT INTO room VALUES ('014', 'H113', 'D', 112.00); 
INSERT INTO room VALUES ('011', 'H114', 'S', 64.00); 
INSERT INTO room VALUES ('003', 'H115', 'F', 147.00); 
INSERT INTO room VALUES ('013', 'H112', 'S', 634.00); 
INSERT INTO room VALUES ('009', 'H115', 'F', 147.00); 

select * from room

INSERT INTO guest VALUES ('G111', 'Aziz-ula-hak', 'Islamabad'); 
INSERT INTO guest VALUES ('G007', 'James Bond', 'London'); 
INSERT INTO guest VALUES ('G136', 'Vikrant Rona', 'Coorg'); 
INSERT INTO guest VALUES ('G114', 'Anjali Nair', 'Malabar'); 
INSERT INTO guest VALUES ('G148', 'Rusptin', 'Dagestan'); 
INSERT INTO guest VALUES ('G195', 'Arsen Nurislam', 'Baikonur'); 

select * from guest

INSERT INTO booking VALUES ('H115', 'G111', DATE'1999-04-01', DATE'1999-04-06', '009');
INSERT INTO booking VALUES ('H007', 'G007', DATE'1997-07-07', DATE'1997-07-07', '007');
INSERT INTO booking VALUES ('H112', 'G136', DATE'2000-06-07', DATE'2000-06-13', '021');
INSERT INTO booking VALUES ('H115', 'G114', DATE'2000-04-07', DATE'2000-04-13', '045');
INSERT INTO booking VALUES ('H114', 'G148', DATE'2000-08-04', DATE'2000-08-26', '045');
INSERT INTO booking VALUES ('H115', 'G195', DATE'2000-09-11', DATE'2000-09-26', '081');

select * from booking

/* Create a separate table with the same structure as the Booking table to hold archive records.
Using the INSERT statement, copy the records from the Booking table to the archive table relating to bookings before 1st January 2000. 
Delete all bookings before 1st January 2000 from the Booking table. */


CREATE TABLE booking_old ( hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from DATETIME NOT NULL, date_to DATETIME NULL, room_no VARCHAR(4) NOT NULL);
INSERT INTO booking_old (SELECT * FROM booking WHERE date_to < DATE'2000-01-01');
select * from booking_old
DELETE FROM booking WHERE date_to < DATE '2000-01-01';
select * from booking




-- Simple Queries

-- 1. List full details of all hotels.
SELECT * FROM hotel;

-- 2. List full details of all hotels in London.
SELECT * FROM hotel WHERE address LIKE '%London%';

-- 3. List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT name, address
FROM guest
WHERE address LIKE '%London%'
ORDER BY name;

-- 4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
SELECT * FROM room
WHERE price < 40 
ORDER BY price; 

-- 5. List the bookings for which no date_to has been specify
SELECT * FROM booking WHERE date_to IS NULL;




-- Aggregate Functions --

-- 1. How many hotels are there?
select count(*) from hotel;

-- 2. What is the average price of a room?
select avg(price) from room


-- 3. What is the total revenue per night from all double rooms?
select * from room
select sum(price) from room where type = 'D';


-- 4. How many different guests have made bookings for August?
select* from booking
select count(distinct guest_no)
 FROM booking
 WHERE (date_from >= '2004-08-01' AND date_from <= '2004-08-31');
 
 
 
 
 
 -- Subqueries and Joins

-- 1. List the price and type of all rooms at the Grosvenor Hotel.
select * from room
select * from hotel
SELECT price, type
FROM room
WHERE hotel_no = (SELECT hotel_no FROM hotel
WHERE name = 'Grosvenor Hotel');

-- 2. List all guests currently staying at the Grosvenor Hotel.
SELECT * FROM guest
WHERE guest_no =
(SELECT guest_no FROM booking
WHERE date_from <= CURRENT_DATE AND date_to >= CURRENT_DATE AND
hotel_no = (SELECT hotel_no FROM hotel
WHERE name = 'Grosvenor Hotel'));

-- 3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
SELECT r.* FROM room r INNER JOIN
(SELECT g.name, h.hotel_no, b.room_no FROM Guest g, Booking b, Hotel h
WHERE g.guest_no = b.guest_no AND b.hotel_no = h.hotel_no AND 
h.name= 'Grosvenor Hotel' AND
b.date_from <= CURRENT_DATE AND b.date_to >= CURRENT_DATE) AS XXX
ON r.hotel_no = XXX.hotel_no AND r.room_no = XXX.room_no;

-- 4. What is the total income from bookings for the Grosvenor Hotel today?
SELECT SUM(price) FROM booking b, room r, hotel h
WHERE (b.date_from <= CURRENT_DATE AND
b.date_to >= '1997-01-01') AND
r.hotel_no = h.hotel_no AND r.room_no = b.room_no AND h.name= 'Comfort Hotel Astana';

select * from room
select * from booking
select * from guest
select * from hotel


-- 5. List the rooms that are currently unoccupied at the Grosvenor Hotel.
SELECT * FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND name = 'Grosvenor Hotel');

-- 6. What is the lost income from unoccupied rooms at the Grosvenor Hotel?
SELECT SUM(price) FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no AND name = 'Grosvenor Hotel');





-- Grouping

-- 1. List the number of rooms in each hotel.
SELECT hotel_no, COUNT(room_no) AS count FROM room
GROUP BY hotel_no;

-- 2. List the number of rooms in each hotel in London.
SELECT hotel.hotel_no, COUNT(room_no)
AS count FROM hotel, room
WHERE room.hotel_no = hotel.hotel_no
AND address LIKE '%London%'
GROUP BY hotelno;

-- 3. What is the average number of bookings for each hotel in August?
SELECT AVG(X) AS AveNumBook FROM
(SELECT hotel_no, COUNT(hotel_no) AS X
FROM booking b
WHERE (b.date_from >= DATE'2000-04-01' AND b.date_from <= DATE'2000-04-30')
GROUP BY hotel_no) AS AnotherThing;
select * from booking

4. What is the most commonly booked room type for each hotel in London?
SELECT MAX(X) AS MostlyBook
FROM (SELECT type, COUNT(type) AS X
FROM booking b, hotel h, room r
WHERE r.room_no = b.room_no AND b.hotel_no = h.hotel_no AND
h.address LIKE '%London%'
GROUP BY type) AS Dummy;

5. What is the lost income from unoccupied rooms at each hotel today?
SELECT hotel_no, SUM(price) FROM room r
WHERE room_no NOT IN
(SELECT room_no FROM booking b, hotel h
WHERE (date_from <= CURRENT_DATE AND
date_to >= CURRENT_DATE) AND
b.hotel_no = h.hotel_no)
GROUP BY hotel_no;
