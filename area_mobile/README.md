# Documentation for Backend API (Area Creation) 

  

## Overview 

  

This API is designed to create and manage "Areas," which consist of actions and reactions triggered by various services. It supports authentication, service management, and event listening to automate these areas. 

  

## Authentication 

  

Authentication is handled via a **Bearer token**. The API has specific routes for registering new users and logging in existing users. Successful registration or login returns a token that must be included in the Authorization header of subsequent requests. 

  

### Authentication Routes 

  

- **POST `/register`** 

  - **Description**: Registers a new user. 

  - **Body**: 

    - `email`: string 

    - `password`: string 

  - **Responses**: 

    - `200`: Account already exists. 

    - `201`: Account created successfully. 

   

- **POST `/login`** 

  - **Description**: Logs in a user. 

  - **Body**: 

    - `email`: string 

    - `password`: string 

  - **Responses**: 

    - `200`: Successful login, returns Bearer token. 

    - `401`: Invalid credentials. 

  

### Bearer Token Usage 

In each authenticated request, include the token in the Authorization header: 

``` 

Authorization: Bearer <token> 

``` 

  

## Adding a New Service 

  

To integrate a new service with the API, it must interact with the event system. The service will capture events and trigger the appropriate actions/reactions. Every new event must be stored in the **event collection** in the database. 

  

### Steps to Add a New Service: 

1. **Service Setup**: Implement the service logic that can detect events. 

2. **Event Capture**: Ensure that each event is captured and added to the event collection in the database. 

3. **Database Update**: Add the service configuration to the database, ensuring it adheres to the structure for listening to events. 

4. **Event Listener**: Ensure that the global event listener captures the event and triggers any areas associated with the event. 

  

### Example Flow: 

- When the service detects an event (e.g., a file is uploaded), it sends the event data to the event collection. 

- The event listener, constantly monitoring this collection, will process the event and execute any associated actions or reactions. 

  

## Managing Actions and Reactions 

  

The configuration of actions and reactions by service is managed through a dedicated route, allowing for flexible and optimized configuration. 

  

### Routes for Action/Reaction Management: 

  

- **POST `/services/{serviceId}/action-reaction`** 

  - **Description**: Configures actions and reactions for a specific service. 

  - **Body**: 

    - `action`: string (the name of the action to trigger) 

    - `reaction`: string (the corresponding reaction to perform) 

  - **Responses**: 

    - `200`: Action and reaction set successfully. 

    - `400`: Invalid configuration. 

  

## Event Management 

  

Events are the backbone of the API’s automation system. Each event triggers specific actions and reactions based on predefined configurations. 

  

### Event Listener: 

- The listener monitors the **event collection** in the database for changes. 

- When a new event is added to the collection, the listener triggers any associated areas (actions/reactions). 

  

### Database Structure: 

- **event collection**: Stores all events triggered by services. 

  - Each entry contains: 

    - `eventId`: Unique identifier for the event. 

    - `serviceId`: The service that generated the event. 

    - `timestamp`: Time the event was captured. 

    - `payload`: Data associated with the event. 

  

### Event Lifecycle: 

1. A service detects an event and sends it to the event collection. 

2. The listener processes the event and checks for any actions or reactions configured for the service. 

3. If an action/reaction is found, the listener triggers the action. 

  

## Conclusion 

  

This API provides a flexible framework for creating and managing areas. By following the outlined steps, you can easily add new services, manage actions and reactions, and ensure authentication and event handling are smoothly integrated. 