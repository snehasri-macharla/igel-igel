
variable "cluster_name" {
  default = "igel-large"
}

variable "cluster_env" {
  default = "dev"
}

variable "role" {
  default = "worker"
}

variable "instance_type" {
  default = "c5.2xlarge" # Change to a smaller instance if needed
}

variable "create_public_ip" {
  default = false
}