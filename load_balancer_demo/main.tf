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


module "ec2_autoscaling" {
  source     = "./modules/ec2_autoscaling"
  name       = var.name
  max_size   = var.max_size
  min_size   = var.min_size
  desired_size = var.desired_size
  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id
  elb_target_group_arn = module.load_balancer.aws_lb_target_group_arn
}

module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
}

resource "aws_vpc_security_group_egress_rule" "lb_allow_egress_ec2" {
  security_group_id = module.load_balancer.load_balancer_sg_id
  referenced_security_group_id = module.ec2_autoscaling.aws_security_group_id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_http_lb" {
  security_group_id = module.ec2_autoscaling.aws_security_group_id
  referenced_security_group_id = module.load_balancer.load_balancer_sg_id
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
