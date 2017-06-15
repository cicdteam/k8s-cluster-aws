resource "aws_security_group" "k8s-master" {
  name        = "${var.name}-master"
  vpc_id      = "${data.terraform_remote_state.infra.vpc_id}"
  description = "${var.name} Kubernetes master node security group"
  tags { Name = "${var.name}-master" }
  tags = [
    { Name = "${var.name}-master" },
    { KubernetesCluster = "${var.name}" }
  ]
  lifecycle { create_before_destroy = false }

  ingress { # no limit inside VPC
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${data.terraform_remote_state.infra.vpc_cidr}"]
  }
  ingress { # SSH
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { # Kube-api-server ssl
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
