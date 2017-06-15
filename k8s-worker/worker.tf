#
# Kubernetes worker node (AutoScaling Group)
#

resource "aws_launch_configuration" "k8s-worker" {
  count = "${var.worker_count_max == "0" ? 0 : 1}"
  associate_public_ip_address = "true"
  name_prefix          = "${var.name}-worker"
  image_id             = "${data.aws_ami.ubuntu.id}"
  instance_type        = "${var.worker_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.k8s-worker.id}"
  key_name             = "${data.terraform_remote_state.infra.key_name}"
  security_groups      = ["${aws_security_group.k8s-worker.id}"]
  user_data            = "${data.template_file.k8s-worker.rendered}"
  enable_monitoring    = "false"
  root_block_device {
    volume_type        = "gp2"
    volume_size        = "30"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "k8s-worker" {
  count = "${var.worker_count_max == "0" ? 0 : 1}"
  name                 = "${var.name}-worker"
  launch_configuration = "${aws_launch_configuration.k8s-worker.name}"
  health_check_type     = "EC2"
  min_size             = "1"
  max_size             = "${var.worker_count_max}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.infra.subnet_id}"]
  tags = [
    {
      key                 = "Name"
      value               = "${var.name}-worker"
      propagate_at_launch = true
    },
    {
      key                 = "KubernetesCluster"
      value               = "${var.name}"
      propagate_at_launch = true
    }
  ]

  lifecycle { create_before_destroy = false }
}
