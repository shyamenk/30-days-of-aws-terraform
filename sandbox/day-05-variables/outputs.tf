output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "aws_s3_bucket" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.assets.bucket
}
