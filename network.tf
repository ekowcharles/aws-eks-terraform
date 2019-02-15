# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_availability_zones" "zones" {}

resource "aws_vpc" "demo" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = "${
    map(
     "Name", "${var.cluster_name}-node",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_subnet" "demo" {
  count = "${length(var.subnet_ids)}"

  availability_zone = "${data.aws_availability_zones.zones.names[count.index]}"
  cidr_block = "${var.subnet_ids[count.index]}"
  vpc_id = "${aws_vpc.demo.id}"

  tags = "${
    map(
     "Name", "${var.cluster_name}-node",
     "kubernetes.io/cluster/${var.cluster_name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  tags {
    Name = "${var.cluster_name}"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = "${aws_vpc.demo.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.demo.id}"
  }
}

resource "aws_route_table_association" "demo" {
  count = "${length(var.subnet_ids)}"

  subnet_id = "${aws_subnet.demo.*.id[count.index]}"
  route_table_id = "${aws_route_table.demo.id}"
}
