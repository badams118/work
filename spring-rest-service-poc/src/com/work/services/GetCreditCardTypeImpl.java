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
import com.nsp.beans.CreditCardTypeResponse;

import oracle.jdbc.OracleCallableStatement;
import oracle.jdbc.OracleTypes;

@Service("getCreditCardTypeService")
@Transactional(propagation=Propagation.REQUIRED)

public class GetCreditCardTypeImpl implements GetCreditCardTypeService {

	@Autowired
	private DataSource dataSource;
	
	@Override
	public CreditCardTypeResponse getCreditCardType(
			String brand, 
			String country, 
			String language, 
			String agent, 
			String clientSystem, 
			String accountNumber, 
			int custAccountID) {
		CreditCardTypeResponse response = new CreditCardTypeResponse();
		Connection connection = null;
		CallableStatement statement = null;

		try {		
			connection = dataSource.getConnection();
			  	
			statement = connection.prepareCall(
					" { call xbol_test.GetCreditCardType(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) } " );

			statement.setString(1, brand);
			statement.setString(2, country);
			statement.setString(3, language);
			statement.setString(4, agent);
			statement.setString(5, clientSystem);
			statement.setString(6, accountNumber);
			statement.setInt(7, custAccountID);
	    	statement.registerOutParameter(8, Types.INTEGER);
	    	statement.registerOutParameter(9, Types.INTEGER);
	    	statement.registerOutParameter(10, Types.VARCHAR);
	    	statement.registerOutParameter(11, OracleTypes.ARRAY, "XBOL_MESSAGESTYPE");
		    	
			statement.execute();	

			Array messagesArray = (Array) statement.getObject(11);
            Object[] messageObjects = (Object []) messagesArray.getArray();
			
			if (statement.getObject(8).equals(1)) {
				response.setSucceeded(true);
			} else {
				response.setSucceeded(false);
			}
			
			if (statement.getObject(9).equals(1)) {
				response.setDataNull(true);
			} else {
				response.setDataNull(false);
			}
			
			response.setCreditCardTypes((String) statement.getObject(10));
			
			List<Message> messages = new ArrayList<Message>();
			for (Object messageObject : messageObjects) {
				Struct messageStruct = (Struct) messageObject;
				Object[] messageArray = messageStruct.getAttributes();
				Message message = new Message();
				if (messageArray[0] != null) {
					message.setDetails(messageArray[0].toString()); //prints address of object
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
