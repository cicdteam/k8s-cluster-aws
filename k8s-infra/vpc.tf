# Define AWS Virtual Private Cloud
#
resource "aws_vpc" "k8s" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = [
    { Name = "${var.name}-vpc" },
    { KubernetesCluster = "${var.name}" }
  ]
  lifecycle {
    create_before_destroy = true
  }
}

output "vpc_id" {
  value = "${aws_vpc.k8s.id}"
}
output "vpc_cidr" {
  value = "${var.vpc_cidr}"
}

# Define AWS Subnet
#
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "k8s" {
  vpc_id            = "${aws_vpc.k8s.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block        = "${cidrsubnet(aws_vpc.k8s.cidr_block, 8, 0)}"
  tags = [
    { Name = "${var.name}-subnet" }
  ]
  map_public_ip_on_launch = true
  lifecycle {
    create_before_destroy = false
  }
}
output "subnet_id" {
  value = "${aws_subnet.k8s.id}"
}
output "subnet_cidr" {
  value = "${aws_subnet.k8s.cidr_block}"
}

# Define Internet Gateway
#
resource "aws_internet_gateway" "k8s" {
  vpc_id = "${aws_vpc.k8s.id}"
  tags = [
    { Name = "${var.name}-gw" }
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# Define route tables
#
resource "aws_route_table" "k8s" {
  vpc_id = "${aws_vpc.k8s.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.k8s.id}"
  }
  tags = [
    { Name = "${var.name}-routing" }
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "k8s" {
  subnet_id      = "${aws_subnet.k8s.id}"
  route_table_id = "${aws_route_table.k8s.id}"
  lifecycle {
    create_before_destroy = true
  }
}
