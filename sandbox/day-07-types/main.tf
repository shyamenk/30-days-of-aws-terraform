resource "aws_instance" "ec2_instance" {
  count                       = var.ec2_instance_count
  monitoring                  = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip
  ami                         = var.ami
  instance_type               = var.ec2_instance_type
  tags = {
    Name = "${local.name_prefix}-ec2_instance"
  }

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  lifecycle {
    precondition {
      condition     = contains(var.allowed_vm_types, var.ec2_instance_type)
      error_message = "Instance type ${var.ec2_instance_type} is not allowed. Allowed types: ${join(", ", var.allowed_vm_types)}."
    }
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_blocks[0]
  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_blocks[1]
  tags = {
    Name = "${local.name_prefix}-public_subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_blocks[2]
  tags = {
    Name = "${local.name_prefix}-private_subnet"
  }
}



