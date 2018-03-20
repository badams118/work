CREATE OR REPLACE TYPE xbol_message AS OBJECT ( 
  Details         VARCHAR2(2000),
  Code            VARCHAR2(30),
  ReferenceNumber VARCHAR2(30),
  MessageType     VARCHAR2(30),
  CreatedDate     DATE,
  CONSTRUCTOR FUNCTION xbol_message RETURN SELF AS RESULT);
/
             
--DROP TYPE BODY xbol_message;

CREATE OR REPLACE TYPE BODY xbol_message AS
  CONSTRUCTOR FUNCTION xbol_message RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

--DROP TYPE xbol_messagestype;
                                   
CREATE OR REPLACE TYPE xbol_messagestype IS TABLE OF xbol_message;
/

CREATE OR REPLACE TYPE xbol_rec_resp_get_cc_type AS OBJECT (
  Succeeded  NUMBER,
  IsDataNull NUMBER,
  Data       VARCHAR2(4000), -- xbol_ar_account_iface_pk.credit_card_tbl_type
  Messages   xbol_message,
  CONSTRUCTOR FUNCTION xbol_rec_resp_get_cc_type RETURN SELF AS RESULT);
/
             
--DROP TYPE BODY xbol_rec_resp_get_cc_type;

CREATE OR REPLACE TYPE BODY xbol_rec_resp_get_cc_type AS
  CONSTRUCTOR FUNCTION xbol_rec_resp_get_cc_type RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

CREATE OR REPLACE TYPE xbol_AddressType AS OBJECT     
  (  ID                       NUMBER
    ,Description              VARCHAR2(240)--hz_party_sites.party_site_name%TYPE
    ,AddressType              VARCHAR2(30)--hz_cust_site_uses_all.site_use_code%TYPE
    ,Name                     VARCHAR2(360)--hz_party_sites.addressee%TYPE
    ,Line1                    VARCHAR2(240)--hz_locations.address1%TYPE
    ,Line2                    VARCHAR2(240)--hz_locations.address2%TYPE
    ,Line3                    VARCHAR2(240)--hz_locations.address3%TYPE
    ,Line4                    VARCHAR2(240)--hz_locations.address4%TYPE
    ,City                     VARCHAR2(60)--hz_locations.city%TYPE
    ,County                   VARCHAR2(30)
    ,Subdivision              VARCHAR2(60)--hz_locations.province%TYPE
    ,PostalCode               VARCHAR2(60)--hz_locations.postal_code%TYPE
    ,Country                  VARCHAR2(60)--hz_locations.country%TYPE
    ,PhoneNumber              VARCHAR2(30)
    ,EmailAddress             VARCHAR2(100)
    ,ShowPricesOnInvoice      NUMBER
    ,ISSIGNATUREREQUIRED      NUMBER
    ,AllowSurePost            NUMBER
    ,DefaultShippingMethodID  VARCHAR2(30)--hz_cust_site_uses_all.ship_via%TYPE
    ,DefaultWarehouse         VARCHAR2(100)
    ,SaveAddressToAddressBook NUMBER
    ,PrimaryFlag              VARCHAR2(1)
    ,CONSTRUCTOR FUNCTION xbol_AddressType RETURN SELF AS RESULT);
/
             
--DROP TYPE BODY xbol_AddressType;

CREATE OR REPLACE TYPE BODY xbol_AddressType AS
  CONSTRUCTOR FUNCTION xbol_AddressType RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

CREATE OR REPLACE TYPE xbol_CreditCard AS OBJECT     
  ( ID                     NUMBER(15)--hz_cust_accounts.cust_account_id%TYPE
  , intsrid                NUMBER(15)--iby_creditcard.instrid%TYPE
  , CreditCardType         VARCHAR2(30)--iby_creditcard.card_issuer_code%TYPE -- 'Undefined','AmericanExpress','Visa','MasterCard','Discover','JCB'
  , CustomersDescription   VARCHAR2(240)--iby_creditcard.description%TYPE
  , NameOnCard             VARCHAR2(80)--iby_creditcard.chname%TYPE
  , CreditCardNumber       VARCHAR2(200) -- iby_creditcard.ccnumber%TYPE
  , Cvv                    VARCHAR2(10) -- not stored
  , MaskedCreditCardNumber VARCHAR2(30)--iby_creditcard.masked_cc_number%TYPE
  , ExpirationDate         DATE--iby_creditcard.expirydate%TYPE
  , Address                xbol_AddressType
  , PriorityIndex          NUMBER(15)--iby_creditcard.cc_num_sec_segment_id%TYPE
  , SaveToSavedCreditCards NUMBER
  , CONSTRUCTOR FUNCTION xbol_CreditCard RETURN SELF AS RESULT);
/
             
--DROP TYPE BODY xbol_CreditCard;

CREATE OR REPLACE TYPE BODY xbol_CreditCard AS
  CONSTRUCTOR FUNCTION xbol_CreditCard RETURN SELF AS RESULT AS
  BEGIN
    RETURN;
  END;
END;
/

--DROP TYPE xbol_tab_credit_card;
                                   
