package com.work.junitreporttestpoc;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class EbsConnection extends ReportsTestCommon {
	private Connection connection = null;
	private CallableStatement appsInitialize = null;
	private CallableStatement setOrgContext = null;
		
	public EbsConnection(String responsibility) {
		this(responsibility, null);
	}

	public EbsConnection(String responsibility, String organization) {
		try { 
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
		} catch (ClassNotFoundException cnfe) { 
			System.out.println("Class not found: " + cnfe.getMessage());
		} 
			
		try {
			connection = DriverManager.getConnection(
					DBMS_URL, DBMS_USER, DBMS_PASSWORD); 
			appsInitialize = connection.prepareCall("{call xbol_fnd_utilities_pk.apps_initialize(?, ?)}");
			appsInitialize.setString(1, CONTEXT_USER);
			appsInitialize.setString(2, responsibility);
			appsInitialize.execute();
			appsInitialize.close();
			
			if (organization != null) {
				setOrgContext = connection.prepareCall("{call xbol_fnd_utilities_pk.set_org_context(?)");
				setOrgContext.setString(1, organization);
				setOrgContext.execute();
				setOrgContext.close();
			}
		} catch (SQLException se) {
			System.out.println("SQL exception: " + se.getMessage());
		}
	}
	
	public Connection getConnection() {
		return connection;
	}
}