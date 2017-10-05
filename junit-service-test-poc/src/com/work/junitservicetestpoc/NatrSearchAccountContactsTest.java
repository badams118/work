package com.work.junitservicetestpoc;

import static org.junit.Assert.*;

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
	public void test() {
		fail("Not yet implemented");
	}

}
