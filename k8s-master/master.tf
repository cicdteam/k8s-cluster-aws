#
# Kubernetes master node
#

data "template_file" "k8s-master" {
  template               = "${file("${path.module}/../templates/master_init.tmpl")}"
  vars {
    region               = "${var.region}"
    efs_id               = "${data.terraform_remote_state.infra.efs_id}"
  }
}

resource "aws_instance" "k8s-master" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  key_name               = "${data.terraform_remote_state.infra.key_name}"
  instance_type          = "${var.master_instance_type}"
  iam_instance_profile   = "${aws_iam_instance_profile.k8s-master.id}"
  network_interface {
    network_interface_id = "${aws_network_interface.k8s-master-private-ip.id}"
    device_index = 0
  }
  monitoring             = false
  user_data              = "${data.template_file.k8s-master.rendered}"
  tags = [
    { Name = "${var.name}-master" },
    { KubernetesCluster = "${var.name}" }
  ]
  root_block_device {
    volume_type   = "gp2"
    volume_size   = "30"
  }
  lifecycle { create_before_destroy = false }
}

resource "aws_eip_association" "k8s-master" {
  instance_id = "${aws_instance.k8s-master.id}"
  allocation_id = "${data.terraform_remote_state.infra.k8s-master-eip-id}"
  lifecycle { create_before_destroy = false }
}

output "k8s-master-eip" {
  value = "${data.terraform_remote_state.infra.k8s-master-eip}"
}
