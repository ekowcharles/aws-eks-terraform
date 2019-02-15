resource "aws_security_group" "worker_node" {
  name = "${var.cluster_name}-worker-node"
  description = "Security group for all nodes in the cluster"
  vpc_id = "${aws_vpc.demo.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
     "Name", "${var.cluster_name}-node",
     "kubernetes.io/cluster/${var.cluster_name}", "owned",
    )
  }"
}

resource "aws_security_group_rule" "worker_node_ingress_self" {
  description = "Allow node to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.worker_node.id}"
  source_security_group_id = "${aws_security_group.worker_node.id}"
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "worker_node_ingress_master" {
  description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = "${aws_security_group.worker_node.id}"
  source_security_group_id = "${aws_security_group.master_cluster.id}"
  to_port = 65535
  type = "ingress"
}
