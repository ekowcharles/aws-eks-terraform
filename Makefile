VAR_FILE ?= values.tfvars
STATE_FILE ?= terraform.tfstate
CLUSTER_NAME ?= terraform-eks-demo

default: setup

init:
	awsudo -u eks terraform init

plan:
	awsudo -u eks terraform plan -var-file="$(VAR_FILE)" -var cluster_name="$(CLUSTER_NAME)"

apply:
	awsudo -u eks terraform apply -var-file="$(VAR_FILE)" -var cluster_name="$(CLUSTER_NAME)" -state="$(STATE_FILE)" -lock=false

output:
	awsudo -u eks terraform output

config:
	awsudo -u eks terraform output config_map_aws_auth > config_map_aws_auth.yml

update:
	awsudo -u eks aws eks update-kubeconfig --name "$(CLUSTER_NAME)"

auth:
	kubectl apply -f config_map_aws_auth.yml

verify:
	kubectl get nodes

destroy:
	awsudo -u eks terraform destroy -var-file="$(VAR_FILE)"

all:
	$(MAKE) apply
	$(MAKE) update
	$(MAKE) auth
	$(MAKE) verify
