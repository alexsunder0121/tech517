# APIs, REST, and HTTP – Fundamentals

## What are APIs? **Application Programming Interface**.

An API is a way for one software system to communicate with another software system.  
Instead of humans interacting through buttons or screens, programs send requests and receive responses.

> An API allows programs to talk to each other.

---
## Why are APIs so popular?

APIs are popular because they:
- allow systems to integrate easily
- reduce manual work
- are scalable and reusable
- work across different programming languages
- support automation and cloud-native systems

In modern software, APIs act as the **connection layer** between services.

---

## API Data Transfer Process (Diagram)

need to add image in

---

## What is a REST API? **Representational State Transfer**.

A REST API is an API that follows a **set of standard design rules** that make it predictable, scalable, and easy to use.

REST focuses on interacting with **resources** rather than actions.

---

## What makes an API RESTful? (REST Guidelines)

A RESTful API follows these principles:

### 1. Uses HTTP verbs correctly
- GET → read data
- POST → create data
- PUT / PATCH → update data
- DELETE → remove data

---

### 2. Uses resource-based URLs
URLs represent objects (resources), not actions.

---

### 3. Is stateless
- Each request is independent
- The server does not store client state between requests

This improves scalability and reliability.

---

### 4. Uses standard data formats
Most REST APIs use **JSON** for responses.

---

### 5. Uses HTTP status codes
Status codes indicate the result of a request.

Examples:
- 200 → OK
- 201 → Created
- 400 → Bad request
- 401 → Unauthorized
- 404 → Not found
- 500 → Server error

---

## What is HTTP?

HTTP stands for **HyperText Transfer Protocol**.

HTTP is the set of rules that define how data is sent and received over the internet.

HTTP is used for:
- websites
- APIs
- communication between services
- cloud and microservice architectures

---

## What is HTTPS?

HTTPS stands for **HyperText Transfer Protocol Secure**.

Difference:
- HTTP sends data in plain text
- HTTPS encrypts data

HTTPS is used to:
- protect sensitive information
- prevent data interception
- secure API communication

---

## Main HTTP Verbs$$

HTTP verbs describe the action being performed.

| Verb   | Purpose  | Description            |
|-------|----------|------------------------|
| GET   | Read     | Retrieve data          |
| POST  | Create   | Send new data          |
| PUT   | Update   | Replace existing data  |
| PATCH | Update   | Modify part of data    |
| DELETE| Delete   | Remove data            |

### REST-style examples:

---

## Summary

APIs allow software systems to communicate using HTTP.  
REST APIs follow standard guidelines such as stateless communication, resource-based URLs, correct HTTP verb usage, and JSON data formats.  
HTTP defines how requests and responses are sent, while HTTPS adds encryption for security.  
APIs are popular because they enable scalable, automated, and reliable system integration.