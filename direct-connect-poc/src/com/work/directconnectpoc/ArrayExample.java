package com.work.directconnectpoc;

import java.sql.Array;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Struct;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.HierarchicalConfiguration;
import org.apache.commons.configuration.XMLConfiguration;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleTypes;

public class ArrayExample {

	public static void main(String[] args) {	
		try {
			OracleConnection connection = getOracleConnection().unwrap(OracleConnection.class);
			
			System.out.println("Got Connection.");
			
			OracleCallableStatement statement = (OracleCallableStatement)connection.prepareCall("{call add_projects(?, ?)}");
	
	    	// create array holding values for the project object's properties
	    	Object[] project1 = new Object[] {"1", "Title 1"};
	    	Object[] project2 = new Object[] {"2", "Title 2"};
	
	    	// each struct is one project_type object
	    	Struct structProject1 = connection.createStruct("PROJECT_TYPE", project1);
	    	Struct structProject2 = connection.createStruct("PROJECT_TYPE", project2);
	
	    	Struct[] structArrayOfProjects = {structProject1, structProject2};
	
	    	// Array holding project_type objects
	    	Array arrayOfProjects = connection.createOracleArray("MY_ARRAY", structArrayOfProjects);	
	    	statement.setArray(1, arrayOfProjects);
	    	
	    	// the return table of project_type objects is also an Array
	    	statement.registerOutParameter(2, OracleTypes.ARRAY, "MY_ARRAY");
	    	statement.execute();
	
	    	System.out.println("Statement executed.");
	    	
	    	Object[] data = (Object[]) ((Array) statement.getObject(2)).getArray();
	    	
	    	// print out each attribute of the Object array of Structs
	    	for (Object project : data) {
	    		Struct record = (Struct) project;
		    	System.out.println(record.getAttributes()[0] + " " + record.getAttributes()[1]);
	    	}
	    	
	    	statement.close();
	    	connection.close();
	    } catch (SQLException se) {
			System.out.println("SQL exception: " + se.getMessage());
	    } catch (Exception e) {
			System.out.println(e.getMessage());
	    } 
	}

	public static Connection getOracleConnection() throws Exception {
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url;
		String user;
		String password;

		try {
			XMLConfiguration config = new XMLConfiguration("config.xml");

			HierarchicalConfiguration sub = config.configurationAt("environment(0)");
	    	
			url = sub.getString("url");
			user = sub.getString("user");
			password = sub.getString("password");
		} catch (ConfigurationException ce) {
			url = "";
			user = "";
			password = "";
			ce.printStackTrace();
		}
			
	    Class.forName(driver); // load Oracle driver
	
	    Connection connection = DriverManager.getConnection(url, user, password);
	
	    return connection;
	}
}