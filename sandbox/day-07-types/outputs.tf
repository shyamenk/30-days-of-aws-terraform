output "vpc_name" {
  value       = var.tags["Name"]
  description = "The Name tag of the VPC, read from the tags map."
}
