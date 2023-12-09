data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "test" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "aws_ec2"
    iam_instance_profile = "AWSDefaultEC2Role"
    root_block_device {
      volume_size = 8
    }

    tags = {
        Name = var.instance_name
        Environment = "Test"
        Project = "Telecom"
    }
}


