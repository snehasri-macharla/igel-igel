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

module "ec2-az1" {
  source = "../../../../modules/ec2"

  cluster_name              = var.cluster_name
  cluster_env               = var.cluster_env
  role                      = var.role
  availability_index        = 1
  instance_type             = var.instance_type
  security_group_ids        = [aws_security_group.ec2_security_group.id]
  subnet_id                 = data.aws_subnet.private_subnets[0].id
  create_public_ip          = var.create_public_ip
}

module "ec2-az2" {
  source = "../../../../modules/ec2"

  cluster_name              = var.cluster_name
  cluster_env               = var.cluster_env
  role                      = var.role
  availability_index        = 2
  instance_type             = var.instance_type
  security_group_ids        = [aws_security_group.ec2_security_group.id]
  subnet_id                 = data.aws_subnet.private_subnets[1].id
  create_public_ip          = var.create_public_ip
}