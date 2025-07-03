variable "cluster_name" {
    default = "igel-large"
}

variable "cluster_env" {
    default = "dev"
}

variable "vpc_cidr" {
    type = string 
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    default = 2
}

variable "private_subnets" {
    default = 2
}

variable "create_bastion_eip" {
    default = true
}