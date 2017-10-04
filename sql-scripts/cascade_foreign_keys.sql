--This procedure changes all foreign keys to cascade on delete.
BEGIN
  FOR r IN (SELECT c.constraint_name constraint_name,
                   cc.table_name     table_name,
                   cc.column_name    column_name,
                   c2.table_name     foreign_key_table,
                   cc2.column_name   foreign_key_column,
                   CASE c.delete_rule
                     WHEN 'CASCADE'  THEN 'ON DELETE CASCADE'
                     WHEN 'SET NULL' THEN 'ON DELETE SET NULL'
                     ELSE NULL
                   END               delete_rule,
                   c.deferrable      deferrable,
                   CASE c.deferred
                     WHEN 'IMMEDIATE' THEN 'INITIALLY IMMEDIATE'
                     ELSE 'INITIALLY DEFERRED'
                   END               deferred,
                   CASE c.status
                     WHEN 'ENABLED' THEN 'ENABLE'
                     ELSE 'DISABLE'
                   END               status,
                   CASE c.validated
                     WHEN 'VALIDATED' THEN 'VALIDATE'
                     ELSE 'NO VALIDATE'
                   END                validated
            FROM   user_cons_columns cc,
                   user_cons_columns cc2,
                   user_constraints  c,
                   user_constraints  c2
            WHERE  cc.constraint_name  = c.constraint_name
            AND    c.r_constraint_name = c2.constraint_name
            AND    c2.constraint_name  = cc2.constraint_name
            AND    c.constraint_type   = 'R')
  LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE '||r.table_name||' DROP CONSTRAINT '||
      r.constraint_name;

    EXECUTE IMMEDIATE
      'ALTER TABLE '||r.table_name||' ADD (
        CONSTRAINT '||r.constraint_name||'
        FOREIGN KEY ('||r.column_name||')
        REFERENCES '||r.foreign_key_table||' ('||r.foreign_key_column||')
        ON DELETE CASCADE '||
        r.deferrable ||' '||
        r.deferred   ||' '||
        r.status     ||' '||
        r.validated  ||')';
  END LOOP;
END;