variable "vpc_cidr_block" {
  type = "string"
  description = "CIDR block for your vpc"
}

variable "subnet_ids" {
  type = "list"
  description = "CIDR blocks subnets to be carved out from the VPC"
}

variable "cluster_name" {
  type = "string"
  description = "Name of EKS cluster"
}

variable "account_id" {
  type = "string"
  description = "Amazon EKS AMI Account ID"
}

variable "permitted_ip" {
  type = "string"
  description = "Your public IP. Services like icanhazip.com can help you find this."
}
