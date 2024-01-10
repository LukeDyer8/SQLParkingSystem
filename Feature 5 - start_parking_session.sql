-- SQL code for starting a parking session
CREATE SEQUENCE SEQ_PARKING_SESSION START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE START_PARKING_SESSION(
    p_customer_id IN NUMBER,
    p_vehicle_id IN NUMBER,
    p_zone_id IN NUMBER,
    p_start_time IN TIMESTAMP,
    p_hours_to_park IN NUMBER
)
AS
    v_available_spots NUMBER;
    v_parking_length_limit NUMBER := 10; -- Adjust the limit as needed
    v_session_id NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_available_spots
    FROM parking_zone
    WHERE zone_id = p_zone_id;

    IF v_available_spots = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No available parking spots in the specified zone.');
        RETURN;
    END IF;

    IF p_hours_to_park > v_parking_length_limit THEN
        DBMS_OUTPUT.PUT_LINE('Parking length exceeds the maximum allowed limit.');
        RETURN;
    END IF;

    INSERT INTO parking_session (
        session_id,
        customer_id,
        vehicle_id,
        zone_id,
        start_time,
        end_time,
        total
    )
    VALUES (
        SEQ_PARKING_SESSION.NEXTVAL,
        p_customer_id,
        p_vehicle_id,
        p_zone_id,
        p_start_time,
        p_start_time + INTERVAL '1' HOUR * p_hours_to_park,
        0
    )
    RETURNING session_id INTO v_session_id;

    DBMS_OUTPUT.PUT_LINE('New parking session created with session ID: ' || v_session_id);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END START_PARKING_SESSION;
/
