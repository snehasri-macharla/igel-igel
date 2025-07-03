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

module "ssh-key" {
    source = "../../../../modules/ssh-key"

    cluster_name = var.cluster_name
    cluster_env  = var.cluster_env
    role         = var.role
}