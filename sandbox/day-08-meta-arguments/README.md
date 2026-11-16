# Day 8: meta-arguments

Practice for `count` and `for_each`, built on the Day 6 layout. Two S3 bucket blocks make two buckets each: one from a `list(string)` with `count`, one from a `set(string)` with `for_each`. Each bucket gets a public access block and KMS encryption, written once per bucket block. Nothing here has been applied, so nothing exists in AWS (empty S3 buckets cost almost nothing, but the KMS key bills a little while it exists).

## What it shows

| Piece | Where | Address in the plan |
|---|---|---|
| `count = length(var.bucket_names_list)` and `count.index` | `main.tf`, `count_buckets` | `aws_s3_bucket.count_buckets[0]`, `[1]` |
| `for_each = var.bucket_names_set` and `each.value` | `main.tf`, `for_each_buckets` | `aws_s3_bucket.for_each_buckets["<name>"]` |
| `for` expressions that collect names and IDs, joined with `concat()` | `outputs.tf` | `bucket_names`, `bucket_ids` |

Still to add: a `depends_on` bucket and the removal test (see `notes/week-02/day-08-meta-arguments.md`, section 4).

## Files

| File | Holds |
|---|---|
| `versions.tf` | required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | the two bucket-name variables, `environment`, `project` and `region` |
| `locals.tf` | the common tags |
| `main.tf` | the `count` and `for_each` bucket blocks |
| `security.tf` | one KMS key, and a public access block and encryption configuration for each bucket block |
| `outputs.tf` | `bucket_names` and `bucket_ids` |

## Checks

`terraform fmt -check`, `terraform validate`, `tflint` and the `trivy config` HIGH/CRITICAL gate pass. `terraform plan` shows `13 to add`: four buckets, one KMS key, four public access blocks and four encryption configurations.
