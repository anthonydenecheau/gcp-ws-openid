#!/bin/bash

set -e

echo "Backend configuration variables are stored in…"
echo "${TF_BACKEND_FILE}"
echo ""
echo "Environment variables are stored in…"
echo "${TF_VAR_FILE}"

echo "terraform init"
terraform init --backend-config="${TF_BACKEND_FILE}"
echo "terraform plan"
terraform plan -var-file="${TF_VAR_FILE}"
echo "terraform apply"
terraform apply -auto-approve -var-file="${TF_VAR_FILE}"

./code/rolling-recreate.sh
