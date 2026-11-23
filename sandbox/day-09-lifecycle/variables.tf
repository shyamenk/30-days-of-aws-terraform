variable "environment" {
  type        = string
  description = "Environment of the resources"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "30-days-of-aws-terraform"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-1"
}
