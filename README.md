# gcp-migration
**Source:**
https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform

## How to get a running terraform CLI _from scratch_

You should already have `gcloud` and `terraform` tools installed onto your computer.

```bash
gcloud auth activate-service-account --project=someproject --key-file=gcpcmdlineuser.json
gcloud config configurations activate lof-ws-test
gcloud organizations list
gcloud beta billing accounts list
export TF_VAR_billing_account=019122-4C6478-3EB971
export TF_VAR_org_id=222456233936

# lof-ws-test-5c33f02ea8c8.json is the JSON file you get from the GCP console.
# It embeds the credentials to use the right service account.

export TF_CREDS='./.credentials/lof-ws-test-5c33f02ea8c8.json'
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
#export TF_ADMIN=${USER}-terraform-admin
export TF_ADMIN=lof-ws-test
export GOOGLE_PROJECT=${TF_ADMIN}
terraform init --backend-config='../vars/backend-lof-ws-test.hcl'
```

## How to do by using a Docker container (Ms Windows version)

Once you have an _up-and-running_ Docker for Windows onto your PC…  
You clone the present repository, go into into it and then…

```
docker run -it  --volume "%cd%/terraform":/terraform-code ^
  --volume "%cd%/secrets":/secrets  ^
  --volume "%cd%/vars":/vars  ^
  --env TF_VAR_FILE=/vars/re7.tfvars  ^
  --env GOOGLE_PROJECT=lof-ws-test  ^
  --env GOOGLE_APPLICATION_CREDENTIALS="/secrets/lof-ws-test.json" ^
  --workdir /terraform-code/ ^
  thegaragebandofit/infra-as-code-tools:gcl286-ter0.12.24
  ```
