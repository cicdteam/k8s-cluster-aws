# External variables
#
variable "region" {}
variable "name" {}
variable "public_key_path" {}

# Terraform configuration
#
terraform {
  required_version = ">= 0.9.6"
  backend "s3" {}
}

provider "aws" {
  region      = "${var.region}"
  max_retries = "10"
}
