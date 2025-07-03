
resource "tls_private_key" "rsa_4096_private_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "tf_key" {
    key_name   = "${var.cluster_name}-${var.cluster_env}-${var.role}"
    public_key = tls_private_key.rsa_4096_private_key.public_key_openssh

    tags = {
        Name = "${var.cluster_name}-${var.cluster_env}-${var.role}"
    }
}

resource "local_file" "tf_key" {
    content  = tls_private_key.rsa_4096_private_key.private_key_pem
    filename = "${var.cluster_name}-${var.cluster_env}-${var.role}.pub"
}