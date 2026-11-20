# Day 8: meta-arguments

Practice for `count`, `for_each` and `depends_on`, built on the Day 6 layout. Two S3 bucket blocks make two buckets each: one from a `list(string)` with `count`, one from a `set(string)` with `for_each`. A fifth bucket waits for the `count` buckets through `depends_on`. Each bucket gets a public access block and KMS encryption, written once per bucket block. Nothing here has been applied, so nothing exists in AWS (empty S3 buckets cost almost nothing, but the KMS key bills a little while it exists).

## What it shows

| Piece | Where | Address in the plan |
|---|---|---|
| `count = length(var.bucket_names_list)` and `count.index` | `main.tf`, `count_buckets` | `aws_s3_bucket.count_buckets[0]`, `[1]` |
| `for_each = var.bucket_names_set` and `each.value` | `main.tf`, `for_each_buckets` | `aws_s3_bucket.for_each_buckets["<name>"]` |
| `depends_on = [aws_s3_bucket.count_buckets]` with no reference between them | `main.tf`, `depends_buckets` | `aws_s3_bucket.depends_buckets` (the order shows in `terraform graph`, not in the plan) |
| `for` expressions that collect names and IDs, joined with `concat()` | `outputs.tf` | `bucket_names`, `bucket_ids` |

The removal test was reasoned, not run, because nothing was applied (see `notes/week-02/day-08-meta-arguments.md`, section 6).

## Files

| File | Holds |
|---|---|
| `versions.tf` | required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | the two bucket-name variables, `environment`, `project` and `region` |
| `locals.tf` | the common tags |
| `main.tf` | the `count`, `for_each` and `depends_on` bucket blocks |
| `security.tf` | one KMS key, and a public access block and encryption configuration for each bucket block |
| `outputs.tf` | `bucket_names` and `bucket_ids` |

## Checks

`terraform fmt -check`, `terraform validate`, `tflint` and the `trivy config` HIGH/CRITICAL gate pass. `terraform plan` shows `16 to add`: five buckets, one KMS key, five public access blocks and five encryption configurations.
