# Attach volume with ETCD data
#
resource "aws_volume_attachment" "k8s-master" {
  device_name = "/dev/sdd"
  volume_id   = "${data.terraform_remote_state.infra.k8s-etcd-storage-id}"
  instance_id = "${aws_instance.k8s-master.id}"
  skip_destroy = "true"
}
