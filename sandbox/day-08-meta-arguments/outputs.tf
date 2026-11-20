output "bucket_names" {
  description = "Names of all buckets, from the count block then the for_each block"
  value = concat(
    [for b in aws_s3_bucket.count_buckets : b.bucket],
    [for b in values(aws_s3_bucket.for_each_buckets) : b.bucket],
  )
}

output "bucket_ids" {
  description = "IDs of all buckets, from the count block then the for_each block"
  value = concat(
    [for b in aws_s3_bucket.count_buckets : b.id],
    [for b in values(aws_s3_bucket.for_each_buckets) : b.id],
  )
}
