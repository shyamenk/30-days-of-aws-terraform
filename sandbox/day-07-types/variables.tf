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

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
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


variable "tags" {
  type        = map(string)
  description = "Tags applied to the VPC. Defaults must be literals, so the Name is written out in full."
  default = {
    Environment = "dev"
    Name        = "tf30-day07-dev-vpc"
    created_by  = "terraform"
  }
}


variable "ingress_values" {
  type        = tuple([number, string, number])
  description = "Ingress rule as [start port, protocol, end port]. The order and the types are fixed."
  default     = [443, "tcp", 443]
}


variable "config" {
  type = object({
    region         = string
    monitoring     = bool
    instance_count = number
  })
  description = "Region, monitoring flag and instance count for the EC2 instances"
  default = {
    region         = "us-east-1"
    monitoring     = true
    instance_count = 1
  }

  validation {
    condition     = contains(var.allowed_region, var.config.region)
    error_message = "The selected region ${var.config.region} is not allowed. Choose from: ${join(", ", var.allowed_region)}."
  }
}
