# Internal variables
#

# Networking...
#
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.10.0.0/16"
}

variable "vpc_cidr_reverse" {
  description = "reverse Zone for the whole VPC"
  default     = "10.10.in-addr.arpa"
}
