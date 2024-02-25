module "vpc" {
  source             = "../../modules/networking/vpc"
  env_name           = var.env_name
  availability_zones = var.availability_zones
  cidr_blocks_object = var.cidr_blocks_object
}

module "application_load_balancer" {
  source             = "../../modules/load_balancers/alb"
  target_group_type  = var.target_group_type
  env_name           = var.env_name
  cidr_blocks_object = var.cidr_blocks_object
  subnet_1_id        = module.vpc.subnet_1_id
  subnet_2_id        = module.vpc.subnet_2_id
  container_port     = var.container_port
  lb_type            = var.lb_type
  domain             = var.domain
  vpc_id             = module.vpc.vpc_id
}

module "route53" {
  source            = "../../modules/dns/route53"
  route53_zone_name = var.domain
  alb_dns_name      = module.application_load_balancer.alb_dns_name
  route53_name      = var.domain
}
