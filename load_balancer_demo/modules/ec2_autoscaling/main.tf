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


resource "aws_autoscaling_group" "default" {
  name                    = var.name
  max_size                = var.max_size
  min_size                = var.min_size
  desired_capacity        = var.desired_size
  vpc_zone_identifier     = var.subnet_ids
  default_instance_warmup = 200
  target_group_arns = var.elb_target_group_arn
  health_check_type = "ELB"

  launch_template {
    id = aws_launch_template.default.id
    version = aws_launch_template.default.latest_version
  }

}

resource "aws_launch_template" "default" {
  name          = "default_ec2"
  image_id      = "ami-02a2af70a66af6dfb"
  instance_type = "t2.micro"
  key_name      = "aws_ec2"
  #vpc_security_group_ids = [ aws_security_group.ec2.id ]
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [ aws_security_group.ec2.id ]
  }
  user_data = filebase64("${path.module}/userdata.sh")
  tags = {
    Environment = "Test"
    Project     = "Telecom"
  }
}

resource "aws_security_group" "ec2" {
  description = "my VPC security group"
  name                   = "ec2_autoscaling_sg"
  vpc_id                 = var.vpc_id

  timeouts {
    delete = "2m"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_allow_ssh" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "ec2_allow_all_egress" {
  security_group_id = aws_security_group.ec2.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}


