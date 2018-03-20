package com.nsp.beans;

public class Address {
	int id;//                       NUMBER
    String description;//              hz_party_sites.party_site_name%TYPE
    String addressType;//              hz_cust_site_uses_all.site_use_code%TYPE
    String name;//                     hz_party_sites.addressee%TYPE
    String line1;//                    hz_locations.address1%TYPE
    String line2;//                    hz_locations.address2%TYPE
    String line3;//                    hz_locations.address3%TYPE
    String line4;//                    hz_locations.address4%TYPE
    String city;//                     hz_locations.city%TYPE
    String county;//                   VARCHAR2(30)
    String subdivision;//              hz_locations.province%TYPE
    String postalCode;//               hz_locations.postal_code%TYPE
    String country;//                  hz_locations.country%TYPE
    String phoneNumber;//              VARCHAR2(30)
    String emailAddress;//             VARCHAR2(100)
    boolean showPricesOnInvoice;//      BOOLEAN
    boolean isSignatureRequired;//      BOOLEAN
    boolean allowSurePost;//            BOOLEAN
    String defaultShippingMethodID;//  hz_cust_site_uses_all.ship_via%TYPE
    String defaultWarehouse;//         VARCHAR2(100)
    boolean saveAddressToAddressBook;// BOOLEAN
    String primaryFlag;//              VARCHAR2(1)
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getAddressType() {
		return addressType;
	}
	public void setAddressType(String addressType) {
		this.addressType = addressType;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLine1() {
		return line1;
	}
	public void setLine1(String line1) {
		this.line1 = line1;
	}
	public String getLine2() {
		return line2;
	}
	public void setLine2(String line2) {
		this.line2 = line2;
	}
	public String getLine3() {
		return line3;
	}
	public void setLine3(String line3) {
		this.line3 = line3;
	}
	public String getLine4() {
		return line4;
	}
	public void setLine4(String line4) {
		this.line4 = line4;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getCounty() {
		return county;
	}
	public void setCounty(String county) {
		this.county = county;
	}
	public String getSubdivision() {
		return subdivision;
	}
	public void setSubdivision(String subdivision) {
		this.subdivision = subdivision;
	}
	public String getPostalCode() {
		return postalCode;
	}
	public void setPostalCode(String postalCode) {
		this.postalCode = postalCode;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getPhoneNumber() {
		return phoneNumber;
	}
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	public String getEmailAddress() {
		return emailAddress;
	}
	public void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}
	public boolean isShowPricesOnInvoice() {
		return showPricesOnInvoice;
	}
	public void setShowPricesOnInvoice(boolean showPricesOnInvoice) {
		this.showPricesOnInvoice = showPricesOnInvoice;
	}
	public boolean isSignatureRequired() {
		return isSignatureRequired;
	}
	public void setSignatureRequired(boolean isSignatureRequired) {
		this.isSignatureRequired = isSignatureRequired;
	}
	public boolean isAllowSurePost() {
		return allowSurePost;
	}
	public void setAllowSurePost(boolean allowSurePost) {
		this.allowSurePost = allowSurePost;
	}
	public String getDefaultShippingMethodID() {
		return defaultShippingMethodID;
	}
	public void setDefaultShippingMethodID(String defaultShippingMethodID) {
		this.defaultShippingMethodID = defaultShippingMethodID;
	}
	public String getDefaultWarehouse() {
		return defaultWarehouse;
	}
	public void setDefaultWarehouse(String defaultWarehouse) {
		this.defaultWarehouse = defaultWarehouse;
	}
	public boolean isSaveAddressToAddressBook() {
		return saveAddressToAddressBook;
	}
	public void setSaveAddressToAddressBook(boolean saveAddressToAddressBook) {
		this.saveAddressToAddressBook = saveAddressToAddressBook;
	}
	public String getPrimaryFlag() {
		return primaryFlag;
	}
	public void setPrimaryFlag(String primaryFlag) {
		this.primaryFlag = primaryFlag;
	}
}
