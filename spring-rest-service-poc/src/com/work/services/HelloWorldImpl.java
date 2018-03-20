package com.nsp.services;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service("helloWorldService")
@Transactional(propagation=Propagation.REQUIRED)

public class HelloWorldImpl implements HelloWorldService {	

	@Autowired
	private DataSource dataSource;
	
	@Override
	public List<String> helloWorld(String request) {
		List<String> response = new ArrayList<String>();
		Connection connection = null;
		CallableStatement statement = null;

		try {		
			connection = dataSource.getConnection();
			  	
			statement = connection.prepareCall(
						" { call xbol_test.hello_world(?, ?) } " );
		    	
			statement.setString(1, request);
	    	statement.registerOutParameter(2, Types.VARCHAR);
		    	
			statement.execute();			

			response.add(request);
			response.add((String) statement.getObject(2));
			response.add("Hello World 2");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (statement != null) {
					statement.close();
				}
				if (connection != null) {
					connection.close();
				}
			} catch (SQLException se) {
				se.printStackTrace();
			}
		}			 
		
		return response;
	}
}
