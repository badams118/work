package com.nsp.beans;

import java.util.List;

public class CreditCardTypeResponse {
	private boolean succeeded;
	private boolean isDataNull;
	private String creditCardTypes;
	private List<Message> messages;
	
	public boolean isSucceeded() {
		return succeeded;
	}
	public void setSucceeded(boolean succeeded) {
		this.succeeded = succeeded;
	}
	public boolean isDataNull() {
		return isDataNull;
	}
	public void setDataNull(boolean isDataNull) {
		this.isDataNull = isDataNull;
	}
	public String getCreditCardTypes() {
		return creditCardTypes;
	}
	public void setCreditCardTypes(String creditCardTypes) {
		this.creditCardTypes = creditCardTypes;
	}
	public List<Message> getMessages() {
		return messages;
	}
	public void setMessages(List<Message> messages) {
		this.messages = messages;
	}
}
