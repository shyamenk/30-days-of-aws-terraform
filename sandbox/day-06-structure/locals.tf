locals {
  name_prefix = "tf30-day06-${var.environment}"
  bucket_name = "${local.name_prefix}-${var.bucket_suffix}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
  }
}
