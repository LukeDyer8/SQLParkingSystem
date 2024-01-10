-- SQL code for printing statistics
CREATE OR REPLACE PROCEDURE PrintStatistics(p_start_date DATE, p_end_date DATE) IS
    v_total_customers INT;
    v_total_vehicles INT;
    v_total_zones INT;
    v_total_sessions INT;
BEGIN
    BEGIN
        SELECT COUNT(DISTINCT Customer_ID)
        INTO   v_total_customers
        FROM   Customer;

        DBMS_OUTPUT.PUT_LINE('Total Number of Customers: ' || v_total_customers);

        SELECT COUNT(*)
        INTO   v_total_vehicles
        FROM   Vehicle;

        DBMS_OUTPUT.PUT_LINE('Total Number of Vehicles: ' || v_total_vehicles);

        SELECT COUNT(*)
        INTO   v_total_zones
        FROM   Parking_Zone;

        DBMS_OUTPUT.PUT_LINE('Total Number of Parking Zones: ' || v_total_zones);

        SELECT COUNT(*)
        INTO   v_total_sessions
        FROM   Parking_Session
        WHERE  Start_Time >= p_start_date AND End_Time <= p_end_date;

        DBMS_OUTPUT.PUT_LINE('Total Number of Parking Sessions: ' || v_total_sessions);

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
END PrintStatistics;
/

-- Carry out Procedure SQL code...
DECLARE
    start_date DATE := TO_DATE('2023-01-01', 'YYYY-MM-DD');
    end_date DATE := TO_DATE('2023-12-31', 'YYYY-MM-DD');
BEGIN
    PrintStatistics(start_date, end_date);
END;
/
