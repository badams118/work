package com.nsp.services;

import java.sql.Array;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Struct;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.nsp.beans.Message;
import com.nsp.beans.Address;
import com.nsp.beans.CreditCard;
import com.nsp.beans.CreditCardResponse;
import com.nsp.beans.CreditCardTypeResponse;

import oracle.jdbc.OracleTypes;

@Service("getCreditCardService")
@Transactional(propagation=Propagation.REQUIRED)

public class GetCreditCardImpl implements GetCreditCardService {

	@Autowired
	private DataSource dataSource;
	
	@Override
	public CreditCardResponse getCreditCard(
			String brand, 
			String country, 
			String language, 
			String agent, 
			String clientSystem, 
			String accountNumber, 
			int custAccountID,
			String cardType) {
		CreditCardResponse response = new CreditCardResponse();
		Connection connection = null;
		CallableStatement statement = null;		

		try {		
			connection = dataSource.getConnection();
			  	
			statement = connection.prepareCall(
					" { call xbol_test.GetCreditCard(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) } " );

			statement.setString(1, brand);
			statement.setString(2, country);
			statement.setString(3, language);
			statement.setString(4, agent);
			statement.setString(5, clientSystem);
			statement.setString(6, accountNumber);
			statement.setInt(7, custAccountID);
			statement.setString(8, cardType);
	    	statement.registerOutParameter(9, Types.INTEGER);
	    	statement.registerOutParameter(10, Types.INTEGER);
	    	statement.registerOutParameter(11, OracleTypes.ARRAY, "XBOL_TAB_CREDIT_CARD");
	    	statement.registerOutParameter(12, OracleTypes.ARRAY, "XBOL_MESSAGESTYPE");
		    	
			statement.execute();	

			if (statement.getObject(9).equals(1)) {
				response.setSucceeded(true);
			} else {
				response.setSucceeded(false);
			}
			
			if (statement.getObject(10).equals(1)) {
				response.setDataNull(true);
			} else {
				response.setDataNull(false);
			}

			Array creditCardsArray = (Array) statement.getObject(11);
            Object[] creditCardObjects = (Object[]) creditCardsArray.getArray();
            
			List<CreditCard> creditCards = new ArrayList<CreditCard>();
			for (Object creditCardObject : creditCardObjects) {
				Struct creditCardStruct = (Struct) creditCardObject;
				Object[] creditCardArray = creditCardStruct.getAttributes();
				CreditCard creditCard = new CreditCard();
				if (creditCardArray[0] != null) {
					creditCard.setId(Integer.parseInt(creditCardArray[0].toString()));
				}
				if (creditCardArray[1] != null) {
					creditCard.setIntsrID(Integer.parseInt(creditCardArray[1].toString()));
				}
				if (creditCardArray[2] != null) {
					creditCard.setCreditCardType(creditCardArray[2].toString());
				}
				if (creditCardArray[3] != null) {
					creditCard.setCustomersDescription(creditCardArray[3].toString());
				}
				if (creditCardArray[4] != null) {
					creditCard.setNameOnCard(creditCardArray[4].toString());
				}
				if (creditCardArray[5] != null) {
					creditCard.setCreditCardNumber(creditCardArray[5].toString());
				}
				if (creditCardArray[6] != null) {
					creditCard.setCvv(creditCardArray[6].toString());
				}
				if (creditCardArray[7] != null) {
					creditCard.setMaskedCreditCardNumber(creditCardArray[7].toString());
				}
				if (creditCardArray[8] != null) {
					creditCard.setExpirationDate(creditCardArray[8].toString());
				}
				if (creditCardArray[9] != null) {
					Struct addressStruct = (Struct) creditCardArray[9];
					Object[] addressArray = addressStruct.getAttributes();
					Address address = new Address();
					if (addressArray[0] != null) {
						address.setId(Integer.parseInt(addressArray[0].toString()));
					}
					if (addressArray[1] != null) {
						address.setDescription(addressArray[1].toString());
					}
					if (addressArray[2] != null) {
						address.setAddressType(addressArray[2].toString());
					}
					if (addressArray[3] != null) {
						address.setName(addressArray[3].toString());
					}
					if (addressArray[4] != null) {
						address.setLine1(addressArray[4].toString());
					}
					if (addressArray[5] != null) {
						address.setLine2(addressArray[5].toString());
					}
					if (addressArray[6] != null) {
						address.setLine3(addressArray[6].toString());
					}
					if (addressArray[7] != null) {
						address.setLine4(addressArray[7].toString());
					}
					if (addressArray[8] != null) {
						address.setCity(addressArray[8].toString());
					}
					if (addressArray[9] != null) {
						address.setCounty(addressArray[9].toString());
					}
					if (addressArray[10] != null) {
						address.setSubdivision(addressArray[10].toString());
					}
					if (addressArray[11] != null) {
						address.setPostalCode(addressArray[11].toString());
					}
					if (addressArray[12] != null) {
						address.setCountry(addressArray[12].toString());
					}
					if (addressArray[13] != null) {
						address.setPhoneNumber(addressArray[13].toString());
					}
					if (addressArray[14] != null) {
						address.setEmailAddress(addressArray[14].toString());
					}
					if (addressArray[15] != null) {
						if (addressArray[15].toString().equals("1")) {
							address.setShowPricesOnInvoice(true);
						} else {
							address.setShowPricesOnInvoice(false);
						}
					}
					if (addressArray[16] != null) {
						if (addressArray[16].toString().equals("1")) {
							address.setSignatureRequired(true);
						} else {
							address.setSignatureRequired(false);
						}
					}
					if (addressArray[17] != null) {
						if (addressArray[17].toString().equals("1")) {
							address.setAllowSurePost(true);
						} else {
							address.setAllowSurePost(false);
						}
					}
					if (addressArray[18] != null) {
						address.setDefaultShippingMethodID(addressArray[18].toString());
					}
					if (addressArray[19] != null) {
						address.setDefaultWarehouse(addressArray[19].toString());
					}
					if (addressArray[20] != null) {
						if (addressArray[20].toString().equals("1")) {
							address.setSaveAddressToAddressBook(true);
						} else {
							address.setSaveAddressToAddressBook(false);
						}
					}
					if (addressArray[21] != null) {
						address.setPrimaryFlag(addressArray[21].toString());
					}
					creditCard.setAddress(address);
				}
				if (creditCardArray[10] != null) {
					creditCard.setPriorityIndex(Integer.parseInt(creditCardArray[10].toString()));
				}
				if (creditCardArray[11] != null) {
					if (creditCardArray[11].toString().equals("1")) {
						creditCard.setSaveToSavedCreditCards(true);
					} else {
						creditCard.setSaveToSavedCreditCards(false);
					}
				}
				creditCards.add(creditCard);
			}
			response.setCreditCards(creditCards);

			Array messagesArray = (Array) statement.getObject(12);
            Object[] messageObjects = (Object[]) messagesArray.getArray();
            
			List<Message> messages = new ArrayList<Message>();
			for (Object messageObject : messageObjects) {
				Struct messageStruct = (Struct) messageObject;
				Object[] messageArray = messageStruct.getAttributes();
				Message message = new Message();
				if (messageArray[0] != null) {
					message.setDetails(messageArray[0].toString());
				}
				if (messageArray[1] != null) { 
					message.setCode(messageArray[1].toString());
				}
				if (messageArray[2] != null) {
					message.setReferenceNumber(messageArray[2].toString());
				}
				if (messageArray[3] != null) {
					message.setMessageType(messageArray[3].toString());
				}
				if (messageArray[4] != null) {
					message.setMessageType(messageArray[4].toString());
				}
				messages.add(message);
			}
			response.setMessages(messages);
			
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
