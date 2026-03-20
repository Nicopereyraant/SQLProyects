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
CONSTRAINT fk_last_station_id
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
CONSTRAINT fk_user_trip_id	
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
CONSTRAINT fk_scooter_id
	FOREIGN KEY (scooter_id) REFERENCES Scooters (scooter_id),
CONSTRAINT fk_station_start_id
	FOREIGN KEY (station_start_id) REFERENCES Stations(station_id),
CONSTRAINT fk_station_end_id	
    FOREIGN KEY (station_end_id) REFERENCES Stations(station_id)
);

CREATE TABLE Payment_Methods (
pay_method_id INT AUTO_INCREMENT PRIMARY KEY,
user_id INT NOT NULL,
method_type VARCHAR(100),
card_last_digits INT,
expiration_date DATE,
CONSTRAINT fk_user_id
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
CONSTRAINT fk_trip_id
	FOREIGN KEY (trip_id) REFERENCES Trips(trip_id),
CONSTRAINT fk_pay_method_id	
    FOREIGN KEY (pay_method_id) REFERENCES Payment_Methods(pay_method_id)
);

CREATE TABLE Staff (
staff_id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
role VARCHAR(50),
phone VARCHAR(20)
);

CREATE TABLE Maintenance (
maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
scooter_id INT NOT NULL,
staff_id INT NOT NULL,
maintenance_date DATETIME DEFAULT CURRENT_TIMESTAMP,
description TEXT, -- Ejemplo: 'Cambio de neumáticos' o 'Carga de batería'
cost DECIMAL(10,2),
CONSTRAINT fk_maintenance_scooter 
	FOREIGN KEY (scooter_id) REFERENCES Scooters(scooter_id),
CONSTRAINT fk_maintenance_staff 
	FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

CREATE TABLE User_Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5), -- Calificación de 1 a 5
    user_comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_trip 
		FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);