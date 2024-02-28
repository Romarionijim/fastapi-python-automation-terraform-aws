locals {
  cidr_map = { for block in var.cidr_blocks_object : block.name => block.cidr_block }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.env_name}-ecs-cluster"
  tags = {
    Name = "${var.env_name}-ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.ecs_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.docker_image
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "ecs_service" {
  name                 = "${var.env_name}-ecs-service"
  cluster              = aws_ecs_cluster.ecs_cluster.id
  launch_type          = var.ecs_launch_type
  task_definition      = aws_ecs_task_definition.task_definition.arn
  desired_count        = var.replicas
  force_new_deployment = true
  network_configuration {
    subnets          = [var.public_subnet_1, var.public_subnet_2]
    security_groups  = [var.alb_sg_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.alb_root_tg_arn
    container_name   = var.container_name
    container_port   = 3000
  }
  depends_on = [aws_iam_role.ecs_task_role]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
