# AMI for Kubernetes 1.6 node with GPU support
#
data "aws_ami" "image" {
  most_recent = true
  filter {
    name = "name"
    values = ["k8s-1.6-ubuntu-xenial-amd64-hvm-ebs-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["551387705498"] # pureclouds
}
