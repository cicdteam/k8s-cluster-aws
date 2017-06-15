# Static Private IP for master node
#
resource "aws_network_interface" "k8s-master-private-ip" {
  subnet_id       = "${data.terraform_remote_state.infra.subnet_id}"
  private_ips     = ["${cidrhost(data.terraform_remote_state.infra.subnet_cidr, 10)}"]
  security_groups = ["${aws_security_group.k8s-master.id}"]
  tags = [
    { Name = "${var.name}-master-ip" }
  ]
}
