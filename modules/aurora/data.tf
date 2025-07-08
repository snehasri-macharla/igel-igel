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

data "aws_subnet" "private_subnets" {
  for_each = { for index, subnetid in data.aws_subnets.private_subnets.ids : index => subnetid }
  id       = each.value
}
