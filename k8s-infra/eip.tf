resource "aws_eip" "k8s-master-eip" {
  vpc      = true
}

output "k8s-master-eip-id" {value = "${aws_eip.k8s-master-eip.id}"}
output "k8s-master-eip"    {value = "${aws_eip.k8s-master-eip.public_ip}"}
