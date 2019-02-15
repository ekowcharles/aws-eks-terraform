data "aws_ami" "eks-worker" {
  filter {
    name = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners = ["${var.account_id}"]
}

# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.master_cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster.master_cluster.certificate_authority.0.data}' '${var.cluster_name}'
USERDATA
}

resource "aws_launch_configuration" "worker_node" {
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.worker_node.name}"
  image_id = "${data.aws_ami.eks-worker.id}"
  instance_type = "${var.worker_instance_type}"
  name_prefix = "${var.cluster_name}"
  security_groups = ["${aws_security_group.worker_node.id}"]
  user_data_base64 = "${base64encode(local.node-userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo" {
  desired_capacity = "${var.worker_instances}"
  launch_configuration = "${aws_launch_configuration.worker_node.id}"
  max_size = "${var.maximum_worker_instances}"
  min_size = "${var.minimum_worker_instances}"
  name = "${var.cluster_name}"
  vpc_zone_identifier = ["${aws_subnet.demo.*.id}"]

  tag {
    key = "Name"
    value = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster_name}"
    value = "owned"
    propagate_at_launch = true
  }
}
