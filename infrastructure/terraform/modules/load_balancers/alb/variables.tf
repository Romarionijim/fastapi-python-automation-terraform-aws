variable "env_name" {}
variable "lb_type" {}
variable "cidr_blocks_object" {
  type = list(object({
    name       = string
    cidr_block = string
  }))
}
variable "vpc_id" {}
variable "subnet_1_id" {}
variable "subnet_2_id" {}
variable "domain" {}
variable "target_group_type" {}
variable "container_port" {}
