package com.work.junitservicetestpoc;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

import org.codehaus.jackson.map.ObjectMapper;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class NatrSearchAccountContactsTest extends ServicesTestCommon {

	@Before
	public void setUp() throws Exception {
		objectName = getClass().getName();
		url = new URL(URL_BASE + "/webservices/rest/account/natrsearchaccountcontacts/");
		userPass = AUTH_USER + ":" + AUTH_PASSWORD;
		encoding = Base64.getEncoder().encodeToString(userPass.getBytes());
		connection = (HttpURLConnection) url.openConnection();
		connection.setDoOutput(true);
		connection.setRequestMethod("POST");
		connection.setRequestProperty("Authorization", "Basic " + encoding);
		connection.setRequestProperty("Content-Type", "application/json");
		objectMapper = new ObjectMapper();
	}

	@After
	public void tearDown() throws Exception {
		connection.disconnect();
	}
	
	@Test
	public void test() throws Exception {
		objectName = objectName.replaceAll(".*\\.", "");
		setPayload(objectName.replaceFirst("Test", "") + "Payload.json");

		outputStream = connection.getOutputStream();
		outputStream.write(payload.getBytes());
		outputStream.flush();

		inputStreamReader = new InputStreamReader(connection.getInputStream());
		bufferedReader = new BufferedReader(inputStreamReader);
        
		assertEquals(connection.getResponseCode(), 200);

		response = new JsonResponse(responseToString(bufferedReader));        
                
		assertTrue(response.getSucceeded());
		assertFalse(response.getIsDataNull());
        
		if (!response.getSucceeded() && response.isMessages()) {
			System.out.println(this.getClass().getSimpleName() + ":");
			System.out.println(response.messagesToString());
		}
	}
	
}