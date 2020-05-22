# gcp-migration
**Source:**
https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform

## How to get a running terraform CLI _from scratch_

docker run -it --volume "/gcp-ws-openid/terraform":/terraform-code \
  --volume "/gcp-ws-openid/packer":/packer \
  --volume "/gcp-ws-openid/secrets":/secrets \
  --volume "/gcp-ws-openid/vars":/vars \
  --env TF_VAR_FILE=/vars/dev.tfvars \
  --env GOOGLE_PROJECT=rugged-shuttle-277619 \
  --env GOOGLE_APPLICATION_CREDENTIALS="/secrets/ws-openid.json" \
  --workdir /terraform-code/ \
  thegaragebandofit/infra-as-code-tools:latest

