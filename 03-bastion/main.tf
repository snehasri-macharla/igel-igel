provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

module "ec2-bastion" {
  source = "../../../../modules/bastion"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  role               = var.role
  instance_type      = var.instance_type
  create_public_ip   = var.create_public_ip
}
