ALTER TABLE IF EXISTS STAFF
    DROP CONSTRAINT IF EXISTS branch_staff;
DROP INDEX IF EXISTS IX_Rent;
DROP TABLE IF EXISTS PAYMENT;
DROP TABLE IF EXISTS RENT;
DROP TABLE IF EXISTS MANAGES;
DROP TABLE IF EXISTS VEHICLE;
DROP TABLE IF EXISTS BRANCH;
DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS COST;
DROP TABLE IF EXISTS STAFF;
DROP TABLE IF EXISTS ADDRESSES;
DROP PROCEDURE IF EXISTS rent_vehicle ();
DROP FUNCTION IF EXISTS vehicle_returned ();
DROP TRIGGER IF EXISTS vehicle_returned ON RENT;

CREATE TABLE ADDRESSES (
   	address_id serial UNIQUE NOT NULL,
    street_name varchar(128) NOT NULL,
    house_number varchar(20) NOT NULL,
    city varchar(20) NOT NULL,
    country varchar(20) NOT NULL,
    zipcode int NOT NULL,
    PRIMARY KEY (address_id)
);
CREATE TABLE STAFF (
    staff_id serial UNIQUE NOT NULL,
    first_name varchar(128) NOT NULL,
    last_name varchar(128) NOT NULL,
    date_of_birth date,
    branch_id int NOT NULL,
    salary numeric(15, 2) NOT NULL,
    commission numeric(3, 3),
    address_id int,
    PRIMARY KEY (staff_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESSES (address_id)
);

CREATE TABLE CUSTOMER (
    customer_id serial UNIQUE NOT NULL,
    first_name varchar(128) NOT NULL,
    last_name varchar(128) NOT NULL,
    date_of_birth date NOT NULL,
    license_number varchar(6) NOT NULL,
    address_id int,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESSES (address_id)
);

CREATE TABLE BRANCH (
    branch_id serial UNIQUE NOT NULL,
    manager_id int,
    parking_spaces int,
    address_id int,
    PRIMARY KEY (branch_id),
    FOREIGN KEY (address_id) REFERENCES ADDRESSES (address_id),
    FOREIGN KEY (manager_id) REFERENCES STAFF (staff_id)
);

CREATE TABLE COST (
    cost_id serial UNIQUE NOT NULL,
    cost_class varchar(128) NOT NULL,
    cost_per_day numeric(15, 2),
    cost_per_kilometer numeric(15, 2),
    security_deposit numeric(15, 2),
    PRIMARY KEY (cost_id)
);

CREATE TABLE VEHICLE (
    vehicle_id serial UNIQUE NOT NULL,
    brand varchar(13),
    mileage int,
    date_bought date,
    cost_id int NOT NULL,
    branch_id int NOT NULL,
    is_available bool NOT NULL,
    PRIMARY KEY (vehicle_id),
    FOREIGN KEY (cost_id) REFERENCES COST (cost_id),
    FOREIGN KEY (branch_id) REFERENCES BRANCH (branch_id)
);

CREATE TABLE MANAGES (
    manage_id serial UNIQUE NOT NULL,
    staff_id int NOT NULL,
    vehicle_id int NOT NULL,
    vehicle_condition varchar(128),
    vehicle_managed_date date NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (manage_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF (staff_id),
    FOREIGN KEY (vehicle_id) REFERENCES VEHICLE (vehicle_id)
);

CREATE TABLE RENT (
    rent_id serial UNIQUE NOT NULL,
    vehicle_id int NOT NULL,
    trip_duration int NOT NULL,
    free_kilometers int DEFAULT 100,
    customer_id int NOT NULL,
    staff_id int NOT NULL,
    is_returned bool DEFAULT FALSE,
    date_rented date NOT NULL DEFAULT CURRENT_DATE,
    date_returned date,
    staff_id_returned int,
    mileage_returned int,
    PRIMARY KEY (rent_id),
    FOREIGN KEY (vehicle_id) REFERENCES VEHICLE (vehicle_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER (customer_id),
    FOREIGN KEY (staff_id) REFERENCES STAFF (staff_id)
);

CREATE TABLE PAYMENT (
    rent_id int NOT NULL,
    payment_amount numeric(15, 2) NOT NULL,
    payment_date date NOT NULL,
    PRIMARY KEY (rent_id, payment_date),
    FOREIGN KEY (rent_id) REFERENCES RENT (rent_id)
);


ALTER TABLE STAFF
    ADD CONSTRAINT branch_staff FOREIGN KEY (branch_id) REFERENCES BRANCH (branch_id);

CREATE UNIQUE INDEX IX_Rent
ON RENT (customer_id, is_returned)
WHERE
    is_returned = FALSE;


/*
PROCEDURE rent_vehicle()
*/
CREATE OR REPLACE PROCEDURE rent_vehicle (vehicleID int, customerID int, staffID int, duration int, rentdate date)
LANGUAGE plpgsql
AS '
BEGIN
    IF (
        SELECT
            is_available
        FROM
            VEHICLE
        WHERE
            VEHICLE.vehicle_id = vehicleID) AND NOT (
    SELECT
        count(*)
    FROM
        RENT
    WHERE
        RENT.customer_id = customerID AND RENT.is_returned = FALSE) > 0 THEN
        UPDATE
            VEHICLE
        SET
            is_available = FALSE
        WHERE
            VEHICLE.vehicle_id = vehicleID;
        UPDATE
            BRANCH
        SET
            parking_spaces = parking_spaces + 1
        WHERE
            branch_id = (
                SELECT
                    branch_id
                FROM
                    VEHICLE
                WHERE
                    VEHICLE.vehicle_id = vehicleID);
        INSERT INTO RENT (vehicle_id, trip_duration, customer_id, staff_id, is_returned, date_rented)
            VALUES (vehicleID, duration, customerID, staffID, FALSE, rentdate);
    ELSE
        RAISE EXCEPTION ''vehicle is not available/ customer already has an active rent'';
    END IF;
END;
';

/*
FUNCTION: vehicle_returned()
*/
CREATE OR REPLACE FUNCTION vehicle_returned()
    RETURNS TRIGGER
    LANGUAGE PLPGSQL
    AS '
BEGIN
    IF NEW.is_returned THEN
        IF (NEW.mileage_returned - (
            SELECT
                mileage
            FROM
                VEHICLE
            WHERE
                VEHICLE.vehicle_id = NEW.vehicle_id)) > NEW.free_kilometers THEN
            INSERT INTO PAYMENT (rent_id, payment_amount, payment_date)
                VALUES (NEW.rent_id, ((NEW.mileage_returned - (
                            SELECT
                                mileage FROM VEHICLE
                            WHERE
                                VEHICLE.vehicle_id = NEW.vehicle_id)) * (
                            SELECT
                                cost.cost_per_kilometer FROM VEHICLE
                            LEFT JOIN COST ON (VEHICLE.cost_id = COST.cost_id)
                        WHERE
                            VEHICLE.vehicle_id = NEW.vehicle_id)),
							(select date_returned from RENT WHERE RENT.rent_id = NEW.rent_id));
        END IF;
        UPDATE
            VEHICLE
        SET
            mileage = NEW.mileage_returned,
            is_available = TRUE
        WHERE
            VEHICLE.vehicle_id = NEW.vehicle_id;
        UPDATE
            BRANCH
        SET
            parking_spaces = parking_spaces - 1
        WHERE
            BRANCH.branch_id = (
                SELECT
                    branch_id
                FROM
                    RENT
                INNER JOIN VEHICLE ON (RENT.vehicle_id = VEHICLE.vehicle_id)
            WHERE
                VEHICLE.vehicle_id = NEW.vehicle_id);
    END IF;
    RETURN NEW;
END;
';

/*
TRIGGER:
This trigger calls the function car_returned() for each row that gets updated in the table RENT.
*/
CREATE TRIGGER vehicle_returned
    AFTER UPDATE ON RENT
    FOR EACH ROW
    EXECUTE PROCEDURE vehicle_returned ();