CREATE TYPE xbol_tab_credit_card IS TABLE OF xbol_CreditCard;
/

CREATE OR REPLACE PACKAGE apps.xbol_test IS
  PROCEDURE hello_world (p_foo IN VARCHAR2, p_bar OUT VARCHAR2);
  PROCEDURE GetCreditCardType (
    p_brand         IN  VARCHAR2,
    p_country       IN  VARCHAR2,
    p_language      IN  VARCHAR2,
    p_agent         IN  VARCHAR2,
    p_clientSystem  IN  VARCHAR2,
    p_accountNumber IN  VARCHAR2, 
    p_custAccountID IN  NUMBER,
    p_succeeded     OUT NUMBER,
    p_isDataNull    OUT NUMBER,
    p_data          OUT VARCHAR2,
    p_messages      OUT xbol_messagestype
  );
  PROCEDURE GetCreditCard (
    p_brand         IN  VARCHAR2,
    p_country       IN  VARCHAR2,
    p_language      IN  VARCHAR2,
    p_agent         IN  VARCHAR2,
    p_clientSystem  IN  VARCHAR2,
    p_accountNumber IN  VARCHAR2, 
    p_custAccountID IN  NUMBER,
    p_cardType      IN  VARCHAR2,
    p_succeeded     OUT NUMBER,
    p_isDataNull    OUT NUMBER,
    p_data          OUT xbol_tab_credit_card,
    p_messages      OUT xbol_messagestype
  );
END xbol_test;
/

