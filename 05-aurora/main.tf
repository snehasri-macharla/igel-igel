
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

module "aurora" {
    source = "../../../../modules/aurora"

    cluster_name      = var.cluster_name
    cluster_env       = var.cluster_env
    role              = var.role
    engine            = var.engine
    engine_version    = var.engine_version
    master_user       = var.master_user
    master_password   = var.master_password
    database_name     = var.database_name
    instance_type     = var.instance_type
    db_instance_count = var.db_instance_count
}