terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_lb" "test_loadbalancer" {
  name = "test-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.lb.id ]
  subnets = var.subnet_ids 
}

resource "aws_lb_target_group" "test_target_group" {
  name = "test"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
}

resource "aws_lb_listener_rule" "test_listerner_rule" {
  listener_arn = aws_lb_listener.test_listener.arn
  priority = 100

  condition {
    path_pattern {
      values = [ "/default" ]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.test_target_group.arn
  }
}

resource "aws_lb_listener" "test_listener" {
  load_balancer_arn = aws_lb.test_loadbalancer.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
      forward {
      target_group {
        arn = aws_lb_target_group.test_target_group.arn
      }
    }
  }
}



resource "aws_security_group" "lb" {
  description = "my load balancer security group"
  name                   = "alb_sg"
  vpc_id                 = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_http" {
  security_group_id = aws_security_group.lb.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
