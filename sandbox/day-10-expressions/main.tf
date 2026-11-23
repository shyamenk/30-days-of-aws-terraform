resource "aws_vpc" "main" {
  cidr_block = var.environment == "prod" ? "10.0.0.0/16" : "10.1.0.0/16"
  tags = {
    Name = "tf30-day10-vpc"
  }
}

resource "aws_security_group" "sg" {
  count       = var.create_sg ? 1 : 0
  name        = "tf30-day10-web-sg"
  description = "tf30 day 10 security group with dynamic ingress rules"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = rule
    content {
      from_port   = rule.value.from_port
      to_port     = rule.value.to_port
      protocol    = rule.value.protocol
      cidr_blocks = rule.value.cidr_blocks
      description = rule.value.description
    }
  }

  tags = {
    Name = "tf30-day10-web-sg"
  }
}

resource "aws_subnet" "count_subnets" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)
  tags = {
    Name = "tf30-day10-count-${count.index}"
  }
}

resource "aws_subnet" "for_each_subnets" {
  for_each   = var.for_each_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, each.value)
  tags = {
    Name = "tf30-day10-fe-${each.key}"
  }
}
