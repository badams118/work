package com.nsp.beans;

import java.util.List;

public class CreditCardResponse {
	private boolean succeeded;
	private boolean isDataNull;
	private List<CreditCard> creditCards;
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
	public List<CreditCard> getCreditCards() {
		return creditCards;
	}
	public void setCreditCards(List<CreditCard> creditCards) {
		this.creditCards = creditCards;
	}
	public List<Message> getMessages() {
		return messages;
	}
	public void setMessages(List<Message> messages) {
		this.messages = messages;
	}
}
