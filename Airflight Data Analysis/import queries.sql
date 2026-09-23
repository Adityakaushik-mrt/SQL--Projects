										
									select * from airports;
									select * from bookings;
									select * from flights;
									select * from passengers;



Drop TABLE if EXISTS Airports;

CREATE table if not EXISTS Airports (
airport_id int PRIMARY KEY,
airport_code VARCHAR(10),
city VARCHAR(15),
country VARCHAR(15)
);

copy Airports(airport_id,airport_code,city,country)
FROM 'E:\Adi New Project\Adi sql\sql_mega_practice_all_csv\airline_flight\airports.csv'
delimiter','
csv HEADER;


------------------------------------------------------------------------------------------------------
Drop TABLE if EXISTS Bookings;

CREATE table if not EXISTS Bookings (
booking_id int PRIMARY KEY,
passenger_id int not null,
flight_id int not null,
booking_date date,
booking_status VARCHAR(20),
seat_class VARCHAR(30)
);

copy Bookings(booking_id,passenger_id,flight_id,booking_date,booking_status,seat_class)
FROM 'E:\Adi New Project\Adi sql\sql_mega_practice_all_csv\airline_flight\bookings.csv'
delimiter','
csv HEADER;

------------------------------------------------------------------------------------------------


Drop TABLE if EXISTS flights;

CREATE table if not EXISTS flights (
flight_id int PRIMARY KEY,
flight_no VARCHAR(10),
origin_airport int not null,
destination_airport int not null,
flight_date	date,
base_fare numeric(10,2)
);

copy flights(flight_id,flight_no,origin_airport,destination_airport,flight_date,base_fare)
FROM 'E:\Adi New Project\Adi sql\sql_mega_practice_all_csv\airline_flight\flights.csv'
delimiter','
csv HEADER;
-----------------------------------------------------------------------------------------------------------------

Drop TABLE if EXISTS passengers;

CREATE table if not EXISTS passengers (
passenger_id int PRIMARY key,
passenger_name VARCHAR(20),
gender VARCHAR(10),
city VARCHAR(20)
);

copy passengers(passenger_id,passenger_name,gender,city)
FROM 'E:\Adi New Project\Adi sql\sql_mega_practice_all_csv\airline_flight\passengers.csv'
delimiter','
csv HEADER;

