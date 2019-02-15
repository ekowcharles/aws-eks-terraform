resource "aws_security_group" "master_cluster" {
  name = "${var.cluster_name}-master-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id = "${aws_vpc.demo.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster_name}"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes.
resource "aws_security_group_rule" "master_cluster_ingress_workstation_https" {
  cidr_blocks = ["${var.permitted_ip}"]
  description = "Allow workstation to communicate with the cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.master_cluster.id}"
  to_port = 443
  type = "ingress"
}

resource "aws_security_group_rule" "master_cluster_ingress_https" {
  description = "Allow pods to communicate with the cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.master_cluster.id}"
  source_security_group_id = "${aws_security_group.worker_node.id}"
  to_port = 443
  type = "ingress"
}
