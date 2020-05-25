#! /bin/bash

google_metadata_get_file () {
    echo "Retrieving $1 file..." >> ~/startup-script.log
    curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1 -H "Metadata-Flavor: Google"
}
google_metadata_get_envvar () {
    echo "Retrieving env. variable: $1..." >> ~/startup-script.log
    curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1 -H "Metadata-Flavor: Google"
}

echo "This is the Startup script!" >> ~/startup-script.log
date  >> ~/startup-script.log

google_metadata_get_file docker-compose-yaml > ~/docker-compose.yml

echo "Sourcing environnement variables..." >> ~/startup-script.log
export DATABASE_PRIVATE_IP=$(google_metadata_get_envvar database-private-ip)
export DATABASE_NAME=$(google_metadata_get_envvar database-name)
export DATABASE_USER=$(google_metadata_get_envvar database-user)
export DATABASE_GENERATED_PASSWORD=$(google_metadata_get_envvar database-generated-password)

echo "DATABASE_PRIVATE_IP:" $DATABASE_PRIVATE_IP
echo "DATABASE_NAME:" $DATABASE_NAME
echo "DATABASE_USER:" $DATABASE_USER
echo "DATABASE_GENERATED_PASSWORD:" $DATABASE_GENERATED_PASSWORD

echo "Starting docker-compose stack..." >> ~/startup-script.log
docker-compose --file ~/docker-compose.yml up -d --force-recreate --remove-orphans >> ~/startup-script.log 2>&1

echo "Components should be up, now!" >> ~/startup-script.log

