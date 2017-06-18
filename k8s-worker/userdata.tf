# User-data shell script used to orhestrate worker on first initial boot
#
data "template_file" "k8s-worker" {
  template = "${file("${path.module}/../templates/worker_init.tmpl")}"
  vars {
    token  = "${data.terraform_remote_state.infra.init-token}"
    master = "${data.terraform_remote_state.infra.k8s-master-eip}"
  }
}
