variable "environment" {
  type        = string
  description = "Environment of the resources"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "The target cloud region for deployment."
  default     = "us-east-1"

  validation {
    condition     = contains(var.allowed_region, var.region)
    error_message = "The selected region ${var.region} is not allowed. Choose from: ${join(", ", var.allowed_region)}."
  }
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "30-days-of-aws-terraform"
}

variable "monitoring_enabled" {
  type        = bool
  description = "Boolean Values to pass for Monitoring"
  default     = true
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
}

variable "ec2_instance_count" {
  type        = number
  description = "Number of EC2 instances to provision."
  default     = 1
}

variable "ami" {
  type        = string
  description = "Amazon Machine Image (AMI) ID to use for EC2 instances."
}

variable "associate_public_ip" {
  type        = bool
  description = "Whether to associate a public IPv4 address with each instance"
  default     = false
}


variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks to use for the VPC"
  default     = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24"]
}


variable "allowed_vm_types" {
  description = "List of allowed EC2 instance types."
  type        = list(string)
  default     = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
  validation {
    condition     = length(var.allowed_vm_types) > 0
    error_message = "You must provide at least one allowed VM type."
  }
}

variable "allowed_region" {
  description = "Set of regions the region variable may take."
  type        = set(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
  validation {
    condition     = length(var.allowed_region) > 0
    error_message = "You must provide at least one allowed region."
  }
}
