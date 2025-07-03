
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Role = "private-subnet"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Role = "public-subnet"
  }
}

data "aws_subnet" "private_subnets" {
  for_each = { for index, subnetid in data.aws_subnets.private_subnets.ids : index => subnetid }
  id       = each.value
}

data "aws_subnet" "public_subnets" {
  for_each = { for index, subnetid in data.aws_subnets.public_subnets.ids : index => subnetid }
  id       = each.value
}

data "aws_security_group" "bastion_security_group" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-${var.cluster_env}-bastion-security-group"]
  }
}