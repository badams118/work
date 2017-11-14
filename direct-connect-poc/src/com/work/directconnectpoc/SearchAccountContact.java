package com.work.directconnectpoc;

import java.sql.Array;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Struct;
import java.sql.Types;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.HierarchicalConfiguration;
import org.apache.commons.configuration.XMLConfiguration;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleConnection;
import oracle.jdbc.OracleTypes;

public class SearchAccountContact {

	public static void main(String[] args) {	
		try {
			OracleConnection connection = getOracleConnection().unwrap(OracleConnection.class);
			
			System.out.println("Got Connection.");
			
	    	Object[] searchParameters = new Object[] {1, null, null, null, null, "IVY", 
	    												null, null, null, null, null, null};	
	    	Struct structParameters = connection.createStruct("XBOL_REC_SEARCH_PARAMETERS", searchParameters);
			
			OracleCallableStatement statement = (OracleCallableStatement)connection.prepareCall(
					"declare x boolean; " +
					"begin " +
					"  XBOL_Search_Account_Contact(?, x, ?, ?, ?, ?, ?, ?, ?); " +
					"end;");

	    	statement.registerOutParameter(1, Types.VARCHAR);
	    	statement.registerOutParameter(2, OracleTypes.ARRAY, "XBOL_TAB_SEARCH_RESULTS");
	    	statement.setString(3, "NSP");
	    	statement.setString(4, "US");
	    	statement.setString(5, "en");
	    	statement.setString(6, "badams");
	    	statement.setString(7, "C3");
	    	statement.setObject(8, structParameters);	    	
	    	
	    	statement.execute();
	
	    	System.out.println("Statement executed.");

	    	Object[] data = (Object[]) ((Array) statement.getObject(2)).getArray();
	    	
	    	for (Object rec : data) {
	    		Struct record = (Struct) rec;
		    	System.out.println(getPipeDelimitedString(record));
	    	}
	    	
	    	statement.close();
	    	connection.close();
	    } catch (SQLException se) {
			System.out.println("SQL exception: " + se.getMessage());
	    } catch (Exception e) {
			System.out.println(e.getMessage());
	    } 
	}

	private static Connection getOracleConnection() throws Exception {
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
	
	    Class.forName(driver); 
	
	    Connection connection = DriverManager.getConnection(url, user, password);
	
	    return connection;
	}
	
	private static String getPipeDelimitedString(Struct record) throws SQLException {
		String pipeString;
		
		pipeString = record.getAttributes()[0]  + "|" + 
				   	 record.getAttributes()[1]  + "|" + 
				   	 record.getAttributes()[2]  + "|" + 
				   	 record.getAttributes()[3]  + "|" + 
					 record.getAttributes()[4]  + "|" + 
					 record.getAttributes()[5]  + "|" + 
					 record.getAttributes()[6]  + "|" + 
					 record.getAttributes()[7]  + "|" + 
					 record.getAttributes()[8]  + "|" + 
					 record.getAttributes()[9]  + "|" + 
					 record.getAttributes()[10] + "|" + 
					 record.getAttributes()[11] + "|" + 
					 record.getAttributes()[12] + "|" + 
					 record.getAttributes()[13] + "|" + 
					 record.getAttributes()[14] + "|" + 
					 record.getAttributes()[15] + "|" + 
					 record.getAttributes()[16] + "|" + 
					 record.getAttributes()[17] + "|" + 
					 record.getAttributes()[18] + "|" + 
					 record.getAttributes()[19] + "|" + 
					 record.getAttributes()[20] + "|" + 
					 record.getAttributes()[21] + "|" + 
					 record.getAttributes()[22] + "|" + 
					 record.getAttributes()[23] + "|" + 
					 record.getAttributes()[24] + "|" + 
					 record.getAttributes()[25];
		
		return pipeString;
	}
}