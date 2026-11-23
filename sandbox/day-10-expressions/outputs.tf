output "sg_id" {
  description = "ID of the security group, or null when create_sg is false"
  value       = one(aws_security_group.sg[*].id)
}

output "count_subnet_ids" {
  description = "IDs of the count subnets, collected with a splat"
  value       = aws_subnet.count_subnets[*].id
}

output "for_each_subnet_ids" {
  description = "IDs of the for_each subnets, keyed by name; a splat cannot read a for_each resource because it is a map"
  value       = { for key, subnet in aws_subnet.for_each_subnets : key => subnet.id }
}
