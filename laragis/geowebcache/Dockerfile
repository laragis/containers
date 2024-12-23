#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
ARG IMAGE_VERSION=9.0.91

##############################################################################
# Base stage
##############################################################################
FROM bitnami/tomcat:$IMAGE_VERSION AS base

# Declare arguments
ARG GWC_VERSION=1.23.4
ARG WAR_URL=https://downloads.sourceforge.net/project/geowebcache/geowebcache/${GWC_VERSION}/geowebcache-${GWC_VERSION}-war.zip

# Read-only environment variables - Bitnami Tomcat
ENV BITNAMI_ROOT_DIR=/opt/bitnami
ENV JAVA_HOME=${BITNAMI_ROOT_DIR}/java
ENV TOMCAT_HOME=${BITNAMI_ROOT_DIR}/tomcat
ENV TOMCAT_WEBAPPS_DIR=${TOMCAT_HOME}/webapps

# Customizable environment variables
ENV \
    INITIAL_MEMORY=1024M  \
    MAXIMUM_MEMORY=1024M \
    GWC_DATA_DIR=${TOMCAT_WEBAPPS_DIR}/geowebcache/data_dir \
    GWC_SEED_RETRY_COUNT=3 \
    GWC_SEED_RETRY_WAIT=100 \
    GWC_SEED_ABORT_LIMIT=10000000

ENV GWC_OPTIONS=" \
    -DGEOWEBCACHE_CONFIG_DIR=${GWC_DATA_DIR} \
    -DGEOWEBCACHE_CACHE_DIR=${GWC_DATA_DIR} \
    -DGWC_SEED_RETRY_COUNT=${GWC_SEED_RETRY_COUNT} \
    -DGWC_SEED_RETRY_WAIT=${GWC_SEED_RETRY_WAIT} \
    -DGWC_SEED_ABORT_LIMIT=${GWC_SEED_ABORT_LIMIT}"

ENV JAVA_OPTS=" \
    -Xms${INITIAL_MEMORY} \
    -Xmx${MAXIMUM_MEMORY} \
    -XX:+UseG1GC \
    -Duser.home=${TOMCAT_HOME} \
    ${GWC_OPTIONS}"

##############################################################################
# Builder stage
##############################################################################
FROM base AS builder-base

# Set user to root
USER root

# Copy packages to container
COPY ./packages /tmp

# Install required tools and clean up
RUN apt-get update \
    && apt-get install -y curl unzip gettext \
    && rm -rf /var/lib/apt/lists/*

# Install gomplate
RUN if [ ! -f /tmp/gomplate_linux-amd64 ]; then \
        curl -o /tmp/gomplate_linux-amd64 -sSL https://github.com/hairyhenderson/gomplate/releases/download/v4.3.0/gomplate_linux-amd64; \
    fi \
    && mv /tmp/gomplate_linux-amd64 /usr/bin/gomplate \
    && chmod 755 /usr/bin/gomplate

# Install geowebcache
RUN if [ ! -f /tmp/geowebcache-${GWC_VERSION}-war.zip ]; then \
        curl -o /tmp/geowebcache-${GWC_VERSION}-war.zip -sSL ${WAR_URL}; \
    fi \
    && unzip -o /tmp/geowebcache-${GWC_VERSION}-war.zip -d /tmp/geowebcache \
    && unzip -o /tmp/geowebcache/geowebcache.war -d ${TOMCAT_WEBAPPS_DIR}/geowebcache \
    && rm -rf /tmp/geowebcache*

##############################################################################
# Production stage
##############################################################################
FROM builder-base AS geowebcache-prod

# Set working directory
WORKDIR /app

# Copy application-specific files to container
COPY ./templates /tmp/templates
COPY ./sources /tmp/sources
COPY ./entrypoint.sh ./

# Create directories for GeoWebCache
RUN mkdir -p ${GWC_DATA_DIR} \
    && chown -R 1001:root ${GWC_DATA_DIR}

# Adjust permissions and ownership for GeoWebCache configuration
RUN chown -R 1001:root ${TOMCAT_WEBAPPS_DIR}/geowebcache/WEB-INF \
    && chmod -R 755 ${TOMCAT_WEBAPPS_DIR}/geowebcache/WEB-INF

# Set entrypoint
ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "catalina.sh", "run" ]

# Expose HTTP port
EXPOSE 8080

# Run as non-root user
USER 1001
