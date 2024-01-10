-- SQL code for adding a vehicle
CREATE OR REPLACE PROCEDURE add_vehicle(
    in_license_plate VARCHAR(15),
    in_state VARCHAR(2),
    in_customer_id INT,
    in_maker VARCHAR(255),
    in_model VARCHAR(255),
    in_year INT,
    in_color VARCHAR(255)
)
AS
    v_existing_customer INT;
    v_existing_vehicle INT;
    v_new_vehicle_id INT;
BEGIN
    SELECT COUNT(*)
    INTO v_existing_customer
    FROM Customer
    WHERE Customer_ID = in_customer_id;

    IF v_existing_customer = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Customer ID');
        RETURN;
    END IF;

    SELECT COUNT(*)
    INTO v_existing_vehicle
    FROM Vehicle
    WHERE License_Plate_Number = in_license_plate
    AND State = in_state;

    IF v_existing_vehicle > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Vehicle already exists');
        RETURN;
    END IF;

    SELECT vehicle_seq.NEXTVAL INTO v_new_vehicle_id FROM DUAL;

    INSERT INTO Vehicle (Vehicle_ID, License_Plate_Number, State, Customer_ID, Maker, Model, Year, Color)
    VALUES (v_new_vehicle_id, in_license_plate, in_state, in_customer_id, in_maker, in_model, in_year, in_color);

    DBMS_OUTPUT.PUT_LINE(v_new_vehicle_id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END add_vehicle;
/
