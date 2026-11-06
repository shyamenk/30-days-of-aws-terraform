terraform {
  # Same major version as the pinned 1.17.1; a Terraform 2.0 could break this code.
  required_version = "~> 1.17"

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

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tf30-day02-vpc"
  }
}
