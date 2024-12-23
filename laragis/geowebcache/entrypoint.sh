#!/bin/bash

# Exit script as soon as a command fails.
set -e 

echo "-----------------------------------------------------"
echo "STARTING GEOWEBCACHE ENTRYPOINT ---------------------------"
echo "-----------------------------------------------------"
date

##############################################################################
# Edit the account
# File: /opt/bitnami/tomcat/webapps/geowebcache/WEB-INF/users.properties
##############################################################################

echo "Editing the account ..."
user_properties_path=${TOMCAT_WEBAPPS_DIR}/geowebcache/WEB-INF/users.properties

if [[ -f "${user_properties_path}" ]]; then
  rm "${user_properties_path}"
  envsubst < "/tmp/templates/users.properties.envsubst" > "${user_properties_path}"
fi

##############################################################################
# Edit the configuration file directory
# File: /opt/bitnami/tomcat/webapps/geowebcache/WEB-INF/web.xml
##############################################################################

echo "Editing the configuration file directory ..."
web_path=${TOMCAT_WEBAPPS_DIR}/geowebcache/WEB-INF/web.xml

if [[ -f "${web_path}" ]]; then
  rm "${web_path}"
  envsubst < "/tmp/templates/web.xml.envsubst" > "${web_path}"
fi

##############################################################################
# Edit the seed thread pool
# File: /opt/bitnami/tomcat/webapps/geowebcache/WEB-INF/geowebcache-core-context.xml
##############################################################################

echo "Editing the seed thread pool ..."
gwc_core_context_path=${TOMCAT_WEBAPPS_DIR}/geowebcache/WEB-INF/geowebcache-core-context.xml

if [[ -f "${gwc_core_context_path}" ]]; then
  rm "${gwc_core_context_path}"
  envsubst < "/tmp/templates/geowebcache-core-context.xml.envsubst" > "${gwc_core_context_path}"
fi

##############################################################################
# Add layers to geowebcache
# File: /opt/bitnami/tomcat/webapps/geowebcache/data_dir/geowebcache.xml
##############################################################################

echo "Adding layers to geowebcache ..."
layer_file_path=/tmp/sources/layers.yaml
gwc_temp_path=/tmp/templates/geowebcache.xml.tmpl
gwc_config_path=${GWC_DATA_DIR}/geowebcache.xml

if [ ! -f "$gwc_config_path" ]; then
  gomplate -d layers_yml="${layer_file_path}" -f "${gwc_temp_path}" -o "${gwc_config_path}"
fi

##############################################################################
# Start Tomcat
# Command: /opt/bitnami/tomcat/bin/
##############################################################################

exec "$@"

date
echo "-----------------------------------------------------"
echo "FINISHED GEOWEBCACHE ENTRYPOINT ---------------------------"
echo "-----------------------------------------------------"
