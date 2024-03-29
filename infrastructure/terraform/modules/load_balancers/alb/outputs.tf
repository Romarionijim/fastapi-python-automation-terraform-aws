output "alb_dns_name" {
  value = aws_alb.application_load_balancer.dns_name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_root_tg_arn" {
  value = aws_lb_target_group.alb_root_target_group.arn
}

output "alb" {
  value = aws_alb.application_load_balancer
}

output "alb_zone_id" {
  value = aws_alb.application_load_balancer.zone_id
}
