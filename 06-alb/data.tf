
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


data "aws_security_group" "worker_security_group" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-${var.cluster_env}-worker-security-group"]
  }
}

data "aws_instances" "ec2_instances" {
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-${var.cluster_env}-worker*"]
  }
}

##data "aws_iam_server_certificate" "certificate" {
#  name_prefix = "star-igel-ums-cloud"
#  latest      = true
#}

#data "aws_acm_certificate" "acm-certificate"{
#  domain   = "*.igelums.cloud"
#  statuses = ["ISSUED"]
#}