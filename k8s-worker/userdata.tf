# User-data shell script used to orhestrate worker on first initial boot
#
data "template_file" "k8s-worker" {
  template               = "${file("${path.module}/../templates/worker_init.tmpl")}"
  vars {
    region               = "${var.region}"
    efs_id               = "${data.terraform_remote_state.infra.efs_id}"
  }
}
