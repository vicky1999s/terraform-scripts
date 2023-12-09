variable "vpc_id" {
  description = "vpc_id for ec2"
  type = string
}


variable "subnet_ids" {
  description = "subnets ids for load balancer"
  type = list(string)
}