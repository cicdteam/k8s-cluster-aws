#
# EFS volume to store data persistently
#
resource "aws_efs_file_system" "k8s" {
  performance_mode = "generalPurpose"
  tags = [
    { Name = "${var.name}-efs" },
    { KubernetesCluster = "${var.name}" }
  ]
}

output "efs_id" {
  value = "${aws_efs_file_system.k8s.id}"
}

resource "aws_efs_mount_target" "k8s" {
  subnet_id       = "${aws_subnet.k8s.id}"
  file_system_id  = "${aws_efs_file_system.k8s.id}"
  security_groups = ["${aws_security_group.k8s-efs.id}"]
}

resource "aws_security_group" "k8s-efs" {
  name        = "${var.name}-efs"
  vpc_id      = "${aws_vpc.k8s.id}"
  description = "${var.name} EFS security group"
  tags = [
    { Name = "${var.name}-efs" }
  ]
  lifecycle { create_before_destroy = true }

  # no limit inside VPC
  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${aws_vpc.k8s.cidr_block}"]
  }
  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${aws_vpc.k8s.cidr_block}"]
  }
}
