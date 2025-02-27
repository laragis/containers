#!/bin/bash

# Exit script in case of error
set -e

echo $"\n\n\n"
echo "-----------------------------------------------------"
echo "STARTING SCRAPYD ENTRYPOINT $(date)"
echo "-----------------------------------------------------"

cmd="$@"

echo "Replacing environement variables in scrapyd.conf"
envsubst < /etc/scrapyd/scrapyd.conf.tpl > /etc/scrapyd/scrapyd.conf

# You can put other setup logic here

echo "-----------------------------------------------------"
echo "FINISHED SCRAPYD ENTRYPOINT"
echo "-----------------------------------------------------"

# Run the CMD 
echo "got command $cmd"
exec $cmd