locals {
  name_prefix = "tf30-day07-${var.environment}"
  common_tags = {
    Project     = var.project
    Environment = var.environment
  }
}
