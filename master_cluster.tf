resource "aws_eks_cluster" "master_cluster" {
  name = "${var.cluster_name}"
  role_arn = "${aws_iam_role.master_cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.master_cluster.id}"]
    subnet_ids = ["${aws_subnet.demo.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.master_cluster_AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.master_cluster_AmazonEKSServicePolicy",
  ]
}
