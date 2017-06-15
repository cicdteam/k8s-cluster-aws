resource "aws_security_group" "k8s-worker" {
  name        = "${var.name}-worker"
  vpc_id      = "${data.terraform_remote_state.infra.vpc_id}"
  description = "${var.name} Kubernetes worker node security group"
  tags { Name = "${var.name}-worker" }
  tags = [
    { Name = "${var.name}-worker" },
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
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
