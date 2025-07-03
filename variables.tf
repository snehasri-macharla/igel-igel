##01- Network
variable "cluster_name" {
  default = "igel-large"
}

variable "cluster_env" {
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
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

##02-ssh-key
variable "role_ssh" {
  default = "ssh-key"
}

##03-bastion
variable "role_bastion" {
  default = "bastion"
}

variable "instance_type" {
  default = "c5.xlarge" # Change to a smaller instance if needed
}

variable "create_public_ip" {
  default = false
}

##05-aurora
variable "role_aurora" {
  default = "db"
}

variable "engine" {
  default = "aurora-postgresql"
}

variable "engine_version" {
  default = "15.4"
}

variable "master_user" {
  default = "web"
}

variable "master_password" {
  default = "2HBKuCguweeF"
}

variable "database_name" {
  default = "umsdb"
}

variable "instance_type" {
  default = "db.t3.medium"
}

variable "db_instance_count" {
  default = "2"
}

##06-alb
variable "role_alb" {
  default = "alb"
}
