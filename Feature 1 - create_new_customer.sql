-- SQL code for creating a new customer
CREATE OR REPLACE PROCEDURE create_new_customer(
    p_name IN VARCHAR2,
    p_phone IN VARCHAR2,
    p_address IN VARCHAR2,
    p_state IN VARCHAR2,
    p_zip IN VARCHAR2,
    p_email IN VARCHAR2,
    p_credit_card IN VARCHAR2
)
AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM customer
    WHERE phone_number = p_phone;

    IF v_count > 0 THEN
        UPDATE customer
        SET
            name = p_name,
            address = p_address,
            state = p_state,
            zipcode = p_zip,
            email = p_email,
            credit_card_number = p_credit_card
        WHERE phone_number = p_phone;

        DBMS_OUTPUT.PUT_LINE('The user exists already! We have updated their information based on your input.');
    ELSE
        INSERT INTO customer (Customer_ID, Name, Phone_Number, Address, State, Zipcode, Email, Credit_Card_Number)
        VALUES (customer_seq.NEXTVAL, p_name, p_phone, p_address, p_state, p_zip, p_email, p_credit_card);

        DBMS_OUTPUT.PUT_LINE('A customer created with the new ID: ' || customer_seq.CURRVAL);
    END IF;
END;
/
