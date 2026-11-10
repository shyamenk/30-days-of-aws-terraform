provider "aws" {
  region = var.config.region
  default_tags {
    tags = local.common_tags
  }
}
