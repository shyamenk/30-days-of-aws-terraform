terraform {
  # Same major version as the pinned 1.17.1; a Terraform 2.0 could break this code.
  required_version = "~> 1.15"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "30-days-of-aws-terraform"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf30-day03-vpc"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "tf30-day03-k7q2x9s"

  tags = {
    Name        = "tf30-day03-bucket-v2"
    Environment = "Dev"
    Vpc         = aws_vpc.main.id
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "bucket" {
  description             = "tf30 day 3 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "tf30-day03-key"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.bucket.arn
    }
  }
}

