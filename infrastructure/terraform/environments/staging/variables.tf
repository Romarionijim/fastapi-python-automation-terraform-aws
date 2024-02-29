variable "env_name" {}
variable "availability_zones" {
  type = map(string)
}
variable "target_group_type" {}
variable "lb_type" {}
variable "domain" {}
variable "container_name" {}
variable "replicas" {}
variable "docker_image" {}
variable "ecs_family" {}
variable "ecs_launch_type" {}
variable "region" {}
variable "sub_domain" {}
variable "vpc_cidr" {}
variable "public_subnet_1_cidr" {}
variable "public_subnet_2_cidr" {}
variable "all_traffic_cidr" {}
