
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

module "vpc" {
    source = "../../../../modules/vpc"

    cluster_name       = var.cluster_name
    cluster_env        = var.cluster_env
    vpc_cidr           = var.vpc_cidr
    public_subnets     = var.public_subnets
    private_subnets    = var.private_subnets
    create_bastion_eip = var.create_bastion_eip
}