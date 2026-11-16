resource "aws_kms_key" "buckets" {
  description             = "tf30 day 8 bucket encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Name = "tf30-day08-key"
  }
}

resource "aws_s3_bucket_public_access_block" "count_buckets" {
  count = length(aws_s3_bucket.count_buckets)

  bucket                  = aws_s3_bucket.count_buckets[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "count_buckets" {
  count = length(aws_s3_bucket.count_buckets)

  bucket = aws_s3_bucket.count_buckets[count.index].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.buckets.arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "for_each_buckets" {
  for_each = aws_s3_bucket.for_each_buckets

  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "for_each_buckets" {
  for_each = aws_s3_bucket.for_each_buckets

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.buckets.arn
    }
  }
}
