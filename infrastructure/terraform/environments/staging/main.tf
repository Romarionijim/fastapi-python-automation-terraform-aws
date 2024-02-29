module "vpc" {
  source               = "../../modules/networking/vpc"
  env_name             = var.env_name
  availability_zones   = var.availability_zones
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  vpc_cidr             = var.vpc_cidr
  all_traffic_cidr     = var.all_traffic_cidr
}

module "application_load_balancer" {
  source            = "../../modules/load_balancers/alb"
  target_group_type = var.target_group_type
  env_name          = var.env_name
  subnet_1_id       = module.vpc.subnet_1_id
  subnet_2_id       = module.vpc.subnet_2_id
  lb_type           = var.lb_type
  domain            = var.domain
  vpc_id            = module.vpc.vpc_id
  all_traffic_cidr  = var.all_traffic_cidr
}

module "ecs" {
  source          = "../../modules/containers/ecs"
  container_name  = var.container_name
  ecs_launch_type = var.ecs_launch_type
  env_name        = var.env_name
  replicas        = var.replicas
  docker_image    = var.docker_image
  vpc_id          = module.vpc.vpc_id
  alb_root_tg_arn = module.application_load_balancer.alb_root_tg_arn
  alb_sg_id       = module.application_load_balancer.alb_sg_id
  public_subnet_1 = module.vpc.subnet_1_id
  public_subnet_2 = module.vpc.subnet_2_id
  ecs_family      = var.ecs_family
}

module "route53" {
  source       = "../../modules/dns/route53"
  alb_dns_name = module.application_load_balancer.alb_dns_name
  alb          = module.application_load_balancer.alb
  domain       = var.domain
  sub_domain   = var.sub_domain
  alb_zone_id  = module.application_load_balancer.alb_zone_id
}
