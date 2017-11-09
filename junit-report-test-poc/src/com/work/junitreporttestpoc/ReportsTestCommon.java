package com.work.junitreporttestpoc;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.HierarchicalConfiguration;
import org.apache.commons.configuration.XMLConfiguration;

public abstract class ReportsTestCommon {	
	public static final String DBMS_URL;
	public static final String DBMS_USER; 
	public static final String DBMS_PASSWORD; 
	public static final String CONTEXT_USER;
	public static final int MAX_CONCURRENT_WAIT_SECONDS =10;// 5 * 60;
	
	static {
		String url;
		String user;
		String password;
		String contextUser;

		try {
			XMLConfiguration config = new XMLConfiguration("config.xml");

			HierarchicalConfiguration sub = config.configurationAt("environment(0)");
	    	
			url = sub.getString("url");
			user = sub.getString("user");
			password = sub.getString("password");
			contextUser = sub.getString("context-user");
		} catch (ConfigurationException ce) {
			url = "";
			user = "";
			password = "";
			contextUser = "";
			ce.printStackTrace();
		}
		
			DBMS_URL = url;
			DBMS_USER = user;
			DBMS_PASSWORD = password;
			CONTEXT_USER = contextUser;
	}
}
