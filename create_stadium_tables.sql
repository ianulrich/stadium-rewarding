CREATE DATABASE stadium_rewarding;

\c stadium_rewarding;

CREATE TABLE stand (
    stand_id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL UNIQUE CHECK (name IN ('EAST', 'WEST', 'SOUTH', 'NORTH')),
    available_seats INTEGER NOT NULL CHECK (available_seats > 0),
    discount_price DECIMAL(10,2) NOT NULL CHECK (discount_price >= 0),
    reserved_seats TEXT[] NOT NULL
);

CREATE TABLE preference (
    preference_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    occupation_code CHAR(3) NOT NULL CHECK (occupation_code IN ('STU', 'EDU', 'MLT', 'OTH')),
    stand_name VARCHAR(10) NOT NULL REFERENCES stand(name) ON DELETE RESTRICT,
    reservation_time TIMESTAMP NOT NULL
);

CREATE TABLE reward (
    reward_id SERIAL PRIMARY KEY,
    preference_id INTEGER NOT NULL UNIQUE REFERENCES preference(preference_id) ON DELETE CASCADE,
    assigned_seat TEXT NOT NULL
);

CREATE INDEX idx_preference_stand ON preference(stand_name);
CREATE INDEX idx_preference_time ON preference(reservation_time);
CREATE UNIQUE INDEX idx_preference_name_lower ON preference(LOWER(first_name), LOWER(last_name));

INSERT INTO stand (name, available_seats, discount_price, reserved_seats) VALUES
('EAST', 3, 10.00, ARRAY['E001', 'E002', 'E003']),
('WEST', 3, 5.00, ARRAY['W501', 'W502', 'W503']),
('SOUTH', 5, 2.00, ARRAY['S101', 'S102', 'S103', 'S104', 'S105']),
('NORTH', 5, 2.00, ARRAY['N601', 'N602', 'N603', 'N604', 'N605']);