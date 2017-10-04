--This procedure makes sure that a table's sequence is up to date with its 
--primary key. 
CREATE OR REPLACE PROCEDURE Increment_Sequence(p_schema VARCHAR2, 
                                               p_table  VARCHAR2)
AS
  v_schema     VARCHAR2(30) := p_schema;
  v_pk_column  VARCHAR2(30);
  v_current_id NUMBER;
  v_max_id     NUMBER; 
  v_seq        NUMBER;
BEGIN 
  IF v_schema IS NULL THEN
    SELECT SYS_CONTEXT('userenv', 'current_schema') 
    INTO   v_schema
    FROM   DUAL;
  END IF;
  
  SELECT cc.column_name
  INTO   v_pk_column
  FROM   all_constraints  ac,
         all_cons_columns cc
  WHERE  ac.constraint_name = cc.constraint_name
  AND    ac.owner           = UPPER(v_schema)
  AND    ac.constraint_type = 'P'
  AND    ac.table_name      = UPPER(v_table);
  
  -- get the largest primary key value from the table
  EXECUTE IMMEDIATE 'SELECT NVL(MAX('||v_pk_column||'), 0) FROM '||v_schema||
                    '.'||p_table 
    INTO v_max_id;
  
  -- get the current sequence number
  EXECUTE IMMEDIATE 'SELECT '||v_schema||'.'||p_table||'_s.NEXTVAL FROM DUAL'
    INTO v_seq;
  
  -- decrement the sequence back to one
  EXECUTE IMMEDIATE 'ALTER SEQUENCE '||v_schema||'.'||p_table||
                    '_s INCREMENT BY -'||v_seq||' MINVALUE 0';
  
  -- decrement the sequence back to one
  EXECUTE IMMEDIATE 'SELECT '||v_schema||'.'||p_table||'_s.NEXTVAL FROM DUAL' 
    INTO v_seq;
    
  v_max_id := NVL(v_max_id, 1);
  
  IF v_max_id = 0 THEN v_max_id := 1; END IF;
    
  EXECUTE IMMEDIATE 'ALTER SEQUENCE '||v_schema||'.'||p_table||
                    '_s INCREMENT BY '||v_max_id;
  
  -- increment the sequence to the max table id
  EXECUTE IMMEDIATE 'SELECT '||v_schema||'.'||p_table||'_s.NEXTVAL FROM DUAL' 
    INTO v_seq;
  
  -- now make sure the sequence is incrementing by one here after
  EXECUTE IMMEDIATE 'ALTER SEQUENCE '||v_schema||'.'||p_table||
                    '_s INCREMENT BY 1';
END;
/

--Iterate through the procedure to make sure all sequences in a schema are up to
--date.
BEGIN
  FOR r IN (SELECT * 
            FROM   user_tables) LOOP
    Increment_Sequence('SCHEMA_NAME', r.table_name);
  END LOOP;
END;