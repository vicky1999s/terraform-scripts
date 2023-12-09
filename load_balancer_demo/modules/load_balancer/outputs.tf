output "load_balancer_sg_id" {
  value = aws_security_group.lb.id
}

output "aws_lb_target_group_arn" {
  value = [aws_lb_target_group.test_target_group.arn]
  
}