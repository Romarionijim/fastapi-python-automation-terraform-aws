variable "env_name" {}
variable "ecs_family" {}
variable "container_port" {}
variable "host_port" {}
variable "container_name" {}
variable "docker_image" {}
variable "replicas" {}
variable "alb_root_tg_arn" {}
# variable "alb_person_tg_arn" {}
# variable "alb_person_path_params_tg_arn" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}
variable "vpc_id" {}
variable "cidr_blocks_object" {}
variable "alb_sg_id" {}
variable "ecs_launch_type" {}