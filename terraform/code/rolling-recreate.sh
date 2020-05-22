#!/usr/bin/env sh
set -e

# ----- Prepare gcloud configuration

echo ""
echo "INFO- Connecting gcloud tools…"
echo "INFO- gcloud key file: .......... ${GOOGLE_APPLICATION_CREDENTIALS}"
echo "INFO- gcp project: .............. ${GOOGLE_PROJECT}"

gcloud auth activate-service-account --project=${GOOGLE_PROJECT} --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

# ----- Check that the service is OK BEFORE refresh



# ----- Identify if GCE running instances match with current instance template 

# Get the instance template that was used to create this instance
myRunningInstanceTemplate=`gcloud compute instances describe $(gcloud compute instances list --filter="name~'scc-docker-server'" --filter="status='RUNNING'" --limit=1 --uri) --format json | jq '.metadata.items[] | select(.key=="instance-template")|.value'| sed 's/"//g' `

myRunningInstanceTemplate_shorten=`basename ${myRunningInstanceTemplate}`

# Check that former result is an instance template
myCurrentInstanceTemplate=`gcloud compute instance-templates list --filter="name~'scc-docker-server'" --uri`
myCurrentInstanceTemplate_shorten=`basename ${myCurrentInstanceTemplate}`

if [ "g${myRunningInstanceTemplate_shorten}" == "g${myCurrentInstanceTemplate_shorten}" ]
then
    echo "INFO- Running instances are defined by instance template: ..... ${myRunningInstanceTemplate_shorten}"
    echo "INFO- Curently defined instance template: ..................... ${myCurrentInstanceTemplate_shorten}"
    exit 0
fi

# ----- Rolling-recreate GCE instances

# Trigger a rolling-replace of current running instances that were not created by the current instance template

echo "INFO- Rolling recreate of GCE instances according to currently defined instance template: ${myCurrentInstanceTemplate_shorten}"
gcloud compute instance-groups managed rolling-action replace scc-docker-server-igm --region=europe-west1

# ----- Check that the service is OK AFTER refresh

