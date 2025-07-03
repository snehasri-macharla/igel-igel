
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}"
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

data "aws_subnet" "public_subnets" {
  for_each = { for index, subnetid in data.aws_subnets.public_subnets.ids : index => subnetid }
  id       = each.value
}

data "aws_eip" "aws_eip_bastion" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-${var.cluster_env}-bastion-eip"]
  }
}