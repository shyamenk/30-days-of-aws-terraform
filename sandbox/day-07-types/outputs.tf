output "vpc_name" {
  value       = var.tags["Name"]
  description = "The Name tag of the VPC, read from the tags map."
}

output "deployment_summary" {
  value = {
    environment    = var.environment
    instance_count = var.config.instance_count
    name           = var.tags["Name"]
  }
  description = "Environment (string), instance count (number) and the Name tag (from the tags map)."
}
