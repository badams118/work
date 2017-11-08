CREATE OR REPLACE TYPE XBOL_Rec_Search_Results AS OBJECT(
                                    Account_Number              VARCHAR2(30)   --hz_cust_accounts.account_number%TYPE
                                   ,Legacy_Account_Number       VARCHAR2(150)  --hz_cust_accounts.attribute2%TYPE
                                   ,Brand                       VARCHAR2(30)   --hz_cust_accounts.attribute_category%TYPE
                                   ,Country                     VARCHAR2(60)   --hz_locations.country%TYPE
                                   ,Mailing_Subdivision         VARCHAR2(60)   --hz_locations.province%TYPE -- hz_locations.state%TYPE
                                   ,Mailing_PostalCode          VARCHAR2(60)   --hz_locations.postal_code%TYPE
                                   ,City                        VARCHAR2(60)   --hz_locations.city%TYPE
                                   ,Account_Type                VARCHAR2(4000)
                                   ,Customer_Type               VARCHAR2(30)   --hz_cust_accounts.customer_type%TYPE
                                   ,Name                        VARCHAR2(360)  --hz_parties.party_name%TYPE
                                   ,Name_In_English             VARCHAR2(320)  --hz_parties.organization_name_phonetic%TYPE
                                   ,Name_Legal                  VARCHAR2(240)  --hz_parties.known_as%TYPE
                                   ,Account_Language            VARCHAR2(1000)
                                   ,Account_Status              VARCHAR2(1000) -- hz_org_profiles_ext_b.c_ext_attr5%TYPE
                                   ,Rank                        VARCHAR2(1000)
                                   ,Daily_Method_Oper           VARCHAR2(150)  --hz_cust_accounts.attribute6%TYPE
                                   ,Is_Valid_Sponsor            NUMBER(1)      --BOOLEAN
                                   ,Contact_ID                  NUMBER(15)     --hz_parties.party_id%TYPE
                                   ,Contact_Type                VARCHAR2(50)
                                   ,Contact_First_Name          VARCHAR2(150)  --hz_parties.person_first_name%TYPE
                                   ,Contact_Middle_Name         VARCHAR2(60)   --hz_parties.person_middle_name%TYPE
                                   ,Contact_Last_Name           VARCHAR2(150)  --hz_parties.person_last_name%TYPE
                                   ,Contact_Full_Name_English   VARCHAR2(150)  --hz_parties.person_last_name%TYPE
                                   ,Contact_Maternal_Last_Name  VARCHAR2(150)  --hz_parties.person_last_name%TYPE
                                   ,Contact_Language            VARCHAR2(4)    --hz_parties.language_name%TYPE
                                   ,Contact_Email_Address       VARCHAR2(2000) --hz_contact_points.email_address%TYPE
                                   ,Call_In_Authentication      VARCHAR2(4000)
                                   ,CONSTRUCTOR FUNCTION XBOL_Rec_Search_Results RETURN SELF AS RESULT
                                   );
/
             
--DROP TYPE BODY XBOL_Rec_Search_Results;

CREATE OR REPLACE TYPE BODY XBOL_Rec_Search_Results AS
  CONSTRUCTOR FUNCTION XBOL_Rec_Search_Results RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

--DROP TYPE XBOL_Tab_Search_Results;
                                   
CREATE TYPE XBOL_Tab_Search_Results IS TABLE OF XBOL_Rec_Search_Results;
/
  
CREATE OR REPLACE TYPE XBOL_Rec_Search_Parameters AS OBJECT(
                                       Search_Globally            NUMBER(1)--BOOLEAN
                                      ,Account_Number             VARCHAR2(30) --hz_cust_accounts.account_number%TYPE
                                      ,Legacy_Account_Num         VARCHAR2(150) --hz_cust_accounts.attribute2%TYPE
                                      ,Phone_Number               VARCHAR2(40) --hz_contact_points.phone_number%TYPE
                                      ,Email_Address              VARCHAR2(2000) --hz_contact_points.email_address%TYPE
                                      ,Account_Name               VARCHAR2(360) --hz_party_sites.addressee%TYPE
                                      ,Contact_First_Name         VARCHAR2(150) --hz_parties.person_first_name%TYPE
                                      ,Contact_Last_Name          VARCHAR2(150) --hz_parties.person_last_name%TYPE
                                      ,Contact_Full_Name_English  VARCHAR2(320) --hz_person_profiles.person_name_phonetic%TYPE
                                      ,City                       VARCHAR2(60) --hz_locations.city%TYPE
                                      ,State                      VARCHAR2(150) --hz_locations.state%TYPE
                                      ,Postal_Code                VARCHAR2(60) --hz_locations.postal_code%TYPE
                                      ,CONSTRUCTOR FUNCTION XBOL_Rec_Search_Parameters RETURN SELF AS RESULT
                                      );
/
                                      
CREATE OR REPLACE TYPE BODY XBOL_Rec_Search_Parameters AS
  CONSTRUCTOR FUNCTION XBOL_Rec_Search_Parameters RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

