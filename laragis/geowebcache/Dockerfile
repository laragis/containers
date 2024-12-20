#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
ARG IMAGE_VERSION=9.0.91-jdk11-temurin-focal
ARG JAVA_HOME=/opt/java/openjdk

##############################################################################
# Production stage
##############################################################################
FROM tomcat:$IMAGE_VERSION AS geowebcache-prod

# Declare arguments
ARG GWC_VERSION=1.23.4
ARG WAR_URL=https://downloads.sourceforge.net/project/geowebcache/geowebcache/${GWC_VERSION}/geowebcache-${GWC_VERSION}-war.zip

# Declare environtment
ENV \
    JAVA_HOME=${JAVA_HOME} \
    INITIAL_MEMORY=1024M  \
    MAXIMUM_MEMORY=1024M \
    GWC_DATA_DIR=/opt/geowebcache/data_dir \
    GWC_SEED_RETRY_COUNT=3 \
    GWC_SEED_RETRY_WAIT=100 \
    GWC_SEED_ABORT_LIMIT=10000000 \
    GWC_INITIAL_SEED_THREAD_POOL=32 \
    GWC_MAXIMUM_SEED_THREAD_POOL=64

ENV GWC_OPTIONS=" \
    -DGEOWEBCACHE_CONFIG_DIR=${GWC_DATA_DIR} \
    -DGEOWEBCACHE_CACHE_DIR=${GWC_DATA_DIR} \
    -DGWC_SEED_RETRY_COUNT=${GWC_SEED_RETRY_COUNT} \
    -DGWC_SEED_RETRY_WAIT=${GWC_SEED_RETRY_WAIT} \
    -DGWC_SEED_ABORT_LIMIT=${GWC_SEED_ABORT_LIMIT}"

ENV JAVA_OPTIONS=" \
    -Xms${INITIAL_MEMORY} \
    -Xmx${MAXIMUM_MEMORY} \
    -XX:-UsePerfData \
    ${GWC_OPTIONS}"

USER root

# Install curl and unzip 
RUN apt-get update \
    && apt-get install -y curl unzip gettext jq \
    && rm -rf /var/lib/apt/lists/*

# Create directories for GeoWebCache data and template file
RUN mkdir -p ${GWC_DATA_DIR} /tmp/geowebcache
RUN chown root:root ${GWC_DATA_DIR} /tmp/geowebcache

# Implement geowebcache package, scripts and settings
ADD ./packages /tmp
ADD ./scripts /scripts
ADD ./settings /settings

# Install geowebcache
RUN if [ -f /tmp/geowebcache-${GWC_VERSION}-war.zip ]; then \
        mv /tmp/geowebcache-${GWC_VERSION}-war.zip /tmp/geowebcache.zip; \
    else \
        curl -L ${WAR_URL} -o /tmp/geowebcache.zip; \
    fi

# Unzip geowebcache and clear folder
RUN unzip -o /tmp/geowebcache.zip -d /tmp/geowebcache \
    && unzip -o /tmp/geowebcache/geowebcache.war -d ${CATALINA_HOME}/webapps/geowebcache \
    && rm -r /tmp/geowebcache*

# Open HTTP port
EXPOSE 8080

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
