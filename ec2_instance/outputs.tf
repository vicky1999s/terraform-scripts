output "public_ip" {
  value = aws_instance.test.public_ip
  description = "public ip of ec2 instance"
}