--DROP TYPE XBOL_Tab_Search_Parameters;

CREATE OR REPLACE TYPE XBOL_Tab_Search_Parameters AS TABLE OF XBOL_Rec_Search_Parameters;
/

CREATE OR REPLACE PROCEDURE XBOL_Search_Account_Contact (
  x_errbuf          OUT VARCHAR2,
  x_retcode         OUT BOOLEAN,
  x_Search_Output   OUT xbol_tab_Search_Results,
  p_Brand           IN  VARCHAR2,
  p_Country         IN  VARCHAR2,
  p_Language        IN  VARCHAR2,
  p_Agent           IN  VARCHAR2,
  p_Client_Sys      IN  VARCHAR2,
  p_Search_Params   IN  xbol_rec_search_parameters)
IS
  j                 NUMBER := 1;
  lc_acct_cursor    SYS_REFCURSOR;
  ls_Country        hz_cust_accounts.attribute1%TYPE;
  ls_SQL            VARCHAR2 (8000);
  ls_Where          VARCHAR2 (8000);
BEGIN
  x_Search_Output := xbol_tab_Search_Results();
  
  x_retcode := TRUE;

  IF p_Search_Params.Search_Globally = 1 THEN
     ls_Country := NULL;
  ELSE
     ls_Country := p_Country;
  END IF;

  IF ls_Country IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || 'AND country LIKE '
        || CHR (39)
        || ls_Country
        || '%'
        || CHR (39);
  ELSE
     ls_Where := ls_Where || 'AND country LIKE ' || CHR (39) || '%' || CHR (39);
  END IF;

  IF p_Search_Params.account_number IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND account_number LIKE'
        || CHR (39)
        || p_Search_Params.account_number
        || CHR (39);
  END IF;

  IF p_Search_Params.legacy_account_num IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND legacy_account_number LIKE'
        || CHR (39)
        || p_Search_Params.legacy_account_num
        || CHR (39);
  END IF;

  IF p_Search_Params.account_name IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND (UPPER(name) LIKE UPPER('
        || CHR (39)
        || p_Search_Params.account_name
        || '%'
        || CHR (39)
        || '))';
  END IF;

  IF p_Search_Params.contact_first_name IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND  UPPER(contact_first_name) LIKE '
        || CHR (39)
        || UPPER (p_Search_Params.contact_first_name)
        || '%'
        || CHR (39);
  END IF;

  IF p_Search_Params.contact_last_name IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND UPPER(contact_last_name) LIKE'
        || CHR (39)
        || UPPER (p_Search_Params.contact_last_name)
        || '%'
        || CHR (39);
  END IF;

  IF p_Search_Params.city IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND city LIKE'
        || CHR (39)
        || p_Search_Params.city
        || '%'
        || CHR (39);
  END IF;

  IF p_Search_Params.state IS NOT NULL THEN
     IF UPPER (p_Country) = 'US' THEN
        ls_Where :=
              ls_Where
           || ' AND subdivision LIKE '
           || CHR (39)
           || UPPER (p_Search_Params.state)
           || CHR (39);
     ELSE
        ls_Where :=
              ls_Where
           || ' AND subdivision LIKE '
           || CHR (39)
           || UPPER (p_Search_Params.state)
           || '%'
           || CHR (39);
     END IF;
  END IF;

  IF p_Search_Params.postal_code IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND postal_code  LIKE'
        || CHR (39)
        || p_Search_Params.postal_code
        || '%'
        || CHR (39);
  END IF;

  IF p_Search_Params.contact_full_name_english IS NOT NULL THEN
     ls_Where :=
           ls_Where
        || ' AND contact_full_name_english LIKE'
        || CHR (39)
        || p_Search_Params.contact_full_name_english
        || '%'
        || CHR (39);
  END IF;

  IF ls_Where IS NULL THEN
     ls_Where := ' AND 1 = 1';
  END IF;

  IF p_Search_Params.phone_number IS NOT NULL THEN
     ls_SQL :=
           'SELECT DISTINCT sav.account_number
             ,sav.legacy_account_number
             ,sav.brand
             ,sav.country
             ,sav.subdivision
             ,sav.postal_code
             ,sav.city
             ,sav.account_type
             ,sav.customer_type
             ,sav.name
             ,sav.name_in_english
             ,sav.name_legal
             ,sav.account_language
             ,sav.account_status
             ,sav.rank
             ,sav.daily_method_of_operation
             ,sav.contact_id
             ,sav.contact_type
             ,sav.contact_first_name
             ,sav.contact_middle_name
             ,sav.contact_last_name
             ,sav.contact_full_name_english
             ,sav.maternal_last_name
             ,sav.xx_lang_pref
             ,sav.primary_contact_email_address AS email_address
             ,sav.xx_auth
         FROM xbol_search_accounts_vw sav
            ,(SELECT account_number
                FROM xbol_account_phone_vw
               WHERE phone_number_raw LIKE '
        || CHR (39)
        || p_Search_Params.phone_number
        || '%'
        || CHR (39)
        || ') ap '
        || ' WHERE sav.account_number = ap.account_number
          AND sav.brand                 = '''
        || p_Brand
        || ''''
        || '  AND account_status <> ''Terminated'''
        || '  AND sav.save_address_flag     = ''Y'''
        || ls_where
        || ' AND ROWNUM <= 501';
  ELSIF p_Search_Params.email_address IS NOT NULL THEN
     ls_SQL :=
           'SELECT DISTINCT sav.account_number
             ,sav.legacy_account_number
             ,sav.brand
             ,sav.country
             ,sav.subdivision
             ,sav.postal_code
             ,sav.city
             ,sav.account_type
             ,sav.customer_type
             ,sav.name
             ,sav.name_in_english
             ,sav.name_legal
             ,sav.account_language
             ,sav.account_status
             ,sav.rank
             ,sav.daily_method_of_operation
             ,sav.contact_id
             ,sav.contact_type
             ,sav.contact_first_name
             ,sav.contact_middle_name
             ,sav.contact_last_name
             ,sav.contact_full_name_english
             ,sav.maternal_last_name
             ,sav.xx_lang_pref
             ,sav.primary_contact_email_address AS email_address
             ,sav.xx_auth
         FROM xbol_search_accounts_vw sav
            ,(SELECT account_number
                FROM xbol_account_email_vw
               WHERE email_address LIKE '
        || CHR (39)
        || LOWER (p_Search_Params.email_address)
        || '%'
        || CHR (39)
        || ') ap '
        || ' WHERE sav.account_number = ap.account_number
          AND sav.brand                 = '''
        || p_Brand
        || ''''
        || '  AND account_status <> ''Terminated'''
        || '  AND sav.save_address_flag     = ''Y'''
        || ls_where
        || ' AND ROWNUM <= 501';
  ELSE
     ls_SQL :=
           'SELECT DISTINCT account_number
             ,legacy_account_number
             ,brand
             ,country
             ,subdivision
             ,postal_code
             ,city
             ,account_type
             ,customer_type
             ,name
             ,name_in_english
             ,name_legal
             ,account_language
             ,account_status
             ,rank
             ,daily_method_of_operation
             ,contact_id
             ,contact_type
             ,contact_first_name
             ,contact_middle_name
             ,contact_last_name
             ,contact_full_name_english
             ,maternal_last_name
             ,xx_lang_pref
             ,primary_contact_email_address AS email_address
             ,xx_auth
         FROM xbol_search_accounts_vw
        WHERE brand                     = '''
        || p_Brand
        || ''''
        || ' AND account_status <> ''Terminated'''
        || ' AND save_address_flag         = ''Y'''
        || ls_where
        || ' AND ROWNUM <= 501';
  END IF;
  
  OPEN lc_acct_cursor FOR ls_SQL;

  LOOP     
      x_Search_Output.EXTEND;
      x_Search_Output(j) := xbol_rec_Search_Results();
     FETCH lc_acct_cursor
        INTO x_Search_Output (j).account_number,
             x_Search_Output (j).legacy_account_number,
             x_Search_Output (j).brand,
             x_Search_Output (j).country,
             x_Search_Output (j).Mailing_Subdivision,
             x_Search_Output (j).Mailing_PostalCode,
             x_Search_Output (j).city,
             x_Search_Output (j).account_type,
             x_Search_Output (j).customer_type,
             x_Search_Output (j).name,
             x_Search_Output (j).name_in_english,
             x_Search_Output (j).name_legal,
             x_Search_Output (j).account_language,
             x_Search_Output (j).account_status,
             x_Search_Output (j).rank,
             x_Search_Output (j).daily_method_oper,
             x_Search_Output (j).contact_id,
             x_Search_Output (j).contact_type,
             x_Search_Output (j).contact_first_name,
             x_Search_Output (j).contact_middle_name,
             x_Search_Output (j).contact_last_name,
             x_Search_Output (j).contact_full_name_english,
             x_Search_Output (j).contact_maternal_last_name,
             x_Search_Output (j).contact_language,
             x_Search_Output (j).contact_email_address,
             x_Search_Output (j).call_in_authentication;
     
     EXIT WHEN lc_acct_cursor%NOTFOUND;
     
     j := j + 1;

     IF j > 500 THEN
        x_errbuf := 'More than 500 records found, aborted with 500 records.';
        EXIT;
     END IF;
  END LOOP;
     
  CLOSE lc_acct_cursor;

  IF j = 0 THEN
     x_retcode := TRUE;
     x_errbuf  := 'No Account or Contact data found.';
  END IF;
EXCEPTION
  WHEN OTHERS THEN
     IF lc_acct_cursor%ISOPEN THEN
        CLOSE lc_acct_cursor;
     END IF;

     x_retcode := FALSE;
     x_errbuf  := 'Unknown error occurred searching for accounts/contacts, error:' || SUBSTR (SQLERRM, 1, 3000);
END XBOL_Search_Account_Contact;
/