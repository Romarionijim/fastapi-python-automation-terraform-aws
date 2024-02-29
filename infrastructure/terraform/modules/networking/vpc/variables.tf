variable "env_name" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_cidr" {}
variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}
variable "all_traffic_cidr" {}