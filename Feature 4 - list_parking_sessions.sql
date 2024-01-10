-- SQL code for listing all parking sessions
CREATE OR REPLACE PROCEDURE ListVehicles(p_zone_id INT) IS
BEGIN
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM Parking_Zone
        WHERE Zone_ID = p_zone_id;

        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Invalid or non-existent Zone ID. Please provide a valid Zone ID.');
            RETURN;
        END IF;

        SELECT COUNT(*)
        INTO v_count
        FROM Parking_Session
        WHERE Zone_ID = p_zone_id;

        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No vehicles are currently parked in the specified zone.');
            RETURN;
        END IF;

        DBMS_OUTPUT.PUT_LINE('Details of vehicles currently parked in Zone ' || p_zone_id || ':');
        DBMS_OUTPUT.PUT_LINE('License Plate | Maker | Model | Year | Color');

        FOR vehicle_rec IN (SELECT V.License_Plate_Number, V.Maker, V.Model, V.Year, V.Color
                            FROM Vehicle V
                            JOIN Parking_Session PS ON V.Vehicle_ID = PS.Vehicle_ID
                            WHERE PS.Zone_ID = p_zone_id)
        LOOP
            DBMS_OUTPUT.PUT_LINE(vehicle_rec.License_Plate_Number || ' | ' ||
                                 vehicle_rec.Maker || ' | ' ||
                                 vehicle_rec.Model || ' | ' ||
                                 vehicle_rec.Year || ' | ' ||
                                 vehicle_rec.Color);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
END ListVehicles;
/

