resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf30-day09-vpc"
  }
}

resource "aws_security_group" "web" {
  name_prefix = local.prefix
  description = "tf30 day 9 create_before_destroy test....."
  vpc_id      = aws_vpc.main.id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "tf30-day09-web"
  }
}

