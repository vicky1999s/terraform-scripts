terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "state_storage" {
    bucket = var.bucket_name

    tags = {
        Name = var.bucket_name
        Environment = "test"
    }
}

resource "aws_s3_bucket_versioning" "state_storage_versioning" {
  bucket = aws_s3_bucket.state_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}  

