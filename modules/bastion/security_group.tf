
resource "aws_security_group" "bastion_security_group" {
  name        = "${var.cluster_name}-${var.cluster_env}-${var.role}-security-group"
  description = "SSH and internal traffic"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}-${var.role}-security-group"
  }
}

resource "aws_security_group_rule" "bastion_security_group_rule_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_security_group.id
}

resource "aws_security_group_rule" "bastion_security_group_rule_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_security_group.id
}