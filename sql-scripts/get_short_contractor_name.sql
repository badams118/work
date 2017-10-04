--This function matches company names by parsing names down to make them easier
--to match.
CREATE OR REPLACE FUNCTION Get_Short_Contractor_Name(p_contractor_name VARCHAR2) 
RETURN VARCHAR2 DETERMINISTIC AS
  v_contractor_name VARCHAR2(4000) := p_contractor_name;
BEGIN
  v_contractor_name := UPPER(v_contractor_name);
  v_contractor_name := REGEXP_REPLACE(v_contractor_name, '-', ' ');
  v_contractor_name := REGEXP_REPLACE(v_contractor_name, '( ){2,}', ' ');
  v_contractor_name := REGEXP_REPLACE(v_contractor_name, 
                                      '\.|,|’|''|CORPORATION|COMPANY', '');
  FOR r IN 1 .. 4 LOOP
    v_contractor_name := REGEXP_REPLACE(TRIM(v_contractor_name), 
                                        ' CO$| LLC$| INC$| CORP$', '');
  END LOOP;
  v_contractor_name := REPLACE(v_contractor_name, 'CONSTRUCTION', 'CONST');
  v_contractor_name := REPLACE(v_contractor_name, 'EXCAVATING',   'EXCAV');
  v_contractor_name := REPLACE(v_contractor_name, 'ELECTRICAL',   'ELEC');
  v_contractor_name := REPLACE(v_contractor_name, 'CONTRACTORS',  'CONT');
  v_contractor_name := REPLACE(v_contractor_name, 'BROTHERS',     'BROS');
  v_contractor_name := REPLACE(v_contractor_name, 'TECHNOLOGIES', 'TECH');
  v_contractor_name := REPLACE(v_contractor_name, 'ASSOCIATES',   'ASSOC');
  v_contractor_name := REPLACE(v_contractor_name, ' AND ',        '&amp;');
  v_contractor_name := REPLACE(v_contractor_name, ' &amp; ',          '&amp;');
  v_contractor_name := TRIM(v_contractor_name);
  
  RETURN v_contractor_name;
END;

--Don't forget to put a function based index on the tables that are using this
--function.