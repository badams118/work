package com.work.junitreporttestpoc;

import static org.junit.Assert.*;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.concurrent.TimeUnit;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class SalesOrderAcknowledgementTest extends ReportsTestCommon {

	private Connection connection = null;
	
	@Before
	public void setUp() {
		EbsConnection ebsConnection = new EbsConnection("Order Management Super User", "210 - NSP US Sales");		
		connection = ebsConnection.getConnection();
		
	}

	@After
	public void tearDown() throws Exception {
		if (connection != null) {
			connection.close();
		}
	}

	@Test
	public void testResponseSuccess() throws SQLException {
		int requestId;
		int waitSeconds = 10;
		int totalWaitSeconds = 0;
		CallableStatement submitRequest = null;
		CallableStatement getRequestStatus = null;

		try {
			submitRequest = connection.prepareCall(
					"{? = call fnd_request.submit_request('ONT', 'OEXOEACK', NULL, NULL, FALSE,"
					+ "'2021', 'MSTK', 'D', '','','','','','','','','','','','','','','','',"
					+ "'SALES', 'ALL', '','', 'Y', '','', 'N', 'N', 'N')}");
			submitRequest.registerOutParameter(1, java.sql.Types.NUMERIC);
			submitRequest.execute();
			assertFalse("Concurrent request submission failed.", submitRequest.getInt(1) == 0);
		} catch (SQLException e) {
			fail("SQL exception: " + e.getMessage());
		}
				
		try {
			requestId = Integer.parseInt(submitRequest.getString(1));
			getRequestStatus = connection.prepareCall(
					"{call xbol_fnd_utilities_pk.get_request_status(?, ?, ?, ?)}");
			getRequestStatus.setInt(1, requestId);
			getRequestStatus.registerOutParameter(2, java.sql.Types.VARCHAR);
			getRequestStatus.registerOutParameter(3, java.sql.Types.VARCHAR);
			getRequestStatus.registerOutParameter(4, java.sql.Types.VARCHAR);
			getRequestStatus.execute();
						
			while (!getRequestStatus.getString(2).trim().equals("Completed")) {
				TimeUnit.SECONDS.sleep(waitSeconds);
				totalWaitSeconds += waitSeconds;				
				assertTrue("Concurrent process took longer than " + MAX_CONCURRENT_WAIT_SECONDS + " seconds.",
						totalWaitSeconds <= MAX_CONCURRENT_WAIT_SECONDS);				
				getRequestStatus.execute();
			}
			
			assertTrue("Concurrent request terminated with status: " 
					+ getRequestStatus.getString(3)	+ ": " + getRequestStatus.getString(4), 
					getRequestStatus.getString(3).trim().equals("Normal"));
		} catch (NumberFormatException ne) {
			fail("Number format exception: " + ne.getMessage());
		} catch (InterruptedException ie) {
			fail("Interrupted exception: " + ie.getMessage());
		} catch (SQLException se) {
			fail("SQL exception: " + se.getMessage());
		}
		
		submitRequest.close();
		getRequestStatus.close();		
	}	

	@Test
	public void testResponseFailure() throws SQLException {
		CallableStatement submitRequest = null;
		
		try {
			submitRequest = connection.prepareCall(
					"{? = call fnd_request.submit_request()}");
			submitRequest.registerOutParameter(1, java.sql.Types.NUMERIC);
			submitRequest.execute();
			assertTrue("Concurrent request submission failed.", submitRequest.getInt(1) == 0);
		} catch (SQLException e) {
			fail("SQL exception: " + e.getMessage());
		}
				
		submitRequest.close();		
	}
}