CREATE OR REPLACE PACKAGE BODY apps.xbol_test AS
  FUNCTION boolean_to_number(p_boolean IN BOOLEAN) RETURN NUMBER IS
    l_number NUMBER;
  BEGIN
    IF p_boolean THEN
      l_number := 1;
    ELSE l_number := 0;
    END IF;
    
    RETURN l_number;
  END;

  PROCEDURE hello_world (p_foo IN VARCHAR2, p_bar OUT VARCHAR2) IS
  BEGIN
    p_bar := 'Hello World!';
  END hello_world;

  PROCEDURE GetCreditCardType (
    p_brand         IN  VARCHAR2,
    p_country       IN  VARCHAR2,
    p_language      IN  VARCHAR2,
    p_agent         IN  VARCHAR2,
    p_clientSystem  IN  VARCHAR2,
    p_accountNumber IN  VARCHAR2, 
    p_custAccountID IN  NUMBER,
    p_succeeded     OUT NUMBER,
    p_isDataNull    OUT NUMBER,
    p_data          OUT VARCHAR2,
    p_messages      OUT xbol_messagestype
  ) IS
    l_response        XBOL_AR_ACCOUNT_IFACE_GET_ISG.rec_resp_get_cred_card_type;
    l_base_parameters XBOL_ISG_ACCOUNT_TYPES_PKG.accountBaseType;
  BEGIN
    p_messages := xbol_messagestype();
  
    l_base_parameters.brand        := p_brand;        --'NSP';      --baseparameters.brand;
    l_base_parameters.country      := p_country;      --'US';       --baseparameters.country;
    l_base_parameters.language     := p_language;     --'en';       --baseparameters.language;
    l_base_parameters.agent        := p_agent;        --'NATRINTF'; --baseparameters.agent;
    l_base_parameters.clientSystem := p_clientSystem; --'C3';       --baseparameters.clientSystem;
  
    xbol_ar_account_iface_get_isg.GetCreditCardType(
      l_response, l_base_parameters, p_AccountNumber, p_CustAccountID);
      
    p_succeeded  := boolean_to_number(l_response.succeeded);
    p_isDataNull := boolean_to_number(l_response.isDataNull);
    
    IF l_response.messages.COUNT > 0 THEN
      FOR j IN 1..l_response.messages.LAST LOOP
        p_messages.EXTEND;
        p_messages(j) := xbol_message();
        p_messages(j).details         := l_response.messages(j).details; 
        p_messages(j).code            := l_response.messages(j).code;    
        p_messages(j).referenceNumber := l_response.messages(j).referenceNumber;
        p_messages(j).messageType     := l_response.messages(j).messageType;
        p_messages(j).createdDate     := l_response.messages(j).createdDate; 
      END LOOP;
    ELSE --test message
      p_messages.EXTEND;
      p_messages(1) := xbol_message();
      p_messages(1).details := 'No messages';
      p_messages(1).createdDate := Sysdate;
    END IF;
    
    p_data := l_response.data;
  END GetCreditCardType;
  
  PROCEDURE GetCreditCard (
    p_brand         IN  VARCHAR2,
    p_country       IN  VARCHAR2,
    p_language      IN  VARCHAR2,
    p_agent         IN  VARCHAR2,
    p_clientSystem  IN  VARCHAR2,
    p_accountNumber IN  VARCHAR2, 
    p_custAccountID IN  NUMBER,
    p_cardType      IN  VARCHAR2,
    p_succeeded     OUT NUMBER,
    p_isDataNull    OUT NUMBER,
    p_data          OUT xbol_tab_credit_card,
    p_messages      OUT xbol_messagestype
  ) IS
    l_response        XBOL_AR_ACCOUNT_IFACE_GET_ISG.rec_resp_get_credit_card;
    l_base_parameters XBOL_ISG_ACCOUNT_TYPES_PKG.accountBaseType;
  BEGIN
    p_data     := xbol_tab_credit_card();
    p_messages := xbol_messagestype();
  
    l_base_parameters.brand        := p_brand;        --'NSP';      --baseparameters.brand;
    l_base_parameters.country      := p_country;      --'US';       --baseparameters.country;
    l_base_parameters.language     := p_language;     --'en';       --baseparameters.language;
    l_base_parameters.agent        := p_agent;        --'NATRINTF'; --baseparameters.agent;
    l_base_parameters.clientSystem := p_clientSystem; --'C3';       --baseparameters.clientSystem;
  
    xbol_ar_account_iface_get_isg.GetCreditCard(
      l_response, l_base_parameters, p_accountNumber, p_custAccountID, p_cardType);
      
    p_succeeded  := boolean_to_number(l_response.succeeded);
    p_isDataNull := boolean_to_number(l_response.isDataNull);
    
    IF l_response.data.COUNT > 0 THEN
      FOR i IN 1..l_response.data.LAST LOOP
        p_data.EXTEND;
        p_data(i)                                  := xbol_CreditCard();
        p_data(i).id                               := l_response.data(i).id;
        p_data(i).intsrID                          := l_response.data(i).intsrID;
        p_data(i).creditCardType                   := l_response.data(i).creditCardType;
        p_data(i).customersDescription             := l_response.data(i).customersDescription;
        p_data(i).nameOnCard                       := l_response.data(i).nameOnCard;
        p_data(i).creditCardNumber                 := l_response.data(i).creditCardNumber;
        p_data(i).cvv                              := l_response.data(i).cvv;
        p_data(i).maskedCreditCardNumber           := l_response.data(i).maskedCreditCardNumber;
        p_data(i).expirationDate                   := l_response.data(i).expirationDate;
        p_data(i).priorityIndex                    := l_response.data(i).priorityIndex;
        p_data(i).saveToSavedCreditCards           := boolean_to_number(l_response.data(i).saveToSavedCreditCards);    
        p_data(i).address                          := xbol_AddressType();
        p_data(i).address.id                       := l_response.data(i).address.id;
        p_data(i).address.Description              := l_response.data(i).address.Description;
        p_data(i).address.AddressType              := l_response.data(i).address.AddressType;
        p_data(i).address.Name                     := l_response.data(i).address.Name;
        p_data(i).address.Line1                    := l_response.data(i).address.Line1;
        p_data(i).address.Line2                    := l_response.data(i).address.Line2;
        p_data(i).address.Line3                    := l_response.data(i).address.Line3;
        p_data(i).address.Line4                    := l_response.data(i).address.Line4;
        p_data(i).address.City                     := l_response.data(i).address.City;
        p_data(i).address.County                   := l_response.data(i).address.County;
        p_data(i).address.Subdivision              := l_response.data(i).address.Subdivision;
        p_data(i).address.PostalCode               := l_response.data(i).address.PostalCode;
        p_data(i).address.Country                  := l_response.data(i).address.Country;
        p_data(i).address.PhoneNumber              := l_response.data(i).address.PhoneNumber;
        p_data(i).address.EmailAddress             := l_response.data(i).address.EmailAddress;
        p_data(i).address.ShowPricesOnInvoice      := boolean_to_number(l_response.data(i).address.ShowPricesOnInvoice);
        p_data(i).address.IsSignatureRequired      := boolean_to_number(l_response.data(i).address.IsSignatureRequired);
        p_data(i).address.AllowSurePost            := boolean_to_number(l_response.data(i).address.AllowSurePost);
        p_data(i).address.DefaultShippingMethodID  := l_response.data(i).address.DefaultShippingMethodID;
        p_data(i).address.DefaultWarehouse         := l_response.data(i).address.DefaultWarehouse;
        p_data(i).address.SaveAddressToAddressBook := boolean_to_number(l_response.data(i).address.SaveAddressToAddressBook);
        p_data(i).address.PrimaryFlag              := l_response.data(i).address.PrimaryFlag;
      END LOOP;
    END IF;
    
    IF l_response.messages.COUNT > 0 THEN
      FOR j IN 1..l_response.messages.LAST LOOP
        p_messages.EXTEND;
        p_messages(j) := xbol_message();
        p_messages(j).details         := l_response.messages(j).details; 
        p_messages(j).code            := l_response.messages(j).code;    
        p_messages(j).referenceNumber := l_response.messages(j).referenceNumber;
        p_messages(j).messageType     := l_response.messages(j).messageType;
        p_messages(j).createdDate     := l_response.messages(j).createdDate; 
      END LOOP;
    ELSE --test message
      p_messages.EXTEND;
      p_messages(1) := xbol_message();
      p_messages(1).details := 'No messages';
      p_messages(1).createdDate := Sysdate;
    END IF;
  END GetCreditCard;
END xbol_test;
/