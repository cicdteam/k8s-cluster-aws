# AMI for Kubernetes 1.6 node with GPU support
# https://github.com/pureclouds/k8s-ami
#
data "aws_ami" "image" {
  most_recent = true
  filter {
    name = "name"
    values = ["k8s-1.6-gpu-ubuntu-xenial-amd64-hvm-ebs"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["551387705498"] # pureclouds
}
