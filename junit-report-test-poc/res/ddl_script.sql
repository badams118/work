CREATE OR REPLACE PACKAGE XBOL_FND_UTILITIES_PK AUTHID CURRENT_USER AS

  PROCEDURE apps_initialize(p_user_name VARCHAR2, p_responsibility_name VARCHAR2);
  
  PROCEDURE apps_initialize(p_user_name VARCHAR2);
					  
  PROCEDURE apps_initialize (p_User_Id       IN NUMBER
                            ,p_Resp_Id       IN NUMBER
	  					              ,p_Resp_Appl_Id  IN NUMBER
						                ,p_Sec_Group_Id  IN NUMBER
						                ,p_Server_Id     IN NUMBER DEFAULT -1);

  PROCEDURE set_org_context(p_org_name IN VARCHAR2);
  
  PROCEDURE get_request_status( p_request_id IN  NUMBER
                               ,p_phase      OUT VARCHAR2
                               ,p_status     OUT VARCHAR2
                               ,p_message    OUT VARCHAR2);
                               
  PROCEDURE wait_for_request( p_request_id IN  NUMBER
                             ,p_interval   IN  NUMBER
                             ,p_max_wait   IN  NUMBER
                             ,p_phase      OUT VARCHAR2
                             ,p_status     OUT VARCHAR2
                             ,p_message    OUT VARCHAR2);

END XBOL_FND_UTILITIES_PK;
/

CREATE OR REPLACE PACKAGE BODY XBOL_FND_UTILITIES_PK AS
    
  PROCEDURE apps_initialize( p_user_name IN VARCHAR2) IS
  BEGIN
    apps_initialize(p_user_name, 'Global Order Management 2');
  END apps_initialize;

  PROCEDURE apps_initialize( p_user_name           IN VARCHAR2
                            ,p_responsibility_name IN VARCHAR2) IS
    v_user_id           NUMBER;
    v_responsibility_id NUMBER;
    v_application_id    NUMBER;
    
    CURSOR c_user IS
      SELECT user_id
      FROM   fnd_user
      WHERE  user_name = UPPER(p_user_name);
      
    CURSOR c_responsibility IS
      SELECT application_id
            ,responsibility_id
      FROM   fnd_responsibility_vl
      WHERE  responsibility_name = p_responsibility_name;
  BEGIN
    IF c_user%ISOPEN THEN
      CLOSE c_user;
    END IF;
    
    OPEN  c_user;
    FETCH c_user INTO v_user_id;
    CLOSE c_user;
    
    IF c_responsibility%ISOPEN THEN
      CLOSE c_responsibility;
    END IF;
    
    OPEN  c_responsibility;
    FETCH c_responsibility INTO v_application_id, v_responsibility_id;
    CLOSE c_responsibility;
    
    fnd_global.apps_initialize( v_user_id
                               ,v_responsibility_id
                               ,v_application_id);
  END apps_initialize;
            
  PROCEDURE apps_initialize ( p_User_Id       IN NUMBER
                             ,p_Resp_Id       IN NUMBER
                             ,p_Resp_Appl_Id  IN NUMBER
                             ,p_Sec_Group_Id  IN NUMBER
                             ,p_Server_Id     IN NUMBER DEFAULT -1) AS
  BEGIN
    FND_GLOBAL.apps_initialize( p_user_id
                               ,p_Resp_Id
                               ,p_Resp_Appl_Id
                               ,p_Sec_Group_Id
                               ,p_Server_Id);
  END apps_initialize;
  
  PROCEDURE set_org_context(p_org_name IN VARCHAR2) IS
    CURSOR c_org_id IS
      SELECT organization_id
      FROM   hr_operating_units
      WHERE  name = p_org_name;
      
    v_org_id NUMBER;
  BEGIN
    IF c_org_id%ISOPEN THEN
      CLOSE c_org_id;
    END IF;
    
    OPEN  c_org_id;
    FETCH c_org_id INTO v_org_id;
    CLOSE c_org_id;
    
    fnd_client_info.set_org_context(v_org_id);
    fnd_request.set_org_id(v_org_id);
    fnd_profile.put('ORG_ID', v_org_id);    
  END set_org_context;
  
  PROCEDURE get_request_status( p_request_id IN  NUMBER
                               ,p_phase      OUT VARCHAR2
                               ,p_status     OUT VARCHAR2
                               ,p_message    OUT VARCHAR2) IS
    v_result     BOOLEAN;
    v_request_id NUMBER := p_request_id;
    v_dev_phase  VARCHAR2(80);
    v_dev_status VARCHAR2(80);
  BEGIN
    v_result := fnd_concurrent.get_request_status( v_request_id
                                                  ,NULL
                                                  ,NULL
                                                  ,p_phase
                                                  ,p_status
                                                  ,v_dev_phase
                                                  ,v_dev_status
                                                  ,p_message);    
  END get_request_status;
  
  PROCEDURE wait_for_request( p_request_id IN  NUMBER
                             ,p_interval   IN  NUMBER
                             ,p_max_wait   IN  NUMBER
                             ,p_phase      OUT VARCHAR2
                             ,p_status     OUT VARCHAR2
                             ,p_message    OUT VARCHAR2) IS
    v_result     BOOLEAN;
    v_request_id NUMBER := p_request_id;
    v_dev_phase  VARCHAR2(80);
    v_dev_status VARCHAR2(80);
  BEGIN
    v_result := fnd_concurrent.wait_for_request( v_request_id
                                                ,p_interval
                                                ,p_max_wait
                                                ,p_phase
                                                ,p_status
                                                ,v_dev_phase
                                                ,v_dev_status
                                                ,p_message);
  END wait_for_request;
    
  FUNCTION isnull(p_exp IN NUMBER) RETURN BOOLEAN IS
    l_return BOOLEAN;
  BEGIN
    IF p_exp IS NULL THEN
      l_return := TRUE;
    ELSE
      l_return := FALSE;
    END IF;
  
    RETURN l_return;
  END isnull;
  
END XBOL_FND_UTILITIES_PK;
/