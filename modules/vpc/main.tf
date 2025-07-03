terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.81.0"
        }
    }
}
data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}"
    }
}

resource "aws_subnet" "public_subnets" {
    count                   = var.public_subnets

    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index + 8)
    map_public_ip_on_launch = true
    availability_zone       = data.aws_availability_zones.available.names[count.index]

    tags = {
        Role = "public-subnet"
        Name = "${var.cluster_name}-${var.cluster_env}-public-subnet-${count.index}"
    }
}

resource "aws_subnet" "private_subnets" {
    count                   = var.private_subnets

    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
    map_public_ip_on_launch = false
    availability_zone       = data.aws_availability_zones.available.names[count.index]

    tags = {
        Role = "private-subnet"
        Name = "${var.cluster_name}-${var.cluster_env}-private-subnet-${count.index}"
    }
}

resource "aws_eip" "bastion_eip" {
    count = var.create_bastion_eip ? 1 : 0

    domain = "vpc"

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-bastion-eip"
    }
}

resource "aws_eip" "nat_gateway_eip" {
    count  = length(aws_subnet.public_subnets)

    domain = "vpc"

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-nat-gateway-eip-${count.index}"
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    count         = length(aws_subnet.public_subnets)

    allocation_id = aws_eip.nat_gateway_eip[count.index].id
    subnet_id     = aws_subnet.public_subnets[count.index].id

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-nat-gateway-${count.index}"
    }
}

resource "aws_internet_gateway" "public" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-public-route-table"
    }
}

resource "aws_route_table" "private_route_table" {
    count  = length(aws_subnet.private_subnets)

    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-private-route-table-${count.index}"
    }
}

resource "aws_route" "public_route" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.public_route_table.id
    gateway_id             = aws_internet_gateway.public.id
}

resource "aws_route" "private_route" {
    count                  = length(aws_subnet.private_subnets)

    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.private_route_table[count.index].id
    nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "public_route_table_association" {
    count          = length(aws_subnet.public_subnets)

    route_table_id = aws_route_table.public_route_table.id
    subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table_association" "private_route_table_association" {
    count          = length(aws_subnet.private_subnets)

    route_table_id = aws_route_table.private_route_table[count.index].id
    subnet_id      = aws_subnet.private_subnets[count.index].id
}