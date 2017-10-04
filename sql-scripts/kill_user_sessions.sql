--Here is some code to kill all all users with a name containing 'APP_USER'.
BEGIN
  FOR r IN (SELECT s.sid,
                   s.serial#
            FROM   gv$session s
                   JOIN gv$process p ON p.addr    = s.paddr 
                                    AND p.inst_id = s.inst_id
            WHERE  s.type != 'BACKGROUND'
            AND    s.username LIKE '%APP_USER%')
  LOOP
    EXECUTE IMMEDIATE ' ALTER SYSTEM KILL SESSION '''||r.sid||','||
      r.serial#||'''';
  END LOOP;
END;

--Run this query to see what's left:
SELECT s.inst_id,
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       s.program
FROM   gv$session s
       JOIN gv$process p ON p.addr    = s.paddr 
                        AND p.inst_id = s.inst_id
WHERE  s.type != 'BACKGROUND';