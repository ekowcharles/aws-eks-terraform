VAR_FILE ?= values.tfvars
STATE_FILE ?= terraform.tfstate

default: setup

init:
	awsudo -u eks terraform init

plan:
	awsudo -u eks terraform plan -var-file="$(VAR_FILE)"

apply:
	awsudo -u eks terraform apply -var-file="$(VAR_FILE)" -state="$(STATE_FILE)" -lock=false

output:
	awsudo -u eks terraform output

config:
	awsudo -u eks terraform output config_map_aws_auth > config_map_aws_auth.yml

destroy:
	awsudo -u eks terraform destroy -var-file="$(VAR_FILE)"