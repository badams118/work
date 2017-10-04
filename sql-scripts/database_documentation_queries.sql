--Here are a couple of queries for creating technical documentation for a 
--database. It is a way to get a list of columns, data types, keys, constraint,
--and other relevant information. These queries are also useful in creating an 
--HTML format using image mapping to link them to a jpeg version of an ERD. You
--could also wrap these statements in a block using dynamic SQL to spool out the
--entire database to a file.
SELECT tc.column_name    column_name, 
       p.position        pk,
       tc.data_type      data_type,
       tc.data_length    data_size,
       tc.data_precision data_scale,
       tc.nullable       null_allowed,
       CASE 
         WHEN p.position IS NOT NULL THEN 'Y'
         ELSE NVL(u.is_unique, 'N')
       END is_unique,
       tc.data_default   data_default,
       cc.comments       description
FROM   user_tables                       t,
       user_tab_columns                  tc,
       (SELECT cc.table_name, 
               cc.column_name,
               cc.position
        FROM   user_cons_columns cc,
               user_constraints  c
        WHERE  cc.constraint_name = c.constraint_name 
        AND    c.constraint_type  = 'P') p,
       (SELECT DISTINCT 
               cc.table_name, 
               cc.column_name,
               'Y' is_unique
        FROM   user_cons_columns cc,
               user_constraints  c
        WHERE  cc.constraint_name = c.constraint_name 
        AND    c.constraint_type  = 'U') u,
       user_col_comments                 cc
WHERE  tc.column_name = p.column_name  (+)
AND    tc.table_name  = p.table_name   (+)
AND    tc.column_name = u.column_name  (+)
AND    tc.table_name  = u.table_name   (+)
AND    tc.column_name = cc.column_name (+)
AND    tc.table_name  = cc.table_name  (+)
AND    tc.table_name  = t.table_name
AND    t.table_name   = 'MY_TABLE_NAME'
ORDER BY p.position, 
         tc.column_id;

SELECT cc.column_name  column_name, 
       c2.table_name   foreign_key_table,
       cc2.column_name foreign_key_column
FROM   user_cons_columns cc,
       user_cons_columns cc2,
       user_constraints  c, 
       user_constraints  c2
WHERE  cc.constraint_name  = c.constraint_name
AND    c.r_constraint_name = c2.constraint_name
AND    c2.constraint_name  = cc2.constraint_name
AND    cc.table_name       = 'MY_TABLE_NAME'
ORDER BY cc.position;
