variable "name" {
  description = "name of the autoscaling group"
  type        = string
}

variable "max_size" {
  description = "max size of autoscaling group"
  type        = number
}

variable "min_size" {
  description = "min size of autoscaling group"
  type        = number
}

variable "desired_size" {
  description = "desired size of autoscaling group"
  type        = number
}

variable "subnet_ids" {
  description = "list of subnet ids to launch instances"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc_id for ec2"
  type = string
}


variable "elb_target_group_arn" {
  description = "arn of elb target group arn"
  type = list(string)
}


