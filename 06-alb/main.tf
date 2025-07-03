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

module "alb" {
    source = "../../../../modules/alb"

    cluster_name              = var.cluster_name
    cluster_env               = var.cluster_env
    role                      = var.role
    security_group_ids        = [data.aws_security_group.worker_security_group.id]
    subnets                   = [for subnet in data.aws_subnet.public_subnets : subnet.id]
    vpc_id                    = data.aws_vpc.vpc.id
    ec2_instances             = data.aws_instances.ec2_instances.ids
    #certificate               = data.aws_iam_server_certificate.certificate.arn
}