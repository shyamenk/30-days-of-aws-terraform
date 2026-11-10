resource "aws_instance" "ec2_instance" {
  count                       = var.config.instance_count
  monitoring                  = var.config.monitoring
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
  tags       = var.tags
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


resource "aws_security_group" "sg" {
  name        = "${local.name_prefix}-sg"
  description = "Allow HTTPS traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${local.name_prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc_sg_ingress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.cidr_blocks[2]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}
