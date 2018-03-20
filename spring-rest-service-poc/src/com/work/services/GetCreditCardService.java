package com.nsp.services;

import com.nsp.beans.CreditCardResponse;

public interface GetCreditCardService {
	public CreditCardResponse getCreditCard(
			String brand, 
			String country, 
			String language, 
			String agent, 
			String clientSystem, 
			String accountNumber, 
			int custAccountID,
			String cardType);
}
