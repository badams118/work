--Below is how to create a context in Oracle. Start by creating the package.  
--This is just a wrapper for the built in dbms_session package.

CREATE PACKAGE context_package AS
  -- value_name can be any value that needs to be tracked, and can pass from the 
  -- application to the database. Most common is the user id, but can be 
  -- anything including the client machine name and/or IP address.

  PROCEDURE set_context(p_context_attribute VARCHAR2, p_context_value VARCHAR2);

  FUNCTION get_context_value(p_context_name VARCHAR2,
                             p_attribute    VARCHAR2) RETURN VARCHAR2;
END context_package;
/

CREATE PACKAGE BODY context_package AS
  PROCEDURE set_context(p_context_attribute VARCHAR2, p_context_value VARCHAR2) 
  IS
  BEGIN
    DBMS_SESSION.SET_CONTEXT('context_name', 
                             p_context_attribute, 
                             p_context_value);
  END set_context;
  
  FUNCTION get_context_value(p_attribute VARCHAR2) RETURN VARCHAR2 
  IS
    v_attribute_value VARCHAR2(4000);
  BEGIN
    SELECT SYS_CONTEXT('context_name', p_attribute)
    INTO   v_attribute_value
    FROM   dual;
    
    RETURN v_attribute_value;
  END get_context_value;
END context_package;
/

--Next, create the context using the package just built.
CREATE CONTEXT context_name USING context_package;

--Test the context.
BEGIN context_package.set_context('user_id', 'test user'); END;

--This should return "test user"
SELECT SYS_CONTEXT('context_name', 'user_id') 
FROM   dual;

--Here is an example of a how to use a context in a trigger to populate the who
--columns.
CREATE OR REPLACE TRIGGER trigger_name
  BEFORE INSERT OR UPDATE ON table_name
  REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
BEGIN
  IF INSERTING THEN
    :NEW.created_by    := context_package.get_context_value('user_id');
    :NEW.creation_date := SYSDATE;
  ELSIF UPDATING THEN
    :NEW.last_updated_by  := context_package.get_context_value('user_id');
    :NEW.last_update_date := SYSDATE;
  END IF;
END;
/