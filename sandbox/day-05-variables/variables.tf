variable "environment" {
  type        = string
  description = "Environment of the resources"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "Region to deploy the resources"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "30-days-of-aws-terraform"
}

variable "bucket_suffix" {
  type        = string
  description = "Short suffix that makes the globally unique bucket name unique"
  default     = "p4w9n7"
}
