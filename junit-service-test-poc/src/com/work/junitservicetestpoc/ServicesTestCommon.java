package com.work.junitservicetestpoc;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.HierarchicalConfiguration;
import org.apache.commons.configuration.XMLConfiguration;
import org.codehaus.jackson.map.ObjectMapper;

public abstract class ServicesTestCommon {
	public static final String URL_BASE;
	public static final String AUTH_USER; 
	public static final String AUTH_PASSWORD;
	public static final String RESPONSIBILITY;
    	
	static {
	    String urlBase;
	    String authUser;
	    String authPassword;
	    String responsibility;

		try {
	    	XMLConfiguration config = new XMLConfiguration("config.xml");

	    	HierarchicalConfiguration sub = config.configurationAt("environment(0)");
	    	
	    	urlBase = sub.getString("url-base");
	    	authUser = sub.getString("auth-user");
	    	authPassword = sub.getString("auth-password");
	    	responsibility = sub.getString("responsibility");
	    }
	    catch (ConfigurationException ce) {
			urlBase = "";
			authUser = "";
			authPassword = "";
			responsibility = "";
			ce.printStackTrace();
		}
		
		URL_BASE = urlBase;
		AUTH_USER = authUser;
		AUTH_PASSWORD = authPassword;
		RESPONSIBILITY = responsibility;
	}
	
	protected URL url;
	protected HttpURLConnection connection;
	protected InputStreamReader inputStreamReader;
	protected BufferedReader bufferedReader;
	protected OutputStream outputStream;
	protected ObjectMapper objectMapper;
	protected JsonResponse response;
	protected String userPass, encoding, payload, parsedResponse, objectName;
		
	protected String responseToString(BufferedReader bufferedReader) throws IOException {
		String responseLine, responseString;
	    
		responseString = "";
		
		while ((responseLine = bufferedReader.readLine()) != null) {
			responseString += responseLine + "\n";
		}
        
		return responseString;
	}
	
	protected void setPayload(String fileName) throws Exception {
		URL url = ClassLoader.getSystemResource(fileName);
		Path resPath = Paths.get(url.toURI());
		payload = new String(Files.readAllBytes(resPath), "UTF8");
				
		payload = payload.replaceAll("XX_RESPONSIBILITY", RESPONSIBILITY);		
	}
}