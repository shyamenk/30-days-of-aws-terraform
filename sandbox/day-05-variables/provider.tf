terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = "~> 1.15"
}

# Configure the AWS Provider
provider "aws" {
  region = var.region

  default_tags {
    tags = local.common_tags
  }
}
