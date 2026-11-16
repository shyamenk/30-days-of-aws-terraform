variable "bucket_names_list" {
  type        = list(string)
  description = "List of unique S3 bucket names to create"
  default     = ["tf30-day08-k7q2x9s", "tf30-day08-k742x9s"]
}

variable "bucket_names_set" {
  type        = set(string)
  description = "Set of unique S3 bucket names to create"
  default     = ["tf30-day08-m3w8p5d", "tf30-day08-r6h1t4n"]
}

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
