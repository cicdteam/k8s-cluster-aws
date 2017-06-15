# External variables
#
variable "region" {}
variable "name" {}
variable "s3_cluster_store" {}
variable "master_instance_type" {}

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

data "terraform_remote_state" "infra" {
  backend = "s3"
  config {
    bucket = "${var.s3_cluster_store}"
    key    = "kubernetes-cluster-infra.tfstate"
    region = "${var.region}"
  }
}
