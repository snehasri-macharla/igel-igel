terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_security_group" "aurora_security_group" {
  name        = "${var.cluster_name}-${var.cluster_env}-${var.role}-security-group"
  vpc_id      = data.aws_vpc.vpc.id
  description = "Allow internal connections for ${var.cluster_name}-${var.cluster_env}-${var.role} Aurora cluster"

  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}-${var.role}-security-group"
  }
}

resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "${var.cluster_name}-${var.cluster_env}-${var.role}-subnet-group"
  subnet_ids = [for subnet in data.aws_subnet.private_subnets : subnet.id]
  description = "Subnet group for ${var.cluster_name}-${var.cluster_env}-${var.role} Aurora cluster"

  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}-${var.role}-subnet-group"
  }
}

resource "aws_security_group_rule" "allow_aurora_access" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/8"]
  security_group_id = aws_security_group.aurora_security_group.id
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier        = "${var.cluster_name}-${var.cluster_env}-${var.role}"
  engine                    = var.engine
  engine_version            = var.engine_version
  master_username           = var.master_user
  master_password           = var.master_password
  database_name             = var.database_name
  vpc_security_group_ids    = [aws_security_group.aurora_security_group.id]
  db_subnet_group_name      = aws_db_subnet_group.aurora_db_subnet_group.name
  skip_final_snapshot       = true
  final_snapshot_identifier = "${var.cluster_name}-${var.cluster_env}-${var.role}-final-snapshot"
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  count                      = var.db_instance_count
  identifier                 = "${var.cluster_name}-${var.cluster_env}-${var.role}-r${count.index}"
  cluster_identifier         = aws_rds_cluster.aurora_cluster.id
  engine                     = var.engine
  engine_version             = var.engine_version
  auto_minor_version_upgrade = false
  instance_class             = var.instance_type
  db_subnet_group_name       = aws_db_subnet_group.aurora_db_subnet_group.name
  apply_immediately          = true
}

