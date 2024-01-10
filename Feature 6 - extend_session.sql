-- SQL code for extending a parking session
CREATE OR REPLACE PROCEDURE extend_session(
    in_session_id INT,
    in_current_time TIMESTAMP,
    in_hours_to_extend INT
)
AS
    v_max_length INT;
    v_end_time TIMESTAMP;
    v_current_end_time TIMESTAMP;
    v_total_charge DECIMAL(10, 2);
BEGIN
    SELECT Max_Length, End_Time, Total_Charge INTO v_max_length, v_current_end_time, v_total_charge
    FROM Parking_Session
    WHERE Session_ID = in_session_id;

    IF v_max_length IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Session ID');
        RETURN;
    END IF;

    v_end_time := v_current_end_time + INTERVAL '1' HOUR * in_hours_to_extend;

    IF v_end_time > (v_current_end_time + INTERVAL '1' HOUR * v_max_length) THEN
        DBMS_OUTPUT.PUT_LINE('Maximal length reached, cannot extend session');
        RETURN;
    END IF;

    IF in_current_time > v_current_end_time THEN
        DBMS_OUTPUT.PUT_LINE('You can only extend a session before it expires');
        RETURN;
    END IF;

    UPDATE Parking_Session
    SET End_Time = v_end_time,
        Total_Charge = v_total_charge + (Hourly_Rate * in_hours_to_extend)
    WHERE Session_ID = in_session_id;

    INSERT INTO Message (Customer_ID, Message_Time, Message_Body)
    VALUES ((SELECT Customer_ID FROM Parking_Session WHERE Session_ID = in_session_id),
            in_current_time,
            'Parking session ' || in_session_id || ' extended to ' || TO_CHAR(v_end_time, 'YYYY-MM-DD HH24:MI:SS'));

    INSERT INTO Payment (Payment_ID, Session_ID, Payment_Time, Amount, Hours_Covered)
    VALUES (payment_seq.NEXTVAL, in_session_id, in_current_time, (Hourly_Rate * in_hours_to_extend), in_hours_to_extend);

    DBMS_OUTPUT.PUT_LINE('Session successfully extended');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred');
END extend_session;
/
