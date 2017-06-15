# External variables
#
variable "region" {}
variable "name" {}
variable "s3_cluster_store" {}
variable "worker_instance_type" {}
variable "worker_count_max" {}
variable "spot_instance_type" {}
variable "spot_count_max" {}
variable "spot_price_max" {}


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
