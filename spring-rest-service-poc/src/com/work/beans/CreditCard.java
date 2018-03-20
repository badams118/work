package com.nsp.beans;

import java.util.Date;

public class CreditCard {
	int id;//                     hz_cust_accounts.cust_account_id%TYPE
	int intsrID;//                iby_creditcard.instrid%TYPE
	String creditCardType;//         iby_creditcard.card_issuer_code%TYPE -- 'Undefined','AmericanExpress','Visa','MasterCard','Discover','JCB'
	String customersDescription;//   iby_creditcard.description%TYPE
	String nameOnCard;//             iby_creditcard.chname%TYPE
	String creditCardNumber;//       VARCHAR2(200) -- iby_creditcard.ccnumber%TYPE
	String cvv;//                    VARCHAR2(10) -- not stored
	String maskedCreditCardNumber;// iby_creditcard.masked_cc_number%TYPE
	String expirationDate;//         iby_creditcard.expirydate%TYPE
	Address address;//                AddressType
	int priorityIndex;//          iby_creditcard.cc_num_sec_segment_id%TYPE
	boolean SaveToSavedCreditCards;// BOOLEAN
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getIntsrID() {
		return intsrID;
	}
	public void setIntsrID(int intsrID) {
		this.intsrID = intsrID;
	}
	public String getCreditCardType() {
		return creditCardType;
	}
	public void setCreditCardType(String creditCardType) {
		this.creditCardType = creditCardType;
	}
	public String getCustomersDescription() {
		return customersDescription;
	}
	public void setCustomersDescription(String customersDescription) {
		this.customersDescription = customersDescription;
	}
	public String getNameOnCard() {
		return nameOnCard;
	}
	public void setNameOnCard(String nameOnCard) {
		this.nameOnCard = nameOnCard;
	}
	public String getCreditCardNumber() {
		return creditCardNumber;
	}
	public void setCreditCardNumber(String creditCardNumber) {
		this.creditCardNumber = creditCardNumber;
	}
	public String getCvv() {
		return cvv;
	}
	public void setCvv(String cvv) {
		this.cvv = cvv;
	}
	public String getMaskedCreditCardNumber() {
		return maskedCreditCardNumber;
	}
	public void setMaskedCreditCardNumber(String maskedCreditCardNumber) {
		this.maskedCreditCardNumber = maskedCreditCardNumber;
	}
	public String getExpirationDate() {
		return expirationDate;
	}
	public void setExpirationDate(String expirationDate) {
		this.expirationDate = expirationDate;
	}
	public Address getAddress() {
		return address;
	}
	public void setAddress(Address address) {
		this.address = address;
	}
	public int getPriorityIndex() {
		return priorityIndex;
	}
	public void setPriorityIndex(int priorityIndex) {
		this.priorityIndex = priorityIndex;
	}
	public boolean isSaveToSavedCreditCards() {
		return SaveToSavedCreditCards;
	}
	public void setSaveToSavedCreditCards(boolean saveToSavedCreditCards) {
		SaveToSavedCreditCards = saveToSavedCreditCards;
	}
}
