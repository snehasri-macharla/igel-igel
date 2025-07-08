module "ec2-bastion" {
  source = "../ec2"

  cluster_name       = var.cluster_name
  cluster_env        = var.cluster_env
  role               = "bastion"
  availability_index = 1
  instance_type      = "t3.micro"
  security_group_ids = [aws_security_group.bastion_security_group.id]
  subnet_id          = data.aws_subnet.public_subnets[0].id
  create_public_ip   = var.create_public_ip
}

resource "aws_eip_association" "instance_eip_association" {
  instance_id   = module.ec2-bastion.instance_id
  allocation_id = data.aws_eip.aws_eip_bastion.id
}