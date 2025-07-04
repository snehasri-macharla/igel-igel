
resource "aws_security_group" "ec2_security_group" {
  name        = "${var.cluster_name}-${var.cluster_env}-${var.role_ec2}-security-group"
  description = "SSH and internal traffic"
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.cluster_name}-${var.cluster_env}-${var.role_ec2}-security-group"
  }
}

resource "aws_security_group_rule" "bastion_security_group_rule_ingress" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.bastion_security_group.id
  description              = "SSH from bastion"
  security_group_id        = aws_security_group.ec2_security_group.id
}

resource "aws_security_group_rule" "alb_security_group_rule_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/8"]
  description       = "Health check from application load balancer"
  security_group_id = aws_security_group.ec2_security_group.id
}

resource "aws_security_group_rule" "ec2_security_group_rule_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_security_group.id
}