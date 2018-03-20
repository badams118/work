package com.nsp.services;

import com.nsp.beans.CreditCardTypeResponse;

public interface GetCreditCardTypeService {
	public CreditCardTypeResponse getCreditCardType(
			String brand, 
			String country, 
			String language, 
			String agent, 
			String clientSystem, 
			String accountNumber, 
			int custAccountID);
}
