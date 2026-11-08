# Day 6: project structure

The Day 5 configuration, split into one file per kind of thing. It creates the same five resources as Day 5 (a VPC, an S3 bucket with a public access block, a KMS key and the bucket's encryption configuration). `terraform plan` shows 5 to add, like `sandbox/day-05-variables/`, but with `tf30-day06-` names. Nothing here has been applied.

## Files

| File | Holds |
|---|---|
| `versions.tf` | `terraform` block: required Terraform version and the AWS provider constraint |
| `provider.tf` | the `aws` provider block, with the default tags |
| `variables.tf` | input variables and their defaults |
| `locals.tf` | the name prefix, bucket name and common tags |
| `main.tf` | the resources |
| `outputs.tf` | the VPC id and the bucket name |
| `terraform.tfvars.example` | variable names with sample values; copy to `terraform.tfvars` (git-ignored) and edit |

## State

This directory uses local state and has no `backend.tf`. Nothing is applied here, and the shared `tf30-` state bucket from Day 4 is deleted, so a remote backend would only add a bucket to create and delete. Add a `backend.tf` when a day needs state shared or kept between sessions.

## Commands

```
terraform init
terraform fmt -check -recursive
terraform validate
tflint
terraform plan
```
