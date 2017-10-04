--Dynamically set a default value of SYSTIMESTAMP for the creation date.
BEGIN
  FOR r IN (SELECT table_name
            FROM   user_tables)
  LOOP
    BEGIN
      EXECUTE IMMEDIATE 'ALTER TABLE '||r.table_name||'
                         MODIFY(CREATION_DATE DEFAULT SYSTIMESTAMP)';
    EXCEPTION WHEN OTHERS THEN
      NULL; -- do nothing in case the table has no who columns
    END;
  END LOOP;
END;