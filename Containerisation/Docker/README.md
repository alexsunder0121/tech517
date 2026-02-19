# Intro to Microservices, Containers and Docker

## Differences between virtualisation and containerisation


>diagram explination

Benefits of each, especially a virtual machine over the traditional architecture

> refer to the diagram to explain 

## Microservices

What are they?
* A way to design software: A software architectural design pattern
* Where application are broken into their smallest parts

How are they made possible?
* Using containers 

How should the parts/microservices work:
  
The parts should:
* Be independent from each other (e.g. have their own database)
  * Benefit:
    * Deploy each microservice independently 
* Loosly coupled 
  * Each microservice can change, deployed and scaled indepdently without breaking other microservices 
    * How to accomplish this?
      * Clear stable APIs
        *  Use versioning to avoid breaking changes 
     * Asychronous communication
       * Event-driven architecture with message brokers 
       * Benefits of this:
         * microservices don't block waiting for other 
         * failures don't cascade as easily 
* Collaborating (be able to talk to each other easily)
 
<br>

Benefits
* Make an application portable + easily to scale 
* 

### Are Microservices always the best solution?

* No, because it adds complexity & challenges 
* Distributed system - parts need to be talk each other 
  * operational 
  * devops - CI/CD pipelines 
  * data - when different microservices use different databases 
  * testing 

**When is it best NOT to use microservices?**

If:
* You are a solo or small devlopment team or 
* If the app is small or at the beginning of devloping an app 

Then you'll move faster/move safely with a modular monolith 

**What is a modular monolith**

* one deployable unit 
* usually uses domain-driven design to create internal module boundaries 
  * Later, if you do decide you need to convert to a microservices architecture, you can more easily convert each module into a microservice 
* Initially you may have a shared database for all modules, but it may evolve so that modules could have their own database

**Examples of domains for an online shop**
* Products 
* Orders
* Payments
* Shipping
* User/Accounts

**When to move from a modular monolith to a microservice architecture**

* When the complexity is worth it, for example:when...
  * you have mulitple devloper teams 
  * you need to be able to scale different parts of the application 
  * you need higher isolation between the modules e.g.
    * one part can change without breaking other parts of the application 
    * one part of the application to be able to fail without breaking the whole application 
    * one part to be able to scale indepently 
    * one team to be able to work on a part of the application without interfering with other parts 
    * one part of the application needs its own technology, database, deployment schedulue 

## Docker

What is it?
* Command line utility 
* Manages containers
* Specifies how a container is built, how an container image loads and runs 

Alternatives
* Podman 
  * Open-source 
  * Same syntax as Docker for most commands


How it works (Docker architecture/API)

>See diagram


## Docker Compose 

### Why use it?

* Define and manage multi-container Docker applications
* Use a simple YAML file to define all the services your application needs, including databases, web services, other components
* By using Docker Compose, you can easily start, stop and manage these services using a single command

### How to use it
 
What do you need to install for it to work?
* Nothing, if you've already installed Docker 
 
How to store your docker compose file?
* Use `docker-compose.yml` file
 
Docker compose commands to manage your application
* start the application (without detached mode)
  * `docker-compose up`
* start the application (in detached mode)
  * `docker-compose up -d`
* what is the difference between running your application with or without detached mode
  * if not detached, engages the terminal to show logs of the running containers
* Stop the application
  * `docker-compose down`
* check services running with docker compose
  * `docker-compose ps`
* view logs in real-time
  * `docker-compose logs -f`
* view docker compose images
  * `docker-compose images`