provider "aws" {
  profile = "default"
  region  = "us-west-2"

  # assume_role {
  #   role_arn     = "arn:aws:iam::${var.account_id}:role/${var.assume_role_name}"
  #   session_name = "terraform"
  # }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

##01-Network 
module "vpc" {
  source = "./modules/vpc"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  create_bastion_eip = var.create_bastion_eip
}

##02-ssh-key
module "ssh-key" {
  source = "./modules/ssh-key"

  cluster_name = var.cluster_name
  cluster_env  = var.cluster_env
  role         = var.role_ssh
}

##03-bastion
module "ec2-bastion" {
  source = "./modules/bastion"

  cluster_name     = var.cluster_name
  cluster_env      = var.cluster_env
  role             = var.role_bastion
  instance_type    = var.instance_type
  create_public_ip = var.create_public_ip
}


##04-ec2
module "ec2-az1" {
  source = "./modules/ec2"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  role               = var.role_ec2
  availability_index = 1
  instance_type      = var.instance_type
  security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id          = data.aws_subnet.private_subnets[0].id
  create_public_ip   = var.create_public_ip
}

module "ec2-az2" {
  source = "./modules/ec2"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  role               = var.role_ec2
  availability_index = 2
  instance_type      = var.instance_type
  security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id          = data.aws_subnet.private_subnets[1].id
  create_public_ip   = var.create_public_ip
}

##05-aurora
module "aurora" {
  source = "./modules/aurora"

  cluster_name      = var.cluster_name
  cluster_env       = var.cluster_env
  role              = var.role_aurora
  engine            = var.engine
  engine_version    = var.engine_version
  master_user       = var.master_user
  master_password   = var.master_password
  database_name     = var.database_name
  instance_type     = var.instance_type
  db_instance_count = var.db_instance_count
}

##06-alb
module "alb" {
  source = "./modules/alb"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  role               = var.role_alb
  security_group_ids = [data.aws_security_group.worker_security_group.id]
  subnets            = [for subnet in data.aws_subnet.public_subnets : subnet.id]
  vpc_id             = data.aws_vpc.vpc.id
  ec2_instances      = data.aws_instances.ec2_instances.ids
  certificate        = data.aws_iam_server_certificate.certificate.arn
}