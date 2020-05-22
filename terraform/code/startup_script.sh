#! /bin/bash

google_metadata_get_file () {
    echo "Retrieving $1 file..." >> ~/startup-script.log
    curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1 -H "Metadata-Flavor: Google"
}

echo "This is the Startup script!" >> ~/startup-script.log
date  >> ~/startup-script.log

google_metadata_get_file docker-compose-yaml > ~/docker-compose.yml

echo "Starting docker-compose stack..." >> ~/startup-script.log
docker-compose --file ~/docker-compose.yml up -d --force-recreate --remove-orphans >> ~/startup-script.log 2>&1

echo "Components should be up, now!"

