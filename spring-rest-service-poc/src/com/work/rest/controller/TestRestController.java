package com.nsp.rest.controller;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import com.nsp.services.GetCreditCardService;
import com.nsp.services.GetCreditCardTypeService;
import com.nsp.services.HelloWorldService;

@Component
@Path("/api")
public class TestRestController {

	@Autowired(required=true)
	@Qualifier("helloWorldService")
	private HelloWorldService helloWorld;

	//copy this section for new server
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/helloWorld/v1")
	public Response helloWorld(@QueryParam ("request") String request) {
		try {
			return Response.ok().entity(helloWorld.helloWorld(request)).build();
		} catch (Exception e) {
			e.printStackTrace();			
			
			return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
					.entity("Exception occurred while calling EBS")
					.type(MediaType.APPLICATION_JSON).
					build();
		}
	}

	@Autowired(required=true)
	@Qualifier("getCreditCardTypeService")
	private GetCreditCardTypeService getCreditCardType;

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/getCreditCardType/v1")
	public Response getCreditCardType(
			@QueryParam ("Brand")         String brand,
			@QueryParam ("Country")       String country,
			@QueryParam ("Language")      String language,
			@QueryParam ("Agent")         String agent,
			@QueryParam ("ClientSystem")  String clientSystem,
			@QueryParam ("AccountNumber") String accountNumber, 
			@QueryParam ("CustAccountID") int custAccountID) {
		try {
			return Response.ok().entity(
					getCreditCardType.getCreditCardType(
							brand,
							country,
							language,
							agent,
							clientSystem,
							accountNumber, 
							custAccountID)).build();
		} catch (Exception e) {
			e.printStackTrace();			
			
			return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
					.entity("Exception occurred while calling EBS")
					.type(MediaType.APPLICATION_JSON).
					build();
		}
	}

	@Autowired(required=true)
	@Qualifier("getCreditCardService")
	private GetCreditCardService getCreditCard;

	@GET
	@Produces(MediaType.APPLICATION_JSON)
	@Path("/getCreditCard/v1")
	public Response getCreditCard(
			@QueryParam ("Brand")         String brand,
			@QueryParam ("Country")       String country,
			@QueryParam ("Language")      String language,
			@QueryParam ("Agent")         String agent,
			@QueryParam ("ClientSystem")  String clientSystem,
			@QueryParam ("AccountNumber") String accountNumber, 
			@QueryParam ("CustAccountID") int custAccountID,
			@QueryParam ("CardType")      String cardType) {
		try {
			return Response.ok().entity(
					getCreditCard.getCreditCard(
							brand,
							country,
							language,
							agent,
							clientSystem,
							accountNumber, 
							custAccountID,
							cardType)).build();
		} catch (Exception e) {
			e.printStackTrace();			
			
			return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
					.entity("Exception occurred while calling EBS")
					.type(MediaType.APPLICATION_JSON).
					build();
		}
	}
}
