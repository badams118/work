--This PL/SQL block, using data dictionary driven dynamic SQL, iteratively issue
--grants on selected valid objects. It is useful in a two schema environment 
--where we want to keep all the objects (and DDL rights) in an "APP_OWNER" 
--schema, allowing only DML access to an "APP_USER" schema.
BEGIN
  FOR r IN (SELECT *
            FROM   user_objects
            WHERE  status = 'VALID'
            AND    object_type IN ('TABLE',
                                   'PROCEDURE',
                                   'FUNCTION',
                                   'PACKAGE',
                                   'VIEW',
                                   'SEQUENCE')) 
  LOOP
    EXECUTE IMMEDIATE 'GRANT ALL ON '||r.object_name||' TO app_user';
  END LOOP;
END;