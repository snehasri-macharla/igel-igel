
resource "aws_instance" "instance" {
    ami                         = data.aws_ami.ubuntu.id
    instance_type               = var.instance_type
    key_name                    = data.aws_key_pair.ssh_key.key_name
    vpc_security_group_ids      = var.security_group_ids
    subnet_id                   = var.subnet_id
    associate_public_ip_address = var.create_public_ip

    root_block_device {
        volume_size = 60
    }

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-${var.role}-az${var.availability_index}"
    }
}

