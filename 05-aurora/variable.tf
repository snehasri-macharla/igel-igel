variable "cluster_name" {
    default = "igel-large"
}

variable "cluster_env" {
    default = "dev"
}

variable "role" {
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
