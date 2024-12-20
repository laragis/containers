#!/bin/bash

##############################################################################
# Common Funtions
##############################################################################

function create_dir() {
  DATA_PATH=$1
  if [[ ! -d ${DATA_PATH} ]]; then
    mkdir -p "${DATA_PATH}"
  fi
}

function delete_file() {
  FILE_PATH=$1
  if [  -f "${FILE_PATH}" ]; then
    rm "${FILE_PATH}"
  fi
}

function delete_folder() {
  FOLDER_PATH=$1
  if [  -d "${FOLDER_PATH}" ]; then
    rm -r "${FOLDER_PATH}"
  fi
}

##############################################################################
# Configure Funtions
##############################################################################

function web_config() {
  web_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/web.xml
  if [[ ! -f "${web_path}" ]]; then
    envsubst < "/settings/web.xml" > "${web_path}"
  fi
}

function user_properties_config() {
  user_properties_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/users.properties
  if [[ ! -f "${user_properties_path}" ]]; then
    envsubst < "/settings/users.properties" > "${user_properties_path}"
  fi
}

function gwc_core_context_config() {
  gwc_core_context_path=$CATALINA_HOME/webapps/geowebcache/WEB-INF/geowebcache-core-context.xml
  if [[ ! -f "${gwc_core_context_path}" ]]; then
    envsubst < "/settings/geowebcache-core-context.xml" > "${gwc_core_context_path}"
  fi
}

function add_layers_to_gwc() {
  gwc_config_path=$GWC_DATA_DIR/geowebcache.xml
  layer_file_path=/settings/layers.json

  if [ -f "$gwc_config_path" ]; then
    layer_count=$(jq '.wmsLayers | length' "${layer_file_path}")
    for (( i=0; i<$layer_count; i++ ))
    do
      NAME=$(jq -r ".wmsLayers[$i].name" "${layer_file_path}")
      TITLE=$(jq -r ".wmsLayers[$i].metaInformation.title" "${layer_file_path}")
      DESCRIPTION=$(jq -r ".wmsLayers[$i].metaInformation.description" "${layer_file_path}")
      WMS_URL=$(jq -r ".wmsLayers[$i].wmsUrl" "${layer_file_path}")
      WMS_LAYERS=$(jq -r ".wmsLayers[$i].wmsLayers" "${layer_file_path}")
      
      sed -i "/<layers>/a\
      <wmsLayer>\
        <name>$NAME</name>\
        <metaInformation>\
          <title>$TITLE</title>\
          <description>$DESCRIPTION</description>\
        </metaInformation>\
        <mimeFormats>\
          <string>image/gif</string>\
          <string>image/jpeg</string>\
          <string>image/png</string>\
          <string>image/png8</string>\
        </mimeFormats>\
        <wmsUrl>\
          <string>$WMS_URL</string>\
        </wmsUrl>\
        <wmsLayers>$WMS_LAYERS</wmsLayers>\
      </wmsLayer>" "${gwc_config_path}"
    done
  fi
}