locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
  }
  prefix = "tf30-day09-web-"
}
