# Generte tiken used by kubeadm to join nodes in cluster
#

resource "random_id" "init" { byte_length = 3 }
resource "random_id" "token" { byte_length = 8 }

output "init-token"    {value = "${random_id.init.hex}.${random_id.token.hex}" }

