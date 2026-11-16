resource "aws_s3_bucket" "count_buckets" {
  count  = length(var.bucket_names_list)
  bucket = var.bucket_names_list[count.index]
}

resource "aws_s3_bucket" "for_each_buckets" {
  for_each = var.bucket_names_set
  bucket   = each.value
}
