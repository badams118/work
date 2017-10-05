package com.work.junitservicetestpoc;
import java.io.IOException;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;

public class JsonResponse {
	private ObjectMapper objectMapper;
	private JsonNode root, outputNode, responseNode, messagesNode;
	
	public JsonResponse(String jsonString) {
        objectMapper = new ObjectMapper();   
        
		try {
			root = objectMapper.readTree(jsonString);
		} catch (JsonProcessingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
        outputNode = root.path("OutputParameters");
        responseNode = outputNode.path("RESPONSE");
        messagesNode = responseNode.path("MESSAGES");
	}
	
	public boolean getSucceeded() {
		Boolean succeeded = false;
		
		if (responseNode.path("SUCCEEDED").asText().equals("1")) {
			succeeded = true;
		}
		
		return succeeded;
	}
	
	public boolean getIsDataNull() {
		Boolean isDataNull = false;
		
		if (responseNode.path("ISDATANULL").asText().equals("1")) {
			isDataNull = true;
		}
		
		return isDataNull;
	}
	
	public Boolean isMessages() {
		Boolean messages = true;
		
		if (messagesNode.isNull()) {
			messages = false;
		}
		
		return messages;
	}
	
	public String messagesToString () {
		String messages = "";
		
		JsonNode messagesItemNode = messagesNode.path("MESSAGES_ITEM");
		
		if (messagesItemNode.isArray()) {
			for (JsonNode message : messagesItemNode) {
				messages += message.path("DETAILS").asText() + "\n";
			}
		} else {
			messages = messagesItemNode.path("DETAILS").asText() + "\n";
		}
		
		return messages;
	}
}
