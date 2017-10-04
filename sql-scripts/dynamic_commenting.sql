--Here is some data dictionary driven dynamic SQL adding a specific comment on
--a "who" column.
BEGIN
  FOR r IN (SELECT cc.table_name, 
                   cc.column_name
            FROM   user_tab_columns  cc,
                   user_col_comments ucc
            WHERE  cc.table_name  = ucc.table_name
            AND    cc.column_name = ucc.column_name
            AND    cc.column_name = 'CREATED_BY'
            AND    ucc.comments IS NULL)
  LOOP
    EXECUTE IMMEDIATE 
      'COMMENT ON COLUMN '||r.table_name||'.'||r.column_name||
      ' IS ''Standard who column. User who created this row.''';
  END LOOP;
END;
/

--Here we add a comment on a table's primary key column based on a consistent
--naming convention.
BEGIN
  FOR r IN (SELECT cc.table_name, 
                   cc.column_name
            FROM   user_cons_columns cc,
                   user_col_comments ucc,
                   user_constraints  c
            WHERE  cc.table_name      = ucc.table_name
            AND    cc.column_name     = ucc.column_name
            AND    cc.constraint_name = c.constraint_name 
            AND    c.constraint_type  = 'P'
            AND    cc.column_name     = cc.table_name||'_ID'
            AND    ucc.comments IS NULL)
  LOOP
    EXECUTE IMMEDIATE 
      'COMMENT ON COLUMN '||r.table_name||'.'||r.column_name||' IS '''||
      REPLACE(INITCAP(r.table_name), '_', ' ')||
      ' identifier and primary key for this table.''';
  END LOOP;
END;
/