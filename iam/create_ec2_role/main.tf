terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "ec2_full_access" {
    statement {
        effect = "Allow"
        principals {
          type = "AWS"
          identifiers = [ data.aws_caller_identity.current.arn ]
        }
        actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "ec2_full_access" {
    name = "EC2CustomFullAccess"
    assume_role_policy = data.aws_iam_policy_document.ec2_full_access.json
    managed_policy_arns = [aws_iam_policy.ec2_full_access.arn]

}

resource "aws_iam_policy" "ec2_full_access" {
    name = "EC2CustomFullAccess"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = ["ec2:*"]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
    
}

