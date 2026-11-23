variable "environment" {
  type        = string
  description = "Environment name; \"prod\" selects the prod VPC CIDR, any other value the non-prod CIDR"
  default     = "dev"
}

variable "project" {
  type        = string
  description = "Project name, used in the Project tag on every resource"
  default     = "30-days-of-aws-terraform"
}

variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "ap-southeast-1"
}

variable "create_sg" {
  type        = bool
  description = "Set to true to create the security group, false to skip it"
  default     = true
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  description = "Ingress rules for the security group; the dynamic block makes one ingress rule per item"
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.1.0.0/16"]
      description = "HTTP from inside the non-prod VPC range"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.1.0.0/16"]
      description = "HTTPS from inside the non-prod VPC range"
    },
  ]
}

variable "for_each_subnets" {
  type        = map(number)
  description = "Subnets made with for_each: key is the name suffix, value is the /24 number inside the VPC range"
  default = {
    a = 3
    b = 4
  }
}
