locals {
  cidr_map = { for block in var.cidr_blocks_object : block.name => block.cidr_block }
}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.env_name}-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.alb_sg.id]
  ip_address_type    = "ipv4"
  subnets            = [var.subnet_1_id, var.subnet_2_id]
  tags = {
    Name = "${var.env_name}-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  description = "${var.env_name}-sg"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr-block"]]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr-block"]]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [local.cidr_map["all-traffic-cidr-block"]]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [local.cidr_map["all-traffic-cidr-block"]]
  }
  tags = {
    Name = "${var.env_name}-alb-sg"
  }
}

resource "aws_lb_listener" "http_alb_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "secure_https_alb_listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.ssl_tls_certifiacte.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_root_target_group.arn
  }
}

data "aws_acm_certificate" "ssl_tls_certifiacte" {
  domain      = var.domain
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_target_group" "alb_root_target_group" {
  target_type      = var.target_group_type
  name             = "${var.env_name}-root-tg"
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  port             = var.container_port
  ip_address_type  = "ipv4"
  protocol_version = "HTTP1"
  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  tags = {
    Name = "${var.env_name}-root-tg"
  }
}

resource "aws_alb_listener_rule" "rule_1" {
  listener_arn = aws_lb_listener.secure_https_alb_listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_root_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_alb_listener_rule" "rule_2" {
  listener_arn = aws_lb_listener.secure_https_alb_listener.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_root_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/person"]
    }
  }
}

resource "aws_alb_listener_rule" "rule_3" {
  listener_arn = aws_lb_listener.secure_https_alb_listener.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_root_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/person/*"]
    }
  }
}

