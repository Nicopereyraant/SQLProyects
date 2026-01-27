CREATE TABLE Stations (
station_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100),
address VARCHAR(200),
capacity INT
);

CREATE TABLE Users (
user_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(50),
document_type VARCHAR(50),
document INT
);

CREATE TABLE Scooters (
scooter_id INT AUTO_INCREMENT PRIMARY KEY,
last_station_id INT NOT NULL,
model VARCHAR(100),
year INT,
battery_level DECIMAL (5,2),
scooter_condition VARCHAR(50),
FOREIGN KEY (last_station_id) REFERENCES Stations(station_id)
);

CREATE TABLE Trips (
trip_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
scooter_id INT NOT NULL,
station_start_id INT NOT NULL,
station_end_id INT NOT NULL,
start_time DATETIME,
end_time DATETIME,
distance_km DECIMAL (10,2),
FOREIGN KEY (user_id) REFERENCES Users(user_id),
FOREIGN KEY (scooter_id) REFERENCES Scooters (scooter_id),
FOREIGN KEY (station_start_id) REFERENCES Stations(station_id),
FOREIGN KEY (station_end_id) REFERENCES Stations(station_id)
);

CREATE TABLE Payment_Methods (
pay_method_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
method_type VARCHAR(100),
card_last_digits INT,
expiration_date DATE,
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Charges (
charge_id INT AUTO_INCREMENT PRIMARY KEY,
trip_id INT NOT NULL,
pay_method_id INT NOT NULL,
total_amount DECIMAL(10,2),
currency VARCHAR(50),
charge_date DATETIME,
charge_status VARCHAR(50),
FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
FOREIGN KEY (pay_method_id) REFERENCES Payment_Method(pay_method_id)
);