# Table of Contents
- [Docker-GeoWebCache](#Docker-GeoWebCache)
  * [Prerequisites](#Prerequisites)
  * [Build and Run the Application](#Build-and-Run-the-Application)
    + [Steps to Run](#Steps-to-Run)
    + [Accessing GeoWebCache](#Accessing-GeoWebCache)
  * [Stopping the Application](#Stopping-the-Application)
  * [Configuration](#Configuration)
    + [Build Arguments](#Build-Arguments)
    + [Environment Variables](#Environment-Variables)
  * [Data Persistence](#Data-Persistence)
  
# Docker-GeoWebCache

This repository contains a Docker setup for running [GeoWebCache](https://geowebcache.org) inside a Tomcat container using Docker or Docker Compose.

## Prerequisites

Before you can run the application, ensure that the following tools are installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Build and Run the Application

### Steps to Run:

1. **Clone the repository**:

```bash
git clone https://github.com/TranNhanGIS/docker-geowebcache.git
cd docker-geowebcache
```

2. **Download and move the GeoWebCache package**:

- You can download the GeoWebCache .zip file from the following link by replacing ${GWC_VERSION} with your desired version:
    https://downloads.sourceforge.net/project/geowebcache/geowebcache/${GWC_VERSION}/geowebcache-${GWC_VERSION}-war.zip
- Example, if you want to download version 1.23.4, use the following link:
    https://downloads.sourceforge.net/project/geowebcache/geowebcache/1.23.4/geowebcache-1.23.4-war.zip
- Once the .zip file has been downloaded, move the .zip file to the "packages" directory of your project. The project structure is as follows:
```bash
docker-geowebcache/
├── packages/
    ├── geowebcache-${GWC_VERSION}-war.zip
├── scripts/
    ├── entrypoint.sh/
    ├── functions.sh/
├── settings/
    ├── geowebcache-core-context.xml/
    ├── geowebcache.xml/
    ├── layers.json/
    ├── user.properties/
    ├── web.xml/
├── .dockerignore
├── .env
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── README.md
```

**Note**:

- Ensure that the .zip file is placed in the correct location in your project to avoid deployment issues.
- If you do not manually download and move this file, the project will need to download it using curl during the setup process.

3. **Build and Run the Docker image**:

- **Docker**

```bash
sudo docker build -t geowebcache-prod .
sudo docker run -p 8600:8080 geowebcache-prod
```

- **Docker compose**

```bash
sudo docker-compose up -d --build geowebcache-prod
```

4. **Access the GeoWebCache instance:**:

After the containers have started, you can access GeoWebCache by navigating to the following URL 
    http://localhost:8600/geowebcache

## Stopping the Application:

- **Docker**

```bash
sudo docker rm -f "<Container_ID>"
sudo docker rmi geowebcache-prod
```

- **Docker compose**

```bash
sudo docker-compose down --rmi all
```

## Configuration

The application has several configurable environment variables, which are defined in the Dockerfile and docker-compose.yml. Below are the relevant environment variables used:

### Build Arguments

* IMAGE_VERSION: The version of the base Tomcat image.
* JAVA_HOME: The location of the Java installation.
* GWC_VERSION: The version of GeoWebCache.
* WAR_URL: URL for downloading GeoWebCache WAR file.

### Environment Variables

* GWS_ADMIN_USER: The default admin user for GeoWebCache.
* GWS_ADMIN_PASSWORD: The password for the admin user.
* GWC_DATA_DIR: Directory where GeoWebCache stores its data.
* INITIAL_MEMORY: The initial memory allocated to the Java heap.
* MAXIMUM_MEMORY: The maximum memory allocated to the Java heap.
* GWC_PORT: Port used internally by GeoWebCache.
* GWC_SEED_RETRY_COUNT: The number of retries for GeoWebCache seeding.
* GWC_SEED_RETRY_WAIT: The wait time between retries for GeoWebCache seeding (in milliseconds).
* GWC_SEED_ABORT_LIMIT: The limit for aborting GeoWebCache seeding.
* GWC_INITIAL_SEED_THREAD_POOL: The initial number of threads allocated for seeding tasks in GeoWebCache. 
* GWC_MAXIMUM_SEED_THREAD_POOL: The maximum number of threads allowed for seeding tasks in GeoWebCache. 

You can modify these variables in the docker-compose.yml file to suit your environment.

### Data Persistence

The GeoWebCache data directory is mounted as a Docker volume (gwc_data). This ensures that any cached tiles or configuration changes made inside the container will persist even if the container is stopped or removed.
