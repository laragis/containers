#!/bin/bash

source /scripts/functions.sh

##############################################################################
# Edit the account
# File: /usr/local/tomcat/webapps/geowebcache/WEB-INF/users.properties
##############################################################################

user_properties_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/users.properties
if [[ -f "${user_properties_path}" ]]; then
  delete_file "${user_properties_path}"
  user_properties_config
fi

##############################################################################
# Edit the configuration file directory
# File: /usr/local/tomcat/webapps/geowebcache/WEB-INF/web.xml
##############################################################################

web_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/web.xml
if [[ -f "${web_path}" ]]; then
  delete_file "${web_path}"
  web_config
fi

##############################################################################
# Edit the seed thread pool
# File: /usr/local/tomcat/webapps/geowebcache/WEB-INF/geowebcache-core-context.xml
##############################################################################

gwc_core_context_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/geowebcache-core-context.xml
if [[ -f "${gwc_core_context_path}" ]]; then
  delete_file "${gwc_core_context_path}"
  gwc_core_context_config
fi

##############################################################################
# Edit the layers configuration
# File: /opt/geowebcache/data_dir/geowebcache.xml
##############################################################################

# Run tomcat (background mode) to generate the file geowebcache.xml
catalina.sh run &
sleep 10

# Add layers to geowebcache
add_layers_to_gwc

# Rerun tomcat (foreground mode) to save changes in the file geowebcache.xml
catalina.sh stop
catalina.sh run