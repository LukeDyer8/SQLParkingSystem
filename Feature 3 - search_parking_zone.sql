-- SQL code for searching for a parking zone
SET SERVEROUTPUT ON;
DECLARE
    n_zipcode VARCHAR2(10) := '21250';
    n_current_time TIMESTAMP := SYSTIMESTAMP;
    n_parking_length INT := 5;
BEGIN
    FOR zone IN (
        SELECT *
        FROM Parking_Zone
        WHERE Zipcode = n_zipcode
        AND Available_Spots > 0
        AND NOT (
            TO_CHAR(n_current_time, 'D') BETWEEN Start_Day AND End_Day
            AND n_current_time BETWEEN TO_TIMESTAMP(Start_Time, 'HH:MI AM') AND TO_TIMESTAMP(End_Time, 'HH:MI AM')
            AND Max_Length >= n_parking_length)
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('In zone ' || zone.Zone_ID || ', there are ' || zone.Available_Spots || ' available spots at ' || zone.Address ||
            '. The hourly rate is $' || TO_CHAR(zone.Hourly_Rate, 'FM999999990.00') ||
            ' and is effective from ' || zone.Start_Day || ' ' || TO_CHAR(zone.Start_Time, 'HH:MI AM') ||
            ' to ' || zone.End_Day || ' ' || TO_CHAR(zone.End_Time, 'HH:MI AM') || '.');
    END LOOP;
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('No available zones.');
    END IF;
END;
