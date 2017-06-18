# Cluster storage volume used by master node to store ETCD data and /etc/kubernetes dir
#

resource "aws_ebs_volume" "k8s" {
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    size = 20
    type = "gp2"
    tags {
        Name = "${var.name}-etcd-storage",
        KubernetesCluster = "${var.name}"
    }
}

output "k8s-etcd-storage-id"    {value = "${aws_ebs_volume.k8s.id}"}
